#!/usr/bin/env bash

set -x
set -euo pipefail

# shellcheck disable=SC1091
. lib.sh

main() {
    local commit=44dc13b5e62ecc2373fbe7e4727a525001f403f4

    install_packages python3 \
        python3-pip \
        msitools \
        ca-certificates

    # python3-six takes forever
    python3 -m pip install six

    local td
    td="$(mktemp -d)"

    pushd "${td}"
    git clone https://github.com/mstorsjo/msvc-wine --depth 1
    cd msvc-wine
    git fetch --depth=1 origin "${commit}"
    git checkout "${commit}"
    python3 vsdownload.py --accept-license --dest /opt/msvc
    ./install.sh /opt/msvc

    BIN=/opt/msvc/bin/x64 . ./msvcenv-native.sh

    # python3 -m pip uninstall six --yes
    purge_packages

    popd

    rm -rf "${td}"
    rm "${0}"
}

main "${@}"
