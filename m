Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BC64CEE45
	for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 16:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789574489; cv=pass; b=quudRQBxaeCwrUhGEMa0qm30J1k9UmnYL+6RmqtHckNDctYkVCElT2nRBm64Q+o13OVSjuSw7r5AHfoSXFtQ+GAu8u/SlXLY0ET3dOgb/9/3gUyEZ9DRfdPLkDKsYN6k2KF1oL6kGcB/Wa5ujft83fe3p04SDr5TqWBT1RMO8bg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789574489; c=relaxed/simple;
	bh=KZzkhX7Yg9tq5VztU7UiOhKrR7TxsvCHoG9frYwd3EM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Amaazt3MS0A4G0xhD92ogyBet2jDR8wYHvwYS9wNHkfoohY+DnuFZ7UvR17eflbnK59Rq9oIyrzW31YnkZkVchMQ/hXEl7EzuuYQ/eWi3Oa7YdPDoOWIyaBrjl/hDYdYhynriApW6tk77cVbAjVACun5XzchjHV/zYHy/SgXfvw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EnIkMeTc; arc=pass smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EnIkMeTc"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-853e2610bb4so1462644b3a.0
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 09:01:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789574485; cv=none;
        d=google.com; s=arc-20260327;
        b=PuzgmgYpSV5EJ0JFaAMkVmju0qTK4Uo4GnLm4LXdIG4Q3v5FDdzFwTdWaI6VgrWoAM
         juEysfdYemYBjXjxewxwrC3PABEdlylRfGUUxDMrUE7AwITi0kIseXATUmCEV6+gMlDn
         0Xgw1HqUqKZpO81+gt5vW9w5Yqac2D1I6iuNchmqu02jOr0oWaMVot0JnggGXGvP47s1
         jVz3M9UN2iAGOlPjWHGH7vkh8putbTQKfIqfCJwHA2HMe7y6Nz+5mWahXJ+pgIRdYVgy
         UqTnVy6WsWuCWmPRMLO+XW8az8kllphtUx9+sFVDHsFGxidCdYyTaW+oKqzXH7jbxmri
         aHBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6dZUcimEc7wlnFEZ6ZQZ/uU5ugi4xLHu5NBwADbejVU=;
        fh=LWJHvJL3IhTl3BEZgb0BLqqrCVpU713cM0XwePn1jxo=;
        b=kaJjFM7fmBo154VmMV3guWqVGbvglSEaqUKdfqZX09pJ6FX7w6P6PqZK2pXdYmPgGp
         zpRkjs7aOBSzuZQQov6SXPtXJw9fkl/ILP40gGRclVePSDYGKvTgiJ4Wic7Ruy8xzolY
         6E6qWNNC0aoUagyV81JOudkMuEqG4/aYKhwSwlC/g4hojvCpE4YiO2HOryWPHaMnYOyc
         RGuJEEhFYz+JM4d+f8XwyexioNb4hi9CSqJRBrP2t+u42JB9csRmWR7YVVBGGOaFn93K
         xOBhK33gdXEL1wdWa+sx1dgvIn5hRsAbBgNZ0phi5KM4k9Oqf/ZIiEDJYou1iojFf1hi
         osVg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789574485; x=1790179285; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6dZUcimEc7wlnFEZ6ZQZ/uU5ugi4xLHu5NBwADbejVU=;
        b=EnIkMeTcAXOTg0ci9YpA/47+oFUHkAXYxkUBwpNaRBxC3heOmzLO6tvS3tHeamEFAi
         4SRifZ9S93GtWNNfIfGx+J1cJwhjonscB1tJAXvCbpY3WBMjw6Gd58HTmEH3e/GRoDtd
         jhbYwtYDseS1GRCY6HugObB6su8NX6DPG6XuFpoAcKovcaqbpKf9wi4rtyz/3og54/wB
         JiJiUB7mdPJ08v3WiIWpvM3gFPTp21LeuJTTUOQPIWd34qrSkH/OQMWkntXvrOFhWoRL
         /DSoUOIbXm4Efy6+sY6FVsUQYjw3r+OBd2bFPb8JKb5+1KXDwi0Din7mp6Wf61EJ79UI
         FhYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789574485; x=1790179285;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6dZUcimEc7wlnFEZ6ZQZ/uU5ugi4xLHu5NBwADbejVU=;
        b=PX5IdDxuZ+Gm8tgZnAAP0I+TGpQmnKd717v/GZvcrJuYjufbLAVvuUeoFRIA7ynY9U
         jcRs5nTKvwlWv6GNMR6Jy6xPcbjqyT7U1A0t0JGsXc5rn7mEtIbZ8gMvMB6AsuSUq/qw
         aLy5dtQOiTcl3yDheBQ87nKrMoRcRpfmXE6x6rysmu46xMZH2A20wHlHP06KDJuDx4ZC
         k0QkfanUg6IQCrjUZ7FdlqN6nNpaKIbR2bKbfBAmNvNXYVsXQf30hg3AZa+NoYxq/Dp0
         Smh7T1HzlDx4rBmtXh7+nC31mhhMe23pOuaNmK0WQurSoRdIKRgg9kF8TvB6G4Tc2nxL
         7z6w==
X-Forwarded-Encrypted: i=1; AKwUvBzfo7zC9jE7yRzBEe127PD2xPZujD3TxKH+3rbkDUv+1g7CDK88jSnyJh7ILWxyyVHnmopTGKBo4ZQ7@vger.kernel.org
X-Gm-Message-State: AFuF++n9QiNbrkWeeQ6ZwGtz8L/LxtyaJLp1unw5fkCU2kmCFQLnYLaf
	+frnLGboGdAaFDCfHOenG+1vZpvKUIZlmrObNjVLPGm2CgOLaGQLqYrVABk+mwSD4qaY64Gd7HK
	j6maNObsVcXj+aQSiSKdubgln0PlJUeI=
X-Gm-Gg: AYBFou2wQmGLL0wUtkm6Y2O9qcH+JtJ/UIiNjckPtXUl5m7X4znJjYsfy9JFh598UJy
	eOcCerbCSa2aGJtgRpkasHbCp69APBfco15HAhEQauQOc47crENE2CfnyhIaEee5qjR6zBa8rgX
	1YvKMrjNx+OTCd6SYCDxlkvnwneRKXIE2R6OA/9IBmCKefnY55LwrdErLDpl+O7nUf5d4ca5R40
	xm51xrdKyFX8aeYC9CAE9Jeep72UaISN4PcpPJyomh/Si1y1ajjG3NEHE7q2LGQv3GJIwQntGi8
	+M+2NW5CnqtktkYM75OFCtmFRop8iQqI1nBGjp3FxGSQlm9dGwVQ4hXb4DPFutY7AFAACwMPCKe
	mDeqKA/scGJuarqYaZWyL91bk6MVyDFANHz+oN2TXXtqbmLuAhmrKl4b/
X-Received: by 2002:a05:6a00:194d:b0:858:ea6a:4415 with SMTP id
 d2e1a72fcca58-87341085f89mr164645b3a.2.1789574484253; Wed, 16 Sep 2026
 09:01:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <06841ed60dda515dce3f3f16b4c3b31fdd7113fe.1789393775.git.lucien.xin@gmail.com>
 <178950185396.22033.4056258856263599395@kernel.org>
In-Reply-To: <178950185396.22033.4056258856263599395@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 16 Sep 2026 12:01:12 -0400
X-Gm-Features: AcwNN1Wlyl-Jb-pcM6ljfG1c-LlXoB2ud7xNxMc2wjUUg2Dsiy8bDgQmSGaxVHw
Message-ID: <CADvbK_d9-8y8uC09+Sqqxxs_7a_YaOZxhL6JXC-5PQZXGARN6w@mail.gmail.com>
Subject: Re: [PATCH net-next v15 12/15] quic: add crypto packet encryption and decryption
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
	mef@scarletmail.rutgers.edu, paul@jakma.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 15, 2026 at 3:50=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found 4 potential
> issue(s) to consider:
>
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 2 =C2=B7 Low: 2
>
> - [Medium] quic_crypto_encrypt() records crypto->key_update_send_time =3D
>   quic_ktime_get_us() *before* attempting to protect the packet=E2=80=A6
> - [Medium] The new packet protection paths
>   (quic_crypto_encrypt()/quic_crypto_decrypt() ->=E2=80=A6
> - [Low] The comments on the new token helpers describe an earlier
>   revision of the code and are now wrong in three ways.
> - [Low] Reported concern: quic_crypto_generate_token() computes len =3D
>   sizeof(flag) + addrlen + sizeof(u64) + conn_id->len + QUIC_TAG_LEN and=
=E2=80=A6
>
> --
>
> quic: add crypto packet encryption and decryption
>
> This patch adds packet-level AEAD encryption and decryption for QUIC,
> including header protection and its removal, plus helpers for the Retry
> integrity tag and for generating and verifying address validation tokens.
>
> A few questions on the new code below.
>
> > diff --git a/net/quic/crypto.c b/net/quic/crypto.c
> > index 910557b680524..d62c6c4bea7de 100644
> > --- a/net/quic/crypto.c
> > +++ b/net/quic/crypto.c
>
> [ ... ]
>
> > @@ -252,6 +253,457 @@ ciphers[QUIC_CIPHER_MAX + 1 - QUIC_CIPHER_MIN] =
=3D {
> >                   "rfc7539(chacha20,poly1305)", "chacha20", "hmac(sha25=
6)"),
> >  };
> >
>
> [ ... ]
>
> > +/* AEAD Usage. */
> > +static int quic_crypto_payload_protect(struct quic_crypto *crypto,
> > +                                    struct sk_buff *skb, bool enc, gfp=
_t gfp)
> > +{
>
> [ ... ]
>
> > +     aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> > +                               quic_crypto_done, skb);
> > +     *(struct quic_crypto **)ctx =3D crypto;
> > +     atomic_inc(&crypto->async_pending[phase]);
> > +     cb->crypto_ctx =3D ctx; /* Async free context for quic_crypto_don=
e() */
> > +     err =3D enc ? crypto_aead_encrypt(req) : crypto_aead_decrypt(req)=
;
>
> [Severity: Medium]
> This is the single place where every QUIC packet is protected or
> unprotected, so it looks like the natural home for the AEAD usage limits
> of rfc9001#section-6.6.  Are those limits enforced anywhere?
>
> struct quic_crypto in net/quic/crypto.h keeps secrets, IVs,
> async_pending[], the key update timestamps and the bit flags, but has no
> field for the number of packets protected with a key, nor for the number
> of packets that failed authentication, and a grep over net/quic at the en=
d
> of the series finds no confidentiality or integrity limit check.
>
> On the RX side quic_crypto_decrypt() just returns the AEAD error, so a
> peer can keep submitting forgery attempts against the same key without th=
e
> connection ever being closed, which rfc9001#section-6.6 requires once the
> integrity limit is reached:
>
>         err =3D quic_crypto_payload_protect(crypto, skb, false, gfp);
>         if (err) {
>                 if (err =3D=3D -EINPROGRESS)
>                         return err;
>                 ...
>                 return err;
>         }
>
> TLS_CIPHER_AES_CCM_128 is supported here (quic_crypto_is_cipher_ccm() and
> the "ccm(aes)" ciphers[] entry) and has the lowest integrity limit of the
> QUIC AEADs.  Is the intent to add the per-key counters and the limit chec=
ks
> in a later patch?
>
True:

This is a missing feature. I'll add per-key counters and the corresponding
limit checks.

> > +     if (err =3D=3D -EINPROGRESS || err =3D=3D -EBUSY) {
> > +             memzero_explicit(nonce, sizeof(nonce));
> > +             return -EINPROGRESS;
> > +     }
> > +     atomic_dec(&crypto->async_pending[phase]);
> > +     cb->crypto_ctx =3D NULL;
> > +
> > +out:
> > +     kfree_sensitive(ctx);
> > +     memzero_explicit(nonce, sizeof(nonce));
> > +     return err;
> > +}
> > +
> > +/* Encrypts a QUIC packet before transmission.  This function performs=
 AEAD
> > + * encryption of the packet payload and applies header protection. It =
handles
> > + * key phase tracking and key update timing.
> > + *
> > + * Return: 0 on success, or a negative error code.
> > + */
> > +int quic_crypto_encrypt(struct quic_crypto *crypto, struct sk_buff *sk=
b,
> > +                     gfp_t gfp)
> > +{
> > +     struct quic_skb_cb *cb =3D QUIC_SKB_CB(skb);
> > +     int err;
> > +
> > +     /* Packet payload is already encrypted (e.g., resumed from async)=
,
> > +      * proceed to header protection only.
> > +      */
> > +     if (cb->resume)
> > +             goto out;
> > +
> > +     cb->key_phase =3D crypto->key_phase;
> > +     /* If a key update is pending and this is the first packet using =
the
> > +      * new key, save the current time. Later used to clear old keys a=
fter
> > +      * some time has passed (see quic_crypto_decrypt()).
> > +      */
> > +     if (crypto->key_pending && !crypto->key_update_send_time)
> > +             crypto->key_update_send_time =3D quic_ktime_get_us();
> > +
> > +     err =3D quic_crypto_payload_protect(crypto, skb, true, gfp);
> > +     if (err)
> > +             return err;
>
> [Severity: Medium]
> Should key_update_send_time be committed only after the packet has actual=
ly
> been protected?
>
> Here the timestamp is stored before quic_crypto_payload_protect() runs, a=
nd
> neither this error return nor the header protection failure below restore=
s
> it.  If payload protection fails (skb_cow_data() returning -ENOMEM,
> quic_crypto_aead_mem_alloc() returning -ENOMEM, an skb_to_sgvec() error, =
or
> an AEAD error) the skb is dropped by the caller, but
> crypto->key_update_send_time now records a time at which nothing was sent=
.
>
> quic_crypto_decrypt() then uses that value as the start of the old key
> retention window:
>
>         if (crypto->key_pending && cb->key_phase =3D=3D crypto->key_phase=
) {
>                 time =3D crypto->key_update_send_time;
>                 if (time &&
>                     quic_ktime_get_us() - time >=3D crypto->key_update_ti=
me) {
>                         crypto->key_pending =3D 0;
>
> Can the window therefore already be expired when the first packet in the
> new phase is really received, so that key_pending is cleared immediately =
and
> a later reordered old-phase packet is treated as a fresh key update
> (phase !=3D crypto->key_phase && !crypto->key_pending), overwriting the o=
ld
> key slot before those packets can be decrypted?
>
True:

This is not a major issue in practice. I'll move setting
key_update_send_time to after payload protection succeeds.

Thanks.
