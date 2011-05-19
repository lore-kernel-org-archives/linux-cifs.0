From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/7] cifs: add ignore_pend flag to cifs_call_async
Date: Thu, 19 May 2011 16:22:55 -0400
Message-ID: <1305836578-26333-5-git-send-email-jlayton@redhat.com>
References: <1305836578-26333-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1305836578-26333-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The current code always ignores the max_pending limit. Have it instead
only optionally ignore the pending limit. For CIFSSMBEcho, we need to
ignore it to make sure they always can go out. For async reads, writes
and potentially other calls, we need to respect it.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsproto.h |    2 +-
 fs/cifs/cifssmb.c   |    2 +-
 fs/cifs/transport.c |    5 +++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index b5407a6..6931631 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -69,7 +69,7 @@ extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *smb_buffer,
 extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
 extern int cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 			   unsigned int nvec, mid_callback_t *callback,
-			   void *cbdata);
+			   void *cbdata, bool ignore_pend);
 extern int SendReceive(const unsigned int /* xid */ , struct cifsSesInfo *,
 			struct smb_hdr * /* input */ ,
 			struct smb_hdr * /* out */ ,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index b998996..0aff051 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -743,7 +743,7 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
 	iov.iov_base = smb;
 	iov.iov_len = be32_to_cpu(smb->hdr.smb_buf_length) + 4;
 
-	rc = cifs_call_async(server, &iov, 1, cifs_echo_callback, server);
+	rc = cifs_call_async(server, &iov, 1, cifs_echo_callback, server, true);
 	if (rc)
 		cFYI(1, "Echo request failed: %d", rc);
 
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index b3c3c6d..d1998b6 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -343,13 +343,14 @@ wait_for_response(struct TCP_Server_Info *server, struct mid_q_entry *midQ)
  */
 int
 cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
-		unsigned int nvec, mid_callback_t *callback, void *cbdata)
+		unsigned int nvec, mid_callback_t *callback, void *cbdata,
+		bool ignore_pend)
 {
 	int rc;
 	struct mid_q_entry *mid;
 	struct smb_hdr *hdr = (struct smb_hdr *)iov[0].iov_base;
 
-	rc = wait_for_free_request(server, CIFS_ASYNC_OP);
+	rc = wait_for_free_request(server, ignore_pend ? CIFS_ASYNC_OP : 0);
 	if (rc)
 		return rc;
 
-- 
1.7.4.4
