# A groovy modbus library

## End 2 End Technologies LLC Notice

This is private variant of the `libmodbus` maintained by the End 2 End Technologies LLC ("E2E").
for its own purposes. However, in order to comply with conditions of the LGPL license,
source code of this variant is made public through this repository.

You are allowed to use this variant of `libmodbus` according to conditions of the LGPL license,
including, but not limited to, creating derivative works.
However, for this variant, feature requests are not accepted, pull requests also not accepted,
and E2E will maintain additional feature set, not available
in the original `libmodbus`, and some other differences from the original library
on its own discretion. Please send your feature requests to the original `libmodbus`.
However, bug reports related to this variant of the library are always welcome.

This version of `libmodbus` is primarily targeted for the Linux based operating systems.
It may be incompatible with other operating systems, that original `libmodbus` is compatible with.

The rest of content of this document is just a copy of the original README.md document
from the original `libmodbus`, slightly updated to refelect some changes,
introduced by E2E. However, E2E does not provide
any warranties of any kind about its accuracy and relevance after the changes,
aplied to the code and makes no any promises of keeping it up to date, accurate and relevant.

## Overview

libmodbus-e2e is a free software library to send/receive data with a device which
respects the Modbus protocol. This library can use a serial port or an Ethernet
connection.

The functions included in the library have been derived from the Modicon Modbus
Protocol Reference Guide which can be obtained from [www.modbus.org](http://www.modbus.org).

The license of libmodbus is *LGPL v2.1 or later*.

The official website of the original `libmodbus` library is [www.libmodbus.org](http://www.libmodbus.org).
The website contains the latest version of the documentation for the original library.
Latest documentation for this variant of library is in this repository.

The original library is written in C and designed to run on Linux, Mac OS X, FreeBSD, Embox,
QNX and Windows. E2E, however, currently targets
this variant of the library only to Linux-based systems.

You can use the original library on MCUs with Embox RTOS.

## Installation

You will only need to install automake, autoconf, libtool and a C compiler (gcc
or clang) to compile the library and asciidoc and xmlto to generate the
documentation (optional).

To install, just run the usual dance, `./configure && make install`. Run
`./autogen.sh` first to generate the `configure` script if required.

You can change installation directory with prefix option, eg.
`./configure --prefix=/usr/local/`.
You have to check that the installation library path is
properly set up on your system (*/etc/ld.so.conf.d*) and library cache is up to
date (run `ldconfig` as root if required).

The library provides a *libmodbus_e2e.pc* file to use with `pkg-config`
to ease your program compilation and linking.

If you want to compile with Microsoft Visual Studio, you should follow the
instructions in `./src/win32/README.md`.

To compile under Windows, install [MinGW](http://www.mingw.org/) and MSYS then
select the common packages (gcc, automake, libtool, etc). The directory
*./src/win32/* contains a Visual C project.

To compile under OS X with [homebrew](http://mxcl.github.com/homebrew/), you
will need to install the following dependencies first:
`brew install autoconf automake libtool`.

To build under Embox, you have to use its build system.

## Testing

Some tests are provided in *tests* directory, you can freely edit the source
code to fit your needs (it's Free Software :).

See *tests/README* for a description of each program.

For a quick test of libmodbus, you can run the following programs in two shells:

1. ./unit-test-server
2. ./unit-test-client

By default, all TCP unit tests will be executed (see --help for options).

It's also possible to run the unit tests with `make check`.

## To report a bug or to contribute

See [CONTRIBUTING](CONTRIBUTING.md) document.

## Documentation

You can serve the local documentation with:

```shell
pip install mkdocs-material
mkdocs serve
```

## Packaging

NOTE: This section is addeed and maintained by End 2 End Technologies LLC.

### Overview of Packaging

This repository contains files and tags for producing binary packages.

Debian packaging files are maintained on the branch `debian`.

Debian package tags have format `debian/vX.Y.Z-D`, which resembles package vesion, including "Debian version" component
(see [Debian Policy Manual, section 5.6.12.2. Special version conventions](https://www.debian.org/doc/debian-policy/ch-controlfields.html#special-version-conventions)
and [Versioning wiki page](https://wiki.debian.org/Versioning)).

RPM packages are not officially supported yet, but branch `rpm` exists for that purpose.

### Releasing a new Debian package version

1. Merge release tag into branch `debian`:

   ```shell
   git checkout debian
   git merge vX.Y.Z
   # Resolve any merge conflicts here
   git push
   ```

2. Add new entry into [changelog](debian/changelog), commit and push it.

   ```shell
   vim debian/changelog
   # add new entry
   git add debian/changelog
   git commit -m "Updated changelog for package vX.Y.Z-D"
   git push
   ```

3. Test package build, fix any issues.

4. Make sure all your changes committed and pushed.

5. Put new package tag and push it.

   ```shell
   git tag debian/vX.Y.Z-D
   git push --tags
   ```

### Building Debian package

1. Preparation: install required build dependencides:

   ```shell
   sudo apt install -y autoconf automake build-essential debhelper asciidoc \
                       xmlto psmisc
   ```

2. Run packaging script with package tag, for example:

   ```shell
   ./pkg.sh debian/v1.0.2-1
   ```

Resulting `deb` and possibly `ddeb` package files will appear in the `$HOME/Packages`.
