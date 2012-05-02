From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: make sure we ignore the credentials= and cred= options
Date: Wed,  2 May 2012 14:03:28 -0400
Message-ID: <1335981808-3885-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ronald645-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Older mount.cifs programs passed this on to the kernel after parsing
the file. Make sure the kernel ignores that option.

Should fix:

    https://bugzilla.kernel.org/show_bug.cgi?id=43195

Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reported-by: Ronald <ronald645-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a75902b..5dcc551 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -215,6 +215,8 @@ static const match_table_t cifs_mount_option_tokens = {
 
 	{ Opt_ignore, "cred" },
 	{ Opt_ignore, "credentials" },
+	{ Opt_ignore, "cred=%s" },
+	{ Opt_ignore, "credentials=%s" },
 	{ Opt_ignore, "guest" },
 	{ Opt_ignore, "rw" },
 	{ Opt_ignore, "ro" },
-- 
1.7.7.6
