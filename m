Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793307079;
	b=yAxUi3P7OJFBCAXVIDIY0ZkMUPj4XDqLk9nF+GhnLUWrBQkcweA0uvINuu50MCFwPD5O
	 jpaWyhggh3dWo6JUKPkudDnen14RDJ4+hEbad7yT25t5tYuOyPx0QdQbdWcocZGJoFu55
	 q7QECyB9zKua/orhQDPBOZJMzieVAM4duqNzmxesFeN3Qu2HMrKjrUsmhU9JLVfrDbeZe
	 IuuBzBjyxGQcByh3CtZ3OEqEn2wHTD85VsCXh638n3Nten6ufNXkeaMOZbGBTsDLh3Awc
	 3ZS8IIwtBml1Y7dpZRmsuXMcOf1g/b9BhIlizqJDHNB4Y9Ad0bHmSsUovagPzt15npg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793307079;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=M/QeBdycFBmMW/5BeoBbGqWDGKRCZXC7X2wditQIHQE=;
	b=c1d0Jf5wMK7r5nvKCN6JUTFACke0DT24yxm0d3tOFT2d+rUqmuRAkuQjFTenSs/GZhL4
	 Gha/2DKWPuV09pHBell/NoaFrhuJLxkjJDJNDgX43Px6TOj4lC1Wc/yUDGHA18eKI+mPE
	 73BE00+qRU6gFkvUWn0a9p/hLhw9atCBkoHXtWIVxBB+Xqmvce4c7DlKD1To2URiQxbja
	 ip7wLoxwhtPVa3RgyE/OArxCag6OiKJJGEDYM8EUErOJP9AoBcIZk1QHap5wpCF6P5asK
	 eSpPVKdGLkg/WTiLrlcrf8sBcrxHHTYb2vrtVdxJ8du0SxfC/PzXEOPQ/wF97J1kdrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ALOVMv66;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CE3606A322;
	Thu, 29 Oct 2026 20:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ALOVMv66
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEBF31F01816;
	Thu, 29 Oct 2026 20:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793307079;
	bh=M/QeBdycFBmMW/5BeoBbGqWDGKRCZXC7X2wditQIHQE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ALOVMv660GDEhsdxOlSAlq0oNCfopkpdQ3k/WmJpMIyPVijk3Jd9X0dAtInQlI1yi
	 LjluZmI3Fdv29QPt9V1ar8P5gNPZEMNchqKup0F37+PtYfeF5/5mGYdX8Gkpun6cz7
	 z8ttoaIzCFw9v7JWmxadjnQ/vWs3qqCJLXGbgB4xrKo85yEFlIawGednHbNq5gKfIq
	 /pGQEqd4AFYLzSWHQ4C5Wt3a6YqJArVR7YGqKW1xRNPsXDeZ9D5NtVIKUpixXDV20E
	 +IO5TsJo3i9+tJipwYMsQZZIKD4G9pktMXucs5K7JzitxSaw8HPm7N/nM1r4Df+HMB
	 Xn2qLpOqf2Fkw==
Date: Thu, 29 Oct 2026 20:51:17 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Nickolai Zeldovich <nickolai@csail.mit.edu>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, 
	Vitaly Wool <vitaly.wool@konsulko.se>, Vitaly Vul <vitaly.vul@partner.samsung.com>, 
	Paulo Alcantara <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org
Subject: Re: [PATCH v1] mempool: fix min_nr exceeding the elements array
 after concurrent resizes
Message-ID: <auOrt2Cfq92heZQk@thinkstation>
References: <20261016132510.789715-1-nickolai@csail.mit.edu>
 <atJBK6hWYh2AqXwK@thinkstation>
 <de86277d-ed7e-4208-a3c2-6d26a8278d0c@kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de86277d-ed7e-4208-a3c2-6d26a8278d0c@kernel.org>

I refined the commit message a bit per Vlastimil's feedback...

On Tue, Oct 20, 2026 at 10:42:53AM +0200, Vlastimil Babka (SUSE) wrote:
> On 10/16/26 17:46, Harry Yoo wrote:
> >> ---
> >>
> >>  mm/mempool.c | 4 +++-
> >>  1 file changed, 3 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/mm/mempool.c b/mm/mempool.c
> >> index cb74e718b2c6..95533e2975ce 100644
> >> --- a/mm/mempool.c
> >> +++ b/mm/mempool.c
> >> @@ -378,7 +378,9 @@ int mempool_resize(struct mempool *pool, int new_min_nr)
> >>  			pool->free(element, pool->pool_data);
> >>  			spin_lock_irqsave(&pool->lock, flags);
> >>  		}
> >> -		pool->min_nr = new_min_nr;
> >> +		/* Raced, the array may now be smaller than new_min_nr */
> >> +		if (new_min_nr <= pool->min_nr)
> 
> There could be just '<' ?
> The outer if uses <= but the == case only leads to an early goto out_unlock.

However I didn't adjust this. the end result:
> mempool: fix min_nr exceeding the elements array after concurrent resizes
> 
> When mempool_resize() shrinks a pool, it releases and re-acquires
> pool->lock for every pool->free() call until the pool holds no more
> than new_min_nr elements, and then updates pool->min_nr to new_min_nr.
> 
> The shrink path has stored new_min_nr unconditionally since a historical
> commit 6892188b54d4 ("[PATCH] Re: [patch] change mempool to not alter
> managed elements"). However, unconditionally updating pool->min_nr is
> incorrect when a concurrent mempool_resize() has shrunk the pool size
> below new_min_nr.
> 
> Re-check new_min_nr against pool->min_nr under the lock and update
> pool->min_nr only if new_min_nr is not larger than pool->min_nr.
> 
> This was discovered by formal verification of mm/mempool.c against the
> kernel binary. While reproducing it in the kernel has not been
> successful, in a userspace implementation of mempool, ASAN was able to
> detect a heap buffer overflow.
> 
> In theory, an in-tree caller can hit this: fs/smb/client resizes the
> global cifs_req_poolp from cifs_demultiplex_thread() (grow, when a TCP
> session is created) and from clean_demultiplex_info() (shrink, when one
> goes away). The two are coordinated only through the atomic
> tcpSesAllocCount, so mounts and unmounts racing on one client run the
> resizes above concurrently; pool->free is kmem_cache_free() there and
> the window is a preemption inside it.  The other callers
> (block/blk-zoned.c, drivers/s390/scsi/zfcp_erp.c) serialise their
> resizes.

[+Cc folks in COMMON INTERNET FILE SYSTEM CLIENT (CIFS and SMB3)
 as the paragraph above mentions it. ]

> Assisted-by: LLM
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

Here I'm bit hesitant to add Cc: stable for a 24-years-old theoretical
race that hasn't been reproduced in the kernel. But it would be easy
to backport if anybody complains.

> Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Link: https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git/commit/?id=6892188b54d484098b79b0c9813c20e543124e2d
> Link: https://patch.msgid.link/20261016132510.789715-1-nickolai@csail.mit.edu
> [ harry@kernel.org: refine changelog per Vlastimil's comment ]
> Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>

This will be queued to slab/for-next-fixes soon.

Thanks!

-- 
Cheers,
Harry / Hyeonggon
