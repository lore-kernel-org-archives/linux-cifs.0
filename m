Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E0D2F5E;
	Sat,  1 Feb 2025 19:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738436638; cv=none; b=rOTiJ9A3bJ12Gzv8xZYX3FbOcQLSgom8t8itNdWa8p3ggAwrYPmhpN0pm9aKZl/w03iA0HwKWtZ+yzLBx2Mtr0LOAMOalvF9KgYQwzqwUnOCm+8F3iV2Bc6LexuAxy+bHGXrucKB87GP97E3BBZ82YqgGq7JiBWsDvQy6jCo2JE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738436638; c=relaxed/simple;
	bh=eHlHxJwtlm0tya4D7/zjG/27qydiIisVU7egrYHWfKk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=muVSLeFu7axCZWuahR9kVhTD/66MaClaAeG+/8OkXqi4oGJEYXPSx55KgAnU4/i+kLyBUmm80Bd09nYk5yACEMWSV6lYOqWOgUKw+Qt3FPhqI+2GUQtYidCXzsUJiU2sBB/U3egKyFU8FnP6IPMRCCL9cY0Sd03LKqbcloPqZ8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Nya1LomB; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Nya1LomB"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-54021daa6cbso3284390e87.0;
        Sat, 01 Feb 2025 11:03:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738436634; x=1739041434; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3/GVvSI89IYVsdqmAGOoy8X8v5dJ84EUxRf0NLPPEyE=;
        b=Nya1LomBgdJF5UvKrd4NR38EtLUF/vPBOl8rLfwNWV0lMzRtFrUvOxPPpRt8c8Fi2I
         F1svb3dHoCddmK7ul/AXUVFWbJv79dnBSUtlgaRnI5I0mCKkAtnhOsFEaPZHhWU1g/da
         /YJXwaLzoGSPCuus8CqOniNPx3g4/hsYAltN0k5wxyaJ8NMuOi8Z1BGWva8NITKO9R2t
         hxn7ra/u7txJ+v7sJ0DgnNcoIIxZ3vHnLcCYA4L+kG6zs8T9Eum9ZKtiUQSqhyOypZ3F
         6o3nJOS/5C7sgFA5YINEjGedUPMjk1XHlBTKpbDKXX+b+1P4uKr06Ss3pkx/dSZGMHra
         ynkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738436634; x=1739041434;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3/GVvSI89IYVsdqmAGOoy8X8v5dJ84EUxRf0NLPPEyE=;
        b=JpUJHDb+yyIU7gW0Da1TbuG51mjKXnbI7sZHYtmVJQKdhOVGHDsiLY0Ab8h7qJPX6j
         Okt8SUQNjDhRqqFf8IqWfrGKfqrYnrd2QyRRDYvFjsDGQKT8tDASW7UzUvw7kALdtRq0
         SfNeXaVn4IUzzh9QukPny++g0okKO9Fpn3GVg4GjOaGfrOGbYrH66pwuFMs5c8ipczBS
         Q/47PJAXTzn7E/nnYeTG2zZldP+BtHIiMcoAOC4HL64PLaBiw1XHiTHkTP/JQd9MVaCF
         fZmCbeJ1gGH2VMKUUw2edRUQAaWQtk/3OwAqe/c9wOcIIqVaigTCDoJ8nRP227XWp3Iq
         Rf3g==
X-Forwarded-Encrypted: i=1; AJvYcCXfTzu/giSSOdBO3INveRAw+8DYImuZiah5GxleaQEBisLNvZdvNMTXps2362cRGoEmtI6uiE4515IH@vger.kernel.org
X-Gm-Message-State: AOJu0YxND5LuxxAWjzaCfYyEmIpzPuxuq17SPlZXvMDSTI6FXyc2ubYA
	VW3kgQcHfj0joQkKHA5HV2hwLI/Q/oN543bHcP6Yfp0MDGBgNu+nwqczwHSbZeYfTERghARYdfl
	7U7u5rV02ChiDImEkjdDynVWFxkDCaZZr
X-Gm-Gg: ASbGncsMGVudcmi+wLaOkFrlAH2wsFpDAMtXH1vFwgJqGS0vNsLIU2NC5gjAOa4sdK2
	pAcvnA/mpA+NnXyJB8oUj7VYb1vGv+b/ipfWRXdCt+Vi3yZaU+mpk1RIZjIn2FvOdGWD0aGjJCB
	OmFjoJeZtWCBFdgCNTEOh3FFDDAWkyeVE=
X-Google-Smtp-Source: AGHT+IEnq4AsbbhOBi2lsoAWc4GU1umYMP7etULjgutBN51MWjEk48ykMVan2TtaF0quxlpqir1f5gcRzu0LBkmOJNE=
X-Received: by 2002:a05:6512:b97:b0:542:6f78:2ace with SMTP id
 2adb3069b0e04-543e4c3c33bmr5225006e87.47.1738436633711; Sat, 01 Feb 2025
 11:03:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 1 Feb 2025 13:03:42 -0600
X-Gm-Features: AWEUYZn1emVQdaX4Bz2hIanIiHakotn4UbcDd1kHUz4R67V0oz2GqHWt1ju6i18
Message-ID: <CAH2r5mv0fCe9F3YnMT-4_hc4DPGgSp+nu7detzz8K1X-bwj9mA@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please pull the following changes since commit
e0b1f59142746f74476a03040f745329c8355a7e:

  Merge tag 'v6.14-rc-smb3-client-fixes-part' of
git://git.samba.org/sfrench/cifs-2.6 (2025-01-23 17:05:45 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.14-rc-smb3-client-fixes-=
part2

for you to fetch changes up to a49da4ef4b94345554923cdba1127a2d2a73d1e6:

  cifs: Fix parsing native symlinks directory/file type (2025-01-31
12:51:44 -0600)

----------------------------------------------------------------
Twenty one cifs/smb3 client fixes, most for special file type handling
- 15 fixes for special file handling, four of them for symlink
handling, three cleanups,
      two for new mount options (e.g. to allow disabling using reparse
points for them,
      and one to allow overriding way symlinks are saved), and fixes
to error paths,
      and add support for creating sockets)
- Fix for kerberos mounts (allow IAKerb)
- SMB1 fix for stat and for setting SACL (auditing)
- Fix an incorrect error code mapping
- Two cleanup
----------------------------------------------------------------
Pali Roh=C3=A1r (19):
      cifs: Change translation of STATUS_NOT_A_REPARSE_POINT to -ENODATA
      cifs: Change translation of STATUS_PRIVILEGE_NOT_HELD to -EPERM
      cifs: Validate EAs for WSL reparse points
      cifs: Remove intermediate object of failed create SFU call
      cifs: Fix getting and setting SACLs over SMB1
      cifs: Remove unicode parameter from parse_reparse_point() function
      cifs: Remove struct reparse_posix_data from struct cifs_open_info_dat=
a
      cifs: Rename struct reparse_posix_data to
reparse_nfs_data_buffer and move to common/smb2pdu.h
      cifs: Update description about ACL permissions
      cifs: Remove symlink member from cifs_open_info_data union
      cifs: Simplify reparse point check in cifs_query_path_info() function
      cifs: Fix creating and resolving absolute NT-style symlinks
      cifs: Add mount option -o symlink=3D for choosing symlink create type
      cifs: Add mount option -o reparse=3Dnone
      cifs: Add support for creating native Windows sockets
      cifs: Add support for creating NFS-style symlinks
      cifs: Fix struct FILE_ALL_INFO
      cifs: Add support for creating WSL-style symlinks
      cifs: Fix parsing native symlinks directory/file type

Steve French (2):
      smb3: add support for IAKerb
      cifs: update internal version number

 fs/smb/client/asn1.c         |   2 +
 fs/smb/client/cifs_spnego.c  |   4 +-
 fs/smb/client/cifsacl.c      |  25 ++-
 fs/smb/client/cifsfs.c       |   6 +
 fs/smb/client/cifsfs.h       |   4 +-
 fs/smb/client/cifsglob.h     |  62 +++++--
 fs/smb/client/cifspdu.h      | 102 ++++++-----
 fs/smb/client/cifsproto.h    |   4 +-
 fs/smb/client/cifssmb.c      |   4 +-
 fs/smb/client/connect.c      |   4 +
 fs/smb/client/fs_context.c   | 104 +++++++++++
 fs/smb/client/fs_context.h   |  21 +++
 fs/smb/client/inode.c        |   7 +-
 fs/smb/client/link.c         |  60 ++++--
 fs/smb/client/netmisc.c      |  10 +-
 fs/smb/client/nterr.c        |   1 +
 fs/smb/client/nterr.h        |   1 +
 fs/smb/client/reparse.c      | 517
+++++++++++++++++++++++++++++++++++++++++++++-------
 fs/smb/client/reparse.h      |   2 +
 fs/smb/client/sess.c         |   3 +-
 fs/smb/client/smb1ops.c      |  30 +--
 fs/smb/client/smb2file.c     |  52 +++++-
 fs/smb/client/smb2inode.c    |   5 +
 fs/smb/client/smb2maperror.c |   4 +-
 fs/smb/client/smb2ops.c      |  23 ++-
 fs/smb/client/smb2pdu.c      |   2 +-
 fs/smb/client/smb2proto.h    |   3 +-
 fs/smb/common/smb2pdu.h      |  14 +-
 28 files changed, 884 insertions(+), 192 deletions(-)



--=20
Thanks,

Steve
