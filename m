Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2875CA6B;
	Sun, 18 Feb 2024 09:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708248692; cv=none; b=bsTqSX6+DPinPqYSLQUnU5ShFyDtN7kVvf/VfxbwRsQwznQrKZTI5pxB9PFXPGhtPr4CTJD2RpZpAMHArq7MTANJzgaJAonk15OcHDYXMOZHTXYH9lHgsDd5F+BTJiFpkKRLLcIgplgXnxr/OZZFsAQ6vuDLipc5ntYcxUlp2yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708248692; c=relaxed/simple;
	bh=bSFPBB1lkAFDYtbdb4l4xmYjc9oVNmeuIY8fCtgzv94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D4FR1F8taaoYktPP9CDmUcfM7ElR6qkoGizrDQ0ME2jdOK2YD2huH9T5ANZbv6T6bBSx6Lsrxu5aD5Vnbc6D7ME1CWaQ+uXKDwTZMqQcRIYHdHtev2KwZ3GqpXZpmyYP9TcfQ14TNlDWyX80DalzmK7wOYSRy138+OW5+qB5yxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FZwWs7JH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FZwWs7JH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B7FC43394;
	Sun, 18 Feb 2024 09:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708248692;
	bh=bSFPBB1lkAFDYtbdb4l4xmYjc9oVNmeuIY8fCtgzv94=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FZwWs7JHDsC80RMCNLqi897BnTy7qFAwkpcVLGniwBnG/15p7RUV5x/H6iwA+F/Zx
	 F3ootulNovmgdC8KF/oU1iH/4oyMlGkPQoNJci2Vd4H59YAiuCWIoW4y53wat4iJxY
	 3S4Wzk4uT0Cy2KgAZifhyEe5fuoa7qYTPAWy8qxI=
Date: Sun, 18 Feb 2024 10:31:29 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vitaly Chikunov <vt@altlinux.org>
Cc: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
	Kees Cook <keescook@chromium.org>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] cifs: Convert struct fealist away from 1-element array
Message-ID: <2024021808-coach-wired-41cb@gregkh>
References: <20230215000832.never.591-kees@kernel.org>
 <qjyfz2xftsbch6aozgplxyjfyqnuhn7j44udrucls4pqa5ey35@adxvvrdtagqf>
 <202402091559.52D7C2AC@keescook>
 <20240210003314.jyrvg57z6ox3is5u@altlinux.org>
 <2024021034-populace-aerospace-03f3@gregkh>
 <20240210102145.p4diskhnevicn6am@altlinux.org>
 <20240217215016.emqr3stdm3yrh4dq@altlinux.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240217215016.emqr3stdm3yrh4dq@altlinux.org>

On Sun, Feb 18, 2024 at 12:50:16AM +0300, Vitaly Chikunov wrote:
> Greg, Sasha,
> 
> On Sat, Feb 10, 2024 at 01:21:45PM +0300, Vitaly Chikunov wrote:
> > On Sat, Feb 10, 2024 at 10:19:46AM +0000, Greg Kroah-Hartman wrote:
> > > On Sat, Feb 10, 2024 at 03:33:14AM +0300, Vitaly Chikunov wrote:
> > > > 
> > > > Can you please backport this commit (below) to a stable 6.1.y tree, it's
> > > > confirmed be Kees this could cause kernel panic due to false positive
> > > > strncpy fortify, and this is already happened for some users.
> > > 
> > > What is the git commit id?
> > 
> > 398d5843c03261a2b68730f2f00643826bcec6ba
> 
> Can you please apply this to the next 6.1.y release?
> 
> There is still non-theoretical crash as reported in
>   https://lore.kernel.org/all/qjyfz2xftsbch6aozgplxyjfyqnuhn7j44udrucls4pqa5ey35@adxvvrdtagqf/
> 
> If commit hash was not enough:
> 
>   commit 398d5843c03261a2b68730f2f00643826bcec6ba
>   Author:     Kees Cook <keescook@chromium.org>
>   AuthorDate: Tue Feb 14 16:08:39 2023 -0800
> 
>       cifs: Convert struct fealist away from 1-element array
> 
> The commit is in mainline and is applying well to linux-6.1.y:
> 
>   (linux-6.1.y)$ git cherry-pick 398d5843c03261a2b68730f2f00643826bcec6ba
>   Auto-merging fs/smb/client/cifspdu.h
>   Auto-merging fs/smb/client/cifssmb.c
>   [linux-6.1.y 4a80b516f202] cifs: Convert struct fealist away from 1-element array
>    Author: Kees Cook <keescook@chromium.org>
>    Date: Tue Feb 14 16:08:39 2023 -0800
>    2 files changed, 10 insertions(+), 10 deletions(-)

It does not apply cleanly due to renames, can you provide a backported,
and tested, patch please?

thanks,

greg k-h
