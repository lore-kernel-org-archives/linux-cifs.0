From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: don't pop a printk when sending on a socket is interrupted
Date: Mon, 24 Jan 2011 12:46:52 -0500
Message-ID: <1295891212-6311-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If we kill the process while it's sending on a socket then the
kernel_sendmsg will return -EINTR. This is normal. No need to spam the
ring buffer with this info.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/transport.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index fbeaee8..748b3b8 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -236,9 +236,9 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
 		server->tcpStatus = CifsNeedReconnect;
 	}
 
-	if (rc < 0) {
+	if (rc < 0 && rc != -EINTR)
 		cERROR(1, "Error %d sending data on socket to server", rc);
-	} else
+	else
 		rc = 0;
 
 	/* Don't want to modify the buffer as a
-- 
1.7.3.4
