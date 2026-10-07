Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F5522D792;
	Wed,  7 Oct 2026 01:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791335125; cv=none; b=ocZNv4Hq/i27B5wvZdsmqdBbXwrlc7ogtQ/Mq6knoc95Dk1pRwxwKWOeDYoeFzZk8Ehfwxc4UhmCwM1AAO93RsGzvxoXcuag6a8EXa+9AnEWFYu6qT4h1lJr7a1febhlTVgGJCQWAlaYR5JkpKoBz1lyaAA6HszEKj/zd0a53G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791335125; c=relaxed/simple;
	bh=zk7WlV4y7nKoKBosfyOVjlrcn8sZouYVTZco+0tsLQk=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HFDefFeVn4yd3xqptyfSMQ3idbE/oDkAHET8Gb1b5A5HyPM0EdwKWcsFTkv0Hmsl4UJVcsAS9ljDlq0GqJT1jOPztpcGDVwEd0w4hHJ1OJrE8183X6RAU2mjNvzyFthGw32qlyo4whR5BAgYcWJA15wUh61urag2KZy+N1F4wk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GT3MQzRl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GT3MQzRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9601F0089B;
	Wed,  7 Oct 2026 01:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791335123;
	bh=1GiWlKTJSTlyYOqlE+nE9lrWSKcGbD4+/VoTJ34E2c8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=GT3MQzRlZa5eBO1b6nKm111+H2SAaljxS4IQ12W7ToRJ1vl+hRAa8SB1PAq5au5Vf
	 jL9pCjMqI5C5aa/6RbAx7Q5yIMnwo+DV7rFGYoKwhChWTMkyqe/2ZgNumQTvUVZlnS
	 NpU8zxc3XZjd3bYwrdMixcP5S4kfpO+vfij4MoQ/2HTxhYRNIbN52VDubEe4rAP0+f
	 9XJn0isNccsTj11ZKzb3Y8VLislTHLD5zQafZAPVtoyTEzCDYaanPPuFeq1BoTT7oa
	 MsisxjPJZjGa28jJhl/tNsAkFVfw4kb+2+NJYdtGExQPjKP7zPCQ85UGvkL+BRMtat
	 3KLJcXJNKitzw==
Subject: Re: [PATCH net-next v16 11/15] quic: add crypto key derivation and
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
 mef@scarletmail.rutgers.edu, paul@jakma.org, kuniyu@google.com
Date: Wed, 07 Oct 2026 01:05:21 +0000
Message-ID: <179133512119.434549.18318076229328796602@kernel.org>
In-Reply-To: =?utf-8?q?=3Ce7412c320cae4da8e01f4f4809f92e570a999593=2E1791227?=
 =?utf-8?q?050=2Egit=2Elucien=2Exin=40gmail=2Ecom=3E?=
References: =?utf-8?q?=3Ce7412c320cae4da8e01f4f4809f92e570a999593=2E17912270?=
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

Thank you for your contribution! Sashiko AI review found 2 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 1 · Low: 1

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] quic_crypto_keys_derive_and_install() (net/quic/crypto.c) sets
  `crypto->rx_fails[phase] = 0` every time it installs RX keys.
- [Low] Two comments in net/quic/crypto.c do not match the code.

--

quic: add crypto key derivation and installation

This patch adds the quic_crypto component. It derives and installs QUIC
packet protection keys for the Initial, Handshake, 0-RTT and 1-RTT
levels. Its helpers cover initial key installation, transform allocation,
traffic secret installation, key updates, and secret derivation for
stateless reset tokens and session resumption, and a new
quic_sock_destruct() frees the crypto state.

> diff --git a/net/quic/crypto.c b/net/quic/crypto.c
> new file mode 100644
> index 0000000000000..4bb6acea5112a
> --- /dev/null
> +++ b/net/quic/crypto.c
> @@ -0,0 +1,587 @@

[ ... ]

> +/* Derive and install reception (RX) or transmission (TX) packet protection
> + * keys for the current key phase.  This installs AEAD protection key, IV, and
> + * optionally header protection key.
> + */

[Severity: Low]
This isn't a bug, but this comment says the keys are installed "for the
current key phase". The function takes an explicit phase argument, and
quic_crypto_key_update() calls it with !phase, which is the next phase.

That is also the case where header protection key derivation is skipped:

	if (crypto->key_phase == phase)
		hp = quic_data(&hp_k, hp_key, keylen);

There is a similar mismatch in quic_crypto_set_cipher(). The comments say:

	/* Allocate AEAD and HP transform for each RX key phase. */
	...
	/* Allocate AEAD and HP transform for each TX key phase. */

But only one HP skcipher is allocated per direction (rx_hp_tfm and
tx_hp_tfm), and both phases share it. Only the AEAD tfms are per phase.

Could these comments be updated to match the code?

> +static int quic_crypto_keys_derive_and_install(struct quic_crypto *crypto,
> +					       bool rx, u8 phase)
> +{

[ ... ]

> +	if (rx) {
> +		crypto->rx_fails[phase] = 0;

[Severity: Medium]
Can resetting rx_fails[phase] here let the connection go past the AEAD
integrity limit?

RFC 9001 section 6.6 says endpoints must count packets that fail
authentication across all keys used in the connection. Once that total
goes over the integrity limit, the endpoint has to close the connection
with AEAD_LIMIT_REACHED.

Here the counter is split by key phase, and every RX key installation
zeroes it, including each key update:

quic_crypto_key_update()
    quic_crypto_keys_derive_and_install(crypto, true, !phase)
        crypto->rx_fails[phase] = 0;

crypto.h also describes rxlimit as "Max failures decrypted per key".

Later in the series, "quic: add crypto packet encryption and decryption"
checks the limit in quic_crypto_decrypt() like this:

	if (++crypto->rx_fails[cb->key_phase] >= crypto->cipher->rxlimit)
		err = -EKEYEXPIRED;

The later patches do not change how the counter works.

An off-path attacker who knows the connection ID could send forged
short-header packets until one phase counter is just below rxlimit. The
next legitimate key update would then reset that counter to zero.

With AES-CCM the limit is 2^21.5. A busy connection also has to update
its keys about every 2^21.5 sent packets, so the attacker's total
forgery budget grows with each key update. Splitting the count by phase
also allows about twice rxlimit per key epoch.

Should rx_fails be one connection-wide counter that key installation does
not reset?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1791227050.git.lucien.xin%40gmail.com
