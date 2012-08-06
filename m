From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 14/15] cifs: replace kvec array in readdata with a single kvec
Date: Mon,  6 Aug 2012 07:31:11 -0400
Message-ID: <1344252672-15244-15-git-send-email-jlayton@redhat.com>
References: <1344252672-15244-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1344252672-15244-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The array is no longer needed. We just need a single kvec to hold the
header for signature checking.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h |  3 +--
 fs/cifs/cifssmb.c  | 29 ++++++++++++++---------------
 fs/cifs/file.c     |  9 ---------
 fs/cifs/smb2pdu.c  | 12 ++++++------
 4 files changed, 21 insertions(+), 32 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 48a5eba..de98a1a 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -980,10 +980,9 @@ struct cifs_readdata {
 	int (*read_into_pages)(struct TCP_Server_Info *server,
 				struct cifs_readdata *rdata,
 				unsigned int len);
+	struct kvec			iov;
 	unsigned int			pagesz;
 	unsigned int			tailsz;
-	unsigned int			nr_iov;
-	struct kvec			*iov;
 	unsigned int			nr_pages;
 	struct page			*pages[];
 };
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 5d7bd75..88bbb3e 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1436,10 +1436,10 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	len = min_t(unsigned int, buflen, server->vals->read_rsp_size) -
 							HEADER_SIZE(server) + 1;
 
-	rdata->iov[0].iov_base = buf + HEADER_SIZE(server) - 1;
-	rdata->iov[0].iov_len = len;
+	rdata->iov.iov_base = buf + HEADER_SIZE(server) - 1;
+	rdata->iov.iov_len = len;
 
-	length = cifs_readv_from_socket(server, rdata->iov, 1, len);
+	length = cifs_readv_from_socket(server, &rdata->iov, 1, len);
 	if (length < 0)
 		return length;
 	server->total_read += length;
@@ -1485,20 +1485,19 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	len = data_offset - server->total_read;
 	if (len > 0) {
 		/* read any junk before data into the rest of smallbuf */
-		rdata->iov[0].iov_base = buf + server->total_read;
-		rdata->iov[0].iov_len = len;
-		length = cifs_readv_from_socket(server, rdata->iov, 1, len);
+		rdata->iov.iov_base = buf + server->total_read;
+		rdata->iov.iov_len = len;
+		length = cifs_readv_from_socket(server, &rdata->iov, 1, len);
 		if (length < 0)
 			return length;
 		server->total_read += length;
 	}
 
 	/* set up first iov for signature check */
-	rdata->iov[0].iov_base = buf;
-	rdata->iov[0].iov_len = server->total_read;
-	rdata->nr_iov = 1;
+	rdata->iov.iov_base = buf;
+	rdata->iov.iov_len = server->total_read;
 	cFYI(1, "0: iov_base=%p iov_len=%zu",
-		rdata->iov[0].iov_base, rdata->iov[0].iov_len);
+		rdata->iov.iov_base, rdata->iov.iov_len);
 
 	/* how much data is in the response? */
 	data_len = server->ops->read_data_length(buf);
@@ -1532,8 +1531,8 @@ cifs_readv_callback(struct mid_q_entry *mid)
 	struct cifs_readdata *rdata = mid->callback_data;
 	struct cifs_tcon *tcon = tlink_tcon(rdata->cfile->tlink);
 	struct TCP_Server_Info *server = tcon->ses->server;
-	struct smb_rqst rqst = { .rq_iov = rdata->iov,
-				 .rq_nvec = rdata->nr_iov,
+	struct smb_rqst rqst = { .rq_iov = &rdata->iov,
+				 .rq_nvec = 1,
 				 .rq_pages = rdata->pages,
 				 .rq_npages = rdata->nr_pages,
 				 .rq_pagesz = rdata->pagesz,
@@ -1580,7 +1579,7 @@ cifs_async_readv(struct cifs_readdata *rdata)
 	READ_REQ *smb = NULL;
 	int wct;
 	struct cifs_tcon *tcon = tlink_tcon(rdata->cfile->tlink);
-	struct smb_rqst rqst = { .rq_iov = rdata->iov,
+	struct smb_rqst rqst = { .rq_iov = &rdata->iov,
 				 .rq_nvec = 1 };
 
 	cFYI(1, "%s: offset=%llu bytes=%u", __func__,
@@ -1621,8 +1620,8 @@ cifs_async_readv(struct cifs_readdata *rdata)
 	}
 
 	/* 4 for RFC1001 length + 1 for BCC */
-	rdata->iov[0].iov_base = smb;
-	rdata->iov[0].iov_len = be32_to_cpu(smb->hdr.smb_buf_length) + 4;
+	rdata->iov.iov_base = smb;
+	rdata->iov.iov_len = be32_to_cpu(smb->hdr.smb_buf_length) + 4;
 
 	kref_get(&rdata->refcount);
 	rc = cifs_call_async(tcon->ses->server, &rqst, cifs_readv_receive,
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 8b23cb2..18098c8 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2413,11 +2413,6 @@ static struct cifs_readdata *
 cifs_readdata_alloc(unsigned int nr_pages, work_func_t complete)
 {
 	struct cifs_readdata *rdata;
-	struct kvec *iov;
-
-	iov = kzalloc(sizeof(*iov) * (nr_pages + 1), GFP_KERNEL);
-	if (!iov)
-		return (struct cifs_readdata *)iov;
 
 	rdata = kzalloc(sizeof(*rdata) + (sizeof(struct page *) * nr_pages),
 			GFP_KERNEL);
@@ -2426,9 +2421,6 @@ cifs_readdata_alloc(unsigned int nr_pages, work_func_t complete)
 		INIT_LIST_HEAD(&rdata->list);
 		init_completion(&rdata->done);
 		INIT_WORK(&rdata->work, complete);
-		rdata->iov = iov;
-	} else {
-		kfree(iov);
 	}
 
 	return rdata;
@@ -2443,7 +2435,6 @@ cifs_readdata_release(struct kref *refcount)
 	if (rdata->cfile)
 		cifsFileInfo_put(rdata->cfile);
 
-	kfree(rdata->iov);
 	kfree(rdata);
 }
 
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index ebd65e6..a2393a9 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1297,9 +1297,9 @@ smb2_readv_callback(struct mid_q_entry *mid)
 	struct cifs_readdata *rdata = mid->callback_data;
 	struct cifs_tcon *tcon = tlink_tcon(rdata->cfile->tlink);
 	struct TCP_Server_Info *server = tcon->ses->server;
-	struct smb2_hdr *buf = (struct smb2_hdr *)rdata->iov[0].iov_base;
+	struct smb2_hdr *buf = (struct smb2_hdr *)rdata->iov.iov_base;
 	unsigned int credits_received = 1;
-	struct smb_rqst rqst = { .rq_iov = rdata->iov,
+	struct smb_rqst rqst = { .rq_iov = &rdata->iov,
 				 .rq_nvec = 1,
 				 .rq_pages = rdata->pages,
 				 .rq_npages = rdata->nr_pages,
@@ -1346,7 +1346,7 @@ smb2_async_readv(struct cifs_readdata *rdata)
 	int rc;
 	struct smb2_hdr *buf;
 	struct cifs_io_parms io_parms;
-	struct smb_rqst rqst = { .rq_iov = rdata->iov,
+	struct smb_rqst rqst = { .rq_iov = &rdata->iov,
 				 .rq_nvec = 1 };
 
 	cFYI(1, "%s: offset=%llu bytes=%u", __func__,
@@ -1358,13 +1358,13 @@ smb2_async_readv(struct cifs_readdata *rdata)
 	io_parms.persistent_fid = rdata->cfile->fid.persistent_fid;
 	io_parms.volatile_fid = rdata->cfile->fid.volatile_fid;
 	io_parms.pid = rdata->pid;
-	rc = smb2_new_read_req(&rdata->iov[0], &io_parms, 0, 0);
+	rc = smb2_new_read_req(&rdata->iov, &io_parms, 0, 0);
 	if (rc)
 		return rc;
 
-	buf = (struct smb2_hdr *)rdata->iov[0].iov_base;
+	buf = (struct smb2_hdr *)rdata->iov.iov_base;
 	/* 4 for rfc1002 length field */
-	rdata->iov[0].iov_len = get_rfc1002_length(rdata->iov[0].iov_base) + 4;
+	rdata->iov.iov_len = get_rfc1002_length(rdata->iov.iov_base) + 4;
 
 	kref_get(&rdata->refcount);
 	rc = cifs_call_async(io_parms.tcon->ses->server, &rqst,
-- 
1.7.11.2
