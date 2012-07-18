From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 06/11] cifs: teach smb_send_rqst how to handle arrays of pages
Date: Wed, 18 Jul 2012 13:59:01 -0400
Message-ID: <1342634346-22818-7-git-send-email-jlayton@redhat.com>
References: <1342634346-22818-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342634346-22818-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Add code that allows smb_send_rqst to send an array of pages after the
initial kvec array has been sent. For now, we simply kmap the page
array and send it using the standard smb_send_kvec function. Eventually,
we may want to convert this code to use kernel_sendpage under the hood
and avoid the kmap altogether for the page data.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/transport.c |   56 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 54 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index af56e91..006c3fb 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -28,6 +28,7 @@
 #include <linux/delay.h>
 #include <linux/freezer.h>
 #include <linux/tcp.h>
+#include <linux/highmem.h>
 #include <asm/uaccess.h>
 #include <asm/processor.h>
 #include <linux/mempool.h>
@@ -241,6 +242,38 @@ smb_send_kvec(struct TCP_Server_Info *server, struct kvec *iov, size_t n_vec,
 	return rc;
 }
 
+/**
+ * rqst_page_to_kvec - Turn a slot in the smb_rqst page array into a kvec
+ * @rqst: pointer to smb_rqst
+ * @idx: index into the array of the page
+ * @iov: pointer to struct kvec that will hold the result
+ *
+ * Helper function to convert a slot in the rqst->rq_pages array into a kvec.
+ * The page will be kmapped and the address placed into iov_base. The length
+ * will then be adjusted according to the ptailoff.
+ */
+static void
+cifs_rqst_page_to_kvec(struct smb_rqst *rqst, unsigned int idx,
+			struct kvec *iov)
+{
+	/*
+	 * FIXME: We could avoid this kmap altogether if we used
+	 * kernel_sendpage instead of kernel_sendmsg. That will only
+	 * work if signing is disabled though as sendpage inlines the
+	 * page directly into the fraglist. If userspace modifies the
+	 * page after we calculate the signature, then the server will
+	 * reject it and may break the connection. kernel_sendmsg does
+	 * an extra copy of the data and avoids that issue.
+	 */
+	iov->iov_base = kmap(rqst->rq_pages[idx]);
+
+	/* if last page, don't send beyond this offset into page */
+	if (idx == (rqst->rq_npages - 1))
+		iov->iov_len = rqst->rq_tailsz;
+	else
+		iov->iov_len = rqst->rq_pagesz;
+}
+
 static int
 smb_send_rqst(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 {
@@ -248,7 +281,8 @@ smb_send_rqst(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 	struct kvec *iov = rqst->rq_iov;
 	int n_vec = rqst->rq_nvec;
 	unsigned int smb_buf_length = get_rfc1002_length(iov[0].iov_base);
-	size_t total_len;
+	unsigned int i;
+	size_t total_len = 0, sent;
 	struct socket *ssocket = server->ssocket;
 	int val = 1;
 
@@ -259,8 +293,26 @@ smb_send_rqst(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 	kernel_setsockopt(ssocket, SOL_TCP, TCP_CORK,
 				(char *)&val, sizeof(val));
 
-	rc = smb_send_kvec(server, iov, n_vec, &total_len);
+	rc = smb_send_kvec(server, iov, n_vec, &sent);
+	if (rc < 0)
+		goto uncork;
+
+	total_len += sent;
+
+	/* now walk the page array and send each page in it */
+	for (i = 0; i < rqst->rq_npages; i++) {
+		struct kvec p_iov;
+
+		cifs_rqst_page_to_kvec(rqst, i, &p_iov);
+		rc = smb_send_kvec(server, &p_iov, 1, &sent);
+		kunmap(rqst->rq_pages[i]);
+		if (rc < 0)
+			break;
+
+		total_len += sent;
+	}
 
+uncork:
 	/* uncork it */
 	val = 0;
 	kernel_setsockopt(ssocket, SOL_TCP, TCP_CORK,
-- 
1.7.10.4
