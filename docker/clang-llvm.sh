#!/usr/bin/env bash
# Sets up clang and other LLVM packages for use with MSVC.
# Note that these functions rely on the docker image being of Ubuntu 22.04

set -o errexit
set -x

install_clang_llvm() {
    apt-get update

    # We install specific versions of clang. This to make sure
    # it remains stable.
    apt-get install --install-recommends --assume-yes \
        clang-13 \
        lld-13 \
        clang-tools-13
}

setup_clang() {
    _setup_clang_symlinks

    # Use clang instead of gcc when compiling binaries targeting the host (eg proc macros, build files)
    update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100
    update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang++ 100
}

_setup_clang_symlinks() {
    # For ubuntu 22.04, clang version 13 is the standard version
    # in apt.

    # Because we install specific versions, there won't exist
    # symlinks for any default installation.
    ln -s /usr/bin/clang-13 /usr/bin/clang
    ln -s /usr/bin/clang++-13 /usr/bin/clang++
    ln -s lld-13 /usr/bin/ld.lld
    ln -s lld-link-13 /usr/bin/lld-link

    # We also need to setup symlinks ourselves for the MSVC shims because they are not
    # installed as clang-cl nor as llvm-lib by default.
    ln -s /usr/bin/clang-cl-13 /usr/bin/clang-cl
    ln -s llvm-ar-13 /usr/bin/llvm-lib

}

install_clang_llvm
setup_clang

