Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD96399D00;
	Tue,  1 Sep 2026 16:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788281431; cv=none; b=t3x1MERKW3y7kZo+nW5osx+ythqvV1cdUo4gsZJXbaRLzU4o8Pf4Lg8RGsH5PMPGJw9gFy3+oRDK+tQiqJ9KFVmIzJenPo2vBb+e7o9xRVvoezwA2DrFPyRldd7fGshM0hLubpzaktBgZE3fRdZpM5nL9pPnWP8op1MFZZdlS6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788281431; c=relaxed/simple;
	bh=SDOwRP58mmnKlrUHlccngVQYFwJN3D63qUx2AYvxIKE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gQ/UcgC7BvCxI+dpKwrz+ezqo98DTRU3/3F+MP4dgg6eKBEUjGWwXq2hfBQeCJ4Fd3yn29zBE7V/Foyhv//f5eHipF3MzVf9tTnYCemKSs1f2bZ7aYTcZWZqRXw/8VxzbWnzzF7WRvgLtkhVZQPiDrM5afkvmnTErEpvbQkgrXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=VPmxNb81; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="VPmxNb81"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=C30V8qWM8Ula8+RBcfws0g6Mkjg3NA2ZsU4qGPGdJpk=; b=VPmxNb81eFyfOgf41a72wjEHKf
	VWtl5rilUbWLhd3Ag+s8wGuWXK/MHFl/l3jpHoinBn0VaJQTC4a3ZBMlgiuxXtPzLfpRLFnTo0gMt
	yr0mpLzhEcvf96lznYG5lDpBJTELFMuhSnZ1x6kGpWvrQPBfa6Rb7Dqugb/gODCE+9122JQ8WkxNx
	hKRCQuRkd2ZH25o2eDWAT30xsruNPeacFiovgHMeN4NuVbRoOKImWgs9EM505OLHnfKl7ZJzenir3
	HLljfqgOmt1LwqNK9enMIGeI5bAhInphbI5ncZcbMzodhHW2hhOBWQKs6z6S1fQ88OKNLw6E+U6N5
	aT2h94xtYjeyeaEjvYYkg5Ow/wqDrYSxftOgiT8Rg1w1pcWDOHUntfOLMg7KJIF0OryuyxBT4733M
	S26EBYmF76txlsiPae8TZgp1aZCTS9kN6pks2W1HG36GIWBNQGdCr2sXQexxsh0Y8fU8pSKC5HeKZ
	TI4KU7YJBztMejqMf4DxnNJv;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1x1Rgg-00000002P6e-0jyo;
	Tue, 01 Sep 2026 16:50:18 +0000
Message-ID: <47142579-3af7-453b-875c-ff6d610f26a7@samba.org>
Date: Tue, 1 Sep 2026 18:50:15 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] RDMA/iwcm: allow aborting an active connect awaiting
 CONNECT_REPLY
To: Leon Romanovsky <leon@kernel.org>, Yunseong Kim <yunseong.kim@est.tech>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Jacob Moroni <jmoroni@google.com>,
 Bart Van Assche <bvanassche@acm.org>, Namjae Jeon <linkinjeon@kernel.org>,
 Tom Talpey <tom@talpey.com>, Yunseong Kim <yunseong.kim@ericsson.com>,
 linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 Bernard Metzler <bernard.metzler@linux.dev>
References: <20260805000159.321645-2-yunseong.kim@est.tech>
 <20260901124103.GL24140@unreal>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20260901124103.GL24140@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Leon,

> On Wed, Aug 05, 2026 at 02:02:00AM +0200, Yunseong Kim wrote:
>> After a successful connect downcall, iw_cm_connect() returns with
>> IWCM_F_CONNECT_WAIT still set and the cm_id in IW_CM_STATE_CONN_SENT.
>> The only thing that clears the flag is the provider delivering
>> IW_CM_EVENT_CONNECT_REPLY (cm_conn_rep_handler()).  Until that event
>> arrives, iw_cm_disconnect() and destroy_cm_id() sleep uninterruptibly
>> in
>>
>> 	wait_event(cm_id_priv->connect_wait,
>> 		   !test_bit(IWCM_F_CONNECT_WAIT, &cm_id_priv->flags));
>>
>> and both state machines treat IW_CM_STATE_CONN_SENT as BUG(), so the
>> API has no way to cancel a pending active connect.  If the provider
>> never generates the reply, because the peer died in the middle of
>> connection setup or because of a provider bug, every teardown path
>> (rdma_disconnect(), rdma_destroy_id()) blocks in D state forever and
>> the ULP cannot recover: there is no way to disconnect after
>> rdma_connect() was called without risking an unbounded hang.
>>
>> This class of problem is not theoretical.  The pending smbdirect
>> change "smb: smbdirect: bound the disconnect wait in destroy_sync" [1]
>> had to work around it on the ULP side:
>> smbdirect_socket_destroy_sync() waited unbounded for the socket to
>> reach SMBDIRECT_SOCKET_DISCONNECTED, a transition that depends on an
>> asynchronous RDMA CM disconnect event, and when the peer died abruptly
>> (a killed client, or Soft-RoCE/RXE where no graceful disconnect
>> completes) that event never arrived.  The destroy ran on the single
>> ksmbd-conn-release workqueue, every later connection release queued
>> behind it in D state, and the whole server wedged until hung_task
>> fired.  That change bounded the wait and drove the socket state
>> machine to DISCONNECTED locally on timeout; ULPs should not have to
>> resort to that, the CM should offer a teardown they can rely on.
>>
>> IWCM_F_CONNECT_WAIT currently guards two different windows:
>>
>>   * the connect/accept downcall into the provider being in progress;
>>     teardown must keep waiting for that, it is short and bounded;
>>
>>   * an issued active connect waiting for CONNECT_REPLY, which is
>>     potentially unbounded.
>>
>> Mark the second window with a new flag, IWCM_F_CONNECT_SENT: set by
>> iw_cm_connect() once the downcall has returned successfully, cleared
>> by cm_conn_rep_handler().  The teardown waits now complete when either
>> the downcall has finished (!IWCM_F_CONNECT_WAIT, as before) or the
>> pending-reply window has been entered (IWCM_F_CONNECT_SENT), and the
>> previously BUG() CONN_SENT cases become:
>>
>>   * iw_cm_disconnect(): return -ENOTCONN; there is no established
>>     connection to disconnect, aborting is the destroy path's job;
>>
>>   * destroy_cm_id(): abort the pending connect locally by moving to
>>     DESTROYING and putting the QP into error so the provider tears the
>>     connection attempt down.
>>
>> A CONNECT_REPLY that arrives after the abort is dropped: either
>> cm_work_handler() sees IWCM_F_DROP_EVENTS, or cm_conn_rep_handler()
>> now recognizes IW_CM_STATE_DESTROYING (the abort and the reply
>> serialize on cm_id_priv->lock) and frees the event without touching
>> the QP that destroy_cm_id() already released.  The cm_id memory stays
>> valid for such a late reply because the provider holds its own
>> reference (cm_id->add_ref) for as long as it can deliver events.
>>
>> The passive side has a sibling gap, where after a successful accept
>> downcall the flag stays set until the provider's ESTABLISHED event
>> arrives, which this patch deliberately does not change.
>>
>> [1] https://github.com/smfrench/smb3-kernel/commit/26d0f82a02c8a9c9c8cdfc138acb7ed0bf8e01a9
>>
>> Suggested-by: Stefan Metzmacher <metze@samba.org>
>> Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
>> ---
>>   drivers/infiniband/core/iwcm.c | 76 +++++++++++++++++++++++++++++-----
>>   drivers/infiniband/core/iwcm.h |  1 +
>>   2 files changed, 67 insertions(+), 10 deletions(-)
> 
> I'm not sure what to do with this patch, as the iWARP folks have
> remained silent.
> 
> Stefan,
> 
> Do you still need this patch? Have you tested it?

I'll test it soon.

But the problem is real and I hit it very often in the past and the only option
was a reboot.

I added Bernard explicitly...

metze

