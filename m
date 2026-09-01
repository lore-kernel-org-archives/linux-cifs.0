Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746FA371053;
	Tue,  1 Sep 2026 12:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788266469; cv=none; b=LDwSDUp2ifi30rDiLEH9sTIph2FlIHVqmMEOHe8x/TR1wmAcd5o0p3Jssi54C6iZInhrB9jWsp72O6voZJverulkBu7WzuY3DcP0IVoeUOgdhB5r1ODu2rB9oTN5fyEaIK1B0VKr3B5i5kzT4bXmmaNfil4Mj4JfP/p40xCpD+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788266469; c=relaxed/simple;
	bh=mJo4l/y4MxbMvXcw1tprHy5vAB2h6U3R8qtue/noZ9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q4pKvcqV1sDYF1RJM/Yo7v+IQsmPMR+5wphhC8jeY3M6J4meV6ijCdaCswW/jAXteXe0elQEAgQ1ULZDVFlEyGJX1ijhh3Kc0rPqscXy+uSvZSc59YAmovNCITxLBAiODpzoY1Ewz7iR+4UptDCt1b59h2Yqn9J3tW/FnVsU2U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QF3m0Q1F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QF3m0Q1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5021F000E9;
	Tue,  1 Sep 2026 12:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788266468;
	bh=8E/4HEhZ+01WRW16r1kh+DTxQ/1UAOLeU+xLOlmoQrA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QF3m0Q1FNTtxaECBq2LCYXalGE6aM1//FUA1jWjZwrYLMTd0dklCHmF+54khHi923
	 k3Z4F1sqcdQRrgJ66QqjtMfAUZ8Ijv84XvJDPfK4nynCoMlh9DElVKpMPq0Mz6hZFC
	 J/EKXuVwVgjD/uunoVMrZkjDGl89L1NLd+oq+R3Nx5XeFuhDaIJkD4dt1jWibGPAbm
	 4lfWzYHq7OwpDj1M8KnOCcEAXs0VkgrmqzWrIbrGbq0s3UE8RuSEttTUhbe4JDuN+c
	 vNsiky0jcDl80mZhYjrGiIF9NKqSZBM08MAOjTqiHh6NbME65+kozouZB1aC6P4fBk
	 13MGrFDmwqGdw==
Date: Tue, 1 Sep 2026 15:41:03 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Yunseong Kim <yunseong.kim@est.tech>,
	Stefan Metzmacher <metze@samba.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Jacob Moroni <jmoroni@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
	Yunseong Kim <yunseong.kim@ericsson.com>,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [RFC PATCH] RDMA/iwcm: allow aborting an active connect awaiting
 CONNECT_REPLY
Message-ID: <20260901124103.GL24140@unreal>
References: <20260805000159.321645-2-yunseong.kim@est.tech>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260805000159.321645-2-yunseong.kim@est.tech>

On Wed, Aug 05, 2026 at 02:02:00AM +0200, Yunseong Kim wrote:
> After a successful connect downcall, iw_cm_connect() returns with
> IWCM_F_CONNECT_WAIT still set and the cm_id in IW_CM_STATE_CONN_SENT.
> The only thing that clears the flag is the provider delivering
> IW_CM_EVENT_CONNECT_REPLY (cm_conn_rep_handler()).  Until that event
> arrives, iw_cm_disconnect() and destroy_cm_id() sleep uninterruptibly
> in
> 
> 	wait_event(cm_id_priv->connect_wait,
> 		   !test_bit(IWCM_F_CONNECT_WAIT, &cm_id_priv->flags));
> 
> and both state machines treat IW_CM_STATE_CONN_SENT as BUG(), so the
> API has no way to cancel a pending active connect.  If the provider
> never generates the reply, because the peer died in the middle of
> connection setup or because of a provider bug, every teardown path
> (rdma_disconnect(), rdma_destroy_id()) blocks in D state forever and
> the ULP cannot recover: there is no way to disconnect after
> rdma_connect() was called without risking an unbounded hang.
> 
> This class of problem is not theoretical.  The pending smbdirect
> change "smb: smbdirect: bound the disconnect wait in destroy_sync" [1]
> had to work around it on the ULP side:
> smbdirect_socket_destroy_sync() waited unbounded for the socket to
> reach SMBDIRECT_SOCKET_DISCONNECTED, a transition that depends on an
> asynchronous RDMA CM disconnect event, and when the peer died abruptly
> (a killed client, or Soft-RoCE/RXE where no graceful disconnect
> completes) that event never arrived.  The destroy ran on the single
> ksmbd-conn-release workqueue, every later connection release queued
> behind it in D state, and the whole server wedged until hung_task
> fired.  That change bounded the wait and drove the socket state
> machine to DISCONNECTED locally on timeout; ULPs should not have to
> resort to that, the CM should offer a teardown they can rely on.
> 
> IWCM_F_CONNECT_WAIT currently guards two different windows:
> 
>  * the connect/accept downcall into the provider being in progress;
>    teardown must keep waiting for that, it is short and bounded;
> 
>  * an issued active connect waiting for CONNECT_REPLY, which is
>    potentially unbounded.
> 
> Mark the second window with a new flag, IWCM_F_CONNECT_SENT: set by
> iw_cm_connect() once the downcall has returned successfully, cleared
> by cm_conn_rep_handler().  The teardown waits now complete when either
> the downcall has finished (!IWCM_F_CONNECT_WAIT, as before) or the
> pending-reply window has been entered (IWCM_F_CONNECT_SENT), and the
> previously BUG() CONN_SENT cases become:
> 
>  * iw_cm_disconnect(): return -ENOTCONN; there is no established
>    connection to disconnect, aborting is the destroy path's job;
> 
>  * destroy_cm_id(): abort the pending connect locally by moving to
>    DESTROYING and putting the QP into error so the provider tears the
>    connection attempt down.
> 
> A CONNECT_REPLY that arrives after the abort is dropped: either
> cm_work_handler() sees IWCM_F_DROP_EVENTS, or cm_conn_rep_handler()
> now recognizes IW_CM_STATE_DESTROYING (the abort and the reply
> serialize on cm_id_priv->lock) and frees the event without touching
> the QP that destroy_cm_id() already released.  The cm_id memory stays
> valid for such a late reply because the provider holds its own
> reference (cm_id->add_ref) for as long as it can deliver events.
> 
> The passive side has a sibling gap, where after a successful accept
> downcall the flag stays set until the provider's ESTABLISHED event
> arrives, which this patch deliberately does not change.
> 
> [1] https://github.com/smfrench/smb3-kernel/commit/26d0f82a02c8a9c9c8cdfc138acb7ed0bf8e01a9
> 
> Suggested-by: Stefan Metzmacher <metze@samba.org>
> Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
> ---
>  drivers/infiniband/core/iwcm.c | 76 +++++++++++++++++++++++++++++-----
>  drivers/infiniband/core/iwcm.h |  1 +
>  2 files changed, 67 insertions(+), 10 deletions(-)

I'm not sure what to do with this patch, as the iWARP folks have
remained silent.

Stefan,

Do you still need this patch? Have you tested it?

Thanks,
