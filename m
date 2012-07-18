From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 30/45] CIFS: Enable signing in SMB2
Date: Wed, 18 Jul 2012 19:48:46 +0400
Message-ID: <1342626541-29872-31-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Use hmac-sha256 and rather than hmac-md5 that is used for CIFS/SMB.

Signature field in SMB2 header is 16 bytes instead of 8 bytes.

Automatically enable signing by client when requested by the server
when signing ability is available to the client.

Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/Kconfig         |    1 +
 fs/cifs/cifsencrypt.c   |   30 +++++++++-
 fs/cifs/cifsglob.h      |    2 +
 fs/cifs/cifsproto.h     |    1 +
 fs/cifs/smb2glob.h      |    4 +
 fs/cifs/smb2pdu.c       |   48 +++++++++++++--
 fs/cifs/smb2proto.h     |    2 +
 fs/cifs/smb2transport.c |  157 ++++++++++++++++++++++++++++++++++++++++++++--
 fs/cifs/transport.c     |   24 ++++----
 9 files changed, 243 insertions(+), 26 deletions(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index a08306a..8029301 100644
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
index 63c460e..e572d55 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -686,12 +686,17 @@ calc_seckey(struct cifs_ses *ses)
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
@@ -716,6 +721,13 @@ cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
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
@@ -727,7 +739,6 @@ cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
 	server->secmech.sdeschmacmd5->shash.tfm = server->secmech.hmacmd5;
 	server->secmech.sdeschmacmd5->shash.flags = 0x0;
 
-
 	size = sizeof(struct shash_desc) +
 			crypto_shash_descsize(server->secmech.md5);
 	server->secmech.sdescmd5 = kmalloc(size, GFP_KERNEL);
@@ -739,12 +750,29 @@ cifs_crypto_shash_allocate(struct TCP_Server_Info *server)
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
index 3e54b19..78ce424 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -128,8 +128,10 @@ struct sdesc {
 struct cifs_secmech {
 	struct crypto_shash *hmacmd5; /* hmac-md5 hash function */
 	struct crypto_shash *md5; /* md5 hash function */
+	struct crypto_shash *hmacsha256; /* hmac-sha256 hash function */
 	struct sdesc *sdeschmacmd5;  /* ctxt to generate ntlmv2 hash, CR1 */
 	struct sdesc *sdescmd5; /* ctxt to generate cifs/smb signature */
+	struct sdesc *sdeschmacsha256;  /* ctxt to generate smb2 signature */
 };
 
 /* per smb session structure/fields */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index bdf8948..722dba8 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -65,6 +65,7 @@ extern char *cifs_compose_mount_options(const char *sb_mountdata,
 extern struct mid_q_entry *AllocMidQEntry(const struct smb_hdr *smb_buffer,
 					struct TCP_Server_Info *server);
 extern void DeleteMidQEntry(struct mid_q_entry *midEntry);
+extern void cifs_delete_mid(struct mid_q_entry *mid);
 extern void cifs_wake_up_task(struct mid_q_entry *mid);
 extern int cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 			   unsigned int nvec, mid_receive_t *receive,
diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
index 11505d7..8635574 100644
--- a/fs/cifs/smb2glob.h
+++ b/fs/cifs/smb2glob.h
@@ -47,4 +47,8 @@
 #define END_OF_CHAIN 4
 #define RELATED_REQUEST 8
 
+#define SMB2_SIGNATURE_SIZE (16)
+#define SMB2_NTLMV2_SESSKEY_SIZE (16)
+#define SMB2_HMACSHA256_SIZE (32)
+
 #endif	/* _SMB2_GLOB_H */
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index cb7d672..46829c6 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -118,9 +118,9 @@ smb2_hdr_assemble(struct smb2_hdr *hdr, __le16 smb2_cmd /* command */ ,
 	/* BB how does SMB2 do case sensitive? */
 	/* if (tcon->nocase)
 		hdr->Flags |= SMBFLG_CASELESS; */
-	/* if (tcon->ses && tcon->ses->server &&
+	if (tcon->ses && tcon->ses->server &&
 	    (tcon->ses->server->sec_mode & SECMODE_SIGN_REQUIRED))
-		hdr->Flags |= SMB2_FLAGS_SIGNED; */
+		hdr->Flags |= SMB2_FLAGS_SIGNED;
 out:
 	pdu->StructureSize2 = cpu_to_le16(parmsize);
 	return;
@@ -441,6 +441,38 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 		rc = -EIO;
 		goto neg_exit;
 	}
+
+	cFYI(1, "sec_flags 0x%x", sec_flags);
+	if (sec_flags & CIFSSEC_MUST_SIGN) {
+		cFYI(1, "Signing required");
+		if (!(server->sec_mode & (SMB2_NEGOTIATE_SIGNING_REQUIRED |
+		      SMB2_NEGOTIATE_SIGNING_ENABLED))) {
+			cERROR(1, "signing required but server lacks support");
+			rc = -EOPNOTSUPP;
+			goto neg_exit;
+		}
+		server->sec_mode |= SECMODE_SIGN_REQUIRED;
+	} else if (sec_flags & CIFSSEC_MAY_SIGN) {
+		cFYI(1, "Signing optional");
+		if (server->sec_mode & SMB2_NEGOTIATE_SIGNING_REQUIRED) {
+			cFYI(1, "Server requires signing");
+			server->sec_mode |= SECMODE_SIGN_REQUIRED;
+		} else {
+			server->sec_mode &=
+				~(SECMODE_SIGN_ENABLED | SECMODE_SIGN_REQUIRED);
+		}
+	} else {
+		cFYI(1, "Signing disabled");
+		if (server->sec_mode & SMB2_NEGOTIATE_SIGNING_REQUIRED) {
+			cERROR(1, "Server requires packet signing to be enabled"
+				  " in /proc/fs/cifs/SecurityFlags.");
+			rc = -EOPNOTSUPP;
+			goto neg_exit;
+		}
+		server->sec_mode &=
+			~(SECMODE_SIGN_ENABLED | SECMODE_SIGN_REQUIRED);
+	}
+
 #ifdef CONFIG_SMB2_ASN1  /* BB REMOVEME when updated asn1.c ready */
 	rc = decode_neg_token_init(security_blob, blob_length,
 				   &server->sec_type);
@@ -669,6 +701,8 @@ SMB2_logoff(const unsigned int xid, struct cifs_ses *ses)
 
 	 /* since no tcon, smb2_init can not do this, so do here */
 	req->hdr.SessionId = ses->Suid;
+	if (server->sec_mode & SECMODE_SIGN_REQUIRED)
+		req->hdr.Flags |= SMB2_FLAGS_SIGNED;
 
 	rc = SendReceiveNoRsp(xid, ses, (char *) &req->hdr, 0);
 	/*
@@ -1268,10 +1302,12 @@ smb2_readv_callback(struct mid_q_entry *mid)
 	case MID_RESPONSE_RECEIVED:
 		credits_received = le16_to_cpu(buf->CreditRequest);
 		/* result already set, check signature */
-		/* if (server->sec_mode &
-		    (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
-			if (smb2_verify_signature(mid->resp_buf, server))
-				cERROR(1, "Unexpected SMB signature"); */
+		if (server->sec_mode &
+		    (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
+			if (smb2_verify_signature2(rdata->iov, rdata->nr_iov,
+						   server))
+				cERROR(1, "Unexpected SMB signature");
+		}
 		/* FIXME: should this be counted toward the initiating task? */
 		task_io_account_read(rdata->bytes);
 		cifs_stats_bytes_read(tcon, rdata->bytes);
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 192d0c7..dbbdc39 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -39,6 +39,8 @@ extern char *smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr);
 extern __le16 *cifs_convert_path_to_utf16(const char *from,
 					  struct cifs_sb_info *cifs_sb);
 
+extern int smb2_verify_signature2(struct kvec *, unsigned int,
+				  struct TCP_Server_Info *);
 extern int smb2_check_receive(struct mid_q_entry *mid,
 			      struct TCP_Server_Info *server, bool log_error);
 extern int smb2_setup_request(struct cifs_ses *ses, struct kvec *iov,
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 31f5d42..7276f6f 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -36,6 +36,149 @@
 #include "smb2proto.h"
 #include "cifs_debug.h"
 #include "smb2status.h"
+#include "smb2glob.h"
+
+static int
+smb2_calc_signature2(const struct kvec *iov, int n_vec,
+		     struct TCP_Server_Info *server)
+{
+	int i, rc;
+	unsigned char smb2_signature[SMB2_HMACSHA256_SIZE];
+	unsigned char *sigptr = smb2_signature;
+	struct smb2_hdr *smb2_pdu = (struct smb2_hdr *)iov[0].iov_base;
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
+		 * signed that occupies the first 4 bytes before the header).
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
+				sigptr);
+	if (rc)
+		cERROR(1, "%s: Could not generate sha256 hash\n", __func__);
+
+	memcpy(smb2_pdu->Signature, sigptr, SMB2_SIGNATURE_SIZE);
+
+	return rc;
+}
+
+/* must be called with server->srv_mutex held */
+static int
+smb2_sign_smb2(struct kvec *iov, int n_vec, struct TCP_Server_Info *server)
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
+	rc = smb2_calc_signature2(iov, n_vec, server);
+
+	return rc;
+}
+
+int
+smb2_verify_signature2(struct kvec *iov, unsigned int n_vec,
+		       struct TCP_Server_Info *server)
+{
+	unsigned int rc;
+	char server_response_sig[16];
+	struct smb2_hdr *smb2_pdu = (struct smb2_hdr *)iov[0].iov_base;
+
+	if ((smb2_pdu->Command == SMB2_NEGOTIATE) ||
+	    (smb2_pdu->Command == SMB2_OPLOCK_BREAK) ||
+	    (!server->session_estab))
+		return 0;
+
+	/*
+	 * BB what if signatures are supposed to be on for session but
+	 * server does not send one? BB
+	 */
+
+	/* Do not need to verify session setups with signature "BSRSPYL " */
+	if (memcmp(smb2_pdu->Signature, "BSRSPYL ", 8) == 0)
+		cFYI(1, "dummy signature received for smb command 0x%x",
+			smb2_pdu->Command);
+
+	/*
+	 * Save off the origiginal signature so we can modify the smb and check
+	 * our calculated signature against what the server sent.
+	 */
+	memcpy(server_response_sig, smb2_pdu->Signature, SMB2_SIGNATURE_SIZE);
+
+	memset(smb2_pdu->Signature, 0, SMB2_SIGNATURE_SIZE);
+
+	mutex_lock(&server->srv_mutex);
+	rc = smb2_calc_signature2(iov, n_vec, server);
+	mutex_unlock(&server->srv_mutex);
+
+	if (rc)
+		return rc;
+
+	if (memcmp(server_response_sig, smb2_pdu->Signature,
+		   SMB2_SIGNATURE_SIZE))
+		return -EACCES;
+	else
+		return 0;
+}
+
+static int
+smb2_verify_signature(struct smb2_hdr *smb2_pdu, struct TCP_Server_Info *server)
+{
+	struct kvec iov;
+
+	iov.iov_base = (char *)smb2_pdu;
+	iov.iov_len = get_rfc1002_length(smb2_pdu) + 4;
+	return smb2_verify_signature2(&iov, 1, server);
+}
 
 /*
  * Set message id for the request. Should be called after wait_for_free_request
@@ -118,12 +261,11 @@ smb2_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 
 	dump_smb(mid->resp_buf, min_t(u32, 80, len));
 	/* convert the length into a more usable form */
-	/* BB - uncomment with SMB2 signing implementation */
-	/* if ((len > 24) &&
+	if ((len > 24) &&
 	    (server->sec_mode & (SECMODE_SIGN_REQUIRED|SECMODE_SIGN_ENABLED))) {
 		if (smb2_verify_signature(mid->resp_buf, server))
 			cERROR(1, "Unexpected SMB signature");
-	} */
+	}
 
 	return map_smb2_to_linux_error(mid->resp_buf, log_error);
 }
@@ -141,9 +283,9 @@ smb2_setup_request(struct cifs_ses *ses, struct kvec *iov,
 	rc = smb2_get_mid_entry(ses, hdr, &mid);
 	if (rc)
 		return rc;
-	/* rc = smb2_sign_smb2(iov, nvec, ses->server);
+	rc = smb2_sign_smb2(iov, nvec, ses->server);
 	if (rc)
-		delete_mid(mid); */
+		cifs_delete_mid(mid);
 	*ret_mid = mid;
 	return rc;
 }
@@ -162,11 +304,12 @@ smb2_setup_async_request(struct TCP_Server_Info *server, struct kvec *iov,
 	if (mid == NULL)
 		return -ENOMEM;
 
-	/* rc = smb2_sign_smb2(iov, nvec, server);
+	rc = smb2_sign_smb2(iov, nvec, server);
 	if (rc) {
 		DeleteMidQEntry(mid);
 		return rc;
-	}*/
+	}
+
 	*ret_mid = mid;
 	return rc;
 }
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 4d37902..cb18dbf 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -109,8 +109,8 @@ DeleteMidQEntry(struct mid_q_entry *midEntry)
 	mempool_free(midEntry, cifs_mid_poolp);
 }
 
-static void
-delete_mid(struct mid_q_entry *mid)
+void
+cifs_delete_mid(struct mid_q_entry *mid)
 {
 	spin_lock(&GlobalMid_Lock);
 	list_del(&mid->qhead);
@@ -423,7 +423,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
 	if (rc == 0)
 		return 0;
 
-	delete_mid(mid);
+	cifs_delete_mid(mid);
 	add_credits(server, 1, optype);
 	wake_up(&server->request_q);
 	return rc;
@@ -533,7 +533,7 @@ cifs_setup_request(struct cifs_ses *ses, struct kvec *iov,
 		return rc;
 	rc = cifs_sign_smb2(iov, nvec, ses->server, &mid->sequence_number);
 	if (rc)
-		delete_mid(mid);
+		cifs_delete_mid(mid);
 	*ret_mid = mid;
 	return rc;
 }
@@ -653,11 +653,11 @@ SendReceive2(const unsigned int xid, struct cifs_ses *ses,
 	rc = ses->server->ops->check_receive(midQ, ses->server,
 					     flags & CIFS_LOG_ERROR);
 
-	/* mark it so buf will not be freed by delete_mid */
+	/* mark it so buf will not be freed by cifs_delete_mid */
 	if ((flags & CIFS_NO_RESP) == 0)
 		midQ->resp_buf = NULL;
 out:
-	delete_mid(midQ);
+	cifs_delete_mid(midQ);
 	add_credits(ses->server, credits, optype);
 
 	return rc;
@@ -763,7 +763,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	memcpy(out_buf, midQ->resp_buf, *pbytes_returned + 4);
 	rc = cifs_check_receive(midQ, ses->server, 0);
 out:
-	delete_mid(midQ);
+	cifs_delete_mid(midQ);
 	add_credits(ses->server, 1, 0);
 
 	return rc;
@@ -847,7 +847,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 
 	rc = cifs_sign_smb(in_buf, ses->server, &midQ->sequence_number);
 	if (rc) {
-		delete_mid(midQ);
+		cifs_delete_mid(midQ);
 		mutex_unlock(&ses->server->srv_mutex);
 		return rc;
 	}
@@ -860,7 +860,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	mutex_unlock(&ses->server->srv_mutex);
 
 	if (rc < 0) {
-		delete_mid(midQ);
+		cifs_delete_mid(midQ);
 		return rc;
 	}
 
@@ -881,7 +881,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 			   blocking lock to return. */
 			rc = send_cancel(ses->server, in_buf, midQ);
 			if (rc) {
-				delete_mid(midQ);
+				cifs_delete_mid(midQ);
 				return rc;
 			}
 		} else {
@@ -893,7 +893,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 			/* If we get -ENOLCK back the lock may have
 			   already been removed. Don't exit in this case. */
 			if (rc && rc != -ENOLCK) {
-				delete_mid(midQ);
+				cifs_delete_mid(midQ);
 				return rc;
 			}
 		}
@@ -930,7 +930,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	memcpy(out_buf, midQ->resp_buf, *pbytes_returned + 4);
 	rc = cifs_check_receive(midQ, ses->server, 0);
 out:
-	delete_mid(midQ);
+	cifs_delete_mid(midQ);
 	if (rstart && rc == -EACCES)
 		return -ERESTARTSYS;
 	return rc;
-- 
1.7.1
