Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793703149;
	b=4bX2qH75qrdpVhUut6LTCc7XO5yKW5JBnFvqCeOmMfWYhFi4nwdGJRnm29kibPM4Gp4r
	 AMWy1iic5C6VxIa8YMPho3kJrBpJSj0rWucddBUAWzcdp/DjNkqxB+r2F+D+QqBP9lHH2
	 Za6GvFQaOAbpt5ccICfWrCA7FGdeWWcBMMKkL+mvgcTpr0ef/CwhEd8kwV2ETFf5smOnx
	 Y4GMDpYGb1lVhbTFbEDZGTsl4CkAyyApmNeVGAD5JuCoCmeHjvKaGFFVJjV81fii7k3nk
	 ZRn91Z2CwBw4B85u+s7OXxyUvgEv0SrrXL4aIu9kR4KinJ0j4XecjvFc1WcXODXtVIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793703149;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=I724FaHvX66qo0qelVXw4qS4NCIiJfupxxzGOtyDOC0=;
	b=0+jgWEit9eQMTKUpKMCRBMEzOePGN9wqRmBZ87x9LkPo/n34X3UzvSYzLOi57SkjP4c2
	 3xdkSo0WvsNNot3nj9FSFRl9ofAQRq386s0FtsLPXnoGVAi+D+MLAnSyUjFynYmjiSh11
	 kJqd84vZ3BeTzl+XndQIZCDw4AP0Yc3qbV/Pla91kLgrtExutgBPj6Ys4CNSdWYqI1j9p
	 MAbI2yaYIa2GMEFIpHP5ORRM+K9QbWiSl0jAuo4nEIVOE/Zvs2wUt/d167h9xAgpyL6dF
	 2l8uGkGPWGEfa7AV1Bi6i7vOBPkzXFWlv2ewgCeZ/otzc2Q0lkcu855EtbxBiczqb0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=kx0sWc79;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0D96074A21;
	Tue,  3 Nov 2026 10:52:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA0D96074A21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key, unprotected) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=kx0sWc79
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=I724FaHvX66qo0qelVXw4qS4NCIiJfupxxzGOtyDOC0=; b=kx0sWc79yBpgulQeghFlm5vQC0
	THDpZu4qaV+lQ5xtpl1gVDyNubQefBVccd0JLMybKpIUMC6T8EWN4LUJWADXMUXqmRy/GFdiyNWgN
	cNUf3PiOg/uR2Mq316xDdIo1sNblYRSBKS62n3fEYfZ5DhRenQBmq5Gro2iRPT8YH57Fa1HDL3izD
	AuIHbYkGe4DBmCj93iLr3LGqakDPobG8J3aDC1qMrXhTlLHCksrG5lKa7k1dXyLaxx2hYUsx4+9u1
	ZxLwGeBemN1SdPNxweFTY1fCSwGX9/9sAf0VUR5OLCAihzklywKq/Fw2p0MTrwoKnBsTp+THuD4PD
	5X781qrGPLL9Rg84v1U8RWYhArwhS9izPh7su6NW7YOPiB52VhAAJ4sAKTGBwU02iFDityATq9l1y
	Gx9FaKz8slMHHsa6KOxhvmatt12pIIFsVDkSNYD8M6Qf5EKprLlzBE8CwWMHX1SkpxjD7H5IixG+b
	bFzGOd07yI29M4gW8JA9Hctc;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xOC7m-00000007rCX-2Kwn;
	Tue, 03 Nov 2026 10:52:18 +0000
Message-ID: <06605c4c-40bf-4dae-a961-a8742fc53de1@samba.org>
Date: Tue, 3 Nov 2026 11:52:17 +0100
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] RDMA/iwcm: allow aborting an active connect awaiting
 CONNECT_REPLY
To: Yunseong Kim <yunseong.kim@est.tech>,
 Bernard Metzler <bernard.metzler@linux.dev>,
 Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Jacob Moroni <jmoroni@google.com>,
 Bart Van Assche <bvanassche@acm.org>, Namjae Jeon <linkinjeon@kernel.org>,
 Tom Talpey <tom@talpey.com>, Yunseong Kim <yunseong.kim@ericsson.com>,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20260805000159.321645-2-yunseong.kim@est.tech>
 <20260901124103.GL24140@unreal>
 <47142579-3af7-453b-875c-ff6d610f26a7@samba.org>
 <46f83a1c-02ed-4c64-9eeb-2fc435fdfb24@linux.dev>
 <473d9515-b951-4cff-a553-b8ed471d0112@samba.org>
 <22e50a64-ea78-4ac7-8680-845b7651db07@est.tech>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <22e50a64-ea78-4ac7-8680-845b7651db07@est.tech>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Yunseong,

> On 16/10/2026 11:25 am, Stefan Metzmacher wrote:
>> Am 03.09.26 um 12:42 schrieb Bernard Metzler:
>>> On 01.09.2026 18:50, Stefan Metzmacher wrote:
>>>> Hi Leon,
>>>>
>>>>> On Wed, Aug 05, 2026 at 02:02:00AM +0200, Yunseong Kim wrote:
>>>>>> [snip...]
>> It actually still hangs in here:
>>
>>      For an active iWarp connect that is still waiting for the MPA reply
>>      (e.g. the peer accepted the TCP connection, but never answers the
>>      MPA request), irdma doesn't flush the marker before the pending
>>      connect is aborted, which only happens in rdma_destroy_id().
>>      smbdirect_socket_destroy_sync() calls ib_drain_qp() before that, so
>>      it waits forever:
>>
>>        __ib_drain_sq+0x139/0x1b0 [ib_core]
>>        ib_drain_sq+0x7f/0x90 [ib_core]
>>        ib_drain_qp+0x16/0x40 [ib_core]
>>        smbdirect_socket_destroy_sync+0x2bd/0xa90 [smbdirect]
>>        smbdirect_socket_release+0x61/0xb0 [smbdirect]
>>        smbd_get_connection+0x22c/0x280 [cifs]
>>
>>
>> Here's my work in progress branch to fix these problems:
>> https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/for-7.3/rdma-backport-testing
> 
> Thank you again for checking this!
> 
>> There I'm able to eliminate all hangs I was able to reproduce with siw, rxe, iw_cxgb4, irdma, mlx5_ib.
>> I tested the following situations:
>> - server iptables drop (port 5445 and 4791)
>> - server nc -lk 5445 (tcp connection accepted by no responses)
>> - ip address del (on the client)
>> - ip link down (on the client)
>>
>> It likely takes a while until I rechecked all commits
>> and submit them in small chunks, but it's good to see
>> that it's possible to avoid deadlocks or very large timeouts.
>>
>> So at least that patch doesn't solve all problems.
>>
>> metze
> 
> I'll also rerun my automated tests based on your branch when I have some time.

Please use for-7.5/smbdirect there I need to recheck after a rebase to v7.4-rc1,
but the core of changes worked and fixed a lot of hangs and deadlocks
when based on v7.3-rc6.

I'll post individual chunks of it, while the long term big picture can be found in
the master-ipproto-smbdirect branch.

Thanks!
metze
