# ProTools (R package)

## Synopsis

**ProTools** is a convenience meta-package that loads all of the standard ProTools R packages with a single command. The suite provides a comprehensive toolkit for astronomical image analysis, galaxy modelling, spectral energy distribution fitting, and more.

Loading **ProTools** attaches the full suite of packages needed for end-to-end astronomical data reduction and analysis:

## Sub-Packages

| Package | Status | Description |
|---------|--------|-------------|
| [celestial](https://github.com/asgr/celestial) | [![R-CMD-check](https://github.com/asgr/celestial/workflows/R-CMD-check/badge.svg)](https://github.com/asgr/celestial/actions) | Core astronomy routines (coordinates, cosmology, etc) |
| [Highlander](https://github.com/asgr/Highlander) | [![R-CMD-check](https://github.com/asgr/Highlander/workflows/R-CMD-check/badge.svg)](https://github.com/asgr/Highlander/actions) | Bayesian optimisation combining CMA-ES and MCMC |
| [hyper.fit](https://github.com/asgr/hyper.fit) | [![R-CMD-check](https://github.com/asgr/hyper.fit/workflows/R-CMD-check/badge.svg)](https://github.com/asgr/hyper.fit/actions) | N-dimensional hyperplane fitting with errors |
| [magicaxis](https://github.com/asgr/magicaxis) | [![R-CMD-check](https://github.com/asgr/magicaxis/workflows/R-CMD-check/badge.svg)](https://github.com/asgr/magicaxis/actions) | Pretty scientific plotting and axis formatting |
| [ParmOff](https://github.com/asgr/ParmOff) | [![R-CMD-check](https://github.com/asgr/ParmOff/workflows/R-CMD-check/badge.svg)](https://github.com/asgr/ParmOff/actions) | Flexible function argument matching |
| [ProFit](https://github.com/ICRAR/ProFit) | [![R-CMD-check](https://github.com/ICRAR/ProFit/workflows/R-CMD-check/badge.svg)](https://github.com/ICRAR/ProFit/actions) | Bayesian galaxy image profile fitting |
| [ProFound](https://github.com/asgr/ProFound) | [![R-CMD-check](https://github.com/asgr/ProFound/workflows/R-CMD-check/badge.svg)](https://github.com/asgr/ProFound/actions) | Source extraction and photometry |
| [ProFuse](https://github.com/asgr/ProFuse) | [![R-CMD-check](https://github.com/asgr/ProFuse/workflows/R-CMD-check/badge.svg)](https://github.com/asgr/ProFuse/actions) | Multi-band galaxy fitting (ProFound + ProFit + ProSpect) |
| [ProGeny](https://github.com/asgr/ProGeny) | [![R-CMD-check](https://github.com/asgr/ProGeny/workflows/R-CMD-check/badge.svg)](https://github.com/asgr/ProGeny/actions) | Simple Stellar Population library generation |
| [ProPane](https://github.com/asgr/ProPane) |  [![R-CMD-check](https://github.com/asgr/ProPane/workflows/R-CMD-check/badge.svg)](https://github.com/asgr/ProPane/actions) | Image warping, stacking, and registration |
| [ProSpect](https://github.com/asgr/ProSpect) | [![R-CMD-check](https://github.com/asgr/ProSpect/workflows/R-CMD-check/badge.svg)](https://github.com/asgr/ProSpect/actions) | Spectral energy distribution generation and fitting |
| [ProSpectData](https://github.com/asgr/ProSpectData) | [![R-CMD-check](https://github.com/asgr/ProSpectData/workflows/R-CMD-check/badge.svg)](https://github.com/asgr/ProSpectData/actions) | Spectral template data for ProSpect |
| [ProUtils](https://github.com/asgr/ProUtils) | [![R-CMD-check](https://github.com/asgr/ProUtils/workflows/R-CMD-check/badge.svg)](https://github.com/asgr/ProUtils/actions) | Shared low-level utilities for ProTools |
| [Rfits](https://github.com/asgr/Rfits) | [![R-CMD-check](https://github.com/asgr/Rfits/workflows/R-CMD-check/badge.svg)](https://github.com/asgr/Rfits/actions) | FITS file I/O for images, tables, and headers |
| [Rwcs](https://github.com/asgr/Rwcs) | [![R-CMD-check](https://github.com/asgr/Rwcs/workflows/R-CMD-check/badge.svg)](https://github.com/asgr/Rwcs/actions) | World Coordinate System projections and conversions |
| [sphereplot](https://github.com/asgr/sphereplot) | [![R-CMD-check](https://github.com/asgr/sphereplot/workflows/R-CMD-check/badge.svg)](https://github.com/asgr/sphereplot/actions) | Spherical coordinate plotting |

Nearly all packages live under GitHub user **asgr**, with the exception of **ProFit** which is hosted under **ICRAR**.

## Installation

### Getting R

First things first, you will probably want to install a recent version of **R** that lets you build packages from source. The advantage of choosing this route is you can then update bleeding edge versions directly from GitHub. If you rely on the pre-built binaries on CRAN you might be waiting much longer.

#### Mac

For Mac just get the latest binaries from the **R** project pages:

<https://cloud.r-project.org/bin/macosx/>

#### Windows

For Windows just get the latest binaries from the **R** project pages:

<https://cloud.r-project.org/bin/windows/>

#### Linux

Debian:	`sudo apt-get install r-base r-base-dev`

Fedora:	`sudo yum install R`

Suse:	More of a pain, see here <https://cloud.r-project.org/bin/linux/suse/README.html>

Ubuntu:	`sudo apt-get install r-base-dev`

All the info on binaries is here: <https://cloud.r-project.org/bin/linux/>

If you have a poorly supported version of Linux (e.g. CentOS) you will need to install **R** from source with the development flags (this bit is important). You can read more here: <https://cloud.r-project.org/sources.html>

Now you have the development version of **R** installed (hopefully) I would also suggest you get yourself **R-Studio**. It is a very popular and well maintained **R** IDE that gives you a lot of helpful shortcuts to scripting and analysing with **R**. The latest version can be grabbed from <https://www.rstudio.com/products/rstudio/> where you almost certainly want the free Desktop version.

### Build Tools

Several packages in the **ProTools** suite require compilation. Here is what you might need depending on your platform.

#### Linux Users

You brave souls, you know what you are doing (I hope). You do you!

#### Mac Users

You should not need to install separate compilers with any **R** after v4.0.0, but in case you are stuck on an older version you can follow the extra instructions here [https://mac.r-project.org/tools/](https://mac.r-project.org/tools/)

#### Windows Users

Windows users might need to go through a couple of additional steps. Most likely you will need to install *Rtools*, which are available at [https://cran.r-project.org/bin/windows/Rtools/](https://cran.r-project.org/bin/windows/Rtools/) and follow the instructions about how to link these into your system path. You will know it is working because the following will not be empty:

```R
Sys.which("make")
```

### Getting ProTools

Install **ProTools** from GitHub using `remotes`:

```R
install.packages('remotes')
remotes::install_github("asgr/ProTools")
library(ProTools)
```

#### Package Dependencies

The above should also install all required packages. The minimum versions required are listed in the DESCRIPTION file. If you have trouble with the automatic install you can install the sub-packages manually first:

```R
install.packages('remotes')
remotes::install_github("asgr/celestial")
remotes::install_github("asgr/Highlander")
remotes::install_github("asgr/hyper.fit")
remotes::install_github("asgr/magicaxis")
remotes::install_github("asgr/ParmOff")
remotes::install_github("ICRAR/ProFit")
remotes::install_github("asgr/ProFound")
remotes::install_github("asgr/ProFuse")
remotes::install_github("asgr/ProGeny")
remotes::install_github("asgr/ProPane")
remotes::install_github("asgr/ProSpectData")
remotes::install_github("asgr/ProSpect")
remotes::install_github("asgr/ProUtils")
remotes::install_github("asgr/Rfits")
remotes::install_github("asgr/Rwcs")
remotes::install_github("asgr/sphereplot")
remotes::install_github("asgr/ProTools")
```

Note that **ProSpectData** must be installed before **ProSpect** since the latter depends on it.

## Code Example

Loading **ProTools** attaches all packages in the suite simultaneously:

```R
library(ProTools)
```

After loading, all functions from every sub-package are immediately available. For example, to read a FITS image, run source extraction, and then fit a galaxy SED:

```R
# Read a FITS image
image = Rfits_read_image(system.file("extdata", "image.fits", package="Rfits"))

# Run source extraction
profound = profoundProFound(image, skycut=1.5, magzero=30, verbose=TRUE)

# Compute a cosmological luminosity distance
cosdistLumDist(z=0.1, H0=70, OmegaM=0.3)
```

To find long-form examples for individual packages please check the vignettes provided with each package, or browse these externally at <http://rpubs.com/asgr/>

## Motivation

The **ProTools** suite was developed to provide a fully integrated, end-to-end pipeline for extragalactic astronomical data analysis in **R**. Rather than relying on a patchwork of loosely connected tools, **ProTools** provides a coherent ecosystem where each package is designed to interoperate naturally with the others. The meta-package exists so that users can load the entire suite with a single command and immediately have access to everything they need.

## Contributors

Aaron Robotham (ICRAR-UWA), Rodrigo Tobar (ICRAR-UWA), Sabine Bellstedt (ICRAR-UWA), Jessica Thorne (ICRAR-UWA), Jordan D'Silva (ICRAR-UWA)

Individual sub-packages have their own contributor lists; see each package's documentation for details.

## Referencing **ProTools**

Nearly all of the **ProTools** packages have appropriate refereed or ASCL citations. Please credit these papers and ASCL when the software is used for your work.

### Refereed Paper References

Publications describing the methods and science behind the **ProTools** packages can be found in [Aaron Robotham's ADS Library](https://ui.adsabs.harvard.edu/user/libraries/-I4xxWbuR_-7f2b77Te36Q).

Key **ProTools** software focussed papers:

Robotham A.S.G., et al., 2017, MNRAS, 466, 1513 (**ProFit** code introduction paper)

Robotham A.S.G., et al., 2018, MNRAS, 476, 3137 (**ProFound** code introduction paper)

Robotham A.S.G., et al., 2020, MNRAS, 495, 905 (**ProSpect** code introduction paper)

Thorne J.E.T., et al., 2021, MNRAS, 505, 540 (**Highlander** is discussed briefly in this work)

Robotham A.S.G., et al., 2022, MNRAS, 513, 2985 (**ProFuse** code introduction paper)

Robotham A.S.G., et al., 2024, MNRAS, 528, 5046 (**ProPane** code introduction paper; **Rfits**, **Rwcs** are also discussed briefly in this work)

Robotham A.S.G. & Bellstedt, 2025, RASTI, 4, 19 (**ProGeny** code introduction paper)

### ASCL References

Robotham A.S.G., 2016, ascl.soft., ascl:1601.002 (**hyper.fit**)

Robotham A.S.G., 2016, ascl.soft., ascl:1602.011 (**celestial**)

Robotham A.S.G., 2016, ascl.soft., ascl:1604.004 (**magicaxis**)

Robotham A.S.G., 2016, ascl.soft., ascl:1612.004 (**ProFit**)

Robotham A.S.G., 2018, ascl.soft., ascl:1804.006 (**ProFound**)

Robotham A.S.G., 2020, ascl.soft., ascl:2002.007 (**ProSpect**)

Robotham A.S.G., 2022, ascl.soft., ascl:2204.018 (**ProFuse**)

Robotham A.S.G., 2023, ascl.soft., ascl:2312.020 (**ProPane**)

Robotham A.S.G., 2024, ascl.soft., ascl:2402.002 (**Rfits**)

Robotham A.S.G., 2024, ascl.soft., ascl:2402.003 (**Rwcs**)

## Resources

<https://ui.adsabs.harvard.edu/user/libraries/-I4xxWbuR_-7f2b77Te36Q>

<http://rpubs.com/asgr/>

## Forums

Please sign up to <http://profit.freeforums.net/> if you want to ask a question (or browse the questions asked by others).

## License

LGPL-3
