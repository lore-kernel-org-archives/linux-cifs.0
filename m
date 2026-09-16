Received: from mta0.migadu.com (out-88.mta0.migadu.com [91.218.175.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9A274AA00D
	for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 09:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789551698; cv=none; b=ChZPzGtiF9Q2OFIXyUGXHTUleLC2QGgLsGbfen4QCWqDhIncuX2Pb+BeOIHKMN0SdJwJbZwW316ldVMwP3bvcwx4/FlU9tbIgqN4jlAssXCgiKRcR0iO9Cy7TneIZkzmfiSzoG08OxsKBD/od4qX96PM0awfIMhRE4Jn2E7m0l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789551698; c=relaxed/simple;
	bh=/O66kM1XqK/k+1+V8AfJSc2H9zVFlAnRkccenBDJgnQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JsfJR5Lg8YHNIvCdYCXDTOMEinci2nlDSYvfCjSTYsPPN3mMIqWL/NA+QkFvU7WpJ8ucak7s1nC+tlFOlQFLANT5gO9crNaUQKt1AuXm2ANZpw4h28juYtu3oDlkitXcvaBUfbvjBO5XpcQOloIwZTWv2w3QILD5jDYnv7CY9U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kxr+j67c; arc=none smtp.client-ip=91.218.175.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kxr+j67c"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=/O66kM1XqK/k+1+V8AfJSc2H9zVFlAnRkccenBDJgnQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789551688; v=1; x=1790156488;
 b=kxr+j67cWvfl9niH+dahQfwtlUZACE/1mJVRa3Yqi3zANF7wEEIVAUbPaoXV3B1TJBXrJoJa
 +nZv4SStHF2SzrN2vop29oJkHnIP50DpWcEp79i58lWZMVkjRnJGKcl5VRGpFpQLOmaKkqr58fV
 0OKFsToDHCC2aR5eniPB6bYs=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 6bb14bcd9a7238ed;
	Wed, 16 Sep 2026 09:41:28 +0000
X-Mizu-Trace-ID: 6bb14bcd9a7238ed
X-Migadu-Flow: FLOW_OUT
Message-ID: <cfcba100-609a-4016-9b47-186346709634@linux.dev>
Date: Wed, 16 Sep 2026 17:42:08 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: client side "current->alloc_tag not set WARNING:
 ./include/linux/alloc_tag.h:161" at accessing CIFS share
To: Paulo Alcantara <pc@manguebit.org>, Erhard Furtner <erhard_f@mailbox.org>
Cc: linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>,
 netfs@lists.linux.dev, linux-kernel@vger.kernel.org
References: <0b004319-9ef7-437c-a4dd-174d6a9a83db@mailbox.org>
 <0e8961201179ba88038de511c587ddc7@manguebit.org>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <0e8961201179ba88038de511c587ddc7@manguebit.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Paulo


Sorry to jump in.

On 2026/9/2 07:19, Paulo Alcantara wrote:
> Erhard Furtner <erhard_f@mailbox.org> writes:
> 
>> Getting this "current->alloc_tag not set WARNING:" every time on my 
>> client PC when I open files on the CIFS share (exported via KSMBD) from 
>> my host PC:
> 
> The warning is triggered by running the following in
> netfs_alloc_request() with CONFIG_MEM_ALLOC_PROFILING_DEBUG=y kernels:
> 
>         rreq = mempool->alloc(gfp, mempool->pool_data);
> 
> for the non-writeback path.
> 
> @mempool->alloc is set to mempool_alloc_slab(), which calls
> kmem_cache_alloc_noprof() directly and expects the caller to have
> already set current->alloc_tag.
> 
> It doesn't occur in the writeback path, however, because we call
> mempool_alloc() macro that wraps to
> 
>         alloc_hooks(mempool_alloc_noprof(...))
> 
> and it sets current->alloc_tag before the allocation.
>

Right - and there's one more instance of the same pattern.
Erhard's second warning (alloc_tag was not set on free) comes from
netfs_folioq_alloc(), which does the same for the folio_queue:
	
	fq = netfs_folioq_pool.alloc(gfp, netfs_folioq_pool.pool_data);

When I first saw the report I wondered why no other mempool user trips over this,
so I had a look around the tree:

Everyone else gets their elements through the mempool_alloc() macro, so the tag is
set at their callsite and the callbacks see a valid current->alloc_tag.

I went back to the commit that introduced the raw call, 1d78d56c43ef ("netfs: Fix folio_queue ENOMEM in
writeback by adding a mempool") and OK, I think I roughly understand the story now.

Here is my proposed fix patch. I don't have a test environment handy though. What do you think?

diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index 420ee7b26580..373be970ec31 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -45,6 +45,9 @@ extern mempool_t netfs_request_pool;
 extern mempool_t netfs_subrequest_pool;
 extern mempool_t netfs_folioq_pool;
 
+#define mempool_alloc_element(_pool, _gfp)				\
+	alloc_hooks((_pool)->alloc(_gfp, (_pool)->pool_data))
+
 #ifdef CONFIG_PROC_FS
 static inline void netfs_proc_add_rreq(struct netfs_io_request *rreq)
 {
diff --git a/fs/netfs/objects.c b/fs/netfs/objects.c
index 01461a74642d..18f5c64d404e 100644
--- a/fs/netfs/objects.c
+++ b/fs/netfs/objects.c
@@ -34,7 +34,7 @@ struct netfs_io_request *netfs_alloc_request(struct address_space *mapping,
 
 		rreq = mempool_alloc(mempool, gfp);
 	} else {
-		rreq = mempool->alloc(gfp, mempool->pool_data);
+		rreq = mempool_alloc_element(mempool, gfp);
 		if (!rreq)
 			return ERR_PTR(-ENOMEM);
 	}
@@ -206,7 +206,7 @@ struct netfs_io_subrequest *netfs_alloc_subrequest(struct netfs_io_request *rreq
 	struct kmem_cache *cache = mempool->pool_data;
 
 	if (rreq->gfp == GFP_KERNEL)
-		subreq = mempool->alloc(rreq->gfp, mempool->pool_data);
+		subreq = mempool_alloc_element(mempool, rreq->gfp);
 	else
 		subreq = mempool_alloc(mempool, rreq->gfp);
 	if (!subreq)
diff --git a/fs/netfs/rolling_buffer.c b/fs/netfs/rolling_buffer.c
index 8c0026836f9c..d1ae6e081664 100644
--- a/fs/netfs/rolling_buffer.c
+++ b/fs/netfs/rolling_buffer.c
@@ -29,7 +29,7 @@ struct folio_queue *netfs_folioq_alloc(unsigned int rreq_id, gfp_t gfp,
 	struct folio_queue *fq;
 
 	if (gfp == GFP_KERNEL)
-		fq = netfs_folioq_pool.alloc(gfp, netfs_folioq_pool.pool_data);
+		fq = mempool_alloc_element(&netfs_folioq_pool, gfp);
 	else
 		fq = mempool_alloc(&netfs_folioq_pool, gfp);
 	if (fq) {
-- 
2.25.1

Thanks
Best Regards
Hao

> I'll look for a possible solution and then let you know.
> 
> Thanks for the report.
