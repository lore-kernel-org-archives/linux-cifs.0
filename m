Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A0701B944;
	Sun, 18 Feb 2024 09:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.107.17.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708250348; cv=none; b=mn/1fPohnZDBCL50BYIN0I10JWiPfuUrqlDJZ0Kww6tNirT/yotAjnm5iUhL0WO2CyFtWm9XffqOPauMC4IAGmTT4YFcD2PhGbiL90UBm7PEQssA5Q7VHoMx9AoUh/l9kyRmoPtDlJu8EVECO5gZrxk7ZemVRZb0EohrS2AqyO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708250348; c=relaxed/simple;
	bh=IGCnPy2SRJuc9eaAUbdC20XKH7Zdj+g2ydOyooARQwI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hxyaKnzx2aGC7HTMZ2zvKzZOoW9AlQF22XV+l/hl8FqJrKYDNpxb2/zP58fErNrJ8Pcq7QIfVdxAOiGP7O/4ho9lLVpeynRz585BoEsCZpSYpPVRxPE6e+BatnsDSkRKAbev0Q69RyP6CHAL4uikxApiIvnDQGDiAfnMYc3eQ3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=194.107.17.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
	by vmicros1.altlinux.org (Postfix) with ESMTP id 934A672C90D;
	Sun, 18 Feb 2024 12:59:03 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
	by imap.altlinux.org (Postfix) with ESMTPSA id 81D7336D016F;
	Sun, 18 Feb 2024 12:59:03 +0300 (MSK)
Date: Sun, 18 Feb 2024 12:59:03 +0300
From: Vitaly Chikunov <vt@altlinux.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
	Kees Cook <keescook@chromium.org>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] cifs: Convert struct fealist away from 1-element array
Message-ID: <20240218095903.5tg6wo3jvnguyzf6@altlinux.org>
References: <20230215000832.never.591-kees@kernel.org>
 <qjyfz2xftsbch6aozgplxyjfyqnuhn7j44udrucls4pqa5ey35@adxvvrdtagqf>
 <202402091559.52D7C2AC@keescook>
 <20240210003314.jyrvg57z6ox3is5u@altlinux.org>
 <2024021034-populace-aerospace-03f3@gregkh>
 <20240210102145.p4diskhnevicn6am@altlinux.org>
 <20240217215016.emqr3stdm3yrh4dq@altlinux.org>
 <2024021808-coach-wired-41cb@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <2024021808-coach-wired-41cb@gregkh>

Greg,

On Sun, Feb 18, 2024 at 10:31:29AM +0100, Greg Kroah-Hartman wrote:
> On Sun, Feb 18, 2024 at 12:50:16AM +0300, Vitaly Chikunov wrote:
> > 
> > On Sat, Feb 10, 2024 at 01:21:45PM +0300, Vitaly Chikunov wrote:
> > > On Sat, Feb 10, 2024 at 10:19:46AM +0000, Greg Kroah-Hartman wrote:
> > > > On Sat, Feb 10, 2024 at 03:33:14AM +0300, Vitaly Chikunov wrote:
> > > > > 
> > > > > Can you please backport this commit (below) to a stable 6.1.y tree, it's
> > > > > confirmed be Kees this could cause kernel panic due to false positive
> > > > > strncpy fortify, and this is already happened for some users.
> > > > 
> > > > What is the git commit id?
> > > 
> > > 398d5843c03261a2b68730f2f00643826bcec6ba
> > 
> > Can you please apply this to the next 6.1.y release?
> > 
> > There is still non-theoretical crash as reported in
> >   https://lore.kernel.org/all/qjyfz2xftsbch6aozgplxyjfyqnuhn7j44udrucls4pqa5ey35@adxvvrdtagqf/
> > 
> > If commit hash was not enough:
> > 
> >   commit 398d5843c03261a2b68730f2f00643826bcec6ba
> >   Author:     Kees Cook <keescook@chromium.org>
> >   AuthorDate: Tue Feb 14 16:08:39 2023 -0800
> > 
> >       cifs: Convert struct fealist away from 1-element array
> > 
> > The commit is in mainline and is applying well to linux-6.1.y:
> > 
> >   (linux-6.1.y)$ git cherry-pick 398d5843c03261a2b68730f2f00643826bcec6ba
> >   Auto-merging fs/smb/client/cifspdu.h
> >   Auto-merging fs/smb/client/cifssmb.c
> >   [linux-6.1.y 4a80b516f202] cifs: Convert struct fealist away from 1-element array
> >    Author: Kees Cook <keescook@chromium.org>
> >    Date: Tue Feb 14 16:08:39 2023 -0800
> >    2 files changed, 10 insertions(+), 10 deletions(-)
> 
> It does not apply cleanly due to renames, can you provide a backported,
> and tested, patch please?

I cannot test it solves the bug since I don't use software that triggers
the crash. But crash logic is obvious - sizeof of first element of char
array is 1 byte and fortify code for strncpy issues panic. The patch is
obviously missed.

I can send that patch that is result of my git applying cleanly 398d5843c03261a2b68730f2f00643826bcec6ba.
And I will try to build kernel and ensure it compiles well.
Will this be enough?

Thanks,

> 
> thanks,
> 
> greg k-h
