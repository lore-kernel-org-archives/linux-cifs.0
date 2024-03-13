Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5D248781;
	Wed, 13 Mar 2024 16:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710345803; cv=none; b=BB4XII1DJ2cgJQAC7+LaX9ZaJsc4ZoWLxOb0xMgyWCMANT5YcWRyGSYbIZs9z9C9QvD1RT3m0XfwfSmLfB1G4BrKGYqpg/kFGO9iMdXa0n+sRZOWCDTUw0cAVM21wz0elIbkktpf2jewFSZxPnxbrnNSCuFrf25dW3N28sotvWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710345803; c=relaxed/simple;
	bh=qbDfXlG++KuOBhHHJkKNDuFE+onQ2w0NR1zwj3a9oMc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kSMRK6c9wd5ABCJHgVEgAOzS3BGh98/sa7q3TOPLqIqy4qpz0e48+0TU5rwwPTnsRbmIdma3wD+T1aOrQyv9UITT9IoSCqRN1On+brJszlfX4FtnIktoERcdP7omyE1+cd5lJ/Q+kAoVww/vDFfTljj93ov1/GIhzIHCh2Q0/qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SqXjh0vZ; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SqXjh0vZ"
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-36576b35951so36858625ab.3;
        Wed, 13 Mar 2024 09:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710345801; x=1710950601; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NyFmyjkVEQMpQUwriMOsNJPA6/CoCjRQUySrWXxJnmE=;
        b=SqXjh0vZebpYF5VrgoUQLxYt9wdcGlaGuxiIClj9V4DGPm48rTgNOzsFzJl6BMdiGq
         IOG9lKu/eI46MKwv53kOv8oeM2RoT+qtpOx7jeUFDON/Rx+F4nrkxVjIGIbVtyrfRgkV
         tGPHaCf4a3tfqwsofmuL2caW8TLk9E/3t6yKLPcrUBXMQU2oj24E4k2i5AVWiEtTYlz5
         2mbZU67qhm4X2tOtz/XGjqJn/Is/3eZHmjJMk9Pl5GvaWabsT/ja7DA9h/bP0JIsLcBI
         M4mHZMdOmjODC+GMfl6oMl/JzFQq9DyYeP/lgArXqSRODdQXtI9NcEHrzOT8yJQwE+Ym
         +RUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710345801; x=1710950601;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NyFmyjkVEQMpQUwriMOsNJPA6/CoCjRQUySrWXxJnmE=;
        b=BVlFRsa4QaAj0epFxbgYrDQWw6lZxIuK1k7ksbGZRfn2WheV7oc19jWXuRrqnfmfFN
         sHws1SEM4k2b+0VSRrpR9ni0U+rv0i+p2MUBJMXzpMHaPl0fGvyqAXYEYUnTC7Ki9886
         aCVoMiEfVd+rkBo16znYYzndKpD9xLaGzg8/NWrjG72vPBfyt1Dk266F5fSZkKQpeAkU
         Jpnyn1j4pQc9+C77tGi6NOcnkb7kpHeW7mVYTpXP4VMruVBSZ6KGhRLI/zJbn3AJ745G
         nIv0SBlmmt3z8yLmEYhI0VYJ6K0Uu2kcfbHiS0JS3elS4bM1nV/uEtnUrsKldokHMopb
         1krw==
X-Forwarded-Encrypted: i=1; AJvYcCVRAbLIOCAk5IZw6g9q0BseXHcbgeE1H7GhCdqh15YmSUmEaHhVfQ8dJ2BnI2o3Ek424G5KTsyY8A9motjGZ7QFiEFwgdreAAwsCA==
X-Gm-Message-State: AOJu0YxOVa5mLMYK1dwxZmrTzhvyIa1VfX323afFt7O1TDGLHozq55DK
	n2OkvO1VkPvjfzILjtYizvErnglZ/F5qLb3ALRxju/g4otmbA5ebSQvwFBBJnYKWYKZWEjiJQHL
	M7heEUqw5F4QHWTu0cC/ZRvtpRUw=
X-Google-Smtp-Source: AGHT+IFHsRmKxkSDcWlHhM7LMx2BlIoDXoViiKIUtHUGspE3tn6pmXJT/sBLxvP7RXC22NNo5Hah1Ik4ERYTI47d+as=
X-Received: by 2002:a05:6e02:12e9:b0:366:7b35:205 with SMTP id
 l9-20020a056e0212e900b003667b350205mr454000iln.8.1710345800599; Wed, 13 Mar
 2024 09:03:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1710173427.git.lucien.xin@gmail.com> <74d5db09-6b5c-4054-b9d3-542f34769083@samba.org>
In-Reply-To: <74d5db09-6b5c-4054-b9d3-542f34769083@samba.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 13 Mar 2024 12:03:09 -0400
Message-ID: <CADvbK_dzVcDKsJ9RN9oc0K1Jwd+kYjxgE6q=ioRbVGhJx7Qznw@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/5] net: In-kernel QUIC implementation with
 Userspace handshake
To: Stefan Metzmacher <metze@samba.org>
Cc: network dev <netdev@vger.kernel.org>, davem@davemloft.net, kuba@kernel.org, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Chuck Lever III <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Sabrina Dubroca <sd@queasysnail.net>, Tyler Fanelli <tfanelli@redhat.com>, 
	Pengtao He <hepengtao@xiaomi.com>, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, 
	Samba Technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 13, 2024 at 4:56=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Hi Xin Long,
>
> first many thanks for working on this topic!
>
Hi, Stefan

Thanks for the comment!

> > Usage
> > =3D=3D=3D=3D=3D
> >
> > This implementation supports a mapping of QUIC into sockets APIs. Simil=
ar
> > to TCP and SCTP, a typical Server and Client use the following system c=
all
> > sequence to communicate:
> >
> >         Client                    Server
> >      ------------------------------------------------------------------
> >      sockfd =3D socket(IPPROTO_QUIC)      listenfd =3D socket(IPPROTO_Q=
UIC)
> >      bind(sockfd)                       bind(listenfd)
> >                                         listen(listenfd)
> >      connect(sockfd)
> >      quic_client_handshake(sockfd)
> >                                         sockfd =3D accecpt(listenfd)
> >                                         quic_server_handshake(sockfd, c=
ert)
> >
> >      sendmsg(sockfd)                    recvmsg(sockfd)
> >      close(sockfd)                      close(sockfd)
> >                                         close(listenfd)
> >
> > Please note that quic_client_handshake() and quic_server_handshake() fu=
nctions
> > are currently sourced from libquic in the github lxin/quic repository, =
and might
> > be integrated into ktls-utils in the future. These functions are respon=
sible for
> > receiving and processing the raw TLS handshake messages until the compl=
etion of
> > the handshake process.
>
> I see a problem with this design for the server, as one reason to
> have SMB over QUIC is to use udp port 443 in order to get through
> firewalls. As QUIC has the concept of ALPN it should be possible
> let a conumer only listen on a specif ALPN, so that the smb server
> and web server on "h3" could both accept connections.
We do provide a sockopt to set ALPN before bind or handshaking:

  https://github.com/lxin/quic/wiki/man#quic_sockopt_alpn

But it's used more like to verify if the ALPN set on the server
matches the one received from the client, instead of to find
the correct server.

So you expect (k)smbd server and web server both to listen on UDP
port 443 on the same host, and which APP server accepts the request
from a client depends on ALPN, right?

Currently, in Kernel, this implementation doesn't process any raw TLS
MSG/EXTs but deliver them to userspace after decryption, and the accept
socket is created before processing handshake.

I'm actually curious how userland QUIC handles this, considering
that the UDP sockets('listening' on the same IP:PORT) are used in
two different servers' processes. I think socket lookup with ALPN
has to be done in Kernel Space. Do you know any userland QUIC
implementation for this?

>
> So the server application should have a way to specify the desired
> ALPN before or during the bind() call. I'm not sure if the
> ALPN is available in cleartext before any crypto is needed,
> so if the ALPN is encrypted it might be needed to also register
> a server certificate and key together with the ALPN.
> Because multiple application may not want to share the same key.
On send side, ALPN extension is in raw TLS messages created in userspace
and passed into the kernel and encoded into QUIC crypto frame and then
*encrypted* before sending out.

On recv side, after decryption, the raw TLS messages are decoded from
the QUIC crypto frame and then delivered to userspace, so in userspace
it processes certificate validation and also see cleartext ALPN.

Let me know if I don't make it clear.

>
> This needs to work indepented of kernel or userspace application.
>
> We may want ksmbd (kernel smb server) and apache or smbd (Samba's userspa=
ce smb server)
> together with apache. And maybe event ksmbd with one certificate for
> ksmbd.example.com and smbd with a certificate for smbd.example.com
> both on ALPN "smb", while apache uses "h3" with a certificate for
> apache.example.com and nginx with "h3" and a certificate for
> nginx.example.com.
>
> But also smbd with "smb" as well as apache with "h3" both using
> a certificate for quic.example.com.
>
> I guess TLS Server Name Indication also works for QUIC, correct?
Yes, QUIC is secured by TLS 1.3, almost all extensions in TLS1.3
are supported in QUIC.

In userspace I believe we can use gnutls_server_name_set() to
set SNI on client and process SNI on server after getting SNI
via gnutls_server_name_get() in .post_client_hello_cb().

I think this would be able to work out the multiple certificates
(with different hostnames) used by one smbd server.
>
> For the client side I guess dynamic udp ports are used and
> there's no problem with multiple applications...
>
Right.

Thanks again for your comment.
