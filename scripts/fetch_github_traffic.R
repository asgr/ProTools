#!/usr/bin/env Rscript
# scripts/fetch_github_traffic.R
#
# Fetch GitHub traffic metrics (views + clones, per-day) for the ProTools suite.
# Writes:
#   data/traffic_latest.csv  – one row per repo (latest day), overwritten each run
#   data/traffic_history.csv – append-only daily buckets, deduplicated by date+owner+repo

library(httr2)

# ── Repos ──────────────────────────────────────────────────────────────────────
repos <- c(
  "asgr/celestial",
  "asgr/Highlander",
  "asgr/hyper.fit",
  "asgr/magicaxis",
  "asgr/ParmOff",
  "ICRAR/ProFit",
  "asgr/ProFound",
  "asgr/ProFuse",
  "asgr/ProGeny",
  "asgr/ProPane",
  "asgr/ProSpect",
  "asgr/ProSpectData",
  "asgr/ProUtils",
  "asgr/Rfits",
  "asgr/Rwcs",
  "asgr/sphereplot"
)

# ── Config ─────────────────────────────────────────────────────────────────────
token <- Sys.getenv("GH_TRAFFIC_TOKEN")
if (nchar(token) == 0L) token <- Sys.getenv("GITHUB_TOKEN")
if (nchar(token) == 0L) stop("No GH_TRAFFIC_TOKEN or GITHUB_TOKEN set")

if (nchar(Sys.getenv("GH_TRAFFIC_TOKEN")) > 0L) {
  message("Using GH_TRAFFIC_TOKEN")
} else {
  message("Falling back to GITHUB_TOKEN")
}

dir.create("data", showWarnings = FALSE, recursive = TRUE)

# ── Helpers ────────────────────────────────────────────────────────────────────

# Build an authenticated, retry-enabled request for a traffic endpoint.
make_traffic_req <- function(owner, repo, endpoint, token) {
  url <- sprintf(
    "https://api.github.com/repos/%s/%s/traffic/%s?per=day",
    owner, repo, endpoint
  )
  request(url) |>
    req_headers(
      Authorization        = paste("Bearer", token),
      Accept               = "application/vnd.github+json",
      `X-GitHub-Api-Version` = "2022-11-28"
    ) |>
    req_retry(
      max_tries   = 4L,
      # Retry on rate-limit and transient server errors
      is_transient = function(resp) resp_status(resp) %in% c(429L, 500L, 502L, 503L, 504L),
      backoff      = function(i) i * 10  # 10 s, 20 s, 30 s
    )
}

# Extract a named list keyed by date string ("YYYY-MM-DD") from a list of
# timestamp/count/uniques records.
index_by_date <- function(records) {
  if (length(records) == 0L) return(list())
  dates <- vapply(records, function(x) substr(x[["timestamp"]], 1L, 10L), character(1L))
  setNames(records, dates)
}

# Safely coerce an integer-or-NULL value to integer; returns NA_integer_ for NULL.
as_int <- function(x) if (is.null(x)) NA_integer_ else as.integer(x)

# ── Per-repo fetch ─────────────────────────────────────────────────────────────
fetch_repo_traffic <- function(owner, repo, token) {
  views_resp  <- req_perform(make_traffic_req(owner, repo, "views",  token))
  clones_resp <- req_perform(make_traffic_req(owner, repo, "clones", token))

  views_map  <- index_by_date(resp_body_json(views_resp)[["views"]])
  clones_map <- index_by_date(resp_body_json(clones_resp)[["clones"]])

  # All daily dates returned for this repo
  all_dates <- sort(union(names(views_map), names(clones_map)))

  # Build history rows (one per day)
  history <- lapply(all_dates, function(d) {
    v <- views_map[[d]]
    cl <- clones_map[[d]]
    data.frame(
      date          = d,
      owner         = owner,
      repo          = repo,
      views_count   = as_int(v[["count"]]),
      views_uniques = as_int(v[["uniques"]]),
      clones_count  = as_int(cl[["count"]]),
      clones_uniques = as_int(cl[["uniques"]]),
      stringsAsFactors = FALSE
    )
  })

  # Latest day snapshot for traffic_latest.csv
  latest_date <- if (length(all_dates) > 0L) all_dates[length(all_dates)] else NA_character_
  v_latest  <- if (!is.na(latest_date)) views_map[[latest_date]]  else NULL
  cl_latest <- if (!is.na(latest_date)) clones_map[[latest_date]] else NULL

  latest <- data.frame(
    owner         = owner,
    repo          = repo,
    fetch_date    = format(Sys.time(), "%Y-%m-%d"),
    latest_day    = if (is.na(latest_date)) NA_character_ else latest_date,
    views_count   = as_int(v_latest[["count"]]),
    views_uniques = as_int(v_latest[["uniques"]]),
    clones_count  = as_int(cl_latest[["count"]]),
    clones_uniques = as_int(cl_latest[["uniques"]]),
    status        = "ok",
    error         = "",
    stringsAsFactors = FALSE
  )

  list(latest = latest, history = history)
}

# ── Main loop ──────────────────────────────────────────────────────────────────
latest_rows  <- vector("list", length(repos))
history_rows <- list()

for (i in seq_along(repos)) {
  repo_str <- repos[[i]]
  parts    <- strsplit(repo_str, "/", fixed = TRUE)[[1L]]
  owner    <- parts[[1L]]
  repo     <- parts[[2L]]

  message(sprintf("[%d/%d] Fetching %s/%s ...", i, length(repos), owner, repo))

  result <- tryCatch({
    fetch_repo_traffic(owner, repo, token)
  }, error = function(e) {
    msg <- conditionMessage(e)
    message(sprintf("  ERROR: %s", msg))
    list(
      latest = data.frame(
        owner         = owner,
        repo          = repo,
        fetch_date    = format(Sys.time(), "%Y-%m-%d"),
        latest_day    = NA_character_,
        views_count   = NA_integer_,
        views_uniques = NA_integer_,
        clones_count  = NA_integer_,
        clones_uniques = NA_integer_,
        status        = "error",
        error         = msg,
        stringsAsFactors = FALSE
      ),
      history = list()
    )
  })

  latest_rows[[i]]  <- result$latest
  history_rows      <- c(history_rows, result$history)
}

# ── Write traffic_latest.csv (overwrite each run) ─────────────────────────────
latest_df <- do.call(rbind, latest_rows)
latest_df <- latest_df[order(latest_df$owner, latest_df$repo), ]
write.csv(latest_df, "data/traffic_latest.csv", row.names = FALSE)
message("Wrote data/traffic_latest.csv (", nrow(latest_df), " rows)")

# ── Write traffic_history.csv (append + dedup) ────────────────────────────────
history_file <- "data/traffic_history.csv"

if (length(history_rows) > 0L) {
  new_history <- do.call(rbind, history_rows)

  if (file.exists(history_file) && file.info(history_file)$size > 0L) {
    existing <- read.csv(history_file, stringsAsFactors = FALSE)
    combined <- rbind(existing, new_history)
    # Keep first occurrence of each (date, owner, repo) triple
    combined <- combined[!duplicated(combined[, c("date", "owner", "repo")]), ]
  } else {
    combined <- new_history
  }

  combined <- combined[order(combined$date, combined$owner, combined$repo), ]
  write.csv(combined, history_file, row.names = FALSE)
  message("Wrote data/traffic_history.csv (", nrow(combined), " total rows)")
} else {
  message("No history rows to write.")
}

traffic_total = aggregate(views_uniques ~ repo, data = combined, FUN = sum)
write.csv(latest_df, "data/traffic_total.csv", row.names = FALSE)
