From: David Disseldorp <ddiss@suse.de>
Subject: [PATCH 1/2] src/cloner: check filesystem type
Date: Wed, 11 Jun 2014 16:05:43 +0200
Message-ID: <1402495544-12865-2-git-send-email-ddiss@suse.de>
References: <1402495544-12865-1-git-send-email-ddiss@suse.de>
Cc: linux-cifs@vger.kernel.org, linux-btrfs@vger.kernel.org,
	David Disseldorp <ddiss@suse.de>
To: fstests@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1402495544-12865-1-git-send-email-ddiss@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Limit clone requests to Btrfs only for the moment.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 src/cloner.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/src/cloner.c b/src/cloner.c
index ccc2354..6fb40fa 100644
--- a/src/cloner.c
+++ b/src/cloner.c
@@ -22,6 +22,7 @@
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/ioctl.h>
+#include <sys/vfs.h>
 #include <stdint.h>
 #include <stdbool.h>
 #include <fcntl.h>
@@ -30,6 +31,7 @@
 #include <stdio.h>
 #include <string.h>
 #include <errno.h>
+#include <linux/magic.h>
 #ifdef HAVE_BTRFS_IOCTL_H
 #include <btrfs/ioctl.h>
 #else
@@ -47,6 +49,10 @@ struct btrfs_ioctl_clone_range_args {
 				   struct btrfs_ioctl_clone_range_args)
 #endif
 
+#ifndef BTRFS_SUPER_MAGIC
+#define BTRFS_SUPER_MAGIC    0x9123683E
+#endif
+
 static void
 usage(char *name, const char *msg)
 {
@@ -89,6 +95,41 @@ clone_file_range(int src_fd, int dst_fd, uint64_t src_off, uint64_t dst_off,
 	return ret;
 }
 
+static int
+cloner_check_fs_support(int src_fd, int dest_fd, unsigned int *fs_type)
+{
+	int ret;
+	struct statfs sfs;
+
+	ret = fstatfs(src_fd, &sfs);
+	if (ret != 0) {
+		printf("failed to stat source FS\n");
+		return errno;
+	}
+
+	if (sfs.f_type != BTRFS_SUPER_MAGIC) {
+		printf("unsupported source FS 0x%x\n",
+		       (unsigned int)sfs.f_type);
+		return ENOTSUP;
+	}
+
+	*fs_type = (unsigned int)sfs.f_type;
+
+	ret = fstatfs(dest_fd, &sfs);
+	if (ret != 0) {
+		printf("failed to stat destination FS\n");
+		return errno;
+	}
+
+	if (sfs.f_type != *fs_type) {
+		printf("dest FS type 0x%x does not match source 0x%x\n",
+		       (unsigned int)sfs.f_type, *fs_type);
+		return ENOTSUP;
+	}
+
+	return 0;
+}
+
 int
 main(int argc, char **argv)
 {
@@ -102,6 +143,7 @@ main(int argc, char **argv)
 	int dst_fd;
 	int ret;
 	int opt;
+	unsigned int fs_type = 0;
 
 	while ((opt = getopt(argc, argv, "s:d:l:")) != -1) {
 		char *sval_end;
@@ -162,6 +204,11 @@ main(int argc, char **argv)
 		goto err_src_close;
 	}
 
+	ret = cloner_check_fs_support(src_fd, dst_fd, &fs_type);
+	if (ret != 0) {
+		goto err_dst_close;
+	}
+
 	if (full_file) {
 		ret = clone_file(src_fd, dst_fd);
 	} else {
-- 
1.8.4.5

