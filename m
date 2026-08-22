Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B557137E5E3;
	Sat, 22 Aug 2026 13:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787405473; cv=none; b=eFF0cRiu9mnBYctJ+FhVHSSANP3bfLLZF0ABlSeTq7VSApdjaDn569+6KDllGHJFZ+wtWFiGaxNCC3ls1oRZBj17lP3G0Ak5ZoQnp+5dgfQYzafMAProQ+rgzEk7r2M/d10w507QbkniKNQ7S/23nSlix36es4Ev2Pgc+k/hZSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787405473; c=relaxed/simple;
	bh=m69bDCWYVxC3d5tOiaHjld2KHlMT2eCZxbSHS0+xBkg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sfhJ8lGkmKP5Rhw/QRKSw6rlYVH3mxBf/4fxw/IYJdOf7AGFxJNt0Jd7wvSEeyjXcATOFY/Gi5gMxe1evydT1z3UEvdB1LW+IhjT08o98yp/EN+H4ji2ihQk7gUaiM+dpkyX1EViaG3etYdMREibB8VCGj84KMN58BYV6y9DDSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kpTVa3s8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kpTVa3s8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23D01F000E9;
	Sat, 22 Aug 2026 13:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787405472;
	bh=9CgzPsIxjl0WiGBJhmToaBr6muHRxSq08jcJTjL5pCE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kpTVa3s8R8eB5cTNFHUTLLQBjNsZ49HRC8YUbKpc0WvXcaRB+AQkVLp14F3q9FDaX
	 ASXeqJsA2Hn5AFjcg6oJTwZz5iKUdNqZYsZkTv9qhv9HeYMeFXXxO/fy/rq067xPH/
	 yL+u9+GNGvy+8l1Q98bVIFYcHd78yG74yjBZ9IbDeO1tMyPbfHWIuU0N8RN5xhmpEg
	 GEAOIo7R73KAX9QvOLjndqhqliuKtyyER/7MVPPx3WtPmDcUw+6TJdp3zYdFXbnKwM
	 qfWEisS6i72FUI7i521JLaHbmmFmUyBVhTq/ol6FtPdg2iC94TVs6cHBbRjbSGs2oM
	 Dze77Xf/aNitg==
Received: by pali.im (Postfix)
	id 68D9D942; Sat, 22 Aug 2026 15:31:12 +0200 (CEST)
Date: Sat, 22 Aug 2026 15:31:12 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 00/11] cifs: Various changes
Message-ID: <20260822133112.s3qd7z7u4m7xfv5n@pali>
References: <20260706184819.22124-1-pali@kernel.org>
 <20260821214722.q7rkflclyyugdxll@pali>
 <CAKYAXd-pq4SXp4252h8tM7WO0ARRzMgpHs==N=30snzfO-JzCw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKYAXd-pq4SXp4252h8tM7WO0ARRzMgpHs==N=30snzfO-JzCw@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Saturday 22 August 2026 22:28:26 Namjae Jeon wrote:
> On Sat, Aug 22, 2026 at 6:47 AM Pali Rohár <pali@kernel.org> wrote:
> >
> > Hello, could you look at other of changes in these series?
> > Steve already merged few of them and others I have rebased (cleanly) on
> > top of v7.2 release and pushed to my cifs branch:
> > https://git.kernel.org/pub/scm/linux/kernel/git/pali/linux.git/log/?h=cifs
> Okay, I will check them. BTW, Do you know why Steve only picked a few patches?

It was late -rc cycle and I wrote to Steve that all changes could wait
for next merge window.

> >
> > On Monday 06 July 2026 20:48:08 Pali Rohár wrote:
> > > This patch series contains various cifs changes which I sent year ago.
> > > All those patches are rebased on top of the 7.2-rc2 and there is no new
> > > change in them, just they are rebased for new code base.
> > >
> > > I pushed these changes also into my git branch cifs:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/pali/linux.git/log/?h=cifs
> > >
> > >
> > > Note that patch "cifs: Remove cifs_backup_query_path_info() and replace
> > > it by cifs_query_path_info()" is removing these lines:
> > >
> > > -                     move_cifs_info_to_smb2(&data->fi, fi);
> > > -                     fdi = (FILE_DIRECTORY_INFO *)fi;
> > > -                     si = (FILE_ID_FULL_DIR_INFO *)fi;
> > >
> > > And I have feeling that in this old code (which is being) removed could
> > > be a buffer overflow as it is casting between incompatible structures.
> > > I have not spent too much time with it as the code is begin removed.
> > > But maybe some AI tool could be able to confirm if this is some buffer
> > > overflow or not.
> > >
> > >
> > > Pali Rohár (11):
> > >   cifs: Fix and improve cifs_is_path_accessible() function
> > >   cifs: Remove code for querying FILE_INFO_STANDARD via
> > >     CIFSSMBQPathInfo()
> > >   cifs: Remove CIFSSMBSetPathInfoFB() fallback function
> > >   cifs: Remove cifs_backup_query_path_info() and replace it by
> > >     cifs_query_path_info()
> > >   cifs: Fix validation of EAs for WSL reparse points
> > >   cifs: Validate presence of EA $LXMOD for WSL reparse points
> > >   cifs: Check if server supports EAs before trying to set it for WSL
> > >   cifs: Extend ->set_EA() callback to allow operate on reparse point
> > >   cifs: Create native Window socket file compatible also with WSL
> > >     subsystem
> > >   cifs: Add support for parsing WSL symlinks in version 1 format
> > >   cifs: Add support for creating WSL symlinks in version 1 format
> > >
> > >  fs/smb/client/cifsglob.h   |  10 +-
> > >  fs/smb/client/cifsproto.h  |   1 +
> > >  fs/smb/client/cifssmb.c    |  79 +++--------
> > >  fs/smb/client/fs_context.c |  11 +-
> > >  fs/smb/client/fs_context.h |   3 +-
> > >  fs/smb/client/inode.c      |  98 +-------------
> > >  fs/smb/client/link.c       |   3 +-
> > >  fs/smb/client/reparse.c    | 267 ++++++++++++++++++++++++++++++++-----
> > >  fs/smb/client/smb1ops.c    |  35 +++--
> > >  fs/smb/client/smb1proto.h  |   4 +-
> > >  fs/smb/client/smb2ops.c    |   6 +-
> > >  fs/smb/client/xattr.c      |   3 +-
> > >  fs/smb/common/fscc.h       |   5 +-
> > >  13 files changed, 306 insertions(+), 219 deletions(-)
> > >
> > > --
> > > 2.20.1
> > >
