From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v2 5/5] CIFS: Move add/set_credits and get_credits_field to ops structure
Date: Wed, 23 May 2012 12:06:46 +0400
Message-ID: <1337760406-3015-6-git-send-email-piastry@etersoft.ru>
References: <1337760406-3015-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337760406-3015-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Acked-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Signed-off-by: Steve French <sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h  |   25 +++++++++++++++----------
 fs/cifs/cifsproto.h |    3 ---
 fs/cifs/cifssmb.c   |   10 +++++-----
 fs/cifs/connect.c   |    4 ++--
 fs/cifs/misc.c      |   19 -------------------
 fs/cifs/smb1ops.c   |   28 ++++++++++++++++++++++++++++
 fs/cifs/transport.c |   23 ++++++++++++-----------
 7 files changed, 62 insertions(+), 50 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 1001924..2396456 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -169,6 +169,9 @@ struct smb_version_operations {
 	/* check response: verify signature, map error */
 	int (*check_receive)(struct mid_q_entry *, struct TCP_Server_Info *,
 			     bool);
+	void (*add_credits)(struct TCP_Server_Info *, const unsigned int);
+	void (*set_credits)(struct TCP_Server_Info *, const int);
+	int * (*get_credits_field)(struct TCP_Server_Info *);
 	/* data offset from read response message */
 	unsigned int (*read_data_offset)(char *);
 	/* data length from read response message */
@@ -372,16 +375,6 @@ in_flight(struct TCP_Server_Info *server)
 	return num;
 }
 
-static inline int*
-get_credits_field(struct TCP_Server_Info *server)
-{
-	/*
-	 * This will change to switch statement when we reserve slots for echos
-	 * and oplock breaks.
-	 */
-	return &server->credits;
-}
-
 static inline bool
 has_credits(struct TCP_Server_Info *server, int *credits)
 {
@@ -392,6 +385,18 @@ has_credits(struct TCP_Server_Info *server, int *credits)
 	return num > 0;
 }
 
+static inline void
+add_credits(struct TCP_Server_Info *server, const unsigned int add)
+{
+	server->ops->add_credits(server, add);
+}
+
+static inline void
+set_credits(struct TCP_Server_Info *server, const int val)
+{
+	server->ops->set_credits(server, val);
+}
+
 /*
  * Macros to allow the TCP_Server_Info->net field and related code to drop out
  * when CONFIG_NET_NS isn't set.
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 57af642..5ec21ec 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -90,9 +90,6 @@ extern int SendReceiveBlockingLock(const unsigned int xid,
 			struct smb_hdr *in_buf ,
 			struct smb_hdr *out_buf,
 			int *bytes_returned);
-extern void cifs_add_credits(struct TCP_Server_Info *server,
-			     const unsigned int add);
-extern void cifs_set_credits(struct TCP_Server_Info *server, const int val);
 extern int checkSMB(char *buf, unsigned int length);
 extern bool is_valid_oplock_break(char *, struct TCP_Server_Info *);
 extern bool backup_cred(struct cifs_sb_info *);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index b1f3751..b5ad716 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -460,7 +460,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses)
 		server->maxReq = min_t(unsigned int,
 				       le16_to_cpu(rsp->MaxMpxCount),
 				       cifs_max_pending);
-		cifs_set_credits(server, server->maxReq);
+		set_credits(server, server->maxReq);
 		server->maxBuf = le16_to_cpu(rsp->MaxBufSize);
 		server->max_vcs = le16_to_cpu(rsp->MaxNumberVcs);
 		/* even though we do not use raw we might as well set this
@@ -568,7 +568,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses)
 	   little endian */
 	server->maxReq = min_t(unsigned int, le16_to_cpu(pSMBr->MaxMpxCount),
 			       cifs_max_pending);
-	cifs_set_credits(server, server->maxReq);
+	set_credits(server, server->maxReq);
 	/* probably no need to store and check maxvcs */
 	server->maxBuf = le32_to_cpu(pSMBr->MaxBufferSize);
 	server->max_rw = le32_to_cpu(pSMBr->MaxRawSize);
@@ -720,7 +720,7 @@ cifs_echo_callback(struct mid_q_entry *mid)
 	struct TCP_Server_Info *server = mid->callback_data;
 
 	DeleteMidQEntry(mid);
-	cifs_add_credits(server, 1);
+	add_credits(server, 1);
 }
 
 int
@@ -1563,7 +1563,7 @@ cifs_readv_callback(struct mid_q_entry *mid)
 
 	queue_work(cifsiod_wq, &rdata->work);
 	DeleteMidQEntry(mid);
-	cifs_add_credits(server, 1);
+	add_credits(server, 1);
 }
 
 /* cifs_async_readv - send an async write, and set up mid to handle result */
@@ -2010,7 +2010,7 @@ cifs_writev_callback(struct mid_q_entry *mid)
 
 	queue_work(cifsiod_wq, &wdata->work);
 	DeleteMidQEntry(mid);
-	cifs_add_credits(tcon->ses->server, 1);
+	add_credits(tcon->ses->server, 1);
 }
 
 /* cifs_async_writev - send an async write, and set up mid to handle result */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index ce033d7..c71c11c 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -4099,11 +4099,11 @@ int cifs_negotiate_protocol(unsigned int xid, struct cifs_ses *ses)
 	if (server->maxBuf != 0)
 		return 0;
 
-	cifs_set_credits(server, 1);
+	set_credits(server, 1);
 	rc = CIFSSMBNegotiate(xid, ses);
 	if (rc == -EAGAIN) {
 		/* retry only once on 1st time connection */
-		cifs_set_credits(server, 1);
+		set_credits(server, 1);
 		rc = CIFSSMBNegotiate(xid, ses);
 		if (rc == -EAGAIN)
 			rc = -EHOSTDOWN;
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index d2bb1e7..e2552d2 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -653,22 +653,3 @@ backup_cred(struct cifs_sb_info *cifs_sb)
 
 	return false;
 }
-
-void
-cifs_add_credits(struct TCP_Server_Info *server, const unsigned int add)
-{
-	spin_lock(&server->req_lock);
-	server->credits += add;
-	server->in_flight--;
-	spin_unlock(&server->req_lock);
-	wake_up(&server->request_q);
-}
-
-void
-cifs_set_credits(struct TCP_Server_Info *server, const int val)
-{
-	spin_lock(&server->req_lock);
-	server->credits = val;
-	server->oplocks = val > 1 ? enable_oplocks : false;
-	spin_unlock(&server->req_lock);
-}
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index ddc8ca6..d9d615f 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -100,11 +100,39 @@ cifs_find_mid(struct TCP_Server_Info *server, char *buffer)
 	return NULL;
 }
 
+static void
+cifs_add_credits(struct TCP_Server_Info *server, const unsigned int add)
+{
+	spin_lock(&server->req_lock);
+	server->credits += add;
+	server->in_flight--;
+	spin_unlock(&server->req_lock);
+	wake_up(&server->request_q);
+}
+
+static void
+cifs_set_credits(struct TCP_Server_Info *server, const int val)
+{
+	spin_lock(&server->req_lock);
+	server->credits = val;
+	server->oplocks = val > 1 ? enable_oplocks : false;
+	spin_unlock(&server->req_lock);
+}
+
+static int *
+cifs_get_credits_field(struct TCP_Server_Info *server)
+{
+	return &server->credits;
+}
+
 struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
 	.compare_fids = cifs_compare_fids,
 	.setup_request = cifs_setup_request,
 	.check_receive = cifs_check_receive,
+	.add_credits = cifs_add_credits,
+	.set_credits = cifs_set_credits,
+	.get_credits_field = cifs_get_credits_field,
 	.read_data_offset = cifs_read_data_offset,
 	.read_data_length = cifs_read_data_length,
 	.map_error = map_smb_to_linux_error,
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 87bd998..1b36ffe 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -304,7 +304,8 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int optype,
 static int
 wait_for_free_request(struct TCP_Server_Info *server, const int optype)
 {
-	return wait_for_free_credits(server, optype, get_credits_field(server));
+	return wait_for_free_credits(server, optype,
+				     server->ops->get_credits_field(server));
 }
 
 static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,
@@ -396,7 +397,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 	rc = cifs_setup_async_request(server, iov, nvec, &mid);
 	if (rc) {
 		mutex_unlock(&server->srv_mutex);
-		cifs_add_credits(server, 1);
+		add_credits(server, 1);
 		wake_up(&server->request_q);
 		return rc;
 	}
@@ -418,7 +419,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 	return rc;
 out_err:
 	delete_mid(mid);
-	cifs_add_credits(server, 1);
+	add_credits(server, 1);
 	wake_up(&server->request_q);
 	return rc;
 }
@@ -582,7 +583,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		mutex_unlock(&ses->server->srv_mutex);
 		cifs_small_buf_release(buf);
 		/* Update # of requests on wire to server */
-		cifs_add_credits(ses->server, 1);
+		add_credits(ses->server, 1);
 		return rc;
 	}
 
@@ -612,7 +613,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
 			cifs_small_buf_release(buf);
-			cifs_add_credits(ses->server, 1);
+			add_credits(ses->server, 1);
 			return rc;
 		}
 		spin_unlock(&GlobalMid_Lock);
@@ -622,7 +623,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 
 	rc = cifs_sync_mid_result(midQ, ses->server);
 	if (rc != 0) {
-		cifs_add_credits(ses->server, 1);
+		add_credits(ses->server, 1);
 		return rc;
 	}
 
@@ -648,7 +649,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		midQ->resp_buf = NULL;
 out:
 	delete_mid(midQ);
-	cifs_add_credits(ses->server, 1);
+	add_credits(ses->server, 1);
 
 	return rc;
 }
@@ -698,7 +699,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	if (rc) {
 		mutex_unlock(&ses->server->srv_mutex);
 		/* Update # of requests on wire to server */
-		cifs_add_credits(ses->server, 1);
+		add_credits(ses->server, 1);
 		return rc;
 	}
 
@@ -730,7 +731,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 			/* no longer considered to be "in-flight" */
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
-			cifs_add_credits(ses->server, 1);
+			add_credits(ses->server, 1);
 			return rc;
 		}
 		spin_unlock(&GlobalMid_Lock);
@@ -738,7 +739,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 
 	rc = cifs_sync_mid_result(midQ, ses->server);
 	if (rc != 0) {
-		cifs_add_credits(ses->server, 1);
+		add_credits(ses->server, 1);
 		return rc;
 	}
 
@@ -754,7 +755,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	rc = cifs_check_receive(midQ, ses->server, 0);
 out:
 	delete_mid(midQ);
-	cifs_add_credits(ses->server, 1);
+	add_credits(ses->server, 1);
 
 	return rc;
 }
-- 
1.7.1
