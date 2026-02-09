Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDEF42049
	for <linux-cifs@vger.kernel.org>; Mon,  9 Feb 2026 21:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770674220; cv=pass; b=Yubkntx+4IIzkaOjYVFkXzLCJRRdxqahMbLc24OXfeTaA4aWwCGrRUK6sEWLEr5j9zrtyYgPt/9KRVQ4guk0lrEPr6yc+NXVrOH4+z7jhOaoOzDAWdYcgewUItP2wfgrYw8NF9oG5u6UnbK0r7cucvf3Znwct2K5qhubH1ygE5E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770674220; c=relaxed/simple;
	bh=ovc8VhFOQbs+GL3mB8/YAvEoQEHefCwWGhAGOY8OOeo=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=te8ZTFAl/0zPplniC01hBnWCy1uiqUQmq5MxJoDeXyr9hm4l++qjJ7KMQtmSRWDjpacUFyf1TgMpj87d9Trfh2Ml963+n/sh5QC+bBSNZDtECAoaRhRr/cfaFNBYENI9zmIz96DpYFW8vrEfX6ockldcCe2H2zmfG4l8QCJ8DRI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ga39SOi1; arc=pass smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ga39SOi1"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-896f5af3d8aso2266716d6.1
        for <linux-cifs@vger.kernel.org>; Mon, 09 Feb 2026 13:56:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770674218; cv=none;
        d=google.com; s=arc-20240605;
        b=HdOmbPVYa1weZWd2OylG6eiQ3KLGsdDv9eu4uuz0g9WoSNyG+MPepUREc1WYWSa1lM
         hqGwbbIljbtQQiGi3yNqk0p9x1EHE2Mya0HUgMlm5e70GETd3yOy44e0RDqTcaofCC7z
         ODBPDPEXPmAvCzFCMdHdQYjWFXH+H1F4SJCmG80LyaPgjjIOcequVQkx2GITg0xqqYuF
         MheetjvcovWl8gN+RwUmDgK9VxKfkBUE/wHocMuFSMDOYNBVc7gsOi2B+KgwoTzXooX8
         wcxXni1e/ZJZvOfBaecOs/YWzT/dYk2Fu5BOlGxA9yBn8aVMaRFEGWCq8dOQQ9ffalQf
         URDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=C3Sj+hdneNwqPf1mdj4NyPDUlB37eID7fNX5vFfWeQg=;
        fh=JeiS/uH06Zl+btMxkrMS8CYXM+hOkzDlBb8+hxZg1a0=;
        b=hOPxmFgWk4nBP0O7C5Xwb95P3ny6Qzu0Ydt/2iyqxLEn58zNc8+ixk4zLtFXRCs2tn
         FxkTAiRrJOAUBFcw2zg9dx+KZi+cqrgY4PDPBr8YCT2wAZjvvHcxSC3GgGqumA8dxLD6
         Xcn6gY/CO+Ef1S8iEmWf1dQM6yHAWNLytVmedDVkvva6QYZSwqhdeR7T6/uMMSJRmS3o
         ZvaTW8M13apfnwljFG8dAHvxVzdrBV/3kh/BB8NXbbcBeolVVZh57x8rPjJ8lZIPhvrK
         p6jZViwGGw5uIy91QOwuay3GTJUwHN2N7R3ugIfWJ/N0yjUrAfrkfUq46Jn/gGb8qOKJ
         CbVQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770674218; x=1771279018; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=C3Sj+hdneNwqPf1mdj4NyPDUlB37eID7fNX5vFfWeQg=;
        b=ga39SOi1w8L2xcPluIt/BCF4z3yiqUdCLcy9vC8FDV/5UmPyv/7ZFULAH2lMD6/R1X
         gbHgSGx8FkFiTSz4I+6GaSaSPlT4MFBZ4DeLHh3TLS5W/pDmAiXK4ile00JXRfBrALy4
         xdrsPi6FzfsWjYktKvA/EjxCsRG8i4wMS8R+6sHUCCxBWX4VCUF/mMpROwqNHctHrNx5
         oMOO4fxqWErTnosjDYmYF55j73VVXzys8/Qyo4l1IR6bG5a1ZPtdTWyqlxqaMEGoG2kI
         qVPoMTmSUudrVCZ/rOubN2eLNlz/9vEeWYDs7OXqJbps8X4qTZpZc+cpTMLH0pH7W3BF
         y8ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770674218; x=1771279018;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C3Sj+hdneNwqPf1mdj4NyPDUlB37eID7fNX5vFfWeQg=;
        b=sVCYByzF4mEMZN6kR3lZMC1G09mamFrXQPnpXv4NKRkf4HdvcvVtRv6BZzSqHiVPzT
         BQyCGdI/qHSG/cEx43eO9Ud3Q1R88jQJ1vA9Ad3DFBcqZ9KftDGiXMEqem1w6lU/QYpX
         I7F2L+T5EyVvPTmxajMh4YVuMERRayRdy0kRANDJ00C0jWyA4Eut+MO8siNrDPc1MINE
         WNMsMS8udYpMKuRmTD3LTiFpowuTAQ4KQr6DU6IHo7D+P7R1ynIJLanzxsl442kkpr28
         cDFZxTP3SJLjkn6CdTjnq/uHjOrY3UaTe5asKFcynLtThB4KP20go+/oqsg0p2NLxlvz
         PwPw==
X-Forwarded-Encrypted: i=1; AJvYcCWZYroi0HTJ/hFdwGDwyw9gUREvCLIOnQgx1TJjUNe5pUDvl/QB7gXT7sqMFb1vJBAQ09vuc+SXu0gn@vger.kernel.org
X-Gm-Message-State: AOJu0YyuyOU2gqiMLXKQZhnvonEONLKjQ/QlGjozU3KwKJLrvTwUGXLx
	wPWhxfHRoCyWNbnlpf75W+Y95Bc4ohKjVMMeWSVIrmipPaWwiTOYKAAgvnko6bQ7R66c59396Hg
	lw2Z2TU9aDY2hgKiOvPboavev0SC0UXo=
X-Gm-Gg: AZuq6aL93z8FLEMW3UI3tBsAH4csvd5Bi0OUxw2MYoRZv5+RfvtVcJdxYFp4LrS8y3G
	mhIE+Y55UYXwhozYi4EV/O8mWKcA6NlbgBE/6+nIiSIZMLBBLZ58WLVPyMTPYCgwpBg71vMwkYv
	C7KjhwHPYN3heqZdJVLqBP9lofEEHvaXtsA/N2ulb89uy0/HHEbE0m0lR1l444ZmGk1h8Ghu61O
	nf4Yz3vwmeeWrB2qsmOVrEk6ly2+nF6yzgnqNf1k83fagndKV57bXEKJU9ijRAPIQWNNzDxHKKT
	UImJxs2ruBbe9ahgW/REGtbA/BDf49N0roDgDPlyXIvkXrOtWlC/hNVi5xbWQqxQF1dKXY0cDQg
	Omc8rUd3dOgQg6ZHBvTIL7a6m9luydC80TPoNRKRkrw/BCjKfdkI=
X-Received: by 2002:a05:6214:27e2:b0:895:1855:f174 with SMTP id
 6a1803df08f44-8953c8065a2mr183411096d6.24.1770674218017; Mon, 09 Feb 2026
 13:56:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 9 Feb 2026 15:56:46 -0600
X-Gm-Features: AZwV_Qjz4xtOA9H0TsJUWN2Vz9vpKOwfFeEzhpIlJwraZVFO7YYpcQi9nuHIWVo
Message-ID: <CAH2r5msuFqDVtb8_HnGin3PyLZ7h4CUnU3yh+ZV_Za_sEWPdhw@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
05f7e89ab9731565d8a62e3b5d1ec206485eeb0b:

  Linux 6.19 (2026-02-08 13:03:27 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v7.0-rc-part1-smb3-client-fixes

for you to fetch changes up to 95080648ed52c6b97153ad989252576a3c070036:

  cifs: Fix the copyright banner on smb1maperror.c (2026-02-09 08:08:54 -0600)

----------------------------------------------------------------
74 client changesets
- Three multichannel improvements, including making add channel async
at mount time
- Fix potential double free in open path
- Four retry fixes
- Three locking improvements
- Fix potential directory lease races
- Eighteen cleanup patches for client headers
- Nineteen patches to better split out SMB1 code
- Minor cleanup of structs for gcc 14 warnings
- Twenty two error handling improvement patches
----------------------------------------------------------------
ChenXiaoSong (3):
      smb/client: check whether smb2_error_map_table is sorted in
ascending order
      smb/client: use bsearch() to find target in smb2_error_map_table
      smb/client: introduce KUnit test to check search result of
smb2_error_map_table

David Howells (40):
      cifs: Scripted clean up fs/smb/client/cached_dir.h
      cifs: Scripted clean up fs/smb/client/dfs.h
      cifs: Scripted clean up fs/smb/client/cifsproto.h
      cifs: Scripted clean up fs/smb/client/cifs_unicode.h
      cifs: Scripted clean up fs/smb/client/netlink.h
      cifs: Scripted clean up fs/smb/client/cifsfs.h
      cifs: Scripted clean up fs/smb/client/dfs_cache.h
      cifs: Scripted clean up fs/smb/client/dns_resolve.h
      cifs: Scripted clean up fs/smb/client/cifsglob.h
      cifs: Scripted clean up fs/smb/client/fscache.h
      cifs: Scripted clean up fs/smb/client/fs_context.h
      cifs: Scripted clean up fs/smb/client/cifs_spnego.h
      cifs: Scripted clean up fs/smb/client/compress.h
      cifs: Scripted clean up fs/smb/client/cifs_swn.h
      cifs: Scripted clean up fs/smb/client/cifs_debug.h
      cifs: Scripted clean up fs/smb/client/smb2proto.h
      cifs: Scripted clean up fs/smb/client/reparse.h
      cifs: Scripted clean up fs/smb/client/ntlmssp.h
      cifs: SMB1 split: Rename cifstransport.c
      cifs: SMB1 split: Create smb1proto.h for SMB1 declarations
      cifs: SMB1 split: Separate out SMB1 decls into smb1proto.h
      cifs: SMB1 split: Move some SMB1 receive bits to smb1transport.c
      cifs: SMB1 split: Move some SMB1 received PDU checking bits to
smb1transport.c
      cifs: SMB1 split: Add some #includes
      cifs: SMB1 split: Split SMB1 protocol defs into smb1pdu.h
      cifs: SMB1 split: Adjust #includes
      cifs: SMB1 split: Move BCC access functions
      cifs: SMB1 split: Don't return smb_hdr from cifs_{,small_}buf_get()
      cifs: Fix cifs_dump_mids() to call ->dump_detail
      cifs: SMB1 split: Move inline funcs
      cifs: SMB1 split: cifs_debug.c
      cifs: SMB1 split: misc.c
      cifs: SMB1 split: netmisc.c
      cifs: SMB1 split: cifsencrypt.c
      cifs: SMB1 split: sess.c
      cifs: SMB1 split: connect.c
      cifs: SMB1 split: Make BCC accessors conditional
      cifs: Label SMB2 statuses with errors
      cifs: Autogenerate SMB2 error mapping table
      cifs: Fix the copyright banner on smb1maperror.c

Gustavo A. R. Silva (1):
      smb: client: Avoid a dozen -Wflex-array-member-not-at-end warnings

Henrique Carvalho (5):
      smb: client: split cached_fid bitfields to avoid shared-byte RMW races
      smb: client: add proper locking around ses->iface_last_update
      smb: client: prevent races in ->query_interfaces()
      smb: client: introduce multichannel async work during mount
      smb: client: add multichannel async work for CONFIG_CIFS_DFS_UPCALL=n

Huiwen He (17):
      smb/client: map NT_STATUS_INVALID_INFO_CLASS to ERRbadpipe
      smb/client: add NT_STATUS_OS2_INVALID_LEVEL
      smb/client: rename ERRinvlevel to ERRunknownlevel
      smb/client: add NT_STATUS_VARIABLE_NOT_FOUND
      smb/client: add NT_STATUS_BIOS_FAILED_TO_CONNECT_INTERRUPT
      smb/client: add NT_STATUS_VOLUME_DISMOUNTED
      smb/client: add NT_STATUS_DIRECTORY_IS_A_REPARSE_POINT
      smb/client: add NT_STATUS_ENCRYPTION_FAILED
      smb/client: add NT_STATUS_DECRYPTION_FAILED
      smb/client: add NT_STATUS_RANGE_NOT_FOUND
      smb/client: add NT_STATUS_NO_RECOVERY_POLICY
      smb/client: add NT_STATUS_NO_EFS
      smb/client: add NT_STATUS_WRONG_EFS
      smb/client: add NT_STATUS_NO_USER_KEYS
      smb/client: add NT_STATUS_VOLUME_NOT_UPGRADED
      smb/client: remove some literal NT error codes from ntstatus_to_dos_map
      smb/client: remove useless comment in mapping_table_ERRSRV

Paulo Alcantara (1):
      smb: client: fix potential UAF and double free in smb2_open_file()

Shyam Prasad N (6):
      cifs: on replayable errors back-off before replay, not after
      netfs: when subreq is marked for retry, do not check if it faced an error
      netfs: avoid double increment of retry_count in subreq
      cifs: make retry logic in read/write path consistent with other paths
      cifs: Corrections to lock ordering notes
      cifs: Fix locking usage for tcon fields

Stefan Metzmacher (1):
      smb: common: add header guards to fs/smb/common/smb2status.h

 fs/netfs/read_collect.c           |   10 +
 fs/netfs/read_retry.c             |    4 +-
 fs/netfs/write_collect.c          |    8 +-
 fs/netfs/write_issue.c            |    1 +
 fs/netfs/write_retry.c            |    1 -
 fs/smb/Kconfig                    |   17 +
 fs/smb/client/Makefile            |   24 +-
 fs/smb/client/cached_dir.c        |   10 +-
 fs/smb/client/cached_dir.h        |   42 +-
 fs/smb/client/cifs_debug.c        |   18 +-
 fs/smb/client/cifs_debug.h        |    1 -
 fs/smb/client/cifs_spnego.h       |    4 +-
 fs/smb/client/cifs_swn.h          |   10 +-
 fs/smb/client/cifs_unicode.c      |    1 -
 fs/smb/client/cifs_unicode.h      |   17 +-
 fs/smb/client/cifsacl.c           |    1 -
 fs/smb/client/cifsencrypt.c       |  124 --
 fs/smb/client/cifsfs.c            |    6 +-
 fs/smb/client/cifsfs.h            |  114 +-
 fs/smb/client/cifsglob.h          |   51 +-
 fs/smb/client/cifspdu.h           | 2377 +----------------------
 fs/smb/client/cifsproto.h         |  780 +++-----
 fs/smb/client/cifssmb.c           |  147 +-
 fs/smb/client/cifstransport.c     |  265 ---
 fs/smb/client/compress.h          |    3 +-
 fs/smb/client/connect.c           |  329 +---
 fs/smb/client/dfs.h               |    3 +-
 fs/smb/client/dfs_cache.h         |   19 +-
 fs/smb/client/dir.c               |    1 -
 fs/smb/client/dns_resolve.h       |    4 +-
 fs/smb/client/file.c              |    1 -
 fs/smb/client/fs_context.c        |    1 -
 fs/smb/client/fs_context.h        |   16 +-
 fs/smb/client/fscache.h           |   17 +-
 fs/smb/client/gen_smb2_mapping    |   86 +
 fs/smb/client/inode.c             |    1 -
 fs/smb/client/ioctl.c             |    1 -
 fs/smb/client/link.c              |    1 -
 fs/smb/client/misc.c              |  302 +--
 fs/smb/client/netlink.h           |    4 +-
 fs/smb/client/netmisc.c           |  824 +-------
 fs/smb/client/nterr.c             |   15 +
 fs/smb/client/nterr.h             |   13 +
 fs/smb/client/ntlmssp.h           |   15 +-
 fs/smb/client/readdir.c           |    1 -
 fs/smb/client/reparse.h           |   14 +-
 fs/smb/client/sess.c              |  982 ----------
 fs/smb/client/smb1debug.c         |   25 +
 fs/smb/client/smb1encrypt.c       |  139 ++
 fs/smb/client/smb1maperror.c      |  809 ++++++++
 fs/smb/client/smb1misc.c          |  189 ++
 fs/smb/client/smb1ops.c           |  279 ++-
 fs/smb/client/smb1pdu.h           | 2354 +++++++++++++++++++++++
 fs/smb/client/smb1proto.h         |  335 ++++
 fs/smb/client/smb1session.c       |  995 ++++++++++
 fs/smb/client/smb1transport.c     |  563 ++++++
 fs/smb/client/smb2file.c          |    4 +-
 fs/smb/client/smb2inode.c         |   23 +-
 fs/smb/client/smb2maperror.c      | 2473 +-----------------------
 fs/smb/client/smb2maperror_test.c |   45 +
 fs/smb/client/smb2misc.c          |    6 +-
 fs/smb/client/smb2ops.c           |   59 +-
 fs/smb/client/smb2pdu.c           |  195 +-
 fs/smb/client/smb2proto.h         |  469 +++--
 fs/smb/client/smbencrypt.c        |    1 -
 fs/smb/client/smberr.h            |    2 +-
 fs/smb/client/trace.h             |    1 +
 fs/smb/client/transport.c         |    1 -
 fs/smb/client/xattr.c             |    1 -
 fs/smb/common/smb2pdu.h           |    3 +
 fs/smb/common/smb2status.h        | 3499 +++++++++++++++++-----------------
 71 files changed, 8650 insertions(+), 10506 deletions(-)
 delete mode 100644 fs/smb/client/cifstransport.c
 create mode 100644 fs/smb/client/gen_smb2_mapping
 create mode 100644 fs/smb/client/smb1debug.c
 create mode 100644 fs/smb/client/smb1encrypt.c
 create mode 100644 fs/smb/client/smb1maperror.c
 create mode 100644 fs/smb/client/smb1misc.c
 create mode 100644 fs/smb/client/smb1pdu.h
 create mode 100644 fs/smb/client/smb1proto.h
 create mode 100644 fs/smb/client/smb1session.c
 create mode 100644 fs/smb/client/smb1transport.c
 create mode 100644 fs/smb/client/smb2maperror_test.c


-- 
Thanks,

Steve
