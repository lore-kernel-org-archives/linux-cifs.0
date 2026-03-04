Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5E5350A1B
	for <linux-cifs@vger.kernel.org>; Wed,  4 Mar 2026 21:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772661498; cv=pass; b=BSv7txrLZkTIAMEBgNtelu8ynbeHpJlY+QgWQRO+fcbR0soAbB2RvHCfLPRzkxTt/XDKgapzpiSthzCJaQxkK8XUe+pHMTL2Z0W/6cPH27qxulo/67ZesndNiBZYrNLT74H7A2bIWb0zI8BmQEYPNQznCqZ724dUkaP9+FOZOSo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772661498; c=relaxed/simple;
	bh=uCVtAulQYUleILEJ6PEjL9aQkaLSkuY4rEkEB5Iccc4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K7vR2B+CRkTlt1N/wUHgmOhn4ogucIqBB+bwQF5HLKPhV36Nbs8v97Njh6ygIEfpILPTCZ3HpTEj7iyTsmJ2VcYBhHxLFqCGvqSQ5nPranekKIOUPcNbHWRq9epkvjARGIgdVCgIK1BdCIAyyYgSGKmVQujXwvA99YOz+rCEI3U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bknOqe/Q; arc=pass smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bknOqe/Q"
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-94aca174532so2099790241.3
        for <linux-cifs@vger.kernel.org>; Wed, 04 Mar 2026 13:58:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772661495; cv=none;
        d=google.com; s=arc-20240605;
        b=dnPNw2X+6yjkMKCqTpPhje9CLLJbVcwELrwCMTqgFg/ReCvrKAVnj6liT4+BQQWsMC
         WbXJfpD07iUHg2oqr5dYhsl8/Zi/7e72f/51Ai2H0QJSmJKnAjlqfTIRNlio7/PcsJzv
         l/JGifM5SSWAM3OaYMjaidN3+Rtw+KiiFxP4IACcbQZ7LM/z7kYtWDsmQ4+NVlNK25wS
         rxmD9RV2z4DR0/9ygcP+jsBjT78+BPJlvYfvCmQ6tRt5qU9SrK7kOwRhnj5jKPgdx/sT
         TxhhqKr6RMrTEnnovMHx8RkYlfSRU3x6efdNdBgzWX99XD21ti6j/Ta/oqyq1sRsSgFZ
         T9mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QKWCkXz0n+kEHmLabX5g1II5xKBH3YQOX4ZTihzPz58=;
        fh=caRVn5Idv7ZHroxZp7nU8k09IQm5kU42GTCdt/IesHY=;
        b=NP8JphAjkMParAH59CiP7HZnhQ1bakptHUM1YO4VLI9/Mgy2SSQc6At4t+M9Ny31BW
         lHWDpeekQur77atlBsLF5yQ0xqxxbGFB8UrTTZcmlRz0AYFiP8RolOeddGg4p1XMKsBF
         OjKiriVXJgha++LMYTCXGgtzVOJkR8bh4LVapNLo2g7PC2GsI3IZBtvcuWqWskyjTR+z
         Ne6SSJs9UZpU9t2JPn7fIBcZyTIzVPulNUXPvTsrw1conDh6noH9vg6GUnbWYqbej1+2
         ReywZ2qnn4yXj3FDiIYnugqjAd4ykqOuXoDD1nLszAw6/iWcp3DNMyLAmIJ3vpJH9/Q/
         uTeg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772661495; x=1773266295; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QKWCkXz0n+kEHmLabX5g1II5xKBH3YQOX4ZTihzPz58=;
        b=bknOqe/Q3ViNm968LpcDQ54rkED/FEk09l6mAA2bY3oD6fVK4iZdJ5rrCO/SHG8Nrj
         ekleXZFZt8rQD4oI0eODaTQjzdy3BWd8DjRGFuOQLp91eciTENXOmLpew6eYHNWMeLb2
         P6H8U3gEl63u95Bv7u5AL5AvAG8NeqcthHFEfg/TFEjtGxG905POupCzTXJXMp+BxEgf
         GoNSulZgl5glNxT3I7aM6GMn5eryVATt+ZQRZL6PQGBrln7aGs1zRLBktrBEEEpVeOpQ
         MsUYGX0ZNfdrNPe8b/9yE50moXHCtEdSB03Xnmy6k+RW+GNpoPQK7zlQh8IyA/Hr/YLc
         oCIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772661495; x=1773266295;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QKWCkXz0n+kEHmLabX5g1II5xKBH3YQOX4ZTihzPz58=;
        b=kirubJTb3K93I0Pt9e4VIscI9jce8gmcErwasD/l6wbLrM+HaHeQ5uM4FD4POtTc/p
         vjDRdivBNo4NXX6OwzFtP3Ojp9zZRIw/vxw7k4ycDTOzerH9FQH1y69VuuzcmWf2pmvm
         YNewL7BTXZvU3kR940dvcsV8zUfQdCV6lmWoyOn+/xh08MRXHumYmTK1rqUGE7xzVsNR
         q3wIx2ByuJ3mhtI8G4Ib05G5sRokCsfzaw8668xGSnCVRIKtd5U7XyHMQmVtvXTGAzgK
         Y5MBfuZBSedtcsoxnKm2zXzmfzFP1OQGmVbI2zpfpCHKrTIb3omsw6NC7dKZDYzS4+0A
         57yg==
X-Forwarded-Encrypted: i=1; AJvYcCXbnxD2QK87BKKF3NMgbsfhN5y5zufOUfzulyflKhDHelwMdBZo8LOembZUekHXZaWSBRvYsxJtiENf@vger.kernel.org
X-Gm-Message-State: AOJu0YyTTIZPClFhWJKbhG1MFpfni5Mst735WBQw50rroTBPkkrlxsE2
	JkvcyrUEhSKp/7JIG1i1O0nBnJZ3X55IJ8+rX0GAWbR5z8RjJjwvgfcjoVGUzkU+n4TrzOOrZ3b
	5z7g8WEvfEH748bIPwSbfQqUtoAEiOZE=
X-Gm-Gg: ATEYQzyBbFyybXTg+PDSJmDKxCPamkNAmyIl930Qo+LRWTdKvwPBaJMlJt2QbYvUBZK
	pPqpw4+BgwoFd5RSlgu/9MsXU3UI71RAQNMVdpVcyyNlcg8/D/WSobiA7oqbaWNC4KqGshrXjrM
	EtJ+Lv6/Jacv8l6R7MWCIW0YHUdj8n1YG92Sx1N5RsMHuFcDgHJBqY6TG4mSV5yp3Yn0tD99fWk
	sux7BiYt3MBeaTdIQu6YrLS6WYgoYR1omujNpImftHYDpC/sDXQ+wYqq3El3KLdb6z3cAYMEvH3
	XYHIotOY2oyXlUc3uPTVAZsywnZQJjcAeBdKwj6HP773zLvMJW6VtGw5R1V1yOewftX9sTAbe5P
	Cv3NExPUshGJE+c0ZZBZKpCAjI+s0NtZtGmj4DxMH
X-Received: by 2002:a05:6102:3f43:b0:5fd:fc84:4b0 with SMTP id
 ada2fe7eead31-5ffaaffd485mr1677319137.35.1772661495041; Wed, 04 Mar 2026
 13:58:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <323138c6deed2652a09aa38dfbe322642b6ad150.1771986861.git.lucien.xin@gmail.com>
 <20260303083233.34650-1-pabeni@redhat.com>
In-Reply-To: <20260303083233.34650-1-pabeni@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 4 Mar 2026 16:58:01 -0500
X-Gm-Features: AaiRm50J6ffZdZLFUmhSXQoVur0S3uDqiz0HfuAqGi8QNmmBNRW9dW8AvLSff9M
Message-ID: <CADvbK_cWP-S1VdsfZJCc_iTxaeVnGTbrXrNsVdWTgYjdqLjwaA@mail.gmail.com>
Subject: Re: [net-next,v10,11/15] quic: add crypto key derivation and installation
To: Paolo Abeni <pabeni@redhat.com>
Cc: hepengtao@xiaomi.com, kuba@kernel.org, jlayton@kernel.org, metze@samba.org, 
	davem@davemloft.net, kernel-tls-handshake@lists.linux.dev, horms@kernel.org, 
	hare@suse.de, aahringo@redhat.com, tfanelli@redhat.com, mail@johnericson.me, 
	andrew.gospodarek@broadcom.com, linkinjeon@kernel.org, dhowells@redhat.com, 
	matttbe@kernel.org, xiyou.wangcong@gmail.com, dreibh@simula.no, 
	jbaron@akamai.com, quic@lists.linux.dev, pc@manguebit.com, 
	marc@fiuczynski.com, edumazet@google.com, alibuda@linux.alibaba.com, 
	steved@redhat.com, illiliti@protonmail.com, tom@talpey.com, 
	marcelo.leitner@gmail.com, sd@queasysnail.net, linux-cifs@vger.kernel.org, 
	netdev@vger.kernel.org, mbuhl@openbsd.org, smfrench@gmail.com, 
	chuck.lever@oracle.com, daniel@haxx.se
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 3, 2026 at 3:33=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wrot=
e:
>
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
>
> For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-loca=
l.html
> ---
> quic: add crypto key derivation and installation
>
> This patch introduces 'quic_crypto', a component responsible for QUIC
> encryption key derivation and installation across the various key
> levels: Initial, Handshake, 0-RTT (Early), and 1-RTT (Application).
> It provides helpers to derive and install initial secrets, set traffic
> secrets and install the corresponding keys, and perform key updates to
> enable forward secrecy.
>
> > diff --git a/net/quic/Makefile b/net/quic/Makefile
> > index 9d8e18297911..58bb18f7926d 100644
> > --- a/net/quic/Makefile
> > +++ b/net/quic/Makefile
> > @@ -6,4 +6,4 @@
> >  obj-$(CONFIG_IP_QUIC) +=3D quic.o
> >
> >  quic-y :=3D common.o family.o protocol.o socket.o stream.o connid.o pa=
th.o \
> > -       cong.o pnspace.o
> > +       cong.o pnspace.o crypto.o
> > diff --git a/net/quic/crypto.c b/net/quic/crypto.c
> > new file mode 100644
> > index 000000000000..a9de418e604e
> > --- /dev/null
> > +++ b/net/quic/crypto.c
>
> [ ... ]
>
> > +/* Initial Secrets. */
> > +int quic_crypto_initial_keys_install(struct quic_crypto *crypto, struc=
t quic_conn_id *conn_id,
> > +                                  u32 version, bool is_serv)
> > +{
> > +     u8 secret[TLS_CIPHER_AES_GCM_128_SECRET_SIZE];
> > +     struct quic_data salt, s, k, l, dcid, z =3D {};
> > +     struct quic_crypto_secret srt =3D {};
> > +     char *tl, *rl, *sal;
> > +     int err;
> > +
> > +     if (is_serv) {
> > +             rl =3D "client in";
> > +             tl =3D "server in";
> > +     } else {
> > +             tl =3D "client in";
> > +             rl =3D "server in";
> > +     }
> > +     sal =3D QUIC_INITIAL_SALT_V1;
> > +     if (version =3D=3D QUIC_VERSION_V2)
> > +             sal =3D QUIC_INITIAL_SALT_V2;
> > +     quic_data(&salt, sal, QUIC_INITIAL_SALT_LEN);
> > +     quic_data(&dcid, conn_id->data, conn_id->len);
> > +     quic_data(&s, secret, TLS_CIPHER_AES_GCM_128_SECRET_SIZE);
> > +     err =3D quic_crypto_hkdf_extract(crypto->secret_tfm, &salt, &dcid=
, &s);
>
> Is crypto->secret_tfm guaranteed to be initialized at this point?
>
> Looking at the function flow, this line uses crypto->secret_tfm before
> quic_crypto_set_secret() below gets a chance to initialize the cipher:
>
> quic_crypto_initial_keys_install() {
>         err =3D quic_crypto_hkdf_extract(crypto->secret_tfm, ...); /* lin=
e 490 */
>         ...
>         err =3D quic_crypto_set_secret(crypto, &srt, version, 0);  /* lin=
e 497 */
> }
>
> If quic_crypto_set_cipher() hasn't been called on this struct quic_crypto
> yet, crypto->secret_tfm is NULL.
>
> This contrasts with quic_crypto_set_secret(), which has lazy initializati=
on:
>
> quic_crypto_set_secret() {
>         if (!crypto->cipher) {
>                 err =3D quic_crypto_set_cipher(crypto, srt->type, flag);
>                 if (err)
>                         return err;
>         }
>         ...
> }
>
> Without this initialization, quic_crypto_hkdf_extract() flows through
> hkdf_extract() -> crypto_shash_setkey(NULL, ...), causing a NULL pointer
> dereference.
>
> Would it make sense to call quic_crypto_set_cipher() before using
> secret_tfm, or to reorder the function so quic_crypto_set_secret() is
> called first?
>
secret_tfm will always set in quic_connect(), quic_accept() and
quic_inet_listen(),
quic_crypto_initial_keys_install() will be only called after one of
these 3 functions
is called.

The patchset-2 (the following series) will give you this completeness.

> > +     if (err)
> > +             goto out;
> > +
> > +     quic_data(&l, tl, strlen(tl));
> > +     quic_data(&k, srt.secret, TLS_CIPHER_AES_GCM_128_SECRET_SIZE);
> > +     srt.type =3D TLS_CIPHER_AES_GCM_128;
> > +     srt.send =3D 1;
> > +     err =3D quic_crypto_hkdf_expand(crypto->secret_tfm, &s, &l, &z, &=
k);
> > +     if (err)
> > +             goto out;
> > +     err =3D quic_crypto_set_secret(crypto, &srt, version, 0);
> > +     if (err)
> > +             goto out;
> > +
> > +     quic_data(&l, rl, strlen(rl));
> > +     quic_data(&k, srt.secret, TLS_CIPHER_AES_GCM_128_SECRET_SIZE);
> > +     srt.type =3D TLS_CIPHER_AES_GCM_128;
> > +     srt.send =3D 0;
> > +     err =3D quic_crypto_hkdf_expand(crypto->secret_tfm, &s, &l, &z, &=
k);
> > +     if (err)
> > +             goto out;
> > +     err =3D quic_crypto_set_secret(crypto, &srt, version, 0);
> > +out:
> > +     memzero_explicit(secret, sizeof(secret));
> > +     memzero_explicit(&srt, sizeof(srt));
> > +     return err;
> > +}
>
> [ ... ]
>
> > +/* Derive and install transmission (TX) packet protection keys for the=
 current key phase.
> > + * This involves generating AEAD encryption key, IV, and optionally he=
ader protection key.
> > + */
> > +static int quic_crypto_tx_keys_derive_and_install(struct quic_crypto *=
crypto)
> > +{
> > +     struct quic_data srt =3D {}, k, iv, hp_k =3D {}, *hp =3D NULL;
> > +     u8 tx_key[QUIC_KEY_LEN], tx_hp_key[QUIC_KEY_LEN] =3D {};
> > +     int err, phase =3D crypto->key_phase;
> > +     u32 keylen, ivlen =3D QUIC_IV_LEN;
> > +
> > +     keylen =3D crypto->cipher->keylen;
> > +     quic_data(&srt, crypto->tx_secret, crypto->cipher->secretlen);
> > +     quic_data(&k, tx_key, keylen);
> > +     quic_data(&iv, crypto->tx_iv[phase], ivlen);
> > +     /* Only derive header protection key when not in key update. */
> > +     if (!crypto->key_pending)
> > +             hp =3D quic_data(&hp_k, tx_hp_key, keylen);
> > +     err =3D quic_crypto_keys_derive(crypto->secret_tfm, &srt, &k, &iv=
, hp, crypto->version);
> > +     if (err)
> > +             goto out;
> > +     err =3D crypto_aead_setauthsize(crypto->tx_tfm[phase], QUIC_TAG_L=
EN);
> > +     if (err)
> > +             goto out;
> > +     err =3D crypto_aead_setkey(crypto->tx_tfm[phase], tx_key, keylen)=
;
> > +     if (err)
> > +             goto out;
> > +     if (hp) {
> > +             err =3D crypto_skcipher_setkey(crypto->tx_hp_tfm, tx_hp_k=
ey, keylen);
> > +             if (err)
> > +                     goto out;
> > +     }
> > +     pr_debug("%s: k: %16phN, iv: %12phN, hp_k:%16phN\n", __func__, k.=
data, iv.data, tx_hp_key);
> > +out:
> > +     memzero_explicit(tx_key, sizeof(tx_key));
> > +     memzero_explicit(tx_hp_key, sizeof(tx_hp_key));
> > +     return err;
> > +}
> > +
> > +/* Derive and install reception (RX) packet protection keys for the cu=
rrent key phase.
> > + * This installs AEAD decryption key, IV, and optionally header protec=
tion key.
> > + */
> > +static int quic_crypto_rx_keys_derive_and_install(struct quic_crypto *=
crypto)
> > +{
> > +     struct quic_data srt =3D {}, k, iv, hp_k =3D {}, *hp =3D NULL;
> > +     u8 rx_key[QUIC_KEY_LEN], rx_hp_key[QUIC_KEY_LEN] =3D {};
> > +     int err, phase =3D crypto->key_phase;
> > +     u32 keylen, ivlen =3D QUIC_IV_LEN;
> > +
> > +     keylen =3D crypto->cipher->keylen;
> > +     quic_data(&srt, crypto->rx_secret, crypto->cipher->secretlen);
> > +     quic_data(&k, rx_key, keylen);
> > +     quic_data(&iv, crypto->rx_iv[phase], ivlen);
> > +     /* Only derive header protection key when not in key update. */
> > +     if (!crypto->key_pending)
> > +             hp =3D quic_data(&hp_k, rx_hp_key, keylen);
> > +     err =3D quic_crypto_keys_derive(crypto->secret_tfm, &srt, &k, &iv=
, hp, crypto->version);
> > +     if (err)
> > +             goto out;
> > +     err =3D crypto_aead_setauthsize(crypto->rx_tfm[phase], QUIC_TAG_L=
EN);
> > +     if (err)
> > +             goto out;
> > +     err =3D crypto_aead_setkey(crypto->rx_tfm[phase], rx_key, keylen)=
;
> > +     if (err)
> > +             goto out;
> > +     if (hp) {
> > +             err =3D crypto_skcipher_setkey(crypto->rx_hp_tfm, rx_hp_k=
ey, keylen);
> > +             if (err)
> > +                     goto out;
> > +     }
> > +     pr_debug("%s: k: %16phN, iv: %12phN, hp_k:%16phN\n", __func__, k.=
data, iv.data, rx_hp_key);
> > +out:
> > +     memzero_explicit(rx_key, sizeof(rx_key));
> > +     memzero_explicit(rx_hp_key, sizeof(rx_hp_key));
> > +     return err;
> > +}
>
> This isn't a bug, but these two functions are nearly identical.
>
> quic_crypto_tx_keys_derive_and_install() and
> quic_crypto_rx_keys_derive_and_install() share the same structure: derive
> keys via quic_crypto_keys_derive(), set AEAD auth size and key,
> conditionally set the HP skcipher key, pr_debug, and memzero_explicit the
> temporaries.
>
> The only differences are the member names accessed (tx_secret vs
> rx_secret, tx_iv vs rx_iv, tx_tfm vs rx_tfm, tx_hp_tfm vs rx_hp_tfm).
>
> Could these be unified into a single static helper that takes
> direction-specific pointers as parameters?
>
Looks possible, and I will give it a try.

Thanks.
