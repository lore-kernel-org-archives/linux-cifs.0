From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: remove the sockopt= mount option
Date: Thu, 21 Feb 2013 06:32:59 -0500
Message-ID: <1361446379-7970-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...as promised for 3.9.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index d997737..8609c42 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -97,7 +97,7 @@ enum {
 	Opt_user, Opt_pass, Opt_ip,
 	Opt_unc, Opt_domain,
 	Opt_srcaddr, Opt_prefixpath,
-	Opt_iocharset, Opt_sockopt,
+	Opt_iocharset,
 	Opt_netbiosname, Opt_servern,
 	Opt_ver, Opt_vers, Opt_sec, Opt_cache,
 
@@ -202,7 +202,6 @@ static const match_table_t cifs_mount_option_tokens = {
 	{ Opt_srcaddr, "srcaddr=%s" },
 	{ Opt_prefixpath, "prefixpath=%s" },
 	{ Opt_iocharset, "iocharset=%s" },
-	{ Opt_sockopt, "sockopt=%s" },
 	{ Opt_netbiosname, "netbiosname=%s" },
 	{ Opt_servern, "servern=%s" },
 	{ Opt_ver, "ver=%s" },
@@ -1722,19 +1721,6 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			 */
 			cFYI(1, "iocharset set to %s", string);
 			break;
-		case Opt_sockopt:
-			string = match_strdup(args);
-			if (string == NULL)
-				goto out_nomem;
-
-			if (strnicmp(string, "TCP_NODELAY", 11) == 0) {
-				printk(KERN_WARNING "CIFS: the "
-					"sockopt=TCP_NODELAY option has been "
-					"deprecated and will be removed "
-					"in 3.9\n");
-				vol->sockopt_tcp_nodelay = 1;
-			}
-			break;
 		case Opt_netbiosname:
 			string = match_strdup(args);
 			if (string == NULL)
-- 
1.7.11.7
