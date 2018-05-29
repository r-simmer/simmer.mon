# <img src="https://raw.githubusercontent.com/r-simmer/r-simmer.github.io/master/images/simmer-logo.png" alt="simmer" width="200" />.mon

[![Build Status](https://travis-ci.org/r-simmer/simmer.mon.svg?branch=master)](https://travis-ci.org/r-simmer/simmer.mon)
[![Coverage Status](https://codecov.io/gh/r-simmer/simmer.mon/branch/master/graph/badge.svg)](https://codecov.io/gh/r-simmer/simmer.mon)
[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/simmer.mon)](https://cran.r-project.org/package=simmer.mon)
[![Downloads](https://cranlogs.r-pkg.org/badges/simmer.mon)](https://cran.rstudio.com/package=simmer.mon)

**simmer.mon** provides monitoring backends that can be attached to [**simmer**](http://r-simmer.org), the Discrete-Event Simulation (DES) package for R, to replace the default in-memory monitor:

- `monitor_dbi()`: inserts monitoring values into a database (via `DBI`), with some in-memory buffering to improve performance, but it's still very experimental and it can be greatly improved.

## Installation

The installation from GitHub requires the [remotes](https://cran.r-project.org/package=remotes) package.

``` r
# install.packages("remotes")
remotes::install_github("r-simmer/simmer.mon")
```
