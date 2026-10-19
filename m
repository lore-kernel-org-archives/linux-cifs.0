Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792445411;
	b=3ykA7QEhydUPOktsTEPnJIDypQo/Aassr4AnRdld2fofdlu/yGBwpNGAuypVlkM+Fmrc
	 RWhzwHFhyPcc/HXJJtzLApiQfS+Zx3SeU0GOql4Ceq6PjHJmZt6WmK7qvsaQGgQLl4hUv
	 E1jFWR4xhsARMxovI5kxJT7DbDVF7R1r/+8oOWHTJzZCu4KVurDbI6m9tLIMyHZZXkHV9
	 lJm97mIhwvpyrWk52YCe1DBYmh4ts2imGXMc2cnT4bUTe7dIHMG8bAxQkdqpA8zbMY3Jp
	 8H89LpveDtYXAB0AhozGz57eDoAl+yMeYbkI3O2gnOrbqSlFAcDnuRwI6M3Y2/fG8Sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792445411;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=SvWICS5d2ZO96odk1YMmjSOzZ9QDsK7PMARrfbrVRUg=;
	b=H/ukV6L3/t0oZtdzq3QJ/LBwtFKC17bvOnPZasRyw7/4FYxLd1Pr/AAfB6vy/WNxYbtk
	 l5zJOQPjgyO2qPdCaUPl+QYiyxxo+Kpc6og5VC30f0o5o6EnwoCD5mEchMKNKsXlf4oVb
	 DVSB5H+grXImDSwH0VnLeB6prB5Ggyd1TzLlFrAIV+zwJ4Lmc4Ap4W53xdJunGOcrvYgz
	 p83ykCH83sM7e62sLhC5TZNR/HheAs6ZvbxgTFl2BI1/Q0T41NxI0Bq60SV4MwgUE5kAY
	 1pJK0GJqeFDLvbLuKzuSSLrROtutm2ZOalSeYHAJongeWqNpDZ1wOS3MRmXYDdNcmUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HYHco4a9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1A3606A31F;
	Mon, 19 Oct 2026 21:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HYHco4a9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028AC1F000C6;
	Mon, 19 Oct 2026 21:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792445410;
	bh=SvWICS5d2ZO96odk1YMmjSOzZ9QDsK7PMARrfbrVRUg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=HYHco4a9bUJow4aGG/dcXfAF5HohWU4EkeV4mL97YC4ubVS7iJKuo1Gh0IfI3Pz/i
	 XUaFgFgEDdfOgvj5ep/zZmHQ4K7AEvOEt/8Xu986jj+r71s8GShGbYwvSDswfNYf5Z
	 FUucajWjd3LYd140qD8kGaSikP5ygWeA1VH8qo3Lje+vGAirbE3ABPJ3g4lv2A2jhD
	 5obWywIm4B2E4Ax4wPtC70r4rrWVNPdTPeClL7S9gWNlsrA8doAaT1Q8qlr0HKZepY
	 C0loDkYYz4gPXFwmDzctAs+9XLyBPxVj2i+fzswM6WZeedjNAtUq8Sf/XBQoMu9KW9
	 rz0gmhdJ/lEsA==
Subject: Re: [PATCH net-next v17 12/15] quic: add crypto packet encryption and
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
Date: Mon, 19 Oct 2026 21:30:07 +0000
Message-ID: <179244540755.3135.6629272689764365696@kernel.org>
In-Reply-To: =?utf-8?q?=3C25d5d63b6de931191e4c1bb0d99edf427facf1a6=2E1792164?=
 =?utf-8?q?438=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3C25d5d63b6de931191e4c1bb0d99edf427facf1a6=2E17921644?=
 =?utf-8?q?38=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
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

Thank you for your contribution! Sashiko AI review found 4 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] The token timestamp is sent in cleartext, and the obfuscation
  offset is too narrow to hide server uptime.
- [Medium] NEW_TOKEN tokens can be linked to the connection that issued
  them, which RFC 9000 Section 8.1.3 forbids.
- [Low] quic_crypto_decrypt() adds every payload-stage failure to the
  connection-wide integrity counter crypto->rx_fails, not just…
- [Low] When an old-key TX packet resumes after async encryption, it can
  start the key-retention timer meant for the first new-key packet.

--

quic: add crypto packet encryption and decryption

This patch adds AEAD payload protection and QUIC header protection for
packets on TX and RX, along with key phase tracking and key update
handling. It also adds helpers to compute the Retry integrity tag and to
generate and verify Retry and address validation tokens.

> diff --git a/net/quic/crypto.c b/net/quic/crypto.c
> index 2b72a781493af..93fd4cdb055f2 100644
> --- a/net/quic/crypto.c
> +++ b/net/quic/crypto.c

[ ... ]

> @@ -269,6 +270,484 @@ ciphers[QUIC_CIPHER_MAX + 1 - QUIC_CIPHER_MIN] = {

[ ... ]

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

[ ... ]

> +out:
> +	err = quic_crypto_header_protect(crypto, skb, true, gfp);
> +	if (err)
> +		return err;
> +	/* If a key update is pending and this is the first packet using the
> +	 * new key, save the current time. Later used to clear old keys after
> +	 * some time has passed (see quic_crypto_decrypt()).
> +	 */
> +	if (crypto->key_pending && !crypto->key_update_send_time)
> +		crypto->key_update_send_time = quic_ktime_get_us();

[Severity: Low]

Can a packet protected with the old key start the old-key retention timer
here when it resumes from async encryption?

One possible sequence:

  TX packet encrypted asynchronously with cb->key_phase = 0
    (async_pending[0]++)

  RX packet with key phase 1 arrives on the backlog
    quic_crypto_decrypt()
      async_pending[1] check passes
      quic_crypto_key_update()
      key_pending = 1, key_phase = 1, key_update_send_time still 0

  Phase 0 TX packet resumes
    quic_crypto_encrypt()
      cb->resume -> goto out
      key_update_send_time = quic_ktime_get_us()

The comment says the timestamp is for "the first packet using the new
key", but this packet used the old key.

The next phase 1 RX packet in quic_crypto_decrypt() can then clear
key_pending based on this earlier timestamp. A later reordered phase 0
packet would then trigger a new key derivation instead of being decrypted
with the retained old keys.

Should this condition also require cb->key_phase == crypto->key_phase?

> +	return 0;
> +}

[ ... ]

> +int quic_crypto_decrypt(struct quic_crypto *crypto, struct sk_buff *skb,
> +			gfp_t gfp)
> +{

[ ... ]

> +	err = quic_crypto_payload_protect(crypto, skb, false, gfp);
> +	if (err) {
> +		if (err == -EINPROGRESS)
> +			return err;

[ ... ]

> +		goto err;
> +	}

[ ... ]

> +	return 0;
> +err:
> +	if (++crypto->rx_fails >= crypto->cipher->rxlimit)
> +		err = -EKEYEXPIRED;

[Severity: Low]

Should rx_fails only count authentication failures here?

Every error that reaches the err label is counted. That includes -ENOMEM
from quic_crypto_aead_mem_alloc() and negative returns from skb_to_sgvec()
in quic_crypto_payload_protect(). It also includes any non-authentication
error a driver reports through cb->crypto_err on the resume path.

RFC 9001 Section 6.6 defines the integrity limit in terms of packets that
fail authentication. For AES-CCM the rxlimit is about 2^21.5. On a
long-lived connection, repeated local allocation failures under memory
pressure could eventually push it to -EKEYEXPIRED.

Would it be more accurate to increment rx_fails only when
err == -EBADMSG?

> +	return err;
> +}

[ ... ]

> @@ -565,6 +1044,241 @@ int quic_crypto_initial_keys_install(struct quic_crypto *crypto,

[ ... ]

> +int quic_crypto_generate_token(struct quic_crypto *crypto, void *addr,
> +			       u32 addrlen, struct quic_conn_id *conn_id,
> +			       u8 *token, u32 *tlen)
> +{
> +	u64 ts = quic_ktime_get_us() - crypto->ts_off;

[Severity: Medium]

Does this offset hide the server uptime?

quic_ktime_get_us() is the monotonic clock in microseconds, but ts_off is
only 32 bits wide:

net/quic/crypto.h:
	u32 ts_off;      /* Random offset for token timestamps */

net/quic/crypto.c:quic_crypto_set_token_secret() {
    ...
	if (!crypto->ts_off)
		get_random_bytes(&crypto->ts_off, sizeof(crypto->ts_off));
    ...
}

That caps the offset at 2^32 us, or about 71.6 minutes.

The timestamp is also part of adlen in the quic_crypto_token_protect()
call below. Bytes 1..8 of the token are therefore authenticated but not
encrypted, and they go out in cleartext.

Any client that receives a Retry or NEW_TOKEN token can read the server's
monotonic uptime to within about 72 minutes. The v17 changelog says ts_off
is used "to prevent timestamps from directly revealing system uptime". Is
that achieved with a 32-bit offset?

quic_crypto_verify_token() already uses the wrap-safe age = (s64)(ts - t).
Would a 64-bit random offset work here with no other changes?

> +	u8 *token_buf, *p, flag = *token;
> +	u32 len, tslen = sizeof(ts);
> +	int err;
> +
> +	len = sizeof(flag) + tslen + addrlen + conn_id->len + QUIC_TAG_LEN;
> +	token_buf = kmalloc(len, GFP_KERNEL);
> +	if (!token_buf)
> +		return -ENOMEM;
> +
> +	p = token_buf;
> +	p = quic_put_int(p, flag, sizeof(flag));
> +	p = quic_put_int(p, ts, tslen);
> +	p = quic_put_data(p, addr, addrlen);
> +	quic_put_data(p, conn_id->data, conn_id->len);
> +
> +	err = quic_crypto_token_protect(crypto, token_buf, len,
> +					sizeof(flag) + tslen, true);

[Severity: Medium]

Can an observer link a NEW_TOKEN token to the connection that issued it?

With adlen = sizeof(flag) + tslen, the microsecond timestamp is associated
data. The client later presents the token in the Token field of an Initial
packet, and the timestamp is readable there in cleartext.

ts_off is set only once per crypto context. Tokens are generated and
verified with the listener's initial crypto, so every token from a
listener uses the same offset.

An on-path observer could find that offset by requesting its own Retry
token. It could then map the ts in any presented token to the microsecond
it was issued and match that against the packet timing of the earlier
connection, even across address changes.

RFC 9000 Section 8.1.3 requires that a token issued with NEW_TOKEN must
not include information that would allow an observer to link it to the
connection on which it was issued.

This appears to come from the v14 change that moved the timestamp from the
encrypted part into the AAD so it could be used to derive the nonce. Could
the timestamp stay in the encrypted part, with the nonce built from
something that does not reveal the issue time?

> +	if (err)
> +		goto out;
> +
> +	memcpy(token, token_buf, len);
> +	*tlen = len;
> +out:
> +	kfree_sensitive(token_buf);
> +	return err;
> +}

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1792164438.git.lucien.xin%40gmail.com
