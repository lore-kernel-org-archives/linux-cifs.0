From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 10/50] CIFS: Add session setup/logoff capability for SMB2
Date: Fri, 20 Jan 2012 12:34:31 +0400
Message-ID: <1327048511-2342-10-git-send-email-piastry@etersoft.ru>
References: <1327048511-2342-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1327048511-2342-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    3 +
 fs/cifs/connect.c   |   14 +++-
 fs/cifs/ntlmssp.h   |   10 ++
 fs/cifs/sess.c      |    6 +-
 fs/cifs/smb2misc.c  |    5 +
 fs/cifs/smb2pdu.c   |  227 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h   |   37 ++++++++
 fs/cifs/smb2proto.h |    3 +
 8 files changed, 300 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index d06a373..8739f52 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -387,6 +387,9 @@ struct cifs_ses {
 	struct session_key auth_key;
 	struct ntlmssp_auth *ntlmssp; /* ciphertext, flags, server challenge */
 	bool need_reconnect:1; /* connection reset, uid now invalid */
+#ifdef CONFIG_CIFS_SMB2
+	__u16 session_flags;
+#endif /* CONFIG_CIFS_SMB2 */
 };
 /* no more than one of the following three session flags may be set */
 #define CIFS_SES_NT4 1
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index a79c979..2130b68 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2165,7 +2165,12 @@ cifs_put_smb_ses(struct cifs_ses *ses)
 
 	if (ses->status == CifsGood) {
 		xid = GetXid();
-		CIFSSMBLogoff(xid, ses);
+#ifdef CONFIG_CIFS_SMB2
+		if (ses->server->is_smb2)
+			SMB2_logoff(xid, ses);
+		else
+#endif
+			CIFSSMBLogoff(xid, ses);
 		_FreeXid(xid);
 	}
 	sesInfoFree(ses);
@@ -3779,7 +3784,12 @@ int cifs_setup_session(unsigned int xid, struct cifs_ses *ses,
 	cFYI(1, "Security Mode: 0x%x Capabilities: 0x%x TimeAdjust: %d",
 		 server->sec_mode, server->capabilities, server->timeAdj);
 
-	rc = CIFS_SessSetup(xid, ses, nls_info);
+#ifdef CONFIG_CIFS_SMB2
+	if (ses->server->is_smb2)
+		rc = SMB2_sess_setup(xid, ses, nls_info);
+	else
+#endif
+		rc = CIFS_SessSetup(xid, ses, nls_info);
 	if (rc) {
 		cERROR(1, "Send error in SessSetup = %d", rc);
 	} else {
diff --git a/fs/cifs/ntlmssp.h b/fs/cifs/ntlmssp.h
index 5d52e4a..848249f 100644
--- a/fs/cifs/ntlmssp.h
+++ b/fs/cifs/ntlmssp.h
@@ -126,3 +126,13 @@ typedef struct _AUTHENTICATE_MESSAGE {
 	   do not set the version is present flag */
 	char UserString[0];
 } __attribute__((packed)) AUTHENTICATE_MESSAGE, *PAUTHENTICATE_MESSAGE;
+
+/*
+ * Size of the session key (crypto key encrypted with the password
+ */
+
+int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len, struct cifs_ses *ses);
+void build_ntlmssp_negotiate_blob(unsigned char *pbuffer, struct cifs_ses *ses);
+int build_ntlmssp_auth_blob(unsigned char *pbuffer, u16 *buflen,
+			struct cifs_ses *ses,
+			const struct nls_table *nls_cp);
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 47ef44e..1a6cea6 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -365,7 +365,7 @@ static int decode_ascii_ssetup(char **pbcc_area, __u16 bleft,
 	return rc;
 }
 
-static int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
+int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 				    struct cifs_ses *ses)
 {
 	unsigned int tioffset; /* challenge message target info area */
@@ -412,7 +412,7 @@ static int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 
 /* We do not malloc the blob, it is passed in pbuffer, because
    it is fixed size, and small, making this approach cleaner */
-static void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
+void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
 					 struct cifs_ses *ses)
 {
 	NEGOTIATE_MESSAGE *sec_blob = (NEGOTIATE_MESSAGE *)pbuffer;
@@ -448,7 +448,7 @@ static void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
 /* We do not malloc the blob, it is passed in pbuffer, because its
    maximum possible size is fixed and small, making this approach cleaner.
    This function returns the length of the data in the blob */
-static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
+int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 					u16 *buflen,
 				   struct cifs_ses *ses,
 				   const struct nls_table *nls_cp)
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 86888ca..70f5fbc 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -227,6 +227,11 @@ char *smb2_get_data_area_len(int *poff, int *plen, struct smb2_hdr *pSMB2)
 		    ((struct smb2_negotiate_rsp *)pSMB2)->SecurityBufferLength);
 		break;
 	case SMB2_SESSION_SETUP:
+		*poff = le16_to_cpu(
+		  ((struct smb2_sess_setup_rsp *)pSMB2)->SecurityBufferOffset);
+		*plen = le16_to_cpu(
+		  ((struct smb2_sess_setup_rsp *)pSMB2)->SecurityBufferLength);
+		break;
 	case SMB2_CREATE:
 	case SMB2_READ:
 	case SMB2_QUERY_INFO:
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 99de190..f894f4e 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -382,3 +382,230 @@ neg_exit:
 	free_rsp_buf(resp_buftype, pSMB2r);
 	return rc;
 }
+
+int
+SMB2_sess_setup(unsigned int xid, struct cifs_ses *ses,
+		const struct nls_table *nls_cp)
+{
+	struct smb2_sess_setup_req *pSMB2;
+	struct smb2_sess_setup_rsp *pSMB2r = NULL;
+	struct kvec iov[2];
+	int rc = 0;
+	int status;
+	int resp_buftype;
+	__le32 phase = NtLmNegotiate; /* NTLMSSP, if needed, is multistage */
+	struct TCP_Server_Info *server;
+	unsigned int sec_flags;
+	u8 temp = 0;
+	u16 blob_length = 0;
+	char *security_blob;
+	char *ntlmssp_blob = NULL;
+	bool use_spnego = false; /* else use raw ntlmssp */
+
+	cFYI(1, "Session Setup");
+
+	if (ses->server)
+		server = ses->server;
+	else {
+		rc = -EIO;
+		return rc;
+	}
+
+	/* if memory allocation is successful, caller of this function
+	 * frees it.
+	 */
+	ses->ntlmssp = kmalloc(sizeof(struct ntlmssp_auth), GFP_KERNEL);
+	if (!ses->ntlmssp)
+		return -ENOMEM;
+
+	ses->server->secType = RawNTLMSSP;
+
+ssetup_ntlmssp_authenticate:
+	if (phase == NtLmChallenge)
+		phase = NtLmAuthenticate; /* if ntlmssp, now final phase */
+
+	rc = small_smb2_init(SMB2_SESSION_SETUP, NULL, (void **) &pSMB2);
+	if (rc)
+		return rc;
+
+	/* if any of auth flags (ie not sign or seal) are overriden use them */
+	if (ses->overrideSecFlg & (~(CIFSSEC_MUST_SIGN | CIFSSEC_MUST_SEAL)))
+		sec_flags = ses->overrideSecFlg;  /* BB FIXME fix sign flags?*/
+	else /* if override flags set only sign/seal OR them with global auth */
+		sec_flags = global_secflags | ses->overrideSecFlg;
+
+	cFYI(1, "sec_flags 0x%x", sec_flags);
+
+	pSMB2->hdr.SessionId = 0; /* First session, not a reauthenticate */
+	pSMB2->VcNumber = 0; /* MBZ */
+
+	/* only one of SMB2 signing flags may be set in SMB2 request */
+	if ((sec_flags & CIFSSEC_MUST_SIGN) == CIFSSEC_MUST_SIGN)
+		temp = SMB2_NEGOTIATE_SIGNING_REQUIRED;
+	else if (ses->server->sec_mode & SMB2_NEGOTIATE_SIGNING_REQUIRED)
+		temp = SMB2_NEGOTIATE_SIGNING_REQUIRED;
+	else if (sec_flags & CIFSSEC_MAY_SIGN) /* MAY_SIGN is a single flag */
+		temp = SMB2_NEGOTIATE_SIGNING_ENABLED;
+
+	pSMB2->SecurityMode = temp;
+
+	/* We only support the DFS cap (others are currently undefined) */
+	pSMB2->Capabilities = cpu_to_le32(SMB2_GLOBAL_CAP_DFS
+						& ses->server->capabilities);
+	pSMB2->Channel = 0; /* MBZ */
+	iov[0].iov_base = (char *)pSMB2;
+	iov[0].iov_len = be32_to_cpu(pSMB2->hdr.smb2_buf_length)
+					+ 4 /* rfc1001 len */ - 1 /* pad */;
+	if (phase == NtLmNegotiate) {
+		ntlmssp_blob = kmalloc(sizeof(struct _NEGOTIATE_MESSAGE),
+					GFP_KERNEL);
+		if (ntlmssp_blob == NULL) {
+			rc = -ENOMEM;
+			goto ssetup_exit;
+		}
+
+		build_ntlmssp_negotiate_blob(ntlmssp_blob, ses);
+		if (use_spnego) {
+			/* blob_length = build_spnego_ntlmssp_blob(
+					&security_blob,
+					sizeof(struct _NEGOTIATE_MESSAGE),
+					ntlmssp_blob); */
+			/* BB eventually need to add this */
+			cERROR(1, "spnego not supported for SMB2 yet");
+			rc = -EOPNOTSUPP;
+			kfree(ntlmssp_blob);
+			goto ssetup_exit;
+		} else {
+			blob_length = sizeof(struct _NEGOTIATE_MESSAGE);
+			/* with raw NTLMSSP we don't encapsulate in SPNEGO */
+			security_blob = ntlmssp_blob;
+		}
+	} else if (phase == NtLmAuthenticate) {
+		pSMB2->hdr.SessionId = ses->Suid;
+		ntlmssp_blob = kzalloc(sizeof(struct _NEGOTIATE_MESSAGE) + 500,
+					GFP_KERNEL);
+		if (ntlmssp_blob == NULL) {
+			cERROR(1, "failed to malloc ntlmssp blob");
+			rc = -ENOMEM;
+			goto ssetup_exit;
+		}
+		rc = build_ntlmssp_auth_blob(ntlmssp_blob, &blob_length,
+					ses, nls_cp);
+		if (rc) {
+			cFYI(1, "build_ntlmssp_auth_blob failed %d", rc);
+			goto ssetup_exit; /* BB double check error handling */
+		}
+		if (use_spnego) {
+			/* blob_length = build_spnego_ntlmssp_blob(
+							&security_blob,
+							blob_length,
+							ntlmssp_blob); */
+			cERROR(1, "spnego not supported for SMB2 yet");
+			rc = -EOPNOTSUPP;
+			kfree(ntlmssp_blob);
+			goto ssetup_exit;
+		} else {
+			security_blob = ntlmssp_blob;
+		}
+	} else {
+		cERROR(1, "illegal ntlmssp phase");
+		rc = -EIO;
+		goto ssetup_exit;
+	}
+
+	/* Testing shows that buffer offset must be at location of Buffer[0] */
+	pSMB2->SecurityBufferOffset = cpu_to_le16(
+			sizeof(struct smb2_sess_setup_req) - 1 /* pad */
+			- 4 /* rfc1001 len */);
+	pSMB2->SecurityBufferLength = cpu_to_le16(blob_length);
+	iov[1].iov_base = security_blob;
+	iov[1].iov_len = blob_length;
+
+	pSMB2->hdr.smb2_buf_length =
+		cpu_to_be32(be32_to_cpu(pSMB2->hdr.smb2_buf_length)
+			    - 1 /* pad */ + blob_length);
+
+	/* BB add code to build os and lm fields */
+
+	rc = smb2_sendrcv2(xid, ses, iov, 2, &resp_buftype /* ret */, &status,
+			   CIFS_STD_OP | CIFS_LOG_ERROR);
+	kfree(security_blob);
+	cFYI(1, "sess setup returned buftype %d with rc %d status 0x%x",
+		 resp_buftype, rc, status);
+	pSMB2r = (struct smb2_sess_setup_rsp *)iov[0].iov_base;
+	if (pSMB2r->hdr.Status ==
+			cpu_to_le32(STATUS_MORE_PROCESSING_REQUIRED)) {
+		if (phase != NtLmNegotiate) {
+			cERROR(1, "Unexpected more processing error");
+			goto ssetup_exit;
+		}
+		if (offsetof(struct smb2_sess_setup_rsp, Buffer) - 4 !=
+			le16_to_cpu(pSMB2r->SecurityBufferOffset)) {
+			cERROR(1, "Invalid security buffer offset %d",
+				    le16_to_cpu(pSMB2r->SecurityBufferOffset));
+			rc = -EIO;
+			goto ssetup_exit;
+		}
+
+		/* NTLMSSP Negotiate sent now processing challenge (response) */
+		phase = NtLmChallenge; /* process ntlmssp challenge */
+		rc = 0; /* MORE_PROCESSING is not an error here but expected */
+		ses->Suid = pSMB2r->hdr.SessionId;
+		rc = decode_ntlmssp_challenge(pSMB2r->Buffer,
+				le16_to_cpu(pSMB2r->SecurityBufferLength), ses);
+	}
+
+	/* BB eventually add code for SPNEGO decoding of NtlmChallenge blob,
+	   but at least the raw NTLMSSP case works */
+
+	/*
+	 * No tcon so can't do
+	 * cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_fail[SMB2...]);
+	 */
+	if (rc != 0)
+		goto ssetup_exit;
+
+	if (pSMB2r == NULL) {
+		rc = -EIO;
+		goto ssetup_exit;
+	}
+
+	ses->session_flags = le16_to_cpu(pSMB2r->SessionFlags);
+ssetup_exit:
+	free_rsp_buf(resp_buftype, pSMB2r);
+
+	/* if ntlmssp, and negotiate succeeded, proceed to authenticate phase */
+	if ((phase == NtLmChallenge) && (rc == 0))
+		goto ssetup_ntlmssp_authenticate;
+	return rc;
+}
+
+int
+SMB2_logoff(const int xid, struct cifs_ses *ses)
+{
+	struct smb2_logoff_req *pSMB2; /* response is also trivial struct */
+	int rc = 0;
+	struct TCP_Server_Info *server;
+
+	cFYI(1, "disconnect session %p", ses);
+
+	if (ses && (ses->server))
+		server = ses->server;
+	else
+		return -EIO;
+
+	rc = small_smb2_init(SMB2_LOGOFF, NULL, (void **) &pSMB2);
+	if (rc)
+		return rc;
+
+	 /* since no tcon, smb2_init can not do this, so do here */
+	pSMB2->hdr.SessionId = ses->Suid;
+
+	rc = smb2_sendrcv_norsp(xid, ses, &pSMB2->hdr,
+				CIFS_STD_OP | CIFS_LOG_ERROR);
+	/*
+	 * No tcon so can't do
+	 * cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_fail[SMB2...]);
+	 */
+	return rc;
+}
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 72d8137..f62442d 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -180,4 +180,41 @@ struct smb2_negotiate_rsp {
 	__u8   Buffer[1];	/* variable length GSS security buffer */
 } __packed;
 
+struct smb2_sess_setup_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 25 */
+	__u8   VcNumber;
+	__u8   SecurityMode;
+	__le32 Capabilities;
+	__le32 Channel;
+	__le16 SecurityBufferOffset;
+	__le16 SecurityBufferLength;
+	__le64 PreviousSessionId;
+	__u8   Buffer[1];	/* variable length GSS security buffer */
+} __packed;
+
+/* Currently defined SessionFlags */
+#define SMB2_SESSION_FLAG_IS_GUEST	0x0001
+#define SMB2_SESSION_FLAG_IS_NULL	0x0002
+struct smb2_sess_setup_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 9 */
+	__le16 SessionFlags;
+	__le16 SecurityBufferOffset;
+	__le16 SecurityBufferLength;
+	__u8   Buffer[1];	/* variable length GSS security buffer */
+} __packed;
+
+struct smb2_logoff_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;	/* Must be 4 */
+	__le16 Reserved;
+} __packed;
+
+struct smb2_logoff_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;	/* Must be 4 */
+	__le16 Reserved;
+} __packed;
+
 #endif				/* _SMB2PDU_H */
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 665f569..cb92666 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -48,5 +48,8 @@ extern int smb2_sendrcv_norsp(const unsigned int xid, struct cifs_ses *ses,
  *  are contained within these calls
  */
 extern int SMB2_negotiate(unsigned int xid, struct cifs_ses *ses);
+extern int SMB2_sess_setup(unsigned int xid, struct cifs_ses *ses,
+			   const struct nls_table *nls_cp);
+extern int SMB2_logoff(const int xid, struct cifs_ses *ses);
 
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
