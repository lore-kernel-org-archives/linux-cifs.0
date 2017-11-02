From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 09/19] cifs: remove rfc1002 header from smb2_tree_connect_req
Date: Thu,  2 Nov 2017 18:03:02 +1100
Message-ID: <20171102070312.18903-10-lsahlber@redhat.com>
References: <20171102070312.18903-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171102070312.18903-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 18 +++++++++---------
 fs/cifs/smb2pdu.h |  2 +-
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index bfd805da6874..305e4be511ba 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1269,6 +1269,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	int unc_path_len;
 	__le16 *unc_path = NULL;
 	int flags = 0;
+	unsigned int total_len;
 
 	cifs_dbg(FYI, "TCON\n");
 
@@ -1290,7 +1291,8 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	if (tcon)
 		tcon->tid = 0;
 
-	rc = small_smb2_init(SMB2_TREE_CONNECT, tcon, (void **) &req);
+	rc = smb2_plain_req_init(SMB2_TREE_CONNECT, tcon, (void **) &req,
+			     &total_len);
 	if (rc) {
 		kfree(unc_path);
 		return rc;
@@ -1301,26 +1303,24 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 			flags |= CIFS_TRANSFORM_REQ;
 
 		/* since no tcon, smb2_init can not do this, so do here */
-		req->hdr.sync_hdr.SessionId = ses->Suid;
+		req->sync_hdr.SessionId = ses->Suid;
 		if (ses->server->sign)
-			req->hdr.sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
+			req->sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
 	} else if (encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
 	iov[0].iov_base = (char *)req;
-	/* 4 for rfc1002 length field and 1 for pad */
-	iov[0].iov_len = get_rfc1002_length(req) + 4 - 1;
+	/* 1 for pad */
+	iov[0].iov_len = total_len - 1;
 
 	/* Testing shows that buffer offset must be at location of Buffer[0] */
 	req->PathOffset = cpu_to_le16(sizeof(struct smb2_tree_connect_req)
-			- 1 /* pad */ - 4 /* do not count rfc1001 len field */);
+			- 1 /* pad */);
 	req->PathLength = cpu_to_le16(unc_path_len - 2);
 	iov[1].iov_base = unc_path;
 	iov[1].iov_len = unc_path_len;
 
-	inc_rfc1001_len(req, unc_path_len - 1 /* pad */);
-
-	rc = SendReceive2(xid, ses, iov, 2, &resp_buftype, flags, &rsp_iov);
+	rc = SendReceive3(xid, ses, iov, 2, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	rsp = (struct smb2_tree_connect_rsp *)rsp_iov.iov_base;
 
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index e7acfa5e3fa6..4f80b95d02ae 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -323,7 +323,7 @@ struct smb2_logoff_rsp {
 #define SMB2_SHAREFLAG_CLUSTER_RECONNECT	0x0001
 
 struct smb2_tree_connect_req {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize;	/* Must be 9 */
 	__le16 Reserved; /* Flags in SMB3.1.1 */
 	__le16 PathOffset;
-- 
2.13.3
