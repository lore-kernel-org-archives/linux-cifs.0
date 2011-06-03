From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH] cifs: make debugging SMB signature issue easier
Date: Fri, 03 Jun 2011 16:49:44 +0530
Message-ID: <4DE8C350.8090100@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

... and make the error message useful. Also make a long variable name shorter
while at it.

Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/cifsencrypt.c |   14 +++++++-------
 fs/cifs/transport.c   |   10 +++++++---
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index dfbd9f1..b5aa654 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -179,7 +179,7 @@ int cifs_verify_signature(struct smb_hdr *cifs_pdu,
 {
 	unsigned int rc;
 	char server_response_sig[8];
-	char what_we_think_sig_should_be[20];
+	char expected_sig[20];
 
 	if (cifs_pdu == NULL || server == NULL)
 		return -EINVAL;
@@ -211,18 +211,18 @@ int cifs_verify_signature(struct smb_hdr *cifs_pdu,
 	cifs_pdu->Signature.Sequence.Reserved = 0;
 
 	mutex_lock(&server->srv_mutex);
-	rc = cifs_calculate_signature(cifs_pdu, server,
-		what_we_think_sig_should_be);
+	rc = cifs_calculate_signature(cifs_pdu, server, expected_sig);
 	mutex_unlock(&server->srv_mutex);
 
 	if (rc)
 		return rc;
 
-/*	cifs_dump_mem("what we think it should be: ",
-		      what_we_think_sig_should_be, 16); */
-
-	if (memcmp(server_response_sig, what_we_think_sig_should_be, 8))
+	if (memcmp(server_response_sig, expected_sig, 8)) {
+		cifs_dump_mem("Expected signature: ", expected_sig, 8);
+		cifs_dump_mem("Signature from server's response: ",
+				server_response_sig, 8);
 		return -EACCES;
+	}
 	else
 		return 0;
 
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 147aa22..d7bbbef 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -500,15 +500,19 @@ int
 cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		   bool log_error)
 {
+	int rc =0;
+
 	dump_smb(mid->resp_buf,
 		 min_t(u32, 92, be32_to_cpu(mid->resp_buf->smb_buf_length)));
 
 	/* convert the length into a more usable form */
 	if (server->sec_mode & (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
 		/* FIXME: add code to kill session */
-		if (cifs_verify_signature(mid->resp_buf, server,
-					  mid->sequence_number + 1) != 0)
-			cERROR(1, "Unexpected SMB signature");
+		rc = cifs_verify_signature(mid->resp_buf, server,
+				mid->sequence_number + 1);
+		if (rc)
+			cERROR(1, "Unexpected SMB signature, error %d while"
+					"verifying signature", rc);
 	}
 
 	/* BB special case reconnect tid and uid here? */
-- 
1.7.1
