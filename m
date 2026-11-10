Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794349791;
	b=RN8x1sojbjwEwqo9R11T+gN/piFkrcmXZLtIGL284YNXuhPObkXZcN2Sy9AHRtM6WY17
	 CcqZQM3j8FLWQkAc92ydNqLW7I1okCLAG3AIf799daAF15QhScL1kdWpNaC9o/ZlFsyQv
	 YpTUfsupFh4h+eCMlnASrj5lBNC/jK1fx60lItjOjRgI1PCu9wz+9iVBoC7D4VVlQ1lRU
	 e0o0nJ1Mx17/WxEAieJBMVnvkzwNue/i8qBZOrhNLBPgXmAlBOElqUtAExLi9/3XqKn5F
	 AzYWvyirmOuRjADHea4Jq86C2dpABR3RzKXXlmp8JssVtdhKIxu2NTgspw9m6Mg3DoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794349791;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=A7tASFXnNuPE+e+nS1b06UWislcan1F6/IvDUWRJ6dY=;
	b=yNL66GEQaEO0EBwlLoL562gKsLnCA+sCfY1witHKsWdL9UQowA5VOHpE+r9KiRTQZW2w
	 SSYm8qYcw4o29hvRXYk2UaGxLOdadw/59ObxWLyudptE0sk39No/R1++c8+zokW/1uU1f
	 2MnzL7r5GwaLpoSWzpqH+53A9Z+zlK9tkiqudUFEaVzL5/irseWn+FhVLcf9oS+Ya15Ct
	 s179dVage5IJHOTNtcFO4mnF4Ozd8nYVOdjnyrdGrryiBOkKVKSLHxo4bc6jjIQ5WM2g9
	 jyQIE8z/Yq0ErgxuSnQXpKfXt5Nx0WFyJJJwdn9cDiZyWMj9Kz2gw4+0zKgCGS2ViKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XYAFMpwx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27D0606A325;
	Tue, 10 Nov 2026 22:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XYAFMpwx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614441F008A2;
	Tue, 10 Nov 2026 22:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794349790;
	bh=A7tASFXnNuPE+e+nS1b06UWislcan1F6/IvDUWRJ6dY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=XYAFMpwxw45Mkdk/2AXix7iUkAY1Rlyq/LaeRmxo2ZjGrowkCLXk3KEBUGulsXekV
	 bmSSzJ4an125Gqm1gKtJKoVoFIJQrnUePTefr1iaTldCLN2lh64LouTcFPx24kMBAE
	 S2W8xZ9s80qGLkMUUtJDErfiYwzS69M5K6XHgzLVO02mo/2yn5Y+WhJ+16pHFQGX6O
	 91bwg4+RziJEIUvoSY94FuYsGBzc5MldYAnZgu637Rox3jGNzVoigXhy/9rjpMc3cL
	 OCYOWyCNOyvW5qqTnydp31qSrF9e/F6zdArpmqUxoGP8HT9MCPDN/AQeXirofAoqmX
	 O2orAmc+iok1g==
Subject: Re: [PATCH net-next v18 11/15] quic: add crypto key derivation and
 installation
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
Date: Tue, 10 Nov 2026 22:29:47 +0000
Message-ID: <179434978792.994134.17759133431780284123@kernel.org>
In-Reply-To: <b269e7436d8e9b5816a8e716d661767a2e43c27b.1794241656.git.lucien.xin@gmail.com>
References: <b269e7436d8e9b5816a8e716d661767a2e43c27b.1794241656.git.lucien.xin@gmail.com>
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

- [Medium] quic_crypto_set_cipher() (net/quic/crypto.c:272) stores seven
  freshly allocated transforms (secret_tfm, rx_tfm[0..1], rx_hp_tfm,…
- [Low] The commit message that stays in git history leaves out the
  socket lifecycle changes in net/quic/socket.c.
- [Low] quic_crypto_set_cipher() allocates the header-protection
  transforms with crypto_alloc_sync_skcipher(), which returns struct…

--

quic: add crypto key derivation and installation

This patch adds net/quic/crypto.c. It provides HKDF helpers, cipher
transform allocation, traffic secret installation, key update and
stateless reset token derivation for QUIC. It also allocates one
struct quic_crypto per encryption level in quic_init_sock(), and a new
sk_destruct callback defers freeing those contexts to quic_wq.

> quic: add crypto key derivation and installation
>
> This patch introduces 'quic_crypto', a component responsible for QUIC
> encryption key derivation and installation across the various key
> levels: Initial, Handshake, 0-RTT (Early), and 1-RTT (Application).

[ ... ]

> - quic_crypto_derive_secret(): Generate token for stateless reset or
>   master key for session resumption.
>
> These mechanisms are essential for establishing and maintaining secure
> communication throughout the QUIC connection lifecycle.

[Severity: Low]
The commit message describes this patch only as adding crypto helpers.
Could it also mention the socket lifecycle changes in net/quic/socket.c?

The patch also does the following:

  - installs a new quic_sock_destruct() as sk->sk_destruct in
    quic_init_sock()
  - allocates QUIC_CRYPTO_MAX struct quic_crypto contexts per socket
    with kzalloc_obj()
  - defers transform teardown to quic_crypto_free_work() on quic_wq,
    which runs after the socket has been destroyed

The function list also leaves out the new exported helper
quic_crypto_set_token_secret().

These details appear only in the v18 notes below the --- line, and
git am drops that text.

> diff --git a/net/quic/crypto.c b/net/quic/crypto.c
> new file mode 100644
> index 0000000000000..c4bf99b3e8239
> --- /dev/null
> +++ b/net/quic/crypto.c

[ ... ]

> +int quic_crypto_set_cipher(struct quic_crypto *crypto, u32 type)
> +{
> +	const struct quic_cipher *cipher;
> +	void *tfm;
> +	int err;
> +
> +	if (type < QUIC_CIPHER_MIN || type > QUIC_CIPHER_MAX)
> +		return -EINVAL;
> +
> +	cipher = &ciphers[type - QUIC_CIPHER_MIN];
> +	tfm = crypto_alloc_shash(cipher->shash, 0, 0);
> +	if (IS_ERR(tfm))
> +		return PTR_ERR(tfm);
> +	crypto->secret_tfm = tfm;

[ ... ]

> +	tfm = crypto_alloc_sync_skcipher(cipher->skc, 0, 0);
> +	if (IS_ERR(tfm)) {
> +		err = PTR_ERR(tfm);
> +		goto err;
> +	}
> +	crypto->rx_hp_tfm = tfm;

[Severity: Low]
Are the types for the header protection transforms consistent here?

crypto_alloc_sync_skcipher() returns a struct crypto_sync_skcipher *.
The result passes through the void *tfm local into rx_hp_tfm, and
tx_hp_tfm is handled the same way. Both fields are declared as struct
crypto_skcipher * in net/quic/crypto.h.

quic_crypto_free() then releases them with crypto_free_skcipher()
instead of crypto_free_sync_skcipher():

	if (crypto->rx_hp_tfm)
		crypto_free_skcipher(crypto->rx_hp_tfm);
	if (crypto->tx_hp_tfm)
		crypto_free_skcipher(crypto->tx_hp_tfm);

This works today only because struct crypto_sync_skcipher wraps a
struct crypto_skcipher base at offset 0. Because tfm is a void *, the
compiler cannot catch the mismatch. The mismatch is still present at
the end of the series, where quic_crypto_header_protect() uses these
fields as struct crypto_skcipher *.

Should the fields be declared as struct crypto_sync_skcipher * and
freed with crypto_free_sync_skcipher()?

[ ... ]

> +	crypto->tx_hp_tfm = tfm;
> +
> +	crypto->cipher = cipher;
> +	crypto->cipher_type = type;
> +	return 0;
> +err:
> +	quic_crypto_free(crypto);
> +	return err;
> +}

[Severity: Medium]
Can this error path destroy state that this call did not create?

quic_crypto_set_cipher() stores seven newly allocated transforms
without checking whether the context already holds any. On failure it
calls quic_crypto_free() on the whole context. That frees every
transform and then zeroes the structure up to send_offset:

	memzero_explicit(crypto, offsetof(struct quic_crypto, send_offset));

If this ran on a context that was already set up, the old transforms
would leak. If that second call then failed, it would also wipe the
live keys, the token secret in tx_secret[1], and the cipher,
send_ready and recv_ready state.

In this series the only caller is quic_crypto_set_secret(). It calls
quic_crypto_set_cipher() only when crypto->cipher is NULL, so this
path does not appear to be reachable yet.

The notes say later patches call quic_crypto_set_cipher() directly from
quic_inet_listen(), quic_connect() and quic_accept(). Those patches are
not part of this series.

Would it be safer to reject a context that already has transforms, and
to unwind only the allocations made by this call?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1794241654.git.lucien.xin%40gmail.com
