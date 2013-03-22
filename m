From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: ignore the unc= and prefixpath= mount options
Date: Fri, 22 Mar 2013 08:42:57 -0400
Message-ID: <1363956177-10112-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...as advertised for 3.10.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c | 56 +++++--------------------------------------------------
 1 file changed, 5 insertions(+), 51 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 8cac0ba..edb2220 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -95,9 +95,7 @@ enum {
 
 	/* Mount options which take string value */
 	Opt_user, Opt_pass, Opt_ip,
-	Opt_unc, Opt_domain,
-	Opt_srcaddr, Opt_prefixpath,
-	Opt_iocharset,
+	Opt_domain, Opt_srcaddr, Opt_iocharset,
 	Opt_netbiosname, Opt_servern,
 	Opt_ver, Opt_vers, Opt_sec, Opt_cache,
 
@@ -193,14 +191,14 @@ static const match_table_t cifs_mount_option_tokens = {
 	{ Opt_blank_ip, "addr=" },
 	{ Opt_ip, "ip=%s" },
 	{ Opt_ip, "addr=%s" },
-	{ Opt_unc, "unc=%s" },
-	{ Opt_unc, "target=%s" },
-	{ Opt_unc, "path=%s" },
+	{ Opt_ignore, "unc=%s" },
+	{ Opt_ignore, "target=%s" },
+	{ Opt_ignore, "path=%s" },
 	{ Opt_domain, "dom=%s" },
 	{ Opt_domain, "domain=%s" },
 	{ Opt_domain, "workgroup=%s" },
 	{ Opt_srcaddr, "srcaddr=%s" },
-	{ Opt_prefixpath, "prefixpath=%s" },
+	{ Opt_ignore, "prefixpath=%s" },
 	{ Opt_iocharset, "iocharset=%s" },
 	{ Opt_netbiosname, "netbiosname=%s" },
 	{ Opt_servern, "servern=%s" },
@@ -1644,30 +1642,6 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			}
 			got_ip = true;
 			break;
-		case Opt_unc:
-			string = vol->UNC;
-			vol->UNC = match_strdup(args);
-			if (vol->UNC == NULL)
-				goto out_nomem;
-
-			convert_delimiter(vol->UNC, '\\');
-			if (vol->UNC[0] != '\\' || vol->UNC[1] != '\\') {
-				printk(KERN_ERR "CIFS: UNC Path does not "
-						"begin with // or \\\\\n");
-				goto cifs_parse_mount_err;
-			}
-
-			/* Compare old unc= option to new one */
-			if (!string || strcmp(string, vol->UNC))
-				printk(KERN_WARNING "CIFS: the value of the "
-					"unc= mount option does not match the "
-					"device string. Using the unc= option "
-					"for now. In 3.10, that option will "
-					"be ignored and the contents of the "
-					"device string will be used "
-					"instead. (%s != %s)\n", string,
-					vol->UNC);
-			break;
 		case Opt_domain:
 			string = match_strdup(args);
 			if (string == NULL)
@@ -1700,26 +1674,6 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 				goto cifs_parse_mount_err;
 			}
 			break;
-		case Opt_prefixpath:
-			/* skip over any leading delimiter */
-			if (*args[0].from == '/' || *args[0].from == '\\')
-				args[0].from++;
-
-			string = vol->prepath;
-			vol->prepath = match_strdup(args);
-			if (vol->prepath == NULL)
-				goto out_nomem;
-			/* Compare old prefixpath= option to new one */
-			if (!string || strcmp(string, vol->prepath))
-				printk(KERN_WARNING "CIFS: the value of the "
-					"prefixpath= mount option does not "
-					"match the device string. Using the "
-					"prefixpath= option for now. In 3.10, "
-					"that option will be ignored and the "
-					"contents of the device string will be "
-					"used instead.(%s != %s)\n", string,
-					vol->prepath);
-			break;
 		case Opt_iocharset:
 			string = match_strdup(args);
 			if (string == NULL)
-- 
1.7.11.7
