LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE_TAGS := optional
LOCAL_CFLAGS := -DLOG_TAG=\"STM401\"
LOCAL_SRC_FILES:= stm401.cpp
LOCAL_MODULE:= stm401
LOCAL_MODULE_OWNER := moto
LOCAL_SHARED_LIBRARIES := libcutils libc
include $(BUILD_EXECUTABLE)