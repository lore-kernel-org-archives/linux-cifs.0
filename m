Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746541BDDB;
	Sat, 24 Aug 2024 13:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724506540; cv=none; b=fzqnsD2/kc9GuEu46R/jbX9aSOfqU7sHPnkEACoP+7LwT0+za9/g9AAeCN0GrykIOvvu97m91QM8YsKu9IRR1kS2V138cBdWQlogBJ3uXdlnyu3PJ4dN56wowhgddK6khg4QAsDIPG9MfY2UaIdayyCzdYFi+0YktQpX67X7xUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724506540; c=relaxed/simple;
	bh=K/ysHGSh2tpJMGU0zcN1LbvUjYwlWxuw99THfl478WQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=msGBSUjcWEz+VDFTMdZbv1LBiaux4oDlBf1FKnl64E2GJkeMdOqmQiRRJEuvMWh8eNZWGzPYkPeFOSsZLEHCEnbuHPnVL9Sz9TXvRgxidgIHsyaVs1jGJ9pclNfml+8wSzf12MQy+hNi5PgeZVnIEj5krtWwHxvLXsRR4dGN1b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TepTd2Io; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TepTd2Io"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-534366c1aa2so2009423e87.1;
        Sat, 24 Aug 2024 06:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724506536; x=1725111336; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=loqmru87kWNBUwgs1DTG9KZigit4FCc1OkbpRIzXkKo=;
        b=TepTd2Ioun/GRCaA2HP5BCYojx/gbqwkKzRMomoaeyVCBm4DS5NXv55ZiwKcJgQCIA
         0XUK+SbQ15f/PgT8B3YJHDX5c5zK2enX55rxmp7H9rReN5rQ6Xfdyfh73d4/mtrL8L8V
         rHMoJTwcTBttCB74X/8+nI+J+bfjjbqHXOON6abdZopEgvOB8VX5gq3wtCKlmrrBe4dN
         J6+cJm+9JH2RtMq7JPHUsDMWQG+uaLIGB8g18P/bZtdPLbryAlSe1TCbtc1CZLD7vbPh
         z8dL1AZnvrML1urmJiFYPNM7vylnawF01MA2H5RVof/aehpQUopwJOExBPKzs8gGI1Vf
         OQXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724506536; x=1725111336;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=loqmru87kWNBUwgs1DTG9KZigit4FCc1OkbpRIzXkKo=;
        b=XFcfHDU6KTALpCJZIwHOuc9tklUjIvHmiXOyiZyl14BFAKmeIoag61Be5fMhZbbbD4
         wI2CUxYueM2BpJQqHzaQuvfdCuNDe0Xueqh5Z6Ca15t3Saoar9pX81ZchCyKnqV4+B8B
         5W8anzT16Z9zplK8omM7kl4zA1DrD1D+MztzMKDfHWux9LjYwCxvARlewCpvmmo84krr
         dn7w0iFtbDb4mg5IeqN9wdDyeach3wrinM0XPzHjeNC1wsZuyu+nd1/Q2gTcB2qxR+hX
         ci/WaqIf7NOyl/kkqeTAHoG7kwElqWuhmN2H+VyGQp93IixX8MIanSiTWzFoL9Hi6rXt
         7b7w==
X-Forwarded-Encrypted: i=1; AJvYcCVDeRORNw5G9aciF2rPhQ2kZ/4WdjSw4QCg2fVKdJpMpSSTjw+b9VbZygziYA3WrukH5KMnEd/aho8f@vger.kernel.org
X-Gm-Message-State: AOJu0YwlOCCuTDJOIkcCr2e/XDm+U1cmqlX0GPuMu9dB44ZmHIYkRKsK
	gVrW/nXg8metqRmRYa0adPF7qxuB9Ka2z7/8jRucjeAuqklY35JVTNsQ2AjQp/9xbqBLyPkG0mx
	GQcbI3/o2z/yM9elHKTgT0YcgPFsbrw==
X-Google-Smtp-Source: AGHT+IFsJFvJKiSYg5+HQTRFRMt8EpNAVNRT1cXUCMCnQ6ElfGri7YUdpNRCdpj9IH7SB08a7En0SqqJVfkzshY1eOA=
X-Received: by 2002:a05:6512:3d24:b0:52c:e3ad:3fbf with SMTP id
 2adb3069b0e04-5343885f866mr3083774e87.42.1724506536013; Sat, 24 Aug 2024
 06:35:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 24 Aug 2024 08:35:23 -0500
Message-ID: <CAH2r5mt24xmXoKUiqHhGzEqXxwusQQQ9iQk0up6xzMbP9xfrKQ@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
b311c1b497e51a628aa89e7cb954481e5f9dced2:

  Merge tag '6.11-rc4-server-fixes' of git://git.samba.org/ksmbd
(2024-08-20 19:03:07 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/6.11-rc5-server-fixes

for you to fetch changes up to 2b7e0573a49064d9c94c114b4471327cd96ae39c:

  smb/server: update misguided comment of smb2_allocate_rsp_buf()
(2024-08-22 09:52:00 -0500)

----------------------------------------------------------------
Five ksmbd server fixes
- query directory flex array fix
- fix potential null ptr reference in open
- fix error message in some open cases
- two minor cleanup
----------------------------------------------------------------
ChenXiaoSong (4):
      smb/server: fix return value of smb2_open()
      smb/server: fix potential null-ptr-deref of lease_ctx_info in smb2_open()
      smb/server: remove useless assignment of 'file_present' in smb2_open()
      smb/server: update misguided comment of smb2_allocate_rsp_buf()

Namjae Jeon (1):
      ksmbd: the buffer of smb2 query dir response has at least 1 byte

 fs/smb/server/oplock.c  |  2 +-
 fs/smb/server/smb2pdu.c | 18 +++++++++---------
 2 files changed, 10 insertions(+), 10 deletions(-)

--
Thanks,

Steve
