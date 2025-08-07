Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D392202C2B;
	Thu,  7 Aug 2025 05:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754544187; cv=none; b=T3/eRWBF1o5c9YNKdvnpYVHQ5VUi6KiFzAqu1EGeEBLA8spcEZr88hIJUNcSxR2qo6TCYFRsphxHnW3vv/2QtQBjU9WiJngzSfFxsu+a5nsLRqtvE+A0m+KQ6zu97wdaTobrJMKb8DaMQnclZtjo3WLs+ms1CTiPt4iHnTQg03E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754544187; c=relaxed/simple;
	bh=YUwPmVrn6K2WFWpNlidZfL01eDYcnmOzCwGou+i6x2c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tmXgVbw5yykOS78TdDWRTH/+duxL5Mb6nIyoKpibmoDmu8HxbC889MlBMXFYTtzJ9II9MWJ0cNA+5OqF+a5Lh5/Mz85rSBFwIrXDybCsPapfZ8ocIaFqY9Qds7DhsImeTvuJtA0s8jd7YdIUOxEAqQH8NSeOk+G2asjdw5nTPhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Vq5WqrP5; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Vq5WqrP5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=6ru3pRMmGQBukf0GXDQ/g5j3M3KKaVhfWOPVpl/umhc=; b=Vq5WqrP5sCnEvoutdYsokfVsMf
	puYtQ4sXLtLpyQw798T5IYTufDecgUn9jvpe8ZXggb1yK/ztZs/dPthYClJzNGwQ3JgXw/yhUIDFT
	0CqzMHqZW4lhae7W/B3/ElhzvsaYlsI1oyeHHAxAh6PbToi/+jTxtkx9kcerKNDhnvNme1t/SYKeC
	6SCrJ8AE9C9GaUJJjPz8lhIkNBfs7MZbBFT84E85g+cStBtmIBTcxnpzZdzyTcwBM5ScvpgfpV4EI
	ZP4zGzxUUU/s7OK423tOcX6kAAG0GoHjX5AFCuMG9wvFLjgSZ7BwjB8gO9qIbYA2T7fk3cEuLhojf
	Q4AbssGH+Arr+52LWDYG1qrJkZsYlz0hZA3bvFPbJgKSbKRr53Ep5q3LRb6O0Uk0YWm2Ww+q+O9kr
	6XxeVXepCN7PEYIb60tRKetKkWYL/yMrlHJ0E9L1RLPSChpjCFpI+TrHA4/aP7NwO9xryYs60t1W+
	RXiOAqwArVUd3Y4tynEc/O84;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ujt5h-001UId-0n;
	Thu, 07 Aug 2025 05:23:01 +0000
Message-ID: <c213ace1-7845-4454-a746-8a5926ab41d0@samba.org>
Date: Thu, 7 Aug 2025 07:23:00 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/31] netfs: [WIP] Allow the use of MSG_SPLICE_PAGES
 and use netmem allocator
To: David Howells <dhowells@redhat.com>, Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>, Shyam Prasad N
 <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Wang Zhaolong <wangzhaolong@huaweicloud.com>,
 Mina Almasry <almasrymina@google.com>, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250806203705.2560493-1-dhowells@redhat.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20250806203705.2560493-1-dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi David,

> The aim is to build up a list of fragments for each request using a bvecq.
> These form a segmented list and can be spliced together when assembling a
> compound request.  The segmented list can then be passed to sendmsg() with
> MSG_SPLICE_PAGES in a single call, thereby only having a single loop (in
> the TCP stack) to shovel data, not loops-over-loops.  Possibly we can
> dispense with corking also, provided we can tell TCP to flush the record
> boundaries.  (Note that this also simplifies smbd_send() for RDMA).

I didn't look at the patches in detail, but I like the simplifications
for the transport layer and that hopefully allows me to
move smbd_send() behind sendmsg() with MSG_SPLICE_PAGES in the end.

So the current situation is that we memcpy (at least) in sendmsg()
and with your patches we do a memcpy higher in the stack, but then
use MSG_SPLICE_PAGES in order to do it twice. Is that correct?

Thanks!
metze
