Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20AC62E3387;
	Thu,  6 Mar 2025 18:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741285922; cv=none; b=GZuEuwt6nrkzjmFSwbes0iDRFdCEc/MHKy8M23Xua6mw3YBFBxJpmFMBhTQDeONJmpTzQVCiK5YToJLBfld7UH04p+6ZmNpJlB7fAFO+JMOd4BdBkwf7XEx4qRAEeifGBJ/I1h9sXAlpW0Vz1MBRM1r1I9VS4htxG22XB1izMl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741285922; c=relaxed/simple;
	bh=HV0J8DGMlvcNRrpY1wTwVNb1J3AkFAPwjBqAYAu/nbk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=mWJ8WsBz0RK73V7tj9tzGD1dFATVN9hUshsDBV59JuHPf6tsRpI/+pHEjHRLBuDBdXaTBlpqPDqfobLeYoOmwAVbBEyQwHMUzUipm1FjhkLCCsej5R7NcxxuZYIVXAP8JAKvzByrLYUbCfv698G23ei/XR5g8q2ISIl64EgaJwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T/QRKizg; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T/QRKizg"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-54954fa61c9so1312530e87.1;
        Thu, 06 Mar 2025 10:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741285919; x=1741890719; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lfgGIcQhYMWkp61kccQ/Wm/qtFJCmbeWxcGslqhIil4=;
        b=T/QRKizgB2ow4dJhrgA5Izu51syaNiKOlSsOToZO8h8FatcsQl090vwSHv21MyxWrQ
         IWeRfxGycZYCMgYguOwDjNbycnNaP7JwFMkuzyCs69iyGE3U7KkqNw0FmMCn6ZbE6vI6
         qJHjNtXF5nrlRSw8BP9SA9vyPhG7ae3qiJUud87uZp9UqZOIYfzioyBKtggjUGV7wWMx
         aecGGv977qE2XQV94POkpLP9ClqGcvHbdz7lGVJ+cchBGWz9tH83jURKjLMzNrItvHjD
         8I10lEPhfROrRqah5dvFhDaglENme4wPZiAPWqNowRqOPTM9dPgFgYHMF5ZJLO8V05yq
         fdxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741285919; x=1741890719;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lfgGIcQhYMWkp61kccQ/Wm/qtFJCmbeWxcGslqhIil4=;
        b=t1oFTg93n67pfnxv3yNDIDNiYDmyOr/LFzzl+O7q8wgmqLC7r82Ea7ShmXEGlsc6Tx
         vEsD7og6Y3m/VEF2w5YXX4Of7gzUIdAOi6ww1oodVJaZ/onEpGsQhBo5YVmZoGSZjND3
         i03NYbQk6xiEHaQswUJ7mGiEeTAlrdB6WBJ5LrCCIwRfm1k9lNu7JX42JYpGsB3R6W1o
         nTuAY3nhvb3K056R7imTUv9KNxL2tsnFNcPgpvixJbphP7Pyzi23wDO3RTXn7sEhBbHX
         PBzqvjEikxaoRNoOA6nzanJ150ouidZvMiB0Jtdn2aYw0+iKJ0as8eC0pg1oKgz/c5DC
         WBiA==
X-Forwarded-Encrypted: i=1; AJvYcCWJa+FBKaMg2ix+tcmLlTinSI6fYtsaIXLNTdkILdpcjCbeUTsKr4L6gnGIulGG908aU35AnOcltS8Ywyg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJp2oh0PrksScpA4YMcQx1wNwfQ/LPgCj5XZ7uIHjcqSnX2yVN
	EdhFwQiBYLzFYcDoEl6GRcdLNDRoUNLHqA9GHsKA4UCe8wzK2k9Lz7GVrsWgln+rFqvu37Ue1KJ
	ftU9SUey/HEwZ/w42+/QbJ5pqDrYGlWWF
X-Gm-Gg: ASbGncsoo/spPCfHiXzOKLctPdSJlIm2z5y7X/nEhkYlXgs+/eoDmg6aULUm/U/vu7f
	t/UqPm50HJQ7MMKEW//AnAE5ib80bwkA2nLHCSCi3UgA5y665amELMSjan+1P/y/bc8JWJB3qfS
	+edVhWI0fqXbkNWImaCW10tMPn6qb9g7xrP43S5+fjIxnKjFl/l12wj7h4lSDD
X-Google-Smtp-Source: AGHT+IEFZSm3FDSvKgfYat0jMvuJcdQ6+9YupuGqE4ANxbclDLZu2H098Kn3C3QwIBCnCsWhh5FMvHnpfSxVv/coZgM=
X-Received: by 2002:a05:6512:ad1:b0:549:8c2a:3b4 with SMTP id
 2adb3069b0e04-54990e5d34dmr97660e87.13.1741285918832; Thu, 06 Mar 2025
 10:31:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 6 Mar 2025 12:31:47 -0600
X-Gm-Features: AQ5f1Jqa2R6cF-zcr1wNKRVyeDtdHCNIwavYqoJ0fmHbKzTTqy6aI7kShW_LZKY
Message-ID: <CAH2r5mt0FL5HNGQX_csHO3Q3sJ3Obn6phdtGxxM29XXSX9UeJw@mail.gmail.com>
Subject: [GIT PULL] smb3 fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
7eb172143d5508b4da468ed59ee857c6e5e01da6:

  Linux 6.14-rc5 (2025-03-02 11:48:20 -0800)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.14-rc5-smb3-fixes

for you to fetch changes up to aa2a739a75ab6f24ef72fb3fdb9192c081eacf06:

  cifs: fix incorrect validation for num_aces field of smb_acl
(2025-03-02 22:50:54 -0600)

----------------------------------------------------------------
Five SMB server fixes, two related client fixes, and minor MAINTAINERS update

I am still reviewing an additional change for validating ACEs, and
also for validating init_acl_state(), that are not included in this
P/R

- Two SMB3 lock fixes fixes (including use after free and bug on fix)
- Fix to race condition that can happen in processing responses on IPC$
- Four ACL related fixes: one related to endianness of num_aces, and
two related fixes to the checks for num_aces (for both client and
server), and one fixing missing check for num_subauths which can
cause memory corruption
- And minor update to email addresses in MAINTAINERS file
----------------------------------------------------------------
Namjae Jeon (8):
      MAINTAINERS: update email address in cifs and ksmbd entry
      ksmbd: fix out-of-bounds in parse_sec_desc()
      ksmbd: fix type confusion via race condition when using
ipc_msg_send_request
      ksmbd: fix use-after-free in smb2_lock
      ksmbd: fix bug on trap in smb2_lock
      smb: common: change the data type of num_aces to le16
      ksmbd: fix incorrect validation for num_aces field of smb_acl
      cifs: fix incorrect validation for num_aces field of smb_acl

 MAINTAINERS                   |  3 +++
 fs/smb/client/cifsacl.c       | 34 +++++++++++++++-------------
 fs/smb/common/smbacl.h        |  3 ++-
 fs/smb/server/smb2pdu.c       |  8 +++----
 fs/smb/server/smbacl.c        | 52 ++++++++++++++++++++++++++++++-------------
 fs/smb/server/smbacl.h        |  2 +-
 fs/smb/server/transport_ipc.c |  1 +
 7 files changed, 66 insertions(+), 37 deletions(-)

-- 
Thanks,

Steve
