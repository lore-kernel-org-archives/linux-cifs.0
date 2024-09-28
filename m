Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53027494;
	Sat, 28 Sep 2024 02:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727489156; cv=none; b=ntUPiS+UD6Jqa+T4yrM86tAuhE8RTJzDGc2lS9domjOKmHf1G50lYef9dVVXIOR4uRDuMFTPcC0Zgf3cZ4UD9eS19D7iamlMsbWWehuSzhpbo+muyR/IOr/08RhgrFH47yQMA5VRKrH7MPEjiDM8akCM/eK1a3zTKQmG4RJ39fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727489156; c=relaxed/simple;
	bh=yHeCVcxV974GSM6bSxhu36POnJDRmLlJe+DU46A7luA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=ZzkZf0BGWDdeZOqZjRoqDPYPdjuz2stX2UMk0WgL/tdIK+IYm/25i0evikZvsTdTB7vrMaAoAHsyI4MD/D1nZiI6u3wCc8B3JVCbc5s7ln8qLtZu/ujE8yPyqj1JOZRlQkaoVwXdWsZiRMidfv74heAipxy9n4SilYc3f3/ggbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lvAz3YYl; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lvAz3YYl"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-53659867cbdso4349666e87.3;
        Fri, 27 Sep 2024 19:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727489153; x=1728093953; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=73Eq7hQfzJxkknzN+e5tNVZCrxvb8j71k6JFA/AKqE0=;
        b=lvAz3YYlkO4tGmQJcjFEjkJ1Kpovm77d1USutYPje9a801VV8LQFGgCKRvmj8OwLyJ
         nwREed59XSzm1w8KP27OLKgvnx7UPNDYLtxTf9LKSvKGt39DM+g+0KgmeDMw5TNbDPxO
         i8tC1lJjcx+H8+R6vqwUSu7Eyr6xmooQuerM2D2d3NJolz0DDUo05MpqjMc6rv92jblF
         JZsYFSsbtE0DUbLVBeK0N/ULmhspJdw6FmmFZNISTvfIekSa3inWopJ/6LmOeagyXCBe
         oe4QUppsGzBubkEPIWhNrkOd5xcUpKMeAET/MittH2+lDAmqfIysYnXY7UBcoAMXuKS3
         4BCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727489153; x=1728093953;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=73Eq7hQfzJxkknzN+e5tNVZCrxvb8j71k6JFA/AKqE0=;
        b=A96T2mmWzjHLzLGSWUlyFGbnNcsz57NFmW7IxC822tuyjCISnzwhPQANGhfVWnRJvo
         6yG8e5N6A3RSv2ebGsAe1cUcROQKG1yAhqLX9k3RrZxa4ggtoH3Kjw+eCs97asLQ3NkW
         58omn3Z0qoQkdC9FXor1wNOAVt9DWicSju0NGtu1BLGn8WKfh4ZNrMX0HRa8ykr20o8X
         Y6TLyKlGY+m4HM+AbtibU/0lm1iXiLrXb+AZ+UQFV3yIJGry3o3Swql4ZOeq/K/i6+7T
         +bDvLIZxc5wOLduThNcZBjpIh1SezrU0bLoegqxt4JNH7BSvGmilZQImNqCalIEvp7m4
         ZCaw==
X-Forwarded-Encrypted: i=1; AJvYcCWBY6r9UVnQrYdRjtgWGhKL9fJhGfhvmRHDZWSVtSBo/wzDR/HNUjykLGdwr0RhFKYY/RQTYIhyDEcI@vger.kernel.org
X-Gm-Message-State: AOJu0YxUTfz5Mc/iw4LGKw2nIkjj51zfjfpe5pC4rt66Whb5/Rr1C2ED
	9FWe17MEQ1xcsrEClRApKoycDuY+SIZxc4iTI53G/TugjiyhkRBfydaolNb02kx1bINJYnxkds1
	0Vrx1NzFI1BQQERdRHiAKGvTsJlHnuFer
X-Google-Smtp-Source: AGHT+IEhi/6Kz4ymENdZxVzCtCDzoOXQ3bEUuZTV6LGGnURikQhlzjlztASgj/s6dZ26pt4uWnkI426cMRIZXXTzaYo=
X-Received: by 2002:a05:6512:3095:b0:536:a5ee:bb75 with SMTP id
 2adb3069b0e04-5389fc3f106mr5354615e87.21.1727489152541; Fri, 27 Sep 2024
 19:05:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 27 Sep 2024 21:05:40 -0500
Message-ID: <CAH2r5mvoGx=vCTUjHWzU2ywfvFrV5b5+GEvvL9PQDL=ydTzd7A@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
4e0373f1f920811a67fef0c3383f1ad602b3845e:

  Merge tag 'v6.12-rc-smb3-client-fixes-part1' of
git://git.samba.org/sfrench/cifs-2.6 (2024-09-19 06:53:40 +0200)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.12-rc-ksmbd-server-fixes

for you to fetch changes up to 9e676e571d39eb6189bf6d55a9c401ba2dd13410:

  ksmbd: Correct typos in multiple comments across various files
(2024-09-25 21:33:22 -0500)

----------------------------------------------------------------
5 smb3 server fixes:
- fix querying dentry for char/block special files
- Four small cleanup patches

----------------------------------------------------------------
Namjae Jeon (3):
      ksmbd: fix warning: comparison of distinct pointer types lacks a cast
      ksmbd: remove unsafe_memcpy use in session setup
      ksmbd: fix open failure from block and char device file

Shen Lichuan (1):
      ksmbd: Correct typos in multiple comments across various files

Thorsten Blum (1):
      ksmbd: Replace one-element arrays with flexible-array members

 fs/smb/common/smb2pdu.h       |  6 +++---
 fs/smb/server/connection.c    |  2 +-
 fs/smb/server/ksmbd_netlink.h |  2 +-
 fs/smb/server/oplock.c        |  4 ++--
 fs/smb/server/server.c        |  2 +-
 fs/smb/server/smb2pdu.c       | 35 ++++++++++++++++-------------------
 fs/smb/server/smb2pdu.h       |  4 ++--
 fs/smb/server/smb_common.c    |  2 +-
 fs/smb/server/vfs_cache.h     |  4 ++--
 fs/smb/server/xattr.h         |  2 +-
 10 files changed, 30 insertions(+), 33 deletions(-)

-- 
Thanks,

Steve
