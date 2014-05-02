From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/4] cifs: Split Kerberos authentication off CIFS_SessSetup()
Date: Fri,  2 May 2014 14:21:30 +0100
Message-ID: <1399036891-15689-4-git-send-email-sprabhu@redhat.com>
References: <1399036891-15689-1-git-send-email-sprabhu@redhat.com>
Cc: Simo Sorce <simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1399036891-15689-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/sess.c | 215 ++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 153 insertions(+), 62 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 2be1ecb..4780a31 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -973,6 +973,155 @@ out:
 	ses->auth_key.response = NULL;
 }
 
+#ifdef CONFIG_CIFS_UPCALL
+static void
+sess_auth_kerberos(struct sess_data *sess_data)
+{
+	int rc = 0;
+	struct smb_hdr *smb_buf;
+	SESSION_SETUP_ANDX *pSMB;
+	char *bcc_ptr;
+	struct cifs_ses *ses = sess_data->ses;
+	__u32 capabilities;
+	__u16 bytes_remaining;
+	struct key *spnego_key = NULL;
+	struct cifs_spnego_msg *msg;
+	u16 blob_len;
+
+	/* extended security */
+	/* wct = 12 */
+	rc = sess_alloc_buffer(sess_data, 12);
+	if (rc)
+		goto out;
+
+	pSMB = (SESSION_SETUP_ANDX *)sess_data->iov[0].iov_base;
+	bcc_ptr = sess_data->iov[2].iov_base;
+	capabilities = cifs_ssetup_hdr(ses, pSMB);
+
+	spnego_key = cifs_get_spnego_key(ses);
+	if (IS_ERR(spnego_key)) {
+		rc = PTR_ERR(spnego_key);
+		spnego_key = NULL;
+		goto out;
+	}
+
+	msg = spnego_key->payload.data;
+	/*
+	 * check version field to make sure that cifs.upcall is
+	 * sending us a response in an expected form
+	 */
+	if (msg->version != CIFS_SPNEGO_UPCALL_VERSION) {
+		cifs_dbg(VFS,
+		  "incorrect version of cifs.upcall (expected %d but got %d)",
+			      CIFS_SPNEGO_UPCALL_VERSION, msg->version);
+		rc = -EKEYREJECTED;
+		goto out_put_spnego_key;
+	}
+
+	ses->auth_key.response = kmemdup(msg->data, msg->sesskey_len,
+					 GFP_KERNEL);
+	if (!ses->auth_key.response) {
+		cifs_dbg(VFS, "Kerberos can't allocate (%u bytes) memory",
+				msg->sesskey_len);
+		rc = -ENOMEM;
+		goto out_put_spnego_key;
+	}
+	ses->auth_key.len = msg->sesskey_len;
+
+	pSMB->req.hdr.Flags2 |= SMBFLG2_EXT_SEC;
+	capabilities |= CAP_EXTENDED_SECURITY;
+	pSMB->req.Capabilities = cpu_to_le32(capabilities);
+	sess_data->iov[1].iov_base = msg->data + msg->sesskey_len;
+	sess_data->iov[1].iov_len = msg->secblob_len;
+	pSMB->req.SecurityBlobLength = cpu_to_le16(sess_data->iov[1].iov_len);
+
+	if (ses->capabilities & CAP_UNICODE) {
+		/* unicode strings must be word aligned */
+		if ((sess_data->iov[0].iov_len
+			+ sess_data->iov[1].iov_len) % 2) {
+			*bcc_ptr = 0;
+			bcc_ptr++;
+		}
+		unicode_oslm_strings(&bcc_ptr, sess_data->nls_cp);
+		unicode_domain_string(&bcc_ptr, ses, sess_data->nls_cp);
+	} else {
+		/* BB: is this right? */
+		ascii_ssetup_strings(&bcc_ptr, ses, sess_data->nls_cp);
+	}
+
+	sess_data->iov[2].iov_len = (long) bcc_ptr -
+			(long) sess_data->iov[2].iov_base;
+
+	rc = sess_sendreceive(sess_data);
+	if (rc)
+		goto out_put_spnego_key;
+
+	pSMB = (SESSION_SETUP_ANDX *)sess_data->iov[0].iov_base;
+	smb_buf = (struct smb_hdr *)sess_data->iov[0].iov_base;
+
+	if (smb_buf->WordCount != 4) {
+		rc = -EIO;
+		cifs_dbg(VFS, "bad word count %d\n", smb_buf->WordCount);
+		goto out_put_spnego_key;
+	}
+
+	if (le16_to_cpu(pSMB->resp.Action) & GUEST_LOGIN)
+		cifs_dbg(FYI, "Guest login\n"); /* BB mark SesInfo struct? */
+
+	ses->Suid = smb_buf->Uid;   /* UID left in wire format (le) */
+	cifs_dbg(FYI, "UID = %llu\n", ses->Suid);
+
+	bytes_remaining = get_bcc(smb_buf);
+	bcc_ptr = pByteArea(smb_buf);
+
+	blob_len = le16_to_cpu(pSMB->resp.SecurityBlobLength);
+	if (blob_len > bytes_remaining) {
+		cifs_dbg(VFS, "bad security blob length %d\n",
+				blob_len);
+		rc = -EINVAL;
+		goto out_put_spnego_key;
+	}
+	bcc_ptr += blob_len;
+	bytes_remaining -= blob_len;
+
+	/* BB check if Unicode and decode strings */
+	if (bytes_remaining == 0) {
+		/* no string area to decode, do nothing */
+	} else if (smb_buf->Flags2 & SMBFLG2_UNICODE) {
+		/* unicode string area must be word-aligned */
+		if (((unsigned long) bcc_ptr - (unsigned long) smb_buf) % 2) {
+			++bcc_ptr;
+			--bytes_remaining;
+		}
+		decode_unicode_ssetup(&bcc_ptr, bytes_remaining, ses,
+				      sess_data->nls_cp);
+	} else {
+		decode_ascii_ssetup(&bcc_ptr, bytes_remaining, ses,
+				    sess_data->nls_cp);
+	}
+
+	rc = sess_establish_session(sess_data);
+out_put_spnego_key:
+	key_invalidate(spnego_key);
+	key_put(spnego_key);
+out:
+	sess_data->result = rc;
+	sess_data->func = NULL;
+	sess_free_buffer(sess_data);
+	kfree(ses->auth_key.response);
+	ses->auth_key.response = NULL;
+}
+
+#else
+
+static void
+sess_auth_kerberos(struct sess_data *sess_data)
+{
+	cifs_dbg(VFS, "Kerberos negotiated but upcall support disabled!\n");
+	sess_data->result = -ENOSYS;
+	sess_data->func = NULL;
+}
+#endif /* ! CONFIG_CIFS_UPCALL */
 
 int
 CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
@@ -990,7 +1139,6 @@ CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
 	struct kvec iov[3];
 	enum securityEnum type;
 	__u16 action, bytes_remaining;
-	struct key *spnego_key = NULL;
 	__le32 phase = NtLmNegotiate; /* NTLMSSP, if needed, is multistage */
 	u16 blob_len;
 	char *ntlmsspblob = NULL;
@@ -1026,6 +1174,9 @@ CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
 	case NTLMv2:
 		sess_auth_ntlmv2(sess_data);
 		goto out;
+	case Kerberos:
+		sess_auth_kerberos(sess_data);
+		goto out;
 	default:
 		/* Continue with the rest of the function */
 		break;
@@ -1082,63 +1233,7 @@ ssetup_ntlmssp_authenticate:
 	iov[1].iov_base = NULL;
 	iov[1].iov_len = 0;
 
-	if (type == Kerberos) {
-#ifdef CONFIG_CIFS_UPCALL
-		struct cifs_spnego_msg *msg;
-
-		spnego_key = cifs_get_spnego_key(ses);
-		if (IS_ERR(spnego_key)) {
-			rc = PTR_ERR(spnego_key);
-			spnego_key = NULL;
-			goto ssetup_exit;
-		}
-
-		msg = spnego_key->payload.data;
-		/* check version field to make sure that cifs.upcall is
-		   sending us a response in an expected form */
-		if (msg->version != CIFS_SPNEGO_UPCALL_VERSION) {
-			cifs_dbg(VFS, "incorrect version of cifs.upcall "
-				   "expected %d but got %d)",
-				   CIFS_SPNEGO_UPCALL_VERSION, msg->version);
-			rc = -EKEYREJECTED;
-			goto ssetup_exit;
-		}
-
-		ses->auth_key.response = kmemdup(msg->data, msg->sesskey_len,
-						 GFP_KERNEL);
-		if (!ses->auth_key.response) {
-			cifs_dbg(VFS,
-				"Kerberos can't allocate (%u bytes) memory",
-				msg->sesskey_len);
-			rc = -ENOMEM;
-			goto ssetup_exit;
-		}
-		ses->auth_key.len = msg->sesskey_len;
-
-		pSMB->req.hdr.Flags2 |= SMBFLG2_EXT_SEC;
-		capabilities |= CAP_EXTENDED_SECURITY;
-		pSMB->req.Capabilities = cpu_to_le32(capabilities);
-		iov[1].iov_base = msg->data + msg->sesskey_len;
-		iov[1].iov_len = msg->secblob_len;
-		pSMB->req.SecurityBlobLength = cpu_to_le16(iov[1].iov_len);
-
-		if (ses->capabilities & CAP_UNICODE) {
-			/* unicode strings must be word aligned */
-			if ((iov[0].iov_len + iov[1].iov_len) % 2) {
-				*bcc_ptr = 0;
-				bcc_ptr++;
-			}
-			unicode_oslm_strings(&bcc_ptr, nls_cp);
-			unicode_domain_string(&bcc_ptr, ses, nls_cp);
-		} else
-		/* BB: is this right? */
-			ascii_ssetup_strings(&bcc_ptr, ses, nls_cp);
-#else /* ! CONFIG_CIFS_UPCALL */
-		cifs_dbg(VFS, "Kerberos negotiated but upcall support disabled!\n");
-		rc = -ENOSYS;
-		goto ssetup_exit;
-#endif /* CONFIG_CIFS_UPCALL */
-	} else if (type == RawNTLMSSP) {
+	if (type == RawNTLMSSP) {
 		if ((pSMB->req.hdr.Flags2 & SMBFLG2_UNICODE) == 0) {
 			cifs_dbg(VFS, "NTLMSSP requires Unicode support\n");
 			rc = -ENOSYS;
@@ -1278,10 +1373,6 @@ ssetup_ntlmssp_authenticate:
 	}
 
 ssetup_exit:
-	if (spnego_key) {
-		key_invalidate(spnego_key);
-		key_put(spnego_key);
-	}
 	kfree(str_area);
 	kfree(ntlmsspblob);
 	ntlmsspblob = NULL;
-- 
1.8.4.2
