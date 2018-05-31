#!/bin/bash
#
# Try to configure fftw3 with android NDK build tools.
#

if test x"${NDK_DIR}" != x; then
    echo "$0: NDK_DIR set to \"${NDK_DIR}\", using it."
    ANDROID_NDK_HOME=${NDK_DIR}
elif test x"${ANDROID_NDK_HOME}" == x; then
    echo "$0: Please ANDROID_NDK_HOME or NDK_DIR to your NDK root directory."
    exit 1;
fi

if test x"${APP_PLATFORM}" == x; then
    APP_PLATFORM=android-14
    echo "APP_PLATFORM not set. Using APP_PLATFORM=${APP_PLATFORM}"
fi

if test x"${NDK_ARCH}" == x; then
    echo "NDK_ARCH not set, Assuming arch-arm (32bit arm)"
    NDK_ARCH=arch-arm
fi

case "${NDK_ARCH}" in
     arch-arm)
         _HOST=arm-linux-android
         APP_ABI=armeabi-v7a
         ;;
     arch-arm64)
         _HOST=aarch64-linux-android
         APP_ABI=arm64-v8a
         ;;
esac

# Search for a gcc that matches the arch pic the last one in sorted order.
CC_SELECTED=$(find ${ANDROID_NDK_HOME}/ -name "${_HOST}*-gcc"| sort | tail -1)

if test x"${CC_SELECTED}" == x; then
    echo "Could not find C compiler in ANDROID_NDK_HOME (${ANDROID_NDK_HOME})."
    exit;
fi

TOOLCHAIN_PATH=$(dirname ${CC_SELECTED})

# _HOST has the platform identifier string for use by configure, like i686-linux or armv7-android etc.
_HOST=$(basename ${CC_SELECTED} "-gcc")

# Compiler flags for use by configure conftests.
LDFLAGS="-L${ANDROID_NDK_HOME}/platforms/${APP_PLATFORM}/${NDK_ARCH}/usr/lib/ --sysroot=${ANDROID_NDK_HOME}/platforms/${APP_PLATFORM}/${NDK_ARCH}/usr/"

# Newer NDK have common sysroot.
if test -d "${ANDROID_NDK_HOME}/sysroot"; then
    CFLAGS="-I${ANDROID_NDK_HOME}/sysroot/usr/include/ -I${ANDROID_NDK_HOME}/sysroot/usr/include/${_HOST}"
else
    CFLAGS="-I${ANDROID_NDK_HOME}/platforms/${APP_PLATFORM}/${NDK_ARCH}/usr/include/ --sysroot=${ANDROID_NDK_HOME}/platforms/${APP_PLATFORM}/${NDK_ARCH}/usr/"
fi

# Save the settings for use by build.sh
cat >$(dirname $0)/.env <<EOF
export ANDROID_NDK_HOME="${ANDROID_NDK_HOME}"
export CFLAGS="${CFLAGS}"
export LDFLAGS="${LDFLAGS}"
export NDK_ARCH="${NDK_ARCH}"
export APP_PLATFORM="${APP_PLATFORM}"
export TOOLCHAIN_PATH="${TOOLCHAIN_PATH}"
export _HOST="${_HOST}"
export NDK_TOOLCHAIN_VERSION=4.9
export APP_ABI=${APP_ABI}
export CC_SELECTED=${CC_SELECTED}
EOF

source $(dirname $0)/.env

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
echo "Hit Enter to try and configure. (Ctrl-C to bail out)"
read

# Configure
pushd $(dirname $0)/..
PATH=$PATH:${TOOLCHAIN_PATH} CC=${_HOST}-gcc ./configure --host=${_HOST} --enable-threads $*
popd

# After configuring make a bunch of symlinks.
make -C $(dirname $0)

echo "Hit Enter to try and run ndk-build. (Ctrl-C to bail out)"
read

# Launch build. -e is require for the build to use the environment variable
# that override make variables.
pushd $(dirname $0)
${ANDROID_NDK_HOME}/ndk-build -e
popd
