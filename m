Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51444C43334
	for <linux-cifs@archiver.kernel.org>; Sun, 24 Jul 2022 15:12:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbiGXPMb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 24 Jul 2022 11:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbiGXPM0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 24 Jul 2022 11:12:26 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC9010FE2
        for <linux-cifs@vger.kernel.org>; Sun, 24 Jul 2022 08:12:25 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id EF8662083C;
        Sun, 24 Jul 2022 15:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658675543; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zmJ2J2iidUctd9TSmKlyRDOSYBHzR0PVAQDvi8GUte0=;
        b=btBcl0+AV3D9urscqGuMdKYF8VV4OYT26NI1dBusv++a2n6H0GKTUtrAD8i4rQePQLjLvR
        LNO+19M9lMmMNn4Nzja53/aNypwscRGYMctDGF2JvRhSK0lL+aPtRmovhZT2fq0XoNWTtd
        MLxD61a2bhb/QRfVPFwfG2wwrhmGXAw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658675543;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zmJ2J2iidUctd9TSmKlyRDOSYBHzR0PVAQDvi8GUte0=;
        b=9oEB0EiwvFrhndiMTbTGyEwIDShHlTVo5IHPJXKhC3TUVVlbYL3emJj6cZyrqoRYMOzsht
        Wm/dD365jgOi1EAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 65DE713A8D;
        Sun, 24 Jul 2022 15:12:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id B72VCldh3WJcMQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Sun, 24 Jul 2022 15:12:23 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [RFC PATCH 10/14] cifs: typedef securityEnum
Date:   Sun, 24 Jul 2022 12:11:33 -0300
Message-Id: <20220724151137.7538-11-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220724151137.7538-1-ematsumiya@suse.de>
References: <20220724151137.7538-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

typedef "enum securityEnum" to "cifs_sectype_t".
Rename the security types values.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifs_swn.c   |  8 ++++----
 fs/cifs/cifsfs.c     | 10 +++++-----
 fs/cifs/cifsglob.h   | 28 ++++++++++++++--------------
 fs/cifs/cifsproto.h  |  8 ++++----
 fs/cifs/cifssmb.c    |  8 ++++----
 fs/cifs/connect.c    | 10 +++++-----
 fs/cifs/fs_context.c |  8 ++++----
 fs/cifs/fs_context.h |  2 +-
 fs/cifs/sess.c       | 32 ++++++++++++++++----------------
 fs/cifs/smb2pdu.c    | 30 +++++++++++++++---------------
 fs/cifs/smb2proto.h  |  4 ++--
 11 files changed, 74 insertions(+), 74 deletions(-)

diff --git a/fs/cifs/cifs_swn.c b/fs/cifs/cifs_swn.c
index 1e4c7cc5287f..58ead3334aae 100644
--- a/fs/cifs/cifs_swn.c
+++ b/fs/cifs/cifs_swn.c
@@ -77,7 +77,7 @@ static int cifs_swn_send_register_message(struct cifs_swn_reg *swnreg)
 {
 	struct sk_buff *skb;
 	struct genlmsghdr *hdr;
-	enum securityEnum authtype;
+	cifs_sectype_t authtype;
 	struct sockaddr_storage *addr;
 	int ret;
 
@@ -140,15 +140,15 @@ static int cifs_swn_send_register_message(struct cifs_swn_reg *swnreg)
 
 	authtype = cifs_select_sectype(swnreg->tcon->ses->server, swnreg->tcon->ses->sectype);
 	switch (authtype) {
-	case Kerberos:
+	case CIFS_SECTYPE_KERBEROS:
 		ret = cifs_swn_auth_info_krb(swnreg->tcon, skb);
 		if (ret < 0) {
 			cifs_dbg(VFS, "%s: Failed to get kerberos auth info: %d\n", __func__, ret);
 			goto nlmsg_fail;
 		}
 		break;
-	case NTLMv2:
-	case RawNTLMSSP:
+	case CIFS_SECTYPE_NTLMv2:
+	case CIFS_SECTYPE_RAW_NTLMSSP:
 		ret = cifs_swn_auth_info_ntlm(swnreg->tcon, skb);
 		if (ret < 0) {
 			cifs_dbg(VFS, "%s: Failed to get NTLM auth info: %d\n", __func__, ret);
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index a8eb41657859..3a0eb78a3378 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -449,7 +449,7 @@ cifs_show_address(struct seq_file *s, struct cifs_server_info *server)
 static void
 cifs_show_security(struct seq_file *s, struct cifs_ses *ses)
 {
-	if (ses->sectype == Unspecified) {
+	if (ses->sectype == CIFS_SECTYPE_UNSPEC) {
 		if (ses->user_name == NULL)
 			seq_puts(s, ",sec=none");
 		return;
@@ -458,13 +458,13 @@ cifs_show_security(struct seq_file *s, struct cifs_ses *ses)
 	seq_puts(s, ",sec=");
 
 	switch (ses->sectype) {
-	case NTLMv2:
+	case CIFS_SECTYPE_NTLMv2:
 		seq_puts(s, "ntlmv2");
 		break;
-	case Kerberos:
+	case CIFS_SECTYPE_KERBEROS:
 		seq_puts(s, "krb5");
 		break;
-	case RawNTLMSSP:
+	case CIFS_SECTYPE_RAW_NTLMSSP:
 		seq_puts(s, "ntlmssp");
 		break;
 	default:
@@ -476,7 +476,7 @@ cifs_show_security(struct seq_file *s, struct cifs_ses *ses)
 	if (ses->sign)
 		seq_puts(s, "i");
 
-	if (ses->sectype == Kerberos)
+	if (ses->sectype == CIFS_SECTYPE_KERBEROS)
 		seq_printf(s, ",cruid=%u",
 			   from_kuid_munged(&init_user_ns, ses->cred_uid));
 }
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index dddd63b6dc82..e2c6cbacb6d5 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -141,12 +141,12 @@ typedef enum {
 	TCON_STATUS_IN_FILES_INVALIDATE
 } cifs_tcon_status_t;
 
-enum securityEnum {
-	Unspecified = 0,	/* not specified */
-	NTLMv2,			/* Legacy NTLM auth with NTLMv2 hash */
-	RawNTLMSSP,		/* NTLMSSP without SPNEGO, NTLMv2 hash */
-	Kerberos,		/* Kerberos via SPNEGO */
-};
+typedef enum {
+	CIFS_SECTYPE_UNSPEC = 0,	/* not specified */
+	CIFS_SECTYPE_NTLMv2,		/* Legacy NTLM auth with NTLMv2 hash */
+	CIFS_SECTYPE_RAW_NTLMSSP,	/* NTLMSSP without SPNEGO, NTLMv2 hash */
+	CIFS_SECTYPE_KERBEROS,		/* Kerberos via SPNEGO */
+} cifs_sectype_t;
 
 struct session_key {
 	unsigned int len;
@@ -506,8 +506,8 @@ struct smb_version_operations {
 	int (*is_transform_hdr)(void *buf);
 	int (*receive_transform)(struct cifs_server_info *,
 				 struct mid_q_entry **, char **, int *);
-	enum securityEnum (*select_sectype)(struct cifs_server_info *,
-			    enum securityEnum);
+	cifs_sectype_t (*select_sectype)(struct cifs_server_info *,
+			    cifs_sectype_t);
 	int (*next_header)(char *);
 	/* ioctl passthrough for query_info */
 	int (*ioctl_query_info)(const unsigned int xid,
@@ -1028,7 +1028,7 @@ struct cifs_ses {
 	char workstation_name[CIFS_MAX_WORKSTATION_LEN];
 	struct session_key auth_key;
 	struct ntlmssp_auth *ntlmssp; /* ciphertext, flags, server challenge */
-	enum securityEnum sectype; /* what security flavor was specified? */
+	cifs_sectype_t sectype; /* what security flavor was specified? */
 	bool sign;		/* is signing required? */
 	bool domainAuto:1;
 	__u16 session_flags;
@@ -2041,14 +2041,14 @@ extern struct smb_version_values smb302_values;
 extern struct smb_version_operations smb311_operations;
 extern struct smb_version_values smb311_values;
 
-static inline char *get_security_type_str(enum securityEnum sectype)
+static inline char *get_security_type_str(cifs_sectype_t sectype)
 {
 	switch (sectype) {
-	case RawNTLMSSP:
-		return "RawNTLMSSP";
-	case Kerberos:
+	case CIFS_SECTYPE_RAW_NTLMSSP:
+		return "CIFS_SECTYPE_RAW_NTLMSSP";
+	case CIFS_SECTYPE_KERBEROS:
 		return "Kerberos";
-	case NTLMv2:
+	case CIFS_SECTYPE_NTLMv2:
 		return "NTLMv2";
 	default:
 		return "Unknown";
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index fce0fd8b1024..439ea5bfc196 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -168,8 +168,8 @@ extern void header_assemble(struct smb_hdr *, char /* command */ ,
 extern int small_smb_init_no_tc(const int smb_cmd, const int wct,
 				struct cifs_ses *ses,
 				void **request_buf);
-extern enum securityEnum select_sectype(struct cifs_server_info *server,
-				enum securityEnum requested);
+extern cifs_sectype_t select_sectype(struct cifs_server_info *server,
+				cifs_sectype_t requested);
 extern int CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
 			  struct cifs_server_info *server,
 			  const struct nls_table *nls_cp);
@@ -594,8 +594,8 @@ int cifs_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 int __cifs_calc_signature(struct smb_rqst *rqst,
 			struct cifs_server_info *server, char *signature,
 			struct shash_desc *shash);
-enum securityEnum cifs_select_sectype(struct cifs_server_info *,
-					enum securityEnum);
+cifs_sectype_t cifs_select_sectype(struct cifs_server_info *,
+					cifs_sectype_t);
 struct cifs_aio_ctx *cifs_aio_ctx_alloc(void);
 void cifs_aio_ctx_release(struct kref *refcount);
 int setup_aio_ctx_iter(struct cifs_aio_ctx *ctx, struct iov_iter *iter, int rw);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index e286bb535c5d..bd987f4042ca 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -505,13 +505,13 @@ cifs_enable_signing(struct cifs_server_info *server, bool mnt_sign_required)
 }
 
 static bool
-should_set_ext_sec_flag(enum securityEnum sectype)
+should_set_ext_sec_flag(cifs_sectype_t sectype)
 {
 	switch (sectype) {
-	case RawNTLMSSP:
-	case Kerberos:
+	case CIFS_SECTYPE_RAW_NTLMSSP:
+	case CIFS_SECTYPE_KERBEROS:
 		return true;
-	case Unspecified:
+	case CIFS_SECTYPE_UNSPEC:
 		if (global_secflags &
 		    (CIFSSEC_MAY_KRB5 | CIFSSEC_MAY_NTLMSSP))
 			return true;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 467f1b598eec..0d0bbd2aa880 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1392,11 +1392,11 @@ match_security(struct cifs_server_info *server, struct smb3_fs_context *ctx)
 {
 	/*
 	 * The select_sectype function should either return the ctx->sectype
-	 * that was specified, or "Unspecified" if that sectype was not
+	 * that was specified, or "CIFS_SECTYPE_UNSPEC" if that sectype was not
 	 * compatible with the given NEGOTIATE request.
 	 */
 	if (server->ops->select_sectype(server, ctx->sectype)
-	     == Unspecified)
+	     == CIFS_SECTYPE_UNSPEC)
 		return false;
 
 	/*
@@ -1730,7 +1730,7 @@ cifs_get_server(struct smb3_fs_context *ctx,
 
 static int match_session(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 {
-	if (ctx->sectype != Unspecified &&
+	if (ctx->sectype != CIFS_SECTYPE_UNSPEC &&
 	    ctx->sectype != ses->sectype)
 		return 0;
 
@@ -1746,7 +1746,7 @@ static int match_session(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 	spin_unlock(&ses->chan_lock);
 
 	switch (ses->sectype) {
-	case Kerberos:
+	case CIFS_SECTYPE_KERBEROS:
 		if (!uid_eq(ctx->cred_uid, ses->cred_uid))
 			return 0;
 		break;
@@ -4101,7 +4101,7 @@ cifs_set_vol_auth(struct smb3_fs_context *ctx, struct cifs_ses *ses)
 	ctx->sectype = ses->sectype;
 
 	/* krb5 is special, since we don't need username or pw */
-	if (ctx->sectype == Kerberos)
+	if (ctx->sectype == CIFS_SECTYPE_KERBEROS)
 		return 0;
 
 	return cifs_set_cifscreds(ctx, ses);
diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 8dc0d923ef6a..7a2f15e71fa4 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -203,7 +203,7 @@ cifs_parse_security_flavors(struct fs_context *fc, char *value, struct smb3_fs_c
 	 * With mount options, the last one should win. Reset any existing
 	 * settings back to default.
 	 */
-	ctx->sectype = Unspecified;
+	ctx->sectype = CIFS_SECTYPE_UNSPEC;
 	ctx->sign = false;
 
 	switch (match_token(value, cifs_secflavor_tokens, args)) {
@@ -214,19 +214,19 @@ cifs_parse_security_flavors(struct fs_context *fc, char *value, struct smb3_fs_c
 		ctx->sign = true;
 		fallthrough;
 	case Opt_sec_krb5:
-		ctx->sectype = Kerberos;
+		ctx->sectype = CIFS_SECTYPE_KERBEROS;
 		break;
 	case Opt_sec_ntlmsspi:
 		ctx->sign = true;
 		fallthrough;
 	case Opt_sec_ntlmssp:
-		ctx->sectype = RawNTLMSSP;
+		ctx->sectype = CIFS_SECTYPE_RAW_NTLMSSP;
 		break;
 	case Opt_sec_ntlmv2i:
 		ctx->sign = true;
 		fallthrough;
 	case Opt_sec_ntlmv2:
-		ctx->sectype = NTLMv2;
+		ctx->sectype = CIFS_SECTYPE_NTLMv2;
 		break;
 	case Opt_sec_none:
 		ctx->nullauth = 1;
diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
index 5f093cb7e9b9..52da4e67cae0 100644
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -182,7 +182,7 @@ struct smb3_fs_context {
 	kgid_t backupgid;
 	umode_t file_mode;
 	umode_t dir_mode;
-	enum securityEnum sectype; /* sectype requested via mnt opts */
+	cifs_sectype_t sectype; /* sectype requested via mnt opts */
 	bool sign; /* was signing requested via mnt opts? */
 	bool ignore_signature:1;
 	bool retry:1;
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 2584b150a648..dd34b73eea97 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -1114,40 +1114,40 @@ int build_ntlmssp_auth_blob(unsigned char **pbuffer,
 	return rc;
 }
 
-enum securityEnum
-cifs_select_sectype(struct cifs_server_info *server, enum securityEnum requested)
+cifs_sectype_t
+cifs_select_sectype(struct cifs_server_info *server, cifs_sectype_t requested)
 {
 	switch (server->negflavor) {
 	case CIFS_NEGFLAVOR_EXTENDED:
 		switch (requested) {
-		case Kerberos:
-		case RawNTLMSSP:
+		case CIFS_SECTYPE_KERBEROS:
+		case CIFS_SECTYPE_RAW_NTLMSSP:
 			return requested;
-		case Unspecified:
+		case CIFS_SECTYPE_UNSPEC:
 			if (server->sec_ntlmssp &&
 			    (global_secflags & CIFSSEC_MAY_NTLMSSP))
-				return RawNTLMSSP;
+				return CIFS_SECTYPE_RAW_NTLMSSP;
 			if ((server->sec_kerberos || server->sec_mskerberos) &&
 			    (global_secflags & CIFSSEC_MAY_KRB5))
-				return Kerberos;
+				return CIFS_SECTYPE_KERBEROS;
 			fallthrough;
 		default:
-			return Unspecified;
+			return CIFS_SECTYPE_UNSPEC;
 		}
 	case CIFS_NEGFLAVOR_UNENCAP:
 		switch (requested) {
-		case NTLMv2:
+		case CIFS_SECTYPE_NTLMv2:
 			return requested;
-		case Unspecified:
+		case CIFS_SECTYPE_UNSPEC:
 			if (global_secflags & CIFSSEC_MAY_NTLMV2)
-				return NTLMv2;
+				return CIFS_SECTYPE_NTLMv2;
 			break;
 		default:
 			break;
 		}
 		fallthrough;
 	default:
-		return Unspecified;
+		return CIFS_SECTYPE_UNSPEC;
 	}
 }
 
@@ -1782,16 +1782,16 @@ static int select_sec(struct sess_data *sess_data)
 
 	type = cifs_select_sectype(server, ses->sectype);
 	cifs_dbg(FYI, "sess setup type %d\n", type);
-	if (type == Unspecified) {
+	if (type == CIFS_SECTYPE_UNSPEC) {
 		cifs_dbg(VFS, "Unable to select appropriate authentication method!\n");
 		return -EINVAL;
 	}
 
 	switch (type) {
-	case NTLMv2:
+	case CIFS_SECTYPE_NTLMv2:
 		sess_data->func = sess_auth_ntlmv2;
 		break;
-	case Kerberos:
+	case CIFS_SECTYPE_KERBEROS:
 #ifdef CONFIG_CIFS_UPCALL
 		sess_data->func = sess_auth_kerberos;
 		break;
@@ -1799,7 +1799,7 @@ static int select_sec(struct sess_data *sess_data)
 		cifs_dbg(VFS, "Kerberos negotiated but upcall support disabled!\n");
 		return -ENOSYS;
 #endif /* CONFIG_CIFS_UPCALL */
-	case RawNTLMSSP:
+	case CIFS_SECTYPE_RAW_NTLMSSP:
 		sess_data->func = sess_auth_rawntlmssp_negotiate;
 		break;
 	default:
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 73d28b2b4517..c514d405f9d0 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1056,7 +1056,7 @@ SMB2_negotiate(const unsigned int xid,
 	/*
 	 * See MS-SMB2 section 2.2.4: if no blob, client picks default which
 	 * for us will be
-	 *	ses->sectype = RawNTLMSSP;
+	 *	ses->sectype = CIFS_SECTYPE_RAW_NTLMSSP;
 	 * but for time being this is our only auth choice so doesn't matter.
 	 * We just found a server which sets blob length to zero expecting raw.
 	 */
@@ -1227,25 +1227,25 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
 	return rc;
 }
 
-enum securityEnum
-smb2_select_sectype(struct cifs_server_info *server, enum securityEnum requested)
+cifs_sectype_t
+smb2_select_sectype(struct cifs_server_info *server, cifs_sectype_t requested)
 {
 	switch (requested) {
-	case Kerberos:
-	case RawNTLMSSP:
+	case CIFS_SECTYPE_KERBEROS:
+	case CIFS_SECTYPE_RAW_NTLMSSP:
 		return requested;
-	case NTLMv2:
-		return RawNTLMSSP;
-	case Unspecified:
+	case CIFS_SECTYPE_NTLMv2:
+		return CIFS_SECTYPE_RAW_NTLMSSP;
+	case CIFS_SECTYPE_UNSPEC:
 		if (server->sec_ntlmssp &&
 			(global_secflags & CIFSSEC_MAY_NTLMSSP))
-			return RawNTLMSSP;
+			return CIFS_SECTYPE_RAW_NTLMSSP;
 		if ((server->sec_kerberos || server->sec_mskerberos) &&
 			(global_secflags & CIFSSEC_MAY_KRB5))
-			return Kerberos;
+			return CIFS_SECTYPE_KERBEROS;
 		fallthrough;
 	default:
-		return Unspecified;
+		return CIFS_SECTYPE_UNSPEC;
 	}
 }
 
@@ -1671,16 +1671,16 @@ SMB2_select_sec(struct SMB2_sess_data *sess_data)
 
 	type = smb2_select_sectype(server, ses->sectype);
 	cifs_dbg(FYI, "sess setup type %d\n", type);
-	if (type == Unspecified) {
+	if (type == CIFS_SECTYPE_UNSPEC) {
 		cifs_dbg(VFS, "Unable to select appropriate authentication method!\n");
 		return -EINVAL;
 	}
 
 	switch (type) {
-	case Kerberos:
+	case CIFS_SECTYPE_KERBEROS:
 		sess_data->func = SMB2_auth_kerberos;
 		break;
-	case RawNTLMSSP:
+	case CIFS_SECTYPE_RAW_NTLMSSP:
 		sess_data->func = SMB2_sess_auth_rawntlmssp_negotiate;
 		break;
 	default:
@@ -1884,7 +1884,7 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 	    !smb3_encryption_required(tcon) &&
 	    !(ses->session_flags &
 		    (SMB2_SESSION_FLAG_IS_GUEST|SMB2_SESSION_FLAG_IS_NULL)) &&
-	    ((ses->user_name != NULL) || (ses->sectype == Kerberos)))
+	    ((ses->user_name != NULL) || (ses->sectype == CIFS_SECTYPE_KERBEROS)))
 		req->hdr.Flags |= SMB2_FLAGS_SIGNED;
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 8ae83ce0083d..81241e844b6d 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -260,8 +260,8 @@ extern int SMB2_lease_break(const unsigned int xid, struct cifs_tcon *tcon,
 			    __u8 *lease_key, const __le32 lease_state);
 extern int smb3_validate_negotiate(const unsigned int, struct cifs_tcon *);
 
-extern enum securityEnum smb2_select_sectype(struct cifs_server_info *,
-					enum securityEnum);
+extern cifs_sectype_t smb2_select_sectype(struct cifs_server_info *,
+					cifs_sectype_t);
 extern void smb2_parse_contexts(struct cifs_server_info *server,
 				struct smb2_create_rsp *rsp,
 				unsigned int *epoch, char *lease_key,
-- 
2.35.3

