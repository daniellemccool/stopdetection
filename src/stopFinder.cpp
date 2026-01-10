#include <Rcpp.h>
#include "haversine.h"
using namespace Rcpp;



//' @title Stop Detection Algorithm (C++ Backend)
//'
//' @description
//' Low-level C++ implementation of the stop detection algorithm.
//' Users should typically call [stopFinderFast()] instead.
//'
//' @param lat Numeric vector of latitudes (decimal degrees)
//' @param lon Numeric vector of longitudes (decimal degrees)
//' @param time Numeric vector of timestamps
//' @param thetaD Distance threshold in meters
//' @param thetaT Time threshold (same units as `time`)
//'
//' @return Integer vector of stop initiation indices (1-indexed), with
//'   `NA` for points not belonging to a stop.
//'
//' @seealso [stopFinderFast()] for the recommended interface
//' @family stop-detection
//' @keywords internal
//' @export
// [[Rcpp::export]]
IntegerVector stopFinder_cpp(NumericVector lat, NumericVector lon,
                            NumericVector time, double thetaD, double thetaT) {
  int n = lon.size();
  IntegerVector stop_idx(n, NA_INTEGER);

  int i = 0;
  while (i < n - 1) {
    int j = i + 1;
    while (j < n) {

      double dist = haversine_impl(lat[i], lon[i], lat[j], lon[j]);

      if (dist >= thetaD) {
        if ((time[j] - time[i]) >= thetaT) {
          for (int k = i; k < j; k++) stop_idx[k] = i + 1; // R's 1-indexing
        }
        i = j;
        break;
      }
      j++;
    }
    if (j >= n) break;
  }

  // Final stop
  if ((time[n-1] - time[i]) >= thetaT) {
    for (int k = i; k < n; k++) stop_idx[k] = i + 1;
  }

  return stop_idx;
}
