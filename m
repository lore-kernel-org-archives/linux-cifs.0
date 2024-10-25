Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF08614D718;
	Fri, 25 Oct 2024 16:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729874425; cv=none; b=TVGYHCZ1+LtZxSH57ZoR2e+rLHxpBj/VGUaEiHhltbRNSKyW+WQQba6SaL86nfYy5SPU/nzPw6wKIvH7pFsJH/5oKJOr1agoGBmK+0jB4jIbAOp3SV2pF3jM6Or0Ih00vfA5vP8xwQ6/hfzKGPXrv6fFGP4BBRGBMFfphvql3aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729874425; c=relaxed/simple;
	bh=E7pTktpCFQLDOmn/4di9IEESIHElCoetiiiyWMDOCZA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=i4vW23qFMZNVOOxB6Vma9Tp+Y1YUkUZry+9+OjJuQ00C+ma33FkARODWvDt+/0W8LmibGpLa1iTclGCA0Kakfiv69lzs/h2rVg39MAOE+TAmcaMD46MAyeP/8yTVvMy83Oy6Y8hbeQ38H+QEd5AkgRofjmihiIHtyJtjqY/DtBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DrubOQ+G; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DrubOQ+G"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-539fbe22ac0so2654120e87.2;
        Fri, 25 Oct 2024 09:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729874422; x=1730479222; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XkffEx/iqtllwnddkRmoM8bOQgGjVSaEbtQ0mnHn7Ww=;
        b=DrubOQ+GZwYtS43HZfQ1yugIY/ytWiuK3SsqtfmIC7rjAW0swDQTTCQBZdSvE9lnql
         0oikzS8NYh8hAfP8Z09dJcwti4iq/IvFQxF6zufYHV+Uvz8Y+NOP8q/Y3pzcQTRkuI3X
         GNBumTNrcAI8NF7rVe2q+vW4vXTDqvFEV0nqB+uEHEmx5pcrUoKKee/c+Xzf9aEE8lEg
         2CtA5etxAPamA4Rs63wKjNvYfqkzAQuEVqNsZ7zgFjOYBKAVLyHGobH6fR8vAvqoTI/v
         n/YktIWj4rl/UPUypgW0wr+hTrvBfStVxEkxNMuXaug3qUmKz6qNwsHCq9ZC2OvpvlGj
         WY5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729874422; x=1730479222;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XkffEx/iqtllwnddkRmoM8bOQgGjVSaEbtQ0mnHn7Ww=;
        b=xFDuLTnAJFvliOBg6asLsHUvP2+wRTyFm1u+kSlgVvFf3rPlHKo3gfSW2PH7ky0h9K
         ct7khItgep6dFNkWTzA/b4VY/eeVsJd5lKzgLVAvn1hiPeG6UJ7BHJ3iVDyvy0sC0pr2
         niIySBkkXvsgt/LtEKCT6x1DHK45Wd+11+Xxlzj4tICVrTUWiiliomHvy2nHBZQdudrm
         rzidHDZO650p8VsJYZq1WR/GlVuzNkZEO8gejx+8H3y5SynHWEBtg7/BNxVphxxNi6Zf
         TVtmHKOAn3zvvHcEjAJhWc/TOgMEU1pLfpYp98Ky4h0WBGDqQf1FKPk6HnpxRxAiYaAV
         DFJw==
X-Forwarded-Encrypted: i=1; AJvYcCVu8hPbXExcZMK/GUjKsQFS0ziE/wzEQ5sGF0BOsUCrzFyFmNp3jTkE1ZmtoJzZ99r5GlKMY9z0CkFd@vger.kernel.org
X-Gm-Message-State: AOJu0YwVO82VXMcoyNprbKL2O6vf4jx7jC1x/s3W9j423U00Iw0qaUwk
	PDKI0bXEWngWKfDAsC4VGAGAVtSdXA747wfERVjgfnhuPBmGl6cdM3Bd3M6Tf8LSSradd7WCYGT
	3D/mZJ0AOUusPYd9TKNVxoFgXiUcXnjZbdg4=
X-Google-Smtp-Source: AGHT+IEpXRq6U1cWjGP/+pRg46LHk9teKroN4hSfvFuFmDTwZgazhJomw6aYJ+08ZHlX0nMC3Ji5LpIVdfuOK8SVPhQ=
X-Received: by 2002:a05:6512:3f1d:b0:539:f7ba:c982 with SMTP id
 2adb3069b0e04-53b23e0d752mr4357739e87.33.1729874421546; Fri, 25 Oct 2024
 09:40:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 25 Oct 2024 11:40:10 -0500
Message-ID: <CAH2r5muxd5VAivOGh1vfKkNSTphne3Dky3ZwTn9vZKxBBKXPmQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
42f7652d3eb527d03665b09edac47f85fb600924:

  Linux 6.12-rc4 (2024-10-20 15:19:38 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.12-rc4-smb3-client-fixes

for you to fetch changes up to 2ce1007f42b8a6a0814386cb056feb28dc6d6091:

  cifs: fix warning when destroy 'cifs_io_request_pool' (2024-10-23
07:42:44 -0500)

----------------------------------------------------------------
Two smb3 client fixes, also for stable
- Fix init module error caseb
- Fix memory allocation error path (for passwords) in mount

----------------------------------------------------------------
Henrique Carvalho (1):
      smb: client: Handle kstrdup failures for passwords

Ye Bin (1):
      cifs: fix warning when destroy 'cifs_io_request_pool'

 fs/smb/client/cifsfs.c     | 2 +-
 fs/smb/client/fs_context.c | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)


-- 
Thanks,

Steve
