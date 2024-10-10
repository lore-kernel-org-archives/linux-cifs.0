Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B8F1A2645;
	Thu, 10 Oct 2024 22:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728600263; cv=none; b=Tdf6waZ9qHKiXb/sO7/1iDsr4Wdc32unN9meOIJqqvKdsYrXIYdzo5ST80DuVsrW/e2pIb+CV1qCoJEIlg3aH2E3o472blqGPx698lPcWbX4wIKdJCHwWYiA1zjv30nEY6HEmTjciUCJHG3szERKA/BRl2ZQPGPpbkfLIm1O6wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728600263; c=relaxed/simple;
	bh=OY6fJZkq+9LkJjpKoVQCACB/iFiX3/X4nwzwLjaFFrg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bD6QJa+d9/Ayt7nSCZndzoK2X8N/5G4Zrh8fjwGVSwUNQ+3AOxlL4JoQXl7c3oBEorbh4owscgHKfDjsyrEpAU6hc122bXV2vuixkpGPQeFR61egp8EIwQQS2EX0WXHrh5UW/ElFuRtfLiNzKppKq6KIbujc89OkDJ0rFWHC1WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GjekT9oA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GjekT9oA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0043AC4CEC5;
	Thu, 10 Oct 2024 22:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728600263;
	bh=OY6fJZkq+9LkJjpKoVQCACB/iFiX3/X4nwzwLjaFFrg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GjekT9oAcVMDatcs0HEPAs4+1pjI6w5UQulGkPSf2QKF+33+tlkTee6J8A6LZfpLg
	 s5/Xdp+R9glw6F05r1KLhVaM0uoH3xaQ73761ZXmXb4Qxi3tRAKm7a1AFTXB+whg0/
	 vJZzM77zbX53xSV4kDREruL3o5Bgri2RvTvN2lEocqIJQnah6o/Iz6geecaOQTPUaK
	 faB9NLGg2v6qt8gcd22BQjgaquTkgImDJ4PTUkEdR/fjQ5RqOwgVjRs+Fa5B0DSuv3
	 zFc4fDnXWqKSEhwX71Duoh8RiyZaLepKcaPLxKq/d550gXKSPmMGufqFulK+fukw4f
	 6SwIbVFe3AZFw==
Received: by pali.im (Postfix)
	id E090C81B; Fri, 11 Oct 2024 00:44:16 +0200 (CEST)
Date: Fri, 11 Oct 2024 00:44:16 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	CIFS <linux-cifs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] cifs: Add mount option -o reparse=native
Message-ID: <20241010224416.kjfdnaiymqmcq5pl@pali>
References: <20241006100046.30772-1-pali@kernel.org>
 <20241006100046.30772-2-pali@kernel.org>
 <CAH2r5muLa_0L5LL4ipQkzEHOUdtYtJVAD29AAjQOaun9dWmK0g@mail.gmail.com>
 <20241007183650.aw3skuztljpgk2bs@pali>
 <CAH2r5mttO-aDq94QrLQm10xJRGLg=PULqX9fcfoykAweVVO+uQ@mail.gmail.com>
 <CAH2r5mvV7WzB62hWt4K6oF_xyrQH1EF75zc0JdfjsjFEV4SQKQ@mail.gmail.com>
 <20241010223857.vasehbu7nilemato@pali>
 <CAH2r5msEiD05ehJs_a05sP_rX7BkVH-9LZp8Sj6EFbpZA9bfrg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5msEiD05ehJs_a05sP_rX7BkVH-9LZp8Sj6EFbpZA9bfrg@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Thursday 10 October 2024 17:42:55 Steve French wrote:
> On Thu, Oct 10, 2024, 5:39 PM Pali Rohár <pali@kernel.org> wrote:
> 
> > On Thursday 10 October 2024 17:21:59 Steve French wrote:
> > > On Thu, Oct 10, 2024 at 5:17 PM Steve French <smfrench@gmail.com> wrote:
> > > >
> > > >
> > > >
> > > > On Mon, Oct 7, 2024 at 1:36 PM Pali Rohár <pali@kernel.org> wrote:
> > > >>
> > > >> Currently choosing how new symlinks are created is quite complicated.
> > > >>
> > > >> Without these patch series, by default new symlinks are created via
> > > >> native reparse points, even when reparse=nfs or reparse=wsl is
> > > >> specified. There is no possibility to create a NFS-style or WSL-style
> > > >> symlink yet, and this patch series address this missing functionality.
> > > >> When option -o sfu is specified then all new symlinks are created in
> > > >> SFU-style, independently of -o reparse option. And when -o mfsymlinks
> > is
> > > >> specified then all new symlinks are created in mf style, independently
> > > >> of -o reparse and -o sfu options.
> > > >>
> > > >> This patch series does not change -o sfu and -o mfsymlinks overrides,
> > it
> > > >> just changes the way how -o reparse is handled.
> > > >>
> > >
> > > I lean toward something similar, and more intuitive - do not have
> > > "reparse=" control symlink creation - but instead use another mount
> > > parm (e.g. "symlink=") for that.  It would be rarely used - only if
> > > you don't want the default (windows default format too) for server
> > > symlinks or "mfsymlinks" (for client only symlinks):
> > >
> > > 1) "symlink=" if specified can be set to one of five formats (with the
> > > default being the windows format)
> > >   a) "mfsymlinks" (Mac style which is safer for many use cases since
> > > they are "client only" symlinks which the server will never use)
> > >      Setting "symlink=mfsymlinks" will have the same effect as just
> > > specifying "mfsymlinks" so won't break anything
> > >   b) "default" (or "windows") which uses the default symlink format
> > > when trying to create a new symlink
> > >   c) "nfs"
> > >   d) "wsl"
> > >   e) "sfu"
> > > 2) "reparse=" will still control how special files are created (char,
> > > block, fifo, socket) and can be set to:
> > >    a) "nfs" (default)
> > >    b) or "wsl"
> > >    c) If "sfu" set on mount will cause special files to be created
> > > with "sfu" format instead of using reparse points to create
> > > 3) reading reparse points will always be supported (unless you want to
> > > add a new parameter "reparse=none" to treat all reparse points as
> > > empty directories)
> > > 4) reading special files via the old "sfu" will only be supported if
> > > you mount with "sfu"
> > >
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> > Ok, and how to handle creating new sockets? For me it makes sense to
> > create new sockets in "native" AF_UNIX style - compatible with Windows
> > WinAPI / WinSocks. Should be there also a new parameter?
> >
> 
> Possibly, but we can decide that later. Aren't sockets typically more
> transient short lives so less likely to cause issues no matter what format
> we use??
> 
> >

Yes, they are short lives.
