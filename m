From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] mount.cifs: don't try to alter mtab if it's a symlink
Date: Mon, 31 Jan 2011 15:05:17 -0500
Message-ID: <1296504317-20472-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Some distros replace /etc/mtab with a symlink to /proc/mounts. In that
situation, mount.cifs will hang for a while trying to lock the mtab.
/bin/mount checks to see if the mtab is a symlink. If it is or if a
stat() call on it fails, it doesn't try to to update the mtab. Have
mount.cifs do the same.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.c |    2 +-
 mount.h      |    1 +
 mtab.c       |   16 ++++++++++++++++
 3 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index f537a07..5f29761 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -1934,7 +1934,7 @@ mount_retry:
 		goto mount_exit;
 	}
 
-	if (!parsed_info->nomtab)
+	if (!parsed_info->nomtab && !mtab_unusable())
 		rc = add_mtab(orig_dev, mountpoint, parsed_info->flags, fstype);
 
 mount_exit:
diff --git a/mount.h b/mount.h
index 23ea4f0..d49c2ea 100644
--- a/mount.h
+++ b/mount.h
@@ -32,6 +32,7 @@
 #define _PATH_MOUNTED_LOCK	_PATH_MOUNTED "~"
 #define _PATH_MOUNTED_TMP	_PATH_MOUNTED ".tmp"
 
+extern int mtab_unusable(void);
 extern int lock_mtab(void);
 extern void unlock_mtab(void);
 
diff --git a/mtab.c b/mtab.c
index 64e7250..9cd50d8 100644
--- a/mtab.c
+++ b/mtab.c
@@ -77,6 +77,22 @@ mono_time(void) {
 	return ret;
 }
 
+/*
+ * See if mtab is present and whether it's a symlink. Returns errno from stat()
+ * call or EMLINK if it's a symlink.
+ */
+int
+mtab_unusable(void)
+{
+	struct stat mstat;
+
+	if(lstat(_PATH_MOUNTED, &mstat))
+		return errno;
+	else if (S_ISLNK(mstat.st_mode))
+		return EMLINK;
+	return 0;
+}
+
 /* Remove lock file.  */
 void
 unlock_mtab (void) {
-- 
1.7.3.4
