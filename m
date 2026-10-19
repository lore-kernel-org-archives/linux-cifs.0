Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792445396;
	b=j/e38DJZOSUkFF9M/wf1JrnF7D4o2dI7aAGI0TnGVqDWMRo7vG0h+CjEd3oUKT4yRUQ0
	 uwlzFCCZtr2WUr+MLxy7Juvw/jAmFBq4QXNIJDzbxPyi4V//mr3udJ1uif7QY9esYJW7n
	 FuCuVp+JTi/NjLDdR4ol9B3fG0JZpQVYL3hFfMlGKRObazbiQlBiVREaVqfJMPX5/kkVd
	 rroaHPJBzIgsGBxnBUHwrOh++w5mWUHEWLZZycnhBl3ta/CwN9XhjVshW6rdeaA4lMeiq
	 js3M8P75Pw8GRwkW9nrBVYhuJ+L3aMOncyiPA6n8PuaItQacdzfby+0hqHoxuR//+pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792445396;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=V1SKqgXsrplLlDz06eFww2PKsFDxp6WP2CMViFGG9y4=;
	b=kHaGJGF60ZeqP+pXT8IX0qXMzEalXAg/4+6aooENz6B5Z0Vsl4kD+7xrUOjR+HqfhCkY
	 glcxvpsIj+UFseKbJdsWocDpIzUyS0dPyGFBNtsdPcy3DDXqCl0I4wHg+kAuPVoQzFxgh
	 vcMYoQRNfXa5gsFF3dgTezVQcQ+cgtAfSdEee+wlOWdzLXVY0ZZbGItRz95Sx10MmPgfC
	 JgrBithD/kzkC6+mDQLYRYn3pmJp4VHrp/RoJMoJDgKRahUHWJiNbFWjYymqwRmau7VBS
	 oAfCCZo5dKygEYN7LUuDFde6dmUgy7ikS8jFoWYS9RxM+eeij99GUNMqpKKsdwrRCXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=heJgehEC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3DB606A31D;
	Mon, 19 Oct 2026 21:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=heJgehEC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9701F000C5;
	Mon, 19 Oct 2026 21:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792445395;
	bh=V1SKqgXsrplLlDz06eFww2PKsFDxp6WP2CMViFGG9y4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=heJgehECDE3wC00XKNuh5KTLi5FNL+/+u55oMozDqmzbiDw8JL4kE/qUYScpZ5MaI
	 nr1GlwXZWZcIFuNSmxRItuKfXeAzDwtuwldJu/P7VzKxviODYWA/mZ6jAQsKz/Lsm2
	 0TCG2pLvxboVLyGhEefw6GRpB1wYacFecLa1WHBBdA0wJC9HRzJm9Ypn1h0MWH5MEN
	 6kHQlnKswpT903Ah9hbeulO7c8W+K2yZp5LY3m0xeb245oFMNjueFc7Ci6Zg7zXJmX
	 4iJ8GKyN571/N6L/uxltwC2khpv4XQ2EyH+DVB+vaBXHHt1A7jaDm3JnKbnCBp/C0G
	 dFISMWb/NlqRw==
Subject: Re: [PATCH net-next v17 06/15] quic: add stream management
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
Date: Mon, 19 Oct 2026 21:29:53 +0000
Message-ID: <179244539310.3135.8921542260670507924@kernel.org>
In-Reply-To: =?utf-8?q?=3Ca92cd8233a031c412bf8b709ba98ed8e9477b74d=2E1792164?=
 =?utf-8?q?438=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3Ca92cd8233a031c412bf8b709ba98ed8e9477b74d=2E17921644?=
 =?utf-8?q?38=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
X-sashiko-severity: Low
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

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The comment above quic_stream_max_streams_update()
  (net/quic/stream.c:313-319) says it "Recalculates the max_uni and…

--

quic: add stream management

This patch adds struct quic_stream_table and struct quic_stream to manage
QUIC streams per socket. It adds quic_stream_get() and quic_stream_put() to
acquire and release send and receive streams. It also adds
quic_stream_id_exceeds() and quic_stream_max_streams_update() to track
stream limits.

> diff --git a/net/quic/stream.c b/net/quic/stream.c
> new file mode 100644
> index 0000000000000..29c9f3568b287
> --- /dev/null
> +++ b/net/quic/stream.c
> @@ -0,0 +1,427 @@

[ ... ]

> +/* Updates the maximum allowed incoming stream IDs if any streams were recently
> + * closed.  Recalculates the max_uni and max_bidi stream ID limits based on the
> + * number of open streams and whether any were marked for deletion.
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

[Severity: Low]
This isn't a bug, but does the comment above
quic_stream_max_streams_update() describe max_uni and max_bidi correctly?

The comment says the function "Recalculates the max_uni and max_bidi stream
ID limits". max_uni and max_bidi are the names of the output parameters, but
those parameters receive stream counts:

    *max_uni = quic_stream_id_to_streams(max);
    ...
    *max_bidi = quic_stream_id_to_streams(max);

Here quic_stream_id_to_streams() returns (stream_id >> 2) + 1. The stream ID
limits are only stored in streams->recv.max_uni_stream_id and
streams->recv.max_bidi_stream_id.

The code itself is correct, because MAX_STREAMS frames carry a count. Nothing
in the series calls this function yet. A future caller that follows the
comment and encodes *max_uni and *max_bidi as stream IDs would advertise the
wrong MAX_STREAMS value.

Could the comment say that the output parameters are stream counts?

> +		streams->recv.uni_pending = 0;
> +	}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1792164438.git.lucien.xin%40gmail.com
