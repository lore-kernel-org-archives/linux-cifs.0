Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2D53ED128;
	Wed, 15 Apr 2026 16:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776272158; cv=none; b=I8xQpZiOR6mUt5aTR/6ORHolT4xJ1n+SAXudms5MiU9T+OPCvuT8mVQKAlRdNW32MqvR7udtNz7lv0sGeT6m4CUNtiVVLO+eH+O/OB3AS40EPxtTUUYKhjpF47XZ9oUX+7jqTkBZPeu9beUr3q/jaAFQO/tSU8T/7TAuP00XoG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776272158; c=relaxed/simple;
	bh=3zdXh2dalBTKnUssNKrWJ6LbV+aO+DH6lNBP0AFCs8Q=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=OXUhDCkNCPvmx9CdO3Na8xtWbbSpE/61sl134fbQzCzgbyERaTFKHc7DbZsj8sXublTfG8hrokJs6roS4+RCwKxJ1/RQGgYRAiyiD2aJjZIcUG5Sg6v626+qOQh8iDeTSpdeq7KdjtAk12NtNxt8R8BCGBsZFDpymX/s4UVKbbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=fkn9Czsk; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="fkn9Czsk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=G0wxnBD19pxGllyq/0BhmejPLNCG8kCLWDn3dt7AqoM=; b=fkn9Czsk2ZH8Z1eJ/BOFUprGgJ
	yHBzJKBeMIgd1M7DXqNXTjQdfFiD09lkxQhjyiJ4T217VB1TY6QfxIrUJGAS43sj88Z9+GBxHpzYV
	BWQDvIuZEiOXGp5fJT6D02R1Qqsx3jaRhvXPoKLAo3OMcvNGGMJhjmB/m8yceNvoXcMWnCrXQ2Zr5
	GLEiiNNTx9WDd/qmRVRkxj2//UOGcGRlxfIP/faLEhv/CPHvZtUT8xjnUXcwCaPHax5/tFF70Sjyl
	VPObTljCkHhmYBGnd+U3ei/UFhiMSARHG33EuRBoO+RWo6XGbVebCgkhtdVaEiuQzoOWETbO7IW7L
	eGWfNcdg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.1)
	id 1wD3Wd-00000000E9c-1YgW;
	Wed, 15 Apr 2026 13:55:39 -0300
Message-ID: <2feeb396883d9223862e036b76092a1f@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: David Howells <dhowells@redhat.com>, Christian Brauner
 <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>, netfs@lists.linux.dev,
 linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
 ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] netfs: Fix early put of sink folio in netfs_read_gaps()
In-Reply-To: <261128.1776251770@warthog.procyon.org.uk>
References: <261128.1776251770@warthog.procyon.org.uk>
Date: Wed, 15 Apr 2026 13:55:37 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

David Howells <dhowells@redhat.com> writes:

> Fix netfs_read_gaps() to release the sink page it uses after waiting for
> the request to complete.  The way the sink page is used is that an
> ITER_BVEC-class iterator is created that has the gaps from the target folio
> at either end, but has the sink page tiled over the middle so that a single
> read op can fill in both gaps.
>
> The bug was found by KASAN detecting a UAF on the generic/075 xfstest in
> the cifsd kernel thread that handles reception of data from the TCP socket:
>
>  BUG: KASAN: use-after-free in _copy_to_iter+0x48a/0xa20
>  Write of size 885 at addr ffff888107f92000 by task cifsd/1285
>  CPU: 2 UID: 0 PID: 1285 Comm: cifsd Not tainted 7.0.0 #6 PREEMPT(lazy)
>  Call Trace:
>   dump_stack_lvl+0x5d/0x80
>   print_report+0x17f/0x4f1
>   kasan_report+0x100/0x1e0
>   kasan_check_range+0x10f/0x1e0
>   __asan_memcpy+0x3c/0x60
>   _copy_to_iter+0x48a/0xa20
>   __skb_datagram_iter+0x2c9/0x430
>   skb_copy_datagram_iter+0x6e/0x160
>   tcp_recvmsg_locked+0xce0/0x1130
>   tcp_recvmsg+0xeb/0x300
>   inet_recvmsg+0xcf/0x3a0
>   sock_recvmsg+0xea/0x100
>   cifs_readv_from_socket+0x3a6/0x4d0 [cifs]
>   cifs_read_iter_from_socket+0xdd/0x130 [cifs]
>   cifs_readv_receive+0xaad/0xb10 [cifs]
>   cifs_demultiplex_thread+0x1148/0x1740 [cifs]
>   kthread+0x1cf/0x210
>
> Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
> Reported-by: Steve French <sfrench@samba.org>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Paulo Alcantara <pc@manguebit.org>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: netfs@lists.linux.dev
> cc: linux-fsdevel@vger.kernel.org
> ---
>  fs/netfs/buffered_read.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
