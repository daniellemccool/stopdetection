# stopdetection 0.1.3

## New Features

* Replaced geodist dependency with custom C++ haversine implementation for
  faster distance calculations and better control over edge cases

## Bug Fixes

* Fixed critical issue where `.` was redefined in utils.R, causing NULL coercion 
  errors in data.table printing functions on CRAN's fedora-gcc test environment 
* Changed `NA` to `NA_integer_` in returnStateEvents.R for type safety concerns
* Removed commented-out legacy code for cleaner codebase

---

# stopdetection 0.1.2
* Bugfix for incorrect handling of two temporally adjacent locations exceeding
  stop radius and time but that fail to become tracks.
---

# stopdetection 0.1.1

* Bugfix for data containing either no tracks or no trips. 
* Added a `NEWS.md` file to track changes to the package.
