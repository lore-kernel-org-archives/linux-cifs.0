From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH v2 47/53] CIFS: Enable signing in SMB2
Date: Fri, 28 Oct 2011 23:54:58 +0400
Message-ID: <1319831704-3572-48-git-send-email-piastry@etersoft.ru>
References: <1319831704-3572-1-git-send-email-piastry@etersoft.ru>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319831704-3572-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Enable signing in smb2. For smb2, hmac-sha256 is used instead
of hmac-md5 used for cifs/smb.

Signature field in smb2 header is 16 bytes instead of 8 bytes.

Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/Kconfig         |    1 +
 fs/cifs/cifsencrypt.c   |   30 +++++++-
 fs/cifs/cifsglob.h      |    2 +
 fs/cifs/smb2pdu.c       |   39 +++++++++-
 fs/cifs/smb2pdu.h       |    3 +
 fs/cifs/smb2proto.h     |    4 +-
 fs/cifs/smb2transport.c |  186 ++++++++++++++++++++++++++++++++++++++++++++--
 7 files changed, 247 insertions(+), 18 deletions(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index f66cc16..ed5452e 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -9,6 +9,7 @@ config CIFS
 	select CRYPTO_ARC4
 	select CRYPTO_ECB
 	select CRYPTO_DES
+	select CRYPTO_SHA256
 	help
 	  This is the client VFS module for the Common Internet File System
 	  (CIFS) protocol which is the successor to the Server Message Block
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 2cfb695..82e9d58 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -681,12 +681,17 @@ calc_seckey(struct cifs_ses *ses)
 void
 cifs_crypto_shash_release(struct TCP_Server_Info *server)
 {
+	if (server->secmech.hmacsha256)
+		crypto_free_shash(server->secmech.hmacsha256);
+
 	if (server->secmech.md5)
 		crypto_free_shash(server->secmech.md5);
 
 	if (server->secmech.hmacmd5)
 		crypto_free_shash(server->secmech.hmacmd5);
 
+	kfree(server->secmech.sdeschmacsha256);
+
 	kfree(server->secmech.sdeschmacmd5);
 
 	kfree(server->secmech.sdescmd5);
@@ -711,6 +716,13 @@ cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
 		goto crypto_allocate_md5_fail;
 	}
 
+	server->secmech.hmacsha256 = crypto_alloc_shash("hmac(sha256)", 0, 0);
+	if (IS_ERR(server->secmech.hmacsha256)) {
+		cERROR(1, "could not allocate crypto hmacsha256\n");
+		rc = PTR_ERR(server->secmech.hmacsha256);
+		goto crypto_allocate_hmacsha256_fail;
+	}
+
 	size = sizeof(struct shash_desc) +
 			crypto_shash_descsize(server->secmech.hmacmd5);
 	server->secmech.sdeschmacmd5 = kmalloc(size, GFP_KERNEL);
@@ -722,7 +734,6 @@ cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
 	server->secmech.sdeschmacmd5->shash.tfm = server->secmech.hmacmd5;
 	server->secmech.sdeschmacmd5->shash.flags = 0x0;
 
-
 	size = sizeof(struct shash_desc) +
 			crypto_shash_descsize(server->secmech.md5);
 	server->secmech.sdescmd5 = kmalloc(size, GFP_KERNEL);
@@ -734,12 +745,29 @@ cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
 	server->secmech.sdescmd5->shash.tfm = server->secmech.md5;
 	server->secmech.sdescmd5->shash.flags = 0x0;
 
+	size = sizeof(struct shash_desc) +
+			crypto_shash_descsize(server->secmech.hmacsha256);
+	server->secmech.sdeschmacsha256 = kmalloc(size, GFP_KERNEL);
+	if (!server->secmech.sdeschmacsha256) {
+		cERROR(1, "%s: Can't alloc hmacsha256\n", __func__);
+		rc = -ENOMEM;
+		goto crypto_allocate_hmacsha256_sdesc_fail;
+	}
+	server->secmech.sdeschmacsha256->shash.tfm = server->secmech.hmacsha256;
+	server->secmech.sdeschmacsha256->shash.flags = 0x0;
+
 	return 0;
 
+crypto_allocate_hmacsha256_sdesc_fail:
+	kfree(server->secmech.sdescmd5);
+
 crypto_allocate_md5_sdesc_fail:
 	kfree(server->secmech.sdeschmacmd5);
 
 crypto_allocate_hmacmd5_sdesc_fail:
+	crypto_free_shash(server->secmech.hmacsha256);
+
+crypto_allocate_hmacsha256_fail:
 	crypto_free_shash(server->secmech.md5);
 
 crypto_allocate_md5_fail:
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 56962a5..520fe75 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -131,8 +131,10 @@ struct sdesc {
 struct cifs_secmech {
 	struct crypto_shash *hmacmd5; /* hmac-md5 hash function */
 	struct crypto_shash *md5; /* md5 hash function */
+	struct crypto_shash *hmacsha256; /* hmac-sha256 hash function */
 	struct sdesc *sdeschmacmd5;  /* ctxt to generate ntlmv2 hash, CR1 */
 	struct sdesc *sdescmd5; /* ctxt to generate cifs/smb signature */
+	struct sdesc *sdeschmacsha256;  /* ctxt to generate smb2 signature */
 };
 
 /* per smb session structure/fields */
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 25d7ac2..ee7eec1 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -173,8 +173,7 @@ set_tcon_flags:
 /*	if (tcon->nocase)
 		buffer->Flags  |= SMBFLG_CASELESS; */
 	if ((tcon->ses) && (tcon->ses->server))
-		if (tcon->ses->server->sec_mode &
-		      SMB2_NEGOTIATE_SIGNING_REQUIRED)
+		if (tcon->ses->server->sec_mode & SECMODE_SIGN_REQUIRED)
 			buffer->Flags |= SMB2_FLAGS_SIGNED;
 out:
 	smb->StructureSize2 = cpu_to_le16(parmsize);
@@ -661,6 +660,37 @@ SMB2_negotiate(unsigned int xid, struct cifs_ses *ses)
 		rc = -EIO;
 		goto neg_exit;
 	}
+
+	if ((sec_flags & CIFSSEC_MAY_SIGN) == 0) {
+		/* MUST_SIGN already includes the MAY_SIGN FLAG
+		   so if this is zero it means that signing is disabled */
+		cFYI(1, "Signing disabled");
+		if (ses->server->sec_mode & SMB2_NEGOTIATE_SIGNING_REQUIRED) {
+			cERROR(1, "Server requires "
+				   "packet signing to be enabled in "
+				   "/proc/fs/cifs/SecurityFlags.");
+			rc = -EOPNOTSUPP;
+		}
+		ses->server->sec_mode &=
+			~(SECMODE_SIGN_ENABLED | SECMODE_SIGN_REQUIRED);
+	} else if ((sec_flags & CIFSSEC_MUST_SIGN) == CIFSSEC_MUST_SIGN) {
+		/* signing required */
+		cFYI(1, "Must sign - sec_flags 0x%x", sec_flags);
+		if ((ses->server->sec_mode & (SMB2_NEGOTIATE_SIGNING_ENABLED |
+				SMB2_NEGOTIATE_SIGNING_REQUIRED)) == 0) {
+			cERROR(1, "signing required but server lacks support");
+			rc = -EOPNOTSUPP;
+		} else
+			ses->server->sec_mode
+				|= SECMODE_SIGN_REQUIRED;
+	} else {
+		/* signing optional ie CIFSSEC_MAY_SIGN */
+		if ((ses->server->sec_mode & SMB2_NEGOTIATE_SIGNING_REQUIRED)
+									== 0)
+			ses->server->sec_mode &=
+				~(SECMODE_SIGN_ENABLED | SECMODE_SIGN_REQUIRED);
+	}
+
 #ifdef CONFIG_SMB2_ASN1  /* BB REMOVEME when updated asn1.c ready */
 	rc = decode_neg_token_init(security_blob, blob_length,
 				   &ses->server->sec_type);
@@ -933,7 +963,6 @@ SMB2_tcon(unsigned int xid, struct cifs_ses *ses,
 	pSMB2->hdr.smb2_buf_length =
 		cpu_to_be32(be32_to_cpu(pSMB2->hdr.smb2_buf_length)
 			    - 1 /* pad */ + unc_path_len);
-
 	rc = smb2_sendrcv2(xid, ses, iov, 2, &resp_buftype /* ret */, &status,
 			   CIFS_STD_OP | CIFS_LOG_ERROR);
 	cFYI(1, "tcon buftype %d rc %d status %d", resp_buftype, rc, status);
@@ -2476,9 +2505,9 @@ smb2_readv_callback(struct mid_q_entry *mid)
 		/* result already set, check signature */
 		if (server->sec_mode &
 		    (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
-/*			if (smb2_verify_signature(mid->resp_buf, server))
+			if (smb2_verify_signature(mid->resp_buf, server))
 				cERROR(1, "Unexpected SMB signature");
-*/		}
+		}
 		/* FIXME: should this be counted toward the initiating task? */
 		task_io_account_read(rdata->bytes);
 		cifs_stats_bytes_read(tcon, rdata->bytes);
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 3558057..d04e8b6 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -1058,4 +1058,7 @@ struct symlink_reparse_data_buf {
 	char pathbuffer[1];
 } __attribute__((packed));
 
+#define SMB2_SIGNATURE_SIZE (16)
+#define SMB2_NTLMV2_SESSKEY_SIZE (16)
+#define SMB2_HMACSHA256_SIZE (32)
 #endif				/* _SMB2PDU_H */
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index ef88f98..0425700 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -93,9 +93,7 @@ extern int smb2_sendrcv_blocking(const unsigned int xid, struct cifs_tcon *tcon,
 			struct smb2_hdr *out_buf,
 			int *pbytes_returned);
 extern int sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *);
-/* BB FIXME - need to add SMB2's signing mechanism - not same as CIFS BB */
-/*extern int smb2_verify_signature(struct smb2_hdr *,
-				 const struct mac_key *mac_key);*/
+extern int smb2_verify_signature(struct smb2_hdr *, struct TCP_Server_Info *);
 extern void smb2_echo_request(struct work_struct *work);
 extern int smb2_demultiplex_thread(struct TCP_Server_Info *server);
 extern int smb2_observe_thread(struct TCP_Server_Info *server);
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index adb701f..acdd0c6 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -37,6 +37,178 @@
 
 extern mempool_t *smb2_mid_poolp;
 
+static int
+smb2_calc_signature(struct smb2_hdr *smb2_pdu, struct TCP_Server_Info *server,
+		    char *signature)
+{
+	int rc;
+	unsigned char smb2_signature[SMB2_HMACSHA256_SIZE];
+	unsigned char *sigptr = smb2_signature;
+
+	memset(smb2_signature, 0x0, SMB2_HMACSHA256_SIZE);
+	memset(smb2_pdu->Signature, 0x0, SMB2_SIGNATURE_SIZE);
+
+	rc = crypto_shash_setkey(server->secmech.hmacsha256,
+		server->session_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
+	if (rc) {
+		cERROR(1, "%s: Could not update with response\n", __func__);
+		return rc;
+	}
+
+	rc = crypto_shash_init(&server->secmech.sdeschmacsha256->shash);
+	if (rc) {
+		cERROR(1, "%s: Could not init md5\n", __func__);
+		return rc;
+	}
+
+	rc = crypto_shash_update(&server->secmech.sdeschmacsha256->shash,
+				smb2_pdu->ProtocolId,
+				be32_to_cpu(smb2_pdu->smb2_buf_length));
+	if (rc) {
+		cERROR(1, "%s: Could not update with payload\n", __func__);
+		return rc;
+	}
+
+	rc = crypto_shash_final(&server->secmech.sdeschmacsha256->shash,
+					sigptr);
+	if (rc)
+		cERROR(1, "%s: Could not generate sha256 hash\n", __func__);
+
+	memcpy(smb2_pdu->Signature, sigptr, SMB2_NTLMV2_SESSKEY_SIZE);
+
+	return rc;
+}
+
+static int
+smb2_calc_signature2(const struct kvec *iov, int n_vec,
+		     struct TCP_Server_Info *server, struct smb2_hdr *smb2_pdu)
+{
+	int i, rc;
+	unsigned char smb2_signature[SMB2_HMACSHA256_SIZE];
+	unsigned char *sigptr = smb2_signature;
+
+	memset(smb2_signature, 0x0, SMB2_HMACSHA256_SIZE);
+	memset(smb2_pdu->Signature, 0x0, SMB2_SIGNATURE_SIZE);
+
+	rc = crypto_shash_setkey(server->secmech.hmacsha256,
+		server->session_key.response, SMB2_NTLMV2_SESSKEY_SIZE);
+	if (rc) {
+		cERROR(1, "%s: Could not update with response\n", __func__);
+		return rc;
+	}
+
+	rc = crypto_shash_init(&server->secmech.sdeschmacsha256->shash);
+	if (rc) {
+		cERROR(1, "%s: Could not init md5\n", __func__);
+		return rc;
+	}
+
+	for (i = 0; i < n_vec; i++) {
+		if (iov[i].iov_len == 0)
+			continue;
+		if (iov[i].iov_base == NULL) {
+			cERROR(1, "null iovec entry");
+			return -EIO;
+		}
+		/*
+		 * The first entry includes a length field (which does not get
+		 * signed that occupies the first 4 bytes before the header
+		 */
+		if (i == 0) {
+			if (iov[0].iov_len <= 8) /* cmd field at offset 9 */
+				break; /* nothing to sign or corrupt header */
+			rc =
+			crypto_shash_update(
+				&server->secmech.sdeschmacsha256->shash,
+				iov[i].iov_base + 4, iov[i].iov_len - 4);
+		} else {
+			rc =
+			crypto_shash_update(
+				&server->secmech.sdeschmacsha256->shash,
+				iov[i].iov_base, iov[i].iov_len);
+		}
+		if (rc) {
+			cERROR(1, "%s: Could not update with payload\n",
+							__func__);
+			return rc;
+		}
+	}
+
+	rc = crypto_shash_final(&server->secmech.sdeschmacsha256->shash,
+					sigptr);
+	if (rc)
+		cERROR(1, "%s: Could not generate sha256 hash\n", __func__);
+
+	memcpy(smb2_pdu->Signature, sigptr, SMB2_NTLMV2_SESSKEY_SIZE);
+
+	return rc;
+}
+
+/* must be called with server->srv_mutex held */
+static int smb2_sign_smb2(struct kvec *iov, int n_vec,
+			  struct TCP_Server_Info *server)
+{
+	int rc = 0;
+	struct smb2_hdr *smb2_pdu = iov[0].iov_base;
+
+	if (!(smb2_pdu->Flags & SMB2_FLAGS_SIGNED) ||
+	    server->tcpStatus == CifsNeedNegotiate)
+		return rc;
+
+	if (!server->session_estab) {
+		strncpy(smb2_pdu->Signature, "BSRSPYL", 8);
+		return rc;
+	}
+
+	rc = smb2_calc_signature2(iov, n_vec, server, smb2_pdu);
+
+	return rc;
+}
+
+int
+smb2_verify_signature(struct smb2_hdr *smb2_pdu, struct TCP_Server_Info *server)
+{
+	unsigned int rc;
+	char server_response_sig[16];
+	char what_we_think_sig_should_be[20];
+
+	if ((smb2_pdu->Command == SMB2_NEGOTIATE) ||
+			(smb2_pdu->Command == SMB2_OPLOCK_BREAK) ||
+			(!server->session_estab))
+		return 0;
+
+	/*
+	 * BB what if signatures are supposed to be on for session but
+	 * server does not send one? BB
+	 */
+
+	/* Do not need to verify session setups with signature "BSRSPYL "  */
+	if (memcmp(smb2_pdu->Signature, "BSRSPYL ", 8) == 0)
+		cFYI(1, "dummy signature received for smb command 0x%x",
+			smb2_pdu->Command);
+
+	/*
+	 * Save off the origiginal signature so we can modify the smb and check
+	 * our calculated signature against what the server sent
+	 */
+	memcpy(server_response_sig, smb2_pdu->Signature, 16);
+
+	memset(smb2_pdu->Signature, 0, 16);
+
+	rc = smb2_calc_signature(smb2_pdu, server, what_we_think_sig_should_be);
+
+	if (rc)
+		return rc;
+
+/*	smb2_dump_mem("what we think it should be: ",
+		      what_we_think_sig_should_be, 16); */
+
+	if (memcmp(server_response_sig, what_we_think_sig_should_be, 8))
+		return -EACCES;
+	else
+		return 0;
+
+}
 /*
  * Set message id for the request. Should be called after wait_for_free_response
  * and locking srv_mutex. iov array must have at least 1 element.
@@ -283,12 +455,8 @@ smb2_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 	/* convert the length into a more usable form */
 	if ((receive_len > 24) &&
 	    (server->sec_mode & SMB2_NEGOTIATE_SIGNING_REQUIRED)) {
-		/* BB fixme */
-		/*rc = smb2_verify_signature(mid->resp_buf,
-					&ses->server->mac_signing_key);
-		if (rc) {
+		if (smb2_verify_signature(mid->resp_buf, server))
 			cERROR(1, "Unexpected SMB signature");
-		} */
 	}
 
 	return map_smb2_to_linux_error(mid->resp_buf, log_error);
@@ -353,12 +521,13 @@ smb2_sendrcv2(const unsigned int xid, struct cifs_ses *ses,
 		wake_up(&ses->server->request_q);
 		return rc;
 	}
-	/* rc = sign_smb2(iov, n_vec, ses->server); BB
+
+	rc = smb2_sign_smb2(iov, n_vec, ses->server);
 	if (rc) {
 		mutex_unlock(&ses->server->srv_mutex);
 		cifs_small_buf_release(buf);
 		goto out;
-	} */
+	}
 
 	midQ->mid_state = MID_REQUEST_SUBMITTED;
 	cifs_in_send_inc(ses->server);
@@ -479,12 +648,11 @@ smb2_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 	list_add_tail(&mid->qhead, &server->pending_mid_q);
 	spin_unlock(&GlobalMid_Lock);
 
-/*	rc = cifs_sign_smb2(iov, nvec, server, &mid->sequence_number);
+	rc = smb2_sign_smb2(iov, nvec, server);
 	if (rc) {
 		mutex_unlock(&server->srv_mutex);
 		goto out_err;
 	}
-*/
 
 	mid->receive = receive;
 	mid->callback = callback;
-- 
1.7.1
