From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: remove ENOSPC handling in smb_sendv
Date: Fri, 22 Mar 2013 08:43:46 -0400
Message-ID: <1363956226-10179-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sjayaraman-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

To my knowledge, no one ever reported seeing this pop.

Suresh Jayaraman <sjayaraman-Et1tbQHTxzrQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/transport.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index cf8bf69..653bf26 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -179,13 +179,7 @@ smb_send_kvec(struct TCP_Server_Info *server, struct kvec *iov, size_t n_vec,
 		 */
 		rc = kernel_sendmsg(ssocket, &smb_msg, &iov[first_vec],
 				    n_vec - first_vec, remaining);
-		if (rc == -ENOSPC || rc == -EAGAIN) {
-			/*
-			 * Catch if a low level driver returns -ENOSPC. This
-			 * WARN_ON will be removed by 3.10 if no one reports
-			 * seeing this.
-			 */
-			WARN_ON_ONCE(rc == -ENOSPC);
+		if (rc == -EAGAIN) {
 			i++;
 			if (i >= 14 || (!server->noblocksnd && (i > 2))) {
 				cifs_dbg(VFS, "sends on sock %p stuck for 15 seconds\n",
-- 
1.7.11.7
