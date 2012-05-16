From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 1/4] cifs: add a cache= option to better describe the different cache flavors
Date: Wed, 16 May 2012 07:55:51 -0400
Message-ID: <1337169354-19045-2-git-send-email-jlayton@redhat.com>
References: <1337169354-19045-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337169354-19045-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently, we have several mount options that control cifs' cache
behavior, but those options aren't considered to be mutually exclusive.
The result is poorly-defined when someone specifies more than one of
these options at mount time.

Fix this by adding a new cache= mount option that will supercede
"strictcache", and "forcedirectio". That will help make it clear that
these options are mutually exclusive. Also, change the legacy options to
be mutually exclusive too, to ensure that users don't get surprises.

Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |   57 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 54 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5dcc551..cf8fe3e 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -102,7 +102,7 @@ enum {
 	Opt_srcaddr, Opt_prefixpath,
 	Opt_iocharset, Opt_sockopt,
 	Opt_netbiosname, Opt_servern,
-	Opt_ver, Opt_sec,
+	Opt_ver, Opt_sec, Opt_cache,
 
 	/* Mount options to be ignored */
 	Opt_ignore,
@@ -212,6 +212,7 @@ static const match_table_t cifs_mount_option_tokens = {
 	{ Opt_ver, "vers=%s" },
 	{ Opt_ver, "version=%s" },
 	{ Opt_sec, "sec=%s" },
+	{ Opt_cache, "cache=%s" },
 
 	{ Opt_ignore, "cred" },
 	{ Opt_ignore, "credentials" },
@@ -260,6 +261,21 @@ static const match_table_t cifs_secflavor_tokens = {
 	{ Opt_sec_err, NULL }
 };
 
+/* cache flavors */
+enum {
+	Opt_cache_loose,
+	Opt_cache_strict,
+	Opt_cache_none,
+	Opt_cache_err
+};
+
+static const match_table_t cifs_cacheflavor_tokens = {
+	{ Opt_cache_loose, "loose" },
+	{ Opt_cache_strict, "strict" },
+	{ Opt_cache_none, "none" },
+	{ Opt_cache_err, NULL }
+};
+
 static int ip_connect(struct TCP_Server_Info *server);
 static int generic_ip_connect(struct TCP_Server_Info *server);
 static void tlink_rb_insert(struct rb_root *root, struct tcon_link *new_tlink);
@@ -1185,6 +1201,31 @@ static int cifs_parse_security_flavors(char *value,
 }
 
 static int
+cifs_parse_cache_flavor(char *value, struct smb_vol *vol)
+{
+	substring_t args[MAX_OPT_ARGS];
+
+	switch (match_token(value, cifs_cacheflavor_tokens, args)) {
+	case Opt_cache_loose:
+		vol->direct_io = false;
+		vol->strict_io = false;
+		break;
+	case Opt_cache_strict:
+		vol->direct_io = false;
+		vol->strict_io = true;
+		break;
+	case Opt_cache_none:
+		vol->direct_io = true;
+		vol->strict_io = false;
+		break;
+	default:
+		cERROR(1, "bad cache= option: %s", value);
+		return 1;
+	}
+	return 0;
+}
+
+static int
 cifs_parse_mount_options(const char *mountdata, const char *devname,
 			 struct smb_vol *vol)
 {
@@ -1413,10 +1454,12 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			vol->seal = 1;
 			break;
 		case Opt_direct:
-			vol->direct_io = 1;
+			vol->direct_io = true;
+			vol->strict_io = false;
 			break;
 		case Opt_strictcache:
-			vol->strict_io = 1;
+			vol->direct_io = false;
+			vol->strict_io = true;
 			break;
 		case Opt_noac:
 			printk(KERN_WARNING "CIFS: Mount option noac not "
@@ -1837,6 +1880,14 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			if (cifs_parse_security_flavors(string, vol) != 0)
 				goto cifs_parse_mount_err;
 			break;
+		case Opt_cache:
+			string = match_strdup(args);
+			if (string == NULL)
+				goto out_nomem;
+
+			if (cifs_parse_cache_flavor(string, vol) != 0)
+				goto cifs_parse_mount_err;
+			break;
 		default:
 			/*
 			 * An option we don't recognize. Save it off for later
-- 
1.7.7.6
