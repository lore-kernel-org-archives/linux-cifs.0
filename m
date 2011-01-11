From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] cifs: add mount option to handle stat() failures by 32-bit
 apps
Date: Tue, 11 Jan 2011 16:10:37 +0530
Message-ID: <4D2C33A5.9000801@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

..compiled without LFS support, but running on 64-bit kernel.

Currently, when a broken (compiled without LFS support) 32-bit application on
a 64-bit kernel tries to do a stat(), it fails with -EOVERFLOW error. This
problem happens because the 32-bit application is unable to fit the huge
64-bit inode number in its target structure field.

This problem could be reproduced by mounting a filesystem that supports 64-bit
inodes (in my case it is a Windows 2003 Server with NTFS) and using the below
reproducer to stat files/dir in the mounted filesystem.

Reproducer
----------

#include <sys/types.h>
#include <sys/stat.h>
#include <time.h>
#include <stdio.h>
#include <stdlib.h>

int
main(int argc, char *argv[])
{
        struct stat sb;
        if (argc != 2) {
                fprintf(stderr, "Usage: %s <pathname>\n", argv[0]);
                exit(EXIT_FAILURE);
        }

        if (stat(argv[1], &sb) == -1) {
                perror("stat");
                exit(EXIT_FAILURE);
        }

        printf("File type: ");
        switch (sb.st_mode & S_IFMT) {

        case S_IFDIR:   printf("directory\n"); break;
        case S_IFLNK:   printf("link\n"); break;
        case S_IFREG:   printf("regular file\n"); break;
        default:        printf("not a regular file or directory or symlink\n");
        }

        printf("inode number: %ld\n", (long) sb.st_ino);

        exit(EXIT_SUCCESS);
}

Ideally, these 32-bit applications should be built with -D_FILE_OFFSET_BITS=64
if they are running on a 64-bit kernel and they should be considered broken if
they are not.i However, there are quite a few applications that are not doing
so.

To workaround this issue, this patch introduces a mount option:
   -o noinode64	- squashes 64-bit inode number to 32-bits for such applications
   -o inode64	- supports 64-bit inodes (default behavior)

Testing: This patch has been tested using the above mentioned reproducer. Also,
verified that the hardlinks are seen properly.

Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/cifs_fs_sb.h |    1 +
 fs/cifs/cifsfs.c     |    4 ++++
 fs/cifs/cifsfs.h     |   16 ++++++++++++++++
 fs/cifs/connect.c    |   10 ++++++++++
 fs/cifs/inode.c      |    4 ++++
 fs/cifs/readdir.c    |    5 ++++-
 6 files changed, 39 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 7852cd6..2563d26 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -40,6 +40,7 @@
 #define CIFS_MOUNT_FSCACHE	0x8000 /* local caching enabled */
 #define CIFS_MOUNT_MF_SYMLINKS	0x10000 /* Minshall+French Symlinks enabled */
 #define CIFS_MOUNT_MULTIUSER	0x20000 /* multiuser mount */
+#define CIFS_MOUNT_32BIT_INODES	0x40000 /* squash to 32-bits */
 
 struct cifs_sb_info {
 	struct rb_root tlink_tree;
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 5e7075d..6b370e8 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -473,6 +473,10 @@ cifs_show_options(struct seq_file *s, struct vfsmount *m)
 		seq_printf(s, ",mfsymlinks");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_FSCACHE)
 		seq_printf(s, ",fsc");
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_32BIT_INODES)
+		seq_printf(s, ",noinode64");
+	else
+		seq_printf(s, ",inode64");
 
 	seq_printf(s, ",rsize=%d", cifs_sb->rsize);
 	seq_printf(s, ",wsize=%d", cifs_sb->wsize);
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 897b2b2..e01d9e3 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -22,6 +22,8 @@
 #ifndef _CIFSFS_H
 #define _CIFSFS_H
 
+#include <linux/compat.h>
+
 #define ROOT_I 2
 
 /*
@@ -37,6 +39,20 @@ cifs_uniqueid_to_ino_t(u64 fileid)
 	return ino;
 }
 
+static inline u64
+cifs_compat_user_ino64(u64 fileid)
+{
+#ifdef CONFIG_COMPAT
+	compat_ulong_t ino;
+#else
+	unsigned long ino;
+#endif
+	ino = fileid;
+	if (sizeof(ino) < sizeof(u64))
+		ino ^= fileid >> (sizeof(u64)-sizeof(ino)) * 8;
+	return ino;
+}
+
 extern struct file_system_type cifs_fs_type;
 extern const struct address_space_operations cifs_addr_ops;
 extern const struct address_space_operations cifs_addr_ops_smallbuf;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a65d311..7fdb361 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -101,6 +101,7 @@ struct smb_vol {
 	bool fsc:1;	/* enable fscache */
 	bool mfsymlinks:1; /* use Minshall+French Symlinks */
 	bool multiuser:1;
+	bool inode64:1;
 	unsigned int rsize;
 	unsigned int wsize;
 	bool sockopt_tcp_nodelay:1;
@@ -836,6 +837,8 @@ cifs_parse_mount_options(char *options, const char *devname,
 	vol->posix_paths = 1;
 	/* default to using server inode numbers where available */
 	vol->server_ino = 1;
+	/* default to support 64-bit inode numbers */
+	vol->inode64 = 1;
 
 	vol->actimeo = CIFS_DEF_ACTIMEO;
 
@@ -1368,6 +1371,10 @@ cifs_parse_mount_options(char *options, const char *devname,
 			vol->mfsymlinks = true;
 		} else if (strnicmp(data, "multiuser", 8) == 0) {
 			vol->multiuser = true;
+		} else if (strnicmp(data, "inode64", 7) == 0) {
+			vol->inode64 = 1;
+		} else if (strnicmp(data, "noinode64", 9) == 0) {
+			vol->inode64 = 0;
 		} else
 			printk(KERN_WARNING "CIFS: Unknown mount option %s\n",
 						data);
@@ -2578,6 +2585,9 @@ static void setup_cifs_sb(struct smb_vol *pvolume_info,
 	if (pvolume_info->multiuser)
 		cifs_sb->mnt_cifs_flags |= (CIFS_MOUNT_MULTIUSER |
 					    CIFS_MOUNT_NO_PERM);
+	if (!pvolume_info->inode64)
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_32BIT_INODES;
+
 	if (pvolume_info->direct_io) {
 		cFYI(1, "mounting share using direct i/o");
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_DIRECT_IO;
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 0c7e369..b31c8d9 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1791,6 +1791,10 @@ int cifs_getattr(struct vfsmount *mnt, struct dentry *dentry,
 			if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID))
 				stat->gid = current_fsgid();
 		}
+
+		/* squash to 32-bits if 'noinode64' option is enabled */
+		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_32BIT_INODES)
+			stat->ino = cifs_uniqueid_to_ino_t(stat->ino);
 	}
 	return err;
 }
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 76b1b37..b902fd0 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -754,7 +754,10 @@ static int cifs_filldir(char *pfindEntry, struct file *file, filldir_t filldir,
 		 */
 		fattr.cf_flags |= CIFS_FATTR_NEED_REVAL;
 
-	ino = cifs_uniqueid_to_ino_t(fattr.cf_uniqueid);
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_32BIT_INODES)
+		ino = cifs_compat_user_ino64(fattr.cf_uniqueid);
+	else
+		ino = cifs_uniqueid_to_ino_t(fattr.cf_uniqueid);
 	tmp_dentry = cifs_readdir_lookup(file->f_dentry, &qstring, &fattr);
 
 	rc = filldir(direntry, qstring.name, qstring.len, file->f_pos,
