From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 16/19] cifs: move sectype to the cifs_ses instead of TCP_Server_Info
Date: Thu, 23 May 2013 11:06:00 -0400
Message-ID: <1369321563-16893-17-git-send-email-jlayton@redhat.com>
References: <1369321563-16893-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369321563-16893-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Now that we track what sort of NEGOTIATE response was received, stop
mandating that every session on a socket use the same type of auth.

Push that decision out into the session setup code, and make the sectype
a per-session property. This should allow us to mix multiple sectypes on
a socket as long as they are compatible with the NEGOTIATE response.

With this too, we can now eliminate the ses->secFlg field since that
info is redundant and harder to work with than a securityEnum.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsencrypt.c |   4 +-
 fs/cifs/cifsglob.h    |   2 -
 fs/cifs/cifsproto.h   |   2 +
 fs/cifs/cifssmb.c     |  89 ++++++++------------------------------
 fs/cifs/connect.c     | 117 ++++++++++++++------------------------------------
 fs/cifs/sess.c        |  57 +++++++++++++++++++++++-
 fs/cifs/smb2pdu.c     |  21 +--------
 7 files changed, 114 insertions(+), 178 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index a85a83d..30bea6b 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -535,7 +535,7 @@ CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
 		return rc;
 	}
 
-	if (ses->server->secType == RawNTLMSSP)
+	if (ses->server->negflavor == CIFS_NEGFLAVOR_EXTENDED)
 		memcpy(ses->auth_key.response + offset,
 			ses->ntlmssp->cryptkey, CIFS_SERVER_CHALLENGE_SIZE);
 	else
@@ -567,7 +567,7 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 	char ntlmv2_hash[16];
 	unsigned char *tiblob = NULL; /* target info blob */
 
-	if (ses->server->secType == RawNTLMSSP) {
+	if (ses->server->negflavor == CIFS_NEGFLAVOR_EXTENDED) {
 		if (!ses->domainName) {
 			rc = find_domain_name(ses, nls_cp);
 			if (rc) {
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index f392ae4..65fd9dd 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -401,7 +401,6 @@ struct smb_vol {
 	kgid_t backupgid;
 	umode_t file_mode;
 	umode_t dir_mode;
-	unsigned secFlg;
 	enum securityEnum sectype; /* sectype requested via mnt opts */
 	bool sign; /* was signing requested via mnt opts? */
 	bool retry:1;
@@ -518,7 +517,6 @@ struct TCP_Server_Info {
 	bool echoes:1; /* enable echoes */
 #endif
 	u16 dialect; /* dialect index that server chose */
-	enum securityEnum secType;
 	bool oplocks:1; /* enable oplocks */
 	unsigned int maxReq;	/* Clients should submit no more */
 	/* than maxReq distinct unanswered SMBs to the server when using  */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index ede010f..a82b3c0 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -118,6 +118,8 @@ extern void header_assemble(struct smb_hdr *, char /* command */ ,
 extern int small_smb_init_no_tc(const int smb_cmd, const int wct,
 				struct cifs_ses *ses,
 				void **request_buf);
+extern enum securityEnum select_sectype(struct TCP_Server_Info *server,
+				enum securityEnum requested);
 extern int CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
 			  const struct nls_table *nls_cp);
 extern struct timespec cifs_NTtimeToUnix(__le64 utc_nanoseconds_since_1601);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index c118533..febe12c 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -368,11 +368,12 @@ vt2_err:
 }
 
 static int
-decode_ext_sec_blob(struct TCP_Server_Info *server, NEGOTIATE_RSP *pSMBr)
+decode_ext_sec_blob(struct cifs_ses *ses, NEGOTIATE_RSP *pSMBr)
 {
 	int	rc = 0;
 	u16	count;
 	char	*guid = pSMBr->u.extended_response.GUID;
+	struct TCP_Server_Info *server = ses->server;
 
 	count = get_bcc(&pSMBr->hdr);
 	if (count < SMB1_CLIENT_GUID_SIZE)
@@ -391,27 +392,13 @@ decode_ext_sec_blob(struct TCP_Server_Info *server, NEGOTIATE_RSP *pSMBr)
 	}
 
 	if (count == SMB1_CLIENT_GUID_SIZE) {
-		server->secType = RawNTLMSSP;
+		server->sec_ntlmssp = true;
 	} else {
 		count -= SMB1_CLIENT_GUID_SIZE;
 		rc = decode_negTokenInit(
 			pSMBr->u.extended_response.SecurityBlob, count, server);
 		if (rc != 1)
 			return -EINVAL;
-
-		/* Make sure server supports what we want to use */
-		switch(server->secType) {
-		case Kerberos:
-			if (!server->sec_kerberos && !server->sec_mskerberos)
-				return -EOPNOTSUPP;
-			break;
-		case RawNTLMSSP:
-			if (!server->sec_ntlmssp)
-				return -EOPNOTSUPP;
-			break;
-		default:
-			return -EOPNOTSUPP;
-		}
 	}
 
 	return 0;
@@ -446,8 +433,7 @@ cifs_enable_signing(struct TCP_Server_Info *server, bool mnt_sign_required)
 
 #ifdef CONFIG_CIFS_WEAK_PW_HASH
 static int
-decode_lanman_negprot_rsp(struct TCP_Server_Info *server, NEGOTIATE_RSP *pSMBr,
-			  unsigned int secFlags, bool sign)
+decode_lanman_negprot_rsp(struct TCP_Server_Info *server, NEGOTIATE_RSP *pSMBr, bool sign)
 {
 	__s16 tmp;
 	struct lanman_neg_rsp *rsp = (struct lanman_neg_rsp *)pSMBr;
@@ -455,12 +441,6 @@ decode_lanman_negprot_rsp(struct TCP_Server_Info *server, NEGOTIATE_RSP *pSMBr,
 	if (server->dialect != LANMAN_PROT && server->dialect != LANMAN2_PROT)
 		return -EOPNOTSUPP;
 
-	if ((secFlags & CIFSSEC_MAY_LANMAN) || (secFlags & CIFSSEC_MAY_PLNTXT))
-		server->secType = LANMAN;
-	else {
-		cifs_dbg(VFS, "mount failed weak security disabled in /proc/fs/cifs/SecurityFlags\n");
-		return -EOPNOTSUPP;
-	}
 	server->sec_mode = le16_to_cpu(rsp->SecurityMode);
 	server->maxReq = min_t(unsigned int,
 			       le16_to_cpu(rsp->MaxMpxCount),
@@ -535,17 +515,20 @@ decode_lanman_negprot_rsp(struct TCP_Server_Info *server, NEGOTIATE_RSP *pSMBr,
 #endif
 
 static bool
-should_set_ext_sec_flag(unsigned int secFlags)
+should_set_ext_sec_flag(enum securityEnum sectype)
 {
-	if ((secFlags & CIFSSEC_MUST_KRB5) == CIFSSEC_MUST_KRB5)
-		return true;
-	else if ((secFlags & CIFSSEC_AUTH_MASK) == CIFSSEC_MAY_KRB5)
-		return true;
-	else if ((secFlags & CIFSSEC_MUST_NTLMSSP) == CIFSSEC_MUST_NTLMSSP)
+	switch (sectype) {
+	case RawNTLMSSP:
+	case Kerberos:
 		return true;
-	else if ((secFlags & CIFSSEC_AUTH_MASK) == CIFSSEC_MAY_NTLMSSP)
-		return true;
-	return false;
+	case Unspecified:
+		if (global_secflags &
+		    (CIFSSEC_MAY_KRB5 | CIFSSEC_MAY_NTLMSSP))
+			return true;
+		/* Fallthrough */
+	default:
+		return false;
+	}
 }
 
 int
@@ -558,7 +541,6 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 	int i;
 	struct TCP_Server_Info *server = ses->server;
 	u16 count;
-	unsigned int secFlags;
 
 	if (!server) {
 		WARN(1, "%s: server is NULL!\n", __func__);
@@ -570,18 +552,10 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 	if (rc)
 		return rc;
 
-	/* if any of auth flags (ie not sign or seal) are overriden use them */
-	if (ses->overrideSecFlg & (~(CIFSSEC_MUST_SIGN | CIFSSEC_MUST_SEAL)))
-		secFlags = ses->overrideSecFlg;  /* BB FIXME fix sign flags? */
-	else /* if override flags set only sign/seal OR them with global auth */
-		secFlags = global_secflags | ses->overrideSecFlg;
-
-	cifs_dbg(FYI, "secFlags 0x%x\n", secFlags);
-
 	pSMB->hdr.Mid = get_next_mid(server);
 	pSMB->hdr.Flags2 |= (SMBFLG2_UNICODE | SMBFLG2_ERR_STATUS);
 
-	if (should_set_ext_sec_flag(secFlags)) {
+	if (should_set_ext_sec_flag(ses->sectype)) {
 		cifs_dbg(FYI, "Requesting extended security.");
 		pSMB->hdr.Flags2 |= SMBFLG2_EXT_SEC;
 	}
@@ -610,7 +584,7 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 		rc = -EOPNOTSUPP;
 		goto neg_err_exit;
 	} else if (pSMBr->hdr.WordCount == 13) {
-		rc = decode_lanman_negprot_rsp(server, pSMBr, secFlags, ses->sign);
+		rc = decode_lanman_negprot_rsp(server, pSMBr, ses->sign);
 		server->negflavor = CIFS_NEGFLAVOR_LANMAN;
 		goto neg_err_exit;
 	} else if (pSMBr->hdr.WordCount != 17) {
@@ -624,31 +598,6 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 	if ((server->sec_mode & SECMODE_USER) == 0)
 		cifs_dbg(FYI, "share mode security\n");
 
-	if ((server->sec_mode & SECMODE_PW_ENCRYPT) == 0)
-#ifdef CONFIG_CIFS_WEAK_PW_HASH
-		if ((secFlags & CIFSSEC_MAY_PLNTXT) == 0)
-#endif /* CIFS_WEAK_PW_HASH */
-			cifs_dbg(VFS, "Server requests plain text password but client support disabled\n");
-
-	if ((secFlags & CIFSSEC_MUST_NTLMV2) == CIFSSEC_MUST_NTLMV2)
-		server->secType = NTLMv2;
-	else if (secFlags & CIFSSEC_MAY_NTLM)
-		server->secType = NTLM;
-	else if (secFlags & CIFSSEC_MAY_NTLMV2)
-		server->secType = NTLMv2;
-	else if (secFlags & CIFSSEC_MAY_KRB5)
-		server->secType = Kerberos;
-	else if (secFlags & CIFSSEC_MAY_NTLMSSP)
-		server->secType = RawNTLMSSP;
-	else if (secFlags & CIFSSEC_MAY_LANMAN)
-		server->secType = LANMAN;
-	else {
-		rc = -EOPNOTSUPP;
-		cifs_dbg(VFS, "Invalid security type\n");
-		goto neg_err_exit;
-	}
-	/* else ... any others ...? */
-
 	/* one byte, so no need to convert this or EncryptionKeyLen from
 	   little endian */
 	server->maxReq = min_t(unsigned int, le16_to_cpu(pSMBr->MaxMpxCount),
@@ -670,7 +619,7 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 			server->capabilities & CAP_EXTENDED_SECURITY) &&
 				(pSMBr->EncryptionKeyLength == 0)) {
 		server->negflavor = CIFS_NEGFLAVOR_EXTENDED;
-		rc = decode_ext_sec_blob(server, pSMBr);
+		rc = decode_ext_sec_blob(ses, pSMBr);
 	} else if (server->sec_mode & SECMODE_PW_ENCRYPT) {
 		rc = -EIO; /* no crypt key only if plain text pwd */
 	} else {
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index f5ea895..a57715b 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1032,56 +1032,40 @@ static int cifs_parse_security_flavors(char *value,
 	vol->sign = false;
 
 	switch (match_token(value, cifs_secflavor_tokens, args)) {
+	case Opt_sec_krb5p:
+		cifs_dbg(VFS, "sec=krb5p is not supported!\n");
+		return 1;
+	case Opt_sec_krb5i:
+		vol->sign = true;
+		/* Fallthrough */
 	case Opt_sec_krb5:
 		vol->sectype = Kerberos;
-		vol->secFlg |= CIFSSEC_MAY_KRB5 | CIFSSEC_MAY_SIGN;
 		break;
-	case Opt_sec_krb5i:
-		vol->sectype = Kerberos;
+	case Opt_sec_ntlmsspi:
 		vol->sign = true;
-		vol->secFlg |= CIFSSEC_MAY_KRB5 | CIFSSEC_MUST_SIGN;
-		break;
-	case Opt_sec_krb5p:
-		/* vol->secFlg |= CIFSSEC_MUST_SEAL | CIFSSEC_MAY_KRB5; */
-		cifs_dbg(VFS, "sec=krb5p is not supported!\n");
-		return 1;
+		/* Fallthrough */
 	case Opt_sec_ntlmssp:
 		vol->sectype = RawNTLMSSP;
-		vol->secFlg |= CIFSSEC_MAY_NTLMSSP;
 		break;
-	case Opt_sec_ntlmsspi:
-		vol->sectype = RawNTLMSSP;
+	case Opt_sec_ntlmi:
 		vol->sign = true;
-		vol->secFlg |= CIFSSEC_MAY_NTLMSSP | CIFSSEC_MUST_SIGN;
-		break;
+		/* Fallthrough */
 	case Opt_ntlm:
-		/* ntlm is default so can be turned off too */
 		vol->sectype = NTLM;
-		vol->secFlg |= CIFSSEC_MAY_NTLM;
 		break;
-	case Opt_sec_ntlmi:
-		vol->sectype = NTLM;
+	case Opt_sec_ntlmv2i:
 		vol->sign = true;
-		vol->secFlg |= CIFSSEC_MAY_NTLM | CIFSSEC_MUST_SIGN;
-		break;
+		/* Fallthrough */
 	case Opt_sec_ntlmv2:
 		vol->sectype = NTLMv2;
-		vol->secFlg |= CIFSSEC_MAY_NTLMV2;
-		break;
-	case Opt_sec_ntlmv2i:
-		vol->sectype = NTLMv2;
-		vol->sign = true;
-		vol->secFlg |= CIFSSEC_MAY_NTLMV2 | CIFSSEC_MUST_SIGN;
 		break;
 #ifdef CONFIG_CIFS_WEAK_PW_HASH
 	case Opt_sec_lanman:
 		vol->sectype = LANMAN;
-		vol->secFlg |= CIFSSEC_MAY_LANMAN;
 		break;
 #endif
 	case Opt_sec_none:
 		vol->nullauth = 1;
-		vol->secFlg |= CIFSSEC_MAY_NTLM;
 		break;
 	default:
 		cifs_dbg(VFS, "bad security option: %s\n", value);
@@ -1444,7 +1428,6 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			vol->local_lease = 1;
 			break;
 		case Opt_sign:
-			vol->secFlg |= CIFSSEC_MUST_SIGN;
 			vol->sign = true;
 			break;
 		case Opt_noac:
@@ -1994,40 +1977,19 @@ match_address(struct TCP_Server_Info *server, struct sockaddr *addr,
 static bool
 match_security(struct TCP_Server_Info *server, struct smb_vol *vol)
 {
-	unsigned int secFlags;
-
-	if (vol->secFlg & (~(CIFSSEC_MUST_SIGN | CIFSSEC_MUST_SEAL)))
-		secFlags = vol->secFlg;
-	else
-		secFlags = global_secflags | vol->secFlg;
-
-	switch (server->secType) {
-	case LANMAN:
-		if (!(secFlags & (CIFSSEC_MAY_LANMAN|CIFSSEC_MAY_PLNTXT)))
-			return false;
-		break;
-	case NTLMv2:
-		if (!(secFlags & CIFSSEC_MAY_NTLMV2))
-			return false;
-		break;
-	case NTLM:
-		if (!(secFlags & CIFSSEC_MAY_NTLM))
-			return false;
-		break;
-	case Kerberos:
-		if (!(secFlags & CIFSSEC_MAY_KRB5))
-			return false;
-		break;
-	case RawNTLMSSP:
-		if (!(secFlags & CIFSSEC_MAY_NTLMSSP))
-			return false;
-		break;
-	default:
-		/* shouldn't happen */
+	/*
+	 * The select_sectype function should either return the vol->sectype
+	 * that was specified, or "Unspecified" if that sectype was not
+	 * compatible with the given NEGOTIATE request.
+	 */
+	if (select_sectype(server, vol->sectype) == Unspecified)
 		return false;
-	}
 
-	/* now check if signing mode is acceptable */
+	/*
+	 * Now check if signing mode is acceptable. No need to check
+	 * global_secflags at this point since if MUST_SIGN is set then
+	 * the server->sign had better be too.
+	 */
 	if (vol->sign && !server->sign)
 		return false;
 
@@ -2230,7 +2192,11 @@ out_err:
 
 static int match_session(struct cifs_ses *ses, struct smb_vol *vol)
 {
-	switch (ses->server->secType) {
+	if (vol->sectype != Unspecified &&
+	    vol->sectype != ses->sectype)
+		return 0;
+
+	switch (ses->sectype) {
 	case Kerberos:
 		if (!uid_eq(vol->cred_uid, ses->cred_uid))
 			return 0;
@@ -2507,7 +2473,6 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb_vol *volume_info)
 	ses->cred_uid = volume_info->cred_uid;
 	ses->linux_uid = volume_info->linux_uid;
 
-	ses->overrideSecFlg = volume_info->secFlg;
 	ses->sectype = volume_info->sectype;
 	ses->sign = volume_info->sign ? volume_info->sign :
 				(global_secflags & CIFSSEC_MUST_SIGN);
@@ -3670,7 +3635,7 @@ CIFSTCon(const unsigned int xid, struct cifs_ses *ses,
 		   NTLMv2 password here) */
 #ifdef CONFIG_CIFS_WEAK_PW_HASH
 		if ((global_secflags & CIFSSEC_MAY_LANMAN) &&
-		    (ses->server->secType == LANMAN))
+		    (ses->sectype == LANMAN))
 			calc_lanman_hash(tcon->password, ses->server->cryptkey,
 					 ses->server->sec_mode &
 					    SECMODE_PW_ENCRYPT ? true : false,
@@ -3882,27 +3847,11 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 static int
 cifs_set_vol_auth(struct smb_vol *vol, struct cifs_ses *ses)
 {
-	switch (ses->server->secType) {
-	case Kerberos:
-		vol->secFlg = CIFSSEC_MUST_KRB5;
+	vol->sectype = ses->sectype;
+
+	/* krb5 is special, since we don't need username or pw */
+	if (vol->sectype == Kerberos)
 		return 0;
-	case NTLMv2:
-		vol->secFlg = CIFSSEC_MUST_NTLMV2;
-		break;
-	case NTLM:
-		vol->secFlg = CIFSSEC_MUST_NTLM;
-		break;
-	case RawNTLMSSP:
-		vol->secFlg = CIFSSEC_MUST_NTLMSSP;
-		break;
-	case LANMAN:
-		vol->secFlg = CIFSSEC_MUST_LANMAN;
-		break;
-	default:
-		/* should never happen */
-		vol->secFlg = 0;
-		break;
-	}
 
 	return cifs_set_cifscreds(vol, ses);
 }
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 82b784a..79358e3 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -550,6 +550,56 @@ setup_ntlmv2_ret:
 	return rc;
 }
 
+enum securityEnum
+select_sectype(struct TCP_Server_Info *server, enum securityEnum requested)
+{
+	switch (server->negflavor) {
+	case CIFS_NEGFLAVOR_EXTENDED:
+		switch (requested) {
+		case Kerberos:
+		case RawNTLMSSP:
+			return requested;
+		case Unspecified:
+			if (server->sec_ntlmssp &&
+			    (global_secflags & CIFSSEC_MAY_NTLMSSP))
+				return RawNTLMSSP;
+			if ((server->sec_kerberos || server->sec_mskerberos) &&
+			    (global_secflags & CIFSSEC_MAY_KRB5))
+				return Kerberos;
+			/* Fallthrough */
+		default:
+			return Unspecified;
+		}
+	case CIFS_NEGFLAVOR_UNENCAP:
+		switch (requested) {
+		case NTLM:
+		case NTLMv2:
+			return requested;
+		case Unspecified:
+			if (global_secflags & CIFSSEC_MAY_NTLMV2)
+				return NTLMv2;
+			if (global_secflags & CIFSSEC_MAY_NTLM)
+				return NTLM;
+			/* Fallthrough */
+		default:
+			return Unspecified;
+		}
+	case CIFS_NEGFLAVOR_LANMAN:
+		switch (requested) {
+		case LANMAN:
+			return requested;
+		case Unspecified:
+			if (global_secflags & CIFSSEC_MAY_LANMAN)
+				return LANMAN;
+			/* Fallthrough */
+		default:
+			return Unspecified;
+		}
+	default:
+		return Unspecified;
+	}
+}
+
 int
 CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
 	       const struct nls_table *nls_cp)
@@ -576,8 +626,13 @@ CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
 		return -EINVAL;
 	}
 
-	type = ses->server->secType;
+	type = select_sectype(ses->server, ses->sectype);
 	cifs_dbg(FYI, "sess setup type %d\n", type);
+	if (type == Unspecified) {
+		cifs_dbg(VFS, "Unable to select appropriate authentication method!");
+		return -EINVAL;
+	}
+
 	if (type == RawNTLMSSP) {
 		/* if memory allocation is successful, caller of this function
 		 * frees it.
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index c753508..d5f2bf0 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -328,7 +328,6 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	int rc = 0;
 	int resp_buftype;
 	struct TCP_Server_Info *server = ses->server;
-	unsigned int sec_flags;
 	int blob_offset, blob_length;
 	char *security_blob;
 	int flags = CIFS_NEG_OP;
@@ -344,14 +343,6 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	if (rc)
 		return rc;
 
-	/* if any of auth flags (ie not sign or seal) are overriden use them */
-	if (ses->overrideSecFlg & (~(CIFSSEC_MUST_SIGN | CIFSSEC_MUST_SEAL)))
-		sec_flags = ses->overrideSecFlg;  /* BB FIXME fix sign flags?*/
-	else /* if override flags set only sign/seal OR them with global auth */
-		sec_flags = global_secflags | ses->overrideSecFlg;
-
-	cifs_dbg(FYI, "sec_flags 0x%x\n", sec_flags);
-
 	req->hdr.SessionId = 0;
 
 	req->Dialects[0] = cpu_to_le16(ses->server->vals->protocol_id);
@@ -453,7 +444,6 @@ SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
 	int resp_buftype;
 	__le32 phase = NtLmNegotiate; /* NTLMSSP, if needed, is multistage */
 	struct TCP_Server_Info *server = ses->server;
-	unsigned int sec_flags;
 	u16 blob_length = 0;
 	char *security_blob;
 	char *ntlmssp_blob = NULL;
@@ -474,7 +464,8 @@ SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
 	if (!ses->ntlmssp)
 		return -ENOMEM;
 
-	ses->server->secType = RawNTLMSSP;
+	/* FIXME: allow for other auth types besides NTLMSSP (e.g. krb5) */
+	ses->sectype = RawNTLMSSP;
 
 ssetup_ntlmssp_authenticate:
 	if (phase == NtLmChallenge)
@@ -484,14 +475,6 @@ ssetup_ntlmssp_authenticate:
 	if (rc)
 		return rc;
 
-	/* if any of auth flags (ie not sign or seal) are overriden use them */
-	if (ses->overrideSecFlg & (~(CIFSSEC_MUST_SIGN | CIFSSEC_MUST_SEAL)))
-		sec_flags = ses->overrideSecFlg;  /* BB FIXME fix sign flags?*/
-	else /* if override flags set only sign/seal OR them with global auth */
-		sec_flags = global_secflags | ses->overrideSecFlg;
-
-	cifs_dbg(FYI, "sec_flags 0x%x\n", sec_flags);
-
 	req->hdr.SessionId = 0; /* First session, not a reauthenticate */
 	req->VcNumber = 0; /* MBZ */
 	/* to enable echos and oplocks */
-- 
1.8.1.4
