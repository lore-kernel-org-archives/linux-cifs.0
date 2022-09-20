Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C508C54EE9
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Sep 2022 18:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiITSKw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Sep 2022 14:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiITSKu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Sep 2022 14:10:50 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79272C1B
        for <linux-cifs@vger.kernel.org>; Tue, 20 Sep 2022 11:10:49 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1B1981F385;
        Tue, 20 Sep 2022 18:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663697448; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=O7YGK2R/PU+QKSnwlCSkWPS3bfW2jGf9j8aPVylfTPg=;
        b=WNyrYO4mdPpF8wBnG/2HkGbgOed3PhaHHtBxXb4D4IH/30ivoWgfh7MaGL8z5jc1LHNDR5
        0Hz/u9URmvJ7Q/xacKtz5wsrrMx0avcU2If8iEuGfum+nhZChG9TT7wWu0hFMIsCPSqEkF
        ir1ep70pQvGCD2A91p4doYBKNyx4j9c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663697448;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=O7YGK2R/PU+QKSnwlCSkWPS3bfW2jGf9j8aPVylfTPg=;
        b=8YBdp+uIrHZ7GpN6ZbQVMkXQUxLdT3EM+P0NZXFtA/FlnDje3tMuoFN9zF4xEeXorP4Ywy
        Iv+/IrdoHmoxpzBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 902B01346B;
        Tue, 20 Sep 2022 18:10:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id PxKbFCcCKmOXdQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Tue, 20 Sep 2022 18:10:47 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, kernel test robot <oliver.sang@intel.com>
Subject: [PATCH v3] cifs: replace kfree() with kfree_sensitive() for sensitive data
Date:   Tue, 20 Sep 2022 15:10:35 -0300
Message-Id: <20220920181035.8845-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Replace kfree with kfree_sensitive, or prepend memzero_explicit() in
other cases, when freeing sensitive material that could still be left
in memory.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Reported-by: kernel test robot <oliver.sang@intel.com>
Link: https://lore.kernel.org/r/202209201529.ec633796-oliver.sang@intel.com
---
v3: fix use-after-free reported by kernel test robot (this UAF existed before this patch,
    actually), adjust commit message slightly
v2: remove unnecessary NULL checks before kfree_sensitive()

 fs/cifs/cifsencrypt.c | 12 ++++++------
 fs/cifs/connect.c     |  6 +++---
 fs/cifs/fs_context.c  | 12 ++++++++++--
 fs/cifs/misc.c        |  2 +-
 fs/cifs/sess.c        | 24 +++++++++++++++---------
 fs/cifs/smb2ops.c     |  6 +++---
 fs/cifs/smb2pdu.c     | 19 ++++++++++++++-----
 7 files changed, 52 insertions(+), 29 deletions(-)

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
index 7ae6f2c08153..a43d5686c302 100644
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
@@ -1580,7 +1580,7 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
 
 	cifs_crypto_secmech_release(server);
 
-	kfree(server->session_key.response);
+	kfree_sensitive(server->session_key.response);
 	server->session_key.response = NULL;
 	server->session_key.len = 0;
 	kfree(server->hostname);
@@ -4134,7 +4134,7 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 		if (ses->auth_key.response) {
 			cifs_dbg(FYI, "Free previous auth_key.response = %p\n",
 				 ses->auth_key.response);
-			kfree(ses->auth_key.response);
+			kfree_sensitive(ses->auth_key.response);
 			ses->auth_key.response = NULL;
 			ses->auth_key.len = 0;
 		}
diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 0e13dec86b25..45119597c765 100644
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
@@ -1470,6 +1477,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	return 0;
 
  cifs_parse_mount_err:
+	kfree_sensitive(ctx->password);
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
index 3af3b05b6c74..f1c3c6d9146c 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -1213,6 +1213,12 @@ sess_alloc_buffer(struct sess_data *sess_data, int wct)
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
@@ -1374,7 +1380,7 @@ sess_auth_ntlmv2(struct sess_data *sess_data)
 	sess_data->result = rc;
 	sess_data->func = NULL;
 	sess_free_buffer(sess_data);
-	kfree(ses->auth_key.response);
+	kfree_sensitive(ses->auth_key.response);
 	ses->auth_key.response = NULL;
 }
 
@@ -1513,7 +1519,7 @@ sess_auth_kerberos(struct sess_data *sess_data)
 	sess_data->result = rc;
 	sess_data->func = NULL;
 	sess_free_buffer(sess_data);
-	kfree(ses->auth_key.response);
+	kfree_sensitive(ses->auth_key.response);
 	ses->auth_key.response = NULL;
 }
 
@@ -1648,7 +1654,7 @@ sess_auth_rawntlmssp_negotiate(struct sess_data *sess_data)
 	rc = decode_ntlmssp_challenge(bcc_ptr, blob_len, ses);
 
 out_free_ntlmsspblob:
-	kfree(ntlmsspblob);
+	kfree_sensitive(ntlmsspblob);
 out:
 	sess_free_buffer(sess_data);
 
@@ -1658,9 +1664,9 @@ sess_auth_rawntlmssp_negotiate(struct sess_data *sess_data)
 	}
 
 	/* Else error. Cleanup */
-	kfree(ses->auth_key.response);
+	kfree_sensitive(ses->auth_key.response);
 	ses->auth_key.response = NULL;
-	kfree(ses->ntlmssp);
+	kfree_sensitive(ses->ntlmssp);
 	ses->ntlmssp = NULL;
 
 	sess_data->func = NULL;
@@ -1759,7 +1765,7 @@ sess_auth_rawntlmssp_authenticate(struct sess_data *sess_data)
 	}
 
 out_free_ntlmsspblob:
-	kfree(ntlmsspblob);
+	kfree_sensitive(ntlmsspblob);
 out:
 	sess_free_buffer(sess_data);
 
@@ -1767,9 +1773,9 @@ sess_auth_rawntlmssp_authenticate(struct sess_data *sess_data)
 		rc = sess_establish_session(sess_data);
 
 	/* Cleanup */
-	kfree(ses->auth_key.response);
+	kfree_sensitive(ses->auth_key.response);
 	ses->auth_key.response = NULL;
-	kfree(ses->ntlmssp);
+	kfree_sensitive(ses->ntlmssp);
 	ses->ntlmssp = NULL;
 
 	sess_data->func = NULL;
@@ -1845,7 +1851,7 @@ int CIFS_SessSetup(const unsigned int xid, struct cifs_ses *ses,
 	rc = sess_data->result;
 
 out:
-	kfree(sess_data);
+	kfree_sensitive(sess_data);
 	return rc;
 }
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 421be43af425..5094336cade6 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4410,11 +4410,11 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
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
index 6352ab32c7e7..722ebff05759 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1345,6 +1345,13 @@ SMB2_sess_alloc_buffer(struct SMB2_sess_data *sess_data)
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
@@ -1477,6 +1484,8 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
 out_put_spnego_key:
 	key_invalidate(spnego_key);
 	key_put(spnego_key);
+	if (rc)
+		kfree_sensitive(ses->auth_key.response);
 out:
 	sess_data->result = rc;
 	sess_data->func = NULL;
@@ -1573,7 +1582,7 @@ SMB2_sess_auth_rawntlmssp_negotiate(struct SMB2_sess_data *sess_data)
 	}
 
 out:
-	kfree(ntlmssp_blob);
+	memzero_explicit(ntlmssp_blob, blob_length);
 	SMB2_sess_free_buffer(sess_data);
 	if (!rc) {
 		sess_data->result = 0;
@@ -1581,7 +1590,7 @@ SMB2_sess_auth_rawntlmssp_negotiate(struct SMB2_sess_data *sess_data)
 		return;
 	}
 out_err:
-	kfree(ses->ntlmssp);
+	kfree_sensitive(ses->ntlmssp);
 	ses->ntlmssp = NULL;
 	sess_data->result = rc;
 	sess_data->func = NULL;
@@ -1657,9 +1666,9 @@ SMB2_sess_auth_rawntlmssp_authenticate(struct SMB2_sess_data *sess_data)
 	}
 #endif
 out:
-	kfree(ntlmssp_blob);
+	memzero_explicit(ntlmssp_blob, blob_length);
 	SMB2_sess_free_buffer(sess_data);
-	kfree(ses->ntlmssp);
+	kfree_sensitive(ses->ntlmssp);
 	ses->ntlmssp = NULL;
 	sess_data->result = rc;
 	sess_data->func = NULL;
@@ -1737,7 +1746,7 @@ SMB2_sess_setup(const unsigned int xid, struct cifs_ses *ses,
 		cifs_server_dbg(VFS, "signing requested but authenticated as guest\n");
 	rc = sess_data->result;
 out:
-	kfree(sess_data);
+	kfree_sensitive(sess_data);
 	return rc;
 }
 
-- 
2.35.3

