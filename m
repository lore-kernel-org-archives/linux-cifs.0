From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 1/3] cifs: remove the vers= and version= synonyms for ver=
Date: Wed, 16 May 2012 23:15:03 +0400
Message-ID: <1337195705-1381-2-git-send-email-piastry@etersoft.ru>
References: <1337195705-1381-1-git-send-email-piastry@etersoft.ru>
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337195705-1381-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

We want these to mean something different entirely, and the mount.cifs
helper only ever passed in ver= automatically. Also, don't allow
ver=cifs anymore since that was never passed in by the mount helper.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index e79df39..0c82881 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -209,8 +209,6 @@ static const match_table_t cifs_mount_option_tokens = {
 	{ Opt_netbiosname, "netbiosname=%s" },
 	{ Opt_servern, "servern=%s" },
 	{ Opt_ver, "ver=%s" },
-	{ Opt_ver, "vers=%s" },
-	{ Opt_ver, "version=%s" },
 	{ Opt_sec, "sec=%s" },
 	{ Opt_cache, "cache=%s" },
 
@@ -1873,8 +1871,7 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			if (string == NULL)
 				goto out_nomem;
 
-			if (strnicmp(string, "cifs", 4) == 0 ||
-			    strnicmp(string, "1", 1) == 0) {
+			if (strnicmp(string, "1", 1) == 0) {
 				/* This is the default */
 				break;
 			}
-- 
1.7.1
