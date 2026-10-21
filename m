Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792576553;
	b=qVs616oRACE0ABNuZypwThqKaLuR4HQLqC3ANJZfbUbu1SfX++4m/uQTSl8ph/A6xCul
	 biGyLRmdOuS1uQIDiDYw+RQqJKDn87/CEsi0FzJGZ2uPuJE4bfX5x1PoYgs/QmU+BaBDI
	 2uw9LfUfHHNYCf6VB9WbcycrrymbmQ54GPBZeH/Nj4T6UAdzjd3o28t9B0tFCMudJxzcl
	 k0wHs7XP21nmAhLzuwN1Oqeszmif/cr0WVDIbVul2dZ0DWOfKGPK1w2adNjunJU8zb8CL
	 xuG5ZZkkxGLRQjeBGRnB4ehlvV+cC3rr7FQXM/eKjjbMvbrDj9dwNwE3Oanf2JN/Dcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792576553;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=IIGWTKmOx1c83FVGvewRkmLSOibVGHHpVBo4E4/42Jo=;
	b=nkpVFvn1BoDShA0ta9AB0qJaeCWlum7BjEym42lYBAppFRSs0tpthCTYHCN0mGOF+wD6
	 oX9uI+5wYIX6i07MRlv1fkrdqDnoedV0Y0KMXaoO0vQ/6V7kid12N103DpOjyFvQz0lVR
	 qHY+u8rbkaIi1SXJzT9t826Mhew2fm4Al9jhduAbV6YT0SRKis0Srph2v+59ZJVzMdKjr
	 Q/WoM/V/3sNaZtH8lqscL//foBxZ9LT27Yt2DbqkiGPgYMqDfLPKhOU/lzpHE54eZAtat
	 xkGr3MmVqIE0/fWY3rhIeno6FKJxxtpWtuwYZIV4oNuZEZlFP/js/o2o/RaA5IgkGGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Lxb6M2eh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8524606A319;
	Wed, 21 Oct 2026 09:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Lxb6M2eh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520C51F000C9;
	Wed, 21 Oct 2026 09:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792576552;
	bh=IIGWTKmOx1c83FVGvewRkmLSOibVGHHpVBo4E4/42Jo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Lxb6M2ehmlNxrSdK52xS7hR0Zf/zuU27nsuvJnITQdREM3X13JasaOw5sBhAI+Zjy
	 YKT3nyR6IxOTVmg/T4litaQH5jzb2lPv+jIM8nyJiCZnXdJxuTIFJC8YOTstUT/cNr
	 3BjGDbTY/AVnaNuV2k7zQmF8Ud/fsC1ugSkx4PX1Akivozx42Wp72xpH34xKcfyc4k
	 AyWtiJQKCfnOilgCQ+IjI2dV5xQ2pKCeqSKGMxroNVmMhClzmCpdaOSGyoBHLnzf0U
	 GnE6FUUp1oZm3pTa3Hah23IAnjLWoqBWRwlpCci/IttRHBd6jxG7NZ5XeMWuBnSj9q
	 boSQIEitH/YDg==
Date: Wed, 21 Oct 2026 11:55:47 +0200
From: Christian Brauner <brauner@kernel.org>
To: NeilBrown <neil@brown.name>
Cc: Paulo Alcantara <pc@manguebit.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] smb/client(cifs): prepare for locking changes.
Message-ID: <20261021-sodbrennen-ausdruck-kurven-72d0b7cc7db9@brauner>
References: <20260928012812.2890035-1-neilb@ownmail.net>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260928012812.2890035-1-neilb@ownmail.net>

On Mon, Sep 28, 2026 at 11:25:01AM +1000, NeilBrown wrote:
> I am working on changes to directory locking.  The medium term goal is
> to lift d_alloc_parallel() locking above i_rwsem, so d_alloc_paralle()
> can be run unlocked, and consequently cannot be called when ->i_rwsem is
> held.
> 
> The requires:
>  1/ that d_alloc_parallel() not be called while i_rwsem is held.  cifs
>     does this in a couple of places.  A new interface d_alloc_trylock()
>     is now available and can be used instead.
> 
>  2/ a dentry must not be d_drop()ed while an operation is ongoing, as an
>     unlocked d_alloc_parallel() would then be able to create a new
>     dentry with the same name.  In particular d_rehash() must be phased
>     out as it won't be safe.  This particularly affects the mechanism to
>     block lookups/revalidates while an unlink/rename is happening.  The
>     mechanism is changed to use one similar to how NFS addresses this
>     needed, though using the new LOOKUP_PRIVATE flag.
> 
> The patches depend on patches recently added to the vfs tree.  I would
> prefer these land in that tree too with an Acked-by or similar from cifs
> maintainers.

Can do, will need an Ack.
