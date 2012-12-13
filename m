From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: fix double-free of "string" in cifs_parse_mount_options
Date: Thu, 13 Dec 2012 06:02:51 -0500
Message-ID: <1355396571-19510-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Dan reported the following regression in commit d387a5c5:

    + fs/cifs/connect.c:1903 cifs_parse_mount_options() error: double free of 'string'

That patch has some of the new option parsing code free "string" without
setting the variable to NULL afterward. Since "string" is automatically
freed in an error condition, fix the code to just rely on that instead
of freeing it explicitly.

Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 7635b5d..17c3643 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1624,14 +1624,11 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 		case Opt_unc:
 			string = vol->UNC;
 			vol->UNC = match_strdup(args);
-			if (vol->UNC == NULL) {
-				kfree(string);
+			if (vol->UNC == NULL)
 				goto out_nomem;
-			}
 
 			convert_delimiter(vol->UNC, '\\');
 			if (vol->UNC[0] != '\\' || vol->UNC[1] != '\\') {
-				kfree(string);
 				printk(KERN_ERR "CIFS: UNC Path does not "
 						"begin with // or \\\\\n");
 				goto cifs_parse_mount_err;
@@ -1687,10 +1684,8 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 
 			string = vol->prepath;
 			vol->prepath = match_strdup(args);
-			if (vol->prepath == NULL) {
-				kfree(string);
+			if (vol->prepath == NULL)
 				goto out_nomem;
-			}
 			/* Compare old prefixpath= option to new one */
 			if (!string || strcmp(string, vol->prepath))
 				printk(KERN_WARNING "CIFS: the value of the "
-- 
1.7.11.7
