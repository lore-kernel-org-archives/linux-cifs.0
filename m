From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 14/19] cifs: remove rfc1002 header from smb2_lease_ack
Date: Mon, 20 Nov 2017 11:24:42 +1100
Message-ID: <20171120002447.32322-15-lsahlber@redhat.com>
References: <20171120002447.32322-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171120002447.32322-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 19 +++++++++++++++----
 fs/cifs/smb2pdu.h |  2 +-
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 58f02213696a..42fc53f0c90d 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3573,24 +3573,35 @@ SMB2_lease_break(const unsigned int xid, struct cifs_tcon *tcon,
 {
 	int rc;
 	struct smb2_lease_ack *req = NULL;
+	struct cifs_ses *ses = tcon->ses;
 	int flags = CIFS_OBREAK_OP;
+	unsigned int total_len;
+	struct kvec iov[1];
+	struct kvec rsp_iov;
+	int resp_buf_type;
 
 	cifs_dbg(FYI, "SMB2_lease_break\n");
-	rc = small_smb2_init(SMB2_OPLOCK_BREAK, tcon, (void **) &req);
+	rc = smb2_plain_req_init(SMB2_OPLOCK_BREAK, tcon, (void **) &req,
+			     &total_len);
 	if (rc)
 		return rc;
 
 	if (encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	req->hdr.sync_hdr.CreditRequest = cpu_to_le16(1);
+	req->sync_hdr.CreditRequest = cpu_to_le16(1);
 	req->StructureSize = cpu_to_le16(36);
-	inc_rfc1001_len(req, 12);
+	total_len += 12;
 
 	memcpy(req->LeaseKey, lease_key, 16);
 	req->LeaseState = lease_state;
 
-	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) req, flags);
+	flags |= CIFS_NO_RESP;
+
+	iov[0].iov_base = (char *)req;
+	iov[0].iov_len = total_len;
+
+	rc = smb2_send_recv(xid, ses, iov, 1, &resp_buf_type, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 
 	if (rc) {
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 3c856f058be7..32f0f633b614 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -1057,7 +1057,7 @@ struct smb2_lease_break {
 } __packed;
 
 struct smb2_lease_ack {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize; /* Must be 36 */
 	__le16 Reserved;
 	__le32 Flags;
-- 
2.13.3
