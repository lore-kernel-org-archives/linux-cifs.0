Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793234999;
	b=KKeeYRcv9jlw6y6koM3O9LecnkmggeSHu+zti3hDE9j7BGw7VNko+vHPX+i5YNe57d44
	 m66g3nDB4Ba0T9eDjp6r8OOqMwgTIdiVEGzTKaT50QDiy2dSkDbpKx60Slo8UB9L7kr5/
	 krTduu/BV6zNsFZxw+ni/9bda2QwDKAAZ1CwREtGxLAzLPpfa7UUJgK+UpyA4ejbF4YGl
	 1/3sP7G+L7owIz8N5zsMxsgYjgvOeC2zEyXQAq4jMSgy6C5GNQUn/S+GrtECJxLi0qzjq
	 PR/qIhUaXc2pSEvPeh1gKbXW+M8MCY4J4K9Hus3ksMnpJcLVsDDfyHOCAHbPpL2Afvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793234999;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=zMb7KePVlG1NjbN5pBAGqS5NP3hS34WZE0E1IMzOgXU=;
	b=xUOn1ZhFEQuok0elRZzCPk79Bc927oYzEsoU8TRLd8gvvzDtAOeSdD0G/EYqrtF+1IfZ
	 hwXrwlbXHd91MPxSil+X1FWtxdSrERemDKLR5vo5JTxjoBoPgaaS4ffyDscA/iZ5FrusO
	 CPUIt+hXSkW5WheCvyi1CSrE2+1l+gb9htbNc1uUw/MlNF5biysDJ3/uI/t+yDZqH87x0
	 hpyxI34Z8Q/MYNQ4WjRgH3Y9Dc3TLlBqyBw/bFWYckbPzgvA+Pwmie7jKvk+43cfkR5Tc
	 WdTa04NmzFqDhc+vBfgwcF7BCjzXoxke1oBAivJppP37fTzyMmE1p80j4FCeeAH3PHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ipbTufuG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FAA8606A31A
	for <linux-cifs@vger.kernel.org>; Thu, 29 Oct 2026 00:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ipbTufuG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51E51F01828
	for <linux-cifs@vger.kernel.org>; Thu, 29 Oct 2026 00:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793234998;
	bh=zMb7KePVlG1NjbN5pBAGqS5NP3hS34WZE0E1IMzOgXU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ipbTufuG+j9FU8i4M5D1b6ojxf41xOTajFZKD62wKaKIhtUZeGeN9h1itTFD3GSDd
	 DRbwrBgM9fdpAA39bWh4qOJ7sQXQScf2OOjHczelfM0fMo4Lfhxd4tzttfHEIxfe6B
	 poYJ+KWwJdOXGiqJij14ei4gOFiidpNxBccKxFLAfDd/A+SRz7yy8XBBs06MSHVL65
	 gop32jjTE75mZIOkaICfBF4xUQ0PyEDya9/2f7JSR3IaSQpxYJcrmku4MKSi3Eo6vl
	 C+LtJYpR9Qplhq9GCCHTl1ey1Z+UJp9NTUHMywLEZw2z2oL0Gvt7NP9feaFfi49p1/
	 JwvD5KRRIov2Q==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c411e139259so144858566b.2
        for <linux-cifs@vger.kernel.org>; Wed, 28 Oct 2026 17:49:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByyzOqlIGzwJ7UnnJNTqqtGiSELP6Oab8VMw4dI8cfiIgJbgQDd2rrvrlc8TVtMqRyTnF4mtowxhpuX@vger.kernel.org
X-Gm-Message-State: AFq9FYLxbJKboYeQofnTi/pPxghs6kz2hWFPKEDDDVt7U5/tTqTRU5NK
	hiRfoowMQxJosVovzb7oYfoDe5Mya6WWTm04bVuHCcQiKpmxXYbLDdZ2Jjg1rGawoQ72GL/28L9
	qYFo+mJoSu1s1wHFozTVe2zam8R5yN68=
X-Received: by 2002:a17:907:3cc9:b0:c46:9876:e9b1 with SMTP id
 a640c23a62f3a-c49be039e8dmr335804166b.43.1793234997622; Wed, 28 Oct 2026
 17:49:57 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261026222600.17323-1-pali@kernel.org>
In-Reply-To: <20261026222600.17323-1-pali@kernel.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 29 Oct 2026 09:49:45 +0900
X-Gmail-Original-Message-ID: <CAKYAXd84MA0R+3Xd-SPq4jWqcQR7+Wu5voHAJWKOmVzdhwkRYw@mail.gmail.com>
X-Gm-Features: AclHuK9fso8DR_4lTSfxfO6FLki4UweW19Ce4XOKWt1DRcLoIEIgc48dhENJEs0
Message-ID: <CAKYAXd84MA0R+3Xd-SPq4jWqcQR7+Wu5voHAJWKOmVzdhwkRYw@mail.gmail.com>
Subject: Re: [PATCH v7.3 0/9] Various changes
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 27, 2026 at 7:26=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> Rebased changes on top of the v7.3.
> No functional change, just fixed 3 oneliners from Sashiko.
> Link to previous: https://lore.kernel.org/linux-cifs/20260825230622.24617=
-1-pali@kernel.org/
>
> Pali Roh=C3=A1r (9):
>   cifs: Remove code for querying FILE_INFO_STANDARD via
>     CIFSSMBQPathInfo()
>   cifs: Remove cifs_backup_query_path_info() and replace it by
>     cifs_query_path_info()
>   cifs: Fix validation of EAs for WSL reparse points
>   cifs: Validate presence of EA $LXMOD for WSL reparse points
>   cifs: Check if server supports EAs before trying to set it for WSL
>   cifs: Extend ->set_EA() callback to allow operate on reparse point
>   cifs: Create native Window socket file compatible also with WSL
>     subsystem
For patches 1=E2=80=937:

Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>

Paulo, Let me know your thoughts.

Thanks.

>   cifs: Add support for parsing WSL symlinks in version 1 format
>   cifs: Add support for creating WSL symlinks in version 1 format
>
>  fs/smb/client/cifsglob.h   |  10 +-
>  fs/smb/client/cifsproto.h  |   1 +
>  fs/smb/client/cifssmb.c    |  43 ++++---
>  fs/smb/client/fs_context.c |  11 +-
>  fs/smb/client/fs_context.h |   3 +-
>  fs/smb/client/inode.c      |  98 +-------------
>  fs/smb/client/link.c       |   3 +-
>  fs/smb/client/reparse.c    | 257 ++++++++++++++++++++++++++++++++-----
>  fs/smb/client/smb1ops.c    |  11 +-
>  fs/smb/client/smb1proto.h  |   4 +-
>  fs/smb/client/smb2ops.c    |   6 +-
>  fs/smb/client/xattr.c      |   3 +-
>  fs/smb/common/fscc.h       |   5 +-
>  13 files changed, 287 insertions(+), 168 deletions(-)
>
> --
> 2.20.1
>
