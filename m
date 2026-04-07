Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884FC372696
	for <linux-cifs@vger.kernel.org>; Tue,  7 Apr 2026 02:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775529154; cv=none; b=tM7/ozWPgUSL4cgyfw2E9BQ1yXyPqR1zKIYSXOT+b7EA6KEIu5Kv0IyXhPnU8H5VGNw8BUKkCIhxo4RI0l4uKsoz/jThPKB4g4XKUTF7bLXzry1DOPGsEJdjI48bzYXjgSKPgtazLVVo5X5YUSUfrNMhPy1UHhEx1aZXoQhNhK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775529154; c=relaxed/simple;
	bh=xcKjLBgzRBXhN/YCN1fOMmz1FND5oYMyyC3mdv2on40=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NMuf8YA6fLxhelHofO7P/vxnwtyae8+YvRveSsGut8A1N80kezZ3IC+CuqZ59hFVMaKp0pSYXVXgcZ1u7HABmfkvcwCjsqJE/QKpBe8hn1WKcUtstUiLgHfyPP1zSSqxMHKtkrai51zkn6s1poEoA8VmuEOaJ6ync23ywSynahE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BOqUh53z; arc=none smtp.client-ip=74.125.224.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BOqUh53z"
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-65005a8840dso4503243d50.0
        for <linux-cifs@vger.kernel.org>; Mon, 06 Apr 2026 19:32:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775529152; x=1776133952; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3TdBrfGIgF2rz7Q+xMUAuaNW7v23bF4qeveXUQt07cE=;
        b=BOqUh53zmuu68WLDyDKmX1DJukUVgLpMKDxf+P+/KNUloRtQPyEatETiH7dDxtPrp+
         9qfi8m4S0AZU8E5t9+FdUgs45lOIgOjAXogPrtyWL7wZJH+jWPgoKcEEBhJ/JUT6BEvx
         NWNf2ZadDgFWOV2+yF7uhSzd5K/NR5y8x81/k5hS+ZSmqtaXnJ+0lxw3yCjVPiR7XgLd
         7IKrODVFdoEv50xdohzxCblsQ8s1NZuXCh0GObkKBWTVNo1bcvV7YoKdNOdYv8ac2iE7
         G0hmt4WU4eCWVUDbW/BcN/GZcbL6urjxqUCtEHez66nmv7yzMUA06RhwRmGEVnAXUNeV
         /qPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775529152; x=1776133952;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3TdBrfGIgF2rz7Q+xMUAuaNW7v23bF4qeveXUQt07cE=;
        b=BiFqVQmXP4zU3k4/teYIsxtmRP+XKJJKX3LnUOYByDNhVAmhqyo2gTPzSR0aTk+5eP
         St3GXdspvMsLzZclY5aCDrsYtU8fvpdaNNzx7c5eTkoBYiqpmwoU7ohf+QIE1q+KJNyA
         dCYjha2qzeOAunf20unuV3lfSIqrYc+gQ4arwMNlMLtxp0v0rL1i4ogg2cIlwYQ6fa8J
         YFbYm3zXovP325ZbP/u4rT7ZdclGfn5qK9ONjBn1oZPUQ9C2sCBvyHa72UWbPpEPoFds
         A546dc2OZKX3ZBWPsrisrCkNk9jHcmqwPq0HbP0oMjF7J4OleFZ+MHpE6GzjOrNtSr5L
         V4OQ==
X-Gm-Message-State: AOJu0YxDE5EfYBdxnFAeuYvlT6ssSaBUgcN8Zqd3+ErYxd+po21P4CNF
	Zm6OoNTHPe+CNpbU4/0ottZzM9Zrt5EmYsklgzb7xlaEeww/+kVLpH4s
X-Gm-Gg: AeBDiesQq+3wQHsV/fBMkrcb9JiZgRizr8gtUjSU0uxo4FLSVp/CjNHMxM9lucYkfvT
	nhDgeYyOfkO6Y5CO440xamsqR1uJqiyziS5iuGuIalGxG6n/qWamD8cd3iKtaMlJzOWj1f2mty5
	B5L4HzRIrCWDhPolo4yXYIkb+AC4/pe/hnrlCSciVLV8mCx/CpR+WzX1PlVwJyCNOa2SAIRGCO0
	Ouv9Bh69IIsCqLOsH2ZwAYeUeYDcto6ktVaLA0kBMVs5mMarxXqZ4tEp/1WWQfmgf7U8max1/Fz
	yaFMkWNo+GxJWsatgcAeFDXChYUGMlx0dVgPDf1vDCmjx1tMjl0NQ/jgs9zDMdZ6xkEit+veTra
	sjtyZVCVDaYEiLKsWLM1w5SKOcTL1BD1EmZOPRgY6JvrQSmSmRBMxnV/oSBpXqCPF2bUhw7jxOS
	h/LJgqtZIci1mo7uX5A/yIF+rLxEA1kPV0XA85YH8eVuknIk9qmigVeJLdpwx+
X-Received: by 2002:a53:d016:0:b0:650:1cdb:5f57 with SMTP id 956f58d0204a3-650486876c2mr14049286d50.5.1775529152430;
        Mon, 06 Apr 2026 19:32:32 -0700 (PDT)
Received: from DEV.lan (c-75-74-152-49.hsd1.fl.comcast.net. [75.74.152.49])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6503a9e916esm6883623d50.21.2026.04.06.19.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2026 19:32:32 -0700 (PDT)
From: Joshua Klinesmith <joshuaklinesmith@gmail.com>
To: linkinjeon@kernel.org,
	smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	senozhatsky@chromium.org,
	tom@talpey.com,
	Joshua Klinesmith <joshuaklinesmith@gmail.com>
Subject: [PATCH] ksmbd: fix use-after-free from async crypto on Qualcomm crypto engine
Date: Mon,  6 Apr 2026 22:32:28 -0400
Message-ID: <20260407023228.51267-1-joshuaklinesmith@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ksmbd_crypt_message() sets a NULL completion callback on AEAD requests
and does not handle the -EINPROGRESS return code from async hardware
crypto engines like the Qualcomm Crypto Engine (QCE). When QCE returns
-EINPROGRESS, ksmbd treats it as an error and immediately frees the
request while the hardware DMA operation is still in flight. The DMA
completion callback then dereferences freed memory, causing a NULL
pointer crash:

  pc : qce_skcipher_done+0x24/0x174
  lr : vchan_complete+0x230/0x27c
  ...
  el1h_64_irq+0x68/0x6c
  ksmbd_free_work_struct+0x20/0x118 [ksmbd]
  ksmbd_exit_file_cache+0x694/0xa4c [ksmbd]

Use the standard crypto_wait_req() pattern with crypto_req_done() as
the completion callback, matching the approach used by the SMB client
in fs/smb/client/smb2ops.c. This properly handles both synchronous
engines (immediate return) and async engines (-EINPROGRESS followed
by callback notification).

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Link: https://github.com/openwrt/openwrt/issues/21822
Signed-off-by: Joshua Klinesmith <joshuaklinesmith@gmail.com>
---
 fs/smb/server/auth.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/auth.c b/fs/smb/server/auth.c
index af5f40304331..7d0691f7263f 100644
--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -827,6 +827,7 @@ int ksmbd_crypt_message(struct ksmbd_work *work, struct kvec *iov,
 	struct smb2_transform_hdr *tr_hdr = smb_get_msg(iov[0].iov_base);
 	unsigned int assoc_data_len = sizeof(struct smb2_transform_hdr) - 20;
 	int rc;
+	DECLARE_CRYPTO_WAIT(wait);
 	struct scatterlist *sg;
 	u8 sign[SMB2_SIGNATURE_SIZE] = {};
 	u8 key[SMB3_ENC_DEC_KEY_SIZE];
@@ -913,12 +914,12 @@ int ksmbd_crypt_message(struct ksmbd_work *work, struct kvec *iov,
 
 	aead_request_set_crypt(req, sg, sg, crypt_len, iv);
 	aead_request_set_ad(req, assoc_data_len);
-	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP, NULL, NULL);
+	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
+				  CRYPTO_TFM_REQ_MAY_SLEEP,
+				  crypto_req_done, &wait);
 
-	if (enc)
-		rc = crypto_aead_encrypt(req);
-	else
-		rc = crypto_aead_decrypt(req);
+	rc = crypto_wait_req(enc ? crypto_aead_encrypt(req) :
+			     crypto_aead_decrypt(req), &wait);
 	if (rc)
 		goto free_iv;
 
-- 
2.43.0

