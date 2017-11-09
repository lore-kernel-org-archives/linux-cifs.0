From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 13/19] cifs: remove rfc1002 header from smb2 read/write requests
Date: Thu,  9 Nov 2017 12:14:27 +1100
Message-ID: <20171109011433.14468-14-lsahlber@redhat.com>
References: <20171109011433.14468-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171109011433.14468-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 42 ++++++++++++++++++++----------------------
 fs/cifs/smb2pdu.h |  2 +-
 2 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index a44d54ea946b..3ba9b2853902 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2471,7 +2471,7 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 	struct smb2_sync_hdr *shdr;
 
 	rc = smb2_plain_req_init(SMB2_READ, io_parms->tcon, (void **) &req,
-				 total_len);
+			     total_len);
 	if (rc)
 		return rc;
 	if (io_parms->tcon->ses->server == NULL)
@@ -2681,7 +2681,7 @@ SMB2_read(const unsigned int xid, struct cifs_io_parms *io_parms,
 
 	iov[0].iov_base = &req_len;
 	iov[0].iov_len = sizeof(__be32);
-	iov[1].iov_base = req;
+	iov[1].iov_base = (char *)req;
 	iov[1].iov_len = total_len;
 
 	rc = cifs_send_recv(xid, ses, &rqst, &resp_buftype, flags, &rsp_iov);
@@ -2786,8 +2786,10 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	struct TCP_Server_Info *server = tcon->ses->server;
 	struct kvec iov[2];
 	struct smb_rqst rqst = { };
+	unsigned int total_len;
+	__be32 rfc1002_marker;
 
-	rc = small_smb2_init(SMB2_WRITE, tcon, (void **) &req);
+	rc = smb2_plain_req_init(SMB2_WRITE, tcon, (void **) &req, &total_len);
 	if (rc) {
 		if (rc == -EAGAIN && wdata->credits) {
 			/* credits was reset by reconnect */
@@ -2803,7 +2805,7 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	if (encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	shdr = get_sync_hdr(req);
+	shdr = (struct smb2_sync_hdr *)req;
 	shdr->ProcessId = cpu_to_le32(wdata->cfile->pid);
 
 	req->PersistentFileId = wdata->cfile->fid.persistent_fid;
@@ -2812,16 +2814,16 @@ smb2_async_writev(struct cifs_writedata *wdata,
 	req->WriteChannelInfoLength = 0;
 	req->Channel = 0;
 	req->Offset = cpu_to_le64(wdata->offset);
-	/* 4 for rfc1002 length field */
 	req->DataOffset = cpu_to_le16(
-				offsetof(struct smb2_write_req, Buffer) - 4);
+				offsetof(struct smb2_write_req, Buffer));
 	req->RemainingBytes = 0;
 
 	/* 4 for rfc1002 length field and 1 for Buffer */
 	iov[0].iov_len = 4;
-	iov[0].iov_base = req;
-	iov[1].iov_len = get_rfc1002_length(req) - 1;
-	iov[1].iov_base = (char *)req + 4;
+	rfc1002_marker = cpu_to_be32(total_len - 1 + wdata->bytes);
+	iov[0].iov_base = &rfc1002_marker;
+	iov[1].iov_len = total_len - 1;
+	iov[1].iov_base = (char *)req;
 
 	rqst.rq_iov = iov;
 	rqst.rq_nvec = 2;
@@ -2835,8 +2837,6 @@ smb2_async_writev(struct cifs_writedata *wdata,
 
 	req->Length = cpu_to_le32(wdata->bytes);
 
-	inc_rfc1001_len(&req->hdr, wdata->bytes - 1 /* Buffer */);
-
 	if (wdata->credits) {
 		shdr->CreditCharge = cpu_to_le16(DIV_ROUND_UP(wdata->bytes,
 						    SMB2_MAX_BUFFER_SIZE));
@@ -2879,13 +2879,15 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 	int resp_buftype;
 	struct kvec rsp_iov;
 	int flags = 0;
+	unsigned int total_len;
 
 	*nbytes = 0;
 
 	if (n_vec < 1)
 		return rc;
 
-	rc = small_smb2_init(SMB2_WRITE, io_parms->tcon, (void **) &req);
+	rc = smb2_plain_req_init(SMB2_WRITE, io_parms->tcon, (void **) &req,
+			     &total_len);
 	if (rc)
 		return rc;
 
@@ -2895,7 +2897,7 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 	if (encryption_required(io_parms->tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	req->hdr.sync_hdr.ProcessId = cpu_to_le32(io_parms->pid);
+	req->sync_hdr.ProcessId = cpu_to_le32(io_parms->pid);
 
 	req->PersistentFileId = io_parms->persistent_fid;
 	req->VolatileFileId = io_parms->volatile_fid;
@@ -2904,20 +2906,16 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 	req->Channel = 0;
 	req->Length = cpu_to_le32(io_parms->length);
 	req->Offset = cpu_to_le64(io_parms->offset);
-	/* 4 for rfc1002 length field */
 	req->DataOffset = cpu_to_le16(
-				offsetof(struct smb2_write_req, Buffer) - 4);
+				offsetof(struct smb2_write_req, Buffer));
 	req->RemainingBytes = 0;
 
 	iov[0].iov_base = (char *)req;
-	/* 4 for rfc1002 length field and 1 for Buffer */
-	iov[0].iov_len = get_rfc1002_length(req) + 4 - 1;
-
-	/* length of entire message including data to be written */
-	inc_rfc1001_len(req, io_parms->length - 1 /* Buffer */);
+	/* 1 for Buffer */
+	iov[0].iov_len = total_len - 1;
 
-	rc = SendReceive2(xid, io_parms->tcon->ses, iov, n_vec + 1,
-			  &resp_buftype, flags, &rsp_iov);
+	rc = smb2_send_recv(xid, io_parms->tcon->ses, iov, n_vec + 1,
+			    &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	rsp = (struct smb2_write_rsp *)rsp_iov.iov_base;
 
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 0c33fc8cce71..3c856f058be7 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -868,7 +868,7 @@ struct smb2_read_rsp {
 #define SMB2_WRITEFLAG_WRITE_UNBUFFERED	0x00000002	/* SMB3.02 or later */
 
 struct smb2_write_req {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize; /* Must be 49 */
 	__le16 DataOffset; /* offset from start of SMB2 header to write data */
 	__le32 Length;
-- 
2.13.3
