From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 12/18] cifs: add cifs_call_async
Date: Fri, 17 Dec 2010 10:08:11 -0500
Message-ID: <1292598497-29796-13-git-send-email-jlayton@redhat.com>
References: <1292598497-29796-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292598497-29796-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Add a function that will send a request, and set up the mid for an
async reply.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsproto.h |    5 ++++
 fs/cifs/transport.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 62 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index fe77e69..4d81f0e 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -61,6 +61,11 @@ extern char *cifs_compose_mount_options(const char *sb_mountdata,
 		const char *fullpath, const struct dfs_info3_param *ref,
 		char **devname);
 /* extern void renew_parental_timestamps(struct dentry *direntry);*/
+extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *smb_buffer,
+					struct TCP_Server_Info *server);
+extern int cifs_call_async(struct TCP_Server_Info *server,
+			   struct smb_hdr *in_buf, mid_callback_t *callback,
+			   void *cbdata);
 extern int SendReceive(const unsigned int /* xid */ , struct cifsSesInfo *,
 			struct smb_hdr * /* input */ ,
 			struct smb_hdr * /* out */ ,
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index ad78cbd..cf8c64d 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -42,7 +42,7 @@ wake_up_task(struct mid_q_entry *mid)
 	wake_up_process(mid->callback_data);
 }
 
-static struct mid_q_entry *
+struct mid_q_entry *
 AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 {
 	struct mid_q_entry *temp;
@@ -345,6 +345,62 @@ wait_for_response(struct TCP_Server_Info *server, struct mid_q_entry *midQ)
 
 
 /*
+ * Send a SMB request and set the callback function in the mid to handle
+ * the result. Caller is responsible for dealing with timeouts.
+ */
+int
+cifs_call_async(struct TCP_Server_Info *server, struct smb_hdr *in_buf,
+		mid_callback_t *callback, void *cbdata)
+{
+	int rc;
+	struct mid_q_entry *mid;
+
+	rc = wait_for_free_request(server, CIFS_ASYNC_OP);
+	if (rc)
+		return rc;
+
+	mutex_lock(&server->srv_mutex);
+	mid = AllocMidQEntry(in_buf, server);
+	if (mid == NULL) {
+		mutex_unlock(&server->srv_mutex);
+		return -ENOMEM;
+	}
+
+	/* put it on the pending_mid_q */
+	spin_lock(&GlobalMid_Lock);
+	list_add_tail(&mid->qhead, &server->pending_mid_q);
+	spin_unlock(&GlobalMid_Lock);
+
+	rc = cifs_sign_smb(in_buf, server, &mid->sequence_number);
+	if (rc) {
+		mutex_unlock(&server->srv_mutex);
+		goto out_err;
+	}
+
+	mid->callback = callback;
+	mid->callback_data = cbdata;
+	mid->midState = MID_REQUEST_SUBMITTED;
+#ifdef CONFIG_CIFS_STATS2
+	atomic_inc(&server->inSend);
+#endif
+	rc = smb_send(server, in_buf, in_buf->smb_buf_length);
+#ifdef CONFIG_CIFS_STATS2
+	atomic_dec(&server->inSend);
+	mid->when_sent = jiffies;
+#endif
+	mutex_unlock(&server->srv_mutex);
+	if (rc)
+		goto out_err;
+
+	return rc;
+out_err:
+	delete_mid(mid);
+	atomic_dec(&server->inFlight);
+	wake_up(&server->request_q);
+	return rc;
+}
+
+/*
  *
  * Send an SMB Request.  No response info (other than return code)
  * needs to be parsed.
-- 
1.7.3.3
