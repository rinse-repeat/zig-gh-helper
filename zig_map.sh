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
            ZIG_OS=linux
            ZIG_EXT=tar.xz
            ;;
        *"windows"*)
            ZIG_OS=windows
            ZIG_EXT=zip
            ;;
        *"macos"*)
            ZIG_OS=macos
            ZIG_EXT=tar.xz
            ;;
        *"darwin"*)
            ZIG_OS=macos
            ZIG_EXT=tar.xz
            ;;
        *)
            echo "zig_map.sh ERROR No ZIG_OS handler for TARGET=$TARGET"
            exit 255
            ;;
    esac

    #################
    # Supported Arch
    case $TARGET in

        *"x86_64"*)
            export ZIG_ARCH=x86_64
            ;;
        *"aarch64"*)
            export ZIG_ARCH=aarch64
            ;;
        *"arm"*)
            export ZIG_ARCH=armv7a
            ;;
        *)
            echo "zig_map.sh ERROR No ZIG_ARCH handler for TARGET=$TARGET"
            exit 255
            ;;
        
    esac

    echo "ZIG_EXT=$ZIG_EXT" | tee -a $ENV_FILE
    echo "ZIG_OS=$ZIG_OS" | tee -a $ENV_FILE
    echo "ZIG_ARCH=$ZIG_ARCH" | tee -a $ENV_FILE

    # TODO: Only from current path? come w/ something better.
    export ZIG_HOME=$PWD/zig/zig-$ZIG_OS-$ZIG_ARCH-$ZIG_VERSION
    echo "ZIG_HOME=$ZIG_HOME" | tee -a $ENV_FILE

}

zig_install_nix() {
    export RUNNER_OS="$1"

    if [[ -d "$ZIG_HOME" ]]
    then
        echo Found Cached ZIG - Skipping install
        return
    fi

    echo "Installing ZIG $ZIG_VERSION Arch-$ZIG_ARCH OS-$ZIG_OS"

    # TODO: DRY introduce ZIG_ROOT ?
    mkdir -p zig
    cd zig

    export ZIG_FILE="zig.$ZIG_EXT"
    
    case $ZIG_EXT in
        "tar.xz")
            wget --quiet -O zig.tar.xz https://ziglang.org/download/0.9.1/zig-$ZIG_OS-$ZIG_ARCH-$ZIG_VERSION.tar.xz
            tar -xvf zig.tar.xz > /dev/null 2>&1
            ;;
        "zip")
            wget --quiet -O zig.zip https://ziglang.org/download/0.9.1/zig-$ZIG_OS-$ZIG_ARCH-$ZIG_VERSION.zip
            unzip -q zig.zip
            ;;
        *)
            echo "zig_map ERROR: No handler for ZIG_EXT=$ZIG_EXT"
            exit 255
            ;;
    esac

    export
    
    export SHA_OUT=""
    case $RUNNER_OS in
        "mac"*)
            export SHA_OUT=`shasum -a 256 zig.$ZIG_EXT | cut -f 1 -d " "`
            ;;
        *)
            export SHA_OUT=`sha256sum zig.$ZIG_EXT | cut -f 1 -d " "`
            ;;      
    esac
    
    if [[ "$ZIG_CHECKSUM" != "$SHA_OUT" ]]
    then
        echo "Downloaded ZIG checksums mismatch!"
        echo "- Downloaded file $ZIG_FILE checksum: $SHA_OUT"
        echo "- Expected checksum: $ZIG_CHECKSUM"
        exit 10
    fi
    
    rm zig.$ZIG_EXT
}
