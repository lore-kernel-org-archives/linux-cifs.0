Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83AD84AAC76
	for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 15:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789573933; cv=pass; b=nElbHw7HjLw0U2CAGi2EKVMYOopB0+MoMxqfLeTjivw+fnpfoZplZXfpTBHtVP+BbO7uV/HUlFYXAnzHOvtpEKazlLGG1j0FUuiNosKg/ltkSYGYBaOfDaWFSTHkSQaHMd1c4n6HLfAA7tuSbkm3pW8LnUmKETE9lTL/5aP5iiA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789573933; c=relaxed/simple;
	bh=95yWInc3f+wvYQiaDhRAR54L526l6o9/CFXKuqW3YLA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oTYp5NYwzh9JrKPcT/+yo4mukbGOERT0K2pSVTuq+dOZsbqZ6B9lqNpERS64Ds/Xu1pgHzhME70EKcxwuBpQV3oeoy2cs66FYcj2V4dmcJ1AgB8b6ymVDOjuKVAl/WQdfp8tJgU8SwLZhKTmSaVkYkJFGO7EZ0DiMnlLJn/fa5M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bp1xQj1r; arc=pass smtp.client-ip=74.125.228.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bp1xQj1r"
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-85f0fc1fd8eso802077b3a.1
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 08:52:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789573928; cv=none;
        d=google.com; s=arc-20260327;
        b=crkmaDN2FEC5iwyEG+J1ZwHiySdLjfH4ZfWzOvyKZ3Ry7C5tAOituIUvCO0vkAHtLI
         UOttgUJhWFzsi+0K5ozV7Mq4pTLBaA5HQ46BdYzxMBgjUKf+EK2e8vebM20cyRhPpGRz
         18LHt48Yy1Bk/7LKedjQjwYDT0aeJlp9DAs3xt1CIqOAkJDcGMvPElOWeTizjNjZqZKF
         TvZqnVHWebCowWIy605O6aNbHVlMuOxtjTPrZ33qk3KJIj6HtKCkmD1Y+AU45rxSTRnT
         ZPjCttHVkgLQkvfcfAGmyMG7laNpVIvxAHGTdljnPtDSbq6jfy8UbtpwrC/fxnWms55t
         S0Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=r5EyfF2xmjvND7Ej5BcVBP3F4zIxnNANBeziUA4WJEI=;
        fh=cefG01bxI4SJxQV+06XWTZGvq9qHHJsC3D0xJDF/LRA=;
        b=O8O4rAndZWTcxOa9gT5up3R+eIRJjmnKtUmjOwhbtxiJ3UqPzRTMX0/rT75c535/uq
         41Aahnew5OhBAn60IZyjIpebSw/W5O/1RlVUfDcNN5UvbBiijR0ROEfGRLn9reePLq+4
         ASqKFfUDO8fTPfcFPzKCGij+DB0ZZBWqpU865I96T/Isgbr4N3RsWQONpACSLC909xFl
         ppHG4EEypHiajGgDZn/2976MAAzXUHa6uqz73EMfTKv7OUyZ+h6VpWMUSbbWACu3hwNV
         cf7XrTEPN3cMeGn6zDa/RnDjj3GwSA28Lt7iYmzVsF4us/3Q+K5intTetJq0eqcWq/f1
         M9wQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789573928; x=1790178728; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=r5EyfF2xmjvND7Ej5BcVBP3F4zIxnNANBeziUA4WJEI=;
        b=Bp1xQj1rLBv1pXqQByiF36455pmW8LlSKKP9/y8U4Q9S6I/4uYomxtCWuer0U8uoDd
         T+UihBOOvLPGHKuEDQ6KwuF6WPaT1cDn5Q1QzSUH190BNqcahEFgAjcnjptgqbCM+XpC
         LWHDvpBeeZC4qnRnePNsskbaAh6Muj79j9UOk6inJfV9goWOY1KBazj7kc25TQCZ+qE4
         stQkV8VwS90y5IA8Vh69cDpo3RjfByx0SAOE0wRcJUHZnuaCazAwbpZuM/Ro6IuirT8/
         8DWmKCS+HaX9vahSrSrAeC9iso4oM8ro8ulFEK+nVQ49HkcEcoUpYUnsOca3gsfETLll
         NjbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789573928; x=1790178728;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r5EyfF2xmjvND7Ej5BcVBP3F4zIxnNANBeziUA4WJEI=;
        b=B5GSNUzSA+NELLCBbbSilALgtjv6aRZGwVkP+PFWKZC0FBFrYwqSc0I/7HiUczm45R
         YjLf8P9prTLTswgEoZnMRlCeqa6IH95jmnGHj+WP+qjBUkkjHmXdhSObeg1NNU/U+voY
         R1n+/mrn3gBCaFoVOhaVf/mP726tMbByzg3ELilgpnfUWDlwVqZLvLAd5qd3FwVP1xwa
         MjAfQEAOhWTWK3s1dVFCJZzoUtUUzDr24NJRxnwxg3jK2QaFXn9C9SrGA6C0dz3yF7xL
         N+p0AquziMFTFgXpoOx2rfg22AvFowEATd7fv+UJeBX0BUVqqE/bWw54fjeLXL3h8z+I
         m0PA==
X-Forwarded-Encrypted: i=1; AKwUvBwuemZGvcMSHXVrrh7H30In4/e2rCj3MZRfDhrim2Hw5tdzLHUezvgL0U9wb2+CSoZI7GI+taEY/9ta@vger.kernel.org
X-Gm-Message-State: AFuF++krEUZ5IoJOcm3s2NqnGFLTYaG0hQYtsIvKLTtSbYEic/geHXud
	xNlB44VedePs73ouQGKkIX7tZ+LHty3JTdGYSoWZfSO/fm8VlwI8thjf9ugHKv26WlcdQ0xj/M/
	Dr6w3rP4jIZFpivx104NHvRKv29Ei9GY=
X-Gm-Gg: AYBFou0clZSTEPGS7nmdFdX7sLb3XnYOrdueZyxFG9dcK4UWagCKaA3NpusVHv02nzb
	UyLUwtUbqSGPtfZt2SKdS6F5xYLXmgPlUJ8JSuHvLHGOymKgoysM++fUujnXGY7oGgFqGr7g4cK
	eSEus8v19VvMCjJh7fmz0A7hDw4e36tedoO3iUbTz48eK9EOKH641qYNxBNYgB52p3Xm0udREWR
	k1fvnuOmS5u6lT6Vb0yv8g2UODUDY8l7xo334y799DuAixAjHQ3C7HnBBhA9zdOblR2iGKDDgMm
	znjyizoMkVqWvcS85WFm9gYykqeJpoqgZ7YYwg6U7QJoEfPYqN7Zb8DU0RhFYKgo/GxBXLmU9j0
	gXwLYjZA0WNY1DJGckL8uUSNhJjdHvmCCq1JM2CyIWuOagynOh8Gm3/xX
X-Received: by 2002:a05:6a00:4b0f:b0:857:7317:cff4 with SMTP id
 d2e1a72fcca58-8723a199a5amr6423934b3a.21.1789573927943; Wed, 16 Sep 2026
 08:52:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <f886c618bd560e42692c0ac3296bae4878755cc1.1789393775.git.lucien.xin@gmail.com>
 <178950185147.22033.10922498784930147476@kernel.org>
In-Reply-To: <178950185147.22033.10922498784930147476@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 16 Sep 2026 11:51:55 -0400
X-Gm-Features: AcwNN1UzfBxaJOMB6iv3Yg7aIgS3jN1akwkjx3YEKnt_lo6ALcoTP6dYS_KHoK0
Message-ID: <CADvbK_f8PF0uvQsULf2Z6ZO4Ln4b4=670EH8ixZZLjE_1uSM5g@mail.gmail.com>
Subject: Re: [PATCH net-next v15 11/15] quic: add crypto key derivation and installation
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
> Thank you for your contribution! Sashiko AI review found 2 potential
> issue(s) to consider:
>
> Critical: 0 =C2=B7 High: 0 =C2=B7 Medium: 1 =C2=B7 Low: 1
>
> - [Medium] net/quic/Kconfig selects CRYPTO_HMAC but not a concrete digest
>   implementation, while every entry of the new ciphers[] table in=E2=80=
=A6
> - [Low] quic_crypto_set_secret() consumes the uAPI struct
>   quic_crypto_secret but never reads `level` or `reserved`, and honours=
=E2=80=A6
>
> --
>
> quic: add crypto key derivation and installation
>
> This adds net/quic/crypto.c with the QUIC key schedule: HKDF-Extract and
> HKDF-Expand-Label helpers, Initial secret derivation, traffic secret
> installation, key update, and stateless reset token derivation.  The new
> struct quic_crypto is embedded per encryption level in struct quic_sock a=
nd
> freed from the new quic_sock_destruct().
>
> > diff --git a/net/quic/crypto.c b/net/quic/crypto.c
> > new file mode 100644
> > index 0000000000000..910557b680524
> > --- /dev/null
> > +++ b/net/quic/crypto.c
> > @@ -0,0 +1,567 @@
>
> [ ... ]
>
> > +static const struct quic_cipher
> > +ciphers[QUIC_CIPHER_MAX + 1 - QUIC_CIPHER_MIN] =3D {
> > +     CIPHER_DESC(TLS_CIPHER_AES_GCM_128,
> > +                 "gcm(aes)", "ecb(aes)", "hmac(sha256)"),
> > +     CIPHER_DESC(TLS_CIPHER_AES_GCM_256,
> > +                 "gcm(aes)", "ecb(aes)", "hmac(sha384)"),
> > +     CIPHER_DESC(TLS_CIPHER_AES_CCM_128,
> > +                 "ccm(aes)", "ecb(aes)", "hmac(sha256)"),
> > +     CIPHER_DESC(TLS_CIPHER_CHACHA20_POLY1305,
> > +                 "rfc7539(chacha20,poly1305)", "chacha20", "hmac(sha25=
6)"),
> > +};
> > +
> > +int quic_crypto_set_cipher(struct quic_crypto *crypto, u32 type)
> > +{
> > +     const struct quic_cipher *cipher;
> > +     void *tfm;
> > +     int err;
> > +
> > +     if (type < QUIC_CIPHER_MIN || type > QUIC_CIPHER_MAX)
> > +             return -EINVAL;
> > +
> > +     cipher =3D &ciphers[type - QUIC_CIPHER_MIN];
> > +     tfm =3D crypto_alloc_shash(cipher->shash, 0, 0);
> > +     if (IS_ERR(tfm))
> > +             return PTR_ERR(tfm);
> > +     crypto->secret_tfm =3D tfm;
>
> [Severity: Medium]
>
> Every entry of ciphers[] requests either hmac(sha256) or hmac(sha384), bu=
t
> net/quic/Kconfig does not select a digest implementation:
>
>         select CRYPTO
>         select CRYPTO_HMAC
>         select CRYPTO_AES
>         select CRYPTO_GCM
>         select CRYPTO_CCM
>         select CRYPTO_CHACHA20POLY1305
>         select NET_UDP_TUNNEL
>
> CRYPTO_HMAC is only the template (it selects CRYPTO_HASH and
> CRYPTO_MANAGER), while CRYPTO_SHA256 and CRYPTO_SHA512 are independent
> tristates without default y.
>
> With IP_QUIC=3Dy/m and CRYPTO_SHA256=3Dn, does crypto_alloc_shash(cipher-=
>shash,
> 0, 0) in quic_crypto_set_cipher() fail with -ENOENT, so that
> quic_crypto_set_secret() and quic_crypto_initial_keys_install() can never
> install keys and no connection can be established?
>
> Should IP_QUIC also select CRYPTO_SHA256 and CRYPTO_SHA512 (the latter fo=
r
> the hmac(sha384) entry)?
>
True:

Verified that CRYPTO_SHA512 can be disabled while QUIC is enabled. I'll add
CRYPTO_SHA256 and CRYPTO_SHA512 to the select list.

Thanks.
