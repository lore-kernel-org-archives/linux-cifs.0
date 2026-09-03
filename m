Received: from mta0.migadu.com (out-57.mta0.migadu.com [91.218.175.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72F743B6F5
	for <linux-cifs@vger.kernel.org>; Thu,  3 Sep 2026 10:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788432150; cv=none; b=D0yYgmpxB+pvLJBv1KJvyhXCHJf7GyCuugg5egMiJcHnCYAZde+Tzk42Yny36s7Fc9vPSDpous2WBh6Py6eagVPrQIMxzLLTaRhQuOr5XjtPyfL+gO5u0TYi1un6FipRdHOqjcqnhA8p5txNxKPsBG9AX4eiZguM8vzOBR5Vqu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788432150; c=relaxed/simple;
	bh=LY41AWwZgTNGgRkVR34EfSW+VvJaa0ABgmH1Yoknl/A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qcRwIiR1mrg/Hh7eWm8sjrct1hARZRwjfeFYqAdzZ48O8L+yrcj3xMpRSwnf29VL192rknrbewVJSDz262hIb5vRiVeJFcf//RRvjyn/0SIfHeQVTCaCWHES4TIiDmZombxQCCvVn/E53ZkLUXuKhb63vQNeCOpuAsRj7O5VhFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RfECx5lI; arc=none smtp.client-ip=91.218.175.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RfECx5lI"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=LY41AWwZgTNGgRkVR34EfSW+VvJaa0ABgmH1Yoknl/A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788432144; v=1; x=1789036944;
 b=RfECx5lIWKZIreKyAHTL9L7mW/SBKzqBFlOX0jJwgp6ws+wshw10mpjD63BH2fgtUfWBKS1q
 +hVaDaiWrvSug7BOhoLCRD6+O1Mi5GY9qRGmcaj1jpbX0nNXWGP30f332snFBaZY5gliykiVfJQ
 1NKfm0Zm7qYW2g4AfqN1Beww=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f601bdfda607a2b4;
	Thu, 03 Sep 2026 10:42:14 +0000
X-Mizu-Trace-ID: f601bdfda607a2b4
X-Migadu-Flow: FLOW_OUT
Message-ID: <46f83a1c-02ed-4c64-9eeb-2fc435fdfb24@linux.dev>
Date: Thu, 3 Sep 2026 12:42:09 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] RDMA/iwcm: allow aborting an active connect awaiting
 CONNECT_REPLY
To: Stefan Metzmacher <metze@samba.org>, Leon Romanovsky <leon@kernel.org>,
 Yunseong Kim <yunseong.kim@est.tech>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Jacob Moroni <jmoroni@google.com>,
 Bart Van Assche <bvanassche@acm.org>, Namjae Jeon <linkinjeon@kernel.org>,
 Tom Talpey <tom@talpey.com>, Yunseong Kim <yunseong.kim@ericsson.com>,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
References: <20260805000159.321645-2-yunseong.kim@est.tech>
 <20260901124103.GL24140@unreal>
 <47142579-3af7-453b-875c-ff6d610f26a7@samba.org>
From: Bernard Metzler <bernard.metzler@linux.dev>
In-Reply-To: <47142579-3af7-453b-875c-ff6d610f26a7@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 01.09.2026 18:50, Stefan Metzmacher wrote:
> Hi Leon,
> 
>> On Wed, Aug 05, 2026 at 02:02:00AM +0200, Yunseong Kim wrote:
>>> After a successful connect downcall, iw_cm_connect() returns with
>>> IWCM_F_CONNECT_WAIT still set and the cm_id in IW_CM_STATE_CONN_SENT.
>>> The only thing that clears the flag is the provider delivering
>>> IW_CM_EVENT_CONNECT_REPLY (cm_conn_rep_handler()).  Until that event
>>> arrives, iw_cm_disconnect() and destroy_cm_id() sleep uninterruptibly
>>> in
>>>
>>>     wait_event(cm_id_priv->connect_wait,
>>>            !test_bit(IWCM_F_CONNECT_WAIT, &cm_id_priv->flags));
>>>
>>> and both state machines treat IW_CM_STATE_CONN_SENT as BUG(), so the
>>> API has no way to cancel a pending active connect.  If the provider
>>> never generates the reply, because the peer died in the middle of
>>> connection setup or because of a provider bug, every teardown path
>>> (rdma_disconnect(), rdma_destroy_id()) blocks in D state forever and
>>> the ULP cannot recover: there is no way to disconnect after
>>> rdma_connect() was called without risking an unbounded hang.
>>>
>>> This class of problem is not theoretical.  The pending smbdirect
>>> change "smb: smbdirect: bound the disconnect wait in destroy_sync" [1]
>>> had to work around it on the ULP side:
>>> smbdirect_socket_destroy_sync() waited unbounded for the socket to
>>> reach SMBDIRECT_SOCKET_DISCONNECTED, a transition that depends on an
>>> asynchronous RDMA CM disconnect event, and when the peer died abruptly
>>> (a killed client, or Soft-RoCE/RXE where no graceful disconnect
>>> completes) that event never arrived.  The destroy ran on the single
>>> ksmbd-conn-release workqueue, every later connection release queued
>>> behind it in D state, and the whole server wedged until hung_task
>>> fired.  That change bounded the wait and drove the socket state
>>> machine to DISCONNECTED locally on timeout; ULPs should not have to
>>> resort to that, the CM should offer a teardown they can rely on.
>>>
>>> IWCM_F_CONNECT_WAIT currently guards two different windows:
>>>
>>>   * the connect/accept downcall into the provider being in progress;
>>>     teardown must keep waiting for that, it is short and bounded;
>>>
>>>   * an issued active connect waiting for CONNECT_REPLY, which is
>>>     potentially unbounded.
>>>
>>> Mark the second window with a new flag, IWCM_F_CONNECT_SENT: set by
>>> iw_cm_connect() once the downcall has returned successfully, cleared
>>> by cm_conn_rep_handler().  The teardown waits now complete when either
>>> the downcall has finished (!IWCM_F_CONNECT_WAIT, as before) or the
>>> pending-reply window has been entered (IWCM_F_CONNECT_SENT), and the
>>> previously BUG() CONN_SENT cases become:
>>>
>>>   * iw_cm_disconnect(): return -ENOTCONN; there is no established
>>>     connection to disconnect, aborting is the destroy path's job;
>>>
>>>   * destroy_cm_id(): abort the pending connect locally by moving to
>>>     DESTROYING and putting the QP into error so the provider tears the
>>>     connection attempt down.
>>>
>>> A CONNECT_REPLY that arrives after the abort is dropped: either
>>> cm_work_handler() sees IWCM_F_DROP_EVENTS, or cm_conn_rep_handler()
>>> now recognizes IW_CM_STATE_DESTROYING (the abort and the reply
>>> serialize on cm_id_priv->lock) and frees the event without touching
>>> the QP that destroy_cm_id() already released.  The cm_id memory stays
>>> valid for such a late reply because the provider holds its own
>>> reference (cm_id->add_ref) for as long as it can deliver events.
>>>
>>> The passive side has a sibling gap, where after a successful accept
>>> downcall the flag stays set until the provider's ESTABLISHED event
>>> arrives, which this patch deliberately does not change.
>>>
>>> [1] https://github.com/smfrench/smb3-kernel/commit/26d0f82a02c8a9c9c8cdfc138acb7ed0bf8e01a9
>>>
>>> Suggested-by: Stefan Metzmacher <metze@samba.org>
>>> Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
>>> ---
>>>   drivers/infiniband/core/iwcm.c | 76 +++++++++++++++++++++++++++++-----
>>>   drivers/infiniband/core/iwcm.h |  1 +
>>>   2 files changed, 67 insertions(+), 10 deletions(-)
>>
>> I'm not sure what to do with this patch, as the iWARP folks have
>> remained silent.
>>
>> Stefan,
>>
>> Do you still need this patch? Have you tested it?
> 
> I'll test it soon.
> 
> But the problem is real and I hit it very often in the past and the only option
> was a reboot.
> 
> I added Bernard explicitly...
> 
> metze
> 
I follow Yunseong's and Stefan's argumentation.

Thanks,
Bernard.
