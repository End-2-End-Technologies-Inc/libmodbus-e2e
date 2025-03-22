# Copyright © Stéphane Raimbault <stephane.raimbault@gmail.com> and/or contibutors.
# Copyright © End 2 End Technologies, Inc., 2025.

CLEANFILES =
ACLOCAL_AMFLAGS = -I m4 ${ACLOCAL_FLAGS}
AM_MAKEFLAGS = --no-print-directory

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = libmodbus_e2e.pc
EXTRA_DIST = libmodbus_e2e.pc.in
CLEANFILES += libmodbus_e2e.pc

dist_doc_DATA = AUTHORS NEWS README.md

SUBDIRS = src

if BUILD_TESTS
SUBDIRS += tests
endif
