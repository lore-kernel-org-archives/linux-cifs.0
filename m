Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCDCE357CFE
	for <linux-cifs@vger.kernel.org>; Sat, 22 Aug 2026 13:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787405320; cv=none; b=fwL2di2QjbOCizMTQa30rGZYFfr1G1M1cmR/I57JWL+spvvxCKmndNIkHumuvk0uall2sxRWNxU8eCrZYpLVqIgEhJPE/699UtRrW9WiYwr0jDhBjCJ3btofoEANdPfnhqgkRCgv4iuSCUXORLraMd+KykC0th7IMpRxIiE2djk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787405320; c=relaxed/simple;
	bh=FbXKzVQ0fdUEXy5ulHLyUotv1ZWsAYbMMTGHiFkUexg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n3SUsVoz6wK3vKkepBKGHgpfGsXllA4RHaMk6I9p9cqOvTahjrRVlBIwGdIQFLbLXcKVaVoh71MI1ac35hWaSdP0YAZRH/s6w6wn8HOjrmZkzeQOYhgnNhGhrltsHduyaZTqu162QVPiohXaMOa0lF1iM4wxgoBhJvKaefjE5Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UTEJ/H06; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UTEJ/H06"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC18A1F000E9
	for <linux-cifs@vger.kernel.org>; Sat, 22 Aug 2026 13:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787405319;
	bh=ic7fPEGQyaEZuHWm7tfIoGAoAGJEgrxUfMq9u5+HAbM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=UTEJ/H06++YAVgX1RxdLHWGwt5+WGuvBmwC1l07HpcLytXlcTrTTXr3InO/h6yNvF
	 EjJgVNGVGikBjM97tW2eFQ5ewxIvuTZNkit3EZwmEkcd0qJ/liLstaDxtV6jhvZr6s
	 XwdLa2iupJBzfV26FwF+j06tBwB1Z0c8uLmFr6AzTMrhPdGCEF31c/PBXEzg6ZaBHb
	 WgLCcYiRjOrasMg4cgL+A1AC/hMesqB2uQnVd+tCZqfSHc1mTy5JiMvpjyJUZO/LhG
	 MRaamHdHjFuSh3k/V2jGICX4XYUJ1Pw5ROWJXZ028cOyIhYRrcTKDJouLAy5OxK0CY
	 obhWj6O6aCbYA==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6a3fda88184so3207056a12.3
        for <linux-cifs@vger.kernel.org>; Sat, 22 Aug 2026 06:28:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrUqFH+7libDC44w/hItIUmcdJ3+FYxWvMSdaHVQOCaRH5YhPD1Ub0HIk5gJMV9MBMRbQIR187QUr+e@vger.kernel.org
X-Gm-Message-State: AFuF++k++vFd5dXN2fyV3ZygHkrPmOWdBlJQ5fvnt1wc2rNfEszeBXzo
	cKL1rAiBc/LTTmuxOCT+cf7NOJMJIJdXQPzCA1i60R1SvstgKozIkbSc3WOe/m423nMbsZlx6QF
	2LJqEO1K3qjbX9UOJAkK4Tf1F3iWBl7Q=
X-Received: by 2002:a17:907:c243:b0:c16:2e4f:a372 with SMTP id
 a640c23a62f3a-c246a5f45b5mr1699207866b.13.1787405318313; Sat, 22 Aug 2026
 06:28:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260706184819.22124-1-pali@kernel.org> <20260821214722.q7rkflclyyugdxll@pali>
In-Reply-To: <20260821214722.q7rkflclyyugdxll@pali>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 22 Aug 2026 22:28:26 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-pq4SXp4252h8tM7WO0ARRzMgpHs==N=30snzfO-JzCw@mail.gmail.com>
X-Gm-Features: AcwNN1WJXbAddcTtk0M_3JRNLqoMlnwgtePYY8MFRt1ekracBAiloUdWAZYKiVA
Message-ID: <CAKYAXd-pq4SXp4252h8tM7WO0ARRzMgpHs==N=30snzfO-JzCw@mail.gmail.com>
Subject: Re: [PATCH RESEND 00/11] cifs: Various changes
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 22, 2026 at 6:47=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> Hello, could you look at other of changes in these series?
> Steve already merged few of them and others I have rebased (cleanly) on
> top of v7.2 release and pushed to my cifs branch:
> https://git.kernel.org/pub/scm/linux/kernel/git/pali/linux.git/log/?h=3Dc=
ifs
Okay, I will check them. BTW, Do you know why Steve only picked a few patch=
es?

>
> On Monday 06 July 2026 20:48:08 Pali Roh=C3=A1r wrote:
> > This patch series contains various cifs changes which I sent year ago.
> > All those patches are rebased on top of the 7.2-rc2 and there is no new
> > change in them, just they are rebased for new code base.
> >
> > I pushed these changes also into my git branch cifs:
> > https://git.kernel.org/pub/scm/linux/kernel/git/pali/linux.git/log/?h=
=3Dcifs
> >
> >
> > Note that patch "cifs: Remove cifs_backup_query_path_info() and replace
> > it by cifs_query_path_info()" is removing these lines:
> >
> > -                     move_cifs_info_to_smb2(&data->fi, fi);
> > -                     fdi =3D (FILE_DIRECTORY_INFO *)fi;
> > -                     si =3D (FILE_ID_FULL_DIR_INFO *)fi;
> >
> > And I have feeling that in this old code (which is being) removed could
> > be a buffer overflow as it is casting between incompatible structures.
> > I have not spent too much time with it as the code is begin removed.
> > But maybe some AI tool could be able to confirm if this is some buffer
> > overflow or not.
> >
> >
> > Pali Roh=C3=A1r (11):
> >   cifs: Fix and improve cifs_is_path_accessible() function
> >   cifs: Remove code for querying FILE_INFO_STANDARD via
> >     CIFSSMBQPathInfo()
> >   cifs: Remove CIFSSMBSetPathInfoFB() fallback function
> >   cifs: Remove cifs_backup_query_path_info() and replace it by
> >     cifs_query_path_info()
> >   cifs: Fix validation of EAs for WSL reparse points
> >   cifs: Validate presence of EA $LXMOD for WSL reparse points
> >   cifs: Check if server supports EAs before trying to set it for WSL
> >   cifs: Extend ->set_EA() callback to allow operate on reparse point
> >   cifs: Create native Window socket file compatible also with WSL
> >     subsystem
> >   cifs: Add support for parsing WSL symlinks in version 1 format
> >   cifs: Add support for creating WSL symlinks in version 1 format
> >
> >  fs/smb/client/cifsglob.h   |  10 +-
> >  fs/smb/client/cifsproto.h  |   1 +
> >  fs/smb/client/cifssmb.c    |  79 +++--------
> >  fs/smb/client/fs_context.c |  11 +-
> >  fs/smb/client/fs_context.h |   3 +-
> >  fs/smb/client/inode.c      |  98 +-------------
> >  fs/smb/client/link.c       |   3 +-
> >  fs/smb/client/reparse.c    | 267 ++++++++++++++++++++++++++++++++-----
> >  fs/smb/client/smb1ops.c    |  35 +++--
> >  fs/smb/client/smb1proto.h  |   4 +-
> >  fs/smb/client/smb2ops.c    |   6 +-
> >  fs/smb/client/xattr.c      |   3 +-
> >  fs/smb/common/fscc.h       |   5 +-
> >  13 files changed, 306 insertions(+), 219 deletions(-)
> >
> > --
> > 2.20.1
> >
