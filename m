From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 16/19] cifs: remove rfc1002 header from smb2_set_info_req
Date: Thu,  9 Nov 2017 12:14:30 +1100
Message-ID: <20171109011433.14468-17-lsahlber@redhat.com>
References: <20171109011433.14468-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171109011433.14468-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 19 +++++++++----------
 fs/cifs/smb2pdu.h |  2 +-
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 192b07bcc330..af807b7417b4 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3118,6 +3118,7 @@ send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
 	unsigned int i;
 	struct cifs_ses *ses = tcon->ses;
 	int flags = 0;
+	unsigned int total_len;
 
 	if (!ses || !(ses->server))
 		return -EIO;
@@ -3129,7 +3130,7 @@ send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
 	if (!iov)
 		return -ENOMEM;
 
-	rc = small_smb2_init(SMB2_SET_INFO, tcon, (void **) &req);
+	rc = smb2_plain_req_init(SMB2_SET_INFO, tcon, (void **) &req, &total_len);
 	if (rc) {
 		kfree(iov);
 		return rc;
@@ -3138,7 +3139,7 @@ send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
 	if (encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	req->hdr.sync_hdr.ProcessId = cpu_to_le32(pid);
+	req->sync_hdr.ProcessId = cpu_to_le32(pid);
 
 	req->InfoType = info_type;
 	req->FileInfoClass = info_class;
@@ -3146,27 +3147,25 @@ send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
 	req->VolatileFileId = volatile_fid;
 	req->AdditionalInformation = cpu_to_le32(additional_info);
 
-	/* 4 for RFC1001 length and 1 for Buffer */
 	req->BufferOffset =
-			cpu_to_le16(sizeof(struct smb2_set_info_req) - 1 - 4);
+			cpu_to_le16(sizeof(struct smb2_set_info_req) - 1);
 	req->BufferLength = cpu_to_le32(*size);
 
-	inc_rfc1001_len(req, *size - 1 /* Buffer */);
-
 	memcpy(req->Buffer, *data, *size);
+	total_len += *size;
 
 	iov[0].iov_base = (char *)req;
-	/* 4 for RFC1001 length */
-	iov[0].iov_len = get_rfc1002_length(req) + 4;
+	/* 1 for Buffer */
+	iov[0].iov_len = total_len - 1;
 
 	for (i = 1; i < num; i++) {
-		inc_rfc1001_len(req, size[i]);
 		le32_add_cpu(&req->BufferLength, size[i]);
 		iov[i].iov_base = (char *)data[i];
 		iov[i].iov_len = size[i];
 	}
 
-	rc = SendReceive2(xid, ses, iov, num, &resp_buftype, flags, &rsp_iov);
+	rc = smb2_send_recv(xid, ses, iov, num, &resp_buftype, flags,
+			    &rsp_iov);
 	cifs_small_buf_release(req);
 	rsp = (struct smb2_set_info_rsp *)rsp_iov.iov_base;
 
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 7f2a7639ea15..f0d6e637b95f 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -1013,7 +1013,7 @@ struct smb2_query_info_rsp {
 } __packed;
 
 struct smb2_set_info_req {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize; /* Must be 33 */
 	__u8   InfoType;
 	__u8   FileInfoClass;
-- 
2.13.3
