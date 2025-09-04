Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4498819AD8B;
	Thu,  4 Sep 2025 02:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756954007; cv=none; b=phL4EY5WLA6RrPokFF5cC07+D423IWtY8MuL3xjZCuz8kSWMyu0zZbR7+dzRp4iUL5Qg35x8otcyBpfcfr/xIn0bMC/zq9daaq5JoYhcV/hStFc0JUvZGBRmfVVU9itMCThpuq7JOmayq+j72fO7oFM7xpgcTzi7ateXnQ5H47g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756954007; c=relaxed/simple;
	bh=TFZJyppGpgM785beXgOJE2uko5s++996WRpRlm49wlU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=XAsZyBFgBvmCyJYNOA5gMQ0Hjd5g0b2JauD5ivtwX3eSyTC0z3RT9qEVMpjnOk4GJ3lyJ+4G2U9a52tqdG9Al/8SSJgiwUiS5eUy2Njy25obhGJutXI/t6GJoNNxRdSU1KK+srnduhBg4icBbI76uQEAKuhy9RWf/hpuWiqS1PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dEx4GWbu; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dEx4GWbu"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-7209bd264f0so18755746d6.1;
        Wed, 03 Sep 2025 19:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756954005; x=1757558805; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3IhbpWeMVcBjFY/vJMFt8gcYgr0JiVin6Pv1b6AVKHA=;
        b=dEx4GWbu+ddfX2BmAeafY0aN34DC7vzvNQwGeoepNbeqtptt0/ozRu/6L6kdDwSg8y
         gDgZEsgFVwLxXVHctWVx7vWn1ie0CU34ArZxtuiFMss3bAYzNz1WLrB5Ds4NO8/NVos1
         k7sshqFiLb2F4f66ue1LcQcR6Ln4/FDlTeLF5NxC/Xr6kTvIzoCTA+gKo15QIMG3EEFN
         UgL+J0Qb9QZhhKSnX924zkR7OaLEwGYGsXb8Nh8G+oFZYEV52tcmm5mdOV+Fz3WSMukz
         /8+X83/WMwE8ttORJfTtEKCqXHKA8Eo4nZ9ctAkj+nwYdHnIiOxZGNeX/ro8YeDu/190
         bTWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756954005; x=1757558805;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3IhbpWeMVcBjFY/vJMFt8gcYgr0JiVin6Pv1b6AVKHA=;
        b=Hf53wS2FBe27lMGuXIZsM2mw9JLz+NirUOs4IJT6s4n4B5zUkJQ48sK81dYOIvaZyK
         7n/k1VdlT9iD2/SVK111tkNw+9OT3vmRiZiWuhV6H5Zcy0gzM2DZZPZGzlqcmUEJYCyH
         miqer3peW5M05+ZGz+zNdvzPiyJOeu0R9PxfhldsCig31hXhQfGrj3fybokIOhAXsHOd
         jv6q6JhJOxfV3OPRdYSLTfHH8d10hmK8MLIKZYZQNhC3BLjLJPUMdI5jlFUbb/wVqF2e
         npgFgyIazmAokG4J13m3gK2xqL3TA/+wCSHOEV2WQ0yaA0ZSF9RHm18EZT2ryFe46iOV
         lXVg==
X-Forwarded-Encrypted: i=1; AJvYcCW1XfrFHS6UYdN+pOjrkSBLiQDrorU/5yopjE0myQO16eR4UHLxLUOWiozr0lShNrQrvfFhMc/TW5hNwh/2@vger.kernel.org, AJvYcCWs29XRIOqXXiWSXREXY21h6c/mGYHSfol4s2M2JGTiXxbfhN/SZmeh/veUF/5E8Pc/0AlS4wtonLCU@vger.kernel.org
X-Gm-Message-State: AOJu0YxOwxKLkGMQkuHL/vm0cB4THG/2VANxBrfn0sM9W5Pvin8ArR7E
	/SGf4N1wdK6EXWmkyXGTWIPMwNeNAQgtPQevAovwia2Lu6Yqtzf57cmq6PO33gl/BrYX0tydJjb
	cVFzxPEEcK+hQGuPxQDxtpP9+TvhoIqI=
X-Gm-Gg: ASbGncuxJrgl6gGPNQ3GQkGMLsmZGIFpM4A49taSMNHzLTvE7DA3XDDvaXTWo7jZNh/
	U8fli++CFCmdYChMyap/WxTDs/GqZF8Km82DuEyIHV36KkASu7cU1rJ2co+s+1kNm542eohDnsn
	t5T5PUrktRZiOvn0b8IAFvYm6/OyefWA83zbDTwrW1HUQ7GE2/5iOxpk9FAeNNF5mZL2TE7qoj7
	FZsjR0YdxgYLsdU6wfE6NLqI0DuaXnfuTB9LBbrVsKxOX9fZxl1+qwTV+LXhcHyP246dfnlTCTo
	H/ugx+ThEaVX1lCuvme30NBE+9HWDiovV2yBAMvUyAiaSWNbTAj4EanHn2IvXoDZgl4XHNOiEFr
	6
X-Google-Smtp-Source: AGHT+IGytADtHdg1qJ4UWeh3qQAmZx2u7rgOEcAoWiD4v/EzjzcDZni4g+vvDW9wNW4rCG4X1sr3dMWLlR0QEkxHbVI=
X-Received: by 2002:a05:6214:260b:b0:721:f163:8678 with SMTP id
 6a1803df08f44-721f1638732mr78294166d6.30.1756954005044; Wed, 03 Sep 2025
 19:46:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 3 Sep 2025 21:46:33 -0500
X-Gm-Features: Ac12FXwB7M1Hr0IivoMKxINa1EzgkBmxbSmeNOoR8dzN5iNhTHNEfoveeDbDXME
Message-ID: <CAH2r5muAY1obqbwyP_KR_mZedEaARQhMyDyKenDv4UOW3cD4bA@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fix
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
b320789d6883cc00ac78ce83bccbfe7ed58afcf0:

  Linux 6.17-rc4 (2025-08-31 15:33:07 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.17-rc4-ksmbd-fix

for you to fetch changes up to b5ee94ac651aa42612095c4a75ff7f5c47cd9315:

  ksmbd: allow a filename to contain colons on SMB3.1.1 posix
extensions (2025-08-31 17:48:38 -0500)

----------------------------------------------------------------
ksmbd server fix
- fix handling filenames with ":" (colon) in them
----------------------------------------------------------------
Philipp Kerling (1):
      ksmbd: allow a filename to contain colons on SMB3.1.1 posix extensions

 fs/smb/server/smb2pdu.c   | 25 ++++++++++++++-----------
 fs/smb/server/vfs_cache.h |  2 ++
 2 files changed, 16 insertions(+), 11 deletions(-)


-- 
Thanks,

Steve
