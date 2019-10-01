LOCAL_PATH:= $(call my-dir)

# copy smbd to /system/bin/
# ======================================
include $(CLEAR_VARS)
LOCAL_MODULE := smbd
LOCAL_SRC_FILES := bin/smbd
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_TAGS := optional
LOCAL_INIT_RC := samba.rc
include $(BUILD_PREBUILT)

# copy nmbd to /system/bin/
# ======================================
include $(CLEAR_VARS)
LOCAL_MODULE := nmbd
LOCAL_SRC_FILES := bin/nmbd
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_TAGS := optional
include $(BUILD_PREBUILT)

# copy smbpasswd to /system/bin/
# ======================================
include $(CLEAR_VARS)
LOCAL_MODULE := smbpasswd
LOCAL_SRC_FILES := bin/smbpasswd
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_TAGS := optional
include $(BUILD_PREBUILT)
