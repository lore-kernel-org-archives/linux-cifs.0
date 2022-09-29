Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7055C433FE
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 20:37:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiI2UhD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Sep 2022 16:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiI2UhC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Sep 2022 16:37:02 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1B11323E5
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 13:37:01 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7054221B74;
        Thu, 29 Sep 2022 20:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1664483820; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vhzj/xJxfT9CH4vDB8il3YZESl9ubkDvRLIplT2p/PE=;
        b=B/ONZLhC487KvZkXeiE/PSUwi8Vpbvh172w2jBoE+JkNlb29mTF56hSuYFnH8oLx/zU1Gd
        HRZPDrkWOmcDSuYXOGn5/P64KJyUx+Pb6YvgDyGKzBVePSw9Jjs3KeSRNo/oWnMSgfAt54
        tDnd6nMqnW/kFqG7kvAtSTySYMLSWSA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1664483820;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vhzj/xJxfT9CH4vDB8il3YZESl9ubkDvRLIplT2p/PE=;
        b=qCKzc2gKtCipdp35XWV7zOtTx6ZHJcPU9xfMHW/5d4bXHiAKz0i7QuK4HkVigBqYBdQetg
        V8z50g0j8NvnvPCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E210B1348E;
        Thu, 29 Sep 2022 20:36:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 3jlTKOsBNmPnTAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 29 Sep 2022 20:36:59 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, tom@talpey.com, metze@samba.org
Subject: [PATCH v4 1/8] smb3: rename encryption/decryption TFMs
Date:   Thu, 29 Sep 2022 17:36:49 -0300
Message-Id: <20220929203652.13178-2-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220929203652.13178-1-ematsumiya@suse.de>
References: <20220929203652.13178-1-ematsumiya@suse.de>
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

