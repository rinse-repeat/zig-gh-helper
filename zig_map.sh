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
            echo "TARGET_OS=linux" | tee -a $ENV_FILE
            ;;
        *"windows"*)
            echo "TARGET_OS=windows" | tee -a $ENV_FILE            
            ;;
        *"macos"*)
            echo "TARGET_OS=macos" | tee -a $ENV_FILE            
            ;;
        
    esac

    #################
    # Supported Arch
    case $TARGET in

        *"x86_64"*)
            echo "TARGETT_ARCH=x86_64" | tee -a $ENV_FILE
            ;;
        *"aarch64"*)
            echo "TARGETT_ARCH=aarch64" | tee -a $ENV_FILE
            ;;
        *"arm"*)
            echo "TARGETT_ARCH=armv7a" | tee -a $ENV_FILE            
            ;;
        
    esac
}

install_target() {

    mkdir zig
    cd zig
    wget -O zig.tar.xz https://ziglang.org/download/0.9.1/zig-$TARGET_OS-$TARGET_ARCH-0.9.1.tar.xz
    tar --strip-components=1 -xvf zig.tar.xz
    rm zig.tar.xz

}
