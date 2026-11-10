Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794349778;
	b=Oby5RqwUtw+3I2lStuxvUtJU+43QtkQcrliZvT3Rx2XMuHQxBHfAF/N4mMgTO78g03h0
	 cm3dQIIXWG1+RIaXtkmLvrVYvx9gnAaoF8HRIXEv5e1BjGF3/lvPlRoZErcwkZK+uKxVx
	 dAYDRSKG4M8JZJhVo5NnX3duPHqmKLZbbIKAVaX6I60d036Tcffiqvehv02AnPBNFubac
	 BkxmLnv8SzP4l3nuDRRSF51+TDMEAcZj4SDDBTuyx/zZ/dBthz3RlNRhaaVUD5zoCFjJT
	 ipojG+BFVp4rOkKEez4+3ZVULFg7AE2QWSFkXQnv3u83eE3LdDW1ApYlvQVFCmhepqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794349778;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=ThHb3I9RI7Z9OSRuQO3/orgGotd2GnkfQDmRvGkuxAU=;
	b=whjxH/guQEnC3tBhDXsRmH5eU70YNuNZK1+DiUaYPJqMEScyTC77rUCrTg0jpHpus6qI
	 eXDMW3GjhyghftLvk+3Gc8+mIiTGz+kAeRqgrTnXJWj9keGscssuJA5NkAK2yvabSuyQ6
	 omo4RaJE0TGyscEZhvGdouAMHiNK877zf1EfEgf2t9crBES3oR2dyWzymsQTE7Wa/B/e3
	 fnzTdpWNiuxrNCcdsdh0dgl0RD5wPzwbwOnKx/kQQEG+rVQIJJQp8yarQ1StRdir8fhdo
	 px0G5zaIjraW1JT7n+2hMvykv9EByZzRDIFhDpnZDzygcB+hySiTrCsomipETpnlqpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nxt2jprB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3B4606A31C;
	Tue, 10 Nov 2026 22:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nxt2jprB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B0D1F008A2;
	Tue, 10 Nov 2026 22:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794349777;
	bh=ThHb3I9RI7Z9OSRuQO3/orgGotd2GnkfQDmRvGkuxAU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=nxt2jprBhbabQ49vzHLzeyL8N9lde/fH4vpNoBHDaHw9YZWi4BM7TjichwYtGPz0T
	 YYj4bqxflnvMLyYNwT3eYYBKydZf6yRQ2NBrgglvvu1bjA6rUhXchQBx9wxsnEt7Fl
	 I+9M/hGFC//34dJRksgBHOzfoIcxoPhwL3vywQsn5D4QVwm781FmaX5E4uLqQCTlsV
	 Qx2sWR8uGpZJN5nWFIFohhlX2q659PvTEeuAYaPpgxIBqmpdh+ZclZiY7fUWbR93Sa
	 EYs6Z4EoGq5Y7qlrcRensLdHwTW9NmlYC1kH+diOyXH7Yi9iwZoTVpspfsyCHJNt12
	 B1roiCSXqyjkQ==
Subject: Re: [PATCH net-next v18 06/15] quic: add stream management
From: netdev-bot+sashiko@kernel.org
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, quic@lists.linux.dev, davem@davemloft.net,
 kuba@kernel.org, edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 metze@samba.org, mbuhl@openbsd.org, tfanelli@redhat.com, hepengtao@xiaomi.com,
 dreibh@simula.no, linux-cifs@vger.kernel.org, pc@manguebit.org,
 linkinjeon@kernel.org, tom@talpey.com, kernel-tls-handshake@lists.linux.dev,
 cel@kernel.org, jlayton@kernel.org, steved@redhat.com, hare@suse.de,
 aahringo@redhat.com, dhowells@redhat.com, matttbe@kernel.org,
 mail@johnericson.me, xiyou.wangcong@gmail.com, alibuda@linux.alibaba.com,
 jbaron@akamai.com, illiliti@protonmail.com, sd@queasysnail.net,
 marcelo.leitner@gmail.com, daniel@haxx.se, andrew.gospodarek@broadcom.com,
 mef@scarletmail.rutgers.edu, paul@jakma.org, kuniyu@google.com
Date: Tue, 10 Nov 2026 22:29:35 +0000
Message-ID: <179434977512.994134.8372693168405229960@kernel.org>
In-Reply-To: <097553ee70519682f76ff255f34b815e73b7c94a.1794241656.git.lucien.xin@gmail.com>
References: <097553ee70519682f76ff255f34b815e73b7c94a.1794241656.git.lucien.xin@gmail.com>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] quic_stream_set_param() (net/quic/stream.c:398-427) overwrites
  limits->next_bidi_stream_id and limits->next_uni_stream_id with the…
- [Medium] quic: wrong errno in quic_stream_get() for closed peer bidi
  stream
- [Low] The comments on active_stream_id in net/quic/stream.h do not
  match how net/quic/stream.c uses it.

--

quic: add stream management

This patch adds struct quic_stream_table and struct quic_stream for
per-socket QUIC stream management. quic_stream_get() and quic_stream_put()
acquire and release send and receive streams. It also adds helpers that
check stream ID limits, decide when MAX_STREAMS frames should be sent, and
apply transport parameters to the stream limits.

> diff --git a/net/quic/stream.c b/net/quic/stream.c
> new file mode 100644
> index 0000000000000..76ae699d6569c
> --- /dev/null
> +++ b/net/quic/stream.c
> @@ -0,0 +1,427 @@

[ ... ]

> +/* Configure stream hashtable from transport parameters. */
> +void quic_stream_set_param(struct quic_stream_table *streams,
> +			   struct quic_transport_param *p, bool is_serv)
> +{
> +	struct quic_stream_limits *limits = p->remote ? &streams->send :
> +							&streams->recv;
> +	u8 bidi_type, uni_type;
> +
> +	limits->max_stream_data_bidi_local = p->max_stream_data_bidi_local;
> +	limits->max_stream_data_bidi_remote = p->max_stream_data_bidi_remote;
> +	limits->max_stream_data_uni = p->max_stream_data_uni;
> +	limits->max_streams_bidi = p->max_streams_bidi;
> +	limits->max_streams_uni = p->max_streams_uni;
> +	limits->active_stream_id = -1;
> +
> +	if (p->remote ^ is_serv) {
> +		bidi_type = QUIC_STREAM_TYPE_CLIENT_BIDI;
> +		uni_type = QUIC_STREAM_TYPE_CLIENT_UNI;
> +	} else {
> +		bidi_type = QUIC_STREAM_TYPE_SERVER_BIDI;
> +		uni_type = QUIC_STREAM_TYPE_SERVER_UNI;
> +	}
> +
> +	limits->max_bidi_stream_id =
> +		quic_stream_streams_to_id(p->max_streams_bidi, bidi_type);
> +	limits->next_bidi_stream_id = bidi_type;
> +
> +	limits->max_uni_stream_id =
> +		quic_stream_streams_to_id(p->max_streams_uni, uni_type);
> +	limits->next_uni_stream_id = uni_type;
> +}

[Severity: Medium]
What happens if quic_stream_set_param() runs a second time for the same
direction after some streams are already open?

Each call resets next_bidi_stream_id and next_uni_stream_id to the base
type ID. The streams already in the hash table stay there, and
streams_bidi/streams_uni are not changed.

quic_stream_create() starts at limits->next_*_stream_id and inserts every
ID up to the requested one. It does not check for an existing entry:

	stream_id = limits->next_bidi_stream_id;
	if (quic_stream_id_uni(max_stream_id))
		stream_id = limits->next_uni_stream_id;
	...
	while (stream_id <= max_stream_id) {
		stream = kzalloc_obj(*stream, gfp);

quic_stream_id_closed() also looks only at next_*_stream_id:

	if (quic_stream_id_uni(stream_id))
		return stream_id < limits->next_uni_stream_id;
	return stream_id < limits->next_bidi_stream_id;

A 0-RTT client looks like one plausible case:

1. It applies the remembered peer parameters (remote=1).
2. It opens bidi streams 0 and 4 for early data.
3. It applies the server's real parameters (remote=1) through
   QUIC_SOCKOPT_TRANSPORT_PARAM_EXT.

After step 3, send.next_bidi_stream_id is back to 0, but streams 0 and 4
are still hashed.

Next, quic_stream_get(id=8, MSG_QUIC_STREAM_NEW) misses in the hash and
passes the closed check. quic_stream_create() then allocates new objects
for 0, 4 and 8. Would that leave duplicate IDs in the per-socket hash,
with the new zeroed objects shadowing the originals in quic_stream_find()?
streams_bidi would also go up by 3 instead of 1.

This also seems to let stream IDs that were already closed and deleted be
opened again, which RFC 9000 section 2.1 does not allow.

There is a related case. quic_stream_create() chooses its start ID from
the uni bit only. It never checks that the initiator bit of
next_*_stream_id matches the requested ID.

If is_serv is different between set_param() and get(), could create
return a stream with a different ID than the one requested? For example,
with next=1 a request for 4 returns stream 1. With next=1 a request for 0
allocates nothing and returns NULL, which quic_stream_get() reports as
-ENOMEM.

quic_stream_put() would then decrement the wrong locality counter, and
could underflow the u16 streams_bidi:

	if (quic_stream_id_local(stream->id, is_serv)) {
		streams->send.streams_bidi--;
	} else {
		streams->recv.streams_bidi--;

I could not find any callers of quic_stream_set_param() or
quic_stream_get() in the series yet. Whether this can trigger depends on
how the follow-up patches call them.

Should quic_stream_set_param() be applied only once, reconcile with
streams that already exist, or document that it must not be called after
streams are open?

> diff --git a/net/quic/stream.h b/net/quic/stream.h
> new file mode 100644
> index 0000000000000..48b27aa339679
> --- /dev/null
> +++ b/net/quic/stream.h
> @@ -0,0 +1,133 @@

[ ... ]

> +	s64 next_bidi_stream_id; /* Next bidi stream ID to open or accept */
> +	s64 next_uni_stream_id;  /* Next uni stream ID to open or accept */
> +	s64 max_bidi_stream_id;  /* Highest allowed bidi stream ID */
> +	s64 max_uni_stream_id;   /* Highest allowed uni stream ID */
> +	s64 active_stream_id;    /* Most recently opened stream ID */

[Severity: Low]
This isn't a bug, but does this comment fit both the send and recv
instances of struct quic_stream_limits?

The only place that writes the field is quic_stream_get():

	if (send || quic_stream_id_valid(stream_id, is_serv, !send))
		streams->send.active_stream_id = stream_id;

That writes the send instance even on the RX path (send == false) when
the peer opens a bidi stream. A uni stream opened by the peer never
updates it. recv.active_stream_id is set to -1 in quic_stream_set_param()
and never written after that.

So the field seems to mean the most recently opened stream we can send on.
It only means something in the send instance, which struct
quic_stream_table describes as "Limits advertised by peer".

Could the comment, or where the field lives, be changed to match? Nothing
reads either copy yet in this series.

[ ... ]

> @@ -0,0 +1,427 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/* QUIC kernel implementation
> + * (C) Copyright Red Hat Corp. 2023
> + *
> + * This file is part of the QUIC kernel implementation
> + *
> + * Stream management.
> + *
> + * Written or modified by:
> + *    Xin Long <lucien.xin@gmail.com>
> + */
> +
> +#include <net/netns/hash.h>
> +#include <linux/jhash.h>
> +#include <linux/quic.h>
> +
> +#include "common.h"
> +#include "stream.h"
> +
> +/* Check if a stream ID is valid for sending or receiving. */
> +static bool quic_stream_id_valid(s64 stream_id, bool is_serv, bool send)
> +{
> +	u8 type = (stream_id & QUIC_STREAM_TYPE_MASK);
> +
> +	if (stream_id < 0)
> +		return false;
> +
> +	if (send) {
> +		if (is_serv)
> +			return type != QUIC_STREAM_TYPE_CLIENT_UNI;
> +		return type != QUIC_STREAM_TYPE_SERVER_UNI;
> +	}
> +	if (is_serv)
> +		return type != QUIC_STREAM_TYPE_SERVER_UNI;
> +	return type != QUIC_STREAM_TYPE_CLIENT_UNI;
> +}
> +
> +/* Check if a stream ID was initiated locally. */
> +static bool quic_stream_id_local(s64 stream_id, bool is_serv)
> +{
> +	return is_serv ^ !(stream_id & QUIC_STREAM_TYPE_SERVER_MASK);
> +}
> +
> +/* Check if a stream ID represents a unidirectional stream. */
> +static bool quic_stream_id_uni(s64 stream_id)
> +{
> +	return stream_id & QUIC_STREAM_TYPE_UNI_MASK;
> +}
> +
> +#define QUIC_STREAM_HT_SIZE	64
> +
> +static struct hlist_head *quic_stream_head(struct quic_stream_table *streams,
> +					   s64 stream_id, struct net *net)
> +{
> +	u32 hash = jhash_1word((u32)(stream_id >> 1), net_hash_mix(net));
> +
> +	return &streams->head[hash & (QUIC_STREAM_HT_SIZE - 1)];
> +}
> +
> +struct quic_stream *quic_stream_find(struct quic_stream_table *streams,
> +				     s64 stream_id, struct net *net)
> +{
> +	struct hlist_head *head = quic_stream_head(streams, stream_id, net);
> +	struct quic_stream *stream;
> +
> +	hlist_for_each_entry(stream, head, node) {
> +		if (stream->id == stream_id)
> +			break;
> +	}
> +	return stream;
> +}
> +
> +static void quic_stream_add(struct quic_stream_table *streams,
> +			    struct quic_stream *stream, struct net *net)
> +{
> +	struct hlist_head *head;
> +
> +	head = quic_stream_head(streams, stream->id, net);
> +	hlist_add_head(&stream->node, head);
> +}
> +
> +static void quic_stream_delete(struct quic_stream *stream)
> +{
> +	hlist_del_init(&stream->node);
> +	kfree(stream);
> +}
> +
> +/* Create and register new streams for sending or receiving. */
> +static struct quic_stream *quic_stream_create(struct quic_stream_table *streams,
> +					      s64 max_stream_id, bool send,
> +					      bool is_serv, struct net *net,
> +					      gfp_t gfp)
> +{
> +	struct quic_stream *pos, *stream = NULL;
> +	struct quic_stream_limits *limits;
> +	struct hlist_node *tmp;
> +	HLIST_HEAD(head);
> +	s64 stream_id;
> +	u32 count = 0;
> +
> +	gfp |= __GFP_ACCOUNT;
> +	limits = send ? &streams->send : &streams->recv;
> +	stream_id = limits->next_bidi_stream_id;
> +	if (quic_stream_id_uni(max_stream_id))
> +		stream_id = limits->next_uni_stream_id;
> +
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
> +				stream->recv.state =
> +					QUIC_STREAM_RECV_STATE_RECV;
> +				stream->recv.window = stream->recv.max_bytes;
> +			}
> +			hlist_add_head(&stream->node, &head);
> +			stream_id += QUIC_STREAM_ID_STEP;
> +			continue;
> +		}
> +
> +		if (quic_stream_id_local(stream_id, is_serv)) {
> +			stream->send.max_bytes =
> +				streams->send.max_stream_data_bidi_remote;
> +			stream->recv.max_bytes =
> +				streams->recv.max_stream_data_bidi_local;
> +		} else {
> +			stream->send.max_bytes =
> +				streams->send.max_stream_data_bidi_local;
> +			stream->recv.max_bytes =
> +				streams->recv.max_stream_data_bidi_remote;
> +		}
> +		stream->recv.state = QUIC_STREAM_RECV_STATE_RECV;
> +		stream->recv.window = stream->recv.max_bytes;
> +		hlist_add_head(&stream->node, &head);
> +		stream_id += QUIC_STREAM_ID_STEP;
> +	}
> +
> +	hlist_for_each_entry_safe(pos, tmp, &head, node) {
> +		hlist_del_init(&pos->node);
> +		quic_stream_add(streams, pos, net);
> +		count++;
> +	}
> +
> +	/* Streams must be opened sequentially. Update the next stream ID so the
> +	 * correct starting point is known if an out-of-order open is requested.
> +	 * Note overflow of next_uni/bidi_stream_id is impossible with s64.
> +	 */
> +	if (quic_stream_id_uni(stream_id)) {
> +		limits->next_uni_stream_id = stream_id;
> +		limits->streams_uni += count;
> +		return stream;
> +	}
> +
> +	limits->next_bidi_stream_id = stream_id;
> +	limits->streams_bidi += count;
> +	return stream;
> +
> +free:
> +	hlist_for_each_entry_safe(pos, tmp, &head, node) {
> +		hlist_del_init(&pos->node);
> +		kfree(pos);
> +	}
> +	return NULL;
> +}
> +
> +/* Check if a send or receive stream ID is already closed. */
> +static bool quic_stream_id_closed(struct quic_stream_table *streams,
> +				  s64 stream_id, bool send)
> +{
> +	struct quic_stream_limits *limits = send ? &streams->send :
> +						   &streams->recv;
> +
> +	if (quic_stream_id_uni(stream_id))
> +		return stream_id < limits->next_uni_stream_id;
> +	return stream_id < limits->next_bidi_stream_id;
> +}
> +
> +/* Check if a stream ID would exceed local (recv) or peer (send) limits. */
> +bool quic_stream_id_exceeds(struct quic_stream_table *streams, s64 stream_id,
> +			    bool send)
> +{
> +	u64 nstreams;
> +
> +	if (!send) {
> +		/* recv.max_uni/bidi_stream_id is updated in
> +		 * quic_stream_max_streams_update() already based on
> +		 * next_uni/bidi_stream_id, max_streams_uni/bidi, and
> +		 * streams_uni/bidi, so only recv.max_uni/bidi_stream_id needs
> +		 * to be checked.
> +		 */
> +		if (quic_stream_id_uni(stream_id))
> +			return stream_id > streams->recv.max_uni_stream_id;
> +
> +		return stream_id > streams->recv.max_bidi_stream_id;
> +	}
> +
> +	if (quic_stream_id_uni(stream_id)) {
> +		if (stream_id > streams->send.max_uni_stream_id)
> +			return true;
> +		stream_id -= streams->send.next_uni_stream_id;
> +		nstreams = quic_stream_id_to_streams(stream_id);
> +
> +		return nstreams + streams->send.streams_uni >
> +		       streams->send.max_streams_uni;
> +	}
> +
> +	if (stream_id > streams->send.max_bidi_stream_id)
> +		return true;
> +	stream_id -= streams->send.next_bidi_stream_id;
> +	nstreams = quic_stream_id_to_streams(stream_id);
> +
> +	return nstreams + streams->send.streams_bidi >
> +	       streams->send.max_streams_bidi;
> +}
> +
> +/* Get or create a send or recv stream by ID. Requires sock lock held. */
> +struct quic_stream *quic_stream_get(struct quic_stream_table *streams,
> +				    s64 stream_id, u32 flags, bool is_serv,
> +				    bool send, struct net *net, gfp_t gfp)
> +{
> +	struct quic_stream *stream;
> +
> +	if (!quic_stream_id_valid(stream_id, is_serv, send))
> +		return ERR_PTR(-EINVAL);
> +
> +	stream = quic_stream_find(streams, stream_id, net);
> +	if (stream)
> +		return stream;
> +
> +	if (!send && quic_stream_id_local(stream_id, is_serv)) {
> +		if (quic_stream_id_closed(streams, stream_id, !send))
> +			return ERR_PTR(-ENOSTR);
> +		return ERR_PTR(-EINVAL);
> +	}
> +	if (send && !quic_stream_id_local(stream_id, is_serv))
> +		return ERR_PTR(-EINVAL);
> +
> +	if (quic_stream_id_closed(streams, stream_id, send))
> +		return ERR_PTR(-ENOSTR);
> +
> +	if (!(flags & MSG_QUIC_STREAM_NEW))
> +		return ERR_PTR(-EINVAL);
> +
> +	if (quic_stream_id_exceeds(streams, stream_id, send))
> +		return ERR_PTR(-EAGAIN);
> +
> +	stream = quic_stream_create(streams, stream_id, send, is_serv, net,
> +				    gfp);
> +	if (!stream)
> +		return ERR_PTR(-ENOMEM);
> +
> +	if (send || quic_stream_id_valid(stream_id, is_serv, !send))
> +		streams->send.active_stream_id = stream_id;
> +
> +	return stream;
> +}
> +
> +/* Release or clean up a send or recv stream. This function updates stream
> + * counters and state when a send stream has either successfully sent all data
> + * or has been reset, or when a recv stream has either received all data or has
> + * been reset. Requires sock lock held.
> + */
> +void quic_stream_put(struct quic_stream_table *streams,
> +		     struct quic_stream *stream, bool is_serv, bool send)
> +{
> +	if (quic_stream_id_uni(stream->id)) {
> +		/* For uni streams, decrement uni count and delete stream. */
> +		if (send) {
> +			streams->send.streams_uni--;
> +			quic_stream_delete(stream);
> +			return;
> +		}
> +		streams->recv.streams_uni--;
> +		streams->recv.uni_pending = 1;
> +		quic_stream_delete(stream);
> +		return;
> +	}
> +
> +	/* For bidi streams, proceed only if both send and receive in a final
> +	 * state.
> +	 */
> +	if (send) {
> +		if (stream->recv.state < QUIC_STREAM_RECV_STATE_RECVD)
> +			return;
> +	} else {
> +		if (stream->send.state != QUIC_STREAM_SEND_STATE_RECVD &&
> +		    stream->send.state != QUIC_STREAM_SEND_STATE_RESET_RECVD)
> +			return;
> +	}
> +	if (quic_stream_id_local(stream->id, is_serv)) {
> +		/* Local-initiated stream: decrement send.bidi count. */
> +		streams->send.streams_bidi--;
> +	} else {
> +		/* Remote-initiated stream: decrement recv.bidi count. */
> +		streams->recv.streams_bidi--;
> +		streams->recv.bidi_pending = 1;
> +	}
> +	quic_stream_delete(stream);
> +}
> +
> +/* Updates the maximum allowed incoming stream IDs if any streams were recently
> + * closed. Recalculates the max_uni and max_bidi stream count limits based on
> + * the number of open streams and whether any were marked for deletion.
> + *
> + * Returns true if either max_uni or max_bidi was updated, indicating that a
> + * MAX_STREAMS_UNI or MAX_STREAMS_BIDI frame should be sent to the peer.
> + */
> +bool quic_stream_max_streams_update(struct quic_stream_table *streams,
> +				    s64 *max_uni, s64 *max_bidi)
> +{
> +	s64 max, rem;
> +
> +	*max_uni = 0;
> +	*max_bidi = 0;
> +	if (streams->recv.uni_pending) {
> +		rem = streams->recv.max_streams_uni - streams->recv.streams_uni;
> +		max = streams->recv.next_uni_stream_id - QUIC_STREAM_ID_STEP +
> +		      (rem << QUIC_STREAM_TYPE_BITS);
> +
> +		streams->recv.max_uni_stream_id = max;
> +		*max_uni = quic_stream_id_to_streams(max);
> +		streams->recv.uni_pending = 0;
> +	}
> +	if (streams->recv.bidi_pending) {
> +		rem = streams->recv.max_streams_bidi -
> +		      streams->recv.streams_bidi;
> +		max = streams->recv.next_bidi_stream_id - QUIC_STREAM_ID_STEP +
> +			(rem << QUIC_STREAM_TYPE_BITS);
> +
> +		streams->recv.max_bidi_stream_id = max;
> +		*max_bidi = quic_stream_id_to_streams(max);
> +		streams->recv.bidi_pending = 0;
> +	}
> +
> +	return *max_uni || *max_bidi;
> +}
> +
> +int quic_stream_init(struct quic_stream_table *streams)
> +{
> +	struct hlist_head *head;
> +	int i;
> +
> +	head = kmalloc_objs(*head, QUIC_STREAM_HT_SIZE, GFP_KERNEL_ACCOUNT);
> +	if (!head)
> +		return -ENOMEM;
> +	for (i = 0; i < QUIC_STREAM_HT_SIZE; i++)
> +		INIT_HLIST_HEAD(&head[i]);
> +	streams->head = head;
> +	return 0;
> +}
> +
> +void quic_stream_free(struct quic_stream_table *streams)
> +{
> +	struct quic_stream *stream;
> +	struct hlist_head *head;
> +	struct hlist_node *tmp;
> +	int i;
> +
> +	if (!streams->head)
> +		return;
> +
> +	for (i = 0; i < QUIC_STREAM_HT_SIZE; i++) {
> +		head = &streams->head[i];
> +		hlist_for_each_entry_safe(stream, tmp, head, node)
> +			quic_stream_delete(stream);
> +	}
> +	kfree(streams->head);
> +	streams->head = NULL;
> +}
> +
> +/* Populate transport parameters from stream hash table. */
> +void quic_stream_get_param(struct quic_stream_table *streams,
> +			   struct quic_transport_param *p)
> +{
> +	struct quic_stream_limits *limits = p->remote ? &streams->send :
> +							&streams->recv;
> +
> +	p->max_stream_data_bidi_remote = limits->max_stream_data_bidi_remote;
> +	p->max_stream_data_bidi_local = limits->max_stream_data_bidi_local;
> +	p->max_stream_data_uni = limits->max_stream_data_uni;
> +	p->max_streams_bidi = limits->max_streams_bidi;
> +	p->max_streams_uni = limits->max_streams_uni;
> +}
> +
> +/* Configure stream hashtable from transport parameters. */
> +void quic_stream_set_param(struct quic_stream_table *streams,
> +			   struct quic_transport_param *p, bool is_serv)
> +{
> +	struct quic_stream_limits *limits = p->remote ? &streams->send :
> +							&streams->recv;
> +	u8 bidi_type, uni_type;
> +
> +	limits->max_stream_data_bidi_local = p->max_stream_data_bidi_local;
> +	limits->max_stream_data_bidi_remote = p->max_stream_data_bidi_remote;
> +	limits->max_stream_data_uni = p->max_stream_data_uni;
> +	limits->max_streams_bidi = p->max_streams_bidi;
> +	limits->max_streams_uni = p->max_streams_uni;
> +	limits->active_stream_id = -1;
> +
> +	if (p->remote ^ is_serv) {
> +		bidi_type = QUIC_STREAM_TYPE_CLIENT_BIDI;
> +		uni_type = QUIC_STREAM_TYPE_CLIENT_UNI;
> +	} else {
> +		bidi_type = QUIC_STREAM_TYPE_SERVER_BIDI;
> +		uni_type = QUIC_STREAM_TYPE_SERVER_UNI;
> +	}
> +
> +	limits->max_bidi_stream_id =
> +		quic_stream_streams_to_id(p->max_streams_bidi, bidi_type);
> +	limits->next_bidi_stream_id = bidi_type;
> +
> +	limits->max_uni_stream_id =
> +		quic_stream_streams_to_id(p->max_streams_uni, uni_type);
> +	limits->next_uni_stream_id = uni_type;
> +}

[Severity: Medium]
Is -EINVAL the intended result here for a peer-initiated bidi stream
that was already opened and has since been closed?

The RX path handles the mirror case differently. When a
locally-initiated bidi stream is no longer in the hash,
quic_stream_get() calls quic_stream_id_closed(streams, stream_id,
!send). It returns -ENOSTR if that ID was already used, and -EINVAL
only if it was never opened. The TX path has no such check for a
peer-initiated stream.

A peer-initiated bidi stream is created on the RX path, which advances
streams->recv.next_bidi_stream_id. Once both directions reach a final
state, quic_stream_put() deletes it from the hash. Suppose
quic_stream_get() is later called for the same ID with send == true:

1. quic_stream_find() misses.
2. The send && !quic_stream_id_local() branch returns -EINVAL.

That happens even though quic_stream_id_closed(streams, stream_id,
false) would report the stream as closed.

This does not look like a corner case. When the peer opens a bidi
stream, quic_stream_get() also records that ID in
streams->send.active_stream_id. If the follow-up sendmsg path falls
back to the active stream ID, a send after teardown would get -EINVAL
instead of -ENOSTR.

Userspace that treats ENOSTR as "this stream is finished" and EINVAL
as a bad argument would get the wrong signal. It would also behave
differently depending on which side opened the stream.

Would it make sense to merge the two branches into one
send != quic_stream_id_local(stream_id, is_serv) check? That check
would consult quic_stream_id_closed(streams, stream_id, !send) before
falling back to -EINVAL. There are no callers in this series yet, so
how much this matters depends on how the later patches use the
error.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1794241654.git.lucien.xin%40gmail.com
