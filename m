Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78A2FC43334
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Jul 2022 03:04:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiGVDEV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Jul 2022 23:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbiGVDEU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Jul 2022 23:04:20 -0400
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 838A08E6D9
        for <linux-cifs@vger.kernel.org>; Thu, 21 Jul 2022 20:04:18 -0700 (PDT)
Received: by mail-pg1-f180.google.com with SMTP id 23so3320659pgc.8
        for <linux-cifs@vger.kernel.org>; Thu, 21 Jul 2022 20:04:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MmRcNo18VTQORj0t0Ge86Wc3/EEM0ruHDXgweqdSMLY=;
        b=SkKBWx4KOwDg/zRuD6FxoeQCCTASoc4AcCGj9KPzB9i7Xhpz63cffpBGur0NfExIf8
         lHUCUP0dihfRDCp/Tht8vEhzQWcNKBQj+Zd90fhMEFuogWg0Q/2xO76IF8PRft6YMcIJ
         yaUgPeH1SUmi9GiWVh8nvqydipbkPdCOPJVPIZcrpHD+fFcxzd6Fx5bUE0ZNuC/zo6VX
         KOX4RrDWIj3kTJrl6Rw+4/sIYg4JcZ2ASgiQYPvWgIz+a2PbAMyxj2B4Semjpx+iJTJO
         Wi5+5QCy/LxjIpfqvSrvfNipZQxBQN+/24V6aymi3alxkV+aQ7JDEX5Uigb8OPJkEWiC
         sJGg==
X-Gm-Message-State: AJIora9v53rbPvI5u4DHWicWPyv5nYrHv/xoEdFSlLJzOv7PCK1DeJjp
        8LhBpTvNoQXJVHUHPunBys1qz3IQ1fc=
X-Google-Smtp-Source: AGRyM1vHAx4ofYDu9SEdzAr7dOskRbrve21b+qLEWhkaPPd4dhWMsxlFIDuxnnTPE30+zR1TiZDL9Q==
X-Received: by 2002:a63:7e4c:0:b0:412:f7e:9ab6 with SMTP id o12-20020a637e4c000000b004120f7e9ab6mr1270374pgn.494.1658459057284;
        Thu, 21 Jul 2022 20:04:17 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id c10-20020a17090a1d0a00b001f216407204sm2115450pjd.36.2022.07.21.20.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 20:04:16 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, hyc.lee@gmail.com, senozhatsky@chromium.org,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 5/5] ksmbd: fix racy issue while destroying session on multichannel
Date:   Fri, 22 Jul 2022 12:03:46 +0900
Message-Id: <20220722030346.28534-5-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220722030346.28534-1-linkinjeon@kernel.org>
References: <20220722030346.28534-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

After multi-channel connection with windows, Several channels of
session are connected. Among them, if there is a problem in one channel,
Windows connects again after disconnecting the channel. In this process,
the session is released and a kernel oop can occurs while processing
requests to other channels. When the channel is disconnected, if other
channels still exist in the session after deleting the channel from
the channel list in the session, the session should not be released.
Finally, the session will be released after all channels are disconnected.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/auth.c              | 56 ++++++++++++++++-------------
 fs/ksmbd/auth.h              | 11 +++---
 fs/ksmbd/connection.h        |  7 ----
 fs/ksmbd/mgmt/tree_connect.c |  5 +--
 fs/ksmbd/mgmt/tree_connect.h |  4 ++-
 fs/ksmbd/mgmt/user_session.c | 68 ++++++++++++++++++++++++------------
 fs/ksmbd/mgmt/user_session.h |  7 ++--
 fs/ksmbd/oplock.c            | 11 +++---
 fs/ksmbd/smb2pdu.c           | 21 +++++------
 fs/ksmbd/smb_common.h        |  2 +-
 fs/ksmbd/vfs.c               |  3 +-
 fs/ksmbd/vfs_cache.c         |  2 +-
 12 files changed, 111 insertions(+), 86 deletions(-)

diff --git a/fs/ksmbd/auth.c b/fs/ksmbd/auth.c
index 911444d21267..c5a5c7b90d72 100644
--- a/fs/ksmbd/auth.c
+++ b/fs/ksmbd/auth.c
@@ -121,8 +121,8 @@ static int ksmbd_gen_sess_key(struct ksmbd_session *sess, char *hash,
 	return rc;
 }
 
-static int calc_ntlmv2_hash(struct ksmbd_session *sess, char *ntlmv2_hash,
-			    char *dname)
+static int calc_ntlmv2_hash(struct ksmbd_conn *conn, struct ksmbd_session *sess,
+			    char *ntlmv2_hash, char *dname)
 {
 	int ret, len, conv_len;
 	wchar_t *domain = NULL;
@@ -158,7 +158,7 @@ static int calc_ntlmv2_hash(struct ksmbd_session *sess, char *ntlmv2_hash,
 	}
 
 	conv_len = smb_strtoUTF16(uniname, user_name(sess->user), len,
-				  sess->conn->local_nls);
+				  conn->local_nls);
 	if (conv_len < 0 || conv_len > len) {
 		ret = -EINVAL;
 		goto out;
@@ -182,7 +182,7 @@ static int calc_ntlmv2_hash(struct ksmbd_session *sess, char *ntlmv2_hash,
 	}
 
 	conv_len = smb_strtoUTF16((__le16 *)domain, dname, len,
-				  sess->conn->local_nls);
+				  conn->local_nls);
 	if (conv_len < 0 || conv_len > len) {
 		ret = -EINVAL;
 		goto out;
@@ -215,8 +215,9 @@ static int calc_ntlmv2_hash(struct ksmbd_session *sess, char *ntlmv2_hash,
  *
  * Return:	0 on success, error number on error
  */
-int ksmbd_auth_ntlmv2(struct ksmbd_session *sess, struct ntlmv2_resp *ntlmv2,
-		      int blen, char *domain_name, char *cryptkey)
+int ksmbd_auth_ntlmv2(struct ksmbd_conn *conn, struct ksmbd_session *sess,
+		      struct ntlmv2_resp *ntlmv2, int blen, char *domain_name,
+		      char *cryptkey)
 {
 	char ntlmv2_hash[CIFS_ENCPWD_SIZE];
 	char ntlmv2_rsp[CIFS_HMAC_MD5_HASH_SIZE];
@@ -230,7 +231,7 @@ int ksmbd_auth_ntlmv2(struct ksmbd_session *sess, struct ntlmv2_resp *ntlmv2,
 		return -ENOMEM;
 	}
 
-	rc = calc_ntlmv2_hash(sess, ntlmv2_hash, domain_name);
+	rc = calc_ntlmv2_hash(conn, sess, ntlmv2_hash, domain_name);
 	if (rc) {
 		ksmbd_debug(AUTH, "could not get v2 hash rc %d\n", rc);
 		goto out;
@@ -333,7 +334,8 @@ int ksmbd_decode_ntlmssp_auth_blob(struct authenticate_message *authblob,
 	/* process NTLMv2 authentication */
 	ksmbd_debug(AUTH, "decode_ntlmssp_authenticate_blob dname%s\n",
 		    domain_name);
-	ret = ksmbd_auth_ntlmv2(sess, (struct ntlmv2_resp *)((char *)authblob + nt_off),
+	ret = ksmbd_auth_ntlmv2(conn, sess,
+				(struct ntlmv2_resp *)((char *)authblob + nt_off),
 				nt_len - CIFS_ENCPWD_SIZE,
 				domain_name, conn->ntlmssp.cryptkey);
 	kfree(domain_name);
@@ -659,8 +661,9 @@ struct derivation {
 	bool binding;
 };
 
-static int generate_key(struct ksmbd_session *sess, struct kvec label,
-			struct kvec context, __u8 *key, unsigned int key_size)
+static int generate_key(struct ksmbd_conn *conn, struct ksmbd_session *sess,
+			struct kvec label, struct kvec context, __u8 *key,
+			unsigned int key_size)
 {
 	unsigned char zero = 0x0;
 	__u8 i[4] = {0, 0, 0, 1};
@@ -720,8 +723,8 @@ static int generate_key(struct ksmbd_session *sess, struct kvec label,
 		goto smb3signkey_ret;
 	}
 
-	if (sess->conn->cipher_type == SMB2_ENCRYPTION_AES256_CCM ||
-	    sess->conn->cipher_type == SMB2_ENCRYPTION_AES256_GCM)
+	if (conn->cipher_type == SMB2_ENCRYPTION_AES256_CCM ||
+	    conn->cipher_type == SMB2_ENCRYPTION_AES256_GCM)
 		rc = crypto_shash_update(CRYPTO_HMACSHA256(ctx), L256, 4);
 	else
 		rc = crypto_shash_update(CRYPTO_HMACSHA256(ctx), L128, 4);
@@ -756,17 +759,17 @@ static int generate_smb3signingkey(struct ksmbd_session *sess,
 	if (!chann)
 		return 0;
 
-	if (sess->conn->dialect >= SMB30_PROT_ID && signing->binding)
+	if (conn->dialect >= SMB30_PROT_ID && signing->binding)
 		key = chann->smb3signingkey;
 	else
 		key = sess->smb3signingkey;
 
-	rc = generate_key(sess, signing->label, signing->context, key,
+	rc = generate_key(conn, sess, signing->label, signing->context, key,
 			  SMB3_SIGN_KEY_SIZE);
 	if (rc)
 		return rc;
 
-	if (!(sess->conn->dialect >= SMB30_PROT_ID && signing->binding))
+	if (!(conn->dialect >= SMB30_PROT_ID && signing->binding))
 		memcpy(chann->smb3signingkey, key, SMB3_SIGN_KEY_SIZE);
 
 	ksmbd_debug(AUTH, "dumping generated AES signing keys\n");
@@ -820,30 +823,31 @@ struct derivation_twin {
 	struct derivation decryption;
 };
 
-static int generate_smb3encryptionkey(struct ksmbd_session *sess,
+static int generate_smb3encryptionkey(struct ksmbd_conn *conn,
+				      struct ksmbd_session *sess,
 				      const struct derivation_twin *ptwin)
 {
 	int rc;
 
-	rc = generate_key(sess, ptwin->encryption.label,
+	rc = generate_key(conn, sess, ptwin->encryption.label,
 			  ptwin->encryption.context, sess->smb3encryptionkey,
 			  SMB3_ENC_DEC_KEY_SIZE);
 	if (rc)
 		return rc;
 
-	rc = generate_key(sess, ptwin->decryption.label,
+	rc = generate_key(conn, sess, ptwin->decryption.label,
 			  ptwin->decryption.context,
 			  sess->smb3decryptionkey, SMB3_ENC_DEC_KEY_SIZE);
 	if (rc)
 		return rc;
 
 	ksmbd_debug(AUTH, "dumping generated AES encryption keys\n");
-	ksmbd_debug(AUTH, "Cipher type   %d\n", sess->conn->cipher_type);
+	ksmbd_debug(AUTH, "Cipher type   %d\n", conn->cipher_type);
 	ksmbd_debug(AUTH, "Session Id    %llu\n", sess->id);
 	ksmbd_debug(AUTH, "Session Key   %*ph\n",
 		    SMB2_NTLMV2_SESSKEY_SIZE, sess->sess_key);
-	if (sess->conn->cipher_type == SMB2_ENCRYPTION_AES256_CCM ||
-	    sess->conn->cipher_type == SMB2_ENCRYPTION_AES256_GCM) {
+	if (conn->cipher_type == SMB2_ENCRYPTION_AES256_CCM ||
+	    conn->cipher_type == SMB2_ENCRYPTION_AES256_GCM) {
 		ksmbd_debug(AUTH, "ServerIn Key  %*ph\n",
 			    SMB3_GCM256_CRYPTKEY_SIZE, sess->smb3encryptionkey);
 		ksmbd_debug(AUTH, "ServerOut Key %*ph\n",
@@ -857,7 +861,8 @@ static int generate_smb3encryptionkey(struct ksmbd_session *sess,
 	return 0;
 }
 
-int ksmbd_gen_smb30_encryptionkey(struct ksmbd_session *sess)
+int ksmbd_gen_smb30_encryptionkey(struct ksmbd_conn *conn,
+				  struct ksmbd_session *sess)
 {
 	struct derivation_twin twin;
 	struct derivation *d;
@@ -874,10 +879,11 @@ int ksmbd_gen_smb30_encryptionkey(struct ksmbd_session *sess)
 	d->context.iov_base = "ServerIn ";
 	d->context.iov_len = 10;
 
-	return generate_smb3encryptionkey(sess, &twin);
+	return generate_smb3encryptionkey(conn, sess, &twin);
 }
 
-int ksmbd_gen_smb311_encryptionkey(struct ksmbd_session *sess)
+int ksmbd_gen_smb311_encryptionkey(struct ksmbd_conn *conn,
+				   struct ksmbd_session *sess)
 {
 	struct derivation_twin twin;
 	struct derivation *d;
@@ -894,7 +900,7 @@ int ksmbd_gen_smb311_encryptionkey(struct ksmbd_session *sess)
 	d->context.iov_base = sess->Preauth_HashValue;
 	d->context.iov_len = 64;
 
-	return generate_smb3encryptionkey(sess, &twin);
+	return generate_smb3encryptionkey(conn, sess, &twin);
 }
 
 int ksmbd_gen_preauth_integrity_hash(struct ksmbd_conn *conn, char *buf,
diff --git a/fs/ksmbd/auth.h b/fs/ksmbd/auth.h
index 95629651cf26..25b772653de0 100644
--- a/fs/ksmbd/auth.h
+++ b/fs/ksmbd/auth.h
@@ -38,8 +38,9 @@ struct kvec;
 int ksmbd_crypt_message(struct ksmbd_conn *conn, struct kvec *iov,
 			unsigned int nvec, int enc);
 void ksmbd_copy_gss_neg_header(void *buf);
-int ksmbd_auth_ntlmv2(struct ksmbd_session *sess, struct ntlmv2_resp *ntlmv2,
-		      int blen, char *domain_name, char *cryptkey);
+int ksmbd_auth_ntlmv2(struct ksmbd_conn *conn, struct ksmbd_session *sess,
+		      struct ntlmv2_resp *ntlmv2, int blen, char *domain_name,
+		      char *cryptkey);
 int ksmbd_decode_ntlmssp_auth_blob(struct authenticate_message *authblob,
 				   int blob_len, struct ksmbd_conn *conn,
 				   struct ksmbd_session *sess);
@@ -58,8 +59,10 @@ int ksmbd_gen_smb30_signingkey(struct ksmbd_session *sess,
 			       struct ksmbd_conn *conn);
 int ksmbd_gen_smb311_signingkey(struct ksmbd_session *sess,
 				struct ksmbd_conn *conn);
-int ksmbd_gen_smb30_encryptionkey(struct ksmbd_session *sess);
-int ksmbd_gen_smb311_encryptionkey(struct ksmbd_session *sess);
+int ksmbd_gen_smb30_encryptionkey(struct ksmbd_conn *conn,
+				  struct ksmbd_session *sess);
+int ksmbd_gen_smb311_encryptionkey(struct ksmbd_conn *conn,
+				   struct ksmbd_session *sess);
 int ksmbd_gen_preauth_integrity_hash(struct ksmbd_conn *conn, char *buf,
 				     __u8 *pi_hash);
 int ksmbd_gen_sd_hash(struct ksmbd_conn *conn, char *sd_buf, int len,
diff --git a/fs/ksmbd/connection.h b/fs/ksmbd/connection.h
index 2e4730457c92..e7f7d5707951 100644
--- a/fs/ksmbd/connection.h
+++ b/fs/ksmbd/connection.h
@@ -20,13 +20,6 @@
 
 #define KSMBD_SOCKET_BACKLOG		16
 
-/*
- * WARNING
- *
- * This is nothing but a HACK. Session status should move to channel
- * or to session. As of now we have 1 tcp_conn : 1 ksmbd_session, but
- * we need to change it to 1 tcp_conn : N ksmbd_sessions.
- */
 enum {
 	KSMBD_SESS_NEW = 0,
 	KSMBD_SESS_GOOD,
diff --git a/fs/ksmbd/mgmt/tree_connect.c b/fs/ksmbd/mgmt/tree_connect.c
index 0d28e723a28c..b35ea6a6abc5 100644
--- a/fs/ksmbd/mgmt/tree_connect.c
+++ b/fs/ksmbd/mgmt/tree_connect.c
@@ -16,7 +16,8 @@
 #include "user_session.h"
 
 struct ksmbd_tree_conn_status
-ksmbd_tree_conn_connect(struct ksmbd_session *sess, char *share_name)
+ksmbd_tree_conn_connect(struct ksmbd_conn *conn, struct ksmbd_session *sess,
+			char *share_name)
 {
 	struct ksmbd_tree_conn_status status = {-EINVAL, NULL};
 	struct ksmbd_tree_connect_response *resp = NULL;
@@ -41,7 +42,7 @@ ksmbd_tree_conn_connect(struct ksmbd_session *sess, char *share_name)
 		goto out_error;
 	}
 
-	peer_addr = KSMBD_TCP_PEER_SOCKADDR(sess->conn);
+	peer_addr = KSMBD_TCP_PEER_SOCKADDR(conn);
 	resp = ksmbd_ipc_tree_connect_request(sess,
 					      sc,
 					      tree_conn,
diff --git a/fs/ksmbd/mgmt/tree_connect.h b/fs/ksmbd/mgmt/tree_connect.h
index 18e2a996e0aa..71e50271dccf 100644
--- a/fs/ksmbd/mgmt/tree_connect.h
+++ b/fs/ksmbd/mgmt/tree_connect.h
@@ -12,6 +12,7 @@
 
 struct ksmbd_share_config;
 struct ksmbd_user;
+struct ksmbd_conn;
 
 struct ksmbd_tree_connect {
 	int				id;
@@ -40,7 +41,8 @@ static inline int test_tree_conn_flag(struct ksmbd_tree_connect *tree_conn,
 struct ksmbd_session;
 
 struct ksmbd_tree_conn_status
-ksmbd_tree_conn_connect(struct ksmbd_session *sess, char *share_name);
+ksmbd_tree_conn_connect(struct ksmbd_conn *conn, struct ksmbd_session *sess,
+			char *share_name);
 
 int ksmbd_tree_conn_disconnect(struct ksmbd_session *sess,
 			       struct ksmbd_tree_connect *tree_conn);
diff --git a/fs/ksmbd/mgmt/user_session.c b/fs/ksmbd/mgmt/user_session.c
index b9acb6770b03..ce32fdd66807 100644
--- a/fs/ksmbd/mgmt/user_session.c
+++ b/fs/ksmbd/mgmt/user_session.c
@@ -151,9 +151,6 @@ void ksmbd_session_destroy(struct ksmbd_session *sess)
 	if (!sess)
 		return;
 
-	if (!atomic_dec_and_test(&sess->refcnt))
-		return;
-
 	down_write(&sessions_table_lock);
 	hash_del(&sess->hlist);
 	up_write(&sessions_table_lock);
@@ -184,16 +181,59 @@ static struct ksmbd_session *__session_lookup(unsigned long long id)
 int ksmbd_session_register(struct ksmbd_conn *conn,
 			   struct ksmbd_session *sess)
 {
-	sess->conn = conn;
+	sess->dialect = conn->dialect;
+	memcpy(sess->ClientGUID, conn->ClientGUID, SMB2_CLIENT_GUID_SIZE);
 	return xa_err(xa_store(&conn->sessions, sess->id, sess, GFP_KERNEL));
 }
 
+static int ksmbd_chann_del(struct ksmbd_conn *conn, struct ksmbd_session *sess)
+{
+	struct channel *chann, *tmp;
+
+	write_lock(&sess->chann_lock);
+	list_for_each_entry_safe(chann, tmp, &sess->ksmbd_chann_list,
+				 chann_list) {
+		if (chann->conn == conn) {
+			list_del(&chann->chann_list);
+			kfree(chann);
+			write_unlock(&sess->chann_lock);
+			return 0;
+		}
+	}
+	write_unlock(&sess->chann_lock);
+
+	return -ENOENT;
+}
+
 void ksmbd_sessions_deregister(struct ksmbd_conn *conn)
 {
 	struct ksmbd_session *sess;
-	unsigned long id;
 
-	xa_for_each(&conn->sessions, id, sess) {
+	if (conn->binding) {
+		struct hlist_node *tmp;
+		int bkt;
+
+		down_write(&sessions_table_lock);
+		hash_for_each_safe(sessions_table, bkt, tmp, sess, hlist) {
+			if (!ksmbd_chann_del(conn, sess)) {
+				up_write(&sessions_table_lock);
+				goto sess_destroy;
+			}
+		}
+		up_write(&sessions_table_lock);
+	} else {
+		unsigned long id;
+
+		xa_for_each(&conn->sessions, id, sess) {
+			if (!ksmbd_chann_del(conn, sess))
+				goto sess_destroy;
+		}
+	}
+
+	return;
+
+sess_destroy:
+	if (list_empty(&sess->ksmbd_chann_list)) {
 		xa_erase(&conn->sessions, sess->id);
 		ksmbd_session_destroy(sess);
 	}
@@ -205,27 +245,12 @@ struct ksmbd_session *ksmbd_session_lookup(struct ksmbd_conn *conn,
 	return xa_load(&conn->sessions, id);
 }
 
-int get_session(struct ksmbd_session *sess)
-{
-	return atomic_inc_not_zero(&sess->refcnt);
-}
-
-void put_session(struct ksmbd_session *sess)
-{
-	if (atomic_dec_and_test(&sess->refcnt))
-		pr_err("get/%s seems to be mismatched.", __func__);
-}
-
 struct ksmbd_session *ksmbd_session_lookup_slowpath(unsigned long long id)
 {
 	struct ksmbd_session *sess;
 
 	down_read(&sessions_table_lock);
 	sess = __session_lookup(id);
-	if (sess) {
-		if (!get_session(sess))
-			sess = NULL;
-	}
 	up_read(&sessions_table_lock);
 
 	return sess;
@@ -306,7 +331,6 @@ static struct ksmbd_session *__session_create(int protocol)
 	INIT_LIST_HEAD(&sess->ksmbd_chann_list);
 	INIT_LIST_HEAD(&sess->rpc_handle_list);
 	sess->sequence_number = 1;
-	atomic_set(&sess->refcnt, 1);
 	rwlock_init(&sess->chann_lock);
 
 	switch (protocol) {
diff --git a/fs/ksmbd/mgmt/user_session.h b/fs/ksmbd/mgmt/user_session.h
index 1ec659f0151b..8934b8ee275b 100644
--- a/fs/ksmbd/mgmt/user_session.h
+++ b/fs/ksmbd/mgmt/user_session.h
@@ -33,8 +33,10 @@ struct preauth_session {
 struct ksmbd_session {
 	u64				id;
 
+	__u16				dialect;
+	char				ClientGUID[SMB2_CLIENT_GUID_SIZE];
+
 	struct ksmbd_user		*user;
-	struct ksmbd_conn		*conn;
 	unsigned int			sequence_number;
 	unsigned int			flags;
 
@@ -59,7 +61,6 @@ struct ksmbd_session {
 	__u8				smb3signingkey[SMB3_SIGN_KEY_SIZE];
 
 	struct ksmbd_file_table		file_table;
-	atomic_t			refcnt;
 };
 
 static inline int test_session_flag(struct ksmbd_session *sess, int bit)
@@ -100,6 +101,4 @@ void ksmbd_release_tree_conn_id(struct ksmbd_session *sess, int id);
 int ksmbd_session_rpc_open(struct ksmbd_session *sess, char *rpc_name);
 void ksmbd_session_rpc_close(struct ksmbd_session *sess, int id);
 int ksmbd_session_rpc_method(struct ksmbd_session *sess, int id);
-int get_session(struct ksmbd_session *sess);
-void put_session(struct ksmbd_session *sess);
 #endif /* __USER_SESSION_MANAGEMENT_H__ */
diff --git a/fs/ksmbd/oplock.c b/fs/ksmbd/oplock.c
index 9bb4fb8b80de..ce4c15c3554d 100644
--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -30,6 +30,7 @@ static DEFINE_RWLOCK(lease_list_lock);
 static struct oplock_info *alloc_opinfo(struct ksmbd_work *work,
 					u64 id, __u16 Tid)
 {
+	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_session *sess = work->sess;
 	struct oplock_info *opinfo;
 
@@ -38,7 +39,7 @@ static struct oplock_info *alloc_opinfo(struct ksmbd_work *work,
 		return NULL;
 
 	opinfo->sess = sess;
-	opinfo->conn = sess->conn;
+	opinfo->conn = conn;
 	opinfo->level = SMB2_OPLOCK_LEVEL_NONE;
 	opinfo->op_state = OPLOCK_STATE_NONE;
 	opinfo->pending_break = 0;
@@ -971,7 +972,7 @@ int find_same_lease_key(struct ksmbd_session *sess, struct ksmbd_inode *ci,
 	}
 
 	list_for_each_entry(lb, &lease_table_list, l_entry) {
-		if (!memcmp(lb->client_guid, sess->conn->ClientGUID,
+		if (!memcmp(lb->client_guid, sess->ClientGUID,
 			    SMB2_CLIENT_GUID_SIZE))
 			goto found;
 	}
@@ -987,7 +988,7 @@ int find_same_lease_key(struct ksmbd_session *sess, struct ksmbd_inode *ci,
 		rcu_read_unlock();
 		if (opinfo->o_fp->f_ci == ci)
 			goto op_next;
-		err = compare_guid_key(opinfo, sess->conn->ClientGUID,
+		err = compare_guid_key(opinfo, sess->ClientGUID,
 				       lctx->lease_key);
 		if (err) {
 			err = -EINVAL;
@@ -1121,7 +1122,7 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 		struct oplock_info *m_opinfo;
 
 		/* is lease already granted ? */
-		m_opinfo = same_client_has_lease(ci, sess->conn->ClientGUID,
+		m_opinfo = same_client_has_lease(ci, sess->ClientGUID,
 						 lctx);
 		if (m_opinfo) {
 			copy_lease(m_opinfo, opinfo);
@@ -1239,7 +1240,7 @@ void smb_break_all_levII_oplock(struct ksmbd_work *work, struct ksmbd_file *fp,
 {
 	struct oplock_info *op, *brk_op;
 	struct ksmbd_inode *ci;
-	struct ksmbd_conn *conn = work->sess->conn;
+	struct ksmbd_conn *conn = work->conn;
 
 	if (!test_share_config_flag(work->tcon->share_conf,
 				    KSMBD_SHARE_FLAG_OPLOCKS))
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index ae5677a66cb2..1f4f2d5217a6 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -603,12 +603,9 @@ static void destroy_previous_session(struct ksmbd_conn *conn,
 	if (!prev_user ||
 	    strcmp(user->name, prev_user->name) ||
 	    user->passkey_sz != prev_user->passkey_sz ||
-	    memcmp(user->passkey, prev_user->passkey, user->passkey_sz)) {
-		put_session(prev_sess);
+	    memcmp(user->passkey, prev_user->passkey, user->passkey_sz))
 		return;
-	}
 
-	put_session(prev_sess);
 	prev_sess->state = SMB2_SESSION_EXPIRED;
 	write_lock(&prev_sess->chann_lock);
 	list_for_each_entry(chann, &prev_sess->ksmbd_chann_list, chann_list)
@@ -1499,7 +1496,7 @@ static int ntlm_authenticate(struct ksmbd_work *work)
 
 	if (smb3_encryption_negotiated(conn) &&
 			!(req->Flags & SMB2_SESSION_REQ_FLAG_BINDING)) {
-		rc = conn->ops->generate_encryptionkey(sess);
+		rc = conn->ops->generate_encryptionkey(conn, sess);
 		if (rc) {
 			ksmbd_debug(SMB,
 					"SMB3 encryption key generation failed\n");
@@ -1590,7 +1587,7 @@ static int krb5_authenticate(struct ksmbd_work *work)
 		sess->sign = true;
 
 	if (smb3_encryption_negotiated(conn)) {
-		retval = conn->ops->generate_encryptionkey(sess);
+		retval = conn->ops->generate_encryptionkey(conn, sess);
 		if (retval) {
 			ksmbd_debug(SMB,
 				    "SMB3 encryption key generation failed\n");
@@ -1678,7 +1675,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 			goto out_err;
 		}
 
-		if (conn->dialect != sess->conn->dialect) {
+		if (conn->dialect != sess->dialect) {
 			rc = -EINVAL;
 			goto out_err;
 		}
@@ -1688,7 +1685,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 			goto out_err;
 		}
 
-		if (strncmp(conn->ClientGUID, sess->conn->ClientGUID,
+		if (strncmp(conn->ClientGUID, sess->ClientGUID,
 			    SMB2_CLIENT_GUID_SIZE)) {
 			rc = -ENOENT;
 			goto out_err;
@@ -1890,7 +1887,7 @@ int smb2_tree_connect(struct ksmbd_work *work)
 	ksmbd_debug(SMB, "tree connect request for tree %s treename %s\n",
 		    name, treename);
 
-	status = ksmbd_tree_conn_connect(sess, name);
+	status = ksmbd_tree_conn_connect(conn, sess, name);
 	if (status.ret == KSMBD_TREE_CONN_STATUS_OK)
 		rsp->hdr.Id.SyncId.TreeId = cpu_to_le32(status.tree_conn->id);
 	else
@@ -4875,7 +4872,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
 				    struct smb2_query_info_rsp *rsp)
 {
 	struct ksmbd_session *sess = work->sess;
-	struct ksmbd_conn *conn = sess->conn;
+	struct ksmbd_conn *conn = work->conn;
 	struct ksmbd_share_config *share = work->tcon->share_conf;
 	int fsinfoclass = 0;
 	struct kstatfs stfs;
@@ -5793,7 +5790,7 @@ static int set_rename_info(struct ksmbd_work *work, struct ksmbd_file *fp,
 	}
 next:
 	return smb2_rename(work, fp, user_ns, rename_info,
-			   work->sess->conn->local_nls);
+			   work->conn->local_nls);
 }
 
 static int set_file_disposition_info(struct ksmbd_file *fp,
@@ -5925,7 +5922,7 @@ static int smb2_set_info_file(struct ksmbd_work *work, struct ksmbd_file *fp,
 		return smb2_create_link(work, work->tcon->share_conf,
 					(struct smb2_file_link_info *)req->Buffer,
 					buf_len, fp->filp,
-					work->sess->conn->local_nls);
+					work->conn->local_nls);
 	}
 	case FILE_DISPOSITION_INFORMATION:
 	{
diff --git a/fs/ksmbd/smb_common.h b/fs/ksmbd/smb_common.h
index e1369b4345a9..318c16fa81da 100644
--- a/fs/ksmbd/smb_common.h
+++ b/fs/ksmbd/smb_common.h
@@ -421,7 +421,7 @@ struct smb_version_ops {
 	int (*check_sign_req)(struct ksmbd_work *work);
 	void (*set_sign_rsp)(struct ksmbd_work *work);
 	int (*generate_signingkey)(struct ksmbd_session *sess, struct ksmbd_conn *conn);
-	int (*generate_encryptionkey)(struct ksmbd_session *sess);
+	int (*generate_encryptionkey)(struct ksmbd_conn *conn, struct ksmbd_session *sess);
 	bool (*is_transform_hdr)(void *buf);
 	int (*decrypt_req)(struct ksmbd_work *work);
 	int (*encrypt_resp)(struct ksmbd_work *work);
diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
index 5d185564aef6..4f75b1436eab 100644
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -481,12 +481,11 @@ int ksmbd_vfs_write(struct ksmbd_work *work, struct ksmbd_file *fp,
 		    char *buf, size_t count, loff_t *pos, bool sync,
 		    ssize_t *written)
 {
-	struct ksmbd_session *sess = work->sess;
 	struct file *filp;
 	loff_t	offset = *pos;
 	int err = 0;
 
-	if (sess->conn->connection_type) {
+	if (work->conn->connection_type) {
 		if (!(fp->daccess & FILE_WRITE_DATA_LE)) {
 			pr_err("no right to write(%pd)\n",
 			       fp->filp->f_path.dentry);
diff --git a/fs/ksmbd/vfs_cache.c b/fs/ksmbd/vfs_cache.c
index c4d59d2735f0..da9163b00350 100644
--- a/fs/ksmbd/vfs_cache.c
+++ b/fs/ksmbd/vfs_cache.c
@@ -569,7 +569,7 @@ struct ksmbd_file *ksmbd_open_fd(struct ksmbd_work *work, struct file *filp)
 	atomic_set(&fp->refcount, 1);
 
 	fp->filp		= filp;
-	fp->conn		= work->sess->conn;
+	fp->conn		= work->conn;
 	fp->tcon		= work->tcon;
 	fp->volatile_id		= KSMBD_NO_FID;
 	fp->persistent_id	= KSMBD_NO_FID;
-- 
2.25.1

