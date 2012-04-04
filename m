From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Fix UNC parsing on mount
Date: Wed, 04 Apr 2012 01:58:56 +0100
Message-ID: <1333501136.2253.41.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Linux CIFS mailing list <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The code cleanup of cifs_parse_mount_options resulted in a new bug being
introduced in the parsing of the UNC. This results in vol->UNC being
modified before vol->UNC was allocated.

Reported-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 302a15c..c201a3a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1649,6 +1649,13 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 				goto cifs_parse_mount_err;
 			}
 
+			vol->UNC = kmalloc(temp_len+1, GFP_KERNEL);
+			if (vol->UNC == NULL) {
+				printk(KERN_WARNING "CIFS: no memory for UNC\n");
+				goto cifs_parse_mount_err;
+			}
+			strcpy(vol->UNC, string);
+
 			if (strncmp(string, "//", 2) == 0) {
 				vol->UNC[0] = '\\';
 				vol->UNC[1] = '\\';
@@ -1658,13 +1665,6 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 				goto cifs_parse_mount_err;
 			}
 
-			vol->UNC = kmalloc(temp_len+1, GFP_KERNEL);
-			if (vol->UNC == NULL) {
-				printk(KERN_WARNING "CIFS: no memory "
-						    "for UNC\n");
-				goto cifs_parse_mount_err;
-			}
-			strcpy(vol->UNC, string);
 			break;
 		case Opt_domain:
 			string = match_strdup(args);
-- 
1.7.7.6
