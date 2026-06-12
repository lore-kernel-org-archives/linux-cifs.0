Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173C6369D71
	for <linux-cifs@vger.kernel.org>; Fri, 12 Jun 2026 20:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781295825; cv=pass; b=fdB4lQKpx1HizJOVKfSHz0D2/Amh7yP9lhakTf7Nb3I4CTTN6fLgOLGD1dhe0iVoZI/lpcHcn0CrpgegZfcLrsMoHm+9cBMYcpgyDnP7VRRfsGW8mYawmCjz7RnTmKNJIFJl5Ygd70EtYY7387qgYMEswZyCRiNSJMCiQ5IhF/0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781295825; c=relaxed/simple;
	bh=j+Tw/DqvrvyTXJQnCqEunpYlqcUp4PdtpY9B1mt+aCo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UzHcPVfhz5oYRzCH1jcxUn11Z2g6RfQ/AywgtdPZL+jTAAVolQL2Q8z0EJfGI+mSlblBOgIqErd3szl+OiwxSHaNaHlVYFL2ad9fZqwgdXL1VnkPXaUxEfvlsmOIOIWSR83qWsur3aRjAEFvi/EIPyi0OaKc2nD4wULn9pROqYo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ne5WEkMp; arc=pass smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ne5WEkMp"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-842cd900ee0so679546b3a.2
        for <linux-cifs@vger.kernel.org>; Fri, 12 Jun 2026 13:23:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781295823; cv=none;
        d=google.com; s=arc-20240605;
        b=GmJJALsO1Ferlf+awZchyHzibZbB+cDbQU0NpNhP3jL2SF64W2tVZsndM0obpIbdqj
         lLUF9xBWh7VIGV0KdEMXmaJCB8UEoBlSBfXZHn+yPcnOtRDbgZK0//g7Ouh2nSTz4tUR
         rMvLVF+KKUrExP9TogmBzJ54mZsBLih+OShFHc682r7gQN9XpThtS545UgMXiNUekuHA
         1wDlBw0u6aVdETnVO1fmZGTzLaYCEP2TDh4lTZPBfAk1zO/2uJylq01UWCSESmHgkJok
         1vgU96x6NSWhgvzLAT8/egZcdghs+dORJHLNNChMAZIYLcGlZ6quPwe6vLPqIrZtO86r
         7ARA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=axLJGxYQXY76T7E7LoVtvtvjy73/TjaCst9TPiXrWdM=;
        fh=RXvYvlNLy/eeskB4HHq4OKIMCpOrq/DzO2bW+QXBQXM=;
        b=CmCTuwve9Qa4Akv8Wxf+SsxmYZWYO/ikbFW2PXp0hQ/c2oVz1FfnUGYYuJC95nXZbH
         zWle9nLeuZhFzTdBuAbJXSzZOpgId59HAG+CTNC0fFI7kBXDffBZu2fSDlNGqAZTKog4
         mAOUSvnLqn8joN2+WhWPIoIN6ap94IG/EfDVQ2BoCEu0+av7LBY6UON3a4P1go5elTyb
         scx63WkyJ7hoeSQbIxe+cwvA4DUkBmMv4VmysN07ljlI0o/u5rGJ5cvARfEXcwbGf6RK
         lcJGQ+63iECwhfgCbx8Oj1TTB6gU15c85oShkL2SHNZYOpO7Bd30rBJOmk618fcHDuJJ
         jpew==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781295823; x=1781900623; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=axLJGxYQXY76T7E7LoVtvtvjy73/TjaCst9TPiXrWdM=;
        b=ne5WEkMp2kmHIGyDCQEuxCE9iJdd+2PuOpk7+knCPHt/uv11aD007VGhRwP//3d7SG
         mtcWpN7lUABEK5Mcx56SeTdzR71MEq785NnjESNoWweMHVz1SPPUcPrtgdV71/rIFDrF
         ddBmGvyz7KvdFXACM7Sg9S32MxsZM44nZMGdyRPy5ngHG1afwKCn5IS4YvUbhYS4yAhD
         kjnALOAFzZPhsCUvvCR958hxN+MBK8mzBveCdxs242mBFszO7/6M1KOOU3mLeKv+ob0A
         3lL8as5PYDzhRdDhFUGeic9OCrgUh5JUelItSJDoOz5FA6X8CFyVVgFArOsdRn3zOxrc
         0y7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781295823; x=1781900623;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=axLJGxYQXY76T7E7LoVtvtvjy73/TjaCst9TPiXrWdM=;
        b=rsFgyWQJP8TtgFdTey4zh7vVUnUxIf05fQEdF9Y9c5vjdK9MVyK6JnZvQSDaYlk3Jh
         a9kL3P6P3o10E9pGsbHgeeeV0SWnkVjddLf3m+vEHXKDhcIJqMIBLt1aufH9WtsDZtIw
         x8Ipxo02IwFRCyN7jEcQxo2F+1mMZCTFQemn7baC8v2dNdVHLPNBwcx+B3Jq8dW1XV+E
         O5/xp36NKcbzCKRwMmZxaE6Cr4u0HwazwfwMF/ELIR+h9Yb9nz3TAn+iYH84lyUzuE3J
         2oEPGNz/Wjo6Sg69OJYk5TkRBeZ2HN24gwY6aIq5eduRdGCw4/L4SmKrLZGNSeWsT5uv
         m23Q==
X-Forwarded-Encrypted: i=1; AFNElJ/2+ZQpoGpggLuwec4tr1QrOT6bkHchTCPujdRyWAC3AFKIFPlma/JuXiSUYGZckkz0Dyp2XSW62HBe@vger.kernel.org
X-Gm-Message-State: AOJu0YxPoy6hk0OFd4nYP6YdxZtY/532TmYbq2lIS+eOAVTraC8CSv3t
	rn21ckvVWbH44vDkG9nZLk1XllvIaBp27l2Ints0GhzZZfzQcZoz4sIUV9HXKSejoH+ZGkDu438
	jFzE25UO8+w97eX06SCTQP/WHZ+i+zSM=
X-Gm-Gg: Acq92OEzNaWe/dVRekydObMa654ZWtiQTIR/3X8N0SNQKug8s5SRo/ljnDzaOzd44fz
	p+ARiDrVuVnDEeXVcjbtnxRtIr14gHf0u28PFryp64TScAYBpsJo7t5fm5YF5cEPU0m+HYVkZwO
	vQ2SiiYRGMvcMwEnVmeSLTe9mBeK6NIiqQx27/lNpfqIWQXvZ4TI+TP6mQUqgwuCPNdv4buMPw0
	b5b0/I69vsrkiWPu0KZobFsKTKD2Szln1dGrOnVipv7U3EaCv4BPE/PxKYN48KzWsDxgROUlmS4
	msTBx2vmeJaCk+/t36tn3E3l1vHLQk1W3DRhdQuZ1D2REgs6pvOPnGQzby5f+SVkWeZFFiwtQuh
	YP89RCiJedCofgVua
X-Received: by 2002:a05:6a00:94c3:b0:842:614e:cc97 with SMTP id
 d2e1a72fcca58-8434d07afcemr4940308b3a.23.1781295823460; Fri, 12 Jun 2026
 13:23:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <287e6b7dd877836e08b9bcb6727f547fe80f6459.1780855297.git.lucien.xin@gmail.com>
 <20260611081948.137325-1-pabeni@redhat.com>
In-Reply-To: <20260611081948.137325-1-pabeni@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 12 Jun 2026 16:23:31 -0400
X-Gm-Features: AVVi8CezbNK4UF3r3lp5uUhw4KnTH33E-BGYuPbz2M3O-qwCLN8CyhZyYdcGzpo
Message-ID: <CADvbK_dAvqBC1j-f4Ft_HkLzVOzP-z9cwVR2B36zbxjSB44atg@mail.gmail.com>
Subject: Re: [PATCH net-next v13 12/15] quic: add crypto packet encryption and decryption
To: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, quic@lists.linux.dev, davem@davemloft.net, 
	kuba@kernel.org, edumazet@google.com, horms@kernel.org, metze@samba.org, 
	mbuhl@openbsd.org, tfanelli@redhat.com, hepengtao@xiaomi.com, 
	dreibh@simula.no, linux-cifs@vger.kernel.org, smfrench@gmail.com, 
	linkinjeon@kernel.org, tom@talpey.com, kernel-tls-handshake@lists.linux.dev, 
	chuck.lever@oracle.com, jlayton@kernel.org, steved@redhat.com, hare@suse.de, 
	aahringo@redhat.com, dhowells@redhat.com, matttbe@kernel.org, 
	mail@johnericson.me, xiyou.wangcong@gmail.com, alibuda@linux.alibaba.com, 
	jbaron@akamai.com, illiliti@protonmail.com, sd@queasysnail.net, 
	marcelo.leitner@gmail.com, daniel@haxx.se, andrew.gospodarek@broadcom.com, 
	mef@scarletmail.rutgers.edu, paul@jakma.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 11, 2026 at 4:20=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> From: AI Reviewer <ai@example.com>
>
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> Full review at: https://netdev-ai.bots.linux.dev/sashiko/
> ---
> quic: add crypto packet encryption and decryption
>
> This patch adds AEAD-based packet encryption/decryption helpers, QUIC
> header protection, and Retry/address-validation token generation and
> verification primitives.
>
> > diff --git a/net/quic/crypto.c b/net/quic/crypto.c
> > index c68a0b570c72..77e633096c2a 100644
> > --- a/net/quic/crypto.c
> > +++ b/net/quic/crypto.c
>
> [ ... ]
>
> > +/* Retry Packet Integrity. */
> > +int quic_crypto_get_retry_tag(struct quic_crypto *crypto, struct sk_bu=
ff *skb,
> > +                           struct quic_conn_id *odcid, u32 version, u8=
 *tag)
> > +{
> > +     /* Reuse RX AEAD (phase 1) in Initial crypto. */
> > +     struct crypto_aead *tfm =3D crypto->rx_tfm[1];
> > +     u8 *pseudo_retry, *p, *iv, *key;
> > +     DECLARE_CRYPTO_WAIT(wait);
> > +     struct aead_request *req;
> > +     struct scatterlist *sg;
> > +     u32 plen;
> > +     int err;
> > +
> > +     if (skb->len < QUIC_TAG_LEN)
> > +             return -EINVAL;
>
> [Low]
> The guard rejects skb->len < QUIC_TAG_LEN, but a later comment in the
> same function says:
>
> > +     /* The caller must ensure skb->len > QUIC_TAG_LEN. */
> > +     plen =3D 1 + odcid->len + skb->len - QUIC_TAG_LEN;
>
> Should the check be <=3D QUIC_TAG_LEN, or should the comment say >=3D to
> match the strict-less-than test?
>
> In the boundary case where skb->len =3D=3D QUIC_TAG_LEN, plen becomes
> 1 + odcid->len, and quic_put_data(p, skb->data, skb->len - QUIC_TAG_LEN)
> copies zero bytes, so the integrity tag would be computed over a
> pseudo-packet containing only the ODCID length and ODCID with no actual
> Retry header bytes.  Is that intended?
>
The callers will make sure skb->len > QUIC_TAG_LEN, and the check
(skb->len < QUIC_TAG_LEN) was added to make the last AI happy.

I will change (skb->len <=3D QUIC_TAG_LEN) to match the comment.


> [ ... ]
>
> > +/* Derives a key and IV using HKDF, configures the AEAD transform and =
performs
> > + * AEAD encryption/decryption for the provided token.
> > + */
> > +static int quic_crypto_token_protect(struct quic_crypto *crypto, u8 *t=
oken,
> > +                                  u32 len, u32 adlen, bool enc)
> > +{
> > +     u8 key[TLS_CIPHER_AES_GCM_128_KEY_SIZE], iv[QUIC_IV_LEN], *tiv;
> > +     /* Reuse TX AEAD (phase 1) in Initial crypto. */
> > +     struct crypto_aead *tfm =3D crypto->tx_tfm[1];
> > +     u32 extra =3D enc ? QUIC_TAG_LEN : 0;
> > +     struct quic_data srt =3D {}, k, i;
> > +     DECLARE_CRYPTO_WAIT(wait);
> > +     struct aead_request *req;
> > +     struct scatterlist *sg;
> > +     void *ctx =3D NULL;
> > +     int err;
> > +
> > +     quic_data(&srt, quic_random_data, QUIC_RANDOM_DATA_LEN);
> > +     quic_data(&k, key, TLS_CIPHER_AES_GCM_128_KEY_SIZE);
> > +     quic_data(&i, iv, QUIC_IV_LEN);
> > +     err =3D quic_crypto_keys_derive(crypto->secret_tfm, &srt, &k, &i,=
 NULL,
> > +                                   QUIC_VERSION_V1);
>
> [Critical]
> Can this lead to AES-GCM nonce reuse across all generated tokens?
>
> quic_random_data is a module-global buffer initialized once in
> quic_crypto_init() via get_random_bytes() and never refreshed:
>
>     static u8 quic_random_data[QUIC_RANDOM_DATA_LEN] __read_mostly;
>
> quic_crypto_keys_derive() runs HKDF-Expand-Label over that constant
> secret with constant labels "quic key" and "quic iv", so both the
> derived key and the derived IV are deterministic and identical on every
> invocation of quic_crypto_token_protect().
>
> > +     if (err)
> > +             goto out;
> > +     err =3D crypto_aead_setauthsize(tfm, QUIC_TAG_LEN);
> > +     if (err)
> > +             goto out;
> > +     err =3D crypto_aead_setkey(tfm, key, TLS_CIPHER_AES_GCM_128_KEY_S=
IZE);
> > +     if (err)
> > +             goto out;
> > +     ctx =3D quic_crypto_aead_mem_alloc(tfm, 0, &tiv, &req, &sg, 1);
> > +     if (!ctx) {
> > +             err =3D -ENOMEM;
> > +             goto out;
> > +     }
> > +     memcpy(tiv, iv, QUIC_IV_LEN);
> > +
> > +     sg_init_one(sg, token, len);
> > +     aead_request_set_tfm(req, tfm);
> > +     aead_request_set_ad(req, adlen);
> > +     aead_request_set_crypt(req, sg, sg, len - adlen - extra, tiv);
>
> Every call ends up using the same (K, N) pair under AES-GCM, with no
> per-token random prefix and no packet-number XOR like
> quic_crypto_payload_protect() does via cb->number.
>
> NIST SP 800-38D forbids reuse of (K, N) under GCM; from two valid
> ciphertexts an attacker can recover the GHASH authentication subkey H
> and forge tokens for arbitrary client addresses, which would defeat
> the address validation in quic_crypto_verify_token() and the
> anti-amplification protections in RFC 9000 section 8.
>
> Could a unique per-token nonce be derived (for example from a random
> prefix stored in the token itself), or a nonce-misuse-resistant AEAD
> be used here instead?
>

I currently don't have a better solution for this. we can't have it in the
socket, as even after the socket closes, this quic_random_data is still
needed to validate tokens.

Thanks.

> > +     aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> > +                               crypto_req_done, &wait);
> > +     err =3D enc ? crypto_aead_encrypt(req) : crypto_aead_decrypt(req)=
;
> > +     if (err =3D=3D -EINPROGRESS || err =3D=3D -EBUSY)
> > +             err =3D crypto_wait_req(err, &wait);
> > +
> > +out:
> > +     memzero_explicit(key, sizeof(key));
> > +     memzero_explicit(iv, sizeof(iv));
> > +     kfree_sensitive(ctx);
> > +     return err;
> > +}
>
> [ ... ]
> --
> This is an AI-generated review.
>
