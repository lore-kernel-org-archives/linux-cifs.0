Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795483272;
	b=5CRkq1hriDoN8Zy4+bBFDPHL5ca5HK3oYryV/aiHXAgPXYccDhXYfVrucEaeF3tLmgrO
	 yWmXeiCusXKONgSv1e3JkCB2K0FRqHxS9AJ8YNpu8v6YOnzllw6F6eug4TTVhZ/lwMPhX
	 FO8EhUam/GVykYe4U6ASWq2SHbHJC/xmOtnnOd1nDVRo0tN4Rr6SsoLGeyYK0UPW8+5wN
	 ZIlD33dkM9pqkKSlbnkcw6y8F0QRF29dudKVhzKmssX35Vio8CO/ku6+G0pc/HcUIaHu2
	 fzBt+czuWA76plAWlfXEJuaEbSrUdVQcEs6IqNpalhk+Fyxe2I0FaND2HrPFw7di42A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795483272;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=39GyTO/gzqytPAtnbDSte+JuTTz0fNzUhnOaxl3OEnk=;
	b=KAw5J7tv9UidbTAkMcpZkTxk1wC0T/m24OVqjaNYsYQDQFCDP7yrZouO8EJ3sI0M1OsF
	 jCg/pwoSbIss+JGAqlUparqiDqeGNGkFVSS8uFFLVdfXNX+7Fl+yPD/hLZkuhrQIjRFPf
	 yTFVu7HrohxCTMsyQCdKOB/Tz9LzzE5IebBax4PkzkQr1WPkuCpuRwWwOqcOBFgKvHbqD
	 RHAELMZyiEelbF803siR/LVx7Vdcjvlu+o8XnYMd9X3AxUFv1VuFbkkGzbumUBElSyKDw
	 V93hA15ALtEyNWsksIFEjkH2PNoYHRZWVXvgTOAEB1cSenldbN3TLeqeE3Y8DFqPBXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PAgPguxB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0E6606A31E;
	Tue, 24 Nov 2026 01:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PAgPguxB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48CB51F000D1;
	Tue, 24 Nov 2026 01:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795483272;
	bh=39GyTO/gzqytPAtnbDSte+JuTTz0fNzUhnOaxl3OEnk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=PAgPguxBUrHpV+vZfh5OZHAwF6atdXKH2vS0Y2OycYWvh9kAvXyNO5botS1d5Hecw
	 C2sWpRkk+dw+otuDSZa8m8wDhFBZiwGs9qzUgvnh3tTzXq8iqqWN/7HCUBlce4QmT7
	 2gQCZJJ1e8ZiR41HFr8hujYbHfsCe8O+VayEy7mxy8M8UOB1IWGN1Ex1xlFPCkFL2t
	 fVlsfmxOdNRM9of/dx0n2eKLVjYkazfwJ2oPt/RHFPvRlyEL6ulmvbJJ2mvVotvEu9
	 edHPOZ8zwwfipYkipgxpbPBTJAU6mIar5DCDwuclD+WnPWgraJhcraEsJ6qM8r4W97
	 UMscRyKzPTVAA==
Subject: Re: [PATCH net-next v19 06/15] quic: add stream management
From: netdev-bot+sashiko@kernel.org
To: lucien.xin@gmail.com
Cc: netdev@vger.kernel.org, quic@lists.linux.dev, davem@davemloft.net,
 kuba@kernel.org, edumazet@kernel.org, pabeni@redhat.com, horms@kernel.org,
 metze@samba.org, mbuhl@openbsd.org, tfanelli@redhat.com, hepengtao@xiaomi.com,
 dreibh@simula.no, jamie.bainbridge@gmail.com, linux-cifs@vger.kernel.org,
 pc@manguebit.org, linkinjeon@kernel.org, tom@talpey.com,
 kernel-tls-handshake@lists.linux.dev, cel@kernel.org, jlayton@kernel.org,
 steved@redhat.com, hare@suse.de, aahringo@redhat.com, dhowells@redhat.com,
 matttbe@kernel.org, mail@johnericson.me, xiyou.wangcong@gmail.com,
 alibuda@linux.alibaba.com, jbaron@akamai.com, illiliti@protonmail.com,
 sd@queasysnail.net, marcelo.leitner@gmail.com, daniel@haxx.se,
 andrew.gospodarek@broadcom.com, mef@scarletmail.rutgers.edu, paul@jakma.org,
 kuniyu@google.com
Date: Tue, 24 Nov 2026 01:21:09 +0000
Message-ID: <179548326987.3135.7163509585500687471@kernel.org>
In-Reply-To: <052a21a5f6e57bb7f6db0f6e274dce9d8523805c.1795393691.git.lucien.xin@gmail.com>
References: <052a21a5f6e57bb7f6db0f6e274dce9d8523805c.1795393691.git.lucien.xin@gmail.com>
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

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] quic: broken next stream ID type update in
  quic_stream_set_param()

--

> diff --git a/net/quic/stream.c b/net/quic/stream.c
> --- /dev/null
> +++ b/net/quic/stream.c
> @@ -0,0 +1,426 @@
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
> +/* Check if a stream ID belongs to the local endpoint. */
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
> +/* Check if a stream ID was already used. */
> +static bool quic_stream_id_closed(struct quic_stream_table *streams,
> +				  s64 stream_id, bool is_serv)
> +{
> +	bool local = quic_stream_id_local(stream_id, is_serv);
> +	struct quic_stream_limits *limits;
> +
> +	limits = local ? &streams->send : &streams->recv;
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
> +	if (quic_stream_id_closed(streams, stream_id, is_serv))
> +		return ERR_PTR(-ENOSTR);
> +
> +	/* Cannot create if the other side must initiate this stream. */
> +	if (send != quic_stream_id_local(stream_id, is_serv))
> +		return ERR_PTR(-EINVAL);
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
> +		streams->active_stream_id = stream_id;
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
> +	streams->active_stream_id = -1;
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
> +	if (limits->next_bidi_stream_id < bidi_type)
> +		limits->next_bidi_stream_id = bidi_type;
> +
> +	limits->max_uni_stream_id =
> +		quic_stream_streams_to_id(p->max_streams_uni, uni_type);
> +	if (limits->next_uni_stream_id < uni_type)
> +		limits->next_uni_stream_id = uni_type;
> +}

[Severity: Medium]
This guard only works when the low two bits of next_bidi_stream_id
and next_uni_stream_id already match the type being applied. It does
not correct them if the role changes before any stream is opened.

Suppose quic_stream_set_param() is first called for the local
parameters (p->remote == 0) while quic_is_serv() is still false, for
example before listen() sets sk_max_ack_backlog. Then
recv.next_bidi_stream_id becomes 1 and recv.next_uni_stream_id
becomes 3. When the same parameters are applied again after the
socket has become a server, bidi_type is 0 and uni_type is 2.
Neither comparison is true (next < 0 can never be true for the
client bidi type), so the stale server parity stays.

After that, quic_stream_id_closed() treats client streams 0 and 2 as
already closed, and quic_stream_get() fails them with -ENOSTR.

It gets worse if the peer opens stream 4 first. quic_stream_create()
starts from 1 and steps by QUIC_STREAM_ID_STEP, so it inserts stream
1 into the hash table, counts it in recv.streams_bidi, and returns it
in place of stream 4. When quic_stream_put() later releases it,
quic_stream_id_local(1, true) is true. So send.streams_bidi is
decremented instead, and that u16 wraps to 65535.

Opening any stream moves next_*_stream_id to at least
QUIC_STREAM_ID_STEP. Would it be enough to compare against
QUIC_STREAM_ID_STEP here instead of the type value? Another option
is to keep the upper bits and replace only the type bits. If
set_param() can never be re-applied across a client/server
transition, could that be documented here?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1795393690.git.lucien.xin%40gmail.com
