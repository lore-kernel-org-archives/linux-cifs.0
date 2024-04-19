Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBF81D699;
	Fri, 19 Apr 2024 19:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713554370; cv=none; b=HX20reDsNHLopoxwSOzeSOBuB22/E+vIoII8WYZSuZna/tDvwJnLlalWE9OVpDTOyTb48jv4evUi0mzdWNng0YbFYTrh0hcC4445x1b463omYZqrBZwXaBn0GXhn0gESHCjLRq+By7dMeV96xa4AYf5/p5+80KAzDIUvQ2Xb26s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713554370; c=relaxed/simple;
	bh=WlfTa9fhttzPEidHyJjm2gyCIOgMLDUYCzU92aupMSM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d4PC5ctLQc2YOAW8JWghdfy93Zh1gqJ+5uo9/A5zYTEDQYwECT5LAHujgaNe/9lyzB3cjhoPv2lSpbG0ctQAmZ8Xyf3DBe4sCP70qKiveoui7bySp3JAf3v0FNiE+33uYj3xMKH8Xk9NYUS30cExSN2lUmcjQm027b3I1FWXaUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IuaBnw1G; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IuaBnw1G"
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-36b08fc1913so7576145ab.0;
        Fri, 19 Apr 2024 12:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713554368; x=1714159168; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WlfTa9fhttzPEidHyJjm2gyCIOgMLDUYCzU92aupMSM=;
        b=IuaBnw1Gkfz6u/+2LmCS9hB8x5oHTshh1d/r6tRtVIyloh6O0E5ibYM83bh+iv2zJj
         hCqa2gTZagdqA0wBdHFbIBUV1ao9lk89DP1gEY5MvSfWxXVqagGxYsVB0mnJZRbd0E2/
         8ScmDj4h1yUZipxdOjGlplWsIRLyHDMKatHpWt/HU2Um49npUdHMG+v83ltvs3DNlEsx
         HfvLDrp5vcu1vBOV3N43r4v8ji183d35wriLj7PanaS/VIhubG9FcfLz3+YOx+ukajB5
         gHggDSYQ7xflVkqTBevLmYhCCK2jwud6ZDH6H8q72DpmsIWhKLUB2ESXqK5ApVwgKTzq
         0otQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713554368; x=1714159168;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WlfTa9fhttzPEidHyJjm2gyCIOgMLDUYCzU92aupMSM=;
        b=ATE+fjFuKZS5EvnEgQS+dLKiqDGHiwaZv2nqF7BlNClxAjoCuBeeMw63rb9lAQDe9T
         4g9/PDAfZsJb13yQNVO38Dv0q+N0P1GZcR+9hyXAjzPcEtZc/K9JruPpcYU6FdNkLsLC
         gZwEe3v6dGnx5+mCsGNr9k/OLGLJgQLMIOLMyUCzQHT2CXMYjpqzDTlv69jIht7JyQBf
         Qk32rrAR1Mu6eIY10+HnIvKDhLQcXhLMt8pKijKtZFKRrBJV63WRuzr+7Rwecp+GfqyA
         JD+mNy/HkroIqcxBozJuG8PGsi7ntOgllYEd4oysWoRB6+x4lnUjWjqXLiAX+Km82c4h
         TbTw==
X-Forwarded-Encrypted: i=1; AJvYcCVDVXwRDUSdyps/pbsFsowbF3GdZ4sAmwz7vh/prlmIb1ke9TpAhBQTwvtQAyhFAcrUtHtY/8yZT6x0xIIMndx2XjRuSrsyCcUwHQ==
X-Gm-Message-State: AOJu0Yz6e2xi9MYh++ug6fzNGFMbVBibsdeyqW5iKiBhRUBsUqBcxpMO
	EOahTwLdjbIaRDdAp2iaDhmZ3pJH5y9nxb4tZFgNQEa9ThmB/r3Ur1Dsb4znt3X0RNUcJUrkEtv
	iyFQ9rNilfhapYjnW2JeueuhRYMc=
X-Google-Smtp-Source: AGHT+IGeRV1g9peFjvgNiukEtx1N2Xy4RepVWJSm8X5REPeBNuoKUhiCcTz/zfTt2+l1zivtUmDXiPf6dGOXEQKsJUI=
X-Received: by 2002:a05:6e02:1526:b0:36b:fa6e:5be7 with SMTP id
 i6-20020a056e02152600b0036bfa6e5be7mr2732230ilu.14.1713554367969; Fri, 19 Apr
 2024 12:19:27 -0700 (PDT)
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
 <1456b69c-4ffd-4a08-b120-6a00abf1eb05@samba.org> <CADvbK_cQRpyzHG4UUOzfgmqLndvpx5Cd+d59rrqGRp0ic3PyxA@mail.gmail.com>
 <95922a2f-07a1-4555-acd2-c745e59bcb8e@samba.org>
In-Reply-To: <95922a2f-07a1-4555-acd2-c745e59bcb8e@samba.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 19 Apr 2024 15:19:16 -0400
Message-ID: <CADvbK_eR4++HbR_RncjV9N__M-uTHtmqcC+_Of1RKVw7Uqf9Cw@mail.gmail.com>
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

On Fri, Apr 19, 2024 at 2:51=E2=80=AFPM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Hi Xin Long,
>
> >> But I think its unavoidable for the ALPN and SNI fields on
> >> the server side. As every service tries to use udp port 443
> >> and somehow that needs to be shared if multiple services want to
> >> use it.
> >>
> >> I guess on the acceptor side we would need to somehow detach low level
> >> udp struct sock from the logical listen struct sock.
> >>
> >> And quic_do_listen_rcv() would need to find the correct logical listen=
ing
> >> socket and call quic_request_sock_enqueue() on the logical socket
> >> not the lowlevel udo socket. The same for all stuff happening after
> >> quic_request_sock_enqueue() at the end of quic_do_listen_rcv.
> >>
> > The implementation allows one low level UDP sock to serve for multiple
> > QUIC socks.
> >
> > Currently, if your 3 quic applications listen to the same address:port
> > with SO_REUSEPORT socket option set, the incoming connection will choos=
e
> > one of your applications randomly with hash(client_addr+port) vi
> > reuseport_select_sock() in quic_sock_lookup().
> >
> > It should be easy to do a further match with ALPN between these 3 quic
> > socks that listens to the same address:port to get the right quic sock,
> > instead of that randomly choosing.
>
> Ah, that sounds good.
>
> > The problem is to parse the TLS Client_Hello message to get the ALPN in
> > quic_sock_lookup(), which is not a proper thing to do in kernel, and
> > might be rejected by networking maintainers, I need to check with them.
>
> Is the reassembling of CRYPTO frames done in the kernel or
> userspace? Can you point me to the place in the code?
In quic_inq_handshake_tail() in kernel, for Client Initial packet
is processed when calling accept(), this is the path:

quic_accept()-> quic_accept_sock_init() -> quic_packet_process() ->
quic_packet_handshake_process() -> quic_frame_process() ->
quic_frame_crypto_process() -> quic_inq_handshake_tail().

Note that it's with the accept sock, not the listen sock.

>
> If it's really impossible to do in C code maybe
> registering a bpf function in order to allow a listener
> to check the intial quic packet and decide if it wants to serve
> that connection would be possible as last resort?
That's a smart idea! man.
I think the bpf hook in reuseport_select_sock() is meant to do such
selection.

For the Client initial packet (the only packet you need to handle),
I double you will need to do the reassembling, as Client Hello TLS message
is always less than 400 byte in my env.

But I think you need to do the decryption for the Client initial packet
before decoding it then parsing the TLS message from its crypto frame.

BTW, for the TLS message parse, I have some prototype code for
TLS Handshake:
https://github.com/lxin/tls_hs/blob/master/crypto/tls_hs.c#L2084

The path to get ALPN:
tls_msg_handle() -> tls_msg_ch_handle() -> tls_ext_handle()

Hope it may be helpful to you.

>
> > Will you be able to work around this by using Unix Domain Sockets pass
> > the sockfd to another process?
>
> Not really. As that would strict coordination between a lot of
> independent projects.
>
> > (Note that we're assuming all your 3 applications are using in-kernel Q=
UIC)
>
> Sure, but I guess for servers using port 443 that the only long term opti=
on.
> and I don't think it will be less performant than a userspace implementat=
ion.
Cool.
