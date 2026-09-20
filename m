Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AB3390999;
	Sun, 20 Sep 2026 19:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789931310; cv=none; b=COdEGHQhtzmDTV+zSWJeJcq34v/kRjHfyVo3fEybxXtGKu5jWZbv6HtS5yXF5JgH2POhEB6LbTA36BkuLVVSvPwyRy1tnKPbTi+6XNoP4f+UL9WrvTyyAY9nOhdRnZitATKZQg9YLcObLDXoozT/y3HITbz/ctSS5v0eVVq5E1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789931310; c=relaxed/simple;
	bh=kQtElpnNITSTtyHK2WXlyLGav5eKkDFQLAlezUEwYkg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DQfnX9iS6KOpzbFKTHams1LeDl4zN1dDeanQvl0A5kqYnb9PG5JWpVwDsXJBQ+9fjm1bjxefltUL5SsKJKTjrpbFPkWIx9VUrmOGxaSN/xlzjti12CPlXjy7+qIEEIMnh4m7RjMhoGYKZ+HHggTqafw6nkWN0whUFnvnsf69gPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=NkteqUSC; arc=none smtp.client-ip=80.241.56.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="NkteqUSC"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4hnwqr4LgXzMl2c;
	Sun, 20 Sep 2026 21:08:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1789931304;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vEHOjSWRZcPnxpiDog+HPMUx4qiEH33lrm296QWoL7s=;
	b=NkteqUSCGYd9As8RVvAJzOfJB/11HqAb0ieUdsusYAMLTBmEfZAnVHx9O/hOy3yirtZPbO
	LySsIYAlFExhaGWBMMwTotRZWyGbho1MYUPsyWx1SB82d18Vr6ymUN53rri1Jp26WrRUcm
	/uRHTjIMUvYftLwjYW5w31uCb1JApfnjQIg/mlauHcboFvbIo89GIBNGZlfT4FZnAup4J7
	SgLyzCQhrU2JzgpAcc/GK/4ADaJkirfzN5zsn5iaBS9mDfkkwFy+dgrcORvA2FjaYs/hJ0
	c9cjbwQtBKLWozzdFFyeXcPC2DhLVSP1/xFrubpZBh1fiXWMUsTo+Rq5hnBGSA==
Message-ID: <1c243393-4fb7-4be3-8d3c-9727b20ae373@mailbox.org>
Date: Sun, 20 Sep 2026 21:08:20 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: client side "current->alloc_tag not set WARNING:
 ./include/linux/alloc_tag.h:161" at accessing CIFS share
To: Hao Ge <hao.ge@linux.dev>, Paulo Alcantara <pc@manguebit.org>
Cc: linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>,
 netfs@lists.linux.dev, linux-kernel@vger.kernel.org
References: <0b004319-9ef7-437c-a4dd-174d6a9a83db@mailbox.org>
 <0e8961201179ba88038de511c587ddc7@manguebit.org>
 <cfcba100-609a-4016-9b47-186346709634@linux.dev>
Content-Language: en-US, de-DE
From: Erhard Furtner <erhard_f@mailbox.org>
In-Reply-To: <cfcba100-609a-4016-9b47-186346709634@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MBO-RS-META: yx9q3f76xgnwuhifp5debybtiokgsto3
X-MBO-RS-ID: 086fc2c6401a82ff953

On 9/16/26 11:42, Hao Ge wrote:
> Right - and there's one more instance of the same pattern.
> Erhard's second warning (alloc_tag was not set on free) comes from
> netfs_folioq_alloc(), which does the same for the folio_queue:
> 	
> 	fq = netfs_folioq_pool.alloc(gfp, netfs_folioq_pool.pool_data);
> 
> When I first saw the report I wondered why no other mempool user trips over this,
> so I had a look around the tree:
> 
> Everyone else gets their elements through the mempool_alloc() macro, so the tag is
> set at their callsite and the callbacks see a valid current->alloc_tag.
> 
> I went back to the commit that introduced the raw call, 1d78d56c43ef ("netfs: Fix folio_queue ENOMEM in
> writeback by adding a mempool") and OK, I think I roughly understand the story now.
> 
> Here is my proposed fix patch. I don't have a test environment handy though. What do you think?
> 
> diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
> index 420ee7b26580..373be970ec31 100644
> --- a/fs/netfs/internal.h
> +++ b/fs/netfs/internal.h
> @@ -45,6 +45,9 @@ extern mempool_t netfs_request_pool;
>   extern mempool_t netfs_subrequest_pool;
>   extern mempool_t netfs_folioq_pool;
>   
> +#define mempool_alloc_element(_pool, _gfp)				\
> +	alloc_hooks((_pool)->alloc(_gfp, (_pool)->pool_data))
> +
>   #ifdef CONFIG_PROC_FS
>   static inline void netfs_proc_add_rreq(struct netfs_io_request *rreq)
>   {
> diff --git a/fs/netfs/objects.c b/fs/netfs/objects.c
> index 01461a74642d..18f5c64d404e 100644
> --- a/fs/netfs/objects.c
> +++ b/fs/netfs/objects.c
> @@ -34,7 +34,7 @@ struct netfs_io_request *netfs_alloc_request(struct address_space *mapping,
>   
>   		rreq = mempool_alloc(mempool, gfp);
>   	} else {
> -		rreq = mempool->alloc(gfp, mempool->pool_data);
> +		rreq = mempool_alloc_element(mempool, gfp);
>   		if (!rreq)
>   			return ERR_PTR(-ENOMEM);
>   	}
> @@ -206,7 +206,7 @@ struct netfs_io_subrequest *netfs_alloc_subrequest(struct netfs_io_request *rreq
>   	struct kmem_cache *cache = mempool->pool_data;
>   
>   	if (rreq->gfp == GFP_KERNEL)
> -		subreq = mempool->alloc(rreq->gfp, mempool->pool_data);
> +		subreq = mempool_alloc_element(mempool, rreq->gfp);
>   	else
>   		subreq = mempool_alloc(mempool, rreq->gfp);
>   	if (!subreq)
> diff --git a/fs/netfs/rolling_buffer.c b/fs/netfs/rolling_buffer.c
> index 8c0026836f9c..d1ae6e081664 100644
> --- a/fs/netfs/rolling_buffer.c
> +++ b/fs/netfs/rolling_buffer.c
> @@ -29,7 +29,7 @@ struct folio_queue *netfs_folioq_alloc(unsigned int rreq_id, gfp_t gfp,
>   	struct folio_queue *fq;
>   
>   	if (gfp == GFP_KERNEL)
> -		fq = netfs_folioq_pool.alloc(gfp, netfs_folioq_pool.pool_data);
> +		fq = mempool_alloc_element(&netfs_folioq_pool, gfp);
>   	else
>   		fq = mempool_alloc(&netfs_folioq_pool, gfp);
>   	if (fq) {

Thanks for your patch Hao! On my side I can confirm it applies on 
v7.3-rc3 and fixes "the current->alloc_tag not set WARNING:"

Regards,
Erhard
