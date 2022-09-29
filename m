Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B472C54EE9
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 01:57:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbiI2B5E (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Sep 2022 21:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbiI2B5E (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Sep 2022 21:57:04 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53964122077
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 18:57:03 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C7BE21F890;
        Thu, 29 Sep 2022 01:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1664416621; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vhzj/xJxfT9CH4vDB8il3YZESl9ubkDvRLIplT2p/PE=;
        b=q9CW7cl+2/aRLWjzsLgTTOq3HWQkLMjnXVwBBBanMHAMCWY/tT9Ptkn20Z2shzRKqgpgiL
        KfBQSj5dVSA9flnBDHV2zMGzN4qzX5dZSKnKLPTEZ8Xhce9UK4XG9FIf4HiiuJ+NMbOd7Y
        n7kyYQxSiRaWommcq1EKiiT45ETGMcg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1664416621;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vhzj/xJxfT9CH4vDB8il3YZESl9ubkDvRLIplT2p/PE=;
        b=CZR3TzQV5+tbHjeknSbK5NBn2lnKl0S+f1tPt0m4dciFQh6++0EmC6cu2JbaeFxkIzyCVV
        /XXjIwrshbC88/Dw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 48D56139B3;
        Thu, 29 Sep 2022 01:57:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id hCAyA237NGN5eQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 29 Sep 2022 01:57:01 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, tom@talpey.com, metze@samba.org
Subject: [PATCH v3 1/8] smb3: rename encryption/decryption TFMs
Date:   Wed, 28 Sep 2022 22:56:30 -0300
Message-Id: <20220929015637.14400-2-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220929015637.14400-1-ematsumiya@suse.de>
References: <20220929015637.14400-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Detach the TFM name from a specific algorithm (AES-CCM) as
AES-GCM is also supported, making the name misleading.

s/ccmaesencrypt/enc/
s/ccmaesdecrypt/dec/

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/cifsencrypt.c   | 12 ++++++------
 fs/cifs/cifsglob.h      |  4 ++--
 fs/cifs/smb2ops.c       |  3 +--
 fs/cifs/smb2transport.c | 12 ++++++------
 4 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 46f5718754f9..f622d2ba6bd0 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -743,14 +743,14 @@ cifs_crypto_secmech_release(struct TCP_Server_Info *server)
 		server->secmech.hmacmd5 = NULL;
 	}
 
-	if (server->secmech.ccmaesencrypt) {
-		crypto_free_aead(server->secmech.ccmaesencrypt);
-		server->secmech.ccmaesencrypt = NULL;
+	if (server->secmech.enc) {
+		crypto_free_aead(server->secmech.enc);
+		server->secmech.enc = NULL;
 	}
 
-	if (server->secmech.ccmaesdecrypt) {
-		crypto_free_aead(server->secmech.ccmaesdecrypt);
-		server->secmech.ccmaesdecrypt = NULL;
+	if (server->secmech.dec) {
+		crypto_free_aead(server->secmech.dec);
+		server->secmech.dec = NULL;
 	}
 
 	kfree(server->secmech.sdesccmacaes);
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index ae7f571a7dba..cbb108b15412 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -171,8 +171,8 @@ struct cifs_secmech {
 	struct sdesc *sdeschmacsha256;  /* ctxt to generate smb2 signature */
 	struct sdesc *sdesccmacaes;  /* ctxt to generate smb3 signature */
 	struct sdesc *sdescsha512; /* ctxt to generate smb3.11 signing key */
-	struct crypto_aead *ccmaesencrypt; /* smb3 encryption aead */
-	struct crypto_aead *ccmaesdecrypt; /* smb3 decryption aead */
+	struct crypto_aead *enc; /* smb3 AEAD encryption TFM (AES-CCM and AES-GCM) */
+	struct crypto_aead *dec; /* smb3 AEAD decryption TFM (AES-CCM and AES-GCM) */
 };
 
 /* per smb session structure/fields */
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 421be43af425..d1528755f330 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4344,8 +4344,7 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 		return rc;
 	}
 
-	tfm = enc ? server->secmech.ccmaesencrypt :
-						server->secmech.ccmaesdecrypt;
+	tfm = enc ? server->secmech.enc : server->secmech.dec;
 
 	if ((server->cipher_type == SMB2_ENCRYPTION_AES256_CCM) ||
 		(server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
index 4640fc4a8b13..d4e1a5d74dcd 100644
--- a/fs/cifs/smb2transport.c
+++ b/fs/cifs/smb2transport.c
@@ -904,7 +904,7 @@ smb3_crypto_aead_allocate(struct TCP_Server_Info *server)
 {
 	struct crypto_aead *tfm;
 
-	if (!server->secmech.ccmaesencrypt) {
+	if (!server->secmech.enc) {
 		if ((server->cipher_type == SMB2_ENCRYPTION_AES128_GCM) ||
 		    (server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
 			tfm = crypto_alloc_aead("gcm(aes)", 0, 0);
@@ -915,23 +915,23 @@ smb3_crypto_aead_allocate(struct TCP_Server_Info *server)
 				 __func__);
 			return PTR_ERR(tfm);
 		}
-		server->secmech.ccmaesencrypt = tfm;
+		server->secmech.enc = tfm;
 	}
 
-	if (!server->secmech.ccmaesdecrypt) {
+	if (!server->secmech.dec) {
 		if ((server->cipher_type == SMB2_ENCRYPTION_AES128_GCM) ||
 		    (server->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
 			tfm = crypto_alloc_aead("gcm(aes)", 0, 0);
 		else
 			tfm = crypto_alloc_aead("ccm(aes)", 0, 0);
 		if (IS_ERR(tfm)) {
-			crypto_free_aead(server->secmech.ccmaesencrypt);
-			server->secmech.ccmaesencrypt = NULL;
+			crypto_free_aead(server->secmech.enc);
+			server->secmech.enc = NULL;
 			cifs_server_dbg(VFS, "%s: Failed to alloc decrypt aead\n",
 				 __func__);
 			return PTR_ERR(tfm);
 		}
-		server->secmech.ccmaesdecrypt = tfm;
+		server->secmech.dec = tfm;
 	}
 
 	return 0;
-- 
2.35.3

