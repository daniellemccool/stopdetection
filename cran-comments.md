## R CMD check results

0 errors | 0 warnings | 0 notes


## winbuilder results
* using R version 4.3.0 RC (2023-04-13 r84270 ucrt)
* using platform: x86_64-w64-mingw32 (64-bit)
Status: OK

## rhub

## Platform:	Fedora Linux, R-devel, clang, gfortran

Status: 1 NOTE

* checking HTML version of manual ... NOTE
Skipping checking HTML validation: no command 'tidy' found
Skipping checking math rendering: package 'V8' unavailable

## Platform:	Ubuntu Linux 20.04.1 LTS, R-release, GCC

Status: 1 NOTE

* checking CRAN incoming feasibility ... NOTE
Maintainer: ‘McCool Danielle <d.m.mccool@uu.nl>’

Found the following (possibly) invalid DOIs:
  DOI: 10.1109/MDM.2009.11
    From: DESCRIPTION
    Message: 418

DOI is valid, unsure how to resolve

## Platform:	Windows Server 2022, R-devel, 64 bit

Status: 1 NOTE

* checking HTML version of manual ... NOTE
Skipping checking math rendering: package 'V8' unavailable
* checking for detritus in the temp directory ... NOTE
Found the following files/directories:
  'lastMiKTeXException'

Apparently a known issue with Rhub
