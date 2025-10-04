#!/usr/bin/env bash
###############################################################################
# SPDX-License-Identifier: LGPL-2.1-or-later
#
# libmodbus-e2e - Fork of the libmodbus library.
# Copyright (c) End 2 End Technologies LLC, 2025. All rights reserved.
#
# pkg.sh
#
# Build Debian packages.
###############################################################################

set -eo pipefail

# DEB packaging tutorials:
# https://john-tucker.medium.com/debian-packaging-by-example-118c18f5dbfe
# https://www.boniface.me/posts/debian-packaging-101/

# Get script directory
# See https://stackoverflow.com/a/246128/1540501
_s="${BASH_SOURCE[0]}"
while [[ -L "${_s}" ]]; do
  _script_dir=$( cd -P "$( dirname "${_s}" )" >/dev/null 2>&1 && pwd )
  _s=$(readlink "${_s}")
  [[ "${_s}" != /* ]] && _s="${_script_dir}/${_s}"
done
_script_dir=$( cd -P "$( dirname "${_s}" )" >/dev/null 2>&1 && pwd )
_script_file=$(basename "$0")

# Constants
_tag_pattern="(debian/vX.Y.Z-D)"

_commit=""
_tag=""
_special_tag=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --latest|--current)
      _special_tag="$1"
      shift
      ;;

    -h|--help)
      echo "Usage: $0 [options] [PACKAGE_VERSION_TAG]"
      echo "Build Debian packages."
      echo ""
      echo "Parameters:"
      echo "PACKAGE_VERSION_TAG   The package version tag."
      echo ""
      echo "Options:"
      echo "  --current    Use current commit (VERSION_TAG is ignored, if specified)"
      echo "  --latest     Use latest version tag (VERSION_TAG is ignored, if specified)"
      echo "  -h, --help   Show this help message and exit"
      exit 0
      ;;

    -*)
      echo "$0: unknown option: $1" >&2
      exit 1
      ;;

    *)
      _tag="$1"
      break
      ;;
  esac
done

# Check that version tag is specified
if [[ -z "${_tag}" && -z "${_special_tag}" ]]; then
  echo "$0: version not specified." >&2
  echo "Try '$0 --help' for more information."
  exit 1
fi

if [[ -n "${_tag}" ]]; then
  _t=$(echo "${_tag}" | grep -E '^debian/v')
  if [[ -z "${_t}" ]]; then
    echo "$0: PACKAGE_VERSION_TAG does not match required pattern ${_tag_pattern}."
    exit 1
  fi
  _t="${_t#debian/v}"
  echo "Tag version part: ${_t}"
  if [[ "${_t}" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)\-([0-9A-Za-z]+)$ ]]; then
    true
  else
    echo "$0: PACKAGE_VERSION_TAG does not match required pattern ${_tag_pattern}."
    exit 1
  fi
fi

if [[ -z "${_special_tag}" ]]; then

  # Collect release tags
  mapfile -t _tags < <( git tag | grep -E '^debian/v' )
  _rtags=()
  for _t in "${_tags[@]}"; do
    _t2="${_t#debian/v}"
    if [[ "${_t2}" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)\-([0-9A-Za-z]+)$ ]]; then
      _rtags+=("${_t}")
    fi
  done
  if [[ "${#_rtags[@]}" == 0 ]]; then
    echo "$0: there are no release tags." >&2
    exit 1
  fi

  # Check if version tag exists
  _exists=0
  for _t in "${_rtags[@]}"; do
    if [[ "${_tag}" == "${_t}" ]]; then
      _exists=1
      break
    fi
  done
  if [[ "${_exists}" == 0 ]]; then
    echo "$0: there is no release tag '${_tag}'." >&2
    exit 1
  fi

elif [[ "${_special_tag}" == "--current" ]]; then

  # Get current commit
  _commit=$(git rev-parse HEAD)

elif [[ "${_special_tag}" == "--latest" ]]; then

  # Collect release tags
  mapfile -t _rtags < <( git tag | grep -E '^debian/v' )
  _a=()
  for _t in "${_rtags[@]}"; do
    _t="${_t#debian/v}"
    if [[ "${_t}" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)\-([0-9A-Za-z]+)$ ]]; then
      _a+=("${_t}")
    fi
  done
  if [[ "${#_a[@]}" == 0 ]]; then
    echo "$0: there are no matching release tags ${_tag_pattern}." >&2
    exit 1
  fi

  # Find maximum major version
  _max_major=0
  for _t in "${_a[@]}"; do
    if [[ "${_t}" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)\-([0-9A-Za-z]+)$ ]]; then
      _major="${BASH_REMATCH[1]}"
      if (( _major > _max_major )); then
        _max_major="${_major}"
      fi
    fi
  done

  # Filter tags according to maximum major version
  _b=()
  for _t in "${_a[@]}"; do
    if [[ "${_t}" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)\-([0-9A-Za-z]+)$ ]]; then
      _major="${BASH_REMATCH[1]}"
      if (( _major == _max_major )); then
        _b+=("${_t}")
      fi
    fi
  done
  if [[ "${#_b[@]}" == 0 ]]; then
    echo "$0: there are no matching release tags ${_tag_pattern} after filtering by maximum major version." >&2
    exit 1
  fi

  # Find max minor version
  _max_minor=0
  for _t in "${_b[@]}"; do
    if [[ "${_t}" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)\-([0-9A-Za-z]+)$ ]]; then
      _minor="${BASH_REMATCH[2]}"
      if (( _minor > _max_minor )); then
        _max_minor="${_minor}"
      fi
    fi
  done

  # Filter tags according to maximum minor version
  _a=()
  for _t in "${_b[@]}"; do
    if [[ "${_t}" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)\-([0-9A-Za-z]+)$ ]]; then
      _minor="${BASH_REMATCH[2]}"
      if (( _minor == _max_minor )); then
        _a+=("${_t}")
      fi
    fi
  done
  if [[ "${#_a[@]}" == 0 ]]; then
    echo "$0: there are no matching release tags ${_tag_pattern} after filtering by maximum minor version." >&2
    exit 1
  fi

  # Find max patch version
  _max_patch=0
  for _t in "${_a[@]}"; do
    if [[ "${_t}" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)\-([0-9A-Za-z]+)$ ]]; then
      _patch="${BASH_REMATCH[3]}"
      if (( _patch > _max_patch )); then
        _max_patch="${_patch}"
      fi
    fi
  done

  # Filter tags according to maximum patch version
  _b=()
  for _t in "${_a[@]}"; do
    if [[ "${_t}" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)\-([0-9A-Za-z]+)$ ]]; then
      _patch="${BASH_REMATCH[3]}"
      if (( _patch == _max_patch )); then
        _b+=("${_t}")
      fi
    fi
  done
  if [[ "${#_b[@]}" == 0 ]]; then
    echo "$0: there are no matching release tags ${_tag_pattern} after filtering by maximum patch version." >&2
    exit 1
  fi

  # Find max debian version
  _max_debian_ver=0
  for _t in "${_b[@]}"; do
    if [[ "${_t}" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)\-([0-9A-Za-z]+)$ ]]; then
      _debian_ver="${BASH_REMATCH[4]}"
      if (( _debian_ver > _max_debian_ver )); then
        _max_debian_ver="${_debian_ver}"
      fi
    fi
  done

  # Reconstruct the tag
  _tag="debian/v${_major}.${_minor}.${_patch}-${_max_debian_ver}"

fi

if [[ -n "${_commit}" ]]; then
  echo "Commit: ${_commit}"
fi

if [[ -n "${_tag}" ]]; then
  echo "Tag: ${_tag}"
fi

_build_dir=""
function on_exit
{
  if [[ -n "${_build_dir}" && -d "${_build_dir}" ]]; then
    echo "Removing temporary directory..."
    rm -rf "${_build_dir}"
  fi
}
trap on_exit EXIT

_build_dir=$(mktemp -d)
echo "Build directory: ${_build_dir}"

echo "Cloning repository..."
cd "${_build_dir}"
if [[ -n "${_commit}" ]]; then
  git clone https://github.com/End-2-End-Technologies-Inc/libmodbus-e2e.git
  cd libmodbus-e2e
  git checkout "${_commit}"
  _ts_now=$(date -u +"%Y%m%d%H%M%S")
  _major=$(grep m4_define configure.ac | grep libmodbus_e2e_version_major | sed -n 's/.*\[\([^]]*\)\].*\[\([^]]*\)\].*/\2/p')
  _minor=$(grep m4_define configure.ac | grep libmodbus_e2e_version_minor | sed -n 's/.*\[\([^]]*\)\].*\[\([^]]*\)\].*/\2/p')
  _patch=$(grep m4_define configure.ac | grep libmodbus_e2e_version_micro | sed -n 's/.*\[\([^]]*\)\].*\[\([^]]*\)\].*/\2/p')
  _version="${_major}.${_minor}.${_patch}~git${_ts_now}.${_commit}"
  mv -f debian/changelog debian/changelog.original
  echo "libmodbus-e2e (${_version}) unstable; urgency=medium" >debian/changelog
  echo "" >>debian/changelog
  echo "  * Intermediate build." >>debian/changelog
  echo "" >>debian/changelog
  _dt=$(date -u -R)
  echo " -- End 2 End Technologies <support@e2etechinc.com>  ${_dt}" >>debian/changelog
  echo "" >>debian/changelog
  cat debian/changelog.original >>debian/changelog
  cd ..
else
  git clone https://github.com/End-2-End-Technologies-Inc/libmodbus-e2e.git --branch "${_tag}" --depth 1
  _version="${_tag#debian/v}"
fi

echo "Version: ${_version}"
echo ""

echo "Building package..."

cd libmodbus-e2e
autoreconf -i
fakeroot debian/rules binary
echo "Packages built."
cd ..
ls -la

echo "Copying package files..."
mkdir -p "$HOME/Packages"
if find . -maxdepth 1 -name '*.deb' | grep -q .; then
  cp -fv *.deb "$HOME/Packages"
fi
if find . -maxdepth 1 -name '*.ddeb' | grep -q .; then
  cp -fv *.ddeb "$HOME/Packages"
fi

echo "Done."
