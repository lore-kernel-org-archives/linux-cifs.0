From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 11/19] cifs: remove rfc1002 header from smb2_flush_req
Date: Tue, 21 Nov 2017 11:04:34 +1100
Message-ID: <20171121000442.24888-12-lsahlber@redhat.com>
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
index 8c927c6098da..c1dd5961cf3f 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2433,13 +2433,14 @@ SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	int resp_buftype;
 	int rc = 0;
 	int flags = 0;
+	unsigned int total_len;
 
 	cifs_dbg(FYI, "Flush\n");
 
 	if (!ses || !(ses->server))
 		return -EIO;
 
-	rc = small_smb2_init(SMB2_FLUSH, tcon, (void **) &req);
+	rc = smb2_plain_req_init(SMB2_FLUSH, tcon, (void **) &req, &total_len);
 	if (rc)
 		return rc;
 
@@ -2450,10 +2451,9 @@ SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 	req->VolatileFileId = volatile_fid;
 
 	iov[0].iov_base = (char *)req;
-	/* 4 for rfc1002 length field */
-	iov[0].iov_len = get_rfc1002_length(req) + 4;
+	iov[0].iov_len = total_len;
 
-	rc = SendReceive2(xid, ses, iov, 1, &resp_buftype, flags, &rsp_iov);
+	rc = smb2_send_recv(xid, ses, iov, 1, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 
 	if (rc != 0)
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 6e1874a81014..a8102e5f4ebb 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -812,7 +812,7 @@ struct smb2_close_rsp {
 } __packed;
 
 struct smb2_flush_req {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize;	/* Must be 24 */
 	__le16 Reserved1;
 	__le32 Reserved2;
-- 
2.13.3
