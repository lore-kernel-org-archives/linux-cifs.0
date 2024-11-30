Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53774AD31;
	Sat, 30 Nov 2024 01:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732928432; cv=none; b=gfH029S0FkV8lBX8p0Xowchwq1JaaxClR7e96gAQxluUvZO5teMsBwmdBJXNgyyjEoMzYNMpTjN8VlsFWg6lVGC6u5nyW456jbVJn6lhRMYMwm94Yp8uO/K4QMmex37DNErPBBrjA9dCsFMR3EF3AktkCNWnpjIsYiILJIPyWi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732928432; c=relaxed/simple;
	bh=iOyjvGf8m8flOUNAy5HM1kQ3giqsOb1zJ7gIH0HmkKI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=gV99uxDF3Z+QsBS5yJI3MrUj//G/uT+ipiI8hasVTHC92KcIxNSGfZwN1x75hxHWkdsFOZCypEKU1Snv9JVRPrBQDuCbxYXDQlSkW/21XhLiWGT9sxP0abyqVhwm4U/mbUXMgmfsRCT6fG7jBZJJZBq6h70O7Dozi7Zej3Gb4JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YxQ7CUWK; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YxQ7CUWK"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-53de84e4005so2849610e87.0;
        Fri, 29 Nov 2024 17:00:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732928428; x=1733533228; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+QKOOvFip81yuHEWpbhpqOV8si2+J1JX1PN+ftGxVC8=;
        b=YxQ7CUWK/W3i9M/skWLT69Rcv/d2LhFdOCuRBjQvutE+a5x1jTmX5Sh3aG/GAdCFxo
         cRz3UdB3mCyU6u2lyjsYnSlgrzb9cAWzYGWpqt+lK8nXDoGuKj/EL+NCJIPtq41Ybvy8
         BrFuICTwn/DPgMoM+PrqsdtMwuS+epaRpSMhyjzTn1EH55Z7G8aas720KJfDDLNRrIKq
         JTaS8TamadExYZCQs6cc4RtsKA3mo6ktbnHabjxyEadMuH9iyMT132Xl9OPUWqYHmb5p
         Iuc15ZzQ2KpmjzTuXX41oPQMwn0DGR2YG0jR33WHGUv6BkhRSyc7eBAEgPmNqEae8WUk
         DNKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732928428; x=1733533228;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+QKOOvFip81yuHEWpbhpqOV8si2+J1JX1PN+ftGxVC8=;
        b=aLQEgW9ETs/+R+j0LPY7eovWc7kVBw3m1bgNcuUGpAtHiUvaQ286r6JevPRVn5u9Nb
         7IPSS8QcHqACgt9ANq2yP2Lp10GfcseOsZT0Fko9PisKafW603MLIYIAcsEtX2GX+28+
         7LmbyGU7i5TI/piPnPCiAMssCZnzuwsIHxBmruXthv7WB9kGIe+GmVP9IFFWzPB6O/Hk
         0IJ37LAGXONMJYEpAARN4WDVpmPw7i6hjGPpkPRmoC9kZqAcA5v+gj4dRMpbb1821g5v
         7ABL9DqcpmhJT9vQ1vl64Z9fP9vbU+oGimdntHodnqqYmirwzt/tLxdrkYWgU62qK3WK
         8NQw==
X-Forwarded-Encrypted: i=1; AJvYcCUMlocUO4m2TkblAwg82KnLzy54bzXm9ULkIV9jk1r/HXTovO1mfdipBKQw5BiziQk/nop1u/eJ0HFPtAk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwTcgi/9eZfC4heKT0/d+hXRzzGbYAfuys9O6SnCaWAsbI08Q2x
	jIAQ3imQFU+ZAFooxnt92xyL6HE/P1k5Fx/qXMFfZc/H2CtTquFLiu9sbRw5VEgMN99vZE7WnwP
	ZW7NjREGKfphm9BfhPfXW1IU0Pg/dlGyS
X-Gm-Gg: ASbGncuW2G1HqCgxbnhM1wrjk8jGH1EGH06nNj/tv9QRTS9eCZA3rtFbbmoIOwBc+Uf
	pxsGbWCsILJmpHtjqNyJDsOMpjnVDuR2U/wlg3GVHFSG5mYv43U16WFWoyP+xXSFzRw==
X-Google-Smtp-Source: AGHT+IEVI/jvUAxOq53CzXENx16Akn805JEEU+wsVpyI0V41/F6QYh36kEb0cfFynZuIXPsN6jFiQw7s+nP0IqEgPcw=
X-Received: by 2002:a05:6512:2210:b0:53d:ed6c:26ea with SMTP id
 2adb3069b0e04-53df00c79a2mr8022446e87.8.1732928428220; Fri, 29 Nov 2024
 17:00:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 29 Nov 2024 19:00:17 -0600
Message-ID: <CAH2r5mtEPAZ4XVpvWszL3=Vah7hxTJYoZbGNzh-fLT_-ayquxg@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please pull the following changes since commit
228a1157fb9fec47eb135b51c0202b574e079ebf:

  Merge tag '6.13-rc-part1-SMB3-client-fixes' of
git://git.samba.org/sfrench/cifs-2.6 (2024-11-22 21:54:14 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.13-rc-part2-smb3-client-f=
ixes

for you to fetch changes up to 8d7690b3c146f8ae3089918226697bf4e3943032:

  cifs: update internal version number (2024-11-28 09:51:14 -0600)

----------------------------------------------------------------
22 SMB3 client fixes
- Five directory lease fixes
- Three password rotation fixes
- Reconnect Fix
- Two minor cleanups
- Fix for SMB3.02 mounts
- Three DFS (global namespace) fixes
- Six fixes for special file handling (most relating to better
handling various types of symlinks)

There is an important additional directory lease fix (unmount cache
race) being investigated,
and some additional special file handling changesets that need to be
rebased that are not included
in this P/R but will try to send next week.
----------------------------------------------------------------
Dan Carpenter (1):
      cifs: unlock on error in smb3_reconfigure()

Henrique Carvalho (3):
      smb: client: remove unnecessary checks in open_cached_dir()
      smb: client: disable directory caching when dir_cache_timeout is zero
      smb: client: change return value in open_cached_dir_by_dentry() if !c=
fids

Marco Crivellari (1):
      Update misleading comment in cifs_chan_update_iface

Meetakshi Setiya (1):
      cifs: support mounting with alternate password to allow password rota=
tion

Pali Roh=C3=A1r (6):
      cifs: Fix parsing native symlinks relative to the export
      cifs: Validate content of native symlink
      cifs: Add support for parsing WSL-style symlinks
      cifs: Improve guard for excluding $LXDEV xattr
      cifs: Validate content of WSL reparse point buffers
      cifs: Fix parsing reparse point with native symlink in SMB1
non-UNICODE session

Paul Aurich (2):
      smb: During unmount, ensure all cached dir instances drop their dentr=
y
      smb: Initialize cfid->tcon before performing network ops

Paulo Alcantara (6):
      smb: client: fix NULL ptr deref in crypto_aead_setkey()
      smb: client: allow more DFS referrals to be cached
      smb: client: get rid of @nlsc param in cifs_tree_connect()
      smb: client: allow reconnect when sending ioctl
      smb: client: don't try following DFS links in cifs_tree_connect()
      smb: client: fix noisy message when mounting shares

Shyam Prasad N (1):
      cifs: during remount, make sure passwords are in sync

Steve French (1):
      cifs: update internal version number

 fs/smb/client/cached_dir.c | 170 +++++++++++++++++++++++++++++++++++------=
----
 fs/smb/client/cached_dir.h |   6 +-
 fs/smb/client/cifsfs.c     |  12 +++-
 fs/smb/client/cifsfs.h     |   4 +-
 fs/smb/client/cifsglob.h   |   4 +-
 fs/smb/client/cifsproto.h  |   4 +-
 fs/smb/client/cifssmb.c    |  15 ++--
 fs/smb/client/connect.c    |  66 +++++++++++++++---
 fs/smb/client/dfs.c        | 193
++++++---------------------------------------------
 fs/smb/client/dfs_cache.c  |   4 +-
 fs/smb/client/fs_context.c |  85 ++++++++++++++++++++---
 fs/smb/client/fs_context.h |   1 +
 fs/smb/client/inode.c      |   4 +-
 fs/smb/client/reparse.c    | 157 ++++++++++++++++++++++++++++++++++++++---
 fs/smb/client/reparse.h    |   4 +-
 fs/smb/client/sess.c       |   5 +-
 fs/smb/client/smb1ops.c    |   4 +-
 fs/smb/client/smb2file.c   |  21 +++---
 fs/smb/client/smb2inode.c  |   6 +-
 fs/smb/client/smb2ops.c    |  14 ++--
 fs/smb/client/smb2pdu.c    |  20 +++---
 fs/smb/client/smb2proto.h  |   9 ++-
 fs/smb/client/trace.h      |   3 +
 fs/smb/common/smb2pdu.h    |   9 +++
 24 files changed, 523 insertions(+), 297 deletions(-)


--=20
Thanks,

Steve
