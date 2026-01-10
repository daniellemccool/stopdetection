#ifndef HAVERSINE_H
#define HAVERSINE_H

#include <cmath>

inline double to_rad(double deg) {
  return deg * M_PI / 180.0;
}

inline double haversine_impl(double lat1, double lon1,
                             double lat2, double lon2) {
  if ((lat1 == lat2) && (lon1 == lon2)) {
    return 0.0;
  }

  const double radius_m = 6371000.0;

  double d_phi = to_rad(lat2 - lat1);
  double d_lambda = to_rad(lon2 - lon1);
  double phi1 = to_rad(lat1);
  double phi2 = to_rad(lat2);

  double a = pow(sin(d_phi / 2.0), 2.0) +
    cos(phi1) * cos(phi2) * pow(sin(d_lambda / 2.0), 2.0);
  double c = 2.0 * atan2(sqrt(a), sqrt(1.0 - a));

  return radius_m * c;
}

#endif
