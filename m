From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: sanity check length of data to send before sending
Date: Fri, 14 Feb 2014 07:21:00 -0500
Message-ID: <1392380460-6997-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We had a bug discovered recently where an upper layer function
(cifs_iovec_write) could pass down a smb_rqst with an invalid amount of
data in it. The length of the SMB frame would be correct, but the rqst
struct would cause smb_send_rqst to send nearly 4GB of data.

This should never be the case. Add some sanity checking to the beginning
of smb_send_rqst that ensures that the amount of data we're going to
send agrees with the length in the RFC1002 header. If it doesn't, WARN()
and return -EIO to the upper layers.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/transport.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index b37570952846..18cd5650a5fc 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -270,6 +270,26 @@ cifs_rqst_page_to_kvec(struct smb_rqst *rqst, unsigned int idx,
 		iov->iov_len = rqst->rq_pagesz;
 }
 
+static unsigned long
+rqst_len(struct smb_rqst *rqst)
+{
+	unsigned int i;
+	struct kvec *iov = rqst->rq_iov;
+	unsigned long buflen = 0;
+
+	/* total up iov array first */
+	for (i = 0; i < rqst->rq_nvec; i++)
+		buflen += iov[i].iov_len;
+
+	/* add in the page array if there is one */
+	if (rqst->rq_npages) {
+		buflen += rqst->rq_pagesz * (rqst->rq_npages - 1);
+		buflen += rqst->rq_tailsz;
+	}
+
+	return buflen;
+}
+
 static int
 smb_send_rqst(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 {
@@ -277,6 +297,7 @@ smb_send_rqst(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 	struct kvec *iov = rqst->rq_iov;
 	int n_vec = rqst->rq_nvec;
 	unsigned int smb_buf_length = get_rfc1002_length(iov[0].iov_base);
+	unsigned long send_length;
 	unsigned int i;
 	size_t total_len = 0, sent;
 	struct socket *ssocket = server->ssocket;
@@ -285,6 +306,14 @@ smb_send_rqst(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 	if (ssocket == NULL)
 		return -ENOTSOCK;
 
+	/* sanity check send length */
+	send_length = rqst_len(rqst);
+	if (send_length != smb_buf_length + 4) {
+		WARN(1, "Send length mismatch(send_length=%lu smb_buf_length=%u)\n",
+			send_length, smb_buf_length);
+		return -EIO;
+	}
+
 	cifs_dbg(FYI, "Sending smb: smb_len=%u\n", smb_buf_length);
 	dump_smb(iov[0].iov_base, iov[0].iov_len);
 
-- 
1.8.5.3
