Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208783C661D
	for <linux-cifs@vger.kernel.org>; Thu,  7 May 2026 16:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778172744; cv=none; b=ecEIYsFFAfvAomOke3mUj8B4TN48WYzNtK4MAokRvIQb35D3E9N9iMXKKtGc+2V/p65IRQzeSgK3kZJpnQJzuW8MvuYjsVnGmGv07prm/jQrAo0fuDCXWK+O+5ORuy4npy1hyG6omZzFOoLaD3/8at/i5NJXYWKP6Dqj0580ATY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778172744; c=relaxed/simple;
	bh=QhvtuPuYuRikxrXlvfGt1GYpisVF2O1XfkkjalC53Gw=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=SchTgqI29oJ+TjKB0/jxOKGWXVaMjMgQ7d+slW0/oJ/pwjSlNzgH6CHig0o9TRsOAAz84QcqiaOGnCIHFbT44n8PeId0O7LLUE8AYaN7Do3AjW/q59LusNBLknkgWfOFKJHsd9ZlFh2u1i6HxYU97wgoJkGySZankaZxmbLIzH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IZ8vnqbX; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IZ8vnqbX"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-36608b2f2dcso628589a91.2
        for <linux-cifs@vger.kernel.org>; Thu, 07 May 2026 09:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778172742; x=1778777542; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gHS86kLfvSZEt6u0DRNxMP3AK+yT0cLfftthW3UK2M0=;
        b=IZ8vnqbX0ySDjCyZnYCi2oTYizpZSy/rVnU90FHeNnXCe/lG4H5VguUR5szRgmVgnn
         hOI55m1zbS7oJMLKoKeD5HQRxElDZgU3TPDjDfdZTgKIWV8d5Ryuj/8k+5YxhxyV5rZi
         kPLSokG9f3YNwpKfrrldIUtgixlmT/8s0FScal0JniyqyrkWd8iTp0I5Z0hd1vZo5txc
         JhP1XByDbBoH3tzyjwpBv+nQW66tIzxjWZ/cMekvkuwQ2saiOdYAWF126Ko3Vv39Kk40
         Gf+ygIXEWk7xdvXlGUPQb9QV972j5vx+b/3DWMPVafy1RM3YIWYaEn9d4ms9O44jEfed
         lERw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778172742; x=1778777542;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gHS86kLfvSZEt6u0DRNxMP3AK+yT0cLfftthW3UK2M0=;
        b=AuGM0MI54Iw+d+E6Tvxwgu937tCBdyJ0KKZkBcLBk6oWiQqvzvpu2R6iaEBS2M1+l1
         0Ncwn+ruZmuVJq/cTRyETcfjyjwn9ynLIUeFI1hX+6vPVyqmve5qYZrfWYq5knnTnJQ3
         Ut0H+DooBNPvXe0mtCfC7TSdHVRdNkQSiV/aOkFJ0OyxVh3GUI/URtX26FV5cKNwWDLb
         f624VixcbdKywiq/Nef2KCwrhizP7HZJA5RpmGzjc6qPPP00XRPQ8SD7ZNwl+E2WvgwL
         R3JTFzIS+tD7U847a7xFoHZItvgKne0pwtsup1MwpdG/XeEy+sElQyn2P2sF+akE2vcw
         jnwQ==
X-Forwarded-Encrypted: i=1; AFNElJ+CaOuU6ncThTm2MDufoeeNFQRgJzVbgHNTsiPrQPrjacu2/Jn17l9Cvs400InhQdbgfw0uqA5fyTDO@vger.kernel.org
X-Gm-Message-State: AOJu0Yydv+bj2SEj9bjkjx64IMN8nqk+1GChKtLaXGELUm/oNWgpd3K6
	unJYFlWr9JAnZRtcgtvqwkcK7AbUEszYJAfQ/KTd/8jJcaSU9Slx7iug
X-Gm-Gg: AeBDies7lMNJSxdWI6pJJ9WIb7pYWK/5zQBUnX2lp4lXqqqwjnfDA6g9NhUAFnLKGmF
	2t14KgWiZHadBt9HG9ksF4vO9yVC4ETqYOkYJLoCmaZeYMHIubvqzM4uNdQFkvtm2oWUnBpgkMk
	LWjJtziCPls2AHq9ke8nQkFebUeGRC9FSv93wtTdTnwrnGrowurF6YQXW9F43OrG+77FtG5rU+p
	L1P05ROn/yIIxr37J2/R2dd+jOq/4iT5/A46JSXk5+7LM0kDLZ/zPTRd9kDTwvDedHol65pauxy
	V1uEb0P969lN7yguA6RO944EPPY5d/blMb8uglSkk+4M4u8NrQTWk1h0KJUyqcJRSF+caCZRzTc
	J3lw2VZACdtbi571u5Ot1fuUT0UjzOIrYEcSkhyleDcbhxvFpu1usqDUeBvV7lUzuisDgV+H0zO
	eBHF4txmS/YwcpmuuKfjYxSZ/MYcYYXgzl+e/Z8hnYH7oOfJCOTg==
X-Received: by 2002:a17:90b:3ecd:b0:366:3517:1a98 with SMTP id 98e67ed59e1d1-36635171b07mr1354381a91.0.1778172742408;
        Thu, 07 May 2026 09:52:22 -0700 (PDT)
Received: from localhost ([49.207.150.30])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-365b4bd67b1sm9638608a91.1.2026.05.07.09.52.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 09:52:21 -0700 (PDT)
From: Piyush Sachdeva <s.piyush1024@gmail.com>
X-Google-Original-From: Piyush Sachdeva <psachdeva@microsoft.com>
Subject: [PATCH v3 0/2] smb: client: Spec-compliance fixes for Kerberos key
 derivation
Date: Thu, 07 May 2026 22:22:12 +0530
Message-Id: <20260507-kerbmi-v3-0-397ebbb53eff@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/zWNQQ6CMBBFr0JmbU0zFQOuvIdhYYepjAZKWiQa0
 rtbUJcvef/9BSIH4QinYoHAs0TxQwazK4C663BjJW1mQI1HfcBaPTjYXlRLuioNtVg7giyPgZ2
 8ttCl+XJ82jvTtK5Xo5M4+fDenmZcvV/U6H90RqWVtnXlGMv8Vp57oeCjd9OefA9NSukDAbn91
 LIAAAA=
X-Change-ID: 20260429-kerbmi-dc0853cd29fc
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org, 
 Shyam Prasad N <sprasad@microsoft.com>, 
 Bharath SM <bharathsm@microsoft.com>, Paulo Alcantara <pc@manguebit.org>, 
 Ronnie Sahlberg <ronniesahlberg@gmail.com>, Tom Talpey <tom@talpey.com>
Cc: samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, vaibsharma@microsoft.com
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3196;
 i=psachdeva@microsoft.com; h=from:subject:message-id;
 bh=QhvtuPuYuRikxrXlvfGt1GYpisVF2O1XfkkjalC53Gw=;
 b=owGbwMvMwCV29FJ3ncRHDT/G02pJDJl/Djt29ets/C4cHbakV6Ptv5ByCLPywWLreA9z4eML9
 KJebz7dMZGFQYyLwVJMkWXDiTuyvPG7JOd9emIEM4eVCWSItEgDAxCwMPDlJuaVGukY6ZlqG+oZ
 GukY6BgzcHEKwFRrTGJkmL5nbW9+q87HpdH5Gr17C1T+v/k2eTlbEKfbJwt7td2rtzEynKn8cSI
 rwac1bWFr6Oy59+Q9pi9UZUgVfyW3hnt6NIc6IwA=
X-Developer-Key: i=psachdeva@microsoft.com; a=openpgp;
 fpr=80350F71F916134953C3EB979E19C6F9839C3CFC

This series fixes two MS-SMB2 section 3.2.5.3 spec violations in the
Kerberos session key handling path of fs/smb/client.

Patch 1/2 (resend of v1 with a small cleanup folded in) fixes the
AES-256 mount failure with sec=krb5: encryption and decryption key
derivation must use Session.FullSessionKey (the full Kerberos session
key, typically 32 bytes for the aes256-cts-hmac-sha1-96 enctype)
instead of Session.SessionKey (the first 16 bytes).

Patch 2/2 closes the related corner case in the same section of the
spec: when the GSS protocol returns a session key shorter than 16
bytes, the buffer must be right-padded with zero bytes. The current
code copies the GSS key verbatim, which causes generate_key() to read
past the end of the allocated buffer and derive keys that do not match
the server. The trigger is deprecated short-key Kerberos enctypes
(e.g. single-DES, 8-byte session key); modern KDCs disable these by
default, so this is a latent issue rather than a reachable one, but it
is still a kernel slab over-read and a literal spec violation.

Verified against Azure Files (AES-256-GCM + Kerberos aes256-cts) which
previously failed to mount with EAGAIN; the dmesg "Session Key" trace
under CONFIG_CIFS_DEBUG_DUMP_KEYS now shows the full 32-byte session
key being used for encryption/decryption KDF input.

Link: https://lore.kernel.org/linux-cifs/20260409161538.3618-1-s.piyush1024@gmail.com/

Changes since v2:
  - Patch 1/2: cast ses->auth_key.len to int when used as field width
    for "%*ph" in the CONFIG_CIFS_DEBUG_DUMP_KEYS dump, fixing a
    -Wformat warning. Reported by Sashiko.

Changes since v1:
  - Patch 1/2: initialize full_key_size at declaration to silence
    -Wmaybe-uninitialized on some toolchains, and drop the now-
    redundant else branch (self-review).
  - Patch 1/2: tighten the FullSessionKey condition to also require
    Connection.Dialect == "3.1.1", matching MS-SMB2 3.2.5.3.1 verbatim.
  - New patch 2/2: zero-pad short GSS session keys per MS-SMB2 3.2.5.3,
    eliminating a latent slab over-read in generate_key().

Signed-off-by: Piyush Sachdeva <psachdeva@microsoft.com>
Signed-off-by: Piyush Sachdeva <s.piyush1024@gmail.com>
---
To: Steve French <sfrench@samba.org>
To: Paulo Alcantara <pc@manguebit.org>
To: Ronnie Sahlberg <ronniesahlberg@gmail.com>
To: Shyam Prasad N <sprasad@microsoft.com>
To: Tom Talpey <tom@talpey.com>
To: Bharath SM <bharathsm@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: stable@vger.kernel.org
Cc: samba-technical@lists.samba.org
Cc: linux-kernel@vger.kernel.org
Cc: vaibsharma@microsoft.com

---
Piyush Sachdeva (2):
      smb: client: Use FullSessionKey for AES-256 encryption key derivation
      smb: client: Zero-pad short GSS session keys per MS-SMB2

 fs/smb/client/ioctl.c         |  2 +-
 fs/smb/client/smb2pdu.c       | 23 ++++++++++++++++++-----
 fs/smb/client/smb2transport.c | 35 ++++++++++++++++++++++++++---------
 3 files changed, 45 insertions(+), 15 deletions(-)
---
base-commit: 0cbc300257d9b399491909806777f504ec687c1d
change-id: 20260429-kerbmi-dc0853cd29fc

Best regards,
--  
Piyush Sachdeva <s.piyush1024@gmail.com>

