From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 04/19] cifs: remove rfc1002 header from smb2_tree_disconnect_req
Date: Tue, 21 Nov 2017 11:04:27 +1100
Message-ID: <20171121000442.24888-5-lsahlber@redhat.com>
References: <20171121000442.24888-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171121000442.24888-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 14 ++++++++++++--
 fs/cifs/smb2pdu.h |  2 +-
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 20757d82b86b..879192966bec 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1400,6 +1400,10 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
 	int rc = 0;
 	struct cifs_ses *ses = tcon->ses;
 	int flags = 0;
+	unsigned int total_len;
+	struct kvec iov[1];
+	struct kvec rsp_iov;
+	int resp_buf_type;
 
 	cifs_dbg(FYI, "Tree Disconnect\n");
 
@@ -1409,14 +1413,20 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
 	if ((tcon->need_reconnect) || (tcon->ses->need_reconnect))
 		return 0;
 
-	rc = small_smb2_init(SMB2_TREE_DISCONNECT, tcon, (void **) &req);
+	rc = smb2_plain_req_init(SMB2_TREE_DISCONNECT, tcon, (void **) &req,
+			     &total_len);
 	if (rc)
 		return rc;
 
 	if (encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
 
-	rc = SendReceiveNoRsp(xid, ses, (char *)req, flags);
+	flags |= CIFS_NO_RESP;
+
+	iov[0].iov_base = (char *)req;
+	iov[0].iov_len = total_len;
+
+	rc = smb2_send_recv(xid, ses, iov, 1, &resp_buf_type, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	if (rc)
 		cifs_stats_fail_inc(tcon, SMB2_TREE_DISCONNECT_HE);
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 0799e0957499..8b7aadefd4a5 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -375,7 +375,7 @@ struct smb2_tree_connect_rsp {
 #define SMB2_SHARE_CAP_ASYMMETRIC cpu_to_le32(0x00000080) /* 3.02 */
 
 struct smb2_tree_disconnect_req {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize;	/* Must be 4 */
 	__le16 Reserved;
 } __packed;
-- 
2.13.3
