From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 09/10] CIFS: Make use of multicredit reads for SMB2
Date: Mon, 20 Aug 2012 22:42:59 +0400
Message-ID: <1345488180-5942-10-git-send-email-pshilovsky@samba.org>
References: <1345488180-5942-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1345488180-5942-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h |    1 +
 fs/cifs/cifssmb.c  |    7 +++++--
 fs/cifs/file.c     |   29 +++++++++++++++++++++++++++--
 fs/cifs/smb2ops.c  |    5 -----
 fs/cifs/smb2pdu.c  |   15 +++++++++++++--
 5 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 3e5ab4e..c76e5ec 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -968,6 +968,7 @@ struct cifs_readdata {
 	struct kvec			iov;
 	unsigned int			pagesz;
 	unsigned int			tailsz;
+	unsigned int			credits;
 	unsigned int			nr_pages;
 	struct page			*pages[];
 };
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 75e9c87..58ced1f 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1575,7 +1575,7 @@ cifs_readv_callback(struct mid_q_entry *mid)
 int
 cifs_async_readv(struct cifs_readdata *rdata)
 {
-	int rc;
+	int rc, flags = 0;
 	READ_REQ *smb = NULL;
 	int wct;
 	struct cifs_tcon *tcon = tlink_tcon(rdata->cfile->tlink);
@@ -1623,9 +1623,12 @@ cifs_async_readv(struct cifs_readdata *rdata)
 	rdata->iov.iov_base = smb;
 	rdata->iov.iov_len = be32_to_cpu(smb->hdr.smb_buf_length) + 4;
 
+	if (rdata->credits)
+		flags = CIFS_HAS_CREDITS;
+
 	kref_get(&rdata->refcount);
 	rc = cifs_call_async(tcon->ses->server, &rqst, cifs_readv_receive,
-			     cifs_readv_callback, rdata, 0);
+			     cifs_readv_callback, rdata, flags);
 
 	if (rc == 0)
 		cifs_stats_inc(&tcon->stats.cifs_stats.num_reads);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 99c7532..2aa4f6e 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2669,9 +2669,11 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
 	unsigned int npages;
 	struct cifs_sb_info *cifs_sb;
 	struct cifs_tcon *tcon;
+	struct TCP_Server_Info *server;
 	struct cifsFileInfo *open_file;
 	struct cifs_readdata *rdata, *tmp;
 	struct list_head rdata_list;
+	unsigned int rsize, credits;
 	pid_t pid;
 
 	if (!nr_segs)
@@ -2685,8 +2687,9 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
 	open_file = file->private_data;
 	tcon = tlink_tcon(open_file->tlink);
+	server = tcon->ses->server;
 
-	if (!tcon->ses->server->ops->async_readv)
+	if (!server->ops->async_readv)
 		return -ENOSYS;
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
@@ -2698,7 +2701,10 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
 		cFYI(1, "attempting read on write only file instance");
 
 	do {
-		cur_len = min_t(const size_t, len - total_read, cifs_sb->rsize);
+		rc = server->ops->wait_mtu_credits(server, cifs_sb->rsize,
+						   &rsize, &credits);
+
+		cur_len = min_t(const size_t, len - total_read, rsize);
 		npages = DIV_ROUND_UP(cur_len, PAGE_SIZE);
 
 		/* allocate a readdata struct */
@@ -2709,6 +2715,8 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
 			goto error;
 		}
 
+		rdata->credits = credits;
+
 		rc = cifs_read_allocate_pages(rdata, npages);
 		if (rc)
 			goto error;
@@ -2726,6 +2734,8 @@ error:
 		if (rc) {
 			kref_put(&rdata->refcount,
 				 cifs_uncached_readdata_release);
+			add_credits(server, credits, 0);
+			wake_up(&server->request_q);
 			break;
 		}
 
@@ -3068,6 +3078,7 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 	struct cifsFileInfo *open_file = file->private_data;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
 	unsigned int rsize = cifs_sb->rsize;
+	struct TCP_Server_Info *server;
 	pid_t pid;
 
 	/*
@@ -3095,6 +3106,7 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 
 	rc = 0;
 	INIT_LIST_HEAD(&tmplist);
+	server = tlink_tcon(open_file->tlink)->ses->server;
 
 	cFYI(1, "%s: file=%p mapping=%p num_pages=%u", __func__, file,
 		mapping, num_pages);
@@ -3118,6 +3130,12 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 		loff_t offset;
 		struct page *page, *tpage;
 		struct cifs_readdata *rdata;
+		unsigned credits;
+
+		rc = server->ops->wait_mtu_credits(server, rsize, &rsize,
+						   &credits);
+		if (rc)
+			break;
 
 		page = list_entry(page_list->prev, struct page, lru);
 
@@ -3133,6 +3151,8 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 		/* give up if we can't stick it in the cache */
 		if (rc) {
 			__clear_page_locked(page);
+			add_credits(server, credits, 0);
+			wake_up(&server->request_q);
 			break;
 		}
 
@@ -3140,6 +3160,7 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 		offset = (loff_t)page->index << PAGE_CACHE_SHIFT;
 		list_move_tail(&page->lru, &tmplist);
 
+
 		/* now try and add more pages onto the request */
 		expected_index = page->index + 1;
 		list_for_each_entry_safe_reverse(page, tpage, page_list, lru) {
@@ -3173,9 +3194,13 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 				page_cache_release(page);
 			}
 			rc = -ENOMEM;
+			add_credits(server, credits, 0);
+			wake_up(&server->request_q);
 			break;
 		}
 
+		rdata->credits = credits;
+
 		rdata->cfile = cifsFileInfo_get(open_file);
 		rdata->mapping = mapping;
 		rdata->offset = offset;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 8b93f03..6692e84 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -235,11 +235,6 @@ smb2_negotiate_rsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
 	/* start with specified rsize, or default */
 	rsize = volume_info->rsize ? volume_info->rsize : CIFS_DEFAULT_IOSIZE;
 	rsize = min_t(unsigned int, rsize, server->max_read);
-	/*
-	 * limit write size to 2 ** 16, because we don't support multicredit
-	 * requests now.
-	 */
-	rsize = min_t(unsigned int, rsize, 2 << 15);
 
 	return rsize;
 }
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 6fc41b8..86489d3 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1455,11 +1455,12 @@ smb2_readv_callback(struct mid_q_entry *mid)
 int
 smb2_async_readv(struct cifs_readdata *rdata)
 {
-	int rc;
+	int rc, flags = 0;
 	struct smb2_hdr *buf;
 	struct cifs_io_parms io_parms;
 	struct smb_rqst rqst = { .rq_iov = &rdata->iov,
 				 .rq_nvec = 1 };
+	struct TCP_Server_Info *server;
 
 	cFYI(1, "%s: offset=%llu bytes=%u", __func__,
 		rdata->offset, rdata->bytes);
@@ -1474,14 +1475,24 @@ smb2_async_readv(struct cifs_readdata *rdata)
 	if (rc)
 		return rc;
 
+	server = io_parms.tcon->ses->server;
 	buf = (struct smb2_hdr *)rdata->iov.iov_base;
 	/* 4 for rfc1002 length field */
 	rdata->iov.iov_len = get_rfc1002_length(rdata->iov.iov_base) + 4;
 
+	if (rdata->credits) {
+		buf->CreditCharge =
+			cpu_to_le16(DIV_ROUND_UP(rdata->bytes, 2 << 15));
+		add_credits(server,
+			rdata->credits - le16_to_cpu(buf->CreditCharge), 0);
+		wake_up(&server->request_q);
+		flags = CIFS_HAS_CREDITS;
+	}
+
 	kref_get(&rdata->refcount);
 	rc = cifs_call_async(io_parms.tcon->ses->server, &rqst,
 			     cifs_readv_receive, smb2_readv_callback,
-			     rdata, 0);
+			     rdata, flags);
 	if (rc)
 		kref_put(&rdata->refcount, cifs_readdata_release);
 
-- 
1.7.1
