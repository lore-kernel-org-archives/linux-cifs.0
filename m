Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14867C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Dec 2021 06:02:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235844AbhLOGCj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Dec 2021 01:02:39 -0500
Received: from mail-pj1-f45.google.com ([209.85.216.45]:39599 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233735AbhLOGCj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Dec 2021 01:02:39 -0500
Received: by mail-pj1-f45.google.com with SMTP id y14-20020a17090a2b4e00b001a5824f4918so19364792pjc.4
        for <linux-cifs@vger.kernel.org>; Tue, 14 Dec 2021 22:02:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4CHS0RNaFgU8K28Mtl/TeaPJMBElZEmMG1mrv7m9n8s=;
        b=wf1zxeViy9dB1+YR+Y0PVy2x9fQ4fuoiXYTQtP9Lw+jeoFzP+mYAobIaq3jf9bpMRt
         JWcNiAs9zSPSLURcG2Q8QcQwfBTLAHgT1FkFod3UO+AcuqvO3IRypcIqJF0QoX30PDgw
         E3FV2VvRelxddidLLPODj5niFX2lDSRaAvVkQCCTpcZWJi4eCRaTnjUlDOy0P4zFhKCr
         W5bzzFQ/+flhMKJUzPQqz+MFg+264cmXwX3zOlePFcHXex4E0DJWNg8oukR2YQUJS1n/
         lzSGwJIOQGEiL/fR7glEvPMKzgSQEclmqn9aDDMFQdvSwwRrqf9RgguBp6UD2QlrxCBD
         PfGQ==
X-Gm-Message-State: AOAM530gj5CYRoxb35rNOo7Yf6Fc26TdSmVx9Gs/yQwqH9G5cT6OM3iF
        RJ0ZBkEqjUHxTSV760SlvAr3TIElsyI=
X-Google-Smtp-Source: ABdhPJzaSy6tudQjEkyL9JKOZH6A0G0AE26+/QEPzM3ZBKFY4EgLDsDtfGXNhsyPxDJ/EU3vTynk3g==
X-Received: by 2002:a17:902:f68e:b0:148:a2e8:278c with SMTP id l14-20020a170902f68e00b00148a2e8278cmr2989409plg.147.1639548158639;
        Tue, 14 Dec 2021 22:02:38 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id oc10sm4575249pjb.26.2021.12.14.22.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 22:02:38 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Ziwei Xie <zw.xie@high-flyer.cn>
Subject: [PATCH 3/3] ksmbd: fix multi session connection failure
Date:   Wed, 15 Dec 2021 15:02:06 +0900
Message-Id: <20211215060206.8048-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211215060206.8048-1-linkinjeon@kernel.org>
References: <20211215060206.8048-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When RSS mode is enable, windows client do simultaneously send several
session requests to server. There is racy issue using
sess->ntlmssp.cryptkey on N connection : 1 session. So authetication
failed using wrong cryptkey on some session. This patch move cryptkey
to ksmbd_conn structure to use each cryptkey on connection.

Tested-by: Ziwei Xie <zw.xie@high-flyer.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/auth.c              | 27 ++++++++++++++-------------
 fs/ksmbd/auth.h              | 10 +++++-----
 fs/ksmbd/connection.h        |  7 +------
 fs/ksmbd/mgmt/user_session.h |  1 -
 fs/ksmbd/smb2pdu.c           |  8 ++++----
 5 files changed, 24 insertions(+), 29 deletions(-)

diff --git a/fs/ksmbd/auth.c b/fs/ksmbd/auth.c
index 3503b1c48cb4..dc3d061edda9 100644
--- a/fs/ksmbd/auth.c
+++ b/fs/ksmbd/auth.c
@@ -215,7 +215,7 @@ static int calc_ntlmv2_hash(struct ksmbd_session *sess, char *ntlmv2_hash,
  * Return:	0 on success, error number on error
  */
 int ksmbd_auth_ntlmv2(struct ksmbd_session *sess, struct ntlmv2_resp *ntlmv2,
-		      int blen, char *domain_name)
+		      int blen, char *domain_name, char *cryptkey)
 {
 	char ntlmv2_hash[CIFS_ENCPWD_SIZE];
 	char ntlmv2_rsp[CIFS_HMAC_MD5_HASH_SIZE];
@@ -256,7 +256,7 @@ int ksmbd_auth_ntlmv2(struct ksmbd_session *sess, struct ntlmv2_resp *ntlmv2,
 		goto out;
 	}
 
-	memcpy(construct, sess->ntlmssp.cryptkey, CIFS_CRYPTO_KEY_SIZE);
+	memcpy(construct, cryptkey, CIFS_CRYPTO_KEY_SIZE);
 	memcpy(construct + CIFS_CRYPTO_KEY_SIZE, &ntlmv2->blob_signature, blen);
 
 	rc = crypto_shash_update(CRYPTO_HMACMD5(ctx), construct, len);
@@ -295,7 +295,8 @@ int ksmbd_auth_ntlmv2(struct ksmbd_session *sess, struct ntlmv2_resp *ntlmv2,
  * Return:	0 on success, error number on error
  */
 int ksmbd_decode_ntlmssp_auth_blob(struct authenticate_message *authblob,
-				   int blob_len, struct ksmbd_session *sess)
+				   int blob_len, struct ksmbd_conn *conn,
+				   struct ksmbd_session *sess)
 {
 	char *domain_name;
 	unsigned int nt_off, dn_off;
@@ -324,7 +325,7 @@ int ksmbd_decode_ntlmssp_auth_blob(struct authenticate_message *authblob,
 
 	/* TODO : use domain name that imported from configuration file */
 	domain_name = smb_strndup_from_utf16((const char *)authblob + dn_off,
-					     dn_len, true, sess->conn->local_nls);
+					     dn_len, true, conn->local_nls);
 	if (IS_ERR(domain_name))
 		return PTR_ERR(domain_name);
 
@@ -333,7 +334,7 @@ int ksmbd_decode_ntlmssp_auth_blob(struct authenticate_message *authblob,
 		    domain_name);
 	ret = ksmbd_auth_ntlmv2(sess, (struct ntlmv2_resp *)((char *)authblob + nt_off),
 				nt_len - CIFS_ENCPWD_SIZE,
-				domain_name);
+				domain_name, conn->ntlmssp.cryptkey);
 	kfree(domain_name);
 	return ret;
 }
@@ -347,7 +348,7 @@ int ksmbd_decode_ntlmssp_auth_blob(struct authenticate_message *authblob,
  *
  */
 int ksmbd_decode_ntlmssp_neg_blob(struct negotiate_message *negblob,
-				  int blob_len, struct ksmbd_session *sess)
+				  int blob_len, struct ksmbd_conn *conn)
 {
 	if (blob_len < sizeof(struct negotiate_message)) {
 		ksmbd_debug(AUTH, "negotiate blob len %d too small\n",
@@ -361,7 +362,7 @@ int ksmbd_decode_ntlmssp_neg_blob(struct negotiate_message *negblob,
 		return -EINVAL;
 	}
 
-	sess->ntlmssp.client_flags = le32_to_cpu(negblob->NegotiateFlags);
+	conn->ntlmssp.client_flags = le32_to_cpu(negblob->NegotiateFlags);
 	return 0;
 }
 
@@ -375,14 +376,14 @@ int ksmbd_decode_ntlmssp_neg_blob(struct negotiate_message *negblob,
  */
 unsigned int
 ksmbd_build_ntlmssp_challenge_blob(struct challenge_message *chgblob,
-				   struct ksmbd_session *sess)
+				   struct ksmbd_conn *conn)
 {
 	struct target_info *tinfo;
 	wchar_t *name;
 	__u8 *target_name;
 	unsigned int flags, blob_off, blob_len, type, target_info_len = 0;
 	int len, uni_len, conv_len;
-	int cflags = sess->ntlmssp.client_flags;
+	int cflags = conn->ntlmssp.client_flags;
 
 	memcpy(chgblob->Signature, NTLMSSP_SIGNATURE, 8);
 	chgblob->MessageType = NtLmChallenge;
@@ -403,7 +404,7 @@ ksmbd_build_ntlmssp_challenge_blob(struct challenge_message *chgblob,
 	if (cflags & NTLMSSP_REQUEST_TARGET)
 		flags |= NTLMSSP_REQUEST_TARGET;
 
-	if (sess->conn->use_spnego &&
+	if (conn->use_spnego &&
 	    (cflags & NTLMSSP_NEGOTIATE_EXTENDED_SEC))
 		flags |= NTLMSSP_NEGOTIATE_EXTENDED_SEC;
 
@@ -414,7 +415,7 @@ ksmbd_build_ntlmssp_challenge_blob(struct challenge_message *chgblob,
 		return -ENOMEM;
 
 	conv_len = smb_strtoUTF16((__le16 *)name, ksmbd_netbios_name(), len,
-				  sess->conn->local_nls);
+				  conn->local_nls);
 	if (conv_len < 0 || conv_len > len) {
 		kfree(name);
 		return -EINVAL;
@@ -430,8 +431,8 @@ ksmbd_build_ntlmssp_challenge_blob(struct challenge_message *chgblob,
 	chgblob->TargetName.BufferOffset = cpu_to_le32(blob_off);
 
 	/* Initialize random conn challenge */
-	get_random_bytes(sess->ntlmssp.cryptkey, sizeof(__u64));
-	memcpy(chgblob->Challenge, sess->ntlmssp.cryptkey,
+	get_random_bytes(conn->ntlmssp.cryptkey, sizeof(__u64));
+	memcpy(chgblob->Challenge, conn->ntlmssp.cryptkey,
 	       CIFS_CRYPTO_KEY_SIZE);
 
 	/* Add Target Information to security buffer */
diff --git a/fs/ksmbd/auth.h b/fs/ksmbd/auth.h
index 9c2d4badd05d..95629651cf26 100644
--- a/fs/ksmbd/auth.h
+++ b/fs/ksmbd/auth.h
@@ -38,16 +38,16 @@ struct kvec;
 int ksmbd_crypt_message(struct ksmbd_conn *conn, struct kvec *iov,
 			unsigned int nvec, int enc);
 void ksmbd_copy_gss_neg_header(void *buf);
-int ksmbd_auth_ntlm(struct ksmbd_session *sess, char *pw_buf);
 int ksmbd_auth_ntlmv2(struct ksmbd_session *sess, struct ntlmv2_resp *ntlmv2,
-		      int blen, char *domain_name);
+		      int blen, char *domain_name, char *cryptkey);
 int ksmbd_decode_ntlmssp_auth_blob(struct authenticate_message *authblob,
-				   int blob_len, struct ksmbd_session *sess);
+				   int blob_len, struct ksmbd_conn *conn,
+				   struct ksmbd_session *sess);
 int ksmbd_decode_ntlmssp_neg_blob(struct negotiate_message *negblob,
-				  int blob_len, struct ksmbd_session *sess);
+				  int blob_len, struct ksmbd_conn *conn);
 unsigned int
 ksmbd_build_ntlmssp_challenge_blob(struct challenge_message *chgblob,
-				   struct ksmbd_session *sess);
+				   struct ksmbd_conn *conn);
 int ksmbd_krb5_authenticate(struct ksmbd_session *sess, char *in_blob,
 			    int in_len,	char *out_blob, int *out_len);
 int ksmbd_sign_smb2_pdu(struct ksmbd_conn *conn, char *key, struct kvec *iov,
diff --git a/fs/ksmbd/connection.h b/fs/ksmbd/connection.h
index e5403c587a58..72dfd155b5bf 100644
--- a/fs/ksmbd/connection.h
+++ b/fs/ksmbd/connection.h
@@ -72,12 +72,7 @@ struct ksmbd_conn {
 	int				connection_type;
 	struct ksmbd_stats		stats;
 	char				ClientGUID[SMB2_CLIENT_GUID_SIZE];
-	union {
-		/* pending trans request table */
-		struct trans_state	*recent_trans;
-		/* Used by ntlmssp */
-		char			*ntlmssp_cryptkey;
-	};
+	struct ntlmssp_auth		ntlmssp;
 
 	spinlock_t			llist_lock;
 	struct list_head		lock_list;
diff --git a/fs/ksmbd/mgmt/user_session.h b/fs/ksmbd/mgmt/user_session.h
index 82289c3cbd2b..e241f16a3851 100644
--- a/fs/ksmbd/mgmt/user_session.h
+++ b/fs/ksmbd/mgmt/user_session.h
@@ -45,7 +45,6 @@ struct ksmbd_session {
 	int				state;
 	__u8				*Preauth_HashValue;
 
-	struct ntlmssp_auth		ntlmssp;
 	char				sess_key[CIFS_KEY_SIZE];
 
 	struct hlist_node		hlist;
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 4f938f038a65..68e5773b5b19 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1282,7 +1282,7 @@ static int ntlm_negotiate(struct ksmbd_work *work,
 	int sz, rc;
 
 	ksmbd_debug(SMB, "negotiate phase\n");
-	rc = ksmbd_decode_ntlmssp_neg_blob(negblob, negblob_len, work->sess);
+	rc = ksmbd_decode_ntlmssp_neg_blob(negblob, negblob_len, work->conn);
 	if (rc)
 		return rc;
 
@@ -1292,7 +1292,7 @@ static int ntlm_negotiate(struct ksmbd_work *work,
 	memset(chgblob, 0, sizeof(struct challenge_message));
 
 	if (!work->conn->use_spnego) {
-		sz = ksmbd_build_ntlmssp_challenge_blob(chgblob, work->sess);
+		sz = ksmbd_build_ntlmssp_challenge_blob(chgblob, work->conn);
 		if (sz < 0)
 			return -ENOMEM;
 
@@ -1308,7 +1308,7 @@ static int ntlm_negotiate(struct ksmbd_work *work,
 		return -ENOMEM;
 
 	chgblob = (struct challenge_message *)neg_blob;
-	sz = ksmbd_build_ntlmssp_challenge_blob(chgblob, work->sess);
+	sz = ksmbd_build_ntlmssp_challenge_blob(chgblob, work->conn);
 	if (sz < 0) {
 		rc = -ENOMEM;
 		goto out;
@@ -1450,7 +1450,7 @@ static int ntlm_authenticate(struct ksmbd_work *work)
 
 		authblob = user_authblob(conn, req);
 		sz = le16_to_cpu(req->SecurityBufferLength);
-		rc = ksmbd_decode_ntlmssp_auth_blob(authblob, sz, sess);
+		rc = ksmbd_decode_ntlmssp_auth_blob(authblob, sz, conn, sess);
 		if (rc) {
 			set_user_flag(sess->user, KSMBD_USER_FLAG_BAD_PASSWORD);
 			ksmbd_debug(SMB, "authentication failed\n");
-- 
2.25.1

