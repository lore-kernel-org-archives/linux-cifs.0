Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7E12FB6;
	Sat, 14 Dec 2024 00:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734134707; cv=none; b=U8oiRd3XNTRymt1EJCXmkyt4lqYnzlOV18fgsqj56maydNfOwM2VCjA8qWQ0YYLX/pnC4z45MBRP2h7sEUjC0zegl94EGq0XTqB9RjYO/UPM3nJO1/CAmQtD6X1UOrWaKJlqW6CVYEPxHLH19HlibCxdouR/w7D+6i5gKZ3+JvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734134707; c=relaxed/simple;
	bh=q9jxJoysr0c2b6Zm2ABgTq3L0MNm+M4VQ6vhLHnTl08=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=itZp+aE99HHph1DK7Fmhn3yZacarWDEclXVQeyZYvrX/Wze4F0kvExlH4aKFDLKom3vSNc0gYDBBabE6hHdrijjbOdRGk1gbI9zFUHnGBu11aeA5zlprlS9g8+Z5MYaCfrdIH0H8VMn+xrZqlzblnBq+NJ0yrOOrzaCayJyZryM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EcHNUvJz; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EcHNUvJz"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-300392cc4caso26470541fa.3;
        Fri, 13 Dec 2024 16:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734134704; x=1734739504; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UDay3WHOhRjIjx7Iai3jihzOyTK4g0Ls6xSC3UCPhpc=;
        b=EcHNUvJzZ1nGiL+smdOOQcd+0kKGf3UlcTvLTzcKDibaWqbyDgtmjSKIqTkMYQCvLZ
         Yrm5h/oMPepU5DZwTYqSPWQ/RMtdpHSrlew1MHZ0FzUaxJ1up0vrBfAbuydEJaGtswS7
         gQkTwSmh59BcaSPmrTFYYwBvZRudM+7IQDECIrYJYQWObtqg/+L5TDR1ejTgvIF/8ksN
         2JB8nLXeRRBlA7mn6znHbsal/tpK0B6GpHwpJsbZ31RozTpEwmon525Ck2qf+aaVYm6R
         g3RGOIZG+LEAqIsfkTavOIpg/vCcPorb/FalV0SSZ+6jjn2cVMiytzChn5hbEqFFqq3j
         H6dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734134704; x=1734739504;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UDay3WHOhRjIjx7Iai3jihzOyTK4g0Ls6xSC3UCPhpc=;
        b=vGBSaXujTeG2Mm9UtKj3QXcYduhK1YhOir4fpzdKVwQpC8BpBoXLdExp/Ew7kOIfCP
         dpGvQoaTkmZDxcjKAwZ2+zjN205Kisy4x6B1klQqc6FYXPistwtSx+if+3A5wrnHFlGt
         D3HJ2UDbUHKL5E1pSJgOOPKKsdZjpZffjnY7h7a/5KjGLUY97Pn2fl+DRYnwoCLR3GCn
         BMhHUBQNc694mX96fL+/jYLrm3ibw81Krbhgvm0R4BhPkLGzuzEtt4tdhmFS/bmhwmhC
         HNFxLSl1Gu1Y6LjYk8w6aJNDTQ7z3EKt785J55MJSUZJd4SXxFP6f4/MKP0Bz8FAcaOj
         VreA==
X-Forwarded-Encrypted: i=1; AJvYcCXArH0BYkQMnm0vkVKON99TuNcCgsI7NzCPDvNBipUiwq6MZtme6vgTV580WthGxjJV7QEcuSe7FYmr598=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZ2DG/6+4BiWrt7oHLCyvjeAYa4kbVDiJPSuo2lolqrxeb7Q8b
	holJ3PiP9uOBwGjSbSGAdHyMsRgb+C+QJyY16H2taov+bjTkMC1rBKPV/iigNNs3LErQxdBJXNJ
	EMp5e4NHTGfiAwY966W3pmDza0JgTCKDo
X-Gm-Gg: ASbGncs9YQGrzn3saSC6ZbkffA1DBNInBsX7zy8Z/CKHexC/dShdnxwolqLCvJja5ce
	QTSKpAE1SCzUm61yGEr2M5r00sn2YTlq3ppLmU6LX+WZnlawLYP41rN17AMuGOHJ7UWwGMC8z
X-Google-Smtp-Source: AGHT+IEFv++x5tNOGInJhiV1yQUEoGsLZIbI5VFxaphO6y7U4nkFfMeoZLVnF7+JPgU9vngXFybe/z7hSmp+DsxL3W8=
X-Received: by 2002:a05:6512:e98:b0:540:2122:fae9 with SMTP id
 2adb3069b0e04-540915e2c9emr1429320e87.46.1734134703691; Fri, 13 Dec 2024
 16:05:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 13 Dec 2024 18:04:51 -0600
Message-ID: <CAH2r5mu+0egy3V0bVRO+OiXbCa+HT5FLA6LKAiJZ2LD85vNvQg@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
fac04efc5c793dccbd07e2d59af9f90b7fc0dca4:

  Linux 6.13-rc2 (2024-12-08 14:03:39 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.13-rc2-smb3-client-fixes

for you to fetch changes up to 633609c48a358134d3f8ef8241dff24841577f58:

  smb: client: destroy cfid_put_wq on module exit (2024-12-10 20:47:39 -0600)

----------------------------------------------------------------
four SMB3 client fixes, most also for stable
- fix rmmod leak
- 2 minor cleanups
- fix for unlink/rename with pending i/o
----------------------------------------------------------------
David Howells (1):
      cifs: Fix rmdir failure due to ongoing I/O on deleted file

Enzo Matsumiya (1):
      smb: client: destroy cfid_put_wq on module exit

Steve French (1):
      smb3: fix compiler warning in reparse code

Thorsten Blum (1):
      cifs: Use str_yes_no() helper in cifs_ses_add_channel()

 fs/smb/client/cifsfs.c  | 1 +
 fs/smb/client/inode.c   | 5 ++++-
 fs/smb/client/reparse.c | 2 +-
 fs/smb/client/sess.c    | 4 ++--
 4 files changed, 8 insertions(+), 4 deletions(-)

-- 
Thanks,

Steve
