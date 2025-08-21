Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECAF919E7E2;
	Thu, 21 Aug 2025 02:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755741779; cv=none; b=qZW/N4bpe5BVgwMEVrUvcPG46IPTWFAmgJ/l0DrJzJbzGga2WydnxMsp6ZQegfF2iEkBkPGaYWgeXtvV1+Ch00yJ7cacxLJy4lOy0yM33gR2WGSE4eJbMbuEe0tgr9TTQi5Q+TNjApOHv9+Opi+wue3Jy6vXmAI4KM3gyivCIPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755741779; c=relaxed/simple;
	bh=q/bb9gTQN/O3uOOQMCaFMGKV2OTwlVVRp0KuduQ/434=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=dAESJvb6vylgkhdPyiRNBs7GYn7tbKCRQ8qsHEgiBMqamFJgDwspVIhAjmHwYyRtDjTc56NV92UHvfThxEZpJ3h/Q8ZlvwaGEnmL44mBD68vxqqwOGHiSHRAl5BPThzQsS13e5dRpLW2r9pP+A+GwIe/+gqozhn4BE7Nthujphs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kasvz05S; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kasvz05S"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7e8704c7a46so62140085a.1;
        Wed, 20 Aug 2025 19:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755741777; x=1756346577; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uChfv3dbEQUO8eMCGtEccp07YhaPFLJJZXa93OWzg6Q=;
        b=kasvz05SMMY1GHfToevo6DPuezcBxoDdtVI2A8R3UYlLuOZ52ge40yVgGGOu3A3TCl
         gAFUDxUiTSIsf4reCO1JpN8eR/S/kVs7gaPynfiF3hhxJO82Aqg5twiwID9sT8jdKjjG
         Wx6pSbIiTz2mxzvq3i1Wehm/89ytLldLgrqk+XQjIrzHzMnSobhOnovVl13Vd3kP1Hj6
         Ez7rTVJHA8GikU2tBmAGfPtLdd11fILxMQlBTw2xn5Oo3X/fHHOOCcJzqLfBwenGyGRc
         sl3dKinhD5orL6YNg+19uIUyhKT+WALLw+gzWqQhNZS+6aVBpOVy9ntKkDpBykRF4Ai3
         5dDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755741777; x=1756346577;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uChfv3dbEQUO8eMCGtEccp07YhaPFLJJZXa93OWzg6Q=;
        b=JgeJxtNppjSi5yaX+lz1aF1K7jkB/2WD5tsRPXkCnkgvejjIgja2yJivg5pHMJPIhB
         VjX6IuAs9lZLh1NAQm+y7iGsHOnzWZcqIKY6pBiOHrKEyPv5Gsr7ppqnG4TbtXoJ0uCh
         kg1uIZeykLIHq41tV1d6AnpSxoAxvjFA+Mi6YYXnR5sgxvPbrSt1cxjpq20KgmXstfU/
         xA/f5HBaa5N2+JYjkMBo0sELk1ZciFJJ08O8Qny7LcEuZrerUhFkm+jMX3kPFPN4qPMu
         9iKCq2brxbhz7y9KnImnCMpytZMHEMGsmNG6xDGnpBdPlZRUhfZt81KgQ2LaqSAL3czg
         gNvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUr+fxnSmhnlAOAo2nPm5fKEhpsde0Qd7aN9jQe60Cm8MNZzvoeZ2XLwV8whB5gYcyMNo4tJiUgD5O8vnps@vger.kernel.org, AJvYcCWvHkZsPprehMHUUYLMbkU+j6z+NlBHEZE99tTx3LWj1hG+JZBGCZ/L7smqFuqgM3Uwi/PW4igJGAJl@vger.kernel.org
X-Gm-Message-State: AOJu0YzxMHr2AiOMGY/bTPW/wYRVDqqv7D6lsBVJAgi8CLHMAQkNwGUD
	L0421khS/fE4IpbcG+/gMjyoT25zBo2CrdAaTBXK5tNJ8SguOa41ykW94/lPEq/CSyIrJYxEyd0
	OyLU9CS44BAcU7r4dPgdaikDSle/+F1GFsQQf
X-Gm-Gg: ASbGncu14SbEu+zrHbXklH9D70EaBbE8/Lz5fUUvmmDPEKT04ICWdcd3s7FFBDFqs4t
	equ6svetD1jv6E7Ygb4042ucL3b7ddmNT6ILHjPzX4UJIkffWjbp32mjNmnV1eKl+nFAHKT6miH
	tbxn6Zvvb9iZovFy/fhqvvd9rx3J2PtLcRSeMRyG3zc+695NLsXLPMpIndi43ENIQ0BkFiT1w+O
	0J0cWPbbLecX2Yt+/AlsHqL8y6+ssU77cNq4JFJUoCY0itvQvU=
X-Google-Smtp-Source: AGHT+IFH1O4qBTSjA04bPjX7F2AhQ8hW+zCerUQe54wrBaRP/uBghNK/ND/L4HDQzKomSt+BYBf8sDaseZ17HBoj95c=
X-Received: by 2002:a05:620a:3190:b0:7e8:710d:a514 with SMTP id
 af79cd13be357-7ea08e43716mr93848385a.53.1755741776612; Wed, 20 Aug 2025
 19:02:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 20 Aug 2025 21:02:45 -0500
X-Gm-Features: Ac12FXx99RwOD6LIDlz9lcKmgeewb4DN6PYRoc4wZWKQ4muA9weLs57PbzDyOuw
Message-ID: <CAH2r5msSBLTFkG1FGLFD9rUjQ+8xSHdnUaoZ4zsBGrG33zGrcg@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
c17b750b3ad9f45f2b6f7e6f7f4679844244f0b9:

  Linux 6.17-rc2 (2025-08-17 15:22:10 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/6.17-rc2-ksmbd-server-fixes

for you to fetch changes up to 89bb430f621124af39bb31763c4a8b504c9651e2:

  ksmbd: fix refcount leak causing resource not released (2025-08-17
19:33:29 -0500)

----------------------------------------------------------------
Three ksmbd smb3 server fixes
- fix refcount issue that can cause memory leak
- rate limit repeated connections from IPv6, not just IPv4 addresses
- fix potential null pointer access of smb direct work queue
----------------------------------------------------------------
Namjae Jeon (1):
      ksmbd: extend the connection limiting mechanism to support IPv6

Stefan Metzmacher (1):
      smb: server: split ksmbd_rdma_stop_listening() out of ksmbd_rdma_destroy()

Ziyan Xu (1):
      ksmbd: fix refcount leak causing resource not released

 fs/smb/server/connection.c     |  3 ++-
 fs/smb/server/connection.h     |  7 ++++++-
 fs/smb/server/oplock.c         | 13 ++++++++++---
 fs/smb/server/transport_rdma.c |  5 ++++-
 fs/smb/server/transport_rdma.h |  4 +++-
 fs/smb/server/transport_tcp.c  | 26 +++++++++++++++++++++++---
 6 files changed, 48 insertions(+), 10 deletions(-)

-- 
Thanks,

Steve
