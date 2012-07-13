From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 16/32] CIFS: Add session setup/logoff capability for SMB2
Date: Fri, 13 Jul 2012 11:53:29 +0400
Message-ID: <1342166025-29377-17-git-send-email-pshilovsky@samba.org>
References: <1342166025-29377-1-git-send-email-pshilovsky@samba.org>
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342166025-29377-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    3 +
 fs/cifs/ntlmssp.h   |   10 +++
 fs/cifs/sess.c      |    6 +-
 fs/cifs/smb2misc.c  |    5 +
 fs/cifs/smb2ops.c   |    2 +
 fs/cifs/smb2pdu.c   |  221 +++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h   |   37 +++++++++
 fs/cifs/smb2proto.h |    3 +
 8 files changed, 284 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 2d48f88..0d78bc4 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -504,6 +504,9 @@ struct cifs_ses {
 	struct session_key auth_key;
 	struct ntlmssp_auth *ntlmssp; /* ciphertext, flags, server challenge */
 	bool need_reconnect:1; /* connection reset, uid now invalid */
+#ifdef CONFIG_CIFS_SMB2
+	__u16 session_flags;
+#endif /* CONFIG_CIFS_SMB2 */
 };
 /* no more than one of the following three session flags may be set */
 #define CIFS_SES_NT4 1
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
index e25b312..b298d27 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -364,7 +364,7 @@ static int decode_ascii_ssetup(char **pbcc_area, __u16 bleft,
 	return rc;
 }
 
-static int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
+int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 				    struct cifs_ses *ses)
 {
 	unsigned int tioffset; /* challenge message target info area */
@@ -415,7 +415,7 @@ static int decode_ntlmssp_challenge(char *bcc_ptr, int blob_len,
 
 /* We do not malloc the blob, it is passed in pbuffer, because
    it is fixed size, and small, making this approach cleaner */
-static void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
+void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
 					 struct cifs_ses *ses)
 {
 	NEGOTIATE_MESSAGE *sec_blob = (NEGOTIATE_MESSAGE *)pbuffer;
@@ -451,7 +451,7 @@ static void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
 /* We do not malloc the blob, it is passed in pbuffer, because its
    maximum possible size is fixed and small, making this approach cleaner.
    This function returns the length of the data in the blob */
-static int build_ntlmssp_auth_blob(unsigned char *pbuffer,
+int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 					u16 *buflen,
 				   struct cifs_ses *ses,
 				   const struct nls_table *nls_cp)
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index e4dede4..10729a7 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -224,6 +224,11 @@ smb2_get_data_area_len(int *off, int *len, struct smb2_hdr *hdr)
 		    ((struct smb2_negotiate_rsp *)hdr)->SecurityBufferLength);
 		break;
 	case SMB2_SESSION_SETUP:
+		*off = le16_to_cpu(
+		    ((struct smb2_sess_setup_rsp *)hdr)->SecurityBufferOffset);
+		*len = le16_to_cpu(
+		    ((struct smb2_sess_setup_rsp *)hdr)->SecurityBufferLength);
+		break;
 	case SMB2_CREATE:
 	case SMB2_READ:
 	case SMB2_QUERY_INFO:
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 2b5232b..0057861 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -170,6 +170,8 @@ struct smb_version_operations smb21_operations = {
 	.dump_detail = smb2_dump_detail,
 	.need_neg = smb2_need_neg,
 	.negotiate = smb2_negotiate,
+	.sess_setup = SMB2_sess_setup,
+	.logoff = SMB2_logoff,
 };
 
 struct smb_version_values smb21_values = {
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 719e4c4..2165f0d 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -328,3 +328,224 @@ neg_exit:
 	free_rsp_buf(resp_buftype, rsp);
 	return rc;
 }
+
+int
+SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
+		const struct nls_table *nls_cp)
+{
+	struct smb2_sess_setup_req *req;
+	struct smb2_sess_setup_rsp *rsp = NULL;
+	struct kvec iov[2];
+	int rc = 0;
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
+	/*
+	 * If memory allocation is successful, caller of this function
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
+	rc = small_smb2_init(SMB2_SESSION_SETUP, NULL, (void **) &req);
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
+	req->hdr.SessionId = 0; /* First session, not a reauthenticate */
+	req->VcNumber = 0; /* MBZ */
+	/* to enable echos and oplocks */
+	req->hdr.CreditRequest = cpu_to_le16(3);
+
+	/* only one of SMB2 signing flags may be set in SMB2 request */
+	if ((sec_flags & CIFSSEC_MUST_SIGN) == CIFSSEC_MUST_SIGN)
+		temp = SMB2_NEGOTIATE_SIGNING_REQUIRED;
+	else if (ses->server->sec_mode & SMB2_NEGOTIATE_SIGNING_REQUIRED)
+		temp = SMB2_NEGOTIATE_SIGNING_REQUIRED;
+	else if (sec_flags & CIFSSEC_MAY_SIGN) /* MAY_SIGN is a single flag */
+		temp = SMB2_NEGOTIATE_SIGNING_ENABLED;
+
+	req->SecurityMode = temp;
+	req->Capabilities = 0;
+	req->Channel = 0; /* MBZ */
+
+	iov[0].iov_base = (char *)req;
+	/* 4 for rfc1002 length field and 1 for pad */
+	iov[0].iov_len = get_rfc1002_length(req) + 4 - 1;
+	if (phase == NtLmNegotiate) {
+		ntlmssp_blob = kmalloc(sizeof(struct _NEGOTIATE_MESSAGE),
+				       GFP_KERNEL);
+		if (ntlmssp_blob == NULL) {
+			rc = -ENOMEM;
+			goto ssetup_exit;
+		}
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
+		req->hdr.SessionId = ses->Suid;
+		ntlmssp_blob = kzalloc(sizeof(struct _NEGOTIATE_MESSAGE) + 500,
+				       GFP_KERNEL);
+		if (ntlmssp_blob == NULL) {
+			cERROR(1, "failed to malloc ntlmssp blob");
+			rc = -ENOMEM;
+			goto ssetup_exit;
+		}
+		rc = build_ntlmssp_auth_blob(ntlmssp_blob, &blob_length, ses,
+					     nls_cp);
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
+	req->SecurityBufferOffset =
+				cpu_to_le16(sizeof(struct smb2_sess_setup_req) -
+					    1 /* pad */ - 4 /* rfc1001 len */);
+	req->SecurityBufferLength = cpu_to_le16(blob_length);
+	iov[1].iov_base = security_blob;
+	iov[1].iov_len = blob_length;
+
+	inc_rfc1001_len(req, blob_length - 1 /* pad */);
+
+	/* BB add code to build os and lm fields */
+
+	rc = SendReceive2(xid, ses, iov, 2, &resp_buftype, CIFS_LOG_ERROR);
+
+	kfree(security_blob);
+	rsp = (struct smb2_sess_setup_rsp *)iov[0].iov_base;
+	if (rsp->hdr.Status == STATUS_MORE_PROCESSING_REQUIRED) {
+		if (phase != NtLmNegotiate) {
+			cERROR(1, "Unexpected more processing error");
+			goto ssetup_exit;
+		}
+		if (offsetof(struct smb2_sess_setup_rsp, Buffer) - 4 !=
+			le16_to_cpu(rsp->SecurityBufferOffset)) {
+			cERROR(1, "Invalid security buffer offset %d",
+				  le16_to_cpu(rsp->SecurityBufferOffset));
+			rc = -EIO;
+			goto ssetup_exit;
+		}
+
+		/* NTLMSSP Negotiate sent now processing challenge (response) */
+		phase = NtLmChallenge; /* process ntlmssp challenge */
+		rc = 0; /* MORE_PROCESSING is not an error here but expected */
+		ses->Suid = rsp->hdr.SessionId;
+		rc = decode_ntlmssp_challenge(rsp->Buffer,
+				le16_to_cpu(rsp->SecurityBufferLength), ses);
+	}
+
+	/*
+	 * BB eventually add code for SPNEGO decoding of NtlmChallenge blob,
+	 * but at least the raw NTLMSSP case works.
+	 */
+	/*
+	 * No tcon so can't do
+	 * cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_fail[SMB2...]);
+	 */
+	if (rc != 0)
+		goto ssetup_exit;
+
+	if (rsp == NULL) {
+		rc = -EIO;
+		goto ssetup_exit;
+	}
+
+	ses->session_flags = le16_to_cpu(rsp->SessionFlags);
+ssetup_exit:
+	free_rsp_buf(resp_buftype, rsp);
+
+	/* if ntlmssp, and negotiate succeeded, proceed to authenticate phase */
+	if ((phase == NtLmChallenge) && (rc == 0))
+		goto ssetup_ntlmssp_authenticate;
+	return rc;
+}
+
+int
+SMB2_logoff(const unsigned int xid, struct cifs_ses *ses)
+{
+	struct smb2_logoff_req *req; /* response is also trivial struct */
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
+	rc = small_smb2_init(SMB2_LOGOFF, NULL, (void **) &req);
+	if (rc)
+		return rc;
+
+	 /* since no tcon, smb2_init can not do this, so do here */
+	req->hdr.SessionId = ses->Suid;
+
+	rc = SendReceiveNoRsp(xid, ses, (char *) &req->hdr, 0);
+	/*
+	 * No tcon so can't do
+	 * cifs_stats_inc(&tcon->stats.smb2_stats.smb2_com_fail[SMB2...]);
+	 */
+	return rc;
+}
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index ef8dae2..26af68b 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -187,4 +187,41 @@ struct smb2_negotiate_rsp {
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
index 8817670..9364fbc 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -47,5 +47,8 @@ extern int smb2_setup_request(struct cifs_ses *ses, struct kvec *iov,
  * are contained within these calls.
  */
 extern int SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses);
+extern int SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
+			   const struct nls_table *nls_cp);
+extern int SMB2_logoff(const unsigned int xid, struct cifs_ses *ses);
 
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
