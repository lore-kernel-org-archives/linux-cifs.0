Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E2E34E765
	for <linux-cifs@vger.kernel.org>; Fri, 17 Apr 2026 19:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776453640; cv=none; b=pzFOgS9uQJhpupaMVZmuR6uf8IlH/E8I8C6+xjNu6NDxKiaaukCdkpnSllDfn1B8OwC1/lHzOVtQ8Aiikl4jGOQJsJ5cmY5I+zjiTimWQcKuW/DXt/OXndqKVZAx0IuJe1YNlC2xcZV44i//s9oAgYgu4KBSVNhREnaMgPZrkMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776453640; c=relaxed/simple;
	bh=D5kZnVaQ/vTrsXOqYWEl96J7QGlRpg6INGoI6xYfsZU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dawRzjZh8rgJmOGeVRDusEJtrdZtNuRJkcVgw/9yo7ki3rEaK9WQE8k20uUbjCzAwWHehg8dw9VFUVk2CQHg3L15fIusIKFa86fUdzWNhDZ+GtWl5tpwX1/G44dLE+5HDIsPGXA7w06+SYmNWwNyYnVvmhza5pDBpdT3AO6TCKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NaY4Q3TY; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NaY4Q3TY"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-483487335c2so9884875e9.2
        for <linux-cifs@vger.kernel.org>; Fri, 17 Apr 2026 12:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776453638; x=1777058438; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qejIuAQOnYrB0ta1vlKG9Tsn1R8vB7zz59IN9WHpiB4=;
        b=NaY4Q3TY0Ni6uB6vXusebzSWOBOlo27f34yAICcMhw0szVdYrak1xSJ01IYZQBu7Uv
         7umFB+tCTz1Re2qQDUzY4rhvgaclwpz8QNHeaGNrxj+Ts5DIQl062JQCDu9Eiy6jnxGb
         d8lOHUUnZE0EehsQjE9JNcq189zx/z0rV6ijvTlCUYwCyDo8MEfe3XatSUQfJbTmz5T7
         Uuew08B8W6acFracgTG2afs6cvp9TU0P11nyPMpT0pDwaMhw1ivjY4XUQg7GJaly9Sa3
         UrFds4oYcyA9wSVanQO4ZRQsWmdNdRMnEVOK5aF2PIEuGsi9YPwv41KwmwzCcSMxpRBO
         RJhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776453638; x=1777058438;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qejIuAQOnYrB0ta1vlKG9Tsn1R8vB7zz59IN9WHpiB4=;
        b=UMXP5rVmtiLHhXAUZd9MNbIPWlPS1bTonNp/IqQcHzQzn9wiPUcTfCUjCDsvTcH4gi
         YInuhXpneS5a4XY2iIROttULTnMo/lVfQyRGRdlFF7oRAfu1RzmUJiBxq16i1NAjAgdk
         HywN2LbCJLNjkcXleh+eitzdx6Wb0vELFSPuGgX6IsLernkQZMvFXUNCyZukBKJzAn8W
         M/rBcLYDS4tXLXdJU+q3kxAkTh+T+eJW2pYHZIzkD5hFxJGqdkoWOsIXp1uK3CsEGWIK
         EcE5/SPSlnXqae6PgyxjhI34lEk6KxgWC16Uzcp4t26fBhr4KOlwrz5SnCBgSt8YabJT
         28gw==
X-Forwarded-Encrypted: i=1; AFNElJ+/dYivaKLLTgZjdOIoGBoXg+HbJmyEkWpKrF420ohj0ATM515xeTuTvDmVL32DM+cyEDaQxhwYLJ0j@vger.kernel.org
X-Gm-Message-State: AOJu0Yzk5mNQJ9tZ1Mqnc4T14mFbtagw5f5GNbHWEDbSqAldejcfc3Q/
	5V8MSoUQ2YFE52mybqTJlHjIW8o7gIND5sJXjkTX3uAZXTIp68b6XD5LBcWJRrc=
X-Gm-Gg: AeBDievEmA360qzVutpIIBFQAxpfn/EPmZLw/Q3c1MhDtgXYOvlHcYAqQf/PZjrCDo8
	8i+ilIY+w+cKYDoeujV4LNZbNHzQ3vqTg/J1UCTfjtPxJbIFPAz0+t1BCwTtCbV/5J32NQ6irk6
	vuuSdSSDTo9ywjV2dxrE6F+UQsSWnAI8h9K2LEezJ1w6zYuotax4TgJIHTte3AmxzwvTnZO4C+1
	l+ocwU8VbZIcwN59TUlR9UOhO4pOgW0ftdgN/aKYoyqgLMenaMGYXuNZhGGW8b0oCow3WkJZss/
	+JhSPZFhNILlqr9XbEj4fOv4J7rTnTNnUylrUwhNCW982C5b6r76PnrWCzcKbQYn39xBJt2Gfa2
	LejIqVHuyYgmY9ztSKRDZcLmUl+DrzbXTQyUo9ybZe3pcjUctyLylnNzDgXNim9Kwsi9D/A3Omr
	sdunhDN3As8QRgHAgwUtry+xx0S0Q=
X-Received: by 2002:a05:600c:8706:b0:488:d6eb:e635 with SMTP id 5b1f17b1804b1-488fb753abdmr66604615e9.12.1776453637660;
        Fri, 17 Apr 2026 12:20:37 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fc1393f5sm61147675e9.9.2026.04.17.12.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 12:20:37 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH] ksmbd: fix out-of-bounds write in smb2_get_ea() EA alignment
Date: Fri, 17 Apr 2026 19:20:36 +0000
Message-ID: <20260417192036.268452-1-tristan@talencesecurity.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_get_ea() applies 4-byte alignment padding via memset() after
writing each EA entry. The bounds check for buf_free_len is performed
before the value memcpy, but the alignment memset fires unconditionally
afterward with no check. When the EA value exactly fills the remaining
buffer space (buf_free_len == 0 after value subtraction), the alignment
memset writes 1-3 NUL bytes past the buf_free_len boundary.

Add a bounds check before the alignment memset to prevent writing past
the authorized buffer space.

This is the same bug pattern as commit beef2634f81f ("ksmbd: fix
out-of-bounds write in get_file_all_info() for compound requests")
and commit fda9522ed6af ("ksmbd: fix out-of-bounds write in
ksmbd_vfs_get_sd_xattr() for compound requests"), both of which
added bounds checks before unconditional writes in QUERY_INFO
response formatting.

Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
---
 fs/smb/server/smb2pdu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ee32e61b6d3c7..407173d2175af 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4821,6 +4821,8 @@ static int smb2_get_ea(struct ksmbd_work *work, struct ksmbd_file *fp,
 		/* align next xattr entry at 4 byte bundary */
 		alignment_bytes = ((next_offset + 3) & ~3) - next_offset;
 		if (alignment_bytes) {
+			if (buf_free_len < alignment_bytes)
+				break;
 			memset(ptr, '\0', alignment_bytes);
 			ptr += alignment_bytes;
 			next_offset += alignment_bytes;
-- 
2.47.3

