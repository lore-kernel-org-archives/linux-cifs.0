Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA824BE42E;
	Tue, 15 Sep 2026 19:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789501858; cv=none; b=ruK4ljDVP4iFtt9VFvbD5AX22OhbE4easZDMX2lyX14vq7g7MGOiomj2C/8E5WPcanvbDl7fEUUlriyN6S3ktCkMrQsg8FzuMlJJrP7sAmkxAxFlmZiJgDg4UNAWCUKcU5RmcDidwSfZsZX6WO0ADaCWyMeuOMMlJlXv1BANxv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789501858; c=relaxed/simple;
	bh=zpxeMh+ZQ9imeXwEYJZhe7gKtQpPmXIrA9+/4rSpvAg=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dkKyGqGPQYdJsBh4wMi3yIyBRBHQrkYx0tZQ0ycPEeyVz0vKRGjoYhDH0JrKahwZo8qMUkWAaixHGsqUFR8YNvLeE6socJWd7e1zjHomymLMQPi2r/5Ya1x2wUsAebJku825O6CeoxiKUKBxIBWMYO1dg1X5WnjUVctqAa3VX0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fk9FCVdn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fk9FCVdn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679371F00899;
	Tue, 15 Sep 2026 19:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789501856;
	bh=risxAHSGZzSfmEcOcauOis3XpWphWD8gxMVPH+ipp/A=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Fk9FCVdnKi2hRCtEsnNVhRsG+lK23+ANgBNXyvw53N45nwW8XuNIKSP1cl/diIV0n
	 CyDfb/tAjLUwx3iymAyZmyAumoTy5gTjiwL6qCjmo1NdULPZnIk0n2hq2HqzFQzN0r
	 GzN/ML5xrCfjpbHlpxMNCtz/Q96tuJVYba6lrkxIffNbvvPO7sIvqmVilqqp8+kz26
	 /4Vt0TokQvqyyMM5pCvHmgwIiq7oD2GJcGPHANZQyLJ8bpWaqOGoce6xZ+D8dKSc43
	 0WAT2w9OTmFKn7tqZr9QYHMTwgzacmHUmCYZXA18tHWBy1WlQtXOhFkzalXCWqPbWq
	 /iY3hnTu9UOiQ==
Subject: Re: [PATCH net-next v15 12/15] quic: add crypto packet encryption and
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
 mef@scarletmail.rutgers.edu, paul@jakma.org
Date: Tue, 15 Sep 2026 19:50:53 +0000
Message-ID: <178950185396.22033.4056258856263599395@kernel.org>
In-Reply-To: =?utf-8?q?=3C06841ed60dda515dce3f3f16b4c3b31fdd7113fe=2E1789393?=
 =?utf-8?q?775=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3C06841ed60dda515dce3f3f16b4c3b31fdd7113fe=2E17893937?=
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

Critical: 0 · High: 0 · Medium: 2 · Low: 2

- [Medium] quic_crypto_encrypt() records crypto->key_update_send_time =
  quic_ktime_get_us() *before* attempting to protect the packet…
- [Medium] The new packet protection paths
  (quic_crypto_encrypt()/quic_crypto_decrypt() ->…
- [Low] The comments on the new token helpers describe an earlier
  revision of the code and are now wrong in three ways.
- [Low] Reported concern: quic_crypto_generate_token() computes len =
  sizeof(flag) + addrlen + sizeof(u64) + conn_id->len + QUIC_TAG_LEN and…

--

quic: add crypto packet encryption and decryption

This patch adds packet-level AEAD encryption and decryption for QUIC,
including header protection and its removal, plus helpers for the Retry
integrity tag and for generating and verifying address validation tokens.

A few questions on the new code below.

> diff --git a/net/quic/crypto.c b/net/quic/crypto.c
> index 910557b680524..d62c6c4bea7de 100644
> --- a/net/quic/crypto.c
> +++ b/net/quic/crypto.c

[ ... ]

> @@ -252,6 +253,457 @@ ciphers[QUIC_CIPHER_MAX + 1 - QUIC_CIPHER_MIN] = {
>  		    "rfc7539(chacha20,poly1305)", "chacha20", "hmac(sha256)"),
>  };
>  

[ ... ]

> +/* AEAD Usage. */
> +static int quic_crypto_payload_protect(struct quic_crypto *crypto,
> +				       struct sk_buff *skb, bool enc, gfp_t gfp)
> +{

[ ... ]

> +	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> +				  quic_crypto_done, skb);
> +	*(struct quic_crypto **)ctx = crypto;
> +	atomic_inc(&crypto->async_pending[phase]);
> +	cb->crypto_ctx = ctx; /* Async free context for quic_crypto_done() */
> +	err = enc ? crypto_aead_encrypt(req) : crypto_aead_decrypt(req);

[Severity: Medium]
This is the single place where every QUIC packet is protected or
unprotected, so it looks like the natural home for the AEAD usage limits
of rfc9001#section-6.6.  Are those limits enforced anywhere?

struct quic_crypto in net/quic/crypto.h keeps secrets, IVs,
async_pending[], the key update timestamps and the bit flags, but has no
field for the number of packets protected with a key, nor for the number
of packets that failed authentication, and a grep over net/quic at the end
of the series finds no confidentiality or integrity limit check.

On the RX side quic_crypto_decrypt() just returns the AEAD error, so a
peer can keep submitting forgery attempts against the same key without the
connection ever being closed, which rfc9001#section-6.6 requires once the
integrity limit is reached:

	err = quic_crypto_payload_protect(crypto, skb, false, gfp);
	if (err) {
		if (err == -EINPROGRESS)
			return err;
		...
		return err;
	}

TLS_CIPHER_AES_CCM_128 is supported here (quic_crypto_is_cipher_ccm() and
the "ccm(aes)" ciphers[] entry) and has the lowest integrity limit of the
QUIC AEADs.  Is the intent to add the per-key counters and the limit checks
in a later patch?

> +	if (err == -EINPROGRESS || err == -EBUSY) {
> +		memzero_explicit(nonce, sizeof(nonce));
> +		return -EINPROGRESS;
> +	}
> +	atomic_dec(&crypto->async_pending[phase]);
> +	cb->crypto_ctx = NULL;
> +
> +out:
> +	kfree_sensitive(ctx);
> +	memzero_explicit(nonce, sizeof(nonce));
> +	return err;
> +}
> +
> +/* Encrypts a QUIC packet before transmission.  This function performs AEAD
> + * encryption of the packet payload and applies header protection. It handles
> + * key phase tracking and key update timing.
> + *
> + * Return: 0 on success, or a negative error code.
> + */
> +int quic_crypto_encrypt(struct quic_crypto *crypto, struct sk_buff *skb,
> +			gfp_t gfp)
> +{
> +	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
> +	int err;
> +
> +	/* Packet payload is already encrypted (e.g., resumed from async),
> +	 * proceed to header protection only.
> +	 */
> +	if (cb->resume)
> +		goto out;
> +
> +	cb->key_phase = crypto->key_phase;
> +	/* If a key update is pending and this is the first packet using the
> +	 * new key, save the current time. Later used to clear old keys after
> +	 * some time has passed (see quic_crypto_decrypt()).
> +	 */
> +	if (crypto->key_pending && !crypto->key_update_send_time)
> +		crypto->key_update_send_time = quic_ktime_get_us();
> +
> +	err = quic_crypto_payload_protect(crypto, skb, true, gfp);
> +	if (err)
> +		return err;

[Severity: Medium]
Should key_update_send_time be committed only after the packet has actually
been protected?

Here the timestamp is stored before quic_crypto_payload_protect() runs, and
neither this error return nor the header protection failure below restores
it.  If payload protection fails (skb_cow_data() returning -ENOMEM,
quic_crypto_aead_mem_alloc() returning -ENOMEM, an skb_to_sgvec() error, or
an AEAD error) the skb is dropped by the caller, but
crypto->key_update_send_time now records a time at which nothing was sent.

quic_crypto_decrypt() then uses that value as the start of the old key
retention window:

	if (crypto->key_pending && cb->key_phase == crypto->key_phase) {
		time = crypto->key_update_send_time;
		if (time &&
		    quic_ktime_get_us() - time >= crypto->key_update_time) {
			crypto->key_pending = 0;

Can the window therefore already be expired when the first packet in the
new phase is really received, so that key_pending is cleared immediately and
a later reordered old-phase packet is treated as a fresh key update
(phase != crypto->key_phase && !crypto->key_pending), overwriting the old
key slot before those packets can be decrypted?

> +out:
> +	return quic_crypto_header_protect(crypto, skb, true, gfp);
> +}
> +

[ ... ]

> @@ -540,6 +992,238 @@ int quic_crypto_initial_keys_install(struct quic_crypto *crypto,
>  	return err;
>  }
>  

[ ... ]

> +/* Derives a key and IV using HKDF, configures the AEAD transform and performs
> + * AEAD encryption/decryption for the provided token.
> + */
> +static int quic_crypto_token_protect(struct quic_crypto *crypto, u8 *token,
> +				     u32 len, u32 adlen, bool enc)
> +{
> +	/* Reuse TX AEAD (phase 1) in Initial crypto. */
> +	struct crypto_aead *tfm = crypto->tx_tfm[1];

[Severity: Low]
Do these three comments still match the code after the v14 rework?

quic_crypto_token_protect() is documented as "Derives a key and IV using
HKDF, configures the AEAD transform", but the body has no HKDF call, no
crypto_aead_setkey() and no crypto_aead_setauthsize(); it only reuses the
key and IV that quic_crypto_set_token_secret() installed into
crypto->tx_tfm[1] and crypto->tx_iv[1]:

net/quic/crypto.c:quic_crypto_set_token_secret() {
	...
	err = crypto_aead_setauthsize(tfm, QUIC_TAG_LEN);
	if (err)
		goto out;
	err = crypto_aead_setkey(tfm, key, TLS_CIPHER_AES_GCM_128_KEY_SIZE);
	...
}

That also makes quic_crypto_set_token_secret() a hard prerequisite, since
crypto_aead_encrypt() returns -ENOKEY while CRYPTO_TFM_NEED_KEY is set.
Could the comment record that ordering requirement instead?

The quic_crypto_generate_token() comment says:

 * Encrypts the token (excluding the first flag byte) using AES-GCM with a key
 * and IV derived via HKDF.

but the call passes adlen = sizeof(flag) + addrlen + tslen, so the flag,
the client address and the timestamp are associated data, authenticated but
sent in the clear; only conn_id->len bytes of ODCID are encrypted.

The quic_crypto_verify_token() comment says:

 * Decrypts the token using derived key and IV. Checks that the decrypted
 * address matches the provided address, validates the embedded timestamp
 * against current time with a version-specific timeout.

The address compared by crypto_memneq() is never encrypted, and the timeout
comes from the token flag (QUIC_TOKEN_FLAG_REGULAR versus the
QUIC_TOKEN_TIMEOUT_RETRY default), not from crypto->version.

> +	u32 extra = enc ? QUIC_TAG_LEN : 0, tslen;

[ ... ]

> +/* Generate a token for Retry or address validation.
> + *
> + * Builds a token with the format: [flag][client address][timestamp][original
> + * DCID][auth tag]
> + *

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

[ ... ]

> +	memcpy(token, token_buf, len);
> +	*tlen = len;

[Severity: Low]
This isn't a bug today, but the interface of quic_crypto_generate_token()
carries no capacity for the token buffer.  len is computed from the
caller supplied addrlen and conn_id->len and then copied into token
without any bound, and *tlen is written only after the copy.

At the end of the series there is no caller at all
(quic_packet_retry_create_and_xmit() is still a stub returning
-EOPNOTSUPP), and the length is bounded in practice because conn_id->len
can only be set through quic_conn_id_update(), which rejects anything
larger than QUIC_CONN_ID_MAX_LEN:

net/quic/common.h:quic_conn_id_update() {
	if (WARN_ON_ONCE(len > QUIC_CONN_ID_MAX_LEN))
		return;
	memcpy(conn_id->data, data, len);
	conn_id->len = (u8)len;
}

Would it be worth passing the destination size in, so a future caller
cannot get this wrong?  The flag byte being read back out of token[0] as
an in/out use of the output buffer is also not mentioned in the comment.

> +out:
> +	kfree_sensitive(token_buf);
> +	return err;
> +}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1789393775.git.lucien.xin%40gmail.com
