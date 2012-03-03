From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 06/17] CIFS: Respect MaxMpxCount field
Date: Sat,  3 Mar 2012 12:37:07 +0300
Message-ID: <1330767438-19469-7-git-send-email-piastry@etersoft.ru>
References: <1330767438-19469-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1330767438-19469-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

by setting the number of available credits to it except 2 that goes
to extra echo and oplock slots. If MaxMpxCount is 2 - disable oplocks,
if 1 - disable oplocks and echos.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsfs.c    |   12 ---------
 fs/cifs/cifsglob.h  |   57 +++++++++++++++++--------------------------
 fs/cifs/cifsproto.h |    7 ++++-
 fs/cifs/cifssmb.c   |   12 +++++----
 fs/cifs/connect.c   |   10 ++++----
 fs/cifs/dir.c       |    5 ++-
 fs/cifs/file.c      |    4 +-
 fs/cifs/misc.c      |   54 +++++++++++++++++++++++++++++++++++++++++
 fs/cifs/transport.c |   67 ++++++++++++++++++++++++--------------------------
 9 files changed, 132 insertions(+), 96 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index e1ce1ca..a9b483b 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -73,10 +73,6 @@ unsigned int cifs_min_small = 30;
 module_param(cifs_min_small, int, 0);
 MODULE_PARM_DESC(cifs_min_small, "Small network buffers in pool. Default: 30 "
 				 "Range: 2 to 256");
-unsigned int cifs_max_pending = CIFS_MAX_REQ;
-module_param(cifs_max_pending, int, 0444);
-MODULE_PARM_DESC(cifs_max_pending, "Simultaneous requests to server. "
-				   "Default: 50 Range: 2 to 256");
 module_param(enable_oplocks, bool, 0644);
 MODULE_PARM_DESC(enable_oplocks, "Enable or disable oplocks (bool). Default:"
 				 "y/Y/1");
@@ -1108,14 +1104,6 @@ init_cifs(void)
 	spin_lock_init(&cifs_file_list_lock);
 	spin_lock_init(&GlobalMid_Lock);
 
-	if (cifs_max_pending < 2) {
-		cifs_max_pending = 2;
-		cFYI(1, "cifs_max_pending set to min of 2");
-	} else if (cifs_max_pending > 256) {
-		cifs_max_pending = 256;
-		cFYI(1, "cifs_max_pending set to max of 256");
-	}
-
 	rc = cifs_fscache_register();
 	if (rc)
 		goto out_clean_proc;
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 5e6c54e..e154cc7 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -53,17 +53,6 @@
  */
 #define CIFS_MAX_ACTIMEO (1 << 30)
 
-/*
- * MAX_REQ is the maximum number of requests that WE will send
- * on one socket concurrently. It also matches the most common
- * value of max multiplex returned by servers.  We may
- * eventually want to use the negotiated value (in case
- * future servers can handle more) when we are more confident that
- * we will not have problems oveloading the socket with pending
- * write data.
- */
-#define CIFS_MAX_REQ 50
-
 #define RFC1001_NAME_LEN 15
 #define RFC1001_NAME_LEN_WITH_NULL (RFC1001_NAME_LEN + 1)
 
@@ -255,7 +244,11 @@ struct TCP_Server_Info {
 	bool noblocksnd;		/* use blocking sendmsg */
 	bool noautotune;		/* do not autotune send buf sizes */
 	bool tcp_nodelay;
-	int credits;  /* send no more requests at once */
+	bool oplocks:1; /* server supports async oplock breaks */
+	bool echos:1; /* server supports async echos */
+	unsigned int echo_credits; /* reserve for echos */
+	unsigned int oplock_credits; /* reserve for oplock breaks */
+	unsigned int credits;  /* send no more requests at once */
 	unsigned int in_flight;  /* number of requests on the wire to server */
 	unsigned int block_locks;  /* number of oustanding blocking locks */
 	spinlock_t req_lock;  /* protect the two values above */
@@ -320,34 +313,31 @@ in_flight(struct TCP_Server_Info *server)
 	return num;
 }
 
-static inline int
-get_credits(struct TCP_Server_Info *server)
-{
-	int num;
-	spin_lock(&server->req_lock);
-	num = server->credits;
-	spin_unlock(&server->req_lock);
-	return num;
-}
+#define   CIFS_OBREAK_OP    0x080    /* oplock break request */
+#define   CIFS_ECHO_OP     0x0100    /* echo request */
+#define   CIFS_REQ_MASK    0x0180    /* mask request type */
 
-static inline void
-add_credits(struct TCP_Server_Info *server, const unsigned int add, int optype)
+static inline unsigned int*
+get_credits_field(struct TCP_Server_Info *server, const int optype)
 {
-	spin_lock(&server->req_lock);
-	server->credits += add;
-	server->in_flight--;
-	/* blocking lock case */
-	if (optype == 1)
-		server->block_locks--;
-	spin_unlock(&server->req_lock);
+	switch (optype) {
+	case CIFS_ECHO_OP:
+		return &server->echo_credits;
+	case CIFS_OBREAK_OP:
+		return &server->oplock_credits;
+	default:
+		return &server->credits;
+	}
 }
 
-static inline void
-set_credits(struct TCP_Server_Info *server, const int val)
+static inline bool
+has_free_credits(struct TCP_Server_Info *server, unsigned int *val)
 {
+	bool res;
 	spin_lock(&server->req_lock);
-	server->credits = val;
+	res = *val > 0;
 	spin_unlock(&server->req_lock);
+	return res;
 }
 
 /*
@@ -1051,7 +1041,6 @@ GLOBAL_EXTERN unsigned int linuxExtEnabled;/*enable Linux/Unix CIFS extensions*/
 GLOBAL_EXTERN unsigned int CIFSMaxBufSize;  /* max size not including hdr */
 GLOBAL_EXTERN unsigned int cifs_min_rcv;    /* min size of big ntwrk buf pool */
 GLOBAL_EXTERN unsigned int cifs_min_small;  /* min size of small buf pool */
-GLOBAL_EXTERN unsigned int cifs_max_pending; /* MAX requests at once to server*/
 
 #ifdef CONFIG_CIFS_ACL
 GLOBAL_EXTERN struct rb_root uidtree;
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 6f4e243..d029d3a 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -71,7 +71,7 @@ extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
 extern int cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 			   unsigned int nvec, mid_receive_t *receive,
 			   mid_callback_t *callback, void *cbdata,
-			   bool ignore_pend);
+			   int optype);
 extern int SendReceive(const unsigned int /* xid */ , struct cifs_ses *,
 			struct smb_hdr * /* input */ ,
 			struct smb_hdr * /* out */ ,
@@ -169,6 +169,11 @@ extern struct smb_vol *cifs_get_volume_info(char *mount_data,
 extern int cifs_mount(struct cifs_sb_info *, struct smb_vol *);
 extern void cifs_umount(struct cifs_sb_info *);
 extern void cifs_dfs_release_automount_timer(void);
+extern int cifs_reconnect(struct TCP_Server_Info *server);
+extern void add_credits(struct TCP_Server_Info *server, const unsigned int add,
+			const int optype);
+extern void set_credits(struct TCP_Server_Info *server, const unsigned int val,
+			const bool init);
 void cifs_proc_init(void);
 void cifs_proc_clean(void);
 
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index b1040c7..6181efe 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -459,6 +459,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses)
 		}
 		server->sec_mode = (__u8)le16_to_cpu(rsp->SecurityMode);
 		server->maxReq = le16_to_cpu(rsp->MaxMpxCount);
+		set_credits(server, server->maxReq, false);
 		server->maxBuf = le16_to_cpu(rsp->MaxBufSize);
 		server->max_vcs = le16_to_cpu(rsp->MaxNumberVcs);
 		/* even though we do not use raw we might as well set this
@@ -565,6 +566,7 @@ CIFSSMBNegotiate(unsigned int xid, struct cifs_ses *ses)
 	/* one byte, so no need to convert this or EncryptionKeyLen from
 	   little endian */
 	server->maxReq = le16_to_cpu(pSMBr->MaxMpxCount);
+	set_credits(server, server->maxReq, false);
 	/* probably no need to store and check maxvcs */
 	server->maxBuf = le32_to_cpu(pSMBr->MaxBufferSize);
 	server->max_rw = le32_to_cpu(pSMBr->MaxRawSize);
@@ -716,7 +718,7 @@ cifs_echo_callback(struct mid_q_entry *mid)
 	struct TCP_Server_Info *server = mid->callback_data;
 
 	DeleteMidQEntry(mid);
-	add_credits(server, 1, 0);
+	add_credits(server, 1, CIFS_ECHO_OP);
 	wake_up(&server->request_q);
 }
 
@@ -744,7 +746,7 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
 	iov.iov_len = be32_to_cpu(smb->hdr.smb_buf_length) + 4;
 
 	rc = cifs_call_async(server, &iov, 1, NULL, cifs_echo_callback,
-			     server, true);
+			     server, CIFS_ECHO_OP);
 	if (rc)
 		cFYI(1, "Echo request failed: %d", rc);
 
@@ -1725,7 +1727,7 @@ cifs_async_readv(struct cifs_readdata *rdata)
 
 	rc = cifs_call_async(tcon->ses->server, rdata->iov, 1,
 			     cifs_readv_receive, cifs_readv_callback,
-			     rdata, false);
+			     rdata, 0);
 
 	if (rc == 0)
 		cifs_stats_inc(&tcon->num_reads);
@@ -2194,7 +2196,7 @@ cifs_async_writev(struct cifs_writedata *wdata)
 
 	kref_get(&wdata->refcount);
 	rc = cifs_call_async(tcon->ses->server, iov, wdata->nr_pages + 1,
-			     NULL, cifs_writev_callback, wdata, false);
+			     NULL, cifs_writev_callback, wdata, 0);
 
 	if (rc == 0)
 		cifs_stats_inc(&tcon->num_writes);
@@ -2382,7 +2384,7 @@ CIFSSMBLock(const int xid, struct cifs_tcon *tcon,
 		return rc;
 
 	if (lockType == LOCKING_ANDX_OPLOCK_RELEASE) {
-		timeout = CIFS_ASYNC_OP; /* no response expected */
+		timeout = CIFS_ASYNC_OP | CIFS_OBREAK_OP;
 		pSMB->Timeout = 0;
 	} else if (waitFlag) {
 		timeout = CIFS_BLOCKING_OP; /* blocking operation, no timeout */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 79e8c68..93d2fe9 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -78,7 +78,7 @@ static int cifs_setup_volume_info(struct smb_vol *volume_info, char *mount_data,
  * reconnect tcp session
  * wake up waiters on reconnection? - (not needed currently)
  */
-static int
+int
 cifs_reconnect(struct TCP_Server_Info *server)
 {
 	int rc = 0;
@@ -324,7 +324,7 @@ cifs_echo_request(struct work_struct *work)
 	 * done, which is indicated by maxBuf != 0. Also, no need to ping if
 	 * we got a response recently
 	 */
-	if (server->maxBuf == 0 ||
+	if (!server->echos || server->maxBuf == 0 ||
 	    time_before(jiffies, server->lstrp + SMB_ECHO_INTERVAL - HZ))
 		goto requeue_echo;
 
@@ -1901,7 +1901,7 @@ cifs_get_tcp_session(struct smb_vol *volume_info)
 	tcp_ses->noautotune = volume_info->noautotune;
 	tcp_ses->tcp_nodelay = volume_info->sockopt_tcp_nodelay;
 	tcp_ses->in_flight = 0;
-	tcp_ses->credits = cifs_max_pending;
+	tcp_ses->credits = 0;
 	tcp_ses->block_locks = 0;
 	init_waitqueue_head(&tcp_ses->response_q);
 	init_waitqueue_head(&tcp_ses->request_q);
@@ -3752,11 +3752,11 @@ int cifs_negotiate_protocol(unsigned int xid, struct cifs_ses *ses)
 	if (server->maxBuf != 0)
 		return 0;
 
-	set_credits(server, cifs_max_pending);
+	set_credits(server, 1, true);
 	rc = CIFSSMBNegotiate(xid, ses);
 	if (rc == -EAGAIN) {
 		/* retry only once on 1st time connection */
-		set_credits(server, cifs_max_pending);
+		set_credits(server, 1, true);
 		rc = CIFSSMBNegotiate(xid, ses);
 		if (rc == -EAGAIN)
 			rc = -EHOSTDOWN;
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index bc7e244..cc70adb 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -171,7 +171,7 @@ cifs_create(struct inode *inode, struct dentry *direntry, umode_t mode,
 	}
 	tcon = tlink_tcon(tlink);
 
-	if (enable_oplocks)
+	if (tcon->ses->server->oplocks)
 		oplock = REQ_OPLOCK;
 
 	if (nd)
@@ -492,7 +492,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 {
 	int xid;
 	int rc = 0; /* to get around spurious gcc warning, set to zero here */
-	__u32 oplock = enable_oplocks ? REQ_OPLOCK : 0;
+	__u32 oplock;
 	__u16 fileHandle = 0;
 	bool posix_open = false;
 	struct cifs_sb_info *cifs_sb;
@@ -517,6 +517,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 		return (struct dentry *)tlink;
 	}
 	pTcon = tlink_tcon(tlink);
+	oplock = pTcon->ses->server->oplocks ? REQ_OPLOCK : 0;
 
 	/*
 	 * Don't allow the separator character in a path component.
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index c90f7f6..1852b72 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -380,7 +380,7 @@ int cifs_open(struct inode *inode, struct file *file)
 	cFYI(1, "inode = 0x%p file flags are 0x%x for %s",
 		 inode, file->f_flags, full_path);
 
-	if (enable_oplocks)
+	if (tcon->ses->server->oplocks)
 		oplock = REQ_OPLOCK;
 	else
 		oplock = 0;
@@ -505,7 +505,7 @@ static int cifs_reopen_file(struct cifsFileInfo *pCifsFile, bool can_flush)
 	cFYI(1, "inode = 0x%p file flags 0x%x for %s",
 		 inode, pCifsFile->f_flags, full_path);
 
-	if (enable_oplocks)
+	if (tcon->ses->server->oplocks)
 		oplock = REQ_OPLOCK;
 	else
 		oplock = 0;
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 703ef5c..33c68a8 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -690,3 +690,57 @@ backup_cred(struct cifs_sb_info *cifs_sb)
 
 	return false;
 }
+
+static void
+cifs_change_conf(struct TCP_Server_Info *server)
+{
+	server->oplock_credits = server->echo_credits = 0;
+	switch (server->credits) {
+	case 0:
+		cifs_reconnect(server);
+		return;
+	case 1:
+		server->echos = false;
+		server->oplocks = false;
+		cERROR(1, "disabling echos and oplocks");
+		break;
+	case 2:
+		server->echos = true;
+		server->oplocks = false;
+		server->echo_credits = 1;
+		cFYI(1, "disabling oplocks");
+		break;
+	default:
+		server->echos = true;
+		server->oplocks = true;
+		server->echo_credits = 1;
+		server->oplock_credits = 1;
+	}
+	server->credits -= server->echo_credits + server->oplock_credits;
+}
+
+void
+add_credits(struct TCP_Server_Info *server, const unsigned int add,
+	    const int optype)
+{
+	unsigned int *val;
+	spin_lock(&server->req_lock);
+	val = get_credits_field(server, optype);
+	*val += add;
+	server->in_flight--;
+	/* blocking lock case */
+	if (optype == CIFS_BLOCKING_OP)
+		server->block_locks--;
+	spin_unlock(&server->req_lock);
+}
+
+void
+set_credits(struct TCP_Server_Info *server, const unsigned int val,
+	    const bool init)
+{
+	spin_lock(&server->req_lock);
+	server->credits = val;
+	if (!init)
+		cifs_change_conf(server);
+	spin_unlock(&server->req_lock);
+}
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 6a8378b..d77ee0c 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -255,51 +255,46 @@ smb_send(struct TCP_Server_Info *server, struct smb_hdr *smb_buffer,
 }
 
 static int
-wait_for_free_request(struct TCP_Server_Info *server, const int long_op)
+wait_for_free_credits(struct TCP_Server_Info *server, unsigned int *num)
 {
 	int rc;
 
-	spin_lock(&server->req_lock);
-
-	if (long_op == CIFS_ASYNC_OP) {
-		/* oplock breaks must not be held up */
-		server->in_flight++;
-		server->credits--;
-		spin_unlock(&server->req_lock);
-		return 0;
-	}
-
-	/* we can't leave the client without available credits */
-	if (long_op == CIFS_BLOCKING_OP &&
-	    (server->block_locks >= (server->in_flight + server->credits) / 2))
-		return -ENOLCK;
-
 	while (1) {
-		if (server->credits <= 0) {
+		if (*num == 0) {
 			spin_unlock(&server->req_lock);
 			cifs_num_waiters_inc(server);
 			rc = wait_event_killable(server->request_q,
-						 get_credits(server) > 0);
+						 has_free_credits(server, num));
 			cifs_num_waiters_dec(server);
 			if (rc)
 				return rc;
 			spin_lock(&server->req_lock);
 		} else {
-			if (server->tcpStatus == CifsExiting) {
-				spin_unlock(&server->req_lock);
+			if (server->tcpStatus == CifsExiting)
 				return -ENOENT;
-			}
-			server->credits--;
+			*num -= 1;
 			server->in_flight++;
-			if (long_op == CIFS_BLOCKING_OP)
-				server->block_locks++;
-			spin_unlock(&server->req_lock);
 			break;
 		}
 	}
 	return 0;
 }
 
+static int
+wait_for_free_request(struct TCP_Server_Info *server, const int optype)
+{
+	int rc;
+	spin_lock(&server->req_lock);
+	if (optype == CIFS_BLOCKING_OP &&
+	    (server->block_locks >= (server->in_flight + server->credits) / 2))
+		return -ENOLCK;
+	rc = wait_for_free_credits(server, get_credits_field(server, optype));
+	if (optype == CIFS_BLOCKING_OP)
+		server->block_locks++;
+	spin_unlock(&server->req_lock);
+	return rc;
+}
+
 static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,
 			struct mid_q_entry **ppmidQ)
 {
@@ -349,13 +344,13 @@ wait_for_response(struct TCP_Server_Info *server, struct mid_q_entry *midQ)
 int
 cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 		unsigned int nvec, mid_receive_t *receive,
-		mid_callback_t *callback, void *cbdata, bool ignore_pend)
+		mid_callback_t *callback, void *cbdata, int optype)
 {
 	int rc;
 	struct mid_q_entry *mid;
 	struct smb_hdr *hdr = (struct smb_hdr *)iov[0].iov_base;
 
-	rc = wait_for_free_request(server, ignore_pend ? CIFS_ASYNC_OP : 0);
+	rc = wait_for_free_request(server, optype);
 	if (rc)
 		return rc;
 
@@ -367,7 +362,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 	mid = AllocMidQEntry(hdr, server);
 	if (mid == NULL) {
 		mutex_unlock(&server->srv_mutex);
-		add_credits(server, 1, 0);
+		add_credits(server, 1, optype);
 		wake_up(&server->request_q);
 		return -ENOMEM;
 	}
@@ -400,7 +395,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 	return rc;
 out_err:
 	delete_mid(mid);
-	add_credits(server, 1, 0);
+	add_credits(server, 1, optype);
 	wake_up(&server->request_q);
 	return rc;
 }
@@ -533,10 +528,12 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 {
 	int rc = 0;
 	int long_op;
+	int optype;
 	struct mid_q_entry *midQ;
 	struct smb_hdr *in_buf = iov[0].iov_base;
 
 	long_op = flags & CIFS_TIMEOUT_MASK;
+	optype = flags & CIFS_REQ_MASK;
 
 	*pRespBufType = CIFS_NO_BUFFER;  /* no response buf yet */
 
@@ -555,7 +552,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	   to the same server. We may make this configurable later or
 	   use ses->maxReq */
 
-	rc = wait_for_free_request(ses->server, long_op);
+	rc = wait_for_free_request(ses->server, optype);
 	if (rc) {
 		cifs_small_buf_release(in_buf);
 		return rc;
@@ -572,7 +569,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		mutex_unlock(&ses->server->srv_mutex);
 		cifs_small_buf_release(in_buf);
 		/* Update # of requests on wire to server */
-		add_credits(ses->server, 1, 0);
+		add_credits(ses->server, 1, optype);
 		wake_up(&ses->server->request_q);
 		return rc;
 	}
@@ -609,7 +606,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 			midQ->callback = DeleteMidQEntry;
 			spin_unlock(&GlobalMid_Lock);
 			cifs_small_buf_release(in_buf);
-			add_credits(ses->server, 1, 0);
+			add_credits(ses->server, 1, optype);
 			wake_up(&ses->server->request_q);
 			return rc;
 		}
@@ -620,7 +617,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 
 	rc = cifs_sync_mid_result(midQ, ses->server);
 	if (rc != 0) {
-		add_credits(ses->server, 1, 0);
+		add_credits(ses->server, 1, optype);
 		wake_up(&ses->server->request_q);
 		return rc;
 	}
@@ -645,7 +642,7 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 		midQ->resp_buf = NULL;
 out:
 	delete_mid(midQ);
-	add_credits(ses->server, 1, 0);
+	add_credits(ses->server, 1, optype);
 	wake_up(&ses->server->request_q);
 
 	return rc;
@@ -682,7 +679,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 		return -EIO;
 	}
 
-	rc = wait_for_free_request(ses->server, long_op);
+	rc = wait_for_free_request(ses->server, 0);
 	if (rc)
 		return rc;
 
-- 
1.7.1
