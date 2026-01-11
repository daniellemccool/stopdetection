## Resubmission

This is a resubmission of stopdetection after being archived in January 2025
due to undefined behaviour and illegal memory access detected by UBSAN
and R-devel checks.

The root cause was an unsafe dependency on the geodist package, which
performed illegal memory accesses in its C code. That dependency has been
removed and replaced with a custom Rcpp Haversine implementation.

In addition, a memory-unsafe data.table column assignment pattern was
fixed by preallocating columns before assignment.

The package has been checked under:
* R-devel m1-san (ASAN + UBSAN)
* GCC UBSAN
* Valgrind (only “possibly lost” TLS allocations originating from libgomp /
  data.table; no definite leaks or invalid reads/writes attributable to
  stopdetection)
* rhub Linux and macOS

No UBSAN, ASAN or valgrind errors have been observed in stopdetection’s
compiled code.
