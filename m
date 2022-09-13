Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28AE4C54EE9
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Sep 2022 19:48:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiIMTs0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Sep 2022 15:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiIMTsY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Sep 2022 15:48:24 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861B467470
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 12:48:23 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2BA4C34E60;
        Tue, 13 Sep 2022 19:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663098502; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=u+cfWXz7m3hdetKIGOSOPGvdfQzac3Fv83mQjEeY3bs=;
        b=PbPjzalFdoQfQfB8+tXrC0Nrorhl9lgDPMZzglHdLqLyrp2nSCTgWndQ2n32WaU97Y0CI+
        s402hStWLOx5Q0gWfm2IxmtFsNu/DXRPczzue64xsumypD3WiyG57rnKbtvwjrnMSiASvX
        /yuoVdbJBHQlOZlCHzEk5jImEoocwMs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663098502;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=u+cfWXz7m3hdetKIGOSOPGvdfQzac3Fv83mQjEeY3bs=;
        b=XkR7c/siHC2n2/cQHR0/yr2gx+IDGilVCrEy0vrPmEQGxJV1EBmbjHQaULcJ8bWJeTJrIQ
        fd7N87MLmh+Ha2Ag==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A5514139B3;
        Tue, 13 Sep 2022 19:48:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mzyMGoXeIGPmKgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Tue, 13 Sep 2022 19:48:21 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [PATCH] cifs: replace kfree() with kfree_sensitive() for sensitive data
Date:   Tue, 13 Sep 2022 16:48:11 -0300
Message-Id: <20220913194811.10045-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This patch is mosltly a s/kfree/kfree_sensitive/ for sensitive material
that could still be left in memory.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifsencrypt.c | 12 ++++++------
 fs/cifs/connect.c     |  6 +++---
 fs/cifs/fs_context.c  | 13 +++++++++++--
 fs/cifs/misc.c        |  2 +-
 fs/cifs/sess.c        | 24 +++++++++++++++---------
 fs/cifs/smb2ops.c     |  6 +++---
 fs/cifs/smb2pdu.c     | 22 +++++++++++++++++-----
 7 files changed, 56 insertions(+), 29 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 46f5718754f9..d848bc0aac27 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -679,7 +679,7 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 unlock:
 	cifs_server_unlock(ses->server);
 setup_ntlmv2_rsp_ret:
-	kfree(tiblob);
+	kfree_sensitive(tiblob);
 
 	return rc;
 }
@@ -753,14 +753,14 @@ cifs_crypto_secmech_release(struct TCP_Server_Info *server)
 		server->secmech.ccmaesdecrypt = NULL;
 	}
 
-	kfree(server->secmech.sdesccmacaes);
+	kfree_sensitive(server->secmech.sdesccmacaes);
 	server->secmech.sdesccmacaes = NULL;
-	kfree(server->secmech.sdeschmacsha256);
+	kfree_sensitive(server->secmech.sdeschmacsha256);
 	server->secmech.sdeschmacsha256 = NULL;
-	kfree(server->secmech.sdeschmacmd5);
+	kfree_sensitive(server->secmech.sdeschmacmd5);
 	server->secmech.sdeschmacmd5 = NULL;
-	kfree(server->secmech.sdescmd5);
+	kfree_sensitive(server->secmech.sdescmd5);
 	server->secmech.sdescmd5 = NULL;
-	kfree(server->secmech.sdescsha512);
+	kfree_sensitive(server->secmech.sdescsha512);
 	server->secmech.sdescsha512 = NULL;
 }
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 389127e21563..46da90dd2d15 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -311,7 +311,7 @@ cifs_abort_connection(struct TCP_Server_Info *server)
 	}
 	server->sequence_number = 0;
 	server->session_estab = false;
-	kfree(server->session_key.response);
+	kfree_sensitive(server->session_key.response);
 	server->session_key.response = NULL;
 	server->session_key.len = 0;
 	server->lstrp = jiffies;
@@ -1585,7 +1585,7 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 
 	cifs_crypto_secmech_release(server);
 
-	kfree(server->session_key.response);
+	kfree_sensitive(server->session_key.response);
 	server->session_key.response = NULL;
 	server->session_key.len = 0;
 	kfree(server->hostname);
@@ -4143,7 +4143,7 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 		if (ses->auth_key.response) {
 			cifs_dbg(FYI, "Free previous auth_key.response = %p\n",
 				 ses->auth_key.response);
-			kfree(ses->auth_key.response);
+			kfree_sensitive(ses->auth_key.response);
 			ses->auth_key.response = NULL;
 			ses->auth_key.len = 0;
 		}
diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 0e13dec86b25..95133b4078f2 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -791,6 +791,13 @@ do {									\
 	cifs_sb->ctx->field = NULL;					\
 } while (0)
 
+#define STEAL_STRING_SENSITIVE(cifs_sb, ctx, field)			\
+do {									\
+	kfree_sensitive(ctx->field);					\
+	ctx->field = cifs_sb->ctx->field;				\
+	cifs_sb->ctx->field = NULL;					\
+} while (0)
+
 static int smb3_reconfigure(struct fs_context *fc)
 {
 	struct smb3_fs_context *ctx = smb3_fc2context(fc);
@@ -811,7 +818,7 @@ static int smb3_reconfigure(struct fs_context *fc)
 	STEAL_STRING(cifs_sb, ctx, UNC);
 	STEAL_STRING(cifs_sb, ctx, source);
 	STEAL_STRING(cifs_sb, ctx, username);
-	STEAL_STRING(cifs_sb, ctx, password);
+	STEAL_STRING_SENSITIVE(cifs_sb, ctx, password);
 	STEAL_STRING(cifs_sb, ctx, domainname);
 	STEAL_STRING(cifs_sb, ctx, nodename);
 	STEAL_STRING(cifs_sb, ctx, iocharset);
@@ -1162,7 +1169,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 		}
 		break;
 	case Opt_pass:
-		kfree(ctx->password);
+		kfree_sensitive(ctx->password);
 		ctx->password = NULL;
 		if (strlen(param->string) == 0)
 			break;
@@ -1470,6 +1477,8 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	return 0;
 
  cifs_parse_mount_err:
+	if (ctx->password)
+		kfree_sensitive(ctx->password);
 	return -EINVAL;
 }
 
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 87f60f736731..85109a9a2146 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1119,7 +1119,7 @@ cifs_alloc_hash(const char *name,
 void
 cifs_free_hash(struct crypto_shash **shash, struct sdesc **sdesc)
 {
-	kfree(*sdesc);
+	kfree_sensitive(*sdesc);
 	*sdesc = NULL;
 	if (*shash)
 		crypto_free_shash(*shash);
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 951874928d70..c9edec7081de 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -1208,6 +1208,12 @@ sess_alloc_buffer(struct sess_data *sess_data, int wct)
 static void
 sess_free_buffer(struct sess_data *sess_data)
 {
+	int i;
+
+	/* zero the session data before freeing, as it might contain sensitive info (keys, etc) */
+	for (i = 0; i < 3; i++)
+		if (sess_data->iov[i].iov_base)
+			memzero_explicit(sess_data->iov[i].iov_base, sess_data->iov[i].iov_len);
 
 	free_rsp_buf(sess_data->buf0_type, sess_data->iov[0].iov_base);
 	sess_data->buf0_type = CIFS_NO_BUFFER;
@@ -1369,7 +1375,7 @@ sess_auth_ntlmv2(struct sess_data *sess_data)
 	sess_data->result = rc;
 	sess_data->func = NULL;
 	sess_free_buffer(sess_data);
-	kfree(ses->auth_key.response);
+	kfree_sensitive(ses->auth_key.response);
 	ses->auth_key.response = NULL;
 }
 
@@ -1507,7 +1513,7 @@ sess_auth_kerberos(struct sess_data *sess_data)
 	sess_data->result = rc;
 	sess_data->func = NULL;
 	sess_free_buffer(sess_data);
-	kfree(ses->auth_key.response);
+	kfree_sensitive(ses->auth_key.response);
 	ses->auth_key.response = NULL;
 }
 
@@ -1642,7 +1648,7 @@ sess_auth_rawntlmssp_negotiate(struct sess_data *sess_data)
 	rc = decode_ntlmssp_challenge(bcc_ptr, blob_len, ses);
 
 out_free_ntlmsspblob:
-	kfree(ntlmsspblob);
+	kfree_sensitive(ntlmsspblob);
 out:
 	sess_free_buffer(sess_data);
 
@@ -1652,9 +1658,9 @@ sess_auth_rawntlmssp_negotiate(struct sess_data *sess_data)
 	}
 
 	/* Else error. Cleanup */
-	kfree(ses->auth_key.response);
+	kfree_sensitive(ses->auth_key.response);
 	ses->auth_key.response = NULL;
-	kfree(ses->ntlmssp);
+	kfree_sensitive(ses->ntlmssp);
 	ses->ntlmssp = NULL;
 
 	sess_data->func = NULL;
@@ -1753,7 +1759,7 @@ sess_auth_rawntlmssp_authenticate(struct sess_data *sess_data)
 	}
 
 out_free_ntlmsspblob:
-	kfree(ntlmsspblob);
+	kfree_sensitive(ntlmsspblob);
 out:
 	sess_free_buffer(sess_data);
 
@@ -1761,9 +1767,9 @@ sess_auth_rawntlmssp_authenticate(struct sess_data *sess_data)
 		rc = sess_establish_session(sess_data);
 
 	/* Cleanup */
-	kfree(ses->auth_key.response);
+	kfree_sensitive(ses->auth_key.response);
 	ses->auth_key.response = NULL;
-	kfree(ses->ntlmssp);
+	kfree_sensitive(ses->ntlmssp);
 	ses->ntlmssp = NULL;
 
 	sess_data->func = NULL;
@@ -1839,7 +1845,7 @@ int CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
 	rc = sess_data->result;
 
 out:
-	kfree(sess_data);
+	kfree_sensitive(sess_data);
 	return rc;
 }
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index d6dd839ca1bb..0b89259c72ac 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4416,11 +4416,11 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 	if (!rc && enc)
 		memcpy(&tr_hdr->Signature, sign, SMB2_SIGNATURE_SIZE);
 
-	kfree(iv);
+	kfree_sensitive(iv);
 free_sg:
-	kfree(sg);
+	kfree_sensitive(sg);
 free_req:
-	kfree(req);
+	kfree_sensitive(req);
 	return rc;
 }
 
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index ae0d07812954..5bae752fe9a8 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1341,6 +1341,13 @@ SMB2_sess_alloc_buffer(struct SMB2_sess_data *sess_data)
 static void
 SMB2_sess_free_buffer(struct SMB2_sess_data *sess_data)
 {
+	int i;
+
+	/* zero the session data before freeing, as it might contain sensitive info (keys, etc) */
+	for (i = 0; i < 2; i++)
+		if (sess_data->iov[i].iov_base)
+			memzero_explicit(sess_data->iov[i].iov_base, sess_data->iov[i].iov_len);
+
 	free_rsp_buf(sess_data->buf0_type, sess_data->iov[0].iov_base);
 	sess_data->buf0_type = CIFS_NO_BUFFER;
 }
@@ -1413,6 +1420,9 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
 	struct smb2_sess_setup_rsp *rsp = NULL;
 	bool is_binding = false;
 
+	/* initialize it to NULL so we can check/free it on exit */
+	ses->auth_key.response = NULL;
+
 	rc = SMB2_sess_alloc_buffer(sess_data);
 	if (rc)
 		goto out;
@@ -1473,6 +1483,8 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
 out_put_spnego_key:
 	key_invalidate(spnego_key);
 	key_put(spnego_key);
+	if (rc && ses->auth_key.response)
+		kfree_sensitive(ses->auth_key.response);
 out:
 	sess_data->result = rc;
 	sess_data->func = NULL;
@@ -1569,7 +1581,7 @@ SMB2_sess_auth_rawntlmssp_negotiate(struct SMB2_sess_data *sess_data)
 	}
 
 out:
-	kfree(ntlmssp_blob);
+	kfree_sensitive(ntlmssp_blob);
 	SMB2_sess_free_buffer(sess_data);
 	if (!rc) {
 		sess_data->result = 0;
@@ -1577,7 +1589,7 @@ SMB2_sess_auth_rawntlmssp_negotiate(struct SMB2_sess_data *sess_data)
 		return;
 	}
 out_err:
-	kfree(ses->ntlmssp);
+	kfree_sensitive(ses->ntlmssp);
 	ses->ntlmssp = NULL;
 	sess_data->result = rc;
 	sess_data->func = NULL;
@@ -1653,9 +1665,9 @@ SMB2_sess_auth_rawntlmssp_authenticate(struct SMB2_sess_data *sess_data)
 	}
 #endif
 out:
-	kfree(ntlmssp_blob);
+	kfree_sensitive(ntlmssp_blob);
 	SMB2_sess_free_buffer(sess_data);
-	kfree(ses->ntlmssp);
+	kfree_sensitive(ses->ntlmssp);
 	ses->ntlmssp = NULL;
 	sess_data->result = rc;
 	sess_data->func = NULL;
@@ -1733,7 +1745,7 @@ SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
 		cifs_server_dbg(VFS, "signing requested but authenticated as guest\n");
 	rc = sess_data->result;
 out:
-	kfree(sess_data);
+	kfree_sensitive(sess_data);
 	return rc;
 }
 
-- 
2.35.3

