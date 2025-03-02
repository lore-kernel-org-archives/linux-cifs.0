Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FC45258;
	Sun,  2 Mar 2025 12:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740918300; cv=none; b=tmlXGUUOgw2FFA7YOzIZe+vWS849htyxMVxm9X7dlo1cRnI9IH/6ouYySmOx4O1bL89crI5D5A7mUUuIt/U4+bWMGYAPnaEpvPwzQa2iss4yVkT4ESHRWdWxGFd8mEfI/+IO3Zr/cBp62uZ3z9Mlpf/6Z4oJgXZM2X6ZE5LULN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740918300; c=relaxed/simple;
	bh=GEa3fmIdqUVuzfQanlaEG+LJph7mxlci3BXP0ERpIJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hcQWZWS+RUo7/qbtf0NObqfxhqO5kpFvzzMRcUdkvSY4n8Un3QjZT1C9ICZ8DG0dVFbDtVTYe0A/bQVfwxsmMMvWUpQstHoTd4A+ej63ABT6LnE/5h8vHfB5cgixOXxE9U9DBXpHsP4tbl7KZMUo076eqj4T6MVkVuIHujWu4Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SIgbTX2n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SIgbTX2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2312AC4CED6;
	Sun,  2 Mar 2025 12:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740918300;
	bh=GEa3fmIdqUVuzfQanlaEG+LJph7mxlci3BXP0ERpIJE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SIgbTX2n/h8eMfmwirzeUbariF6JWOmF5h924QuvyUgH46g1AEEZH8PY75RQWOJtL
	 4UnZQKTwhlcgrpSVPs5UCScEHRAU+8fJrxyBR2/p4UfQp76+Jhe/1wUvT2dU/H+dlG
	 RNasa3lnlPLkVbd9jjTgYm1iVR6BKvZXcwl3Bp2s6okjZbspVJUAHnAZmIByTFB5S8
	 VFguBtprqiFxNIbRxPGbHbDLcqPXLdUmH8LsbO7ZHWJH0FPT9Inhja57K9CzuzUWD/
	 HQrxs14m4gw8SYEOofLhIW4NFN9ZOgFPxPFiuhl1K3RuTuOpEl4i+f4xNitdGyHkhn
	 n5N2Zvw9DkjGA==
Received: by pali.im (Postfix)
	id D83037B3; Sun,  2 Mar 2025 13:24:46 +0100 (CET)
Date: Sun, 2 Mar 2025 13:24:46 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] cifs: Handle all name surrogate reparse points
Message-ID: <20250302122446.dpqd6hlpfmy3fo3l@pali>
References: <20241222145845.23801-1-pali@kernel.org>
 <20250223222306.plgy3bpy5mjojfve@pali>
 <CAH2r5mv_+ZarrSPEhDjgEYPzqkvdqL-K7NjDsE0sXtrhx65G7A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5mv_+ZarrSPEhDjgEYPzqkvdqL-K7NjDsE0sXtrhx65G7A@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Sunday 23 February 2025 18:48:50 Steve French wrote:
> On Sun, Feb 23, 2025 at 4:23 PM Pali Rohár <pali@kernel.org> wrote:
> >
> > Hello Steve, I see that you have merged first two changes (1/4 and 2/4)
> > from this patch series, but the remaining (3/4 and 4/4). Is there any
> > reason why 3/4 and 4/4 was not taken?
> 
> Mainly because I wasn't able to easily test it, and didn't get test
> feedback for anyone else
> on those two who had tried it.
> 
> I am ok with looking at them again - and thx for rebasing.

Ok, when you have a time, please look at them.

> There are some of the 41 patches in your updated cifs branch that do look suitable or rc5

There is "cifs: Change translation of STATUS_DELETE_PENDING to -EBUSY"
which stops returning -ENOENT for directory entry which still exists.

> 
> > On Sunday 22 December 2024 15:58:41 Pali Rohár wrote:
> > > Name surrogate reparse point represents another named entity in the system.
> > >
> > > If the name surrogate reparse point is not handled by Linux SMB client
> > > and it is of directory type then treat it as a new mount point.
> > >
> > > Cleanup code for all explicit surrogate reparse points (like reparse
> > > points with tag IO_REPARSE_TAG_MOUNT_POINT) as they are handled by
> > > generic name surrogate reparse point code.
> > >
> > > Pali Rohár (4):
> > >   cifs: Throw -EOPNOTSUPP error on unsupported reparse point type from
> > >     parse_reparse_point()
> > >   cifs: Treat unhandled directory name surrogate reparse points as mount
> > >     directory nodes
> > >   cifs: Remove explicit handling of IO_REPARSE_TAG_MOUNT_POINT in
> > >     inode.c
> > >   cifs: Improve handling of name surrogate reparse points in reparse.c
> > >
> > >  fs/smb/client/inode.c    | 17 +++++++++++++----
> > >  fs/smb/client/reparse.c  | 24 ++++++++++--------------
> > >  fs/smb/common/smbfsctl.h |  3 +++
> > >  3 files changed, 26 insertions(+), 18 deletions(-)
> > >
> > > --
> > > 2.20.1
> > >
> >
> 
> 
> -- 
> Thanks,
> 
> Steve
