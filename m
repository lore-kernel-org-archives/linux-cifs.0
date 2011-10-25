From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 32/53] CIFS: Add readpages support for SMB2
Date: Tue, 25 Oct 2011 10:12:05 +0400
Message-ID: <1319523146-2859-33-git-send-email-piastry@etersoft.ru>
References: <1319523146-2859-1-git-send-email-piastry@etersoft.ru>
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319523146-2859-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsglob.h  |   16 ++++++++++
 fs/cifs/cifsproto.h |   20 ++++---------
 fs/cifs/cifssmb.c   |   78 +++++++++++++++++++++++++++++++++++++++++----------
 fs/cifs/file.c      |   14 +++++++--
 fs/cifs/smb2file.c  |   10 ++++++-
 fs/cifs/smb2pdu.c   |   72 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2proto.h |    3 ++
 7 files changed, 180 insertions(+), 33 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 54125cc..bde6241 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -600,6 +600,22 @@ typedef int (reopen_callback_t)(struct cifsFileInfo *cifs_file, int xid,
 				 struct cifs_tcon *tcon, const char *full_path,
 				 __u32 *oplock);
 
+/* asynchronous read support */
+struct cifs_readdata {
+	struct cifsFileInfo		*cfile;
+	struct address_space		*mapping;
+	__u64				offset;
+	unsigned int			bytes;
+	pid_t				pid;
+	int				result;
+	struct list_head		pages;
+	struct work_struct		work;
+	unsigned int			nr_iov;
+	struct kvec			iov[1];
+};
+
+typedef int (areadv_callback_t)(struct cifs_readdata *);
+
 struct cifs_writedata;
 typedef int (awritev_callback_t)(struct cifs_writedata *);
 
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 0d0afad..f2c04b8 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -205,6 +205,11 @@ extern int cifs_launder_page(struct page *page);
 extern int cifs_readpage(struct file *file, struct page *page);
 extern int cifs_readpages(struct file *file, struct address_space *mapping,
 			  struct list_head *page_list, unsigned num_pages);
+extern int cifs_readpages_generic(struct file *file,
+				  struct address_space *mapping,
+				  struct list_head *page_list,
+				  unsigned num_pages,
+				  areadv_callback_t *read_cb);
 extern int cifs_writepages(struct address_space *mapping,
 			   struct writeback_control *wbc);
 extern int cifs_writepages_generic(struct address_space *mapping,
@@ -495,23 +500,10 @@ extern int E_md4hash(const unsigned char *passwd, unsigned char *p16);
 extern int SMBencrypt(unsigned char *passwd, const unsigned char *c8,
 			unsigned char *p24);
 
-/* asynchronous read support */
-struct cifs_readdata {
-	struct cifsFileInfo		*cfile;
-	struct address_space		*mapping;
-	__u64				offset;
-	unsigned int			bytes;
-	pid_t				pid;
-	int				result;
-	struct list_head		pages;
-	struct work_struct		work;
-	unsigned int			nr_iov;
-	struct kvec			iov[1];
-};
-
 struct cifs_readdata *cifs_readdata_alloc(unsigned int nr_pages);
 void cifs_readdata_free(struct cifs_readdata *rdata);
 int cifs_async_readv(struct cifs_readdata *rdata);
+int cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid);
 
 int cifs_async_writev(struct cifs_writedata *wdata);
 struct cifs_writedata *cifs_writedata_alloc(unsigned int nr_pages);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 0c73678..5c81cd4 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -43,6 +43,9 @@
 #include "cifs_unicode.h"
 #include "cifs_debug.h"
 #include "fscache.h"
+#ifdef CONFIG_CIFS_SMB2
+#include "smb2proto.h"
+#endif
 
 #ifdef CONFIG_CIFS_POSIX
 static struct {
@@ -1410,17 +1413,24 @@ cifs_readdata_free(struct cifs_readdata *rdata)
 static int
 cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
-	READ_RSP *rsp = (READ_RSP *)server->smallbuf;
-	unsigned int rfclen = be32_to_cpu(rsp->hdr.smb_buf_length);
+	unsigned int rfclen = get_rfc1002_length(server->smallbuf);
 	int remaining = rfclen + 4 - server->total_read;
 	struct cifs_readdata *rdata = mid->callback_data;
+	size_t max_hdr_size;
+
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2)
+		max_hdr_size = MAX_SMB2_HDR_SIZE;
+	else
+#endif
+		max_hdr_size = MAX_CIFS_HDR_SIZE;
 
 	while (remaining > 0) {
 		int length;
 
 		length = cifs_read_from_socket(server, server->bigbuf,
 				min_t(unsigned int, remaining,
-					CIFSMaxBufSize + MAX_CIFS_HDR_SIZE));
+					CIFSMaxBufSize + max_hdr_size));
 		if (length < 0)
 			return length;
 		server->total_read += length;
@@ -1431,30 +1441,47 @@ cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	return 0;
 }
 
-static int
+int
 cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 {
 	int length, len;
 	unsigned int data_offset, remaining, data_len;
 	struct cifs_readdata *rdata = mid->callback_data;
-	READ_RSP *rsp = (READ_RSP *)server->smallbuf;
-	unsigned int rfclen = be32_to_cpu(rsp->hdr.smb_buf_length) + 4;
+	unsigned int rfclen = get_rfc1002_length(server->smallbuf) + 4;
+	READ_RSP *smb_rsp = NULL;
+#ifdef CONFIG_CIFS_SMB2
+	struct read_rsp *smb2_rsp = NULL;
+#endif
 	u64 eof;
 	pgoff_t eof_index;
 	struct page *page, *tpage;
+	size_t read_buf_size, buf_size;
 
 	cFYI(1, "%s: mid=%llu offset=%llu bytes=%u", __func__,
 		mid->mid, rdata->offset, rdata->bytes);
 
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2) {
+		smb2_rsp = (struct read_rsp *)server->smallbuf;
+		read_buf_size = sizeof(*smb2_rsp) - 1;
+		buf_size = sizeof(struct smb2_hdr);
+	} else {
+#endif
+		smb_rsp = (READ_RSP *)server->smallbuf;
+		read_buf_size = sizeof(*smb_rsp);
+		buf_size = sizeof(struct smb_hdr);
+#ifdef CONFIG_CIFS_SMB2
+	}
+#endif
+
 	/*
 	 * read the rest of READ_RSP header (sans Data array), or whatever we
 	 * can if there's not enough data. At this point, we've read down to
 	 * the Mid.
 	 */
-	len = min_t(unsigned int, rfclen, sizeof(*rsp)) -
-			sizeof(struct smb_hdr) + 1;
+	len = min_t(unsigned int, rfclen, read_buf_size) - buf_size + 1;
 
-	rdata->iov[0].iov_base = server->smallbuf + sizeof(struct smb_hdr) - 1;
+	rdata->iov[0].iov_base = server->smallbuf + buf_size - 1;
 	rdata->iov[0].iov_len = len;
 
 	length = cifs_readv_from_socket(server, rdata->iov, 1, len);
@@ -1463,7 +1490,12 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	server->total_read += length;
 
 	/* Was the SMB read successful? */
-	rdata->result = map_smb_to_linux_error(&rsp->hdr, false);
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2)
+		rdata->result = map_smb2_to_linux_error(&smb2_rsp->hdr, false);
+	else
+#endif
+		rdata->result = map_smb_to_linux_error(&smb_rsp->hdr, false);
 	if (rdata->result != 0) {
 		cFYI(1, "%s: server returned error %d", __func__,
 			rdata->result);
@@ -1471,14 +1503,20 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	}
 
 	/* Is there enough to get to the rest of the READ_RSP header? */
-	if (server->total_read < sizeof(READ_RSP)) {
+	if (server->total_read < read_buf_size) {
 		cFYI(1, "%s: server returned short header. got=%u expected=%zu",
-			__func__, server->total_read, sizeof(READ_RSP));
+			__func__, server->total_read, read_buf_size);
 		rdata->result = -EIO;
 		return cifs_readv_discard(server, mid);
 	}
 
-	data_offset = le16_to_cpu(rsp->DataOffset) + 4;
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2)
+		data_offset = smb2_rsp->DataOffset;
+	else
+#endif
+		data_offset = le16_to_cpu(smb_rsp->DataOffset);
+	data_offset += 4;
 	if (data_offset < server->total_read) {
 		/*
 		 * win2k8 sometimes sends an offset of 0 when the read
@@ -1517,8 +1555,16 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		rdata->iov[0].iov_base, rdata->iov[0].iov_len);
 
 	/* how much data is in the response? */
-	data_len = le16_to_cpu(rsp->DataLengthHigh) << 16;
-	data_len += le16_to_cpu(rsp->DataLength);
+#ifdef CONFIG_CIFS_SMB2
+	if (server->is_smb2)
+		data_len = le32_to_cpu(smb2_rsp->DataLength);
+	else {
+#endif
+		data_len = le16_to_cpu(smb_rsp->DataLengthHigh) << 16;
+		data_len += le16_to_cpu(smb_rsp->DataLength);
+#ifdef CONFIG_CIFS_SMB2
+	}
+#endif
 	if (data_offset + data_len > rfclen) {
 		/* data_len is corrupt -- discard frame */
 		rdata->result = -EIO;
@@ -1605,6 +1651,8 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	if (server->total_read < rfclen)
 		return cifs_readv_discard(server, mid);
 
+	mid->resp_buf = server->smallbuf;
+	server->smallbuf = NULL;
 	dequeue_mid(mid, false);
 	return length;
 }
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 91a3edd..d090b6b 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2686,8 +2686,9 @@ int cifs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	return rc;
 }
 
-int cifs_readpages(struct file *file, struct address_space *mapping,
-		   struct list_head *page_list, unsigned num_pages)
+int cifs_readpages_generic(struct file *file, struct address_space *mapping,
+			   struct list_head *page_list, unsigned num_pages,
+			   areadv_callback_t *async_readv)
 {
 	int rc;
 	struct list_head tmplist;
@@ -2817,7 +2818,7 @@ int cifs_readpages(struct file *file, struct address_space *mapping,
 				if (rc != 0)
 					continue;
 			}
-			rc = cifs_async_readv(rdata);
+			rc = async_readv(rdata);
 		} while (rc == -EAGAIN);
 
 		if (rc != 0) {
@@ -2836,6 +2837,13 @@ int cifs_readpages(struct file *file, struct address_space *mapping,
 	return rc;
 }
 
+int cifs_readpages(struct file *file, struct address_space *mapping,
+		   struct list_head *page_list, unsigned num_pages)
+{
+	return cifs_readpages_generic(file, mapping, page_list, num_pages,
+				      cifs_async_readv);
+}
+
 static int cifs_readpage_worker(struct file *file, struct page *page,
 	loff_t *poffset)
 {
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 8ed434a..c81f76a 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -150,7 +150,7 @@ const struct file_operations smb2_file_direct_nobrl_ops = {
 
 const struct address_space_operations smb2_addr_ops = {
 	.readpage = cifs_readpage,
-	/*.readpages = cifs_readpages,*/
+	.readpages = smb2_readpages,
 	.writepage = cifs_writepage,
 	.writepages = smb2_writepages,
 	.write_begin = cifs_write_begin,
@@ -470,3 +470,11 @@ smb2_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
 	return cifs_writepages_generic(mapping, wbc, smb2_async_writev);
 }
+
+int
+smb2_readpages(struct file *file, struct address_space *mapping,
+	       struct list_head *page_list, unsigned num_pages)
+{
+	return cifs_readpages_generic(file, mapping, page_list, num_pages,
+				      smb2_async_readv);
+}
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index dca8687..b5e717a 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -29,6 +29,7 @@
 #include <linux/fs.h>
 #include <linux/kernel.h>
 #include <linux/vfs.h>
+#include <linux/task_io_accounting_ops.h>
 #include <linux/uaccess.h>
 #include <linux/pagemap.h>
 #include <linux/xattr.h>
@@ -2369,6 +2370,77 @@ int SMB2_read(const int xid, struct cifs_io_parms *io_parms,
 	return rc;
 }
 
+static void
+smb2_readv_callback(struct mid_q_entry *mid)
+{
+	struct cifs_readdata *rdata = mid->callback_data;
+	struct cifs_tcon *tcon = tlink_tcon(rdata->cfile->tlink);
+	struct TCP_Server_Info *server = tcon->ses->server;
+	struct smb2_hdr *buf = (struct smb2_hdr *)mid->resp_buf;
+	unsigned int credits_received = 1;
+
+	cFYI(1, "%s: mid=%llu state=%d result=%d bytes=%u", __func__,
+		mid->mid, mid->mid_state, rdata->result, rdata->bytes);
+
+	switch (mid->mid_state) {
+	case MID_RESPONSE_RECEIVED:
+		credits_received = le16_to_cpu(buf->CreditRequest);
+		/* result already set, check signature */
+		if (server->sec_mode &
+		    (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
+/*			if (smb2_verify_signature(mid->resp_buf, server))
+				cERROR(1, "Unexpected SMB signature");
+*/		}
+		/* FIXME: should this be counted toward the initiating task? */
+		task_io_account_read(rdata->bytes);
+		cifs_stats_bytes_read(tcon, rdata->bytes);
+		break;
+	case MID_REQUEST_SUBMITTED:
+	case MID_RETRY_NEEDED:
+		rdata->result = -EAGAIN;
+		break;
+	default:
+		rdata->result = -EIO;
+	}
+
+	queue_work(system_nrt_wq, &rdata->work);
+	smb2_mid_entry_free(mid);
+	atomic_add(credits_received, &server->credits);
+	wake_up(&server->request_q);
+}
+
+/* smb2_async_readv - send an async write, and set up mid to handle result */
+int
+smb2_async_readv(struct cifs_readdata *rdata)
+{
+	int rc;
+	struct smb2_hdr *buf;
+	struct cifs_io_parms io_parms;
+
+	cFYI(1, "%s: offset=%llu bytes=%u", __func__,
+		rdata->offset, rdata->bytes);
+
+	io_parms.tcon = tlink_tcon(rdata->cfile->tlink);
+	io_parms.offset = rdata->offset;
+	io_parms.length = rdata->bytes;
+	io_parms.volatile_fid = rdata->cfile->volatile_fid;
+	io_parms.persist_fid = rdata->cfile->persist_fid;
+	io_parms.pid = rdata->pid;
+	rc = new_read_req(&rdata->iov[0], &io_parms, 0, 0);
+	if (rc)
+		return rc;
+
+	buf = (struct smb2_hdr *)rdata->iov[0].iov_base;
+	rdata->iov[0].iov_len = get_rfc1002_length(rdata->iov[0].iov_base) + 4;
+
+	rc = smb2_call_async(io_parms.tcon->ses->server, rdata->iov, 1,
+			     cifs_readv_receive, smb2_readv_callback,
+			     rdata, false);
+
+	cifs_small_buf_release(buf);
+	return rc;
+}
+
 /*
  * SMB2_write function gets iov pointer to kvec array with n_vec as a length.
  * The length field from io_parms must be at least 1 and indicates a number of
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 10be24a..79d05ab 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -144,6 +144,8 @@ extern ssize_t smb2_user_writev(struct kiocb *iocb, const struct iovec *iov,
 				unsigned long nr_segs, loff_t pos);
 extern int smb2_writepages(struct address_space *mapping,
 			   struct writeback_control *wbc);
+extern int smb2_readpages(struct file *file, struct address_space *mapping,
+			  struct list_head *page_list, unsigned num_pages);
 
 extern int smb2_mkdir(struct inode *inode, struct dentry *direntry, int mode);
 extern int smb2_rmdir(struct inode *inode, struct dentry *direntry);
@@ -208,6 +210,7 @@ extern int SMB2_close(const int xid, struct cifs_tcon *tcon,
 extern int SMB2_read(const int xid, struct cifs_io_parms *io_parms,
 		     unsigned int *nbytes, char **buf, int *pbuf_type,
 		     unsigned int remaining_bytes);
+extern int smb2_async_readv(struct cifs_readdata *rdata);
 extern int SMB2_write(const int xid, struct cifs_io_parms *io_parms,
 		      unsigned int *nbytes, struct kvec *iov, int n_vec,
 		      const unsigned int remaining_bytes, int wtimeout);
-- 
1.7.1
