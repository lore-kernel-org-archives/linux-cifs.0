Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248AA20E6;
	Sun, 30 Mar 2025 23:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743376764; cv=none; b=EsA+rOn1jxt8iS7hwUZNdeMCT2B3OKAzT3mPOED2dg5zGhqCaW/D8MaLnA9S4JQ9qXH7sShh9RQwUtfZCbPqhKUwRxqQOuZCENtuPXTyTY4LbmLGxdfq2Wo755kE9co4oKt6fUsj3jF8RJRocrSJpGJ0pbrI681MKVlttNQEM6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743376764; c=relaxed/simple;
	bh=8nQGx2KJsjUrKVGpuIbNILsMlvjdk37dTmK+6zn4g/g=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=EbVTJ3kB8adm/KcjbPqA3HJGLeup3D1+YiAIxAAnk+LGMOU3FaETUYRs2BGjoPnNunXoXQfx7ZHn2gt3aOsc0e2wHPfgaBhzb0fZYoY+Kpr/oDPJmVKd2yeA8XTLz590TYM492XgWnT9q7v3h7RutoNqfB6QIanYI0ouBrEOcQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TwXxlMnM; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TwXxlMnM"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5499bd3084aso3738109e87.0;
        Sun, 30 Mar 2025 16:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743376761; x=1743981561; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6BJMr1YMIspleLREyQx5LlPS/Sumgq17WN3aY8QEoU0=;
        b=TwXxlMnMl3H8N2jFZTz1MT8fAw/9B7JxlaQHlo0tjz9dTpetN1/w9OxewNn//QxlLK
         oyMOJxtPq8XRg7qmhd9CdzDoFG9A2GQFBEhnW94gM6iaqlJmbt0x/Lk/XCYyKfkCR5CT
         GWu3o6vQOiP+Ujy3FJhm75odyiMGzTixyDVdIKK2ywRgodlnDG/QhHkZrzxNlwqB+P02
         xmCSBbF0FKfFTPc79gaV83dotv/jkTj5/XL7bc407hp1GKUwyZ7uLOca5DRMR0njJTzI
         PVyuWbY7/EKI6XOz14gk9m2yFzTccc3t5szfZG2MvkyBQPbPYP3wJWxwUkWCyyZsiizx
         j72Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743376761; x=1743981561;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6BJMr1YMIspleLREyQx5LlPS/Sumgq17WN3aY8QEoU0=;
        b=Od9KG3j4LLCpZ/O0YRDT4M59GCq5H4dHTvCNga72Yt2q+Qlv4+LA4MXcnu+Wu5uGCn
         W+r5kIGszvRwDxSIVVtNG/xCycZOTg1uvvjxSpiQgUVw5OPY3CvziPCpzKaPXHaoEvRn
         GoqFd7+hESGQjhgw3T1apSQ6sIq/gTOBrnjuZ2k2ybOac5Atx6RdEVVYDcHt58FsClPc
         b2FftFELUzIjC/B3TfujdYtTCh5uaVaq7Hg/AmCysv8rfWuyVHqLZG5kf4+e6LLNj2vc
         aEElJWWoUgCripdsSEQ1YC4mC+MZyMEqkw5jCcSyuK/zsJLbYvIlxS9YTmQJvAUOXo0I
         gg5A==
X-Forwarded-Encrypted: i=1; AJvYcCVtTqQ6QZ6zF1/zfvjp4W7Drqp29Kd1G2d/35woV+N7as4/zQrJY8j8Ho0uXwxIh4PtVYXylgCZw3OE@vger.kernel.org
X-Gm-Message-State: AOJu0YwQyujlX8m50Bgsm3lfXgG5wykMWh9aepFr8F88do0WAB+cY2I7
	XDAyjr1QPWQB3Bfl4kx9EhthM8hqDHo4v44Fe+tsZ2xfWFUvpNqMK6bYGP1hCUI5P/TDrtVCjpJ
	EoyoDasAazR18ndggicucueYdE5hJSgV1
X-Gm-Gg: ASbGncvFJf8vuhTz9e1DtHMg8iSRmqHiST6LbDKiOPATpqMP5yzaoTMHscTIRVt/Byn
	uQHT15coR1+GSreFE70NGkjh5utd4j+AmTwgky1z+1rJAotvUPQH/wrW5CvJP6NvUkDMS+JgUCI
	Dq7H0xoEgpfNlrznknKOCl+Ds4CYM6/ufcZb3azf4MpIwnMrV3j9HEUCFVPOzO
X-Google-Smtp-Source: AGHT+IGqqNkf/CsL8lniMdgz9V+ClCUIp47QcW90Bhn1P7CsqBJ2PdWK0XnE9d4syvgquR9xzQefhhaVkK5Da4mxuvE=
X-Received: by 2002:a05:6512:a90:b0:549:8cc8:efed with SMTP id
 2adb3069b0e04-54b1113f152mr1727512e87.48.1743376760845; Sun, 30 Mar 2025
 16:19:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sun, 30 Mar 2025 18:19:09 -0500
X-Gm-Features: AQ5f1Jreu8PzZ5-rQRxOkZLjfT8xaaUmNfo78xnkzAvd54z5yLE3DLisMbT91_s
Message-ID: <CAH2r5mtYV4wqDvgod+qrzv1+YQN_zzjvEh1TKTwPmtkBU5jC6g@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please pull the following changes since commit
38fec10eb60d687e30c8c6b5420d86e8149f7557:

  Linux 6.14 (2025-03-24 07:02:41 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.15-rc-part1-smb3-client-f=
ixes

for you to fetch changes up to e14b64247438e5026b2fce8ffd7cdf80a87e2bfa:

  cifs: Add new mount option -o nounicode to disable SMB1 UNICODE mode
(2025-03-26 14:51:58 -0500)

----------------------------------------------------------------
14 smb3/cifs client fixes and minor update to maintainers file
- Fix for network namespace refcount leak
- Multichannel fix and minor multichannel debug message cleanup
- Fix potential null ptr reference in SMB3 close
- Fix for special file handling when reparse points not supported by server
- Two ACL fixes one for stricter ACE validation, one for incorrect
perms requested
- Three RFC1001 fixes: one for SMB3 mounts on port 139, one for better
default hostname, and one for better session response processing
- Minor update to email address for MAINTAINERS file
- Allow disabling Unicode for access to old SMB1 servers
- Three minor cleanups
----------------------------------------------------------------
Alexandra Diupina (1):
      cifs: avoid NULL pointer dereference in dbg call

Aman (1):
      CIFS: Propagate min offload along with other parameters from
primary to secondary channels.

Bharath SM (2):
      smb: minor cleanup to remove unused function declaration
      smb: mark the new channel addition log as informational log with cifs=
_info

Ivan Abramov (2):
      smb: client: Remove redundant check in cifs_oplock_break()
      smb: client: Remove redundant check in smb2_is_path_accessible()

Namjae Jeon (1):
      cifs: add validation check for the fields in smb_aces

Pali Roh=C3=A1r (6):
      cifs: Check if server supports reparse points before using them
      cifs: Fix getting DACL-only xattr system.cifs_acl and system.smb3_acl
      cifs: Fix establishing NetBIOS session for SMB2+ connection
      cifs: Improve establishing SMB connection with NetBIOS session
      cifs: Set default Netbios RFC1001 server name to hostname in UNC
      cifs: Add new mount option -o nounicode to disable SMB1 UNICODE mode

Steve French (1):
      MAINTAINERS: reorder preferred email for Steve French

Wang Zhaolong (1):
      smb: client: Fix netns refcount imbalance causing leaks and use-after=
-free

 MAINTAINERS                |   2 +-
 fs/smb/client/cifsacl.c    |  21 ++++-
 fs/smb/client/cifsfs.c     |   4 +
 fs/smb/client/cifsglob.h   |   2 +
 fs/smb/client/cifsproto.h  |   4 +-
 fs/smb/client/cifssmb.c    |  11 ++-
 fs/smb/client/connect.c    | 206
++++++++++++++++++++++++++++++++++++++++++++-----
 fs/smb/client/file.c       |   2 +-
 fs/smb/client/fs_context.c |  22 ++++++
 fs/smb/client/fs_context.h |   2 +
 fs/smb/client/link.c       |   3 +-
 fs/smb/client/sess.c       |  10 ++-
 fs/smb/client/smb1ops.c    |   1 +
 fs/smb/client/smb2inode.c  |   8 ++
 fs/smb/client/smb2misc.c   |   9 ++-
 fs/smb/client/smb2ops.c    |   6 +-
 fs/smb/client/smb2pdu.c    |   4 +-
 fs/smb/client/transport.c  |   2 +-
 fs/smb/client/xattr.c      |  15 +++-
 19 files changed, 289 insertions(+), 45 deletions(-)


--=20
Thanks,

Steve
