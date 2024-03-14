Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D7073519;
	Thu, 14 Mar 2024 16:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710433320; cv=none; b=BcDbNK3GGVFmDwbdIGUREpZcAIZm7KkN5KgYczCUjl4gf6vxCSB8GEqSpvYKjSlC+mFn/zkaHCvlIM1HQNlm+w2bBQVa/+gMwQvGJmIv1vgml1kVNXnb8Js2HTZDs9BJ6RwIbWucbrlt/P5VR1WDghGgqloYv5TC7tr0fx9XC/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710433320; c=relaxed/simple;
	bh=QorPhialxJWPZxkjSK6y/hBbtOQitSoiJRUth6qq8/0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WxmzvKYwmpcF0qMcMtU2U+ws8qs6hLaeyFYluPKpAybttvYk8vZvrG5c8VG22bd9M6kPUakE0Aw64DQTXMidTyj5jRWKrXVQL8ZzxnpHGGf9j8hO5MiE3qs0H1rsbQUMQo2RkdSkmSMd3BPlytZ3mdlw8A5kILyah8MoU/CEVew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QM3a+9wA; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QM3a+9wA"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3662fd7ae8cso7853445ab.0;
        Thu, 14 Mar 2024 09:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710433318; x=1711038118; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oVooeOZzJu58LCKX5z87rmVDpoTjxekGbeCuWFZDgzk=;
        b=QM3a+9wAWtaxC5BSDsE2gaagcEy4WkoGrdA0jAPFNoZ2DTIq/+bdDj0YipVKyy+sdk
         +cLvNuLCvVL2VqRQWInOJVocVchM8qWth2hvmn8coh09zxGwxjXyUyFG6Gclq//l/1wD
         ka/xK5puQ/NGTq+3MM2iGiit6SE1LZqj9Ky3rCsPjdlOV90ZU8GMnyMB+RONWSNlS7yD
         dJHCiE6QzbcF4AVRC+o6utPYfQuA3i9/3YIO3U5SvaeUa9NHgr3PKNux7BiVKGFGqZlR
         7/ZYtKfB1GNpB+Oyw4DSnDNmBkwf1SBuYx9VLLaQT4hy+/mFiO/SKZIVGuSpc79CuLzr
         NUWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710433318; x=1711038118;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oVooeOZzJu58LCKX5z87rmVDpoTjxekGbeCuWFZDgzk=;
        b=CE21Bl5ImAOz/jg8vPupQ/vqMWOkYxvA3pb8ftc4zHiyUgjF2eJd22Qku6zGG5/nbc
         SyXXf3tvi5EGHBGKO+C7mryezoqIw+AHzTKehgCHPFz75F5179jimOtlY7SChlI0OtJC
         KVrQJlLSgRaLrAZQEXdjlBfl7L9ioUA+1tBtz0Jgforw6bX6JbTodoBNRYOSNe2LUs82
         oe+gcm8aOugCjuchC+T2lShUED1LlNIWXSk278S6fDcWWJAh9MfjiAr8P5YEilT7Ycln
         KitJ6IQMt8zQswtm+WFH+r9sB1NJzAYbUnTaiTbWIUUGMPLUwRhnl/6ffsXkJtS/FvSH
         /0bw==
X-Forwarded-Encrypted: i=1; AJvYcCVJPFvLvuvxOlqY1YgyjCdi29fhQUZEEIoJc+DD0e1pinqZwGOl5UmHDGiFrbSND0th81/+yecFADQmEgtoDU9TjvaTHCg7UtxwtQ==
X-Gm-Message-State: AOJu0YxSwcGxIRurfhsuUD7O/sItq0VIUyq3J/dAs73c8MS0bM4EAz9W
	0kkFOPKbRx798xVdVb3sHobsa2/jw2B2laBfVQBJxzLjC4gS87DhuVHI8TMR/b2Z8lRMONwf3cr
	wo3Y9DfiPFyoB/gZoIij0/SYOFFk=
X-Google-Smtp-Source: AGHT+IGDOQfbMXteSJoUKpnQXRrN0zK6VvuAkR/1JDNZMM9hJvAGDw7Lp56ZvcnO5Vn681pnZhAYTiMYcBsB50fMDNQ=
X-Received: by 2002:a05:6e02:147:b0:365:cd40:c1e7 with SMTP id
 j7-20020a056e02014700b00365cd40c1e7mr2345848ilr.11.1710433318051; Thu, 14 Mar
 2024 09:21:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1710173427.git.lucien.xin@gmail.com> <74d5db09-6b5c-4054-b9d3-542f34769083@samba.org>
 <CADvbK_dzVcDKsJ9RN9oc0K1Jwd+kYjxgE6q=ioRbVGhJx7Qznw@mail.gmail.com>
 <f427b422-6cfc-45ac-88eb-3e7694168b63@samba.org> <CADvbK_cA-RCLiUUWkyNsS=4OhkWrUWb68QLg28yO2=8PqNuGBQ@mail.gmail.com>
 <438496a6-7f90-403d-9558-4a813e842540@samba.org>
In-Reply-To: <438496a6-7f90-403d-9558-4a813e842540@samba.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 14 Mar 2024 12:21:46 -0400
Message-ID: <CADvbK_fkbOnhKL+Rb+pp+NF+VzppOQ68c=nk_6MSNjM_dxpCoQ@mail.gmail.com>
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

On Thu, Mar 14, 2024 at 5:21=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Am 13.03.24 um 20:39 schrieb Xin Long:
> > On Wed, Mar 13, 2024 at 1:28=E2=80=AFPM Stefan Metzmacher <metze@samba.=
org> wrote:
> >>
> >> Am 13.03.24 um 17:03 schrieb Xin Long:
> >>> On Wed, Mar 13, 2024 at 4:56=E2=80=AFAM Stefan Metzmacher <metze@samb=
a.org> wrote:
> >>>>
> >>>> Hi Xin Long,
> >>>>
> >>>> first many thanks for working on this topic!
> >>>>
> >>> Hi, Stefan
> >>>
> >>> Thanks for the comment!
> >>>
> >>>>> Usage
> >>>>> =3D=3D=3D=3D=3D
> >>>>>
> >>>>> This implementation supports a mapping of QUIC into sockets APIs. S=
imilar
> >>>>> to TCP and SCTP, a typical Server and Client use the following syst=
em call
> >>>>> sequence to communicate:
> >>>>>
> >>>>>           Client                    Server
> >>>>>        ------------------------------------------------------------=
------
> >>>>>        sockfd =3D socket(IPPROTO_QUIC)      listenfd =3D socket(IPP=
ROTO_QUIC)
> >>>>>        bind(sockfd)                       bind(listenfd)
> >>>>>                                           listen(listenfd)
> >>>>>        connect(sockfd)
> >>>>>        quic_client_handshake(sockfd)
> >>>>>                                           sockfd =3D accecpt(listen=
fd)
> >>>>>                                           quic_server_handshake(soc=
kfd, cert)
> >>>>>
> >>>>>        sendmsg(sockfd)                    recvmsg(sockfd)
> >>>>>        close(sockfd)                      close(sockfd)
> >>>>>                                           close(listenfd)
> >>>>>
> >>>>> Please note that quic_client_handshake() and quic_server_handshake(=
) functions
> >>>>> are currently sourced from libquic in the github lxin/quic reposito=
ry, and might
> >>>>> be integrated into ktls-utils in the future. These functions are re=
sponsible for
> >>>>> receiving and processing the raw TLS handshake messages until the c=
ompletion of
> >>>>> the handshake process.
> >>>>
> >>>> I see a problem with this design for the server, as one reason to
> >>>> have SMB over QUIC is to use udp port 443 in order to get through
> >>>> firewalls. As QUIC has the concept of ALPN it should be possible
> >>>> let a conumer only listen on a specif ALPN, so that the smb server
> >>>> and web server on "h3" could both accept connections.
> >>> We do provide a sockopt to set ALPN before bind or handshaking:
> >>>
> >>>     https://github.com/lxin/quic/wiki/man#quic_sockopt_alpn
> >>>
> >>> But it's used more like to verify if the ALPN set on the server
> >>> matches the one received from the client, instead of to find
> >>> the correct server.
> >>
> >> Ah, ok.
> > Just note that, with a bit change in the current libquic, it still
> > allows users to use ALPN to find the correct function or thread in
> > the *same* process, usage be like:
> >
> > listenfd =3D socket(IPPROTO_QUIC);
> > /* match all during handshake with wildcard ALPN */
> > setsockopt(listenfd, QUIC_SOCKOPT_ALPN, "*");
> > bind(listenfd)
> > listen(listenfd)
> >
> > while (1) {
> >    sockfd =3D accept(listenfd);
> >    /* the alpn from client will be set to sockfd during handshake */
> >    quic_server_handshake(sockfd, cert);
> >
> >    getsockopt(sockfd, QUIC_SOCKOPT_ALPN, alpn);
>
> Would quic_server_handshake() call setsockopt()?
Yes, I just made a bit change in the userspace libquic:

  https://github.com/lxin/quic/commit/9c75bd42769a8cbc1652e2f4c8d77780f23af=
de6

So you can set up multple ALPNs on listen sock:

  setsockopt(listenfd, QUIC_SOCKOPT_ALPN, "smbd, h3, ksmbd");

Then during handshake, the matched ALPN from client will be set into
the accept socket, then users can get it later after handshake.

Note that userspace libquic is a very light lib (a couple of hundred lines
of code), you can add more TLS related support without touching Kernel code=
,
including the SNI support you mentioned.

>
> >    switch (alpn) {
> >      case "smbd": smbd_thread(sockfd);
> >      case "h3": h3_thread(sockfd);
> >      case "ksmbd": ksmbd_thread(sockfd);
> >    }
> > }
>
> Ok, but that would mean all application need to be aware of each other,
> but it would be possible and socket fds could be passed to other
> processes.
It doesn't sound common to me, but yes, I think Unix Domain Sockets
can pass it to another process.

>
> >>
> >>> So you expect (k)smbd server and web server both to listen on UDP
> >>> port 443 on the same host, and which APP server accepts the request
> >>> from a client depends on ALPN, right?
> >>
> >> yes.
> > Got you. This can be done by also moving TLS 1.3 message exchange to
> > kernel where we can get the ALPN before looking up the listening socket=
.
> > However, In-kernel TLS 1.3 Handshake had been NACKed by both kernel
> > netdev maintainers and userland ssl lib developers with good reasons.
> >
> >>
> >>> Currently, in Kernel, this implementation doesn't process any raw TLS
> >>> MSG/EXTs but deliver them to userspace after decryption, and the acce=
pt
> >>> socket is created before processing handshake.
> >>>
> >>> I'm actually curious how userland QUIC handles this, considering
> >>> that the UDP sockets('listening' on the same IP:PORT) are used in
> >>> two different servers' processes. I think socket lookup with ALPN
> >>> has to be done in Kernel Space. Do you know any userland QUIC
> >>> implementation for this?
> >>
> >> I don't now, but I guess QUIC is only used for http so
> >> far and maybe dns, but that seems to use port 853.
> >>
> >> So there's no strict need for it and the web server
> >> would handle all relevant ALPNs.
> > Honestly, I don't think any userland QUIC can use ALPN to lookup for
> > different sockets used by different servers/processes. As such thing
> > can be only done in Kernel Space.
> >
> >>
> >>>>
> >>>> So the server application should have a way to specify the desired
> >>>> ALPN before or during the bind() call. I'm not sure if the
> >>>> ALPN is available in cleartext before any crypto is needed,
> >>>> so if the ALPN is encrypted it might be needed to also register
> >>>> a server certificate and key together with the ALPN.
> >>>> Because multiple application may not want to share the same key.
> >>> On send side, ALPN extension is in raw TLS messages created in usersp=
ace
> >>> and passed into the kernel and encoded into QUIC crypto frame and the=
n
> >>> *encrypted* before sending out.
> >>
> >> Ok.
> >>
> >>> On recv side, after decryption, the raw TLS messages are decoded from
> >>> the QUIC crypto frame and then delivered to userspace, so in userspac=
e
> >>> it processes certificate validation and also see cleartext ALPN.
> >>>
> >>> Let me know if I don't make it clear.
> >>
> >> But the first "new" QUIC pdu from will trigger the accept() to
> >> return and userspace (or the kernel helper function) will to
> >> all crypto? Or does the first decryption happen in kernel (before acce=
pt returns)?
> > Good question!
> >
> > The first "new" QUIC pdu will cause to create a 'request sock' (contain=
s
> > 4-tuple and connection IDs only) and queue up to reqsk list of the list=
en
> > sock (if validate_peer_address param is not set), and this pdu is enque=
ued
> > in the inq->backlog_list of the listen sock.
> >
> > When accept() is called, in Kernel, it dequeues the "request sock" from=
 the
> > reqsk list of the listen sock, and creates the accept socket based on t=
his
> > reqsk. Then it processes the pdu for this new accept socket from the
> > inq->backlog_list of the listen sock, including *decrypting* QUIC packe=
t
> > and decoding CRYPTO frame, then deliver the raw/cleartext TLS message t=
o
> > the Userspace libquic.
>
> Ok, when the kernel already decrypts it could already
> look find the ALPN. It doesn't mean it should do the full
> handshake, but parse enough to find the ALPN.
Correct, in-kernel QUIC should only do the QUIC related things,
and all TLS handshake msgs must be handled in Userspace.
This won't cause "layering violation", as Nick Banks said.

>
> But I don't yet understand how the kernel gets the key to
> do the initlal decryption, I'd assume some call before listen()
> need to tell the kernel about the keys.
For initlal decryption, the keys can be derived with the initial packet.
basically, it only needs the dst_connection_id from the client initial
packet. see:

  https://datatracker.ietf.org/doc/html/rfc9001#name-initial-secrets

so we don't need to set up anything to kernel for initial's keys.

But for the handshake, application or early_data keys, they will be set
up into kernel during handshake via:

  setsockopt(QUIC_SOCKOPT_CRYPTO_SECRET)

Thanks.
>
> > Then in Userspace libquic, it handles the received TLS message and crea=
tes
> > a new raw/cleartext TLS message for response via libgnutls, and deliver=
s to
> > kernel. In kernel, it will encode this message to a CRYPTO frame in a Q=
UIC
> > packet and then *encrypt* this QUIC packet and send it out.
> >
> > So as you can see, there's no en/decryption happening in Userspace. In
> > Userspace libquic, it only does raw/cleartext TLS message exchange. ALL
> > en/decryption happens in Kernel Space, as these en/decryption are done
> > against QUIC packets, not directly against the TLS messages.
> >
> >>
> >> Maybe it would be possible to optionally have socket option to
> >> register ALPNs with certificates so that tls_server_hello_x509()
> >> could be called automatically before accept returns (even for
> >> userspace consumers).
> >>
> >> It may mean the tlshd protocol needs to be extended...
> >>
> > so that userspace consumers don't need quic_client/server_handshake(), =
and
> > accept() returns a socket that already has the handshake done, right?
> >
> > We didn't do that, as:
> >
> > 1. It's not a good idea for Userspace consumers' applications to reply =
on
> >     a daemon like tlshd, not convenient for users, also a bit weird for
> >     userspace app to ask another userspace app to help do the handshake=
.
> > 2. It's too complex to implement, especially if we also want to call
> >     tls_client_hello_x509() before connect() returns on client side.
> > 3. For Kernel usage, I prefer leaving this to the kernel consumers for
> >     more flexibility for handshake requests.
> >
> > As for the ALPNs with certificates, not sure if I understand correctly.
> > But if you want the server to select certificates according to the ALPN
> > received from the client during handshake. I think it could be done in
> > userspace libquic. But yes, tlshd service may also need to extend.
>
> I was just brainstorming for ideas...
>
> metze
