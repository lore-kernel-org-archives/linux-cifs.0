Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9100F78F26
	for <linux-cifs@vger.kernel.org>; Sat, 27 Jun 2026 23:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782604140; cv=none; b=SkLVfcUkExRRMmUY1aaTdMLY1ZgfDX2qDnhk5X1L6ituJdjz2jAULqX7lUPxuU0+aVNQ9hlUojh06A6dxdKAWJCLVww31OlphXXH2X16lfTPQSKWcSOiMzpU/qmrYi33l4UzvtmkCTEQiVjw6pn8pJ2+jI1blL6XbTgt4USCoWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782604140; c=relaxed/simple;
	bh=waHxhph+nBgFejZHpSyIFOhE7EHivDDBSVeIvY4d60A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n2HbOgj/92r/c4oNmoFYHEVT6NMV+V9onfp6TgWvmSi1jDomN1ygO7ShzOz5W2AS6IKf5spzUxI4QOFhVrJBCl3ab+ZNO1hroW6oPCMZln0g/2fcuX6weDEoJvReDRN4C9sowc6M4ak4jVnOjfUTWtEjBXTVv3Y7VN53hjoJnvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZaBy7puC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZaBy7puC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B9A1F000E9;
	Sat, 27 Jun 2026 23:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782604139;
	bh=GJbO6ViJSeuqjqHnOMlvMGxwcLzSAHGTXI5z98GvrjA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZaBy7puCbGOazeYYLJOB8BvwLUGKB35BWJBktMtBGzMCgHM9CUIdf5LU1lKhf3D2H
	 xrPqVxHugKrFK7B8sPn2mDbsCDOoha+goP1o1Z9Mh6QwrnFRvW/6r+nWWh/TYz7Xqe
	 EzMItJ88lYppz0yPOUXpW6u+6eoJQcFdoKAU9OJpdmSBKRKCArl2TkxfTm0gzntpV6
	 4gA2zHwIm3Jjz1ogo+i6FLaXZlnttMMPzqeDlO7BjgMOMhi9wr+TasyU2z7evcjAMD
	 c7us8aUEdCcIIi8Id1abANQ7630H0OKqodU7U0i0UzJLwsYq/fzULtWlz7Ieii8d7w
	 OWWPckN35p1uQ==
Received: by pali.im (Postfix)
	id AB354AFA; Sun, 28 Jun 2026 01:48:55 +0200 (CEST)
Date: Sun, 28 Jun 2026 01:48:55 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Ralph Boehme <slow@samba.org>, Paulo Alcantara <pc@manguebit.org>,
	Max-Ulrich Farber <m.u.farber@freenet.de>,
	CIFS <linux-cifs@vger.kernel.org>, Jeremy Allison <jra@samba.org>
Subject: Re: BUG: SMB3.11 POSIX extensions: Absolute symlinks lose leading
 slash on creation
Message-ID: <20260627234855.ware6olxcglill4o@pali>
References: <4a88b87d-c38d-4248-a3c3-59dd8c1f5095@freenet.de>
 <33ca19f8-6c6e-4738-bfab-25e70f77dcf3@samba.org>
 <077744e0-ffa3-4ab6-90cc-855fc7adbba3@samba.org>
 <CAH2r5mseoZJwfwyUUB43OBq5uEuxBVApHw_B9wizrQ50ncpnOQ@mail.gmail.com>
 <20260627231638.pbjmqnfxg6wbrlls@pali>
 <CAH2r5mujZ003gkxbGp1meQAHaCbkrZRQHWK54ZfVeeRYBzi4qA@mail.gmail.com>
 <20260627232703.geoovnhheiupj6gh@pali>
 <20260627233151.mrn632z445d7irtb@pali>
 <CAH2r5munDo73ym8q4926eVDe1xuLFOgufMSHdQ1ULzpKzY=0WQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5munDo73ym8q4926eVDe1xuLFOgufMSHdQ1ULzpKzY=0WQ@mail.gmail.com>
User-Agent: NeoMutt/20180716

That is also strange as in this code reparse=wsl code I do not see any
manipulation with leading slash. There is again just cifs_strndup_to_utf16()
call: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/smb/client/reparse.c?id=780d569e6c4b422290f5cba319eb904b355d64be#n537

When I was adding support for wsl symlinks, I explicitly did tests that
absolute symlinks are correctly created (with leading slash) and that
WSL on Windows was able to correctly recognize those symlinks.
So if it does not work with recent Linux version, then this is
definitely a regression.

On Saturday 27 June 2026 18:43:32 Steve French wrote:
> It also fails with repairs=wsl
> 
> Thanks,
> 
> Steve
> 
> On Sat, Jun 27, 2026, 6:31 PM Pali Rohár <pali@kernel.org> wrote:
> 
> > According to the reparse.c history, the code itself was not changed.
> > Code for creating of reparse=nfs type symlink is here:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/smb/client/reparse.c?id=780d569e6c4b422290f5cba319eb904b355d64be#n470
> > So maybe the cifs_strndup_to_utf16() function was changed and started
> > stripping that leading slash? Just trying to guess something because is
> > sounds strange that it is broken and reparse.c file do not have any
> > change.
> >
> > On Sunday 28 June 2026 01:27:03 Pali Rohár wrote:
> > > Thank for info. For reparse=nfs this is for sure a bug, and IMHO this
> > > has to be a regression. Because when I was sending my patches for
> > > improving symlink and reparse point support, this worked correctly.
> > >
> > > I have tested it (at that time) and absolute symlink with reparse=nfs
> > > was sent with leading / and was created on windows server with leading /.
> > > I also tested interop with MS NFS server and it understood those reparse
> > > points correctly and correctly served those symlinks over NFS protocol
> > > as absolute with leading /.
> > >
> > > On Saturday 27 June 2026 18:21:18 Steve French wrote:
> > > > symlink creation with "posix" (which defaults to reparse=nfs) creates
> > > > the wrong target path when it is an absolute symlink (leading slash)
> > > > e.g.
> > > >
> > > >    ln -s  /mnt/scratch/file6 symlinktofile6
> > > >
> > > > is sent as
> > > >
> > > >    mnt/scratch/file6 instead of /mnt/scratch/file6
> > > >
> > > > and stat shows:
> > > >
> > > > root@smfrench-ThinkPad-P16s-Gen-2:/mnt/scratch# stat symlinktofile6
> > > >   File: symlinktofile6 -> mnt/scratch/file6
> > > >   Size: 17        Blocks: 8          IO Block: 16384  symbolic link
> > > > Device: 0,61 Inode: 403750517   Links: 1
> > > > Access: (0777/lrwxrwxrwx)  Uid: (    0/    root)   Gid: (
> > 1001/testuser)
> > > > Access: 2026-06-27 18:06:36.415314500 -0500
> > > > Modify: 2026-06-27 18:06:36.415314500 -0500
> > > > Change: 2026-06-27 18:06:36.418477300 -0500
> > > >  Birth: -
> > > >
> > > > On Sat, Jun 27, 2026 at 6:16 PM Pali Rohár <pali@kernel.org> wrote:
> > > > >
> > > > > Can you give a full context of the issue/bug? Link would be enough.
> > > > > I just did not caught from this description what is the issue.
> > > > >
> > > > > On Saturday 27 June 2026 18:14:07 Steve French wrote:
> > > > > > Yes - I have verified that it is the client code (so copying Paulo
> > and
> > > > > > Pali who did most of this code) that has the bug.   When the
> > > > > > FSCTL_SET_REPARSE_POINT is sent by the client, the leading '/' is
> > > > > > already stripped off.  This affects both reparse=nfs (default)
> > > > > > and reparse=wsl.    I would recommend mounting instead with
> > > > > > "mfsymlinks" (which is safer for most cases as well since the
> > > > > > symlinks are not processed by the server for the "mfsymlinks"
> > case).
> > > > > >
> > > > > > Paulo and Pali,
> > > > > > Any ideas about this bug with absolute pathnames in symlinks being
> > > > > > broken with reparse points by stripping off the leading slash?
> > > > > >
> > > > > > On Fri, Jun 26, 2026 at 1:15 PM Ralph Boehme <slow@samba.org>
> > wrote:
> > > > > > >
> > > > > > > On 6/26/26 7:41 PM, Ralph Boehme wrote:
> > > > > > > > Now that we store as empty file + xattr on the server, not real
> > > > > > > > symlinks, this design decision might need to be revisited.
> > > > > > > >
> > > > > > > > I don't remember of the top of my head if this behaviour is
> > implemented
> > > > > > > > in the client or the server. Does anyone remember? I'd have to
> > check.
> > > > > > >
> > > > > > > it's the client: in cifs_convert_path_to_utf16() it strips the
> > leading
> > > > > > > slash for the symlink target when called from
> > create_native_symlink().
> > > > > > >
> > > > > > > As symlinks in SMB3 POSIX may be created any way the server
> > thinks is
> > > > > > > safe (Samba does file+xattr, it never creates real symlinks on
> > the
> > > > > > > server), so symlinks are just a client side thing and we should
> > allow
> > > > > > > creating absolute symlinks. POSIX allows it (and users use it),
> > so we
> > > > > > > should (safely) also allow it in SMB3 POSIX.
> > > > > >
> > > > > >
> > > > > >
> > > > > > --
> > > > > > Thanks,
> > > > > >
> > > > > > Steve
> > > >
> > > >
> > > >
> > > > --
> > > > Thanks,
> > > >
> > > > Steve
> >
