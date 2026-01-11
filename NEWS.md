# stopdetection 0.1.3

## New Features

* Added experimental C++ implementation of stopFinder, stopFinderFast

## Bug fixes and stability

* Replaced geodist dependency with custom C++ haversine implementation to
  remove illegal memory access in upstream code.
* Fixed memory-unsafe data.table column assignment that caused crashes under
  R-devel and UBSAN.
* Package now clean under ASAN, UBSAN and valgrind.

---

# stopdetection 0.1.2
* Bugfix for incorrect handling of two temporally adjacent locations exceeding
  stop radius and time but that fail to become tracks.
---

# stopdetection 0.1.1

* Bugfix for data containing either no tracks or no trips. 
* Added a `NEWS.md` file to track changes to the package.
