#ifndef __F2FS_LOG_H__
#define __F2FS_LOG_H__

/*
 * for now, only fsck records log. If you want to add slog/klog to other
 * components, you should:
 *   1. add new log type and tag to log_type and log_tag;
 *   2. add case in init_log_info();
 *   3. add slog_init/slog_exit to corresponding main().
 */
enum log_type {
	LOG_TYP_F2FS_TOOLS,
	LOG_TYP_FSCK,
	LOG_TYP_DUMP,
	LOG_TYP_DEFRAG,
	LOG_TYP_MKFS,
	LOG_TYP_MAX,
};

extern char *log_tag[];
struct log_info {
	enum log_type type;
	int slog_fd;
	int klog_fd;
	int dsm_fd;
	int klog_level;
	char *slog_file;
	char *slog_file_bak;
	char *log_dir;
};
extern struct log_info log_i;

#ifdef BG_FSCK
#include <fs_mgr_fsck.h>
int cp_bg_fsck_result();
void rm_bg_fsck_result();
int is_in_bg_fsck();
void set_bg_fsck_mode();
int need_fg_fsck();
#else
static inline int cp_bg_fsck_result()
{
	return 0;
}
static inline void rm_bg_fsck_result()
{
	return;
}
static inline int is_in_bg_fsck()
{
	return 0;
}
static inline void set_bg_fsck_mode()
{
	return;
}
static inline int need_fg_fsck()
{
	return 1;
}
#endif

#ifdef HAVE_LOG

int  slog_init(int log_type);
void slog_exit(void);
int  slog_write(const char *fmt, ...);
void klog_write(int level, const char* fmt, ...);
int  dmd_report(const char *client, int dmd_err);
void dmd_insert_error(int type, int err, const char *func, int line);

#define KLOG_ERROR_LEVEL	3
#define KLOG_INFO_LEVEL		6
#define KLOG_DEFAULT_LEVEL	6
#define LOG_BUF_MAX         512

#define KLOGE(fmt, ...)					\
	klog_write(KLOG_ERROR_LEVEL, "<3> %s: " fmt,	\
		   log_tag[log_i.type], ##__VA_ARGS__)
#define KLOGI(fmt, ...)					\
	klog_write(KLOG_INFO_LEVEL, "<6> %s: " fmt,	\
		   log_tag[log_i.type], ##__VA_ARGS__)
#define SLOG(x...) slog_write(x)

/* dmd report the error number */
#define DMD_ADD_ERROR(type, err) \
		dmd_insert_error(type, err, __func__, __LINE__);

/*
 * TEMP_FAILURE_RETRY is defined by some, but not all, versions of
 * <unistd.h>. (Alas, it is not as standard as we'd hoped!) So, if it's
 * not already defined, then define it here.
 */
/* Copied from system/core/include/cutils/fs.h */
#ifndef TEMP_FAILURE_RETRY
/* Used to retry syscalls that can return EINTR. */
#define TEMP_FAILURE_RETRY(exp) ({             \
       typeof (exp) _rc;                       \
       do {                                    \
               _rc = (exp);                    \
        } while (_rc == -1 && errno == EINTR); \
_rc; })
#endif

#else  /* HAVE_LOG */
static int inline slog_init(int log_type)
{
	return 0;
}

static void inline slog_exit(void)
{
	return;
}

static int inline slog_write(const char *fmt, ...)
{
	return 0;
}

static int inline dmd_report(const char *client, int dmd_err)
{
	return 0;
}

static void dmd_insert_error(int type, int err, const char *func, int line)
{
	return;
}
#endif /* !HAVE_LOG */

#endif
