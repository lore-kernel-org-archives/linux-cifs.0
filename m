Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA293239E6F;
	Fri, 16 Jan 2026 16:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768580454; cv=none; b=DvN0A/L6l9P1i4D+L0R2wIGQTUZeOLBQdmOkIR2EUlJ75QTKwSnRlGqpi3qqFbX5/I/3N0mV9Qy8xGONO8ab2HOPC7LpU8UnP4lOq5FVUPIya5GqCI9DjM4We/yQAvQKh7NdomoRg0UNVrIy7Mz4iJYEWYZJWsZgMkaLvv4UOEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768580454; c=relaxed/simple;
	bh=4V0NNattcxbc6kE8c4ucZ1bOm+W4hajweZxGNGyRnUI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JBVPCFFmuggjRLlfXptAzV4840+Jq6oD6BP0IEGM7p2D1kLGYwGKUoEpLT+23dRUEwppiFgBWVLSCN+RFKKF2lrS8U2YX1ldAazQCMnmyTGJw5Is/HkqiW8BEtuttwxYws1env6aKhidiu1nMR+MCQGygtud/JbAHWfRej9x97E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=L4TrQQZg; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="L4TrQQZg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=RAAIESFCZIySsre2ggKYEZUhjcb2kgEO1Ur6PmSLVio=; b=L4TrQQZgQelgnMZj0NjACXF5ap
	O/aK6A6g6Ci2CroPb1Q0NNzrosJgaTsiaOS4IOnHO7RACaj8jb88YECHVf58BDyqPX8yy749r4IU9
	JQFGi9XfENx+nmpGVv8Yhnr3tqpitPZuvjUp8FjOBIeKkA6hFxCY2n22W2zU913vU+yLEU8G6+UPR
	kIbV2Gs2ClpiimokU5KOBGfhlpL5AXkcc4YgVLff1c3orcPsF02vzj5LbX1dF9CVElOmm4b8Ob9xw
	3GfkD85847TJ2fQlKpc+w7UUpuzQo2ViouZrnrSQSI1YQJE5wtJVmdyXi9n5P4e5NyFnAGvcpxW0d
	MRqzRbqt1vKy5/Z9ijwMbJW6lYRXtZkA9gPcFPg7X58+0MfcuftcA0qSMwFsjTvm6g2a7YUjFa6Ms
	H+fI1jjc/CILWcEoMYduC9XcDR/WWplnFlW2H+Gieyup4QtYv1ZnkQiqdnli28fNd/hI7urXKkmZi
	kb4eYtr30zYdWLrx3x76x/jm;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vgmYw-00000000Tx6-3cop;
	Fri, 16 Jan 2026 16:20:39 +0000
Message-ID: <0daa8090-b63f-4d7c-870e-d32dd7f85266@samba.org>
Date: Fri, 16 Jan 2026 17:20:35 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v7 16/16] quic: add packet parser base
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>,
 quic@lists.linux.dev
Cc: davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>,
 Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz <dreibh@simula.no>,
 linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>, Paulo Alcantara <pc@manguebit.com>,
 Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev,
 Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>,
 Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>,
 Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>,
 Matthieu Baerts <matttbe@kernel.org>, John Ericson <mail@johnericson.me>,
 Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe"
 <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>,
 illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Daniel Stenberg <daniel@haxx.se>,
 Andy Gospodarek <andrew.gospodarek@broadcom.com>
References: <cover.1768489876.git.lucien.xin@gmail.com>
 <89a67cd3c41feb4e0129bcdcdf0bfe178528c735.1768489876.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <89a67cd3c41feb4e0129bcdcdf0bfe178528c735.1768489876.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 15.01.26 um 16:11 schrieb Xin Long:
> This patch usess 'quic_packet' to handle packing of QUIC packets on the
> receive (RX) path.
> 
> It introduces mechanisms to parse the ALPN from client Initial packets
> to determine the correct listener socket. Received packets are then
> routed and processed accordingly. Similar to the TX path, handling for
> application and handshake packets is not yet implemented.
> 
> - quic_packet_parse_alpn()`: Parse the ALPN from a client Initial packet,
>    then locate the appropriate listener using the ALPN.
> 
> - quic_packet_rcv(): Locate the appropriate socket to handle the packet
>    via quic_packet_process().
> 
> - quic_packet_process()`: Process the received packet.
> 
> In addition to packet flow, this patch adds support for ICMP-based MTU
> updates by locating the relevant socket and updating the stored PMTU
> accordingly.
> 
> - quic_packet_rcv_err_pmtu(): Find the socket and update the PMTU via
>    quic_packet_mss_update().
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
> v5:
>    - In quic_packet_rcv_err(), remove the unnecessary quic_is_listen()
>      check and move quic_get_mtu_info() out of sock lock (suggested
>      by Paolo).
>    - Replace cancel_work_sync() to disable_work_sync() (suggested by
>      Paolo).
> v6:
>    - Fix the loop using skb_dequeue() in quic_packet_backlog_work(), and
>      kfree_skb() when sk is not found (reported by AI Reviews).
>    - Remove skb_pull() from quic_packet_rcv(), since it is now handled
>      in quic_path_rcv().
>    - Note for AI reviews: add if (dst) check in quic_packet_rcv_err_pmtu(),
>      although quic_packet_route() >= 0 already guarantees it is not NULL.
>    - Note for AI reviews: it is safe to do *plen -= QUIC_HLEN in
>      quic_packet_get_version_and_connid(), since quic_packet_get_sock()
>      already checks if (skb->len < QUIC_HLEN).
>    - Note for AI reviews: cb->length - cb->number_len - QUIC_TAG_LEN
>      cannot underflow, because quic_crypto_header_decrypt() already checks
>      if (cb->length < QUIC_PN_MAX_LEN + QUIC_SAMPLE_LEN).
>    - Note for AI reviews: the cast (u16)length in quic_packet_parse_alpn()
>      is safe, as there is a prior check if (length > (u16)len); len is
>      skb->len, which cannot exceed U16_MAX.
>    - Note for AI reviews: it's correct to do if (flags &
>      QUIC_F_MTU_REDUCED_DEFERRED) in quic_release_cb(), since
>      QUIC_MTU_REDUCED_DEFERRED is the bit used with test_and_set_bit().
>    - Note for AI reviews: move skb_cb->backlog = 1 before adding skb to
>      backlog, although it's safe to write skb_cb after adding to backlog
>      with sk_lock.slock, as skb dequeue from backlog requires sk_lock.slock.
> v7:
>    - Pass udp sk to quic_packet_rcv(), quic_packet_rcv_err() and
>      quic_sock_lookup().
>    - Move the call to skb_linearize() and skb_set_owner_sk_safe() to
>      .quic_path_rcv()/quic_packet_rcv().
> ---
>   net/quic/packet.c   | 644 ++++++++++++++++++++++++++++++++++++++++++++
>   net/quic/packet.h   |   9 +
>   net/quic/protocol.c |   6 +
>   net/quic/protocol.h |   4 +
>   net/quic/socket.c   | 134 +++++++++
>   net/quic/socket.h   |   5 +
>   6 files changed, 802 insertions(+)
> 
> diff --git a/net/quic/packet.c b/net/quic/packet.c
> index 348e760aa197..415eda603355 100644
> --- a/net/quic/packet.c
> +++ b/net/quic/packet.c
> @@ -14,6 +14,650 @@
>   
>   #define QUIC_HLEN		1
>   
> +#define QUIC_LONG_HLEN(dcid, scid) \
> +	(QUIC_HLEN + QUIC_VERSION_LEN + 1 + (dcid)->len + 1 + (scid)->len)
> +
> +#define QUIC_VERSION_NUM	2
> +
> +/* Supported QUIC versions and their compatible versions. Used for Compatible Version
> + * Negotiation in rfc9368#section-2.3.
> + */
> +static u32 quic_versions[QUIC_VERSION_NUM][4] = {
> +	/* Version,	Compatible Versions */
> +	{ QUIC_VERSION_V1,	QUIC_VERSION_V2,	QUIC_VERSION_V1,	0 },
> +	{ QUIC_VERSION_V2,	QUIC_VERSION_V2,	QUIC_VERSION_V1,	0 },
> +};
> +
> +/* Get the compatible version list for a given QUIC version. */
> +u32 *quic_packet_compatible_versions(u32 version)
> +{
> +	u8 i;
> +
> +	for (i = 0; i < QUIC_VERSION_NUM; i++)
> +		if (version == quic_versions[i][0])
> +			return quic_versions[i];
> +	return NULL;
> +}
> +
> +/* Convert version-specific type to internal standard packet type. */
> +static u8 quic_packet_version_get_type(u32 version, u8 type)
> +{
> +	if (version == QUIC_VERSION_V1)
> +		return type;
> +
> +	switch (type) {
> +	case QUIC_PACKET_INITIAL_V2:
> +		return QUIC_PACKET_INITIAL;
> +	case QUIC_PACKET_0RTT_V2:
> +		return QUIC_PACKET_0RTT;
> +	case QUIC_PACKET_HANDSHAKE_V2:
> +		return QUIC_PACKET_HANDSHAKE;
> +	case QUIC_PACKET_RETRY_V2:
> +		return QUIC_PACKET_RETRY;
> +	default:
> +		return -1;
> +	}
> +	return -1;
> +}
> +
> +/* Parse QUIC version and connection IDs (DCID and SCID) from a Long header packet buffer. */
> +static int quic_packet_get_version_and_connid(struct quic_conn_id *dcid, struct quic_conn_id *scid,
> +					      u32 *version, u8 **pp, u32 *plen)
> +{
> +	u64 len, v;
> +
> +	*pp += QUIC_HLEN;
> +	*plen -= QUIC_HLEN;
> +
> +	if (!quic_get_int(pp, plen, &v, QUIC_VERSION_LEN))
> +		return -EINVAL;
> +	*version = v;
> +
> +	if (!quic_get_int(pp, plen, &len, 1) ||
> +	    len > *plen || len > QUIC_CONN_ID_MAX_LEN)
> +		return -EINVAL;
> +	quic_conn_id_update(dcid, *pp, len);
> +	*plen -= len;
> +	*pp += len;
> +
> +	if (!quic_get_int(pp, plen, &len, 1) ||
> +	    len > *plen || len > QUIC_CONN_ID_MAX_LEN)
> +		return -EINVAL;
> +	quic_conn_id_update(scid, *pp, len);
> +	*plen -= len;
> +	*pp += len;
> +	return 0;
> +}
> +
> +/* Change the QUIC version for the connection.
> + *
> + * Frees existing initial crypto keys and installs new initial keys compatible with the new
> + * version.
> + */
> +static int quic_packet_version_change(struct sock *sk, struct quic_conn_id *dcid, u32 version)
> +{
> +	struct quic_crypto *crypto = quic_crypto(sk, QUIC_CRYPTO_INITIAL);
> +
> +	if (quic_crypto_initial_keys_install(crypto, dcid, version, quic_is_serv(sk)))
> +		return -1;
> +
> +	quic_packet(sk)->version = version;
> +	return 0;
> +}
> +
> +/* Select the best compatible QUIC version from offered list.
> + *
> + * Considers the local preferred version, currently chosen version, and versions offered by
> + * the peer. Selects the best compatible version based on client/server role and updates the
> + * connection version accordingly.
> + */
> +int quic_packet_select_version(struct sock *sk, u32 *versions, u8 count)
> +{
> +	struct quic_packet *packet = quic_packet(sk);
> +	struct quic_config *c = quic_config(sk);
> +	u8 i, pref_found = 0, ch_found = 0;
> +	u32 preferred, chosen, best = 0;
> +
> +	preferred = c->version ?: QUIC_VERSION_V1;
> +	chosen = packet->version;
> +
> +	for (i = 0; i < count; i++) {
> +		if (!quic_packet_compatible_versions(versions[i]))
> +			continue;
> +		if (preferred == versions[i])
> +			pref_found = 1;
> +		if (chosen == versions[i])
> +			ch_found = 1;
> +		if (best < versions[i]) /* Track highest offered version. */
> +			best = versions[i];
> +	}
> +
> +	if (!pref_found && !ch_found && !best)
> +		return -1;
> +
> +	if (quic_is_serv(sk)) { /* Server prefers preferred version if offered, else chosen. */
> +		if (pref_found)
> +			best = preferred;
> +		else if (ch_found)
> +			best = chosen;
> +	} else { /* Client prefers chosen version, else preferred. */
> +		if (ch_found)
> +			best = chosen;
> +		else if (pref_found)
> +			best = preferred;
> +	}
> +
> +	if (packet->version == best)
> +		return 0;
> +
> +	/* Change to selected best version. */
> +	return quic_packet_version_change(sk, &quic_paths(sk)->orig_dcid, best);
> +}
> +
> +/* Extracts a QUIC token from a buffer in the Client Initial packet. */
> +static int quic_packet_get_token(struct quic_data *token, u8 **pp, u32 *plen)
> +{
> +	u64 len;
> +
> +	if (!quic_get_var(pp, plen, &len) || len > *plen)
> +		return -EINVAL;
> +	quic_data(token, *pp, len);
> +	*plen -= len;
> +	*pp += len;
> +	return 0;
> +}
> +
> +/* Process PMTU reduction event on a QUIC socket. */
> +void quic_packet_rcv_err_pmtu(struct sock *sk)
> +{
> +	struct quic_path_group *paths = quic_paths(sk);
> +	struct quic_packet *packet = quic_packet(sk);
> +	struct quic_config *c = quic_config(sk);
> +	u32 pathmtu, info, taglen;
> +	struct dst_entry *dst;
> +	bool reset_timer;
> +
> +	if (!ip_sk_accept_pmtu(sk))
> +		return;
> +
> +	info = clamp(paths->mtu_info, QUIC_PATH_MIN_PMTU, QUIC_PATH_MAX_PMTU);
> +	/* If PLPMTUD is not enabled, update MSS using the route and ICMP info. */
> +	if (!c->plpmtud_probe_interval) {
> +		if (quic_packet_route(sk) < 0)
> +			return;
> +
> +		dst = __sk_dst_get(sk);
> +		if (dst)
> +			dst->ops->update_pmtu(dst, sk, NULL, info, true);
> +		quic_packet_mss_update(sk, info - packet->hlen);
> +		return;
> +	}
> +	/* PLPMTUD is enabled: adjust to smaller PMTU, subtract headers and AEAD tag.  Also
> +	 * notify the QUIC path layer for possible state changes and probing.
> +	 */
> +	taglen = quic_packet_taglen(packet);
> +	info = info - packet->hlen - taglen;
> +	pathmtu = quic_path_pl_toobig(paths, info, &reset_timer);
> +	if (reset_timer)
> +		quic_timer_reset(sk, QUIC_TIMER_PMTU, c->plpmtud_probe_interval);
> +	if (pathmtu)
> +		quic_packet_mss_update(sk, pathmtu + taglen);
> +}
> +
> +/* Handle ICMP Toobig packet and update QUIC socket path MTU. */
> +static int quic_packet_rcv_err(struct sock *sk, struct sk_buff *skb)
> +{
> +	union quic_addr daddr, saddr;
> +	u32 info;
> +
> +	/* All we can do is lookup the matching QUIC socket by addresses. */
> +	quic_get_msg_addrs(skb, &saddr, &daddr);
> +	sk = quic_sock_lookup(skb, &daddr, &saddr, sk, NULL);
> +	if (!sk)
> +		return -ENOENT;
> +
> +	if (quic_get_mtu_info(skb, &info)) {
> +		sock_put(sk);
> +		return 0;
> +	}
> +
> +	/* Success: update socket path MTU info. */
> +	bh_lock_sock(sk);
> +	quic_paths(sk)->mtu_info = info;
> +	if (sock_owned_by_user(sk)) {
> +		/* Socket is in use by userspace context.  Defer MTU processing to later via
> +		 * tasklet.  Ensure the socket is not dropped before deferral.
> +		 */
> +		if (!test_and_set_bit(QUIC_MTU_REDUCED_DEFERRED, &sk->sk_tsq_flags))
> +			sock_hold(sk);
> +		goto out;
> +	}
> +	/* Otherwise, process the MTU reduction now. */
> +	quic_packet_rcv_err_pmtu(sk);
> +out:
> +	bh_unlock_sock(sk);
> +	sock_put(sk);
> +	return 1;
> +}
> +
> +#define QUIC_PACKET_BACKLOG_MAX		4096
> +
> +/* Queue a packet for later processing when sleeping is allowed. */
> +static int quic_packet_backlog_schedule(struct net *net, struct sk_buff *skb)
> +{
> +	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
> +	struct quic_net *qn = quic_net(net);
> +
> +	if (cb->backlog)
> +		return 0;
> +
> +	if (skb_queue_len_lockless(&qn->backlog_list) >= QUIC_PACKET_BACKLOG_MAX) {
> +		QUIC_INC_STATS(net, QUIC_MIB_PKT_RCVDROP);
> +		kfree_skb(skb);
> +		return -1;
> +	}
> +
> +	cb->backlog = 1;
> +	skb_queue_tail(&qn->backlog_list, skb);
> +	queue_work(quic_wq, &qn->work);
> +	return 1;
> +}
> +
> +#define TLS_MT_CLIENT_HELLO	1
> +#define TLS_EXT_alpn		16
> +
> +/*  TLS Client Hello Msg:
> + *
> + *    uint16 ProtocolVersion;
> + *    opaque Random[32];
> + *    uint8 CipherSuite[2];
> + *
> + *    struct {
> + *        ExtensionType extension_type;
> + *        opaque extension_data<0..2^16-1>;
> + *    } Extension;
> + *
> + *    struct {
> + *        ProtocolVersion legacy_version = 0x0303;
> + *        Random rand;
> + *        opaque legacy_session_id<0..32>;
> + *        CipherSuite cipher_suites<2..2^16-2>;
> + *        opaque legacy_compression_methods<1..2^8-1>;
> + *        Extension extensions<8..2^16-1>;
> + *    } ClientHello;
> + */
> +
> +#define TLS_CH_RANDOM_LEN	32
> +#define TLS_CH_VERSION_LEN	2
> +
> +/* Extract ALPN data from a TLS ClientHello message.
> + *
> + * Parses the TLS ClientHello handshake message to find the ALPN (Application Layer Protocol
> + * Negotiation) TLS extension. It validates the TLS ClientHello structure, including version,
> + * random, session ID, cipher suites, compression methods, and extensions. Once the ALPN
> + * extension is found, the ALPN protocols list is extracted and stored in @alpn.
> + *
> + * Return: 0 on success or no ALPN found, a negative error code on failed parsing.
> + */
> +static int quic_packet_get_alpn(struct quic_data *alpn, u8 *p, u32 len)
> +{
> +	int err = -EINVAL, found = 0;
> +	u64 length, type;
> +
> +	/* Verify handshake message type (ClientHello) and its length. */
> +	if (!quic_get_int(&p, &len, &type, 1) || type != TLS_MT_CLIENT_HELLO)
> +		return err;
> +	if (!quic_get_int(&p, &len, &length, 3) ||
> +	    length < TLS_CH_RANDOM_LEN + TLS_CH_VERSION_LEN)
> +		return err;
> +	if (len > (u32)length) /* Limit len to handshake message length if larger. */
> +		len = length;
> +	/* Skip legacy_version (2 bytes) + random (32 bytes). */
> +	p += TLS_CH_RANDOM_LEN + TLS_CH_VERSION_LEN;
> +	len -= TLS_CH_RANDOM_LEN + TLS_CH_VERSION_LEN;
> +	/* legacy_session_id_len must be zero (QUIC requirement). */
> +	if (!quic_get_int(&p, &len, &length, 1) || length)
> +		return err;
> +
> +	/* Skip cipher_suites (2 bytes length + variable data). */
> +	if (!quic_get_int(&p, &len, &length, 2) || length > (u64)len)
> +		return err;
> +	len -= length;
> +	p += length;
> +
> +	/* Skip legacy_compression_methods (1 byte length + variable data). */
> +	if (!quic_get_int(&p, &len, &length, 1) || length > (u64)len)
> +		return err;
> +	len -= length;
> +	p += length;
> +
> +	if (!quic_get_int(&p, &len, &length, 2)) /* Read TLS extensions length (2 bytes). */
> +		return err;
> +	if (len > (u32)length) /* Limit len to extensions length if larger. */
> +		len = length;
> +	while (len > 4) { /* Iterate over extensions to find ALPN (type TLS_EXT_alpn). */
> +		if (!quic_get_int(&p, &len, &type, 2))
> +			break;
> +		if (!quic_get_int(&p, &len, &length, 2))
> +			break;
> +		if (len < (u32)length) /* Incomplete TLS extensions. */
> +			return 0;
> +		if (type == TLS_EXT_alpn) { /* Found ALPN extension. */
> +			len = length;
> +			found = 1;
> +			break;
> +		}
> +		/* Skip non-ALPN extensions. */
> +		p += length;
> +		len -= length;
> +	}
> +	if (!found) { /* no ALPN extension found: set alpn->len = 0 and alpn->data = p. */
> +		quic_data(alpn, p, 0);
> +		return 0;
> +	}
> +
> +	/* Parse ALPN protocols list length (2 bytes). */
> +	if (!quic_get_int(&p, &len, &length, 2) || length > (u64)len)
> +		return err;
> +	quic_data(alpn, p, length); /* Store ALPN protocols list in alpn->data. */
> +	len = length;
> +	while (len) { /* Validate ALPN protocols list format. */
> +		if (!quic_get_int(&p, &len, &length, 1) || length > (u64)len) {
> +			/* Malformed ALPN entry: set alpn->len = 0 and alpn->data = NULL. */
> +			quic_data(alpn, NULL, 0);
> +			return err;
> +		}
> +		len -= length;
> +		p += length;
> +	}
> +	pr_debug("%s: alpn_len: %d\n", __func__, alpn->len);
> +	return 0;
> +}
> +
> +/* Parse ALPN from a QUIC Initial packet.
> + *
> + * This function processes a QUIC Initial packet to extract the ALPN from the TLS ClientHello
> + * message inside the QUIC CRYPTO frame. It verifies packet type, version compatibility,
> + * decrypts the packet payload, and locates the CRYPTO frame to parse the TLS ClientHello.
> + * Finally, it calls quic_packet_get_alpn() to extract the ALPN extension data.
> + *
> + * Return: 0 on success or no ALPN found, a negative error code on failed parsing.
> + */
> +static int quic_packet_parse_alpn(struct sk_buff *skb, struct quic_data *alpn)
> +{
> +	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
> +	struct net *net = sock_net(skb->sk);
> +	u8 *p = skb->data, *data, type;
> +	struct quic_conn_id dcid, scid;
> +	u32 len = skb->len, version;
> +	struct quic_crypto *crypto;
> +	struct quic_data token;
> +	u64 offset, length;
> +	int err = -EINVAL;
> +
> +	if (!sysctl_quic_alpn_demux)
> +		return 0;

Can this be made dynamic, turning it on if someone
listens on a socket with QUIC_SOCKOPT_ALPN set?

Otherwise I guess it silently doesn't work
and needs administrator interaction.

Thanks!
metze
