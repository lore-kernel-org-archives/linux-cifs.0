Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.181
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792529759;
	b=cCTPzBhdQ64SwIKHmXh9aJ/Zmz09ulbAhlSc9BCwgCv0jB7vc5vSNEsP2JeGMPXXo34w
	 ZoTaOexmEy4bLZEM50kY6paU6L9wyENS45fdh+0g33SyvH6Ri7m//IIUJsfqIpbgJvrcX
	 RaO9/8MNlcLdy9Hn2LpUl2iZcGZFsIDioxVanjRUN4+wuKdSQd3T2xXzO4t7L8QEAcHd4
	 DvlRCR8Mu0fjEggo97SQDv5kwsYEeJsVeENzAkasID/H9hwIMpj7tSXOy8pBdVaYtf5Tn
	 CE4j2u+0fuXn0BCnfawKUD86bqQlZX9iH72R9wd+/aP3fN7jm7UArrF8Mp36DplcI4g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792529759;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=9va69Z70VDBET6RC2fy59u2Ycvr0LSmJxWPH1bvD2co=;
	b=WhaBkh0rkVhdhYTinNOLKCnU85f7xHS0DTJFo61//Wvpt5eCcCzy/G0FPcGZzCr08zWY
	 XJTN+ZjkYR3a8TnRwuC+dXB7m5jPznHU5rZj+uL0TItB0r+uJWkRCoNp8GCs9nWEWFx+U
	 wNDkINoQmjh4ZIRIGa5ZovZhF46Wi9XaY6XcQCPYeO2t3gzvFiLrB7UaItSPCuEobEk9d
	 8As1P6cuu9oPEZMJn1uRKutUnmz4MSzVWYZP2aHLaIizA7nNGnD8Uo5yOloXyzeZWI2fw
	 +62m0NvrhkMC1LX/E14K2NQWqWo8yULyAfGt9k9jetpn2X3ibi+L0LqGR/Efpx5DRXQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=QrNh3kgc;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.181
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8825A606A31E
	for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 20:55:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8825A606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=QrNh3kgc
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8a06b436dffso16902b3a.3
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 13:55:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792529758; cv=none;
        d=google.com; s=arc-20260327;
        b=IiVGYHTHZLGPLxi+G2hc3U1C2mC9sJM27ynf/mP7bE94m5U/HnWoh/JWWlDr2O2p2P
         XxtVg4CaQ+PDOX041BDWdIR1F5hejAiEgouNJiQ5cviz0hzRvOlUX+5FxXrh6jO1UBMO
         ne1Br+YMzHqV97poFXkW0eSHE6D5vkalX6633ChJjX0s3zbrQIIg1I7DYh2CafeUUqqt
         Vn/G3FVeygymUIhjt/qt5cctjae26FBqqRsgRRvmtfIw2g1XdXxwD4rhLcY0KutFMjg5
         hl6eVCkq1FOo4/XLAFv0kIi9L7uA/dvAHR41UU3sd/+0kl2S9GAv5kIfxZXx4KRM7+/w
         Sk7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9va69Z70VDBET6RC2fy59u2Ycvr0LSmJxWPH1bvD2co=;
        fh=e1V+Cgs4rKgBAXxb/bz+kdgE5osLTT8dZNZib3ngxWo=;
        b=LTn8WJIGzb1V/6LOfl9UpM5EYlwU2SozLwRMLJlIAx5f8yWIe8XeKr7YcX/2fn8fHk
         zt2449aZd0Nm4tvClKEPDbnWlkCx7RZNDZbuxZyRd2v6G2cS4UAPYJCEjIYzTVrTpifj
         C+E6ISHatYQi4Nf8tKirqHGwXfrpJyACslzdogz1x7e18lhmuGd4CdduGS2IxR1u4lpn
         LRhgsWZiOHz0QGbD3PEn07HgYpHy1qlRy1yWlUraV2092BziENP4hf6HLt1MBRuhwnWp
         TJWtz1E5M8Qz4mOA1FUOKwb3P1at+Pb8MENTUWRsTnbMoYNKvaKUgs31HyuhC7r3ReVG
         Zmqg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792529758; x=1793134558; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9va69Z70VDBET6RC2fy59u2Ycvr0LSmJxWPH1bvD2co=;
        b=QrNh3kgcdR/6jLgf7MwS2UZRSkGRoGZhk18YMBsEnRYrGG5nJKu38/qpATYqjQli2M
         BlCzS9dUMi8inZgL5aGyjJ+dQBf842MYTJrRhpJxlNHs2t1yFjMDpHPC2fTAjy7F0O57
         GFqSWT2CpgAxr5SAXS5zLNQMWBQuweohGGNKyIy009mlEGwi+m2Q9Zu9/zvut3wcuPL1
         TrcK7XZqqswCRpvhXdW6PLYomEFiBbocJzkD1yEbaeE+Numo51nFgBTZmU3+oBz9Yp6x
         fcFX1Nc2xS+g/h7UbOcfRwr7UqVol1rCW6bl/KSAtRnXIST4bjOlAJwJfq6wVhUS5Hao
         VVog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792529758; x=1793134558;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9va69Z70VDBET6RC2fy59u2Ycvr0LSmJxWPH1bvD2co=;
        b=Tp+Yvdu7PZTlHD+hFrNSju7d1KIfQKPBF08IMDVNek68ZKugt4wUeq9RSgyeQIqmiE
         zmEZyle01xMnGlRvsx+TcZhkrB5P3MjElx7N/gAnACak7fRxW+XEFnA5CqJgBweVqGlE
         nEzjPglZo2TxeqM4KWIT62NZt1QcUvdZ/ZSCUJWldLXcesb7Pz5/RI5fXOcxNd92Yy3w
         BQgQPCq5g7rcVkq44sIiWJY5aqJZurUPVw4trDiVQr7qF8ORsRh3136n5wHacwFcomjr
         JUVqqQkYtTev0GbC1pqw79ycQi7CFSganKtaUsuwOmCcU2svkzHNCjA74poP++VoumtY
         UC3Q==
X-Forwarded-Encrypted: i=1; AKwUvBz6CG05ZzZ3vPbJzyl43+EjT46tRx35PrGtijc8/fb/0pV0GaK4i6dsaYF9+oPpTl4M24qa9rJkghI2@vger.kernel.org
X-Gm-Message-State: AFq9FYLc1u5nrlMGC1LYnOtpo+Um6knp3hXBqgrmefQ0Iv4LJ1cT3kS7
	bG/XPTugFz/uJJlm8y9dOpKpEkMfHhJtetD4RMBy0bWWttlnalShzfK+3Z48Fx7+1NSo/QA0TNS
	sjEVWAwdOyk8QA3vS7g/KEq2N2yhsuPw=
X-Gm-Gg: AYBFou3HK761rSGWB2H1z3yoHzxaxGnNcELzKvsX43tzatt9Sbo2HfWfjYc7Xj/xC1d
	FugEfxbJp2l7d3LkNSYxwSUr1HUOL58yAGmGp8iaWkr6vis5+q9LwuAc6bGiDIWEf+u3f7Jpomb
	hUqjlDlAm4sO6QaNKXN2DFceMEOjdPxJkQviLz/x/fZlZZackMjtJbCbGEI3kjHGe4zcc3fUEDx
	PTyC6f7WoBU2KTx4Owy67JibkCecYfUD9K9rYMP/JMGnJzoXR0f5zaHe7A7goZvMfoijsPqh1fs
	rux6NV8RdmpYIeSKvJZL2xLy/g5B3JJReUz1NGK3lcE8Uv6BsFj+MLSHwuz6dzxMsqZJ/Y8ybgS
	qZcd/RL8x0bzA+f+nTgFjeKkIzpOiEd1Ln5/9/FMuXbayu3leBVz2WxgiTYTbwTKCz+KovH5p+/
	Ks0Og1ooQW9Ze3vw==
X-Received: by 2002:a05:6a00:4c92:b0:89e:261c:447a with SMTP id
 d2e1a72fcca58-8a089d8f4cdmr110909b3a.7.1792529757792; Tue, 20 Oct 2026
 13:55:57 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <1da72318e969eb252977ccf5d8e3e506c2fa2e69.1792164438.git.lucien.xin@gmail.com>
 <179244540463.3135.17132817693152829356@kernel.org>
In-Reply-To: <179244540463.3135.17132817693152829356@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 20 Oct 2026 16:55:46 -0400
X-Gm-Features: AclHuK_xypNF_3ZupZmQ5gCHrMwwp4u_9BbDfwJ9qW_3NU4_ksSvUmCEVd-BZ04
Message-ID: <CADvbK_d=J7Oq8VQFRYzoxX0YPs26tnJvxE7wMa4hyoe_M5n39A@mail.gmail.com>
Subject: Re: [PATCH net-next v17 11/15] quic: add crypto key derivation and installation
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

On Mon, Oct 19, 2026 at 5:30=E2=80=AFPM <netdev-bot+sashiko@kernel.org> wro=
te:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider.
>
> Critical: 0 =C2=B7 High: 1 =C2=B7 Medium: 0 =C2=B7 Low: 0
>
> If you believe none of the issues are legitimate, please reply to each
> issue of Medium severity or higher and explain why the AI is wrong.
> If any of them are legitimate and you plan to respin, please let patchwor=
k
> know by including "pw-bot: cr" as a separate line at the end of your repl=
y
> (one such reply per series is enough).
>
> - [High] quic_init_sock() (net/quic/socket.c:58) sets sk->sk_destruct =3D
>   quic_sock_destruct.
>
> --
>
> quic: add crypto key derivation and installation
>
> This patch adds quic_crypto, which derives and installs QUIC packet
> protection keys for the Initial, Handshake, 0-RTT and 1-RTT levels. It
> handles key updates and stateless reset token generation. It also adds a
> quic_sock_destruct() callback that frees the per-level crypto transforms
> when the last socket reference goes away.
>
> > diff --git a/net/quic/socket.c b/net/quic/socket.c
> > index 12f0817c8b55f..9b1106a9f5e73 100644
> > --- a/net/quic/socket.c
> > +++ b/net/quic/socket.c
> > @@ -40,10 +40,22 @@ static void quic_write_space(struct sock *sk)
> >       rcu_read_unlock();
> >  }
> >
> > +static void quic_sock_destruct(struct sock *sk)
> > +{
> > +     u8 i;
> > +
> > +     /* Deferred crypto free for async encryption/decryption. */
> > +     for (i =3D 0; i < QUIC_CRYPTO_MAX; i++)
> > +             quic_crypto_free(quic_crypto(sk, i));
>
> [Severity: High]
> Is it safe to free the crypto transforms from sk_destruct, given the
> context it can run in?
>
> sk_destruct runs in whatever context drops the last socket reference.
> Later in this series, several of those contexts are softirq:
>
>   quic_packet_rcv() (UDP encap receive) ends with sock_put(sk)
>   quic_timer_timeout() ends with sock_put(sk)
>   quic_packet_rcv_err() drops its reference with sock_put()
>   quic_packet_xmit() takes a reference per TX skb through
>     skb_set_owner_sk_safe(); sock_efree() releases it on TX completion,
>     usually in NAPI
>
> If the user has already closed the socket, any of these can end up as:
>
>   sock_put()
>     __sk_destruct()
>       quic_sock_destruct()
>         quic_crypto_free()
>           crypto_free_aead()
>             crypto_destroy_tfm()
>               alg->cra_exit()
>
> The AEADs come from crypto_alloc_aead(cipher->aead, 0, 0), so an async
> hardware implementation can be selected. hisi_sec2, for example, register=
s
> both "gcm(aes)" and "ccm(aes)". Its sec_aead_exit() calls
> dma_free_coherent(). Behind an IOMMU that leads to __iommu_dma_free() and
> then vunmap(), which begins with:
>
> mm/vmalloc.c:vunmap() {
>         ...
>         BUG_ON(in_interrupt());
>         ...
> }
>
> Can this hit that BUG when a QUIC socket is destroyed from softirq?
> Listen sockets already hold AEAD transforms in this series, via
> quic_packet_get_alpn()->quic_crypto_initial_keys_install().
>
> macsec hit the same crash and fixed it in commit 6624bba469a3 ("macsec:
> use rcu_work to defer RX SA crypto cleanup out of softirq").
>
> The note about in-flight async requests holding a socket reference covers
> the lifetime of the transforms. It does not cover the context in which
> the free runs.
>
> Would it work to defer the tfm teardown to process context, for example
> with a work item or rcu_work queued from quic_sock_destruct()?
>
True.

Didn't know crypto_free_aead() must be called in process context
due to the async hardware crypto implementation.

I will  defer crypto cleanup to a work thread like quic_udp_sock.

Thanks.
