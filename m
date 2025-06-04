Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E19224AF2;
	Wed,  4 Jun 2025 23:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749079262; cv=none; b=OgsB6gisj+bC9iQZhBLe2vuN4qYzo0LmUwo+pxFaL4VWELKB96ZyGw1bIBBveS9SWihmS0l5HCFicrhg3dFvUJzIi22AD1uini652M2GPZhbUFwbyGAamisA7d60m92BuojPVV70G+0jjcHD1YgA0qjPoAKcoiQo8uI/qKo5NVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749079262; c=relaxed/simple;
	bh=6BGMLTyI9Ec3Kg+cz9cQUC2Bo3OQ73n6D16zPOw6tag=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=bzm9aUee7XTeLFonSlx1b99u7UxuHJ2fml2IZEFi2DWiR9tRivdQk4T+uzLfO0bnfpeC4gk6s3I4KG4IIyNK85k/4YEpLPITDz7kNEQFIarFWtpYsomFbmG9TiyU7bk/GMhJsJfpfsI658wy9BWkF/IZrCos8sO+W1kWnF+vCcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Neb5tKoA; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Neb5tKoA"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-32aabfd3813so3410191fa.3;
        Wed, 04 Jun 2025 16:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749079258; x=1749684058; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UcMlhn223WOqcIHrp/y1AR8lknYH1/5nhJEfUOf9IMI=;
        b=Neb5tKoAVeSdJ6gKM6u/QX7Bg2/6Mv6EMJ229sjeWjwCe3QRdXznsARtscO3KLyV2j
         r7SambjyclkPWKt5vIwALVP3dwo2DJmXPZ8RvODaXiPw2vDWmQW4hfnwZT3zZTC4rTnp
         ugDl/N56U/O48GEAJmquyTtEd7SGB1M1ptEwA4cUWWY6rwGiogMncOhxy8DEnQFzcVo4
         Qa0rEmrUF5wmzMoFId5zHafUtWi/6kcsZmJ2YNAxwqW4X1yF1g09yBl1tvVjfhEBnK8a
         0N9uTUhtW7DqsIUwMKeqvYSZa5Qn7ohWj+D+y7ziHBSI6pamw76dAdK2RNyJUah5gNzp
         DbWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749079258; x=1749684058;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UcMlhn223WOqcIHrp/y1AR8lknYH1/5nhJEfUOf9IMI=;
        b=BFeL459vKQUJRMpV+NgQjIEHGKuVAXVHRx7/dQ8iRv0IIsRBZP34JbdkA+Ui3d02YI
         SyU49NlxH8hCxs2WTRFLK7ydq5oRd4xAbfS69t+SE7qOeAkOOJYLZCj2p0XjN21RViQN
         pEjn56xBYbDRiLtx5JPum4GB0c4Pn3czTYvwjPngjPzPOV4HYDr9GTor1xnwLs6pnu8Y
         oQOM6QdBu31BFldYz2JK+gzGkvom5howDP4qRH/bK19F/hUbOTP3t6jY4O8APDhnbM2s
         prquLyEKFGYJwQi3M1KCu+cWcfDEljQ59T9pdVoMw3QMXpFQ1KuniBIe9n4cFJzu9rfQ
         Kg7w==
X-Forwarded-Encrypted: i=1; AJvYcCWMpvBaFRBpzcqUWVCtgQ2RCuWbvJvZ/zUbogYK0mRPUAMG9HRBN5AUM/6J268Og/nX6+cg0RpqRM8U@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+pldaXSYRj2H4O/Y5o13jmNjn99Ewyfql7sqUkO9sQu71KCXM
	HlnTQkOqQfQwyqT3z5ExNcDeRkS5BWJSwUFv+z5biYyeFniTJtU8kY8VMZ9QZGQMuClybErHLhx
	CqEK4tyvmrAo45v3CL9TUvhtY9F6hfBsgUzEK
X-Gm-Gg: ASbGnctrPsYSPLmeLG1uoWAa/kI66/fKRoKNBG1YXS7Il3lVph0fdlouwYF9YE4+gE4
	jP9sAO6Jb2R9gLnIx3a7zmhCQP2wbMe0kXQeG0e9eSacmyUTGU+Xc5Qf60wuTLSCstUu38AICpi
	6cthsD1xdmE20bh25gK2HiGCl8TmamQuZXEvt5jyQph9SYpSBH5K0eshc1NUjXup7Fsdg=
X-Google-Smtp-Source: AGHT+IFL2Qw6EsGAEuRXuJAmoNr5yp53DHvRWgBZPHf+Ix91ruEjntk+8gIX1QcwGtGYq7Hoaf+2qRbanUVs+n+qBwI=
X-Received: by 2002:a05:651c:221a:b0:32a:739d:fac with SMTP id
 38308e7fff4ca-32ac71f622emr15383591fa.36.1749079258404; Wed, 04 Jun 2025
 16:20:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 4 Jun 2025 18:20:46 -0500
X-Gm-Features: AX0GCFuI4gwd-C54TyFnZ12WsmWNzGe6gNjA5_gF8xWRTIxrxe0mf7oAXH5PbUM
Message-ID: <CAH2r5muDAU9fFmkDERtE_Dvrt2HgC4s9t1wH-uHG6B4vQH39iw@mail.gmail.com>
Subject: [GIT PULL] ksmbd sever fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
0ff41df1cb268fc69e703a08a57ee14ae967d0ca:

  Linux 6.15 (2025-05-25 16:09:23 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/6.16-rc-ksmbd-server-fixes

for you to fetch changes up to dc3e0f17f74558e8a2fce00608855f050de10230:

  ksmbd: allow a filename to contain special characters on SMB3.1.1
posix extension (2025-05-27 10:25:12 -0500)

----------------------------------------------------------------
four smb3 server fixes
- Fix for special character handling when mounting with "posix"
- Fix for mounts from Mac for fs that don't provide unique inode numbers
- Two cleanup patches (e.g. for crypto calls)
-----------------------------------------------------------------
Eric Biggers (2):
      ksmbd: use SHA-256 library API instead of crypto_shash API
      ksmbd: remove unnecessary softdep on crc32

Namjae Jeon (2):
      ksmbd: provide zero as a unique ID to the Mac client
      ksmbd: allow a filename to contain special characters on
SMB3.1.1 posix extension

 fs/smb/server/Kconfig      |  1 +
 fs/smb/server/auth.c       | 34 ---------------------
 fs/smb/server/auth.h       |  2 --
 fs/smb/server/connection.h |  1 +
 fs/smb/server/crypto_ctx.c |  8 -----
 fs/smb/server/crypto_ctx.h |  4 ---
 fs/smb/server/server.c     |  1 -
 fs/smb/server/smb2pdu.c    | 72 +++++++++++++++++++++++++++------------------
 fs/smb/server/smb2pdu.h    |  3 ++
 fs/smb/server/vfs.c        | 20 +++----------
 10 files changed, 53 insertions(+), 93 deletions(-)

-- 
Thanks,

Steve
