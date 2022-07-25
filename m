Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03CC5CCA48B
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Jul 2022 22:39:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237400AbiGYWjp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Jul 2022 18:39:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiGYWiv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Jul 2022 18:38:51 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C53125E85
        for <linux-cifs@vger.kernel.org>; Mon, 25 Jul 2022 15:37:46 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E5E1833720;
        Mon, 25 Jul 2022 22:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658788655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/AgmEBwMB0YI0m6pMmhNmtUN3FAVVIbWbQ6ld01vKtM=;
        b=pGE3sQZasxp5KZgCPCkr8V6prldNdYOdOk1LVX09FyP9N5YYDKjlrXiw4TrJ4P6tdH4itH
        zIXPiqnw8KPKF37rjM63T1lLOhEx6ADQXPM3WfTb752pceDr2wni6kBCjkgaYeyuKIWtaV
        qxROJvqm3XeI02YLfoqBbVFxSzAd8W4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658788655;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/AgmEBwMB0YI0m6pMmhNmtUN3FAVVIbWbQ6ld01vKtM=;
        b=FYILGZ1y/vpVldx4+NTyjGQj+tGFGYe2CSnitdJ+p1e3oXR+UjP0bFSxUXk7urPAw6VI3b
        TRp29Vy1DU9JocBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2E05B13ABB;
        Mon, 25 Jul 2022 22:37:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id urLHOC4b32IORwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 25 Jul 2022 22:37:34 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [RFC PATCH v2 06/10] cifs: change status and security types enums to constants
Date:   Mon, 25 Jul 2022 19:37:03 -0300
Message-Id: <20220725223707.14477-7-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220725223707.14477-1-ematsumiya@suse.de>
References: <20220725223707.14477-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Change server, tcon, and session status, and security types enums
to constants integers.

Since some of the status values were common between server, tcon, and
session, define a "generic" status code instead of having specific enums
for each data structure.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifs_debug.c    |   4 +-
 fs/cifs/cifs_swn.c      |   8 +--
 fs/cifs/cifsencrypt.c   |   2 +-
 fs/cifs/cifsfs.c        |  14 ++--
 fs/cifs/cifsglob.h      |  82 +++++++++--------------
 fs/cifs/cifsproto.h     |   6 +-
 fs/cifs/cifssmb.c       |  26 ++++----
 fs/cifs/connect.c       | 144 ++++++++++++++++++++--------------------
 fs/cifs/fs_context.c    |   8 +--
 fs/cifs/fs_context.h    |   2 +-
 fs/cifs/misc.c          |   4 +-
 fs/cifs/sess.c          |  32 ++++-----
 fs/cifs/smb1ops.c       |   2 +-
 fs/cifs/smb2ops.c       |   8 +--
 fs/cifs/smb2pdu.c       |  44 ++++++------
 fs/cifs/smb2proto.h     |   4 +-
 fs/cifs/smb2transport.c |  12 ++--
 fs/cifs/transport.c     |  24 +++----
 18 files changed, 203 insertions(+), 223 deletions(-)

diff --git a/fs/cifs/cifs_debug.c b/fs/cifs/cifs_debug.c
index eb24928e1298..c88bea9d3ac3 100644
--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -382,7 +382,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 				(ses->serverNOS == NULL)) {
 				seq_printf(m, "\n\t%d) Address: %s Uses: %d Capability: 0x%x\tSession Status: %d ",
 					i, ses->ip_addr, ses->ses_count,
-					ses->capabilities, ses->ses_status);
+					ses->capabilities, ses->status);
 				if (ses->session_flags & SMB2_SESSION_FLAG_IS_GUEST)
 					seq_printf(m, "Guest ");
 				else if (ses->session_flags & SMB2_SESSION_FLAG_IS_NULL)
@@ -394,7 +394,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 					"\n\tSMB session status: %d ",
 				i, ses->ip_addr, ses->serverDomain,
 				ses->ses_count, ses->serverOS, ses->serverNOS,
-				ses->capabilities, ses->ses_status);
+				ses->capabilities, ses->status);
 			}
 
 			seq_printf(m, "\n\tSecurity type: %s ",
diff --git a/fs/cifs/cifs_swn.c b/fs/cifs/cifs_swn.c
index 1e4c7cc5287f..b85da1e0648d 100644
--- a/fs/cifs/cifs_swn.c
+++ b/fs/cifs/cifs_swn.c
@@ -77,7 +77,7 @@ static int cifs_swn_send_register_message(struct cifs_swn_reg *swnreg)
 {
 	struct sk_buff *skb;
 	struct genlmsghdr *hdr;
-	enum securityEnum authtype;
+	int authtype;
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
+	case CIFS_SECTYPE_NTLMV2:
+	case CIFS_SECTYPE_RAW_NTLMSSP:
 		ret = cifs_swn_auth_info_ntlm(swnreg->tcon, skb);
 		if (ret < 0) {
 			cifs_dbg(VFS, "%s: Failed to get NTLM auth info: %d\n", __func__, ret);
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 7d8020b90220..a5d6f0def82a 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -143,7 +143,7 @@ int cifs_sign_rqst(struct smb_rqst *rqst, struct cifs_server_info *server,
 
 	spin_lock(&g_servers_lock);
 	if (!(cifs_pdu->Flags2 & SMBFLG2_SECURITY_SIGNATURE) ||
-	    server->status == CifsNeedNegotiate) {
+	    server->status == CIFS_STATUS_NEED_NEGOTIATE) {
 		spin_unlock(&g_servers_lock);
 		return rc;
 	}
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 6db4b008dbb1..59e2966b3594 100644
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
+	case CIFS_SECTYPE_NTLMV2:
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
@@ -712,14 +712,14 @@ static void cifs_umount_begin(struct super_block *sb)
 	tcon = cifs_sb_master_tcon(cifs_sb);
 
 	spin_lock(&g_servers_lock);
-	if ((tcon->tc_count > 1) || (tcon->status == TID_EXITING)) {
+	if ((tcon->tc_count > 1) || (tcon->status == CIFS_STATUS_EXITING)) {
 		/* we have other mounts to same share or we have
 		   already tried to force umount this and woken up
 		   all waiting network requests, nothing to do */
 		spin_unlock(&g_servers_lock);
 		return;
 	} else if (tcon->tc_count == 1)
-		tcon->status = TID_EXITING;
+		tcon->status = CIFS_STATUS_EXITING;
 	spin_unlock(&g_servers_lock);
 
 	/* cancel_brl_requests(tcon); */ /* BB mark all brl mids as exiting */
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 12b6aafa5fa6..c02be7cafa62 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -25,6 +25,7 @@
 #include <uapi/linux/cifs/cifs_mount.h>
 #include "../smbfs_common/smb2pdu.h"
 #include "smb2pdu.h"
+#include "cifspdu.h"
 
 #define SMB_PATH_MAX 260
 #define CIFS_PORT 445
@@ -107,46 +108,27 @@
 #define CIFS_MAX_WORKSTATION_LEN  (__NEW_UTS_LEN + 1)  /* reasonable max for client */
 
 /*
- * CIFS vfs client Status information (based on what we know.)
+ * Status information
  */
+#define CIFS_STATUS_NEW				0x0 /* server, ses, tcon */
+#define CIFS_STATUS_GOOD			0x1 /* server, ses, tcon */
+#define CIFS_STATUS_EXITING			0x2 /* server, ses, tcon */
+#define CIFS_STATUS_NEED_RECONNECT		0x3 /* server, ses, tcon */
+#define CIFS_STATUS_NEED_NEGOTIATE		0x4 /* server */
+#define CIFS_STATUS_NEED_TCON			0x5 /* tcon */
+#define CIFS_STATUS_IN_NEGOTIATE		0x6 /* server */
+#define CIFS_STATUS_IN_SETUP			0x7 /* ses */
+#define CIFS_STATUS_IN_TCON			0x8 /* tcon */
+#define CIFS_STATUS_NEED_FILES_INVALIDATE	0x9 /* ses */
+#define CIFS_STATUS_IN_FILES_INVALIDATE		0xa /* ses */
 
-/* associated with each connection */
-enum statusEnum {
-	CifsNew = 0,
-	CifsGood,
-	CifsExiting,
-	CifsNeedReconnect,
-	CifsNeedNegotiate,
-	CifsInNegotiate,
-};
-
-/* associated with each smb session */
-enum ses_status_enum {
-	SES_NEW = 0,
-	SES_GOOD,
-	SES_EXITING,
-	SES_NEED_RECON,
-	SES_IN_SETUP
-};
-
-/* associated with each tree connection to the server */
-enum tid_status_enum {
-	TID_NEW = 0,
-	TID_GOOD,
-	TID_EXITING,
-	TID_NEED_RECON,
-	TID_NEED_TCON,
-	TID_IN_TCON,
-	TID_NEED_FILES_INVALIDATE, /* currently unused */
-	TID_IN_FILES_INVALIDATE
-};
-
-enum securityEnum {
-	Unspecified = 0,	/* not specified */
-	NTLMv2,			/* Legacy NTLM auth with NTLMv2 hash */
-	RawNTLMSSP,		/* NTLMSSP without SPNEGO, NTLMv2 hash */
-	Kerberos,		/* Kerberos via SPNEGO */
-};
+/*
+ * Security types
+ */
+#define CIFS_SECTYPE_UNSPEC		0x0 /* not specified */
+#define CIFS_SECTYPE_NTLMV2		0x1 /* Legacy NTLM auth with NTLMv2 hash */
+#define CIFS_SECTYPE_RAW_NTLMSSP	0x2 /* NTLMSSP without SPNEGO, NTLMv2 hash */
+#define CIFS_SECTYPE_KERBEROS		0x3 /* Kerberos via SPNEGO */
 
 struct session_key {
 	unsigned int len;
@@ -506,8 +488,8 @@ struct smb_version_operations {
 	int (*is_transform_hdr)(void *buf);
 	int (*receive_transform)(struct cifs_server_info *,
 				 struct mid_q_entry **, char **, int *);
-	enum securityEnum (*select_sectype)(struct cifs_server_info *,
-			    enum securityEnum);
+	int (*select_sectype)(struct cifs_server_info *,
+			    int);
 	int (*next_header)(char *);
 	/* ioctl passthrough for query_info */
 	int (*ioctl_query_info)(const unsigned int xid,
@@ -612,7 +594,7 @@ struct cifs_server_info {
 	struct smb_version_operations	*ops;
 	struct smb_version_values	*vals;
 	/* updates to status protected by g_servers_lock */
-	enum statusEnum status; /* what we think the status is */
+	int status; /* what we think the status is */
 	char *hostname; /* hostname portion of UNC string */
 	struct socket *ssocket;
 	struct sockaddr_storage dstaddr;
@@ -1011,7 +993,7 @@ struct cifs_ses {
 	struct mutex session_mutex;
 	struct cifs_server_info *server;	/* pointer to server info */
 	int ses_count;		/* reference counter */
-	enum ses_status_enum ses_status;  /* updates protected by g_servers_lock */
+	int status; /* updates protected by g_servers_lock */
 	unsigned overrideSecFlg;  /* if non-zero override global sec flags */
 	char *serverOS;		/* name of operating system underlying server */
 	char *serverNOS;	/* name of network operating system of server */
@@ -1028,7 +1010,7 @@ struct cifs_ses {
 	char workstation_name[CIFS_MAX_WORKSTATION_LEN];
 	struct session_key auth_key;
 	struct ntlmssp_auth *ntlmssp; /* ciphertext, flags, server challenge */
-	enum securityEnum sectype; /* what security flavor was specified? */
+	int sectype; /* what security flavor was specified? */
 	bool sign;		/* is signing required? */
 	bool domainAuto:1;
 	__u16 session_flags;
@@ -1179,7 +1161,7 @@ struct cifs_tcon {
 	char *password;		/* for share-level security */
 	__u32 tid;		/* The 4 byte tree id */
 	__u16 Flags;		/* optional support bits */
-	enum tid_status_enum status;
+	int status;
 	atomic_t num_smbs_sent;
 	union {
 		struct {
@@ -1948,7 +1930,7 @@ extern struct list_head		g_servers_list;
  * tcp session, and the list of tcon's per smb session. It also protects
  * the reference counters for the server, smb session, and tcon. It also
  * protects some fields in the cifs_server_info struct such as dstaddr. Finally,
- * changes to the tcon->tidStatus should be done while holding this lock.
+ * changes to the tcon->status should be done while holding this lock.
  * generally the locks should be taken in order g_servers_lock before
  * tcon->open_file_lock and that before file->file_info_lock since the
  * structure order is cifs_socket-->cifs_ses-->cifs_tcon-->cifs_file
@@ -2041,14 +2023,14 @@ extern struct smb_version_values smb302_values;
 extern struct smb_version_operations smb311_operations;
 extern struct smb_version_values smb311_values;
 
-static inline char *get_security_type_str(enum securityEnum sectype)
+static inline char *get_security_type_str(int sectype)
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
+	case CIFS_SECTYPE_NTLMV2:
 		return "NTLMv2";
 	default:
 		return "Unknown";
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index fce0fd8b1024..5b08e74d7307 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -168,8 +168,7 @@ extern void header_assemble(struct smb_hdr *, char /* command */ ,
 extern int small_smb_init_no_tc(const int smb_cmd, const int wct,
 				struct cifs_ses *ses,
 				void **request_buf);
-extern enum securityEnum select_sectype(struct cifs_server_info *server,
-				enum securityEnum requested);
+extern int select_sectype(struct cifs_server_info *server, int requested);
 extern int CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
 			  struct cifs_server_info *server,
 			  const struct nls_table *nls_cp);
@@ -594,8 +593,7 @@ int cifs_create_mf_symlink(unsigned int xid, struct cifs_tcon *tcon,
 int __cifs_calc_signature(struct smb_rqst *rqst,
 			struct cifs_server_info *server, char *signature,
 			struct shash_desc *shash);
-enum securityEnum cifs_select_sectype(struct cifs_server_info *,
-					enum securityEnum);
+int cifs_select_sectype(struct cifs_server_info *, int);
 struct cifs_aio_ctx *cifs_aio_ctx_alloc(void);
 void cifs_aio_ctx_release(struct kref *refcount);
 int setup_aio_ctx_iter(struct cifs_aio_ctx *ctx, struct iov_iter *iter, int rw);
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 326db1db353e..4bdd1f8b4634 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -75,11 +75,11 @@ cifs_mark_open_files_invalid(struct cifs_tcon *tcon)
 
 	/* only send once per connect */
 	spin_lock(&g_servers_lock);
-	if ((tcon->ses->ses_status != SES_GOOD) || (tcon->status != TID_NEED_RECON)) {
+	if ((tcon->ses->status != CIFS_STATUS_GOOD) || (tcon->status != CIFS_STATUS_NEED_RECONNECT)) {
 		spin_unlock(&g_servers_lock);
 		return;
 	}
-	tcon->status = TID_IN_FILES_INVALIDATE;
+	tcon->status = CIFS_STATUS_IN_FILES_INVALIDATE;
 	spin_unlock(&g_servers_lock);
 
 	/* list all files open on tree connection and mark them invalid */
@@ -99,8 +99,8 @@ cifs_mark_open_files_invalid(struct cifs_tcon *tcon)
 	mutex_unlock(&tcon->crfid.fid_mutex);
 
 	spin_lock(&g_servers_lock);
-	if (tcon->status == TID_IN_FILES_INVALIDATE)
-		tcon->status = TID_NEED_TCON;
+	if (tcon->status == CIFS_STATUS_IN_FILES_INVALIDATE)
+		tcon->status = CIFS_STATUS_NEED_TCON;
 	spin_unlock(&g_servers_lock);
 
 	/*
@@ -135,7 +135,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	 * have tcon) are allowed as we start force umount
 	 */
 	spin_lock(&g_servers_lock);
-	if (tcon->status == TID_EXITING) {
+	if (tcon->status == CIFS_STATUS_EXITING) {
 		if (smb_command != SMB_COM_WRITE_ANDX &&
 		    smb_command != SMB_COM_OPEN_ANDX &&
 		    smb_command != SMB_COM_TREE_DISCONNECT) {
@@ -154,9 +154,9 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	 * reconnect -- should be greater than cifs socket timeout which is 7
 	 * seconds.
 	 */
-	while (server->status == CifsNeedReconnect) {
+	while (server->status == CIFS_STATUS_NEED_RECONNECT) {
 		rc = wait_event_interruptible_timeout(server->response_q,
-						      (server->status != CifsNeedReconnect),
+						      (server->status != CIFS_STATUS_NEED_RECONNECT),
 						      10 * HZ);
 		if (rc < 0) {
 			cifs_dbg(FYI, "%s: aborting reconnect due to a received signal by the process\n",
@@ -166,7 +166,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 
 		/* are we still trying to reconnect? */
 		spin_lock(&g_servers_lock);
-		if (server->status != CifsNeedReconnect) {
+		if (server->status != CIFS_STATUS_NEED_RECONNECT) {
 			spin_unlock(&g_servers_lock);
 			break;
 		}
@@ -202,7 +202,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	 * and status set to reconnect.
 	 */
 	spin_lock(&g_servers_lock);
-	if (server->status == CifsNeedReconnect) {
+	if (server->status == CIFS_STATUS_NEED_RECONNECT) {
 		spin_unlock(&g_servers_lock);
 		rc = -EHOSTDOWN;
 		goto out;
@@ -504,13 +504,13 @@ cifs_enable_signing(struct cifs_server_info *server, bool mnt_sign_required)
 }
 
 static bool
-should_set_ext_sec_flag(enum securityEnum sectype)
+should_set_ext_sec_flag(int sectype)
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
index 4ab1933fca76..fc777c6b7a3e 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -207,7 +207,7 @@ cifs_signal_cifsd_for_reconnect(struct cifs_server_info *server,
 
 	spin_lock(&g_servers_lock);
 	if (!all_channels) {
-		pserver->status = CifsNeedReconnect;
+		pserver->status = CIFS_STATUS_NEED_RECONNECT;
 		spin_unlock(&g_servers_lock);
 		return;
 	}
@@ -215,7 +215,7 @@ cifs_signal_cifsd_for_reconnect(struct cifs_server_info *server,
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
 		spin_lock(&ses->chan_lock);
 		for (i = 0; i < ses->chan_count; i++)
-			ses->chans[i].server->status = CifsNeedReconnect;
+			ses->chans[i].server->status = CIFS_STATUS_NEED_RECONNECT;
 		spin_unlock(&ses->chan_lock);
 	}
 	spin_unlock(&g_servers_lock);
@@ -228,7 +228,7 @@ cifs_signal_cifsd_for_reconnect(struct cifs_server_info *server,
  * cifs_signal_cifsd_for_reconnect
  *
  * @server: the tcp ses for which reconnect is needed
- * @server needs to be previously set to CifsNeedReconnect.
+ * @server needs to be previously set to CIFS_STATUS_NEED_RECONNECT.
  * @mark_smb_session: whether even sessions need to be marked
  */
 void
@@ -277,11 +277,11 @@ cifs_mark_server_conns_for_reconnect(struct cifs_server_info *server,
 		if (!mark_smb_session && !CIFS_ALL_CHANS_NEED_RECONNECT(ses))
 			goto next_session;
 
-		ses->ses_status = SES_NEED_RECON;
+		ses->status = CIFS_STATUS_NEED_RECONNECT;
 
 		list_for_each_entry(tcon, &ses->tcon_list, tcon_list) {
 			tcon->need_reconnect = true;
-			tcon->status = TID_NEED_RECON;
+			tcon->status = CIFS_STATUS_NEED_RECONNECT;
 		}
 		if (ses->tcon_ipc)
 			ses->tcon_ipc->need_reconnect = true;
@@ -352,7 +352,7 @@ static bool cifs_server_needs_reconnect(struct cifs_server_info *server, int num
 {
 	spin_lock(&g_servers_lock);
 	server->nr_targets = num_targets;
-	if (server->status == CifsExiting) {
+	if (server->status == CIFS_STATUS_EXITING) {
 		/* the demux thread will exit normally next time through the loop */
 		spin_unlock(&g_servers_lock);
 		wake_up(&server->response_q);
@@ -362,7 +362,7 @@ static bool cifs_server_needs_reconnect(struct cifs_server_info *server, int num
 	cifs_dbg(FYI, "Mark tcp session as need reconnect\n");
 	trace_smb3_reconnect(server->current_mid, server->conn_id,
 			     server->hostname);
-	server->status = CifsNeedReconnect;
+	server->status = CIFS_STATUS_NEED_RECONNECT;
 
 	spin_unlock(&g_servers_lock);
 	return true;
@@ -415,17 +415,17 @@ static int __cifs_reconnect(struct cifs_server_info *server,
 			atomic_inc(&g_server_reconnect_count);
 			set_credits(server, 1);
 			spin_lock(&g_servers_lock);
-			if (server->status != CifsExiting)
-				server->status = CifsNeedNegotiate;
+			if (server->status != CIFS_STATUS_EXITING)
+				server->status = CIFS_STATUS_NEED_NEGOTIATE;
 			spin_unlock(&g_servers_lock);
 			cifs_swn_reset_server_dstaddr(server);
 			cifs_server_unlock(server);
 			mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
 		}
-	} while (server->status == CifsNeedReconnect);
+	} while (server->status == CIFS_STATUS_NEED_RECONNECT);
 
 	spin_lock(&g_servers_lock);
-	if (server->status == CifsNeedNegotiate)
+	if (server->status == CIFS_STATUS_NEED_NEGOTIATE)
 		mod_delayed_work(cifsiod_wq, &server->echo, 0);
 	spin_unlock(&g_servers_lock);
 
@@ -535,20 +535,20 @@ static int reconnect_dfs_server(struct cifs_server_info *server)
 			continue;
 		}
 		/*
-		 * Socket was created.  Update tcp session status to CifsNeedNegotiate so that a
+		 * Socket was created.  Update tcp session status to CIFS_STATUS_NEED_NEGOTIATE so that a
 		 * process waiting for reconnect will know it needs to re-establish session and tcon
 		 * through the reconnected target server.
 		 */
 		atomic_inc(&g_server_reconnect_count);
 		set_credits(server, 1);
 		spin_lock(&g_servers_lock);
-		if (server->status != CifsExiting)
-			server->status = CifsNeedNegotiate;
+		if (server->status != CIFS_STATUS_EXITING)
+			server->status = CIFS_STATUS_NEED_NEGOTIATE;
 		spin_unlock(&g_servers_lock);
 		cifs_swn_reset_server_dstaddr(server);
 		cifs_server_unlock(server);
 		mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
-	} while (server->status == CifsNeedReconnect);
+	} while (server->status == CIFS_STATUS_NEED_RECONNECT);
 
 	if (target_hint)
 		dfs_cache_noreq_update_tgthint(refpath, target_hint);
@@ -557,7 +557,7 @@ static int reconnect_dfs_server(struct cifs_server_info *server)
 
 	/* Need to set up echo worker again once connection has been established */
 	spin_lock(&g_servers_lock);
-	if (server->status == CifsNeedNegotiate)
+	if (server->status == CIFS_STATUS_NEED_NEGOTIATE)
 		mod_delayed_work(cifsiod_wq, &server->echo, 0);
 
 	spin_unlock(&g_servers_lock);
@@ -604,9 +604,9 @@ cifs_echo_request(struct work_struct *work)
 	 * Also, no need to ping if we got a response recently.
 	 */
 
-	if (server->status == CifsNeedReconnect ||
-	    server->status == CifsExiting ||
-	    server->status == CifsNew ||
+	if (server->status == CIFS_STATUS_NEED_RECONNECT ||
+	    server->status == CIFS_STATUS_EXITING ||
+	    server->status == CIFS_STATUS_NEW ||
 	    (server->ops->can_echo && !server->ops->can_echo(server)) ||
 	    time_before(jiffies, server->lstrp + server->echo_interval - HZ))
 		goto requeue_echo;
@@ -671,8 +671,8 @@ server_unresponsive(struct cifs_server_info *server)
 	 *     a response in >60s.
 	 */
 	spin_lock(&g_servers_lock);
-	if ((server->status == CifsGood ||
-	    server->status == CifsNeedNegotiate) &&
+	if ((server->status == CIFS_STATUS_GOOD ||
+	    server->status == CIFS_STATUS_NEED_NEGOTIATE) &&
 	    (!server->ops->can_echo || server->ops->can_echo(server)) &&
 	    time_after(jiffies, server->lstrp + 3 * server->echo_interval)) {
 		spin_unlock(&g_servers_lock);
@@ -727,12 +727,12 @@ cifs_readv_from_socket(struct cifs_server_info *server, struct msghdr *smb_msg)
 			length = sock_recvmsg(server->ssocket, smb_msg, 0);
 
 		spin_lock(&g_servers_lock);
-		if (server->status == CifsExiting) {
+		if (server->status == CIFS_STATUS_EXITING) {
 			spin_unlock(&g_servers_lock);
 			return -ESHUTDOWN;
 		}
 
-		if (server->status == CifsNeedReconnect) {
+		if (server->status == CIFS_STATUS_NEED_RECONNECT) {
 			spin_unlock(&g_servers_lock);
 			cifs_reconnect(server, false);
 			return -ECONNABORTED;
@@ -745,7 +745,7 @@ cifs_readv_from_socket(struct cifs_server_info *server, struct msghdr *smb_msg)
 			/*
 			 * Minimum sleep to prevent looping, allowing socket
 			 * to clear and app threads to set status
-			 * CifsNeedReconnect if server hung.
+			 * CIFS_STATUS_NEED_RECONNECT if server hung.
 			 */
 			usleep_range(1000, 2000);
 			length = 0;
@@ -916,7 +916,7 @@ static void clean_demultiplex_info(struct cifs_server_info *server)
 	cancel_delayed_work_sync(&server->resolve);
 
 	spin_lock(&g_servers_lock);
-	server->status = CifsExiting;
+	server->status = CIFS_STATUS_EXITING;
 	spin_unlock(&g_servers_lock);
 	wake_up_all(&server->response_q);
 
@@ -1123,7 +1123,7 @@ cifs_demultiplex_thread(void *p)
 
 	set_freezable();
 	allow_kernel_signal(SIGKILL);
-	while (server->status != CifsExiting) {
+	while (server->status != CIFS_STATUS_EXITING) {
 		if (try_to_freeze())
 			continue;
 
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
@@ -1534,7 +1534,7 @@ cifs_put_server(struct cifs_server_info *server, int from_reconnect)
 		cancel_delayed_work_sync(&server->reconnect);
 
 	spin_lock(&g_servers_lock);
-	server->status = CifsExiting;
+	server->status = CIFS_STATUS_EXITING;
 	spin_unlock(&g_servers_lock);
 
 	cifs_crypto_secmech_release(server);
@@ -1634,7 +1634,7 @@ cifs_get_server(struct smb3_fs_context *ctx,
 	 * to the struct since the kernel thread not created yet
 	 * no need to spinlock this init of status or srv_count
 	 */
-	server->status = CifsNew;
+	server->status = CIFS_STATUS_NEW;
 	++server->srv_count;
 
 	if (ctx->echo_interval >= SMB_ECHO_INTERVAL_MIN &&
@@ -1685,7 +1685,7 @@ cifs_get_server(struct smb3_fs_context *ctx,
 	 * no need to spinlock this update of status
 	 */
 	spin_lock(&g_servers_lock);
-	server->status = CifsNeedNegotiate;
+	server->status = CIFS_STATUS_NEED_NEGOTIATE;
 	spin_unlock(&g_servers_lock);
 
 	if ((ctx->max_credits < 20) || (ctx->max_credits > 60000))
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
@@ -1863,7 +1863,7 @@ cifs_find_smb_ses(struct cifs_server_info *server, struct smb3_fs_context *ctx)
 
 	spin_lock(&g_servers_lock);
 	list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
-		if (ses->ses_status == SES_EXITING)
+		if (ses->status == CIFS_STATUS_EXITING)
 			continue;
 		if (!match_session(ses, ctx))
 			continue;
@@ -1882,7 +1882,7 @@ void cifs_put_smb_ses(struct cifs_ses *ses)
 	struct cifs_server_info *server = ses->server;
 
 	spin_lock(&g_servers_lock);
-	if (ses->ses_status == SES_EXITING) {
+	if (ses->status == CIFS_STATUS_EXITING) {
 		spin_unlock(&g_servers_lock);
 		return;
 	}
@@ -1898,13 +1898,13 @@ void cifs_put_smb_ses(struct cifs_ses *ses)
 	/* ses_count can never go negative */
 	WARN_ON(ses->ses_count < 0);
 
-	if (ses->ses_status == SES_GOOD)
-		ses->ses_status = SES_EXITING;
+	if (ses->status == CIFS_STATUS_GOOD)
+		ses->status = CIFS_STATUS_EXITING;
 	spin_unlock(&g_servers_lock);
 
 	cifs_free_ipc(ses);
 
-	if (ses->ses_status == SES_EXITING && server->ops->logoff) {
+	if (ses->status == CIFS_STATUS_EXITING && server->ops->logoff) {
 		xid = get_xid();
 		rc = server->ops->logoff(xid, ses);
 		if (rc)
@@ -2113,7 +2113,7 @@ cifs_get_smb_ses(struct cifs_server_info *server, struct smb3_fs_context *ctx)
 	ses = cifs_find_smb_ses(server, ctx);
 	if (ses) {
 		cifs_dbg(FYI, "Existing smb sess found (status=%d)\n",
-			 ses->ses_status);
+			 ses->status);
 
 		spin_lock(&ses->chan_lock);
 		if (cifs_chan_needs_reconnect(ses, server)) {
@@ -2237,7 +2237,7 @@ cifs_get_smb_ses(struct cifs_server_info *server, struct smb3_fs_context *ctx)
 
 static int match_tcon(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 {
-	if (tcon->status == TID_EXITING)
+	if (tcon->status == CIFS_STATUS_EXITING)
 		return 0;
 	if (strncmp(tcon->treeName, ctx->UNC, MAX_TREE_SIZE))
 		return 0;
@@ -3179,7 +3179,7 @@ static int mount_get_conns(struct mount_ctx *mnt_ctx)
 		 */
 		reset_cifs_unix_caps(xid, tcon, cifs_sb, ctx);
 		spin_lock(&g_servers_lock);
-		if ((tcon->ses->server->status == CifsNeedReconnect) &&
+		if ((tcon->ses->server->status == CIFS_STATUS_NEED_RECONNECT) &&
 		    (le64_to_cpu(tcon->fsUnixInfo.Capability) &
 		     CIFS_UNIX_TRANSPORT_ENCRYPTION_MANDATORY_CAP)) {
 			spin_unlock(&g_servers_lock);
@@ -3988,25 +3988,25 @@ cifs_negotiate_protocol(const unsigned int xid, struct cifs_ses *ses,
 	/* only send once per connect */
 	spin_lock(&g_servers_lock);
 	if (!server->ops->need_neg(server) ||
-	    server->status != CifsNeedNegotiate) {
+	    server->status != CIFS_STATUS_NEED_NEGOTIATE) {
 		spin_unlock(&g_servers_lock);
 		return 0;
 	}
-	server->status = CifsInNegotiate;
+	server->status = CIFS_STATUS_IN_NEGOTIATE;
 	spin_unlock(&g_servers_lock);
 
 	rc = server->ops->negotiate(xid, ses, server);
 	if (rc == 0) {
 		spin_lock(&g_servers_lock);
-		if (server->status == CifsInNegotiate)
-			server->status = CifsGood;
+		if (server->status == CIFS_STATUS_IN_NEGOTIATE)
+			server->status = CIFS_STATUS_GOOD;
 		else
 			rc = -EHOSTDOWN;
 		spin_unlock(&g_servers_lock);
 	} else {
 		spin_lock(&g_servers_lock);
-		if (server->status == CifsInNegotiate)
-			server->status = CifsNeedNegotiate;
+		if (server->status == CIFS_STATUS_IN_NEGOTIATE)
+			server->status = CIFS_STATUS_NEED_NEGOTIATE;
 		spin_unlock(&g_servers_lock);
 	}
 
@@ -4029,9 +4029,9 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 	else
 		scnprintf(ses->ip_addr, sizeof(ses->ip_addr), "%pI4", &addr->sin_addr);
 
-	if (ses->ses_status != SES_GOOD &&
-	    ses->ses_status != SES_NEW &&
-	    ses->ses_status != SES_NEED_RECON) {
+	if (ses->status != CIFS_STATUS_GOOD &&
+	    ses->status != CIFS_STATUS_NEW &&
+	    ses->status != CIFS_STATUS_NEED_RECONNECT) {
 		spin_unlock(&g_servers_lock);
 		return 0;
 	}
@@ -4049,7 +4049,7 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 	spin_unlock(&ses->chan_lock);
 
 	if (!is_binding)
-		ses->ses_status = SES_IN_SETUP;
+		ses->status = CIFS_STATUS_IN_SETUP;
 	spin_unlock(&g_servers_lock);
 
 	if (!is_binding) {
@@ -4075,16 +4075,16 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 	if (rc) {
 		cifs_server_dbg(VFS, "Send error in SessSetup = %d\n", rc);
 		spin_lock(&g_servers_lock);
-		if (ses->ses_status == SES_IN_SETUP)
-			ses->ses_status = SES_NEED_RECON;
+		if (ses->status == CIFS_STATUS_IN_SETUP)
+			ses->status = CIFS_STATUS_NEED_RECONNECT;
 		spin_lock(&ses->chan_lock);
 		cifs_chan_clear_in_reconnect(ses, server);
 		spin_unlock(&ses->chan_lock);
 		spin_unlock(&g_servers_lock);
 	} else {
 		spin_lock(&g_servers_lock);
-		if (ses->ses_status == SES_IN_SETUP)
-			ses->ses_status = SES_GOOD;
+		if (ses->status == CIFS_STATUS_IN_SETUP)
+			ses->status = CIFS_STATUS_GOOD;
 		spin_lock(&ses->chan_lock);
 		cifs_chan_clear_in_reconnect(ses, server);
 		cifs_chan_clear_need_reconnect(ses, server);
@@ -4101,7 +4101,7 @@ cifs_set_vol_auth(struct smb3_fs_context *ctx, struct cifs_ses *ses)
 	ctx->sectype = ses->sectype;
 
 	/* krb5 is special, since we don't need username or pw */
-	if (ctx->sectype == Kerberos)
+	if (ctx->sectype == CIFS_SECTYPE_KERBEROS)
 		return 0;
 
 	return cifs_set_cifscreds(ctx, ses);
@@ -4559,13 +4559,13 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 
 	/* only send once per connect */
 	spin_lock(&g_servers_lock);
-	if (tcon->ses->ses_status != SES_GOOD ||
-	    (tcon->status != TID_NEW &&
-	    tcon->status != TID_NEED_TCON)) {
+	if (tcon->ses->status != CIFS_STATUS_GOOD ||
+	    (tcon->status != CIFS_STATUS_NEW &&
+	    tcon->status != CIFS_STATUS_NEED_TCON)) {
 		spin_unlock(&g_servers_lock);
 		return 0;
 	}
-	tcon->status = TID_IN_TCON;
+	tcon->status = CIFS_STATUS_IN_TCON;
 	spin_unlock(&g_servers_lock);
 
 	tree = kzalloc(MAX_TREE_SIZE, GFP_KERNEL);
@@ -4606,13 +4606,13 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 
 	if (rc) {
 		spin_lock(&g_servers_lock);
-		if (tcon->status == TID_IN_TCON)
-			tcon->status = TID_NEED_TCON;
+		if (tcon->status == CIFS_STATUS_IN_TCON)
+			tcon->status = CIFS_STATUS_NEED_TCON;
 		spin_unlock(&g_servers_lock);
 	} else {
 		spin_lock(&g_servers_lock);
-		if (tcon->status == TID_IN_TCON)
-			tcon->status = TID_GOOD;
+		if (tcon->status == CIFS_STATUS_IN_TCON)
+			tcon->status = CIFS_STATUS_GOOD;
 		spin_unlock(&g_servers_lock);
 		tcon->need_reconnect = false;
 	}
@@ -4627,25 +4627,25 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon, const stru
 
 	/* only send once per connect */
 	spin_lock(&g_servers_lock);
-	if (tcon->ses->ses_status != SES_GOOD ||
-	    (tcon->status != TID_NEW &&
-	    tcon->status != TID_NEED_TCON)) {
+	if (tcon->ses->status != CIFS_STATUS_GOOD ||
+	    (tcon->status != CIFS_STATUS_NEW &&
+	    tcon->status != CIFS_STATUS_NEED_TCON)) {
 		spin_unlock(&g_servers_lock);
 		return 0;
 	}
-	tcon->status = TID_IN_TCON;
+	tcon->status = CIFS_STATUS_IN_TCON;
 	spin_unlock(&g_servers_lock);
 
 	rc = ops->tree_connect(xid, tcon->ses, tcon->treeName, tcon, nlsc);
 	if (rc) {
 		spin_lock(&g_servers_lock);
-		if (tcon->status == TID_IN_TCON)
-			tcon->status = TID_NEED_TCON;
+		if (tcon->status == CIFS_STATUS_IN_TCON)
+			tcon->status = CIFS_STATUS_NEED_TCON;
 		spin_unlock(&g_servers_lock);
 	} else {
 		spin_lock(&g_servers_lock);
-		if (tcon->status == TID_IN_TCON)
-			tcon->status = TID_GOOD;
+		if (tcon->status == CIFS_STATUS_IN_TCON)
+			tcon->status = CIFS_STATUS_GOOD;
 		spin_unlock(&g_servers_lock);
 		tcon->need_reconnect = false;
 	}
diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 8dc0d923ef6a..e9de045b97a6 100644
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
+		ctx->sectype = CIFS_SECTYPE_NTLMV2;
 		break;
 	case Opt_sec_none:
 		ctx->nullauth = 1;
diff --git a/fs/cifs/fs_context.h b/fs/cifs/fs_context.h
index 5f093cb7e9b9..b9cf73bdbe81 100644
--- a/fs/cifs/fs_context.h
+++ b/fs/cifs/fs_context.h
@@ -182,7 +182,7 @@ struct smb3_fs_context {
 	kgid_t backupgid;
 	umode_t file_mode;
 	umode_t dir_mode;
-	enum securityEnum sectype; /* sectype requested via mnt opts */
+	int sectype; /* sectype requested via mnt opts */
 	bool sign; /* was signing requested via mnt opts? */
 	bool ignore_signature:1;
 	bool retry:1;
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index a31780cf6d21..0773b5a2ddb7 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -69,7 +69,7 @@ sesInfoAlloc(void)
 	ret_buf = kzalloc(sizeof(struct cifs_ses), GFP_KERNEL);
 	if (ret_buf) {
 		atomic_inc(&g_ses_alloc_count);
-		ret_buf->ses_status = SES_NEW;
+		ret_buf->status = CIFS_STATUS_NEW;
 		++ret_buf->ses_count;
 		INIT_LIST_HEAD(&ret_buf->smb_ses_list);
 		INIT_LIST_HEAD(&ret_buf->tcon_list);
@@ -124,7 +124,7 @@ tconInfoAlloc(void)
 	mutex_init(&ret_buf->crfid.dirents.de_mutex);
 
 	atomic_inc(&g_tcon_alloc_count);
-	ret_buf->status = TID_NEW;
+	ret_buf->status = CIFS_STATUS_NEW;
 	++ret_buf->tc_count;
 	INIT_LIST_HEAD(&ret_buf->openFileList);
 	INIT_LIST_HEAD(&ret_buf->tcon_list);
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 2584b150a648..31c81bf96b13 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -1114,40 +1114,40 @@ int build_ntlmssp_auth_blob(unsigned char **pbuffer,
 	return rc;
 }
 
-enum securityEnum
-cifs_select_sectype(struct cifs_server_info *server, enum securityEnum requested)
+int
+cifs_select_sectype(struct cifs_server_info *server, int requested)
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
+		case CIFS_SECTYPE_NTLMV2:
 			return requested;
-		case Unspecified:
+		case CIFS_SECTYPE_UNSPEC:
 			if (global_secflags & CIFSSEC_MAY_NTLMV2)
-				return NTLMv2;
+				return CIFS_SECTYPE_NTLMV2;
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
+	case CIFS_SECTYPE_NTLMV2:
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
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 8b2a504c92f1..e184f1806e26 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -1024,7 +1024,7 @@ cifs_dir_needs_close(struct cifs_file_info *cfile)
 static bool
 cifs_can_echo(struct cifs_server_info *server)
 {
-	if (server->status == CifsGood)
+	if (server->status == CIFS_STATUS_GOOD)
 		return true;
 
 	return false;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 41d1237bb24c..f10a8eab3ffb 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -127,8 +127,8 @@ smb2_add_credits(struct cifs_server_info *server,
 	}
 
 	spin_lock(&g_servers_lock);
-	if (server->status == CifsNeedReconnect
-	    || server->status == CifsExiting) {
+	if (server->status == CIFS_STATUS_NEED_RECONNECT
+	    || server->status == CIFS_STATUS_EXITING) {
 		spin_unlock(&g_servers_lock);
 		return;
 	}
@@ -219,7 +219,7 @@ smb2_wait_mtu_credits(struct cifs_server_info *server, unsigned int size,
 		} else {
 			spin_unlock(&server->req_lock);
 			spin_lock(&g_servers_lock);
-			if (server->status == CifsExiting) {
+			if (server->status == CIFS_STATUS_EXITING) {
 				spin_unlock(&g_servers_lock);
 				return -ENOENT;
 			}
@@ -5080,7 +5080,7 @@ static void smb2_decrypt_offload(struct work_struct *work)
 		} else {
 			spin_lock(&g_servers_lock);
 			spin_lock(&g_mid_lock);
-			if (dw->server->status == CifsNeedReconnect) {
+			if (dw->server->status == CIFS_STATUS_NEED_RECONNECT) {
 				mid->mid_state = MID_RETRY_NEEDED;
 				spin_unlock(&g_mid_lock);
 				spin_unlock(&g_servers_lock);
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index b5bdd7356d59..72978655d2c3 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -163,7 +163,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		return 0;
 
 	spin_lock(&g_servers_lock);
-	if (tcon->status == TID_EXITING) {
+	if (tcon->status == CIFS_STATUS_EXITING) {
 		/*
 		 * only tree disconnect, open, and write,
 		 * (and ulogoff which does not have tcon)
@@ -179,7 +179,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		}
 	}
 	spin_unlock(&g_servers_lock);
-	if ((!tcon->ses) || (tcon->ses->ses_status == SES_EXITING) ||
+	if ((!tcon->ses) || (tcon->ses->status == CIFS_STATUS_EXITING) ||
 	    (!tcon->ses->server) || !server)
 		return -EIO;
 
@@ -191,7 +191,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	 * reconnect -- should be greater than cifs socket timeout which is 7
 	 * seconds.
 	 */
-	while (server->status == CifsNeedReconnect) {
+	while (server->status == CIFS_STATUS_NEED_RECONNECT) {
 		/*
 		 * Return to caller for TREE_DISCONNECT and LOGOFF and CLOSE
 		 * here since they are implicitly done when session drops.
@@ -208,7 +208,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		}
 
 		rc = wait_event_interruptible_timeout(server->response_q,
-						      (server->status != CifsNeedReconnect),
+						      (server->status != CIFS_STATUS_NEED_RECONNECT),
 						      10 * HZ);
 		if (rc < 0) {
 			cifs_dbg(FYI, "%s: aborting reconnect due to a received signal by the process\n",
@@ -218,7 +218,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 
 		/* are we still trying to reconnect? */
 		spin_lock(&g_servers_lock);
-		if (server->status != CifsNeedReconnect) {
+		if (server->status != CIFS_STATUS_NEED_RECONNECT) {
 			spin_unlock(&g_servers_lock);
 			break;
 		}
@@ -257,7 +257,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 	 * and status set to reconnect.
 	 */
 	spin_lock(&g_servers_lock);
-	if (server->status == CifsNeedReconnect) {
+	if (server->status == CIFS_STATUS_NEED_RECONNECT) {
 		spin_unlock(&g_servers_lock);
 		rc = -EHOSTDOWN;
 		goto out;
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
+int
+smb2_select_sectype(struct cifs_server_info *server, int requested)
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
+	case CIFS_SECTYPE_NTLMV2:
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
@@ -3873,7 +3873,7 @@ void smb2_reconnect_server(struct work_struct *work)
 		goto done;
 	}
 
-	tcon->status = TID_GOOD;
+	tcon->status = CIFS_STATUS_GOOD;
 	tcon->retry = false;
 	tcon->need_reconnect = false;
 
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 8ae83ce0083d..e164e1ff2ee2 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -260,8 +260,8 @@ extern int SMB2_lease_break(const unsigned int xid, struct cifs_tcon *tcon,
 			    __u8 *lease_key, const __le32 lease_state);
 extern int smb3_validate_negotiate(const unsigned int, struct cifs_tcon *);
 
-extern enum securityEnum smb2_select_sectype(struct cifs_server_info *,
-					enum securityEnum);
+extern int smb2_select_sectype(struct cifs_server_info *,
+					int);
 extern void smb2_parse_contexts(struct cifs_server_info *server,
 				struct smb2_create_rsp *rsp,
 				unsigned int *epoch, char *lease_key,
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 4417953ecbb2..816c764a5bd4 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -763,24 +763,24 @@ smb2_get_mid_entry(struct cifs_ses *ses, struct cifs_server_info *server,
 		   struct smb2_hdr *shdr, struct mid_q_entry **mid)
 {
 	spin_lock(&g_servers_lock);
-	if (server->status == CifsExiting) {
+	if (server->status == CIFS_STATUS_EXITING) {
 		spin_unlock(&g_servers_lock);
 		return -ENOENT;
 	}
 
-	if (server->status == CifsNeedReconnect) {
+	if (server->status == CIFS_STATUS_NEED_RECONNECT) {
 		spin_unlock(&g_servers_lock);
 		cifs_dbg(FYI, "tcp session dead - return to caller to retry\n");
 		return -EAGAIN;
 	}
 
-	if (server->status == CifsNeedNegotiate &&
+	if (server->status == CIFS_STATUS_NEED_NEGOTIATE &&
 	   shdr->Command != SMB2_NEGOTIATE) {
 		spin_unlock(&g_servers_lock);
 		return -EAGAIN;
 	}
 
-	if (ses->ses_status == SES_NEW) {
+	if (ses->status == CIFS_STATUS_NEW) {
 		if ((shdr->Command != SMB2_SESSION_SETUP) &&
 		    (shdr->Command != SMB2_NEGOTIATE)) {
 			spin_unlock(&g_servers_lock);
@@ -789,7 +789,7 @@ smb2_get_mid_entry(struct cifs_ses *ses, struct cifs_server_info *server,
 		/* else ok - we are setting up session */
 	}
 
-	if (ses->ses_status == SES_EXITING) {
+	if (ses->status == CIFS_STATUS_EXITING) {
 		if (shdr->Command != SMB2_LOGOFF) {
 			spin_unlock(&g_servers_lock);
 			return -EAGAIN;
@@ -870,7 +870,7 @@ smb2_setup_async_request(struct cifs_server_info *server, struct smb_rqst *rqst)
 	struct mid_q_entry *mid;
 
 	spin_lock(&g_servers_lock);
-	if (server->status == CifsNeedNegotiate &&
+	if (server->status == CIFS_STATUS_NEED_NEGOTIATE &&
 	   shdr->Command != SMB2_NEGOTIATE) {
 		spin_unlock(&g_servers_lock);
 		return ERR_PTR(-EAGAIN);
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 22ed055c0c39..81022ef20d62 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -578,7 +578,7 @@ wait_for_free_credits(struct cifs_server_info *server, const int num_credits,
 			spin_unlock(&server->req_lock);
 
 			spin_lock(&g_servers_lock);
-			if (server->status == CifsExiting) {
+			if (server->status == CIFS_STATUS_EXITING) {
 				spin_unlock(&g_servers_lock);
 				return -ENOENT;
 			}
@@ -726,7 +726,7 @@ static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,
 			struct mid_q_entry **ppmidQ)
 {
 	spin_lock(&g_servers_lock);
-	if (ses->ses_status == SES_NEW) {
+	if (ses->status == CIFS_STATUS_NEW) {
 		if ((in_buf->Command != SMB_COM_SESSION_SETUP_ANDX) &&
 			(in_buf->Command != SMB_COM_NEGOTIATE)) {
 			spin_unlock(&g_servers_lock);
@@ -735,7 +735,7 @@ static int allocate_mid(struct cifs_ses *ses, struct smb_hdr *in_buf,
 		/* else ok - we are setting up session */
 	}
 
-	if (ses->ses_status == SES_EXITING) {
+	if (ses->status == CIFS_STATUS_EXITING) {
 		/* check if SMB session is bad because we are setting it up */
 		if (in_buf->Command != SMB_COM_LOGOFF_ANDX) {
 			spin_unlock(&g_servers_lock);
@@ -1079,7 +1079,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	}
 
 	spin_lock(&g_servers_lock);
-	if (server->status == CifsExiting) {
+	if (server->status == CIFS_STATUS_EXITING) {
 		spin_unlock(&g_servers_lock);
 		return -ENOENT;
 	}
@@ -1187,7 +1187,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	 * Compounding is never used during session establish.
 	 */
 	spin_lock(&g_servers_lock);
-	if ((ses->ses_status == SES_NEW) || (optype & CIFS_NEG_OP) || (optype & CIFS_SESS_OP)) {
+	if ((ses->status == CIFS_STATUS_NEW) || (optype & CIFS_NEG_OP) || (optype & CIFS_SESS_OP)) {
 		spin_unlock(&g_servers_lock);
 
 		cifs_server_lock(server);
@@ -1260,7 +1260,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	 * Compounding is never used during session establish.
 	 */
 	spin_lock(&g_servers_lock);
-	if ((ses->ses_status == SES_NEW) || (optype & CIFS_NEG_OP) || (optype & CIFS_SESS_OP)) {
+	if ((ses->status == CIFS_STATUS_NEW) || (optype & CIFS_NEG_OP) || (optype & CIFS_SESS_OP)) {
 		struct kvec iov = {
 			.iov_base = resp_iov[0].iov_base,
 			.iov_len = resp_iov[0].iov_len
@@ -1361,7 +1361,7 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	}
 
 	spin_lock(&g_servers_lock);
-	if (server->status == CifsExiting) {
+	if (server->status == CIFS_STATUS_EXITING) {
 		spin_unlock(&g_servers_lock);
 		return -ENOENT;
 	}
@@ -1506,7 +1506,7 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	}
 
 	spin_lock(&g_servers_lock);
-	if (server->status == CifsExiting) {
+	if (server->status == CIFS_STATUS_EXITING) {
 		spin_unlock(&g_servers_lock);
 		return -ENOENT;
 	}
@@ -1564,15 +1564,15 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	/* Wait for a reply - allow signals to interrupt. */
 	rc = wait_event_interruptible(server->response_q,
 		(!(midQ->mid_state == MID_REQUEST_SUBMITTED)) ||
-		((server->status != CifsGood) &&
-		 (server->status != CifsNew)));
+		((server->status != CIFS_STATUS_GOOD) &&
+		 (server->status != CIFS_STATUS_NEW)));
 
 	/* Were we interrupted by a signal ? */
 	spin_lock(&g_servers_lock);
 	if ((rc == -ERESTARTSYS) &&
 		(midQ->mid_state == MID_REQUEST_SUBMITTED) &&
-		((server->status == CifsGood) ||
-		 (server->status == CifsNew))) {
+		((server->status == CIFS_STATUS_GOOD) ||
+		 (server->status == CIFS_STATUS_NEW))) {
 		spin_unlock(&g_servers_lock);
 
 		if (in_buf->Command == SMB_COM_TRANSACTION2) {
-- 
2.35.3

