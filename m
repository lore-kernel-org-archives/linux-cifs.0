Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BF7455171;
	Tue, 15 Sep 2026 19:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789501843; cv=none; b=p37rMLrluvY/yLFU0AU8dEMqYrP9BaTNTY9J6MB0zRDZoF2AGs0Gom3GJTSFZZx10sgxk5Dvwq+9rnMv1Huv/Fie70ozVJamyjSAG2/Ioqt0D7/5AHXuKet3Sof/ZE6k+PV4BVv6b1Z+SVYAX6fY2fJ+/4jOkDRY1NGSRxGH1GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789501843; c=relaxed/simple;
	bh=7pAhkgANEwxgn8l1oPuF03lULyArxtQyBwEI9RYMApE=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mH/kXViJ4iklTw6IgiLS2pINHkKFeIObHV5TGfc+3x0fljQR8+xoIE0mQoo1YsXB61EE1QzCZ3ZsOzCVl8Q6R13PlelASYJfejoD2oNcx4F9QwVdjvXgWzf4dROvIa3QTjWTFn5U6lb/vnm81VQ0wVnfYbpK/q9dRtLS0K+/Zgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dgz1BDS5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dgz1BDS5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9E41F000FF;
	Tue, 15 Sep 2026 19:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789501841;
	bh=41PbzTlkbDDun+VgvFEcL5oYarBRBEjhf2sVY+7b2qY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Dgz1BDS5005RIgsSrFQdknqfu/FpOvFx5v0nrRWiH7RVr2oT18O9vUjVpKXv22tOC
	 ZRBXl1kzca3p3JYKJCS9KT3CgMMchLtumv929SCNt55lGS6zg/vS05FKm/KIpux1kW
	 86xYUBfQWSI65IqV0IDAKGWMEo5RexS2wrLwkF7Mk2J5YPhUyPYTo5x4GZoBayYINu
	 Fz4/x9ImNHisa1AjhhoRTl3y3Th0oLfPTIdUsvIzm4w2qX9v632D2bO7Oxrs38TU0v
	 ++q+toZ/6IaY2pKZOePz/YozBWASFi3eVgRS/+ZXQPjWKpw9ug4UuaMya8sUFe1KrR
	 44+fLaQ7m+yKA==
Subject: Re: [PATCH net-next v15 06/15] quic: add stream management
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
Date: Tue, 15 Sep 2026 19:50:39 +0000
Message-ID: <178950183921.22033.10083649522216474862@kernel.org>
In-Reply-To: =?utf-8?q?=3C6d7bfc9ba424a7170befff9ca9eaed1663017ca8=2E1789393?=
 =?utf-8?q?775=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3C6d7bfc9ba424a7170befff9ca9eaed1663017ca8=2E17893937?=
 =?utf-8?q?75=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 1 · Low: 2

- [Medium] quic_stream_set_param() (net/quic/stream.c:387-416) treats the
  UAPI field `struct quic_transport_param::remote` (a __u8, so 0..255)…
- [Low] quic_stream_create() (net/quic/stream.c:83-160) allocates each
  stream with kzalloc_obj() and explicitly initializes only id,…
- [Low] Concern: quic_stream_free() is called from quic_destroy_sock()
  (net/quic/socket.c:60), i.e. from proto->destroy, which…

--

quic: add stream management

Adds struct quic_stream_table and struct quic_stream along with the
per-socket stream hash table, the acquire/release helpers
quic_stream_get()/quic_stream_put(), the stream ID limit checks, and the
transport parameter get/set helpers.  The table is allocated in
quic_init_sock() and released in quic_destroy_sock().

A few questions below about stream state initialization, the handling of
the transport parameter "remote" field, and the teardown ordering.

> diff --git a/net/quic/socket.c b/net/quic/socket.c
> index 0e0a13235fa42..731c1e00dba2b 100644
> --- a/net/quic/socket.c
> +++ b/net/quic/socket.c
> @@ -49,11 +49,16 @@ static int quic_init_sock(struct sock *sk)
>  	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
>  	INIT_LIST_HEAD(quic_reqs(sk));
>  
> +	if (quic_stream_init(quic_streams(sk)))
> +		return -ENOMEM;
> +
>  	return 0;
>  }
>  
>  static void quic_destroy_sock(struct sock *sk)
>  {
> +	quic_stream_free(quic_streams(sk));

[Severity: Low]
Is the stream table teardown ordering here what is intended for later
patches?  quic_destroy_sock() is proto->destroy, and sk_common_release()
runs it before ->unhash(), with no socket lock held:

net/core/sock.c:sk_common_release() {
	...
	if (sk->sk_prot->destroy)
		sk->sk_prot->destroy(sk);
	...
	sk->sk_prot->unhash(sk);
	...
}

So quic_stream_free() frees streams->head and then stores NULL into it at
a point where the socket is no longer reachable from user space but is
still, in principle, reachable from the network.  A concurrent
quic_stream_find() would then walk freed hlist heads, or dereference NULL
in quic_stream_head().

Nothing can hit this in the current tree, since quic_hash() is
"return 0;" and quic_unhash() is empty, so a QUIC socket is never inserted
into a hash table and cannot be looked up from the receive path.  Would it
still be worth doing the free after unhash, or under the socket lock the
way udp_destroy_sock() does with lock_sock_fast(), so this stays correct
once the lookup paths land?

[ ... ]

> diff --git a/net/quic/stream.c b/net/quic/stream.c
> new file mode 100644
> index 0000000000000..6b34b117103a8
> --- /dev/null
> +++ b/net/quic/stream.c
> @@ -0,0 +1,416 @@

[ ... ]

> +	/* rfc9000#section-2.1: A stream ID that is used out of order results in
> +	 * all streams of that type with lower-numbered stream IDs also being
> +	 * opened.
> +	 */
> +	while (stream_id <= max_stream_id) {
> +		stream = kzalloc_obj(*stream, gfp);
> +		if (!stream)
> +			goto free;
> +
> +		stream->id = stream_id;
> +		if (quic_stream_id_uni(stream_id)) {
> +			if (send) {
> +				stream->send.max_bytes =
> +					limits->max_stream_data_uni;
> +			} else {
> +				stream->recv.max_bytes =
> +					limits->max_stream_data_uni;
> +				stream->recv.window = stream->recv.max_bytes;
> +			}

[Severity: Low]
Should stream->recv.state be initialized here?

The stream comes from kzalloc_obj(), and only id, send.max_bytes,
recv.max_bytes and recv.window are assigned, so recv.state stays 0.  The
send and receive states share one enum in include/uapi/linux/quic.h:

	enum {
		QUIC_STREAM_SEND_STATE_READY,
		...
		QUIC_STREAM_SEND_STATE_RESET_RECVD,

		QUIC_STREAM_RECV_STATE_RECV,
		...
	};

which makes 0 equal to QUIC_STREAM_SEND_STATE_READY, while
QUIC_STREAM_RECV_STATE_RECV is 6.

net/quic/stream.h documents the field as a receive state:

		u8 state;  /* Receive stream state, per rfc9000#section-3.2 */

and quic_stream_put() compares it against the receive constants:

		if (stream->recv.state < QUIC_STREAM_RECV_STATE_RECVD)
			return;

This comparison happens to give the same answer for 0 as for 6, so nothing
misbehaves today, and the same field is what gets reported to user space as
struct quic_stream_update::state.  Would setting recv.state to
QUIC_STREAM_RECV_STATE_RECV at creation time (or documenting that 0 means
"Recv") avoid an equality test going wrong later?

[ ... ]

> +/* Configure stream hashtable from transport parameters. */
> +void quic_stream_set_param(struct quic_stream_table *streams,
> +			   struct quic_transport_param *p, bool is_serv)
> +{
> +	struct quic_stream_limits *limits = p->remote ? &streams->send :
> +							&streams->recv;
> +	u8 bidi_type, uni_type;
> +
[ ... ]
> +	if (p->remote ^ is_serv) {
> +		bidi_type = QUIC_STREAM_TYPE_CLIENT_BIDI;
> +		uni_type = QUIC_STREAM_TYPE_CLIENT_UNI;
> +	} else {
> +		bidi_type = QUIC_STREAM_TYPE_SERVER_BIDI;
> +		uni_type = QUIC_STREAM_TYPE_SERVER_UNI;
> +	}

[Severity: Medium]
Can the two different interpretations of p->remote in this function
disagree?  It is a __u8 in the uAPI (struct quic_transport_param), so it
can hold 0..255.  The limits selection uses a truth test, while the type
selection uses a bitwise XOR, so for p->remote == 2 with is_serv == true:

	limits    = &streams->send		/* truth test: non-zero */
	2 ^ 1 = 3 -> non-zero			/* takes the CLIENT branch */
	bidi_type = QUIC_STREAM_TYPE_CLIENT_BIDI

which leaves streams->send.next_bidi_stream_id = 0 on a server instead of
1.  Would !!p->remote ^ is_serv (or rejecting p->remote > 1) keep the two
tests consistent?

The follow-on in that state is that quic_stream_get() for the server's
first bidi stream (ID 1) passes every gate: quic_stream_id_valid(1, true,
true) is true, find() returns NULL, quic_stream_id_local(1, true) is true,
quic_stream_id_closed() is false because 1 < 0 is false, and
quic_stream_id_exceeds() is false.  quic_stream_create() then starts at
stream_id 0:

> +	while (stream_id <= max_stream_id) {

allocates a single stream with id 0, advances stream_id to 4 and returns
that stream.  quic_stream_get() reports success and records
streams->send.active_stream_id = 1 for a stream that does not exist, while
ID 1 is now permanently -ENOSTR because next_bidi_stream_id is 4.

A later quic_stream_put() on the returned stream 0 evaluates
quic_stream_id_local(0, true) as false and decrements
streams->recv.streams_bidi, which was never incremented, so that u16
underflows and feeds quic_stream_max_streams_update().

quic_stream_set_param() has no caller yet in the tree, so this is
forward-looking rather than something reachable today.  Along the same
lines, should quic_stream_create() return an error rather than a stream
whose id differs from the requested max_stream_id, since no caller can
detect that today?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1789393775.git.lucien.xin%40gmail.com
