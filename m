Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63484422532
	for <linux-cifs@vger.kernel.org>; Thu,  6 Aug 2026 22:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786055010; cv=pass; b=Ms0fCEyPsEHce+GTJslxGKzChioRBLpKzv3YT1RG8fMa2tDV8PM4dCk6Nya82b2qYw532xDUtdOEnZ6xbHSQsQMNb+QDpHlFjul/Aczt0QL9prg6MBKTugIcDlgBvzZyOXR2DsLdz+ZTNtayi5913cKDEIigyu5cZLUS4YmVC6o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786055010; c=relaxed/simple;
	bh=pK/VZevyc+nGJHah6XfL+M8SSMGwXrmIaeo6mwoBSBE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=uAEmSgtq8p0Aku2JPzGYcO797p5Er51GqCtuZT8X1uJ8vNeUhTPTSA+7Tm2V3euTq6Sbe2CRpsS6M//lHiTXVsynFRqOUL7ZgEghrwK0UEeFXmQJOsZ3kvYnhliMNMOYYYAN1THIC9EE29H+REQgFTOTnxhtC1wYuAZsZs0S3Pw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gnd0mac9; arc=pass smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gnd0mac9"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-908a2ca5becso908326d6.0
        for <linux-cifs@vger.kernel.org>; Thu, 06 Aug 2026 15:23:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786055005; cv=none;
        d=google.com; s=arc-20260327;
        b=QtWC6bfGcca+V0B7Fou8PF7gRlgT7EHVsPcrzC9f5GeGmdO1mhL2thPTwcTKbNdp9m
         YNShWpBLVqQcuSUnoq4qHT9R+LrEJiytSgvj0L3dxXlmAYi94U1HGBthASrCP0nOPUQa
         v6ta9a/V2iaBrTuLk7Iz9/HM7DN3shJdR1l//7CYPMyRZje0NqK/Mkqmm+M3s2X59Moa
         sup8l9kPB7ybV2YhEu/2I1SxOJdy2+byMXZFMqTm6VeSGQRUhss5f0wwMAiUbCRdaoHb
         3iR0fUvGZ6o6h+Ikm1jge5ixkY7LZE/eMEX7XG+MTddCl0pslVGqgEIS/bsOQ+1yCA/V
         JtCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=kgWNyL7eSIzjMt2OkjUM2nEGx85W+qRuUJnVqft+lXU=;
        fh=TgbYcRS7hkRZZ/f8+VgkN+DgWeSx8yFxKyVLwUmG8v0=;
        b=IVDPKu1IucgMqF96Qg+XVNpypPCDrYRyq34pnOAzVkHiW6cx/M7O7DSZWNasSVbCVA
         qxVgWrMWyULuZgMV3I/URxypxoKc87R2XoLmUQL7wDxRZzE4laiXjJQWAH9p80ne5Pht
         AbxWkAFDxXPW8pcZDiCXPU3twvdJz+4OZC0krMFCBGxlRTz9kU4oLsSUWRuzqMhCIF21
         r20ZLWV3S1kVr6fGada2U7LeUj1CXFZ6eumnksHXMa9Y6LtHb87d8SX81SXa0dw074wl
         w4QAApZOh/BhL1YQlWCYOczJwiU52dTpVt0/MRsprQ6DAHsJpvewx5AvLLCxVntrEDwb
         qBmA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786055005; x=1786659805; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kgWNyL7eSIzjMt2OkjUM2nEGx85W+qRuUJnVqft+lXU=;
        b=Gnd0mac9E5lkQ0caq9y/li9av4/4CgYbwcsBvtfd3PLRz6r7jlTVc2CySy0pFK6IqD
         IEM9vTNGyinSmfcK90yM1lCJaQMfieymkmA7HKWayOuz9F3tnBJt890sIDEZoROrsphT
         VudimQkzZI1mz58am+qlzNzeSFdC8lp2GZ9BKkgtf7g1ktbi25PBdbBTREmfKg3zkZdA
         J7ZFwSdExxhlIwS8OZ3IPVNCLp0eIdYdgWCA8z//LFKxP8iLArQSBFiYl5xNJXhKZeWu
         XJEcOUWt9FFtfOVYSwoU58w5a767vE6HbYJlwROjR7V3bEKn6yTAvpqiprUNPY5B3udy
         O9hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786055005; x=1786659805;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=kgWNyL7eSIzjMt2OkjUM2nEGx85W+qRuUJnVqft+lXU=;
        b=mqgJHIb4xczX1vCrKVdn/fAa+36hylthDUt81iQGbp/33WYGUX24cC4xWatZwoh0S0
         Tw6wxqDlpg4y/kr0mloPgg87GqLuxRp4WWzNV9A22hYxKCCxR6rgHXilz6dZ1o2zHp5j
         ST1y0/0eYzvsIY42aQm4Y4gwOkOfiWAaLphmINgF+I1gxJM4yYFaDpi3gJ5ax2rd97aj
         SJEz1ZEdyuAIJVzQsYPDXIIu4r4TSh9Oki4/r0+IX1OUW5uYJ8yo/kSiUuFb6bFw/p0n
         xcHizYRniu0opDIi9a5482WEjs1ml8/IGAwI7h3Z+dJnBI9/VAC9zeIfa2P43ERIbw9u
         AeTQ==
X-Forwarded-Encrypted: i=1; AHgh+RopHu5gQT/3byzQWAD8pIrdME1zsdpXc2nbgyXYieQwO5jNB05ybMXNk6lBwBsXYqQ6IHZegC4J4r66@vger.kernel.org
X-Gm-Message-State: AOJu0Yytk/wVYlXAcyLwzEl+28CZv2lZKTtgoE1iFNtLsaEBeJRLA7/m
	Ds9qzl7AxjRAHo5o0XTYU5O3ouqHKBtJSTq7IEGdh8gGJFti4iDiu8K8VkNFIAF4DfPj+9jMjqN
	1hYgTnSn8plJHijfSUs/k+Rw8tR8owHs=
X-Gm-Gg: AR+sD12D229tw4U6+2c3Jd27lZJ9MpC+rlD2gDQpo6BzXo4WSgR/KGK7pvygM5WjRoy
	mY0nd5uoT3/NvEIrexyo4QnDCwbmyaRbmqW7d/Vnpb3jxab+Bk0+Cqg8tqTTz+ihabw/v5RmLbT
	59e//sqQonIMbzfWowGf8pa4HX5xHfQlHHul3SIhq3639mdByPR1KJBVphMU1X5gsWVc2Rg5VkS
	1Y61v+YPk3eQMYo9PPoLlJitAyeMeEO2JG6Ysi/HrrSYVlAnPtMcspOoIfc2szwRsKIXvtxSa0n
	CYzeTtf3gc/phJWKghAMwjHdzjN1cifa8iIPkS9oysmVe+NET6EeCEFmqJuGwiQgN5wd/2Xpevz
	EBkb9VIAvPuvXlMxmPwPo7oGPfb9fLRzLRRvp3xUs5wMS8p6YeadDMntiPXB+HkT36ORtIFXTw+
	BqifEeCLdiez2M+9dFwsRpxq5axbEL/SVKVh6KB7SVGo9sMPdke76zAwT2Hqk=
X-Received: by 2002:a05:6214:19e8:b0:908:8f97:7d9c with SMTP id
 6a1803df08f44-9089c03be27mr62385976d6.30.1786055005411; Thu, 06 Aug 2026
 15:23:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 6 Aug 2026 17:23:14 -0500
X-Gm-Features: AUfX_mwMI8MV3o0amsndlicc776qGgKw7L9T3Lw0OaZLhDGr9NONuZfxQlGY3jw
Message-ID: <CAH2r5mtVcOC7XuoAUQkzV2tGpv5wBN7DOqxz0SD+nEbEPBLFbw@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
075b74841bd0065a3bda3440873c747938e69b68:

  Linux 7.2-rc6 (2026-08-02 16:24:24 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v7.2-rc6-smb3-client-fixes

for you to fetch changes up to 26fa4d17c023dbe5427a92d3a7bd9ae1d1e58bc5:

  smb: client: fix SMB1 TRANS2 multi-response truncation in
SendReceive() (2026-08-04 18:17:02 -0500)

----------------------------------------------------------------
Three client fixes
- Fix potential use after free in cifs_try_adding_channels
- Fix SMB1 large directory enumeration
- Minor debug improvement (show compress mount option)
----------------------------------------------------------------
ChenXiaoSong (1):
      smb/client: show compress mount option

Frank Sorenson (1):
      smb: client: fix SMB1 TRANS2 multi-response truncation in SendReceive()

Shuangpeng Bai (1):
      smb: client: Fix use-after-free in cifs_try_adding_channels()

 fs/smb/client/cifsfs.c        |  2 ++
 fs/smb/client/sess.c          |  2 +-
 fs/smb/client/smb1transport.c | 28 ++++++++++++++++++++++------
 3 files changed, 25 insertions(+), 7 deletions(-)

-- 
Thanks,

Steve
