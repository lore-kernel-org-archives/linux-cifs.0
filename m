Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B26224DE;
	Wed, 13 Mar 2024 19:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710358790; cv=none; b=KnxKngkV/HKIG3seMc0OzEskWoNfo75dIITGc43VChUVHz1uatSd6kpPlICGfanN+Of3R+nxYHYuME0g+SuMZQY6Ebd7bdImI2sqmvza8o0PwUG3PsDkYL+ta67iL7AqQn9i+1ZgsXMli0A62zHj4CwtRxIoEErfM0Ny/N9dueg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710358790; c=relaxed/simple;
	bh=yJ8IyuvMf3vzjeelzz4sas3NGUM7l3OXQQnVf3MtGYU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NtIUqV68elctVstNpUVyUiD+oKuvkU0c4JmnUis+B6OUM7cgHBwvUBPaxe1W8vWU3mDZ0O73ASir84Q5YEZRuzI7E3fUXXU1VuhH2n09lGZJ+OC+I8EwEVBxn+NKWV3+/l2L8Q6VdW4BaklFYjmSjvAW+WyswJDRVL0dqRQJa9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LGhJBrAb; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LGhJBrAb"
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-36678885723so1391255ab.1;
        Wed, 13 Mar 2024 12:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710358788; x=1710963588; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ypcrvtk4Rzc5tG9Ngch2IY8AauL0Gqs9F0/89xr62Y8=;
        b=LGhJBrAbJSWEPFakVdmTyurjUm7yeN4uwlFkRs9AiglcEoozG7f6IRWopJe3E2rqvK
         xDdBHrlhdTMrSyoaywTioARU69eGzocAYSuybyaGNpwm/6A/gts9Iy9G/UeXGXYLWpX4
         JMVB+E3KmuJcL9oZIaH0ZGy8nGa980I+q2z7ujbfGucf+kUCnHL0N5xh9tI/28F2qWzi
         Jn04mUDh/wzfCA0wNQodH36j9FquaWckVglwf1GCjceL04huC8CPQTmEJQEw5bspYOkl
         /J0nlIaJdb/81D/DadafP2ewkOzwXTnfmmZ0XdwDJida9SgtJFrwCK14R5lTAe3acpEG
         TBrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710358788; x=1710963588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ypcrvtk4Rzc5tG9Ngch2IY8AauL0Gqs9F0/89xr62Y8=;
        b=evefNcOrGm8iam8Hh5540y+8Nj/5AOvJbeARJQnshZjwXoprI+1OS4JOPYZ5L2rvH8
         FWITBHUTNU3hhM8VzGQM4DQCeBwqQqdQ7d9Yx4jtm1MhUJ3i3mT8a9S+XIjdJKmnGX3A
         zZpK6V9cRfqzm0/HQlC48FJs1drx3GYtA9WmHDxdsfvslZu/q3vMrjcIseIl+5PTy6Zl
         BoPgZAhxuZUAnJwRhRdimN8RAVg4/4aciM+vLM0nkJuYfX2/93kKSEV6GMvJFSzv2EBU
         exNqphkgqhMSFjRUlA8D6EuSZ6W/w92C20RSQWIcVnYAk4pcpKdMLlJLsGgMFMemHCWP
         bRpw==
X-Forwarded-Encrypted: i=1; AJvYcCWxps70BC+S0OdKAGDxBXUAM5MpKrhJb86SI8OMckhd6aiEhY4fth3rfcSOPRTbKYrMFSYjoLfZgnLEcBK6GQTF4h6mFSeSb3Yhrg==
X-Gm-Message-State: AOJu0Yzh1Y9nWPPaPF+po4ZXF/FlDqMmwfApYH0RQnB/BV7SVZDPuHlo
	T2G6a3bseRL5vQqV6AG7raw+8avT6Fi0L2mCrJsq3TXYR07xGmkPMhFGozWYjOzBotM79JsoPs4
	GDuAp6VPo+Do/1ma8kMEKH6cXR78=
X-Google-Smtp-Source: AGHT+IGBTT5DQ0JdWTO2jB2ca3ijpZlAVdlu+VNbbvNiTXKLmhe7skRdbfCy+bMDaSa/SsGessrReKobW6bL3z+HtKM=
X-Received: by 2002:a05:6e02:1c8f:b0:365:fe08:8268 with SMTP id
 w15-20020a056e021c8f00b00365fe088268mr1070248ill.5.1710358788023; Wed, 13 Mar
 2024 12:39:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1710173427.git.lucien.xin@gmail.com> <74d5db09-6b5c-4054-b9d3-542f34769083@samba.org>
 <CADvbK_dzVcDKsJ9RN9oc0K1Jwd+kYjxgE6q=ioRbVGhJx7Qznw@mail.gmail.com> <f427b422-6cfc-45ac-88eb-3e7694168b63@samba.org>
In-Reply-To: <f427b422-6cfc-45ac-88eb-3e7694168b63@samba.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 13 Mar 2024 15:39:36 -0400
Message-ID: <CADvbK_cA-RCLiUUWkyNsS=4OhkWrUWb68QLg28yO2=8PqNuGBQ@mail.gmail.com>
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

On Wed, Mar 13, 2024 at 1:28=E2=80=AFPM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Am 13.03.24 um 17:03 schrieb Xin Long:
> > On Wed, Mar 13, 2024 at 4:56=E2=80=AFAM Stefan Metzmacher <metze@samba.=
org> wrote:
> >>
> >> Hi Xin Long,
> >>
> >> first many thanks for working on this topic!
> >>
> > Hi, Stefan
> >
> > Thanks for the comment!
> >
> >>> Usage
> >>> =3D=3D=3D=3D=3D
> >>>
> >>> This implementation supports a mapping of QUIC into sockets APIs. Sim=
ilar
> >>> to TCP and SCTP, a typical Server and Client use the following system=
 call
> >>> sequence to communicate:
> >>>
> >>>          Client                    Server
> >>>       ---------------------------------------------------------------=
---
> >>>       sockfd =3D socket(IPPROTO_QUIC)      listenfd =3D socket(IPPROT=
O_QUIC)
> >>>       bind(sockfd)                       bind(listenfd)
> >>>                                          listen(listenfd)
> >>>       connect(sockfd)
> >>>       quic_client_handshake(sockfd)
> >>>                                          sockfd =3D accecpt(listenfd)
> >>>                                          quic_server_handshake(sockfd=
, cert)
> >>>
> >>>       sendmsg(sockfd)                    recvmsg(sockfd)
> >>>       close(sockfd)                      close(sockfd)
> >>>                                          close(listenfd)
> >>>
> >>> Please note that quic_client_handshake() and quic_server_handshake() =
functions
> >>> are currently sourced from libquic in the github lxin/quic repository=
, and might
> >>> be integrated into ktls-utils in the future. These functions are resp=
onsible for
> >>> receiving and processing the raw TLS handshake messages until the com=
pletion of
> >>> the handshake process.
> >>
> >> I see a problem with this design for the server, as one reason to
> >> have SMB over QUIC is to use udp port 443 in order to get through
> >> firewalls. As QUIC has the concept of ALPN it should be possible
> >> let a conumer only listen on a specif ALPN, so that the smb server
> >> and web server on "h3" could both accept connections.
> > We do provide a sockopt to set ALPN before bind or handshaking:
> >
> >    https://github.com/lxin/quic/wiki/man#quic_sockopt_alpn
> >
> > But it's used more like to verify if the ALPN set on the server
> > matches the one received from the client, instead of to find
> > the correct server.
>
> Ah, ok.
Just note that, with a bit change in the current libquic, it still
allows users to use ALPN to find the correct function or thread in
the *same* process, usage be like:

listenfd =3D socket(IPPROTO_QUIC);
/* match all during handshake with wildcard ALPN */
setsockopt(listenfd, QUIC_SOCKOPT_ALPN, "*");
bind(listenfd)
listen(listenfd)

while (1) {
  sockfd =3D accept(listenfd);
  /* the alpn from client will be set to sockfd during handshake */
  quic_server_handshake(sockfd, cert);

  getsockopt(sockfd, QUIC_SOCKOPT_ALPN, alpn);

  switch (alpn) {
    case "smbd": smbd_thread(sockfd);
    case "h3": h3_thread(sockfd);
    case "ksmbd": ksmbd_thread(sockfd);
  }
}

>
> > So you expect (k)smbd server and web server both to listen on UDP
> > port 443 on the same host, and which APP server accepts the request
> > from a client depends on ALPN, right?
>
> yes.
Got you. This can be done by also moving TLS 1.3 message exchange to
kernel where we can get the ALPN before looking up the listening socket.
However, In-kernel TLS 1.3 Handshake had been NACKed by both kernel
netdev maintainers and userland ssl lib developers with good reasons.

>
> > Currently, in Kernel, this implementation doesn't process any raw TLS
> > MSG/EXTs but deliver them to userspace after decryption, and the accept
> > socket is created before processing handshake.
> >
> > I'm actually curious how userland QUIC handles this, considering
> > that the UDP sockets('listening' on the same IP:PORT) are used in
> > two different servers' processes. I think socket lookup with ALPN
> > has to be done in Kernel Space. Do you know any userland QUIC
> > implementation for this?
>
> I don't now, but I guess QUIC is only used for http so
> far and maybe dns, but that seems to use port 853.
>
> So there's no strict need for it and the web server
> would handle all relevant ALPNs.
Honestly, I don't think any userland QUIC can use ALPN to lookup for
different sockets used by different servers/processes. As such thing
can be only done in Kernel Space.

>
> >>
> >> So the server application should have a way to specify the desired
> >> ALPN before or during the bind() call. I'm not sure if the
> >> ALPN is available in cleartext before any crypto is needed,
> >> so if the ALPN is encrypted it might be needed to also register
> >> a server certificate and key together with the ALPN.
> >> Because multiple application may not want to share the same key.
> > On send side, ALPN extension is in raw TLS messages created in userspac=
e
> > and passed into the kernel and encoded into QUIC crypto frame and then
> > *encrypted* before sending out.
>
> Ok.
>
> > On recv side, after decryption, the raw TLS messages are decoded from
> > the QUIC crypto frame and then delivered to userspace, so in userspace
> > it processes certificate validation and also see cleartext ALPN.
> >
> > Let me know if I don't make it clear.
>
> But the first "new" QUIC pdu from will trigger the accept() to
> return and userspace (or the kernel helper function) will to
> all crypto? Or does the first decryption happen in kernel (before accept =
returns)?
Good question!

The first "new" QUIC pdu will cause to create a 'request sock' (contains
4-tuple and connection IDs only) and queue up to reqsk list of the listen
sock (if validate_peer_address param is not set), and this pdu is enqueued
in the inq->backlog_list of the listen sock.

When accept() is called, in Kernel, it dequeues the "request sock" from the
reqsk list of the listen sock, and creates the accept socket based on this
reqsk. Then it processes the pdu for this new accept socket from the
inq->backlog_list of the listen sock, including *decrypting* QUIC packet
and decoding CRYPTO frame, then deliver the raw/cleartext TLS message to
the Userspace libquic.

Then in Userspace libquic, it handles the received TLS message and creates
a new raw/cleartext TLS message for response via libgnutls, and delivers to
kernel. In kernel, it will encode this message to a CRYPTO frame in a QUIC
packet and then *encrypt* this QUIC packet and send it out.

So as you can see, there's no en/decryption happening in Userspace. In
Userspace libquic, it only does raw/cleartext TLS message exchange. ALL
en/decryption happens in Kernel Space, as these en/decryption are done
against QUIC packets, not directly against the TLS messages.

>
> Maybe it would be possible to optionally have socket option to
> register ALPNs with certificates so that tls_server_hello_x509()
> could be called automatically before accept returns (even for
> userspace consumers).
>
> It may mean the tlshd protocol needs to be extended...
>
so that userspace consumers don't need quic_client/server_handshake(), and
accept() returns a socket that already has the handshake done, right?

We didn't do that, as:

1. It's not a good idea for Userspace consumers' applications to reply on
   a daemon like tlshd, not convenient for users, also a bit weird for
   userspace app to ask another userspace app to help do the handshake.
2. It's too complex to implement, especially if we also want to call
   tls_client_hello_x509() before connect() returns on client side.
3. For Kernel usage, I prefer leaving this to the kernel consumers for
   more flexibility for handshake requests.

As for the ALPNs with certificates, not sure if I understand correctly.
But if you want the server to select certificates according to the ALPN
received from the client during handshake. I think it could be done in
userspace libquic. But yes, tlshd service may also need to extend.
