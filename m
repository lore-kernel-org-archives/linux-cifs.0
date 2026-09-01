Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054BC383306;
	Tue,  1 Sep 2026 23:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788304779; cv=none; b=NMbAT+iR2vEYwHJBIYU8dxB0+9VlqZeEfjX/3+Ci6trwxYFqeYwjdGm2D8i85kPL4oDV7kGOBdchGNCZ/TrXauX0AXKrVwFxpMWC2HLs8z4fME3pHd6xvs0pNcAkJ4ECJYfnRci2pQQJd8W332+RPCmXj5AG0OAIAPlOhkBh61I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788304779; c=relaxed/simple;
	bh=Lze/+TCUstK3y+dtKoHqgs5paw4KD+vu7hVBpTs8qgw=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=YnFYJjrvIgIOKUJ+nf2MHAz7RWpyod/itRN+LNTXozz12brcObms2lssB3kA0AIs1cNWblxNBNz5tKkrcTcyRoXFlX0Fwp0tMcO+raj0h0BCC5gdHHOX+zV9HdebROI3ERPhXu5lvGwZxy9xmZ0GOyr7+bw3QBa34oswhKzc6wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=1Z6yT3Qy; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="1Z6yT3Qy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qKjdx9HaXUprHp4cBWsJINyVzLHc1vdbhmDiVrRhpAk=; b=1Z6yT3QyHBzOZ6/8SrfWQtO1XB
	YbQ8QS6gc13actNBe6nFCTsU3/NAn6TPeCkk1ZXDX9IkoKexu5sbj3WuTdIq45maxGjuhf79OZK6n
	mVtgxKgL93Byy5NdWewaaPyhCEmIHOjYmCenC9gcBHbCMUixJilN8LUaQRmU5MQodbT5XR0bJUysx
	ACRAKh/rdHA8nWeOx/TFlPMM5Bz+VS2xGMeRibO1TXAyNvQU4Rw1PuSeDekSBovMbkY4696bkr3Do
	1Zn4+oQ/VlxH8u4EjKN8r+KjwmspbIoWL0irA+d5n+OXYwFX94CBYCwXdOCIflXp24Op0T0Slupox
	dh2YbrMw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x1XlI-00000000Sld-1OG4;
	Tue, 01 Sep 2026 20:19:28 -0300
Message-ID: <0e8961201179ba88038de511c587ddc7@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Erhard Furtner <erhard_f@mailbox.org>, linux-kernel@vger.kernel.org
Cc: linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>,
 netfs@lists.linux.dev
Subject: Re: client side "current->alloc_tag not set WARNING:
 ./include/linux/alloc_tag.h:161" at accessing CIFS share
In-Reply-To: <0b004319-9ef7-437c-a4dd-174d6a9a83db@mailbox.org>
References: <0b004319-9ef7-437c-a4dd-174d6a9a83db@mailbox.org>
Date: Tue, 01 Sep 2026 20:19:27 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Erhard Furtner <erhard_f@mailbox.org> writes:

> Getting this "current->alloc_tag not set WARNING:" every time on my 
> client PC when I open files on the CIFS share (exported via KSMBD) from 
> my host PC:

The warning is triggered by running the following in
netfs_alloc_request() with CONFIG_MEM_ALLOC_PROFILING_DEBUG=y kernels:

        rreq = mempool->alloc(gfp, mempool->pool_data);

for the non-writeback path.

@mempool->alloc is set to mempool_alloc_slab(), which calls
kmem_cache_alloc_noprof() directly and expects the caller to have
already set current->alloc_tag.

It doesn't occur in the writeback path, however, because we call
mempool_alloc() macro that wraps to

        alloc_hooks(mempool_alloc_noprof(...))

and it sets current->alloc_tag before the allocation.

I'll look for a possible solution and then let you know.

Thanks for the report.
