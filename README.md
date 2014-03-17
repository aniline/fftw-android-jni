fftw-android-jni
================

Makefiles for building fftw3 for android

1. Requires https://github.com/FFTW/fftw3
2. Clone this repository to jni directory at the top level build dir.

        cd fftw3
        git clone git@github.com:aniline/fftw-android-jni.git jni

3. Configure fftw3 so a config.h is available.
4. Then create symlinks using:

        cd jni
        make

5. Build using ndk-build

        $NDK_DIR/ndk-build
