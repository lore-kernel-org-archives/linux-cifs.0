From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 02/16] cifs: consolidate signature generating code
Date: Fri, 26 Aug 2011 15:06:15 -0400
Message-ID: <1314385589-27136-3-git-send-email-jlayton@redhat.com>
References: <1314385589-27136-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1314385589-27136-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We have two versions of signature generating code. A vectorized and
non-vectorized version. Eliminate a large chunk of cut-and-paste
code by turning the non-vectorized version into a wrapper around the
vectorized one.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsencrypt.c |  103 ++++++++++---------------------------------------
 fs/cifs/cifsproto.h   |    2 +-
 fs/cifs/transport.c   |   11 ++++-
 3 files changed, 30 insertions(+), 86 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index f11dfb6..cf9b338 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -37,83 +37,8 @@
  * the sequence number before this function is called. Also, this function
  * should be called with the server->srv_mutex held.
  */
-static int cifs_calculate_signature(const struct smb_hdr *cifs_pdu,
-				struct TCP_Server_Info *server, char *signature)
-{
-	int rc;
-
-	if (cifs_pdu == NULL || signature == NULL || server == NULL)
-		return -EINVAL;
-
-	if (!server->secmech.sdescmd5) {
-		cERROR(1, "%s: Can't generate signature\n", __func__);
-		return -1;
-	}
-
-	rc = crypto_shash_init(&server->secmech.sdescmd5->shash);
-	if (rc) {
-		cERROR(1, "%s: Could not init md5\n", __func__);
-		return rc;
-	}
-
-	rc = crypto_shash_update(&server->secmech.sdescmd5->shash,
-		server->session_key.response, server->session_key.len);
-	if (rc) {
-		cERROR(1, "%s: Could not update with response\n", __func__);
-		return rc;
-	}
-
-	rc = crypto_shash_update(&server->secmech.sdescmd5->shash,
-		cifs_pdu->Protocol, be32_to_cpu(cifs_pdu->smb_buf_length));
-	if (rc) {
-		cERROR(1, "%s: Could not update with payload\n", __func__);
-		return rc;
-	}
-
-	rc = crypto_shash_final(&server->secmech.sdescmd5->shash, signature);
-	if (rc)
-		cERROR(1, "%s: Could not generate md5 hash\n", __func__);
-
-	return rc;
-}
-
-/* must be called with server->srv_mutex held */
-int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct TCP_Server_Info *server,
-		  __u32 *pexpected_response_sequence_number)
-{
-	int rc = 0;
-	char smb_signature[20];
-
-	if ((cifs_pdu == NULL) || (server == NULL))
-		return -EINVAL;
-
-	if (!(cifs_pdu->Flags2 & SMBFLG2_SECURITY_SIGNATURE) ||
-	    server->tcpStatus == CifsNeedNegotiate)
-		return rc;
-
-	if (!server->session_estab) {
-		memcpy(cifs_pdu->Signature.SecuritySignature, "BSRSPYL", 8);
-		return rc;
-	}
-
-	cifs_pdu->Signature.Sequence.SequenceNumber =
-			cpu_to_le32(server->sequence_number);
-	cifs_pdu->Signature.Sequence.Reserved = 0;
-
-	*pexpected_response_sequence_number = server->sequence_number++;
-	server->sequence_number++;
-
-	rc = cifs_calculate_signature(cifs_pdu, server, smb_signature);
-	if (rc)
-		memset(cifs_pdu->Signature.SecuritySignature, 0, 8);
-	else
-		memcpy(cifs_pdu->Signature.SecuritySignature, smb_signature, 8);
-
-	return rc;
-}
-
-static int cifs_calc_signature2(const struct kvec *iov, int n_vec,
-				struct TCP_Server_Info *server, char *signature)
+static int cifs_calc_signature(const struct kvec *iov, int n_vec,
+			struct TCP_Server_Info *server, char *signature)
 {
 	int i;
 	int rc;
@@ -179,7 +104,7 @@ int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *server,
 {
 	int rc = 0;
 	char smb_signature[20];
-	struct smb_hdr *cifs_pdu = iov[0].iov_base;
+	struct smb_hdr *cifs_pdu = (struct smb_hdr *)iov[0].iov_base;
 
 	if ((cifs_pdu == NULL) || (server == NULL))
 		return -EINVAL;
@@ -200,7 +125,7 @@ int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *server,
 	*pexpected_response_sequence_number = server->sequence_number++;
 	server->sequence_number++;
 
-	rc = cifs_calc_signature2(iov, n_vec, server, smb_signature);
+	rc = cifs_calc_signature(iov, n_vec, server, smb_signature);
 	if (rc)
 		memset(cifs_pdu->Signature.SecuritySignature, 0, 8);
 	else
@@ -209,13 +134,27 @@ int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *server,
 	return rc;
 }
 
-int cifs_verify_signature(struct smb_hdr *cifs_pdu,
+/* must be called with server->srv_mutex held */
+int cifs_sign_smb(struct smb_hdr *cifs_pdu, struct TCP_Server_Info *server,
+		  __u32 *pexpected_response_sequence_number)
+{
+	struct kvec iov;
+
+	iov.iov_base = cifs_pdu;
+	iov.iov_len = be32_to_cpu(cifs_pdu->smb_buf_length) + 4;
+
+	return cifs_sign_smb2(&iov, 1, server,
+			      pexpected_response_sequence_number);
+}
+
+int cifs_verify_signature(struct kvec *iov, unsigned int nr_iov,
 			  struct TCP_Server_Info *server,
 			  __u32 expected_sequence_number)
 {
 	unsigned int rc;
 	char server_response_sig[8];
 	char what_we_think_sig_should_be[20];
+	struct smb_hdr *cifs_pdu = (struct smb_hdr *)iov[0].iov_base;
 
 	if (cifs_pdu == NULL || server == NULL)
 		return -EINVAL;
@@ -247,8 +186,8 @@ int cifs_verify_signature(struct smb_hdr *cifs_pdu,
 	cifs_pdu->Signature.Sequence.Reserved = 0;
 
 	mutex_lock(&server->srv_mutex);
-	rc = cifs_calculate_signature(cifs_pdu, server,
-		what_we_think_sig_should_be);
+	rc = cifs_calc_signature(iov, nr_iov, server,
+				 what_we_think_sig_should_be);
 	mutex_unlock(&server->srv_mutex);
 
 	if (rc)
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 8df28e9..03dc945 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -380,7 +380,7 @@ extern void tconInfoFree(struct cifs_tcon *);
 extern int cifs_sign_smb(struct smb_hdr *, struct TCP_Server_Info *, __u32 *);
 extern int cifs_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *,
 			  __u32 *);
-extern int cifs_verify_signature(struct smb_hdr *,
+extern int cifs_verify_signature(struct kvec *iov, unsigned int nr_iov,
 				 struct TCP_Server_Info *server,
 				__u32 expected_sequence_number);
 extern int SMBNTencrypt(unsigned char *, unsigned char *, unsigned char *);
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index a30c7e9..316d4cb 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -500,13 +500,18 @@ int
 cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		   bool log_error)
 {
-	dump_smb(mid->resp_buf,
-		 min_t(u32, 92, be32_to_cpu(mid->resp_buf->smb_buf_length)));
+	unsigned int len = be32_to_cpu(mid->resp_buf->smb_buf_length) + 4;
+
+	dump_smb(mid->resp_buf, min_t(u32, 92, len));
 
 	/* convert the length into a more usable form */
 	if (server->sec_mode & (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
+		struct kvec iov;
+
+		iov.iov_base = mid->resp_buf;
+		iov.iov_len = len;
 		/* FIXME: add code to kill session */
-		if (cifs_verify_signature(mid->resp_buf, server,
+		if (cifs_verify_signature(&iov, 1, server,
 					  mid->sequence_number + 1) != 0)
 			cERROR(1, "Unexpected SMB signature");
 	}
-- 
1.7.6
