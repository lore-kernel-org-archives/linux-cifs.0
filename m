Return-Path: <SRS0=1kIp=UI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D2F3C468BE
	for <linux-cifs@archiver.kernel.org>; Sun,  9 Jun 2019 11:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1551820673
	for <linux-cifs@archiver.kernel.org>; Sun,  9 Jun 2019 11:55:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OLPdHgSz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728492AbfFILzZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 9 Jun 2019 07:55:25 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33737 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728488AbfFILzX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 9 Jun 2019 07:55:23 -0400
Received: by mail-wr1-f68.google.com with SMTP id n9so6412426wru.0
        for <linux-cifs@vger.kernel.org>; Sun, 09 Jun 2019 04:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FtvYOYxztxbWsU9/lKjUQ/gy5B0HYQB6YbiXWNKXOpM=;
        b=OLPdHgSzFB1MTVBS8K5hN47PvE3j+y5cIZLb7UZa7CDVK/icDJolMMoWsbaqWXQv90
         x1Uyb3jdC/qOgYOZQ4n3JzM6V4z8GVqcsfslB8g9iYALbttFmCPU2yRlCiE4arLI81o7
         Rr3soYdiw5TX3oCMUthupMc3zsVq9Ad57qRFRZQQxZIGiqVAM2IhLjLFrh9wRIKBjuew
         rvDgmxUQ56Im6FRBJaaiRkGTHQ9C8rt/xhVuevjCHhB5MzDPnGsovMws+nUtovpB1qkO
         V5pvXQgOVA2g4BWXViD89dSuaqk781I1QwjuBTxSU8vCS/LSbirAgatG5S38vvcf1Ock
         wYlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FtvYOYxztxbWsU9/lKjUQ/gy5B0HYQB6YbiXWNKXOpM=;
        b=ac2NOz9DVtTtpIlHHGPxpPPG5H9c03QihcvN71++i3Ad/rAvk8KRiD69Yoax23TaUm
         oos4qj3HwdVVAV0LGfgF74YaEciYby37v2tZfp/Gl4M1ZMFAUmS7GWGMpVUxNdeaNKGV
         N6yFUFPWToZL+kaJBuFGQ0gVFJXOVQ9P5IQQ8toyplMcQwb4EKgTzHLroT+Bpy/6vLAg
         Wm2PRBIGHdmVFswNjJHtiqgosYZCbfxGlpHcsDICa+eyrd3uTEGHIRc57vM9EAjjR2vy
         LLnjkMmguehSt8KNEAECAjYpPih0t7BXkVVZ/3D8LVjEKI/Zpz8IagfUcNI40B5r04B2
         iwmg==
X-Gm-Message-State: APjAAAUrScvmvBJKY2O/A5YDFbvY6hnCjz5OuOkRaP6JP0eKjgENzBDJ
        v9lmBIpKBrpFBiUjCDX4CcL/LQ==
X-Google-Smtp-Source: APXvYqxR1SuLRGdvvcOW64SwAvu34cyQ9oV2pSjirjwOLYDt3nQxxcAHR+7t7VDu1SnT8gANF4WaPw==
X-Received: by 2002:adf:ee48:: with SMTP id w8mr18631727wro.308.1560081321031;
        Sun, 09 Jun 2019 04:55:21 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:5129:23cd:5870:89d4])
        by smtp.gmail.com with ESMTPSA id r5sm14954317wrg.10.2019.06.09.04.55.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jun 2019 04:55:20 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>, linux-cifs@vger.kernel.org,
        Steve French <sfrench@samba.org>
Subject: [PATCH v2 7/7] fs: cifs: switch to RC4 library interface
Date:   Sun,  9 Jun 2019 13:55:09 +0200
Message-Id: <20190609115509.26260-8-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190609115509.26260-1-ard.biesheuvel@linaro.org>
References: <20190609115509.26260-1-ard.biesheuvel@linaro.org>
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
 fs/cifs/cifsencrypt.c | 50 +++++---------------
 2 files changed, 13 insertions(+), 39 deletions(-)

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
index d2a05e46d6f5..d0ab5a38e5d2 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -33,7 +33,7 @@
 #include <linux/ctype.h>
 #include <linux/random.h>
 #include <linux/highmem.h>
-#include <crypto/skcipher.h>
+#include <crypto/arc4.h>
 #include <crypto/aead.h>
 
 int __cifs_calc_signature(struct smb_rqst *rqst,
@@ -772,11 +772,9 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 int
 calc_seckey(struct cifs_ses *ses)
 {
-	int rc;
-	struct crypto_skcipher *tfm_arc4;
-	struct scatterlist sgin, sgout;
-	struct skcipher_request *req;
+	struct crypto_arc4_ctx *ctx_arc4;
 	unsigned char *sec_key;
+	int rc = 0;
 
 	sec_key = kmalloc(CIFS_SESS_KEY_SIZE, GFP_KERNEL);
 	if (sec_key == NULL)
@@ -784,49 +782,25 @@ calc_seckey(struct cifs_ses *ses)
 
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
+	crypto_arc4_set_key(ctx_arc4, ses->auth_key.response,
+			    CIFS_SESS_KEY_SIZE);
+	crypto_arc4_crypt(ctx_arc4, ses->ntlmssp->ciphertext, sec_key,
+			  CIFS_CPHTXT_SIZE);
 
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

