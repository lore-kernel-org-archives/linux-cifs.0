Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5046322D792;
	Wed,  7 Oct 2026 01:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791335127; cv=none; b=bLFKFZpA1mHSxWxEwOyNH0MOhn6DZCpeqddQwlFZ120249vj/+ocor/AQqq3feUHhRPBbfPLMBVcDgeDUbz6SnlEqSq4ijN6AJNxic9N6KYqbPsjhAdY5wwAO8RqfeTeB/0LjUIB0hTqreQ1J5X3KzBKINhJ7vNbr5b89JkEWvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791335127; c=relaxed/simple;
	bh=C7KKwOZ2bUCd6iV3VCE/5t7zpDAN2WMijgPvdjcdeug=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rNUkYZNk8iz9YfXcZjZMlGmH7usWmRPdYiO0QtwXPJqeMn4WfGhTmSmlZzl+jJUlDP3IC36PffPa5ZeBVBlRp7wJExVEgfnWFp7Jcp6TJsHSha1Smp34ktfxnVgcVmFEYHVjj1IKH/rd2FcKeFZHE+S4GVVE2xOP5QOvKExJ7cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BeS2RnNo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BeS2RnNo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C30F1F0089C;
	Wed,  7 Oct 2026 01:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791335126;
	bh=8KJgCnX5dOaV2D8339K10TtV2WrhG/+Ka5C8a4Fr7EE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=BeS2RnNojatHBpo44iV6zdImr1QnDsrLyfKVpx4czeUk5gaCCf14EWzGTZx4MHWyD
	 4hhd3JuIKYhvnvdz9P1J5d4zbfbs0WHUJxTcSqAW2UrAL5mG0tYP1wyUaO3mo0ZyW7
	 oAEoZ2nhBx5F90eIvA928Z7YAaVkXEA46M/AYxwz+XLp1V+b1CgP6p3rj9MWiyikMu
	 oweT6DmQaKUsxOuKE2sS1LKbdv1XApnxpLJARfIFeT6LnK80br/7z+xHpcIrro+WNQ
	 cb7eTScMvnMrin4vF+/vMj1rNyRy4FZK1v969P2o15vQo1V4G3BUvHaNjIV9/SKogf
	 65pfttdpunGiQ==
Subject: Re: [PATCH net-next v16 12/15] quic: add crypto packet encryption and
 decryption
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
Date: Wed, 07 Oct 2026 01:05:23 +0000
Message-ID: <179133512379.434549.1011079085204348692@kernel.org>
In-Reply-To: =?utf-8?q?=3C4dc3c5117810571e41211781bd0280510460e4da=2E1791227?=
 =?utf-8?q?050=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3C4dc3c5117810571e41211781bd0280510460e4da=2E17912270?=
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

Thank you for your contribution! Sashiko AI review found 5 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 · Low: 3

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The AEAD integrity limit that this patch enforces does not
  count failures across the whole connection, as RFC 9001 §6.6 requires.
- [Medium] quic_crypto_generate_token() writes the raw 64-bit
  quic_ktime_get_us() timestamp (ktime_get(), i.e. CLOCK_MONOTONIC in µs…
- [Low] The kernel-doc of quic_crypto_verify_token() says "Return: 0 if
  the token is valid, -EINVAL if invalid, or another negative error…
- [Low] quic_crypto_decrypt() counts every non-EINPROGRESS failure of
  quic_crypto_payload_protect() toward the AEAD integrity limit, not…
- [Low] async_pending[] is used as a quiescence check before re-keying a
  tfm, but both sides use unordered atomics.

--

quic: add crypto packet encryption and decryption

This patch adds AEAD payload protection and QUIC header protection for
TX and RX via quic_crypto_encrypt() and quic_crypto_decrypt(). It also
adds helpers to compute the Retry integrity tag, and to generate and
verify Retry/address validation tokens.

> diff --git a/net/quic/crypto.c b/net/quic/crypto.c
> index 4bb6acea5112a..fa326cc9266a8 100644
> --- a/net/quic/crypto.c
> +++ b/net/quic/crypto.c
> @@ -270,6 +271,484 @@ ciphers[QUIC_CIPHER_MAX + 1 - QUIC_CIPHER_MIN] = {

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
Is the ordering here strong enough for async_pending[] to work as a
quiescence check before re-keying?

quic_crypto_done() signals completion with a plain atomic_dec(). Per
Documentation/atomic_t.txt, that operation is unordered:

    atomic_dec(&crypto->async_pending[cb->key_phase]);

This side reads the counter with a relaxed atomic_read(). When it sees 0,
it calls quic_crypto_key_update(), which rewrites the key schedule through
crypto_aead_setkey().

Nothing orders the completing CPU's loads of the key schedule during the
AEAD operation before its decrement. The socket lock does not cover this,
because the decrement happens before cb->crypto_done() takes the lock
again.

On weakly ordered architectures, can the re-keying CPU see 0 and overwrite
the key while the completing request's reads are still unordered? Would
atomic_dec_return_release(), or smp_mb__before_atomic() plus atomic_dec(),
in quic_crypto_done() paired with atomic_read_acquire() here be needed?

> +		if (err) {
> +			cb->errcode = QUIC_TRANSPORT_ERROR_KEY_UPDATE;
> +			return err;
> +		}
> +		cb->sync = 1;
> +		cb->key_update = 1; /* Mark packet as triggering key update. */
> +	}
> +
> +	err = quic_crypto_payload_protect(crypto, skb, false, gfp);
> +	if (err) {
> +		if (err == -EINPROGRESS)
> +			return err;
> +		/* When using the old keys can not decrypt the packets, the
> +		 * peer might start another key_update. Thus, clear the last
> +		 * key_pending so that next packets will trigger the new
> +		 * key-update.
> +		 */
> +		if (crypto->key_pending && phase != crypto->key_phase) {
> +			crypto->key_pending = 0;
> +			crypto->key_update_time = 0;
> +			crypto->key_update_send_time = 0;
> +		}
> +		goto err;
> +	}

[Severity: Low]
Should every quic_crypto_payload_protect() failure count toward the AEAD
integrity limit?

All of these reach the err label and increment rx_fails[cb->key_phase]:

  - -ENOMEM from quic_crypto_aead_mem_alloc()
  - a negative skb_to_sgvec() result
  - on the resume path, any async engine error delivered in
    cb->crypto_err

RFC 9001 section 6.6 counts only received packets that fail
authentication.

Under sustained allocation failure, could a legitimate connection end up
with -EKEYEXPIRED (AEAD_LIMIT_REACHED) instead of just dropping packets?

[ ... ]

> +	return 0;
> +err:
> +	if (++crypto->rx_fails[cb->key_phase] >= crypto->cipher->rxlimit)
> +		err = -EKEYEXPIRED;
> +	return err;
> +}

[Severity: Medium]
Does this enforce the integrity limit across the whole connection, as
RFC 9001 section 6.6 requires?

The comment on the QUIC_AEAD_RX_* constants cites that section. It says
endpoints MUST count packets that fail authentication during the lifetime
of a connection, across all keys.

Two things seem to weaken the limit here.

First, cb->key_phase comes from the key bit after header protection is
removed, and the packet has not been authenticated yet. Forged
short-header packets therefore spread across both rx_fails[] slots, which
allows about 2 * rxlimit forgeries.

Second, quic_crypto_keys_derive_and_install() resets the slot on every RX
key install. That includes each key update reached through
quic_crypto_decrypt()->quic_crypto_key_update():

net/quic/crypto.c:quic_crypto_keys_derive_and_install() {
    ...
	if (rx) {
		crypto->rx_fails[phase] = 0;
    ...
}

For AES-CCM (rxlimit 2965820, about 2^21.5), an off-path sender would get
roughly (2 + number of key updates) * rxlimit forgery attempts.

Would a single connection-wide failure counter, not indexed by key phase
and not reset on key install, be more appropriate? tx_count could stay
per key.

[ ... ]

> @@ -560,6 +1039,234 @@ int quic_crypto_initial_keys_install(struct quic_crypto *crypto,

[ ... ]

> +int quic_crypto_generate_token(struct quic_crypto *crypto, void *addr,
> +			       u32 addrlen, struct quic_conn_id *conn_id,
> +			       u8 *token, u32 *tlen)
> +{
> +	u8 *token_buf, *p, flag = *token;
> +	u64 ts = quic_ktime_get_us();
> +	u32 len, tslen = sizeof(ts);
> +	int err;
> +
> +	len = sizeof(flag) + addrlen + tslen + conn_id->len + QUIC_TAG_LEN;
> +	token_buf = kmalloc(len, GFP_KERNEL);
> +	if (!token_buf)
> +		return -ENOMEM;
> +
> +	p = token_buf;
> +	p = quic_put_int(p, flag, sizeof(flag));
> +	p = quic_put_data(p, addr, addrlen);
> +	p = quic_put_int(p, ts, tslen);
> +	quic_put_data(p, conn_id->data, conn_id->len);

[Severity: Medium]
Does this expose the server's uptime to any client that receives a token?

ts is the raw ktime_get() value, in microseconds since boot.
quic_crypto_token_protect() only authenticates the flag, address and
timestamp as associated data. It does not encrypt them:

	aead_request_set_ad(req, adlen);
	aead_request_set_crypt(req, sg, sg, len - adlen - extra, nonce);

Tokens are sent to unauthenticated clients in Retry packets and NEW_TOKEN
frames, so the monotonic clock can be read from them in plaintext. TCP
avoids a similar leak with per-connection timestamp offsets
(secure_tcp_ts_off).

The v14 change moved the timestamp from the encrypted part into the AAD
so it could be used for the nonce. That change appears to have introduced
this exposure.

The serialized address is also sent in plaintext. For IPv6,
quic_v6_get_msg_addrs() in net/quic/family.c sets:

	sa->v6.sin6_scope_id = skb->skb_iif;

Would the server's ingress ifindex end up in the token as well?

[ ... ]

> +/* Validate a Retry or address validation token.
> + *
> + * Decrypts and authenticates the token, checks the client address and validates
> + * the timestamp against the timeout selected by the token flag. For a Retry
> + * token, extracts the original destination connection ID.
> + *
> + * Return: 0 if the token is valid, -EINVAL if invalid, or another negative
> + * error code.
> + */
> +int quic_crypto_verify_token(struct quic_crypto *crypto, void *addr,
> +			     u32 addrlen, struct quic_conn_id *conn_id,
> +			     u8 *token, u32 len)
> +{

[ ... ]

> +	err = quic_crypto_token_protect(crypto, token_buf, len,
> +					sizeof(flag) + addrlen + tslen, false);
> +	if (err)
> +		goto out;
> +
> +	err = -EINVAL;

[Severity: Low]
The kernel-doc says -EINVAL is returned for an invalid token. Does a
forged or tampered token actually return -EINVAL?

A tag mismatch makes crypto_aead_decrypt() return -EBADMSG. That value is
returned unchanged through the goto out above, before err is set to
-EINVAL. A token key that was never set would give -ENOKEY in the same
way.

Only the length precheck and the address, timestamp and ODCID length
checks return -EINVAL.

Should the comment be updated, or should authentication failures be
mapped to -EINVAL?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1791227050.git.lucien.xin%40gmail.com
