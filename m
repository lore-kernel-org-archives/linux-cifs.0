From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 17/19] cifs: remove rfc1002 header from smb2_query_directory_req
Date: Tue, 21 Nov 2017 11:04:40 +1100
Message-ID: <20171121000442.24888-18-lsahlber@redhat.com>
References: <20171121000442.24888-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171121000442.24888-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 14 +++++++-------
 fs/cifs/smb2pdu.h |  2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 8fa79a4bf1a3..cbdf61d95fa2 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2993,13 +2993,15 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 	unsigned int output_size = CIFSMaxBufSize;
 	size_t info_buf_size;
 	int flags = 0;
+	unsigned int total_len;
 
 	if (ses && (ses->server))
 		server = ses->server;
 	else
 		return -EIO;
 
-	rc = small_smb2_init(SMB2_QUERY_DIRECTORY, tcon, (void **) &req);
+	rc = smb2_plain_req_init(SMB2_QUERY_DIRECTORY, tcon, (void **) &req,
+			     &total_len);
 	if (rc)
 		return rc;
 
@@ -3031,7 +3033,7 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 	memcpy(bufptr, &asteriks, len);
 
 	req->FileNameOffset =
-		cpu_to_le16(sizeof(struct smb2_query_directory_req) - 1 - 4);
+		cpu_to_le16(sizeof(struct smb2_query_directory_req) - 1);
 	req->FileNameLength = cpu_to_le16(len);
 	/*
 	 * BB could be 30 bytes or so longer if we used SMB2 specific
@@ -3042,15 +3044,13 @@ SMB2_query_directory(const unsigned int xid, struct cifs_tcon *tcon,
 	req->OutputBufferLength = cpu_to_le32(output_size);
 
 	iov[0].iov_base = (char *)req;
-	/* 4 for RFC1001 length and 1 for Buffer */
-	iov[0].iov_len = get_rfc1002_length(req) + 4 - 1;
+	/* 1 for Buffer */
+	iov[0].iov_len = total_len - 1;
 
 	iov[1].iov_base = (char *)(req->Buffer);
 	iov[1].iov_len = len;
 
-	inc_rfc1001_len(req, len - 1 /* Buffer */);
-
-	rc = SendReceive2(xid, ses, iov, 2, &resp_buftype, flags, &rsp_iov);
+	rc = smb2_send_recv(xid, ses, iov, 2, &resp_buftype, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	rsp = (struct smb2_query_directory_rsp *)rsp_iov.iov_base;
 
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index f0d6e637b95f..630a5c064f0c 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -942,7 +942,7 @@ struct smb2_echo_rsp {
 #define SMB2_REOPEN			0x10
 
 struct smb2_query_directory_req {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize; /* Must be 33 */
 	__u8   FileInformationClass;
 	__u8   Flags;
-- 
2.13.3
