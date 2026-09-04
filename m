Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE28390CB7;
	Fri,  4 Sep 2026 10:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788517785; cv=none; b=rbQyGdI2AF5udzhal1VZXAR9mmQeKXABLuFTGBhjgYW8Nb0f+Rtx7YU7BokhWN+k7hnYfCN8esn3kwir/CUnjvJXY97u99USdNCfLh/mmiZ+isCaNx09lVVm/oLfmF/2A/oYiNMPfSo8dML835vap4DI7s9dr4Y9Yp/Q2Mj+u/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788517785; c=relaxed/simple;
	bh=29Sj+eziO1kqksXjmFLPRye1OGap9QWjDqk6tmiRTP8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B/XyY6ZjroaYHJ3o0NJi//rdPG7vj0tuDAQHGaCt+IipEuvQnNFlmUsjunfXs4SM4nzfJ/MQnOgUD2ZObZTBqMYJ1LhYVFzXvJSi+9f5moQgVxdNrr3nVyXu2Tw0rloYXw1S7UK9/MxBts12XD65R2JVB8fsjUS6NlwA+EBN+Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gX2PEnHv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gX2PEnHv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1C71F00A3D;
	Fri,  4 Sep 2026 10:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788517783;
	bh=J2UnILogmIqp5OMWhlZHu7jpPjsG5igcXjj6drLDMmQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gX2PEnHvSzB6nu3GS4yoj7ieyiKVakFVVELYWlZW30alRNsYhZlTGGoHIH2nQamIO
	 lmx9vkIalMbRt+ReVZPuYtFG4grjT5KManOcpF9OIHPtK9W8VDI+NYM/QXQLDrfE5h
	 LB67+bl7X+BCNz1/XtjnmKIuGNtXhV8bRFwJww1Dl1za8mIdu1ILAgWB9HCnQGhsEV
	 bnx9iIDeciU6SD7qlr8EMADPTB1HRi2c17q35nTfMX+bk9/VEjmo7gV7OA9bgf/2BO
	 xCYtNUkE54yWWCKqPErmkdvBSezQ94llqJEdVV2bMsmSu17TqjFiMCQYKwV1XwuZy+
	 B8g8WKl/lHy8w==
Date: Fri, 4 Sep 2026 12:29:39 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Karl Mehltretter <kmehltretter@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Paulo Alcantara <pc@manguebit.org>, 
	linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] super: make iterate_supers_type() deletion-safe
Message-ID: <20260904-astronaut-anpfiff-unbebaut-743381f4995a@brauner>
References: <20260903013336.92081-1-kmehltretter@gmail.com>
 <32afuwcqxfzvc2qwsvx6ecpyvbunr45wnvmezbbqzz25qtfn35@tvotjvtm3soe>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <32afuwcqxfzvc2qwsvx6ecpyvbunr45wnvmezbbqzz25qtfn35@tvotjvtm3soe>

On Thu, Sep 03, 2026 at 12:16:14PM +0200, Jan Kara wrote:
> On Thu 03-09-26 03:33:36, Karl Mehltretter wrote:
> > iterate_supers_type() drops sb_lock while invoking the callback and keeps
> > only a passive reference to the current superblock. That reference keeps
> > the object allocated, but does not keep its s_instances node linked.
> > 
> > After the callback releases s_umount, final teardown can unlink the current
> > s_instances node. The iterator then advances through a reinitialized node.
> > With the current hlist it stops without visiting the remaining superblocks.
> > The unlink moved from generic_shutdown_super() to kill_super_notify(), but
> > the cursor lifetime has been unsafe since the helper was introduced.
> > 
> > The CIFS DFS lookup can consequently miss a matching superblock and return
> > -EINVAL.
> > 
> > Walk the global superblock list in reverse and filter it by filesystem
> > type. A passive reference keeps its s_list node linked, and reverse
> > traversal preserves newest-first visitation. Superblocks removed from
> > fs_supers remain on the global list, but teardown marks them SB_DYING
> > before unlinking them, so the existing filter excludes them.
> > 
> > This broadens the scan from superblocks of one type to all superblocks.
> > The only in-tree caller is the CIFS DFS lookup, so the broader scan is
> > limited to that path.
> > 
> > Fixes: 43e15cdbefea ("new helper: iterate_supers_type()")
> > Cc: stable@vger.kernel.org
> > Assisted-by: LLM
> > Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> 
> Good spotting! But what I'm wondering about is whether we just shouldn't
> move where we delete sb from fs_supers. Currently we do that in
> kill_super_notify() to hide the sb from sget_fc() (which would otherwise
> permanently retry and call test() for S_DEAD sb which can cause problems).
> But if we just skipped S_DEAD superblocks in sget_fc(), we could move
> removal from fs_supers list to put_super() (make it symmetric with the
> handling of super_blocks list) and that would also fix
> iterate_supers_type(). Christian, what do you think?

Yes, that might work work.
