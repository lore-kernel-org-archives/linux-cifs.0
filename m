Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA34A4C956C;
	Wed,  8 Jul 2026 18:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783535758; cv=none; b=UcF0nNkHGdTq9nTDQSk5Ypdgv3woHDk4gspogfXWQUk/TpV0sysGhAjl4ve/z+bq2CLGMIgoDOOS3pIVJagrAxxtMRlALvG4flmkVyz4Twdo3jdJDttfFtX1zh6fLc5T90agrS1Qi6BJ9zWY+sDhXA340viY9mVAdlRNnwzB/Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783535758; c=relaxed/simple;
	bh=ekvaDdp7fA9Bhp+aw9ZsPuLDRULCvkemm22RN2E9vhY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A/0Pulp9kM0d5HlA+n4BH39PmTuTLdFoJ+ax3I23CHCggWrrW8TzitYg1vxlc237j6TceitZVkOaIlPYoIkg93qAtSa08yOKt/ZpR1iCUXYoxIXksij/6z4eiqWfw+52j1f6+x8kpSaVlEW3TaaQSE12Lbs8hyVWTzPnr2unhmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iaEA7w31; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iaEA7w31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BB3E1F00A3A;
	Wed,  8 Jul 2026 18:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783535756;
	bh=Lc+F5vSqEmvM5EG+3ZR027lOpDoM9jf8dozLYd9r3zE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iaEA7w31Qn2eL80kVCa37/rJf6Yc1r7CWFfs5WdjjdA5dJ6ewXbGOWsgn8LREveRe
	 gJ2lCS9Ejr5/q2iBasjyA7XQRPcHcjZaLlGRgQFimn+/lEkacOoyU6nMZ94cM7+ows
	 weBXKi6NVfibzDwthtWixwTp+QbCNJsUnfY6sWScjA6ErF+P28uTSLy/oFdK7oTmiY
	 mavgmYSh+ommnQ3MerEzwbN0sg4awxhU+Wur3kQFlXdmMZXBZ2M6lHApVhTHAqAiXs
	 LQVMC5Syb6URHzeUb8ne3LSDfoHQOoh0bR8b381TLojDpbdzpT74JID5oaOdCAGryF
	 5LILXiALQKM1w==
Received: by pali.im (Postfix)
	id 3FD76BA9; Wed,  8 Jul 2026 20:35:54 +0200 (CEST)
Date: Wed, 8 Jul 2026 20:35:54 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix support for creating SFU fifo
Message-ID: <20260708183554.6wxt7qkdcwcehn2x@pali>
References: <20260707090356.26163-1-pali@kernel.org>
 <CAH2r5mtT0-o-jTdtOEsGe8wiO37kEmxjYrrts5L0m0pen+sb-A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mtT0-o-jTdtOEsGe8wiO37kEmxjYrrts5L0m0pen+sb-A@mail.gmail.com>
User-Agent: NeoMutt/20180716

I have verified WSL and it does not use "LnxFIFO". This looks like AI hallucination too.
WSL stores fifos as reparse point of IO_REPARSE_TAG_LX_FIFO type.

On Wednesday 08 July 2026 08:55:02 Steve French wrote:
> AI search says that "LnxFIFO" is used by WSL?  Have you verified this recently.
> 
> On Tue, Jul 7, 2026 at 4:13 AM Pali Rohár <pali@kernel.org> wrote:
> >
> > SFU fifos are natively supported (created and recognized) at least by:
> > - Microsoft POSIX subsystem
> > - OpenNT/Interix subsystem
> > - Microsoft SFU (Windows Services for UNIX)
> > - Microsoft SUA (Subsystem for UNIX-based Applications)
> > - Windows NFS server (up to the Windows Server 2008 R2)
> >
> > Windows NFS server since Windows Server 2012 uses new reparse point format
> > for storing new fifos, but still can recognize this old format (also in the
> > latest Windows Server 2022 version).
> >
> > SFU-style fifo is empty regular file which has system attribute set.
> >
> > These SFU-style fifos are already recognized by Linux SMB client.
> >
> > But Linux SMB client is currently creating new SFU fifos in different
> > format which is not compatible with all those SFU-style consumers. Fix this
> > by creating new fifos in correct SFU format which would be recognized by
> > all those applications and also by existing Linux SMB clients.
> >
> > This change affects only creating new fifos when mount option -o sfu is used.
> >
> > Signed-off-by: Pali Rohár <pali@kernel.org>
> > ---
> >  fs/smb/client/smb2ops.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> > index e59fda1b2230..1261b928edee 100644
> > --- a/fs/smb/client/smb2ops.c
> > +++ b/fs/smb/client/smb2ops.c
> > @@ -5293,10 +5293,8 @@ int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
> >                 type[0] = '\0';
> >                 break;
> >         case S_IFIFO:
> > -               type_len = 8;
> > -               strscpy(type, "LnxFIFO");
> > -               data = (u8 *)&pdev;
> > -               data_len = sizeof(pdev);
> > +               /* SFU fifo is system file which is empty */
> > +               type_len = 0;
> >                 break;
> >         default:
> >                 rc = -EPERM;
> > --
> > 2.20.1
> >
> >
> 
> 
> -- 
> Thanks,
> 
> Steve
