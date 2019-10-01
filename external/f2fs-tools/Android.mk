LOCAL_PATH:= $(call my-dir)

# f2fs-tools depends on Linux kernel headers being in the system include path.
ifeq ($(HOST_OS),linux)

# The versions depend on $(LOCAL_PATH)/VERSION
version_CFLAGS := -DF2FS_MAJOR_VERSION=1 -DF2FS_MINOR_VERSION=8 -DF2FS_TOOLS_VERSION=\"1.8.0\" -DF2FS_TOOLS_DATE=\"2017-02-03\"
common_CFLAGS := -DWITH_ANDROID $(version_CFLAGS)
# Workaround for the <sys/types.h>/<sys/sysmacros.h> split, here now for
# bionic and coming later for glibc.
target_CFLAGS := $(common_CFLAGS) -include sys/sysmacros.h

# external/e2fsprogs/lib is needed for uuid/uuid.h
common_C_INCLUDES := $(LOCAL_PATH)/include external/e2fsprogs/lib/ external/selinux/libselinux/include system/core/libsparse/include bionic/libc/kernel/android/ system/core/libcutils/include

# Sources for formatting with pre-load files
sload_src_files := \
    sload/bit_operations.c \
    sload/checkpoint.c \
    sload/dir.c \
    sload/sload.c \
    sload/file.c \
    sload/index.c \
    sload/node.c \
    sload/segment.c \
    sload/xattr.c

#----------------------------------------------------------
include $(CLEAR_VARS)
LOCAL_MODULE := libf2fs_fmt
LOCAL_SRC_FILES := \
	lib/libf2fs.c \
	lib/libf2fs_zoned.c \
	lib/libf2fs_log.c \
	mkfs/f2fs_format.c \
	mkfs/f2fs_format_utils.c \

LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(target_CFLAGS)
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include $(LOCAL_PATH)/mkfs
include $(BUILD_STATIC_LIBRARY)

#----------------------------------------------------------
include $(CLEAR_VARS)
LOCAL_MODULE := libf2fs_fmt_host
LOCAL_SRC_FILES := \
	lib/libf2fs.c \
	lib/libf2fs_zoned.c \
	lib/libf2fs_log.c \
	mkfs/f2fs_format.c \
	mkfs/f2fs_format_utils.c

LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(target_CFLAGS)
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include $(LOCAL_PATH)/mkfs
include $(BUILD_HOST_STATIC_LIBRARY)

#----------------------------------------------------------
include $(CLEAR_VARS)
LOCAL_MODULE := libf2fs_sload_host
LOCAL_SRC_FILES := $(sload_src_files) \
    lib/libf2fs.c \
    lib/libf2fs_zoned.c \
    lib/libf2fs_log.c \
	mkfs/f2fs_format.c

LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(common_CFLAGS)
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include $(LOCAL_PATH)/mkfs $(LOCAL_PATH)/sload
include $(BUILD_HOST_STATIC_LIBRARY)

#----------------------------------------------------------
include $(CLEAR_VARS)
LOCAL_MODULE := libf2fs_fmt_host_dyn
LOCAL_SRC_FILES := \
	lib/libf2fs.c \
	lib/libf2fs_zoned.c \
	lib/libf2fs_io.c \
	mkfs/f2fs_format_utils.c \
	lib/libf2fs_log.c \
	mkfs/f2fs_format.c

LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(common_CFLAGS)
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/include $(LOCAL_PATH)/mkfs
LOCAL_STATIC_LIBRARIES := \
	libf2fs_ioutils_host \
	libext2_uuid \
	libsparse \
	libz
# LOCAL_LDLIBS := -ldl
include $(BUILD_HOST_SHARED_LIBRARY)

#----------------------------------------------------------
include $(CLEAR_VARS)
# The LOCAL_MODULE name is referenced by the code. Don't change it.
LOCAL_MODULE := mkfs.f2fs

# mkfs.f2fs is used in recovery: must be static.
LOCAL_FORCE_STATIC_EXECUTABLE := true

LOCAL_MODULE_PATH := $(TARGET_RECOVERY_ROOT_OUT)/sbin

LOCAL_SRC_FILES := \
	lib/libf2fs.c \
	lib/libf2fs_zoned.c \
	lib/libf2fs_io.c \
	lib/libf2fs_log.c \
	mkfs/f2fs_format.c \
	mkfs/f2fs_format_utils.c \
	mkfs/f2fs_format_main.c
LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(target_CFLAGS)
LOCAL_STATIC_LIBRARIES := libc libf2fs_fmt libext2_uuid libsparse libz
LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)

#----------------------------------------------------------
include $(CLEAR_VARS)
LOCAL_MODULE := resize.f2fs
LOCAL_SRC_FILES := \
	fsck/resize.c \
	fsck/defrag.c \
	fsck/dump.c \
	fsck/fsck.c \
	fsck/main.c \
	fsck/mount.c \
	fsck/node.c \
	fsck/segment.c \
	fsck/xattr.c \
	fsck/dir.c \
	fsck/sload.c \
	lib/libf2fs.c \
	lib/libf2fs_zoned.c \
	lib/libf2fs_io.c \
	lib/libf2fs_log.c

LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(target_CFLAGS)
LOCAL_STATIC_LIBRARIES := libf2fs_fmt
LOCAL_SHARED_LIBRARIES := libext2_uuid libsparse
LOCAL_SYSTEM_SHARED_LIBRARIES := libc
LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)

#----------------------------------------------------------
include $(CLEAR_VARS)
# The LOCAL_MODULE name is referenced by the code. Don't change it.
LOCAL_MODULE := resize.f2fs_s

# f2fs.resize is used in recovery: must be static.
LOCAL_FORCE_STATIC_EXECUTABLE := true

LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)/sbin

LOCAL_SRC_FILES := \
	fsck/resize.c \
	fsck/defrag.c \
	fsck/dump.c \
	fsck/fsck.c \
	fsck/main.c \
	fsck/mount.c \
	fsck/node.c \
	fsck/segment.c \
	fsck/xattr.c \
	fsck/dir.c \
	fsck/sload.c \
	lib/libf2fs.c \
	lib/libf2fs_zoned.c \
	lib/libf2fs_io.c \
	lib/libf2fs_log.c

LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(version_CFLAGS)
LOCAL_STATIC_LIBRARIES := libc libext2_uuid_static
LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)

#----------------------------------------------------------
include $(CLEAR_VARS)
# The LOCAL_MODULE name is referenced by the code. Don't change it.
LOCAL_MODULE := fsck.f2fs_s
LOCAL_SRC_FILES := \
	fsck/dump.c \
	fsck/fsck.c \
	fsck/main.c \
	fsck/mount.c \
	fsck/defrag.c \
	fsck/resize.c \
	fsck/node.c \
	fsck/segment.c \
	fsck/xattr.c \
	fsck/dir.c \
	fsck/sload.c \
	lib/libf2fs.c \
	lib/libf2fs_zoned.c \
	lib/libf2fs_io.c \
	lib/libf2fs_log.c

LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(version_CFLAGS)
LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_STATIC_LIBRARIES := libc libext2_uuid_static
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)/sbin
LOCAL_UNSTRIPPED_PATH := $(TARGET_ROOT_OUT_SBIN_UNSTRIPPED)
LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)

#----------------------------------------------------------
include $(CLEAR_VARS)
LOCAL_MODULE := fsck.f2fs
LOCAL_SRC_FILES := \
	fsck/dump.c \
	fsck/fsck.c \
	fsck/main.c \
	fsck/mount.c \
	fsck/defrag.c \
	fsck/resize.c \
	fsck/node.c \
	fsck/segment.c \
	fsck/xattr.c \
	fsck/dir.c \
	fsck/sload.c \
	lib/libf2fs.c \
	lib/libf2fs_zoned.c \
	lib/libf2fs_io.c \
	lib/libf2fs_log.c

LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(target_CFLAGS)

ifeq ($(CONFIG_BG_FSCK),true)
LOCAL_C_INCLUDES += system/core/fs_mgr/include/
LOCAL_CFLAGS += -DBG_FSCK
endif

LOCAL_SHARED_LIBRARIES := libext2_uuid libsparse
LOCAL_SYSTEM_SHARED_LIBRARIES := libc
LOCAL_MODULE_TAGS := optional
include $(BUILD_EXECUTABLE)

#----------------------------------------------------------
include $(CLEAR_VARS)
LOCAL_MODULE := fsck.f2fs
LOCAL_SRC_FILES := \
	fsck/dump.c \
	fsck/fsck.c \
	fsck/main.c \
	fsck/mount.c \
	fsck/defrag.c \
	fsck/resize.c \
	fsck/node.c \
	fsck/segment.c \
	fsck/xattr.c \
	fsck/dir.c \
	fsck/sload.c \
	lib/libf2fs.c \
	lib/libf2fs_zoned.c \
	lib/libf2fs_io.c \
	lib/libf2fs_log.c

LOCAL_C_INCLUDES := $(common_C_INCLUDES)
LOCAL_CFLAGS := $(version_CFLAGS)
LOCAL_SHARED_LIBRARIES := libsparse
LOCAL_HOST_SHARED_LIBRARIES :=  libext2_uuid
include $(BUILD_HOST_EXECUTABLE)

endif
