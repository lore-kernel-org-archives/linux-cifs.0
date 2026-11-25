Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.176
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795622404;
	b=B9SyWSxUC9ySNNpgtePbc38jtMDMYSqf5+fFyhPUvSOWYQ7OMXJuL8Lz1TBxI6yXSMwq
	 C0yFlW1soT7+C0HBpLCsBcNeQdgWge9o1l6S+PSEEQ9uIKtV5H0QtBPGEqAfU+uJmWDT8
	 tEXiwja8mwA6NsOQzxJUT67XgbeXulQvumpQ2YREiAmEO6UsRVwxa2Yf9vmg+10ndHLR7
	 tGsRfe7O6KzZPGE7spQigflRd6mtvQQw3uOUGuMEypvkKmSEy04AyxqNOppuviWxcJfLA
	 UAZxvJAFwdkSgEWk1ld8+1qbqRm5epVvIZbghY5UOwOPZ5nubMeqq7hKAyPrr3fVxCQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622404;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=SzwTl3wJ5EGvPDR1ifZFuAECe6VYxaw0oJcYKT7Gpec=;
	b=DXYyqgiri1lg+dNwNkSFBby9/t575egTcJPV/lwyqki5NJ9zCW2qE+gOeplXNPYukTr1
	 inLNHp2eyuMqCrz1E7g58xhlH1xmaJWwSbyrYMnNE7yjCHbuleE5TffejHwJ0La2JlRvP
	 wKxwMwDYl4lELlF2UfFlGH0L73DAOyvx96g6ZrbANPSwuaJCsDWSwzzOBNPzVPEHDyP7N
	 SDtNasTcrlzxML5+NI4SNYcMAmfR7SiHy8joJLBjbvdC2CMTnA7Nc4C+XlJ+/iE+EJC6H
	 fnZYZK4XdqrX1KC27uJ8zWSmDKeBTX0PVxYJe56r1sQ9Mi9/nZo8zKw4gkEtjxMLQAg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="Wqj/+kU8";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.176
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCF1606A330
	for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 16:00:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5CCF1606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Wqj/+kU8
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8c5ebbc5150so4132408b3a.3
        for <linux-cifs@vger.kernel.org>; Wed, 25 Nov 2026 08:00:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795622404; cv=none;
        d=google.com; s=arc-20260327;
        b=ed+2N3HTqIeIQLO5XcBdYaLO8gY0P5rgGBAoQ1W0QK2qfojoLYjRRb2iZ1NaCE57AS
         GMAPYuXOheBkQ+Agscf+EGLFIaCNFBKnYgg6FzY7tzDiHxF98AVNacr27Hc+DRRRjldl
         qjFJzgZ5gu/F/LilxVKT+A9ee5lj2/pwKqjxsXSbbaWBDGu4rmnyyHS8rrpGkkVdnI1e
         AmrvnPeYwAsIPjNPfkHap6U8QRI88OZPrAImH8PTNBLPrCP5qzeHEab/KBgl93BoNwDh
         jwPB34VfpLlsyjtvKt8i+twuIFLr1q0Kc7njaCdkC7je7C2VGxg4ujV6xxPzprI1m5ub
         06/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SzwTl3wJ5EGvPDR1ifZFuAECe6VYxaw0oJcYKT7Gpec=;
        fh=CMoS3fB4YETOu7EGV4fVabj8Fwo9HcIfG7RG2oAToUA=;
        b=oc1xzyJFOD1+m1W2LyRrstVF0794xngj1S8ecTJKRiQUbP3qseovS6gG+KdHic4HGw
         AUfBixuLjJrKdr2DS9slzEGY1LBfJ7XS4qQJJIOpZhlqMZL/C3rst9l/Vy7WKXw3ATJR
         upKuya9EIR3piefffTmifnn/QNJBVKqgi0unLB4PO2VZiyhIX21XLXsidOo3zlejIeJ0
         rF61bPOsw0VCdMwmxo0SuZsNB/UZk1zwmLUgQrmEkno32ldNk/xuyOWupAqUBBYNLi6T
         BoXYVif/hpTtLwns0A1AMXKpzVaCACq4ehQzN5uu8oG8dNZyBFfYaHcTNyGGq9DvWUuy
         wOvg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795622404; x=1796227204; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SzwTl3wJ5EGvPDR1ifZFuAECe6VYxaw0oJcYKT7Gpec=;
        b=Wqj/+kU8dfTEMWZuxxYVNFKl34CP0jUErxvi3DHLJAwMVPgvsZuuJXlpRVCQCQquv0
         cXAqq346gq6HyXw6DlxZdVcyny8DsMIJYIISnoXQoqZrEPIegUwTzjnsziilwmyBBEbo
         AsKiGZ6ag9CqOFM3OVtbPlaTTorh6sST3h16iZwZBkM82t/yfsMa+3CLPWZuM+ASyhre
         vc6Ul+LgQKExfFbou50Q2HUxTuS3b3/QJR0sNsZaAzVmnO6SY1RtmjF/eoWg+F1fQnfz
         Tn0hx5s3gtupmF/D5MXAU8Jl4cuyAOKaM68LnMX0jt0QoQb5uxkv165N3gFQi1bRDEnO
         FHwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795622404; x=1796227204;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SzwTl3wJ5EGvPDR1ifZFuAECe6VYxaw0oJcYKT7Gpec=;
        b=xhD2FLnCpbTutO6fIcfJF4QMTIvrwJrpy9N79eniZBceiPfIgEe6Mp0TNBY+NfBEpr
         N3iDmANiLI+qsaXaBJk1MBg8isSTcziQxUPwRfZArIz8IObkPPy1aqgNIV7EtNXAXWfJ
         2OAkkE7XG2NvIs7CKi2Bkt68YaRe+u9y7HPW1UnaksrtVw7lABGqXMacrW8746naCh2v
         PqsISVfYy/SzoefpxpV5vKewZQ/WhQRk5XhZMMOoMxETdgtuGKuUM8CSVs8UF3b8AcBS
         WjFNUD3QORJRwv7hyVOBqtA01I6cFEeNh1EY3or81DmhW+pZm8M2gqkAcQmWggRV6R2W
         z2+Q==
X-Forwarded-Encrypted: i=1; AL+hErGH3YhBjgaGKSCJi1AmxHwobs9TTXd+CFe8J6bhTQdAbvCqvBqTTUeoJsgsWGVSHjLirk45pXc56EKj@vger.kernel.org
X-Gm-Message-State: APuU4Z94GhvE2Z2Zu0GHE2/Bj0MknxE0FfPZCTNrNxQqglqK6GnGI8rB
	s2OrT3tsvU5PVAHlWVvS/FgnalhEqysDyu/II1UNKAqR+dE+VS8soAOArkPNhBNKMKpq9uK2XZj
	DjWcW13m/9jizf3yYYTV6et9u0mziw5A=
X-Gm-Gg: AZFdTZehV0hhlL/p1yFzHUL3TDpgZW0uYZhpa+vRk+Z6AQCOx+r6Qx+/7pmLhhSmXfY
	wEtq+6cxIJymI1kEaZ0+/ES4GjxQ3RaYl/BC8t2lk0t4neZcJDKmnHoPFU31J7vKEpBLxCiqv6m
	/1cQN6/jtPAOa7E5v30LSPMNBmcCw6zD5ua3EZhwZS6eqHM7Md9yq2ySQkgTli8VRj1gdDJx0Rz
	mCmNO22Dk7P34CHI63iQIi6EQIsvD8F5lo/hhSoADG56X5GpNZLEryjS2wIyxr5M7YXy3haMSsP
	m+NIDvxd0EI8d5QssFlRC5Diwvd8w0UaIYwlSxAmvNo4+b84M5Zx+8gwDiRVWgiKx8vuQ66HgDa
	6I8wCtgh+ebvKI2vrt7f4TPQQ28miboSOf5YbpwTLGZJql84+fYU/XgvPjZzO2MoQf7K1oZKou5
	UBD282Pxb11eZwIYCJ+/YHhq8+5Pn5WD5a6GWIVRV4t0Ui5OYXA7G+172ydbtN0pNd7AtK
X-Received: by 2002:aa7:88cf:0:b0:8b6:594d:7030 with SMTP id
 d2e1a72fcca58-8c87ca51fe7mr16624530b3a.42.1795622403510; Wed, 25 Nov 2026
 08:00:03 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <035db09843f506bea729e16d523b453c56647be8.1795393691.git.lucien.xin@gmail.com>
 <179548328150.3135.7027633658882912871@kernel.org>
In-Reply-To: <179548328150.3135.7027633658882912871@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 25 Nov 2026 10:59:51 -0500
X-Gm-Features: Aa3M54q3YNjzrJVhLtcHaagwpwzPqENqz5Odfa9zG0cW6ddLoL6_XWMexKurxXc
Message-ID: <CADvbK_cdNQi6YuDMpCQypyt7ij+=5gSuiPFMXOSxPm7aD+6RCg@mail.gmail.com>
Subject: Re: [PATCH net-next v19 11/15] quic: add crypto key derivation and installation
To: netdev-bot+sashiko@kernel.org
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 23, 2026 at 8:21=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found 5 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 2 =C2=B7 Low: 3
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [Medium] Shared token key: AES-GCM nonce uniqueness across sockets
>   depends only on a random 64-bit counter start.
> - [Medium] The AEAD integrity limit is enforced per encryption level, but
>   RFC 9001 Section 6.6 requires it per connection.
> - [Low] The commit message body does not mention the socket lifecycle
>   changes in net/quic/socket.c.
> - [Low] struct quic_crypto::tx_count[2] is documented as 'Packets
>   encrypted (key phase 0 and 1)' and is compared with=E2=80=A6
> - [Low] Type mismatch between the HP transform fields and the API used to
>   allocate and free them.
>
> --
>
> quic: add crypto key derivation and installation
>
> This patch adds net/quic/crypto.c with HKDF-based derivation and
> installation of QUIC packet protection keys for the Initial, Handshake,
> 0-RTT and 1-RTT levels. It also adds key updates and token / stateless
> reset secret derivation. quic_init_sock() now allocates one struct
> quic_crypto per level, and a new quic_sock_destruct() defers freeing
> them to a workqueue.
>
> > diff --git a/net/quic/crypto.c b/net/quic/crypto.c
> > new file mode 100644
> > index 0000000000000..c28c6fa565c1a
> > --- /dev/null
> > +++ b/net/quic/crypto.c
> > @@ -0,0 +1,593 @@
>
> [ ... ]
>
> > +int quic_crypto_set_cipher(struct quic_crypto *crypto, u32 type)
> > +{
>
> [ ... ]
>
> > +     crypto->rx_tfm[1] =3D tfm;
> > +     tfm =3D crypto_alloc_sync_skcipher(cipher->skc, 0, 0);
> > +     if (IS_ERR(tfm)) {
> > +             err =3D PTR_ERR(tfm);
> > +             goto err;
> > +     }
> > +     crypto->rx_hp_tfm =3D tfm;
>
> [Severity: Low]
>
> This isn't a bug, but crypto_alloc_sync_skcipher() returns a struct
> crypto_sync_skcipher pointer. In struct quic_crypto, rx_hp_tfm and
> tx_hp_tfm are declared as struct crypto_skcipher pointers. Because the
> value goes through void *tfm, the compiler does not see the mismatch.
>
> quic_crypto_free() then releases them with crypto_free_skcipher() instead
> of the matching crypto_free_sync_skcipher():
>
>         if (crypto->rx_hp_tfm)
>                 crypto_free_skcipher(crypto->rx_hp_tfm);
>
> This only works because base is the first member of struct
> crypto_sync_skcipher.
>
> Could these fields be declared as struct crypto_sync_skcipher pointers
> and freed with crypto_free_sync_skcipher()? That would also let
> SYNC_SKCIPHER_REQUEST_ON_STACK() and skcipher_request_set_sync_tfm() be
> used without casts.
>
> [ ... ]
>
> > +/* Save token secret in Initial TX secret (phase 1) for token generati=
on. */
> > +int quic_crypto_set_token_secret(struct quic_crypto *crypto)
> > +{
> > +     /* Reuse TX AEAD (phase 1) in Initial crypto. */
> > +     u8 key[TLS_CIPHER_AES_GCM_128_KEY_SIZE], *srt =3D crypto->tx_secr=
et[1];
> > +     struct crypto_aead *tfm =3D crypto->tx_tfm[1];
> > +     struct quic_data s =3D {}, k, i;
> > +     int err;
> > +
> > +     if (!memchr_inv(srt, 0, TLS_CIPHER_AES_GCM_128_SECRET_SIZE))
> > +             get_random_bytes(srt, TLS_CIPHER_AES_GCM_128_SECRET_SIZE)=
;
> > +
> > +     quic_data(&s, srt, TLS_CIPHER_AES_GCM_128_SECRET_SIZE);
> > +     quic_data(&k, key, TLS_CIPHER_AES_GCM_128_KEY_SIZE);
> > +     quic_data(&i, crypto->tx_iv[1], QUIC_IV_LEN);
> > +     err =3D quic_crypto_keys_derive(crypto->secret_tfm, &s, &k, &i, N=
ULL,
> > +                                   QUIC_VERSION_V1);
> > +     if (err)
> > +             goto out;
> > +     err =3D crypto_aead_setauthsize(tfm, QUIC_TAG_LEN);
> > +     if (err)
> > +             goto out;
> > +     err =3D crypto_aead_setkey(tfm, key, TLS_CIPHER_AES_GCM_128_KEY_S=
IZE);
> > +     if (err)
> > +             goto out;
> > +     get_random_bytes(&crypto->tx_count[1], sizeof(crypto->tx_count[1]=
));
>
> [Severity: Medium]
>
> If tx_secret[1] is already set, for example inherited from the listening
> socket, this keeps that secret. It then re-derives the token AEAD key and
> tx_iv[1] with the fixed QUIC_VERSION_V1 labels. So every socket that
> shares the listener's token secret gets the same AES-GCM key and the same
> base IV.
>
> The only per-socket difference is the random starting value of
> tx_count[1]. In the later patch "quic: add crypto packet encryption and
> decryption", quic_crypto_generate_token() does:
>
>         counter =3D crypto->tx_count[1]++;
>
> and quic_crypto_token_protect() builds the nonce as tx_iv[1] XOR counter.
>
> Won't two sockets reuse a (key, nonce) pair whenever their counter
> windows overlap? With S sockets each issuing n tokens, the chance is
> roughly S^2 * n / 2^64.
>
> The listener's own Retry token counter also starts at a random point in
> the same space. Nothing rotates the key. The counter is also sent in
> clear in the token AAD, so an observer can see collisions directly.
>
> A single GCM nonce reuse reveals the XOR of the two plaintexts and lets
> an attacker recover the GHASH key. With that key, Retry and NEW_TOKEN
> tokens can be forged, which defeats address validation on the listener.
>
> The code that copies tx_secret[1] into accepted sockets is not in this
> series. This concern is based on the memchr_inv() reuse branch above and
> on the v19 changelog, which says the randomization was added "to prevent
> AES-GCM nonce reuse across sockets accepted from the same listening
> socket".
>
> Does the randomization prevent reuse, or does it only make reuse
> unlikely within a 64-bit space? Keeping collisions under the usual 2^-32
> bound for GCM allows only about 2^16 sockets.
>
> Would a deterministic scheme fit better? Options include a per-socket key
> derived from a unique salt, one shared counter on the listener, or key
> rotation.
>
False.

The 64-bit random start gives ample collision resistance for realistic
token volumes. A per-socket key or shared counter adds complexity for a
narrow threat.

> [ ... ]
>
> > diff --git a/net/quic/crypto.h b/net/quic/crypto.h
> > new file mode 100644
> > index 0000000000000..29eaf0cbd2e17
> > --- /dev/null
> > +++ b/net/quic/crypto.h
> > @@ -0,0 +1,90 @@
>
> [ ... ]
>
> > +     u64 txlimit; /* Max packets encrypted per key */
> > +     u64 rxlimit; /* Max decryption failures per crypto level */
> > +};
> > +
> > +struct quic_crypto {
>
> [ ... ]
>
> > +     atomic_t async_pending[2]; /* Async pending count (key phase 0 an=
d 1) */
> > +     u64 tx_count[2];           /* Packets encrypted (key phase 0 and =
1) */
>
> [Severity: Low]
>
> tx_count[] is documented as a per-phase count of encrypted packets,
> compared against txlimit. quic_crypto_keys_derive_and_install() treats it
> that way and resets it on rekey:
>
>         crypto->tx_count[phase] =3D 0;
>
> quic_crypto_set_token_secret() uses tx_count[1] of the Initial crypto in
> a different way, as a random AES-GCM token nonce counter. The comments on
> tx_secret[1], tx_iv[1] and tx_tfm[1] say "key phase 0 and 1". They do not
> say that phase 1 of the Initial crypto holds the token secret and the
> token AEAD.
>
> Nothing fails at the end of the series, because Initial packets always
> use key phase 0. A later change that rekeys or limit-checks phase 1 of
> the Initial crypto could silently break token nonce generation, or hit a
> spurious -EKEYEXPIRED.
>
> Could the comments document this dual use, or could the token state move
> to dedicated fields?
>
> > +
> > +     /* Timestamp 1st packet sent after key update */
> > +     u64 key_update_send_time;
> > +     u64 key_update_time; /* Duration to retain old keys after key upd=
ate */
> > +     u64 rx_fails;        /* Failures decrypted */
>
> [Severity: Medium]
>
> Is this counter meant to be connection-wide? quic_init_sock() allocates
> a separate struct quic_crypto for each of the QUIC_CRYPTO_MAX levels, so
> each level has its own rx_fails. struct quic_cipher above also documents
> rxlimit as "Max decryption failures per crypto level".
>
> In the later patch, quic_crypto_decrypt() checks the per-level counter:
>
>         if (err =3D=3D -EBADMSG && ++crypto->rx_fails >=3D crypto->cipher=
->rxlimit)
>
> RFC 9001 Section 6.6 says:
>
>   If the total number of received packets that fail authentication
>   within the connection, across all keys, exceeds the integrity limit
>   for the selected AEAD, the endpoint MUST immediately close the
>   connection
>
> Handshake, 0-RTT and 1-RTT all use the negotiated AEAD. An attacker
> sending forged packets could therefore get up to about rxlimit failures
> at each level before any counter trips. This matters most for AES-CCM,
> where the limit is 2^21.5.
>
> The v17 changelog says rx_fails was made "a connection-wide counter ...
> as required by RFC9001 Section 6". Was that undone by the v18 per-level
> allocation and the v19 "per crypto level" comment?
>
False.

rx_fails is per level for implementation simplicity since the entire
quic_crypto struct is per level. The non-app levels are short-lived, so the
effective connection-wide budget is dominated by the 1-RTT counter. The
practical difference from a shared counter is negligible.

> [ ... ]
>
> > diff --git a/net/quic/socket.c b/net/quic/socket.c
> > index 78a08dd998a8e..d717efca9b9e6 100644
> > --- a/net/quic/socket.c
> > +++ b/net/quic/socket.c
> > @@ -40,11 +40,38 @@ static void quic_write_space(struct sock *sk)
>
> [ ... ]
>
> > +static void quic_sock_destruct(struct sock *sk)
> > +{
> > +     struct quic_crypto *crypto;
> > +     u8 i;
> > +
> > +     /* Deferred crypto free for async encryption/decryption. */
> > +     for (i =3D 0; i < QUIC_CRYPTO_MAX; i++) {
> > +             crypto =3D quic_crypto(sk, i);
> > +             if (!crypto)
> > +                     continue;
> > +             queue_work(quic_wq, &crypto->work);
> > +     }
> > +
> > +     quic_sk_destruct(sk);
> > +}
> > +
> >  static int quic_init_sock(struct sock *sk)
> >  {
> >       struct quic_pnspace *space;
> > +     struct quic_crypto *crypto;
> >       u8 i;
> >
> > +     sk->sk_destruct =3D quic_sock_destruct;
>
> [Severity: Low]
>
> This isn't a bug, but the commit message body only describes the
> crypto.c helpers. It doesn't mention three changes in socket.c:
>
> - quic_init_sock() now sets sk->sk_destruct to quic_sock_destruct().
>
> - quic_init_sock() allocates one struct quic_crypto per encryption
>   level, which adds new -ENOMEM failure points to socket creation.
>
> - Crypto teardown is deferred to quic_wq through quic_crypto_free_work(),
>   and runs after the socket is gone.
>
> The async crypto lifetime argument depends on these points. Right now
> they only appear in the v12 and v18 notes below the "---" line, which
> won't end up in git history.
>
> The body also doesn't say that several new fields and helpers are not
> read or called anywhere in this patch, and are placeholders for later
> patches. These include rx_fails, async_pending, key_update_send_time,
> key_update_time, ticket_ready, send_offset, recv_offset, txlimit,
> rxlimit, the QUIC_TOKEN_* defines and quic_crypto_discard().
>
> Could the commit message cover these?
>
> [ ... ]
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/cover.1795393690.git.lucien.xin%40gmail.com
