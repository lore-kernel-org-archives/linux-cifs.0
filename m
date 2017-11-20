From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 03/19] cifs: remove rfc1002 header from smb2_logoff_req
Date: Mon, 20 Nov 2017 11:24:31 +1100
Message-ID: <20171120002447.32322-4-lsahlber@redhat.com>
References: <20171120002447.32322-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171120002447.32322-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 17 +++++++++++++----
 fs/cifs/smb2pdu.h |  2 +-
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index adfae01fe4d9..20757d82b86b 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1204,6 +1204,10 @@ SMB2_logoff(const unsigned int xid, struct cifs_ses *ses)
 	int rc = 0;
 	struct TCP_Server_Info *server;
 	int flags = 0;
+	unsigned int total_len;
+	struct kvec iov[1];
+	struct kvec rsp_iov;
+	int resp_buf_type;
 
 	cifs_dbg(FYI, "disconnect session %p\n", ses);
 
@@ -1216,19 +1220,24 @@ SMB2_logoff(const unsigned int xid, struct cifs_ses *ses)
 	if (ses->need_reconnect)
 		goto smb2_session_already_dead;
 
-	rc = small_smb2_init(SMB2_LOGOFF, NULL, (void **) &req);
+	rc = smb2_plain_req_init(SMB2_LOGOFF, NULL, (void **) &req, &total_len);
 	if (rc)
 		return rc;
 
 	 /* since no tcon, smb2_init can not do this, so do here */
-	req->hdr.sync_hdr.SessionId = ses->Suid;
+	req->sync_hdr.SessionId = ses->Suid;
 
 	if (ses->session_flags & SMB2_SESSION_FLAG_ENCRYPT_DATA)
 		flags |= CIFS_TRANSFORM_REQ;
 	else if (server->sign)
-		req->hdr.sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
+		req->sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
+
+	flags |= CIFS_NO_RESP;
+
+	iov[0].iov_base = (char *)req;
+	iov[0].iov_len = total_len;
 
-	rc = SendReceiveNoRsp(xid, ses, (char *) req, flags);
+	rc = smb2_send_recv(xid, ses, iov, 1, &resp_buf_type, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 	/*
 	 * No tcon so can't do
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 0fe2382597ad..0799e0957499 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -308,7 +308,7 @@ struct smb2_sess_setup_rsp {
 } __packed;
 
 struct smb2_logoff_req {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize;	/* Must be 4 */
 	__le16 Reserved;
 } __packed;
-- 
2.13.3
