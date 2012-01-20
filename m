From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 31/50] CIFS: Add writepages support for SMB2
Date: Fri, 20 Jan 2012 12:34:52 +0400
Message-ID: <1327048511-2342-31-git-send-email-piastry@etersoft.ru>
References: <1327048511-2342-1-git-send-email-piastry@etersoft.ru>
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1327048511-2342-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsglob.h      |   17 +++++++
 fs/cifs/cifsproto.h     |   17 ++-----
 fs/cifs/cifssmb.c       |    5 +-
 fs/cifs/file.c          |   14 ++++-
 fs/cifs/smb2file.c      |   10 +++-
 fs/cifs/smb2pdu.c       |  123 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2proto.h     |   11 ++++
 fs/cifs/smb2transport.c |   65 ++++++++++++++++++++++++-
 8 files changed, 240 insertions(+), 22 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 31cce8e..74c723b 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -593,6 +593,23 @@ typedef int (reopen_callback_t)(struct cifsFileInfo *cifs_file, int xid,
 				 struct cifs_tcon *tcon, const char *full_path,
 				 __u32 *oplock);
 
+struct cifs_writedata;
+typedef int (awritev_callback_t)(struct cifs_writedata *);
+
+/* asynchronous write support */
+struct cifs_writedata {
+	struct kref			refcount;
+	enum writeback_sync_modes	sync_mode;
+	struct work_struct		work;
+	awritev_callback_t		*requeue_writev;
+	struct cifsFileInfo		*cfile;
+	__u64				offset;
+	unsigned int			bytes;
+	int				result;
+	unsigned int			nr_pages;
+	struct page			*pages[1];
+};
+
 struct cifs_io_parms {
 	__u16 netfid;
 	__u64 persist_fid;
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 9b447a0..e273ab3 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -212,10 +212,14 @@ extern int cifs_readpages(struct file *file, struct address_space *mapping,
 			  struct list_head *page_list, unsigned num_pages);
 extern int cifs_writepages(struct address_space *mapping,
 			   struct writeback_control *wbc);
+extern int cifs_writepages_generic(struct address_space *mapping,
+				   struct writeback_control *wbc,
+				   awritev_callback_t *async_writev);
 extern int cifs_writepage(struct page *page, struct writeback_control *wbc);
 void cifs_proc_init(void);
 void cifs_proc_clean(void);
 
+extern void inc_rfc1001_len(void *pSMB, int count);
 extern int cifs_negotiate_protocol(unsigned int xid,
 				  struct cifs_ses *ses);
 extern int cifs_setup_session(unsigned int xid, struct cifs_ses *ses,
@@ -516,19 +520,6 @@ struct cifs_readdata *cifs_readdata_alloc(unsigned int nr_pages);
 void cifs_readdata_free(struct cifs_readdata *rdata);
 int cifs_async_readv(struct cifs_readdata *rdata);
 
-/* asynchronous write support */
-struct cifs_writedata {
-	struct kref			refcount;
-	enum writeback_sync_modes	sync_mode;
-	struct work_struct		work;
-	struct cifsFileInfo		*cfile;
-	__u64				offset;
-	unsigned int			bytes;
-	int				result;
-	unsigned int			nr_pages;
-	struct page			*pages[1];
-};
-
 int cifs_async_writev(struct cifs_writedata *wdata);
 struct cifs_writedata *cifs_writedata_alloc(unsigned int nr_pages);
 void cifs_writedata_release(struct kref *refcount);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index ac41696..0e29b36 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -365,7 +365,7 @@ vt2_err:
 	return -EINVAL;
 }
 
-static inline void inc_rfc1001_len(void *pSMB, int count)
+inline void inc_rfc1001_len(void *pSMB, int count)
 {
 	struct smb_hdr *hdr = (struct smb_hdr *)pSMB;
 
@@ -2001,7 +2001,7 @@ cifs_writev_requeue(struct cifs_writedata *wdata)
 	}
 
 	do {
-		rc = cifs_async_writev(wdata);
+		rc = wdata->requeue_writev(wdata);
 	} while (rc == -EAGAIN);
 
 	for (i = 0; i < wdata->nr_pages; i++) {
@@ -2108,6 +2108,7 @@ cifs_writev_callback(struct mid_q_entry *mid)
 		break;
 	}
 
+	wdata->requeue_writev = cifs_async_writev;
 	queue_work(system_nrt_wq, &wdata->work);
 	DeleteMidQEntry(mid);
 	atomic_dec(&tcon->ses->server->inFlight);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index e0a12fa..9e377f2 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1743,8 +1743,10 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
 	return rc;
 }
 
-int cifs_writepages(struct address_space *mapping,
-			   struct writeback_control *wbc)
+int
+cifs_writepages_generic(struct address_space *mapping,
+			struct writeback_control *wbc,
+			awritev_callback_t *async_writev)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(mapping->host->i_sb);
 	bool done = false, scanned = false, range_whole = false;
@@ -1897,7 +1899,7 @@ retry:
 				rc = -EBADF;
 				break;
 			}
-			rc = cifs_async_writev(wdata);
+			rc = async_writev(wdata);
 		} while (wbc->sync_mode == WB_SYNC_ALL && rc == -EAGAIN);
 
 		for (i = 0; i < nr_pages; ++i)
@@ -1942,6 +1944,12 @@ retry:
 	return rc;
 }
 
+int
+cifs_writepages(struct address_space *mapping, struct writeback_control *wbc)
+{
+	return cifs_writepages_generic(mapping, wbc, cifs_async_writev);
+}
+
 static int
 cifs_writepage_locked(struct page *page, struct writeback_control *wbc)
 {
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 6e55700..1894b77 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -151,7 +151,7 @@ const struct address_space_operations smb2_addr_ops = {
 	.readpage = cifs_readpage,
 	/*.readpages = cifs_readpages,*/
 	.writepage = cifs_writepage,
-	/*.writepages = cifs_writepages,*/
+	.writepages = smb2_writepages,
 	.write_begin = cifs_write_begin,
 	.write_end = cifs_write_end,
 	.set_page_dirty = __set_page_dirty_nobuffers,
@@ -168,7 +168,7 @@ const struct address_space_operations smb2_addr_ops = {
 const struct address_space_operations smb2_addr_ops_smallbuf = {
 	.readpage = cifs_readpage,
 	.writepage = cifs_writepage,
-	/*.writepages = cifs_writepages,*/
+	.writepages = smb2_writepages,
 	.write_begin = cifs_write_begin,
 	.write_end = cifs_write_end,
 	.set_page_dirty = __set_page_dirty_nobuffers,
@@ -459,3 +459,9 @@ smb2_write_cb(int xid, struct cifsFileInfo *cfile, struct cifs_io_parms *parms,
 	return SMB2_write(xid, parms, written, iov, nr_segs,
 			  remaining_bytes, timeout);
 }
+
+int
+smb2_writepages(struct address_space *mapping, struct writeback_control *wbc)
+{
+	return cifs_writepages_generic(mapping, wbc, smb2_async_writev);
+}
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index f323d6d..8791b85 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -31,6 +31,7 @@
 #include <linux/kernel.h>
 #include <linux/vfs.h>
 #include <linux/uaccess.h>
+#include <linux/pagemap.h>
 #include <linux/xattr.h>
 #include "smb2pdu.h"
 #include "cifsglob.h"
@@ -1299,3 +1300,125 @@ int SMB2_write(const int xid, struct cifs_io_parms *io_parms,
 	}
 	return rc;
 }
+
+/*
+ * Check the mid_state and signature on received buffer (if any), and queue the
+ * workqueue completion task.
+ */
+static void
+smb2_writev_callback(struct mid_q_entry *mid)
+{
+	struct cifs_writedata *wdata = mid->callback_data;
+	struct cifs_tcon *tcon = tlink_tcon(wdata->cfile->tlink);
+	unsigned int written;
+	struct smb2_write_rsp *smb2 = (struct smb2_write_rsp *)mid->resp_buf;
+	unsigned int credits_received = 1;
+
+	switch (mid->mid_state) {
+	case MID_RESPONSE_RECEIVED:
+		credits_received = le16_to_cpu(smb2->hdr.CreditRequest);
+		wdata->result = smb2_check_receive(mid, tcon->ses->server,
+						   get_rfc1002_length(smb2), 0);
+		if (wdata->result != 0)
+			break;
+
+		written = le32_to_cpu(smb2->DataLength);
+		/*
+		 * Mask off high 16 bits when bytes written as returned
+		 * by the server is greater than bytes requested by the
+		 * client. OS/2 servers are known to set incorrect
+		 * CountHigh values.
+		 */
+		if (written > wdata->bytes)
+			written &= 0xFFFF;
+
+		if (written < wdata->bytes)
+			wdata->result = -ENOSPC;
+		else
+			wdata->bytes = written;
+		break;
+	case MID_REQUEST_SUBMITTED:
+	case MID_RETRY_NEEDED:
+		wdata->result = -EAGAIN;
+		break;
+	default:
+		wdata->result = -EIO;
+		break;
+	}
+
+	wdata->requeue_writev = smb2_async_writev;
+	queue_work(system_nrt_wq, &wdata->work);
+	DeleteMidQEntry(mid);
+	atomic_add(credits_received, &tcon->ses->server->credits);
+	wake_up(&tcon->ses->server->request_q);
+}
+
+/* smb2_async_writev - send an async write, and set up mid to handle result */
+int
+smb2_async_writev(struct cifs_writedata *wdata)
+{
+	int i, rc = -EACCES;
+	struct smb2_write_req *smb2 = NULL;
+	struct cifs_tcon *tcon = tlink_tcon(wdata->cfile->tlink);
+	struct inode *inode = wdata->cfile->dentry->d_inode;
+	struct kvec *iov = NULL;
+
+	rc = small_smb2_init(SMB2_WRITE, tcon, (void **) &smb2);
+	if (rc)
+		goto async_writev_out;
+
+	/* 1 iov per page + 1 for header */
+	iov = kzalloc((wdata->nr_pages + 1) * sizeof(*iov), GFP_NOFS);
+	if (iov == NULL) {
+		rc = -ENOMEM;
+		goto async_writev_out;
+	}
+
+	smb2->hdr.ProcessId = cpu_to_le32(wdata->cfile->pid);
+
+	smb2->PersistentFileId = wdata->cfile->persist_fid;
+	smb2->VolatileFileId = wdata->cfile->volatile_fid;
+	smb2->WriteChannelInfoOffset = 0;
+	smb2->WriteChannelInfoLength = 0;
+	smb2->Channel = 0;
+	smb2->Offset = cpu_to_le64(wdata->offset);
+	smb2->DataOffset = cpu_to_le16(
+				offsetof(struct smb2_write_req, Buffer) - 4);
+	smb2->RemainingBytes = 0;
+
+	/* 4 for RFC1001 length + 1 for BCC */
+	iov[0].iov_len = be32_to_cpu(smb2->hdr.smb2_buf_length) + 4 - 1;
+	iov[0].iov_base = smb2;
+
+	/* marshal up the pages into iov array */
+	wdata->bytes = 0;
+	for (i = 0; i < wdata->nr_pages; i++) {
+		iov[i + 1].iov_len = min(inode->i_size -
+				      page_offset(wdata->pages[i]),
+					(loff_t)PAGE_CACHE_SIZE);
+		iov[i + 1].iov_base = kmap(wdata->pages[i]);
+		wdata->bytes += iov[i + 1].iov_len;
+	}
+
+	cFYI(1, "async write at %llu %u bytes", wdata->offset, wdata->bytes);
+
+	smb2->Length = cpu_to_le32(wdata->bytes);
+
+	inc_rfc1001_len(&smb2->hdr, wdata->bytes - 1);
+
+	kref_get(&wdata->refcount);
+	rc = smb2_call_async(tcon->ses->server, iov, wdata->nr_pages + 1,
+			     NULL, smb2_writev_callback, wdata, false);
+
+	if (rc)
+		kref_put(&wdata->refcount, cifs_writedata_release);
+
+	/* send is done, unmap pages */
+	for (i = 0; i < wdata->nr_pages; i++)
+		kunmap(wdata->pages[i]);
+
+async_writev_out:
+	cifs_small_buf_release(smb2);
+	kfree(iov);
+	return rc;
+}
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index d84e604..7336c2b 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -23,6 +23,7 @@
 #define _SMB2PROTO_H
 #include <linux/nls.h>
 #include <linux/key-type.h>
+#include "cifsproto.h"
 
 struct statfs;
 
@@ -56,9 +57,16 @@ extern __le16 *cifs_convert_path_to_utf16(const char *from,
 					  struct nls_table *local_nls);
 extern __le16 *cifs_build_utf16path_from_dentry(struct dentry *direntry);
 
+extern int smb2_check_receive(struct mid_q_entry *mid,
+			      struct TCP_Server_Info *server,
+			      unsigned int receive_len, bool log_error);
 extern int smb2_sendrcv2(const unsigned int xid, struct cifs_ses *ses,
 			 struct kvec *vec, int nvec, int *ret_buf_type,
 			 int *status, const int flags);
+extern int smb2_call_async(struct TCP_Server_Info *server, struct kvec *iov,
+			   unsigned int nvec, mid_receive_t *receive,
+			   mid_callback_t *callback, void *cbdata,
+			   bool ignore_pend);
 extern int smb2_sendrcv_norsp(const unsigned int xid, struct cifs_ses *ses,
 			      struct smb2_hdr *in_buf, int flags);
 extern int smb2_setup_session(unsigned int xid, struct cifs_ses *psesinfo,
@@ -95,6 +103,8 @@ extern int smb2_read_cb(int xid, struct cifsFileInfo *cfile,
 			struct cifs_io_parms *parms, unsigned int *bytes_read,
 			char **buf, int *buf_type,
 			unsigned int remaining_bytes);
+extern int smb2_writepages(struct address_space *mapping,
+			   struct writeback_control *wbc);
 
 /*
  *  SMB2 Worker functions - most of protocol specific implementation details
@@ -120,6 +130,7 @@ extern int SMB2_query_info(const int xid, struct cifs_tcon *tcon,
 extern int SMB2_write(const int xid, struct cifs_io_parms *io_parms,
 		      unsigned int *nbytes, struct kvec *iov, int n_vec,
 		      const unsigned int remaining_bytes, int wtimeout);
+extern int smb2_async_writev(struct cifs_writedata *wdata);
 extern int smb2_new_read_req(struct kvec *iov, struct cifs_io_parms *io_parms,
 			     unsigned int remaining_bytes, int request_type);
 extern int SMB2_read(const int xid, struct cifs_io_parms *io_parms,
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index b5702f3..05240ab 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -120,7 +120,7 @@ smb2_get_mid_entry(struct cifs_ses *ses, struct smb2_hdr *buf,
 	return 0;
 }
 
-static int
+int
 smb2_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		   unsigned int receive_len, bool log_error)
 {
@@ -308,4 +308,65 @@ smb2_sendrcv_norsp(const unsigned int xid, struct cifs_ses *ses,
 	return rc;
 }
 
-/* BB add missing functions here */
+/*
+ * Send a SMB2 request and set the callback function in the mid to handle
+ * the result. Caller is responsible for dealing with timeouts.
+ */
+int
+smb2_call_async(struct TCP_Server_Info *server, struct kvec *iov,
+		unsigned int nvec, mid_receive_t *receive,
+		mid_callback_t *callback, void *cbdata, bool ignore_pend)
+{
+	int rc;
+	struct mid_q_entry *mid;
+	struct smb2_hdr *hdr = (struct smb2_hdr *)iov[0].iov_base;
+
+	rc = cifs_wait_for_free_request(server,
+					ignore_pend ? CIFS_ASYNC_OP : 0);
+	if (rc)
+		return rc;
+
+	mutex_lock(&server->srv_mutex);
+
+	smb2_seq_num_into_buf(server, iov);
+
+	mid = smb2_mid_entry_alloc(hdr, server);
+	if (mid == NULL) {
+		mutex_unlock(&server->srv_mutex);
+		atomic_inc(&server->credits);
+		wake_up(&server->request_q);
+		return -ENOMEM;
+	}
+
+	/* put it on the pending_mid_q */
+	spin_lock(&GlobalMid_Lock);
+	list_add_tail(&mid->qhead, &server->pending_mid_q);
+	spin_unlock(&GlobalMid_Lock);
+
+	/* rc = smb2_sign_smb2(iov, nvec, server);
+	if (rc) {
+		mutex_unlock(&server->srv_mutex);
+		goto out_err;
+	} */
+
+	mid->receive = receive;
+	mid->callback = callback;
+	mid->callback_data = cbdata;
+	mid->mid_state = MID_REQUEST_SUBMITTED;
+
+	cifs_in_send_inc(server);
+	rc = smb_sendv(server, iov, nvec);
+	cifs_in_send_dec(server);
+	cifs_save_when_sent(mid);
+	mutex_unlock(&server->srv_mutex);
+
+	if (rc)
+		goto out_err;
+
+	return rc;
+out_err:
+	cifs_delete_mid(mid);
+	atomic_inc(&server->credits);
+	wake_up(&server->request_q);
+	return rc;
+}
-- 
1.7.1
