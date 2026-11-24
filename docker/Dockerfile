# ProTools suite — headless image for HPC (no X11/OpenGL required).
# Build from the repository root:
#   docker build -f docker/Dockerfile -t protools:0.6.0 \
#     --secret id=github_pat,env=GITHUB_PAT .
# See docker/README.md for details and Apptainer/Singularity conversion.

FROM rocker/r-ver:4.5.3

# Pin CRAN to a dated Posit Package Manager snapshot so CRAN dependencies are
# as reproducible as the GitHub pins in versions.lock. Binary packages are
# served for the base image's Ubuntu codename, keeping the build fast.
ARG CRAN_SNAPSHOT=2026-11-20
RUN CODENAME=$(. /etc/os-release && echo "$VERSION_CODENAME") && \
    echo "options(repos = c(CRAN = 'https://packagemanager.posit.co/cran/__linux__/${CODENAME}/${CRAN_SNAPSHOT}'))" \
      >> "${R_HOME}/etc/Rprofile.site"

# Toolchain + libraries for the compiled suite packages (Rcpp, wcslib, ...).
# Deliberately no X11 / Mesa / GLU: rgl is built with --disable-opengl below.
RUN apt-get update && apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      build-essential \
      gfortran \
      libcurl4-openssl-dev \
      libssl-dev \
      libxml2-dev \
      libpng-dev \
      libjpeg-dev \
      libtiff-dev \
      libfftw3-dev \
      libglpk-dev \
      zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

RUN Rscript -e 'install.packages("remotes")'

COPY docker/versions.lock docker/install_protools.R /tmp/protools-build/
COPY DESCRIPTION NAMESPACE /tmp/protools-build/ProTools/

# ProSpectData is ~360 MB and repeatedly fails/rate-limits through the GitHub
# API path. Fetch it here via codeload with resumable retries instead; the R
# install step then uses the local tarball. Cached as its own layer.
ARG PROSPECTDATA_SHA=5eb9b27bd87fa19b71bbad3918abdab84b526ec1
RUN curl -fL --retry 10 --retry-delay 15 --retry-all-errors -C - \
      -o /tmp/protools-build/ProSpectData.tar.gz \
      "https://codeload.github.com/asgr/ProSpectData/tar.gz/${PROSPECTDATA_SHA}"

# GITHUB_PAT avoids GitHub API rate limits across the ~20 repo downloads.
# Passed as a BuildKit secret so it never lands in an image layer.
RUN --mount=type=secret,id=github_pat \
    GITHUB_PAT="$(cat /run/secrets/github_pat 2>/dev/null || true)" \
    Rscript /tmp/protools-build/install_protools.R \
    && rm -rf /tmp/protools-build

# Fail the build if the suite cannot attach
RUN Rscript -e 'library(ProTools); cat("ProTools", as.character(packageVersion("ProTools")), "OK\n")'

WORKDIR /work
CMD ["R"]
