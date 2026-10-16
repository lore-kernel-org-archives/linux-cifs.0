Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E6E46A5F2;
	Fri, 16 Oct 2026 09:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792142734; cv=none; b=hO0k/VpsLqZF+Q7wZx3Tt62utOEGyipejSnzsgJRQvdicCwcSAJFrkupzWFNGXJdljGX09t1AkP7MLrQSGejuv3cIcSoTjFydC32m2dGs/0F17Re0s+ep2ROUfq+jw5FYNYqzKF0r8gzj29ap04Cg/AcD9QcQFMN4vJ3hhf5WW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792142734; c=relaxed/simple;
	bh=CdGqR/CPgTmzueiHF/jTYAn2Xbt4dYm9NhCQwTt99mo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=poallTJ4f58QpGzX6pCVJ9k8BYYFb7PwrXxnwdH6dPEFpaPV9mgrq4K7Cofl6kawrqi2+QIq1OO2xkBG76vw6nO3syqvCSZVYx3b5ktwOY7cghh/oOh0rFcwsZnT+RxcnSqJuKXV8b2Qqm1VtwmlOp8OvaO2qnmUpZninelnMek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=eIuIMDVj; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="eIuIMDVj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=PDojlLCVuBUweMTHHqbhfCIgU/dCgFlQCc4LCljaO18=; b=eIuIMDVjH4CtokX230CGJ4NHsm
	TcWEC9B58Z0t7sbtI50mMSVfirFgCflWMGKITkvSERg+nMTe9UMyo9+VrRHPN1qIqO/cvKAT+C9kS
	wAE1LhErVQBbNquHUXKb/5X6Ca/u21QTKXIIj/SivYgv6CMu5xogyqFdwYjACqwIxP9YzK3OguHph
	MAkPw8PqDTK305/yqnvp0oRZybb9yaE27cxD6IepnE0pIQmHMYXjQNdiJINRV+5gf4aaO0AqF1IV0
	CNdQ7COmXZ29Bkfwlsh4p1LDbOdQS91FBKcBEuUc9cPXIAISAcQY/i/9eDuTQd4AIPz0MxFoABNpd
	VThvFjV6F//uCFpeEVnHCKVeeHx4vVCoTPXmfMXlwivg6eXE9RO3g7Zq36ppXDySHQ2sMWpjUGYgO
	ygkJwJwzWimNMckIWhrufvl7s1zdjFFX+ydlTbRDqNaRVaSs+HnkZs//J7AzqOt1Qw7LVq7iPfSlk
	cecxSa/FUxLnMVqg8s6aFoxT;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xHeBq-00000002Ypa-3fKM;
	Fri, 16 Oct 2026 09:25:27 +0000
Message-ID: <473d9515-b951-4cff-a553-b8ed471d0112@samba.org>
Date: Fri, 16 Oct 2026 11:25:26 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] RDMA/iwcm: allow aborting an active connect awaiting
 CONNECT_REPLY
To: Bernard Metzler <bernard.metzler@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Yunseong Kim <yunseong.kim@est.tech>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Jacob Moroni <jmoroni@google.com>,
 Bart Van Assche <bvanassche@acm.org>, Namjae Jeon <linkinjeon@kernel.org>,
 Tom Talpey <tom@talpey.com>, Yunseong Kim <yunseong.kim@ericsson.com>,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20260805000159.321645-2-yunseong.kim@est.tech>
 <20260901124103.GL24140@unreal>
 <47142579-3af7-453b-875c-ff6d610f26a7@samba.org>
 <46f83a1c-02ed-4c64-9eeb-2fc435fdfb24@linux.dev>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <46f83a1c-02ed-4c64-9eeb-2fc435fdfb24@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 03.09.26 um 12:42 schrieb Bernard Metzler:
> On 01.09.2026 18:50, Stefan Metzmacher wrote:
>> Hi Leon,
>>
>>> On Wed, Aug 05, 2026 at 02:02:00AM +0200, Yunseong Kim wrote:
>>>> After a successful connect downcall, iw_cm_connect() returns with
>>>> IWCM_F_CONNECT_WAIT still set and the cm_id in IW_CM_STATE_CONN_SENT.
>>>> The only thing that clears the flag is the provider delivering
>>>> IW_CM_EVENT_CONNECT_REPLY (cm_conn_rep_handler()).  Until that event
>>>> arrives, iw_cm_disconnect() and destroy_cm_id() sleep uninterruptibly
>>>> in
>>>>
>>>>     wait_event(cm_id_priv->connect_wait,
>>>>            !test_bit(IWCM_F_CONNECT_WAIT, &cm_id_priv->flags));
>>>>
>>>> and both state machines treat IW_CM_STATE_CONN_SENT as BUG(), so the
>>>> API has no way to cancel a pending active connect.  If the provider
>>>> never generates the reply, because the peer died in the middle of
>>>> connection setup or because of a provider bug, every teardown path
>>>> (rdma_disconnect(), rdma_destroy_id()) blocks in D state forever and
>>>> the ULP cannot recover: there is no way to disconnect after
>>>> rdma_connect() was called without risking an unbounded hang.
>>>>
>>>> This class of problem is not theoretical.  The pending smbdirect
>>>> change "smb: smbdirect: bound the disconnect wait in destroy_sync" [1]
>>>> had to work around it on the ULP side:
>>>> smbdirect_socket_destroy_sync() waited unbounded for the socket to
>>>> reach SMBDIRECT_SOCKET_DISCONNECTED, a transition that depends on an
>>>> asynchronous RDMA CM disconnect event, and when the peer died abruptly
>>>> (a killed client, or Soft-RoCE/RXE where no graceful disconnect
>>>> completes) that event never arrived.  The destroy ran on the single
>>>> ksmbd-conn-release workqueue, every later connection release queued
>>>> behind it in D state, and the whole server wedged until hung_task
>>>> fired.  That change bounded the wait and drove the socket state
>>>> machine to DISCONNECTED locally on timeout; ULPs should not have to
>>>> resort to that, the CM should offer a teardown they can rely on.
>>>>
>>>> IWCM_F_CONNECT_WAIT currently guards two different windows:
>>>>
>>>>   * the connect/accept downcall into the provider being in progress;
>>>>     teardown must keep waiting for that, it is short and bounded;
>>>>
>>>>   * an issued active connect waiting for CONNECT_REPLY, which is
>>>>     potentially unbounded.
>>>>
>>>> Mark the second window with a new flag, IWCM_F_CONNECT_SENT: set by
>>>> iw_cm_connect() once the downcall has returned successfully, cleared
>>>> by cm_conn_rep_handler().  The teardown waits now complete when either
>>>> the downcall has finished (!IWCM_F_CONNECT_WAIT, as before) or the
>>>> pending-reply window has been entered (IWCM_F_CONNECT_SENT), and the
>>>> previously BUG() CONN_SENT cases become:
>>>>
>>>>   * iw_cm_disconnect(): return -ENOTCONN; there is no established
>>>>     connection to disconnect, aborting is the destroy path's job;
>>>>
>>>>   * destroy_cm_id(): abort the pending connect locally by moving to
>>>>     DESTROYING and putting the QP into error so the provider tears the
>>>>     connection attempt down.
>>>>
>>>> A CONNECT_REPLY that arrives after the abort is dropped: either
>>>> cm_work_handler() sees IWCM_F_DROP_EVENTS, or cm_conn_rep_handler()
>>>> now recognizes IW_CM_STATE_DESTROYING (the abort and the reply
>>>> serialize on cm_id_priv->lock) and frees the event without touching
>>>> the QP that destroy_cm_id() already released.  The cm_id memory stays
>>>> valid for such a late reply because the provider holds its own
>>>> reference (cm_id->add_ref) for as long as it can deliver events.
>>>>
>>>> The passive side has a sibling gap, where after a successful accept
>>>> downcall the flag stays set until the provider's ESTABLISHED event
>>>> arrives, which this patch deliberately does not change.
>>>>
>>>> [1] https://github.com/smfrench/smb3-kernel/commit/26d0f82a02c8a9c9c8cdfc138acb7ed0bf8e01a9
>>>>
>>>> Suggested-by: Stefan Metzmacher <metze@samba.org>
>>>> Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
>>>> ---
>>>>   drivers/infiniband/core/iwcm.c | 76 +++++++++++++++++++++++++++++-----
>>>>   drivers/infiniband/core/iwcm.h |  1 +
>>>>   2 files changed, 67 insertions(+), 10 deletions(-)
>>>
>>> I'm not sure what to do with this patch, as the iWARP folks have
>>> remained silent.
>>>
>>> Stefan,
>>>
>>> Do you still need this patch? Have you tested it?
>>
>> I'll test it soon.
>>
>> But the problem is real and I hit it very often in the past and the only option
>> was a reboot.
>>
>> I added Bernard explicitly...
>>
>> metze
>>
> I follow Yunseong's and Stefan's argumentation.
It actually still hangs in here:

     For an active iWarp connect that is still waiting for the MPA reply
     (e.g. the peer accepted the TCP connection, but never answers the
     MPA request), irdma doesn't flush the marker before the pending
     connect is aborted, which only happens in rdma_destroy_id().
     smbdirect_socket_destroy_sync() calls ib_drain_qp() before that, so
     it waits forever:

       __ib_drain_sq+0x139/0x1b0 [ib_core]
       ib_drain_sq+0x7f/0x90 [ib_core]
       ib_drain_qp+0x16/0x40 [ib_core]
       smbdirect_socket_destroy_sync+0x2bd/0xa90 [smbdirect]
       smbdirect_socket_release+0x61/0xb0 [smbdirect]
       smbd_get_connection+0x22c/0x280 [cifs]


Here's my work in progress branch to fix these problems:
https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/for-7.3/rdma-backport-testing
There I'm able to eliminate all hangs I was able to reproduce with siw, rxe, iw_cxgb4, irdma, mlx5_ib.
I tested the following situations:
- server iptables drop (port 5445 and 4791)
- server nc -lk 5445 (tcp connection accepted by no responses)
- ip address del (on the client)
- ip link down (on the client)

It likely takes a while until I rechecked all commits
and submit them in small chunks, but it's good to see
that it's possible to avoid deadlocks or very large timeouts.

So at least that patch doesn't solve all problems.

metze



