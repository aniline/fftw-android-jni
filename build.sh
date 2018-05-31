#!/bin/bash

if test -f $(dirname $0)/.env; then
    source $(dirname $0)/.env
fi

echo "--------------------------------------------------------------------------------"
echo "Using the following settings:"
echo "NDK_ARCH=${NDK_ARCH}"
echo "APP_PLATFORM=${APP_PLATFORM}"
echo "LDFLAGS=${LDFLAGS}"
echo "CFLAGS=${CFLAGS}"
echo "TOOLCHAIN_PATH=${TOOLCHAIN_PATH}"
echo "_HOST=${_HOST}"
echo "APP_ABI=${APP_ABI}"
echo "NDK_TOOLCHAIN_VERSION=${NDK_TOOLCHAIN_VERSION}"
echo "--------------------------------------------------------------------------------"
echo "Hit Enter to try and build (runing ndk-build -e).."
read

pushd $(dirname $0)
${ANDROID_NDK_HOME}/ndk-build -e
popd
