From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: drop spinlock before calling cifs_put_tlink
Date: Mon, 11 Jul 2011 10:16:34 -0400
Message-ID: <1310393794-12407-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...as that function can sleep.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ceab134..dd695c5 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2241,8 +2241,8 @@ cifs_match_super(struct super_block *sb, void *data)
 
 	rc = compare_mount_options(sb, mnt_data);
 out:
-	cifs_put_tlink(tlink);
 	spin_unlock(&cifs_tcp_ses_lock);
+	cifs_put_tlink(tlink);
 	return rc;
 }
 
-- 
1.7.6
