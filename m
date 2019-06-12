Return-Path: <SRS0=Mq7t=UL=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFADBC31E48
	for <linux-cifs@archiver.kernel.org>; Wed, 12 Jun 2019 16:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97E322082C
	for <linux-cifs@archiver.kernel.org>; Wed, 12 Jun 2019 16:20:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="s5cC4TI0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404608AbfFLQUQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 12 Jun 2019 12:20:16 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33353 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730745AbfFLQUQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 12 Jun 2019 12:20:16 -0400
Received: by mail-wr1-f68.google.com with SMTP id n9so17630490wru.0
        for <linux-cifs@vger.kernel.org>; Wed, 12 Jun 2019 09:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pcVl9rz8wdPQIbvWbTWkIx9A5zksK1bSEdXxVyTfU04=;
        b=s5cC4TI0lnWPK+GDgtrqTDlet2i0OPiORYXE+/Ic638xklkCAjsb0spBQVUHFdfzWj
         unvV4+WlGu6/AcBM6M1We7Yok27ESfVZnoYBYkfSrreFoVn8wWC+I4ZDQP2tXRMBO0U+
         qy/drraE5GCMBp9DiNE9ST9DBfh5h2QVwRcLu2UIMzFcI70qqiywL7jR/jNd0aDF2DNQ
         su/xTA9KGcirsoaFVrbDj3XhmQnIrSImK8LIBLH26S7E2XQwa0RldV9q1FhIWEuOrHBT
         +07mqQnQ+m0NpPloOXJeNxhBzXJAHrTlTJRbkH8VHUthdxMJUXi2AXgxyFBTzkfKfqpR
         z47Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pcVl9rz8wdPQIbvWbTWkIx9A5zksK1bSEdXxVyTfU04=;
        b=dHhL4LV2nD4X+tO5jaqjDvWEaQIWdcaVPcjaYNeWKOCiqjEHKhHm7d5rGqrm7mi/Cu
         ARvflQW1fMKf2w6d8wzM/2WYC04deKouumpgzFYf01Nazuno5Qjv44G4XnIy/t/j+nB9
         ue/UQFmw+fkciprnjTLpAHnCU6MB+P53F9fflpfYYOhxOASSE60IERrD+Iv+ANvol9GQ
         ihirj+mdXp1+uf2Z5eARKu5MPcOrdKMbilgliqMy899AbxIa3FF9p2GRaN79b4YCgAGV
         rayBl9bvKD48qyRy00hbWPrDrYyKuABs4lRWSK7Wqca2QFDYtoRHX9EbfovG4S4N6waE
         nfAw==
X-Gm-Message-State: APjAAAUaO7XaNaJo6s3nB0J2awe4SIwOSQ3RZgLzB/wnhGzIM20nd937
        fC3YHkN4E277aXdPrDAiTyF1JCj1g9juHA==
X-Google-Smtp-Source: APXvYqwXPB1T9vJUrdJh9D51oSoiSJLgkpmi95fZgaP6KWetUp946YSZKxBQ4CjakZ2I5oIfgt+VUA==
X-Received: by 2002:a5d:43c9:: with SMTP id v9mr54497358wrr.70.1560356413425;
        Wed, 12 Jun 2019 09:20:13 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:353a:f33a:a393:3ada])
        by smtp.gmail.com with ESMTPSA id c16sm70172wrr.53.2019.06.12.09.20.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 09:20:12 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>
Subject: [PATCH v5 7/7] fs: cifs: switch to RC4 library interface
Date:   Wed, 12 Jun 2019 18:19:59 +0200
Message-Id: <20190612161959.30478-8-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190612161959.30478-1-ard.biesheuvel@linaro.org>
References: <20190612161959.30478-1-ard.biesheuvel@linaro.org>
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

This also reverts commit 5f4b55699aaf ("CIFS: Fix BUG() in calc_seckey()"),
since it is no longer necessary to allocate sec_key on the heap.

Cc: linux-cifs@vger.kernel.org
Cc: Steve French <sfrench@samba.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 fs/cifs/Kconfig       |  2 +-
 fs/cifs/cifsencrypt.c | 62 +++++---------------
 fs/cifs/cifsfs.c      |  1 -
 3 files changed, 17 insertions(+), 48 deletions(-)

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
index d2a05e46d6f5..97b7497c13ef 100644
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
@@ -772,63 +773,32 @@ setup_ntlmv2_rsp(struct cifs_ses *ses, const struct nls_table *nls_cp)
 int
 calc_seckey(struct cifs_ses *ses)
 {
-	int rc;
-	struct crypto_skcipher *tfm_arc4;
-	struct scatterlist sgin, sgout;
-	struct skcipher_request *req;
-	unsigned char *sec_key;
+	unsigned char sec_key[CIFS_SESS_KEY_SIZE]; /* a nonce */
+	struct arc4_ctx *ctx_arc4;
 
-	sec_key = kmalloc(CIFS_SESS_KEY_SIZE, GFP_KERNEL);
-	if (sec_key == NULL)
-		return -ENOMEM;
+	if (fips_enabled)
+		return -ENODEV;
 
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
-		rc = -ENOMEM;
-		cifs_dbg(VFS, "could not allocate crypto API arc4 request\n");
-		goto out_free_cipher;
+	ctx_arc4 = kmalloc(sizeof(*ctx_arc4), GFP_KERNEL);
+	if (!ctx_arc4) {
+		cifs_dbg(VFS, "could not allocate arc4 context\n");
+		return -ENOMEM;
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
-out:
-	kfree(sec_key);
-	return rc;
+	memzero_explicit(sec_key, CIFS_SESS_KEY_SIZE);
+	kzfree(ctx_arc4);
+	return 0;
 }
 
 void
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index f5fcd6360056..e55afaf9e5a3 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1590,7 +1590,6 @@ MODULE_DESCRIPTION
 	("VFS to access SMB3 servers e.g. Samba, Macs, Azure and Windows (and "
 	"also older servers complying with the SNIA CIFS Specification)");
 MODULE_VERSION(CIFS_VERSION);
-MODULE_SOFTDEP("pre: arc4");
 MODULE_SOFTDEP("pre: des");
 MODULE_SOFTDEP("pre: ecb");
 MODULE_SOFTDEP("pre: hmac");
-- 
2.20.1

