From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 18/19] cifs: remove rfc1002 header from smb2_query_info_req
Date: Mon, 20 Nov 2017 11:24:46 +1100
Message-ID: <20171120002447.32322-19-lsahlber@redhat.com>
References: <20171120002447.32322-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171120002447.32322-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 26 ++++++++++++++------------
 fs/cifs/smb2pdu.h |  2 +-
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index fcc9e5ed6ee4..a4994937898e 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2194,13 +2194,15 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 	int resp_buftype;
 	struct cifs_ses *ses = tcon->ses;
 	int flags = 0;
+	unsigned int total_len;
 
 	cifs_dbg(FYI, "Query Info\n");
 
 	if (!ses || !(ses->server))
 		return -EIO;
 
-	rc = small_smb2_init(SMB2_QUERY_INFO, tcon, (void **) &req);
+	rc = smb2_plain_req_init(SMB2_QUERY_INFO, tcon, (void **) &req,
+			     &total_len);
 	if (rc)
 		return rc;
 
@@ -2217,15 +2219,14 @@ query_info(const unsigned int xid, struct cifs_tcon *tcon,
 	 * We do not use the input buffer (do not send extra byte)
 	 */
 	req->InputBufferOffset = 0;
-	inc_rfc1001_len(req, -1);
 
 	req->OutputBufferLength = cpu_to_le32(output_len);
 
 	iov[0].iov_base = (char *)req;
-	/* 4 for rfc1002 length field */
-	iov[0].iov_len = get_rfc1002_length(req) + 4;
+	/* 1 for Buffer */
+	iov[0].iov_len = total_len - 1;
 
-	rc = SendReceive2(xid, ses, iov, 1, &resp_buftype, flags, &rsp_iov);
+	rc = smb2_send_recv(xid, ses, iov, 1, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	rsp = (struct smb2_query_info_rsp *)rsp_iov.iov_base;
 
@@ -3374,13 +3375,15 @@ build_qfs_info_req(struct kvec *iov, struct cifs_tcon *tcon, int level,
 {
 	int rc;
 	struct smb2_query_info_req *req;
+	unsigned int total_len;
 
 	cifs_dbg(FYI, "Query FSInfo level %d\n", level);
 
 	if ((tcon->ses == NULL) || (tcon->ses->server == NULL))
 		return -EIO;
 
-	rc = small_smb2_init(SMB2_QUERY_INFO, tcon, (void **) &req);
+	rc = smb2_plain_req_init(SMB2_QUERY_INFO, tcon, (void **) &req,
+			     &total_len);
 	if (rc)
 		return rc;
 
@@ -3388,15 +3391,14 @@ build_qfs_info_req(struct kvec *iov, struct cifs_tcon *tcon, int level,
 	req->FileInfoClass = level;
 	req->PersistentFileId = persistent_fid;
 	req->VolatileFileId = volatile_fid;
-	/* 4 for rfc1002 length field and 1 for pad */
+	/* 1 for pad */
 	req->InputBufferOffset =
-			cpu_to_le16(sizeof(struct smb2_query_info_req) - 1 - 4);
+			cpu_to_le16(sizeof(struct smb2_query_info_req) - 1);
 	req->OutputBufferLength = cpu_to_le32(
 		outbuf_len + sizeof(struct smb2_query_info_rsp) - 1 - 4);
 
 	iov->iov_base = (char *)req;
-	/* 4 for rfc1002 length field */
-	iov->iov_len = get_rfc1002_length(req) + 4;
+	iov->iov_len = total_len;
 	return 0;
 }
 
@@ -3422,7 +3424,7 @@ SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
 	if (encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	rc = SendReceive2(xid, ses, &iov, 1, &resp_buftype, flags, &rsp_iov);
+	rc = smb2_send_recv(xid, ses, &iov, 1, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(iov.iov_base);
 	if (rc) {
 		cifs_stats_fail_inc(tcon, SMB2_QUERY_INFO_HE);
@@ -3478,7 +3480,7 @@ SMB2_QFS_attr(const unsigned int xid, struct cifs_tcon *tcon,
 	if (encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	rc = SendReceive2(xid, ses, &iov, 1, &resp_buftype, flags, &rsp_iov);
+	rc = smb2_send_recv(xid, ses, &iov, 1, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(iov.iov_base);
 	if (rc) {
 		cifs_stats_fail_inc(tcon, SMB2_QUERY_INFO_HE);
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 630a5c064f0c..19d34881815f 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -989,7 +989,7 @@ struct smb2_query_directory_rsp {
 #define SL_INDEX_SPECIFIED	0x00000004
 
 struct smb2_query_info_req {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize; /* Must be 41 */
 	__u8   InfoType;
 	__u8   FileInfoClass;
-- 
2.13.3
