From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 15/19] cifs: remove rfc1002 header from smb2_oplock_break we get from server
Date: Tue, 21 Nov 2017 11:04:38 +1100
Message-ID: <20171121000442.24888-16-lsahlber@redhat.com>
References: <20171121000442.24888-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171121000442.24888-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2misc.c |  2 +-
 fs/cifs/smb2pdu.c  | 19 +++++++++++++++----
 fs/cifs/smb2pdu.h  | 14 +++++++++++++-
 3 files changed, 29 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 7b08a1446a7f..76d03abaa38c 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -578,7 +578,7 @@ smb2_is_valid_lease_break(char *buffer)
 bool
 smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 {
-	struct smb2_oplock_break *rsp = (struct smb2_oplock_break *)buffer;
+	struct smb2_oplock_break_rsp *rsp = (struct smb2_oplock_break_rsp *)buffer;
 	struct list_head *tmp, *tmp1, *tmp2;
 	struct cifs_ses *ses;
 	struct cifs_tcon *tcon;
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 2042c2bc99e2..e43b010ae116 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3319,11 +3319,17 @@ SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 		  __u8 oplock_level)
 {
 	int rc;
-	struct smb2_oplock_break *req = NULL;
+	struct smb2_oplock_break_req *req = NULL;
+	struct cifs_ses *ses = tcon->ses;
 	int flags = CIFS_OBREAK_OP;
+	unsigned int total_len;
+	struct kvec iov[1];
+	struct kvec rsp_iov;
+	int resp_buf_type;
 
 	cifs_dbg(FYI, "SMB2_oplock_break\n");
-	rc = small_smb2_init(SMB2_OPLOCK_BREAK, tcon, (void **) &req);
+	rc = smb2_plain_req_init(SMB2_OPLOCK_BREAK, tcon, (void **) &req,
+			     &total_len);
 	if (rc)
 		return rc;
 
@@ -3333,9 +3339,14 @@ SMB2_oplock_break(const unsigned int xid, struct cifs_tcon *tcon,
 	req->VolatileFid = volatile_fid;
 	req->PersistentFid = persistent_fid;
 	req->OplockLevel = oplock_level;
-	req->hdr.sync_hdr.CreditRequest = cpu_to_le16(1);
+	req->sync_hdr.CreditRequest = cpu_to_le16(1);
+
+	flags |= CIFS_NO_RESP;
 
-	rc = SendReceiveNoRsp(xid, tcon->ses, (char *) req, flags);
+	iov[0].iov_base = (char *)req;
+	iov[0].iov_len = total_len;
+
+	rc = smb2_send_recv(xid, ses, iov, 1, &resp_buf_type, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 
 	if (rc) {
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 32f0f633b614..7f2a7639ea15 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -1031,7 +1031,19 @@ struct smb2_set_info_rsp {
 	__le16 StructureSize; /* Must be 2 */
 } __packed;
 
-struct smb2_oplock_break {
+/* oplock break without an rfc1002 header */
+struct smb2_oplock_break_req {
+	struct smb2_sync_hdr sync_hdr;
+	__le16 StructureSize; /* Must be 24 */
+	__u8   OplockLevel;
+	__u8   Reserved;
+	__le32 Reserved2;
+	__u64  PersistentFid;
+	__u64  VolatileFid;
+} __packed;
+
+/* oplock break with an rfc1002 header */
+struct smb2_oplock_break_rsp {
 	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 24 */
 	__u8   OplockLevel;
-- 
2.13.3
