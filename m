Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC8F4CE681;
	Tue, 15 Sep 2026 19:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789501867; cv=none; b=LAoQOC2kkxCFJP1tlwn5wywMI6DgAkLZoFUDgl2GNvvShDQdJLzcpvh4TAjixhFeY8pWPlqLMvWaQP1qJRZkhlerV1D3jhLM2Hutpt7ZGGg4Jjl8NkGfxoVWPYmIZ2tN9Uw4/+p9BDBhpesv26nxJtFVJgewkgJF9oTxnWlnSBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789501867; c=relaxed/simple;
	bh=VmIEyBAJ2Ht6FVn5eNb/r4aPtW8o9zQ5A4E6OQRPc60=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RN6fjmuOjbI/2GVk+x883hQ5wa7YN38T1ZLfjWhQec/Q9nptRCwQHwPR2CFEvIF85qQ2fsORYmPjVID/fl6mvZFxbZuGU9l0K2zInNCF3Pi3GpAtTZbOEFWpscRD07+arbQKUqge8sm7jqsRfOnIIt023qQSuYOO9QwEAw3xJEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PJKpwu4/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PJKpwu4/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0111F000FF;
	Tue, 15 Sep 2026 19:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789501863;
	bh=6zzzkOibwLg3ijghTQuUq11Xk65Vh9KwtHiOOYIPMP0=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=PJKpwu4/O1DEbk5GiieScXPvVHe7mxGnjto5ui7GOzwBZNGYaX4NjxwKEK/Nhamh6
	 YpEsl6zIwzU4hbvR+VbIxo89hywOBEmGk/UMcTShttuNec7hJ4EseyozDiyvb45+qr
	 tdcxXrEl+Od2H1crNcpWx/QBd16alCEh8YIjrKtQ2yAAphBGRfze7A76/iUKCXTRDj
	 HvLLwmIf6iT+PUZVX7msazmyY+NvI4vEO+PCJprwIRMZzy7fGyW9Xw2tgYHhHSaHjZ
	 cZvIkHGGyxcPCazb6Jb/aNd8JlTuGsZPm8WovnHITHgFzrSBqaoSdDRQz7Gw6lrx+I
	 pRUuBO04Od5+w==
Subject: Re: [PATCH net-next v15 15/15] quic: add packet parser base
From: netdev-bot+sashiko@kernel.org
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, quic@lists.linux.dev, davem@davemloft.net,
 kuba@kernel.org, edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 metze@samba.org, mbuhl@openbsd.org, tfanelli@redhat.com, hepengtao@xiaomi.com,
 dreibh@simula.no, linux-cifs@vger.kernel.org, pc@manguebit.org,
 linkinjeon@kernel.org, tom@talpey.com, kernel-tls-handshake@lists.linux.dev,
 chuck.lever@oracle.com, jlayton@kernel.org, steved@redhat.com, hare@suse.de,
 aahringo@redhat.com, dhowells@redhat.com, matttbe@kernel.org,
 mail@johnericson.me, xiyou.wangcong@gmail.com, alibuda@linux.alibaba.com,
 jbaron@akamai.com, illiliti@protonmail.com, sd@queasysnail.net,
 marcelo.leitner@gmail.com, daniel@haxx.se, andrew.gospodarek@broadcom.com,
 mef@scarletmail.rutgers.edu, paul@jakma.org
Date: Tue, 15 Sep 2026 19:51:01 +0000
Message-ID: <178950186149.22033.824022402798948504@kernel.org>
In-Reply-To: =?utf-8?q?=3C40d0796769992c78bffe59b179833d71ed80e771=2E1789393?=
 =?utf-8?q?775=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3C40d0796769992c78bffe59b179833d71ed80e771=2E17893937?=
 =?utf-8?q?75=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 7 potential
issue(s) to consider:

Critical: 0 · High: 1 · Medium: 5 · Low: 1

- [High] quic_request_sock_create() publishes a newly allocated request
  before its first packet is successfully queued: it links req into…
- [Medium] Commit message understates the scope of the patch and does not
  disclose that the newly added listen-side connection-establishment…
- [Medium] quic_listen_sock_lookup() passes hdr_len = 1 to
  reuseport_select_sock() (net/quic/socket.c:292-293), but by the time…
- [Medium] In quic_accept_sock_exists() (net/quic/socket.c:132-135) and
  quic_listen_sock_switch() (socket.c:~330) the indirect call is…
- [Medium] A QUIC Initial decryption failure inside
  quic_packet_get_alpn() is counted twice and once under the wrong…
- [Medium] quic_packet_listen_process() treats every non-zero return of
  quic_crypto_verify_token() as a peer token-validation failure.
- [Low] The documented meanings of struct quic_packet's saddr/daddr are
  the reverse of the new receive-side implementation.

--

quic: add packet parser base

This adds the RX side of the QUIC packet handling: quic_packet_rcv() looks
up the socket for an incoming datagram, quic_packet_process() dispatches it,
and ICMP Packet Too Big errors are turned into PMTU updates.  A listener
path with ALPN parsing, request sock creation and a per-socket deferred
workqueue is added as well.

A few questions on the new code below.

> diff --git a/net/quic/packet.c b/net/quic/packet.c
> index a1967f39c9242..db87c32d7469d 100644
> --- a/net/quic/packet.c
> +++ b/net/quic/packet.c
> @@ -14,6 +14,768 @@

[ ... ]

> +/* Decrypt Initial packet and extract ALPN from TLS ClientHello for ALPN-based
> + * socket demultiplexing. Marks packet as decrypted (cb->resume = 1) to avoid
> + * redundant decryption later.
> + */
> +static int quic_packet_get_alpn(struct sk_buff *skb, struct quic_data *alpn)
> +{

[ ... ]

> +	cb->sync = 1;
> +	net = sock_net(sk);
> +	err = quic_crypto_decrypt(crypto, skb, GFP_KERNEL);
> +	if (err) {
> +		QUIC_INC_STATS(net, QUIC_MIB_PKT_DECDROP);
> +		return err;
> +	}

[Severity: Medium]
Is a single dropped packet meant to bump two drop counters here?

quic_packet_get_alpn() counts the AEAD failure as QUIC_MIB_PKT_DECDROP and
returns the error, and the caller in quic_packet_listen_process() then counts
the same skb again:

	err = quic_packet_get_alpn(skb, &alpns);
	if (err) {
		QUIC_INC_STATS(net, QUIC_MIB_PKT_INVHDRDROP);
		kfree_skb(skb);
		return err;
	}

net/quic/protocol.h documents these as distinct reasons:

	QUIC_MIB_PKT_INVHDRDROP,     /* Dropped: invalid packet header */
	...
	QUIC_MIB_PKT_DECDROP,        /* Dropped: decryption failure */

So QuicPktInvHdrDrop ends up reporting drops for packets whose header parsed
fine.  The same applies to a quic_crypto_initial_keys_install() failure inside
quic_packet_get_alpn(), which is not a header error either.

[ ... ]

> +static int quic_packet_retry_create_and_xmit(struct sock *sk)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static int quic_packet_version_create_and_xmit(struct sock *sk, gfp_t gfp)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static int quic_packet_stateless_reset_create_and_xmit(struct sock *sk, u32 len,
> +						       gfp_t gfp)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static int quic_packet_refuse_close_create_and_xmit(struct sock *sk,
> +						    u32 errcode)
> +{
> +	return -EOPNOTSUPP;
> +}

[Severity: Medium]
Could the changelog describe the listener side that is added here?

The commit message says:

  "Similar to the TX path, handling for application and handshake packets is
   not yet implemented."

and names only quic_packet_get_alpn(), quic_packet_rcv(),
quic_packet_process() and quic_packet_rcv_err_pmtu().

The patch also adds the whole listen path: quic_packet_listen_process() with
token validation and Retry triggering, quic_request_sock_create() /
quic_request_sock_lookup() / quic_request_sock_backlog_tail() with accept
queue accounting, quic_accept_sock_exists(), quic_listen_sock_switch(), two
socket lookup helpers and a per-socket deferred workqueue.

At the same time every response the embedded RFC quotes promise is one of the
four stubs above, and the skb is then consumed, so those packets are silently
dropped rather than answered.

And the request socks produced by this path have no consumer in the resulting
tree, since the registered .accept callback is:

net/quic/socket.c:
	static struct sock *quic_accept(struct sock *sk, struct proto_accept_arg *arg)
	{
		arg->err = -EOPNOTSUPP;
		return NULL;
	}

so requests that are created, charged with sk_acceptq_added() and signalled
with sk_data_ready() can never be dequeued.

[ ... ]

> +static int quic_packet_listen_process(struct sock *sk, struct sk_buff *skb,
> +				      gfp_t gfp)
> +{

[ ... ]

> +	/* Read Destination address (packet->saddr) and Source address
> +	 * (packet->daddr).
> +	 */
> +	quic_get_msg_addrs(skb, &packet->saddr, &packet->daddr);

[Severity: Low]
This isn't a bug, but the struct quic_packet field comments now say the
opposite of what this code stores.

quic_get_msg_addrs(skb, da, sa) fills its first output with the packet's
destination:

net/quic/family.c:
	static void quic_v4_get_msg_addrs(struct sk_buff *skb, union quic_addr *da,
					  union quic_addr *sa)
	{
		...
		da->v4.sin_addr.s_addr = ip_hdr(skb)->daddr;

so packet->saddr holds the local address and packet->daddr holds the peer,
which matches the local comment here and all the new consumers
(quic_request_sock_create/lookup, quic_accept_sock_exists,
quic_listen_sock_switch), but not the declarations in packet.h quoted further
down.  Could the struct comments be updated to match?

[ ... ]

> +		/* Verify Token. */
> +		crypto = quic_crypto(sk, QUIC_CRYPTO_INITIAL);
> +		err = quic_crypto_verify_token(crypto, &packet->daddr,
> +					       sizeof(packet->daddr),
> +					       &odcid, token.data, token.len);
> +		if (err) {
> +			if (!retry) {
> +				err = quic_packet_retry_create_and_xmit(sk);
> +				consume_skb(skb);
> +				return err;
> +			}

[Severity: Medium]
Should a local allocation failure here be reported to the peer as an invalid
token?

quic_crypto_verify_token() does not only return token mismatches:

net/quic/crypto.c:
	token_buf = kmemdup(token, len, GFP_KERNEL);
	if (!token_buf)
		return -ENOMEM;

and it also propagates -ENOMEM from quic_crypto_token_protect(), which
allocates via quic_crypto_aead_mem_alloc().

Under memory pressure a client presenting a perfectly valid NEW_TOKEN token
gets a Retry it should not receive, and one presenting a valid Retry token
takes the rfc9000#section-8.1.3 path:

	errcode = QUIC_TRANSPORT_ERROR_INVALID_TOKEN;
	quic_packet_refuse_close_create_and_xmit(sk, errcode);

Would it be better to distinguish -ENOMEM from a real verification failure
and just drop the packet?

[ ... ]

> +out:
> +	/* Add to backlog list and wake blocked accept() calls */
> +	return quic_request_sock_backlog_tail(sk, req, skb);
> +}

[ ... ]

> diff --git a/net/quic/packet.h b/net/quic/packet.h
> index 18b89f5051214..7f12bb53927b8 100644
> --- a/net/quic/packet.h
> +++ b/net/quic/packet.h
> @@ -14,6 +14,8 @@ struct quic_packet {
>  	union quic_addr daddr;    /* Dest address from received packet */
>  	union quic_addr saddr;    /* Source address from received packet */
>  
> +	struct sk_buff_head deferred_list; /* Packets deferred to work queue */
> +	struct sk_buff_head backlog_list;  /* Packets waiting for crypto keys */

These are the two comments referred to above: daddr is described as the
received packet's destination and saddr as its source, while the new RX code
stores them the other way around.

[ ... ]

> diff --git a/net/quic/path.c b/net/quic/path.c
> index a9e02fc22e609..a41b99dd31eff 100644
> --- a/net/quic/path.c
> +++ b/net/quic/path.c
> @@ -27,14 +27,14 @@ static int quic_udp_rcv(struct sock *sk, struct sk_buff *skb)
>  
>  	skb_pull(skb, sizeof(struct udphdr));
>  	skb_dst_force(skb);
> -	kfree_skb(skb);
> +	quic_packet_rcv(sk, skb, false);

Note the skb_pull() of the UDP header before quic_packet_rcv() runs; see the
reuseport question in socket.c below.

[ ... ]

> diff --git a/net/quic/socket.c b/net/quic/socket.c
> index 1e278a2109b2f..0fcb123d31bba 100644
> --- a/net/quic/socket.c
> +++ b/net/quic/socket.c
> @@ -24,6 +24,324 @@ static void quic_enter_memory_pressure(struct sock *sk)

[ ... ]

> +/* Create and enqueue a QUIC request sock for a new incoming connection. */
> +struct quic_request_sock *quic_request_sock_create(struct sock *sk,
> +						   struct quic_conn_id *odcid,
> +						   u8 retry, gfp_t gfp)
> +{

[ ... ]

> +	/* Enqueue request into listen socket’s pending list for accept(). */
> +	list_add_tail(&req->list, quic_reqs(sk));
> +	sk_acceptq_added(sk);
> +	return req;
> +}
> +
> +int quic_request_sock_backlog_tail(struct sock *sk,
> +				   struct quic_request_sock *req,
> +				   struct sk_buff *skb)
> +{
> +	u32 limit = sk->sk_rcvbuf / sk->sk_max_ack_backlog;
> +	int len = skb->truesize;
> +
> +	limit =  max_t(u32, limit, QUIC_MIN_UDP_PAYLOAD * 4);
> +	if (req->blen + len > limit || !__sk_rmem_schedule(sk, len, false)) {
> +		QUIC_INC_STATS(sock_net(sk), QUIC_MIB_PKT_RCVDROP);
> +		kfree_skb(skb);
> +		return -ENOBUFS;
> +	}

[Severity: High]
Can this path leak the quic_request_sock and permanently consume an accept
queue slot?

quic_request_sock_create() already published the request before the first
packet was queued:

	list_add_tail(&req->list, quic_reqs(sk));
	sk_acceptq_added(sk);

and quic_packet_listen_process() then hands it straight to the enqueue:

net/quic/packet.c:
	out:
		/* Add to backlog list and wake blocked accept() calls */
		return quic_request_sock_backlog_tail(sk, req, skb);

On the -ENOBUFS path above only the skb is freed.  The request stays linked in
quic_reqs(sk) with an empty backlog, and sk_acceptq_added() is not undone.

The size test is deterministic for a given packet size, since limit is
max(sk_rcvbuf / sk_max_ack_backlog, QUIC_MIN_UDP_PAYLOAD * 4), so a client
sending a large Initial fails on the first attempt and on every
retransmission, and the slot is never reclaimed.  Repeating with different
addresses or DCIDs would then make sk_acceptq_is_full() refuse all further
connections.

Should this failure path unlink and free a freshly created request, or should
the request only be created after the first packet is successfully queued?

> +
> +	QUIC_SKB_CB(skb)->backlog = 1;
> +	skb_set_owner_r(skb, sk);
> +	__skb_queue_tail(&req->backlog_list, skb);
> +	req->blen += len;
> +
> +	sk->sk_data_ready(sk);
> +	return 0;
> +}
> +
> +/* Check if a matching accept socket exists. This is needed because an accept
> + * socket might have been created after this packet was enqueued in the listen
> + * socket's backlog.
> + */
> +bool quic_accept_sock_exists(struct sock *sk, struct sk_buff *skb)
> +{

[ ... ]

> +	} else {
> +		/* Socket not busy: process immediately. */
> +		sk->sk_backlog_rcv(sk, skb); /* quic_packet_process(). */
> +	}

[Severity: Medium]
Is the annotation on this indirect call right?  .backlog_rcv is
quic_backlog_rcv(), further down in this file:

	static int quic_backlog_rcv(struct sock *sk, struct sk_buff *skb)
	{
		return quic_packet_process(sk, skb, GFP_ATOMIC);
	}

The existing site in quic_packet_rcv() spells it as
/* quic_backlog_rcv(). */, so the two new sites here and in
quic_listen_sock_switch() look inconsistent.

More than the name: quic_listen_sock_switch() runs in sleepable context (it
calls release_sock()/lock_sock() around the hand-off and is reached from the
deferred workqueue), but routing through .backlog_rcv pins the allocation
flags to GFP_ATOMIC, which defeats the gfp argument this patch threads through
quic_packet_process() so that quic_packet_deferred_work() can pass
GFP_KERNEL.  Should those two sites call quic_packet_process() directly with
the appropriate gfp?

[ ... ]

> +struct sock *quic_listen_sock_lookup(struct sk_buff *skb, union quic_addr *sa,
> +				     union quic_addr *da, struct sock *usk,
> +				     struct quic_data *alpns)
> +{

[ ... ]

> +out:
> +	if (sk && sk->sk_reuseport)
> +		sk = reuseport_select_sock(sk, quic_addr_hash(net, da), skb, 1);

[Severity: Medium]
Should the hdr_len argument be 0 rather than 1 here?

quic_udp_rcv() already did skb_pull(skb, sizeof(struct udphdr)) before
quic_packet_rcv() is reached, so skb->data points at the QUIC payload, and
reuseport_select_sock() documents hdr_len as how far the pointer must advance
to reach the payload.

With a classic SO_ATTACH_REUSEPORT_CBPF program, run_bpf_filter() does:

net/core/sock_reuseport.c:
	if (unlikely(!pskb_may_pull(skb, hdr_len)))
		return -EINVAL;
	...
	pskb_pull(skb, hdr_len);
	...
	__skb_push(skb, hdr_len);

so the filter would see the datagram starting one byte into the QUIC header:
all its offsets are shifted and the first byte (form/fixed/type bits) is
invisible, which can select the wrong socket in the reuseport group.

[ ... ]

> +bool quic_listen_sock_switch(struct sk_buff *skb, struct quic_data *alpns)
> +{

[ ... ]

> +	lock_sock(nsk);
> +	nsk->sk_backlog_rcv(nsk, skb); /* quic_packet_process(). */
> +	release_sock(nsk);

This is the second site of the .backlog_rcv naming and GFP_ATOMIC question
raised above, and the one running in sleepable context.

[ ... ]

> @@ -262,8 +587,7 @@ static void quic_shutdown(struct sock *sk, int how)
>  
>  static int quic_backlog_rcv(struct sock *sk, struct sk_buff *skb)
>  {
> -	kfree_skb(skb);
> -	return 0;
> +	return quic_packet_process(sk, skb, GFP_ATOMIC);
>  }

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1789393775.git.lucien.xin%40gmail.com
