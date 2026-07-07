Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED0B3DA7F8
	for <linux-cifs@vger.kernel.org>; Tue,  7 Jul 2026 10:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783418480; cv=none; b=tugGqJVM46ZDHvAJBKb7bcLQPXcq8/YGLQ4ueDYP9PWa5pGULrHrTgZVwZy14Ch+m0CTsgaICdWIJY6ehEYMgKUcqF9K0TNQFLa0H+if4nR+hfZkOCPumHHfCp9T2wuluu6BXgTSRNhJMRT5jmCN9W8Q9fK+/eL0keTtQy5isDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783418480; c=relaxed/simple;
	bh=zoDOdnC9CPcr2MajpBgRCHjXCmaHQWPV+5gZtoqxJpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tkZKQtHhjUnSu7apP5mQXE4QCd037OjhEkfISeGUSUHjgXeUMykgXbWBai8NMxnQCvciYO3a99SBy9AYCShywZXxXcimLg5V9pLYQTm5Px7ktOhv6FDRBPe+eqiX9WcFBDkvI13gSdoxE3+kY60/noIXXxomclYGYEWYapUDVMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xk7TZGUj; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xk7TZGUj"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-4720f3bf164so269266f8f.1
        for <linux-cifs@vger.kernel.org>; Tue, 07 Jul 2026 03:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783418477; x=1784023277; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TwwSUqtLPZM119JzlJ2E0sodYVIhvvVH90LrNbMrb/A=;
        b=Xk7TZGUj336brKXsIoW1oflaWaIu0F/MJhtoc4/KYt7f8rDWZrzwoHVXQmve0d9Zhj
         qFP9jg66fsh5fsgyT6mDGCrSiwErwrY7L1UE3YsO42vsem8X/PAzfwWBhh+Am984JwfX
         eIUWW/qpiYsK6gHdPabSBBFvPpotm13rOA+PV/hcdxOrMfHR48Elo6rAKWp3mC3Pcwvr
         EdurGR4yw8zJSNr4tCKZmHlXROlDAq12B3Y+PXIjaE/oCwNykMbmyxnn+ubjEcWOU87K
         Kqyaz5TLDTSt2860zR5FIWdd65t/L3UfUvG040p/wQ7r5PN4tG6RFMR3FA0Glt2C4hJM
         HZ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783418477; x=1784023277;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TwwSUqtLPZM119JzlJ2E0sodYVIhvvVH90LrNbMrb/A=;
        b=M6fFp2/fVekeqBBJoL+DbpBjoNj+VOZILK+OSWgwiOPf15Fsz3c3TP4R2dGujQ6qjX
         Blv21agTCpAIocPWMsJ7QAfYxJVk9wA09oLF70BH0YxCIWOSYbj8aZ4tlROd7xOXNjN7
         TNrdeTk6/NiW6Ng2FW2ch64ldbpEMPJunV5uxK6Le+Fzr793EJAiVgATDvUx2vQ7T1Fh
         jY8cikXc+EMgrgg5HllzKdgyeuGoajSZdd592OCuGSho9NYIiMsNE9XLy8DIAdTE6+UU
         lX+Gg24hd7hF5Mrh3mp9OrPEB1BQS5I1VK5p0bVAfXK+srEt5CTBlfMgwii4IPONbkWt
         UU1Q==
X-Forwarded-Encrypted: i=1; AHgh+RqNIO/u8pIPEib+sxnNyPX8vA2vaIhzPZ+v4qoiB5d/oBNfUOqt18LwqBzWAqeUhjrQLJ4Wvma08zFv@vger.kernel.org
X-Gm-Message-State: AOJu0YyHQZh1XyMjq1B/gTDW6ELYWGt5v8C4KeQtf4fjgHhwFjPYyqQ2
	ncamjEPIyPGAoVTXifNf1TsNogYNqFTguZaukmhQxBGt36O1bO1hozMG
X-Gm-Gg: AfdE7clsGlkLLiwfwoH1U5AOdH01PvpDx817UDVqTdEEotLix4ILOZTY2DtzEZRNPAx
	4UjoPVOeWB2ebVDCTMPcrRIBtH/Ec6ip+/rMTE6dcT1NWz+2NAEU6HKfHNKL9pcsXIQf4hJlLU2
	qp4vFfxUmrnaQuaURspT+zM6aIg5looTdr9yEyP7S9foFcxchdo2h1TTStGqgJ18x/AXhaeUmdF
	UlXIk7y+B17ocVrpF9V+1lY98ayHOdGKBshhF8U9AUulYdphDI3SXQRyBrQ5VoOfUtZavlKxfnn
	G/VQTg92bL8KPA1czrg7EX71H0GXMv9Kh2DlcRmUgbhvcIhDP2fmGskIMu6i6HsfXRAQLlDgPG8
	0Jr6ATXxrLpk6sWYPnTuZ+yBDdbRAqdZnB1KXxnYz2uyIShqBf/2h+C9ERD/i3QHoPohepFCXwp
	D2oW1QvZYCDj7dP+euARTlnNt4PCueXR9JAQStLaiWXvKdNQ==
X-Received: by 2002:a05:6000:2c0c:b0:475:f0c2:75b4 with SMTP id ffacd0b85a97d-47de9a447bfmr2305721f8f.31.1783418475804;
        Tue, 07 Jul 2026 03:01:15 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0960634sm33908295f8f.26.2026.07.07.03.01.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 07 Jul 2026 03:01:15 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 1/7] ksmbd: fix off-by-one rejecting minimal COPYCHUNK query-limits request
Date: Tue,  7 Jul 2026 11:55:01 +0200
Message-ID: <20260707100033.47512-2-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260707100033.47512-1-g.blivet@me.com>
References: <20260707100033.47512-1-g.blivet@me.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

The FSCTL_COPYCHUNK/FSCTL_COPYCHUNK_WRITE input length check uses
in_buf_len <= sizeof(struct copychunk_ioctl_req), which rejects a
buffer that is exactly sizeof(struct copychunk_ioctl_req) bytes -- the
minimal, valid request containing only the fixed header with
ChunkCount=0 and no chunk entries, used by clients to query the
server's copy limits before issuing a real copychunk.

Since copychunk_ioctl_req ends in a flexible array member, the correct
minimum is that the buffer covers the fixed header, so use
offsetof(..., Chunks) with '<' instead of '<=' against sizeof(): same
value, but the boundary case is now correctly accepted.

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index e7aa15ab3..39188bb84 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -9314,7 +9314,7 @@ int smb2_ioctl(struct ksmbd_work *work)
 			goto out;
 		}
 
-		if (in_buf_len <= sizeof(struct copychunk_ioctl_req)) {
+		if (in_buf_len < offsetof(struct copychunk_ioctl_req, Chunks)) {
 			ret = -EINVAL;
 			goto out;
 		}
-- 
2.43.0

