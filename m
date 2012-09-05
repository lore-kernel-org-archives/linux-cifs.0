From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: remove support for deprecated "forcedirectio" and "strictcache" mount options
Date: Wed,  5 Sep 2012 09:57:53 -0400
Message-ID: <1346853473-13383-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...and make the default cache=strict as promised for 3.7.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c | 37 ++++---------------------------------
 1 file changed, 4 insertions(+), 33 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 59c595e..a792282 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -82,8 +82,7 @@ enum {
 	Opt_serverino, Opt_noserverino,
 	Opt_rwpidforward, Opt_cifsacl, Opt_nocifsacl,
 	Opt_acl, Opt_noacl, Opt_locallease,
-	Opt_sign, Opt_seal, Opt_direct,
-	Opt_strictcache, Opt_noac,
+	Opt_sign, Opt_seal, Opt_noac,
 	Opt_fsc, Opt_mfsymlinks,
 	Opt_multiuser, Opt_sloppy,
 
@@ -160,10 +159,6 @@ static const match_table_t cifs_mount_option_tokens = {
 	{ Opt_locallease, "locallease" },
 	{ Opt_sign, "sign" },
 	{ Opt_seal, "seal" },
-	{ Opt_direct, "direct" },
-	{ Opt_direct, "directio" },
-	{ Opt_direct, "forcedirectio" },
-	{ Opt_strictcache, "strictcache" },
 	{ Opt_noac, "noac" },
 	{ Opt_fsc, "fsc" },
 	{ Opt_mfsymlinks, "mfsymlinks" },
@@ -1105,8 +1100,6 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 	char *string = NULL;
 	char *tmp_end, *value;
 	char delim;
-	bool cache_specified = false;
-	static bool cache_warned = false;
 
 	separator[0] = ',';
 	separator[1] = 0;
@@ -1138,6 +1131,9 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 	/* default to using server inode numbers where available */
 	vol->server_ino = 1;
 
+	/* default is to use strict cifs caching semantics */
+	vol->strict_io = true;
+
 	vol->actimeo = CIFS_DEF_ACTIMEO;
 
 	/* FIXME: add autonegotiation -- for now, SMB1 is default */
@@ -1321,22 +1317,6 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			 */
 			vol->seal = 1;
 			break;
-		case Opt_direct:
-			cache_specified = true;
-			vol->direct_io = true;
-			vol->strict_io = false;
-			cERROR(1, "The \"directio\" option will be removed in "
-				  "3.7. Please switch to the \"cache=none\" "
-				  "option.");
-			break;
-		case Opt_strictcache:
-			cache_specified = true;
-			vol->direct_io = false;
-			vol->strict_io = true;
-			cERROR(1, "The \"strictcache\" option will be removed "
-				"in 3.7. Please switch to the \"cache=strict\" "
-				"option.");
-			break;
 		case Opt_noac:
 			printk(KERN_WARNING "CIFS: Mount option noac not "
 				"supported. Instead set "
@@ -1771,7 +1751,6 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 				goto cifs_parse_mount_err;
 			break;
 		case Opt_cache:
-			cache_specified = true;
 			string = match_strdup(args);
 			if (string == NULL)
 				goto out_nomem;
@@ -1822,14 +1801,6 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 		printk(KERN_NOTICE "CIFS: ignoring forcegid mount option "
 				   "specified with no gid= option.\n");
 
-	/* FIXME: remove this block in 3.7 */
-	if (!cache_specified && !cache_warned) {
-		cache_warned = true;
-		printk(KERN_NOTICE "CIFS: no cache= option specified, using "
-				   "\"cache=loose\". This default will change "
-				   "to \"cache=strict\" in 3.7.\n");
-	}
-
 	kfree(mountdata_copy);
 	return 0;
 
-- 
1.7.11.4
