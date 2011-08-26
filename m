From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/5] cifs: add cifs_async_readv
Date: Fri, 26 Aug 2011 15:18:15 -0400
Message-ID: <1314386298-27424-3-git-send-email-jlayton@redhat.com>
References: <1314386298-27424-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1314386298-27424-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...which will allow cifs to do an asynchronous read call to the server.
The caller will allocate and set up cifs_readdata for each READ_AND_X
call that should be issued on the wire.

The caller will lock the pages, add them to the pagecache, and hang them
off the pages list using the lru list head embedded in struct page. Once
the read completes, the pages are added to the LRU list, set Uptodate
and unlocked.

While this may seem like an odd way to handle the pagecache, it does
prevent the VFS from attempting to issue duplicate reads on the same
pages.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsproto.h |   23 ++++
 fs/cifs/cifssmb.c   |  298 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/connect.c   |   26 +++---
 3 files changed, 334 insertions(+), 13 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 51c0ebc..5f5e0c8 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -152,6 +152,12 @@ extern struct cifs_ntsd *get_cifs_acl(struct cifs_sb_info *, struct inode *,
 extern int set_cifs_acl(struct cifs_ntsd *, __u32, struct inode *,
 				const char *);
 
+extern void dequeue_mid(struct mid_q_entry *mid, bool malformed);
+extern int cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
+		     unsigned int to_read);
+extern int cifs_readv_from_socket(struct TCP_Server_Info *server,
+		struct kvec *iov_orig, unsigned int nr_segs,
+		unsigned int to_read);
 extern void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 			       struct cifs_sb_info *cifs_sb);
 extern int cifs_match_super(struct super_block *, void *);
@@ -441,6 +447,23 @@ extern int E_md4hash(const unsigned char *passwd, unsigned char *p16);
 extern int SMBencrypt(unsigned char *passwd, const unsigned char *c8,
 			unsigned char *p24);
 
+/* asynchronous read support */
+struct cifs_readdata {
+	struct cifsFileInfo		*cfile;
+	struct address_space		*mapping;
+	__u64				offset;
+	unsigned int			bytes;
+	pid_t				pid;
+	int				result;
+	struct list_head		pages;
+	unsigned int			nr_iov;
+	struct kvec			iov[1];
+};
+
+struct cifs_readdata *cifs_readdata_alloc(unsigned int nr_pages);
+void cifs_readdata_free(struct cifs_readdata *rdata);
+int cifs_async_readv(struct cifs_readdata *rdata);
+
 /* asynchronous write support */
 struct cifs_writedata {
 	struct kref			refcount;
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 911bc7e..c5f6ea6 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -33,6 +33,8 @@
 #include <linux/slab.h>
 #include <linux/posix_acl_xattr.h>
 #include <linux/pagemap.h>
+#include <linux/swap.h>
+#include <linux/task_io_accounting_ops.h>
 #include <asm/uaccess.h>
 #include "cifspdu.h"
 #include "cifsglob.h"
@@ -40,6 +42,7 @@
 #include "cifsproto.h"
 #include "cifs_unicode.h"
 #include "cifs_debug.h"
+#include "fscache.h"
 
 #ifdef CONFIG_CIFS_POSIX
 static struct {
@@ -1386,6 +1389,301 @@ openRetry:
 	return rc;
 }
 
+struct cifs_readdata *
+cifs_readdata_alloc(unsigned int nr_pages)
+{
+	struct cifs_readdata *rdata;
+
+	/* readdata + 1 kvec for each page */
+	rdata = kzalloc(sizeof(*rdata) +
+			sizeof(struct kvec) * nr_pages, GFP_KERNEL);
+	if (rdata != NULL)
+		INIT_LIST_HEAD(&rdata->pages);
+	return rdata;
+}
+
+void
+cifs_readdata_free(struct cifs_readdata *rdata)
+{
+	put_pages_list(&rdata->pages);
+	kfree(rdata);
+}
+
+/*
+ * Discard any remaining data in the current SMB. To do this, we borrow the
+ * current bigbuf.
+ */
+static int
+cifs_readv_discard(struct TCP_Server_Info *server, struct mid_q_entry *mid)
+{
+	READ_RSP *rsp = (READ_RSP *)server->smallbuf;
+	unsigned int rfclen = be32_to_cpu(rsp->hdr.smb_buf_length);
+	int remaining = rfclen + 4 - server->total_read;
+	struct cifs_readdata *rdata = mid->callback_data;
+
+	while (remaining > 0) {
+		int length;
+
+		length = cifs_read_from_socket(server, server->bigbuf,
+				min_t(unsigned int, remaining,
+					CIFSMaxBufSize + MAX_CIFS_HDR_SIZE));
+		if (length < 0)
+			return length;
+		server->total_read += length;
+		remaining -= length;
+	}
+
+	dequeue_mid(mid, rdata->result);
+	return 0;
+}
+
+static int
+cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
+{
+	int length, len, data_len, remaining;
+	unsigned int data_offset;
+	struct cifs_readdata *rdata = mid->callback_data;
+	READ_RSP *rsp = (READ_RSP *)server->smallbuf;
+	unsigned int rfclen = be32_to_cpu(rsp->hdr.smb_buf_length);
+	struct page *page, *tpage;
+
+	cFYI(1, "%s: mid=%u offset=%llu bytes=%u", __func__,
+		mid->mid, rdata->offset, rdata->bytes);
+
+	/*
+	 * read the rest of READ_RSP header (sans Data array), or whatever we
+	 * can if there's not enough data. At this point, we've read down to
+	 * the Mid.
+	 */
+	len = min_t(unsigned int, rfclen + 4, sizeof(*rsp)) -
+			sizeof(struct smb_hdr) + 1;
+
+	rdata->iov[0].iov_base = server->smallbuf + sizeof(struct smb_hdr) - 1;
+	rdata->iov[0].iov_len = len;
+
+	length = cifs_readv_from_socket(server, rdata->iov, 1, len);
+	if (length < 0)
+		return length;
+	server->total_read += length;
+
+	/* Was the SMB read successful? */
+	rdata->result = map_smb_to_linux_error(&rsp->hdr, false);
+	if (rdata->result != 0) {
+		cFYI(1, "%s: server returned error %d", __func__,
+			rdata->result);
+		return cifs_readv_discard(server, mid);
+	}
+
+	/* Is there enough to get to the rest of the READ_RSP header? */
+	if (server->total_read < sizeof(READ_RSP) - 1) {
+		cFYI(1, "%s: server returned short header got=%u expected=%lu",
+			__func__, server->total_read, sizeof(READ_RSP));
+		rdata->result = -EIO;
+		return cifs_readv_discard(server, mid);
+	}
+
+	/* check that DataOffset isn't beyond end of smallbuf */
+	data_offset = le16_to_cpu(rsp->DataOffset) + 4;
+	if (data_offset > MAX_CIFS_SMALL_BUFFER_SIZE) {
+		cFYI(1, "%s: data offset (%u) beyond end of smallbuf",
+			__func__, data_offset);
+		rdata->result = -EIO;
+		return cifs_readv_discard(server, mid);
+	}
+
+	cFYI(1, "%s: total_read=%u data_offset=%u", __func__,
+		server->total_read, data_offset);
+	len = data_offset - server->total_read;
+	if (len > 0) {
+		/* read any junk before data into the rest of smallbuf */
+		rdata->iov[0].iov_base = server->smallbuf + server->total_read;
+		rdata->iov[0].iov_len = len;
+		length = cifs_readv_from_socket(server, rdata->iov, 1, len);
+		if (length < 0)
+			return length;
+		server->total_read += length;
+	}
+
+	/* set up first iov for signature check */
+	rdata->iov[0].iov_base = server->smallbuf;
+	rdata->iov[0].iov_len = server->total_read;
+	cFYI(1, "0: iov_base=%p iov_len=%lu",
+		rdata->iov[0].iov_base, rdata->iov[0].iov_len);
+
+	/* how much data is in the response? */
+	data_len = le16_to_cpu(rsp->DataLengthHigh) << 16;
+	data_len += le16_to_cpu(rsp->DataLength);
+
+	/* marshal up the page array */
+	remaining = data_len;
+	rdata->nr_iov = 1;
+	list_for_each_entry_safe(page, tpage, &rdata->pages, lru) {
+		if (remaining >= PAGE_CACHE_SIZE) {
+			rdata->iov[rdata->nr_iov].iov_base = kmap(page);
+			rdata->iov[rdata->nr_iov].iov_len = PAGE_CACHE_SIZE;
+			cFYI(1, "%u: iov_base=%p iov_len=%lu", rdata->nr_iov,
+				rdata->iov[rdata->nr_iov].iov_base,
+				rdata->iov[rdata->nr_iov].iov_len);
+			++rdata->nr_iov;
+			len += PAGE_CACHE_SIZE;
+			remaining -= PAGE_CACHE_SIZE;
+		} else if (remaining > 0) {
+			rdata->iov[rdata->nr_iov].iov_base = kmap(page);
+			rdata->iov[rdata->nr_iov].iov_len = remaining;
+			cFYI(1, "%u: iov_base=%p iov_len=%lu", rdata->nr_iov,
+				rdata->iov[rdata->nr_iov].iov_base,
+				rdata->iov[rdata->nr_iov].iov_len);
+			/* zero out remainder of page */
+			memset(rdata->iov[rdata->nr_iov].iov_base + remaining,
+				'\0', PAGE_CACHE_SIZE - remaining);
+			++rdata->nr_iov;
+			len += remaining;
+			remaining = 0;
+		} else {
+			/* no need to hold page hostage */
+			delete_from_page_cache(page);
+			list_del(&page->lru);
+			unlock_page(page);
+			page_cache_release(page);
+		}
+	}
+
+	/* issue the read */
+	length = cifs_readv_from_socket(server, &rdata->iov[1],
+					rdata->nr_iov - 1, len);
+	if (length < 0)
+		return length;
+	server->total_read += length;
+
+	rdata->bytes = length;
+
+	cFYI(1, "total_read=%u rfclen=%u remaining=%u",
+		server->total_read, rfclen, remaining);
+
+	/* discard anything left over */
+	if (remaining > 0)
+		return cifs_readv_discard(server, mid);
+
+	dequeue_mid(mid, false);
+	return length;
+}
+
+static void
+cifs_readv_callback(struct mid_q_entry *mid)
+{
+	struct cifs_readdata *rdata = mid->callback_data;
+	struct cifs_tcon *tcon = tlink_tcon(rdata->cfile->tlink);
+	struct TCP_Server_Info *server = tcon->ses->server;
+	struct page *page, *tpage;
+
+	cFYI(1, "%s: mid=%u state=%d result=%d bytes=%u", __func__,
+		mid->mid, mid->midState, rdata->result, rdata->bytes);
+
+	switch (mid->midState) {
+	case MID_RESPONSE_RECEIVED:
+		/* result already set, check signature */
+		if (server->sec_mode &
+		    (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
+			if (cifs_verify_signature(rdata->iov, rdata->nr_iov,
+					  server, mid->sequence_number + 1))
+				cERROR(1, "Unexpected SMB signature");
+		}
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
+	list_for_each_entry_safe(page, tpage, &rdata->pages, lru) {
+		list_del(&page->lru);
+
+		if (rdata->result == 0) {
+			kunmap(page);
+			lru_cache_add_file(page);
+			flush_dcache_page(page);
+			SetPageUptodate(page);
+			cifs_readpage_to_fscache(rdata->mapping->host, page);
+		} else {
+			delete_from_page_cache(page);
+		}
+
+		unlock_page(page);
+		page_cache_release(page);
+	}
+
+	cifs_readdata_free(rdata);
+	DeleteMidQEntry(mid);
+	atomic_dec(&tcon->ses->server->inFlight);
+	wake_up(&tcon->ses->server->request_q);
+}
+
+/* cifs_async_readv - send an async write, and set up mid to handle result */
+int
+cifs_async_readv(struct cifs_readdata *rdata)
+{
+	int rc;
+	READ_REQ *smb = NULL;
+	int wct;
+	struct cifs_tcon *tcon = tlink_tcon(rdata->cfile->tlink);
+
+	cFYI(1, "%s: offset=%llu bytes=%u", __func__,
+		rdata->offset, rdata->bytes);
+
+	if (tcon->ses->capabilities & CAP_LARGE_FILES)
+		wct = 12;
+	else {
+		wct = 10; /* old style read */
+		if ((rdata->offset >> 32) > 0)  {
+			/* can not handle this big offset for old */
+			return -EIO;
+		}
+	}
+
+	rc = small_smb_init(SMB_COM_READ_ANDX, wct, tcon, (void **)&smb);
+	if (rc)
+		return rc;
+
+	smb->hdr.Pid = cpu_to_le16((__u16)rdata->pid);
+	smb->hdr.PidHigh = cpu_to_le16((__u16)(rdata->pid >> 16));
+
+	smb->AndXCommand = 0xFF;	/* none */
+	smb->Fid = rdata->cfile->netfid;
+	smb->OffsetLow = cpu_to_le32(rdata->offset & 0xFFFFFFFF);
+	if (wct == 12)
+		smb->OffsetHigh = cpu_to_le32(rdata->offset >> 32);
+	smb->Remaining = 0;
+	smb->MaxCount = cpu_to_le16(rdata->bytes & 0xFFFF);
+	smb->MaxCountHigh = cpu_to_le32(rdata->bytes >> 16);
+	if (wct == 12)
+		smb->ByteCount = 0;
+	else {
+		/* old style read */
+		struct smb_com_readx_req *smbr =
+			(struct smb_com_readx_req *)smb;
+		smbr->ByteCount = 0;
+	}
+
+	/* 4 for RFC1001 length + 1 for BCC */
+	rdata->iov[0].iov_base = smb;
+	rdata->iov[0].iov_len = be32_to_cpu(smb->hdr.smb_buf_length) + 4;
+
+	rc = cifs_call_async(tcon->ses->server, rdata->iov, 1,
+			     cifs_readv_receive, cifs_readv_callback,
+			     rdata, false);
+
+	if (rc == 0)
+		cifs_stats_inc(&tcon->num_reads);
+
+	cifs_small_buf_release(smb);
+	return rc;
+}
+
 int
 CIFSSMBRead(const int xid, struct cifs_io_parms *io_parms, unsigned int *nbytes,
 	    char **buf, int *pbuf_type)
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 9d0b1c2..fc0ea41 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -422,9 +422,9 @@ get_server_iovec(struct TCP_Server_Info *server, unsigned int nr_segs)
 	return new_iov;
 }
 
-static int
-readv_from_socket(struct TCP_Server_Info *server, struct kvec *iov_orig,
-		  unsigned int nr_segs, unsigned int to_read)
+int
+cifs_readv_from_socket(struct TCP_Server_Info *server, struct kvec *iov_orig,
+		       unsigned int nr_segs, unsigned int to_read)
 {
 	int length = 0;
 	int total_read;
@@ -479,16 +479,16 @@ readv_from_socket(struct TCP_Server_Info *server, struct kvec *iov_orig,
 	return total_read;
 }
 
-static int
-read_from_socket(struct TCP_Server_Info *server, char *buf,
-		 unsigned int to_read)
+int
+cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
+		      unsigned int to_read)
 {
 	struct kvec iov;
 
 	iov.iov_base = buf;
 	iov.iov_len = to_read;
 
-	return readv_from_socket(server, &iov, 1, to_read);
+	return cifs_readv_from_socket(server, &iov, 1, to_read);
 }
 
 static bool
@@ -553,8 +553,8 @@ find_mid(struct TCP_Server_Info *server, struct smb_hdr *buf)
 	return NULL;
 }
 
-static void
-dequeue_mid(struct mid_q_entry *mid, int malformed)
+void
+dequeue_mid(struct mid_q_entry *mid, bool malformed)
 {
 #ifdef CONFIG_CIFS_STATS2
 	mid->when_received = jiffies;
@@ -731,7 +731,7 @@ standard_receive3(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	}
 
 	/* now read the rest */
-	length = read_from_socket(server,
+	length = cifs_read_from_socket(server,
 			  buf + sizeof(struct smb_hdr) - 1,
 			  pdu_length - sizeof(struct smb_hdr) + 1 + 4);
 	if (length < 0)
@@ -792,7 +792,7 @@ cifs_demultiplex_thread(void *p)
 		buf = server->smallbuf;
 		pdu_length = 4; /* enough to get RFC1001 header */
 
-		length = read_from_socket(server, buf, pdu_length);
+		length = cifs_read_from_socket(server, buf, pdu_length);
 		if (length < 0)
 			continue;
 		server->total_read = length;
@@ -817,8 +817,8 @@ cifs_demultiplex_thread(void *p)
 		}
 
 		/* read down to the MID */
-		length = read_from_socket(server, buf + 4,
-					  sizeof(struct smb_hdr) - 1 - 4);
+		length = cifs_read_from_socket(server, buf + 4,
+					sizeof(struct smb_hdr) - 1 - 4);
 		if (length < 0)
 			continue;
 		server->total_read += length;
-- 
1.7.6
