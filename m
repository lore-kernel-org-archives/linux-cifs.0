From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 05/19] cifs: remove rfc1002 header from smb2_close_req
Date: Tue, 21 Nov 2017 11:04:28 +1100
Message-ID: <20171121000442.24888-6-lsahlber@redhat.com>
References: <20171121000442.24888-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171121000442.24888-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 8 ++++----
 fs/cifs/smb2pdu.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 879192966bec..be68b129c8fa 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2094,13 +2094,14 @@ SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 	int resp_buftype;
 	int rc = 0;
 	int flags = 0;
+	unsigned int total_len;
 
 	cifs_dbg(FYI, "Close\n");
 
 	if (!ses || !(ses->server))
 		return -EIO;
 
-	rc = small_smb2_init(SMB2_CLOSE, tcon, (void **) &req);
+	rc = smb2_plain_req_init(SMB2_CLOSE, tcon, (void **) &req, &total_len);
 	if (rc)
 		return rc;
 
@@ -2111,10 +2112,9 @@ SMB2_close(const unsigned int xid, struct cifs_tcon *tcon,
 	req->VolatileFileId = volatile_fid;
 
 	iov[0].iov_base = (char *)req;
-	/* 4 for rfc1002 length field */
-	iov[0].iov_len = get_rfc1002_length(req) + 4;
+	iov[0].iov_len = total_len;
 
-	rc = SendReceive2(xid, ses, iov, 1, &resp_buftype, flags, &rsp_iov);
+	rc = smb2_send_recv(xid, ses, iov, 1, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	rsp = (struct smb2_close_rsp *)rsp_iov.iov_base;
 
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 8b7aadefd4a5..5404207d9ee7 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -789,7 +789,7 @@ struct smb2_ioctl_rsp {
 /* Currently defined values for close flags */
 #define SMB2_CLOSE_FLAG_POSTQUERY_ATTRIB	cpu_to_le16(0x0001)
 struct smb2_close_req {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize;	/* Must be 24 */
 	__le16 Flags;
 	__le32 Reserved;
-- 
2.13.3
