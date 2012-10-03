From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: reinstate the forcegid option
Date: Wed,  3 Oct 2012 16:02:36 -0400
Message-ID: <1349294556-20656-1-git-send-email-jlayton@redhat.com>
Cc: sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, gregory.lee.bartholomew-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Apparently this was lost when we converted to the standard option
parser.

Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reported-by: Gregory Lee Bartholomew <gregory.lee.bartholomew-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 2fdbe08..5c670b9 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -67,6 +67,7 @@ enum {
 	/* Mount options that take no arguments */
 	Opt_user_xattr, Opt_nouser_xattr,
 	Opt_forceuid, Opt_noforceuid,
+	Opt_forcegid, Opt_noforcegid,
 	Opt_noblocksend, Opt_noautotune,
 	Opt_hard, Opt_soft, Opt_perm, Opt_noperm,
 	Opt_mapchars, Opt_nomapchars, Opt_sfu,
@@ -117,6 +118,8 @@ static const match_table_t cifs_mount_option_tokens = {
 	{ Opt_nouser_xattr, "nouser_xattr" },
 	{ Opt_forceuid, "forceuid" },
 	{ Opt_noforceuid, "noforceuid" },
+	{ Opt_forcegid, "forcegid" },
+	{ Opt_noforcegid, "noforcegid" },
 	{ Opt_noblocksend, "noblocksend" },
 	{ Opt_noautotune, "noautotune" },
 	{ Opt_hard, "hard" },
@@ -1195,6 +1198,12 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 		case Opt_noforceuid:
 			override_uid = 0;
 			break;
+		case Opt_forcegid:
+			override_gid = 1;
+			break;
+		case Opt_noforcegid:
+			override_gid = 0;
+			break;
 		case Opt_noblocksend:
 			vol->noblocksnd = 1;
 			break;
-- 
1.7.11.4
