Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFBD2D3A7C;
	Wed,  7 Oct 2026 01:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791335112; cv=none; b=SgFdLGwpxDC9oJY2wjC0YtT0U/kEPwZkOdmSc2jJ3853yNI/8ArNefHfvIgbd2tmjfrwFp3y+dLHcqylz8BEEgWC+Y3xDtJ8Yjj2Bw7Nz7bn1zGr1jMd4KImcxP96HYbu/3EdC7LD+Pe/6AyWM4ZYZWScR3vy1JZAT6L+QiOYOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791335112; c=relaxed/simple;
	bh=4aQUJby0ATovBDTSq/h3myJpdFjvKp7634bLj+NHI90=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=by1oMVPBof7p1mLhYTjtF6irkRiwgSXOkDFB36Uy27F3/kpNzfQbxGtJF6WUjVlE4Aamt8FNwdnsMmDLG2xyCdTdOfzOcTy/i1FZWhEc8QJdm9sOIZUPy0CVAovoClaS86SyYebBND9I4Nu+FgXu40tqfAeZRB+C4ZcuOxfhdDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jB7SGNMS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jB7SGNMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F901F0089F;
	Wed,  7 Oct 2026 01:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791335110;
	bh=9uR+SkPMDlxkozw3VA2KJyMu7Cb4AV71fq5494Rprxk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=jB7SGNMSotX3J1UXE5rmwtxQ3G/ytgfyQR0Mj8csJDCUN7T3yeiq//ENmQ73x+4gJ
	 4cbXWUPOnzgE3s0N+FWVkXG6shmy9k+KQYCqak8ORiTrfrd4DijMYFAYdgGl1zFDKC
	 AeXyTg8b+RTNsh0P0yKM0Y2vaBdrpeak/MJiPrxPQfQke+pxwMWWMkGuIoW+Yrxb60
	 pl/qhXtB4QVKnh0aMvHbjpsLphH4jcJlwtQl9Jf3n/U1sw/KUPaVUIrDUPy8bzgbbA
	 yW2IUNVKX626SvMvC54s7o3qfl+gL0oGIGZ3XVScjDX0GoBT8p9A+duHmCPfr2lDuc
	 EFETI+WsGQMcg==
Subject: Re: [PATCH net-next v16 06/15] quic: add stream management
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
 mef@scarletmail.rutgers.edu, paul@jakma.org, kuniyu@google.com
Date: Wed, 07 Oct 2026 01:05:08 +0000
Message-ID: <179133510837.434549.10953579867468905208@kernel.org>
In-Reply-To: =?utf-8?q?=3Ca691d4ce8c646dd1d70f1c0f88f081ec30bd03a1=2E1791227?=
 =?utf-8?q?050=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3Ca691d4ce8c646dd1d70f1c0f88f081ec30bd03a1=2E17912270?=
 =?utf-8?q?50=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
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
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] quic_stream_init() (net/quic/stream.c) allocates the per-
  socket 64-entry hlist_head table (512 bytes on 64-bit) with…
- [Medium] The per-socket stream table has a fixed 64 buckets and a
  predictable, unkeyed hash, (stream_id >> 1) & 63 in quic_stream_head().
- [Low] The uAPI header (include/uapi/linux/quic.h) puts send and receive
  stream states in one anonymous enum, so the receive states start at 6…
- [Low] The comment above
  bidi_blocked/uni_blocked/bidi_pending/uni_pending in struct…

--

quic: add stream management

This patch adds struct quic_stream_table, a per-socket hash table of
struct quic_stream objects. It also adds helpers to get, create and put
send and receive streams. It includes logic to check stream ID limits and
to decide when MAX_STREAMS frames should be sent to the peer.

> diff --git a/net/quic/stream.c b/net/quic/stream.c
> new file mode 100644
> index 0000000000000..c0bfaab0be8e2
> --- /dev/null
> +++ b/net/quic/stream.c

[ ... ]

> +#define QUIC_STREAM_HT_SIZE	64
> +
> +static struct hlist_head *quic_stream_head(struct quic_stream_table *streams,
> +					   s64 stream_id)
> +{
> +	/* Skip the SERVER initiator bit, which is constant per endpoint. */
> +	return &streams->head[(stream_id >> 1) & (QUIC_STREAM_HT_SIZE - 1)];
> +}
> +
> +struct quic_stream *quic_stream_find(struct quic_stream_table *streams,
> +				     s64 stream_id)
> +{
> +	struct hlist_head *head = quic_stream_head(streams, stream_id);
> +	struct quic_stream *stream;
> +
> +	hlist_for_each_entry(stream, head, node) {
> +		if (stream->id == stream_id)
> +			break;
> +	}
> +	return stream;
> +}

[Severity: Medium]
Can a remote peer put all of its live streams on a single chain here?

The hash in quic_stream_head() is fixed and has no key. Bit 0 of
(stream_id >> 1) is the uni bit, so bidi IDs land only in even buckets and
uni IDs only in odd ones. That gives each stream type 32 buckets, and
every 32nd stream of a type maps to the same bucket.

The peer decides which of its streams stay open. It could open streams up
to the advertised limit and then finish or reset every stream except the
ones that hash to one bucket. It then gets new credit through:

quic_stream_put()
    streams->recv.bidi_pending = 1;
quic_stream_max_streams_update()
    streams->recv.max_bidi_stream_id = max;

If the peer repeats this, every live peer stream ends up on one hlist
chain. That is up to recv.max_streams_*, which is 100 by default and up to
QUIC_MAX_STREAMS.

Once the RX path lands, quic_stream_get() will call quic_stream_find() for
each received STREAM, RESET_STREAM, STOP_SENDING and MAX_STREAM_DATA
frame. Each lookup would then walk the whole chain under the socket lock
in softirq. A single datagram can carry many small STREAM frames.

Would a keyed hash (for example, seeded per socket), or a larger or
resizable table, be worth considering? This lookup does not have an RX
caller in this series yet.

[ ... ]

> +/* Create and register new streams for sending or receiving. */
> +static struct quic_stream *quic_stream_create(struct quic_stream_table *streams,
> +					      s64 max_stream_id, bool send,
> +					      bool is_serv, gfp_t gfp)
> +{

[ ... ]

> +	while (stream_id <= max_stream_id) {
> +		stream = kzalloc_obj(*stream, gfp);
> +		if (!stream)
> +			goto free;
> +
> +		stream->id = stream_id;

[ ... ]

> +		stream->recv.window = stream->recv.max_bytes;
> +		hlist_add_head(&stream->node, &head);
> +		stream_id += QUIC_STREAM_ID_STEP;
> +	}

[Severity: Low]
Should recv.state be initialized to QUIC_STREAM_RECV_STATE_RECV here?

The uapi header puts the send and receive states in one enum:

include/uapi/linux/quic.h:
enum {
	QUIC_STREAM_SEND_STATE_READY,
	...
	QUIC_STREAM_SEND_STATE_RESET_RECVD,

	QUIC_STREAM_RECV_STATE_RECV,
	...
};

That makes QUIC_STREAM_RECV_STATE_RECV equal to 6. The stream comes from
kzalloc_obj() and recv.state is never set. Every new stream therefore
starts with recv.state == 0, which is QUIC_STREAM_SEND_STATE_READY and not
a receive state.

The only reader in this patch is quic_stream_put():

	if (stream->recv.state < QUIC_STREAM_RECV_STATE_RECVD)
		return;

This works only because 0 is less than QUIC_STREAM_RECV_STATE_RECVD. Any
equality check against QUIC_STREAM_RECV_STATE_RECV would see an invalid
receive state. So would code that reports the state to userspace through
the state field of struct quic_stream_update.

[ ... ]

> +int quic_stream_init(struct quic_stream_table *streams)
> +{
> +	struct hlist_head *head;
> +	int i;
> +
> +	head = kmalloc_objs(*head, QUIC_STREAM_HT_SIZE);

[Severity: Medium]
Should this allocation be charged to the memcg?

When no gfp argument is given, kmalloc_objs() defaults to GFP_KERNEL. The
64-entry table (512 bytes on 64-bit) is therefore not accounted.

Other per-socket memory in this patch is accounted.
quic_stream_create() adds __GFP_ACCOUNT for the stream objects, and the
sock itself comes from a SLAB_ACCOUNT proto slab.

quic_init_sock() calls this for every socket(2). An unprivileged process
in a memory-limited cgroup therefore gets 512 bytes of unaccounted slab
for each QUIC socket it creates.

Would kmalloc_objs(*head, QUIC_STREAM_HT_SIZE, GFP_KERNEL_ACCOUNT) be more
consistent here?

[ ... ]

> diff --git a/net/quic/stream.h b/net/quic/stream.h
> new file mode 100644
> index 0000000000000..cb6b35929ba51
> --- /dev/null
> +++ b/net/quic/stream.h

[ ... ]

> +	/* STREAMS_BLOCKED_BIDI/UNI sent and awaiting ACK for send limits and
> +	 * MAX_STREAMS_BIDI/UNI sent and awaiting ACK for recv limits;
> +	 * MAX_STREAMS_BIDI/UNI needs to be set for send limits.
> +	 */
> +	u8 bidi_blocked;
> +	u8 uni_blocked;
> +	u8 bidi_pending;
> +	u8 uni_pending;

[Severity: Low]
This isn't a bug, but does the last line of this comment name the right
limits?

In this patch, bidi_pending and uni_pending are only used on the recv
limits. quic_stream_put() sets streams->recv.uni_pending and
streams->recv.bidi_pending. quic_stream_max_streams_update() reads and
clears only streams->recv.*_pending when deciding whether to send
MAX_STREAMS_UNI/BIDI.

Should it say "for recv limits" instead?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1791227050.git.lucien.xin%40gmail.com
