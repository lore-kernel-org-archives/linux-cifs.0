Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3FA013B58A
	for <linux-cifs@vger.kernel.org>; Sat, 30 May 2026 00:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780099256; cv=pass; b=OCkOtUuNryCizvZTO8lfrTgkj33m37XAMkjQwKUnF9fk1xNx94utMCDhT0JF1uzXLrfFcugxvLZDP7/LSA3lyHLK8Aq7WsG0abgvPEOnKIzvN3xGp8WjrTXMVQK4v7iS62pSJF19xtF21U/lftLsY1LjHT6NwUdeMdqkJUUKbFw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780099256; c=relaxed/simple;
	bh=33vmJrDltqY+64sPBwD8bMNNYKDzHDaJYDXlYEPpF5E=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=hoAzsMotJClrKdiTyT9qhx0Xvkvs332o5LNS500YtbKghOo37f+l7iVsgI9uS59dkDJN8JPPUX1/J67RJVDJ5w4Fl5hL86+0cI/lAR1gVZI4SY1PW/1RQnX0S+YlH81oqcTRsjHglHFamzyZrBtgSkMIzyM9TBcZm8QcWCLc+BQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h7q3g+VU; arc=pass smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h7q3g+VU"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-8c92737a8d3so94810746d6.1
        for <linux-cifs@vger.kernel.org>; Fri, 29 May 2026 17:00:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780099254; cv=none;
        d=google.com; s=arc-20240605;
        b=iSVzMz1OaL5z7wfoML25QMji3x+tDwtF2Cal1O3rxrku1AvhFp3WiTZt+Zw3qTQMJE
         /e6gxzSu1QZbdptZnC1Kc7rKC++4vpEPnIcAOk3vmKHqJ2rCfLz7uuBZ0tqmkBdpkg91
         /ISvcOcX8f3fWVv2NtcDohj3YE7b7sLitHkY1DuH7r22BXudP8Jj0qGw//ITJAMS/z1Y
         Ik/FiTDiVfrLrwoKClLb8VZKUPPNTl5ucthiIqARDNquK5BMi68amWgLZAmuIlqvoxCi
         W9MGmouzfjpKsf/7Ra1HgbMuaWv/YcWKXfDuXB9NChIZgJRTz2e/poSTDMhKWyku5UPQ
         4T6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=TWGswphD+bZOHCJ11G2jKpBxaoJonw9YVK4kfZSPQEk=;
        fh=aWuwO5lHHlNdJJ5YGVLl+Ie4EaFauyelA/OpB1HwjyY=;
        b=Cb7YxQEAWjrZDU6AWgZIgQQ3wUfiM9qZTtYO8T5HEEtXxVsyC7KrXoh9rPWFtqclrr
         DEQVWdBQs6gNoDZmRjZicXZwAjnYijGDOXUCVGuT/U9Kv6gofrFD94h8H76RqwMS6aVp
         eqLzE1BGvQ7bSUCN80l1v7y57SSfHmQQSw52dKPxUBruBmJfaxK0S9jYt8rJkA69EfJa
         OCCHQErwd4WjT+TJdjtlJxpmSkMOrJRwq8N08NwZK+dO4NObEX7CmQ6303PgzTJW0g9C
         H+if6W64eiwPKGTgBC8FlxSXYo3LXVbmkdgnHJb7O2qo35lOgpXuxzFiI93llHEa6qOj
         D5dw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780099254; x=1780704054; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TWGswphD+bZOHCJ11G2jKpBxaoJonw9YVK4kfZSPQEk=;
        b=h7q3g+VUmR21jpGkNCvs511WFBvv3+A4NBlVl1ergs+epqP9CayYm76gy+ulV6T5qG
         H+u6Zy4HjcTwBfTN3qDLj9FTgPo4J+lRGbILfOoyxe9ayZfGQrFAi7DTdNAU7BVOkQPD
         OVDiSonY5FOo/YQtDRUPVjZ672zlcNsZXmhlNNbhbXcVF+bOiSymOrjacvHptB0tU5Xg
         490yOJZ9XN0eNzWIYYs1VFN71ow7hisO3oV7KiiBlVICJSdNRX/uEcEGRwaw74dHQR9y
         mL5kLXqDQPEMMjGdSN1wChB2+hD1Vg23rp48fkfXU+ikmQUmshfo0ZV8/3RUmgz/dHPa
         9RJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780099254; x=1780704054;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TWGswphD+bZOHCJ11G2jKpBxaoJonw9YVK4kfZSPQEk=;
        b=VhhXIHCeqWrDxjowBlVxvy3ewKm019ESoVZNxjD8M4iV/MijIXiUse3vs3wuiNmGeh
         cXj5Mtw2zJIKQ9UGvZF1lEsy/pu/uR13eFQhsc9y5FxboBlNdkVwpsIn7SaPnlcJxalY
         GojQG2VXweGN4dDD18hW1vQSzxiaXC2MaNmOP0R4on58qI6iESKTTQk2udNnAEwZoOsl
         gQ4Y3e1s/rubo5/9sekgk22HWIDmVs4O4BbKv/UT7huwr11HWP1M8vLGnbDmvQiQ1GSi
         ElXsM3zdE+1faydW6IIrhfu1iR2hUUwiIGME0pV0cwLdMBy9HJS+kvgkLrGposONUPdc
         +Mfg==
X-Forwarded-Encrypted: i=1; AFNElJ/N5uSjAbwiClMRVCCZqICxVjObnKauqCz22IWgJiFA1fWV2awmiFcfvBC+aqYiNO8tsaJ1Htqo90vT@vger.kernel.org
X-Gm-Message-State: AOJu0Yy348s1ciV3L6vdVSQm77YB7mo/d6xvF7xryjVbAQutqhL7rAp8
	hMoaKDPFxdRlHRdq/oaf5MV26xiH6LnRKy2x5bE7Kdxq8z6RwSujF3CNPVXALYqemcA/4eDSuy1
	AkfaAQWlijB8lwrizUWwRZuu9ruJmK++bsnOjD4w=
X-Gm-Gg: Acq92OHt3eE3XklpfD21ce2iwWcdz9BBfbvKphszv5/gJQhYpHKNGU8FMA4dpo9AXFF
	CQGRmG+7x4TXqOLiNJntTF/MAi/pB+s+EmBQcIoT0VZ08egArLzcbtxf2RW0sTOtvUEVVcF14yn
	MA2j+aHREm0oa1bpZgi7eX1m8kQy57X5c4MhUXfX9A/Ng/ba5ugh68DTW6dI3mYRo+aG0BP1LhZ
	yloGlKyDt9cxCCWVa/5hA/R5XAT1CZhpnERA9eur+eCCO6k9IcAymMqophqunExdAbdAFHwYIi9
	ks/+txLaOyGNqN6RIH68Dnksa1msfTARIQTwl/emrGNG3AcrpKej0K9ebBEwZiI4Y86bjAoSfjo
	uhf1nMRwZyBwF0NhIQUO3FjxoZ3Z/xk56B968XPDMkkQC5IZcTSlYM1mK55oO33n429uoysuQl4
	rhVw+cDkG+fBhCwjAWUqeVt3NYJ054qdU=
X-Received: by 2002:a05:6214:5092:b0:8b3:f59b:6c8 with SMTP id
 6a1803df08f44-8ccefdc15admr31393106d6.31.1780099253472; Fri, 29 May 2026
 17:00:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 29 May 2026 19:00:41 -0500
X-Gm-Features: AVHnY4KCOsOZl2s1I7odiC8vXi_au7lWZrkPdfGVZv0TY2DlryNs1lqgHr5XEgE
Message-ID: <CAH2r5muwEzNYv-g_A41PSTFJoOCW6AzBD5U1WCuzTrao8k9xVA@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
e7ae89a0c97ce2b68b0983cd01eda67cf373517d:

  Linux 7.1-rc5 (2026-05-24 13:48:06 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v7.1-rc6-ksmbd-server-fixes

for you to fetch changes up to cc57232cae23c0df91b4a59d0f519141ce9b5b02:

  ksmbd: fix FSCTL permission bypass by adding a permission check for
FSCTL_SET_SPARSE (2026-05-26 20:36:36 -0500)

----------------------------------------------------------------
Three ksmbd server fixes
- security fix for FSCTL_SET_SPARSE
- fix leak in ksmbd_query_inode_status()
- fix OOB read in smb_check_perm_dacl()
----------------------------------------------------------------
Aleksandr Golovnya (1):
      ksmbd: release ksmbd_inode ref via ksmbd_inode_put on lookup paths

Ali Ganiyev (1):
      ksmbd: OOB read regression in smb_check_perm_dacl() ACE-walk loops

Sean Shen (1):
      ksmbd: fix FSCTL permission bypass by adding a permission check
for FSCTL_SET_SPARSE

 fs/smb/server/smb2pdu.c   | 11 +++++++++++
 fs/smb/server/smbacl.c    |  8 ++++----
 fs/smb/server/vfs_cache.c |  6 +++---
 3 files changed, 18 insertions(+), 7 deletions(-)

-- 
Thanks,

Steve
