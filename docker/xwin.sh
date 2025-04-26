#!/usr/bin/env bash

# Sets up xwin and installs the latest
# available Microsoft Windows 10 SDK.

set -o errexit
set -x

die() {
    echo "$@" >&2
    exit 1
}

install_xwin() {
    export PATH="$HOME/.cargo/bin:$PATH"
    apt-get install --assume-yes --install-recommends tar

    cargo install --locked xwin
}

download_and_splat_win_sdk() {
    declare -r arg_arch="$1"
    declare -r arg_sdk_version="$2"

    export PATH="$HOME/.cargo/bin:$PATH"
    # Splat the CRT and SDK files to /xwin/crt and /xwin/sdk respectively
    xwin --accept-license --arch "$arg_arch" --sdk-version "$arg_sdk_version" splat --output /xwin
}

arch="x86_64"
sdk_version="10.0.26100"

while [[ $# -gt 0 ]]; do
    echo "$1"
    case $1 in
        "--arch")
            arch="$2"
            shift # past argument
            ;;
        "--sdk-version")
            sdk_version="$2"
            shift # past argument
            ;;
        "-*" | "--*")
            die "unknown argument $1"
            ;;
        * )
            break
    esac
    shift # past value
done

install_xwin
download_and_splat_win_sdk "$arch" "$sdk_version"

