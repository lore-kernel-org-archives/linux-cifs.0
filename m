Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F26F5383;
	Sat,  5 Jul 2025 00:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751676076; cv=none; b=lvlO1+UXVefjCoyfjNS2JugKU8WHvCjYdZrZ1fAVGN2RqAtQY2k11zFD739SukmiSDXlGnwDgTBZacClGJyNkalow+FcTmqsxmlVfRGBu5JQxxnn0CsWETLBbzimhBfa3L2WefKAUqHh/XjngSgqvZ/9WAG8LXsupdoZGyrn1xw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751676076; c=relaxed/simple;
	bh=ONin8yVrjLkha9Ng7A3VH/2v7okB0ffiONDD/FneRp8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Mhq+XmBnTTVOX2IKz98fcLK3NV9PEXIaKY4LKcnqbesC8T5i3SxrIGV9YOYUhdMje+cHqyz+QekHPPew1IJ7zjU7wqcm4x3r3yyqkEb3MhQHyBMDhEkFXOXj2Pq3WK+rGnu/VSREhkqHkiWcPqdnuhlsce0BGSSQN122AgeJuUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GFT9yV1j; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GFT9yV1j"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-6face367320so14264576d6.3;
        Fri, 04 Jul 2025 17:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751676074; x=1752280874; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2jYqu1y4C8gZBwtmd5DW4Q1O4gV8eIhCjn6oLyYM0qE=;
        b=GFT9yV1j7rEg/KndHhUHz1JayDTjbaCvyA5Ke37t6f5RLIGMHMsUQ792ycwEyI7s0K
         ZATk1GpjANfY/6wjGa56Dt/lXQ1XrIVLjKk2Evsc636hGBe21NGRDY1Q+qRzQU3+VopQ
         IuSwkV0g5efN/JNqfdrnNpKwVZe+neOl4os3waKCD0oxAP0H/mLLNcyIJ7zyn4g/kwjb
         jbNlv6XBs0PQXlvykZirQtmyiaCvBH78MW2pFCvm+jRidj7TUYYbqy7q2Kf2o+Bt5E9A
         OHtEh5sEtkCXIdWnOfde7wjYvQpO2iNn4SDSGq9BtUxjVKX1iD+zid9OPg/UDAsjsCvG
         wahw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751676074; x=1752280874;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2jYqu1y4C8gZBwtmd5DW4Q1O4gV8eIhCjn6oLyYM0qE=;
        b=tl6G62JNbZ0h/GAaTzIEhsxE4V4m/lqAcBwT40BfnhXzskgeofXFWyLYra30dykdEn
         P4tWsI3sTXOm+FuPP7tDgEdgthNDeqTij571vM7RTIFyVXm60pjAnurFPGKT4Z51iLeh
         IDphiUjvPPkSX8IkrGJdxJ9GDrKsINSa0Lw6IARp5jJLktx6M/xCTDsFMouU9neE16bY
         Ul7znP8xo6KyluyusQBZUVY3DAin38SCbC0ix1A+V/w5ixlI+X80mPC/1odIYzvveVEg
         gScchmMk+KwRWBTjEJWYsynzDEfIQDDplp8/JJZfqbtnyYagCIJfzRV4LNAG5sgCfNKv
         BMEA==
X-Forwarded-Encrypted: i=1; AJvYcCV5ayL3SGrx4pD915WNBX2/zFnUj25MYlBhLuczTEOXV1qkMjSWL79+ZjOC9VSVLovsck05tmRkER1/@vger.kernel.org
X-Gm-Message-State: AOJu0Yxst1YnMldkB+7G3F+faw1ZfdAf/Xk3LnhwIlPYyNrHkmqmJhfR
	f4o8cc48a05TzeHOkENuqXfjq9/fuTauAgpluBY6d2ZGB2py2rydyUmh6w0PhT4aDvzP5l9dCyE
	X1XZnJD5UlYPvx8XHoR5vZy8hdt685Nk=
X-Gm-Gg: ASbGncu706GozsPDCfCKYc2fMnwGlk4vkI+YZOW3J4ehIZtmaDQZrGag5dWm1uMHt8C
	maNMR+Q2Fls8+yE5J1+qigRR+44/xK/NbheqWD/UZA2f9CgCURG3AwOIDQm9mZuq1VONQ69zaar
	QY62vUu7jNi1klvwqIa24P7WSRfO2Mk6gJAH8XKYVgFufMEaD643yPY3AjClWfuuIMg8IBu2kK0
	bIOuA==
X-Google-Smtp-Source: AGHT+IHY9oGBxlpQmj0udq8hM2zlvfj7LkfGNTNzO4aq2lcPYBS4usESsq0qZiaWlVgYkfUaS0c+QplfM1byALByi34=
X-Received: by 2002:a05:6214:1c85:b0:6fd:c80:98f2 with SMTP id
 6a1803df08f44-702c6d7a645mr67563026d6.27.1751676074097; Fri, 04 Jul 2025
 17:41:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 4 Jul 2025 19:41:02 -0500
X-Gm-Features: Ac12FXxtlnxPHPVBiNIXhOdJcvTVigCmrZELQVNhM5Z26pxSx1XTRQqXR6HR4tQ
Message-ID: <CAH2r5mubFOMTrOVPwzq20wEx9u1dU1emymFptOGjB6rs8FTkjA@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
d0b3b7b22dfa1f4b515fd3a295b3fd958f9e81af:

  Linux 6.16-rc4 (2025-06-29 13:09:04 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.16-rc4-smb3-client-fixes

for you to fetch changes up to 3363da82e02f1bddc54faa92ea430c6532e2cd2e:

  smb: client: fix native SMB symlink traversal (2025-07-03 18:43:04 -0500)

----------------------------------------------------------------
Five smb3 client fixes
- Two reconnect fixes including one for a reboot/reconnect race
- Fix for incorrect file type that can be returned by SMB3.1.1 POSIX extensions
- tcon initialization fix
- Fix for resolving Windows symlinks with absolute paths
----------------------------------------------------------------
Paulo Alcantara (2):
      smb: client: fix warning when reconnecting channel
      smb: client: fix native SMB symlink traversal

Philipp Kerling (1):
      smb: client: fix readdir returning wrong type with POSIX extensions

Shyam Prasad N (1):
      cifs: all initializations for tcon should happen in tcon_info_alloc

Wang Zhaolong (1):
      smb: client: fix race condition in negotiate timeout by using
more precise timing

 fs/smb/client/cifsglob.h   |  2 ++
 fs/smb/client/cifsproto.h  |  1 +
 fs/smb/client/connect.c    | 15 +++++----------
 fs/smb/client/fs_context.c | 17 +++++++----------
 fs/smb/client/misc.c       |  6 ++++++
 fs/smb/client/readdir.c    |  2 +-
 fs/smb/client/reparse.c    | 22 +++++++++++++---------
 fs/smb/client/smb2pdu.c    | 10 ++++------
 8 files changed, 39 insertions(+), 36 deletions(-)


-- 
Thanks,

Steve
