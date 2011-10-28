From: Pavel Shilovsky <piastry@etersoft.ru>
Subject: [PATCH v2 31/53] CIFS: Add writepages support for SMB2
Date: Fri, 28 Oct 2011 23:54:42 +0400
Message-ID: <1319831704-3572-32-git-send-email-piastry@etersoft.ru>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
Cc: linux-fsdevel@vger.kernel.org,
	Pavel Shilovsky <piastryyy@gmail.com>
To: linux-cifs@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Pavel Shilovsky <piastryyy@gmail.com>

Signed-off-by: Pavel Shilovsky <piastryyy@gmail.com>
---
 fs/cifs/cifsglob.h      |   17 +++++++
 fs/cifs/cifsproto.h     |   17 ++-----
 fs/cifs/cifssmb.c       |    5 +-
 fs/cifs/file.c          |   14 ++++-
 fs/cifs/smb2file.c      |   10 +++-
 fs/cifs/smb2pdu.c       |  122 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2proto.h     |   12 +++++
 fs/cifs/smb2transport.c |   67 +++++++++++++++++++++++++-
 8 files changed, 242 insertions(+), 22 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 465e87c..54125cc 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -600,6 +600,23 @@ typedef int (reopen_callback_t)(struct cifsFileInfo *cifs_file, int xid,
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
index eee59f7..6cf4313 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -207,10 +207,14 @@ extern int cifs_readpages(struct file *file, struct address_space *mapping,
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
@@ -509,19 +513,6 @@ struct cifs_readdata *cifs_readdata_alloc(unsigned int nr_pages);
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
index bc13c8b..0c73678 100644
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
index 4e9616d..91a3edd 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1722,8 +1722,10 @@ static int cifs_partialpagewrite(struct page *page, unsigned from, unsigned to)
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
@@ -1876,7 +1878,7 @@ retry:
 				rc = -EBADF;
 				break;
 			}
-			rc = cifs_async_writev(wdata);
+			rc = async_writev(wdata);
 		} while (wbc->sync_mode == WB_SYNC_ALL && rc == -EAGAIN);
 
 		for (i = 0; i < nr_pages; ++i)
@@ -1921,6 +1923,12 @@ retry:
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
index 40f05e4..33c0928 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -152,7 +152,7 @@ const struct address_space_operations smb2_addr_ops = {
 	.readpage = cifs_readpage,
 	/*.readpages = cifs_readpages,*/
 	.writepage = cifs_writepage,
-	/*.writepages = cifs_writepages,*/
+	.writepages = smb2_writepages,
 	.write_begin = cifs_write_begin,
 	.write_end = cifs_write_end,
 	.set_page_dirty = __set_page_dirty_nobuffers,
@@ -169,7 +169,7 @@ const struct address_space_operations smb2_addr_ops = {
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
index 8d13b34..cc4ed73 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -30,6 +30,7 @@
 #include <linux/kernel.h>
 #include <linux/vfs.h>
 #include <linux/uaccess.h>
+#include <linux/pagemap.h>
 #include <linux/xattr.h>
 #include "smb2pdu.h"
 #include "cifsglob.h"
@@ -2432,6 +2433,127 @@ int SMB2_write(const int xid, struct cifs_io_parms *io_parms,
 	return rc;
 }
 
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
+	struct write_rsp *smb2 = (struct write_rsp *)mid->resp_buf;
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
+	smb2_mid_entry_free(mid);
+	atomic_add(credits_received, &tcon->ses->server->credits);
+	wake_up(&tcon->ses->server->request_q);
+}
+
+/* smb2_async_writev - send an async write, and set up mid to handle result */
+int
+smb2_async_writev(struct cifs_writedata *wdata)
+{
+	int i, rc = -EACCES;
+	struct write_req *smb2 = NULL;
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
+	smb2->DataOffset = cpu_to_le16(offsetof(struct write_req, Buffer) - 4);
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
+
 int SMB2_lock(const int xid, struct cifs_tcon *tcon,
 	const u64 persistent_fid, const u64 volatile_fid,
 	u64 length, u64 offset, u32 lockFlags, int wait)
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 7798626..d017843 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -22,6 +22,7 @@
 #define _SMB2PROTO_H
 #include <linux/nls.h>
 #include <linux/key-type.h>
+#include "cifsproto.h"
 
 struct statfs;
 
@@ -66,12 +67,20 @@ extern int map_smb2_to_linux_error(struct smb2_hdr *smb2, int logErr);
 extern __le16 *cifs_convert_path_to_ucs(const char *from,
 					struct nls_table *local_nls);
 
+extern int smb2_check_receive(struct mid_q_entry *mid,
+			      struct TCP_Server_Info *server,
+			      unsigned int receive_len, bool log_error);
+extern void smb2_mid_entry_free(struct mid_q_entry *mid_entry);
 extern int smb2_send(struct TCP_Server_Info *, struct smb2_hdr *,
 		     unsigned int /* length */);
 extern int smb2_sendrcv2(const unsigned int /* xid */ , struct cifs_ses *,
 			struct kvec *, int /* nvec to send */,
 			int * /* type of buf returned */,
 			int * /* smb2 network status code */, const int flags);
+extern int smb2_call_async(struct TCP_Server_Info *server, struct kvec *iov,
+			   unsigned int nvec, mid_receive_t *receive,
+			   mid_callback_t *callback, void *cbdata,
+			   bool ignore_pend);
 extern int smb2_send_complex(const unsigned int, struct cifs_ses *,
 			     struct kvec *, int /* nvec to send */,
 			     int * /* type of buf returned */,
@@ -133,6 +142,8 @@ extern ssize_t smb2_user_readv(struct kiocb *iocb, const struct iovec *iov,
 			       unsigned long nr_segs, loff_t pos);
 extern ssize_t smb2_user_writev(struct kiocb *iocb, const struct iovec *iov,
 				unsigned long nr_segs, loff_t pos);
+extern int smb2_writepages(struct address_space *mapping,
+			   struct writeback_control *wbc);
 
 extern int smb2_mkdir(struct inode *inode, struct dentry *direntry, int mode);
 extern int smb2_rmdir(struct inode *inode, struct dentry *direntry);
@@ -200,6 +211,7 @@ extern int SMB2_read(const int xid, struct cifs_io_parms *io_parms,
 extern int SMB2_write(const int xid, struct cifs_io_parms *io_parms,
 		      unsigned int *nbytes, struct kvec *iov, int n_vec,
 		      const unsigned int remaining_bytes, int wtimeout);
+extern int smb2_async_writev(struct cifs_writedata *wdata);
 extern int SMB2_write_complex(const int xid, struct cifs_tcon *tcon,
 	const u64 persistent_fid, const u64 volatile_fid,
 	const unsigned int count, const __u64 lseek,
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 68cbba9..adb701f 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -168,7 +168,7 @@ static int get_smb2_mid(struct cifs_ses *ses, struct smb2_hdr *in_buf,
 	return 0;
 }
 
-static void
+void
 smb2_mid_entry_free(struct mid_q_entry *mid_entry)
 {
 #ifdef CONFIG_CIFS_STATS2
@@ -273,7 +273,7 @@ free_smb2_mid(struct mid_q_entry *mid)
 	smb2_mid_entry_free(mid);
 }
 
-static int
+int
 smb2_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		   unsigned int receive_len, bool log_error)
 {
@@ -444,4 +444,67 @@ out:
 	wake_up(&ses->server->request_q);
 	return rc;
 }
+
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
+	rc = wait_for_free_request(server, ignore_pend ? CIFS_ASYNC_OP : 0);
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
+/*	rc = cifs_sign_smb2(iov, nvec, server, &mid->sequence_number);
+	if (rc) {
+		mutex_unlock(&server->srv_mutex);
+		goto out_err;
+	}
+*/
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
+	free_smb2_mid(mid);
+	atomic_inc(&server->credits);
+	wake_up(&server->request_q);
+	return rc;
+}
 /* BB add missing functions here */
-- 
1.7.1

