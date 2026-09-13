Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38CF2E7185
	for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 23:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789342096; cv=none; b=OaJkyzgP9CNcbFRb25UABjMnILA3dqVy3SZYAW6cK7iBsPTcosVlMpNa6Hc5xM+FVWr1ZfcqkzW31YyZnd1SKeiOLLd7/b/zjD+qV2Fr/J8/Cl5SBxT1oohdD42FhGoLfWOg5FbmCM6yT6K8ejHdjVkZGlPox7EwZfApDNvvPMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789342096; c=relaxed/simple;
	bh=t8tFv8uAMASN/aq0WIFIHvOUy6F436mtOCJA9JzsuzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jZeI0ZZgfGZBYl3G6CbISkTlMZyt0Mj2uFAPZcJrrWyVVfa1WoU0sYHij5V+3v3ehYft6cFd/Bx5XU1WLuEu57NAKYA9fssZHNVjrPaXt0wfNSF6fzMVZ/VFD8O5pM0OSS/DnQWFCyVCLlvTTQMp7ZlWDQx+30o9gkHsyvhEahQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YoXQQ1yL; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YoXQQ1yL"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cd5462b69so8150925e9.1
        for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 16:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789342093; x=1789946893; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zg1m0C9O4uvn7KLOr801mi1GnnK/kwMkv7Jh2hnUVkI=;
        b=YoXQQ1yLCDkhyubEPyDftnw0aD1X5KGRQZjA1v0ijq3F/9Cn7YZdLDCvo2S7dnvCjO
         /fNrC+ikVQ1FHs91etQHQUsUHkmZIg9RMFVXozD1J/UgndwirFYr1eoROyaYICof/52K
         b+wLX1u5tQd/dunGUy4ESuh+Dzm6ogUBMK1N4xRTARD5nSlDM2d7jnkkEcRcO+c0ariQ
         btNqRRxsX95+S2ivWd0Mw9sp9weHG9KMpKtdxvcFlMHq7P3mbHky8leGyoza4y9n610f
         H0m4+QBTkjZm9lhmmUwkrLRMb6pu/mcbP7vVy0CkCa+6gpEl03qcZZIPMb87v1lj3/Nn
         RQwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789342093; x=1789946893;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zg1m0C9O4uvn7KLOr801mi1GnnK/kwMkv7Jh2hnUVkI=;
        b=QnA4L9n+tIY5WsBaQjyHa6zJ927JL0GAGPAUzQsoNHHwROrshGp8jhQHXJMXpijyQy
         hzwSwD42/VntVitqLrV2jPeBXQldeCjeaMaf0ULU3VGPigglCnLp8/W4WFg89UdNO49A
         jnh3ZcddMrCdsm140fCnS1zEYWPFSXgPlz6EuKBZfgNQVqRevYK3k0pEyGiCvN2iu4BQ
         5hwgVX9LbWMHUHOfbKiq2nyX/xAwAiJ5mWqGhV5xVntwmXbF5agCUBTQ6mTkuWSHdfPI
         dIO0W4EHY4qCu584ALNztSGsy/XsKo2W09ul5T3wCWptjZqbAqZlYWCF5NOQ2U2yP5gr
         7Rqg==
X-Forwarded-Encrypted: i=1; AKwUvBw066cz949RCoCSTVcnifx22AdQpTLW55b5y4A/qApc/XjU3p7oAeJF8LgTn8w0f4NlOoDz2f2c8saw@vger.kernel.org
X-Gm-Message-State: AFuF++lWEZOTI/Tih9tg9cQ3K92DV9YgBbyE7KHEyg6X3Sq5ONspZ0KM
	q6fZAnAlDnze3Nl2QrQVVzNBUhHK8RuB9r4VSO3C4ORJfP747VGBZa9NCsyfxg==
X-Gm-Gg: AYBFou1MXfHzDpmNgNe7m1EHWJbvSKdH/WYOZKOB/hDDYyzev2ObiRtJ5kcwAa82ppe
	/Nm3IFsr+03qw/kioe4XWqON7FmSQDNfZZjFDcRwBUyRe8GdVr0oJozZyGt7MFIjI32SjIAFHw/
	ivYQ71p0YDwIHIJTHKw3nND1n8QZKP8m9Zej7ZQT8bStNzCc68rBvk6vNx/POkYRSiayrQ2Vfht
	24ydETh55kOmX1d8FfJLR1OQWJrgR+IL+4nxXLbtezqBcY+nEMhO9UmV//KGLd8mODf4z/KIy48
	3DKeU3YCLgw+FVvImkLIB6eoCyYlXiMzCY+Q4eO1b1bWdFJWSP7Hx8PXtHDJzvECG4hz9QilA3I
	c3JmOqrR7ZuiRkKqYxYVe9gqvCSL0W8fPJuCeR0XA90YOGnTaUN0W3+nAPd9Obo+siuzW2OscRW
	O53APNWncsldA3hn7mRhFKX0lZj8EWLEvszTEy0VjfBe9Np6jouB2StBtI26dJQkI1HcXqvoxuW
	E+SikseAc1Gl8LYFcO0Uw==
X-Received: by 2002:a05:600c:6309:b0:49e:65ac:eb5f with SMTP id 5b1f17b1804b1-49e7a67eb3emr2318145e9.10.1789342093106;
        Sun, 13 Sep 2026 16:28:13 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e6499d57bsm396657625e9.3.2026.09.13.16.28.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 13 Sep 2026 16:28:12 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 3/4] ksmbd: fix AFP_AfpInfo header fields in synthesized xattr
Date: Mon, 14 Sep 2026 01:26:37 +0200
Message-ID: <20260913232737.51704-4-g.blivet@me.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260913232737.51704-1-g.blivet@me.com>
References: <20260913232737.51704-1-g.blivet@me.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

smb2_set_stream_name_xattr() synthesizes a 60-byte AFP_AfpInfo xattr
when a client opens a nonexistent one on a Time Machine share, so the
probe is answered instead of failing with -EBADF. Its header does not
match what clients write: ksmbd uses 0x00051607 and 0x00020000 for the
first two fields and leaves the third zero.

The user.DosStream.AFP_AfpInfo:$DATA xattr a macOS client writes
begins:

  00000000: 4146 5000 0000 0100 0000 0000 0000 0080  AFP.............

Write those sixteen bytes: the signature, the version at offset 4 and
the backup time at offset 12. The 60-byte length is already correct and
the rest stays zeroed: a zero type and creator lets the client use the
file extension for icon and type detection.

Fixes: eaff8e924f60 ("ksmbd: synthesize empty AFP_AfpInfo xattr on first probe")
Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
Assisted-by: Claude:claude-opus-5
---
 fs/smb/server/smb2pdu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 79b0cd165562..52ec5dd19632 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3433,8 +3433,9 @@ static noinline int smb2_set_stream_name_xattr(const struct path *path,
 			 * AAPL there too.
 			 */
 			static const u8 afpinfo_empty[60] = {
-				0x00, 0x05, 0x16, 0x07, /* magic  0x00051607 BE */
-				0x00, 0x02, 0x00, 0x00, /* version 0x00020000 BE */
+				'A', 'F', 'P', 0x00,	/* signature */
+				0x00, 0x00, 0x01, 0x00,	/* version */
+				[15] = 0x80,		/* backup time */
 			};
 			rc = ksmbd_vfs_setxattr(idmap, path, xattr_stream_name,
 						(void *)afpinfo_empty,
-- 
2.53.0

