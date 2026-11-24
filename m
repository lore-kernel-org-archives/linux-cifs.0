Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795483284;
	b=fzMVRjS3JxZKFUuWOblT89HEjlk1lGkGV8vmpL4Zpa23O5xQ+PoY/Ev0DQNnHDi73j23
	 P1sLgKu+YTx49wx5y7DF6WL9WIGJBYazm1Q985+fMgwD+NXUvPWjZVVh9B7lJCg0gNYJT
	 HQNgqUGQOGFfq5QTwPWXEcfphK8PaeWLtlBPzRy3WvL7cpnUbtXY5ZX4afZob+ENLPQP+
	 69ulXJXGuyrJez0esMXx+QJWjCWztf+eT4ywHOKZyA/aCiHWsEDe3n/6wkliHsaXysjWr
	 Z+OavoavtDXRovSaKsmcSNRLkBuyVVJRfmoJp4aYZPXPtNIvIJwy4zBjDzfspSrtEzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795483284;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=tDDaWID/lQ1QzxC8r4xF/LXzQrCJIGE9RJf2Gc3LDsw=;
	b=FJh858R1IaxhArYsh8W01hH2RNfMFHcrLA9ytq1O8/Y07jdcO3zzNQx2lodBI5aHk5jy
	 zN6xMJ1GTrW5Cn9IfPMkzQnRkCfuWvmo5pJpIA39cgnJmnSOHLkZhZNFG3Cqpx9rUuEE4
	 9WrBD352/l86T2fSG63EsovqlnlbpjleoRiRR/RCxBMNKMxANJNl8OeSlivNjKh9uOwt1
	 +hX0jVrs0UQelUqTqj1+TGzRJ45EKjrRGAYjGqO30u++Eex0lmz233JQHWPIhPVQfL3h4
	 zlGcQYgUyOnRG2y0R6XxyoQ+8ORMYnWa09V9KPwNnplURn6+RE6I23LwoodVch/SpOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XOLa7GEn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F22A606A321;
	Tue, 24 Nov 2026 01:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XOLa7GEn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84091F000CF;
	Tue, 24 Nov 2026 01:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795483283;
	bh=tDDaWID/lQ1QzxC8r4xF/LXzQrCJIGE9RJf2Gc3LDsw=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=XOLa7GEnCURmfUATmU74iiejawy8vIhx7IMw4yTerYxgkNp7j7PdaYJQKVcil+86Q
	 /Hh9U4sHgwJgFwMkB8EnY1ugcSWoeMFys1eMoFYmIIs1kecwbiX2vCPiQIpgUNBqO2
	 i+kej04mJqcPqGimxtVlsugTMcl/WnuIR6vuro4BHascCBLZ4p6puEKieZqYmB/7Gj
	 wTtBtplu46Ou8OMDoVpdhqkkWHl/pIQWQ7aLbVIfIqlpdUX7yWZXUfkM4KrSLM7+RW
	 gegf2VBlQqgGjIND61JkIeZoA1YmuxCtgU2McBz0ThRqoKolCAp4DVO4kjnpGQGMo8
	 FCRE0xzl4Xncg==
Subject: Re: [PATCH net-next v19 11/15] quic: add crypto key derivation and
 installation
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
Date: Tue, 24 Nov 2026 01:21:21 +0000
Message-ID: <179548328150.3135.7027633658882912871@kernel.org>
In-Reply-To: <035db09843f506bea729e16d523b453c56647be8.1795393691.git.lucien.xin@gmail.com>
References: <035db09843f506bea729e16d523b453c56647be8.1795393691.git.lucien.xin@gmail.com>
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

Thank you for your contribution! Sashiko AI review found 5 potential
issue(s) to consider.

Critical: 0 · High: 0 · Medium: 2 · Low: 3

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] Shared token key: AES-GCM nonce uniqueness across sockets
  depends only on a random 64-bit counter start.
- [Medium] The AEAD integrity limit is enforced per encryption level, but
  RFC 9001 Section 6.6 requires it per connection.
- [Low] The commit message body does not mention the socket lifecycle
  changes in net/quic/socket.c.
- [Low] struct quic_crypto::tx_count[2] is documented as 'Packets
  encrypted (key phase 0 and 1)' and is compared with…
- [Low] Type mismatch between the HP transform fields and the API used to
  allocate and free them.

--

quic: add crypto key derivation and installation

This patch adds net/quic/crypto.c with HKDF-based derivation and
installation of QUIC packet protection keys for the Initial, Handshake,
0-RTT and 1-RTT levels. It also adds key updates and token / stateless
reset secret derivation. quic_init_sock() now allocates one struct
quic_crypto per level, and a new quic_sock_destruct() defers freeing
them to a workqueue.

> diff --git a/net/quic/crypto.c b/net/quic/crypto.c
> new file mode 100644
> index 0000000000000..c28c6fa565c1a
> --- /dev/null
> +++ b/net/quic/crypto.c
> @@ -0,0 +1,593 @@

[ ... ]

> +int quic_crypto_set_cipher(struct quic_crypto *crypto, u32 type)
> +{

[ ... ]

> +	crypto->rx_tfm[1] = tfm;
> +	tfm = crypto_alloc_sync_skcipher(cipher->skc, 0, 0);
> +	if (IS_ERR(tfm)) {
> +		err = PTR_ERR(tfm);
> +		goto err;
> +	}
> +	crypto->rx_hp_tfm = tfm;

[Severity: Low]

This isn't a bug, but crypto_alloc_sync_skcipher() returns a struct
crypto_sync_skcipher pointer. In struct quic_crypto, rx_hp_tfm and
tx_hp_tfm are declared as struct crypto_skcipher pointers. Because the
value goes through void *tfm, the compiler does not see the mismatch.

quic_crypto_free() then releases them with crypto_free_skcipher() instead
of the matching crypto_free_sync_skcipher():

	if (crypto->rx_hp_tfm)
		crypto_free_skcipher(crypto->rx_hp_tfm);

This only works because base is the first member of struct
crypto_sync_skcipher.

Could these fields be declared as struct crypto_sync_skcipher pointers
and freed with crypto_free_sync_skcipher()? That would also let
SYNC_SKCIPHER_REQUEST_ON_STACK() and skcipher_request_set_sync_tfm() be
used without casts.

[ ... ]

> +/* Save token secret in Initial TX secret (phase 1) for token generation. */
> +int quic_crypto_set_token_secret(struct quic_crypto *crypto)
> +{
> +	/* Reuse TX AEAD (phase 1) in Initial crypto. */
> +	u8 key[TLS_CIPHER_AES_GCM_128_KEY_SIZE], *srt = crypto->tx_secret[1];
> +	struct crypto_aead *tfm = crypto->tx_tfm[1];
> +	struct quic_data s = {}, k, i;
> +	int err;
> +
> +	if (!memchr_inv(srt, 0, TLS_CIPHER_AES_GCM_128_SECRET_SIZE))
> +		get_random_bytes(srt, TLS_CIPHER_AES_GCM_128_SECRET_SIZE);
> +
> +	quic_data(&s, srt, TLS_CIPHER_AES_GCM_128_SECRET_SIZE);
> +	quic_data(&k, key, TLS_CIPHER_AES_GCM_128_KEY_SIZE);
> +	quic_data(&i, crypto->tx_iv[1], QUIC_IV_LEN);
> +	err = quic_crypto_keys_derive(crypto->secret_tfm, &s, &k, &i, NULL,
> +				      QUIC_VERSION_V1);
> +	if (err)
> +		goto out;
> +	err = crypto_aead_setauthsize(tfm, QUIC_TAG_LEN);
> +	if (err)
> +		goto out;
> +	err = crypto_aead_setkey(tfm, key, TLS_CIPHER_AES_GCM_128_KEY_SIZE);
> +	if (err)
> +		goto out;
> +	get_random_bytes(&crypto->tx_count[1], sizeof(crypto->tx_count[1]));

[Severity: Medium]

If tx_secret[1] is already set, for example inherited from the listening
socket, this keeps that secret. It then re-derives the token AEAD key and
tx_iv[1] with the fixed QUIC_VERSION_V1 labels. So every socket that
shares the listener's token secret gets the same AES-GCM key and the same
base IV.

The only per-socket difference is the random starting value of
tx_count[1]. In the later patch "quic: add crypto packet encryption and
decryption", quic_crypto_generate_token() does:

	counter = crypto->tx_count[1]++;

and quic_crypto_token_protect() builds the nonce as tx_iv[1] XOR counter.

Won't two sockets reuse a (key, nonce) pair whenever their counter
windows overlap? With S sockets each issuing n tokens, the chance is
roughly S^2 * n / 2^64.

The listener's own Retry token counter also starts at a random point in
the same space. Nothing rotates the key. The counter is also sent in
clear in the token AAD, so an observer can see collisions directly.

A single GCM nonce reuse reveals the XOR of the two plaintexts and lets
an attacker recover the GHASH key. With that key, Retry and NEW_TOKEN
tokens can be forged, which defeats address validation on the listener.

The code that copies tx_secret[1] into accepted sockets is not in this
series. This concern is based on the memchr_inv() reuse branch above and
on the v19 changelog, which says the randomization was added "to prevent
AES-GCM nonce reuse across sockets accepted from the same listening
socket".

Does the randomization prevent reuse, or does it only make reuse
unlikely within a 64-bit space? Keeping collisions under the usual 2^-32
bound for GCM allows only about 2^16 sockets.

Would a deterministic scheme fit better? Options include a per-socket key
derived from a unique salt, one shared counter on the listener, or key
rotation.

[ ... ]

> diff --git a/net/quic/crypto.h b/net/quic/crypto.h
> new file mode 100644
> index 0000000000000..29eaf0cbd2e17
> --- /dev/null
> +++ b/net/quic/crypto.h
> @@ -0,0 +1,90 @@

[ ... ]

> +	u64 txlimit; /* Max packets encrypted per key */
> +	u64 rxlimit; /* Max decryption failures per crypto level */
> +};
> +
> +struct quic_crypto {

[ ... ]

> +	atomic_t async_pending[2]; /* Async pending count (key phase 0 and 1) */
> +	u64 tx_count[2];           /* Packets encrypted (key phase 0 and 1) */

[Severity: Low]

tx_count[] is documented as a per-phase count of encrypted packets,
compared against txlimit. quic_crypto_keys_derive_and_install() treats it
that way and resets it on rekey:

	crypto->tx_count[phase] = 0;

quic_crypto_set_token_secret() uses tx_count[1] of the Initial crypto in
a different way, as a random AES-GCM token nonce counter. The comments on
tx_secret[1], tx_iv[1] and tx_tfm[1] say "key phase 0 and 1". They do not
say that phase 1 of the Initial crypto holds the token secret and the
token AEAD.

Nothing fails at the end of the series, because Initial packets always
use key phase 0. A later change that rekeys or limit-checks phase 1 of
the Initial crypto could silently break token nonce generation, or hit a
spurious -EKEYEXPIRED.

Could the comments document this dual use, or could the token state move
to dedicated fields?

> +
> +	/* Timestamp 1st packet sent after key update */
> +	u64 key_update_send_time;
> +	u64 key_update_time; /* Duration to retain old keys after key update */
> +	u64 rx_fails;        /* Failures decrypted */

[Severity: Medium]

Is this counter meant to be connection-wide? quic_init_sock() allocates
a separate struct quic_crypto for each of the QUIC_CRYPTO_MAX levels, so
each level has its own rx_fails. struct quic_cipher above also documents
rxlimit as "Max decryption failures per crypto level".

In the later patch, quic_crypto_decrypt() checks the per-level counter:

	if (err == -EBADMSG && ++crypto->rx_fails >= crypto->cipher->rxlimit)

RFC 9001 Section 6.6 says:

  If the total number of received packets that fail authentication
  within the connection, across all keys, exceeds the integrity limit
  for the selected AEAD, the endpoint MUST immediately close the
  connection

Handshake, 0-RTT and 1-RTT all use the negotiated AEAD. An attacker
sending forged packets could therefore get up to about rxlimit failures
at each level before any counter trips. This matters most for AES-CCM,
where the limit is 2^21.5.

The v17 changelog says rx_fails was made "a connection-wide counter ...
as required by RFC9001 Section 6". Was that undone by the v18 per-level
allocation and the v19 "per crypto level" comment?

[ ... ]

> diff --git a/net/quic/socket.c b/net/quic/socket.c
> index 78a08dd998a8e..d717efca9b9e6 100644
> --- a/net/quic/socket.c
> +++ b/net/quic/socket.c
> @@ -40,11 +40,38 @@ static void quic_write_space(struct sock *sk)

[ ... ]

> +static void quic_sock_destruct(struct sock *sk)
> +{
> +	struct quic_crypto *crypto;
> +	u8 i;
> +
> +	/* Deferred crypto free for async encryption/decryption. */
> +	for (i = 0; i < QUIC_CRYPTO_MAX; i++) {
> +		crypto = quic_crypto(sk, i);
> +		if (!crypto)
> +			continue;
> +		queue_work(quic_wq, &crypto->work);
> +	}
> +
> +	quic_sk_destruct(sk);
> +}
> +
>  static int quic_init_sock(struct sock *sk)
>  {
>  	struct quic_pnspace *space;
> +	struct quic_crypto *crypto;
>  	u8 i;
>  
> +	sk->sk_destruct = quic_sock_destruct;

[Severity: Low]

This isn't a bug, but the commit message body only describes the
crypto.c helpers. It doesn't mention three changes in socket.c:

- quic_init_sock() now sets sk->sk_destruct to quic_sock_destruct().

- quic_init_sock() allocates one struct quic_crypto per encryption
  level, which adds new -ENOMEM failure points to socket creation.

- Crypto teardown is deferred to quic_wq through quic_crypto_free_work(),
  and runs after the socket is gone.

The async crypto lifetime argument depends on these points. Right now
they only appear in the v12 and v18 notes below the "---" line, which
won't end up in git history.

The body also doesn't say that several new fields and helpers are not
read or called anywhere in this patch, and are placeholders for later
patches. These include rx_fails, async_pending, key_update_send_time,
key_update_time, ticket_ready, send_offset, recv_offset, txlimit,
rxlimit, the QUIC_TOKEN_* defines and quic_crypto_discard().

Could the commit message cover these?

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.1795393690.git.lucien.xin%40gmail.com
