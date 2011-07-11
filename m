From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: trivial: goto out here is unnecessary
Date: Mon, 11 Jul 2011 10:18:14 -0400
Message-ID: <1310393894-12579-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...and remove some obsolete comments.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 6ec366ff..729514c 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3192,15 +3192,9 @@ mount_fail_check:
 		else
 			cifs_put_tcp_session(srvTcp);
 		bdi_destroy(&cifs_sb->bdi);
-		goto out;
 	}
 
-	/* volume_info->password is freed above when existing session found
-	(in which case it is not needed anymore) but when new sesion is created
-	the password ptr is put in the new session structure (in which case the
-	password will be freed at unmount time) */
 out:
-	/* zero out password before freeing */
 	FreeXid(xid);
 	return rc;
 }
-- 
1.7.6
