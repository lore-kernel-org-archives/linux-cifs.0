From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 09/09] cifs: add mount option to enable local caching
Date: Mon,  5 Jul 2010 18:13:36 +0530
Message-ID: <1278333816-30885-1-git-send-email-sjayaraman@suse.de>
References: <Yes>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cachefs-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Yes>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Add a mount option 'fsc' to enable local caching on CIFS.

I considered adding a separate debug bit for caching, but it appears that
debugging would be relatively easier with the normal CIFS_INFO level.

As the cifs-utils (userspace) changes are not done yet, this patch enables
'fsc' by default to enable testing.

Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Acked-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifs_fs_sb.h |    1 +
 fs/cifs/connect.c    |    8 ++++++++
 2 files changed, 9 insertions(+)

Index: cifs-2.6/fs/cifs/cifs_fs_sb.h
===================================================================
--- cifs-2.6.orig/fs/cifs/cifs_fs_sb.h
+++ cifs-2.6/fs/cifs/cifs_fs_sb.h
@@ -35,6 +35,7 @@
 #define CIFS_MOUNT_DYNPERM      0x1000 /* allow in-memory only mode setting   */
 #define CIFS_MOUNT_NOPOSIXBRL   0x2000 /* mandatory not posix byte range lock */
 #define CIFS_MOUNT_NOSSYNC      0x4000 /* don't do slow SMBflush on every sync*/
+#define CIFS_MOUNT_FSCACHE	0x8000 /* local caching enabled */
 
 struct cifs_sb_info {
 	struct cifsTconInfo *tcon;	/* primary mount */
Index: cifs-2.6/fs/cifs/connect.c
===================================================================
--- cifs-2.6.orig/fs/cifs/connect.c
+++ cifs-2.6/fs/cifs/connect.c
@@ -98,6 +98,7 @@ struct smb_vol {
 	bool noblocksnd:1;
 	bool noautotune:1;
 	bool nostrictsync:1; /* do not force expensive SMBflush on every sync */
+	bool fsc:1;	/* enable fscache */
 	unsigned int rsize;
 	unsigned int wsize;
 	bool sockopt_tcp_nodelay:1;
@@ -843,6 +844,9 @@ cifs_parse_mount_options(char *options,
 	/* default to using server inode numbers where available */
 	vol->server_ino = 1;
 
+	/* XXX: default to fsc for testing until mount.cifs pieces are done */
+	vol->fsc = 1;
+
 	if (!options)
 		return 1;
 
@@ -1332,6 +1336,8 @@ cifs_parse_mount_options(char *options,
 			printk(KERN_WARNING "CIFS: Mount option noac not "
 				"supported. Instead set "
 				"/proc/fs/cifs/LookupCacheEnabled to 0\n");
+		} else if (strnicmp(data, "fsc", 3) == 0) {
+			vol->fsc = true;
 		} else
 			printk(KERN_WARNING "CIFS: Unknown mount option %s\n",
 						data);
@@ -2405,6 +2411,8 @@ static void setup_cifs_sb(struct smb_vol
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_OVERR_GID;
 	if (pvolume_info->dynperm)
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_DYNPERM;
+	if (pvolume_info->fsc)
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_FSCACHE;
 	if (pvolume_info->direct_io) {
 		cFYI(1, "mounting share using direct i/o");
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_DIRECT_IO;
