# <img src="https://raw.githubusercontent.com/r-simmer/r-simmer.github.io/master/images/simmer-logo.png" alt="simmer" width="200" />.mon

[![build](https://github.com/r-simmer/simmer.mon/actions/workflows/build.yml/badge.svg)](https://github.com/r-simmer/simmer.mon/actions/workflows/build.yml)
[![Status\_Badge](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)

**simmer.mon** provides monitoring backends that can be attached to [**simmer**](http://r-simmer.org), the Discrete-Event Simulation (DES) package for R, to replace the default in-memory monitor:

- `monitor_dbi()`: inserts monitoring values into a database (via `DBI`), with some in-memory buffering to improve performance, but it's still very experimental and it can be greatly improved.

## Installation

The installation from GitHub requires the [remotes](https://cran.r-project.org/package=remotes) package.

``` r
# install.packages("remotes")
remotes::install_github("r-simmer/simmer.mon")
```
