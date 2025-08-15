Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3535526AF3;
	Fri, 15 Aug 2025 03:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755227187; cv=none; b=lo1vc0pe8a6wLC5SbmRtIRb0eHq0XvVaLW1AoiIn5N81DLmj2jRua7ythyRc3KzbMdu7mlo3ZVDPPQPiJUsUpYpiiEyKUIvJS0y0ZYuljhgq/O7YuSkhw6CjzI4vqj8WpwJ43ckPjLa8uJajxw4eVRVbf+y8FTUiIXJolpqM31A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755227187; c=relaxed/simple;
	bh=UbtTd5cDnA+tL0Z4ZPtN97UkW1xDXL+wKRfOIrUF1Fo=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=hh9qlXizwO2NftF0eR0niziwQ0TngNBzTU9Wmds0Jd/CiYiuwLeSffGe1/zS37XhB/kvDD/rLxUrdCCG8q+76R4IaUmcSX3FZISqhzJ3oZL20d/vMAB04N5gsyjO8VmCaMpWTPMWv+Huf+/xE5avKVLmzDBC/YVOFJ9SgJ8jEFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CCm+kYpZ; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CCm+kYpZ"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-70a928cca6aso9161176d6.2;
        Thu, 14 Aug 2025 20:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755227185; x=1755831985; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=y/msescSO6DjiLygH5SQxhYUOUBz7dEiXRHXJI+7dv8=;
        b=CCm+kYpZVQAwhkuSO1loAdg+V4WBnTktqoTS0dR+wlg6rFBMvqfVhPv9MO1TRAKfKi
         +sLPRIqO7bYUmyHoEXq2316/AyyR/S4Bw15R+c+BzxuUz+iF8zb3vrN8VBJLWi+dDehR
         kFRdCZGyx2uAuGY/x+f2mYjUiq0yF94/nlVi1CLw6inwNs14SqVxce22KEa2BOmlU1l5
         wIHR57XU78hasbcDM/MiWrH455rMbfbIB+6O+1YZbSdVXcApCiEE4XZWOD2kcL3/RMYl
         b1w9m+Hbq/veEy33/QHtEgNu+vNsqXGXykSMPZ54V+6B6KihByxvDZaD34nwPR0cx5/V
         rtWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755227185; x=1755831985;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y/msescSO6DjiLygH5SQxhYUOUBz7dEiXRHXJI+7dv8=;
        b=oij8udTXGUVhKouY0asOYKQd5FESNTf3rwemga7AcdFZtQl9ZL/ipuQbaq9JntD0nT
         9yHNxWtLoF9Eg3brmVokDPgiCG4F5mR97cIGPod4yUnlROTYGbd3FesbMbC8pSCkj9fP
         NLCqFipvGLERVFvKd5ZHr4l9z6KChrR4HFtVYAnB1CPem/WAUmRSvPz1N+ewyq+rLHHC
         +5n1pEn2YnBXEn4hCVWhxLW3bVOOZIhaSp8IOr87fFgOCvJrgjlEB8T5B2d7OZr9obi8
         A29k8SU9U3IRosPa04sKX/rjCHE3ul/Y2GHS4FEDfxt3G5t6qhyvC3cAI6QS4F5W+B3/
         CH1g==
X-Forwarded-Encrypted: i=1; AJvYcCVB8eUZDNYtWnWomkLcsXBBeehl1n0fY+S8lr5Kw2ggxkfN4mKR6ekaNkCxuWoFG67CN3KKrBmZCKq/@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/66r2VSRS0EJG0XRhHXVZIs0cFGCXRm4D4HXxtFvDL/SIvlVN
	5mrnHqnT4I+5rGMU465t0Iqz3cqJ18RHbpv5pl/1IwzEefaao7c0/uezVfIwrUT6m4jwDAWL4W5
	D2ZJ2f+pqcV1NMFIpSZ51iiFVt5LLEu39GQ==
X-Gm-Gg: ASbGncvLFLBnZq9NWDMta0qeSXyhpdGuZ9Yfx4ndi7yMHXu1wgZeHsFFHyQbczCnjf6
	GnaG8zofRAqMSUzuoTsDoGMVazYdrZB+CLKXq0MEY6x2z+lE6qpwrnYO6UWP9nb8c9gP+Iq7jVc
	EGgxXpGxf68Rwk8/aQY16lTqfX79uB9yqOZTvSm+HflhUycBo2WAJxrjVD6v5j6P9oIxgeEPybf
	zTC59zsDHwEceorScOVhu1jF8GdtV33zYDyiJDOeyUCGYg7jN7a
X-Google-Smtp-Source: AGHT+IG/1pXVT5fuud5x3Oo/+E1+MALLJEWdNuFJJRMGFx0JokLcZ+B1zIJyQq4KPAwIYE2Vxz648vFKk0BSyvBNtPk=
X-Received: by 2002:a05:6214:20c5:b0:709:31f8:fd9a with SMTP id
 6a1803df08f44-70ba7c02df1mr3600896d6.27.1755227184960; Thu, 14 Aug 2025
 20:06:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 14 Aug 2025 22:06:13 -0500
X-Gm-Features: Ac12FXxeH_6vd5VjaiU_viR1KykxMXTGxBa6cz6cDdEZKa3m_F-CiLpsrEJ1Wc0
Message-ID: <CAH2r5mtRBY-kVFHxA+w2mgvyG_f5cnbtMqxDgAQjDeecC1jyKQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
8f5ae30d69d7543eee0d70083daf4de8fe15d585:

  Linux 6.17-rc1 (2025-08-10 19:41:16 +0300)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.17-rc1-smb3-client-fixes

for you to fetch changes up to e19d8dd694d261ac26adb2a26121a37c107c81ad:

  smb: client: remove redundant lstrp update in negotiate protocol
(2025-08-13 11:36:24 -0500)

----------------------------------------------------------------
Nine smb3 client fixes
- Fix unlink race and rename races
- SMB3.1.1 compression fix
- Avoid unneeded strlen calls in cifs_get_spnego_key
- Fix slab out of bounds in parse_server_interfaces()
- Fix mid leak and server buffer leak
- smbdirect send error path fix
- update internal version #
- Fix unneeded response time update in negotiate protocol

----------------------------------------------------------------
David Howells (1):
      cifs: Fix collect_sample() to handle any iterator type

Dmitry Antipov (1):
      cifs: avoid extra calls to strlen() in cifs_get_spnego_key()

Paulo Alcantara (2):
      smb: client: fix race with concurrent opens in unlink(2)
      smb: client: fix race with concurrent opens in rename(2)

Stefan Metzmacher (1):
      smb: client: don't wait for info->send_pending == 0 on error

Steve French (2):
      smb3: fix for slab out of bounds on mount to ksmbd
      cifs: update internal version number

Wang Zhaolong (2):
      smb: client: fix mid_q_entry memleak leak with per-mid locking
      smb: client: remove redundant lstrp update in negotiate protocol

 fs/smb/client/cifs_spnego.c   | 47 +++++++++++-----------------
 fs/smb/client/cifsfs.h        |  4 +--
 fs/smb/client/cifsglob.h      | 21 +++++++++++++
 fs/smb/client/cifstransport.c | 19 ++++++-----
 fs/smb/client/compress.c      | 71 +++++++++++++-----------------------------
 fs/smb/client/connect.c       |  9 +++---
 fs/smb/client/inode.c         | 34 ++++++++++++++++++--
 fs/smb/client/smb2ops.c       | 15 +++++++--
 fs/smb/client/smb2transport.c |  1 +
 fs/smb/client/smbdirect.c     | 10 +++---
 fs/smb/client/transport.c     |  7 ++---
 11 files changed, 128 insertions(+), 110 deletions(-)

--
Thanks,

Steve
