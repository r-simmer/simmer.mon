#include "dbi.h"
using namespace Rcpp;

//[[Rcpp::export]]
SEXP DBIMonitor__new(const std::string& ends, const std::string& releases,
                     const std::string& attributes, const std::string& resources,
                     Function& dbClear, Function& dbAppend)
{
  return XPtr<DBIMonitor>(
    new DBIMonitor(ends, releases, attributes, resources, dbClear, dbAppend));
}
