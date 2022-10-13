## Test environments
- R-hub windows-x86_64-devel (r-devel)
- R-hub ubuntu-gcc-release (r-release)
- R-hub fedora-clang-devel (r-devel)

## R CMD check results

- Notes on misspellings are a name and two accepted words

❯ On windows-x86_64-devel (r-devel)
  checking CRAN incoming feasibility ... [11s] NOTE
  Maintainer: 'McCool Danielle <d.m.mccool@uu.nl>'
  
  New submission
  
  Possibly misspelled words in DESCRIPTION:
    Montoliu (16:5) 
    Spatiotemporal (3:9)
    geolocation (10:50)

❯ On windows-x86_64-devel (r-devel)
  checking for detritus in the temp directory ... NOTE
  Found the following files/directories:
    'lastMiKTeXException'

❯ On ubuntu-gcc-release (r-release)
  checking CRAN incoming feasibility ... NOTE
  Maintainer: ‘McCool Danielle <d.m.mccool@uu.nl>’
  
  New submission
  
  Possibly misspelled words in DESCRIPTION:
    geolocation (10:50)
    Montoliu (16:5)
    Spatiotemporal (3:9)

❯ On fedora-clang-devel (r-devel)
  checking CRAN incoming feasibility ... [4s/13s] NOTE
  Maintainer: ‘McCool Danielle <d.m.mccool@uu.nl>’
  
  New submission
  
  Possibly misspelled words in DESCRIPTION:
    Montoliu (16:5)
    Spatiotemporal (3:9)
    geolocation (10:50)

❯ On fedora-clang-devel (r-devel)
  checking HTML version of manual ... NOTE
  Skipping checking HTML validation: no command 'tidy' found
  Skipping checking math rendering: package 'V8' unavailable

0 errors ✔ | 0 warnings ✔ | 5 notes ✖
