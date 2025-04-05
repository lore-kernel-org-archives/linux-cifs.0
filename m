Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F63D1474CC
	for <linux-cifs@vger.kernel.org>; Sat,  5 Apr 2025 17:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743873647; cv=none; b=Evb1AdK7r2llTLp4ZS19LjaOIl88y6yPTFFEbYYFfOxJat+dWaCjPbFCKjet++Ow6REdVREhc+Ad5o8zchOYgvzyJ/raiBFK1udZqHkBO0qs6/S+2g0Tx7ZIvdlcgkEVIlzvG3x3lQFEvJse8y2UbHu7G621qlrEekwOnZcEDKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743873647; c=relaxed/simple;
	bh=GMvyT/a2MxIIPr5SaIuPrk816LyESdyhV8ANOb+0JH8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OLRvEoIz9oIb9/dV449iCumN8yjxMax+7DqunMi5sHXdFMGMAnENbbvwttof0O3mousu18il7zrhlFsnOrQWrdXi1O/9ynwdRIJqC9CaP6Py2AmswYjN+yTGlwH0+WhJRnf5xdFdewslByhwTJ4GrpJ/Ok//Hc94q3vrkFWjXh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MaBeDafA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MaBeDafA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0CCDC4CEE4;
	Sat,  5 Apr 2025 17:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743873647;
	bh=GMvyT/a2MxIIPr5SaIuPrk816LyESdyhV8ANOb+0JH8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MaBeDafAMc2MSnLT8yxGzEOcymUi5YqyOFWnJboekw8RGAYDplhgBMUMEZf1nKTHE
	 wgPBOinUycFcLYm6ArVG+HqJ6+w6b84MT/pJ2AFh6hra8hI1j592BgPWM8VBOBDLl0
	 oRInuED3Wz3wICMh3js/Mspz9NIAJhtHk1L+vOcYDb81aRxX0iBiqUoSLULF9qinLt
	 FiUJXAE6kZKCKYUevmshsgrO4aEoeFSAku1F+LufxqkQFJq3mCX1yFpgcKWT6vjGts
	 s/+Blb7qSFRPJJQbmPA+mi9zqXC3fMe/wwhYjAWxAy6okgeULcywP1kSjFfeutW75m
	 GZy7ORey6sr5Q==
Received: by pali.im (Postfix)
	id E5A6585D; Sat,  5 Apr 2025 19:20:30 +0200 (CEST)
Date: Sat, 5 Apr 2025 19:20:30 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Junwen Sun <sunjw8888@gmail.com>
Cc: Steve French <smfrench@gmail.com>, 1marc1@gmail.com,
	linux-cifs@vger.kernel.org, pc@manguebit.com, profnandaa@gmail.com,
	samba-technical <samba-technical@lists.samba.org>
Subject: Re: Issue with kernel 6.8.0-40-generic?
Message-ID: <20250405172030.4ptuwa73nnqhkzdy@pali>
References: <CAJXSQBms+s2Whk7SfugzQ1kby-xyJ62aVLVvM05rPtFAo7247Q@mail.gmail.com>
 <CAH2r5ms2=o4baY-6_aLmHpJhBYwvaWXUKwZufKs-iT3vsEg_hA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5ms2=o4baY-6_aLmHpJhBYwvaWXUKwZufKs-iT3vsEg_hA@mail.gmail.com>
User-Agent: NeoMutt/20180716

Hello Junwen,

Could you please provide me more details about your issue? What exact
kernel version is affected and what error message you see? Because in
email subject is version 6.8 and in description is 6.12, so I quite
confused.

I will look at this issue, just I need all detailed information.
It looks like that the error handling is missing some case there.

Thanks

Pali

On Saturday 05 April 2025 12:16:27 Steve French wrote:
> Good catch - it does look like a regression introduced by:
> 
>         cad3fc0a4c8c ("cifs: Throw -EOPNOTSUPP error on unsupported
> reparse point type from parse_reparse_point()")
> 
> The "unhandled reparse tag: 0x9000701a" looks like (based on MS-FSCC
> document) refers to
> 
>     "IO_REPARSE_TAG_CLOUD_7   0x9000701A  Used by the Cloud Files
> filter, for files managed by a sync engine such as OneDrive"
> 
> Will need to revert that as it looks like there are multiple reparse
> tags that it will break not just the onedrive one above
> 
> 
> On Fri, Apr 4, 2025 at 10:24 PM Junwen Sun <sunjw8888@gmail.com> wrote:
> >
> > Dear all,
> >
> > This is my first time submit an issue about kernel, if I am doing this
> > wrong, please correct me.
> >
> > I'm using Debian testing amd64 as a home server. Recently, it updated
> > to linux-image-6.12.20-amd64 and I found that it couldn't mount
> > OneDrive shared folder using cifs. If I boot the system with 6.12.19,
> > then there is no such problem.
> >
> > It just likes the issue Marc encountered in this thread. And the issue
> > was fixed by commit 'ec686804117a0421cf31d54427768aaf93aa0069'. So,
> > I've done some research and found that in 6.12.20, there is a new
> > commit 'fef9d44b24be9b6e3350b1ac47ff266bd9808246' in cifs which almost
> > revert the commit 'ec686804117a0421cf31d54427768aaf93aa0069'. I guess
> > it brings the same issue back to 6.12.20.
> >
> > Thanks very much in advance if someone can have a look into this issue again.
> >
> > 孙峻文
> > Sun Junwen
> 
> 
> 
> -- 
> Thanks,
> 
> Steve
