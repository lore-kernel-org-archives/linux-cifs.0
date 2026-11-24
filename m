Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.180
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795551597;
	b=Bp+3J5uU+VW/Oas/n4DfwblYNq4XuaV2eoI4wmYEVmQZofF+d3x8CoNFy1NNR72I+Fqh
	 5nxPz9VXL8XlhyDJTHheIohJ/CJDpNJYqM3FnDm2Nv3f+G7KZCOJvPpcsbxB9fvhEVq4s
	 aMvLpoqABI9qj2BU6cPyT5kV5NiFMl2KPs4p+jB5vIvCBGEC/yx6D1VFZXIvP2P8L4DhA
	 jdo4er0xox4FMiVZZkmSRRUfOnIUtxFaPD4gsxX3/QIRoZIISlYlkULa0JVjCVhpHEGXh
	 +nfGYU7aWpiVX985w2RwB4oQt88vxDvAH5hM5p+806P+kvCDd7qI1yDffzrYC/496qQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795551597;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=IWHkOExNTIIKhjxQS3sMtn2Z92YI/DSSmmMbSwEzbEA=;
	b=BpfBPGDopcVf+6hAuBUkNoV6o2T+k1q7E2Jwd7WcY0BO/TRGgR37OwTI+T8Vjs7uzRXY
	 SNtMWJKsERZSB381rSdP+oWqJKDrzryX3huLfTBlwa4jseHHDE1+htTwylZteBCY+g3uB
	 4tXNu/sU1Kr8X5xs748Lla+zwZlJsWE4SDgodZj5W41Vd6K7U+7UuB1C8HVrhVWohmgzO
	 XtqQXpFJU9ll6TFJddIdpPDx/qK+kWeQfgAwvHPHZaqbse/W6hl1HR50QXQeAUaxyxHL8
	 oLtOe3AIzMdRjvm9vb8CRXVEnJ5koC0Qks2OgF0a+RVur/Cwu0P07n5AmwUbOJlf1qQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oximlhy4;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.180
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01F0C606A33C
	for <linux-cifs@vger.kernel.org>; Tue, 24 Nov 2026 20:19:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 01F0C606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oximlhy4
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8b5c3288e6cso1937555b3a.3
        for <linux-cifs@vger.kernel.org>; Tue, 24 Nov 2026 12:19:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795551596; cv=none;
        d=google.com; s=arc-20260327;
        b=mZJ/hRBZkWlglmgplxkUvmteoL1XtXBu2P3yYj4bFZHcNgLTGH3d6vIDR5ZULEGXA9
         8CttmQycOKwupc/g/GXitrZyDqEAEJT+gHxJyo3vZPOQQzhMajGXO+NcS68/9j9HA7Ym
         JZRoT3tlydHCP2aNYVg6FYNrnL3hn4y94Z0SveIFA3rXs+jzBkrYPYOf8Wm4wsu2UqF3
         7WAUmTzyDMljDKGACBgY3DtbdtsbQN+EfA3PlGW5Es5nPWtfVNx8KnPl4algNQaXVXkg
         zq/nAbD28CFPVVPTzh+8oQzxTirt43ttXzwIpHxq4L+yGW/z7S5m9fEnuZGvWYE31Z2+
         XMUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IWHkOExNTIIKhjxQS3sMtn2Z92YI/DSSmmMbSwEzbEA=;
        fh=WQkdZ5FGvC44VNjw4PukZVMEE+cPnq/PEQPye2rs0xc=;
        b=ZbFiSdgOrakeppi2VeRdQaUjLQjcRDQsq6n3Tir+r3vLTloTu/oqsLaN9034qb3+Tx
         ghcHiqa3OFZ5eG0iTuRddiJo/2Bo+2mcPVBctWCI5LDU/5sWLqPyS6hEsNwMcPKUMIIH
         rOn8vEXxQV9S/M3wUDEX2QlYT+PeGGertAa1s7ddW72WBPHbt9sslm4gO0XkNDhktnAP
         Xt/U3yKD7TGIJ8gdmu0GNk2hVQh/O63EYPwCwZIqHUAMlU1KOHGN8VztM36nSGhPIToG
         st6HRe8eRW4/KgB7nYeg7iMnf0NY15wHWQ6SdCrT8Jkr2xIEBWe5iW2oMTAE8tpmebo7
         N1NQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795551596; x=1796156396; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IWHkOExNTIIKhjxQS3sMtn2Z92YI/DSSmmMbSwEzbEA=;
        b=oximlhy4LUFgFBargecL3MFyT5UDeJ6JAEXhrRWSyCt5n1M07S5F4fVevgly2MPnlk
         bCZn1bv8qYAGuExuHI7QXubEzp5hhBF2zVqkK1pujon0shTGoL9KDcOxX2sr2+nnt0p6
         KLRcryFZmJ6sY9MuQU78mCocYTuxs3Jh9ZQtXyKeJazDHtM7nGGHlqMn33skZRRw+kCE
         NvNrI6J3CG69WKv/Useuj3CRL9/ymRL5E+CV6Zbk9fcGsmqW8aPBy11eKBJShYsHFoQI
         1i8B7bnTOjE1wAtagaoWKl0Ju/M6Qobstl4E+w0RTNL+A3KP0pjuPm6GYqzE21eNI9f6
         hc1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795551596; x=1796156396;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IWHkOExNTIIKhjxQS3sMtn2Z92YI/DSSmmMbSwEzbEA=;
        b=yuKCI33oKQ9vHO6XI6U4OZQsbUrHppW0Jd+1BN+GcraMZKDB7vXDc+3MOIta61VPTn
         6VpVGGkRLlWBWtBsBTLSVH0McaP3l6vwXJ3R7RHmI9JI5ex401W8S1goPkONxfqjlki7
         ENWzbZd7agNwM/8BDnCqui640yxzSlYscc3WXKuok5iVCbzWVQx9WBoYkAUSo1KfWPzG
         6pqZzEiUcHxaX6h423t8tm5sAqwvrLFS5nhbnOwa4xqmmpICn1XRNrBaiQ/rWtaoIk9K
         kVNtg1+gTZ1NyAExrgAXcno/iLuYAE2IqwgRudSF+0AXzWZLaxqs75zowhfGolc+JGa5
         bvXw==
X-Forwarded-Encrypted: i=1; AL+hErEhbn1kMd8Mn55hD/vszMfoEy0rvlJ4iUqsSCVWdpOBi4N4mx4wfU5VgOdQ42o0kfAJPOrnemZ14wlf@vger.kernel.org
X-Gm-Message-State: APuU4Z8SO460Q/7JyvEKii+CCTJsf6sNEVJtI1kB+eG4kDGHp44/5quj
	FEPa8yFgHlRbkIMnGe1Wf6MdzIzJjUDu+knvPHFG0B9RlNvU2hsuLDm+wrj/WZWhFxUZSB5NFai
	vWQw1hoRQ+x58aDL40FPnh2MrrUjYLII=
X-Gm-Gg: AZFdTZeVZI8Y7dmNpyTvR6f1CVIMG3lJz05FSZgMN3DjVMT7oGDiGal7VIKqKDFV3zO
	79O/+U9bVErEHFmoj6ybjZ79E819lSx/e5A4WrF4BPEP2m2I+dGjQ0zWYkev81gsncUgNtXDttu
	1IQBRrZWKN5lD6BCWJ9ZIBPn7UA+koh82VmD8092RpIAYQP+tzeyq64yQ8RnSM40m79RpPZn6wm
	Xy0oJgVyrQnitQ1rW1FJWyU7DMIviWIG82vWvguIx9MeeCMQJpoGr8HGTo+ZKQtf+LqQ37LqiDB
	cxrOZf9uzVlG3U3ZmIet2fvOsAMH7XASCMHzoLVgfvuU2yA4nyVS8QuCRxvVdYxK7EvE0+2tY8o
	FtE3//b4Fqjm+dc1zSV+jDgSDIiBihLCuFlA42x1yBV87uYHdv+4GU/WFXbj3OxVhG9hXbO1wlr
	s6jISA1xRiUUWq7petH4okGEGSmYcjJGZ3u9/WHlyYId6R9XgA2GaRLC+6
X-Received: by 2002:aa7:87cf:0:b0:8b6:12fd:7286 with SMTP id
 d2e1a72fcca58-8cf8604d889mr607750b3a.58.1795551595957; Tue, 24 Nov 2026
 12:19:55 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <21e45bc3fabb264d05600bfc7c32f1e680c8140a.1795393691.git.lucien.xin@gmail.com>
 <179548328461.3135.7564598888424511077@kernel.org>
In-Reply-To: <179548328461.3135.7564598888424511077@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 24 Nov 2026 15:19:44 -0500
X-Gm-Features: Aa3M54rfVVIoS2yfErEj9uGMU9IT79u6PyZ7COn7zv9bV2E6axQ8BLvwPXukCPQ
Message-ID: <CADvbK_cRwWH6xLeQa6HwnTMTAfpo-h1CSyP3LJW+oxLvVvtUgQ@mail.gmail.com>
Subject: Re: [PATCH net-next v19 12/15] quic: add crypto packet encryption and decryption
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
> Thank you for your contribution! Sashiko AI review found 3 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 1 =C2=B7 Medium: 1 =C2=B7 Low: 1
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [High] quic: missing packet number decode on backlog retry in
>   quic_crypto_decrypt()
> - [Medium] Retry and NEW_TOKEN tokens now carry a sequential 64-bit
>   counter in cleartext.
> - [Low] The kernel-doc for quic_crypto_decrypt() says 'Return: 0 on
>   success, -EINPROGRESS for async operation, or negative error.' It also=
=E2=80=A6
>
> --
>
> quic: add crypto packet encryption and decryption
>
> This patch adds AEAD payload protection and QUIC header protection for
> the TX and RX paths through quic_crypto_encrypt() and
> quic_crypto_decrypt(). It also adds Retry integrity tag computation and
> helpers to generate and verify Retry and address validation tokens.
>
> > diff --git a/net/quic/crypto.c b/net/quic/crypto.c
> > index c28c6fa565c1a..ccb1050921c34 100644
> > --- a/net/quic/crypto.c
> > +++ b/net/quic/crypto.c
> > @@ -269,6 +270,485 @@ ciphers[QUIC_CIPHER_MAX + 1 - QUIC_CIPHER_MIN] =
=3D {
>
> [ ... ]
>
> > +/* Decrypts a QUIC packet after reception.  This function removes head=
er
> > + * protection, decrypts the payload, and processes any key updates if =
the key
> > + * phase bit changes.
> > + *
> > + * Return: 0 on success, -EINPROGRESS for async operation, or negative=
 error.
> > + */
> > +int quic_crypto_decrypt(struct quic_crypto *crypto, struct sk_buff *sk=
b,
> > +                     gfp_t gfp)
> > +{
>
> [Severity: Low]
> Is this return documentation complete? quic_crypto_decrypt() also returns
> several negative values that act as control signals rather than ordinary
> drop-the-packet errors:
>
>         if (!cb->backlog) /* Key update requires process context. */
>                 return -EKEYREVOKED;
>         /* Cannot do key update while async crypto is in progress. */
>         if (unlikely(atomic_read(&crypto->async_pending[phase])))
>                 return -EBUSY;
>         ...
> err:
>         if (err =3D=3D -EBADMSG && ++crypto->rx_fails >=3D crypto->cipher=
->rxlimit)
>                 err =3D -EKEYEXPIRED;
>
> -EKEYREVOKED defers the key update to process context. -EBUSY is a
> transient retry-later result. -EKEYEXPIRED means the integrity limit was
> reached, and RFC 9001 section 6.6 requires the connection to be closed.
>
> The text "processes any key updates if the key phase bit changes" also
> doesn't hold for the -EKEYREVOKED and -EBUSY cases. In both, the key upda=
te
> is postponed.
>
> quic_crypto_encrypt() has the same gap for its confidentiality limit:
>
>         if (crypto->tx_count[cb->key_phase] >=3D crypto->cipher->txlimit)
>                 return -EKEYEXPIRED;
>
> Could these return values be documented, so that the callers added later =
in
> the series know which ones need more than a plain drop? A caller that dro=
ps
> on every negative return would lose key-update packets that arrive outsid=
e
> backlog context.
>
> [ ... ]
>
> > @@ -566,6 +1046,257 @@ int quic_crypto_initial_keys_install(struct quic=
_crypto *crypto,
>
> [ ... ]
>
> > +int quic_crypto_generate_token(struct quic_crypto *crypto, void *addr,
> > +                            u32 addrlen, struct quic_conn_id *conn_id,
> > +                            u8 *token, u32 *tlen)
> > +{
>
> [ ... ]
>
> > +     /* Use counter for nonce derivation to prevent collisions. */
> > +     counter =3D crypto->tx_count[1]++;
> > +     p =3D token_buf;
> > +     p =3D quic_put_int(p, flag, sizeof(flag));
> > +     p =3D quic_put_int(p, counter, sizeof(counter));
> > +     p =3D quic_put_int(p, ts, tslen);
> > +     p =3D quic_put_data(p, addr, addrlen);
> > +     quic_put_data(p, conn_id->data, conn_id->len);
> > +
> > +     err =3D quic_crypto_token_protect(crypto, token_buf, len,
> > +                                     sizeof(flag) + sizeof(counter), t=
rue);
>
> [Severity: Medium]
> Does this put a linkable sequence number in cleartext into every token?
>
> The counter occupies token bytes 1-8. quic_crypto_token_protect() uses it
> only as AAD and as nonce input (adlen =3D 1 + 8), so it is never encrypte=
d.
> quic_crypto_set_token_secret() seeds it only once per crypto instance:
>
>         get_random_bytes(&crypto->tx_count[1], sizeof(crypto->tx_count[1]=
));
>
> As a result, successive tokens from the same issuer carry X, X+1, X+2, an=
d
> so on in the clear.
>
> Clients send these tokens back in cleartext Initial packets. Suppose a
> server issues several NEW_TOKEN tokens on one connection, and the client
> uses each one on a separate later connection, as RFC 9000 section 8.1.3
> asks in order to avoid linking. An on-path observer could still group tho=
se
> connections by their adjacent counter values.
>
> For a listener that issues Retry tokens, the gap between two observed
> counters also shows how many tokens were issued in between.
>
> The v18 changelog moved the timestamp into the encrypted payload "to
> prevent exposing server uptime and linking NEW_TOKEN tokens to their
> issuing connections".
>
> Would a random per-token nonce stored in the token, or a nonce input that
> isn't visible on the wire, keep nonces unique without adding a new linkab=
le
> cleartext field?
>
> [ ... ]
>
> > @@ -269,6 +270,485 @@ ciphers[QUIC_CIPHER_MAX + 1 - QUIC_CIPHER_MIN] =
=3D {
> >                   QUIC_AEAD_TX_CHACHA, QUIC_AEAD_RX_CHACHA),
> >  };
> >
> > +static bool quic_crypto_is_cipher_ccm(struct quic_crypto *crypto)
> > +{
> > +     return crypto->cipher_type =3D=3D TLS_CIPHER_AES_CCM_128;
> > +}
> > +
> > +static bool quic_crypto_is_cipher_chacha(struct quic_crypto *crypto)
> > +{
> > +     return crypto->cipher_type =3D=3D TLS_CIPHER_CHACHA20_POLY1305;
> > +}
> > +
> > +static void *quic_crypto_skcipher_mem_alloc(struct crypto_skcipher *tf=
m,
> > +                                         u32 mask_size, u8 **iv,
> > +                                         struct skcipher_request **req=
,
> > +                                         gfp_t gfp)
> > +{
> > +     unsigned int iv_size, req_size;
> > +     unsigned int len;
> > +     u8 *mem;
> > +
> > +     iv_size =3D crypto_skcipher_ivsize(tfm);
> > +     req_size =3D sizeof(**req) + crypto_skcipher_reqsize(tfm);
> > +
> > +     len =3D mask_size;
> > +     len +=3D iv_size;
> > +     len +=3D crypto_skcipher_alignmask(tfm) &
> > +            ~(crypto_tfm_ctx_alignment() - 1);
> > +     len =3D ALIGN(len, crypto_tfm_ctx_alignment());
> > +     len +=3D req_size;
> > +
> > +     mem =3D kzalloc(len, gfp);
> > +     if (!mem)
> > +             return NULL;
> > +
> > +     *iv =3D (u8 *)PTR_ALIGN(mem + mask_size,
> > +                           crypto_skcipher_alignmask(tfm) + 1);
> > +     *req =3D (struct skcipher_request *)PTR_ALIGN(*iv + iv_size,
> > +                                                 crypto_tfm_ctx_alignm=
ent());
> > +
> > +     return (void *)mem;
> > +}
> > +
> > +/* Extracts and reconstructs the packet number from an incoming QUIC p=
acket. */
> > +static int quic_crypto_get_number(struct sk_buff *skb)
> > +{
> > +     struct quic_skb_cb *cb =3D QUIC_SKB_CB(skb);
> > +     s64 number_max =3D cb->number;
> > +     u32 len =3D cb->length;
> > +     u8 *p;
> > +
> > +     /* rfc9000#section-17.1:
> > +      *
> > +      * Once header protection is removed, the packet number is decode=
d by
> > +      * finding the packet number value that is closest to the next ex=
pected
> > +      * packet. The next expected packet is the highest received packe=
t
> > +      * number plus one.
> > +      */
> > +     p =3D (u8 *)quic_hdr(skb) + cb->number_offset;
> > +     if (!quic_get_int(&p, &len, &cb->number, cb->number_len))
> > +             return -EINVAL;
> > +     cb->number =3D quic_get_num(number_max, cb->number, cb->number_le=
n);
> > +     return 0;
> > +}
> > +
> > +#define QUIC_SAMPLE_LEN              16
> > +
> > +#define QUIC_HEADER_FORM_BIT 0x80
> > +#define QUIC_LONG_HEADER_MASK        0x0f
> > +#define QUIC_SHORT_HEADER_MASK       0x1f
> > +
> > +/* Header Protection. */
> > +static int quic_crypto_header_protect(struct quic_crypto *crypto,
> > +                                   struct sk_buff *skb, bool enc, gfp_=
t gfp)
> > +{
> > +     struct quic_skb_cb *cb =3D QUIC_SKB_CB(skb);
> > +     u8 *mask, *iv, *p, h_mask, chacha;
> > +     struct skcipher_request *req;
> > +     struct crypto_skcipher *tfm;
> > +     struct sk_buff *trailer;
> > +     struct scatterlist sg;
> > +     int err, i;
> > +
> > +     chacha =3D quic_crypto_is_cipher_chacha(crypto);
> > +     if (!enc) {
> > +             tfm =3D crypto->rx_hp_tfm;
> > +             if (cb->length < QUIC_PN_MAX_LEN + QUIC_SAMPLE_LEN)
> > +                     return -EINVAL;
> > +
> > +             err =3D skb_cow_data(skb, 0, &trailer);
> > +             if (err < 0)
> > +                     return err;
> > +     } else {
> > +             tfm =3D crypto->tx_hp_tfm;
> > +     }
> > +
> > +     mask =3D quic_crypto_skcipher_mem_alloc(tfm, QUIC_SAMPLE_LEN, &iv=
, &req,
> > +                                           gfp);
> > +     if (!mask)
> > +             return -ENOMEM;
> > +
> > +     /* rfc9001#section-5.4.2: Header Protection Sample:
> > +      *
> > +      *   # pn_offset is the start of the Packet Number field.
> > +      *   sample_offset =3D pn_offset + 4
> > +      *
> > +      *   sample =3D packet[sample_offset..sample_offset+sample_length=
]
> > +      *
> > +      * rfc9001#section-5.4.3: AES-Based Header Protection:
> > +      *
> > +      *   header_protection(hp_key, sample):
> > +      *     mask =3D AES-ECB(hp_key, sample)
> > +      *
> > +      * rfc9001#section-5.4.4: ChaCha20-Based Header Protection:
> > +      *
> > +      *   header_protection(hp_key, sample):
> > +      *     counter =3D sample[0..3]
> > +      *     nonce =3D sample[4..15]
> > +      *     mask =3D ChaCha20(hp_key, counter, nonce, {0,0,0,0,0})
> > +      */
> > +     p =3D skb->data + cb->number_offset + QUIC_PN_MAX_LEN;
> > +     memcpy((chacha ? iv : mask), p, QUIC_SAMPLE_LEN);
> > +     sg_init_one(&sg, mask, QUIC_SAMPLE_LEN);
> > +     skcipher_request_set_tfm(req, tfm);
> > +     skcipher_request_set_crypt(req, &sg, &sg, QUIC_SAMPLE_LEN, iv);
> > +     err =3D crypto_skcipher_encrypt(req);
> > +     if (err)
> > +             goto out;
> > +
> > +     /* rfc9001#section-5.4.1:
> > +      *
> > +      * mask =3D header_protection(hp_key, sample)
> > +      *
> > +      * pn_length =3D (packet[0] & 0x03) + 1
> > +      * if (packet[0] & 0x80) =3D=3D 0x80:
> > +      *    # Long header: 4 bits masked
> > +      *    packet[0] ^=3D mask[0] & 0x0f
> > +      * else:
> > +      *    # Short header: 5 bits masked
> > +      *    packet[0] ^=3D mask[0] & 0x1f
> > +      *
> > +      * # pn_offset is the start of the Packet Number field.
> > +      * packet[pn_offset:pn_offset+pn_length] ^=3D mask[1:1+pn_length]
> > +      */
> > +     p =3D skb->data;
> > +     h_mask =3D ((*p & QUIC_HEADER_FORM_BIT) =3D=3D QUIC_HEADER_FORM_B=
IT) ?
> > +              QUIC_LONG_HEADER_MASK : QUIC_SHORT_HEADER_MASK;
> > +     *p =3D (u8)(*p ^ (mask[0] & h_mask));
> > +     if (!enc) {
> > +             if (!quic_hdr(skb)->form)
> > +                     cb->key_phase =3D quic_hdr(skb)->key;
> > +             cb->number_len =3D quic_hdr(skb)->pnl + 1;
> > +     }
> > +     p +=3D cb->number_offset;
> > +     for (i =3D 1; i <=3D cb->number_len; i++)
> > +             *p++ ^=3D mask[i];
> > +
> > +     if (!enc)
> > +             err =3D quic_crypto_get_number(skb);
> > +out:
> > +     kfree_sensitive(mask);
> > +     return err;
> > +}
> > +
> > +static void *quic_crypto_aead_mem_alloc(struct crypto_aead *tfm, u32 c=
tx_size,
> > +                                     u8 **iv, struct aead_request **re=
q,
> > +                                     struct scatterlist **sg, u32 nsg,
> > +                                     gfp_t gfp)
> > +{
> > +     unsigned int iv_size, req_size;
> > +     unsigned int len;
> > +     u8 *mem;
> > +
> > +     iv_size =3D crypto_aead_ivsize(tfm);
> > +     req_size =3D sizeof(**req) + crypto_aead_reqsize(tfm);
> > +
> > +     len =3D ctx_size;
> > +     len +=3D iv_size;
> > +     len +=3D crypto_aead_alignmask(tfm) & ~(crypto_tfm_ctx_alignment(=
) - 1);
> > +     len =3D ALIGN(len, crypto_tfm_ctx_alignment());
> > +     len +=3D req_size;
> > +     len =3D ALIGN(len, __alignof__(struct scatterlist));
> > +     len +=3D nsg * sizeof(**sg);
> > +
> > +     mem =3D kzalloc(len, gfp);
> > +     if (!mem)
> > +             return NULL;
> > +
> > +     *iv =3D (u8 *)PTR_ALIGN(mem + ctx_size, crypto_aead_alignmask(tfm=
) + 1);
> > +     *req =3D (struct aead_request *)PTR_ALIGN(*iv + iv_size,
> > +                                             crypto_tfm_ctx_alignment(=
));
> > +     *sg =3D (struct scatterlist *)PTR_ALIGN((u8 *)*req + req_size,
> > +                                           __alignof__(struct scatterl=
ist));
> > +
> > +     return (void *)mem;
> > +}
> > +
> > +static void quic_crypto_done(void *data, int err)
> > +{
> > +     struct sk_buff *skb =3D data;
> > +     struct quic_crypto *crypto;
> > +     struct quic_skb_cb *cb;
> > +
> > +     if (err =3D=3D -EINPROGRESS)
> > +             return;
> > +
> > +     cb =3D QUIC_SKB_CB(skb);
> > +     crypto =3D *(struct quic_crypto **)cb->crypto_ctx;
> > +     atomic_dec(&crypto->async_pending[cb->key_phase]);
> > +
> > +     kfree_sensitive(cb->crypto_ctx);
> > +     cb->crypto_err =3D err;
> > +     cb->crypto_done(skb);
> > +}
> > +
> > +/* AEAD Usage. */
> > +static int quic_crypto_payload_protect(struct quic_crypto *crypto,
> > +                                    struct sk_buff *skb, bool enc, gfp=
_t gfp)
> > +{
> > +     u8 *base_iv, *iv, i, nonce[QUIC_IV_LEN], ccm, phase;
> > +     struct quic_skb_cb *cb =3D QUIC_SKB_CB(skb);
> > +     u32 len, hlen, sglen, nsg;
> > +     struct aead_request *req;
> > +     struct crypto_aead *tfm;
> > +     struct sk_buff *trailer;
> > +     struct scatterlist *sg;
> > +     void *ctx;
> > +     __be64 n;
> > +     int err;
> > +
> > +     ccm =3D quic_crypto_is_cipher_ccm(crypto);
> > +     phase =3D cb->key_phase;
> > +     hlen =3D cb->number_offset + cb->number_len;
> > +     if (enc) {
> > +             tfm =3D crypto->tx_tfm[phase];
> > +             base_iv =3D crypto->tx_iv[phase];
> > +             len =3D skb->len;
> > +             err =3D skb_cow_data(skb, QUIC_TAG_LEN, &trailer);
> > +             if (err < 0)
> > +                     return err;
> > +             pskb_put(skb, trailer, QUIC_TAG_LEN);
> > +             if (!quic_hdr(skb)->form)
> > +                     quic_hdr(skb)->key =3D phase;
> > +             sglen =3D skb->len;
> > +             nsg =3D (u32)err;
> > +     } else {
> > +             tfm =3D crypto->rx_tfm[phase];
> > +             base_iv =3D crypto->rx_iv[phase];
> > +             len =3D cb->length + cb->number_offset;
> > +             if (len - hlen < QUIC_TAG_LEN)
> > +                     return -EINVAL;
> > +             sglen =3D len;
> > +             nsg =3D 1;
> > +     }
> > +
> > +     ctx =3D quic_crypto_aead_mem_alloc(tfm, sizeof(void *), &iv, &req=
, &sg,
> > +                                      nsg, gfp);
> > +     if (!ctx)
> > +             return -ENOMEM;
> > +
> > +     sg_init_table(sg, nsg);
> > +     err =3D skb_to_sgvec(skb, sg, 0, sglen);
> > +     if (err < 0)
> > +             goto out;
> > +
> > +     /* rfc9001#section-5.3:
> > +      *
> > +      * The associated data, A, for the AEAD is the contents of the QU=
IC
> > +      * header, starting from the first byte of either the short or lo=
ng
> > +      * header, up to and including the unprotected packet number.
> > +      *
> > +      * The nonce, N, is formed by combining the packet protection IV =
with
> > +      * the packet number.  The 62 bits of the reconstructed QUIC pack=
et
> > +      * number in network byte order are left-padded with zeros to the=
 size
> > +      * of the IV. The exclusive OR of the padded packet number and th=
e IV
> > +      * forms the AEAD nonce.
> > +      */
> > +     memcpy(nonce, base_iv, QUIC_IV_LEN);
> > +     n =3D cpu_to_be64(cb->number);
> > +     for (i =3D 0; i < sizeof(n); i++)
> > +             nonce[QUIC_IV_LEN - sizeof(n) + i] ^=3D ((u8 *)&n)[i];
> > +
> > +     /* For CCM based ciphers, first byte of IV is a constant. */
> > +     iv[0] =3D TLS_AES_CCM_IV_B0_BYTE;
> > +     memcpy(&iv[ccm], nonce, QUIC_IV_LEN);
> > +     aead_request_set_tfm(req, tfm);
> > +     aead_request_set_ad(req, hlen);
> > +     aead_request_set_crypt(req, sg, sg, len - hlen, iv);
> > +     if (cb->sync) {
> > +             DECLARE_CRYPTO_WAIT(wait);
> > +
> > +             aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG=
,
> > +                                       crypto_req_done, &wait);
> > +             err =3D enc ? crypto_aead_encrypt(req) : crypto_aead_decr=
ypt(req);
> > +             if (err =3D=3D -EINPROGRESS || err =3D=3D -EBUSY)
> > +                     err =3D crypto_wait_req(err, &wait);
> > +             goto out;
> > +     }
> > +
> > +     aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> > +                               quic_crypto_done, skb);
> > +     *(struct quic_crypto **)ctx =3D crypto;
> > +     atomic_inc(&crypto->async_pending[phase]);
> > +     cb->crypto_ctx =3D ctx; /* Async free context for quic_crypto_don=
e() */
> > +     err =3D enc ? crypto_aead_encrypt(req) : crypto_aead_decrypt(req)=
;
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
> > + * Return: 0 on success, -EINPROGRESS for async operation, or negative=
 error.
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
> > +     if (cb->resume) {
> > +             err =3D cb->crypto_err;
> > +             if (err)
> > +                     return err;
> > +             goto out;
> > +     }
> > +
> > +     cb->key_phase =3D crypto->key_phase;
> > +     if (crypto->tx_count[cb->key_phase] >=3D crypto->cipher->txlimit)
> > +             return -EKEYEXPIRED;
> > +     crypto->tx_count[cb->key_phase]++;
> > +     err =3D quic_crypto_payload_protect(crypto, skb, true, gfp);
> > +     if (err)
> > +             return err;
> > +out:
> > +     err =3D quic_crypto_header_protect(crypto, skb, true, gfp);
> > +     if (err)
> > +             return err;
> > +     /* If a key update is pending and this is the first packet using =
the
> > +      * new key, save the current time. Later used to clear old keys a=
fter
> > +      * some time has passed (see quic_crypto_decrypt()).
> > +      */
> > +     if (crypto->key_pending && !crypto->key_update_send_time &&
> > +         cb->key_phase =3D=3D crypto->key_phase)
> > +             crypto->key_update_send_time =3D quic_ktime_get_us();
> > +     return 0;
> > +}
> > +
> > +/* Decrypts a QUIC packet after reception.  This function removes head=
er
> > + * protection, decrypts the payload, and processes any key updates if =
the key
> > + * phase bit changes.
> > + *
> > + * Return: 0 on success, -EINPROGRESS for async operation, or negative=
 error.
> > + */
> > +int quic_crypto_decrypt(struct quic_crypto *crypto, struct sk_buff *sk=
b,
> > +                     gfp_t gfp)
> > +{
> > +     struct quic_skb_cb *cb =3D QUIC_SKB_CB(skb);
> > +     int err =3D 0;
> > +     u64 time;
> > +     u8 phase;
> > +
> > +     /* Payload was decrypted asynchronously.  Proceed with parsing pa=
cket
> > +      * number and key phase.
> > +      */
> > +     if (cb->resume) {
> > +             err =3D cb->crypto_err;
> > +             if (err) {
> > +                     /* Apply same key_pending cleanup as synchronous =
path to
> > +                      * avoid deadlock in key update state machine.
> > +                      */
> > +                     if (crypto->key_pending &&
> > +                         cb->key_phase !=3D crypto->key_phase) {
> > +                             crypto->key_pending =3D 0;
> > +                             crypto->key_update_time =3D 0;
> > +                             crypto->key_update_send_time =3D 0;
> > +                     }
> > +                     goto err;
> > +             }
> > +             err =3D quic_crypto_get_number(skb);
> > +             if (err)
> > +                     return err;
> > +             goto out;
> > +     }
> > +     if (!cb->number_len) { /* Packet header not yet decrypted. */
> > +             err =3D quic_crypto_header_protect(crypto, skb, false, gf=
p);
> > +             if (err) {
> > +                     pr_debug("%s: hd decrypt err %d\n", __func__, err=
);
> > +                     return err;
> > +             }
> > +     }
> > +
> > +     /* rfc9001#section-6:
> > +      *
> > +      * The Key Phase bit allows a recipient to detect a change in key=
ing
> > +      * material without needing to receive the first packet that trig=
gered
> > +      * the change. An endpoint that notices a changed Key Phase bit u=
pdates
> > +      * keys and decrypts the packet that contains the changed value.
> > +      */
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
> > +
> > +out:
> > +     /* rfc9001#section-6.2:
> > +      *
> > +      * If a packet is successfully processed using the next key and I=
V,
> > +      * then the peer has initiated a key update.
> > +      */
> > +     if (cb->key_update) {
> > +             crypto->key_pending =3D 1;
> > +             crypto->key_derived =3D 0;
> > +             crypto->key_phase =3D !crypto->key_phase;
> > +     }
> > +     /* rfc9001#section-6.1:
> > +      *
> > +      * An endpoint MUST retain old keys until it has successfully
> > +      * unprotected a packet sent using the new keys. An endpoint SHOU=
LD
> > +      * retain old keys for some time after unprotecting a packet sent=
 using
> > +      * the new keys.
> > +      */
> > +     if (crypto->key_pending && cb->key_phase =3D=3D crypto->key_phase=
) {
> > +             time =3D crypto->key_update_send_time;
> > +             if (time &&
> > +                 quic_ktime_get_us() - time >=3D crypto->key_update_ti=
me) {
> > +                     crypto->key_pending =3D 0;
> > +                     crypto->key_update_time =3D 0;
> > +                     crypto->key_update_send_time =3D 0;
> > +             }
> > +     }
> > +     return 0;
> > +err:
> > +     if (err =3D=3D -EBADMSG && ++crypto->rx_fails >=3D crypto->cipher=
->rxlimit)
> > +             err =3D -EKEYEXPIRED;
> > +     return err;
> > +}
> > +
> >  int quic_crypto_set_cipher(struct quic_crypto *crypto, u32 type)
> >  {
> >       const struct quic_cipher *cipher;
>
> [Severity: High]
> What value does cb->number hold when a deferred key-update packet comes
> back into quic_crypto_decrypt() from process context?
>
> On the first pass in softirq context, cb->number_len is still 0. That
> means quic_crypto_header_protect() runs: it removes header protection in
> place, sets cb->key_phase and cb->number_len, and calls
> quic_crypto_get_number(), which overwrites cb->number with the
> reconstructed packet number. The flipped key phase then makes the
> function return -EKEYREVOKED, or -EBUSY while async_pending[phase] is
> non-zero. The packet is then requeued with cb->backlog set.
>
> On the second pass cb->resume is 0 and cb->number_len is non-zero. Header
> protection removal is correctly skipped, but that also skips the only
> call to quic_crypto_get_number() outside the resume branch.
> quic_crypto_payload_protect() then builds the AEAD nonce directly from
> cb->number.
>
> For the cb->resume path, the cover letter says callers reset cb->number
> to the largest previously seen packet number before re-entering, and
> quic_crypto_get_number() decodes it again. Suppose the backlog re-entry
> follows the same caller contract. Then cb->number no longer holds this
> packet's number, the nonce is wrong, and crypto_aead_decrypt() fails
> with -EBADMSG.
False.

For the backlog re-entry, cb->number_len is set and cb->resume is 0,
and neither condition fires, so the already-decoded value is preserved.

I will continue to check these Medium findings tomorrow.

Thanks.

>
> The result would be that every peer-initiated key update whose first
> packet lands in softirq context gets dropped. cb->key_update never takes
> effect, so crypto->key_phase never flips. rx_fails is also incremented
> for a valid packet. Every later packet from the peer under the new phase
> goes through the same defer-and-fail cycle, so the connection stalls
> instead of completing the key update.
>
> Should quic_crypto_decrypt() call quic_crypto_get_number() when
> cb->number_len is already set but cb->resume is not? Or must the caller
> preserve the decoded cb->number across the backlog requeue? If it is the
> latter, could that be documented next to the cb->number field? The two
> re-entry paths would then have opposite contracts for the same field.
>
> --
> Sashiko AI review =C2=B7 https://netdev-ai.bots.linux.dev/sashiko/#/patch=
set/cover.1795393690.git.lucien.xin%40gmail.com
