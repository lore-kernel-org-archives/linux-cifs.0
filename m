Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9291362;
	Sat, 25 May 2024 03:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716607031; cv=none; b=Nxi4TGpUHZnbZ3YFQdjfDBIdMBejCU7eRsLonts1I1HSeZOXnL7QlzUbSZuubXwnlSIieR40WKlE9XlrNLQcwy7fOCMPdgYSjV+u8/7o4vR8K4QP+iyCJpApz550QdcJtw6YH339WiSrKYhjK1xpHg0jhiKcEaxgiFt2fZY8SeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716607031; c=relaxed/simple;
	bh=079klw2gKtfb7nK1gRrC9I40T1GTydSOUAvHTEeIVPk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=CosIOA4/BmpkAvCMReUoNZXKYa8//JiedhTct3Slhsgj+WRxsdozw+BasboeuhtAdYBkGKyOqsUvystMJiAgN+iHffMOCPDwz7KXAPOQj0aT0JQgnLdaXUAvzv4Tn4PNbymgPRdCCPfwqawOLakT1kqSWv6QmbvBowgFMost5D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WXmcMAxP; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WXmcMAxP"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2e95a883101so18218621fa.3;
        Fri, 24 May 2024 20:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716607028; x=1717211828; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1PWMx3tpZZZibSMN1DWA1me1vnkm3QjzaG0mSt/LkqA=;
        b=WXmcMAxPQ+hm7rka+RAb+vsTCxlDCt8bIOcEAuqh5Sx6KBtwdjYv7Oz6Jxs3PHN5pD
         xyPSqYf8AQgv/vBFzGFwrQ5akR21/GaNqEU+L0m5sVImyAWCEiMobtZMolVtay73FKvp
         CUOka0t0Xa71A8lTq8ata8z+pInjNcG8Z2gWTnhfedCw2s2XoeenlLE6WFab0urvvOqs
         K2TVx0xR0+sfNoHuXfOVEE16fVjwqLBkG1xUR2nIA89VfdAPgCrIgPxuLH8pkw11uDLQ
         x9++3czvhUUqF3+xzmYzyB+6zBgTzauXkx/1ME8quraAObQV4Mc/NiGEF/xpTicuvWrX
         4ILw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716607028; x=1717211828;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1PWMx3tpZZZibSMN1DWA1me1vnkm3QjzaG0mSt/LkqA=;
        b=h4Ym8IZhGJozlLMTH70L6d/offWcHiQbc+pdKMT4weUTHRbXKDBRAJfQZG3vzRMCaI
         cKq2Vmtm2OkLAgyNIFijCUMi7rZKFHjh9dnV8agtwS9NnHE+b2HsUyRVMwlFzrR4GmAp
         YgLh1wi18sM69LEDrBUt5QR63ALnvcbP4fRlLKxcKrQwRRc2ZbFbqHN2DZz5eynz/+lL
         Klrxthu2L2QG4ldxjPm6vmOaxUjl+nTyjEaTI9XN1kj8csclezfXBpsQOSgzorDSlfHl
         F7bvzR96wW4U1cv25ga3yAs/F8W4I5sxhs2bn2KzZfyXhRvenGDJFzIgubmKRF+TTRZn
         humw==
X-Forwarded-Encrypted: i=1; AJvYcCWchGAz1P65mUW8EQFMgcx4jui6f1KwesXrMcoIZJMnLpOlmz/rFreShj+kqh67BPlO3HtLw8EJyfpGP875cPj3W6sqLBaWIMN93YgK
X-Gm-Message-State: AOJu0Yy5Zv3XOVOG8m9PfePdIrcHQZU29yLvoso9R2U7ybseGvyhuYnx
	NWre7WFCb3PlZXsqntB214w9v45lMb/OJjwPj10tsy17fVXdwfND3sQKj/rcvkl9a7z/hLToDfL
	rhLzr7A1z7AVskw1Ruzq+6BlBm9wFRdqH
X-Google-Smtp-Source: AGHT+IHgWyQyXwrJSKsHmor9QF7NQ5zL2MozPMpJVWXz3mNr9RMWG4ovM4QfJ1bd+GEgVpc+y1lujgAv1COh4FX8rag=
X-Received: by 2002:a2e:a783:0:b0:2e9:5ad5:2bb6 with SMTP id
 38308e7fff4ca-2e95b27f04fmr28144881fa.47.1716607027781; Fri, 24 May 2024
 20:17:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 24 May 2024 22:16:56 -0500
Message-ID: <CAH2r5mvL-bvRPsbj6qhNwguxu_7wtkfYOAN5vdizG26rfcMKKQ@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
a38297e3fb012ddfa7ce0321a7e5a8daeb1872b6:

  Linux 6.9 (2024-05-12 14:12:29 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/6.10-rc-ksmbd-server-fixes

for you to fetch changes up to 405ee4097c4bc3e70556520aed5ba52a511c2266:

  ksmbd: ignore trailing slashes in share paths (2024-05-22 18:26:29 -0500)

----------------------------------------------------------------
two ksmbd server fixes, both for stable
- fix oplock problem noticed with test generic/011
- fix trailing slash issue with iOS and Android clients

----------------------------------------------------------------
Namjae Jeon (1):
      ksmbd: avoid to send duplicate oplock break notifications

Nandor Kracser (1):
      ksmbd: ignore trailing slashes in share paths

 fs/smb/server/mgmt/share_config.c |  6 +++++-
 fs/smb/server/oplock.c            | 21 +++++++++++++--------
 2 files changed, 18 insertions(+), 9 deletions(-)

-- 
Thanks,

Steve
