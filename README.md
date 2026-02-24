# ProTools

**ProTools** is a convenience meta-package that loads all of the standard ProTools R packages with a single command. The suite provides a comprehensive toolkit for astronomical image analysis, galaxy modelling, spectral energy distribution fitting, and more.

## Sub-Packages

| Package | Status | Description |
|---------|--------|-------------|
| [celestial](https://github.com/asgr/celestial) | [![R-CMD-check](https://github.com/asgr/celestial/workflows/R-CMD-check/badge.svg)](https://github.com/asgr/celestial/actions) | Core astronomy routines (coordinates, cosmology, etc) |
| [Highlander](https://github.com/asgr/Highlander) | | Bayesian optimisation combining CMA-ES and MCMC |
| [hyper.fit](https://github.com/asgr/hyper.fit) | | N-dimensional hyperplane fitting with errors |
| [magicaxis](https://github.com/asgr/magicaxis) | [![R-CMD-check](https://github.com/asgr/magicaxis/workflows/R-CMD-check/badge.svg)](https://github.com/asgr/magicaxis/actions) | Pretty scientific plotting and axis formatting |
| [ParmOff](https://github.com/asgr/ParmOff) | | Flexible function argument matching |
| [ProFit](https://github.com/ICRAR/ProFit) | [![R-CMD-check](https://github.com/ICRAR/ProFit/workflows/R-CMD-check/badge.svg)](https://github.com/ICRAR/ProFit/actions) | Bayesian galaxy image profile fitting |
| [ProFound](https://github.com/asgr/ProFound) | [![R-CMD-check](https://github.com/asgr/ProFound/workflows/R-CMD-check/badge.svg)](https://github.com/asgr/ProFound/actions) | Source extraction and photometry |
| [ProFuse](https://github.com/asgr/ProFuse) |[![R-CMD-check](https://github.com/asgr/ProFuse/workflows/R-CMD-check/badge.svg)] | Multi-band galaxy fitting (ProFound + ProFit + ProSpect) |
| [ProGeny](https://github.com/asgr/ProGeny) | [![R-CMD-check](https://github.com/asgr/ProGeny/workflows/R-CMD-check/badge.svg)](https://github.com/asgr/ProGeny/actions) | Simple Stellar Population library generation |
| [ProPane](https://github.com/asgr/ProPane) | | Image warping, stacking, and registration |
| [ProSpect](https://github.com/asgr/ProSpect) | [![R-CMD-check](https://github.com/asgr/ProSpect/workflows/R-CMD-check/badge.svg)](https://github.com/asgr/ProSpect/actions) | Spectral energy distribution generation and fitting |
| [ProSpectData](https://github.com/asgr/ProSpectData) | | Spectral template data for ProSpect |
| [ProUtils](https://github.com/asgr/ProUtils) | [![R-CMD-check](https://github.com/asgr/ProUtils/workflows/R-CMD-check/badge.svg)](https://github.com/asgr/ProUtils/actions) | Shared low-level utilities for ProTools |
| [Rfits](https://github.com/asgr/Rfits) | [![R-CMD-check](https://github.com/asgr/Rfits/workflows/R-CMD-check/badge.svg)](https://github.com/asgr/Rfits/actions) | FITS file I/O for images, tables, and headers |
| [Rwcs](https://github.com/asgr/Rwcs) | [![R-CMD-check](https://github.com/asgr/Rwcs/workflows/R-CMD-check/badge.svg)](https://github.com/asgr/Rwcs/actions) | World Coordinate System projections and conversions |
| [sphereplot](https://github.com/asgr/sphereplot) | | Spherical coordinate plotting |

Nearly all packages live under GitHub user **asgr**, with the exception of **ProFit** which is hosted under **ICRAR**.

## Installation

First you will need to install each package listed above to at least the version number required in the DESCRIPTION file. Follow instructions on individual repos if required.

Next, install **ProTools** from GitHub using `remotes`:

```r
install.packages("remotes")
remotes::install_github("asgr/ProTools")
```

Loading the package will attach the entire **ProTools** software suite:

```r
library(ProTools)
```

## Papers

Publications describing the methods and science behind the ProTools packages can be found in [Aaron Robotham's ADS Library](https://ui.adsabs.harvard.edu/user/libraries/-I4xxWbuR_-7f2b77Te36Q).

## Author

[Aaron Robotham (ICRAR-UWA)](https://research-repository.uwa.edu.au/en/persons/aaron-robotham/)

## License

LGPL-3
