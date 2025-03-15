Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1A76EC0;
	Sat, 15 Mar 2025 01:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742003752; cv=none; b=WmGF3z5gAXhUPKETgsO6wl3IfZD5VrQ1cZFLNpu3rLG5KRakK6e+JWA66dg7YqyIjJco0Y7VBImTq8Cm5le912vR8WW8BYhPDwgqhpW9gs8E5pzVqF6AIX7yrJHUztK6Ejn0aA4yC8znK6e/31fLMZ0g9UtK8ukMW4+Hg6yUP2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742003752; c=relaxed/simple;
	bh=tZ+LdPW/9zBCe2fdf1wszE5UMK5AfZQL2/ciE1QjnnE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Gylec1OXwy4mBtRY9Zb+QsoVRkPW4gidhmqfFsly2FxOndKg4aQTk7vCdLte/aiUe4uEaLpPdDPiyiuOQCUHDny255ps5XXxGxHyZ4vKsgyxhjEJrDRAaAEaoDrQHBhUk9abmZsJTkR4+ZvFWjkhc7KauZ0FyDEP+vU0NXaKQ9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FO1iVHpf; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FO1iVHpf"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-30c2d427194so28749331fa.0;
        Fri, 14 Mar 2025 18:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742003749; x=1742608549; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MpuyzVi711r61vqlrwtMxn3Epnkwyrhrdj/bz/ZWnGo=;
        b=FO1iVHpfhhPMMKlPWB5xOboBg25EYG2wjmey7ChpQOpeAb21+uunidosXD2HoXqONr
         rhvQte4c5dCdBNjUgN+YULYoIKJQyaQkm89wPFYqOvOlFHObXulhza4o/sJv+anXS0Pg
         wjaGTsbC2I3oZLkHK8UtVa7yMlvyMHUO4NyDEuQyBzjxdsnHVXCw4FnCSYZdPUzMOfZr
         DQhhkeLgxtpel52hPRcb0KqBN7XhjvtCBwK+V65YQG/VWbMRyM1yWpIKSAsilyTupJ+6
         lqE93I+4zeJXAz5F3HjroS7UVYOf3tvnWknr+9dVUAe835HvYRe/4sgf3m/Zm6uJbKAs
         fg+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742003749; x=1742608549;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MpuyzVi711r61vqlrwtMxn3Epnkwyrhrdj/bz/ZWnGo=;
        b=tAxUHCjVcjH1sSHTqsQ7lAdRNqQHKQDWKuNzL90TXJhiHIF5WO45ZHPTiPTq5ig89v
         MvxZbd1efDr1HIf1nByfPmr88fMeKVKO+yXLfhHaW3BqXVMtQzqM2Z9nT+dnl648hld1
         yjHjdYpRN2c7kCEVRZM3WmQMUx5K1GJ9UZ0MIHvwKFx3OI0Sdv5nJ9f7R6MiOg15fE2P
         v88G3feYoDqfJ/BgpLwvggCU5kBCvA+6QbIJ28wb7suimcok6HvBKBg9FsQwJcZc74e8
         cbRFf8eFXtBU/bP6gNwrKH9mBw7qFS5qSev5Wk5Fvs+x5ZF9ZzJmBqoKuq4Xy0rkUul4
         oe9w==
X-Forwarded-Encrypted: i=1; AJvYcCXEagnySe7OquV0/m/P/rm9cC4A+LN3AvJ7JGk8GsevaCfl5Q7K5Uk/VCKW3Q0WdQdB7a6Mjq7rosSF49E2@vger.kernel.org, AJvYcCXT/RqdogtR1lHqfKysn51PirDz8ZHlrXDnEGUW6YGo8XtETFpjVHWxdyYn9EGR2m39hHOPiE7bOmps@vger.kernel.org
X-Gm-Message-State: AOJu0YxiYTjLTgw9rBe9pUepAlrcRc9y1jhppWCOjTQt6mLpeAmoM7zQ
	KQXg5WaUqIZdHgpqmrOchzoRfI7RrRyMrEvVwr1Nn1L0LDb7H9gomE24hQoGGDV7Ky+ok0yknIH
	o6vzuPegowxeaDwsmq74P/IQZ7WUbYbHN
X-Gm-Gg: ASbGncvd6Ro1DDoMp/00uWF2r9Bnp9v4RSdSrEC9wB2QwrRQycwtktGMfMNl+ZuWJWR
	KCFIOlrtmvuU19BOtm9AfDpFYaXbqJL3oeRBeuP5JB3Qz4G7OCFpEERJhKsTlYYa2OrKBL7GLLH
	6so3lsINzHwAMiiCXEx5Lb7zA1P3meVNZw/aLrJ+M0zroRlarFVCvWlQUQFKAM
X-Google-Smtp-Source: AGHT+IHU3P17vt6eomiqX+nXneZuHzkGIisD190iL8kyNKnWPsiC6zUnjZFP3Br7qqpCm0RG6Mtu6db5ZZxv2E2ZcQM=
X-Received: by 2002:a05:6512:2823:b0:548:794f:f9dd with SMTP id
 2adb3069b0e04-549c38f1d97mr1486470e87.10.1742003748512; Fri, 14 Mar 2025
 18:55:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 14 Mar 2025 20:55:37 -0500
X-Gm-Features: AQ5f1JrbOHHJF-tZFXPE2qmpbQC4hCL1BZboQGmA2Y1tuebbR0ruezrPmtMycP8
Message-ID: <CAH2r5msyWMiGJi2VK50A=h3dD9F06eS9M5c51oY0DiSTe0Av_w@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
80e54e84911a923c40d7bee33a34c1b4be148d7a:

  Linux 6.14-rc6 (2025-03-09 13:45:25 -1000)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.14-rc6-smb3-server-fixes

for you to fetch changes up to 3aa660c059240e0c795217182cf7df32909dd917:

  ksmbd: prevent connection release during oplock break notification
(2025-03-10 12:54:32 -0500)

----------------------------------------------------------------
Two SMB server fixes
- Two fixes for oplock break/lease races

----------------------------------------------------------------
Namjae Jeon (2):
      ksmbd: fix use-after-free in ksmbd_free_work_struct
      ksmbd: prevent connection release during oplock break notification

 fs/smb/server/connection.c | 20 ++++++++++++++++++++
 fs/smb/server/connection.h |  2 ++
 fs/smb/server/ksmbd_work.c |  3 ---
 fs/smb/server/ksmbd_work.h |  1 -
 fs/smb/server/oplock.c     | 43 +++++++++++++++++++++----------------------
 fs/smb/server/oplock.h     |  1 -
 fs/smb/server/server.c     | 14 ++------------
 7 files changed, 45 insertions(+), 39 deletions(-)

-- 
Thanks,

Steve
