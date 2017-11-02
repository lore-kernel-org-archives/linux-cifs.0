From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 06/19] cifs: remove rfc1002 header from smb2_ioctl_req
Date: Thu,  2 Nov 2017 18:02:59 +1100
Message-ID: <20171102070312.18903-7-lsahlber@redhat.com>
References: <20171102070312.18903-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171102070312.18903-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 21 ++++++++++-----------
 fs/cifs/smb2pdu.h |  2 +-
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 0ed1c1d3846a..91d78bed6940 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1906,6 +1906,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	int n_iov;
 	int rc = 0;
 	int flags = 0;
+	unsigned int total_len;
 
 	cifs_dbg(FYI, "SMB2 IOCTL\n");
 
@@ -1924,7 +1925,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	if (!ses || !(ses->server))
 		return -EIO;
 
-	rc = small_smb2_init(SMB2_IOCTL, tcon, (void **) &req);
+	rc = smb2_plain_req_init(SMB2_IOCTL, tcon, (void **) &req, &total_len);
 	if (rc)
 		return rc;
 
@@ -1935,8 +1936,8 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 		}
 
 		cifs_dbg(FYI, "replacing tid 0x%x with IPC tid 0x%x\n",
-			 req->hdr.sync_hdr.TreeId, ses->ipc_tid);
-		req->hdr.sync_hdr.TreeId = ses->ipc_tid;
+			 req->sync_hdr.TreeId, ses->ipc_tid);
+		req->sync_hdr.TreeId = ses->ipc_tid;
 	}
 	if (encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
@@ -1949,7 +1950,7 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 		req->InputCount = cpu_to_le32(indatalen);
 		/* do not set InputOffset if no input data */
 		req->InputOffset =
-		       cpu_to_le32(offsetof(struct smb2_ioctl_req, Buffer) - 4);
+		       cpu_to_le32(offsetof(struct smb2_ioctl_req, Buffer));
 		iov[1].iov_base = in_data;
 		iov[1].iov_len = indatalen;
 		n_iov = 2;
@@ -1984,21 +1985,19 @@ SMB2_ioctl(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	 * but if input data passed to ioctl, we do not
 	 * want to double count this, so we do not send
 	 * the dummy one byte of data in iovec[0] if sending
-	 * input data (in iovec[1]). We also must add 4 bytes
-	 * in first iovec to allow for rfc1002 length field.
+	 * input data (in iovec[1]).
 	 */
 
 	if (indatalen) {
-		iov[0].iov_len = get_rfc1002_length(req) + 4 - 1;
-		inc_rfc1001_len(req, indatalen - 1);
+		iov[0].iov_len = total_len - 1;
 	} else
-		iov[0].iov_len = get_rfc1002_length(req) + 4;
+		iov[0].iov_len = total_len;
 
 	/* validate negotiate request must be signed - see MS-SMB2 3.2.5.5 */
 	if (opcode == FSCTL_VALIDATE_NEGOTIATE_INFO)
-		req->hdr.sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
+		req->sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
 
-	rc = SendReceive2(xid, ses, iov, n_iov, &resp_buftype, flags, &rsp_iov);
+	rc = SendReceive3(xid, ses, iov, n_iov, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	rsp = (struct smb2_ioctl_rsp *)rsp_iov.iov_base;
 
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 5404207d9ee7..2c743d338a11 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -753,7 +753,7 @@ struct duplicate_extents_to_file {
 } __packed;
 
 struct smb2_ioctl_req {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize;	/* Must be 57 */
 	__u16 Reserved;
 	__le32 CtlCode;
-- 
2.13.3
