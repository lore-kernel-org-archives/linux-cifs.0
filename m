From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/6] cifs: clean up handling of unc= option
Date: Fri, 16 Nov 2012 12:36:52 -0500
Message-ID: <1353087414-32152-5-git-send-email-jlayton@redhat.com>
References: <1353087414-32152-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fsauter-LVkJPw3T+odGBRGhe+f61g@public.gmane.org,
	almiller_1-/E1597aS9LT10XsdtD+oqA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1353087414-32152-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Make sure we free any existing memory allocated for vol->UNC, just in
case someone passes in multiple unc= options.

Get rid of the check for too long a UNC. The check for >300 bytes seems
arbitrary. We later copy this into the tcon->treeName, for instance and
it's a lot shorter than 300 bytes.

Eliminate an extra kmalloc and copy as well. Just set the vol->UNC
directly with the contents of match_strdup.

Establish that the UNC should be stored with '\\' delimiters. Use
convert_delimiter to change it in place in the vol->UNC.

Finally, move the check for a malformed UNC into
cifs_parse_mount_options so we can catch that situation earlier.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c | 39 ++++++++++++---------------------------
 1 file changed, 12 insertions(+), 27 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 7d95206..89f426f 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1557,29 +1557,15 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			got_ip = true;
 			break;
 		case Opt_unc:
-			string = match_strdup(args);
-			if (string == NULL)
+			kfree(vol->UNC);
+			vol->UNC = match_strdup(args);
+			if (vol->UNC == NULL)
 				goto out_nomem;
 
-			temp_len = strnlen(string, 300);
-			if (temp_len  == 300) {
-				printk(KERN_WARNING "CIFS: UNC name too long\n");
-				goto cifs_parse_mount_err;
-			}
-
-			vol->UNC = kmalloc(temp_len+1, GFP_KERNEL);
-			if (vol->UNC == NULL) {
-				printk(KERN_WARNING "CIFS: no memory for UNC\n");
-				goto cifs_parse_mount_err;
-			}
-			strcpy(vol->UNC, string);
-
-			if (strncmp(string, "//", 2) == 0) {
-				vol->UNC[0] = '\\';
-				vol->UNC[1] = '\\';
-			} else if (strncmp(string, "\\\\", 2) != 0) {
+			convert_delimiter(vol->UNC, '\\');
+			if (vol->UNC[0] != '\\' || vol->UNC[1] != '\\') {
 				printk(KERN_WARNING "CIFS: UNC Path does not "
-						    "begin with // or \\\\\n");
+						"begin with // or \\\\\n");
 				goto cifs_parse_mount_err;
 			}
 
@@ -1804,6 +1790,12 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 		goto cifs_parse_mount_err;
 	}
 
+	/* make sure UNC has a share name */
+	if (!strchr(vol->UNC + 3, '\\')) {
+		cERROR(1, "Malformed UNC. Unable to find share name.");
+		goto cifs_parse_mount_err;
+	}
+
 	if (!got_ip) {
 		/* No ip= option specified? Try to get it from UNC */
 		if (!cifs_convert_address(dstaddr, &vol->UNC[2],
@@ -2577,13 +2569,6 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb_vol *volume_info)
 		}
 	}
 
-	if (strchr(volume_info->UNC + 3, '\\') == NULL
-	    && strchr(volume_info->UNC + 3, '/') == NULL) {
-		cERROR(1, "Missing share name");
-		rc = -ENODEV;
-		goto out_fail;
-	}
-
 	/*
 	 * BB Do we need to wrap session_mutex around this TCon call and Unix
 	 * SetFS as we do on SessSetup and reconnect?
-- 
1.7.11.7
