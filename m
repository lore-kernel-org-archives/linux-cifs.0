Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03861353A75;
	Wed,  2 Sep 2026 07:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788333343; cv=none; b=j8bjktn1OJz0G7jKojsHxaIFRvjC3jCX7hT+wHIl5Aw1zRiYeALsIe4CYDTt9oA69iOaR0SJUgo5pGjBfKom89DLIwxFIBOya2eXUqOLwoE20PhUnWXk6pLz3w2s6ysoqpGtOdRy5tfzI3vVbQOtHsBg585ZPq8SDd0gPvhy5os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788333343; c=relaxed/simple;
	bh=OKy5yup/CYY4kcxfwb4lGlnPb5ToVewK7dTd3Qc8wpI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eHS12KOgKmLRIu4L9g17XZh0GLM3SnfTH/wZZtxTXOkVYNmB6pBVfPYaQ1bdzsJRFcWDrMGsdM2/3Af8OaXJxBfwEpAA66syX3v8+gwInJC0XGyGz/6adNMuPwCss8B6Jz6CWNRS9CFlPwhEGpNS0O9idcmNI4xMbvTK84MORCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R93//Y3/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R93//Y3/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B7A1F00A3A;
	Wed,  2 Sep 2026 07:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788333341;
	bh=P+AuOxa+N9qYbUUYycRh4JCzPQGFmXmYbqmzEftVe64=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=R93//Y3/ZEIMcg5tdMBsW5gD1ENAb0xx0YEa5J8jNJMV6Nv/bqgaINFhKobBEu6ae
	 mJS8+tjQ+j723vQzfc/M9ocjCogr2PQurnL13ywd8fFytZECMuLVcydynbXuE7Hz/q
	 y15dN0M7XDAAS+m15RJs+EDCQvlxJ2Lt0TKkJYAgnfNGeH4OBdMrRDz/ANacc7fx1D
	 4iKwINUtjRhgnlk3jl6wqti1qzcblpriSCTC2m4NHXuVhjcIR1KXhL5ake/ptkQYOg
	 3UJzVoze9pHIJ8X0udUeLO2WstfUM75VgNJkZaE3fMuJZ5I1kKXyu2ilsEWAiLvCRO
	 D6u7GAtfRiTGg==
Date: Wed, 2 Sep 2026 10:15:38 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Stefan Metzmacher <metze@samba.org>
Cc: Yunseong Kim <yunseong.kim@est.tech>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jacob Moroni <jmoroni@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
	Yunseong Kim <yunseong.kim@ericsson.com>,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
	Bernard Metzler <bernard.metzler@linux.dev>
Subject: Re: [RFC PATCH] RDMA/iwcm: allow aborting an active connect awaiting
 CONNECT_REPLY
Message-ID: <20260902071538.GP24140@unreal>
References: <20260805000159.321645-2-yunseong.kim@est.tech>
 <20260901124103.GL24140@unreal>
 <47142579-3af7-453b-875c-ff6d610f26a7@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47142579-3af7-453b-875c-ff6d610f26a7@samba.org>

On Tue, Sep 01, 2026 at 06:50:15PM +0200, Stefan Metzmacher wrote:
> Hi Leon,
> 
> > On Wed, Aug 05, 2026 at 02:02:00AM +0200, Yunseong Kim wrote:
> > > After a successful connect downcall, iw_cm_connect() returns with
> > > IWCM_F_CONNECT_WAIT still set and the cm_id in IW_CM_STATE_CONN_SENT.
> > > The only thing that clears the flag is the provider delivering
> > > IW_CM_EVENT_CONNECT_REPLY (cm_conn_rep_handler()).  Until that event
> > > arrives, iw_cm_disconnect() and destroy_cm_id() sleep uninterruptibly
> > > in
> > > 
> > > 	wait_event(cm_id_priv->connect_wait,
> > > 		   !test_bit(IWCM_F_CONNECT_WAIT, &cm_id_priv->flags));
> > > 
> > > and both state machines treat IW_CM_STATE_CONN_SENT as BUG(), so the
> > > API has no way to cancel a pending active connect.  If the provider
> > > never generates the reply, because the peer died in the middle of
> > > connection setup or because of a provider bug, every teardown path
> > > (rdma_disconnect(), rdma_destroy_id()) blocks in D state forever and
> > > the ULP cannot recover: there is no way to disconnect after
> > > rdma_connect() was called without risking an unbounded hang.
> > > 
> > > This class of problem is not theoretical.  The pending smbdirect
> > > change "smb: smbdirect: bound the disconnect wait in destroy_sync" [1]
> > > had to work around it on the ULP side:
> > > smbdirect_socket_destroy_sync() waited unbounded for the socket to
> > > reach SMBDIRECT_SOCKET_DISCONNECTED, a transition that depends on an
> > > asynchronous RDMA CM disconnect event, and when the peer died abruptly
> > > (a killed client, or Soft-RoCE/RXE where no graceful disconnect
> > > completes) that event never arrived.  The destroy ran on the single
> > > ksmbd-conn-release workqueue, every later connection release queued
> > > behind it in D state, and the whole server wedged until hung_task
> > > fired.  That change bounded the wait and drove the socket state
> > > machine to DISCONNECTED locally on timeout; ULPs should not have to
> > > resort to that, the CM should offer a teardown they can rely on.
> > > 
> > > IWCM_F_CONNECT_WAIT currently guards two different windows:
> > > 
> > >   * the connect/accept downcall into the provider being in progress;
> > >     teardown must keep waiting for that, it is short and bounded;
> > > 
> > >   * an issued active connect waiting for CONNECT_REPLY, which is
> > >     potentially unbounded.
> > > 
> > > Mark the second window with a new flag, IWCM_F_CONNECT_SENT: set by
> > > iw_cm_connect() once the downcall has returned successfully, cleared
> > > by cm_conn_rep_handler().  The teardown waits now complete when either
> > > the downcall has finished (!IWCM_F_CONNECT_WAIT, as before) or the
> > > pending-reply window has been entered (IWCM_F_CONNECT_SENT), and the
> > > previously BUG() CONN_SENT cases become:
> > > 
> > >   * iw_cm_disconnect(): return -ENOTCONN; there is no established
> > >     connection to disconnect, aborting is the destroy path's job;
> > > 
> > >   * destroy_cm_id(): abort the pending connect locally by moving to
> > >     DESTROYING and putting the QP into error so the provider tears the
> > >     connection attempt down.
> > > 
> > > A CONNECT_REPLY that arrives after the abort is dropped: either
> > > cm_work_handler() sees IWCM_F_DROP_EVENTS, or cm_conn_rep_handler()
> > > now recognizes IW_CM_STATE_DESTROYING (the abort and the reply
> > > serialize on cm_id_priv->lock) and frees the event without touching
> > > the QP that destroy_cm_id() already released.  The cm_id memory stays
> > > valid for such a late reply because the provider holds its own
> > > reference (cm_id->add_ref) for as long as it can deliver events.
> > > 
> > > The passive side has a sibling gap, where after a successful accept
> > > downcall the flag stays set until the provider's ESTABLISHED event
> > > arrives, which this patch deliberately does not change.
> > > 
> > > [1] https://github.com/smfrench/smb3-kernel/commit/26d0f82a02c8a9c9c8cdfc138acb7ed0bf8e01a9
> > > 
> > > Suggested-by: Stefan Metzmacher <metze@samba.org>
> > > Signed-off-by: Yunseong Kim <yunseong.kim@est.tech>
> > > ---
> > >   drivers/infiniband/core/iwcm.c | 76 +++++++++++++++++++++++++++++-----
> > >   drivers/infiniband/core/iwcm.h |  1 +
> > >   2 files changed, 67 insertions(+), 10 deletions(-)
> > 
> > I'm not sure what to do with this patch, as the iWARP folks have
> > remained silent.
> > 
> > Stefan,
> > 
> > Do you still need this patch? Have you tested it?
> 
> I'll test it soon.
> 
> But the problem is real and I hit it very often in the past and the only option
> was a reboot.

I see. I'll wait for a tag (Acked-by, Reviewed-by, Tested-by, etc.) from
either you or Bernard.

Thanks

> 
> I added Bernard explicitly...
> 
> metze
> 
