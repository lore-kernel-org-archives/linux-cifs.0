Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FE82EA48F;
	Mon, 18 May 2026 21:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779139980; cv=none; b=YYz8nHOCAVYawXqgK8ixn0Lugn8BL3jO9m9E3lQyBNtlABbGZFdC0Q9mE2W+M9mvJVotHJ5wQ/O3JgbPH8CPcFXqns+pZBxgmVwqYrlkt6DYtQ3X//sPjHyTD5E1AIt+2tXpb3PMTbEiLmmWQRNqjWgIWcR6iH+XvVQquf2cfX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779139980; c=relaxed/simple;
	bh=jis/84+rkvHhz3eLpzRb1KQ/6cDGjSDLWK2VgQBy0nY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XuOKygyJxryKpsrcd7E10lsOrv8/WCUK8IgKn/rMw2IfxDVGywJbgG9tiOSvPEr02SaTubtrMmDIpV0vRUJplA5bvTUUZrDJ6ouEr9E4grB2ZiU2x9yBKMk+wifgN3NxxFd2DBnLnsiKVwr23HEXlTyyK6Gl6hsDMSRQzDfdLx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e4xuEb5N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e4xuEb5N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B54C2BCB7;
	Mon, 18 May 2026 21:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779139979;
	bh=jis/84+rkvHhz3eLpzRb1KQ/6cDGjSDLWK2VgQBy0nY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e4xuEb5N4t+ZQ32+HoppzD7dGfIv79c9G8VPYDoKw8hfLhTpasPVU5SNO3KxVkoZI
	 zXD3sMIyxguLEgPJisL/cEKZuvcvXlmAKpQNjbdKHaWGVcM/xSpAt4knEkan2wMRQW
	 5TPOb1aoe1qh3vPpQ9BPrARxqHazIlT+BCEknsDUEDVnX9elIBUDFwnhdsHjFO7Q6F
	 Wq15wqXybMQj1zAhzqHGyJvNktDch/k/E8NujL3UP/iJIplJnggiGyw4EsI6s2O2Ys
	 98ffzxZ7vTzLNS71a6Qp2GyRmlfwD5kogoGlD4TNrJS3K2tY09KD+ZTmTZCxhQZPd2
	 tn4j2ppCHiqWw==
Date: Mon, 18 May 2026 14:32:54 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Steve French <sfrench@samba.org>,
	Christian Brauner <brauner@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.org>
Subject: Re: [GIT PULL for v7.1] vfs fixes
Message-ID: <20260518213254.GB3979157@ax162>
References: <20260518194622.GA2914683@ax162>
 <20260518-vfs-7.1-rc5.fixes-3eded3a501f4@brauner>
 <406981.1779138300@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <406981.1779138300@warthog.procyon.org.uk>

On Mon, May 18, 2026 at 10:05:00PM +0100, David Howells wrote:
> Nathan Chancellor <nathan@kernel.org> wrote:
> 
> > > David Howells (22):
> > >       netfs: Fix potential for tearing in ->remote_i_size and ->zero_point
> > ...
> > >  fs/smb/client/cifsfs.c       |  38 ++++--
> > 
> > The changes in this file from that patch breaks the build with clang:
> > 
> >   fs/smb/client/cifsfs.c:1390:29: error: variable 'old_size' is uninitialized when used here [-Werror,-Wuninitialized]
> >    1390 |                 if (rc == 0 && new_size > old_size) {
> >         |                                           ^~~~~~~~
> >   fs/smb/client/cifsfs.c:1307:37: note: initialize the variable 'old_size' to silence this warning
> >    1307 |         unsigned long long i_size, old_size, new_size, zero_point;
> >         |                                            ^
> >         |                                             = 0
> >   fs/smb/client/cifsfs.c:1375:13: error: variable 'zero_point' is uninitialized when used here [-Werror,-Wuninitialized]
> >    1375 |         if (fend > zero_point)
> >         |                    ^~~~~~~~~~
> >   fs/smb/client/cifsfs.c:1307:59: note: initialize the variable 'zero_point' to silence this warning
> >    1307 |         unsigned long long i_size, old_size, new_size, zero_point;
> >         |                                                                  ^
> >         |                                                                   = 0
> >   2 errors generated.
> 
> For some reason, make W=1 with gcc doesn't seem to generate uninitialised
> variable warnings (though maybe clang does?).  Is that specifically
> suppressed?
> 
> 	ifdef CONFIG_CC_IS_GCC
> 	KBUILD_CFLAGS += -Wno-maybe-uninitialized
> 	endif

Yeah, clang's -Wuninitialized and -Wsometimes-uninitialized are on by
default (not just at W=1) for the kernel, whereas GCC's
-Wmaybe-uninitialized has been under W=2 since 78a5255ffb6a ("Stop the
ad-hoc games with -Wno-maybe-initialized") back in 5.7.

I consider this an unfortunate difference between GCC and clang with
regards to -Wuninitialized. If there is any control flow that would
avoid the block that uses the variable uninitialized, GCC "downgrades"
it to -Wmaybe-uninitialized, whereas clang keeps it as -Wuninitialized
with a note of "when used here" to make it clear that the variable will
be used uninitialized if the block is reached:

  https://godbolt.org/z/6eb5zK76T

> I guess.  Can we remove that?

It would be nice for my sanity if it could be but then we are back into
the same situation of false positives, as GCC's warnings are influenced
by optimizations, whereas clang's warnings happen purely in the frontend
before optimizations happen. clang's versions do not flag as many
instances of potentially uninitialized variables (as it cannot do
interprocedural analysis to see across function boundaries) but that
results in much fewer false positives in my experience.

> > There were no -next updates last week, so it seems like the majority of
> > this pull request saw zero -next testing time. I see two kbuild test
> > robot build reports but I guess they were ignored.
> > 
> >   https://lore.kernel.org/202605031459.eX5UbO3K-lkp@intel.com/
> >   https://lore.kernel.org/202605021450.ca5QGqLH-lkp@intel.com/
> 
> Gmail labelled them as spam :-(

Bummer :/

> I think this should be fixed as below, but Steve needs to look it over.

Thanks, I will give it a build test but it seems obvious that it will
fix it.

-- 
Cheers,
Nathan
