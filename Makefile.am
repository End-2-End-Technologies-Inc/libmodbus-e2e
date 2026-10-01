# Copyright © Stéphane Raimbault <stephane.raimbault@gmail.com> and/or contibutors.
# Copyright © End 2 End Technologies, LLC., 2025.

CLEANFILES =
ACLOCAL_AMFLAGS = -I m4 ${ACLOCAL_FLAGS}
AM_MAKEFLAGS = --no-print-directory

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = libmodbus_e2e.pc
EXTRA_DIST = libmodbus_e2e.pc.in
CLEANFILES += libmodbus_e2e.pc

dist_doc_DATA = AUTHORS NEWS.md README.md

SUBDIRS = src

if BUILD_TESTS
SUBDIRS += tests
endif

# Code coverage (gcov/lcov)
# Usage: make CFLAGS="--coverage -O0" LDFLAGS="--coverage" && make coverage

.PHONY: coverage

coverage:
	-find $(top_builddir) -name '*.gcda' -delete
	$(MAKE) check
	lcov --capture --directory $(top_builddir)/src --output-file coverage.info --ignore-errors source
	lcov --remove coverage.info '/usr/*' --output-file coverage.info
	genhtml coverage.info --output-directory coverage

CLEANFILES += coverage.info
clean-local:
	-rm -rf coverage
	-find $(top_builddir) -name '*.gcda' -delete
	-find $(top_builddir) -name '*.gcno' -delete
