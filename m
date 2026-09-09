Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A136D441600;
	Wed,  9 Sep 2026 08:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788941465; cv=none; b=bC1cZK1/yCayPDbvscnKSmapkPtDtFMsXnmt34NgNMQ46h26YqQkhsTfntiYq+S61TYVzosDrHwYeaRcQ+EbT20rjlxxkPnrOMZBdYikTNBNnfx38dOEDU4rCogt6YreCM4Yi3SnhX/YiHtnfQyXh47Cjct+pJq3OWSS27lFmKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788941465; c=relaxed/simple;
	bh=1m348XouXFHB5CWK3FLkoGzEKvTq/MkQ8i8Mazo7Z6Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GEPj+qd579JI5bu3Pr0e7ymSKuWHw2psqvwNPqkXbwgDdFoKI/7p/BwbKcLZG76RJBs7AjVr7CM14m9kQbCF0QKOZUC/l7v7iWGroOgvK2lyLVEGVydCxD23iL6pqIoMM1GAC64m11/qOet6uYs7U0ku1aDUEha1HXuhu7LDQ8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lLb96y7W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lLb96y7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C591F00A3A;
	Wed,  9 Sep 2026 08:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788941464;
	bh=4u6JKCOXGiXpWoDfTTuQ2uKPcNZPW86gx3ocAHFyjCw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lLb96y7W/DXlitq2Lg0rT4P01HqYUE64cjKdIpGXQo+3Q9zjag7hijc5IVuDKGIBH
	 G2sZHRTcpRP3ETp02C5VWjGPQ/OR0f/cZh33mkJ6oeuELXOUNmQHO+eDdcYtnmKDNy
	 x1eCyxYPz3xwzSaIPWc5EVc0tsqbU4SCM+cVAekr7OHwIJ/N5PmzQs5cTv/LPyULmn
	 mTiixjAWvlcZJNklR6vouzl0l1hxH+qGydiPkusgpuOppNBYn/bX7hHIWHtuSfWwDC
	 XtzWw3gyrTHXbncIY3x18o+pcagqQtiowqfdVGA3dYRVbPWnERgKsIB+1otBXuQo/v
	 rmbwjZ4TBwYEA==
Date: Wed, 9 Sep 2026 10:10:58 +0200
From: Christian Brauner <brauner@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Paulo Alcantara <pc@manguebit.org>, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] super: make iterate_supers_type() deletion-safe
Message-ID: <20260909-speichel-hiesig-windig-480afa97f0b6@brauner>
References: <20260903013336.92081-1-kmehltretter@gmail.com>
 <32afuwcqxfzvc2qwsvx6ecpyvbunr45wnvmezbbqzz25qtfn35@tvotjvtm3soe>
 <20260904-astronaut-anpfiff-unbebaut-743381f4995a@brauner>
 <20260904-rockkonzert-bergtour-dahin-23c9c5c87d0f@brauner>
 <apu0mCbJ4S0TKIQM@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <apu0mCbJ4S0TKIQM@gmail.com>

On Sat, Sep 05, 2026 at 08:31:32AM +0200, Karl Mehltretter wrote:
> On Fri, Sep 04, 2026 at 01:11:53PM +0100, Christian Brauner wrote:
> > 
> > Draft, feel free to grab, Jan or Karl.
> > 
> > ---
> >  fs/kernfs/mount.c |  4 ++--
> >  fs/super.c        | 39 +++++++++++++++++++--------------------
> >  2 files changed, 21 insertions(+), 22 deletions(-)
> > 
> 
> Thanks, I found no issues with your draft.
> All the tests I ran on my patch also pass with your draft.
> 
> Below is my proposed changelog. If it looks good, I'll send v2 with you as
> author. Could you provide your Signed-off-by?
> 
> super: make iterate_supers_type() deletion-safe
> 
> iterate_supers_type() drops sb_lock while invoking the callback and keeps
> only a passive reference to the current superblock. That reference keeps
> the object allocated, but does not keep its s_instances node linked.
> 
> After the iterator releases s_umount, final teardown can unlink the current
> s_instances node. The iterator then advances through a reinitialized node.
> With the current hlist it stops without visiting the remaining superblocks.
> The unlink moved from generic_shutdown_super() to kill_super_notify(), but
> the cursor lifetime has been unsafe since the helper was introduced.
> 
> The CIFS DFS lookup can consequently miss a matching superblock and return
> -EINVAL.
> 
> Move removal from fs_supers to put_super(), alongside removal from
> super_blocks, so a passive reference keeps both list nodes linked. Keep
> the filesystem module reference until then, since unlinking s_instances
> may touch type->fs_supers.
> 
> Make sget_fc() skip SB_DEAD superblocks before invoking test(), and set
> SB_DEAD under sb_lock to serialize with those callbacks. This allows
> kernfs to free its private information after kill_anon_super() returns.
> Keep matching SB_DYING superblocks until SB_DEAD is set so concurrent
> mounts still wait for teardown before retrying.
> 
> Fixes: 43e15cdbefea ("new helper: iterate_supers_type()")
> Reported-by: Karl Mehltretter <kmehltretter@gmail.com>
> Suggested-by: Jan Kara <jack@suse.cz>
> Cc: stable@vger.kernel.org
> <your Signed-off-by>
> Tested-by: Karl Mehltretter <kmehltretter@gmail.com>
> Assisted-by: LLM
> <my Signed-off-by>

Sure,
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org> 
