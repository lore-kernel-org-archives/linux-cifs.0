From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 01/11] cifs: remove bogus reset of smb_buf_length in smb_send routines
Date: Wed, 18 Jul 2012 13:58:56 -0400
Message-ID: <1342634346-22818-2-git-send-email-jlayton@redhat.com>
References: <1342634346-22818-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342634346-22818-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

There's a comment here about how we don't want to modify this length,
but nothing in this function actually does.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/transport.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 3097ee5..fa51913 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -126,7 +126,6 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
 	int rc = 0;
 	int i = 0;
 	struct msghdr smb_msg;
-	__be32 *buf_len = (__be32 *)(iov[0].iov_base);
 	unsigned int len = iov[0].iov_len;
 	unsigned int total_len;
 	int first_vec = 0;
@@ -235,9 +234,6 @@ smb_sendv(struct TCP_Server_Info *server, struct kvec *iov, int n_vec)
 	else
 		rc = 0;
 
-	/* Don't want to modify the buffer as a side effect of this call. */
-	*buf_len = cpu_to_be32(smb_buf_length);
-
 	return rc;
 }
 
-- 
1.7.10.4
