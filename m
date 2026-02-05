Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D593090FF
	for <linux-cifs@vger.kernel.org>; Thu,  5 Feb 2026 18:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770317773; cv=pass; b=huNvqmdC8Ayhd+Sm4P0BH7oF1cmjJnkQbEGlVgcLMSzgcKH0Q3WbQ8ZkaXgb7kywexgIodemtQZwpQXnp9ZGlUyM8sr/Q4O6EZH2TpPl8axR2iRC6Mu9faexOnfZa6TIiFjVoG3GBu7k0o5qibBeoZbxZnjVIIiquCPOOY0ZrJk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770317773; c=relaxed/simple;
	bh=UTAeTogqMPOzWsl43rYalxijcnMd4QsYh0uYCJzTId8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nz1sGU5clD8KZ3KqvuWwsgDXG9wiI8ZbQKAcGJ1Ot4s6ZtoFY4eAUjUWObSPZvzomATC2TtKr4gIIjNAcJYrYRnaZi4AuE/sqhhJF4knhiGi2x/aH9mmGdeidSYuOtQ5jRZIZWoqYfQvdxnoCD1HrLbjRJN8s8efaTsG4hJX71o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lMv3Zw2a; arc=pass smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lMv3Zw2a"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-35334ea1f98so586928a91.1
        for <linux-cifs@vger.kernel.org>; Thu, 05 Feb 2026 10:56:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770317772; cv=none;
        d=google.com; s=arc-20240605;
        b=fx6whtJNC4lzDJHlg6Z56xTqeor02lFq0mylf1uY1C8XXF8ZTC5EWJYFCbAv+moERz
         ZIrBuhj5aPz7E0zbJ2EniDPm2GUETYU1CmK6o1/pSgr4tn2p39/acCLbEh3HCIRWcbuO
         n0DGu8hbYX9W5JKYJFgYUJgklnjMAiELm2odR7bF21PnxVTQRPmtxPJWwcUEYbEWelM2
         j8wK87KWqnqIJ4TtiPDgJtdBnkCGrse44sc3i6LulywHRUU1MuUw1cIhROY4YDfUPag4
         2WFa2NO8CgAiLqGQsn5Qhqr0GO06ZjLSLqT1hPpQznIyNsif/grTFJLzY25b+RuxL5/9
         Z/JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=80WFsFgkgPBLtk7OvSKjFaYy+3cWwSZUPkBNVljL2Sk=;
        fh=nGlmBadbRzUraubq9vUNCRV6hPsk5MHI3IcGwxBbvYM=;
        b=f1F1NmjAAkZ/1fAWEsjGe6zEcnNkMLdQCl0zW92yZa+HnNfM3/9mFLuiIRZz7M/xI2
         m/2kzhmF8kDg6DHI3qYbtfLMYk/PSKGoWmIDtxKPk5g98TG8V1l+DxTlsBN7C4jageN/
         evF9oha3sowTH8fWcg5h+R3qIYJlzSZ6239y7WpEOl1a5qZKcduR1NCp9p46vKkPhhMs
         QC1yEsYVdvDfXtrh8ELTAadMfHPrpQR7pZyaVch96sirLLUn6FX54zIU1IzgFOROquGR
         s9IF6qA5o8ua9cHhIsNwFisfJfXp8GjOWPnKxk+MbJi1/1hcPFe2RBfmc8yUYiK2zkdA
         ZHnQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770317772; x=1770922572; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=80WFsFgkgPBLtk7OvSKjFaYy+3cWwSZUPkBNVljL2Sk=;
        b=lMv3Zw2a+QeA2cN8eABE/FT4y6vVlCp7pT3IoxX+Bg2ldQLofHOWSVw3WGKQk9i4ht
         nDuvNL/00V/K+mDNEzQ6XapgzytpieQk8+hxXxNudzjLBQHDUhM1d4olkBLORw2H06qK
         CMU1aaCnO1V6pQBfSB8dIdWR6HsP0kXkn/96LuwlMjftJxTnR1OvRdQPJh9b912lenyp
         JpZ1rsxigAdJO5tBdhaKWZ9HfOIdkGbkDhBEoe8mxl/iEyNjaul36l375PlvxuIwr0D7
         MZ81Q/xyWp6seSAdKhPeFCfAISKtQbhIKrtGd6OTzQXsqL4DlL1rcS8ZHtzCa56V4OZ3
         fD/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770317772; x=1770922572;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=80WFsFgkgPBLtk7OvSKjFaYy+3cWwSZUPkBNVljL2Sk=;
        b=dse71iEl3kjfNZEuzaLJbLtX/53ip3FS/ZXEoVaPvNexLQfFBEymC1uJzk4Ms7OYfW
         os8Aff9/QnD+CGnbGrAssYF1TBmioSteS5bgLLyU902NOMNt8HcjlOqGDGwCZFyweiVy
         r3ODoVQDt72l2SipIj2tlcNpGUmKJEnCpCQM0kTwQXgGrNBC2Uu8FY/8o1cEN+E1fhEB
         t/duZWCQG5QFfV7XIhfBy/RmRQ3VKN+rG2QU3WT6nr+Gwv0iCbxjJpoB97OGR2zDg7Wr
         Y99zXRX98TdsjfSW9hsSsua02OUu6wQQa2Qi9zKevJuC80acWCKxcQA7p4alArZM2zKV
         p3fA==
X-Forwarded-Encrypted: i=1; AJvYcCUzbGOjrzWLr537WL27iAtvfIJmG1qH25HVjclhPbJsSF+VBdRhvWXx0TTCVd+Wy2c5WKPPewAUw2zl@vger.kernel.org
X-Gm-Message-State: AOJu0YyFwlhw4n7tSd4/Ne+MuDvFlcEMBprs7Bs8ohjKHdPH0FLYjHH2
	BFvbp+t5cWvxadCeO/nXilnGKnrh7+wwVWwcpF945+aTuFj1Hi7ztaYh/n0ytBs8S+xWRY/gcPg
	fuETJcXUBe/NUOwfjvTRbxTnTapg2SMM=
X-Gm-Gg: AZuq6aIykocgtgGLAXrf3Du32hDVScnAo/uGe7ckdMPC0Y5O4mJivXVy6ZQzMCmqT+2
	mlwVYx6hkOF6oq7RrEP9yXGInKrcqhHcJ8KoplPNztESgGkGZZNKHJRhv1KA5SXrDpKP9K8OWxl
	Y6zQZVc7sVRghdcBW0UbfM3P77gj5IUcQNjHPruTEqcvRr47jlPshTqHl1t04/uNIg2NpezSoul
	eMt4iqGoc/Xs4J6S/BbTHwCnlj/CeV/e0lQrAr4XU8Kl1jLYX8efLev3MINcsRhPERY1UjbBfqT
	693ajRzm3arP8DTcjB/xiYLUbfuA
X-Received: by 2002:a17:90b:3d89:b0:34c:2db6:57a7 with SMTP id
 98e67ed59e1d1-354b3c50bcdmr29630a91.8.1770317772303; Thu, 05 Feb 2026
 10:56:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d3a376cf555e7740330a50d83e6201c9084bff01.1770042461.git.lucien.xin@gmail.com>
 <20260205115518.2195328-1-horms@kernel.org>
In-Reply-To: <20260205115518.2195328-1-horms@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 5 Feb 2026 13:56:01 -0500
X-Gm-Features: AZwV_QhMX6JEvl213fgLGN4KP_FM-9zVeYTAxoLTMPmESDUtW4x9IOxJ01wxKVg
Message-ID: <CADvbK_fsXE6MkgF9KMVThTgsid9Tgkyjrvwyek9NM1jd0KZ4Vg@mail.gmail.com>
Subject: Re: [net-next,v9,06/15] quic: add stream management
To: Simon Horman <horms@kernel.org>
Cc: steved@redhat.com, marcelo.leitner@gmail.com, aahringo@redhat.com, 
	alibuda@linux.alibaba.com, jbaron@akamai.com, hare@suse.de, kuba@kernel.org, 
	tom@talpey.com, linux-cifs@vger.kernel.org, daniel@haxx.se, 
	quic@lists.linux.dev, jlayton@kernel.org, tfanelli@redhat.com, 
	dhowells@redhat.com, linkinjeon@kernel.org, hepengtao@xiaomi.com, 
	pc@manguebit.com, kernel-tls-handshake@lists.linux.dev, 
	illiliti@protonmail.com, xiyou.wangcong@gmail.com, 
	andrew.gospodarek@broadcom.com, mail@johnericson.me, edumazet@google.com, 
	pabeni@redhat.com, matttbe@kernel.org, netdev@vger.kernel.org, 
	smfrench@gmail.com, metze@samba.org, mbuhl@openbsd.org, 
	chuck.lever@oracle.com, dreibh@simula.no, davem@davemloft.net, 
	sd@queasysnail.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 5, 2026 at 6:55=E2=80=AFAM Simon Horman <horms@kernel.org> wrot=
e:
>
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
>
> For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-loca=
l.html
> ---
> quic: add stream management
>
> This patch introduces stream management infrastructure for the QUIC
> protocol, including a hash table for tracking active streams, functions
> for acquiring and releasing streams, and logic for detecting stream
> ID limits.
>
> > diff --git a/net/quic/socket.c b/net/quic/socket.c
> > index b86989080184..d6f25669c693 100644
> > --- a/net/quic/socket.c
> > +++ b/net/quic/socket.c
> > @@ -41,6 +41,9 @@ static int quic_init_sock(struct sock *sk)
> >       sk->sk_write_space =3D quic_write_space;
> >       sock_set_flag(sk, SOCK_USE_WRITE_QUEUE);
> >
> > +     if (quic_stream_init(quic_streams(sk)))
> > +             return -ENOMEM;
>
> If quic_stream_init() fails here, the function returns before calling
> sk_sockets_allocated_inc() and sock_prot_inuse_add() below. However,
> when initialization fails, inet_create() calls sk_common_release() which
> invokes quic_destroy_sock():
>
> quic_init_sock()
>     quic_stream_init() fails
>     return -ENOMEM
>         -> sk_common_release()
>             -> quic_destroy_sock()
>                 -> sk_sockets_allocated_dec()  // underflow
>                 -> sock_prot_inuse_add(..., -1)  // underflow
>
> Can this cause counter underflow since the increments never executed but
> the decrements in quic_destroy_sock() are unconditional?
This is a good catch, will fix it.

Thanks.
>
> > +
> >       WRITE_ONCE(sk->sk_sndbuf, READ_ONCE(sysctl_quic_wmem[1]));
> >       WRITE_ONCE(sk->sk_rcvbuf, READ_ONCE(sysctl_quic_rmem[1]));
> >
> > @@ -52,6 +55,8 @@ static int quic_init_sock(struct sock *sk)
> >
> >  static void quic_destroy_sock(struct sock *sk)
> >  {
> > +     quic_stream_free(quic_streams(sk));
> > +
> >       quic_data_free(quic_ticket(sk));
>
> [ ... ]
