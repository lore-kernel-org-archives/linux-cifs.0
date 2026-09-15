Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A9D4CCDF8;
	Tue, 15 Sep 2026 19:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789501862; cv=none; b=Dqe+laSjm1VIQ8Qc6c3P4gO3ew8A7fQOJYOXUC6WddleThnSdvfS5RfRFWJMmw/qnA1jznOVPquaEowkvDnkRZGzaN8lCgX/ly3HZKl7kLKVAadLUsTaEdaXmC8vZCd0T6RA/2OmRlyERQ3ElRHf4iqy10ZyBsuFA7TB73Oj4Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789501862; c=relaxed/simple;
	bh=bCc04E61Rp12gnLyZZHdgOG8tFTubd0q7zl6A8B8IjM=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tnHVSkvp7lHpqwMBCfZ4kNK+RTkHvegDf4m1I/BQ1FKPuvogqbleLxftUc2bNsxi6lngsDV9PE6Ny95p4d8mIMo06hZTaCZwrs5WKeIUA0ASoSOOpcpYI7nuZ6oek8QOPFseeHTc+jKD9QQm+ZMlbu4Bg7gONfIJ2iO094FG0L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cy32MMNr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cy32MMNr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A611F00893;
	Tue, 15 Sep 2026 19:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789501861;
	bh=2Bim09QVxsJM3p4pdkDhDNcTwlw4SUxSG+t1HZ3c3pI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Cy32MMNrkSRp8sm2kl85aTuI5nAgruspkdPXzAQDB5wuZkDjLS0pAk9Y6pt3Px9RF
	 EiRm/YxXPwSz5EYqVX5omU0EAjHJeNuj8U3p0jWA6yEDlwPc9GNBuleNwnMkqjCK/E
	 9WOaBriqIEQMDXwpwJvzCaL4Skf3cF0MpkCImsUIbfn4XMt1ZXMED6zREM+GXFlFRQ
	 LIcPwFhyFQuFsO51/b9llxurTvP8+6htujJsXyE/UcDUwpq1bJzHIW2zWNvXmx1xUb
	 j1P8vjAIpc/lEhyH/RglBYHTxPX2SCecphQXOGsmk7Msf0U+IQyrP+Sca01OH9RHa+
	 Ud6KAspAnrpqQ==
Subject: Re: [PATCH net-next v15 14/15] quic: add packet builder base
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
Date: Tue, 15 Sep 2026 19:50:59 +0000
Message-ID: <178950185914.22033.7074901863240008115@kernel.org>
In-Reply-To: =?utf-8?q?=3C927bfa67165193368d642396c4b8fcfc580d494d=2E1789393?=
 =?utf-8?q?775=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3C927bfa67165193368d642396c4b8fcfc580d494d=2E17893937?=
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

Thank you for your contribution! Sashiko AI review found 4 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 1 · Low: 3

- [Medium] Unit mismatch in quic_packet_route()
  (net/quic/packet.c:63-66): the *IP-level* MTU returned by dst_mtu() is…
- [Low] Claim that the commit message over-advertises the packet builder:
  quic_packet_handshake_create()/quic_packet_app_create()…
- [Low] In struct quic_packet (net/quic/packet.h:24) the field comment
  reads 'u16 mss[2]; /* MSS for datagram and non-datagram packets */',…
- [Low] Claim that quic_packet_xmit() (net/quic/packet.c:199) must bail
  out instead of only warning when skb_set_owner_sk_safe(skb, sk) fails,…

--

quic: add packet builder base

This adds net/quic/packet.c and net/quic/packet.h with the TX-side
'quic_packet' state: quic_packet_config() sets the path and computes header
overhead, quic_packet_create_and_xmit() builds and sends a packet, and
quic_packet_flush() sends any bundled packets.  quic_packet_init() is wired
into quic_init_sock().

A few questions on the new code below.

> diff --git a/net/quic/packet.c b/net/quic/packet.c
> new file mode 100644
> index 0000000000000..a1967f39c9242
> --- /dev/null
> +++ b/net/quic/packet.c
> @@ -0,0 +1,280 @@

[ ... ]

> +static struct sk_buff *quic_packet_handshake_create(struct sock *sk, gfp_t gfp)
> +{
> +	return NULL;
> +}
> +
> +static int quic_packet_number_check(struct sock *sk, gfp_t gfp)
> +{
> +	return 0;
> +}
> +
> +static struct sk_buff *quic_packet_app_create(struct sock *sk, gfp_t gfp)
> +{
> +	return NULL;
> +}

[Severity: Low]
This isn't a bug, but could the commit message list all of the placeholders?

It mentions that "Functions to create application (short) and handshake
(long) packets are currently placeholders for future implementation", which
covers quic_packet_handshake_create() and quic_packet_app_create() above,
but quic_packet_encrypt_done() is also a stub that frees every
asynchronously encrypted packet:

net/quic/packet.c:quic_packet_encrypt_done() {
	/* Free it for now, future patches will implement the actual deferred
	 * transmission logic.
	 */
	kfree_skb(skb);
}

Worth naming that one in the changelog too?

[ ... ]

> +/* Perform routing for the QUIC packet on the specified path, update header
> + * length and MSS accordingly, reset path and start PMTU timer.
> + */
> +int quic_packet_route(struct sock *sk)
> +{
> +	struct quic_path_group *paths = quic_paths(sk);
> +	struct quic_packet *packet = quic_packet(sk);
> +	union quic_addr *sa, *da;
> +	u32 pmtu;
> +	int err;
> +
> +	da = quic_path_daddr(paths, packet->path);
> +	sa = quic_path_saddr(paths, packet->path);
> +	err = quic_flow_route(sk, da, sa, &paths->fl);
> +	if (err)
> +		return err < 0 ? err : 0;
> +
> +	packet->hlen = quic_encap_len(da);
> +	pmtu = clamp(dst_mtu(__sk_dst_get(sk)),
> +		     QUIC_PATH_MIN_PMTU, QUIC_PATH_MAX_PMTU);
> +	quic_packet_mss_update(sk, pmtu - packet->hlen);

[Severity: Medium]
Are the units on both sides of this subtraction the same?

The clamp floor is applied to the IP-level MTU returned by dst_mtu(), and
packet->hlen (the full IP plus UDP encapsulation length from
quic_encap_len(), 28 for IPv4 and 48 for IPv6) is subtracted afterwards.
So for a route whose dst_mtu() is at or below 1228 (IPv4) the result is
1172, and at or below 1248 (IPv6) it is 1152:

	pmtu  = clamp(dst_mtu(...), 1200, 65535);   /* IP MTU */
	mss   = pmtu - packet->hlen;                /* UDP payload */

That value then lands in packet->mss[QUIC_PACKET_MSS_NORMAL] and in
congestion control via quic_packet_mss_update() -> quic_cong_set_mss(),
and it is also the coalescing limit in quic_packet_bundle():

	if (packet->head->len + skb->len >
	    packet->mss[QUIC_PACKET_MSS_NORMAL]) {

Can that put the UDP payload size below the 1200-byte minimum that
quic_packet_init() installs as QUIC_MIN_UDP_PAYLOAD, and below
QUIC_BASE_PLPMTU (also 1200, in net/quic/path.c) that quic_path_pl_reset()
writes into paths->pl.pmtu two lines later?

Note dst_mtu() can legitimately come back well under 1200 after a remote
ICMP "fragmentation needed", which is presumably why the clamp is there at
all.  Should the floor be QUIC_MIN_UDP_PAYLOAD + packet->hlen, or the
resulting MSS clamped to 1200 instead?

The three 1200 constants in this codebase denote three different layers
(net/quic/path.h QUIC_PATH_MIN_PMTU as an IP MTU floor, path.h
QUIC_MIN_UDP_PAYLOAD as a UDP payload size, path.c QUIC_BASE_PLPMTU as a
packetization-layer size), which makes this easy to mix up.

[ ... ]

> +/* Transmit a QUIC packet, possibly encrypting and bundling it. */
> +static int quic_packet_xmit(struct sock *sk, struct sk_buff *skb, gfp_t gfp)
> +{
> +	struct quic_packet *packet = quic_packet(sk);
> +	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
> +	struct net *net = sock_net(sk);
> +	int err;
> +
> +	/* Associate skb with sk to ensure sk is valid during async encryption
> +	 * completion.
> +	 */
> +	WARN_ON_ONCE(!skb_set_owner_sk_safe(skb, sk));

[Severity: Low]
This isn't a bug, but the comment says the reference is what keeps sk alive
across async encryption, while a failure here is only warned about and
execution continues into quic_crypto_encrypt().

skb_set_owner_sk_safe() only returns false when sk is NULL or
refcount_inc_not_zero(&sk->sk_refcnt) fails, and neither can happen on a TX
path whose caller already holds a socket reference, so the warn-and-continue
form matches the existing users in net/ipv4/tcp.c and net/ipv4/udp.c.  Is a
short note to that effect worth adding next to the WARN_ON_ONCE(), so it is
clear the continuation is deliberate?

[ ... ]

> +void quic_packet_init(struct sock *sk)
> +{
> +	struct quic_packet *packet = quic_packet(sk);
> +
> +	INIT_LIST_HEAD(&packet->frame_list);
> +	packet->taglen[QUIC_PACKET_FORM_SHORT] = QUIC_TAG_LEN;
> +	packet->taglen[QUIC_PACKET_FORM_LONG] = QUIC_TAG_LEN;
> +	packet->mss[QUIC_PACKET_MSS_NORMAL] = QUIC_MIN_UDP_PAYLOAD;
> +	packet->mss[QUIC_PACKET_MSS_DGRAM] = QUIC_MIN_UDP_PAYLOAD;
> +
> +	packet->version = QUIC_VERSION_V1;
> +}
> diff --git a/net/quic/packet.h b/net/quic/packet.h
> new file mode 100644
> index 0000000000000..18b89f5051214
> --- /dev/null
> +++ b/net/quic/packet.h
> @@ -0,0 +1,112 @@

[ ... ]

> +	u8 taglen[2];  /* Tag length for short and long packets */
> +	u16 padding;   /* Total padding bytes to append after frames */
> +	u16 frames;    /* Number of ack-eliciting frames */
> +	u16 mss[2];    /* MSS for datagram and non-datagram packets */
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[Severity: Low]
This isn't a bug, but is the slot order in this comment backwards?

The comment lists datagram first, which reads as slot 0 being the datagram
MSS, while the macros added just below say the opposite:

	#define QUIC_PACKET_MSS_NORMAL		0
	#define QUIC_PACKET_MSS_DGRAM		1

The neighbouring taglen[2] comment follows the "first listed is index 0"
convention and matches QUIC_PACKET_FORM_SHORT 0 / QUIC_PACKET_FORM_LONG 1.
Should this read "MSS for non-datagram and datagram packets" instead?

[ ... ]

> +#define QUIC_PACKET_MSS_NORMAL		0
> +#define QUIC_PACKET_MSS_DGRAM		1

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1789393775.git.lucien.xin%40gmail.com
