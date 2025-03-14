Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDB21DDA33;
	Fri, 14 Mar 2025 23:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741996082; cv=none; b=FT7lcFsux7Iy70i/HcDpunccc10J3dqphNaZ2mIxnUhb+r/YGeRpVHcNboeOj7URCvyleIEkVzNo5uTwi5OaGH8ILcaWs/cOSP+ihWivGGqBzuff2NmfnSxSu+9SSys/JqAlixeQMcSuvxpi4/nBYat542wXEZvOFSQenvZQNkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741996082; c=relaxed/simple;
	bh=+7pU9FaVIxplM2QQXRjrSOQmrNpnTBXr6bVcvpaVm6s=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=nd0krl0f0lZ934DytvrXMIdY2SSHrkBsx2Kph6gcl/V0+w7fkaArpHSFBgT8jG4uabzpVwgin1kZcksqpA4rVNQRthT46exqbulK9qlFmwZJfaeRk6W5pU+IssvNzssKBmjxOecKguQCBGivgPvrnWrHyp96nYdUugdHuSc91MU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mifx5IhR; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mifx5IhR"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-549b159c84cso2679272e87.3;
        Fri, 14 Mar 2025 16:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741996078; x=1742600878; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XRGqHueSif0HYVzdCNbfrvXSSbqFDS5N49LVavrqwU8=;
        b=Mifx5IhRvy1Ho4hjz2d91j6T+gPdd9Ww2WHdF8pIyfe5XUNrpwDyvMjVVscSajst3P
         aT6H9JB4aQyxrxttLfuIsUop8Vhdv+Y8eXOcFBmtn+tJCauUZVbVWgLtsRJ19RjYwTYL
         L7UUyTktPRFI0fCWnWMx8BrBHJh/gdfPUvIT19IEIAoxKUWzpWYJcKvwYVlSv8aAw5Y5
         kJQbL1Jqoicwo8CPmmSztId0GMQ3V1N1a14lBKt7KR6Tdths0m7sgvUyzvWkjyTl1CmY
         XHza8osZD53zQXXOpgDS37HCP8swfEKmWUDEefFJ6mjKd0O7Jdt0IZIPK4TLcvEM9NfX
         LKAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741996078; x=1742600878;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XRGqHueSif0HYVzdCNbfrvXSSbqFDS5N49LVavrqwU8=;
        b=S4oYozBABA7VaZjAOnjyfWFKdSNzgtS/OyLLxiKCmpNYkWcyG7uUPUduM2+6c/R28z
         4bgfL4vGAv5I6EXeryFjaGf9tl6RE0056gGnQo9NFHGTri0kOxRyDaj4SKOiscuDODZz
         CXfBU+0IUJ+3xDJLJhr706YIxcMbKMyBieQ6uF9E8QU2bS0vArAnQ/JzaxecIOwPpwqC
         2FOz7684YsuToEhfrE/1CbPBi0sswaCTjgk3PNU2phqjibYDKfOy02W27ElBeoeRwE5X
         HqJLi16M1o743lbWC+1u0PZnSmZF2+VQcqBOei6G+xl5elDfo/Pmxruyx5MbmPHQL4qt
         H2eA==
X-Forwarded-Encrypted: i=1; AJvYcCXSJ5fbVmIBTeBcsDwCoDop9alSr4t3lrVWJHF1hWpt9K4njLUgXRiNAUnMyl8dQJ6emksI3pjKjg8R@vger.kernel.org
X-Gm-Message-State: AOJu0YxzUDnyob/CgUlK3b6dw7jJ5JLZ5Qlm9Hqrhvhy+E1t26g8I2J9
	2MNCfRHMnMnb2qbQ5h3tvkOZOviCT1AeX9pBzVqoSyptL3SNFlzubuwWUci+6oAS6+nItKoo0W4
	JhDdOjWpMHsCKlTkVe5op8NIMBq4O7g==
X-Gm-Gg: ASbGncvkwN1bTLFg4P9OJU0d/gjNQOINXjJ6xK8DUWjZwxfBBsW3S57sg8BiwW5v2Z7
	kg5U4OwjLgTY/vx0FiHWNDwN4cF0g9iDVS1DdR3j3/N0wkKnOBfDRndZ/OQvA1Lop2KrKxxRoVm
	wqNdtTh3SVtVKdaNK7Qe8yk9oxv9GL+cUHpQp/MayaaLUrWRFzU+94UGN7e8WmtRpjDal0
X-Google-Smtp-Source: AGHT+IFjH0tu9Z5mbfJnVOdn/zkjA4D8n9BGkB4gPSaO62QYh0tkgwDxtghfSoVG/MTku2E67UgjsfHjUtDH0FBMlQs=
X-Received: by 2002:a05:6512:2250:b0:545:2fa9:8cf5 with SMTP id
 2adb3069b0e04-549c39aebb7mr1733347e87.49.1741996077992; Fri, 14 Mar 2025
 16:47:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 14 Mar 2025 18:47:46 -0500
X-Gm-Features: AQ5f1JrR475Xc7TGBi9yUbuZ6288i0ZEr8NExxR-y7rl9ST4g9CCmvdARulT6jU
Message-ID: <CAH2r5mtLERdeDNKxfDjHyHQuf82OOd-KXBq==5bOoBi8P7NrrA@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
80e54e84911a923c40d7bee33a34c1b4be148d7a:

  Linux 6.14-rc6 (2025-03-09 13:45:25 -1000)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.14-rc6-smb3-client-fixes

for you to fetch changes up to 605b249ea96770ac4fac4b8510a99e0f8442be5e:

  smb: client: Fix match_session bug preventing session reuse
(2025-03-13 08:41:28 -0500)

----------------------------------------------------------------
Six small SMB3 client fixes, all also for stable
- four mount parm validation fixes for incorrect upper bounds checks
- fix for guest mounts when null alt password specified
- fix session reuse bug
----------------------------------------------------------------
Henrique Carvalho (1):
      smb: client: Fix match_session bug preventing session reuse

Murad Masimov (4):
      cifs: Fix integer overflow while processing acregmax mount option
      cifs: Fix integer overflow while processing acdirmax mount option
      cifs: Fix integer overflow while processing actimeo mount option
      cifs: Fix integer overflow while processing closetimeo mount option

Paulo Alcantara (1):
      smb: client: fix regression with guest option

 fs/smb/client/connect.c    | 16 ++++++++++++----
 fs/smb/client/fs_context.c | 18 +++++++++++-------
 2 files changed, 23 insertions(+), 11 deletions(-)


--
Thanks,

Steve
