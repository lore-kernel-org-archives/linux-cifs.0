Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795483287;
	b=AmSGkp6NKi2vLndl6wZKVHqiSHMEfJ/YOP9AkbRrY5YFmO7nPAxvSCaRsjuXjeNuVGb2
	 6hgMeNSkylJEqN5KtPpCb3yro2X3ueo+2zFhhg/UX1iTmn8JL5VNbv0DqLw9sW447iP8h
	 XSZl8qRAGQCYXWH8EgRpzNcmRv/ueiVH/oHEenTzn2clh7IJz8L3iECyDfEg5DMxlup7R
	 +6+JUBSbTe1/9M8AevkgDQj5ivOq6C6KZJBnStJxFbvA/ia3YXfFxu6z+O4SLSpUHa2kO
	 3BSBaifF0/XcFNcpt2XudoHf474QCfBvAAJ2icghwf/t2g7dQIpYU5HxOl3PH8Osdvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795483287;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=qgXAtoP5sFQeq8piL0TymnkSt/hI8uLlxxkB+CmpvCI=;
	b=nYh3UEUDfKkk7GQ6OiyYwZjnvMTzVx3s13/IGLUMju+FbnG4y3OfyOacCcSMC3d5oIp5
	 GFEd7OhfBBmUVq/E06LmuPdEAZNWavkCtjQrd08rW10eo0cMERqIfIxsZmdv29npwrXqM
	 ok8vnWP2JpVYOB9LZqk2jnbkXSZRMRMZHaA3oNC95RAobnQonohF10bcURIeTpyOdtptE
	 4P7Br4DtGiHP42CkRvZ28Mw/0r6nzRZovZ9H6LQgDbIPYyb6U7jDe9lSGDhhj0eTmYy+8
	 0DKdNFa/j/BY5y77kVsOU7LuYh30xQ3cYiVytJ9DXBzoQKVoj/wr1tyV9viqOb404WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JigdjSLf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0639606A321;
	Tue, 24 Nov 2026 01:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JigdjSLf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07A2A1F000D2;
	Tue, 24 Nov 2026 01:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795483286;
	bh=qgXAtoP5sFQeq8piL0TymnkSt/hI8uLlxxkB+CmpvCI=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=JigdjSLfsDA6g+zJKSnb6jFc3Q9o3XJ9S+WjslH263p7ULIj2JwgHZ67Q4gpFI6bv
	 VYhIXepfuhx3g+eJPrgQlITJJgoVlFMbqrCV0O9BHBeNImDhs7JGm8Hhef8mdZSISV
	 G8uH8iP0as9MVp2blZCuR78bnFwNutjUUVi0goRBwMg5/bf9uM2w6GSB5p7BqM3tB/
	 +/8rVSia/bFJ7SYRZT1S23otg0fc+xMwMniv1LftHCR/3YIayK6mtYdVf27q38Yg5F
	 2xwCGc75Qftj6joZy9ZqMRRrCuFrowsuoLOoeLh1c4GHXTDLzjvfFclq4GrFpAoVxZ
	 dVvD3n/2HEsug==
Subject: Re: [PATCH net-next v19 12/15] quic: add crypto packet encryption and
 decryption
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
Date: Tue, 24 Nov 2026 01:21:24 +0000
Message-ID: <179548328461.3135.7564598888424511077@kernel.org>
In-Reply-To: <21e45bc3fabb264d05600bfc7c32f1e680c8140a.1795393691.git.lucien.xin@gmail.com>
References: <21e45bc3fabb264d05600bfc7c32f1e680c8140a.1795393691.git.lucien.xin@gmail.com>
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

Critical: 0 · High: 1 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] quic: missing packet number decode on backlog retry in
  quic_crypto_decrypt()
- [Medium] Retry and NEW_TOKEN tokens now carry a sequential 64-bit
  counter in cleartext.
- [Low] The kernel-doc for quic_crypto_decrypt() says 'Return: 0 on
  success, -EINPROGRESS for async operation, or negative error.' It also…

--

quic: add crypto packet encryption and decryption

This patch adds AEAD payload protection and QUIC header protection for
the TX and RX paths through quic_crypto_encrypt() and
quic_crypto_decrypt(). It also adds Retry integrity tag computation and
helpers to generate and verify Retry and address validation tokens.

> diff --git a/net/quic/crypto.c b/net/quic/crypto.c
> index c28c6fa565c1a..ccb1050921c34 100644
> --- a/net/quic/crypto.c
> +++ b/net/quic/crypto.c
> @@ -269,6 +270,485 @@ ciphers[QUIC_CIPHER_MAX + 1 - QUIC_CIPHER_MIN] = {

[ ... ]

> +/* Decrypts a QUIC packet after reception.  This function removes header
> + * protection, decrypts the payload, and processes any key updates if the key
> + * phase bit changes.
> + *
> + * Return: 0 on success, -EINPROGRESS for async operation, or negative error.
> + */
> +int quic_crypto_decrypt(struct quic_crypto *crypto, struct sk_buff *skb,
> +			gfp_t gfp)
> +{

[Severity: Low]
Is this return documentation complete? quic_crypto_decrypt() also returns
several negative values that act as control signals rather than ordinary
drop-the-packet errors:

	if (!cb->backlog) /* Key update requires process context. */
		return -EKEYREVOKED;
	/* Cannot do key update while async crypto is in progress. */
	if (unlikely(atomic_read(&crypto->async_pending[phase])))
		return -EBUSY;
	...
err:
	if (err == -EBADMSG && ++crypto->rx_fails >= crypto->cipher->rxlimit)
		err = -EKEYEXPIRED;

-EKEYREVOKED defers the key update to process context. -EBUSY is a
transient retry-later result. -EKEYEXPIRED means the integrity limit was
reached, and RFC 9001 section 6.6 requires the connection to be closed.

The text "processes any key updates if the key phase bit changes" also
doesn't hold for the -EKEYREVOKED and -EBUSY cases. In both, the key update
is postponed.

quic_crypto_encrypt() has the same gap for its confidentiality limit:

	if (crypto->tx_count[cb->key_phase] >= crypto->cipher->txlimit)
		return -EKEYEXPIRED;

Could these return values be documented, so that the callers added later in
the series know which ones need more than a plain drop? A caller that drops
on every negative return would lose key-update packets that arrive outside
backlog context.

[ ... ]

> @@ -566,6 +1046,257 @@ int quic_crypto_initial_keys_install(struct quic_crypto *crypto,

[ ... ]

> +int quic_crypto_generate_token(struct quic_crypto *crypto, void *addr,
> +			       u32 addrlen, struct quic_conn_id *conn_id,
> +			       u8 *token, u32 *tlen)
> +{

[ ... ]

> +	/* Use counter for nonce derivation to prevent collisions. */
> +	counter = crypto->tx_count[1]++;
> +	p = token_buf;
> +	p = quic_put_int(p, flag, sizeof(flag));
> +	p = quic_put_int(p, counter, sizeof(counter));
> +	p = quic_put_int(p, ts, tslen);
> +	p = quic_put_data(p, addr, addrlen);
> +	quic_put_data(p, conn_id->data, conn_id->len);
> +
> +	err = quic_crypto_token_protect(crypto, token_buf, len,
> +					sizeof(flag) + sizeof(counter), true);

[Severity: Medium]
Does this put a linkable sequence number in cleartext into every token?

The counter occupies token bytes 1-8. quic_crypto_token_protect() uses it
only as AAD and as nonce input (adlen = 1 + 8), so it is never encrypted.
quic_crypto_set_token_secret() seeds it only once per crypto instance:

	get_random_bytes(&crypto->tx_count[1], sizeof(crypto->tx_count[1]));

As a result, successive tokens from the same issuer carry X, X+1, X+2, and
so on in the clear.

Clients send these tokens back in cleartext Initial packets. Suppose a
server issues several NEW_TOKEN tokens on one connection, and the client
uses each one on a separate later connection, as RFC 9000 section 8.1.3
asks in order to avoid linking. An on-path observer could still group those
connections by their adjacent counter values.

For a listener that issues Retry tokens, the gap between two observed
counters also shows how many tokens were issued in between.

The v18 changelog moved the timestamp into the encrypted payload "to
prevent exposing server uptime and linking NEW_TOKEN tokens to their
issuing connections".

Would a random per-token nonce stored in the token, or a nonce input that
isn't visible on the wire, keep nonces unique without adding a new linkable
cleartext field?

[ ... ]

> @@ -269,6 +270,485 @@ ciphers[QUIC_CIPHER_MAX + 1 - QUIC_CIPHER_MIN] = {
>  		    QUIC_AEAD_TX_CHACHA, QUIC_AEAD_RX_CHACHA),
>  };
>  
> +static bool quic_crypto_is_cipher_ccm(struct quic_crypto *crypto)
> +{
> +	return crypto->cipher_type == TLS_CIPHER_AES_CCM_128;
> +}
> +
> +static bool quic_crypto_is_cipher_chacha(struct quic_crypto *crypto)
> +{
> +	return crypto->cipher_type == TLS_CIPHER_CHACHA20_POLY1305;
> +}
> +
> +static void *quic_crypto_skcipher_mem_alloc(struct crypto_skcipher *tfm,
> +					    u32 mask_size, u8 **iv,
> +					    struct skcipher_request **req,
> +					    gfp_t gfp)
> +{
> +	unsigned int iv_size, req_size;
> +	unsigned int len;
> +	u8 *mem;
> +
> +	iv_size = crypto_skcipher_ivsize(tfm);
> +	req_size = sizeof(**req) + crypto_skcipher_reqsize(tfm);
> +
> +	len = mask_size;
> +	len += iv_size;
> +	len += crypto_skcipher_alignmask(tfm) &
> +	       ~(crypto_tfm_ctx_alignment() - 1);
> +	len = ALIGN(len, crypto_tfm_ctx_alignment());
> +	len += req_size;
> +
> +	mem = kzalloc(len, gfp);
> +	if (!mem)
> +		return NULL;
> +
> +	*iv = (u8 *)PTR_ALIGN(mem + mask_size,
> +			      crypto_skcipher_alignmask(tfm) + 1);
> +	*req = (struct skcipher_request *)PTR_ALIGN(*iv + iv_size,
> +						    crypto_tfm_ctx_alignment());
> +
> +	return (void *)mem;
> +}
> +
> +/* Extracts and reconstructs the packet number from an incoming QUIC packet. */
> +static int quic_crypto_get_number(struct sk_buff *skb)
> +{
> +	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
> +	s64 number_max = cb->number;
> +	u32 len = cb->length;
> +	u8 *p;
> +
> +	/* rfc9000#section-17.1:
> +	 *
> +	 * Once header protection is removed, the packet number is decoded by
> +	 * finding the packet number value that is closest to the next expected
> +	 * packet. The next expected packet is the highest received packet
> +	 * number plus one.
> +	 */
> +	p = (u8 *)quic_hdr(skb) + cb->number_offset;
> +	if (!quic_get_int(&p, &len, &cb->number, cb->number_len))
> +		return -EINVAL;
> +	cb->number = quic_get_num(number_max, cb->number, cb->number_len);
> +	return 0;
> +}
> +
> +#define QUIC_SAMPLE_LEN		16
> +
> +#define QUIC_HEADER_FORM_BIT	0x80
> +#define QUIC_LONG_HEADER_MASK	0x0f
> +#define QUIC_SHORT_HEADER_MASK	0x1f
> +
> +/* Header Protection. */
> +static int quic_crypto_header_protect(struct quic_crypto *crypto,
> +				      struct sk_buff *skb, bool enc, gfp_t gfp)
> +{
> +	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
> +	u8 *mask, *iv, *p, h_mask, chacha;
> +	struct skcipher_request *req;
> +	struct crypto_skcipher *tfm;
> +	struct sk_buff *trailer;
> +	struct scatterlist sg;
> +	int err, i;
> +
> +	chacha = quic_crypto_is_cipher_chacha(crypto);
> +	if (!enc) {
> +		tfm = crypto->rx_hp_tfm;
> +		if (cb->length < QUIC_PN_MAX_LEN + QUIC_SAMPLE_LEN)
> +			return -EINVAL;
> +
> +		err = skb_cow_data(skb, 0, &trailer);
> +		if (err < 0)
> +			return err;
> +	} else {
> +		tfm = crypto->tx_hp_tfm;
> +	}
> +
> +	mask = quic_crypto_skcipher_mem_alloc(tfm, QUIC_SAMPLE_LEN, &iv, &req,
> +					      gfp);
> +	if (!mask)
> +		return -ENOMEM;
> +
> +	/* rfc9001#section-5.4.2: Header Protection Sample:
> +	 *
> +	 *   # pn_offset is the start of the Packet Number field.
> +	 *   sample_offset = pn_offset + 4
> +	 *
> +	 *   sample = packet[sample_offset..sample_offset+sample_length]
> +	 *
> +	 * rfc9001#section-5.4.3: AES-Based Header Protection:
> +	 *
> +	 *   header_protection(hp_key, sample):
> +	 *     mask = AES-ECB(hp_key, sample)
> +	 *
> +	 * rfc9001#section-5.4.4: ChaCha20-Based Header Protection:
> +	 *
> +	 *   header_protection(hp_key, sample):
> +	 *     counter = sample[0..3]
> +	 *     nonce = sample[4..15]
> +	 *     mask = ChaCha20(hp_key, counter, nonce, {0,0,0,0,0})
> +	 */
> +	p = skb->data + cb->number_offset + QUIC_PN_MAX_LEN;
> +	memcpy((chacha ? iv : mask), p, QUIC_SAMPLE_LEN);
> +	sg_init_one(&sg, mask, QUIC_SAMPLE_LEN);
> +	skcipher_request_set_tfm(req, tfm);
> +	skcipher_request_set_crypt(req, &sg, &sg, QUIC_SAMPLE_LEN, iv);
> +	err = crypto_skcipher_encrypt(req);
> +	if (err)
> +		goto out;
> +
> +	/* rfc9001#section-5.4.1:
> +	 *
> +	 * mask = header_protection(hp_key, sample)
> +	 *
> +	 * pn_length = (packet[0] & 0x03) + 1
> +	 * if (packet[0] & 0x80) == 0x80:
> +	 *    # Long header: 4 bits masked
> +	 *    packet[0] ^= mask[0] & 0x0f
> +	 * else:
> +	 *    # Short header: 5 bits masked
> +	 *    packet[0] ^= mask[0] & 0x1f
> +	 *
> +	 * # pn_offset is the start of the Packet Number field.
> +	 * packet[pn_offset:pn_offset+pn_length] ^= mask[1:1+pn_length]
> +	 */
> +	p = skb->data;
> +	h_mask = ((*p & QUIC_HEADER_FORM_BIT) == QUIC_HEADER_FORM_BIT) ?
> +		 QUIC_LONG_HEADER_MASK : QUIC_SHORT_HEADER_MASK;
> +	*p = (u8)(*p ^ (mask[0] & h_mask));
> +	if (!enc) {
> +		if (!quic_hdr(skb)->form)
> +			cb->key_phase = quic_hdr(skb)->key;
> +		cb->number_len = quic_hdr(skb)->pnl + 1;
> +	}
> +	p += cb->number_offset;
> +	for (i = 1; i <= cb->number_len; i++)
> +		*p++ ^= mask[i];
> +
> +	if (!enc)
> +		err = quic_crypto_get_number(skb);
> +out:
> +	kfree_sensitive(mask);
> +	return err;
> +}
> +
> +static void *quic_crypto_aead_mem_alloc(struct crypto_aead *tfm, u32 ctx_size,
> +					u8 **iv, struct aead_request **req,
> +					struct scatterlist **sg, u32 nsg,
> +					gfp_t gfp)
> +{
> +	unsigned int iv_size, req_size;
> +	unsigned int len;
> +	u8 *mem;
> +
> +	iv_size = crypto_aead_ivsize(tfm);
> +	req_size = sizeof(**req) + crypto_aead_reqsize(tfm);
> +
> +	len = ctx_size;
> +	len += iv_size;
> +	len += crypto_aead_alignmask(tfm) & ~(crypto_tfm_ctx_alignment() - 1);
> +	len = ALIGN(len, crypto_tfm_ctx_alignment());
> +	len += req_size;
> +	len = ALIGN(len, __alignof__(struct scatterlist));
> +	len += nsg * sizeof(**sg);
> +
> +	mem = kzalloc(len, gfp);
> +	if (!mem)
> +		return NULL;
> +
> +	*iv = (u8 *)PTR_ALIGN(mem + ctx_size, crypto_aead_alignmask(tfm) + 1);
> +	*req = (struct aead_request *)PTR_ALIGN(*iv + iv_size,
> +						crypto_tfm_ctx_alignment());
> +	*sg = (struct scatterlist *)PTR_ALIGN((u8 *)*req + req_size,
> +					      __alignof__(struct scatterlist));
> +
> +	return (void *)mem;
> +}
> +
> +static void quic_crypto_done(void *data, int err)
> +{
> +	struct sk_buff *skb = data;
> +	struct quic_crypto *crypto;
> +	struct quic_skb_cb *cb;
> +
> +	if (err == -EINPROGRESS)
> +		return;
> +
> +	cb = QUIC_SKB_CB(skb);
> +	crypto = *(struct quic_crypto **)cb->crypto_ctx;
> +	atomic_dec(&crypto->async_pending[cb->key_phase]);
> +
> +	kfree_sensitive(cb->crypto_ctx);
> +	cb->crypto_err = err;
> +	cb->crypto_done(skb);
> +}
> +
> +/* AEAD Usage. */
> +static int quic_crypto_payload_protect(struct quic_crypto *crypto,
> +				       struct sk_buff *skb, bool enc, gfp_t gfp)
> +{
> +	u8 *base_iv, *iv, i, nonce[QUIC_IV_LEN], ccm, phase;
> +	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
> +	u32 len, hlen, sglen, nsg;
> +	struct aead_request *req;
> +	struct crypto_aead *tfm;
> +	struct sk_buff *trailer;
> +	struct scatterlist *sg;
> +	void *ctx;
> +	__be64 n;
> +	int err;
> +
> +	ccm = quic_crypto_is_cipher_ccm(crypto);
> +	phase = cb->key_phase;
> +	hlen = cb->number_offset + cb->number_len;
> +	if (enc) {
> +		tfm = crypto->tx_tfm[phase];
> +		base_iv = crypto->tx_iv[phase];
> +		len = skb->len;
> +		err = skb_cow_data(skb, QUIC_TAG_LEN, &trailer);
> +		if (err < 0)
> +			return err;
> +		pskb_put(skb, trailer, QUIC_TAG_LEN);
> +		if (!quic_hdr(skb)->form)
> +			quic_hdr(skb)->key = phase;
> +		sglen = skb->len;
> +		nsg = (u32)err;
> +	} else {
> +		tfm = crypto->rx_tfm[phase];
> +		base_iv = crypto->rx_iv[phase];
> +		len = cb->length + cb->number_offset;
> +		if (len - hlen < QUIC_TAG_LEN)
> +			return -EINVAL;
> +		sglen = len;
> +		nsg = 1;
> +	}
> +
> +	ctx = quic_crypto_aead_mem_alloc(tfm, sizeof(void *), &iv, &req, &sg,
> +					 nsg, gfp);
> +	if (!ctx)
> +		return -ENOMEM;
> +
> +	sg_init_table(sg, nsg);
> +	err = skb_to_sgvec(skb, sg, 0, sglen);
> +	if (err < 0)
> +		goto out;
> +
> +	/* rfc9001#section-5.3:
> +	 *
> +	 * The associated data, A, for the AEAD is the contents of the QUIC
> +	 * header, starting from the first byte of either the short or long
> +	 * header, up to and including the unprotected packet number.
> +	 *
> +	 * The nonce, N, is formed by combining the packet protection IV with
> +	 * the packet number.  The 62 bits of the reconstructed QUIC packet
> +	 * number in network byte order are left-padded with zeros to the size
> +	 * of the IV. The exclusive OR of the padded packet number and the IV
> +	 * forms the AEAD nonce.
> +	 */
> +	memcpy(nonce, base_iv, QUIC_IV_LEN);
> +	n = cpu_to_be64(cb->number);
> +	for (i = 0; i < sizeof(n); i++)
> +		nonce[QUIC_IV_LEN - sizeof(n) + i] ^= ((u8 *)&n)[i];
> +
> +	/* For CCM based ciphers, first byte of IV is a constant. */
> +	iv[0] = TLS_AES_CCM_IV_B0_BYTE;
> +	memcpy(&iv[ccm], nonce, QUIC_IV_LEN);
> +	aead_request_set_tfm(req, tfm);
> +	aead_request_set_ad(req, hlen);
> +	aead_request_set_crypt(req, sg, sg, len - hlen, iv);
> +	if (cb->sync) {
> +		DECLARE_CRYPTO_WAIT(wait);
> +
> +		aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> +					  crypto_req_done, &wait);
> +		err = enc ? crypto_aead_encrypt(req) : crypto_aead_decrypt(req);
> +		if (err == -EINPROGRESS || err == -EBUSY)
> +			err = crypto_wait_req(err, &wait);
> +		goto out;
> +	}
> +
> +	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> +				  quic_crypto_done, skb);
> +	*(struct quic_crypto **)ctx = crypto;
> +	atomic_inc(&crypto->async_pending[phase]);
> +	cb->crypto_ctx = ctx; /* Async free context for quic_crypto_done() */
> +	err = enc ? crypto_aead_encrypt(req) : crypto_aead_decrypt(req);
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
> + * Return: 0 on success, -EINPROGRESS for async operation, or negative error.
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
> +	if (cb->resume) {
> +		err = cb->crypto_err;
> +		if (err)
> +			return err;
> +		goto out;
> +	}
> +
> +	cb->key_phase = crypto->key_phase;
> +	if (crypto->tx_count[cb->key_phase] >= crypto->cipher->txlimit)
> +		return -EKEYEXPIRED;
> +	crypto->tx_count[cb->key_phase]++;
> +	err = quic_crypto_payload_protect(crypto, skb, true, gfp);
> +	if (err)
> +		return err;
> +out:
> +	err = quic_crypto_header_protect(crypto, skb, true, gfp);
> +	if (err)
> +		return err;
> +	/* If a key update is pending and this is the first packet using the
> +	 * new key, save the current time. Later used to clear old keys after
> +	 * some time has passed (see quic_crypto_decrypt()).
> +	 */
> +	if (crypto->key_pending && !crypto->key_update_send_time &&
> +	    cb->key_phase == crypto->key_phase)
> +		crypto->key_update_send_time = quic_ktime_get_us();
> +	return 0;
> +}
> +
> +/* Decrypts a QUIC packet after reception.  This function removes header
> + * protection, decrypts the payload, and processes any key updates if the key
> + * phase bit changes.
> + *
> + * Return: 0 on success, -EINPROGRESS for async operation, or negative error.
> + */
> +int quic_crypto_decrypt(struct quic_crypto *crypto, struct sk_buff *skb,
> +			gfp_t gfp)
> +{
> +	struct quic_skb_cb *cb = QUIC_SKB_CB(skb);
> +	int err = 0;
> +	u64 time;
> +	u8 phase;
> +
> +	/* Payload was decrypted asynchronously.  Proceed with parsing packet
> +	 * number and key phase.
> +	 */
> +	if (cb->resume) {
> +		err = cb->crypto_err;
> +		if (err) {
> +			/* Apply same key_pending cleanup as synchronous path to
> +			 * avoid deadlock in key update state machine.
> +			 */
> +			if (crypto->key_pending &&
> +			    cb->key_phase != crypto->key_phase) {
> +				crypto->key_pending = 0;
> +				crypto->key_update_time = 0;
> +				crypto->key_update_send_time = 0;
> +			}
> +			goto err;
> +		}
> +		err = quic_crypto_get_number(skb);
> +		if (err)
> +			return err;
> +		goto out;
> +	}
> +	if (!cb->number_len) { /* Packet header not yet decrypted. */
> +		err = quic_crypto_header_protect(crypto, skb, false, gfp);
> +		if (err) {
> +			pr_debug("%s: hd decrypt err %d\n", __func__, err);
> +			return err;
> +		}
> +	}
> +
> +	/* rfc9001#section-6:
> +	 *
> +	 * The Key Phase bit allows a recipient to detect a change in keying
> +	 * material without needing to receive the first packet that triggered
> +	 * the change. An endpoint that notices a changed Key Phase bit updates
> +	 * keys and decrypts the packet that contains the changed value.
> +	 */
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
> +
> +out:
> +	/* rfc9001#section-6.2:
> +	 *
> +	 * If a packet is successfully processed using the next key and IV,
> +	 * then the peer has initiated a key update.
> +	 */
> +	if (cb->key_update) {
> +		crypto->key_pending = 1;
> +		crypto->key_derived = 0;
> +		crypto->key_phase = !crypto->key_phase;
> +	}
> +	/* rfc9001#section-6.1:
> +	 *
> +	 * An endpoint MUST retain old keys until it has successfully
> +	 * unprotected a packet sent using the new keys. An endpoint SHOULD
> +	 * retain old keys for some time after unprotecting a packet sent using
> +	 * the new keys.
> +	 */
> +	if (crypto->key_pending && cb->key_phase == crypto->key_phase) {
> +		time = crypto->key_update_send_time;
> +		if (time &&
> +		    quic_ktime_get_us() - time >= crypto->key_update_time) {
> +			crypto->key_pending = 0;
> +			crypto->key_update_time = 0;
> +			crypto->key_update_send_time = 0;
> +		}
> +	}
> +	return 0;
> +err:
> +	if (err == -EBADMSG && ++crypto->rx_fails >= crypto->cipher->rxlimit)
> +		err = -EKEYEXPIRED;
> +	return err;
> +}
> +
>  int quic_crypto_set_cipher(struct quic_crypto *crypto, u32 type)
>  {
>  	const struct quic_cipher *cipher;

[Severity: High]
What value does cb->number hold when a deferred key-update packet comes
back into quic_crypto_decrypt() from process context?

On the first pass in softirq context, cb->number_len is still 0. That
means quic_crypto_header_protect() runs: it removes header protection in
place, sets cb->key_phase and cb->number_len, and calls
quic_crypto_get_number(), which overwrites cb->number with the
reconstructed packet number. The flipped key phase then makes the
function return -EKEYREVOKED, or -EBUSY while async_pending[phase] is
non-zero. The packet is then requeued with cb->backlog set.

On the second pass cb->resume is 0 and cb->number_len is non-zero. Header
protection removal is correctly skipped, but that also skips the only
call to quic_crypto_get_number() outside the resume branch.
quic_crypto_payload_protect() then builds the AEAD nonce directly from
cb->number.

For the cb->resume path, the cover letter says callers reset cb->number
to the largest previously seen packet number before re-entering, and
quic_crypto_get_number() decodes it again. Suppose the backlog re-entry
follows the same caller contract. Then cb->number no longer holds this
packet's number, the nonce is wrong, and crypto_aead_decrypt() fails
with -EBADMSG.

The result would be that every peer-initiated key update whose first
packet lands in softirq context gets dropped. cb->key_update never takes
effect, so crypto->key_phase never flips. rx_fails is also incremented
for a valid packet. Every later packet from the peer under the new phase
goes through the same defer-and-fail cycle, so the connection stalls
instead of completing the key update.

Should quic_crypto_decrypt() call quic_crypto_get_number() when
cb->number_len is already set but cb->resume is not? Or must the caller
preserve the decoded cb->number across the backlog requeue? If it is the
latter, could that be documented next to the cb->number field? The two
re-entry paths would then have opposite contracts for the same field.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1795393690.git.lucien.xin%40gmail.com
