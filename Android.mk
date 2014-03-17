APP_ABI := armeabi-v7a

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE    := fftw3
include $(LOCAL_PATH)/src.mk
include $(LOCAL_PATH)/inc.mk

include $(BUILD_SHARED_LIBRARY)

# libbench2

include $(CLEAR_VARS)

LOCAL_MODULE    := bench2
include $(LOCAL_PATH)/libbench2_src.mk
include $(LOCAL_PATH)/inc.mk

include $(BUILD_STATIC_LIBRARY)

# Threads lib

include $(CLEAR_VARS)

LOCAL_MODULE    := fftw_threads
include $(LOCAL_PATH)/threads_src.mk
include $(LOCAL_PATH)/inc.mk

include $(BUILD_STATIC_LIBRARY)

# Test program.

include $(CLEAR_VARS)

LOCAL_MODULE    := fftw_bench
LOCAL_SHARED_LIBRARIES := fftw3
LOCAL_STATIC_LIBRARIES := bench2 fftw_threads
include $(LOCAL_PATH)/test_src.mk
include $(LOCAL_PATH)/inc.mk

include $(BUILD_EXECUTABLE)
