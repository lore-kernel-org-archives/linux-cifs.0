From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/3] [SMB3] decode_negTokenInit had wrong calling sequence
Date: Mon, 20 Oct 2014 15:09:02 -0500
Message-ID: <1413835743-13566-2-git-send-email-smfrench@gmail.com>
References: <1413835743-13566-1-git-send-email-smfrench@gmail.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1413835743-13566-1-git-send-email-smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

For krb5 enablement of SMB3, decoding negprot, caller now passes
server struct not the old sec_type
---
 fs/cifs/smb2pdu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 8f1672b..0ca7f63 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -431,8 +431,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	if (rc)
 		goto neg_exit;
 	if (blob_length)
-		rc = decode_neg_token_init(security_blob, blob_length,
-				   &server->sec_type);
+		rc = decode_negTokenInit(security_blob, blob_length, server);
 	if (rc == 1)
 		rc = 0;
 	else if (rc == 0) {
-- 
1.9.1
