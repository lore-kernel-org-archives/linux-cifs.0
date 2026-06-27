Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126E538D
	for <linux-cifs@vger.kernel.org>; Sat, 27 Jun 2026 23:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782602828; cv=none; b=mN+yu6WwmTcXJYL5jMS98WY0M8MtE8Y56iywlDX0KsUZZvB4ciu+EuXwlXWNjQ1DcpDRd/Jm7E6hNS6n1MxbwLoSSYI5v+euxJBMKTELdUMNmN4wWUxhdioho5pmAx0QLpGPokpBlQE8GtWI5cskgFIayJY3dFjAuaXGyvSbuZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782602828; c=relaxed/simple;
	bh=jwKt6IpnRtK/9NLFFd9EZqIdsPrvINEBK6fN6KPSkcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W5vIv3R8AWQiD61BKugzvoSULiz4feanUO2rNU/0cQ40omCD6arlwzK/3ppTCRVs7QU46AhZifKRVWOV+5pO2ot0O3hA5YoQkgT+uvbkOJppoGMH93XcWvJpznXc6SwQ50/AMEzF7rINZWnYYbty/Ea4d3QCd4rMTjJCTGQhkWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IRNNwoxN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IRNNwoxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F231F000E9;
	Sat, 27 Jun 2026 23:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782602826;
	bh=0iNd8dYPF8dNLcP5VMacypEaIgzky+PLwrSOQkxMzXo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IRNNwoxNwEE2VgLQOigNl2ZNfRfqbwQ6NWDlYCjH24sxotNg4oXjgzoXtk5WM9qRK
	 WSUgfbgh637MBlPkhBsOjkLdd/eRGFYMVTnTiNf6CmK8lgb64lqSAP1/t8/annfb0R
	 qP/9t8NoQ74wzq8wDW7emWS3idZ/FEOZ6y3w/N2qWX/esze1p45uszJxMDZnaymQSm
	 6YRIGfR6cQlik3w6O5CFKsy1d1ZTOqcbYOiGh6xuwXIVaUUE0TMXXEkcZhTzwvGONV
	 Q9eFZIxZy5qSUU+sF0mEQUJjxY+/Ij5E/rQ3SGuS6qLILE0plmTXguIB30nBBEpFAq
	 6aqKezCHWpEdQ==
Received: by pali.im (Postfix)
	id 6208CAFA; Sun, 28 Jun 2026 01:27:03 +0200 (CEST)
Date: Sun, 28 Jun 2026 01:27:03 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Ralph Boehme <slow@samba.org>, Paulo Alcantara <pc@manguebit.org>,
	Max-Ulrich Farber <m.u.farber@freenet.de>,
	linux-cifs@vger.kernel.org, Jeremy Allison <jra@samba.org>
Subject: Re: BUG: SMB3.11 POSIX extensions: Absolute symlinks lose leading
 slash on creation
Message-ID: <20260627232703.geoovnhheiupj6gh@pali>
References: <4a88b87d-c38d-4248-a3c3-59dd8c1f5095@freenet.de>
 <33ca19f8-6c6e-4738-bfab-25e70f77dcf3@samba.org>
 <077744e0-ffa3-4ab6-90cc-855fc7adbba3@samba.org>
 <CAH2r5mseoZJwfwyUUB43OBq5uEuxBVApHw_B9wizrQ50ncpnOQ@mail.gmail.com>
 <20260627231638.pbjmqnfxg6wbrlls@pali>
 <CAH2r5mujZ003gkxbGp1meQAHaCbkrZRQHWK54ZfVeeRYBzi4qA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mujZ003gkxbGp1meQAHaCbkrZRQHWK54ZfVeeRYBzi4qA@mail.gmail.com>
User-Agent: NeoMutt/20180716

Thank for info. For reparse=nfs this is for sure a bug, and IMHO this
has to be a regression. Because when I was sending my patches for
improving symlink and reparse point support, this worked correctly.

I have tested it (at that time) and absolute symlink with reparse=nfs
was sent with leading / and was created on windows server with leading /.
I also tested interop with MS NFS server and it understood those reparse
points correctly and correctly served those symlinks over NFS protocol
as absolute with leading /.

On Saturday 27 June 2026 18:21:18 Steve French wrote:
> symlink creation with "posix" (which defaults to reparse=nfs) creates
> the wrong target path when it is an absolute symlink (leading slash)
> e.g.
> 
>    ln -s  /mnt/scratch/file6 symlinktofile6
> 
> is sent as
> 
>    mnt/scratch/file6 instead of /mnt/scratch/file6
> 
> and stat shows:
> 
> root@smfrench-ThinkPad-P16s-Gen-2:/mnt/scratch# stat symlinktofile6
>   File: symlinktofile6 -> mnt/scratch/file6
>   Size: 17        Blocks: 8          IO Block: 16384  symbolic link
> Device: 0,61 Inode: 403750517   Links: 1
> Access: (0777/lrwxrwxrwx)  Uid: (    0/    root)   Gid: ( 1001/testuser)
> Access: 2026-06-27 18:06:36.415314500 -0500
> Modify: 2026-06-27 18:06:36.415314500 -0500
> Change: 2026-06-27 18:06:36.418477300 -0500
>  Birth: -
> 
> On Sat, Jun 27, 2026 at 6:16 PM Pali Rohár <pali@kernel.org> wrote:
> >
> > Can you give a full context of the issue/bug? Link would be enough.
> > I just did not caught from this description what is the issue.
> >
> > On Saturday 27 June 2026 18:14:07 Steve French wrote:
> > > Yes - I have verified that it is the client code (so copying Paulo and
> > > Pali who did most of this code) that has the bug.   When the
> > > FSCTL_SET_REPARSE_POINT is sent by the client, the leading '/' is
> > > already stripped off.  This affects both reparse=nfs (default)
> > > and reparse=wsl.    I would recommend mounting instead with
> > > "mfsymlinks" (which is safer for most cases as well since the
> > > symlinks are not processed by the server for the "mfsymlinks" case).
> > >
> > > Paulo and Pali,
> > > Any ideas about this bug with absolute pathnames in symlinks being
> > > broken with reparse points by stripping off the leading slash?
> > >
> > > On Fri, Jun 26, 2026 at 1:15 PM Ralph Boehme <slow@samba.org> wrote:
> > > >
> > > > On 6/26/26 7:41 PM, Ralph Boehme wrote:
> > > > > Now that we store as empty file + xattr on the server, not real
> > > > > symlinks, this design decision might need to be revisited.
> > > > >
> > > > > I don't remember of the top of my head if this behaviour is implemented
> > > > > in the client or the server. Does anyone remember? I'd have to check.
> > > >
> > > > it's the client: in cifs_convert_path_to_utf16() it strips the leading
> > > > slash for the symlink target when called from create_native_symlink().
> > > >
> > > > As symlinks in SMB3 POSIX may be created any way the server thinks is
> > > > safe (Samba does file+xattr, it never creates real symlinks on the
> > > > server), so symlinks are just a client side thing and we should allow
> > > > creating absolute symlinks. POSIX allows it (and users use it), so we
> > > > should (safely) also allow it in SMB3 POSIX.
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> 
> 
> 
> -- 
> Thanks,
> 
> Steve
