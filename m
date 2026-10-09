Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524502ED16D
	for <linux-cifs@vger.kernel.org>; Fri,  9 Oct 2026 01:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791510518; cv=pass; b=JSF/3OVpdPhHFZPDr1AS5ZUDOgC+jt/tF0sxd14so3EIYtcKsx+MbsHZNTfIF+mFXz2+fJ/Mg8YeEwoQS6Bywzmq0YoLn84kIScIgbp221keX9CjXNOj8MmZ2qwj2XAYUFn/VHIWFzXU/qhqsqIi1ow5qboAk94RjF4xCn/48Fw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791510518; c=relaxed/simple;
	bh=wUTN84wEWmLrTrkwe83lVi5yrj5Vdynx3RbkpcvXUYQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uym91Jdcj/BJ1PXTg7IR86fopnCaBkPbBi0E04PQ0RRjnlY0fH0+ier/rhfort4d8UBJ2va4/bIxAPRvvA4UWeMDvcGu8Lj0EhJj4huboTkAfL/VDrLhcjca8cGkY/Wws32955AoPuEoWkHgxSDasKdQW3Ft2w6DrAZI4NcQHqQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iXsjTtpf; arc=pass smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iXsjTtpf"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-872024e2b4eso1853000b3a.0
        for <linux-cifs@vger.kernel.org>; Thu, 08 Oct 2026 18:48:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791510516; cv=none;
        d=google.com; s=arc-20260327;
        b=mOAie86cSOQ2beJhmCmTkvhy+xlTY5N3hY4ULfASm1R75Rm7mHUx2ER4Y0N8+IVXxT
         XkWad0XW8rTHEY2+uHUk3DCiWhG9GiOk0Fkfarwz5c8ipGxp6Gansh9uacIMQ4D5cia6
         wJjXTE3wgx1OpwSIxS2akzaiNvfCQHHEfF4hzeYqB2AjnsNqx82uShDervo75yv3ecIq
         9/AaMIhvAu+DrLD0XdjFqEs/g18w0AcNaycONnQK5rn0l+J1269iStdFoLo5vLZgAQCK
         t8j6hdgYcApZn0LfEKYuHuyOBjxpVjIAic1rPtYhCFKyJ4kNGN6Ga44htUlHBC5Rpy+E
         z1Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=g0cBSDkX5TVuKiqF8g84xPSGpnh8it3kfI90lKRUo4w=;
        fh=+OlhocqJ+xak5tpvvtw5oA1r2ZNNsq5fv2FYPOc6rv8=;
        b=JLMR6AMWbdSd5I+0cWoPx8TxNMr0RBTi4h2MVKCCWiNth0VD6QOci4fdtCvEF+EKS4
         IAZXcxEzFBjjrNdO//ALvkHhvX0rHyVmihcNj+rLuTIWUoldYQ8JG5P9qvzVgQpKqsQA
         M7IzpkquxCUNASv0cFDg34OhJkzyv5dVPEkU7chd+OoQLUFZT7zExd+KWrNsWxkqjasU
         Jh7yBtrZPgSLY8VR4son+speSM17aksrB+uh7ckCbSV7L0URkk1PRbr7VF1xNyvKYeOL
         IJkkOU43b/0nT03GDZD5EYqU2i+6/jeUx4SZJRt+bJuY2M+AEv5zu2u2zAnhBN/m6BUF
         I7Ng==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791510516; x=1792115316; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=g0cBSDkX5TVuKiqF8g84xPSGpnh8it3kfI90lKRUo4w=;
        b=iXsjTtpfZsshFHSpF7KnyDpmfIhrkwAjVR4sRmRcQV5sahY0LhTFwvX0cNsfLbB0l7
         j/klO8ia91NNCSDSFpSybfmGWdPS19paG+z1mA+Arj2ORCNme2C8F5yZo9CKFPP8ddkn
         c8Ou//rK725o0DREaeuqvjSo7ihmHyyjkFBNimOEJvxI+nOOwQGR5camDuaP8jtZ/daF
         JuDsN67Jd7i8YjhF8aCQe66XBoBlMuA4IdPMCHvyV5iQJ8tE3LhJvDshiuNPQMGOpwIG
         7thpnHFenJTJQVIf9lzfFsYQgC/v6xONUu1m26/v+5KB7VXgfK5/z3pjcul3B82xKza6
         bSdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791510516; x=1792115316;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g0cBSDkX5TVuKiqF8g84xPSGpnh8it3kfI90lKRUo4w=;
        b=SRT2srMY1hfewFskpZNm+8sZcsGB0Nsbd6P4ldrgPI+DMyCMEQDeHamJn7SjDHb5ae
         DdqFmXj5hlTmAzLH6pAm2/RdLsIzwzrXOBdclBlAmuoVMzEh8fL7ItbW16+RAFwk3hN9
         WcmYPghVFRshp0yYxq/y2641QQAmj5lYYjJe5OukWkH+HM2+czIyaGH6xaTSr7NkXSDN
         lMtSnM3W/JdJiQjrXFJu0bZtCZ5oZwLBMIpmubxSAeWvd6GdMcf4Fq6dx97cBiYhWrGG
         0/sUmXaUbrOUMK6cykU77jrYCfLaeUvJUDwvUADiMPDQqk0lkBh78+9iU0ZwzQsm2ZJ/
         gXGw==
X-Forwarded-Encrypted: i=1; AKwUvBxp9CbXPU3aTn3JrzCJCgFTRnYUy4H0Izoq+NX/+vf9a+VnHGhLj833bkQGH+iTtbe/Y3i4bVnNNHoj@vger.kernel.org
X-Gm-Message-State: AFq9FYJuUvW2PrGclhlCZ8RIm/2E8A2MPbexdILOQzNTngLcvx14qfNt
	qxdVyAYMd1r8QzdlJT3+pIjyN/+VYptGQxtUUbAUV4b6vUnMQ5EljHMDr7bFOVDyL5+vyOGRYkL
	kWTWISQzrIwiDKNpX5ajPnIFlVkS3W+s=
X-Gm-Gg: AYBFou1LUMloYzwAuKFO3Awzvxhumb8sOWys7YFfUoPoeGhN85MJCNIHvWl9rBmDDGP
	BkiyzkmPLWiaJ4++C1AK9CktamyQh+rRlNQWyBHp6LX6LX8j87nIRO5Smi6BJNDUbW1Lpcp7ORG
	gXOX1AEm8BwKrUC+7JhbXjiCAr412T/byrz//6zyJ5O5FEOfDbOAPMGzBO+y7RBhf+H2pM0bfqN
	GhS4xPbkFN/1XiiecLmvVXayxokACgtIQGIev9vPBZHy459Kl5KBfvB/HUEXWfhOjF+dCltpq2a
	hBdWCeTp7jhWrxsfPgr7KoTtXPn6ealFoxO54Q73iK5LXBxbceLjTEcuJo+W1UTr13+HgPxQyYV
	hyaevdKvOQmkoaZhgcShEKs+Z5/avnzA458bkohy8ZWurni21Z3VB
X-Received: by 2002:a05:6a00:99a:b0:881:ac65:715e with SMTP id
 d2e1a72fcca58-897c82b3a1dmr267063b3a.58.1791510515511; Thu, 08 Oct 2026
 18:48:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <4dc3c5117810571e41211781bd0280510460e4da.1791227050.git.lucien.xin@gmail.com>
 <179133512379.434549.1011079085204348692@kernel.org>
In-Reply-To: <179133512379.434549.1011079085204348692@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 8 Oct 2026 21:48:24 -0400
X-Gm-Features: AclHuK9uRikezuu_s0N89XRYmqsG92abnIe6hnbR5B-c3f-eILbuCbfT4rSeql8
Message-ID: <CADvbK_f3s+p803=1UmbsG594jNsjXoyy4DDB4wzhCCoK_+EYAA@mail.gmail.com>
Subject: Re: [PATCH net-next v16 12/15] quic: add crypto packet encryption and decryption
To: netdev-bot+sashiko@kernel.org
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 6, 2026 at 9:05=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wrot=
e:
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
> - [Medium] The AEAD integrity limit that this patch enforces does not
>   count failures across the whole connection, as RFC 9001 =C2=A76.6 requi=
res.
> - [Medium] quic_crypto_generate_token() writes the raw 64-bit
>   quic_ktime_get_us() timestamp (ktime_get(), i.e. CLOCK_MONOTONIC in =C2=
=B5s=E2=80=A6
> - [Low] The kernel-doc of quic_crypto_verify_token() says "Return: 0 if
>   the token is valid, -EINVAL if invalid, or another negative error=E2=80=
=A6
> - [Low] quic_crypto_decrypt() counts every non-EINPROGRESS failure of
>   quic_crypto_payload_protect() toward the AEAD integrity limit, not=E2=
=80=A6
> - [Low] async_pending[] is used as a quiescence check before re-keying a
>   tfm, but both sides use unordered atomics.
>
> --
>
> quic: add crypto packet encryption and decryption
>
> This patch adds AEAD payload protection and QUIC header protection for
> TX and RX via quic_crypto_encrypt() and quic_crypto_decrypt(). It also
> adds helpers to compute the Retry integrity tag, and to generate and
> verify Retry/address validation tokens.
>
> > diff --git a/net/quic/crypto.c b/net/quic/crypto.c
> > index 4bb6acea5112a..fa326cc9266a8 100644
> > --- a/net/quic/crypto.c
> > +++ b/net/quic/crypto.c
> > @@ -270,6 +271,484 @@ ciphers[QUIC_CIPHER_MAX + 1 - QUIC_CIPHER_MIN] =
=3D {
>
> [ ... ]
>
> > +int quic_crypto_decrypt(struct quic_crypto *crypto, struct sk_buff *sk=
b,
> > +                     gfp_t gfp)
> > +{
>
> [ ... ]
>
> > +     phase =3D cb->key_phase;
> > +     if (phase !=3D crypto->key_phase && !crypto->key_pending) {
> > +             if (!crypto->send_ready) /* Not ready for key update. */
> > +                     return -EINVAL;
> > +             if (!cb->backlog) /* Key update requires process context.=
 */
> > +                     return -EKEYREVOKED;
> > +             /* Cannot do key update while async crypto is in progress=
. */
> > +             if (unlikely(atomic_read(&crypto->async_pending[phase])))
> > +                     return -EBUSY;
> > +             err =3D quic_crypto_key_update(crypto); /* Perform key up=
date. */
>
> [Severity: Low]
> Is the ordering here strong enough for async_pending[] to work as a
> quiescence check before re-keying?
>
> quic_crypto_done() signals completion with a plain atomic_dec(). Per
> Documentation/atomic_t.txt, that operation is unordered:
>
>     atomic_dec(&crypto->async_pending[cb->key_phase]);
>
> This side reads the counter with a relaxed atomic_read(). When it sees 0,
> it calls quic_crypto_key_update(), which rewrites the key schedule throug=
h
> crypto_aead_setkey().
>
> Nothing orders the completing CPU's loads of the key schedule during the
> AEAD operation before its decrement. The socket lock does not cover this,
> because the decrement happens before cb->crypto_done() takes the lock
> again.
>
> On weakly ordered architectures, can the re-keying CPU see 0 and overwrit=
e
> the key while the completing request's reads are still unordered? Would
> atomic_dec_return_release(), or smp_mb__before_atomic() plus atomic_dec()=
,
> in quic_crypto_done() paired with atomic_read_acquire() here be needed?
>
> > +             if (err) {
> > +                     cb->errcode =3D QUIC_TRANSPORT_ERROR_KEY_UPDATE;
> > +                     return err;
> > +             }
> > +             cb->sync =3D 1;
> > +             cb->key_update =3D 1; /* Mark packet as triggering key up=
date. */
> > +     }
> > +
> > +     err =3D quic_crypto_payload_protect(crypto, skb, false, gfp);
> > +     if (err) {
> > +             if (err =3D=3D -EINPROGRESS)
> > +                     return err;
> > +             /* When using the old keys can not decrypt the packets, t=
he
> > +              * peer might start another key_update. Thus, clear the l=
ast
> > +              * key_pending so that next packets will trigger the new
> > +              * key-update.
> > +              */
> > +             if (crypto->key_pending && phase !=3D crypto->key_phase) =
{
> > +                     crypto->key_pending =3D 0;
> > +                     crypto->key_update_time =3D 0;
> > +                     crypto->key_update_send_time =3D 0;
> > +             }
> > +             goto err;
> > +     }
>
> [Severity: Low]
> Should every quic_crypto_payload_protect() failure count toward the AEAD
> integrity limit?
>
> All of these reach the err label and increment rx_fails[cb->key_phase]:
>
>   - -ENOMEM from quic_crypto_aead_mem_alloc()
>   - a negative skb_to_sgvec() result
>   - on the resume path, any async engine error delivered in
>     cb->crypto_err
>
> RFC 9001 section 6.6 counts only received packets that fail
> authentication.
>
> Under sustained allocation failure, could a legitimate connection end up
> with -EKEYEXPIRED (AEAD_LIMIT_REACHED) instead of just dropping packets?
>
> [ ... ]
>
> > +     return 0;
> > +err:
> > +     if (++crypto->rx_fails[cb->key_phase] >=3D crypto->cipher->rxlimi=
t)
> > +             err =3D -EKEYEXPIRED;
> > +     return err;
> > +}
>
> [Severity: Medium]
> Does this enforce the integrity limit across the whole connection, as
> RFC 9001 section 6.6 requires?
>
> The comment on the QUIC_AEAD_RX_* constants cites that section. It says
> endpoints MUST count packets that fail authentication during the lifetime
> of a connection, across all keys.
>
> Two things seem to weaken the limit here.
>
> First, cb->key_phase comes from the key bit after header protection is
> removed, and the packet has not been authenticated yet. Forged
> short-header packets therefore spread across both rx_fails[] slots, which
> allows about 2 * rxlimit forgeries.
>
> Second, quic_crypto_keys_derive_and_install() resets the slot on every RX
> key install. That includes each key update reached through
> quic_crypto_decrypt()->quic_crypto_key_update():
>
> net/quic/crypto.c:quic_crypto_keys_derive_and_install() {
>     ...
>         if (rx) {
>                 crypto->rx_fails[phase] =3D 0;
>     ...
> }
>
> For AES-CCM (rxlimit 2965820, about 2^21.5), an off-path sender would get
> roughly (2 + number of key updates) * rxlimit forgery attempts.
>
> Would a single connection-wide failure counter, not indexed by key phase
> and not reset on key install, be more appropriate? tx_count could stay
> per key.
True.

But the same as the one reported on the last patch.

>
> [ ... ]
>
> > @@ -560,6 +1039,234 @@ int quic_crypto_initial_keys_install(struct quic=
_crypto *crypto,
>
> [ ... ]
>
> > +int quic_crypto_generate_token(struct quic_crypto *crypto, void *addr,
> > +                            u32 addrlen, struct quic_conn_id *conn_id,
> > +                            u8 *token, u32 *tlen)
> > +{
> > +     u8 *token_buf, *p, flag =3D *token;
> > +     u64 ts =3D quic_ktime_get_us();
> > +     u32 len, tslen =3D sizeof(ts);
> > +     int err;
> > +
> > +     len =3D sizeof(flag) + addrlen + tslen + conn_id->len + QUIC_TAG_=
LEN;
> > +     token_buf =3D kmalloc(len, GFP_KERNEL);
> > +     if (!token_buf)
> > +             return -ENOMEM;
> > +
> > +     p =3D token_buf;
> > +     p =3D quic_put_int(p, flag, sizeof(flag));
> > +     p =3D quic_put_data(p, addr, addrlen);
> > +     p =3D quic_put_int(p, ts, tslen);
> > +     quic_put_data(p, conn_id->data, conn_id->len);
>
> [Severity: Medium]
> Does this expose the server's uptime to any client that receives a token?
>
> ts is the raw ktime_get() value, in microseconds since boot.
> quic_crypto_token_protect() only authenticates the flag, address and
> timestamp as associated data. It does not encrypt them:
>
>         aead_request_set_ad(req, adlen);
>         aead_request_set_crypt(req, sg, sg, len - adlen - extra, nonce);
>
> Tokens are sent to unauthenticated clients in Retry packets and NEW_TOKEN
> frames, so the monotonic clock can be read from them in plaintext. TCP
> avoids a similar leak with per-connection timestamp offsets
> (secure_tcp_ts_off).
>
> The v14 change moved the timestamp from the encrypted part into the AAD
> so it could be used for the nonce. That change appears to have introduced
> this exposure.
>
> The serialized address is also sent in plaintext. For IPv6,
> quic_v6_get_msg_addrs() in net/quic/family.c sets:
>
>         sa->v6.sin6_scope_id =3D skb->skb_iif;
>
> Would the server's ingress ifindex end up in the token as well?
>
True.
- Will add crypto->ts_off to randomize the timestamps as TCP does.
- Will move the address from the auth part to the encrypted part in token.

Thanks.

> [ ... ]
>
> > +/* Validate a Retry or address validation token.
> > + *
> > + * Decrypts and authenticates the token, checks the client address and=
 validates
> > + * the timestamp against the timeout selected by the token flag. For a=
 Retry
> > + * token, extracts the original destination connection ID.
> > + *
> > + * Return: 0 if the token is valid, -EINVAL if invalid, or another neg=
ative
> > + * error code.
> > + */
> > +int quic_crypto_verify_token(struct quic_crypto *crypto, void *addr,
> > +                          u32 addrlen, struct quic_conn_id *conn_id,
> > +                          u8 *token, u32 len)
> > +{
>
> [ ... ]
>
> > +     err =3D quic_crypto_token_protect(crypto, token_buf, len,
> > +                                     sizeof(flag) + addrlen + tslen, f=
alse);
> > +     if (err)
> > +             goto out;
> > +
> > +     err =3D -EINVAL;
>
> [Severity: Low]
> The kernel-doc says -EINVAL is returned for an invalid token. Does a
> forged or tampered token actually return -EINVAL?
>
> A tag mismatch makes crypto_aead_decrypt() return -EBADMSG. That value is
> returned unchanged through the goto out above, before err is set to
> -EINVAL. A token key that was never set would give -ENOKEY in the same
> way.
>
> Only the length precheck and the address, timestamp and ODCID length
> checks return -EINVAL.
>
> Should the comment be updated, or should authentication failures be
> mapped to -EINVAL?
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/cover.1791227050.git.lucien.xin%40gmail.com
