Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2086132103;
	Wed, 18 Jun 2025 22:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750286826; cv=none; b=W6Xcy+Q4Nh2jFddTeV9SvV/zp6y7jbepxTUotIpMWDLBgc6mihiFAKiGuI1p9dYn5uQ6L0gm19YGfccWivCwLpqLvjfcza16fFGi1iHviAxtVL48Uhd6yUaYpt0fTSb0JDSU98WQ5hzfTjNsamgTQnLwDrrP0kjUkLPWWHZeqJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750286826; c=relaxed/simple;
	bh=0e+/USoYPcURqCQQLUMdgoWmJuk66wZTtCbIw16hMtY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=c/6yze6C6dcTg28jkKm6/mJZ7ufM1hYKlhSXeqQ/Eu1JRSZS1dBk8wbI/9OxsUMD/H35sPn/SfxY4gDL9BW98sMIxoBJWL8Oke7NJ/vNJIo5d9hVVehPtFA3OBSaD6DnNSjsmcu3Fzg2i4XCr7cUUUcp2IIyBc+pJ5Q5hIE1KNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WSeerZyj; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WSeerZyj"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-553b584ac96so123169e87.1;
        Wed, 18 Jun 2025 15:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750286823; x=1750891623; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nDaqiY1ASR8uHXUiFFngS51fiM7CygsiMHCTQPGhjEU=;
        b=WSeerZyjXSXv/2+01cGM4mDWnoZ6jfXqH+SYqfxLgRYjie017gNGiHMgW1qb5Nw0uV
         WLxNGTZMqU489S3eEGKpkptKgpS9YsVprU6mZZJZNTJjQn+KndDq7rbjvVnFyT7bGEwC
         MPHmpO3FWSYfYARHlwaRh+agc5iz38hRbi8fh0A6KjU5zhr+S/UwAmCqEK0pjoMECGak
         iAUQie1Xtv2+r/Hz25kEc5vQXKxbezGP19ZKfUshYm+A4DCQZuC4r3WfVQvFEMfNiO33
         cDcCxY59tH/gCR/k8jeV/IX4V1Yg95XZFn2bhvdbNO8GI1uzpSHUTj3PMlJ8HsadsVDu
         eIvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750286823; x=1750891623;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nDaqiY1ASR8uHXUiFFngS51fiM7CygsiMHCTQPGhjEU=;
        b=JAokzktiKKLyyESpiK63ek3bqWEhWQ9dnTqrqAQ5U6KLEBNrq5610HO3RQD3P9IJji
         lOaWKZvqORIKNhGv7wuFae5vDKLhRXP8sLcLw5kOUl5Mz1upkTDf6kFUc4X3ECXocsmb
         3eDzz00ej2CTwcpND/5VTh3kHnzxGLrQoID/mvlHJwX6q8sHIlpw2IUmIxitoQJ6sAtl
         /2eqbWjaJWloFVg+g2bD7t5G5Fubs7MpM3oMF1O3QhGnQsS4IdqZOkp8xxvuIlgmHr7+
         jpRZQqmSHqY2TQonYqFUpUc/tPYwkifzpIKyB475xD2Me7OL01Ox7uH47YSzL2vZXd8d
         E1Xg==
X-Forwarded-Encrypted: i=1; AJvYcCUk2Z1glW/OFa2+VdMWjmNY7z7MP0SE3TfdIRoBk02BR2dfC03EZdh2qsINzZ0uuPlCnTkIp4GDZWKn@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7MhSypH14631bDCbqlfZDkZfm1elnRkxLsOZhT3YbE/sr7Nyn
	Bqyrcl7s20pRcAGz86GxhLKkhiqJw1l7Bl84vwtVt92eYiovIGRrA5r4McafTIXRtK5sxOGCWrq
	+cezAsvKqDfd4wMhFVvrB27ABa2UzepM=
X-Gm-Gg: ASbGncstzYgb6nntMhS3b9GzrLSIIuWhqwGdCPQRPx1ZmiRI1J3rBv43T3EvygBiQC2
	Dd9hcHK8cOmb5xu6s8fzSd7byFxvAjpYXILrYAu9tK+D9GLTgh2TMNK8MQlx0oqLmLWzuaQQb/X
	jnnnQ7pLnHncFFCXSggpzczARNnRmdWe9TBUI3qo+d0SLCkU10d0lJcQhjOm44eL8n6NAmwGMGH
	ptPbg==
X-Google-Smtp-Source: AGHT+IFdpbtjmt/7xSeE+erriKiT/+f/BXcoRLJTfAMZYpMzZlPRMUsjREt+tejRrPJd/2YV2pGwOo0YOBY0IvhTZs0=
X-Received: by 2002:a05:6512:aca:b0:553:aaf1:f62c with SMTP id
 2adb3069b0e04-553b6e8abb8mr5204267e87.14.1750286822364; Wed, 18 Jun 2025
 15:47:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 18 Jun 2025 17:46:50 -0500
X-Gm-Features: AX0GCFsgYWiPmHhdimbVexMyu8xSzlP73zF94uqBSACpXTmvFftA5_gpV3AEzPA
Message-ID: <CAH2r5mthMn2x-R8-xiktKqJ+bYsCD4nBAHEyFMTsDgG-5_boTw@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
e04c78d86a9699d136910cfc0bdcf01087e3267e:

  Linux 6.16-rc2 (2025-06-15 13:49:41 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/6.16-rc2-ksmbd-server-fixes

for you to fetch changes up to 4ea0bb8aaedfad8e695429cda6bd1c8b0dad0844:

  ksmbd: handle set/get info file for streamed file (2025-06-17 16:27:16 -0500)

----------------------------------------------------------------
Three smb3 server fixes, including two important ones also for stable
- Fix alternate data streams bug
- Important fix for null pointer deref with Kerberos authentication
- Fix oops in smbdirect (RDMA) in free_transport
----------------------------------------------------------------
Namjae Jeon (3):
      ksmbd: add free_transport ops in ksmbd connection
      ksmbd: fix null pointer dereference in destroy_previous_session
      ksmbd: handle set/get info file for streamed file

 fs/smb/server/connection.c     |  2 +-
 fs/smb/server/connection.h     |  1 +
 fs/smb/server/smb2pdu.c        | 74 ++++++++++++++++++++++++++++++++----------
 fs/smb/server/transport_rdma.c | 10 ++++--
 fs/smb/server/transport_tcp.c  |  3 +-
 fs/smb/server/vfs.c            |  5 +--
 fs/smb/server/vfs_cache.h      |  1 +
 7 files changed, 72 insertions(+), 24 deletions(-)

-- 
Thanks,

Steve
