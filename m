From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 02/15] cifs: change smb2 signing routines to use smb_rqst structs
Date: Mon,  6 Aug 2012 07:30:59 -0400
Message-ID: <1344252672-15244-3-git-send-email-jlayton@redhat.com>
References: <1344252672-15244-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1344252672-15244-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c       |  5 +++--
 fs/cifs/smb2proto.h     |  4 ++--
 fs/cifs/smb2transport.c | 44 ++++++++++++++++++++++----------------------
 3 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index b183420..8c70c04 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1297,6 +1297,8 @@ smb2_readv_callback(struct mid_q_entry *mid)
 	struct TCP_Server_Info *server = tcon->ses->server;
 	struct smb2_hdr *buf = (struct smb2_hdr *)rdata->iov[0].iov_base;
 	unsigned int credits_received = 1;
+	struct smb_rqst rqst = { .rq_iov = rdata->iov,
+				 .rq_nvec = rdata->nr_iov };
 
 	cFYI(1, "%s: mid=%llu state=%d result=%d bytes=%u", __func__,
 		mid->mid, mid->mid_state, rdata->result, rdata->bytes);
@@ -1307,8 +1309,7 @@ smb2_readv_callback(struct mid_q_entry *mid)
 		/* result already set, check signature */
 		if (server->sec_mode &
 		    (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
-			if (smb2_verify_signature2(rdata->iov, rdata->nr_iov,
-						   server))
+			if (smb2_verify_signature(&rqst, server))
 				cERROR(1, "Unexpected SMB signature");
 		}
 		/* FIXME: should this be counted toward the initiating task? */
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index a73a963..a9bda04 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -26,6 +26,7 @@
 #include <linux/key-type.h>
 
 struct statfs;
+struct smb_rqst;
 
 /*
  *****************************************************************
@@ -39,8 +40,7 @@ extern char *smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr);
 extern __le16 *cifs_convert_path_to_utf16(const char *from,
 					  struct cifs_sb_info *cifs_sb);
 
-extern int smb2_verify_signature2(struct kvec *, unsigned int,
-				  struct TCP_Server_Info *);
+extern int smb2_verify_signature(struct smb_rqst *, struct TCP_Server_Info *);
 extern int smb2_check_receive(struct mid_q_entry *mid,
 			      struct TCP_Server_Info *server, bool log_error);
 extern int smb2_setup_request(struct cifs_ses *ses, struct kvec *iov,
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 7276f6f..af0e390 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -39,12 +39,13 @@
 #include "smb2glob.h"
 
 static int
-smb2_calc_signature2(const struct kvec *iov, int n_vec,
-		     struct TCP_Server_Info *server)
+smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 {
 	int i, rc;
 	unsigned char smb2_signature[SMB2_HMACSHA256_SIZE];
 	unsigned char *sigptr = smb2_signature;
+	struct kvec *iov = rqst->rq_iov;
+	int n_vec = rqst->rq_nvec;
 	struct smb2_hdr *smb2_pdu = (struct smb2_hdr *)iov[0].iov_base;
 
 	memset(smb2_signature, 0x0, SMB2_HMACSHA256_SIZE);
@@ -106,10 +107,10 @@ smb2_calc_signature2(const struct kvec *iov, int n_vec,
 
 /* must be called with server->srv_mutex held */
 static int
-smb2_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *server)
+smb2_sign_rqst(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 {
 	int rc = 0;
-	struct smb2_hdr *smb2_pdu = iov[0].iov_base;
+	struct smb2_hdr *smb2_pdu = rqst->rq_iov[0].iov_base;
 
 	if (!(smb2_pdu->Flags & SMB2_FLAGS_SIGNED) ||
 	    server->tcpStatus == CifsNeedNegotiate)
@@ -120,18 +121,17 @@ smb2_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *server)
 		return rc;
 	}
 
-	rc = smb2_calc_signature2(iov, n_vec, server);
+	rc = smb2_calc_signature(rqst, server);
 
 	return rc;
 }
 
 int
-smb2_verify_signature2(struct kvec *iov, unsigned int n_vec,
-		       struct TCP_Server_Info *server)
+smb2_verify_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server)
 {
 	unsigned int rc;
 	char server_response_sig[16];
-	struct smb2_hdr *smb2_pdu = (struct smb2_hdr *)iov[0].iov_base;
+	struct smb2_hdr *smb2_pdu = (struct smb2_hdr *)rqst->rq_iov[0].iov_base;
 
 	if ((smb2_pdu->Command == SMB2_NEGOTIATE) ||
 	    (smb2_pdu->Command == SMB2_OPLOCK_BREAK) ||
@@ -157,7 +157,7 @@ smb2_verify_signature2(struct kvec *iov, unsigned int n_vec,
 	memset(smb2_pdu->Signature, 0, SMB2_SIGNATURE_SIZE);
 
 	mutex_lock(&server->srv_mutex);
-	rc = smb2_calc_signature2(iov, n_vec, server);
+	rc = smb2_calc_signature(rqst, server);
 	mutex_unlock(&server->srv_mutex);
 
 	if (rc)
@@ -170,16 +170,6 @@ smb2_verify_signature2(struct kvec *iov, unsigned int n_vec,
 		return 0;
 }
 
-static int
-smb2_verify_signature(struct smb2_hdr *smb2_pdu, struct TCP_Server_Info *server)
-{
-	struct kvec iov;
-
-	iov.iov_base = (char *)smb2_pdu;
-	iov.iov_len = get_rfc1002_length(smb2_pdu) + 4;
-	return smb2_verify_signature2(&iov, 1, server);
-}
-
 /*
  * Set message id for the request. Should be called after wait_for_free_request
  * and when srv_mutex is held.
@@ -258,12 +248,18 @@ smb2_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 		   bool log_error)
 {
 	unsigned int len = get_rfc1002_length(mid->resp_buf);
+	struct kvec iov;
+	struct smb_rqst rqst = { .rq_iov = &iov,
+				 .rq_nvec = 1 };
+
+	iov.iov_base = (char *)mid->resp_buf;
+	iov.iov_len = get_rfc1002_length(mid->resp_buf) + 4;
 
 	dump_smb(mid->resp_buf, min_t(u32, 80, len));
 	/* convert the length into a more usable form */
 	if ((len > 24) &&
 	    (server->sec_mode & (SECMODE_SIGN_REQUIRED|SECMODE_SIGN_ENABLED))) {
-		if (smb2_verify_signature(mid->resp_buf, server))
+		if (smb2_verify_signature(&rqst, server))
 			cERROR(1, "Unexpected SMB signature");
 	}
 
@@ -277,13 +273,15 @@ smb2_setup_request(struct cifs_ses *ses, struct kvec *iov,
 	int rc;
 	struct smb2_hdr *hdr = (struct smb2_hdr *)iov[0].iov_base;
 	struct mid_q_entry *mid;
+	struct smb_rqst rqst = { .rq_iov = iov,
+				 .rq_nvec = nvec };
 
 	smb2_seq_num_into_buf(ses->server, hdr);
 
 	rc = smb2_get_mid_entry(ses, hdr, &mid);
 	if (rc)
 		return rc;
-	rc = smb2_sign_smb2(iov, nvec, ses->server);
+	rc = smb2_sign_rqst(&rqst, ses->server);
 	if (rc)
 		cifs_delete_mid(mid);
 	*ret_mid = mid;
@@ -297,6 +295,8 @@ smb2_setup_async_request(struct TCP_Server_Info *server, struct kvec *iov,
 	int rc = 0;
 	struct smb2_hdr *hdr = (struct smb2_hdr *)iov[0].iov_base;
 	struct mid_q_entry *mid;
+	struct smb_rqst rqst = { .rq_iov = iov,
+				 .rq_nvec = nvec };
 
 	smb2_seq_num_into_buf(server, hdr);
 
@@ -304,7 +304,7 @@ smb2_setup_async_request(struct TCP_Server_Info *server, struct kvec *iov,
 	if (mid == NULL)
 		return -ENOMEM;
 
-	rc = smb2_sign_smb2(iov, nvec, server);
+	rc = smb2_sign_rqst(&rqst, server);
 	if (rc) {
 		DeleteMidQEntry(mid);
 		return rc;
-- 
1.7.11.2
