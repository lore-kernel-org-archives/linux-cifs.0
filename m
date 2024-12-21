Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71711A841A;
	Sat, 21 Dec 2024 03:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734751662; cv=none; b=LEciukzpZdBya2uwTZuRY0xXvW3ql/kovxXppp/PIjrVZ2ZoZR4b85MXPKPgdfJa4ocHUmRXsGz2g9IRKYYOss8Uuy9tCx8Gt0XaswDrlBC1kuRARRF2sWTadT9wpAjG8I/iZ6YJqSG5EeCo8VaOumezsOaZKe5rrRCi/r39xc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734751662; c=relaxed/simple;
	bh=rubgnwj5/9ZxRG3BkSM0MTYYGd810ghgLYvBpI3gcS4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=ja+DbJCm0k1TlfutrzaD70zYEt7Wu6HMnv3n4JFnlEoE49uHW4Ka3EA4NH4/VTKS8E01MJJl+h/DI0KKXciGiPi6gpPFtW/Mu7KKn6R/oVIkLbloWyL12syI6eOkhoITJz7v3E8vfofTr2fKs/4PEVe+0p3k/z6EacBq4zPRHyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NvGH+K4+; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NvGH+K4+"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-54026562221so2445405e87.1;
        Fri, 20 Dec 2024 19:27:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734751659; x=1735356459; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=96DeUPdpKFj/5zSnGwKoF9G0VXYJ5enVxaoUjuGpltc=;
        b=NvGH+K4+1+qHUC1C0tOfNp7SZbvf3BOA9tZkrtdQkcdyNulBcAUtnsAS4bTBRZvc6T
         wahsalIhaSufDEyVF6Rn6DyN7loCRfg/zyU8s4nJR50vY3pVQV7NLehSFBny3EooPqNq
         3oszcd3yl55EWEyoDPy8gJN+n47WdXdBy4kLTr/czyPWvkP5tbm6TLSbusUIARnq8pQ3
         Bl3GuE26a854yc7gqp8wGr2DYnechLMjQCww5+FF5emv+St8CWSCV1L1+bshfhrE8h5C
         q5sVigWpglNyY7SnaHpdJqhz6/PMEv+uZShjJYHwPyZaxGN5zQDn1XGaMpKNe/O62j5H
         Hi5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734751659; x=1735356459;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=96DeUPdpKFj/5zSnGwKoF9G0VXYJ5enVxaoUjuGpltc=;
        b=vvf165R9NpZuSNjvIONXKMSZ66XmBIU9BxWxDWo1LgJX+3tGgdr5TCikR/NBRGdDm4
         PPnSnnoOD8ML5DXDMA/z6IvEvfidUMuJfjTKEwiVV+bKcWV44SmMr+kvSD3VOlggKqi4
         eNdJukl7zU+oAerGL/fEW9kjcwH/xOzGlWaXCJA72loNcyo/BPhCx9qRmqsXnZLng25s
         CEwjD55PAgS9HAxs70PaX8dyYdpZd4/nkDuwa8KJOGFv4cTUsQh4YFQcVc5oMfmLYw0z
         xKugcYt8BZhWEFidt5igG1MjtEXtPbvr/Eb1HO/BsLBFZ2zeuCC6Fqd88i1WHyKBejIz
         +qMg==
X-Forwarded-Encrypted: i=1; AJvYcCVOv8JEte+Sut4sVTIvKbYQHwKT0nT4h5VF4P7y5RTe1796007Ysj/zIz3G2fYOmJzsSXNbq1oN6yt6@vger.kernel.org
X-Gm-Message-State: AOJu0YwXkcnTYtiG1Yf9t+D3ExDWIGXeEL994IKRLQ4Ladx+0XbL1TbQ
	rAjlchTO1U0/B5yCPyoWgnjAdEwT17Iv6ga6ZjohRv9CH2DFdU7/zKk7ZqQygfeCAbN9beOsrIY
	854dRa9mbJyUhZn+JHgZARMLxKgM6UMr/
X-Gm-Gg: ASbGncvsmLyvX9JWUdxYnQkjpcOqt3UU5980U9ko8MnYUK2pUVfDZZqaWnMicKIe0lI
	rQK/ykwz5a2iv6YGo3WiiyFFNDjuapA1UGKn/NA==
X-Google-Smtp-Source: AGHT+IFXMQRlKzrykmm97yybUr97nM0J2zbFmJZlr1gaBp34CAIkKF9lDpLAAIP8vbh5XOwzARgN8FuB0ITye3oNxrM=
X-Received: by 2002:a05:6512:12c9:b0:53e:389d:8ce4 with SMTP id
 2adb3069b0e04-54229549444mr1401487e87.34.1734751658996; Fri, 20 Dec 2024
 19:27:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 20 Dec 2024 21:27:28 -0600
Message-ID: <CAH2r5mvT2k2ToswPuhzqtcxTjAa6mAEYgZ5ZOHUeE19jYq=xoA@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
78d4f34e2115b517bcbfe7ec0d018bbbb6f9b0b8:

  Linux 6.13-rc3 (2024-12-15 15:58:23 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.13-rc3-SMB3-client-fixes

for you to fetch changes up to 92941c7f2c9529fac1b2670482d0ced3b46eac70:

  smb: fix bytes written value in /proc/fs/cifs/Stats (2024-12-19
12:14:11 -0600)

----------------------------------------------------------------
Four smb3 client fixes
- fix regression in display of write stats
- fix rmmod failure with network namespaces
- two minor cleanup
----------------------------------------------------------------
Bharath SM (2):
      smb: use macros instead of constants for leasekey size and
default cifsattrs value
      smb: fix bytes written value in /proc/fs/cifs/Stats

Dragan Simic (1):
      smb: client: Deduplicate "select NETFS_SUPPORT" in Kconfig

Enzo Matsumiya (1):
      smb: client: fix TCP timers deadlock after rmmod

 fs/smb/client/Kconfig   |  1 -
 fs/smb/client/cifsfs.c  |  2 +-
 fs/smb/client/connect.c | 36 ++++++++++++++++++++++++++----------
 fs/smb/client/smb2pdu.c |  5 ++++-
 4 files changed, 31 insertions(+), 13 deletions(-)

-- 
Thanks,

Steve
