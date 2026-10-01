#!/usr/bin/env bash
###############################################################################
# SPDX-License-Identifier: LGPL-2.1-or-later
#
# libmodbus-e2e - Fork of the libmodbus library.
# Copyright (c) End 2 End Technologies LLC, 2025. All rights reserved.
#
# gencs.sh
#
# Generate checksum file.
###############################################################################

set -exo pipefail

if find . -maxdepth 1 -name '*.deb' | grep -q .; then
  _main_pkg_search="libmodbus-e2e0"
  _main_pkg_base=$(find . -maxdepth 1 -name '*.deb' | grep "${_main_pkg_search}" | grep -v dbgsym | sed 's|./||g' | sed 's|.deb||g')
  if [[ -z "${_main_pkg_base}" ]]; then
    echo "$0: Main package (containing with ${_main_pkg_search}) not found." >&2
    exit 1
  fi
  echo "Found main package"
  _cs_file="${_main_pkg_base}.sha256"
  sha256sum *.deb > "${_cs_file}"
else
  echo "$0: No DEB files generated!" >&2
  exit 1
fi
if find . -maxdepth 1 -name '*.ddeb' | grep -q .; then
  sha256sum *.ddeb >> "${_cs_file}"
fi

echo ""
echo "###############################################################################"
cat "${_cs_file}"
echo "###############################################################################"
