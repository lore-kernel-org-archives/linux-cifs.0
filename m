Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F50D1AC426;
	Fri, 22 Nov 2024 22:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732313677; cv=none; b=qBEbMYzbmQVPSkOL1bVps1WHYRut4so4i12GTQOYGi3owPSVUd0mQXGSGDhplCmvEeI5fig8DFopfrTaszyrhHNayriN3cKtORKH6VHWP2YxqRkyCSDO8FmwNEYZrUy6amoQKEBezh0sD+mFnX6FqTq5LjQfin+n4KGNNIT/pYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732313677; c=relaxed/simple;
	bh=nAxY3sebuEX1uLz0DVN9IR1ICZkSCuZzKQZYYcFhHhk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=mLg11/G2kTfnbxTwVJeT6knj5vT6MckFxNLhV8+iznL8Kd4uiE5KUFToWW9dGNoOi6hon2O02RQ5UvrS2gRo9Wd9R+32bRtJxVe1WYv+X2V646UGenbCXM2Uh538vd0VCIa968snz5hnkMv51aozZEIE+SRHAxX9jE+VTX1mq0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FZ++Eu7T; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FZ++Eu7T"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-53da6801c6dso2355381e87.0;
        Fri, 22 Nov 2024 14:14:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732313673; x=1732918473; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Cfr5Vm544hL51GdwhcMXXqC83zX/wqHoEmLypgXkod8=;
        b=FZ++Eu7TK2NqAyLWHO28jjDkgHAwHUqxIs9kNTB0miIurrokggDa9p8YU9SBplnuHw
         KWRXRXkBRRffB2TiChZmU2sbxQQO326QMeqajXTKQ9zxsBrggyk5j5uGXN5I6Tf2drIh
         ELkdydk2nYd8ESx3JDk0AlvdQo9oiMoNGV+GSlMLnJz4VRiPBu2+kx+AHCs+49FeBusu
         bzLdfV+3BZ2iIb6mr6zUbQf9cw6qqFv+zGD6WzH2ZVHVBzgroOBHATt1T9dD+vXQtZdz
         A+uRPsSTO4cFePykUn+fxn/9idUMUWmSKMKVtZsi/NAo2rKemWqG4ENSKEgeElqiUXvh
         ybaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732313673; x=1732918473;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cfr5Vm544hL51GdwhcMXXqC83zX/wqHoEmLypgXkod8=;
        b=J7vLW2Pq0WMxzhXeZ9pCcvhMEEePM9Q4I9/YwqyM39K/w80Z/TUGf/WGgdMfiO0Go6
         oBF0Xmu6LPTFdSDuE99zF3jifcqH3vn9BIZmV6jQKgrNJXn1awPpce2AySge04bswq1d
         o+won9orKxXubC6jmIMvshNcvJwlqLkbAv87eaQOJ9wXnmUja6gmtI7q+qEv4kHg4Ir7
         NpyLxpOythFHU3c/vCZ7Y95wcnqnCwAsqOj/nxt99RSQCSDrV5OBSC5UJIn76XsxBvza
         zss7TaMOEYOlX7kaPPLpKG16XUXdksesFi+yOh/Y4zDtv93Jo4HiDDvsz3VsE1qMfrkR
         Bd4A==
X-Forwarded-Encrypted: i=1; AJvYcCXK2Ta8hWSGRhzoTgoF6IGTxSrabvP3oQ9e7FzMy3ZP+IobtwlNS6aTMJxso++mwp7xCjDKyGiMhv7f@vger.kernel.org
X-Gm-Message-State: AOJu0YxuzumeNWuo+2/4JRPMIU7FSchTYg9xAdGAQA41Bk/6NN8qA3Zx
	GS2xH/if+neEYQYBDEKa55ac+sPBjwIj4yKGKArRUOMG5+DI1SVVh/YBUaKqnLpRa8ryvQGles4
	dlgst2cms1FSHL7rOCcxaA8naDaJ5L6fo
X-Gm-Gg: ASbGncs7UKSFg46ljmeLuWACgmpDPsdce4wrKODpHuTZ0nuRpTzYHM0dD6NMtGBqwJd
	aBuYjWRtPTI5lzl48ijx4dJGGYroZGGsxs/i+ubIjrNdDWxnSajAmXohTUKa3RO8V
X-Google-Smtp-Source: AGHT+IGKIcyLi6CxkNbWAFYn9BO2rQDfmMAtJW7ZSH88vE39T2SNb1i8FylVyLr0l/sHAvdtsJBN2EF83XxNQPYpyhY=
X-Received: by 2002:a05:6512:b81:b0:539:fc45:a292 with SMTP id
 2adb3069b0e04-53dd39a4b25mr2889940e87.43.1732313673161; Fri, 22 Nov 2024
 14:14:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 22 Nov 2024 16:14:22 -0600
Message-ID: <CAH2r5mvA00Q69_YqTQFgG-AmBx8N1BdxA8MM24iknf9DSrnyGQ@mail.gmail.com>
Subject: [GIT PULL] smb3 fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please pull the following changes since commit
adc218676eef25575469234709c2d87185ca223a:

  Linux 6.12 (2024-11-17 14:15:08 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.13-rc-part1-SMB3-client-f=
ixes

for you to fetch changes up to a9685b409a03b73d2980bbfa53eb47555802d0a9:

  smb: prevent use-after-free due to open_cached_dir error paths
(2024-11-21 10:45:50 -0600)

----------------------------------------------------------------
15 smb3 client fixes, most also for stable
- Fix two SMB3.1.1 POSIX Extensions problems
- Fixes for special file handling (symlinks and FIFOs)
- Improve compounding
- Four cleanup patches
- Fix use after free in signing
- Add support for handling namespaces for reconnect related upcalls
(e.g. for DNS names resolution and auth)
- Fix various directory lease problems (directory entry caching),
including some important potential use after frees

There are additional important fixes still being tested that are not
included in this P/R, but should be ready later
in the merge window, including for remount cases, e.g. for DFS, and
also additional important directory lease fixes.
----------------------------------------------------------------
Dan Carpenter (1):
      smb/client: Prevent error pointer dereference

Dr. David Alan Gilbert (1):
      cifs: Remove pre-historic unused CIFSSMBCopy

Kees Cook (1):
      smb: client: memcpy() with surrounding object base address

Pali Roh=C3=A1r (1):
      cifs: Recognize SFU char/block devices created by Windows NFS
server on Windows Server <<2012

Paul Aurich (3):
      smb: cached directories can be more than root file handle
      smb: Don't leak cfid when reconnect races with open_cached_dir
      smb: prevent use-after-free due to open_cached_dir error paths

Paulo Alcantara (4):
      smb: client: fix use-after-free of signing key
      smb: client: improve compound padding in encryption
      smb: client: get rid of bounds check in SMB2_ioctl_init()
      smb: client: handle max length for SMB symlinks

Ralph Boehme (1):
      fs/smb/client: implement chmod() for SMB3 POSIX Extensions

Ritvik Budhiraja (1):
      CIFS: New mount option for cifs.upcall namespace resolution

Steve French (1):
      smb3: request handle caching when caching directories

Thorsten Blum (1):
      smb: client: Use str_yes_no() helper function

 fs/smb/client/cached_dir.c    | 99
++++++++++++++++++++++++++---------------------------------
 fs/smb/client/cifs_spnego.c   | 16 ++++++++++
 fs/smb/client/cifsacl.c       | 54 +++++++++++++++++++-------------
 fs/smb/client/cifsfs.c        | 25 +++++++++++++++
 fs/smb/client/cifsglob.h      | 11 +++++--
 fs/smb/client/cifsproto.h     | 11 ++-----
 fs/smb/client/cifssmb.c       | 65 +--------------------------------------
 fs/smb/client/connect.c       | 20 ++++++++++++
 fs/smb/client/dfs_cache.c     |  8 ++---
 fs/smb/client/fs_context.c    | 39 +++++++++++++++++++++++
 fs/smb/client/fs_context.h    | 10 ++++++
 fs/smb/client/inode.c         | 26 +++++++++++++++-
 fs/smb/client/reparse.c       |  5 ++-
 fs/smb/client/reparse.h       |  2 ++
 fs/smb/client/smb2ops.c       | 39 +++--------------------
 fs/smb/client/smb2pdu.c       | 11 +------
 fs/smb/client/smb2proto.h     |  2 --
 fs/smb/client/smb2transport.c | 56 +++++++++++++++++++++++----------
 fs/smb/client/transport.c     | 40 ++++++++----------------
 19 files changed, 293 insertions(+), 246 deletions(-)

--=20
Thanks,

Steve
