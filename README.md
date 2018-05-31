# FFTW build with android NDK

## Needs

* Android NDK on Linux (I've not gotten around to trying it on Mac or Windows).
* python2
* make
* bash shell

## Steps

Makefiles for building fftw3 for android

1. Download the fftw3 source from http://fftw.org/download.html (The
   github [repo](https://github.com/FFTW/fftw3) is not 'ready-to-use' they advise against using it) and
   untar it somewhere convenient.
1. Assuming the fftw3 sources are under fftw-3.3.8, change to the
   directory and clone this repo under the name `jni`.

        cd fftw-3.3.8
        git clone git@github.com:aniline/fftw-android-jni.git jni

1. Set your Android `ANDROID_NDK_HOME` (or `NDK_DIR`) path to your NDK root directory. for e.g:

        export ANDROID_NDK_HOME=/home/myhome/android-ndk-r16e

1. Configure fftw3 so a correct config.h is available.

   The script `jni/configure.sh` could be used for this. It requires the environment variables:

   | Variable                        | Purpose                                     |
   | ------------------------------- | ------------------------------------------- |
   | `ANDROID_NDK_HOME` or `NDK_DIR` | NDK root directory                          |
   | `APP_PLATFORM`                  | SDK level (`android-14`, `android-21` etc.) |
   | `NDK_ARCH`                      | `arch-arm` (32bit) or `arch-arm64`          |

   So one could run configure for arm64 like, this :

        APP_PLATFORM=android-21 NDK_ARCH=arch-arm64 bash jni/configure.sh

   or arm (32 bit) like, say, this:

        APP_PLATFORM=android-21 NDK_ARCH=arch-arm bash jni/configure.sh

1. The configure script also launches the compile at the end. You
could break it and run `jni/build.sh` to just build it later. The
variables set by the configure.sh are saved to `jni/.env`. So just
running `bash jni/build.sh` should build with the previously
configured setting.

## Gotchas

* Reasonably new NDK has clang set as the default toolchain. We override and set it
  to gcc-4.9 (using `NDK_TOOLCHAIN_VERSION=4.9`).
* There is a `find` command in the configure script which tries to
  find out the gcc compilers available in the NDK. Its ugly.
* Directly `ndk-build` set would build for all the architectures on
  that particular SDK level (say 21). But the configure step (using
  the configure.sh script) would configure fftw for only one
  platform. So the resulting builds for architectures other than the
  one configured for might be trouble. Some more work is needed to
  automagically configure for all architecures on a given level.
