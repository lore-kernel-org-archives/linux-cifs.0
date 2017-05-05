From: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 0/2] cifs: CIFS_ENUMERATE_SNAPSHOTS fixes
Date: Fri, 5 May 2017 15:47:55 +0200
Message-ID: <20170505154755.56d64708@suse.de>
References: <20170503153909.5783-1-ddiss@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170503153909.5783-1-ddiss-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed,  3 May 2017 17:39:07 +0200, David Disseldorp wrote:

> A couple of one line fixes for the new CIFS_ENUMERATE_SNAPSHOTS
> functionality.
> 
>  fs/cifs/ioctl.c   | 2 ++
>  fs/cifs/smb2ops.c | 1 +
>  2 files changed, 3 insertions(+)

FWIW, below is the xfstests based reproducer that I used to trip the
CIFS_ENUMERATE_SNAPSHOTS and CIFS_IOC_GET_MNT_INFO bugs. It can be
run against file and dir paths on a cifs.ko mount. 

As discussed with Steve, it'd probably make sense to add some sort of
xfs_io like helper to cifs-utils, to avoid polluting xfstests with
these things (cloner could also go).

Cheers, David

>From 4df1ea0e254b9b394a49606f82717302bb7fadbc Mon Sep 17 00:00:00 2001
From: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Date: Fri, 5 May 2017 13:22:39 +0200
Subject: [PATCH] src/shot: cifs snapshot ioctl helper

Signed-off-by: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
---
 src/Makefile |   2 +-
 src/shot.c   | 188 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 189 insertions(+), 1 deletion(-)
 create mode 100644 src/shot.c

diff --git a/src/Makefile b/src/Makefile
index f1338ca9..6378e076 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -22,7 +22,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec cloner \
 	renameat2 t_getcwd e4compact test-nextquota punch-alternating \
 	attr-list-by-handle-cursor-test listxattr dio-interleaved t_dir_type \
-	dio-invalidate-cache stat_test
+	dio-invalidate-cache stat_test shot
 
 SUBDIRS =
 
diff --git a/src/shot.c b/src/shot.c
new file mode 100644
index 00000000..f668cd62
--- /dev/null
+++ b/src/shot.c
@@ -0,0 +1,188 @@
+/*
+ *  cifs.ko snapshot access utility
+ *
+ *  Copyright (C) 2017 SUSE Linux GmbH. All Rights Reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/ioctl.h>
+#include <sys/vfs.h>
+#include <stdint.h>
+#include <stdbool.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <errno.h>
+#include <linux/magic.h>
+#include <linux/limits.h>
+#ifdef HAVE_CIFS_IOCTL_H
+#include <cifs/ioctl.h>
+#else
+
+struct smb_snapshot_array {
+	uint32_t   number_of_snapshots;
+	uint32_t   number_of_snapshots_returned;
+	uint32_t   snapshot_array_size;
+	/*      snapshots[]; */
+};
+
+struct smb_mnt_fs_info {
+        uint32_t   version; /* 0001 */
+        uint16_t   protocol_id;
+        uint16_t   tcon_flags;
+        uint32_t   vol_serial_number;
+        uint32_t   vol_create_time;
+        uint32_t   share_caps;
+        uint32_t   share_flags;
+        uint32_t   sector_flags;
+        uint32_t   optimal_sector_size;
+        uint32_t   max_bytes_chunk;
+        uint32_t   fs_attributes;
+        uint32_t   max_path_component;
+        uint32_t   device_type;
+        uint32_t   device_characteristics;
+        uint32_t   maximal_access;
+        uint64_t   cifs_posix_caps;
+};
+
+#define CIFS_IOCTL_MAGIC 0xCF
+#define CIFS_IOC_GET_MNT_INFO _IOR(CIFS_IOCTL_MAGIC, 5, struct smb_mnt_fs_info)
+#define CIFS_ENUMERATE_SNAPSHOTS _IOR(CIFS_IOCTL_MAGIC, 6, struct smb_snapshot_array)
+
+#endif
+
+#ifndef CIFS_MAGIC_NUMBER
+#define CIFS_MAGIC_NUMBER    0xFE534D42
+#endif
+
+#define SNAPS_MAX 10
+
+static void
+usage(char *name, const char *msg)
+{
+	printf("Fatal: %s\n"
+	       "Usage:\n"
+	       "%s [options] <path>\n",
+	       msg, name);
+	_exit(1);
+}
+
+static int
+shot_enum_path_cifs(int enum_fd)
+{
+	struct {
+		struct smb_snapshot_array hdr;
+		char snap_name[SNAPS_MAX][PATH_MAX];
+	} snaps;
+	struct smb_mnt_fs_info mnt_info;
+	int ret;
+
+	memset(&mnt_info, 0, sizeof(mnt_info));
+	ret = ioctl(enum_fd, CIFS_IOC_GET_MNT_INFO, &mnt_info);
+	if (ret != 0) {
+		ret = errno;
+		printf("failed to get mount info: %s\n", strerror(ret));
+		return ret;
+	}
+
+	memset(&snaps, 0, sizeof(snaps));
+	ret = ioctl(enum_fd, CIFS_ENUMERATE_SNAPSHOTS, &snaps);
+	if (ret != 0) {
+		ret = errno;
+		printf("failed to enum snaps: %s\n", strerror(ret));
+	}
+	return ret;
+}
+
+static int
+shot_check_fs_support(int enum_fd)
+{
+	int ret;
+	struct statfs sfs;
+
+	ret = fstatfs(enum_fd, &sfs);
+	if (ret != 0) {
+		printf("failed to stat source FS\n");
+		return errno;
+	}
+
+	if (sfs.f_type != CIFS_MAGIC_NUMBER) {
+		printf("unsupported source FS 0x%x\n",
+		       (unsigned int)sfs.f_type);
+		return ENOTSUP;
+	}
+
+	return 0;
+}
+
+int
+main(int argc, char **argv)
+{
+	char *enum_path;
+	int enum_fd;
+	int ret;
+	int opt;
+
+	while ((opt = getopt(argc, argv, "")) != -1) {
+		switch (opt) {
+		default:
+			usage(argv[0], "invalid argument");
+		}
+	}
+
+	/* should be exactly one args left */
+	if (optind != argc - 1)
+		usage(argv[0], "missing mandatory path");
+
+	enum_path = (char *)strdup(argv[optind++]);
+	if (enum_path == NULL) {
+		ret = ENOMEM;
+		printf("no memory\n");
+		goto err_out;
+	}
+
+	enum_fd = open(enum_path, O_RDONLY);
+	if (enum_fd == -1) {
+		ret = errno;
+		printf("failed to open %s: %s\n", enum_path, strerror(errno));
+		goto err_path_free;
+	}
+
+	ret = shot_check_fs_support(enum_fd);
+	if (ret != 0) {
+		goto err_fd_close;
+	}
+
+	ret = shot_enum_path_cifs(enum_fd);
+	if (ret != 0) {
+		goto err_fd_close;
+	}
+
+	ret = 0;
+err_fd_close:
+	if (close(enum_fd)) {
+		ret |= errno;
+		printf("failed to close fd: %s\n", strerror(errno));
+	}
+err_path_free:
+	free(enum_path);
+err_out:
+	return ret;
+}
-- 
2.12.0
