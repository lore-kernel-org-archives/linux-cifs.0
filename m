Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C2E26ACE;
	Wed, 15 May 2024 05:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715751482; cv=none; b=hb4l6gyV5g0vEREC3dI+WXPx3eiMCFG2MCqgJ4khA4kQIpi2L2CRrqvWCVKcA6Wzuw2uDALOK1/Zfkc9igOBOQPb+uLheapH5kbtqlTKPWtl0us97Y6tYSlC1YykUmAFHIW9LpvqBFV/JC9eLXINLPW8in06i35E8nXTPRSaSEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715751482; c=relaxed/simple;
	bh=D51RIjWRv8o6Dpi8VLUaL1hXkhUUOxK208oZ6GT7L/A=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=NzMkkUBR8PCg11Eqrt+8I0gpefMt8WKWuXE2EfkAdiJhH4Vy3O0i8PiXXSRRA9GhG3kblQBVHSANHI4i+S5A9JRg/7P7JjrlzC3bOwzsQ6d7k9gBTFDI1+2j1DeBLfCCoqoF9C2hcWeviqU9c1c+GNh/wbSLYbL/7k98MeQPYqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KyMOTv0a; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KyMOTv0a"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-52232d0e5ceso5519586e87.0;
        Tue, 14 May 2024 22:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715751479; x=1716356279; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ihd3QNerXp7+Mq2S4MhLYzSsw3F02E9Een2uVN98XOg=;
        b=KyMOTv0acjMps8Vw30lc5k7l1UgrXV5AJTJudgRHrFReFMF88UkEi+Zt8eJXL2GxPp
         9I41RzEOz3dmLJNrjUGu3Y1cZ6D7D7/WrS9W/Ocv0OCk8FZUPoPcJTIaC0c1ikcihibB
         iJ/62Tgrsb8MYMaX0npumDh+Ak+JliozZseiSZr3i6z9/72Iv98mUrw+BPYd89s8eidR
         6XP2kRfGrEraUrtlKPvbwUZhB+wY2zyv89sv6VHyToM7n94Iu6vv1fKwqQLiRvJ8bLY2
         20s0JfRR4hCWJkLGpHT9US18EjMxNV3xVi+WBwloLhCGLqhzY6GXe2NyCCyM24FY/bDG
         d11g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715751479; x=1716356279;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ihd3QNerXp7+Mq2S4MhLYzSsw3F02E9Een2uVN98XOg=;
        b=jFDW+96pBTFiAAocifAaomy1/s1PKmw7+MtAq6BnIEix8KI7FEs9aia2W2P/qBKLG9
         pBgIgI/dfSRWhjDQ+JVMpXSi4UyIxYUTVKumS3k2oOHi1whnSy1FLLiOxdtUux5p2piH
         CKLYGsFW2fq7YnM3N3ry2X9Av7BqW2WI7lL4qxLZEe9gSbMQnN4uBaVQcLQyM/hHKxeV
         kwzoSo/GLuS82YQmQzTCLeT4sO8V8U5MCMRoBJRU0Zjb1BE5Jo8n11A3BUTHpA+Zznbj
         ZI7TyA7rpCMmTZpTYEVMRvG7RB2Y3bZtVga8Prasdlhp9iCx7GswYA0j04QjZmur53Vx
         CMqA==
X-Forwarded-Encrypted: i=1; AJvYcCX6seYV2U1JdMlYX6ur7/Z6WEtuxama8ngAiQM2ITEjQ2xgPsCU7gH2pXkcD/vHChrE8tb1jDdQp2Ml3c0U8yi/sPpgpq+b8qO3IA==
X-Gm-Message-State: AOJu0Yx3313mNLrFKZh0Styial3me5M2xoZl1OGbBWN7nUFH8AYc8YKq
	y+SykXiA9UBxy3Hza+Vl9JkJGv6p88gh2vQoS8SMiNHzJDL/Gvy1FypREAVCVKuF//iwU4B18Rw
	66DXN3jtVDY4CtIfBgrf3tvoHgd0=
X-Google-Smtp-Source: AGHT+IFyovi0W8uHxoh/KUdlVgHTl16xpTpIIyDB51PFM3PdeTmKop8BlqVpWWgglBJ0GfPtacu3t8MtIB9udNVByzg=
X-Received: by 2002:a05:6512:33c5:b0:522:2a2c:759e with SMTP id
 2adb3069b0e04-5222a2c76c2mr10669245e87.6.1715751478626; Tue, 14 May 2024
 22:37:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 15 May 2024 00:37:46 -0500
Message-ID: <CAH2r5mv5B8PAWpMq-5L_n9NXjOb_Jw6atrTETWOUi1rUM=8ugw@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	David Howells <dhowells@redhat.com>, Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
f4e8d80292859809ea135e9f4c43bae47e4f58bc:

  Merge tag 'vfs-6.10.rw' of
git://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs (2024-05-13
12:23:17 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.10-rc-smb3-fixes

for you to fetch changes up to edfc6481faf896301cab940da776229fe39e9fc9:

  smb3: fix perf regression with cached writes with netfs conversion
(2024-05-14 17:38:39 -0500)

----------------------------------------------------------------
four smb client fixes, including three important fixes to recent netfs
regressions
- three important fixes to recent netfs conversion to fix various
xfstest failures, and rmmod oops
- cleanup patch to fix various GCC-14 warnings

A couple more fixes related to the recent netfs conversion are still
needed (e.g. to address a data corruption found when running some
xfstests).
----------------------------------------------------------------
Gustavo A. R. Silva (1):
      smb: smb2pdu.h: Avoid -Wflex-array-member-not-at-end warnings

Steve French (3):
      cifs: Change from mempool_destroy to mempool_exit for request pools
      cifs: Fix locking in cifs_strict_readv()
      smb3: fix perf regression with cached writes with netfs conversion

 fs/netfs/direct_read.c   |  3 ++-
 fs/smb/client/cifsfs.c   |  4 ++--
 fs/smb/client/cifsglob.h |  1 +
 fs/smb/client/file.c     | 34 +++++++++++++++++++++++++---------
 fs/smb/client/inode.c    |  3 ---
 fs/smb/client/smb2pdu.h  | 12 ++++++------
 fs/smb/common/smb2pdu.h  | 33 ++++++++++++++++++---------------
 fs/smb/server/smb2pdu.h  | 18 +++++++++---------
 include/linux/netfs.h    |  1 +
 9 files changed, 64 insertions(+), 45 deletions(-)


-- 
Thanks,

Steve
