From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 08/10] CIFS: Make use of multicredit write for SMB2
Date: Mon, 20 Aug 2012 22:42:58 +0400
Message-ID: <1345488180-5942-9-git-send-email-pshilovsky@samba.org>
References: <1345488180-5942-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1345488180-5942-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h      |    7 ++++++
 fs/cifs/cifsproto.h     |    3 ++
 fs/cifs/cifssmb.c       |    7 ++++-
 fs/cifs/file.c          |   33 ++++++++++++++++++++++++++++---
 fs/cifs/smb1ops.c       |    8 +++++++
 fs/cifs/smb2ops.c       |   48 ++++++++++++++++++++++++++++++++++++++++++----
 fs/cifs/smb2pdu.c       |   14 +++++++++++-
 fs/cifs/smb2transport.c |    4 +++
 fs/cifs/transport.c     |   29 +++++++++++++++++++++++----
 9 files changed, 135 insertions(+), 18 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 3155080..3e5ab4e 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -367,6 +367,11 @@ struct smb_version_operations {
 	void (*set_lease_key)(struct inode *, struct cifs_fid *fid);
 	/* generate new lease key */
 	void (*new_lease_key)(struct cifs_fid *fid);
+	/* get mtu credits */
+	int (*wait_mtu_credits)(struct TCP_Server_Info *, unsigned int,
+				unsigned int *, unsigned int *);
+	/* how many credits a packet charge */
+	unsigned int (*get_credit_size)(char *);
 };
 
 struct smb_version_values {
@@ -983,6 +988,7 @@ struct cifs_writedata {
 	int				result;
 	unsigned int			pagesz;
 	unsigned int			tailsz;
+	unsigned int			credits;
 	unsigned int			nr_pages;
 	struct page			*pages[1];
 };
@@ -1303,6 +1309,7 @@ static inline void free_dfs_info_array(struct dfs_info3_param *param,
 #define   CIFS_OBREAK_OP   0x0100    /* oplock break request */
 #define   CIFS_NEG_OP      0x0200    /* negotiate request */
 #define   CIFS_OP_MASK     0x0380    /* mask request type */
+#define   CIFS_HAS_CREDITS 0x0400    /* already has credits */
 
 /* Security Flags: indicate type of session setup needed */
 #define   CIFSSEC_MAY_SIGN	0x00001
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 15e38dc..5411857 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -86,6 +86,9 @@ extern struct mid_q_entry *cifs_setup_async_request(struct TCP_Server_Info *,
 						struct smb_rqst *);
 extern int cifs_check_receive(struct mid_q_entry *mid,
 			struct TCP_Server_Info *server, bool log_error);
+extern int cifs_wait_mtu_credits(struct TCP_Server_Info *server,
+				 unsigned int size, unsigned int *num,
+				 unsigned int *credits);
 extern int SendReceive2(const unsigned int /* xid */ , struct cifs_ses *,
 			struct kvec *, int /* nvec to send */,
 			int * /* type of buf returned */ , const int flags);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 88bbb3e..75e9c87 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2025,7 +2025,7 @@ cifs_writev_callback(struct mid_q_entry *mid)
 int
 cifs_async_writev(struct cifs_writedata *wdata)
 {
-	int rc = -EACCES;
+	int rc = -EACCES, flags = 0;
 	WRITE_REQ *smb = NULL;
 	int wct;
 	struct cifs_tcon *tcon = tlink_tcon(wdata->cfile->tlink);
@@ -2089,9 +2089,12 @@ cifs_async_writev(struct cifs_writedata *wdata)
 		iov.iov_len += 4; /* pad bigger by four bytes */
 	}
 
+	if (wdata->credits)
+		flags = CIFS_HAS_CREDITS;
+
 	kref_get(&wdata->refcount);
 	rc = cifs_call_async(tcon->ses->server, &rqst, NULL,
-				cifs_writev_callback, wdata, 0);
+			     cifs_writev_callback, wdata, flags);
 
 	if (rc == 0)
 		cifs_stats_inc(&tcon->stats.cifs_stats.num_writes);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index af4a832..99c7532 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1781,20 +1781,29 @@ static int cifs_writepages(struct address_space *mapping,
 	}
 retry:
 	while (!done && index <= end) {
-		unsigned int i, nr_pages, found_pages;
+		unsigned int i, nr_pages, found_pages, wsize, credits;
 		pgoff_t next = 0, tofind;
 		struct page **pages;
 
-		tofind = min((cifs_sb->wsize / PAGE_CACHE_SIZE) - 1,
-				end - index) + 1;
+		server = cifs_sb_master_tcon(cifs_sb)->ses->server;
+		rc = server->ops->wait_mtu_credits(server, cifs_sb->wsize,
+						   &wsize, &credits);
+		if (rc)
+			break;
+
+		tofind = min((wsize / PAGE_CACHE_SIZE) - 1, end - index) + 1;
 
 		wdata = cifs_writedata_alloc((unsigned int)tofind,
 					     cifs_writev_complete);
 		if (!wdata) {
 			rc = -ENOMEM;
+			add_credits(server, credits, 0);
+			wake_up(&server->request_q);
 			break;
 		}
 
+		wdata->credits = credits;
+
 		/*
 		 * find_get_pages_tag seems to return a max of 256 on each
 		 * iteration, so we must call it several times in order to
@@ -1814,6 +1823,8 @@ retry:
 
 		if (found_pages == 0) {
 			kref_put(&wdata->refcount, cifs_writedata_release);
+			add_credits(server, credits, 0);
+			wake_up(&server->request_q);
 			break;
 		}
 
@@ -1890,6 +1901,8 @@ retry:
 		/* nothing to write? */
 		if (nr_pages == 0) {
 			kref_put(&wdata->refcount, cifs_writedata_release);
+			add_credits(server, credits, 0);
+			wake_up(&server->request_q);
 			continue;
 		}
 
@@ -2259,6 +2272,7 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 	struct iov_iter it;
 	struct cifsFileInfo *open_file;
 	struct cifs_tcon *tcon;
+	struct TCP_Server_Info *server;
 	struct cifs_sb_info *cifs_sb;
 	struct cifs_writedata *wdata, *tmp;
 	struct list_head wdata_list;
@@ -2291,18 +2305,29 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 	iov_iter_init(&it, iov, nr_segs, len, 0);
 	do {
 		size_t save_len;
+		unsigned int wsize, credits;
+
+		server = tcon->ses->server;
+		rc = server->ops->wait_mtu_credits(server, cifs_sb->wsize,
+						   &wsize, &credits);
 
-		nr_pages = get_numpages(cifs_sb->wsize, len, &cur_len);
+		nr_pages = get_numpages(wsize, len, &cur_len);
 		wdata = cifs_writedata_alloc(nr_pages,
 					     cifs_uncached_writev_complete);
 		if (!wdata) {
 			rc = -ENOMEM;
+			add_credits(server, credits, 0);
+			wake_up(&server->request_q);
 			break;
 		}
 
+		wdata->credits = credits;
+
 		rc = cifs_write_allocate_pages(wdata->pages, nr_pages);
 		if (rc) {
 			kfree(wdata);
+			add_credits(server, credits, 0);
+			wake_up(&server->request_q);
 			break;
 		}
 
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 5fb0fe5..7e34bd1 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -134,6 +134,12 @@ cifs_get_credits(struct mid_q_entry *mid)
 	return 1;
 }
 
+static unsigned int
+cifs_get_credit_size(char *buf)
+{
+	return 1;
+}
+
 /*
  * Find a free multiplex id (SMB mid). Otherwise there could be
  * mid collisions which might cause problems, demultiplexing the
@@ -918,6 +924,8 @@ struct smb_version_operations smb1_operations = {
 	.set_credits = cifs_set_credits,
 	.get_credits_field = cifs_get_credits_field,
 	.get_credits = cifs_get_credits,
+	.wait_mtu_credits = cifs_wait_mtu_credits,
+	.get_credit_size = cifs_get_credit_size,
 	.get_next_mid = cifs_get_next_mid,
 	.read_data_offset = cifs_read_data_offset,
 	.read_data_length = cifs_read_data_length,
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 6a11190..8b93f03 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -111,6 +111,47 @@ smb2_get_credits(struct mid_q_entry *mid)
 	return le16_to_cpu(((struct smb2_hdr *)mid->resp_buf)->CreditRequest);
 }
 
+static int
+smb2_wait_mtu_credits(struct TCP_Server_Info *server, unsigned int size,
+		      unsigned int *num, unsigned int *credits)
+{
+	int rc = 0;
+	spin_lock(&server->req_lock);
+	while (1) {
+		if (server->credits <= 0) {
+			spin_unlock(&server->req_lock);
+			cifs_num_waiters_inc(server);
+			rc = wait_event_killable(server->request_q,
+					has_credits(server, &server->credits));
+			cifs_num_waiters_dec(server);
+			if (rc)
+				return rc;
+			spin_lock(&server->req_lock);
+		} else {
+			if (server->tcpStatus == CifsExiting) {
+				spin_unlock(&server->req_lock);
+				return -ENOENT;
+			}
+
+			*num = min_t(unsigned int, server->credits * (2 << 15),
+				     size);
+
+			*credits = DIV_ROUND_UP(*num, 2 << 15);
+			server->credits -= *credits;
+			server->in_flight++;
+			break;
+		}
+	}
+	spin_unlock(&server->req_lock);
+	return rc;
+}
+
+static unsigned int
+smb2_get_credit_size(char *buf)
+{
+	return le16_to_cpu(((struct smb2_hdr *)buf)->CreditCharge);
+}
+
 static __u64
 smb2_get_next_mid(struct TCP_Server_Info *server)
 {
@@ -181,11 +222,6 @@ smb2_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
 	/* start with specified wsize, or default */
 	wsize = volume_info->wsize ? volume_info->wsize : CIFS_DEFAULT_IOSIZE;
 	wsize = min_t(unsigned int, wsize, server->max_write);
-	/*
-	 * limit write size to 2 ** 16, because we don't support multicredit
-	 * requests now.
-	 */
-	wsize = min_t(unsigned int, wsize, 2 << 15);
 
 	return wsize;
 }
@@ -586,6 +622,8 @@ struct smb_version_operations smb21_operations = {
 	.set_credits = smb2_set_credits,
 	.get_credits_field = smb2_get_credits_field,
 	.get_credits = smb2_get_credits,
+	.wait_mtu_credits = smb2_wait_mtu_credits,
+	.get_credit_size = smb2_get_credit_size,
 	.get_next_mid = smb2_get_next_mid,
 	.read_data_offset = smb2_read_data_offset,
 	.read_data_length = smb2_read_data_length,
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 8466031..6fc41b8 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -103,6 +103,7 @@ smb2_hdr_assemble(struct smb2_hdr *hdr, __le16 smb2_cmd /* command */ ,
 	hdr->StructureSize = cpu_to_le16(64);
 	hdr->Command = smb2_cmd;
 	hdr->CreditRequest = cpu_to_le16(2); /* BB make this dynamic */
+	hdr->CreditCharge = cpu_to_le16(1);
 	hdr->ProcessId = cpu_to_le32((__u16)current->tgid);
 
 	if (!tcon)
@@ -1595,7 +1596,7 @@ smb2_writev_callback(struct mid_q_entry *mid)
 int
 smb2_async_writev(struct cifs_writedata *wdata)
 {
-	int rc = -EACCES;
+	int rc = -EACCES, flags = 0;
 	struct smb2_write_req *req = NULL;
 	struct cifs_tcon *tcon = tlink_tcon(wdata->cfile->tlink);
 	struct kvec iov;
@@ -1635,9 +1636,18 @@ smb2_async_writev(struct cifs_writedata *wdata)
 
 	inc_rfc1001_len(&req->hdr, wdata->bytes - 1 /* Buffer */);
 
+	if (wdata->credits) {
+		req->hdr.CreditCharge =
+			cpu_to_le16(DIV_ROUND_UP(wdata->bytes, 2 << 15));
+		add_credits(tcon->ses->server,
+			wdata->credits - le16_to_cpu(req->hdr.CreditCharge), 0);
+		wake_up(&tcon->ses->server->request_q);
+		flags = CIFS_HAS_CREDITS;
+	}
+
 	kref_get(&wdata->refcount);
 	rc = cifs_call_async(tcon->ses->server, &rqst, NULL,
-				smb2_writev_callback, wdata, 0);
+			     smb2_writev_callback, wdata, flags);
 
 	if (rc)
 		kref_put(&wdata->refcount, cifs_writedata_release);
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 2a5fdf2..6e6b51a 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -188,7 +188,11 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 static inline void
 smb2_seq_num_into_buf(struct TCP_Server_Info *server, struct smb2_hdr *hdr)
 {
+	int i, num = le16_to_cpu(hdr->CreditCharge);
 	hdr->MessageId = get_next_mid(server);
+	/* skip message numbers according to CreditCharge field */
+	for (i = 1; i < num; i++)
+		get_next_mid(server);
 }
 
 static struct mid_q_entry *
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 0844b03..ca7a427 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -413,6 +413,19 @@ wait_for_free_request(struct TCP_Server_Info *server, const int timeout,
 				server->ops->get_credits_field(server, optype));
 }
 
+int
+cifs_wait_mtu_credits(struct TCP_Server_Info *server, unsigned int size,
+		      unsigned int *num, unsigned int *credits)
+{
+	int rc;
+	rc = wait_for_free_request(server, 0, 0);
+	if (rc)
+		return rc;
+	*num = size;
+	*credits = 1;
+	return rc;
+}
+
 static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,
 			struct mid_q_entry **ppmidQ)
 {
@@ -489,19 +502,25 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 {
 	int rc, timeout, optype;
 	struct mid_q_entry *mid;
+	unsigned int credits;
 
 	timeout = flags & CIFS_TIMEOUT_MASK;
 	optype = flags & CIFS_OP_MASK;
 
-	rc = wait_for_free_request(server, timeout, optype);
-	if (rc)
-		return rc;
+	if ((flags & CIFS_HAS_CREDITS) == 0) {
+		rc = wait_for_free_request(server, timeout, optype);
+		if (rc)
+			return rc;
+		credits = 1;
+	} else
+		credits = server->ops->get_credit_size(
+						rqst->rq_iov[0].iov_base);
 
 	mutex_lock(&server->srv_mutex);
 	mid = server->ops->setup_async_request(server, rqst);
 	if (IS_ERR(mid)) {
 		mutex_unlock(&server->srv_mutex);
-		add_credits(server, 1, optype);
+		add_credits(server, credits, optype);
 		wake_up(&server->request_q);
 		return PTR_ERR(mid);
 	}
@@ -527,7 +546,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 		return 0;
 
 	cifs_delete_mid(mid);
-	add_credits(server, 1, optype);
+	add_credits(server, credits, optype);
 	wake_up(&server->request_q);
 	return rc;
 }
-- 
1.7.1
