Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794349788;
	b=rrzlo0jiQRf+kNaG0IBNYerj54/gg3s58TIL5HMzYJgSmdIfO0XQYXG66kj05r2St5/6
	 MF+xwaFcL2oyCbEz4J4dX/hTUDNLTZKyI7ul+JKdka8AeNsUM91rJgeeNjMIpQwUcGb7f
	 2HTWlo5E4ndsSkPEWleswsRw+N/5+pib7JZSCF+1IwVlxwwY4O8jkNLrz+T93M/LqYaET
	 RkLjXc8/KkPSx30w+1cM5+AvVAreaFLDkQDxuNlCz5nANAfgSm0i5XP/rpbAmtkkbbePK
	 w0YZvuSLRlHc99DR24DzLkstuuNlydMSA/3poW+MpxTzah1/a7iAR7G3kSaMMxYqjAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794349788;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=87ofhARvOBFaOFAoJKqtpzEqRWBplzPTfRwfrLXCvmo=;
	b=f1XNktBmOyleNLxnb82YVNXmtokDnGVha1CVUqR48KU1g+MSSwI/Ab730v7tkwE35PS+
	 yGTgs0fx1oQlK7kRGTjq9qv5S6suKnpBSXnn9HG0wvGRlm2LkDe0/RwGK5PrygqJ/HoBM
	 VDYOKF4503EjDn3EpqWg7KRHLXmXwxoPklnpyxHQwmk6SWkcbtpRk4qxef1xR8+0bScbK
	 kLH19AmFCuVCyanPcZHHsJC33wD+YNFMyFQjNuHsNaI8zb6OoOx7wNGfOfx7Es4Q13/eE
	 usV8yp+gQNUj2HCNppnQ5Dz0oJQ7X8CAy32dar1quPe9UoKrvxNJXjwIYlg18zNlNeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bezUhnvS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD54C606A31C;
	Tue, 10 Nov 2026 22:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bezUhnvS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C890B1F008A2;
	Tue, 10 Nov 2026 22:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794349787;
	bh=87ofhARvOBFaOFAoJKqtpzEqRWBplzPTfRwfrLXCvmo=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=bezUhnvSKU3BgXSBVWkC9IcFmM5i4m/sNS5X856GQEyo+VVOXpkOnh7PsbkyYJ/ZR
	 t0+/s85s/z6YpN74GNHYiQKwye/pbZG1QIvisZH3GDEjYhndFgVqRj1tJTnf0Sp9ra
	 leXqhqATtPnwF+KGW3AXvUQoeEfGBXm0alzIpIW4CENOuiGSot3GYUlOS8QH8Yb9IQ
	 ldh7lufrPu9uQo5FdzrbFoVPnTc9ewyUNWwk+jIwcgRJT0jc6pZFUyhfIvlg63BQc2
	 hCZxpd0H1EPDkrgR1XoGub8j9A8m3DKGc9OVqTEjntT+DMfFJ7Cg2/SEvx0f4owoTR
	 8lCRZxUqT2PFw==
Subject: Re: [PATCH net-next v18 10/15] quic: add packet number space
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
Date: Tue, 10 Nov 2026 22:29:45 +0000
Message-ID: <179434978537.994134.14523513856125397463@kernel.org>
In-Reply-To: <fda017f7e2ebe19deb54aa43d2de4022b6f9ea4c.1794241656.git.lucien.xin@gmail.com>
References: <fda017f7e2ebe19deb54aa43d2de4022b6f9ea4c.1794241656.git.lucien.xin@gmail.com>
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

Critical: 0 · High: 0 · Medium: 1 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] quic_destroy_sock() (net/quic/socket.c) kfree()s the
  separately allocated pnspace objects at the start of teardown and…
- [Low] The commit message names a symbol that does not exist.
- [Low] After quic_pnspace_init() (net/quic/pnspace.c), base_pn is -1 but
  max_pn_seen, last_max_pn_seen and min_pn_seen stay at their kzalloc…

--

quic: add packet number space

This patch adds struct quic_pnspace, which holds per packet number space
state: a bitmap of received packet numbers for ACK generation, timestamps
for loss detection and RTT, and ECN counters. It adds helpers to check and
mark received packet numbers, build gap ack blocks and validate peer ECN
counts. quic_init_sock() allocates the pnspace objects per socket and
quic_destroy_sock() frees them.

> To support ACK frame generation, quic_pnspace includes a packet number
> acknowledgment map (pn_ack_map) that tracks received packet numbers.

[Severity: Low]
This isn't a bug, but should this say pn_map rather than pn_ack_map?
Nothing in net/quic/ is called pn_ack_map. The field in struct quic_pnspace
is:

	unsigned long *pn_map; /* Received PN bitmap for ACK generation */

> - quic_pnspace_num_gabs(): Returns the gap ACK blocks for constructing
>   ACK frames.

quic_pnspace_num_gabs() fills the caller's gabs array and returns a u16
count. When there are more than QUIC_PN_MAP_MAX_GABS gaps, it also merges
the oldest gaps into one block.

Only the code comment and the v15/v16 changelog below the --- line
describe this, and that changelog won't be kept in git history. Could the
commit message describe it?

> diff --git a/net/quic/pnspace.c b/net/quic/pnspace.c
> new file mode 100644
> index 0000000000000..fcf68f0df1848
> --- /dev/null
> +++ b/net/quic/pnspace.c
> @@ -0,0 +1,273 @@

[ ... ]

> +int quic_pnspace_init(struct quic_pnspace *space)
> +{
> +	space->pn_map = bitmap_zalloc(QUIC_PN_MAP_INITIAL, GFP_KERNEL_ACCOUNT);
> +	if (!space->pn_map)
> +		return -ENOMEM;
> +	space->pn_map_len = QUIC_PN_MAP_INITIAL;
> +
> +	space->max_time_limit = QUIC_PNSPACE_TIME_LIMIT;
> +	space->next_pn = QUIC_PNSPACE_NEXT_PN;
> +	space->max_pn_acked_seen = -1;
> +	space->base_pn = -1;
> +	return 0;
> +}

[Severity: Low]
After this runs, base_pn is -1 but max_pn_seen, last_max_pn_seen and
min_pn_seen are still 0 from kzalloc. So quic_pnspace_has_gap() reports a
gap (-1 != 0 + 1) for a space that hasn't received anything:

static inline bool quic_pnspace_has_gap(const struct quic_pnspace *space)
{
	return space->base_pn != space->max_pn_seen + 1;
}

quic_pnspace_set_base_pn() otherwise keeps max_pn_seen == base_pn - 1 as
the no-gap state.

The current callers seem fine. quic_pnspace_mark() handles base_pn == -1
before it calls has_gap(). In quic_pnspace_num_gabs(), the bounds checks in
quic_pnspace_next_gap_ack() make it return 0 (start_ = 0, end_ = 64, and
0 <= -1 + 64 - 1).

Would it be better to keep max_pn_seen and friends at base_pn - 1 here as
well? Otherwise a later caller that relies only on has_gap() before the
first packet is marked would get the wrong answer.

[ ... ]

> diff --git a/net/quic/socket.c b/net/quic/socket.c
> index 41f7de7d163a0..78a08dd998a8e 100644
> --- a/net/quic/socket.c
> +++ b/net/quic/socket.c

[ ... ]

> @@ -58,11 +61,34 @@ static int quic_init_sock(struct sock *sk)

[ ... ]

>  static void quic_destroy_sock(struct sock *sk)
>  {
> +	struct quic_pnspace *space;
> +	u8 i;
> +
> +	for (i = 0; i < QUIC_PNSPACE_MAX; i++) {
> +		space = quic_pnspace(sk, i);
> +		if (!space)
> +			continue;
> +		quic_pnspace_free(space);
> +		kfree(space);
> +	}
> +
>  	quic_path_unbind(sk, quic_paths(sk), 0);
>  	quic_path_unbind(sk, quic_paths(sk), 1);

[Severity: Medium]
The pnspaces are freed here before quic_path_unbind() and
quic_conn_id_set_free() take the socket off the UDP tunnel and out of the
RCU conn-ID hash. quic_sk(sk)->space[i] is also left pointing at freed
memory. Before v18 the pnspaces were embedded in the SOCK_RCU_FREE sock, so
they shared its lifetime.

As far as I can tell, nothing in the series reaches the freed memory today.
quic_close() sets QUIC_SS_CLOSED under lock_sock() before
sk_common_release() calls ->destroy. Later in the series,
quic_packet_process() drops packets for a closed socket before it touches
any pnspace:

	if (quic_is_closed(sk)) {
		kfree_skb(skb);
		return 0;
	}

Later patches also call quic_timer_free() and quic_packet_free() before
this free.

However, quic_pnspace() returns the raw space[] pointer without any
lifetime check. A future RX path that skips the closed-state check would
then use freed memory.

Would it be safer to free the pnspaces after the path unbind and conn-ID
teardown, and to set quic_sk(sk)->space[i] to NULL after kfree()?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1794241654.git.lucien.xin%40gmail.com
