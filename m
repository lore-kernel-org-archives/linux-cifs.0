From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 07/19] cifs: remove rfc1002 header from smb2_echo_req
Date: Thu,  2 Nov 2017 18:03:00 +1100
Message-ID: <20171102070312.18903-8-lsahlber@redhat.com>
References: <20171102070312.18903-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171102070312.18903-1-lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 14 ++++++++------
 fs/cifs/smb2pdu.h |  2 +-
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 91d78bed6940..908be5899502 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2390,6 +2390,8 @@ SMB2_echo(struct TCP_Server_Info *server)
 	struct kvec iov[2];
 	struct smb_rqst rqst = { .rq_iov = iov,
 				 .rq_nvec = 2 };
+	unsigned int total_len;
+	__be32 rfc1002_marker;
 
 	cifs_dbg(FYI, "In echo request\n");
 
@@ -2399,17 +2401,17 @@ SMB2_echo(struct TCP_Server_Info *server)
 		return rc;
 	}
 
-	rc = small_smb2_init(SMB2_ECHO, NULL, (void **)&req);
+	rc = smb2_plain_req_init(SMB2_ECHO, NULL, (void **)&req, &total_len);
 	if (rc)
 		return rc;
 
-	req->hdr.sync_hdr.CreditRequest = cpu_to_le16(1);
+	req->sync_hdr.CreditRequest = cpu_to_le16(1);
 
-	/* 4 for rfc1002 length field */
 	iov[0].iov_len = 4;
-	iov[0].iov_base = (char *)req;
-	iov[1].iov_len = get_rfc1002_length(req);
-	iov[1].iov_base = (char *)req + 4;
+	rfc1002_marker = cpu_to_be32(total_len);
+	iov[0].iov_base = &rfc1002_marker;
+	iov[1].iov_len = total_len;
+	iov[1].iov_base = (char *)req;
 
 	rc = cifs_call_async(server, &rqst, NULL, smb2_echo_callback, NULL,
 			     server, CIFS_ECHO_OP);
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 2c743d338a11..b22bf8c6753e 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -924,7 +924,7 @@ struct smb2_lock_rsp {
 } __packed;
 
 struct smb2_echo_req {
-	struct smb2_hdr hdr;
+	struct smb2_sync_hdr sync_hdr;
 	__le16 StructureSize;	/* Must be 4 */
 	__u16  Reserved;
 } __packed;
-- 
2.13.3
