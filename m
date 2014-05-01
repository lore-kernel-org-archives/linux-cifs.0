From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/4] cifs: Separate rawntlmssp auth from CIFS_SessSetup()
Date: Thu,  1 May 2014 13:41:05 +0100
Message-ID: <1398948065-23265-5-git-send-email-sprabhu@redhat.com>
References: <1398948065-23265-1-git-send-email-sprabhu@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Simo Sorce <simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1398948065-23265-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Separate rawntlmssp authentication from CIFS_SessSetup(). Also cleanup
CIFS_SessSetup() since we no longer do any auth within it.

Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/sess.c | 437 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 214 insertions(+), 223 deletions(-)

diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 869ad37..fb86600 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -1125,242 +1125,177 @@ sess_auth_kerberos(struct sess_data *sess_data)
 }
 #endif /* ! CONFIG_CIFS_UPCALL */
 
-int
-CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
-	       const struct nls_table *nls_cp)
+static void
+_sess_auth_rawntlmssp(struct sess_data *sess_data, __le32 phase);
+
+static void
+sess_auth_rawntlmssp_negotiate(struct sess_data *sess_data)
+{
+	_sess_auth_rawntlmssp(sess_data, NtLmNegotiate);
+
+}
+
+static void
+sess_auth_rawntlmssp_authenticate(struct sess_data *sess_data)
+{
+	_sess_auth_rawntlmssp(sess_data, NtLmAuthenticate);
+
+}
+
+static void
+_sess_auth_rawntlmssp(struct sess_data *sess_data, __le32 phase)
 {
 	int rc = 0;
-	int wct;
 	struct smb_hdr *smb_buf;
-	char *bcc_ptr;
-	char *str_area;
 	SESSION_SETUP_ANDX *pSMB;
+	char *bcc_ptr;
+	struct cifs_ses *ses = sess_data->ses;
 	__u32 capabilities;
-	__u16 count;
-	int resp_buf_type;
-	struct kvec iov[3];
-	enum securityEnum type;
-	__u16 action, bytes_remaining;
-	__le32 phase = NtLmNegotiate; /* NTLMSSP, if needed, is multistage */
+	__u16 bytes_remaining;
 	u16 blob_len;
 	char *ntlmsspblob = NULL;
-	struct sess_data *sess_data;
 
-	if (ses == NULL) {
-		WARN(1, "%s: ses == NULL!", __func__);
-		return -EINVAL;
-	}
-
-	sess_data = kzalloc(sizeof(struct sess_data), GFP_KERNEL);
-	if (!sess_data)
-		return -ENOMEM;
-	sess_data->xid = xid;
-	sess_data->ses = ses;
-	sess_data->nls_cp = (struct nls_table *) nls_cp;
-
-	type = select_sectype(ses->server, ses->sectype);
-	cifs_dbg(FYI, "sess setup type %d\n", type);
-	if (type == Unspecified) {
-		cifs_dbg(VFS,
-			"Unable to select appropriate authentication method!");
-		return -EINVAL;
-	}
-
-        switch (type) {
-        case LANMAN:
-                sess_auth_lanman(sess_data);
-		goto out;
-	case NTLM:
-                sess_auth_ntlm(sess_data);
-		goto out;
-	case NTLMv2:
-                sess_auth_ntlmv2(sess_data);
-		goto out;
-	case Kerberos:
-                sess_auth_kerberos(sess_data);
+	/* wct = 12 */
+	rc = sess_alloc_buffer(sess_data, 12);
+	if (rc)
 		goto out;
-	default:
-		/* Continue with the rest of the function */
-		break;
-	}
 
-	if (type == RawNTLMSSP) {
-		/* if memory allocation is successful, caller of this function
-		 * frees it.
-		 */
+	pSMB = (SESSION_SETUP_ANDX *)sess_data->iov[0].iov_base;
+	bcc_ptr = sess_data->iov[2].iov_base;
+	capabilities = cifs_ssetup_hdr(ses, pSMB);
+	smb_buf = (struct smb_hdr *)pSMB;
+
+	/*
+	 * Check if ses->ntlmssp is already allocated before allocating
+	 * if memory allocation is successful, caller of this function
+	 * frees it.
+	 */
+	if (!ses->ntlmssp) {
 		ses->ntlmssp = kmalloc(sizeof(struct ntlmssp_auth), GFP_KERNEL);
-		if (!ses->ntlmssp)
-			return -ENOMEM;
+		if (!ses->ntlmssp) {
+			rc = -ENOMEM;
+			goto out;
+		}
 		ses->ntlmssp->sesskey_per_smbsess = false;
-
 	}
 
-ssetup_ntlmssp_authenticate:
-	if (phase == NtLmChallenge)
-		phase = NtLmAuthenticate; /* if ntlmssp, now final phase */
-
-	/* same size: negotiate or auth, NTLMSSP or extended security */
-	wct = 12;
-
-	rc = small_smb_init_no_tc(SMB_COM_SESSION_SETUP_ANDX, wct, ses,
-			    (void **)&smb_buf);
-	if (rc)
-		return rc;
-
-	pSMB = (SESSION_SETUP_ANDX *)smb_buf;
-
-	capabilities = cifs_ssetup_hdr(ses, pSMB);
-
-	/* we will send the SMB in three pieces:
-	a fixed length beginning part, an optional
-	SPNEGO blob (which can be zero length), and a
-	last part which will include the strings
-	and rest of bcc area. This allows us to avoid
-	a large buffer 17K allocation */
-	iov[0].iov_base = (char *)pSMB;
-	iov[0].iov_len = be32_to_cpu(smb_buf->smb_buf_length) + 4;
-
-	/* setting this here allows the code at the end of the function
-	   to free the request buffer if there's an error */
-	resp_buf_type = CIFS_SMALL_BUFFER;
-
-	/* 2000 big enough to fit max user, domain, NOS name etc. */
-	str_area = kmalloc(2000, GFP_KERNEL);
-	if (str_area == NULL) {
-		rc = -ENOMEM;
-		goto ssetup_exit;
+	sess_data->iov[2].iov_base = bcc_ptr;
+	if ((pSMB->req.hdr.Flags2 & SMBFLG2_UNICODE) == 0) {
+		cifs_dbg(VFS, "NTLMSSP requires Unicode support\n");
+		rc = -ENOSYS;
+		goto out;
 	}
-	bcc_ptr = str_area;
-
-	iov[1].iov_base = NULL;
-	iov[1].iov_len = 0;
 
-	if (type == RawNTLMSSP) {
-		if ((pSMB->req.hdr.Flags2 & SMBFLG2_UNICODE) == 0) {
-			cifs_dbg(VFS, "NTLMSSP requires Unicode support\n");
-			rc = -ENOSYS;
-			goto ssetup_exit;
+	cifs_dbg(FYI, "ntlmssp session setup phase %d\n", phase);
+	pSMB->req.hdr.Flags2 |= SMBFLG2_EXT_SEC;
+	capabilities |= CAP_EXTENDED_SECURITY;
+	pSMB->req.Capabilities |= cpu_to_le32(capabilities);
+
+	switch(phase) {
+	case NtLmNegotiate:
+		build_ntlmssp_negotiate_blob(
+			pSMB->req.SecurityBlob, ses);
+		sess_data->iov[1].iov_len = sizeof(NEGOTIATE_MESSAGE);
+		sess_data->iov[1].iov_base = pSMB->req.SecurityBlob;
+		pSMB->req.SecurityBlobLength =
+			cpu_to_le16(sizeof(NEGOTIATE_MESSAGE));
+		break;
+	case NtLmAuthenticate:
+		/*
+		 * 5 is an empirical value, large enough to hold
+		 * authenticate message plus max 10 of av paris,
+		 * domain, user, workstation names, flags, etc.
+		 */
+		ntlmsspblob = kzalloc(
+			5*sizeof(struct _AUTHENTICATE_MESSAGE),
+			GFP_KERNEL);
+		if (!ntlmsspblob) {
+			rc = -ENOMEM;
+			goto out;
 		}
 
-		cifs_dbg(FYI, "ntlmssp session setup phase %d\n", phase);
-		pSMB->req.hdr.Flags2 |= SMBFLG2_EXT_SEC;
-		capabilities |= CAP_EXTENDED_SECURITY;
-		pSMB->req.Capabilities |= cpu_to_le32(capabilities);
-		switch(phase) {
-		case NtLmNegotiate:
-			build_ntlmssp_negotiate_blob(
-				pSMB->req.SecurityBlob, ses);
-			iov[1].iov_len = sizeof(NEGOTIATE_MESSAGE);
-			iov[1].iov_base = pSMB->req.SecurityBlob;
-			pSMB->req.SecurityBlobLength =
-				cpu_to_le16(sizeof(NEGOTIATE_MESSAGE));
-			break;
-		case NtLmAuthenticate:
-			/*
-			 * 5 is an empirical value, large enough to hold
-			 * authenticate message plus max 10 of av paris,
-			 * domain, user, workstation names, flags, etc.
-			 */
-			ntlmsspblob = kzalloc(
-				5*sizeof(struct _AUTHENTICATE_MESSAGE),
-				GFP_KERNEL);
-			if (!ntlmsspblob) {
-				rc = -ENOMEM;
-				goto ssetup_exit;
-			}
-
-			rc = build_ntlmssp_auth_blob(ntlmsspblob,
-						&blob_len, ses, nls_cp);
-			if (rc)
-				goto ssetup_exit;
-			iov[1].iov_len = blob_len;
-			iov[1].iov_base = ntlmsspblob;
-			pSMB->req.SecurityBlobLength = cpu_to_le16(blob_len);
-			/*
-			 * Make sure that we tell the server that we are using
-			 * the uid that it just gave us back on the response
-			 * (challenge)
-			 */
-			smb_buf->Uid = ses->Suid;
-			break;
-		default:
-			cifs_dbg(VFS, "invalid phase %d\n", phase);
-			rc = -ENOSYS;
-			goto ssetup_exit;
-		}
-		/* unicode strings must be word aligned */
-		if ((iov[0].iov_len + iov[1].iov_len) % 2) {
-			*bcc_ptr = 0;
-			bcc_ptr++;
-		}
-		unicode_oslm_strings(&bcc_ptr, nls_cp);
-	} else {
-		cifs_dbg(VFS, "secType %d not supported!\n", type);
+		rc = build_ntlmssp_auth_blob(ntlmsspblob,
+					&blob_len, ses, sess_data->nls_cp);
+		if (rc)
+			goto out_free_ntlmsspblob;
+		sess_data->iov[1].iov_len = blob_len;
+		sess_data->iov[1].iov_base = ntlmsspblob;
+		pSMB->req.SecurityBlobLength = cpu_to_le16(blob_len);
+		/*
+		 * Make sure that we tell the server that we are using
+		 * the uid that it just gave us back on the response
+		 * (challenge)
+		 */
+		smb_buf->Uid = ses->Suid;
+		break;
+	default:
+		cifs_dbg(VFS, "invalid phase %d\n", phase);
 		rc = -ENOSYS;
-		goto ssetup_exit;
+		goto out;
 	}
+	/* unicode strings must be word aligned */
+	if ((sess_data->iov[0].iov_len + sess_data->iov[1].iov_len) % 2) {
+		*bcc_ptr = 0;
+		bcc_ptr++;
+	}
+	unicode_oslm_strings(&bcc_ptr, sess_data->nls_cp);
 
-	iov[2].iov_base = str_area;
-	iov[2].iov_len = (long) bcc_ptr - (long) str_area;
-
-	count = iov[1].iov_len + iov[2].iov_len;
-	smb_buf->smb_buf_length =
-		cpu_to_be32(be32_to_cpu(smb_buf->smb_buf_length) + count);
-
-	put_bcc(count, smb_buf);
+	sess_data->iov[2].iov_len = (long) bcc_ptr -
+					(long) sess_data->iov[2].iov_base;
 
-	rc = SendReceive2(xid, ses, iov, 3 /* num_iovecs */, &resp_buf_type,
-			  CIFS_LOG_ERROR);
-	/* SMB request buf freed in SendReceive2 */
+	rc = sess_sendreceive(sess_data);
 
-	pSMB = (SESSION_SETUP_ANDX *)iov[0].iov_base;
-	smb_buf = (struct smb_hdr *)iov[0].iov_base;
+	pSMB = (SESSION_SETUP_ANDX *)sess_data->iov[0].iov_base;
+	smb_buf = (struct smb_hdr *)sess_data->iov[0].iov_base;
 
-	if ((type == RawNTLMSSP) && (resp_buf_type != CIFS_NO_BUFFER) &&
+	if ((sess_data->buf0_type != CIFS_NO_BUFFER) &&
 	    (smb_buf->Status.CifsError ==
-			cpu_to_le32(NT_STATUS_MORE_PROCESSING_REQUIRED))) {
+	     cpu_to_le32(NT_STATUS_MORE_PROCESSING_REQUIRED))) {
 		if (phase != NtLmNegotiate) {
 			cifs_dbg(VFS, "Unexpected more processing error\n");
-			goto ssetup_exit;
+			goto out;
 		}
 		/* NTLMSSP Negotiate sent now processing challenge (response) */
 		phase = NtLmChallenge; /* process ntlmssp challenge */
 		rc = 0; /* MORE_PROC rc is not an error here, but expected */
 	}
+
 	if (rc)
-		goto ssetup_exit;
+		goto out;
+
 
 	if (smb_buf->WordCount != 4) {
 		rc = -EIO;
 		cifs_dbg(VFS, "bad word count %d\n", smb_buf->WordCount);
-		goto ssetup_exit;
+		goto out_free_ntlmsspblob;
 	}
-	action = le16_to_cpu(pSMB->resp.Action);
-	if (action & GUEST_LOGIN)
+
+	if (le16_to_cpu(pSMB->resp.Action) & GUEST_LOGIN)
 		cifs_dbg(FYI, "Guest login\n"); /* BB mark SesInfo struct? */
+
 	ses->Suid = smb_buf->Uid;   /* UID left in wire format (le) */
 	cifs_dbg(FYI, "UID = %llu\n", ses->Suid);
-	/* response can have either 3 or 4 word count - Samba sends 3 */
-	/* and lanman response is 3 */
+
 	bytes_remaining = get_bcc(smb_buf);
 	bcc_ptr = pByteArea(smb_buf);
 
 	blob_len = le16_to_cpu(pSMB->resp.SecurityBlobLength);
 	if (blob_len > bytes_remaining) {
 		cifs_dbg(VFS, "bad security blob length %d\n",
-			 blob_len);
+				blob_len);
 		rc = -EINVAL;
-		goto ssetup_exit;
+		goto out_free_ntlmsspblob;
 	}
 	if (phase == NtLmChallenge) {
 		rc = decode_ntlmssp_challenge(bcc_ptr, blob_len, ses);
 		/* now goto beginning for ntlmssp authenticate phase */
 		if (rc)
-			goto ssetup_exit;
+			goto out_free_ntlmsspblob;
 	}
 	bcc_ptr += blob_len;
 	bytes_remaining -= blob_len;
 
+
 	/* BB check if Unicode and decode strings */
 	if (bytes_remaining == 0) {
 		/* no string area to decode, do nothing */
@@ -1370,61 +1305,117 @@ ssetup_ntlmssp_authenticate:
 			++bcc_ptr;
 			--bytes_remaining;
 		}
-		decode_unicode_ssetup(&bcc_ptr, bytes_remaining, ses, nls_cp);
+		decode_unicode_ssetup(&bcc_ptr, bytes_remaining, ses,
+				      sess_data->nls_cp);
 	} else {
-		decode_ascii_ssetup(&bcc_ptr, bytes_remaining, ses, nls_cp);
+		decode_ascii_ssetup(&bcc_ptr, bytes_remaining, ses,
+				    sess_data->nls_cp);
 	}
 
-ssetup_exit:
-	kfree(str_area);
-	kfree(ntlmsspblob);
-	ntlmsspblob = NULL;
-	if (resp_buf_type == CIFS_SMALL_BUFFER) {
-		cifs_dbg(FYI, "ssetup freeing small buf %p\n", iov[0].iov_base);
-		cifs_small_buf_release(iov[0].iov_base);
-	} else if (resp_buf_type == CIFS_LARGE_BUFFER)
-		cifs_buf_release(iov[0].iov_base);
-
-	/* if ntlmssp, and negotiate succeeded, proceed to authenticate phase */
-	if ((phase == NtLmChallenge) && (rc == 0))
-		goto ssetup_ntlmssp_authenticate;
-
-	if (!rc) {
-		mutex_lock(&ses->server->srv_mutex);
-		if (!ses->server->session_estab) {
-			if (ses->server->sign) {
-				ses->server->session_key.response =
-					kmemdup(ses->auth_key.response,
-					ses->auth_key.len, GFP_KERNEL);
-				if (!ses->server->session_key.response) {
-					rc = -ENOMEM;
-					mutex_unlock(&ses->server->srv_mutex);
-					goto keycp_exit;
-				}
-				ses->server->session_key.len =
-							ses->auth_key.len;
-			}
-			ses->server->sequence_number = 0x2;
-			ses->server->session_estab = true;
-		}
-		mutex_unlock(&ses->server->srv_mutex);
-
-		cifs_dbg(FYI, "CIFS session established successfully\n");
-		spin_lock(&GlobalMid_Lock);
-		ses->status = CifsGood;
-		ses->need_reconnect = false;
-		spin_unlock(&GlobalMid_Lock);
+out_free_ntlmsspblob:
+	if (ntlmsspblob) {
+		kfree(ntlmsspblob);
+		ntlmsspblob = NULL;
 	}
+out:
+	sess_data->result = rc;
+	sess_free_buffer(sess_data);
 
-keycp_exit:
+	if ((phase == NtLmChallenge) && (rc==0)) {
+		sess_data->func = sess_auth_rawntlmssp_authenticate;
+		return;
+	} else
+		sess_data->func = NULL;
+
+	sess_establish_session(sess_data);
+	/* only free ses->auth_key.response on completion or error */
 	kfree(ses->auth_key.response);
 	ses->auth_key.response = NULL;
 	kfree(ses->ntlmssp);
+	ses->ntlmssp = NULL;
+}
 
-	return rc;
+int select_sec(struct cifs_ses *ses, struct sess_data *sess_data)
+{
+	int type;
 
-out:
+	type = select_sectype(ses->server, ses->sectype);
+	cifs_dbg(FYI, "sess setup type %d\n", type);
+	if (type == Unspecified) {
+		cifs_dbg(VFS,
+			"Unable to select appropriate authentication method!");
+		return -EINVAL;
+	}
+
+	switch (type) {
+	case LANMAN:
+		/* LANMAN and plaintext are less secure and off by default.
+		 * So we make this explicitly be turned on in kconfig (in the
+		 * build) and turned on at runtime (changed from the default)
+		 * in proc/fs/cifs or via mount parm.  Unfortunately this is
+		 * needed for old Win (e.g. Win95), some obscure NAS and OS/2 */
+#ifdef CONFIG_CIFS_WEAK_PW_HASH
+		sess_data->func = sess_auth_lanman;
+		break;
+#else
+		return -EOPNOTSUPP;
+#endif
+	case NTLM:
+		sess_data->func = sess_auth_ntlm;
+		break;
+	case NTLMv2:
+		sess_data->func = sess_auth_ntlmv2;
+		break;
+	case Kerberos:
+#ifdef CONFIG_CIFS_UPCALL
+		sess_data->func = sess_auth_kerberos;
+		break;
+#else
+		cifs_dbg(VFS, "Kerberos negotiated but upcall support disabled!\n");
+		return -ENOSYS;
+		break;
+#endif /* CONFIG_CIFS_UPCALL */
+	case RawNTLMSSP:
+		sess_data->func = sess_auth_rawntlmssp_negotiate;
+		break;
+	default:
+		cifs_dbg(VFS, "secType %d not supported!\n", type);
+		return -ENOSYS;
+	}
+
+	return 0;
+}
+
+int CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
+		    const struct nls_table *nls_cp)
+{
+	int rc = 0;
+	struct sess_data *sess_data;
+
+	if (ses == NULL) {
+		WARN(1, "%s: ses == NULL!", __func__);
+		return -EINVAL;
+	}
+
+	sess_data = kzalloc(sizeof(struct sess_data), GFP_KERNEL);
+	if (!sess_data)
+		return -ENOMEM;
+
+	rc = select_sec(ses, sess_data);
+	if (rc)
+		goto out;
+
+	sess_data->xid = xid;
+	sess_data->ses = ses;
+	sess_data->nls_cp = (struct nls_table *) nls_cp;
+
+	while (sess_data->func)
+		sess_data->func(sess_data);
+
+	/* Store result before we free sess_data */
 	rc = sess_data->result;
+
+out:
 	kfree(sess_data);
 	return rc;
 }
-- 
1.8.4.2
