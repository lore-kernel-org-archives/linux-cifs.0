Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4C4A937;
	Mon, 29 Apr 2024 10:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714387848; cv=none; b=h42ZQAY4QDfJip/JTenvy5pdyDEREvo36VV9yk24afhzMR2A5lLAKtwpivqlgz3ZOi0weRW06QxSg9VIHdZxvL4SmSZvkpBU2V9sRBpTj7tbF3jXkAJ5qi2Zibayc1GjPdiUi6Dhvl4wMKVut848IABOqBhox4UYLrSy65g2fKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714387848; c=relaxed/simple;
	bh=DsoKwItt0T3i6xV7miD8GkO5Dax6KkM58wXFBhQngqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EN5LYPSoRG9AfyTzBlJ+fnWx+U7XwKzZ5bCD22VfzYO42DJL36vs36VTQeIW0rA5OsQ+2JR3SmdNuMMCzSFXmzXbClafPsJ5x0tLqUqOZrgTAsUEGAgU7MFqbc7iWAmvnmatCSCwJDivG7hs3b43T9DxSynn+S1k8tVXjWSecLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WmWLiqFZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WmWLiqFZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB62C4AF1B;
	Mon, 29 Apr 2024 10:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714387848;
	bh=DsoKwItt0T3i6xV7miD8GkO5Dax6KkM58wXFBhQngqM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WmWLiqFZBhcGzWXukEbDsqsobkDcBGLvQ3JlWNG9PQE7eIn6BX7kKSnHqL2dqffQJ
	 qS0G58p9dNiWYu4RB6RETtc/xfmOhHCq+2sjTOWO7mclHZVFLd/VtAnyCZ1xsmzlvx
	 mbi+4LOT9WwccnRb0Fjz7Qw3kHgfKkRshll4vh2g=
Date: Mon, 29 Apr 2024 12:50:45 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Salvatore Bonaccorso <carnil@debian.org>
Cc: Paulo Alcantara <pc@manguebit.com>, regressions@lists.linux.dev,
	Steve French <stfrench@microsoft.com>, sashal@kernel.org,
	stable@vger.kernel.org, linux-cifs@vger.kernel.org
Subject: Re: [regression 6.1.80+] "CIFS: VFS: directory entry name would
 overflow frame end of buf" and invisible files under certain conditions and
 at least with noserverino mount option
Message-ID: <2024042912-unloader-slighting-c756@gregkh>
References: <ZiBCsoc0yf_I8In8@eldamar.lan>
 <cc3eea56282f4b43d0fe151a9390c512@manguebit.com>
 <ZiCoYjr79HXxiTjr@eldamar.lan>
 <29e0cbcab5be560608d1dfbfb0ccbc96@manguebit.com>
 <ZiLQG4x0m1L70ugu@eldamar.lan>
 <adfd2a680e289404140ef917cf0bd0ab@manguebit.com>
 <Zigg4RWtRfQYW1RR@eldamar.lan>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zigg4RWtRfQYW1RR@eldamar.lan>

On Tue, Apr 23, 2024 at 10:58:09PM +0200, Salvatore Bonaccorso wrote:
> Hi Paulo,
> 
> On Mon, Apr 22, 2024 at 12:08:53PM -0300, Paulo Alcantara wrote:
> > Salvatore Bonaccorso <carnil@debian.org> writes:
> > 
> > > I'm still failing to provide you a recipe with a minimal as possible
> > > setup, but with the instance I was able to reproduce the issue the
> > > regression seems gone with cherry-picking 35235e19b393 ("cifs: Replace
> > > remaining 1-element arrays") .
> > 
> > It's OK, no problem.  Could you please provide the backport to stable
> > team?
> 
> Sure, here it is. Greg or Sasha is it ok to pick that up for the 6.1.y
> queues?

Glad to, for some reason I thought this caused problems, but if it
passes your testing, great!  I'll go queue it up now, thanks.

greg k-h
