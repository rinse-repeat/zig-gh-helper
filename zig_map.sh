#!/bin/bash

##################################################################
#
# Normalize TARGET to Zig Installation
#
# linux-x86_64-0.9.1.tar.xz, linux-i386-0.9.1.tar.xz, linux-aarch64-0.9.1.tar.xz, linux-armv7a-0.9.1.tar.xz
# macos-x86_64-0.9.1.tar.xz, NAN                    , macos-aarch64-0.9.1.tar.xz, NAN
# windows-x86_64-0.9.1.zip  ,windows-i386-0.9.1.zip , windows-aarch64-0.9.1.zip , NAN
# 
zig_triplets_env() {
    export ENV_FILE="$1"
    export TARGET="$2"
    
    #################
    # Supported OS
    case $TARGET in

        *"linux"*)
            TARGET_OS=linux
            ZIG_EXT=tar.xz
            ;;
        *"windows"*)
            TARGET_OS=windows
            ZIG_EXT=zip
            ;;
        *"macos"*)
            TARGET_OS=macos
            ZIG_EXT=tar.xz
            ;;
        
    esac

    #################
    # Supported Arch
    case $TARGET in

        *"x86_64"*)
            export TARGET_ARCH=x86_64
            ;;
        *"aarch64"*)
            export TARGET_ARCH=aarch64
            ;;
        *"arm"*)
            export TARGET_ARCH=armv7a
            ;;
        
    esac

    echo "ZIG_EXT=$ZIG_EXT" | tee -a $ENV_FILE
    echo "TARGET_OS=$TARGET_OS" | tee -a $ENV_FILE
    echo "TARGET_ARCH=$TARGET_ARCH" | tee -a $ENV_FILE

    # TODO: Only from current path? come w/ something better.
    export ZIG_HOME=$PWD/zig/zig-$TARGET_OS-$TARGET_ARCH-0.9.1
    echo "ZIG_HOME=$ZIG_HOME" | tee -a $ENV_FILE

}

zig_install_nix() {
    export ENV_FILE="$1"

    mkdir zig
    cd zig
    case $ZIG_EXT in
        "tar.xz")
            wget --quiet -O zig.tar.xz https://ziglang.org/download/0.9.1/zig-$TARGET_OS-$TARGET_ARCH-0.9.1.tar.xz
            tar -xvf zig.tar.xz > /dev/null
            rm zig.tar.xz
            ;;
        "zip")
            wget --quiet -O zig.zip https://ziglang.org/download/0.9.1/zig-$TARGET_OS-$TARGET_ARCH-0.9.1.zip
            unzip -q zig.zip
            mv 
            rm zig.zip
            ;;
    esac

}
