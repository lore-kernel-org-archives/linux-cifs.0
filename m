Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D7BF9C0
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 00:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783555568; cv=none; b=q4n18/D81N7qtJD15//skpDV+gxyOEiETJdo1On4LC29kqSfqgRFm2OBAwHWx7BcAA+8u4gZjz8/99sIoVTtkZJlgmQ3PDTqbC9s2hGtDziayxWGybfXk47SsYVbd9wKrg+n4Zy7T1IOkLfLYlwvfCDHnu0+wrgCWRVMMtJft7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783555568; c=relaxed/simple;
	bh=VJWw4ch6mSopKHDiJQc4+oBMxqjmAQ+eWpdIPigE9QA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHXHqcJp8fCHNReGIjRYKAC3ATlinA9iNj6zMSrz9QP5q2adu1CaHkJFtlpDhNIhbxWryQxHUots3laMlUBYtUTK6Ycv0CqXd/M+em6JhBGB2OUgTZ0bpRKqQAFezOVUGLiN9ZHKkNg0cbLK2GBFtZO+tx1sAdRUdAmiAe5k/1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fh3MdmR1; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fh3MdmR1"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-493b61b52b6so11958595e9.1
        for <linux-cifs@vger.kernel.org>; Wed, 08 Jul 2026 17:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783555564; x=1784160364; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SJjSgk21eT6uAWeFn7NE4lFXny0BgIdoVw6lWr3L20k=;
        b=Fh3MdmR1/w1JBwdnp8TrMhRMOqJVjSXqrEDfOQ++SWaxF+ipmypo6uN2rAnCoIzBgK
         KpML/eDCrNkiShul08FlokVfhLVlr4LbVkvqvYce/rYEG4qeOJC8da8QnYBP7PjMAf1G
         IJXus9bzUJ0XNeRPbtjO1EAOa/hDmC7OZbkTTVjWe7mlhVQbE2tbWYsJiIMhqpu3LnhS
         0iwAZBOcIINNcPwffrBsADsF7BZ1cYXb3EVGrQTT3rAgV9CdE15s8gqrFq49fvZr22dD
         E/ozx6FNkhBrkevZijHOBOoXDOX30sPKyFeY16t5bYu+1MMFIN7Ce15Phe8g6tzWOhBa
         GPaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783555564; x=1784160364;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SJjSgk21eT6uAWeFn7NE4lFXny0BgIdoVw6lWr3L20k=;
        b=N6mykn3S7pdK+FWsGM7VKk9xEeAhjlARdw5auNHRKe+wk2jS93LutdjW5p8Wqrf8Ln
         c7cRSEJ6ZYOpFLvAJgzZ0CP/LKbeMp9eL4NPy13cWkjNFeg0toro0uEcTbdVwhwGw+Jp
         d5iUtyqHdmZkWv/lgNR4Lg80AvzKTU9lYonJhhmCuuTyJ5WPuI/C9ta5NhZO52K1DeWT
         KbZMp76Nu4hlMMzkcosLwfz0vDjGnMCHVssSPyE/rEeG31XjXy6aa3hpj4dWisuUu3sy
         oggvbyTU4uLhOXUipd8hxfXaNQa7PPs2k1eaX+H08Y2IbaFosusloMSpQ8YQeM/n8IfL
         04xA==
X-Forwarded-Encrypted: i=1; AHgh+Rr1YsStjZmFxXjAZaHB1RaEfxBCfywOxA/gg7g3HBD7x2FJ/8mgA42UahR7FsTi24Q1Ir/k2tTuUKA4@vger.kernel.org
X-Gm-Message-State: AOJu0Yyl9xm4mv5aFV7/Cq42YGCY8vASaFVBufSz2JXovEYZwnoo3T5D
	s/SHtlvwvTgxqsxcbOat6yrR4/5i9+ZyZw/YoppSIDaSncRpB3g0Zcmp
X-Gm-Gg: AfdE7cloPExzKPaF3aJEQXjNzvpDZJcu4lWoxkjtxNye8Qbnx6Sc+R7HJKWRW/l9sWC
	MkrykZyfdstLhu9KtdX6zT3H2V+ljENurD1RxkC+nkZ8i+fm8qp4mrVW0hpm3TWfMgbCcLu7oZD
	Zp2nWbIBlzq0Mj3xGrKYA4IvaiTtP6ZcYsRUaHSqogPlUP8vi7iKpp0E+sdK4erp7PsGmNTORSf
	ZmL/1//5RSuZFQQVP/kIqR3y6RCJvwx5MhpuHY+Uw5x+o0wMpyqKpwi57DxbykaN3DgD4WAtL5O
	6i7z5TQxVJNupk1te5i5pEPPKyPCbXbtV2V8lT9Sl1TQgCrypkd1mzjyiRmNfma4EDiM6hfFeLF
	ZZ17vOEWhoz+BdVYj68uFNPwODOXoRW51FLamk0HskfU2klgOmqCrDgrjYos3uWG+VoCPXYIREA
	++mMtdpstXv4k8a3zsEQnNeK+yRoFL/AlsJ28=
X-Received: by 2002:a05:600c:821a:b0:493:a570:df7d with SMTP id 5b1f17b1804b1-493e68bef51mr46883015e9.20.1783555564264;
        Wed, 08 Jul 2026 17:06:04 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb742d0esm15843755e9.13.2026.07.08.17.06.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 08 Jul 2026 17:06:03 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 4/8] ksmbd: validate out_buf_len before FSCTL_CREATE_OR_GET_OBJECT_ID and FSCTL_GET_REPARSE_POINT writes
Date: Thu,  9 Jul 2026 02:01:07 +0200
Message-ID: <20260709000548.66445-5-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260709000548.66445-1-g.blivet@me.com>
References: <20260709000548.66445-1-g.blivet@me.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

Both cases write a fixed-size response structure into rsp->Buffer
without first checking that out_buf_len (the space smb2_ioctl()
actually has available, computed by smb2_calc_max_out_buf_len() from
the client's OutputBufferLength minus space already consumed earlier
in a compound request) is large enough. Every comparable case in this
same switch (FSCTL_SRV_ENUMERATE_SNAPSHOTS, FSCTL_GET_COMPRESSION,
FSCTL_VALIDATE_NEGOTIATE_INFO, FSCTL_SRV_REQUEST_RESUME_KEY,
FSCTL_SRV_COPYCHUNK) validates this first; these two don't.

A client can send a compound SMB2 request where an earlier command in
the same compound chain consumes most of work->response_buf, leaving
smb2_calc_max_out_buf_len() only a few bytes of out_buf_len for a
trailing FSCTL_CREATE_OR_GET_OBJECT_ID or FSCTL_GET_REPARSE_POINT.
Both then unconditionally write their full fixed-size structure
(64 bytes and 8 bytes respectively) at rsp->Buffer[0] regardless,
overflowing past the actual remaining space in the response buffer.

Add the same out_buf_len check used by every other fixed-size-response
case in this function, before the write.

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
---
 fs/smb/server/smb2pdu.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 190fde409..ffdae74b6 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -9390,6 +9390,11 @@ int smb2_ioctl(struct ksmbd_work *work)
 		struct file_object_buf_type1_ioctl_rsp *obj_buf;
 		struct ksmbd_file *fp;
 
+		if (out_buf_len < sizeof(struct file_object_buf_type1_ioctl_rsp)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
 		fp = ksmbd_lookup_fd_fast(work, id);
 		if (!fp) {
 			ret = -EBADF;
@@ -9585,6 +9590,11 @@ int smb2_ioctl(struct ksmbd_work *work)
 		struct reparse_data_buffer *reparse_ptr;
 		struct ksmbd_file *fp;
 
+		if (out_buf_len < sizeof(struct reparse_data_buffer)) {
+			ret = -EINVAL;
+			goto out;
+		}
+
 		reparse_ptr = (struct reparse_data_buffer *)&rsp->Buffer[0];
 		fp = ksmbd_lookup_fd_fast(work, id);
 		if (!fp) {
-- 
2.43.0

