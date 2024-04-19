Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44AFD130A5B;
	Fri, 19 Apr 2024 18:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713550161; cv=none; b=JsqX0dR4mAGKP12nVmBMEqy/22KudAP0fgU+x4wzT6TgtZWSBspoK2r1jQoA0xruY3L+lExtV3lIXJlgAx3PQFGX4CQvRrWnihFM7EwC8VySzHsVMVWmXvi92SzWSCdj/zXFDuzamh4SqysZCsJRS3l93Sex6eXzW0n1sTCigyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713550161; c=relaxed/simple;
	bh=/H0aLUXbptTJMstIHyHEZwTIjUhoB/hN9C5wrtUFPMU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H+i69oVXZCNz/YJoURqzfmTjj/Z4lZz1uNKu9+V8Y2HBzSYeIsRIqCDcZInZloLZXl+DXxebOZ0bNw5LTY+EzI3CJ/83g/TawS/ebhW2JIrMeYmWIOtsvAHirgCQ+fmRDyskCCiB0L7PFtJvI8rIjEpy6jDnwgt5fqlv9eesfsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JnaCRwyL; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JnaCRwyL"
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-36a0f64f5e0so9351085ab.3;
        Fri, 19 Apr 2024 11:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713550158; x=1714154958; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g7KXggaRzvJm+KkzUYbiIOloVMuu2JkMjWu2cTt/gx4=;
        b=JnaCRwyLoXL4WVmzJ65rN3Rn5thQyrTjrSp4PW6MHGqTzMcU8ntudox20m6C7gxTnD
         YCwrskO5E01LxtZFnkTFGn+a6MBt+5dqocxQgZp/MBerUxokfYTSgIBvQG8OS3FoFgt/
         uJjSfSi37ar1cTM4v3k48O0ytcSmqZ2jWNMirBZWc3kqbOGwD8ViHUiwHVCw1M/TI4yh
         dqK85+/eypuRn7UMssZKro1qweGqpR0abayrAVODon2EJVPlkg9Wlf8N5VxjArQtsyTb
         XDLvNY0T85lqD19AfYyUM807NHYxmoUmEn3eBYzyL7q0k3eqzzFZe64o7UT2w0q935RS
         jOGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713550158; x=1714154958;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g7KXggaRzvJm+KkzUYbiIOloVMuu2JkMjWu2cTt/gx4=;
        b=EPnL7d/n8lvykIP/8aovU/zmCjORoOFWMLKyPOXhIykHqBLFFdJvOeWyzKpQz37bzL
         qL7+NH8goMgIvbZsszFFEm9CHJZj3E2q2HATXIxwz6DbmPWlLAHu7lkTLHhJgOhta448
         7fYzFYzdjBeb0u1120qRO6uUWutEILXQyXiWRYOy0aN0nFhUlvgS7lOUVUICDYdV8Nm3
         0FqtFsScDPVA8iDqgpWmEvzTs//ZvBoeqlt7i44pM7yMharO/XxM0X6776ygJZ34C4Wa
         8kmp9bW2LgIaXdiICB9LV2bHZJohWJUg/w3aUH9bmN735wXknZOZlBciKKMBB3rN6h0m
         sOSg==
X-Forwarded-Encrypted: i=1; AJvYcCXYotvVX8mwCy5HSCMyen6O8TgsttsgsW62+8/9pRENkythgGxQihjcijWxsc7I90E8CO+ppotlkyPC1+M6CWtWLUYFwIplMGrhZA==
X-Gm-Message-State: AOJu0YzCp16mzyQvzq5BBMNwLTZwNPDHVkf5BvVWe+UNGW8ntyqLT0mh
	3JBElmd7V7hn4rneZWONQog8JclVUBv/zCiuCmG174l/6/hAqDGhuz4DJjHI4qsVMoIe0CrUcrc
	e7OX+ztC1PU9MoVuTdeStPjxcPWE=
X-Google-Smtp-Source: AGHT+IE4lCwZtZpUyQd+1DbBguwHIua50xSCriDUHtoUoKRspHBbfK0+Ug2BbedUssLY1Wg9fmv6CtuL+hRLxIN1Fmw=
X-Received: by 2002:a05:6e02:2141:b0:36a:3515:b82d with SMTP id
 d1-20020a056e02214100b0036a3515b82dmr3661054ilv.13.1713550158113; Fri, 19 Apr
 2024 11:09:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1710173427.git.lucien.xin@gmail.com> <74d5db09-6b5c-4054-b9d3-542f34769083@samba.org>
 <CADvbK_dzVcDKsJ9RN9oc0K1Jwd+kYjxgE6q=ioRbVGhJx7Qznw@mail.gmail.com>
 <f427b422-6cfc-45ac-88eb-3e7694168b63@samba.org> <CADvbK_cA-RCLiUUWkyNsS=4OhkWrUWb68QLg28yO2=8PqNuGBQ@mail.gmail.com>
 <438496a6-7f90-403d-9558-4a813e842540@samba.org> <CADvbK_fkbOnhKL+Rb+pp+NF+VzppOQ68c=nk_6MSNjM_dxpCoQ@mail.gmail.com>
 <1456b69c-4ffd-4a08-b120-6a00abf1eb05@samba.org>
In-Reply-To: <1456b69c-4ffd-4a08-b120-6a00abf1eb05@samba.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 19 Apr 2024 14:09:06 -0400
Message-ID: <CADvbK_cQRpyzHG4UUOzfgmqLndvpx5Cd+d59rrqGRp0ic3PyxA@mail.gmail.com>
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

On Fri, Apr 19, 2024 at 10:07=E2=80=AFAM Stefan Metzmacher <metze@samba.org=
> wrote:
>
> Hi Xin Long,
>
> >>>>>> first many thanks for working on this topic!
> >>>>>>
> >>>>> Hi, Stefan
> >>>>>
> >>>>> Thanks for the comment!
> >>>>>
> >>>>>>> Usage
> >>>>>>> =3D=3D=3D=3D=3D
> >>>>>>>
> >>>>>>> This implementation supports a mapping of QUIC into sockets APIs.=
 Similar
> >>>>>>> to TCP and SCTP, a typical Server and Client use the following sy=
stem call
> >>>>>>> sequence to communicate:
> >>>>>>>
> >>>>>>>            Client                    Server
> >>>>>>>         ---------------------------------------------------------=
---------
> >>>>>>>         sockfd =3D socket(IPPROTO_QUIC)      listenfd =3D socket(=
IPPROTO_QUIC)
> >>>>>>>         bind(sockfd)                       bind(listenfd)
> >>>>>>>                                            listen(listenfd)
> >>>>>>>         connect(sockfd)
> >>>>>>>         quic_client_handshake(sockfd)
> >>>>>>>                                            sockfd =3D accecpt(lis=
tenfd)
> >>>>>>>                                            quic_server_handshake(=
sockfd, cert)
> >>>>>>>
> >>>>>>>         sendmsg(sockfd)                    recvmsg(sockfd)
> >>>>>>>         close(sockfd)                      close(sockfd)
> >>>>>>>                                            close(listenfd)
> >>>>>>>
> >>>>>>> Please note that quic_client_handshake() and quic_server_handshak=
e() functions
> >>>>>>> are currently sourced from libquic in the github lxin/quic reposi=
tory, and might
> >>>>>>> be integrated into ktls-utils in the future. These functions are =
responsible for
> >>>>>>> receiving and processing the raw TLS handshake messages until the=
 completion of
> >>>>>>> the handshake process.
> >>>>>>
> >>>>>> I see a problem with this design for the server, as one reason to
> >>>>>> have SMB over QUIC is to use udp port 443 in order to get through
> >>>>>> firewalls. As QUIC has the concept of ALPN it should be possible
> >>>>>> let a conumer only listen on a specif ALPN, so that the smb server
> >>>>>> and web server on "h3" could both accept connections.
> >>>>> We do provide a sockopt to set ALPN before bind or handshaking:
> >>>>>
> >>>>>      https://github.com/lxin/quic/wiki/man#quic_sockopt_alpn
> >>>>>
> >>>>> But it's used more like to verify if the ALPN set on the server
> >>>>> matches the one received from the client, instead of to find
> >>>>> the correct server.
> >>>>
> >>>> Ah, ok.
> >>> Just note that, with a bit change in the current libquic, it still
> >>> allows users to use ALPN to find the correct function or thread in
> >>> the *same* process, usage be like:
> >>>
> >>> listenfd =3D socket(IPPROTO_QUIC);
> >>> /* match all during handshake with wildcard ALPN */
> >>> setsockopt(listenfd, QUIC_SOCKOPT_ALPN, "*");
> >>> bind(listenfd)
> >>> listen(listenfd)
> >>>
> >>> while (1) {
> >>>     sockfd =3D accept(listenfd);
> >>>     /* the alpn from client will be set to sockfd during handshake */
> >>>     quic_server_handshake(sockfd, cert);
> >>>
> >>>     getsockopt(sockfd, QUIC_SOCKOPT_ALPN, alpn);
> >>
> >> Would quic_server_handshake() call setsockopt()?
> > Yes, I just made a bit change in the userspace libquic:
> >
> >    https://github.com/lxin/quic/commit/9c75bd42769a8cbc1652e2f4c8d77780=
f23afde6
> >
> > So you can set up multple ALPNs on listen sock:
> >
> >    setsockopt(listenfd, QUIC_SOCKOPT_ALPN, "smbd, h3, ksmbd");
> >
> > Then during handshake, the matched ALPN from client will be set into
> > the accept socket, then users can get it later after handshake.
> >
> > Note that userspace libquic is a very light lib (a couple of hundred li=
nes
> > of code), you can add more TLS related support without touching Kernel =
code,
> > including the SNI support you mentioned.
> >
> >>
> >>>     switch (alpn) {
> >>>       case "smbd": smbd_thread(sockfd);
> >>>       case "h3": h3_thread(sockfd);
> >>>       case "ksmbd": ksmbd_thread(sockfd);
> >>>     }
> >>> }
> >>
> >> Ok, but that would mean all application need to be aware of each other=
,
> >> but it would be possible and socket fds could be passed to other
> >> processes.
> > It doesn't sound common to me, but yes, I think Unix Domain Sockets
> > can pass it to another process.
>
> I think it will be extremely common to have multiple services
> based on udp port 443.
>
> People will expect to find web services, smb and maybe more
> behind the same dnshost name. And multiple dnshostnames pointing
> to the same ip address is also very likely.
>
> With plain tcp/udp it's also possible to independent sockets
> per port. There's no single userspace daemon that listens on
> 'tcp' and will dispatch into different process base on the port.
>
> And with QUIC the port space is the ALPN and/or SNI
> combination.
>
> And I think this should be addressed before this becomes an
> unchangeable kernel ABI, written is stone.
>
> >>>>> So you expect (k)smbd server and web server both to listen on UDP
> >>>>> port 443 on the same host, and which APP server accepts the request
> >>>>> from a client depends on ALPN, right?
> >>>>
> >>>> yes.
> >>> Got you. This can be done by also moving TLS 1.3 message exchange to
> >>> kernel where we can get the ALPN before looking up the listening sock=
et.
> >>> However, In-kernel TLS 1.3 Handshake had been NACKed by both kernel
> >>> netdev maintainers and userland ssl lib developers with good reasons.
> >>>
> >>>>
> >>>>> Currently, in Kernel, this implementation doesn't process any raw T=
LS
> >>>>> MSG/EXTs but deliver them to userspace after decryption, and the ac=
cept
> >>>>> socket is created before processing handshake.
> >>>>>
> >>>>> I'm actually curious how userland QUIC handles this, considering
> >>>>> that the UDP sockets('listening' on the same IP:PORT) are used in
> >>>>> two different servers' processes. I think socket lookup with ALPN
> >>>>> has to be done in Kernel Space. Do you know any userland QUIC
> >>>>> implementation for this?
> >>>>
> >>>> I don't now, but I guess QUIC is only used for http so
> >>>> far and maybe dns, but that seems to use port 853.
> >>>>
> >>>> So there's no strict need for it and the web server
> >>>> would handle all relevant ALPNs.
> >>> Honestly, I don't think any userland QUIC can use ALPN to lookup for
> >>> different sockets used by different servers/processes. As such thing
> >>> can be only done in Kernel Space.
> >>>
> >>>>
> >>>>>>
> >>>>>> So the server application should have a way to specify the desired
> >>>>>> ALPN before or during the bind() call. I'm not sure if the
> >>>>>> ALPN is available in cleartext before any crypto is needed,
> >>>>>> so if the ALPN is encrypted it might be needed to also register
> >>>>>> a server certificate and key together with the ALPN.
> >>>>>> Because multiple application may not want to share the same key.
> >>>>> On send side, ALPN extension is in raw TLS messages created in user=
space
> >>>>> and passed into the kernel and encoded into QUIC crypto frame and t=
hen
> >>>>> *encrypted* before sending out.
> >>>>
> >>>> Ok.
> >>>>
> >>>>> On recv side, after decryption, the raw TLS messages are decoded fr=
om
> >>>>> the QUIC crypto frame and then delivered to userspace, so in usersp=
ace
> >>>>> it processes certificate validation and also see cleartext ALPN.
> >>>>>
> >>>>> Let me know if I don't make it clear.
> >>>>
> >>>> But the first "new" QUIC pdu from will trigger the accept() to
> >>>> return and userspace (or the kernel helper function) will to
> >>>> all crypto? Or does the first decryption happen in kernel (before ac=
cept returns)?
> >>> Good question!
> >>>
> >>> The first "new" QUIC pdu will cause to create a 'request sock' (conta=
ins
> >>> 4-tuple and connection IDs only) and queue up to reqsk list of the li=
sten
> >>> sock (if validate_peer_address param is not set), and this pdu is enq=
ueued
> >>> in the inq->backlog_list of the listen sock.
> >>>
> >>> When accept() is called, in Kernel, it dequeues the "request sock" fr=
om the
> >>> reqsk list of the listen sock, and creates the accept socket based on=
 this
> >>> reqsk. Then it processes the pdu for this new accept socket from the
> >>> inq->backlog_list of the listen sock, including *decrypting* QUIC pac=
ket
> >>> and decoding CRYPTO frame, then deliver the raw/cleartext TLS message=
 to
> >>> the Userspace libquic.
> >>
> >> Ok, when the kernel already decrypts it could already
> >> look find the ALPN. It doesn't mean it should do the full
> >> handshake, but parse enough to find the ALPN.
> > Correct, in-kernel QUIC should only do the QUIC related things,
> > and all TLS handshake msgs must be handled in Userspace.
> > This won't cause "layering violation", as Nick Banks said.
>
> But I think its unavoidable for the ALPN and SNI fields on
> the server side. As every service tries to use udp port 443
> and somehow that needs to be shared if multiple services want to
> use it.
>
> I guess on the acceptor side we would need to somehow detach low level
> udp struct sock from the logical listen struct sock.
>
> And quic_do_listen_rcv() would need to find the correct logical listening
> socket and call quic_request_sock_enqueue() on the logical socket
> not the lowlevel udo socket. The same for all stuff happening after
> quic_request_sock_enqueue() at the end of quic_do_listen_rcv.
>
The implementation allows one low level UDP sock to serve for multiple
QUIC socks.

Currently, if your 3 quic applications listen to the same address:port
with SO_REUSEPORT socket option set, the incoming connection will choose
one of your applications randomly with hash(client_addr+port) via
reuseport_select_sock() in quic_sock_lookup().

It should be easy to do a further match with ALPN between these 3 quic
socks that listens to the same address:port to get the right quic sock,
instead of that randomly choosing.

The problem is to parse the TLS Client_Hello message to get the ALPN in
quic_sock_lookup(), which is not a proper thing to do in kernel, and
might be rejected by networking maintainers, I need to check with them.

Will you be able to work around this by using Unix Domain Sockets pass
the sockfd to another process?

(Note that we're assuming all your 3 applications are using in-kernel QUIC)

> >> But I don't yet understand how the kernel gets the key to
> >> do the initlal decryption, I'd assume some call before listen()
> >> need to tell the kernel about the keys.
> > For initlal decryption, the keys can be derived with the initial packet=
.
> > basically, it only needs the dst_connection_id from the client initial
> > packet. see:
> >
> >    https://datatracker.ietf.org/doc/html/rfc9001#name-initial-secrets
> >
> > so we don't need to set up anything to kernel for initial's keys.
>
> I got it thanks!
>
> metze
>
