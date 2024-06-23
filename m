Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18280182DA;
	Sun, 23 Jun 2024 06:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719125105; cv=none; b=RfJ5QzlOw75q0l4yb//2ZhzIBResdEKqfYjAiflWwP8pAMs/TPh7Wttd8BicOEizDp++1Qp8jNgSnm+jvoN9TfgisQZArfzDOEIzOJhPAl7mKecaBaPm1w6DPV5plm9LVYqXWYv+5s8GVTSPbxs+W2RnQSs/i36iSXzWnaXjsQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719125105; c=relaxed/simple;
	bh=zGWK5dgWVWqqWK1Xp2v04GaVCTE3oAOjyF9BijF3mpo=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=SauSULBjOX6oMhK3lT6YEYA7m7zSRRfbHgb6QQSMYxhe3fUvLYBsw7xuuGq0d60wQExuDCkZlqDb8VfXoeMLVgD38khAuVjHP3jH3/zsa9ika/n6fAXaRvGyqy1qSP4Is1Aq5be655botPBSDIxK7wyS3NVLaPB6ECtDtajhtgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TCchBqIn; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TCchBqIn"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-52cdc4d221eso1549525e87.3;
        Sat, 22 Jun 2024 23:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719125102; x=1719729902; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=b0HDme8zwzetpLVLe3ZLYcKIkWDYFkkDDeVg8ad57SE=;
        b=TCchBqIneki8nldUqHuMXniCmWbFXWeKGN7Lc/u/3JMtl2QSAQd8MqIkT7lsFlK/uL
         5bRVGJqlzUuxrQfS3tVqGB4n996/cJw2IhG25ev8TJVGqbBgafTLRD1wRB1bfatTB8PG
         +wKhVaGbi/P5TCTf3BM/ovIhrQwM96VnLNOIa+bj4srvQx+D1FHFeowyr2K6LICJzcp1
         jOhFfBm1sXKnwUSQb0FgbiS/v1eQ4C8DeXbB+W13yY93ZPBh/qFOoAuPi4AZArvyPMYC
         5dUNBvtTWjqc7zu/Pp0tWDT/FTisxKPZ9zEbKJiMGZbM8puLy8PjUYulykhhb/UMSJ4t
         M7pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719125102; x=1719729902;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b0HDme8zwzetpLVLe3ZLYcKIkWDYFkkDDeVg8ad57SE=;
        b=E47IpPOoZsNV0HeRCBpHLDvWnyBIXbNXdW9a5ZjfBX6xNSNW3ASNzcd1qOuxbYhN1X
         DZrp3dasZEFe0xvuJRHFw/h7/w5tIyx31/C3t+255l9LUmtcHIZtZXw19mw6uz/vpLdv
         TzTZKqVlIE6fdfdIZrI05aUzjrY6cjiDX8aSQQAV3vWiJ3MvEW/JoMkl+qgzUkW1gd2f
         uUKTazgbB5FYRiA3d5yT7PV9UGFIpt/pqGm2DCVmGR0XpU4b4viVw/sWPKg9Pkawiynb
         62ZKqbTGbbjdqe7/r0RhYSP155V4Y5RAiy+aPZihqC9zs1ny/8ft6yZWl4utW7PGKM+g
         W+jA==
X-Forwarded-Encrypted: i=1; AJvYcCVx4/g3BdtlvqtpVp9ChaIkhj/NsgxDILC64Fj+rYDdbpnyfRlLHIkD86XapnVnDNHuqWxy0EkrfBvp06UmF2VoCY/EPYtEvnNKNg==
X-Gm-Message-State: AOJu0YypUd383f2YZCkKj/T4dfDK7b1TzLavY/QPLXmLjpZI3t17/0u7
	G1HhueiTH3rK9T/VYOTyal0kSbOWgknCYEgAqYaSg5TiP8taDTXEC7fQckjxSETx/h+Xr3xHI80
	j91RJ0R695nVgbgv/c4hVC26v7iyDSA==
X-Google-Smtp-Source: AGHT+IH2oQN3N/6TojRQCylSWvwvfHLcu4jX8oVssZCi8Hzie6yb9ZJCjK8vm/Twz1asOyIBK+W2LmcUv3K6tetyHAI=
X-Received: by 2002:a19:a417:0:b0:52c:dc26:465b with SMTP id
 2adb3069b0e04-52ce183b261mr701460e87.41.1719125101756; Sat, 22 Jun 2024
 23:45:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sun, 23 Jun 2024 01:44:50 -0500
Message-ID: <CAH2r5muEks4khtNFc_rE=ywU15-6FfACkohXfxNGNvkdZ=0ovQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
6ba59ff4227927d3a8530fc2973b80e94b54d58f:

  Linux 6.10-rc4 (2024-06-16 13:40:16 -0700)

are available in the Git repository at:

  git://git.samba.org/smfrench/cifs-2.6.git 6.10-rc4-smb3-client-fixes

for you to fetch changes up to 3f59138580bf8006fa99641b5803d0f683709f10:

  cifs: Move the 'pid' from the subreq to the req (2024-06-20 15:25:08 -0500)

----------------------------------------------------------------
Five smb3 client fixes
- three nets/fiolios cifs fixes
- fix typo in module parameters description
- fix incorrect swap warning
----------------------------------------------------------------
Barry Song (1):
      cifs: drop the incorrect assertion in cifs_swap_rw()

David Howells (3):
      cifs: Defer read completion
      cifs: Only pick a channel once per read request
      cifs: Move the 'pid' from the subreq to the req

Steve French (1):
      cifs: fix typo in module parameter enable_gcm_256

 fs/smb/client/cifsfs.c   |  2 +-
 fs/smb/client/cifsglob.h |  3 ++-
 fs/smb/client/cifssmb.c  |  8 ++++----
 fs/smb/client/file.c     | 27 ++++++---------------------
 fs/smb/client/smb2pdu.c  | 19 ++++++++++++++-----
 5 files changed, 27 insertions(+), 32 deletions(-)

-- 
Thanks,

Steve
