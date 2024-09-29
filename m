Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCF34D8BC;
	Sun, 29 Sep 2024 22:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727647426; cv=none; b=CpjAln0aBnPSEsWtHn4zbqjs4tLRdM75sZ2yD4oT3SrXAalAxbRLY0lShMwOlTzggYv8sHFTuA6jrR8EvgzQHHw5hecGab5R1w6Q8BrJeXWokPqXpQUP88sfd/xaLEkKp42EMihLzv7pAduV/vWn/DLNqIQ70YBpj1k+ou2+GVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727647426; c=relaxed/simple;
	bh=gnRVU+XWSdtQw+26C68u18ttuL5GoOOs4A59OpXac30=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BTTIX2okdGo5P4cgmePe5gyppGTHwAj++ddWFGkOyq5IatD5PCrkSnD742VIGEaXtvw3WP+b/SgMSBQLL+RQ2cgzMcSxD2co0AIbT2pcdT6MBPEcQH4lSoAPGWiffqiTJj7nJ2kXnZeDBAgCMfYzkUKqKGlLjRhuDdbzEh3JmaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lxO72Txb; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lxO72Txb"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5389e24a4d1so3159293e87.3;
        Sun, 29 Sep 2024 15:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727647423; x=1728252223; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oOKNP9unjnbGz/vC3RNR8i3aY4wvoDtLBu9z/FV6wn0=;
        b=lxO72TxbmS4+KRsNdPZ2rWICBypCkC2Igw0ycYetQ6KnpOtqOJdQH5WD9xeswmbBhV
         eYfONkQ3NsMcyCtFKrOcNZd7XGcDhwBYNhBqRG3HKcsdOW66YRKkNKDASwlh8Af9ZPqK
         mBXL/Kp4j8W6otT93voP6SWbFRqg9o1fAuQQ6z6i18GcAlgGib2Gm+ZF6oKyt5B1jOR0
         ldz8Ba7TXGH17oRGNCxWEtrvIfTvri82J6sgAGtpyjSjEKK9ryTXWsKKCZ9p6obUrvVp
         Zayot7UYU0B7gpxEnxlQ6FoYQh8jZadlvyFYWzMLNuGM0kR5185M/Or+x9+v9RLhch8w
         oSDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727647423; x=1728252223;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oOKNP9unjnbGz/vC3RNR8i3aY4wvoDtLBu9z/FV6wn0=;
        b=ZuSmbafU4I04cjCYc65rOg0z2KzILcxZNVn9X7d3+hxmYGsGfnLpJ6T2ffItnbpsH/
         AgNel5vg2ZfH+S2AVq/hBNS7D0PtCoOzPqWIJqggMZ8sBcf7FsCqV3y84TpzGrATlTeZ
         ikkCHEvchSTTPsHkF4rXsopttxZI86iWzxwjv3cGkVv9cK+olPZw5PbC5vi7w1wEaJt1
         ryRylHNzeD8D66UDNNBOuWvIebododET4iU2vBC2ROrIJZ1aWTQKqimSXPBdxG9cNjA8
         9A+ve8BCG5gpY9QgWYWWqZDyI2jG5yXYYcuTgnwrmarF3cNix/a7P6oJ3Ep+wjx6SVSE
         CMeA==
X-Forwarded-Encrypted: i=1; AJvYcCV6wzPb3+0Ck1KDtENdiwtqMe3tHxeqfY6y9iwp/HAnnyyPz3zh4ZGN3f5u5Bg3C9N//pZK2/LGMpah@vger.kernel.org, AJvYcCVFiJtWxVDiXS7x23ql/QQVNpb/04y2Nxmn8yLZyreZPyt05SrgFq+JVCkQ7RACjeHODkfj1q1HwVtoPno6@vger.kernel.org
X-Gm-Message-State: AOJu0YwLvnO8V5IJ12B5kEgAwLmjPiSnCh4pGAe8nzjxB9NX9F5aklup
	nDd5U4iVkGS6mWLmpVUcLo7DfqIGNjRO8ftxuebfk8VC8ehqRh4Y3MNOfNekgV/tfDdMfuCih3G
	3Cfdbd2UpbcDy8G4ufo5u5bho5+o=
X-Google-Smtp-Source: AGHT+IFNc5tJneem8/sh8b5+49MrMDK0yObr0P9ZF4YM2s81/IAdqytBHBeK5wjTet5KJ5F6c8P9hmT7Z8WZ5BwYUHM=
X-Received: by 2002:a05:6512:3994:b0:535:681d:34a4 with SMTP id
 2adb3069b0e04-5389fc348d8mr4266404e87.7.1727647422515; Sun, 29 Sep 2024
 15:03:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240929185053.10554-1-pali@kernel.org>
In-Reply-To: <20240929185053.10554-1-pali@kernel.org>
From: Steve French <smfrench@gmail.com>
Date: Sun, 29 Sep 2024 17:03:31 -0500
Message-ID: <CAH2r5muq4S+w-W-J+YMuJ9RzPJsbmf6zKuGPN0H8DohXe--1uA@mail.gmail.com>
Subject: Re: [PATCH 0/7] cifs: Improve support for native SMB symlinks
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Merged patches 2, 3, 4 and 6 from this series into cifs-2.6.git for-next

For patch 1, seems like rename could get in the way of backports, and
is only a minor improvement (could consider it in the future for
6.13-rc if part of other cleanup/improvements, but lower priority)

For patch 5 it could be ok - but wanted more opinions on that ...
since wouldn't want it to break POSIX - e.g. what would happen with
this patch if a Linux server changed the target of a symlink from a
file to directory (or the other way around) - is there any risk of
breaking POSIX symlink semantics in a pure Linux->Linux case with this
patch?

For patch 7, it is relatively larger fix (and less important for pure
Linux workloads) so wanted some additional opinions/feedback on this
from others

On Sun, Sep 29, 2024 at 1:51=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> This patch series improves interoperability of native SMB symlinks
> (stored in IO_REPARSE_TAG_SYMLINK reparse point) between Linux SMB
> client and Windows SMB server storage (NTFS).
>
> Fixed test cases by this patch series are:
>
> Fixes parsing of symlinks relative to the top of the export which can be
> created on Windows by:
>
>   mklink symlink \relative\path\from\export
>
>
> Fixes parsing of symlinks in absolute form which can be created on
> Windows by:
>
>   mklink symlink C:\absolute\path
>
>
> Fixes creating of symlinks pointing to directory. So Linux commands:
>
>   mkdir dir
>   ln -s dir symlink1
>   ln -s another_dir/ symlink2
>
> creates a symlink which would be now understood also by Windows as
> symlinks to directories.
>
>
> Fixes creating of symlinks pointing to current or parent directory.
> So following commands create valid symlink understood by Windows:
>
>   ln -s . symlink_cur
>   ln -s .. symlink_parent
>
>
> Fixes creating of absolute symlinks. Absolute symlinks on Windows are
> quite complicated due to nature of DOS/Win32 path form used by Windows
> applications and NT path form in which are symlink paths stored. Also
> complication is that NT object paths have different hierarchy than POSIX
> paths generally. Required information about NT object hierarchy used in
> native absolute symlinks are in comments in the last patch from this
> series.
>
> To resolve mentioned problems I chosse way which is used by WSL, its
> -t drvfs has mount option -o symlinkroot=3D which specify Linux path ther=
e
> should point absolute windows drive letter symlinks. This could make
> -t cifs mounts in WSL2 more compatible with symlinks coming from local
> NTFS disks mounted by -t drvfs.
>
> I'm not sure how good are these changes, but I think that they improve
> compatibility of symlinks between Linux and Windows systems. Maybe there
> is some better solution how to handle some of those issues?
>
>
> Pali Roh=C3=A1r (7):
>   cifs: Rename smb2_get_reparse_inode to smb2_create_reparse_inode
>   cifs: Improve creating native symlinks pointing to directory
>   cifs: Fix creating native symlinks pointing to current or parent
>     directory
>   cifs: Fix parsing native symlinks relative to the export
>   cifs: Fix parsing native symlinks directory/file type
>   cifs: Validate content of native symlink
>   cifs: Fix creating and resolving absolute NT-style symlinks
>
>  fs/smb/client/cifs_unicode.c |  17 +-
>  fs/smb/client/cifsglob.h     |   1 +
>  fs/smb/client/cifsproto.h    |   1 +
>  fs/smb/client/fs_context.c   |  22 ++
>  fs/smb/client/fs_context.h   |   2 +
>  fs/smb/client/inode.c        |   1 +
>  fs/smb/client/reparse.c      | 513 ++++++++++++++++++++++++++++++++---
>  fs/smb/client/reparse.h      |   4 +-
>  fs/smb/client/smb1ops.c      |   3 +-
>  fs/smb/client/smb2file.c     |  67 ++++-
>  fs/smb/client/smb2inode.c    |  15 +-
>  fs/smb/client/smb2proto.h    |  13 +-
>  12 files changed, 602 insertions(+), 57 deletions(-)
>
> --
> 2.20.1
>
>


--=20
Thanks,

Steve
