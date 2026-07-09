Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978624C041A
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 17:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783618228; cv=none; b=Wp87S0t+unBlOEKvg8WeiDHXjT9etTqS5u59PDJgWjrayJRgor89aD7jyLlPc0nP940pI1bPkmT35VKkTdmbZ1G2z+gDczNuJCgVWG81wtqxMaJbB5xOrEEsZMk0S9jE9Lx9LcKGcm5bRUuH/ObCXkaUpy1Bm85/4uY9TvqyLl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783618228; c=relaxed/simple;
	bh=5ykCmTpMfCEQeOhUefQy4Coty8Pe/H+83qUuhS/gcL4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C31lCYxVkIBWE+JFjnNYS3Dc5o076UZDddqd2a6GySj4uP1Jy1cc5Fmt4lMcSbmbFK57xDXpcIAdwhLOfaYConMh/jRY+3Ro+2qrjKOCgTo3k8Wvmduo2sj4Ehemb7F/PnGOl5K2PMGvtgTCIcBxPZqUbyNUHV288YdV00oMrX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KtRVkKc2; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KtRVkKc2"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c966b9ee9cbso46905a12.1
        for <linux-cifs@vger.kernel.org>; Thu, 09 Jul 2026 10:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783618227; x=1784223027; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8iGOAD5CXSjPRAYGylnvXRw4wXgFTYw4EXvlb3WE+Wc=;
        b=KtRVkKc2tcYkD3cfYS3YX0hdRO9oMPdwBLiRISJNbd+owOvx5z2wasmCiHTWCQ7nIM
         zP2T3BCOXbOedj3nDlONoW2h0Kg/c2qMH65DtEpdb/CFwgywla8WAG8/XoPaVhvCM7BH
         jXWxMs8QQCfRkaJBwlPix+XYShE9Q0qUBkskEqTQbSKRWD+I9ljizURdXd8C1WN3iQ21
         WFLsKLoQfH1gHtPlou6cP+ck5m65OEkeoi5pYhS8N1JYePRTBgbAXxztS80fDLNKDb0B
         bQsPlDFDXe5XdqnrYuIW5l3C/5SQUhpr44jRr7/WzOwPPJXTAyS+bHpJnWX4vIf07mBx
         lZOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783618227; x=1784223027;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8iGOAD5CXSjPRAYGylnvXRw4wXgFTYw4EXvlb3WE+Wc=;
        b=CdVOaAJmaJPTiI4u8d7lmTnrXzfuX047Ib8mVE/IFOCvzp3rSvszmwTTYcSx1pFIQ9
         4IN54DFUJ4HUNeRVSIXNpxpPCX1eQm0SBtbZUoLdxRpTNVEmN7zL6GT5BsHuoVb9DwIJ
         JKuZN+6u4xn5U9eS7lrnz/7stUHLUdCKITA0v1JpEl6hfyiiliD1IVdl69m+Bk3A/EJN
         P6E9YsPhffvxVmnGDnEngvWwkzlCK/rbknXO1Zkmjz0Xr6HestJBaVZBJl41eRFGSdOr
         x6lyTII0ew7h9KfSHlVQef6pLwubiSHzfuJoGoJUwLiGx5jkZ8dpjQ+/GUDAJo6pxe+k
         7iVw==
X-Forwarded-Encrypted: i=1; AHgh+RoFCS2h9VULr3OtF/MP6bin5QZCH82PAEMom/Nguyuy6kNHXleGP7yMlezbPqhRBfmwPhtWVzJSBbMN@vger.kernel.org
X-Gm-Message-State: AOJu0YxkLFEpkKY+JLlpAILMOhII3iFpLueQl9/ydnFtjJFsB6fWP3Me
	ASYF0NcT9q4IWDaXgLETWI/tmPXpKunmks01Ouc6UcmT1axXsga3dXkv
X-Gm-Gg: AfdE7cntBrhZRayugIrLDmdoauUYNZpmmAxCe8Jg5Pvv31JI25GuR6/Ag8bHOcDmUDb
	w7i2Ckdh8xvorh9GxFRRF6m/k5Zc5C0kOgTJ1AEG8djg3EkJ96HT/1jyS4u2kSyETkMoATkCsGB
	XLRV4w7CgOxwosA+gbSQTL/J+hDpQ8xjm1BpkR31Sb/3iMykuRrDw1wF3pTaknzjXXJolXwfeZO
	N618OM5wdR8IQdZzahNITq40UsamzfqrcOjhTXEdWDLY3N2SdeDsZe92CtbGvtcMsKlpN2UIYuB
	Q8cfF96rBjD9xZTgSgT8bNqiJSIzx7OeOQhJ0Fkcf0Rr11qWO8lqC60eICqe5ZLdmlwKCwJ5Q7a
	SapxynqcEGhC0VehDLTogcG0cu9kvRk4LD2GztxF51jlZySDmdEMAvIXNJvvDuf8YpUuEDpxAGo
	lmxznEIZrCAA8h5n37R0qiw74rrWZytXOwrsWgsvxl4suLV4Nukm2gJ/ZRSQde6ZOsYdYLDCF/
X-Received: by 2002:a05:6a21:38c:b0:3bf:6e72:68f9 with SMTP id adf61e73a8af0-3c0bd0fa825mr9078347637.38.1783618226906;
        Thu, 09 Jul 2026 10:30:26 -0700 (PDT)
Received: from localhost.localdomain ([2405:acc0:1306:5177:44f2:7cf8:bf02:d020])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13b6593c4ddsm35977235c88.1.2026.07.09.10.30.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 09 Jul 2026 10:30:26 -0700 (PDT)
From: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
To: Steve French <sfrench@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@samba.org>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] smb: common: fix undefined shifts in LZ77 flag encoding
Date: Thu,  9 Jul 2026 23:15:19 +0545
Message-ID: <20260709173019.36808-1-acharyalaxman8848@gmail.com>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The LZ77 encoder emits flags in 32-bit words, but keeps the
accumulator in a long and can shift it by 32 bits.

This happens when lz77_encode_literals() emits a full all-literal flag
word, and again when smb_lz77_compress() pads an empty final flag word.
On 32-bit builds these shift counts are equal to the width of the
shifted type, so UBSAN can report a runtime error and the encoded flag
word is undefined.

Use a u32 accumulator and special-case the full-word states so the same
flag words are emitted without issuing 32-bit shifts.

Fixes: d14bbfff259c ("smb3: mark compression as CONFIG_EXPERIMENTAL and fix missing compression operation")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5
Signed-off-by: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
---
 fs/smb/common/compress/lz77.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/fs/smb/common/compress/lz77.c b/fs/smb/common/compress/lz77.c
index 9216d973d87..be6853ad576 100644
--- a/fs/smb/common/compress/lz77.c
+++ b/fs/smb/common/compress/lz77.c
@@ -188,7 +188,7 @@ static __always_inline void *lz77_encode_match(void *dst, void **nib, u16 dist,
  * MS-XCA 2.3.4 "Plain LZ77 Compression Algorithm Details" - "Processing"
  */
 static __always_inline void *lz77_encode_literals(const void *start, const void *end, void *dst,
-						  long *f, u32 *fc, void **fp)
+						  u32 *f, u32 *fc, void **fp)
 {
 	if (start >= end)
 		return dst;
@@ -201,7 +201,10 @@ static __always_inline void *lz77_encode_literals(const void *start, const void
 		dst += len;
 		start += len;
 
-		*f <<= len;
+		if (len == LZ77_FLAG_MAX)
+			*f = 0;
+		else
+			*f <<= len;
 		*fc += len;
 		if (*fc == LZ77_FLAG_MAX) {
 			lz77_write32(*fp, *f);
@@ -225,7 +228,7 @@ noinline int smb_lz77_compress(const void *src, const u32 slen,
 	const void *srcp, *rlim, *end, *anchor;
 	u32 *htable, hash, flag_count = 0;
 	void *dstp, *nib, *flag_pos;
-	long flag = 0;
+	u32 flag = 0;
 
 	/* This is probably a bug, so throw a warning. */
 	if (WARN_ON_ONCE(*dlen < smb_lz77_compressed_alloc_size(slen)))
@@ -327,9 +330,13 @@ noinline int smb_lz77_compress(const void *src, const u32 slen,
 out:
 	dstp = lz77_encode_literals(anchor, end, dstp, &flag, &flag_count, &flag_pos);
 
-	flag_count = LZ77_FLAG_MAX - flag_count;
-	flag <<= flag_count;
-	flag |= (1UL << flag_count) - 1;
+	if (flag_count) {
+		flag_count = LZ77_FLAG_MAX - flag_count;
+		flag <<= flag_count;
+		flag |= (1U << flag_count) - 1;
+	} else {
+		flag = ~0U;
+	}
 	lz77_write32(flag_pos, flag);
 
 	*dlen = dstp - dst;
-- 
2.53.0

