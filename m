Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794349793;
	b=l4RrJPLmeJi+m33PWtqdZg6jgFjo9q/gyNJRkbvbimd16ckNz6mVy7ZZrHUxqcdDbVRk
	 8jvowaJBU9G00i4czwDVXgepYtdrx26UZf7epSZ16xiGAYc6AqSZjUd3wZ/4NnA+UR5C8
	 mlmJ/zZGcI8PFfoRa1xFkVMm4wXVlTAcnCU9LNU8JkfkvmtbmtbWoq7OWVVEglpa+pwxj
	 oT9l+ZviKigcWtIsYgvzsyjpChTUjFR4gR9t5/U0DVE6N8zko3ec/EfNEK5+XX0jVKF/1
	 ilV3sL0HU5/s++GV5Ob7aOdyGaw2q9umnkaCZUhRKKU1nWCoo8Ka09zMpbkzZ5Td/lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794349793;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=F4/PdHrzBlcggV8YW4nkZrr2K8nMPnl0FAFqU9q+VJw=;
	b=mJcDvAeeiR7DepTHoFZJPBKDt+DmAfQNBMrUl2hDHacsrgrjF+cZyAtjTkQ35x4hsP9s
	 yyAHS+LpyWgAdglP6Z0hOLdscEyyCZt8xWSiLgGPklzqRlWUBznWvj8fWBAZCpReS87oq
	 XRCPrhoJkXM8E22cjMb+m5qgTwXx5dRRffTt1P0w7c+tTenkyIrgX2daPg0KWIOzy+sH2
	 bzxhA2HLvGDQhDYTfLs4Akm0rxXjwnri5Mkjj1tQaJWLicE/K7BzCZvo/0V5zPf8R7yDp
	 Ko0x+MwVgT52isVJbXDrWqOlxjDh9sPzR5a1Y1bEls56TUs+3QhClZclKtFFaH7bpnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YWw35ylj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF79606A325;
	Tue, 10 Nov 2026 22:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YWw35ylj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FA61F008AB;
	Tue, 10 Nov 2026 22:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794349792;
	bh=F4/PdHrzBlcggV8YW4nkZrr2K8nMPnl0FAFqU9q+VJw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=YWw35yljPunpBrdubF40KFTSLvsKSfhpEMzZk+WK8MwgvJVemM5C5OIyoP8MOE5VI
	 XC4gOLm0uZgGUvwDwGM23hJEQZisaDjEdI/XwyrU7mEH07F/NvTnNJaTGM6xYet6wx
	 gh7YPqcKrI7BG41sILAj4VlssBjXedt0NxkdqYGMb5oNTFoWCB9fzl9omtAPAhZ8/I
	 Jc1RZEC1kb0DXRbC5E3UwQELxF9kDBQUy12uCrXxW7KUeS13Xu0KLCvX0gXrlBJ16X
	 gX9jgZV51HHhBta6Y3nN6gn7AZA7ycGHdt019DeyDLkBq9wQ7ZqAG+31OGDJ4BcYn4
	 1i2CuGOXdbCFA==
Subject: Re: [PATCH net-next v18 12/15] quic: add crypto packet encryption and
 decryption
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
Date: Tue, 10 Nov 2026 22:29:50 +0000
Message-ID: <179434979059.994134.18317543021105952060@kernel.org>
In-Reply-To: <adecdb94b1bbb4f329cb2cfea6d5f142c52d91a0.1794241656.git.lucien.xin@gmail.com>
References: <adecdb94b1bbb4f329cb2cfea6d5f142c52d91a0.1794241656.git.lucien.xin@gmail.com>
X-sashiko-severity: High
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

Critical: 0 · High: 1 · Medium: 0 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] Retry/NEW_TOKEN tokens can reuse an AES-GCM (key, nonce) pair
  across sockets.
- [Low] The AEAD integrity limit is enforced per encryption level, but it
  is documented as per connection.
- [Low] crypto->async_pending[] decides when the AEAD transforms can be
  rekeyed, but every access to it is relaxed.

--

quic: add crypto packet encryption and decryption

This patch adds AEAD payload protection and QUIC header protection for
the TX and RX paths, through quic_crypto_encrypt() and
quic_crypto_decrypt(). It also adds Retry integrity tag computation and
helpers to generate and verify Retry and address validation tokens.

> diff --git a/net/quic/crypto.c b/net/quic/crypto.c
> index c4bf99b3e8239..54fccaf715105 100644
> --- a/net/quic/crypto.c
> +++ b/net/quic/crypto.c

[ ... ]

> +int quic_crypto_decrypt(struct quic_crypto *crypto, struct sk_buff *skb,
> +			gfp_t gfp)
> +{

[ ... ]

> +	phase = cb->key_phase;
> +	if (phase != crypto->key_phase && !crypto->key_pending) {
> +		if (!crypto->send_ready) /* Not ready for key update. */
> +			return -EINVAL;
> +		if (!cb->backlog) /* Key update requires process context. */
> +			return -EKEYREVOKED;
> +		/* Cannot do key update while async crypto is in progress. */
> +		if (unlikely(atomic_read(&crypto->async_pending[phase])))
> +			return -EBUSY;
> +		err = quic_crypto_key_update(crypto); /* Perform key update. */

[Severity: Low]
Is the memory ordering here strong enough to make rekeying the tfm safe?
The async completion path reports that it is done using a void atomic op:

quic_crypto_done() {
    ...
	crypto = *(struct quic_crypto **)cb->crypto_ctx;
	atomic_dec(&crypto->async_pending[cb->key_phase]);
    ...
}

This side then checks the counter with a plain atomic_read() before
quic_crypto_key_update()->quic_crypto_keys_derive_and_install() calls
crypto_aead_setkey() on the same phase's tfm.

Documentation/atomic_t.txt says void atomic RMW ops are unordered. So
nothing orders the driver's earlier reads of the key context before the
decrement, and there is no acquire on the reader side.

On weakly ordered architectures, could a request completing on one CPU
still be reading the old key schedule after another CPU has seen
async_pending == 0 and rekeyed? That request would then run with mixed
key material.

Would atomic_dec_return_release() (or smp_mb__before_atomic()) in
quic_crypto_done(), paired with atomic_read_acquire() here, be enough?

[ ... ]

> +	return 0;
> +err:
> +	if (err == -EBADMSG && ++crypto->rx_fails >= crypto->cipher->rxlimit)
> +		err = -EKEYEXPIRED;
> +	return err;
> +}

[Severity: Low]
Does this enforce the limit per connection? struct quic_cipher in
net/quic/crypto.h documents it as:

	u64 rxlimit; /* Max decryption failures per connection */

The v17 changelog also calls rx_fails a connection-wide counter.

However, rx_fails is a field of struct quic_crypto, and quic_init_sock()
allocates a separate quic_crypto for each of the QUIC_CRYPTO_MAX
encryption levels. Authentication failures at the Initial, Handshake,
0-RTT and 1-RTT levels are therefore counted separately and never add
up.

RFC 9001 section 6.6 counts failures within the connection, across all
keys. Should the counter be shared across levels, or should the comment
and changelog be updated?

[ ... ]

> +static int quic_crypto_token_protect(struct quic_crypto *crypto, u8 *token,
> +				     u32 len, u32 adlen, bool enc)
> +{

[ ... ]

> +	memcpy(nonce, crypto->tx_iv[1], QUIC_IV_LEN);
> +
> +	/* Read counter value from token AAD (bytes 1-8) and XOR with IV. */
> +	clen = sizeof(c);
> +	p = token + adlen - clen;
> +	quic_get_int(&p, &clen, &c, clen);
> +
> +	n = cpu_to_be64(c);
> +	for (i = 0; i < sizeof(n); i++)
> +		nonce[QUIC_IV_LEN - sizeof(n) + i] ^= ((u8 *)&n)[i];

[ ... ]

> +int quic_crypto_generate_token(struct quic_crypto *crypto, void *addr,
> +			       u32 addrlen, struct quic_conn_id *conn_id,
> +			       u8 *token, u32 *tlen)
> +{

[ ... ]

> +	/* Use counter for nonce derivation to prevent collisions. */
> +	counter = crypto->tx_count[1]++;

[Severity: High]
Can this counter value repeat under the same token key on different
sockets?

quic_crypto_token_protect() builds the AES-GCM nonce as tx_iv[1] XOR
counter. Both the AEAD key and tx_iv[1] are derived only from
tx_secret[1] in quic_crypto_set_token_secret(), and that function keeps
any secret that is already set:

	if (!memchr_inv(srt, 0, TLS_CIPHER_AES_GCM_128_SECRET_SIZE))
		get_random_bytes(srt, TLS_CIPHER_AES_GCM_128_SECRET_SIZE);

The token secret looks like it is meant to be shared server-wide. Later
in the series, quic_packet_process() verifies both Retry and
QUIC_TOKEN_FLAG_REGULAR (NEW_TOKEN) tokens with the listener's Initial
crypto, but accepted sockets are the ones that issue NEW_TOKEN.
quic_crypto_derive_secret() also seeds the stateless reset and
resumption secrets from tx_secret[1].

tx_count[1], on the other hand, is per quic_crypto. quic_init_sock()
kzalloc's each quic_crypto, so every socket's counter starts at 0.
quic_crypto_keys_derive_and_install() also resets tx_count[] like a
packet counter.

So wouldn't the listener's first token and the first token from each
accepted socket all use nonce tx_iv[1] XOR 0 under the same key?

Two AES-GCM messages with the same (key, nonce) let an attacker recover
the GHASH key and forge valid tokens. For example, they could swap in a
different client address or an arbitrary ODCID, which defeats address
validation. The counter is sent in the clear in the AAD, so collisions
are easy to spot.

The note after the --- line about token nonce reuse argues from the
earlier timestamp nonce and socket lock serialization. Does that
reasoning still apply when separate sockets keep independent counters
under one shared key?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1794241654.git.lucien.xin%40gmail.com
