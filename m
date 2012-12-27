From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: adjust sequence number downward after signing NT_CANCEL request
Date: Thu, 27 Dec 2012 08:05:03 -0500
Message-ID: <1356613503-30109-1-git-send-email-jlayton@redhat.com>
Cc: tdparmor-sambabugs-/E1597aS9LQAvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When a call goes out, the signing code adjusts the sequence number
upward by two to account for the request and the response. An NT_CANCEL
however doesn't get a response of its own, it just hurries the server
along to get it to respond to the original request more quickly.
Therefore, we must adjust the sequence number back down by one after
signing a NT_CANCEL request.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Reported-by: Tim Perry <tdparmor-sambabugs-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb1ops.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index a5d234c..dd79056 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -53,6 +53,13 @@ send_nt_cancel(struct TCP_Server_Info *server, void *buf,
 		mutex_unlock(&server->srv_mutex);
 		return rc;
 	}
+
+	/*
+	 * The response to this call was already factored into the sequence
+	 * number when the call went out, so we must adjust it back downward
+	 * after signing here.
+	 */
+	--server->sequence_number;
 	rc = smb_send(server, in_buf, be32_to_cpu(in_buf->smb_buf_length));
 	mutex_unlock(&server->srv_mutex);
 
-- 
1.7.11.7
