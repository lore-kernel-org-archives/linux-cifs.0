Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9792BC15A;
	Sat, 17 Feb 2024 21:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.107.17.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708206627; cv=none; b=qYtRphgpYvBrODGVoHj7oj7xD5IF+Cuc/DQCbFaybvtf/Ta7IbbSMsFDJF4em09VHKkelKsLOQMBL6uDqQO39TmDQSnS8JqhYlTaHXbvJvNW4bvFIJG9xWHqXKSUvUeeMxLj6hfrYSOTlrzI9icXTowYPLFUEdQ4UPW5L1OJCBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708206627; c=relaxed/simple;
	bh=McTR83ultDi5i6tUnz/ncWKcPH2XUaC1tFksjbU9pb0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MXXQX7700cj1yGBWierFf9CBUf7BB1PVxGV+W26Q39fNcCH8VKnIYiDyevmo8m27lsZ6FCj302NfRffvMjopRhlprcS5AV3d0zSu2ojBYdw15TU8laxOtfunUIi7mlkmUHbqclsH1pPZcrPPDnW3ILGJe8J8Djyaf3zRBMPbh3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=194.107.17.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
	by vmicros1.altlinux.org (Postfix) with ESMTP id 1D1BD72C8FB;
	Sun, 18 Feb 2024 00:50:17 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
	by imap.altlinux.org (Postfix) with ESMTPSA id 0F40536D016B;
	Sun, 18 Feb 2024 00:50:17 +0300 (MSK)
Date: Sun, 18 Feb 2024 00:50:16 +0300
From: Vitaly Chikunov <vt@altlinux.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] cifs: Convert struct fealist away from 1-element array
Message-ID: <20240217215016.emqr3stdm3yrh4dq@altlinux.org>
References: <20230215000832.never.591-kees@kernel.org>
 <qjyfz2xftsbch6aozgplxyjfyqnuhn7j44udrucls4pqa5ey35@adxvvrdtagqf>
 <202402091559.52D7C2AC@keescook>
 <20240210003314.jyrvg57z6ox3is5u@altlinux.org>
 <2024021034-populace-aerospace-03f3@gregkh>
 <20240210102145.p4diskhnevicn6am@altlinux.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20240210102145.p4diskhnevicn6am@altlinux.org>

Greg, Sasha,

On Sat, Feb 10, 2024 at 01:21:45PM +0300, Vitaly Chikunov wrote:
> On Sat, Feb 10, 2024 at 10:19:46AM +0000, Greg Kroah-Hartman wrote:
> > On Sat, Feb 10, 2024 at 03:33:14AM +0300, Vitaly Chikunov wrote:
> > > 
> > > Can you please backport this commit (below) to a stable 6.1.y tree, it's
> > > confirmed be Kees this could cause kernel panic due to false positive
> > > strncpy fortify, and this is already happened for some users.
> > 
> > What is the git commit id?
> 
> 398d5843c03261a2b68730f2f00643826bcec6ba

Can you please apply this to the next 6.1.y release?

There is still non-theoretical crash as reported in
  https://lore.kernel.org/all/qjyfz2xftsbch6aozgplxyjfyqnuhn7j44udrucls4pqa5ey35@adxvvrdtagqf/

If commit hash was not enough:

  commit 398d5843c03261a2b68730f2f00643826bcec6ba
  Author:     Kees Cook <keescook@chromium.org>
  AuthorDate: Tue Feb 14 16:08:39 2023 -0800

      cifs: Convert struct fealist away from 1-element array

The commit is in mainline and is applying well to linux-6.1.y:

  (linux-6.1.y)$ git cherry-pick 398d5843c03261a2b68730f2f00643826bcec6ba
  Auto-merging fs/smb/client/cifspdu.h
  Auto-merging fs/smb/client/cifssmb.c
  [linux-6.1.y 4a80b516f202] cifs: Convert struct fealist away from 1-element array
   Author: Kees Cook <keescook@chromium.org>
   Date: Tue Feb 14 16:08:39 2023 -0800
   2 files changed, 10 insertions(+), 10 deletions(-)

Thanks,



> 
> Thanks,
> 
> > 
> > thanks,
> > 
> > greg k-h
