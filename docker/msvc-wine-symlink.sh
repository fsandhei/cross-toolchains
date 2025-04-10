#!/usr/bin/env bash
# shellcheck disable=SC2016

set -x
set -euo pipefail

main() {
    local arch="${1}"

    # create a symlink to our sysroot to make it accessible in the dockerfile
    local msvc_version
    msvc_version=$(ls /opt/msvc/vc/tools/msvc/)
    ln -s "/opt/msvc/vc/tools/msvc/${msvc_version}" "/opt/msvc/vc/tools/msvc/latest"

    rm "${0}"
}

main "${@}"
