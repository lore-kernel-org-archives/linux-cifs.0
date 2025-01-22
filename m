Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C551CAA86;
	Wed, 22 Jan 2025 23:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737589926; cv=none; b=RmzJD6JVyCaJe7EMDdVocRYdToE/4sodQ8r171Yc36/Q09+28aeK1IkRP5/2dX+7FWsmIP1VIhH8gCUNFi1W4BpW+X5/0TjTpMpoBtEuVyblXVht4HTH+rw2RMI3hifu4iVwcbiHgkWeTtb1uWnFQcQTe8L50NnrObE/OH/8XyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737589926; c=relaxed/simple;
	bh=vOIDyRHpNj3NfvJjhj0zMTLPyb6TUXVWK7CzwxrSOEM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=t9Tsab5NNuEHSjtg17jkdwH4FpoCvfmJkdtvcXT812nSsib7JcxXFE8ddC5lUYAkCN9UGdbX6Rw/ojdDJWFi2IL6h4KNUcMAkl4Y0oHJMjLIzvdxgOKCwmEO8vYHaw1GonJ4jv0kYyYM1wzf1jOojhwgRE0KAeS8Xz++e//SUi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e7enpfr0; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e7enpfr0"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-54024aa9febso398576e87.1;
        Wed, 22 Jan 2025 15:52:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737589922; x=1738194722; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9Vvq1tcfKlOaxm3GsM5RHLnJ5mbbHwbV9Z0rd5wzpYw=;
        b=e7enpfr0OZ4Yrpl3NsPxSOFb2/ZFmIBqYNXRZ2I7xHFwrDxXrsShmPwuymHZiyst6K
         BO1wURIjHZ7AI9TEjqlBFGLSU3bdh2xGHbmmluAgNXV2m1DzX92PwSDdLiEnWP7yR4cd
         bFZ6hRbW9WpioOztekQeKwCulYthUNTKWjevrBT5U6R5Kjq4eq2J26C41frAsmnrmtU/
         MnufOvFmajPTxSoJiaZJl7QcW0CUvgL07I3szyG1p5ZbM0fl1pl1hFM6uiTC/0OoxkKR
         gUG/pDgDRsAu7r3jC4KCtfH8B1178rRFF5qHuq14T1Klr8kha/uTHn1/mVO/sDA2gwQf
         KmQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737589922; x=1738194722;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9Vvq1tcfKlOaxm3GsM5RHLnJ5mbbHwbV9Z0rd5wzpYw=;
        b=ITURntMyIH4kWkzdaG/G2q9LbIIC41TR6MnUqORsGkMD64/+4+CLzNcwM2CHNgBAKF
         4a30+9tn6FrjOXqNCEFH+LamOVtTu2G9y7nq6BCfRoyOWWuF0K32oSEQEAKlNfbtQNP5
         XAPfgwSC8mzfLR1wHrm5EykeoGHtu05uZEtI9UA7aIWXnYy5x4OQAIceEpmmf7axDGHY
         RJ09U3hdy2vJCLG24+TDQB26F/4d4GNs/3ZczSXswOYSGmQwJ+HcvkJf/XocY3ybIfX+
         17IgLKrIaAc97Pm8xUhKgLNqqng3pBYrOgZLTxH5+Dl1POpI5T2kuTxrrcFMmeBxKBm0
         9/ng==
X-Forwarded-Encrypted: i=1; AJvYcCVOaeFuf9EajtCkMUlryZebOOLzb9RHGXe5ef0jqGGWecCCpVpYnRcueVXgrfnCA/TujMKhy6lW9MU7@vger.kernel.org
X-Gm-Message-State: AOJu0YxYOLC/3UMl11KF1THIHCtsbOF6tp3nixxTqGzttQxUSNceLhLg
	fmwCyK/NPeEhb/ybSzPDDLCkHmkptlEOMC29fTIBYojM20OKTuQPGVy2ltLFc7Fakpa87mDRg/Q
	8tVklvtfRooll6XnhFaBkCFDX6U4=
X-Gm-Gg: ASbGncvIoQzqSTnX8isCGDA8S2Z1tCgBRyE6bt8XrUs0Ls3Iz3QbpzuB4OqY7hE7IGc
	oedGcqAN9d2TiclJ1WiFn7FL9we15C3uQQ48HFxMZEtTvj0S3xDJHcVfWN//IDA==
X-Google-Smtp-Source: AGHT+IHBJvO/wCTSmZp2aDhLBi5av1gaQX/fIfEHgzRbreRdKRhI+bc8Px9X6QuPGuibzFyl4b1xw1BhLAVP6fsi5JQ=
X-Received: by 2002:a05:6512:e8c:b0:540:2223:9b0b with SMTP id
 2adb3069b0e04-5439c282cd8mr8282319e87.35.1737589922265; Wed, 22 Jan 2025
 15:52:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 22 Jan 2025 17:51:51 -0600
X-Gm-Features: AbW1kvbdVQjzUCKEkPPSjCvkLLC2bwhFiYmp5t7OWshi0nMHXMMq5oHH0r2m_Uw
Message-ID: <CAH2r5mvrTgizT-zVYJpn0wE8S6DWJemS5yaOC4d=t_ejVz7wsQ@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
5bc55a333a2f7316b58edc7573e8e893f7acb532:

  Linux 6.13-rc7 (2025-01-12 14:37:56 -0800)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.14-rc-ksmbd-server-fixes

for you to fetch changes up to aab98e2dbd648510f8f51b83fbf4721206ccae45:

  ksmbd: fix integer overflows on 32 bit systems (2025-01-15 23:24:51 -0600)

----------------------------------------------------------------
Three ksmbd server fixes
- Fix potential memory corruption in IPC calls
- Support FSCTL_QUERY_INTERFACE_INFO for more configurations
- Remove some unused functions
----------------------------------------------------------------
Dan Carpenter (1):
      ksmbd: fix integer overflows on 32 bit systems

Dr. David Alan Gilbert (1):
      ksmbd: Remove unused functions

Namjae Jeon (1):
      ksmbd: browse interfaces list on FSCTL_QUERY_INTERFACE_INFO IOCTL

 fs/smb/server/ksmbd_netlink.h |  3 +-
 fs/smb/server/server.h        |  1 +
 fs/smb/server/smb2pdu.c       |  4 +++
 fs/smb/server/transport_ipc.c | 35 +++++++---------------
 fs/smb/server/transport_ipc.h |  2 --
 fs/smb/server/transport_tcp.c | 73
++++++++++++++++++++-------------------------
 fs/smb/server/transport_tcp.h |  1 +
 fs/smb/server/vfs.c           |  7 -----
 fs/smb/server/vfs.h           |  1 -
 9 files changed, 50 insertions(+), 77 deletions(-)

-- 
Thanks,

Steve
