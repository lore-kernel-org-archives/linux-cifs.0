From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: Allow passwords which begin with a delimitor
Date: Tue,  9 Apr 2013 18:17:41 +0100
Message-ID: <1365527861-6624-1-git-send-email-sprabhu@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Peter Maloney <peter.maloney-bU717sqhW2kTELwDM1PSjyEWGD4kr0XT@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Fixes a regression in cifs_parse_mount_options where a password
which begins with a delimitor is parsed incorrectly as being a blank
password.

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 12b3da3..f7199b9 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1546,14 +1546,24 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			}
 			break;
 		case Opt_blank_pass:
-			vol->password = NULL;
-			break;
-		case Opt_pass:
 			/* passwords have to be handled differently
 			 * to allow the character used for deliminator
 			 * to be passed within them
 			 */
 
+			/*
+			 * Check if this is a case where the  password
+			 * starts with a delimiter
+			 */
+			tmp_end = strchr(data, '=');
+			tmp_end++;
+			if (!(tmp_end < end && tmp_end[1] == delim)) {
+				/* No it is not. Set the password to NULL */
+				vol->password = NULL;
+				break;
+			}
+			/* Yes it is. Drop down to Opt_pass below.*/
+		case Opt_pass:
 			/* Obtain the value string */
 			value = strchr(data, '=');
 			value++;
-- 
1.7.11.7
