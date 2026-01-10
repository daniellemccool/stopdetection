#include <Rcpp.h>
#include "haversine.h"
using namespace Rcpp;


//' Haversine Distance Between Two Points
//' Calculate the great circle distance between two points on Earth
//' using the Haversine formula.
//'
//' @param lat1 Latitude of first point (decimal degrees)
//' @param lon1 Longitude of first point (decimal degrees)
//' @param lat2 Latitude of second point (decimal degrees)
//' @param lon2 Longitude of second point (decimal degrees)
//' @return Distance in meters
//' @export
//' @examples
//' # Distance between two points
//' haversine_cpp(52.092839, 5.1299311, 52.092698, 5.135613)
// [[Rcpp::export]]
double haversine_cpp(double lat1, double lon1,
                     double lat2, double lon2) {
  return haversine_impl(lat1, lon1, lat2, lon2);
}

//' Vectorized Haversine Distance (Paired)
//' Calculate distances between corresponding pairs of points.
//'
//' @param lat1 Vector of starting latitudes
//' @param lon1 Vector of starting longitudes
//' @param lat2 Vector of ending latitudes
//' @param lon2 Vector of ending longitudes
//' @return Vector of distances in meters
//' @export
//' @examples
//' haversine_vec(c(52.09, 52.10), c(5.12, 5.13),
//'               c(52.10, 52.11), c(5.13, 5.14))
// [[Rcpp::export]]
NumericVector haversine_vec(NumericVector lat1, NumericVector lon1,
                            NumericVector lat2, NumericVector lon2) {
  int n = lat1.size();

  // Check that all vectors have the same length
  if (lon1.size() != n || lat2.size() != n || lon2.size() != n) {
    stop("All input vectors must have the same length");
  }

  NumericVector distances(n);

  for (int i = 0; i < n; i++) {
    distances[i] = haversine_impl(lat1[i], lon1[i], lat2[i], lon2[i]);
  }

  return distances;
}

//' Vectorized Haversine Distance (Sequential)
//' Calculate distances between consecutive points in a trajectory.
//'
//' @param lat Vector of latitudes
//' @param lon Vector of longitudes
//' @return Vector of distances in meters (length n-1)
//' @export
//' @examples
//' # Distance between consecutive points
//' haversine_seq(c(52.09, 52.10, 52.11), c(5.12, 5.13, 5.14))
// [[Rcpp::export]]
NumericVector haversine_seq(NumericVector lat, NumericVector lon) {
  int n = lat.size();

  if (n < 2) {
    return NumericVector(0);  // Return empty vector for < 2 points
  }

  if (lon.size() != n) {
    stop("lat and lon must have the same length");
  }

  NumericVector distances(n - 1);

  for (int i = 0; i < n - 1; i++) {
    distances[i] = haversine_impl(lat[i], lon[i], lat[i + 1], lon[i + 1]);
  }

  return distances;
}
