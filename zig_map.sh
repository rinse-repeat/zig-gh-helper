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
            ;;
        *"windows"*)
            TARGET_OS=windows
            ;;
        *"macos"*)
            TARGET_OS=macos
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

    echo "TARGET_OS=$TARGET_oS" | tee -a $ENV_FILE
    echo "TARGET_ARCH=$TARGET_ARCH" | tee -a $ENV_FILE
}

zig_install() {

    mkdir zig
    cd zig
    wget -O zig.tar.xz https://ziglang.org/download/0.9.1/zig-$TARGET_OS-$TARGET_ARCH-0.9.1.tar.xz
    tar --strip-components=1 -xvf zig.tar.xz
    rm zig.tar.xz

}
