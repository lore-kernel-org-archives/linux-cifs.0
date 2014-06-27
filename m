From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 10/16] CIFS: Use multicredits for SMB 2.1/3 writes
Date: Fri, 27 Jun 2014 13:57:47 +0400
Message-ID: <1403863073-19526-11-git-send-email-pshilovsky@samba.org>
References: <1403863073-19526-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403863073-19526-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If we negotiate SMB 2.1 and higher version of the protocol and
a server supports large write buffer size, we need to consume 1
credit per 65536 bytes. So, we need to know how many credits
we have and obtain the required number of them before constructing
a writedata structure in writepages and iovec write.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h      | 15 ++++++++++++++
 fs/cifs/cifsproto.h     |  3 +++
 fs/cifs/file.c          | 38 ++++++++++++++++++++++++++++++------
 fs/cifs/smb1ops.c       |  1 +
 fs/cifs/smb2ops.c       | 52 +++++++++++++++++++++++++++++++++++++++++++++++--
 fs/cifs/smb2pdu.c       | 29 +++++++++++++++++++++++----
 fs/cifs/smb2transport.c |  5 +++++
 fs/cifs/transport.c     | 25 +++++++++++++++++-------
 8 files changed, 149 insertions(+), 19 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 8c53f20..54ca2b9 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -406,6 +406,9 @@ struct smb_version_operations {
 			int);
 	/* writepages retry size */
 	unsigned int (*wp_retry_size)(struct inode *);
+	/* get mtu credits */
+	int (*wait_mtu_credits)(struct TCP_Server_Info *, unsigned int,
+				unsigned int *, unsigned int *);
 };
 
 struct smb_version_values {
@@ -642,6 +645,16 @@ add_credits(struct TCP_Server_Info *server, const unsigned int add,
 }
 
 static inline void
+add_credits_and_wake_if(struct TCP_Server_Info *server, const unsigned int add,
+			const int optype)
+{
+	if (add) {
+		server->ops->add_credits(server, add, optype);
+		wake_up(&server->request_q);
+	}
+}
+
+static inline void
 set_credits(struct TCP_Server_Info *server, const int val)
 {
 	server->ops->set_credits(server, val);
@@ -1075,6 +1088,7 @@ struct cifs_writedata {
 	int				result;
 	unsigned int			pagesz;
 	unsigned int			tailsz;
+	unsigned int			credits;
 	unsigned int			nr_pages;
 	struct page			*pages[];
 };
@@ -1400,6 +1414,7 @@ static inline void free_dfs_info_array(struct dfs_info3_param *param,
 #define   CIFS_OBREAK_OP   0x0100    /* oplock break request */
 #define   CIFS_NEG_OP      0x0200    /* negotiate request */
 #define   CIFS_OP_MASK     0x0380    /* mask request type */
+#define   CIFS_HAS_CREDITS 0x0400    /* already has credits */
 
 /* Security Flags: indicate type of session setup needed */
 #define   CIFSSEC_MAY_SIGN	0x00001
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index de49d7a..c31ce98 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -90,6 +90,9 @@ extern struct mid_q_entry *cifs_setup_async_request(struct TCP_Server_Info *,
 						struct smb_rqst *);
 extern int cifs_check_receive(struct mid_q_entry *mid,
 			struct TCP_Server_Info *server, bool log_error);
+extern int cifs_wait_mtu_credits(struct TCP_Server_Info *server,
+				 unsigned int size, unsigned int *num,
+				 unsigned int *credits);
 extern int SendReceive2(const unsigned int /* xid */ , struct cifs_ses *,
 			struct kvec *, int /* nvec to send */,
 			int * /* type of buf returned */ , const int flags);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index f661977..2e49a17 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1670,8 +1670,8 @@ cifs_write(struct cifsFileInfo *open_file, __u32 pid, const char *write_data,
 					break;
 			}
 
-			len = min((size_t)cifs_sb->wsize,
-				  write_size - total_written);
+			len = min(server->ops->wp_retry_size(dentry->d_inode),
+				  (unsigned int)write_size - total_written);
 			/* iov[0] is reserved for smb header */
 			iov[1].iov_base = (char *)write_data + total_written;
 			iov[1].iov_len = len;
@@ -2046,6 +2046,7 @@ static int cifs_writepages(struct address_space *mapping,
 			   struct writeback_control *wbc)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(mapping->host->i_sb);
+	struct TCP_Server_Info *server;
 	bool done = false, scanned = false, range_whole = false;
 	pgoff_t end, index;
 	struct cifs_writedata *wdata;
@@ -2068,23 +2069,30 @@ static int cifs_writepages(struct address_space *mapping,
 			range_whole = true;
 		scanned = true;
 	}
+	server = cifs_sb_master_tcon(cifs_sb)->ses->server;
 retry:
 	while (!done && index <= end) {
-		unsigned int nr_pages, found_pages;
+		unsigned int nr_pages, found_pages, wsize, credits;
 		pgoff_t next = 0, tofind, saved_index = index;
 
-		tofind = min((cifs_sb->wsize / PAGE_CACHE_SIZE) - 1,
-				end - index) + 1;
+		rc = server->ops->wait_mtu_credits(server, cifs_sb->wsize,
+						   &wsize, &credits);
+		if (rc)
+			break;
+
+		tofind = min((wsize / PAGE_CACHE_SIZE) - 1, end - index) + 1;
 
 		wdata = wdata_alloc_and_fillpages(tofind, mapping, end, &index,
 						  &found_pages);
 		if (!wdata) {
 			rc = -ENOMEM;
+			add_credits_and_wake_if(server, credits, 0);
 			break;
 		}
 
 		if (found_pages == 0) {
 			kref_put(&wdata->refcount, cifs_writedata_release);
+			add_credits_and_wake_if(server, credits, 0);
 			break;
 		}
 
@@ -2094,10 +2102,16 @@ retry:
 		/* nothing to write? */
 		if (nr_pages == 0) {
 			kref_put(&wdata->refcount, cifs_writedata_release);
+			add_credits_and_wake_if(server, credits, 0);
 			continue;
 		}
 
+		wdata->credits = credits;
+
 		rc = wdata_send_pages(wdata, nr_pages, mapping, wbc);
+		if (rc)
+			add_credits_and_wake_if(server, wdata->credits, 0);
+
 		kref_put(&wdata->refcount, cifs_writedata_release);
 
 		if (wbc->sync_mode == WB_SYNC_ALL && rc == -EAGAIN) {
@@ -2469,17 +2483,26 @@ cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
 	memcpy(&saved_from, from, sizeof(struct iov_iter));
 
 	do {
-		nr_pages = get_numpages(cifs_sb->wsize, len, &cur_len);
+		unsigned int wsize, credits;
+
+		rc = server->ops->wait_mtu_credits(server, cifs_sb->wsize,
+						   &wsize, &credits);
+		if (rc)
+			break;
+
+		nr_pages = get_numpages(wsize, len, &cur_len);
 		wdata = cifs_writedata_alloc(nr_pages,
 					     cifs_uncached_writev_complete);
 		if (!wdata) {
 			rc = -ENOMEM;
+			add_credits_and_wake_if(server, credits, 0);
 			break;
 		}
 
 		rc = cifs_write_allocate_pages(wdata->pages, nr_pages);
 		if (rc) {
 			kfree(wdata);
+			add_credits_and_wake_if(server, credits, 0);
 			break;
 		}
 
@@ -2488,6 +2511,7 @@ cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
 			for (i = 0; i < nr_pages; i++)
 				put_page(wdata->pages[i]);
 			kfree(wdata);
+			add_credits_and_wake_if(server, credits, 0);
 			break;
 		}
 
@@ -2499,12 +2523,14 @@ cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
 		wdata->bytes = cur_len;
 		wdata->pagesz = PAGE_SIZE;
 		wdata->tailsz = cur_len - ((nr_pages - 1) * PAGE_SIZE);
+		wdata->credits = credits;
 
 		if (!wdata->cfile->invalidHandle ||
 		    !cifs_reopen_file(wdata->cfile, false))
 			rc = server->ops->async_writev(wdata,
 					cifs_uncached_writedata_release);
 		if (rc) {
+			add_credits_and_wake_if(server, wdata->credits, 0);
 			kref_put(&wdata->refcount,
 				 cifs_uncached_writedata_release);
 			if (rc == -EAGAIN) {
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 8a96342..5e8c22d 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -1025,6 +1025,7 @@ struct smb_version_operations smb1_operations = {
 	.set_credits = cifs_set_credits,
 	.get_credits_field = cifs_get_credits_field,
 	.get_credits = cifs_get_credits,
+	.wait_mtu_credits = cifs_wait_mtu_credits,
 	.get_next_mid = cifs_get_next_mid,
 	.read_data_offset = cifs_read_data_offset,
 	.read_data_length = cifs_read_data_length,
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index e35ce5b..fecc2de 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -112,6 +112,53 @@ smb2_get_credits(struct mid_q_entry *mid)
 	return le16_to_cpu(((struct smb2_hdr *)mid->resp_buf)->CreditRequest);
 }
 
+static int
+smb2_wait_mtu_credits(struct TCP_Server_Info *server, unsigned int size,
+		      unsigned int *num, unsigned int *credits)
+{
+	int rc = 0;
+	unsigned int scredits;
+
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
+			scredits = server->credits;
+			/* can deadlock with reopen */
+			if (scredits == 1) {
+				*num = SMB2_MAX_BUFFER_SIZE;
+				*credits = 0;
+				break;
+			}
+
+			/* leave one credit for a possible reopen */
+			scredits--;
+			*num = min_t(unsigned int, size,
+				     scredits * SMB2_MAX_BUFFER_SIZE);
+
+			*credits = DIV_ROUND_UP(*num, SMB2_MAX_BUFFER_SIZE);
+			server->credits -= *credits;
+			server->in_flight++;
+			break;
+		}
+	}
+	spin_unlock(&server->req_lock);
+	return rc;
+}
+
 static __u64
 smb2_get_next_mid(struct TCP_Server_Info *server)
 {
@@ -182,8 +229,6 @@ smb2_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
 	/* start with specified wsize, or default */
 	wsize = volume_info->wsize ? volume_info->wsize : CIFS_DEFAULT_IOSIZE;
 	wsize = min_t(unsigned int, wsize, server->max_write);
-	/* set it to the maximum buffer size value we can send with 1 credit */
-	wsize = min_t(unsigned int, wsize, SMB2_MAX_BUFFER_SIZE);
 
 	return wsize;
 }
@@ -1120,6 +1165,7 @@ struct smb_version_operations smb20_operations = {
 	.set_credits = smb2_set_credits,
 	.get_credits_field = smb2_get_credits_field,
 	.get_credits = smb2_get_credits,
+	.wait_mtu_credits = cifs_wait_mtu_credits,
 	.get_next_mid = smb2_get_next_mid,
 	.read_data_offset = smb2_read_data_offset,
 	.read_data_length = smb2_read_data_length,
@@ -1196,6 +1242,7 @@ struct smb_version_operations smb21_operations = {
 	.set_credits = smb2_set_credits,
 	.get_credits_field = smb2_get_credits_field,
 	.get_credits = smb2_get_credits,
+	.wait_mtu_credits = smb2_wait_mtu_credits,
 	.get_next_mid = smb2_get_next_mid,
 	.read_data_offset = smb2_read_data_offset,
 	.read_data_length = smb2_read_data_length,
@@ -1272,6 +1319,7 @@ struct smb_version_operations smb30_operations = {
 	.set_credits = smb2_set_credits,
 	.get_credits_field = smb2_get_credits_field,
 	.get_credits = smb2_get_credits,
+	.wait_mtu_credits = smb2_wait_mtu_credits,
 	.get_next_mid = smb2_get_next_mid,
 	.read_data_offset = smb2_read_data_offset,
 	.read_data_length = smb2_read_data_length,
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index da7aa62..b0c89ef 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1892,15 +1892,25 @@ int
 smb2_async_writev(struct cifs_writedata *wdata,
 		  void (*release)(struct kref *kref))
 {
-	int rc = -EACCES;
+	int rc = -EACCES, flags = 0;
 	struct smb2_write_req *req = NULL;
 	struct cifs_tcon *tcon = tlink_tcon(wdata->cfile->tlink);
+	struct TCP_Server_Info *server = tcon->ses->server;
 	struct kvec iov;
 	struct smb_rqst rqst;
 
 	rc = small_smb2_init(SMB2_WRITE, tcon, (void **) &req);
-	if (rc)
+	if (rc) {
+		if (rc == -EAGAIN && wdata->credits) {
+			/* credits was reseted by reconnect */
+			wdata->credits = 0;
+			/* reduce in_flight value since we won't send the req */
+			spin_lock(&server->req_lock);
+			server->in_flight--;
+			spin_unlock(&server->req_lock);
+		}
 		goto async_writev_out;
+	}
 
 	req->hdr.ProcessId = cpu_to_le32(wdata->cfile->pid);
 
@@ -1933,9 +1943,20 @@ smb2_async_writev(struct cifs_writedata *wdata,
 
 	inc_rfc1001_len(&req->hdr, wdata->bytes - 1 /* Buffer */);
 
+	if (wdata->credits) {
+		req->hdr.CreditCharge = cpu_to_le16(DIV_ROUND_UP(wdata->bytes,
+						    SMB2_MAX_BUFFER_SIZE));
+		spin_lock(&server->req_lock);
+		server->credits += wdata->credits -
+					le16_to_cpu(req->hdr.CreditCharge);
+		spin_unlock(&server->req_lock);
+		wake_up(&server->request_q);
+		flags = CIFS_HAS_CREDITS;
+	}
+
 	kref_get(&wdata->refcount);
-	rc = cifs_call_async(tcon->ses->server, &rqst, NULL,
-				smb2_writev_callback, wdata, 0);
+	rc = cifs_call_async(server, &rqst, NULL, smb2_writev_callback, wdata,
+			     flags);
 
 	if (rc) {
 		kref_put(&wdata->refcount, release);
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 59c748c..5111e72 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -466,7 +466,12 @@ smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 static inline void
 smb2_seq_num_into_buf(struct TCP_Server_Info *server, struct smb2_hdr *hdr)
 {
+	unsigned int i, num = le16_to_cpu(hdr->CreditCharge);
+
 	hdr->MessageId = get_next_mid64(server);
+	/* skip message numbers according to CreditCharge field */
+	for (i = 1; i < num; i++)
+		get_next_mid(server);
 }
 
 static struct mid_q_entry *
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 18cd565..9d087f4 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -448,6 +448,15 @@ wait_for_free_request(struct TCP_Server_Info *server, const int timeout,
 	return wait_for_free_credits(server, timeout, val);
 }
 
+int
+cifs_wait_mtu_credits(struct TCP_Server_Info *server, unsigned int size,
+		      unsigned int *num, unsigned int *credits)
+{
+	*num = size;
+	*credits = 0;
+	return 0;
+}
+
 static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,
 			struct mid_q_entry **ppmidQ)
 {
@@ -531,20 +540,23 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 {
 	int rc, timeout, optype;
 	struct mid_q_entry *mid;
+	unsigned int credits = 0;
 
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
+	}
 
 	mutex_lock(&server->srv_mutex);
 	mid = server->ops->setup_async_request(server, rqst);
 	if (IS_ERR(mid)) {
 		mutex_unlock(&server->srv_mutex);
-		add_credits(server, 1, optype);
-		wake_up(&server->request_q);
+		add_credits_and_wake_if(server, credits, optype);
 		return PTR_ERR(mid);
 	}
 
@@ -572,8 +584,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 		return 0;
 
 	cifs_delete_mid(mid);
-	add_credits(server, 1, optype);
-	wake_up(&server->request_q);
+	add_credits_and_wake_if(server, credits, optype);
 	return rc;
 }
 
-- 
1.8.1.2
