Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4317D4594A;
	Tue, 17 Sep 2024 08:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726561353; cv=none; b=tt4ByPaWTaFHhHQEpfkRa76IiGctfKginQ80ZIcfsq9PUqg+pxmgl4s3H+TWDOs5UL95gmOHlqasOneF2II7vGYYqwJAh1yqmUrCKfqlUYwuglM3ec0pKlP+fsHSttCR668WGzyqsIfQFDM2CXLNa7Ptk1EUGa4PNvXKjhi7bsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726561353; c=relaxed/simple;
	bh=l1pSz29EuUBpMGd3E01UJeVACK68jEKOOMaVk6onMDQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=J8lSONh5tyMswqEK8qj3bZnOTZO/OnqCFVIJIYQjk+ovt6VKUN6EQIu0gwTRA7mDkXZkU39HDryYJBfz2ZxtQeX5fmecwec80Y12f+f4qILkRQ6u2uAMQfY8UeymfT7NuStWtz5Ue+TlZqPtlp4wFRxXO41QzOJ5qHoKd7Lsf7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FZUo3d75; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FZUo3d75"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5365d3f9d34so4485422e87.3;
        Tue, 17 Sep 2024 01:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726561349; x=1727166149; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Wbe/JfD8hhe2IqgyM7Dn2Wgv/TP3Y/5IerNzqQMyyOQ=;
        b=FZUo3d75zxE7ffgGvbztuyKwQZErsUpoBSrv/z3T6tDdjDN9BHJEGvDBDvHQVTZ2sx
         qUe7wcTuGry2Pl5nkR3xhfbyimWLlKsZUj+ptIuCMtQ8YkDlHSGU+VeTVysNaDLasKLI
         v69e6WiqvUh7TB9vhPGDjzTI5UcghqaovGLEB57/cqS5U43Gklu9kVUChQAxeY2lFhde
         94HVosrPg0yzlBSJfrKibFGLkZ3Xm+VdBEjjSJEGrQp7QTESgIWE4nxnbH+BEv/EgvuY
         lbWON2y58g7qXizKwzz+R3JEYi+ehPTvZu5rB6Q2UZKeVkgvovlvtpg0bzJm+UfiP3N2
         uWUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726561349; x=1727166149;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wbe/JfD8hhe2IqgyM7Dn2Wgv/TP3Y/5IerNzqQMyyOQ=;
        b=Tsqb+9UWTDT4oSztPcBCGND2VBGc0wS1vpAWj6cuQCJIf9mX9ynbOdohJGGgbPAfsr
         z/2sWEb22imx1yRjq1beONPJHl739k93guLok70lV3Pkjm3w6xW8jrAiJUgpX6p4Isf7
         fTeGj/r0FC/xVBIs/nwB2SrdkRFej179FFP8f7YOaDAS2cBLs7E4MmCukEaS/UpUuRND
         XIeo1CGcVSzmw3TUIwGN8q9m4ItZfxxEK3ElSBUeSj35knfnNtgImMlwwdRFJpUwn3Gm
         KjQa+2VCacaLss9WVU6dRS4DrXV6vkiypNwN8AhX3KhlAG8jT6qHgKm/4Odg0FlCkVy0
         bRHQ==
X-Forwarded-Encrypted: i=1; AJvYcCWlanW/IahZLJLRBBsAMrb8Phg9y+pOPEDYi3hKHocG9sRj4vc3r5GvrzgF4RIKq4JJCiLrugkqi65d@vger.kernel.org
X-Gm-Message-State: AOJu0Yxw9OouQbpSSKctLbfWCFS5tB+pQlwZ7zAeMQg+pBnYnYmYrfhp
	R0MhMGcNixAS9AHeT2Njt1iFmZsoKHDaibpAFdLIgJyA+aa7OSK2PKTr4OYFf+tZ7fKQK2YYius
	Q7BGZAPUElGfjcHCKD4Ae8zbxOpCX7dxg
X-Google-Smtp-Source: AGHT+IEhuYf/jcliFXdW7ziBm3JsmBOtvVSb58+Ce7EZD5hsRuY/ASltwEu0MpB1LolN5xbuROCqCw2X1u4JJakeFiE=
X-Received: by 2002:ac2:4bc4:0:b0:52e:a63d:e5c1 with SMTP id
 2adb3069b0e04-5367fee52a2mr6667367e87.30.1726561349141; Tue, 17 Sep 2024
 01:22:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 17 Sep 2024 03:22:17 -0500
Message-ID: <CAH2r5mvoPwxQgOFOJpLke-deTpy2rh6o=Xh-F8tWr08bMdiEcg@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please pull the following changes since commit
98f7e32f20d28ec452afb208f9cffc08448a2652:

  Linux 6.11 (2024-09-15 16:57:56 +0200)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.12-rc-smb3-client-fixes-=
part1

for you to fetch changes up to 5ac1f99fdd09d80223e8f47dffaea41a6563aace:

  smb: client: fix compression heuristic functions (2024-09-16 20:10:39 -05=
00)

----------------------------------------------------------------
SMB3 client fixes
 11 cleanup changesets (moving duplicated code, removing unused code etc.)
 7 fixes relating to "sfu" mount options (for better handling special
file types)
 6 SMB3.1.1 compression fixes/improvements
----------------------------------------------------------------
ChenXiaoSong (7):
      smb/client: rename cifs_ntsd to smb_ntsd
      smb/client: rename cifs_sid to smb_sid
      smb/client: rename cifs_acl to smb_acl
      smb/client: rename cifs_ace to smb_ace
      smb: move some duplicate definitions to common/smbacl.h
      smb: move SMB2 Status code to common header file
      smb: add comment to STATUS_MCA_OCCURED

Enzo Matsumiya (3):
      smb: client: insert compression check/call on write requests
      smb: client: compress: LZ77 code improvements cleanup
      smb: client: fix compression heuristic functions

Gaosheng Cui (1):
      cifs: Remove obsoleted declaration for cifs_dir_open

Hongbo Li (1):
      smb: use LIST_HEAD() to simplify code

Pali Roh=C3=A1r (7):
      cifs: Fix recognizing SFU symlinks
      cifs: Add support for reading SFU symlink location
      cifs: Put explicit zero byte into SFU block/char types
      cifs: Show debug message when SFU Fifo type was detected
      cifs: Recognize SFU socket type
      cifs: Add support for creating SFU symlinks
      cifs: Update SFU comments about fifos and sockets

Qianqiang Liu (2):
      smb: client: compress: fix a potential issue of freeing an invalid po=
inter
      smb: client: compress: fix an "illegal accesses" issue

Shen Lichuan (1):
      smb: client: Use min() macro

Steve French (1):
      smb3: mark compression as CONFIG_EXPERIMENTAL and fix missing
compression operation

Yuesong Li (1):
      cifs: convert to use ERR_CAST()

 fs/smb/client/Kconfig                  |   14 +
 fs/smb/client/Makefile                 |    2 +
 fs/smb/client/cifs_debug.c             |    7 +-
 fs/smb/client/cifsacl.c                |  226 +++---
 fs/smb/client/cifsacl.h                |   99 +--
 fs/smb/client/cifsfs.h                 |    1 -
 fs/smb/client/cifsglob.h               |   25 +-
 fs/smb/client/cifspdu.h                |    6 -
 fs/smb/client/cifsproto.h              |   28 +-
 fs/smb/client/cifssmb.c                |   14 +-
 fs/smb/client/compress.c               |  390 ++++++++++
 fs/smb/client/compress.h               |   90 +++
 fs/smb/client/compress/lz77.c          |  235 ++++++
 fs/smb/client/compress/lz77.h          |   15 +
 fs/smb/client/connect.c                |    5 +-
 fs/smb/client/file.c                   |    7 +-
 fs/smb/client/fs_context.c             |   20 +-
 fs/smb/client/inode.c                  |   42 +-
 fs/smb/client/link.c                   |    3 +
 fs/smb/client/misc.c                   |    9 +-
 fs/smb/client/smb1ops.c                |    2 +-
 fs/smb/client/smb2file.c               |    6 +-
 fs/smb/client/smb2inode.c              |    6 +-
 fs/smb/client/smb2maperror.c           |    2 +-
 fs/smb/client/smb2misc.c               |    2 +-
 fs/smb/client/smb2ops.c                |   98 ++-
 fs/smb/client/smb2pdu.c                |   19 +-
 fs/smb/client/smb2pdu.h                |    8 +-
 fs/smb/client/smb2proto.h              |    2 +-
 fs/smb/client/smb2transport.c          |    2 +-
 fs/smb/client/smbdirect.c              |    6 +-
 fs/smb/client/transport.c              |    4 +
 fs/smb/client/xattr.c                  |    4 +-
 fs/smb/{client =3D> common}/smb2status.h |    6 +
 fs/smb/common/smbacl.h                 |  121 ++++
 fs/smb/server/oplock.c                 |    2 +-
 fs/smb/server/server.c                 |    2 +-
 fs/smb/server/smb2misc.c               |    2 +-
 fs/smb/server/smb2pdu.c                |    2 +-
 fs/smb/server/smb_common.c             |    2 +-
 fs/smb/server/smbacl.h                 |  111 +--
 fs/smb/server/smbstatus.h              | 1822
-----------------------------------------------
 fs/smb/server/transport_rdma.c         |    2 +-
 43 files changed, 1206 insertions(+), 2265 deletions(-)
 create mode 100644 fs/smb/client/compress.c
 create mode 100644 fs/smb/client/compress.h
 create mode 100644 fs/smb/client/compress/lz77.c
 create mode 100644 fs/smb/client/compress/lz77.h
 rename fs/smb/{client =3D> common}/smb2status.h (99%)
 create mode 100644 fs/smb/common/smbacl.h
 delete mode 100644 fs/smb/server/smbstatus.h


--
Thanks,

Steve
