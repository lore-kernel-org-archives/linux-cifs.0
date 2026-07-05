Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83EA37A488
	for <linux-cifs@vger.kernel.org>; Sun,  5 Jul 2026 11:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783251587; cv=none; b=M2hNJTfrRuYHSneBHpu0RJxfuyVbhJtm+IUBCPhfcgS+PRtspawruzRRvZQrjazeCs26jBC4mcZHmRzrDRIG8Oms8C5WS1au3iJ+RqXmpqDICa2u6nUCn5dZot4WGTg25lNW/jJ8OSKAGH3yD8bty3fjcROd49cV52odC1cxiNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783251587; c=relaxed/simple;
	bh=9ICYpiA46kjXs78rxuz0wi8yUagGKStx26/jKAnvMb0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JAVnTzW/n3AUH1WrPSLHmNIsz8HkVSgzQepgbQdhXLIGkqDCUed47B2/Q2HAQYrpXCOF57TcO4y/Un0frtXrCCaOoEeRHuD0lPwsXlNbylt+imr3u+ZTDxuQErq8rQYfdIiJEbmrGQq1nI1VNeZztW0c7//oNvSVf6feB0Nb8qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EA+uAef4; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EA+uAef4"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2caced6038eso20647245ad.0
        for <linux-cifs@vger.kernel.org>; Sun, 05 Jul 2026 04:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783251586; x=1783856386; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7sHrKicVLK04idB7o9GQy999YKtMdUDkeXXte4a2Qcc=;
        b=EA+uAef46y2m4ivWIsIJTCD7ZMVZh5mjI9hArt304umukoptskDUAJPxi2VCtyJQYj
         4WmISG+QtDEEykngcT4LjhDF3R881BgQ/jL9Dsm9ynaQ8P1UIc63EyMwyeMEkfadKMmv
         aBuyLHAFtMA2tSGIhUEq7lm6iAFndplz1982j83EdlQcFMN+q+2sFmQxfa5pv7jku7mj
         DIEPHGQwMy1QukmaJyMy8XrXBgOPurB6vyvWy7jjA67dsmh6G6d1bflS2R6Uy5VfSh1w
         OUTOMcv4Na0w1hko+3fcvvoftu+XyWLNNetBa3uIx/Tc9vbtkhDIF18fL0RoB/PiH7Pk
         o7Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783251586; x=1783856386;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7sHrKicVLK04idB7o9GQy999YKtMdUDkeXXte4a2Qcc=;
        b=EmdUbi9QWNEngScp5wk4WhlJRlAktrHyyJdNhzEfqkNYr+/Znw43eVRdxrpSRXO/1E
         wlpuVydQkLuh11wYqjrgXpvVb+Aj4p/DVPtEuY0kX7d0woIlb78yxj/stdj02c+fEwBu
         t4DcrJcWMVO8mdMCLV1CoRTiwD+eFkHocA2fHIgHwHfhEvc0Yfakv2NBIRPhd9T+pz1r
         WLAAaz5vXT/Nl7Y+CFUpZ/QwD1Tnk50CzAtHD0TB+lG0aNF9L7K2wb2LMzR7yE9/iRNs
         8ff5Tkp6hzcJdqXnHgtynhT++UcLyx8Zhx9l8Hp0UjWDRF3bL46erI+2p6wQ3+JsFfPh
         ru3w==
X-Forwarded-Encrypted: i=1; AHgh+RrMyjBFPE/mIxpFFz7jEHGuCepBErWmDRIrV6GsTHrvwm+Skp+8nB+c04OxPF3hJoL4QQM39NakWGE0@vger.kernel.org
X-Gm-Message-State: AOJu0YwTGC4ivrYeyBjiivb80AFGuA89vsoYLiaYqlB4kKK0eX06DutP
	btvfGh3aQ3ZjEf7A0Y8nOxmwBMyHUN8pYENUNzjXUBfI5JjIm1sUGvvt
X-Gm-Gg: AfdE7cluuIb2b7Ehk04QVsSrvgxSmiTuAcjVqu8/rTQvhQAl1kuADBorqVLKK1NGe0Z
	PvbX5kcIPNwDTEkb3Y4dyohFapDhQAMY6FBj7Wk1aIH3t4CoEb0ZJom2Kr92jwxaU83CaD7O6U7
	8AbRz7n4lKrr8BCaDK4Z6pXLpdGWu72H9N3RBFjHRqnAchVLM3nqkwkN9VDNEghKqCzUKC+fekl
	5Yh4fDxiaFiiXyOaE9V2Spxjija5kQZ3JttgEoK/oZ1W3LfZwJOprdYWlHWFOH+gIIzAJ3sWeS+
	4EGjgWP0Uld9BDERvTKFiDSIFrw3dFt062TG4okWnkcmSZn3tIbBG4Mm3m4ne5xs6qnHIWY3fMs
	EeY6Il3EzntCQ0cB1mFMBfKGEGt15p07L6GOPH6fklhLX1YbJ2Rr0h9yfipi3+0Z5APoQLuc=
X-Received: by 2002:a17:903:1aec:b0:2ca:53f7:3c69 with SMTP id d9443c01a7336-2cacacc0323mr94654545ad.9.1783251586030;
        Sun, 05 Jul 2026 04:39:46 -0700 (PDT)
Received: from lgs.. ([2001:250:5800:1000::f280])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad6bd7611sm33338065ad.0.2026.07.05.04.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2026 04:39:45 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	Qianchang Zhao <pioooooooooip@gmail.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH] ksmbd: Do not skip lock checks for single-byte ranges
Date: Sun,  5 Jul 2026 19:34:35 +0800
Message-ID: <20260705113435.285715-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

check_lock_range() uses inclusive ranges. Its callers pass the end
offset as start + length - 1, so start == end represents a valid
single-byte range rather than an empty range.

The start == end shortcut therefore skips mandatory byte-range lock
checks for one-byte reads, writes, copychunk operations and one-byte
truncate ranges. A conflicting lock covering that byte is not checked
and the operation is allowed to proceed.

Remove the shortcut. The truncate size == inode->i_size case is already
handled by only calling check_lock_range() when the new size differs
from the current file size.

Fixes: 5d510ac31626 ("ksmbd: skip lock-range check on equal size to avoid size==0 underflow")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 fs/smb/server/vfs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index f5fa22d87603..9605a25c93b1 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -297,9 +297,6 @@ static int check_lock_range(struct file *filp, loff_t start, loff_t end,
 	struct file_lock_context *ctx = locks_inode_context(file_inode(filp));
 	int error = 0;
 
-	if (start == end)
-		return 0;
-
 	if (!ctx || list_empty_careful(&ctx->flc_posix))
 		return 0;
 
-- 
2.43.0

