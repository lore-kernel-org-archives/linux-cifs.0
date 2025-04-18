Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EA721170D;
	Fri, 18 Apr 2025 16:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744993480; cv=none; b=IqVTt2MwumVLg4GtsUHuipNNi3FYwS34pR7dUZPLL1odHouVpejxv7qjN0T5Mug7ZEhywdh9vTwP7hP3mA+CXAT7rU4mVzWPARW6S6Q7weagki4A28C73LHcyVSXLtC7TxqYlc0N4e7dWK1yg7TrMZ6KjBXtHlS/Woh8fdDSuAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744993480; c=relaxed/simple;
	bh=nsaZPdmWgVvguNtZOwRGLuxY8iSRGpPgrmr3CDVcCC8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=QYJNopbMNQx/eBYdUFBigtV7eTnw9cp8Jsn5GuSMeiIXUvnX1QQjkhO5ZnNF4f8R0jigQ5NM3fEFlxrN8upxjlgqmnsKVF84NeefL/Vpsc0ucBlJtJISlVoGV1BRMyhGxJ9XIxnACEhLae7dNIJ+Q+Vv4ePkqPEzDLOLitqFrm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iIvHfHJ6; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iIvHfHJ6"
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-54996d30bfbso1889521e87.2;
        Fri, 18 Apr 2025 09:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744993476; x=1745598276; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=N3fjnglQ9I2MXOdr777pvs+iSblzgDUOB41zVUcYzEo=;
        b=iIvHfHJ6x9HEpe9tg8oqjciWdWVwRpXmjP4i+H4c/UN+QDn71EL1H7rB7jdQDAatLa
         XcxONj1IkWqPxLfjjgLadGRJsFEiy0n4Jn0vwxXEEZZfPmRHg3scpkFXUoI3wCZHqPli
         wS2EArJUUerHwlBqMAfwavglJU6728JxP59jQWOV06W6hm/84geJgCPRZmUDdVIIm3U1
         EWyabugEzvusjW6xQM8isXoSV9fKNdrmrKyZVVpcf3b6UEKnk6r4nXbMFc7uDE/HTV+g
         87G4waPEVoTqtV7ILQZI+VNv2vkww/zrh91iwoN+U2F8XgFYL9WEAPDsPvLRLq30HEqo
         DEnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744993476; x=1745598276;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N3fjnglQ9I2MXOdr777pvs+iSblzgDUOB41zVUcYzEo=;
        b=mKqtcQnslY2X6ex81P9pwcVmd27/5YuZdbN9xrDabuEGIdXhM/ht/+fSqBBCdCNnNf
         l76kkdL4sY/U6tHQSW/28PmHNGkRhO4oAgEgkAwplNQHZfc8LxxIAL3YaffAnTVp6TRy
         hopZVOrG8qB7VgfgOY0eaFf7TVUrd/4M0jB/1Bk/5dlS/lXSJZqOqrUe+CYeHgpcabU/
         qg+3BkiKL3AAQimbk/T/3U0jF4kak9EOybTD7IoASUQqfrux1aX7zEnGRawT3F0EHuEQ
         vFpOrEw79EJGIbya508PmC0vpBp9KijW0DeBAcTwkwScvYpC3rxRh1VFSrUv3V8VgBy+
         o9Rw==
X-Forwarded-Encrypted: i=1; AJvYcCURjhir8t7i9qkOoz/YCep+ZVxrAW1rlmYMTwXkSMLoK+vosT0a1rTs7hncuPLQIZ52C9/FUxxWcKN8@vger.kernel.org
X-Gm-Message-State: AOJu0YyiNTLvKQ5nIOJexKj9Bq6BnmJiHBRLlsM9ROU1CgDw1sDk7/3U
	PBr64zZ/cwHt8SgCa9KBHVm1bSDWB37ryJYT+S4hdoKruPdV4a+AYjiLoQNN5xZVU/E4iax2J7N
	0YsJ1U18KwdK+yFPdVf9tuci94L5utxqh
X-Gm-Gg: ASbGnctZFVfaa09vOKfN+YceynegOCMUZEcD/JDZBRYvfqL/NoHZqov7GxkqYFaF1FE
	Vu31PCrHpyOY/8p7giGkYa73ZwJapBTmVI+U4YMFfTOzSgzMitu2537ItnmFCJ8H1Lr+5JjHWnn
	WengthBO99clCt/dy7GUxdIrbPQAM7E1uoVydtiZ+A9Gb5V3cwrEKJ8kslYogWYf80SxM=
X-Google-Smtp-Source: AGHT+IHkGnG7OlU6mZ3tDDLadfjNlWj0uAaKRd4MgPgvgjI8bi0X2QM2g22TzadWaI84KtIU3taX6GXsDJIz+HRACN8=
X-Received: by 2002:a05:6512:1104:b0:545:d27:e375 with SMTP id
 2adb3069b0e04-54d6e65db34mr931032e87.42.1744993476082; Fri, 18 Apr 2025
 09:24:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 18 Apr 2025 11:24:24 -0500
X-Gm-Features: ATxdqUF54QLIM7a09DJdqkvGI4NRXLLLa_K7hI1gBMLxcL3-gqLeJ7vOI4gycY0
Message-ID: <CAH2r5msB5K8EdzYK3JXe5Rzo-yGpOk_y6qJghBOO770SpjHrDA@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
8ffd015db85fea3e15a77027fda6c02ced4d2444:

  Linux 6.15-rc2 (2025-04-13 11:54:49 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.15-rc2-ksmbd-server-fixes

for you to fetch changes up to a93ff742820f75bf8bb3fcf21d9f25ca6eb3d4c6:

  ksmbd: Prevent integer overflow in calculation of deadtime
(2025-04-14 22:21:26 -0500)

----------------------------------------------------------------
6 ksmbd SMB3 server fixes, most also for stable
- FIx integer overflow in server disconnect deadtime calculation
- Three fixes for potential use after frees: one for oplocks, and one for leases
   and one for kerberos authentication
- Fix to prevent attempted write to directory
- Fix locking warning for durable scavenger thread
----------------------------------------------------------------
Denis Arefev (1):
      ksmbd: Prevent integer overflow in calculation of deadtime

Namjae Jeon (4):
      ksmbd: fix WARNING "do not call blocking ops when !TASK_RUNNING"
      ksmbd: fix use-after-free in __smb2_lease_break_noti()
      ksmbd: fix use-after-free in smb_break_all_levII_oplock()
      ksmbd: fix the warning from __kernel_write_iter

Sean Heelan (1):
      ksmbd: Fix dangling pointer in krb_authenticate

 fs/smb/server/connection.c    |  4 +++-
 fs/smb/server/oplock.c        | 29 +++++++++--------------------
 fs/smb/server/oplock.h        |  1 -
 fs/smb/server/smb2pdu.c       |  4 +++-
 fs/smb/server/transport_ipc.c |  7 ++++++-
 fs/smb/server/transport_tcp.c | 14 +++++++++-----
 fs/smb/server/transport_tcp.h |  1 +
 fs/smb/server/vfs.c           |  3 ++-
 fs/smb/server/vfs_cache.c     |  8 +-------
 9 files changed, 34 insertions(+), 37 deletions(-)

-- 
Thanks,

Steve
