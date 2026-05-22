Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623B728B7EA
	for <linux-cifs@vger.kernel.org>; Fri, 22 May 2026 15:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779465027; cv=pass; b=bM6wielmcFFsXkzqn7hq2f3zfhMa7s0zXOqf3iCbb86FXok0i6nSbySvPVUwvFZO65gg+o27U+Yp2DgFVFlgiZTzvATNip6CBFHwP14LD+5VDZ1OHKVEg1Gs0/0JHOH+NjPLJhJXwtCA3rmgm9bd+GNPSLoWvUNB7+/0lX0ZOP0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779465027; c=relaxed/simple;
	bh=u2SfmiQfv2KNJ/LaOrGDhl8QuBT7CI5YQFEvFtXk6IY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=AKJS+QNSyoloMmuCy9v1Nwki2nNdJV7BrJ4CeaRU51147hrmzMN7Nj/K79vIl4Wjt/Tq80Gd/LzrULCMNuCiYE2ZEBHx0wfjm74gCWGmS6M/9dZAWiToCaMHL+BQmc1Kgspix1XZktSlAD84rJJ+b+0QNA+TaxIt9FVXZh8meU8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lwa7L4bw; arc=pass smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lwa7L4bw"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5a62f43b76aso8558219e87.3
        for <linux-cifs@vger.kernel.org>; Fri, 22 May 2026 08:50:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779465024; cv=none;
        d=google.com; s=arc-20240605;
        b=JQgCwdR5qbeFTyKZArQ2u3xb6teSXsg2pcpWoaVRQuewqPZjFG+PM9aU8qlWqBWw/3
         nT2LaH7qqDiXRvvVQMr4FfcpBaGJzLI+EAAveFo8gig55fE/MoliikweUSy5pN856Frn
         vPUCYI2YEWFBQJZjZkYeyFTx27MQu5Na+ctNg062wyIHeTvZVzlBlr7XJ9TSk0rkwOR5
         qaEZbWeahqjwTz/dNw8Kp1wLH1ERcpiB7+AvGrX5qFi8YNYJqJDyqAsUAzRouoL3eSGT
         Ruf5m8OnNzo60+OieB2urcr7W+V5b2CgH9qtmQKH4SyUAUyHIHyutS0w7nmv8wNsBV31
         6kmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=y5axxcSD3iSMtyMyeQY7GM6ntyPDO8keied/tb/1CNA=;
        fh=d7wB+XTiiUHL+Om++lWCRo7fTwm4v56OvYCQomH0cdY=;
        b=J93on8OYW1brMyEXxQ7i0JG1/+rizSEwawpbqmQV3ORBt3Z/RflXuZg97lBFnuemuG
         nL/SkQ/UmwHMyIjN6RkzydBH/rQoAqZoCLU5prfVVrN6UxSuuW3i4k0rHitQk2dv+DV8
         kOS8o+6021cC0EoVIlHpNdXxwvma1oyrLqgKsxVx6xPcfL/497Srsg/wRRZ/QERPVP4f
         cilEI/wzjcy3FGb09BG6syUFRiiMeRG33C/+v2udXYSGECLi4okJmLSWuFNerFqMgAyr
         grgSTpL0GtobQExtQ1BCpaU4PnchKWpKu/pX5o//xmum4roFnyCrZW2ekSy65yNV8729
         De8A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779465024; x=1780069824; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=y5axxcSD3iSMtyMyeQY7GM6ntyPDO8keied/tb/1CNA=;
        b=Lwa7L4bwDr7qie3YTQqp1GtPxZbtWu+HF9vpyc9kd39gXqlPlIDJqrltI+mTMdCM7J
         WPYT7qg5Gkn+R78tIU5vtturvGGW5x4oMgUXiVGPRXvMf48CHlP3T1ophIo5+oN1im4b
         RLW49VMGCMinU4VZXL66EZBbyfMxjqrV6+a0t4l6EHETLf7/K6rbcNwmeUxO997dhlOT
         CoXxkWbXnnJlg7jvr3yNVqJZurKxoc10aAEO1/NV6BwmOUtVt5i/dkMSfj+K43gCNtlX
         wVQb4fcZTlAgDniKuPooEsfJrTj4f6Ubuc9Nc/tfLwlZyGPwZF5hYjco3e/jVu8f0EhN
         5mtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779465024; x=1780069824;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y5axxcSD3iSMtyMyeQY7GM6ntyPDO8keied/tb/1CNA=;
        b=Atg+cqGlOCHIyBEwIL72IjvoA/cF1LaBgiGe+DuFVHeQqzIn/C02ydD2afXMmrMlXT
         3xaubMwRsaQYIt7G2wRWqPGT4SHwKLJfeMxzBEIqoVOxogTz/SZKw0XckN/YY6DLMmv+
         ++dsDX89xVjF3G2FUPQewrZERfPGsPdnouZb7Fs6K9+P0P8wgIvt4aYF/8PHlPENlG3O
         /nOulGeuLL+f9QhRCTWdC1uA17NyapRB7hS86IM9C/PM57H63NrNCS78/FGRn98aQYmr
         IRXlHdKUYtTcmbhRuDFq3gGHbch2Gt70R3paODQzKzVag9BIHU9EpxXWSaqAyHqjeXtZ
         cuzw==
X-Forwarded-Encrypted: i=1; AFNElJ90pdxvg6xTWODC7nWI5wWBZgfTUuTOZVvJAUleQcrggJ+Kkqh0D6tlk5OKFpZP3+pzmVtQlgUFePl0@vger.kernel.org
X-Gm-Message-State: AOJu0YyoroJbYeqB/Lx+wo/QssU/WG4uQWXzC/1IdQOjqbV0AeFVxN3+
	FQcuJp/YlcDPJiW/wPyqpvKIJ/lqh5NiTG29l13h6d0be9VyWguPzkQgJ1znqCrofn5E0zR8NHu
	ol3WsTt+1T9af3/mBHc7AIcQmtA/duLz//uF0FAM=
X-Gm-Gg: Acq92OGSiuoSrE3qG+y8QlWHiGwL8h5jKVAMzewzDFwbZUe+MyEUUiMQH+vmAa4j57N
	pK91MPccKHADTfVean4dn2/tyVVO1LRtzEPp8xRZLm0T/yNiVcAT3cHzxB2bIiGCVEg1y/uvPmp
	YuKcKAosf8HtvECN/4KSoXY1VNADXh+1DRenhSCoSz5Unv+L4r8Z8aD1T+Ev04sjfGUH0NhuBSu
	actKvpegYlGacxJBSh8itx/X+sYfHcoOdiwweCgo7bRcEWbAm23h6mNqgzkIb0mLE4TVJZjeVle
	ACGb74SlbEZ4zfL+wJUlvVkzT1uvQANkthxHSkiB25qTOyThxYCDar5zDpcHI2xPzFtupsYeyoZ
	WqmCoeH3vmPXYO+lgKtbhm9T+0brCvT0VLw9rSMu0lPvlNBBZv67yOihNFLLcFBzZm+uU+KB4oc
	aWm5pnrfQxUTgH+Pno99gjmFjmagOr+UAq
X-Received: by 2002:a05:6512:31c4:b0:5a7:4a60:1454 with SMTP id
 2adb3069b0e04-5aa323a93b2mr1522530e87.33.1779465024341; Fri, 22 May 2026
 08:50:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 22 May 2026 10:50:10 -0500
X-Gm-Features: AVHnY4LvA_dtnYC8LimP7KHT87S_dEzTQwfBHj3HV7b1WoTBRvWBkKA4dU_nO3U
Message-ID: <CAH2r5mu4Gn_=ytSix0xtuSLp5ENp0pgx=M8xBauG5-1U-+y2rw@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
5200f5f493f79f14bbdc349e402a40dfb32f23c8:

  Linux 7.1-rc4 (2026-05-17 13:59:58 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v7.1-rc5-smb3-client-fixes

for you to fetch changes up to dcd4313f0987d69c4134c12bbe3a8cdf795f6c1e:

  smb: client: change allocation requirements in DUP_CTX_STR macro
(2026-05-21 11:16:09 -0500)

----------------------------------------------------------------
seven client fixes
- Fix missing lock
- Fix dentry in use after unmounting
- cifs.upcall security fix
- require CAP_NET_ADMIN for swn netlink
- change allocation in DUP_CTX_STR to GFP_KERNEL
- minor smbdirect debug fix
- handle_read_data() folio fix
----------------------------------------------------------------
Alexander A. Klimov (1):
      smb: smbdirect: divide, not multiply, milliseconds by 1000

Asim Viladi Oglu Manizada (1):
      smb: client: reject userspace cifs.spnego descriptions

Fredric Cover (1):
      smb: client: change allocation requirements in DUP_CTX_STR macro

Henrique Carvalho (1):
      smb: client: protect tc_count increment in
smb2_find_smb_sess_tcon_unlocked()

Jeremy Erazo (1):
      smb: client: use data_len for SMB2 READ encrypted folioq copy

Michael Bommarito (1):
      smb: client: require net admin for CIFS SWN netlink

Zhihao Cheng (1):
      cifs: Fix busy dentry used after unmounting

 fs/smb/client/cifs_spnego.c   | 16 ++++++++++++++++
 fs/smb/client/cifsfs.c        |  2 ++
 fs/smb/client/fs_context.c    |  2 +-
 fs/smb/client/netlink.c       |  6 +++++-
 fs/smb/client/smb2ops.c       |  4 ++--
 fs/smb/client/smb2transport.c |  2 ++
 fs/smb/smbdirect/debug.c      |  2 +-
 7 files changed, 29 insertions(+), 5 deletions(-)


-- 
Thanks,

Steve
