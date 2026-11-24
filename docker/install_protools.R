#!/usr/bin/env Rscript
# Install the ProTools suite at the exact commits in versions.lock, then the
# ProTools meta-package from the local build context.
# Run inside the Docker build; see docker/Dockerfile.

build_dir <- "/tmp/protools-build"

# ProSpectData is a ~360 MB repo; default 60 s timeout will fail on slow links
options(timeout = 3600)

lock <- read.table(
  file.path(build_dir, "versions.lock"),
  col.names = c("repo", "sha", "version"),
  comment.char = "#", stringsAsFactors = FALSE
)

# ProSpectData was pre-downloaded by curl in the Dockerfile (resumable retries;
# the ~360 MB repo is unreliable through the GitHub API path). Install it first
# from the local tarball so remotes sees the dependency already satisfied.
psd <- lock[lock$repo == "asgr/ProSpectData", ]
install.packages(file.path(build_dir, "ProSpectData.tar.gz"),
                 repos = NULL, type = "source")
if (as.character(packageVersion("ProSpectData")) != psd$version) {
  stop("ProSpectData tarball version mismatch")
}

# rgl is a hard dependency (hyper.fit, sphereplot) but needs no X11/OpenGL on
# headless HPC: the null-OpenGL build keeps rglwidget() browser output working.
# rgl's dependency tree installs from the default (PPM binary) repo first.
# The dummy install also pulls the binary rgl, which is then removed.
install.packages("rgl")
remove.packages("rgl")

# Then compile rgl itself from genuine source: the __linux__ PPM repo serves
# prebuilt binaries (based on User-Agent) that ignore configure.args and link
# libGLU, which is absent on headless images. The plain snapshot URL always
# serves source; dependencies = FALSE keeps the binaries above untouched.
snapshot <- Sys.getenv("CRAN_SNAPSHOT", "2026-11-20")
install.packages(
  "rgl",
  repos = paste0("https://packagemanager.posit.co/cran/", snapshot),
  type = "source",
  dependencies = FALSE,
  configure.args = "--disable-opengl"
)
stopifnot(rgl::rgl.useNULL())

# Some suite packages declare asgr/imager@test_v4 in Remotes, a branch that no
# longer exists upstream; remotes errors resolving it even though imager is
# only a Suggests. Neutralise the Remotes field during dependency resolution.
# Safe here because every GitHub-only hard dependency is pinned in the lock.
# Remove this workaround once the upstream Remotes fields are fixed.
unlockBinding("extra_deps", asNamespace("remotes"))
assign("extra_deps", function(pkg, field) remotes:::package_deps_new(),
       envir = asNamespace("remotes"))

# Install each pin in dependency order (lock file is roughly topological).
# dependencies = NA installs Depends/Imports/LinkingTo only, skipping Suggests
# (imager, fftw, EBImage, ...), which keeps the image lean.
for (i in seq_len(nrow(lock))) {
  if (lock$repo[i] == "asgr/ProSpectData") next
  remotes::install_github(
    paste0(lock$repo[i], "@", lock$sha[i]),
    dependencies = NA, upgrade = "never"
  )
}

# imager + fftw are formally Suggests, but profoundProFound's default smoothing
# and ProFit's PSF convolution need them; core workflows fail without them.
install.packages(c("imager", "fftw"))

# Meta-package from the local checkout (DESCRIPTION + NAMESPACE only)
install.packages(file.path(build_dir, "ProTools"), repos = NULL, type = "source")

# Verify every pinned version actually landed
ip <- installed.packages()
pkg <- basename(lock$repo)
got <- ip[pkg, "Version"]
bad <- got != lock$version
if (any(bad)) {
  stop("Version mismatch after install:\n",
       paste(sprintf("  %s: expected %s, got %s",
                     pkg[bad], lock$version[bad], got[bad]), collapse = "\n"))
}

# Record the full environment (incl. CRAN packages) as a build manifest
dir.create("/opt/protools", showWarnings = FALSE, recursive = TRUE)
manifest <- as.data.frame(ip)[, c("Package", "Version")]
write.csv(manifest, "/opt/protools/manifest.csv", row.names = FALSE)

message("ProTools suite installed: ", nrow(lock), " pinned packages, ",
        nrow(manifest), " total packages in image.")
