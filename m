Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9362D26E71F
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 23:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783639689; cv=pass; b=WOUXUI7n6hrznfdiPH3z1IrI1BEM5vryyELKMGae7ICuB/c+m4HcKvFMOjHvMioAg/Bq1qbkxCZJXlhx0N2JZ5B1iQbMvhhvOqky558WFcx1jdKBazdUTzkZz/9Lu3SgFE8oJAjqJH9FJbLZpNYchqgxuAABSNX2yyxwBWZsaa8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783639689; c=relaxed/simple;
	bh=DMxQSJOfZvRUQV4rNAFKsDLNaBqTmLDuQVWoPgiaqP0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=gXOWKtmVM/ZmkZcJWRggwAWd0mvgB70H7YQ22VZ3gl6whVP0Ey2/961kpGHy462e5DHxgkHSci6gUQvOR1qbsZNbiVCm6PnyquPT1wqyUvXR/Yb+vGxivBm0On/g3/mTZzWT8VjFl4srnNUW9Ljg0q7tDmkWZQj300hme2iCtPU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OhCXC96h; arc=pass smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OhCXC96h"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8eeb4508f29so3333226d6.0
        for <linux-cifs@vger.kernel.org>; Thu, 09 Jul 2026 16:28:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783639686; cv=none;
        d=google.com; s=arc-20260327;
        b=eyxT26/WxKCLuHay+VwTiqQ+bMKO4meGs9SC/JaF7Zgm2OWcODXOeF+EVmHetOyQWD
         9eQJ2oHA3XC8sKK16TjPM8bwXfrWH2u5Tu1sIWZe56XUmbRQkVKZjYBtegqiKcuczcmj
         8spDcOGdzSFFHGBPcko2gokput4zP6CyXXsB6zfbIfZJj7Xn62KHkZcheNAW+fvnUKIX
         X8c9y1eOWaJQL8xdNORheUqGcEs8VX0VwS+lAbUTWj3k5cCeNW0dC8XT9RTvH98tvv4g
         tBXZqDZwZpSLd+awLx+EC9vppQuh9pBQrpl6LClYyRIoBY4NLt5MpvAFa8ZslkrNHrZI
         xsQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=8kNlCR9tmsOWmOq+doWWUrLta1QpUzmaAQPYdfT7rAE=;
        fh=TJL+rVN8QRfVv8fdH57A5I9Enf5FIGg1hnib5S2Ddu0=;
        b=LI5AolM3DPs8bpRC7TLTw9YyuS1QyqVLmkQ6coD0Ed4fB10urjVdSrh6Ipuwxy/Lm6
         0vgc/zZMNfQFQn1NfhNMOooeANPKjpYgbadRTGDlqPqC7nUtjpB8M6ZIFJfHHo7Qlkpn
         FDj7Kwm/vXMQtAKMVqd8NeOJy/IwvL9rMpIzOi+G2sIS50LzvjkOVFcF6BGOhySonp45
         Y74nVteat/C57X2MJlbTgOqPbrIJPIO8PUKii6OFzjloDefBc6+FVZb+VS4jN8IoFOi3
         neOZAt00yK01sqfbWphNFNsPT0tkfk740ebcJ3oive9s3/GtG4SO4R54rS9gdlMazmrg
         cc/Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783639686; x=1784244486; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8kNlCR9tmsOWmOq+doWWUrLta1QpUzmaAQPYdfT7rAE=;
        b=OhCXC96hHj9AkdZRYfaSQl8OoxtynHB7/K+tp9IDo4/xop0XcqTSw45eZ4+mCu+SEt
         KVHff+m7L8IeZvl3wiruG2vHKjKS+o43Cfj+ayfTkmuoJ9wrlcu/gHgcsdMchNKoweYK
         5j+rerAHPq4i9uEiwy4ABPoGBGjMhdPB4g4SqTCR8d5hTjrMo+/Sjn0VD9d5Hc8GGmTP
         0b7NBybSHG5H9AMbQZKV7kYAjEl8h5vaLx6nQE0MYNcot6Y2ZG1a9I9ocFApIe3u1323
         j3tmTJuxEYc4imQqo6tBu45CvUL19rQD1t99fOILEUqTa27aYH9B28AGALon4BUiaEOk
         CbOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783639686; x=1784244486;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8kNlCR9tmsOWmOq+doWWUrLta1QpUzmaAQPYdfT7rAE=;
        b=Syggeq1Xvb8Da+l76NbHnFLKA4W3F3clySZpVaQoBzHo7MU7iFyANDyvZ988F6KMmW
         XImasyY3qtlhsf5g5KN3jQUiLQ9Hjz6Cet/+eUn8ADwHmBQrGIZ/UBMN0Cxfjla9uKG4
         9FpxdGe2qDHrW1HlYneuCgUgEa9gxJrUVD46eaSV0d64G3aBwoProXaGE9tIkGL22JxN
         O7rFtcVkXz7/QBXSefTumVQUjyUlBLtMAaULjNmwra4JZmVm2HZWGAhE6z+ILHuWPJuP
         rU+s8ae7Ca1ldvBL+C40/YP/E0WYEN0F2J+bS6mZ09qKmXnkd4aogtGvj0SoVjZGSXSp
         4RzQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp+jQR1jpZkdSVzs43HPR0/sfBtZs8jezciatId5b11G6T9R3jgy2UJMxhcgPFnbiVI6pw/bZ1JVMZO@vger.kernel.org
X-Gm-Message-State: AOJu0YxFfCzZkD2qTJipshBnTQ4Y3NF0dKnthINfJLs9Pl4GK+h5Kn6c
	YYnb8ui19Tg1LbNsfXhd5MBV3gC0YM5ZSQnbwBMD2EdQ7F97uS36zfRilMGP8s7y09MVAdANVPp
	4P3PwuYlf9KujHupUsDCBC+X9BpoCqUqmw0NBxn8=
X-Gm-Gg: AfdE7ckZ5ZoyD7dhgrtMIzeCgJwvrCRh3eTnl4mv3lke1oBGvQIGMOeiRI3dJQeb0y0
	CV6FaiZREhRKhgyj+NfjajK4aHPLUICJpT2PhqTNVI8ai6xWGp3zEwixDh/EtwpRcTsjZshyLS9
	wJ7eaY9lYVj5rtZxzXltsmv/YVtj+8XJXgGUtshpN0UQI0uNb9UhlqgV9HDHlGn61D+GPAbNdfP
	SGCxeki7HFJnDgaQmWH8lRgAXlVs9q4fSDLkKt+S9CfyPZgjmucH82XCtDhTBa+So3zbMrhUSWs
	leu/ok682dhhCsTwsJLGF5ACgpcyEiWnjnCVBPrO5CJ21pWHaIY7zgq1jWnUM3K+4nYRYGImbfw
	VY6VldIJgXNvbiwENAIViefa7f0jklIobtHMcXfO8Df0okRU/meldFPpIyE/6JMytJAF1euSHek
	TB3g75IVH7Jw==
X-Received: by 2002:a05:6214:e8f:b0:8dd:69a7:d60 with SMTP id
 6a1803df08f44-8febd5f96bbmr103802136d6.0.1783639686529; Thu, 09 Jul 2026
 16:28:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 9 Jul 2026 18:27:55 -0500
X-Gm-Features: AUfX_mxnY_dlXIrTbNxIvWtpE5zl81B1TlG-l1bJv_M0QOMqXKmX8zXEa1ZAjZk
Message-ID: <CAH2r5muX5fYTtxMvj9DrdMmMEU2Oi+_nk2oK0zH+J4fRctrJLQ@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
8cdeaa50eae8dad34885515f62559ee83e7e8dda:

  Linux 7.2-rc2 (2026-07-05 14:44:06 -1000)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v7.2-rc2-smb3-server-fixes

for you to fetch changes up to f49bca41c12f9f79d39dbf0779d0c672d74b09fe:

  ksmbd: use the session dialect for rejected binding signatures
(2026-07-06 07:55:41 -0500)

----------------------------------------------------------------
This contains a set of ten SMB server fixes mostly around session setup,
multichannel/session binding, and protocol-compatible error reporting.

- Fix SID-to-id mapping so only SIDs with a valid local Unix representation
  are translated, while preserving other Windows SIDs in NT ACL xattrs.
- Fix SMB3 multichannel binding across multi-round authentication, keep the
  derived channel key separate from the established session key, and enforce
  the 32-channel session limit.
- Match Windows-compatible close timestamp behavior by coalescing automatic
  write time updates smaller than 15ms.
- Return STATUS_DISK_FULL for SET_INFO allocation failures caused by
 ENOSPC or EFBIG.
- Fix several signed SESSION_SETUP error paths so clients see the intended
  server status instead of replacing it with STATUS_ACCESS_DENIED.
- Fix reauthentication on bound channels and reject different-user channel
  binding with STATUS_ACCESS_DENIED.
- Use the referenced session dialect/signing algorithm when validating and
  signing rejected cross-dialect binding requests.
----------------------------------------------------------------
Huiwen He (1):
      smb/server: map SET_INFO ENOSPC to disk full

Namjae Jeon (9):
      ksmbd: validate SID namespace before mapping IDs
      ksmbd: fix multichannel binding and enforce channel limit
      ksmbd: coalesce sub-15ms write time updates on close
      ksmbd: mark invalid session responses as signed
      ksmbd: find bound sessions during reauthentication
      ksmbd: handle channel binding with a different user
      ksmbd: sign rejected SMB2.1 session binding responses
      ksmbd: mark rejected cross-dialect bindings as signed
      ksmbd: use the session dialect for rejected binding signatures

 fs/smb/server/auth.c              |  49 +++++----
 fs/smb/server/auth.h              |   7 +-
 fs/smb/server/mgmt/user_session.c |   4 +-
 fs/smb/server/mgmt/user_session.h |   1 +
 fs/smb/server/server.c            |  16 ++-
 fs/smb/server/smb2pdu.c           | 205 ++++++++++++++++++++++++++++----------
 fs/smb/server/smbacl.c            |  21 +++-
 fs/smb/server/vfs_cache.h         |   1 +
 8 files changed, 218 insertions(+), 86 deletions(-)

-- 
Thanks,

Steve
