Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486C325F96B;
	Fri,  9 May 2025 21:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746826734; cv=none; b=FBiBMF9tGkR4lRAGoGJTn1wUMNaEthqz6A9B+7jaHJDvnsWuYPGafZBvehtcmjtZd8cZyGlvfPr6j0YdMd4v7z6ATKEdCX92met+A6Wl7OtIrxYUZgpEtQoXbZYDc7t+BBrdgoG62VbHd1hp8fj756vFY/lpjmKVu3MsgUSrl5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746826734; c=relaxed/simple;
	bh=91W7ueLS5HdVm1Clt1QkBDNDRP4JzBN7wYYf77hdg04=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=hxwoIMy7aOUTq/31HQN/Xj68sqSbnAw1GGDqhTYNF/AyyR98muET7e4fWRr4o7FfJCEEtG74mo1P/bC3vAkFP4TgE+oyqEa9lhfUdXcKX0QkmAnx0GVkwblZsdYEqzSSuPGFlcQX5x2a7mDPhlD7Q1LxaS6uT/mpxCwICIzeAsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LNU90x5e; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LNU90x5e"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-54d6f93316dso3129981e87.2;
        Fri, 09 May 2025 14:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746826730; x=1747431530; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Pqeg5Kbolg0TbSLK5TiwNzMW4HjK1zUJYay4xctNtEI=;
        b=LNU90x5eS1hiMe4Of3COazw//c/AzdRrI3Q21SF2voDLI/SEIFGhxhKc60WaLYbyER
         8rqsaYnozpuz5u/j1/0EgzVgA8ptkfPvkhhk4YLkgu2XzWlvMrLfoKvBrWuQr7WeQDGT
         k1rWpK51whANQsHj5QkUat3auI9dYJgu5MhPp8O/XnCSytnhVJJOSq21CrqhkgMzL3wL
         YXmEpTTfSZEoXVG2EF6COh78frn18rifjHJtqPYTEz+4WqoOZJpUILgHYuOYdfmYtZq1
         ypd5UxhpSrQwHZUqAkbVQyP7OIylzlUSkzfOl/6RscfafXg2RrGN3TWGgQ7ddF3+bvcz
         +2xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746826730; x=1747431530;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pqeg5Kbolg0TbSLK5TiwNzMW4HjK1zUJYay4xctNtEI=;
        b=UO72BxRAbx2hjfklMqaZNU9V38wrFf/nuAUo4wGJA634qg0YjMwUyx3DtF9RCsonv5
         kAD0jlhQNBXnDyLce/Y0tM/x0lw1HXF+MY196bHkUAyTHK9dyrUGM1qdK97pGleSajRi
         aO8gEjzF5qZgrnJjRr3BHRvj6RK6Cz6zEUJfxlvqzdwsYQjXZIuWU016S3NVFuD4ULYK
         48dWj4zyQTTk6rvaAub5hJEpRP27lAo7/lelsZwR8ym6ILIaBJaJ1491TJK9oS7TKaYa
         tXKaSejd4cu9ozN/3Ze4LTrR7QIQ6P//aQwRr2CQptwGmxGjniJhNLh+iCdDy6TcwNcz
         /f6g==
X-Forwarded-Encrypted: i=1; AJvYcCXR3Cc7hhOO/7RnkTgPdiHva8pbCHjuxLNXz7CJ0ht69wnbXLewWvOpTVlq/4zdJX7+dgV7A/BHYk8x@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4cPW/l0hR8UwRYmO6UuojLZSIwdQtjwr/pJGcVBUgGepjEda/
	X2Ka3d1E4j2SByrpPwn1BHEEQRS+wocmr2NomOEuuf1goJgib6YKWYD1WWESbN2Af2NRJPHiRyc
	EXezte4rEcC/4HFjKTtnL32LWGGyDOLmc
X-Gm-Gg: ASbGncunxKxMK6Q1MsTCbffrG/Muzsy788A4K6yadBi3crCW3kB7/yYjsrC+BhOmd5Q
	tpun3jiVVdp+SyASPkjG9jJ7QIDWlJ+gUWeTxxX2MNnruWRfd40KUpoD1E6CWwUpXPUIIYXy+Ij
	nT4jWLhNYfjVSaSzKpy+8WRmHMq+H0EaACIIrTa5vgGAFwQikvLVsT7s9xySwqhgPevrBH+JRmY
	+DR2Q==
X-Google-Smtp-Source: AGHT+IFKch58Oxm0Zd3Mdu5vSnuibffWdeDnh6KbU28wpAArKT46hsD7FE302nVCsk8zxurDBq4Ia/39NHHcNMgeA38=
X-Received: by 2002:a05:6512:4389:b0:545:60b:f381 with SMTP id
 2adb3069b0e04-54fc67cd721mr1403053e87.29.1746826729864; Fri, 09 May 2025
 14:38:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 9 May 2025 16:38:38 -0500
X-Gm-Features: AX0GCFuuAL9nz40cy802jNJhELepR98AAkSqEkzNu0xtAZ5gZw3CC_KYBNH4XoU
Message-ID: <CAH2r5mtRj=+xk4bt74j=pzbOF8=BxJNp2L3nr_VzvtZY5tLW0g@mail.gmail.com>
Subject: [GIT PULL] smb3 cilent fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
92a09c47464d040866cf2b4cd052bc60555185fb:

  Linux 6.15-rc5 (2025-05-04 13:55:04 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.15-rc5-smb3-client-fixes

for you to fetch changes up to 3ca02e63edccb78ef3659bebc68579c7224a6ca2:

  smb: client: Avoid race in open_cached_dir with lease breaks
(2025-05-07 15:24:46 -0500)

----------------------------------------------------------------
Two smb3 client fixes
- Fix dentry leak which can cause umount crash
- Add warn for parse contexts error on compounded operation
----------------------------------------------------------------
Paul Aurich (1):
      smb: client: Avoid race in open_cached_dir with lease breaks

Steve French (1):
      smb3 client: warn when parse contexts returns error on
compounded operation

 fs/smb/client/cached_dir.c | 10 ++--------
 fs/smb/client/smb2inode.c  |  2 ++
 2 files changed, 4 insertions(+), 8 deletions(-)


-- 
Thanks,

Steve
