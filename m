Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A616423C50A
	for <linux-cifs@vger.kernel.org>; Fri,  2 Jan 2026 03:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767326062; cv=none; b=DN3Sx1E8Zxwl4rwSTpbHmu2XbUjyhGOEX3cbufg51UuanpuvGF5CYWEPL2SSstj1kaGcN/MCgFvp8gRf9wA5YOMDSdlEm33A3+xBF66hCoIO0nirkT4j8FPsKAFwKudKbST0SZoIamc+7DBis83vnbfIKfvQgNH6sZd4dNaaM88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767326062; c=relaxed/simple;
	bh=y3mA4ItRr+3SbF71gxTpXk0OO5uUGSsVm733vrUDM8M=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Wr+ru2dmVoLtenczW5Mn1pn9Cwkh2bCtBI5TWrLu2CIsgP+WQ4yIBFT3cmojxB2QXkzJIjz8NYnNkBbeoca5p6CVjAE9YbUEk6THWsHneaZS3GV2RF2Ta5foZ5hS1afp7HalrT/r0+fezedsZPkNL3X52DKZMO8YNN4F8964Wz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DEt4p425; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DEt4p425"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ed9c19248bso101613471cf.1
        for <linux-cifs@vger.kernel.org>; Thu, 01 Jan 2026 19:54:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767326059; x=1767930859; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rRhSPZP5WvVax8UHgJMah0AYxpmKWUf7qtYho6M4+vY=;
        b=DEt4p425QZbBEs2CMQS5h21JS6GR+RdP3RkxGqT2xr/6tBADe5OCXotvP/dPIjGWdZ
         S5i+YaCzqGV5pVvdJ2bRorIaCMQ0ctBLsSY9hwd4aJSSZ98EAG+4s9uaqsjjqJ/mkEW/
         j+RBGfdIgLlajHZ7U4c1YApx0l7UXzRn4KAccU+3M2VXtY0ThS59JidPPwrPDLXMwAqc
         FEJiVSTH6EXPUxjCtgShn7LzePi16CZ4OB43tU0MZYeFkZUHsFVd/0yCxZiRl0TMqgGk
         j3pNPFf1j5JjMzsUzDyZ4Nkr+UAJDTD9iPeHR+p6CUzMN8LcH3fYEdaxpsGXnFs3D3PT
         jqdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767326059; x=1767930859;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rRhSPZP5WvVax8UHgJMah0AYxpmKWUf7qtYho6M4+vY=;
        b=mIBLmc+EawAPzpG1267ng+tEyJWwt9SamEo+LRoHunQFYamnnJTa41eoW1tQau0Bkg
         nWugIstFbUnj+2g4pmY7LBwePoiHPmjrreD0zxkYULAr7lZZUSCJQK/V/XBmDIzxJcmK
         iv4gfffBMw41XgFH2Z/uGETpKXZGniNZui64omNm8yjEtMOw0mvDZ0XgcNLIjV0UHckp
         fj21iNggLwcLA1Mve4obzyPNZQUbO0EM0Jjmr0sF5uI1gONGrZKLnUDncV2HQsqRlQSK
         0nBAjMi3bCSabPXofe2bJ0Q2NipKCuQ+NuCGbaWBSjLpT9FMUZ9oS+F2t8P500DF5t2R
         HvwQ==
X-Forwarded-Encrypted: i=1; AJvYcCWtY1yKfXsLV7xcGTPByuj2cmQOaD+WS1qgyiXg+d6f8/MD2YRwU5GfJylbwp38J4fASkrI+7w9R71o@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5ublqMdIh37auxFlo1MwvajtzmzoHsexo7UtFNyslUI+sWosI
	FXDEX2hb9LrWAvRbyzgW+j0XW2J+TL2feFD4Q3V3/USOYFKBUC2b4v6kjsO6/yQB7RBKeKukhpN
	siLmakD4f3tecADk3fJ77ibXxNRFyev0=
X-Gm-Gg: AY/fxX7fMCiuR1Np9FqzL33g/0C6oXvXbtAkB0DS6hCMsAoJ9KPQH7QmmSAFnh0iyEw
	sigN87ALORYih3ShMqRkyCjApzmVSppv1YTqhBl9eNDXCrG04tgLJecIjS1NplP2ZQDoi73khzL
	WqEZIt/9r4TulSsrufys7ra6ZuR5i3W3qfZNbJQlynaA3bSx8UxaqdDwhd2jDlKOWc5avv08/tG
	FnvP5AizruJIitVJgS6G1pwuJIChqQN0Y8pkTxKHrXzpa7UT4ActaKqmeIImKXvxMJ+6eI2PKgT
	M0NZiT6jKGks3YeZSmv5tHfgs+6SNzQvN8X9WlP21UJT2/9It/DMojoUkQEPkZkhNUgD86yjQOT
	/56MQtU8HimcfzIurFBCCVuJOzT6eDPkN+yHCjOL9VU7q91muWgw=
X-Google-Smtp-Source: AGHT+IEruY3B8PsYyfhU2KJWgqnP5UPeAQQYE+5t227ZFfh2eWyT+mUh+/8GM7Fe6RDH+QfmRwUOApYD+hObp5G6BEk=
X-Received: by 2002:a05:622a:cc:b0:4ee:9b1:e2c with SMTP id
 d75a77b69052e-4f4abd35e3emr676950681cf.33.1767326059533; Thu, 01 Jan 2026
 19:54:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 1 Jan 2026 21:54:08 -0600
X-Gm-Features: AQt7F2pwwh0jRIe3Kk8_vBAPCszjYv7yqwf3XEpUv3Aw8Zv9DY1qKFo2paF9YBc
Message-ID: <CAH2r5mtb82d1+_nY=Kk6F3VN-8V3sY8f-PXtK0E=sa_C6vgtUw@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
f8f9c1f4d0c7a64600e2ca312dec824a0bc2f1da:

  Linux 6.19-rc3 (2025-12-28 13:24:26 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.19-rc3-smb3-client-fixes

for you to fetch changes up to fa2fd0b10f66b08bc44745feed1761d7c1539d6e:

  smb: client: fix UBSAN array-index-out-of-bounds in
smb2_copychunk_range (2025-12-30 09:17:41 -0600)

----------------------------------------------------------------
Two smb3 client fixes
- Fix array out of bounds error in copy_file_range
- Add tracepoint to help debug ioctl failures
----------------------------------------------------------------
Henrique Carvalho (1):
      smb: client: fix UBSAN array-index-out-of-bounds in smb2_copychunk_range

Steve French (1):
      smb3 client: add missing tracepoint for unsupported ioctls

 fs/smb/client/ioctl.c   | 3 +++
 fs/smb/client/smb2ops.c | 6 ++++++
 fs/smb/client/trace.h   | 1 +
 3 files changed, 10 insertions(+)


-- 
Thanks,

Steve
