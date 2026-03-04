Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F6B39A04A
	for <linux-cifs@vger.kernel.org>; Wed,  4 Mar 2026 22:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772663536; cv=pass; b=XsbHPt4DYt4d4JO+giBUhwgChdDOyKdteaXq/vTXyaBBMGCQeEbOst1+SeIOt6BaMTVyYA56r0bi+cT9g4GXZyHHdYxj3R9Q5KKg6o8nGxNUDGk0vAVLmnWfrvgSl2QnAFgca2xNgfyaKX8FNcChS9pPp89Z9MjaHV8/nGQxuLo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772663536; c=relaxed/simple;
	bh=KXu//3EBPLrBvO/MghuctSsCjd474Oji/fve+ps6wFU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RUcUdhDF9XkO84UvhqVzVvPTvPGikEuLTkEYQV7tzEGeaFESNkLYEsd1L8JsILP0eFfOv+n7yE3aAIvLTJ3ayVXS7nzNpU4VDq3WSYfu4/kAzo+1AUsE/Y05qtLwaO5yIGhJf3WtercGqlj8fEWtvha+dO3cWpTwkR2gGThp8+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hn5q+uLu; arc=pass smtp.client-ip=209.85.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hn5q+uLu"
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-94ace5d0e39so2199476241.2
        for <linux-cifs@vger.kernel.org>; Wed, 04 Mar 2026 14:32:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772663531; cv=none;
        d=google.com; s=arc-20240605;
        b=NFU3qo5c524n9I030vyf1idtAz0P8ui5TVBY5bWk4yAtZUA4s8HgGY1aC+1S7xlFy4
         hvO5ECnXwwlyFQretFYZ75HCSgLVE6mIVth/dC4TD59VE+2sPBpuIT1Imm0W75LeneFj
         48tIZVgC8+VG0gVVqIfxluX/ga9CUSoVtBEp3b5T/fGt9t7frv4x2sxg7G87y5DQL0ZH
         mK9+Miv/TiPdU0Xqx6UiLJSPEVZYZHdR+m8dSsTtMbKko7OKLTdddrDxsA5mz9up6fOJ
         yVkqSd8obCk238brMTp+GE+ImdN6qYKhTxaBaytZq1qoAmpYj+RxiLzyxYZNW6nT/EKf
         OASw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=z/QRphmRzy8FO2fkKgVz78bs8tUVjsFCxQ1wuKvg3pk=;
        fh=zF0NxwEP/aFb403WlzZP6N97NDPBflyfzv/ex/ztnmI=;
        b=c61Ql40j4Y2Hkoh1tbu6Z3/hYD5JQqm0s0FFX4qzLNHxJu/CEQyhru1j6CExdK82Ip
         pU4DOAjz+sXmZ6alhl4Bony1hjBbzGNAQo5dILkHxVoDDbFiIO6Z1u7AlbO4wsRl2JQc
         IR2SJ7N6LYAjjJOkXnzB7O9elmH7GklhosSX2Pazcqw8JOWKTAGLPFiKEoTFp9yNLcU2
         Vv6ozTXSHmZBFnys30PXs+Ch2gS6ymY+bAdx6KCtvvUHlkSRoS2CzaSYwLVQpEZkxiQg
         8Tv76ZAP6TRHXave/CS7q3jxvCWPRQMeqK0FFoZHi8kvBgP3ME0YsPxH9G6dC404B2ls
         hBWg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772663531; x=1773268331; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z/QRphmRzy8FO2fkKgVz78bs8tUVjsFCxQ1wuKvg3pk=;
        b=hn5q+uLuYQJFI83/xK/Vuu128PMbAr3QfZZ9RqYskdHx245x8xq5+iWEkmBKjXVRTJ
         WMgu7YsrRxEoaT04SPsiQAO4BNr4rw2qasTMDcuDvlB2lrrio59DXa9Zy42U8Qyo+sEg
         9kybkTGGzEzY8rCnsToLHxesJ0/c/bY32aD0UTHti1nMghWOQX9UdqFsNrAoz+5G5kgd
         5JLoXthawmt+qjd3YuC2927ikvctTSg03JTCLemU/R/6MBn2fcw8C/Ywy3q+kkZ4PCSt
         tGLw6mtMxUMk87xaDhplsiyKya22DsSzpQOkvmtujdgqXWrHWaP83wzpJxjJxlwgXpcl
         KPLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772663531; x=1773268331;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z/QRphmRzy8FO2fkKgVz78bs8tUVjsFCxQ1wuKvg3pk=;
        b=oKc7x6mKC6INf4faG67r5sNiylW8xCqkWIzdQB5HouM+yYFDzPny+qCaFPnpAgQw4k
         RuoSC/vJF8YcQfzkjkRkfBuZdkRMrjSpC0xL9YQ9thmEcdr5PlZAPtYAoZ3KsSHJS+Wz
         kT03oJ6gjRiyZM2ht7Vi84c8hexsdLA03jTgjGQERFkRZ6qysSgI1z1UxK8CXVbhXkLa
         r9gKkVIa26g3Nb9RrL4s++iNXAJoV9LA6dOwvftLUcGpti5rwAxqRzxfIL4zYz6WIIVf
         d2IIGnHYqZkzZ6B4cOTOQ344Jyqhpoa4pMs5TceXwrJssdHaEb9iwmTgjFoIlW84/+A+
         +3Rg==
X-Forwarded-Encrypted: i=1; AJvYcCV6tekIiIPcICnZL/8PjnKBGGM89u/+y2GIdZa8314OWEKseYW7VNPd1EOChyOF/5A8X9QWCq5MMh3H@vger.kernel.org
X-Gm-Message-State: AOJu0YyXKXADMywVq/GMvT/SDpYONnX40nZLpbuZbv2fsFxk1ckCqtr8
	5J+d/5OAsPfmo2Zy6hyZmXS3tDkB7ZqD/An2cefXbKDnO9REYHR6jfbRCIfPqUmrCVPe2ej5Oc1
	Wb862510yZ8g3B7cRqRnORRzPrWF/QVw=
X-Gm-Gg: ATEYQzzqcy2B69pX6mwM5RseJsYcskFr5S7wtA+W0cX+XgNOfzcLUjRZvsWM6R7EdRF
	hB3nh/eusOcXt2bexbQswoHFK60Ff3hJcJl679gDRGvI4lBPJ4iXok3QZwn2Ob37x2jpPsi3mNo
	8SI07iCF/9YhiD/v7c82gFYxE43ajt7SrEgDpAC5KmaFIQ/4J1bwzgB0r7nWibR01OzoxU7ZtM3
	ezQJnUgBdKTQQtGJDegZx1M0Hd7v4fAA3hpZjVd1fZXVE/1PTNAMjt49mwOZQXXyAXZ0pPtBuKM
	HJwWXzmRiz4HnD61hQn4tVkmwJgzhi7FUkDUvntEH84yBySGL4nepsz11y054FQRqts8XiUPkJB
	zw3z19g==
X-Received: by 2002:a05:6102:b0d:b0:5f8:e2c7:a3f2 with SMTP id
 ada2fe7eead31-5ffaa6f6c3bmr1576946137.0.1772663530592; Wed, 04 Mar 2026
 14:32:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <3c6ae7299c2fff0fa689d4dcd43ef916e5697d65.1771986861.git.lucien.xin@gmail.com>
 <20260303083255.35354-1-pabeni@redhat.com>
In-Reply-To: <20260303083255.35354-1-pabeni@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 4 Mar 2026 17:31:57 -0500
X-Gm-Features: AaiRm51Y186obU2AYuGIwk5fISUHhxMUkh7jtjQG4bgQBZwaKmERG0jYjFiCfpA
Message-ID: <CADvbK_fHhrCh-5zPDY1sh16TEKhJTWhZcUS4-pw=49krocV3SA@mail.gmail.com>
Subject: Re: [net-next,v10,12/15] quic: add crypto packet encryption and decryption
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
> quic: add crypto packet encryption and decryption
>
> This patch adds core support for packet-level encryption and decryption
> using AEAD, including both payload protection and QUIC header protection.
> It introduces helpers to encrypt and decrypt packets for secure QUIC
> packet exchange and address validation.
>
> > diff --git a/net/quic/crypto.c b/net/quic/crypto.c
> > index a9de418e604e..a84fd8d7bf93 100644
> > --- a/net/quic/crypto.c
> > +++ b/net/quic/crypto.c
>
> [ ... ]
>
> > @@ -231,6 +562,137 @@ static struct quic_cipher ciphers[QUIC_CIPHER_MAX=
 + 1 - QUIC_CIPHER_MIN] =3D {
>
> [ ... ]
>
> > +/* Encrypts a QUIC packet before transmission.  This function performs=
 AEAD encryption of
> > + * the packet payload and applies header protection. It handles key ph=
ase tracking and key
> > + * update timing.
> > + *
> > + * Return: 0 on success, or a negative error code.
> > + */
> > +int quic_crypto_encrypt(struct quic_crypto *crypto, struct sk_buff *sk=
b)
> > +{
> > +     u8 *iv, cha, ccm, phase =3D crypto->key_phase;
> > +     struct quic_skb_cb *cb =3D QUIC_SKB_CB(skb);
> > +     int err;
> > +
> > +     cb->key_phase =3D phase;
> > +     iv =3D crypto->tx_iv[phase];
> > +     /* Packet payload is already encrypted (e.g., resumed from async)=
, proceed to header
> > +      * protection only.
> > +      */
> > +     if (cb->resume)
> > +             goto out;
> > +
> > +     /* If a key update is pending and this is the first packet using =
the new key, save the
> > +      * current time. Later used to clear old keys after some time has=
 passed (see
> > +      * quic_crypto_decrypt()).
> > +      */
> > +     if (crypto->key_pending && !crypto->key_update_send_time)
> > +             crypto->key_update_send_time =3D quic_ktime_get_us();
> > +
> > +     ccm =3D quic_crypto_is_cipher_ccm(crypto);
> > +     err =3D quic_crypto_payload_encrypt(crypto->tx_tfm[phase], skb, i=
v, ccm);
> > +     if (err)
> > +             return err;
> > +out:
> > +     cha =3D quic_crypto_is_cipher_chacha(crypto);
> > +     return quic_crypto_header_encrypt(crypto->tx_hp_tfm, skb, cha);
> > +}
>
> This function calls quic_crypto_payload_encrypt(). Looking at that
> function:
>
> > +/* AEAD Usage. */
> > +static int quic_crypto_payload_encrypt(struct crypto_aead *tfm, struct=
 sk_buff *skb,
> > +                                    u8 *tx_iv, bool ccm)
> > +{
> > +     struct quic_skb_cb *cb =3D QUIC_SKB_CB(skb);
> > +     u8 *iv, i, nonce[QUIC_IV_LEN];
> > +     struct aead_request *req;
> > +     struct sk_buff *trailer;
> > +     struct scatterlist *sg;
> > +     struct quichdr *hdr;
> > +     u32 nsg, hlen, len;
> > +     void *ctx;
> > +     __be64 n;
> > +     int err;
> > +
> > +     len =3D skb->len;
> > +     err =3D skb_cow_data(skb, QUIC_TAG_LEN, &trailer);
> > +     if (err < 0)
> > +             return err;
> > +     nsg =3D (u32)err;
> > +     pskb_put(skb, trailer, QUIC_TAG_LEN);
> > +     hdr =3D quic_hdr(skb);
> > +     hdr->key =3D cb->key_phase;
> > +
> > +     ctx =3D quic_crypto_aead_mem_alloc(tfm, 0, &iv, &req, &sg, nsg);
> > +     if (!ctx)
> > +             return -ENOMEM;
>
> If the kzalloc(GFP_ATOMIC) inside quic_crypto_aead_mem_alloc() fails,
> this returns -ENOMEM without rolling back the SKB modifications. The
> SKB is now permanently enlarged by QUIC_TAG_LEN (16 bytes) with a
> modified hdr->key.
>
> Compare with quic_crypto_payload_decrypt():
>
> > +static int quic_crypto_payload_decrypt(struct crypto_aead *tfm, struct=
 sk_buff *skb,
> > +                                    u8 *rx_iv, bool ccm)
> > +{
> > +     struct quic_skb_cb *cb =3D QUIC_SKB_CB(skb);
> > +     u8 *iv, i, nonce[QUIC_IV_LEN];
> > +     struct aead_request *req;
> > +     int nsg, hlen, len, err;
> > +     struct scatterlist *sg;
> > +     void *ctx;
> > +     __be64 n;
> > +
> > +     len =3D cb->length + cb->number_offset;
> > +     hlen =3D cb->number_offset + cb->number_len;
> > +     if (len - hlen < QUIC_TAG_LEN)
> > +             return -EINVAL;
> > +     nsg =3D 1; /* skb is already linearized in quic_packet_rcv(). */
> > +     ctx =3D quic_crypto_aead_mem_alloc(tfm, 0, &iv, &req, &sg, nsg);
> > +     if (!ctx)
> > +             return -ENOMEM;
> > +
> > +     sg_init_table(sg, nsg);
> > +     err =3D skb_to_sgvec(skb, sg, 0, len);
>
> In the decrypt path, quic_crypto_aead_mem_alloc() is called before any
> SKB modifications. Should quic_crypto_payload_encrypt() do the same to
> avoid leaving the SKB in a modified state if allocation fails?
>
This is not true.

- firstly, on RX or Decrypt path, skb_cow_data() is called in
quic_crypto_header_decrypt(), which is called before
quic_crypto_payload_decrypt() in quic_crypto_decrypt(), so
skb_cow_data() is called before mem_alloc for both places.

- secondly, even if the mem_alloc is failed, the skb will be dropped,
no issue could be caused.

> [ ... ]
>
> > +     /* Similar logic to quic_crypto_payload_encrypt(). */
> > +     memcpy(nonce, rx_iv, QUIC_IV_LEN);
> > +     n =3D cpu_to_be64(cb->number);
> > +     for (i =3D 0; i < sizeof(n); i++)
> > +             nonce[QUIC_IV_LEN - sizeof(n) + i] ^=3D ((u8 *)&n)[i];
>
> This isn't a bug, but there's duplicated logic between
> quic_crypto_payload_encrypt() and quic_crypto_payload_decrypt(). The
> AEAD nonce construction sequence (memcpy nonce from IV, XOR with be64
> packet number, set CCM byte) appears in both functions.
>
> In quic_crypto_payload_encrypt():
>
> > +     hlen =3D cb->number_offset + cb->number_len;
> > +     memcpy(nonce, tx_iv, QUIC_IV_LEN);
> > +     n =3D cpu_to_be64(cb->number);
> > +     for (i =3D 0; i < sizeof(n); i++)
> > +             nonce[QUIC_IV_LEN - sizeof(n) + i] ^=3D ((u8 *)&n)[i];
> > +
> > +     /* For CCM based ciphers, first byte of IV is a constant. */
> > +     iv[0] =3D TLS_AES_CCM_IV_B0_BYTE;
> > +     memcpy(&iv[ccm], nonce, QUIC_IV_LEN);
>
> And in quic_crypto_payload_decrypt():
>
> > +     /* Similar logic to quic_crypto_payload_encrypt(). */
> > +     memcpy(nonce, rx_iv, QUIC_IV_LEN);
> > +     n =3D cpu_to_be64(cb->number);
> > +     for (i =3D 0; i < sizeof(n); i++)
> > +             nonce[QUIC_IV_LEN - sizeof(n) + i] ^=3D ((u8 *)&n)[i];
> > +
> > +     iv[0] =3D TLS_AES_CCM_IV_B0_BYTE;
> > +     memcpy(&iv[ccm], nonce, QUIC_IV_LEN);
>
> The AEAD request teardown pattern (EINPROGRESS check, kfree_sensitive,
> memzero_explicit) is also duplicated. Would a shared static helper for
> nonce construction reduce the risk of the two copies diverging during
> maintenance?
>
I will see what I can do to dedup a bit for this.

Thanks.
