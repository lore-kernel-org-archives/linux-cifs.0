Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286874B0489;
	Tue, 15 Sep 2026 19:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789501855; cv=none; b=IIsrCaH6dTzDcp4oND434ts4HxoT/updQwmBZMh6OWHx+LbsEvuXItpMbUmMmNUvesKAYDMc+vhnOO7vEgagx8Gc7NWu1ZJxgN6mY0t2KpM9mUdVspJMKp5n2A5+yLtIT4IZaAOoqrfYzg4PNno68Upg8cVM7WF46GDBpcvDWdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789501855; c=relaxed/simple;
	bh=weysBftilaGof+eydWnwFKnAVaV9cO1UBGH6Dyjy3SA=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cYz+wveNp3d0e3LqzlYAIOo8iyT2bcq180XK8yQS0Jfkb6ok107oOv75ku6TNsXWM7h8iTMaWAezZwFROM3eFKAdU0BcGb1RIGZpEf7EmZFefToCkrZ2rduaa5IC2pz4PhRJ0iuI1Fq80z+O9uxhpKnx4IDFfYlWMC4v4bdEeIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c0Ris3+V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c0Ris3+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18621F00893;
	Tue, 15 Sep 2026 19:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789501853;
	bh=Ygz3AlpRNEAbW11RsmKEeuhy5GEYVpsZ/KpY12agi+c=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=c0Ris3+VEijzm2sXJLQciZv2ZIJZ3xg9bKwHOMxP2LWi5yPkmh8gJcWHPqo9IM/+m
	 P7auJriX3XwjpzB/z3zNnBLKpvygBCRlbxI6rpIQUCzzb+SRemJcNmwNrhhngQGlrU
	 J7y3NYb+bqBPboef9RQ3TJsi87eHAm+C1Tt83uep79F0Unjd3+nvrcvnzofXmOKe88
	 lIfL5Jg0Ep0u8LBG6mH8q6iqxrIiNTbLn+d7HX6Vpstnxys47mY2PaUFOBPao0wzys
	 W+k34W2fRQytiCoJjLuqj1YqYbS97CJhGgGQ2cB2ZfNO5E8g8d93HnIRsLQrbYyumW
	 zIyhL3VltfRtQ==
Subject: Re: [PATCH net-next v15 11/15] quic: add crypto key derivation and
 installation
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
Date: Tue, 15 Sep 2026 19:50:51 +0000
Message-ID: <178950185147.22033.10922498784930147476@kernel.org>
In-Reply-To: =?utf-8?q?=3Cf886c618bd560e42692c0ac3296bae4878755cc1=2E1789393?=
 =?utf-8?q?775=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3Cf886c618bd560e42692c0ac3296bae4878755cc1=2E17893937?=
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 1 · Low: 1

- [Medium] net/quic/Kconfig selects CRYPTO_HMAC but not a concrete digest
  implementation, while every entry of the new ciphers[] table in…
- [Low] quic_crypto_set_secret() consumes the uAPI struct
  quic_crypto_secret but never reads `level` or `reserved`, and honours…

--

quic: add crypto key derivation and installation

This adds net/quic/crypto.c with the QUIC key schedule: HKDF-Extract and
HKDF-Expand-Label helpers, Initial secret derivation, traffic secret
installation, key update, and stateless reset token derivation.  The new
struct quic_crypto is embedded per encryption level in struct quic_sock and
freed from the new quic_sock_destruct().

> diff --git a/net/quic/crypto.c b/net/quic/crypto.c
> new file mode 100644
> index 0000000000000..910557b680524
> --- /dev/null
> +++ b/net/quic/crypto.c
> @@ -0,0 +1,567 @@

[ ... ]

> +static const struct quic_cipher
> +ciphers[QUIC_CIPHER_MAX + 1 - QUIC_CIPHER_MIN] = {
> +	CIPHER_DESC(TLS_CIPHER_AES_GCM_128,
> +		    "gcm(aes)", "ecb(aes)", "hmac(sha256)"),
> +	CIPHER_DESC(TLS_CIPHER_AES_GCM_256,
> +		    "gcm(aes)", "ecb(aes)", "hmac(sha384)"),
> +	CIPHER_DESC(TLS_CIPHER_AES_CCM_128,
> +		    "ccm(aes)", "ecb(aes)", "hmac(sha256)"),
> +	CIPHER_DESC(TLS_CIPHER_CHACHA20_POLY1305,
> +		    "rfc7539(chacha20,poly1305)", "chacha20", "hmac(sha256)"),
> +};
> +
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

[Severity: Medium]

Every entry of ciphers[] requests either hmac(sha256) or hmac(sha384), but
net/quic/Kconfig does not select a digest implementation:

	select CRYPTO
	select CRYPTO_HMAC
	select CRYPTO_AES
	select CRYPTO_GCM
	select CRYPTO_CCM
	select CRYPTO_CHACHA20POLY1305
	select NET_UDP_TUNNEL

CRYPTO_HMAC is only the template (it selects CRYPTO_HASH and
CRYPTO_MANAGER), while CRYPTO_SHA256 and CRYPTO_SHA512 are independent
tristates without default y.

With IP_QUIC=y/m and CRYPTO_SHA256=n, does crypto_alloc_shash(cipher->shash,
0, 0) in quic_crypto_set_cipher() fail with -ENOENT, so that
quic_crypto_set_secret() and quic_crypto_initial_keys_install() can never
install keys and no connection can be established?

Should IP_QUIC also select CRYPTO_SHA256 and CRYPTO_SHA512 (the latter for
the hmac(sha384) entry)?

[ ... ]

> +int quic_crypto_set_secret(struct quic_crypto *crypto,
> +			   struct quic_crypto_secret *srt, u32 version)
> +{
> +	const struct quic_cipher *cipher;
> +	u8 phase = crypto->key_phase;
> +	int err;
> +
> +	/* If no cipher has been initialized yet, set it up. */
> +	if (!crypto->cipher) {
> +		err = quic_crypto_set_cipher(crypto, srt->type);
> +		if (err)
> +			return err;
> +	}
> +	cipher = crypto->cipher;

[Severity: Low]

This isn't a bug in the current series, since quic_do_setsockopt() still
returns -EOPNOTSUPP and the only in-tree producer,
quic_crypto_initial_keys_install(), sets srt.type = TLS_CIPHER_AES_GCM_128 on
both calls.

Still, srt->type is only consulted while crypto->cipher is NULL, and
srt->level and srt->reserved are never read at all.  Once the setsockopt path
is wired up, would a second call carrying a different TLS_CIPHER_* value be
silently served with the already installed cipher, copying cipher->secretlen
bytes out of the caller's secret buffer instead of returning -EINVAL?

Would it make sense to reject srt->type disagreeing with crypto->cipher_type
here?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1789393775.git.lucien.xin%40gmail.com
