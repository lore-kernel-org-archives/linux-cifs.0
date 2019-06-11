Return-Path: <SRS0=/HTR=UK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E18BC4321B
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Jun 2019 13:48:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 462B720896
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Jun 2019 13:48:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Jpyybqlu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391217AbfFKNsF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 Jun 2019 09:48:05 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50263 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390327AbfFKNsE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 11 Jun 2019 09:48:04 -0400
Received: by mail-wm1-f65.google.com with SMTP id c66so3054314wmf.0
        for <linux-cifs@vger.kernel.org>; Tue, 11 Jun 2019 06:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2CZ7XNP6ncpKBw0YJudQO1JgyRd0fuR40ry6DWOpcj4=;
        b=Jpyybqlurfd8p8HkRweWx9A0ZRZRilrim08I8+62egJ0xAS8tiahGPiVz7xuNNXCBg
         6nCHBPnqGNKdvljtQN9d1ojCYrj5nfQwrvCnKva3USqRdCqmYd3Komp1ou8KiqViYDQp
         Y47OauyVN8Fzy4YQxyG90+u2pC9mcRjt7BiKS0kTyG9Sk8HZQ/8dbxiGdoKRWVu7HaxD
         tQiw4lsxthogrO0uShmlz2yz68rPA2p/vNfA55oQAH/nTEEte46iJRn3S+Zbj5aU+4Ve
         V+AclEU688L+c2wmvK445FKZBCHYQCq3jMQKNoYDWdskNjbYLPJj+NY61LIH1l1/gZC3
         RMIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2CZ7XNP6ncpKBw0YJudQO1JgyRd0fuR40ry6DWOpcj4=;
        b=C+snfwXPynyboX7X1DEklyBO1VY+A1T06XOmr6l/Xy/uC/6apH+D/xhF1XvtkBltrZ
         AEcH2TbW57PSw0yaePih2kZTWBZyRzpQ/5MY1DNwzQ4nhZr1hJD2QWhFCuCjBxdH/EUq
         XuiXvHvFZu9KC4GJ6NN/O8lELvhckP0s/T+xUZbWFSv0sqh9CumrPs2jB38aMmCVE/zZ
         gjxSDRnGMro977r6Uf4nix/kdqaZqQu9Sqgl/UwfgubTMEHIktojb/HuVBEjLCttm+O3
         6HnRuFSyGvCFsutewD9p2YugpImnIlspxco50OsWk/V8l9Y90R5dLKTmy9qM/IBc7vW4
         c/Mw==
X-Gm-Message-State: APjAAAWgOmIVny8CKdLEVfD+etPm5Tvp/iMUqdvjl/6GHNCRQWCNSnJA
        kL2i7uQ0JnkFzLcVnil/mJ+HFA==
X-Google-Smtp-Source: APXvYqykFvdzrVY18edtq46qoHfHf3p2RGGd1PJ7mo4pHhVHCSHHI4aen/Ca4c6s/pQLyrvXyxHavw==
X-Received: by 2002:a1c:2e09:: with SMTP id u9mr18173175wmu.137.1560260883273;
        Tue, 11 Jun 2019 06:48:03 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:24bb:7f31:25fe:43a7])
        by smtp.gmail.com with ESMTPSA id o126sm3964305wmo.31.2019.06.11.06.48.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 06:48:02 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>
Subject: [PATCH v3 7/7] fs: cifs: switch to RC4 library interface
Date:   Tue, 11 Jun 2019 15:47:50 +0200
Message-Id: <20190611134750.2974-8-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190611134750.2974-1-ard.biesheuvel@linaro.org>
References: <20190611134750.2974-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The CIFS code uses the sync skcipher API to invoke the ecb(arc4) skcipher,
of which only a single generic C code implementation exists. This means
that going through all the trouble of using scatterlists etc buys us
very little, and we're better off just invoking the arc4 library directly.

Cc: linux-cifs@vger.kernel.org
Cc: Steve French <sfrench@samba.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 fs/cifs/Kconfig       |  2 +-
 fs/cifs/cifsencrypt.c | 53 ++++++--------------
 2 files changed, 16 insertions(+), 39 deletions(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index aae2b8b2adf5..523e9ea78a28 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -10,7 +10,7 @@ config CIFS
 	select CRYPTO_SHA512
 	select CRYPTO_CMAC
 	select CRYPTO_HMAC
-	select CRYPTO_ARC4
+	select CRYPTO_LIB_ARC4
 	select CRYPTO_AEAD2
 	select CRYPTO_CCM
 	select CRYPTO_ECB
diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index d2a05e46d6f5..3b7b5e83493d 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -33,7 +33,8 @@
 #include <linux/ctype.h>
 #include <linux/random.h>
 #include <linux/highmem.h>
-#include <crypto/skcipher.h>
+#include <linux/fips.h>
+#include <crypto/arc4.h>
 #include <crypto/aead.h>
 
 int __cifs_calc_signature(struct smb_rqst *rqst,
@@ -772,11 +773,12 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 int
 calc_seckey(struct cifs_ses *ses)
 {
-	int rc;
-	struct crypto_skcipher *tfm_arc4;
-	struct scatterlist sgin, sgout;
-	struct skcipher_request *req;
+	struct arc4_ctx *ctx_arc4;
 	unsigned char *sec_key;
+	int rc = 0;
+
+	if (fips_enabled)
+		return -ENODEV;
 
 	sec_key = kmalloc(CIFS_SESS_KEY_SIZE, GFP_KERNEL);
 	if (sec_key == NULL)
@@ -784,49 +786,24 @@ calc_seckey(struct cifs_ses *ses)
 
 	get_random_bytes(sec_key, CIFS_SESS_KEY_SIZE);
 
-	tfm_arc4 = crypto_alloc_skcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(tfm_arc4)) {
-		rc = PTR_ERR(tfm_arc4);
-		cifs_dbg(VFS, "could not allocate crypto API arc4\n");
-		goto out;
-	}
-
-	rc = crypto_skcipher_setkey(tfm_arc4, ses->auth_key.response,
-					CIFS_SESS_KEY_SIZE);
-	if (rc) {
-		cifs_dbg(VFS, "%s: Could not set response as a key\n",
-			 __func__);
-		goto out_free_cipher;
-	}
-
-	req = skcipher_request_alloc(tfm_arc4, GFP_KERNEL);
-	if (!req) {
+	ctx_arc4 = kmalloc(sizeof(*ctx_arc4), GFP_KERNEL);
+	if (!ctx_arc4) {
 		rc = -ENOMEM;
-		cifs_dbg(VFS, "could not allocate crypto API arc4 request\n");
-		goto out_free_cipher;
+		cifs_dbg(VFS, "could not allocate arc4 context\n");
+		goto out;
 	}
 
-	sg_init_one(&sgin, sec_key, CIFS_SESS_KEY_SIZE);
-	sg_init_one(&sgout, ses->ntlmssp->ciphertext, CIFS_CPHTXT_SIZE);
-
-	skcipher_request_set_callback(req, 0, NULL, NULL);
-	skcipher_request_set_crypt(req, &sgin, &sgout, CIFS_CPHTXT_SIZE, NULL);
-
-	rc = crypto_skcipher_encrypt(req);
-	skcipher_request_free(req);
-	if (rc) {
-		cifs_dbg(VFS, "could not encrypt session key rc: %d\n", rc);
-		goto out_free_cipher;
-	}
+	arc4_setkey(ctx_arc4, ses->auth_key.response, CIFS_SESS_KEY_SIZE);
+	arc4_crypt(ctx_arc4, ses->ntlmssp->ciphertext, sec_key,
+		   CIFS_CPHTXT_SIZE);
 
 	/* make secondary_key/nonce as session key */
 	memcpy(ses->auth_key.response, sec_key, CIFS_SESS_KEY_SIZE);
 	/* and make len as that of session key only */
 	ses->auth_key.len = CIFS_SESS_KEY_SIZE;
 
-out_free_cipher:
-	crypto_free_skcipher(tfm_arc4);
 out:
+	kfree(ctx_arc4);
 	kfree(sec_key);
 	return rc;
 }
-- 
2.20.1

