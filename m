From: David Disseldorp <ddiss@suse.de>
Subject: [PATCH 2/2] src/cloner: add CIFS_IOC_COPYCHUNK_FILE support
Date: Wed, 11 Jun 2014 16:05:44 +0200
Message-ID: <1402495544-12865-3-git-send-email-ddiss@suse.de>
References: <1402495544-12865-1-git-send-email-ddiss@suse.de>
Cc: linux-cifs@vger.kernel.org, linux-btrfs@vger.kernel.org,
	David Disseldorp <ddiss@suse.de>
To: fstests@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1402495544-12865-1-git-send-email-ddiss@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

cifs.ko supports server-side copy offloads via CIFS_IOC_COPYCHUNK_FILE.
In handling the ioctl, the request is split into a series of
SMB2 FSCTL_SRV_COPYCHUNK wire requests, which may be handled by the SMB
server as a local read/write, or COW clone as is the case for Samba with
vfs_btrfs.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 configure.ac |  1 +
 src/cloner.c | 78 +++++++++++++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 68 insertions(+), 11 deletions(-)

diff --git a/configure.ac b/configure.ac
index 53459d8..d038f95 100644
--- a/configure.ac
+++ b/configure.ac
@@ -31,6 +31,7 @@ AC_HEADER_STDC
 			sys/fs/xfs_itable.h	\
 			xfs/platform_defs.h	\
 			btrfs/ioctl.h		\
+			cifs/ioctl.h		\
     ])
 
 AC_CHECK_HEADERS([xfs/xfs_log_format.h],,,[#include <xfs/libxfs.h>])
diff --git a/src/cloner.c b/src/cloner.c
index 6fb40fa..18c44b9 100644
--- a/src/cloner.c
+++ b/src/cloner.c
@@ -1,6 +1,5 @@
 /*
- *  Tiny program to perform file (range) clones using raw Btrfs ioctls.
- *  It should only be needed until btrfs-progs has an xfs_io equivalent.
+ *  Tiny program to perform file (range) clones using raw Btrfs and CIFS ioctls.
  *
  *  Copyright (C) 2014 SUSE Linux Products GmbH. All Rights Reserved.
  *
@@ -49,9 +48,21 @@ struct btrfs_ioctl_clone_range_args {
 				   struct btrfs_ioctl_clone_range_args)
 #endif
 
+#ifdef HAVE_CIFS_IOCTL_H
+#include <cifs/ioctl.h>
+#else
+
+#define CIFS_IOCTL_MAGIC 0xCF
+#define CIFS_IOC_COPYCHUNK_FILE _IOW(CIFS_IOCTL_MAGIC, 3, int)
+
+#endif
+
 #ifndef BTRFS_SUPER_MAGIC
 #define BTRFS_SUPER_MAGIC    0x9123683E
 #endif
+#ifndef CIFS_MAGIC_NUMBER
+#define CIFS_MAGIC_NUMBER    0xFE534D42
+#endif
 
 static void
 usage(char *name, const char *msg)
@@ -59,17 +70,19 @@ usage(char *name, const char *msg)
 	printf("Fatal: %s\n"
 	       "Usage:\n"
 	       "%s [options] <src_file> <dest_file>\n"
-	       "\tA full file clone (reflink) is performed by default, "
-	       "unless any of the following are specified:\n"
+	       "\tA full file clone is performed by default, "
+	       "unless any of the following are specified (Btrfs only):\n"
 	       "\t-s <offset>:	source file offset (default = 0)\n"
 	       "\t-d <offset>:	destination file offset (default = 0)\n"
-	       "\t-l <length>:	length of clone (default = 0)\n",
+	       "\t-l <length>:	length of clone (default = 0)\n\n"
+	       "\tBoth Btrfs and CIFS are supported. On Btrfs, a COW clone "
+	       "is attempted. On CIFS, a server-side copy is requested.\n",
 	       msg, name);
 	_exit(1);
 }
 
 static int
-clone_file(int src_fd, int dst_fd)
+clone_file_btrfs(int src_fd, int dst_fd)
 {
 	int ret = ioctl(dst_fd, BTRFS_IOC_CLONE, src_fd);
 	if (ret != 0)
@@ -78,8 +91,33 @@ clone_file(int src_fd, int dst_fd)
 }
 
 static int
-clone_file_range(int src_fd, int dst_fd, uint64_t src_off, uint64_t dst_off,
-		 uint64_t len)
+clone_file_cifs(int src_fd, int dst_fd)
+{
+	int ret = ioctl(dst_fd, CIFS_IOC_COPYCHUNK_FILE, src_fd);
+	if (ret != 0)
+		ret = errno;
+	return ret;
+}
+
+static int
+clone_file(unsigned int fs_type, int src_fd, int dst_fd)
+{
+	switch (fs_type) {
+	case BTRFS_SUPER_MAGIC:
+		return clone_file_btrfs(src_fd, dst_fd);
+		break;
+	case CIFS_MAGIC_NUMBER:
+		return clone_file_cifs(src_fd, dst_fd);
+		break;
+	default:
+		return ENOTSUP;
+		break;
+	}
+}
+
+static int
+clone_file_range_btrfs(int src_fd, int dst_fd, uint64_t src_off,
+		       uint64_t dst_off, uint64_t len)
 {
 	struct btrfs_ioctl_clone_range_args cr_args;
 	int ret;
@@ -96,6 +134,22 @@ clone_file_range(int src_fd, int dst_fd, uint64_t src_off, uint64_t dst_off,
 }
 
 static int
+clone_file_range(unsigned int fs_type, int src_fd, int dst_fd, uint64_t src_off,
+		 uint64_t dst_off, uint64_t len)
+{
+	switch (fs_type) {
+	case BTRFS_SUPER_MAGIC:
+		return clone_file_range_btrfs(src_fd, dst_fd, src_off, dst_off,
+					      len);
+		break;
+	case CIFS_MAGIC_NUMBER:	/* only supports full file server-side copies */
+	default:
+		return ENOTSUP;
+		break;
+	}
+}
+
+static int
 cloner_check_fs_support(int src_fd, int dest_fd, unsigned int *fs_type)
 {
 	int ret;
@@ -107,7 +161,8 @@ cloner_check_fs_support(int src_fd, int dest_fd, unsigned int *fs_type)
 		return errno;
 	}
 
-	if (sfs.f_type != BTRFS_SUPER_MAGIC) {
+	if ((sfs.f_type != BTRFS_SUPER_MAGIC)
+	 && (sfs.f_type != CIFS_MAGIC_NUMBER)) {
 		printf("unsupported source FS 0x%x\n",
 		       (unsigned int)sfs.f_type);
 		return ENOTSUP;
@@ -210,9 +265,10 @@ main(int argc, char **argv)
 	}
 
 	if (full_file) {
-		ret = clone_file(src_fd, dst_fd);
+		ret = clone_file(fs_type, src_fd, dst_fd);
 	} else {
-		ret = clone_file_range(src_fd, dst_fd, src_off, dst_off, len);
+		ret = clone_file_range(fs_type, src_fd, dst_fd, src_off,
+				       dst_off, len);
 	}
 	if (ret != 0) {
 		printf("clone failed: %s\n", strerror(ret));
-- 
1.8.4.5

