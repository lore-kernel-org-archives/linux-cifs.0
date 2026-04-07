Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B92A369213
	for <linux-cifs@vger.kernel.org>; Tue,  7 Apr 2026 02:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775529083; cv=none; b=V8EbdIoH10lbjE5oueZVNLszVvZPH++rL5KLAgd/3HJdmTTNLISUpqyFBG1ZRGt//Ka1/FEUtaX+Gnz/DLEfoW9Cz/nf4cTuAwXX/Pd+aClyn9+ztjy3xhziTIYXlSP15U1wvtWKL8ttHCc97/L1RtQk7L+CvjrSQ+c7lJGc3ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775529083; c=relaxed/simple;
	bh=xcKjLBgzRBXhN/YCN1fOMmz1FND5oYMyyC3mdv2on40=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V0PFaOCRsLo7LU/YUaU0tg5n+H/sz5WtBBRbdpm3IFmsVmliQqRlVb+lXDB9K4WsCMyNd28CGFIUbHT5CnMtdiBy2VnH7WQSG2yRSZDLKjMYG+1RMdnkWf0tkv2d3lZmjserNOhR3snhcG3cpitGop7L++cwx6kBG5rnf4faIc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=n8K+Wclp; arc=none smtp.client-ip=74.125.224.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n8K+Wclp"
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-6507a833e68so436023d50.1
        for <linux-cifs@vger.kernel.org>; Mon, 06 Apr 2026 19:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775529081; x=1776133881; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3TdBrfGIgF2rz7Q+xMUAuaNW7v23bF4qeveXUQt07cE=;
        b=n8K+WclpdKC0IPAgo/GFC3AxA3YFpB30vavruP71/bUl73zqmT0asM+TS69W1bd7iK
         jPWqu2oWcUNlO5dFY5rVNhUbh7dzet0OGSawFQiJJZ7vZ8f3OVzbX/r9JhSlz9QCdGiC
         RBHFrB1slb7fODwkzzmtoGm8STW9Ig4dlCt4UxC27RZpXKNf+4CIFY8+y5OSKHDdMI/X
         yMm5Z8aj3anbtoQkkOOrWPJjWumWRrWhB3nPV0hHwNAGVn2cZgvPGwE2Igc+mepPj2cl
         bejJmJBb4hck0yZJryHOpD3CkKkY86jWsB9+/YzW9loE+IrE3AjkInLYj3+i1mdIxiWq
         d4/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775529081; x=1776133881;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3TdBrfGIgF2rz7Q+xMUAuaNW7v23bF4qeveXUQt07cE=;
        b=SXwY6Oj8GYlzIg7OAG6z2N19tgrgrTqEW6gIVt07NZ5TOxzr7CSzN5bGq8rhMrQKAw
         frGP8Yu2PsgSwWTt+cLqzjZMGriUe7HwwbYPVNGlSFG4JYmiUPy9hGz1/CGIPHZ30dxT
         ZuDYk83O9URjsA16XESIbECin4s8iMtTegjDMwgV+LtDIoYCiUjKBWCdKmDK832qZqzn
         ZImDxzyGgPIRuDFsxj4RCFWciEc1XlVE1I+ncWsswwiosavE2ML5NWp63QKXU6pyTgC6
         8yfyYLw8JVpZILSNFiX/4kkexWw+jUVnCYGhsJcC346QvixTY8abyhgRo49xA6RtQ3BI
         K3fQ==
X-Forwarded-Encrypted: i=1; AJvYcCWqvruyov4SrT2aLp8sOplBZ9/EY66vQxhggvJcLq0samLmo4S/yyCRvwnQ9qJ1ztruhlSpDeAdV8kT@vger.kernel.org
X-Gm-Message-State: AOJu0YyY/8ID4A9tRbVKmi+fkxOs5fGy5fpH+YVJQAna7Gtlzz5QM2GT
	zJZdEA6fLyPbQJhQNAsnJdHwdwkyB/Nua69B9Ogs1vhIXe/XxU9s0S/fIk3cjkcK
X-Gm-Gg: AeBDietTZ+/nV/3rrZnND/cLi+Bc5nbnUf37KTcD6nyIB5aAmRHA4I/U2L2hIk2dyFv
	tU0R1DpIr3+uNwTENKyf2kBUUlyYG38nwduoiyd58VcmtZXPpTed/EH5iTFRFdIVSXJ7ANzhiYc
	yefY94b0c+WNbK+nyK6exfXNVlGGp4WyUwTC3QKSJsaS8hcmMVJbCs8wOqMbIUm4gDRs+40DgG5
	d2WPFpz72p12L/9ZhrQdSJVyloKXU0XKA0a/H8f/tRsnq95koQkQWn1J3cysTDd/4hZaq8OiOiO
	QpX9JDnR2Xo6OOlwVxnmVIxbKBp8lCjx/gwMWG1xTlBmGZHEHaLMKg8oCAo7mcdwmbAzr5aST0n
	lj/5C+KNOnDbKvfImMSWqZXY9JByVaTlGl9bdihau8FMuMid+8FmksDwPGryonwGp9bJYEu4Ffh
	RltEjy/+IiLtKenSrl1la4e1+m4Rssu5+bvv2fDcwkBlsel22NNyg8p6EDcoN+
X-Received: by 2002:a05:690e:d52:b0:64e:5c43:e254 with SMTP id 956f58d0204a3-6504881abcfmr15820364d50.47.1775529081446;
        Mon, 06 Apr 2026 19:31:21 -0700 (PDT)
Received: from DEV.lan (c-75-74-152-49.hsd1.fl.comcast.net. [75.74.152.49])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6503a828f3csm6986912d50.3.2026.04.06.19.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2026 19:31:21 -0700 (PDT)
From: Joshua Klinesmith <joshuaklinesmith@gmail.com>
To: linkinjeon@kernel.org
Cc: samba-technical@lists.samba.org,
	linux-cifs@vger.kernel.org,
	Joshua Klinesmith <joshuaklinesmith@gmail.com>
Subject: [PATCH] ksmbd: fix use-after-free from async crypto on Qualcomm crypto engine
Date: Mon,  6 Apr 2026 22:31:12 -0400
Message-ID: <20260407023112.51220-1-joshuaklinesmith@gmail.com>
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

