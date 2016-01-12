Create a Magerun RPM package
============================

This simple project will download the latest version of the excellent [n98-magerun](https://github.com/netz98/n98-magerun) and build a RPM file that installs to **/usr/bin/magerun**

## Build requirements

- PHP (>= 5.3)
- curl
- [fpm](https://github.com/jordansissel/fpm)
- rpmbuild

## Usage

    $ ./build-rpm.sh

This should spit out the RPM in the current directory.

## Package contents

    $ rpm -pql magerun-1.97.10-1.noarch.rpm
    /usr/bin/magerun
