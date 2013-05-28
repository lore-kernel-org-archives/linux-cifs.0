From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 15/19] cifs: track the enablement of signing in the TCP_Server_Info
Date: Tue, 28 May 2013 08:11:56 -0400
Message-ID: <1369743120-18941-16-git-send-email-jlayton@redhat.com>
References: <1369743120-18941-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369743120-18941-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently, we determine this according to flags in the sec_mode, flags
in the global_secflags and via other methods. That makes the semantics
very hard to follow and there are corner cases where we don't handle
this correctly.

Add a new bool to the TCP_Server_Info that acts as a simple flag to tell
us whether signing is enabled on this connection or not, and fix up the
places that need to determine this to use that flag.

This is a bit weird for the SMB2 case, where signing is per-session.
SMB2 needs work in this area already though. The existing SMB2 code has
similar logic to what we're using here, so there should be no real
change in behavior. These changes should make it easier to implement
per-session signing in the future though.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifsglob.h      |  1 +
 fs/cifs/cifsproto.h     |  2 +-
 fs/cifs/cifssmb.c       | 76 ++++++++++++++++++++++++++-----------------------
 fs/cifs/connect.c       | 12 ++------
 fs/cifs/misc.c          |  3 +-
 fs/cifs/sess.c          |  9 ++----
 fs/cifs/smb1ops.c       |  3 +-
 fs/cifs/smb2pdu.c       | 40 +++++++++++---------------
 fs/cifs/smb2transport.c |  3 +-
 fs/cifs/transport.c     |  4 +--
 10 files changed, 71 insertions(+), 82 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index a911a33..f392ae4 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -510,6 +510,7 @@ struct TCP_Server_Info {
 	struct task_struct *tsk;
 	char server_GUID[16];
 	__u16 sec_mode;
+	bool sign; /* is signing enabled on this connection? */
 	bool session_estab; /* mark when very first sess is established */
 #ifdef CONFIG_CIFS_SMB2
 	int echo_credits;  /* echo reserved slots */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index f0e93ff..ede010f 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -212,7 +212,7 @@ extern int cifs_negotiate_protocol(const unsigned int xid,
 				   struct cifs_ses *ses);
 extern int cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 			      struct nls_table *nls_info);
-extern int cifs_enable_signing(struct TCP_Server_Info *server, unsigned int secFlags);
+extern int cifs_enable_signing(struct TCP_Server_Info *server, bool mnt_sign_required);
 extern int CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses);
 
 extern int CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 80ca688..dd7e2f6 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -418,32 +418,43 @@ decode_ext_sec_blob(struct TCP_Server_Info *server, NEGOTIATE_RSP *pSMBr)
 }
 
 int
-cifs_enable_signing(struct TCP_Server_Info *server, unsigned int secFlags)
+cifs_enable_signing(struct TCP_Server_Info *server, bool mnt_sign_required)
 {
-	if ((secFlags & CIFSSEC_MAY_SIGN) == 0) {
-		/* MUST_SIGN already includes the MAY_SIGN FLAG
-		   so if this is zero it means that signing is disabled */
-		cifs_dbg(FYI, "Signing disabled\n");
-		if (server->sec_mode & SECMODE_SIGN_REQUIRED) {
-			cifs_dbg(VFS, "Server requires packet signing to be enabled in /proc/fs/cifs/SecurityFlags\n");
-			return -EOPNOTSUPP;
+	bool srv_sign_required = server->sec_mode & SECMODE_SIGN_REQUIRED;
+	bool srv_sign_enabled = server->sec_mode & SECMODE_SIGN_ENABLED;
+	bool mnt_sign_enabled = global_secflags & CIFSSEC_MAY_SIGN;
+
+	/*
+	 * Is signing required by mnt options? If not then check
+	 * global_secflags to see if it is there.
+	 */
+	if (!mnt_sign_required)
+		mnt_sign_required = ((global_secflags & CIFSSEC_MUST_SIGN) ==
+						CIFSSEC_MUST_SIGN);
+
+	/*
+	 * If signing is required then it's automatically enabled too,
+	 * otherwise, check to see if the secflags allow it.
+	 */
+	mnt_sign_enabled = mnt_sign_required ? mnt_sign_required :
+				(global_secflags & CIFSSEC_MAY_SIGN);
+
+	/* If server requires signing, does client allow it? */
+	if (srv_sign_required) {
+		if (!mnt_sign_enabled) {
+			cifs_dbg(VFS, "Server requires signing, but it's disabled in SecurityFlags!");
+			return -ENOTSUPP;
 		}
-		server->sec_mode &=
-			~(SECMODE_SIGN_ENABLED | SECMODE_SIGN_REQUIRED);
-	} else if ((secFlags & CIFSSEC_MUST_SIGN) == CIFSSEC_MUST_SIGN) {
-		/* signing required */
-		cifs_dbg(FYI, "Must sign - secFlags 0x%x\n", secFlags);
-		if ((server->sec_mode &
-			(SECMODE_SIGN_ENABLED | SECMODE_SIGN_REQUIRED)) == 0) {
-			cifs_dbg(VFS, "signing required but server lacks support\n");
-			return -EOPNOTSUPP;
-		} else
-			server->sec_mode |= SECMODE_SIGN_REQUIRED;
-	} else {
-		/* signing optional ie CIFSSEC_MAY_SIGN */
-		if ((server->sec_mode & SECMODE_SIGN_REQUIRED) == 0)
-			server->sec_mode &=
-				~(SECMODE_SIGN_ENABLED | SECMODE_SIGN_REQUIRED);
+		server->sign = true;
+	}
+
+	/* If client requires signing, does server allow it? */
+	if (mnt_sign_required) {
+		if (!srv_sign_enabled) {
+			cifs_dbg(VFS, "Server does not support signing!");
+			return -ENOTSUPP;
+		}
+		server->sign = true;
 	}
 
 	return 0;
@@ -685,7 +696,7 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 
 signing_check:
 	if (!rc)
-		rc = cifs_enable_signing(server, secFlags);
+		rc = cifs_enable_signing(server, ses->sign);
 neg_err_exit:
 	cifs_buf_release(pSMB);
 
@@ -810,9 +821,8 @@ CIFSSMBLogoff(const unsigned int xid, struct cifs_ses *ses)
 
 	pSMB->hdr.Mid = get_next_mid(ses->server);
 
-	if (ses->server->sec_mode &
-		   (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
-			pSMB->hdr.Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
+	if (ses->server->sign)
+		pSMB->hdr.Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
 
 	pSMB->hdr.Uid = ses->Suid;
 
@@ -1573,8 +1583,7 @@ cifs_readv_callback(struct mid_q_entry *mid)
 	switch (mid->mid_state) {
 	case MID_RESPONSE_RECEIVED:
 		/* result already set, check signature */
-		if (server->sec_mode &
-		    (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
+		if (server->sign) {
 			int rc = 0;
 
 			rc = cifs_verify_signature(&rqst, server,
@@ -4827,11 +4836,8 @@ getDFSRetry:
 		strncpy(pSMB->RequestFileName, search_name, name_len);
 	}
 
-	if (ses->server) {
-		if (ses->server->sec_mode &
-		   (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
-			pSMB->hdr.Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
-	}
+	if (ses->server && ses->server->sign)
+		pSMB->hdr.Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
 
 	pSMB->hdr.Uid = ses->Suid;
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 3fb3ae2..cfb1bfc 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2028,13 +2028,8 @@ match_security(struct TCP_Server_Info *server, struct smb_vol *vol)
 	}
 
 	/* now check if signing mode is acceptable */
-	if ((secFlags & CIFSSEC_MAY_SIGN) == 0 &&
-	    (server->sec_mode & SECMODE_SIGN_REQUIRED))
-			return false;
-	else if (((secFlags & CIFSSEC_MUST_SIGN) == CIFSSEC_MUST_SIGN) &&
-		 (server->sec_mode &
-		  (SECMODE_SIGN_ENABLED|SECMODE_SIGN_REQUIRED)) == 0)
-			return false;
+	if (vol->sign && !server->sign)
+		return false;
 
 	return true;
 }
@@ -3692,8 +3687,7 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
 		}
 	}
 
-	if (ses->server->sec_mode &
-			(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
+	if (ses->server->sign)
 		smb_buffer->Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
 
 	if (ses->capabilities & CAP_STATUS32) {
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 1bec014..f7d4b22 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -267,8 +267,7 @@ header_assemble(struct smb_hdr *buffer, char smb_command /* command */ ,
 		if (treeCon->nocase)
 			buffer->Flags  |= SMBFLG_CASELESS;
 		if ((treeCon->ses) && (treeCon->ses->server))
-			if (treeCon->ses->server->sec_mode &
-			  (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
+			if (treeCon->ses->server->sign)
 				buffer->Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
 	}
 
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 0d0fe38..82b784a 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -138,8 +138,7 @@ static __u32 cifs_ssetup_hdr(struct cifs_ses *ses, SESSION_SETUP_ANDX *pSMB)
 	capabilities = CAP_LARGE_FILES | CAP_NT_SMBS | CAP_LEVEL_II_OPLOCKS |
 			CAP_LARGE_WRITE_X | CAP_LARGE_READ_X;
 
-	if (ses->server->sec_mode &
-	    (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
+	if (ses->server->sign)
 		pSMB->req.hdr.Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
 
 	if (ses->capabilities & CAP_UNICODE) {
@@ -427,8 +426,7 @@ void build_ntlmssp_negotiate_blob(unsigned char *pbuffer,
 	flags = NTLMSSP_NEGOTIATE_56 |	NTLMSSP_REQUEST_TARGET |
 		NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIATE_UNICODE |
 		NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTIATE_EXTENDED_SEC;
-	if (ses->server->sec_mode &
-			(SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
+	if (ses->server->sign) {
 		flags |= NTLMSSP_NEGOTIATE_SIGN;
 		if (!ses->server->session_estab)
 			flags |= NTLMSSP_NEGOTIATE_KEY_XCH;
@@ -466,8 +464,7 @@ int build_ntlmssp_auth_blob(unsigned char *pbuffer,
 		NTLMSSP_REQUEST_TARGET | NTLMSSP_NEGOTIATE_TARGET_INFO |
 		NTLMSSP_NEGOTIATE_128 | NTLMSSP_NEGOTIATE_UNICODE |
 		NTLMSSP_NEGOTIATE_NTLM | NTLMSSP_NEGOTIATE_EXTENDED_SEC;
-	if (ses->server->sec_mode &
-	   (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
+	if (ses->server->sign) {
 		flags |= NTLMSSP_NEGOTIATE_SIGN;
 		if (!ses->server->session_estab)
 			flags |= NTLMSSP_NEGOTIATE_KEY_XCH;
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 7d1c78b..b28aabd 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -449,8 +449,7 @@ cifs_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
 	 * WRITEX header, not including the 4 byte RFC1001 length.
 	 */
 	if (!(server->capabilities & CAP_LARGE_WRITE_X) ||
-	    (!(server->capabilities & CAP_UNIX) &&
-	     (server->sec_mode & (SECMODE_SIGN_ENABLED|SECMODE_SIGN_REQUIRED))))
+	    (!(server->capabilities & CAP_UNIX) && server->sign))
 		wsize = min_t(unsigned int, wsize,
 				server->maxBuf - sizeof(WRITE_REQ) + 4);
 
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 1609699..c753508 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -119,8 +119,7 @@ smb2_hdr_assemble(struct smb2_hdr *hdr, __le16 smb2_cmd /* command */ ,
 	/* BB how does SMB2 do case sensitive? */
 	/* if (tcon->nocase)
 		hdr->Flags |= SMBFLG_CASELESS; */
-	if (tcon->ses && tcon->ses->server &&
-	    (tcon->ses->server->sec_mode & SECMODE_SIGN_REQUIRED))
+	if (tcon->ses && tcon->ses->server && tcon->ses->server->sign)
 		hdr->Flags |= SMB2_FLAGS_SIGNED;
 out:
 	pdu->StructureSize2 = cpu_to_le16(parmsize);
@@ -330,7 +329,6 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	int resp_buftype;
 	struct TCP_Server_Info *server = ses->server;
 	unsigned int sec_flags;
-	u16 temp = 0;
 	int blob_offset, blob_length;
 	char *security_blob;
 	int flags = CIFS_NEG_OP;
@@ -362,12 +360,12 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	inc_rfc1001_len(req, 2);
 
 	/* only one of SMB2 signing flags may be set in SMB2 request */
-	if ((sec_flags & CIFSSEC_MUST_SIGN) == CIFSSEC_MUST_SIGN)
-		temp = SMB2_NEGOTIATE_SIGNING_REQUIRED;
-	else if (sec_flags & CIFSSEC_MAY_SIGN) /* MAY_SIGN is a single flag */
-		temp = SMB2_NEGOTIATE_SIGNING_ENABLED;
-
-	req->SecurityMode = cpu_to_le16(temp);
+	if (ses->sign)
+		req->SecurityMode = SMB2_NEGOTIATE_SIGNING_REQUIRED;
+	else if (global_secflags & CIFSSEC_MAY_SIGN)
+		req->SecurityMode = SMB2_NEGOTIATE_SIGNING_ENABLED;
+	else
+		req->SecurityMode = 0;
 
 	req->Capabilities = cpu_to_le32(ses->server->vals->req_capabilities);
 
@@ -424,8 +422,7 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 		goto neg_exit;
 	}
 
-	cifs_dbg(FYI, "sec_flags 0x%x\n", sec_flags);
-	rc = cifs_enable_signing(server, sec_flags);
+	rc = cifs_enable_signing(server, ses->sign);
 #ifdef CONFIG_SMB2_ASN1  /* BB REMOVEME when updated asn1.c ready */
 	if (rc)
 		goto neg_exit;
@@ -457,7 +454,6 @@ SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
 	__le32 phase = NtLmNegotiate; /* NTLMSSP, if needed, is multistage */
 	struct TCP_Server_Info *server = ses->server;
 	unsigned int sec_flags;
-	u8 temp = 0;
 	u16 blob_length = 0;
 	char *security_blob;
 	char *ntlmssp_blob = NULL;
@@ -502,14 +498,13 @@ ssetup_ntlmssp_authenticate:
 	req->hdr.CreditRequest = cpu_to_le16(3);
 
 	/* only one of SMB2 signing flags may be set in SMB2 request */
-	if ((sec_flags & CIFSSEC_MUST_SIGN) == CIFSSEC_MUST_SIGN)
-		temp = SMB2_NEGOTIATE_SIGNING_REQUIRED;
-	else if (ses->server->sec_mode & SMB2_NEGOTIATE_SIGNING_REQUIRED)
-		temp = SMB2_NEGOTIATE_SIGNING_REQUIRED;
-	else if (sec_flags & CIFSSEC_MAY_SIGN) /* MAY_SIGN is a single flag */
-		temp = SMB2_NEGOTIATE_SIGNING_ENABLED;
-
-	req->SecurityMode = temp;
+	if (server->sign)
+		req->SecurityMode = SMB2_NEGOTIATE_SIGNING_REQUIRED;
+	else if (global_secflags & CIFSSEC_MAY_SIGN) /* MAY_SIGN is a single flag */
+		req->SecurityMode = SMB2_NEGOTIATE_SIGNING_ENABLED;
+	else
+		req->SecurityMode = 0;
+
 	req->Capabilities = 0;
 	req->Channel = 0; /* MBZ */
 
@@ -652,7 +647,7 @@ SMB2_logoff(const unsigned int xid, struct cifs_ses *ses)
 
 	 /* since no tcon, smb2_init can not do this, so do here */
 	req->hdr.SessionId = ses->Suid;
-	if (server->sec_mode & SECMODE_SIGN_REQUIRED)
+	if (server->sign)
 		req->hdr.Flags |= SMB2_FLAGS_SIGNED;
 
 	rc = SendReceiveNoRsp(xid, ses, (char *) &req->hdr, 0);
@@ -1357,8 +1352,7 @@ smb2_readv_callback(struct mid_q_entry *mid)
 	case MID_RESPONSE_RECEIVED:
 		credits_received = le16_to_cpu(buf->CreditRequest);
 		/* result already set, check signature */
-		if (server->sec_mode &
-		    (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
+		if (server->sign) {
 			int rc;
 
 			rc = smb2_verify_signature(&rqst, server);
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 01f0ac8..c802ecf 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -275,8 +275,7 @@ smb2_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 
 	dump_smb(mid->resp_buf, min_t(u32, 80, len));
 	/* convert the length into a more usable form */
-	if ((len > 24) &&
-	    (server->sec_mode & (SECMODE_SIGN_REQUIRED|SECMODE_SIGN_ENABLED))) {
+	if (len > 24 && server->sign) {
 		int rc;
 
 		rc = smb2_verify_signature(&rqst, server);
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index bfbf470..1996d6c 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -463,7 +463,7 @@ cifs_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst)
 	struct mid_q_entry *mid;
 
 	/* enable signing if server requires it */
-	if (server->sec_mode & (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED))
+	if (server->sign)
 		hdr->Flags2 |= SMBFLG2_SECURITY_SIGNATURE;
 
 	mid = AllocMidQEntry(hdr, server);
@@ -612,7 +612,7 @@ cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
 	dump_smb(mid->resp_buf, min_t(u32, 92, len));
 
 	/* convert the length into a more usable form */
-	if (server->sec_mode & (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
+	if (server->sign) {
 		struct kvec iov;
 		int rc = 0;
 		struct smb_rqst rqst = { .rq_iov = &iov,
-- 
1.8.1.4
