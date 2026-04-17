Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DFF389470
	for <linux-cifs@vger.kernel.org>; Fri, 17 Apr 2026 19:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776454404; cv=none; b=EoJcN7I5q71ISy5hFg1vPkLH0WGKLKi4r8exNWk9TcQQg3jERg7TE43HQFagovTIyHNkHKsxI90rZKON0zyShS/WLBXt2Hk2BotsCM2PofqgmBwG4og+ChhT2Ri1Shqr5LULtrlaA6vbadB8R5VhKdNvrCcGNI2vC5MFL+iURcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776454404; c=relaxed/simple;
	bh=wSouMAxbC4qBTG56Li1QJbGu7+b7Rn1l0WqH5ApVDw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOd/90WQ5iB06ftpB6KE0KDD0dF81h+/w7cxNcJCJl55WqdwQ2FtRK7rmwwFZc/JLgXhC9q9wWIdP/BXCEX9scnlYIqh39fsj871QADgmD15Mmpog3w6m07ZoK1ARyxJ96inrXYiZyyi9maumfwsdpRJUFufaUEjQguI922spxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zfwpzdvd; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zfwpzdvd"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-43cfd1f9fd1so660512f8f.3
        for <linux-cifs@vger.kernel.org>; Fri, 17 Apr 2026 12:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776454399; x=1777059199; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kQ0cthg0w4P6S7KugYGvtLaxhgxAoG60Ed2oJXFQlJE=;
        b=Zfwpzdvdgew6YVKkzjQU10DXoYj8onpvnXmHUf9zsPbNCD59dL0gSkbUO1EZA6PnKo
         WiZe864Tz9ApWMdKvIIXx1UniqinnJPZWN/rNWm9jm4CpQB7Tpx+KQvfTNoykE2Bm00H
         1icNTvekACYfOrozraQSvZ6RcBRjQHNFqcbpN1GoklQr05pfG2WE0nmjpRjOJwr/4JJz
         v9Jgr1JK/BlH6jeBxPcpCgy2VOWGlJ31e9vxKxnQbXzG32i8GwJdojA/LOEfQGQZwgTh
         uh8BvvFU4IpFvfP6Dl8f2skhZMF8bess0QIfAu4CVF5PJfoth/zZ9WTBqZ0F8nPS6mkl
         NLfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776454399; x=1777059199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kQ0cthg0w4P6S7KugYGvtLaxhgxAoG60Ed2oJXFQlJE=;
        b=Faw5cZCOpoLlK6ajmIEIZl+ZSQ8QO4wbmqnH203xn2DM0HhMVy6lD8QAM9PpbOjaav
         d150prMH1EBINJ9k1r5W6mPyLcRCgAqG7zVjTtU1Z5Zd9cWmZVJCABf0fM5gckFfq/RP
         xsVQUhWSIU4TzdLb2yUhG0Hq06SXgrXC6eL1zEs89gQP5RvySkJJuAWb9M/PMTSkhikZ
         IFhrSxLB9kOmEmMU/lp3Isxr14uNpcWsTY1aVmOSQGCvxUGdZu0JInoKVwH1gnfbb9f/
         RbQSeQUGIZMME4FRYN2IszKupFUCi14MixKbzwDRuPQR4QYNWcqpZ0giqalzLohPcayG
         1ssw==
X-Forwarded-Encrypted: i=1; AFNElJ+Jtapv+1M7zR3kegZxpeM2hok9jfzcudTxOkScmoQdZOyiOm0FRjH2jmWMdT1lcchb0CYicrQkUwvF@vger.kernel.org
X-Gm-Message-State: AOJu0Yyk93e4mQH4O6rMnax7qHn9JM0JVPTqzay1mIGBiFFhzTfSI+3n
	sBBN5pe8HJmTxJ1xUUM4rMnKL2SYXmMTtvpA+JXrI2ZqG2nIqyKEY5oJm4Xbc+Y=
X-Gm-Gg: AeBDiesiEAOeDNaguDYn+1Pls0Y/Jzsqg5r0hISpsRMCfncSidTATm5ekxSlhbDMKJX
	hF2tFY1JaotxCgiSlVQtMo7edN9EHudREBnhb1RI8cFLG+WRbpZ10n3zLiall05OwCIxkdcBr54
	sGJit/Wcibpyx84nvKO2MxFxiVfos0GdIWzebXyXCcQ7G6HvGYwoEVgSp/LK+EK8FETrqOPtrRP
	4ExZcVmVoiODT1RaagzVh4ybMOsmCcPow03FFVWQnKZhXqT8aQm5sKXDREZWVwTnL25MunZqRiR
	yQ2ux4IyvaktxGbFDp3VpSl9ezh7mMZU7VJTH+z87NeSBjK19B8UejWl/9ZDjkulLDeA22hRQci
	lTezhzQTwpjVC3ymBeCLmmTPH6xWEWkTM3BMZMionCb1YZQqghBTJcP4nFJaW3fiBvcUm3GibYy
	TxcElwLbfaJgpIggc9
X-Received: by 2002:a05:6000:1446:b0:43d:73d4:b2f with SMTP id ffacd0b85a97d-43fe3e11634mr6425771f8f.39.1776454399246;
        Fri, 17 Apr 2026 12:33:19 -0700 (PDT)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e4daf2sm6341754f8f.33.2026.04.17.12.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 12:33:18 -0700 (PDT)
From: Tristan Madani <tristmd@gmail.com>
X-Google-Original-From: Tristan Madani <tristan@talencesecurity.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH v2] ksmbd: fix out-of-bounds write in smb2_get_ea() EA alignment
Date: Fri, 17 Apr 2026 19:33:17 +0000
Message-ID: <20260417193317.315698-1-tristan@talencesecurity.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260417192036.268452-1-tristan@talencesecurity.com>
References: <20260417192036.268452-1-tristan@talencesecurity.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_get_ea() applies 4-byte alignment padding via memset() after
writing each EA entry. The bounds check on buf_free_len is performed
before the value memcpy, but the alignment memset fires unconditionally
afterward with no check on remaining space.

When the EA value exactly fills the remaining buffer (buf_free_len == 0
after value subtraction), the alignment memset writes 1-3 NUL bytes
past the buf_free_len boundary. In compound requests where the response
buffer is shared across commands, the first command (e.g., READ) can
consume most of the buffer, leaving a tight remainder for the QUERY_INFO
EA response. The alignment memset then overwrites past the physical
kvmalloc allocation into adjacent kernel heap memory.

Add a bounds check before the alignment memset to ensure buf_free_len
can accommodate the padding bytes.

This is the same bug pattern fixed by commit beef2634f81f ("ksmbd: fix
potencial OOB in get_file_all_info() for compound requests") and
commit fda9522ed6af ("ksmbd: fix OOB write in QUERY_INFO for compound
requests"), both of which added bounds checks before unconditional
writes in QUERY_INFO response handlers.

Cc: stable@vger.kernel.org
Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
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

