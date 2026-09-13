Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080F62E7185
	for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 23:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789342094; cv=none; b=uVq5pCeehZjGHvPUuiGIXU2F9g++ahNDCumHnuiAoRl6zlvYt7uUNKipwMf9ubMgQ9TAbBWlagN5u4aqq0jW7lwMUuCYS5X/ueHGbJirwTiBYervhKTpAQpROODZH3K0sMYnQoYAILc0V44VyeWjvJfdGc+0+dqgM+XbowVQfxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789342094; c=relaxed/simple;
	bh=L+RT9XCjgibOde1ozhn5xwevT5mB6jEMdwviiqbOuA0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n5FmlLW5rFInnBRX60Z5vAPTvPf4sXcjjppXay7yrKQbr3Zi1mHH8qkqcAl4NbP+55Qh/9n9Y2xLovnhJ15OaQDbhtfcYRyU/dANWtuHiWHeocCqQx+XvIcVZjRMrdeTATz/NKDtZS0hZYKJjqSkitdlR39eR4rqFPl7lsNTL54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lLwSp1hC; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lLwSp1hC"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e7355e411so8583155e9.1
        for <linux-cifs@vger.kernel.org>; Sun, 13 Sep 2026 16:28:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789342091; x=1789946891; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NWPJT/v098+Xtj/w3ehTrZhw5D6BrCdKPhwCfHniK6s=;
        b=lLwSp1hCVOuksgPjmcmHFCaPl2M+o3tAdEUinUY2FnyMh/miYrjkUhmL+K6lZ2pkmu
         ixJvvJ6XX8wQxgxgLIIVPZ0FE1NKVQS0ea+4f6ohAZkCtw8dA80njsfh6pftSjIeoI3N
         9idctF5iiOIr9ae2zkjCn026DcRjE8Bt8NEJ2MrNDlvbQrIEVvbZJy+ubUKBYebuEN3u
         PnyK1dzSAiWF9IaS4Mo1DRhdd8SzrBkkVPBYDZyhjlK5dTwjCrX24Tv3WU0Bhe81TLz0
         O0d1iZEo8ZfjovB5mHprYRypyicIXkK9E8YLdveNwMSLeYBIt8mdudtbVM/ESRih3DdA
         H5Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789342091; x=1789946891;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NWPJT/v098+Xtj/w3ehTrZhw5D6BrCdKPhwCfHniK6s=;
        b=DFfgBNi46pkpu343qxo4TP7Ctj6pq6qh99+AcPm3q5sLOE7ME1AZhsReWc3PsUd5Kt
         wRqk/sjcETIsx1tfaWFbyP618C47QgSEywe+8UAhOaWfAg8cvDMsHBEyS2HlKKtVkqK0
         g37sqxCfiSzL8Nc1JEafYgfKGhOh373GDxzBisxSDE/MZtxihuou/jsCi852L2eAwiIJ
         7UAUyDsTcC+eURLnK4MfvhkRrmnDyofyOL0Aoku0FVTLNaN6ooBmhRGWkUck97YAFyqp
         p7It8E/GWyR+B6Z8jevIyQgbZ2wr+giG9TQsFp87UprwRFaqQuPmP1CWE5E1UTnJVstQ
         BUqw==
X-Forwarded-Encrypted: i=1; AKwUvByCV9H2TVlM3LyTk/8zNS9soXux4DK4Yshd3Slmr5ymW+BuPMphsWpcy80OK8dVRxxaQ+xjwR3juiid@vger.kernel.org
X-Gm-Message-State: AFuF++mDLJb24Bg1VfDvjXLS7RGWo7QI6ZHFikvh+vhPOswMqR/lV324
	QgxGa7LqKmai8Xyaq9m+ciGGmMbxHrqrbVRT921Kta9vG2L3DEBTvVXVh/QPFg==
X-Gm-Gg: AYBFou21iVMTqJZ706IOYw2Xw5NFA8ORAMZG2c1p3qSyv24awsjaRoZAWkgNXYUNQyn
	FQBS0ZsaTMWJJUCVVTM96tdNkAJrBaMPM4v8uWUQ1vNTNR/DTaNvyqlqeyLOuUYIskkR+r3BD0U
	38R5xiWQpFVefuT5I822SKUDJeee9rI0wp4o/qN57aMNlO1Wrm/I3r8RIV0bcpGrlhu2QK2RphC
	nbhEcTum+ooK4qkz0Kf3xfy8debrqmBI7OqFk9iq2OSspmef60pP+rSYfV10eOgyarmaeGFDABT
	FtYfM/UcHo+imAaER34Bl7v3ysuMevVyinmd7Ozf1G3p+CuX5fsMccdjjmp820tiilvd1yf0YDa
	2ecJz+JSn0KpskXnfFYWkURjNUfIIYdfbQY+/UG2E4T869bFQbpogP/Diofz+Jpz+aIpLyHJBnF
	MA/gJ/8oR7sk/rp3Bfrdq/s2QBcqmthfI2maoM4thTJVy3L1MgfISVPM9BJweD8jz3dAhFw2GZA
	8dsVEW9K4xa3deAfkUuCQ==
X-Received: by 2002:a05:600c:a00d:b0:49e:663c:c69f with SMTP id 5b1f17b1804b1-49e7a686db5mr2210355e9.15.1789342091007;
        Sun, 13 Sep 2026 16:28:11 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e6499d57bsm396657625e9.3.2026.09.13.16.28.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 13 Sep 2026 16:28:10 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 0/4] ksmbd: stream xattr and procfs fixes
Date: Mon, 14 Sep 2026 01:26:34 +0200
Message-ID: <20260913232737.51704-1-g.blivet@me.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

Four independent fixes.

Patches 1 and 2 are named stream bugs: renaming a stream produced an
empty target, and stream enumeration sized each stream with a
case-insensitive lookup, so two streams differing only in case reported
each other's size.

Patch 3 corrects the header of the AFP_AfpInfo xattr ksmbd synthesizes
on Time Machine shares.

Patch 4 fixes the procfs listings printing a native IPv6 client address
as a bogus IPv4 address.

Gael Blivet (4):
  ksmbd: copy stream content when renaming to a new stream name
  ksmbd: look up stream size by exact xattr name
  ksmbd: fix AFP_AfpInfo header fields in synthesized xattr
  ksmbd: print IPv6 client addresses correctly in procfs

 fs/smb/server/connection.c        |  2 +-
 fs/smb/server/connection.h        |  3 ++
 fs/smb/server/mgmt/user_session.c |  4 +--
 fs/smb/server/smb2pdu.c           | 53 ++++++++++++++++++++-----------
 fs/smb/server/transport_tcp.c     |  1 +
 fs/smb/server/vfs.c               | 10 +++---
 fs/smb/server/vfs.h               |  5 +++
 7 files changed, 52 insertions(+), 26 deletions(-)

-- 
2.53.0

