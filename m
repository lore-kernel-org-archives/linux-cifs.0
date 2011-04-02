From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/5] cifs: add cifs_async_writev
Date: Sat,  2 Apr 2011 08:23:58 -0400
Message-ID: <1301747039-31411-5-git-send-email-jlayton@redhat.com>
References: <1301747039-31411-1-git-send-email-jlayton@redhat.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1301747039-31411-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Add the ability for CIFS to do an asynchronous write. The kernel will
set the frame up as it would for a "normal" SMBWrite2 request, and use
cifs_call_async to send it. The mid callback will then be configured to
handle the result.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsproto.h |   19 +++++
 fs/cifs/cifssmb.c   |  219 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 238 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index e255a2b..7b964df 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -21,6 +21,7 @@
 #ifndef _CIFSPROTO_H
 #define _CIFSPROTO_H
 #include <linux/nls.h>
+#include <linux/pagevec.h>
 
 struct statfs;
 struct smb_vol;
@@ -433,4 +434,22 @@ extern int mdfour(unsigned char *, unsigned char *, int);
 extern int E_md4hash(const unsigned char *passwd, unsigned char *p16);
 extern int SMBencrypt(unsigned char *passwd, const unsigned char *c8,
 			unsigned char *p24);
+
+/* asynchronous write support */
+struct cifs_writedata {
+	struct list_head	pending;
+	struct kref		refcount;
+	struct completion	completion;
+	struct work_struct	work;
+	struct cifsFileInfo	*cfile;
+	__u64			offset;
+	unsigned int		bytes;
+	int			result;
+	struct page 		*pages[PAGEVEC_SIZE];
+};
+
+int cifs_async_writev(struct cifs_writedata *wdata);
+struct cifs_writedata *cifs_writedata_alloc(void);
+void cifs_writedata_release(struct kref *refcount);
+
 #endif			/* _CIFSPROTO_H */
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 8de7e79..b308605 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -32,6 +32,7 @@
 #include <linux/vfs.h>
 #include <linux/slab.h>
 #include <linux/posix_acl_xattr.h>
+#include <linux/pagemap.h>
 #include <asm/uaccess.h>
 #include "cifspdu.h"
 #include "cifsglob.h"
@@ -1604,6 +1605,224 @@ CIFSSMBWrite(const int xid, struct cifs_tcon *tcon,
 	return rc;
 }
 
+void
+cifs_writedata_release(struct kref *refcount)
+{
+	struct cifs_writedata *wdata = container_of(refcount,
+					struct cifs_writedata, refcount);
+	struct address_space *mapping;
+
+	if (wdata->cfile) {
+		mapping = wdata->cfile->dentry->d_inode->i_mapping;
+
+		spin_lock(&mapping->private_lock);
+		list_del(&wdata->pending);
+		spin_unlock(&mapping->private_lock);
+
+		cifsFileInfo_put(wdata->cfile);
+	}
+
+	kfree(wdata);
+}
+
+static void
+cifs_writev_complete(struct work_struct *work)
+{
+	struct cifs_writedata *wdata = container_of(work,
+						struct cifs_writedata, work);
+	struct cifs_tcon *tcon = tlink_tcon(wdata->cfile->tlink);
+	struct inode *inode = wdata->cfile->dentry->d_inode;
+	struct page *page;
+	int i = 0;
+
+	if (wdata->result == 0) {
+		cifs_update_eof(CIFS_I(inode), wdata->offset, wdata->bytes);
+		cifs_stats_bytes_written(tcon, wdata->bytes);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(wdata->pages) && (page = wdata->pages[i]);
+			i++) {
+		if (wdata->result == -EAGAIN)
+			__set_page_dirty_nobuffers(page);
+		else if (wdata->result < 0)
+			SetPageError(page);
+		end_page_writeback(page);
+		page_cache_release(page);
+	}
+	if (wdata->result != -EAGAIN)
+		mapping_set_error(inode->i_mapping, wdata->result);
+	complete(&wdata->completion);
+	kref_put(&wdata->refcount, cifs_writedata_release);
+}
+
+struct cifs_writedata *
+cifs_writedata_alloc(void)
+{
+	struct cifs_writedata *wdata;
+
+	wdata = kzalloc(sizeof(*wdata), GFP_NOFS);
+	if (wdata != NULL) {
+		INIT_LIST_HEAD(&wdata->pending);
+		INIT_WORK(&wdata->work, cifs_writev_complete);
+		kref_init(&wdata->refcount);
+		init_completion(&wdata->completion);
+	}
+	return wdata;
+}
+
+/*
+ * Check the midState and signature on received buffer (if any), and queue the
+ * workqueue completion task.
+ */
+static void
+cifs_writev_callback(struct mid_q_entry *mid)
+{
+	struct cifs_writedata *wdata = mid->callback_data;
+	struct cifs_tcon *tcon = tlink_tcon(wdata->cfile->tlink);
+	unsigned int written;
+	WRITE_RSP *smb = (WRITE_RSP *)mid->resp_buf;
+
+	switch(mid->midState) {
+	case MID_RESPONSE_RECEIVED:
+		wdata->result = cifs_check_receive(mid, tcon->ses->server, 0);
+		if (wdata->result != 0)
+			break;
+
+		written = le16_to_cpu(smb->CountHigh);
+		written <<= 16;
+		written += le16_to_cpu(smb->Count);
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
+	queue_work(system_nrt_wq, &wdata->work);
+	DeleteMidQEntry(mid);
+	atomic_dec(&tcon->ses->server->inFlight);
+	wake_up(&tcon->ses->server->request_q);
+}
+
+/* cifs_async_writev - send an async write, and set up mid to handle result */
+int
+cifs_async_writev(struct cifs_writedata *wdata)
+{
+	int i, rc = -EACCES;
+	WRITE_REQ *smb = NULL;
+	int wct;
+	struct cifs_tcon *tcon = tlink_tcon(wdata->cfile->tlink);
+	struct inode *inode = wdata->cfile->dentry->d_inode;
+	unsigned int npages = ARRAY_SIZE(wdata->pages);
+	struct kvec *iov = NULL;
+
+	cFYI(1, "async write at %llu %u bytes", wdata->offset, wdata->bytes);
+
+	if (tcon->ses->capabilities & CAP_LARGE_FILES) {
+		wct = 14;
+	} else {
+		wct = 12;
+		if (wdata->offset >> 32 > 0) {
+			/* can not handle big offset for old srv */
+			return -EIO;
+		}
+	}
+
+	rc = small_smb_init(SMB_COM_WRITE_ANDX, wct, tcon, (void **)&smb);
+	if (rc)
+		goto async_writev_out;
+
+	/* FIXME: only allocate number of kvecs we need */
+	iov = kzalloc((npages + 1) * sizeof(*iov), GFP_NOFS);
+	if (iov == NULL) {
+		rc = -ENOMEM;
+		goto async_writev_out;
+	}
+
+	smb->AndXCommand = 0xFF;	/* none */
+	smb->Fid = wdata->cfile->netfid;
+	smb->OffsetLow = cpu_to_le32(wdata->offset & 0xFFFFFFFF);
+	if (wct == 14)
+		smb->OffsetHigh = cpu_to_le32(wdata->offset >> 32);
+	smb->Reserved = 0xFFFFFFFF;
+	smb->WriteMode = 0;
+	smb->Remaining = 0;
+
+	smb->DataOffset =
+	    cpu_to_le16(offsetof(struct smb_com_write_req, Data) - 4);
+
+	/* 4 for RFC1001 length + 1 for BCC */
+	iov[0].iov_len = be32_to_cpu(smb->hdr.smb_buf_length) + 4 + 1;
+	iov[0].iov_base = smb;
+
+	/* marshal up the pages into iov array */
+	npages = 0;
+	wdata->bytes = 0;
+	for (i = 0; i < ARRAY_SIZE(wdata->pages) && wdata->pages[i]; i++) {
+		if (wdata->bytes + PAGE_CACHE_SIZE <=
+		    CIFS_SB(inode->i_sb)->wsize) {
+			iov[i + 1].iov_len = min(inode->i_size -
+					      page_offset(wdata->pages[i]),
+						(loff_t)PAGE_CACHE_SIZE);
+			iov[i + 1].iov_base = kmap(wdata->pages[i]);
+			wdata->bytes += iov[i + 1].iov_len;
+			npages++;
+		} else {
+			/* if we're beyond wsize, then re-mark page dirty */
+			__set_page_dirty_nobuffers(wdata->pages[i]);
+		}
+	}
+
+	smb->DataLengthLow = cpu_to_le16(wdata->bytes & 0xFFFF);
+	smb->DataLengthHigh = cpu_to_le16(wdata->bytes >> 16);
+
+	if (wct == 14) {
+		inc_rfc1001_len(&smb->hdr, wdata->bytes + 1);
+		put_bcc(wdata->bytes + 1, &smb->hdr);
+	} else {
+		/* wct == 12 */
+		struct smb_com_writex_req *smbw =
+				(struct smb_com_writex_req *)smb;
+		inc_rfc1001_len(&smbw->hdr, wdata->bytes + 5);
+		put_bcc(wdata->bytes + 5, &smbw->hdr);
+		iov[0].iov_len += 4; /* pad bigger by four bytes */
+	}
+
+	kref_get(&wdata->refcount);
+	rc = cifs_call_async(tcon->ses->server, iov, npages + 1,
+			     cifs_writev_callback, wdata);
+
+	if (rc == 0)
+		cifs_stats_inc(&tcon->stats.cifs_stats.num_writes);
+	else
+		kref_put(&wdata->refcount, cifs_writedata_release);
+
+	/* send is done, unmap pages */
+	for (i = 0; i < npages; i++)
+		kunmap(wdata->pages[i]);
+
+async_writev_out:
+	cifs_small_buf_release(smb);
+	kfree(iov);
+	return rc;
+}
+
 int
 CIFSSMBWrite2(const int xid, struct cifs_tcon *tcon,
 	     const int netfid, const unsigned int count,
-- 
1.7.4
