Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A7E1EEE6;
	Fri, 10 Jan 2025 00:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736469454; cv=none; b=P4Te4/tYV2QgC84Pqk4QcFQVL06oFAWq0+1VPiwRmxjTSXPFglSi/yv8zgvJO7qTVvVqm/nj/swy65e9bmO+xAKKP2qUMNaiqIIDrbyWBW426mKYCoKvHxhqwrTN2hTXYMVh6mExaEdsPKMjvd/sW2LnNCVybWWDovraGp6ZenE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736469454; c=relaxed/simple;
	bh=saIWlCsNWck/lIB1JB4n9H3t90D8WxpDJTXggACNNOg=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=ocxg1ebJJo7LkQiBGd8grMtgv0xAOZA5EqzwJ7E+/lr1H46HDgSXiCuyNOM2aT3YTMyqf/hyoeZ2nu7/q6JtMeL4qbsbmOjIDZlzL7Rjl+Zcosbzx3vqWdbP4ZgiIObZgv95LDy+Dk4WnrhvhsL2MNcVmOjuPLsvOXCZJ/2WJv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FxC/08fU; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FxC/08fU"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-53e399e3310so1553735e87.1;
        Thu, 09 Jan 2025 16:37:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736469451; x=1737074251; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9QMVaLwUp/s5Yq/Lrd/xvFBo+JhGNOLNDVAzeb24SEQ=;
        b=FxC/08fUYT1j5hVFGAhTHiTw/ZkKkO1J9Z/VOwXq6Sr0gvBEb+namM4azDUeg6BxEQ
         8uxar4ZH5gdxTv0sMJxY/ssnZk1qX3KCgpe6s1VwzkTveiMCB6jGYAVmN9tjBxTBawuP
         mLwFRHpsXDEZm8oCItP1GKRWLzku+Kq6JWYQNZxKghm1QCDSqmEVp2ZkSmqZbQ7VPukl
         W0Tt8+u0gkH7iTZjsBOKrlOdztC0vjhVXo/EVH7l0k2wF40EIKApxDl+9uPpCSo9nNbu
         eJdmqBjKXJ3K4kUekzP3vQfepTODNlBs7Drkrckw92/6wVqDbGnII+OxBsQmA/yJAY3l
         GWNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736469451; x=1737074251;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9QMVaLwUp/s5Yq/Lrd/xvFBo+JhGNOLNDVAzeb24SEQ=;
        b=rBOUz/gkIewAD23BAuegRSL9nEqXZwjSdE1t+Pn3cmWjULJlIlJMdVt6IYIWERhqTH
         FkfpgiBShr4zhVCCnU+j8N0IYc5kHk31JVtJ1KxbuuX2G/vAJn0i6oIPSeW91g9NRoPo
         Ep+Asg25jedFbL7UljtayUcD+YDDNMOa9I/i9hvmUhpSf6ApccuxmRZodlt31vpoTMW1
         H1x64dnrWPeJkDgpnsDLHXrQHURJG1lXcGEwQRt1RfI5E6sopJ7L5OiCmIEYG+8CnINz
         TGkccjhHhIF+P0KeZJmYJMKDyhEb2na/6d5G3nLGgrCDObpxxKeSiCHGFyoUZ7CNOg9c
         WALQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZF1E5r+CCxv1wEvhadUWmz7z0eiBfEDj1YlE3cyHuiTm/xeE0PKQY/57SsudRnT1W0I6oiTGaUm3d@vger.kernel.org
X-Gm-Message-State: AOJu0Ywc44vYy0XgK7LeLEY5P6MzOxg6JfPWlZBEhszsct7ooPmcpVY5
	DzPtfdwA7KF20dNly60LwzBD0I3u8yGRtGk9HaDnuPPVn00ZiIkzomr5S/vh54npnmr8vZL0kVL
	PMjgG9q0F34czLroUNIDFiKn+y0I=
X-Gm-Gg: ASbGncsNxScmz/pmQ+TenO+XrW18F7mFrTm62wf5oJYmWSE4ZdD+sFavqq8Ev69e863
	wUhf4a2pumKZ8n1JClDWpoPKvojffayGoKdYDNPIOQCVn88b2G6jy/uALQvsctEfvLhUwOtaX
X-Google-Smtp-Source: AGHT+IFJNZIZkqz4dOQJzQ3f/USP1QjbBwz0aDPkUDs18sTNzWDG8xk4wD8ni9icctM1Ukp9LnHQvsNy1lElMaPDqa4=
X-Received: by 2002:a05:6512:4029:b0:53e:38fd:7514 with SMTP id
 2adb3069b0e04-542848241f5mr2768918e87.51.1736469450823; Thu, 09 Jan 2025
 16:37:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 9 Jan 2025 18:37:19 -0600
X-Gm-Features: AbW1kva7dWUdE4IBEV0_zbBhb8gK9ufW8UbnK1rqXO2RPoqV3HbEgtSD4UGYg3Q
Message-ID: <CAH2r5mvjSQNPb7M1ammL5_9+Qx7d-hVQXtTy+rBrbcdDSbfK9w@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
9d89551994a430b50c4fffcb1e617a057fa76e20:

  Linux 6.13-rc6 (2025-01-05 14:13:40 -0800)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/6.13-rc6-ksmbd-server-fixes

for you to fetch changes up to e8580b4c600e085b3c8e6404392de2f822d4c132:

  ksmbd: Implement new SMB3 POSIX type (2025-01-07 18:48:49 -0600)

----------------------------------------------------------------
Four ksmbd server fixes, most also for stable
- fix for reporting special file type more accurately when POSIX
extensions negotiated
- minor cleanup
- fix possible incorrect creation path when dirname is not present.
In some cases, Windows's apps create files without checking if they exist.
- fix potential NULL pointer dereference sending interim response
----------------------------------------------------------------
He Wang (1):
      ksmbd: fix unexpectedly changed path in ksmbd_vfs_kern_path_locked

Namjae Jeon (1):
      ksmbd: Implement new SMB3 POSIX type

Thorsten Blum (1):
      ksmbd: Remove unneeded if check in ksmbd_rdma_capable_netdev()

Wentao Liang (1):
      ksmbd: fix a missing return value check bug

 fs/smb/server/smb2pdu.c        | 43 +++++++++++++++++++++++++++++++++++++++++++
 fs/smb/server/smb2pdu.h        | 10 ++++++++++
 fs/smb/server/transport_rdma.c |  3 +--
 fs/smb/server/vfs.c            |  3 ++-
 4 files changed, 56 insertions(+), 3 deletions(-)

-- 
Thanks,

Steve
