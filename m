From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: fix error handling when calling cifs_parse_devname
Date: Wed, 22 May 2013 20:56:31 -0400
Message-ID: <1369270591-16546-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When we allowed separate unc= and prefixpath= mount options, we could
ignore EINVAL errors from cifs_parse_devname. Now that they are
deprecated, we need to check for that as well and fail the mount if it's
malformed.

Also fix a later error message that refers to the unc= option.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 0a7fdc3..c587657 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1258,14 +1258,18 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 	vol->backupuid_specified = false; /* no backup intent for a user */
 	vol->backupgid_specified = false; /* no backup intent for a group */
 
-	/*
-	 * For now, we ignore -EINVAL errors under the assumption that the
-	 * unc= and prefixpath= options will be usable.
-	 */
-	if (cifs_parse_devname(devname, vol) == -ENOMEM) {
-		printk(KERN_ERR "CIFS: Unable to allocate memory to parse "
-				"device string.\n");
-		goto out_nomem;
+	switch(cifs_parse_devname(devname, vol)) {
+	case 0:
+		break;
+	case -ENOMEM:
+		cifs_dbg(VFS, "Unable to allocate memory for devname.\n");
+		goto cifs_parse_mount_err;
+	case -EINVAL:
+		cifs_dbg(VFS, "Malformed UNC in devname.\n");
+		goto cifs_parse_mount_err;
+	default:
+		cifs_dbg(VFS, "Unknown error parsing devname.\n");
+		goto cifs_parse_mount_err;
 	}
 
 	while ((data = strsep(&options, separator)) != NULL) {
@@ -1827,7 +1831,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 	}
 #endif
 	if (!vol->UNC) {
-		cifs_dbg(VFS, "CIFS mount error: No usable UNC path provided in device string or in unc= option!\n");
+		cifs_dbg(VFS, "CIFS mount error: No usable UNC path provided in device string!\n");
 		goto cifs_parse_mount_err;
 	}
 
-- 
1.8.1.4
