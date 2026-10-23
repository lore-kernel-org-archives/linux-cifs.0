Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792716051;
	b=CZICwveEhnAZFefH9P+WTvdsgozFKXoCct3B+rNrkXrGEeuZMxQW4NnjM7/2Q4S/qY/p
	 MXuUiWX/Y/F1/PRzP06J5K5jd7O4mn6KWimRZGyI+rxXWv7h4k44GF6B5YCtIU0h8cL2F
	 s0zCVtQ7S6l3LPYejLJC5kWbAelJX6X+Fc92DcgZ36CMTL9kskyM1XjulUlgPqxNXIVut
	 MvFjzNzaQAlsyQE/qAMpu8TdqcFnSDtXCB/vHz4+qnuPEHFWINxpJAvuNE9D/dFBWCPjX
	 0AG1J2tNuPuLPKzURj/X0MUg+WdFqEThrro7obnTLXnIxoFlhbOQ/w7gazWGWLQtuUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792716051;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=uWyqPtiO9T3gA3HzTMYjuquERoZRGMe37lTtw9Jts+o=;
	b=i8R4zQ62d5f6A0TTQanDIQK/PNBfZK98lR3EcFh+odiYdnw5/vkw45S0DJVsnd7WPY/6
	 vvtonQnV/8lfWjiUO5BD9gEj/YjhK9Zt8Kdzpg0GRRfGmE9GV0RBBE7koX3Uty0nMkhq0
	 KGalX7c9fCyOZa+Xf5um2qB/gxY9P1cMqcjtop4FiHkrfcQFnH61+tG2fmO1COMW8iqBL
	 KkxSDxL42Xt81CP+Utpkb5ZjEQENMNYdZXzUY2M+SWSHwxPYYU5YMytphtfXvO5tvVi84
	 ut/V71Qlmotax2nf5wTnm6phbZ7QK0hjfMqN4yqZZ4bZYPAGG51T1W6/w1xxHuCs5Lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=TXhpX0Bw;
	arc=none smtp.remote-ip=209.85.218.49
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D268606A31A
	for <linux-cifs@vger.kernel.org>; Fri, 23 Oct 2026 00:40:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D268606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=TXhpX0Bw
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c3f04e0e65fso50890166b.2
        for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 17:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792716050; x=1793320850; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=uWyqPtiO9T3gA3HzTMYjuquERoZRGMe37lTtw9Jts+o=;
        b=TXhpX0Bw8RC+C+6aO7v84NJcvA6Y6SBRlt/g3tanIP9RPjaV46IAJ7GtnrZigg5+NB
         u6BDsVBkeabEXXpYzULc1G9c1X5Y8ivE6kxaFq2vCAnmvBU2wqsxL8kPk4Wpvjz852PQ
         zsiEZQB4DLHXf/LnNWW7QZU8GFbeG7ydwc98Cr0xhQ4eErXDwkolmxsSg32G0kDJFJb0
         vxthV8K/mM71zLP7qBcRIbholw2QWyaJ0PGqSdCOyW/dT6UvusVn8abJulDGqV2l59eK
         76zqrbHrbV/7C36vXpcgcGIypP1y6Q1lSyHjhUOpQg5tOAirhT8NkRqkWFOv9V2wjE+s
         gRWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792716050; x=1793320850;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uWyqPtiO9T3gA3HzTMYjuquERoZRGMe37lTtw9Jts+o=;
        b=m4syXS4Ri7apBYQgOJDX2RhaLfX2eDKJpU+jJ0ih+kfHDlxFcDdOyZfsJq2xn/Jp/l
         yI51kxp1CRd9Jj1cQQg7s0OqUUAQHn2DVqgBeGVeeOA6ZvkcDeHcP+DZlfW628RE0u8Y
         eRe0TFD4KvEga9LUScQWVFKpq43aqai1RO5Tsqpd7cKHm9pBEQQN0gYmIN96QbYIHvpi
         Y1pP8nKIYRBxP5VHteb1H46UIH0EJ+xEOxUm/nAHdYdVwU38gNb6hNn+xpgbihNuVwF+
         AL3jc9kH7SOJgsow+t6HyT0ln67TbMXHbuNW2ryiF9l6efKHWGJNzhPsHHNW1R361Yel
         4IWA==
X-Forwarded-Encrypted: i=1; AKwUvBzUUUXXSrEfBm7e06+24MQ2jlM9kkggfDXFWwiUMs+G5Fldfcpk6o/sZmIUq5GMlQ9+8ndo4IO9DSI1@vger.kernel.org
X-Gm-Message-State: AFq9FYJ62FLUSXWqylWFFMkSbNM4L0+o20zBRa7ijNzhtmll1CVx5gUb
	S64PLMt/gxzzNDSLo+aNzXqHwA4mvGjpWpKSxP5JZObYgbMo+rDT3Ccj
X-Gm-Gg: AYBFou0YhY196EFTRANyuXJU/KLpHvOdJlCdE+mNBOuHv8obkK3vC23MEm8BOviS7cY
	phFjT/cJDQAZVR/pYUHc2yrMJeekzQIAPy9nQB3AJCx3CO0Gg71XDOd3ERzKQw5KjXO6do+kxIV
	a6YJIxKgVwdh5sPkLMHDewNF2aYd+9Titk8ZmHxVAgTj4mB+yY6VXSfeW/3GLYOfhW4ywS0HHDs
	XUGQ0TFuECEsIDmOPcNzPbmDQxQkhVd3R7mAFQ93eDpe4HI084SIxx1/XnaaIVzydW35pGg7mTE
	oeT2JS8CjKfmI3T53InKo97hbdWbUjDQc+UEfMm5gcOlkR0m26JrHSGN8Uvzd7VEIpZxftPpHIS
	GjFAUbi8f2fPE9fu7yYYlBRm32Ucocl1suK8uGeZGTnHZN3lKLoG4hrRJQb4oOEHdWi2mDZo/Ww
	HIhvnbnzf1Nu4x2/m42X/DRsuomkbl8TADB3zPPXVce6jc+5PRIGr9EV88SW5vEi8YwlgO6kEf7
	bJ4GzwLHyXIve0AxXo4/LeGaBezzZv6N0URiKCpHEVcEH+A+L6MkuYvn9Leka/zjxBnBo5dYQyx
	Et/k5gUx9EzSZp+bnHjyCa/6qVW8aQRqdrMAg+p0
X-Received: by 2002:a17:907:7285:b0:c42:2d07:4c38 with SMTP id a640c23a62f3a-c46a903b6e9mr116843766b.26.1792716049876;
        Thu, 22 Oct 2026 17:40:49 -0700 (PDT)
Received: from localhost.localdomain ([45.93.75.180])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46a5a90202sm47330966b.5.2026.10.22.17.40.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 22 Oct 2026 17:40:48 -0700 (PDT)
From: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Subject: [PATCH] ksmbd: select CRYPTO_AES
Date: Fri, 23 Oct 2026 02:40:45 +0200
Message-ID: <20261023004045.98484-1-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ksmbd allocates "gcm(aes)" and "ccm(aes)" AEAD transforms for SMB3
encryption, but SMB_SERVER only selects CRYPTO_GCM and CRYPTO_CCM, not
an AES cipher. With a configuration in which nothing else enables
CRYPTO_AES, ksmbd builds but cannot allocate the transforms, and every
session that uses encryption fails:

  ksmbd: Failed to alloc encrypt aead : -2
  ksmbd: crypto alloc failed

Select CRYPTO_AES, as the SMB client already does.

Fixes: a848c4f15ab6 ("cifsd: add Kconfig and Makefile")
Assisted-by: LLM
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
---
On x86_64, defconfig plus SMB_SERVER=y ends up with CRYPTO_AES unset
once MAC80211, XFRM_ESP and CRYPTO_KRB5 are disabled; with this patch
olddefconfig enables it. Without CRYPTO_AES, ksmbd logs the messages
above when a client negotiates encryption (seen under UML on
ksmbd-for-next f75c93278608), and with CRYPTO_AES the same client
connects. Distribution configs already enable CRYPTO_AES, so this only
affects custom configs.

The smbtorture smb2 tests run here (dir, create, getinfo, setinfo,
rename, compound, streams, dosmode, read, lock) passed on the kernel
without CRYPTO_AES, as they do not negotiate encryption by default.

 fs/smb/server/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/Kconfig b/fs/smb/server/Kconfig
index b7665e0e494..f8b03605db5 100644
--- a/fs/smb/server/Kconfig
+++ b/fs/smb/server/Kconfig
@@ -16,6 +16,7 @@ config SMB_SERVER
 	select CRYPTO_AEAD2
 	select CRYPTO_CCM
 	select CRYPTO_GCM
+	select CRYPTO_AES
 	select ASN1
 	select OID_REGISTRY
 	select CRC32
-- 
2.43.0

