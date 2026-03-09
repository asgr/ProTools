# Traffic Metrics Data

This directory contains GitHub repository traffic data collected nightly by the
[`nightly-traffic`](../.github/workflows/nightly-traffic.yml) GitHub Actions
workflow.

## Files

| File | Contents |
|------|----------|
| `traffic_latest.csv` | One row per repo – the **most recent day's** view/clone metrics, refreshed on every run |
| `traffic_history.csv` | **Append-only** daily snapshots across all runs; deduplicated by `(date, owner, repo)` |
| `traffic_total.csv` | Activity totals dated from 2026-03-09 |

## Column Reference

### `traffic_latest.csv`

| Column | Description |
|--------|-------------|
| `owner` | GitHub organisation / user that owns the repo |
| `repo` | Repository name |
| `fetch_date` | UTC date on which this row was collected (`YYYY-MM-DD`) |
| `latest_day` | The most recent date bucket returned by the GitHub API |
| `views_count` | Total page views on `latest_day` |
| `views_uniques` | Unique visitors on `latest_day` |
| `clones_count` | Total git clones on `latest_day` |
| `clones_uniques` | Unique clone sources on `latest_day` |
| `status` | `ok` or `error` |
| `error` | Human-readable error message (empty when `status = ok`) |

### `traffic_history.csv`

| Column | Description |
|--------|-------------|
| `date` | Daily bucket date (`YYYY-MM-DD`) |
| `owner` | GitHub organisation / user |
| `repo` | Repository name |
| `views_count` | Total page views on that day |
| `views_uniques` | Unique visitors on that day |
| `clones_count` | Total git clones on that day |
| `clones_uniques` | Unique clone sources on that day |

### `traffic_total.csv`

| Column | Description |
|--------|-------------|
| `repo` | Repository name |
| `views_count` | Total page views since workflow started (2026-03-09) |
| `views_uniques` | Unique visitors since workflow started (2026-03-09) |
| `clones_count` | Total git clones since workflow started (2026-03-09) |
| `clones_uniques` | Unique clone sources since workflow started (2026-03-09) |

## Limitations and caveats

* **14-day window.** The GitHub traffic API returns data for approximately the
  last 14 days only.  Older data is not available via the API; the history file
  accumulates data from each nightly run, so the full history extends back to
  whenever the workflow was first enabled.

* **Aggregated counts.** GitHub aggregates traffic into calendar-day buckets
  (UTC).  Counts from the same day collected on different runs may differ if
  GitHub's backend re-aggregates the data.  The history file keeps the *first*
  recorded value for each `(date, owner, repo)` triple to avoid overwriting
  already-stored measurements.

* **"Uniques" is an approximation.** GitHub deduplicates views and clones by
  IP address within a 24-hour window.  The `*_uniques` columns are a reasonable
  proxy for organic interest, but they cannot perfectly filter automated bots,
  CI pipelines, or repeat visits from the same user across different networks.

* **Permissions.** The GitHub traffic API requires **push (write) access** to
  each repository being queried.  The workflow uses `GITHUB_TOKEN` by default,
  but that token is scoped only to `asgr/ProTools`.  To collect traffic data for
  all 16 repos in the suite you need a token with `repo` scope for each of them
  (e.g. a personal access token stored as a repository secret named
  `GH_TRAFFIC_TOKEN`, or a fine-grained PAT covering all target repos).  If no
  such token is available the workflow will still run; repos that are not
  accessible will have `status = error` in `traffic_latest.csv` and the rest of
  the run continues normally.
