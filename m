Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6F2146D65;
	Mon, 14 Oct 2024 09:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728898339; cv=none; b=mg/x2TZBM0LR6d+q1Shz/UAk4bo9cdBEPGFcjBrB3FwLcvkKGRzaHxNLgxhsEDSeYGyJDEqUjBjP0+sENWE8ywjtxYjIT2Xz14FtKSTzYgHHDqTUDIVB+GSrAMG2UaW31idEoDhp4QmO1+eGexXa2iDNx59v1dO3dPGZso6Zqkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728898339; c=relaxed/simple;
	bh=QXdb3dmbBO1WUFzxA15O4RBDNdglYPNtG79nukr33RU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dOvzhX/hsaz/YzKy2XF0IQqAwQeRHVuyhCFfbTsUvgOIRUHfGYxEEp0KxdEJ0M43M80zZoryfAk+E2zd8crkaNkC6+nTqf11UCLHrAZ6hykjOTOGSj8/srOxdiHibnDdKgRoHhxKrg0YySk3g0/EFDidFDDMDRCMp4InSoLarD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aGkzEZ+4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aGkzEZ+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98590C4CEC3;
	Mon, 14 Oct 2024 09:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728898338;
	bh=QXdb3dmbBO1WUFzxA15O4RBDNdglYPNtG79nukr33RU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aGkzEZ+4xIlDkUKCbi1UFiyfxfqw+IUf5sVqj2uo1Ng0T03ngS/RSF1mW7bGrRpMn
	 9HZqvMn25gyP8En/Orq4IPo4Q4NpMeBmdob93LoNEH6aWnCjousUxiqbup9icj5MI5
	 scp5PD9Zj3jChTXrceDYml1ddWVUN8NJXMd5LyT/npc7l37RAz9HgozcJRjbRdqlUS
	 SFRYuU0OBopUj8wHDQms+EHOKeVabsvGrX2V69ar14jOzBWnrpQt3tqwUNdFZVBxpI
	 3OX/RCaAUFRjMU2Ckbyr034Fwu7b/ubBtwBOeqhWiOWAiyGs3nUon01uk5GvcgcYRu
	 ell7FqmGAh0Nw==
Received: by pali.im (Postfix)
	id AF3809DA; Mon, 14 Oct 2024 11:32:12 +0200 (CEST)
Date: Mon, 14 Oct 2024 11:32:12 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] Allow to choose symlink and socket type
Message-ID: <20241014093212.rrijt2x43jubaclz@pali>
References: <20241006100046.30772-1-pali@kernel.org>
 <20241012085252.560-1-pali@kernel.org>
 <CAH2r5mtGqqM35Cy5k9NN=X05rTZPk-adhb7LgoV8PGNVL9P6FQ@mail.gmail.com>
 <20241013133827.lodho6ep2uspbzpk@pali>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241013133827.lodho6ep2uspbzpk@pali>
User-Agent: NeoMutt/20180716

Now I found this statement in FSCTL_SET_REPARSE_POINT documentation:
https://learn.microsoft.com/en-us/windows/win32/api/winioctl/ni-winioctl-fsctl_set_reparse_point

  "FSCTL_SET_REPARSE_POINT IOCTL - Sets a reparse point on a file or directory."
  "The calling process must have the SE_CREATE_SYMBOLIC_LINK_NAME privilege."

On Sunday 13 October 2024 15:38:27 Pali Rohár wrote:
> Anyway, I think that the create symlink privilege is needed to create
> any reparse point, so fallback to NFS reparse point would not help.
> 
> On Saturday 12 October 2024 23:18:13 Steve French wrote:
> > after doing more experiments with native windows symlinks (and how
> > difficult it is to get permission to set them over the wire to Windows),
> > was wondering if we should allow fall back strategy if creating windows
> > style symlinks fails with STATUS_PRIVILEGE_NOT_HELD then we should try NFS
> > reparse point symlink.  Any opinions?
> > 
> > On Sat, Oct 12, 2024 at 3:53 AM Pali Rohár <pali@kernel.org> wrote:
> > 
> > > This patch series improves choosing reparse format when creating new
> > > special files.
> > >
> > > Changes since v1:
> > > * Instead of new -o reparse= mount option is now a new -o symlink= mount
> > >   option for choosing symlink type during creation, and new option
> > >   -o nonativesocket for choosing socket type
> > >
> > > Pali Rohár (7):
> > >   cifs: Add mount option -o symlink= for choosing symlink create type
> > >   cifs: Add mount option -o reparse=none
> > >   cifs: Add support for creating native Windows sockets
> > >   cifs: Add support for creating NFS-style symlinks
> > >   cifs: Improve guard for excluding $LXDEV xattr
> > >   cifs: Add support for creating WSL-style symlinks
> > >   cifs: Validate content of WSL reparse point buffers
> > >
> > >  fs/smb/client/cifsfs.c     |   4 +
> > >  fs/smb/client/cifsglob.h   |  36 +++++++
> > >  fs/smb/client/connect.c    |   4 +
> > >  fs/smb/client/fs_context.c |  82 +++++++++++++++
> > >  fs/smb/client/fs_context.h |  19 ++++
> > >  fs/smb/client/link.c       |  60 ++++++++---
> > >  fs/smb/client/reparse.c    | 201 +++++++++++++++++++++++++++++++------
> > >  fs/smb/client/reparse.h    |   2 +
> > >  8 files changed, 364 insertions(+), 44 deletions(-)
> > >
> > > --
> > > 2.20.1
> > >
> > >
> > >
> > 
> > -- 
> > Thanks,
> > 
> > Steve
