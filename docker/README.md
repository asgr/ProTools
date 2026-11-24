# ProTools Docker Image

Headless, reproducible image of the full ProTools suite, intended for HPC use
(via Apptainer/Singularity) or anywhere Docker runs. No X11, OpenGL, or GPU
needed: `rgl` is compiled with `--disable-opengl` (null device), which keeps
`rglwidget()` browser output fully functional. Interactive `plot3d()` windows
are unavailable; use `rglwidget()` or headless snapshots instead.

## Files

| File | Purpose |
|------|---------|
| `Dockerfile` | Image definition; build context is the repository root |
| `versions.lock` | Exact commit SHAs for all 16 suite packages + GitHub-only transitive deps (`LaplacesDemon`, `cmaeshpc`), in dependency order |
| `install_protools.R` | Installs pinned packages, verifies versions, writes a manifest to `/opt/protools/manifest.csv` inside the image |

## Reproducibility model

Three layers are pinned:

1. **R itself** — the `rocker/r-ver:4.5.3` base image tag.
2. **CRAN packages** — a dated Posit Package Manager snapshot (`CRAN_SNAPSHOT`
   build arg, default `2026-11-20`).
3. **GitHub packages** — commit SHAs in `versions.lock`.

The ProTools meta-package is installed from the local build context, so build
release images from a clean, committed checkout (tag it first).

## Building

A GitHub PAT is recommended to avoid API rate limits during the ~20 repo
downloads. It is passed as a BuildKit secret and never stored in a layer:

```sh
export GITHUB_PAT=ghp_...   # classic PAT, public_repo scope is enough
docker build -f docker/Dockerfile -t protools:0.6.0 \
  --secret id=github_pat,env=GITHUB_PAT .
```

Without a PAT the build still works (anonymous API), just more likely to hit
rate limits. Expect a long build: `ProSpectData` alone is a ~360 MB download,
and several packages compile C/C++/Fortran.

## Running

```sh
docker run --rm -it -v "$PWD":/work protools:0.6.0
```

For running on HPC (including Pawsey Setonix), see the **Docker on HPC**
section of the [main README](../README.md#docker-on-hpc-pawsey-setonix).

## Publishing

The image is published at `ghcr.io/asgr/protools` (public; anonymous pulls
work, so HPC users need no credentials):

```sh
docker login ghcr.io -u asgr   # PAT with write:packages
docker tag protools:0.6.0 ghcr.io/asgr/protools:0.6.0
docker tag protools:0.6.0 ghcr.io/asgr/protools:latest
docker push ghcr.io/asgr/protools:0.6.0
docker push ghcr.io/asgr/protools:latest
```

New GHCR packages default to **private**; flip visibility once under
github.com/users/asgr/packages/container/protools/settings → Danger Zone.
When cutting a new release, push the new version tag and move `latest`.

## Build notes / gotchas

These are handled in the Dockerfile and install script; documented here so
future maintainers understand why the recipe looks the way it does:

* **ProSpectData** (~360 MB) is fetched with `curl` from codeload (resumable,
  retries) rather than through the GitHub API path, which repeatedly fails or
  rate-limits for this repo. Its SHA appears twice: `versions.lock` and the
  `PROSPECTDATA_SHA` build arg — update both together.
* **rgl** must be compiled from genuine source with `--disable-opengl`. The
  `__linux__` PPM repo serves *prebuilt binaries* based on the HTTP User-Agent
  regardless of `type = "source"`; those link `libGLU` and fail on headless
  hosts. The install script pulls rgl's dependency tree as binaries first,
  then compiles rgl itself from the plain (non-`__linux__`) snapshot URL.
* **Dead upstream Remotes**: several suite packages list `asgr/imager@test_v4`
  in `Remotes:`, a branch that no longer exists. remotes errors resolving it
  even though imager is only a Suggests. The install script neutralises
  Remotes-field resolution (safe: all GitHub-only hard deps are pinned in the
  lock). Remove this workaround once upstream DESCRIPTIONs are fixed.
* **imager and fftw** are formally Suggests but are installed anyway:
  `profoundProFound`'s default smoothing and ProFit PSF convolution need them.
  System libraries `libtiff-dev`, `libfftw3-dev`, `libglpk-dev` (via igraph)
  support them.
* Suite packages install **sequentially in lock-file order** (roughly
  topological) with `dependencies = NA`, so CRAN deps come from the pinned
  snapshot as binaries and Suggests stay out of the image.

## Updating the lock file

Bump pins deliberately when cutting a new image, never implicitly:

```sh
for repo in $(grep -v '^#' docker/versions.lock | awk '{print $1}'); do
  sha=$(curl -sf "https://api.github.com/repos/$repo/commits/HEAD" \
        | python3 -c "import json,sys; print(json.load(sys.stdin)['sha'])")
  ver=$( (curl -sf "https://raw.githubusercontent.com/$repo/master/DESCRIPTION" \
        || curl -sf "https://raw.githubusercontent.com/$repo/main/DESCRIPTION") \
        | grep '^Version:' | awk '{print $2}')
  echo "$repo $sha $ver"
done
```

Keep the dependency ordering and update `PROSPECTDATA_SHA` in the Dockerfile to
match. Then update `CRAN_SNAPSHOT` to a recent date, rebuild, test, and tag the
repo and image with matching version numbers. Keep old images available so
published analyses remain reproducible.

## Rolling vs pinned

`DESCRIPTION`'s `Remotes:` intentionally stays unpinned for interactive
`remotes::install_github("asgr/ProTools")` users who want current code. The
Docker image is the pinned, citable artifact. If you also want a bleeding-edge
image, build the same Dockerfile with a lock regenerated at HEAD and tag it
`protools:rolling`.
