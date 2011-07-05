From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: remove bogus call to cifs_cleanup_volume_info
Date: Tue,  5 Jul 2011 17:37:37 -0400
Message-ID: <1309901857-32016-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, awilliam-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This call to cifs_cleanup_volume_info is clearly wrong. As soon as it's
called the following call to cifs_get_tcp_session will oops as the
volume_info pointer will then be NULL.

The caller of cifs_mount should clean up this data since it passed it
in. There's no need for us to call this here.

Regression introduced by commit 724d9f1cfba.

Reported-by: Adam Williamson <awilliam-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index c8cb83e..545e854 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3012,7 +3012,6 @@ try_mount_again:
 		else if (pSesInfo)
 			cifs_put_smb_ses(pSesInfo);
 
-		cifs_cleanup_volume_info(&volume_info);
 		FreeXid(xid);
 	}
 #endif
-- 
1.7.6
