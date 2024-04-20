Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52F4205E37;
	Sat, 20 Apr 2024 19:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713641550; cv=none; b=BC3QAr6SouR8kAe/gulDJy4IKi3xrGcOnpLpPWowbLEPX8yNq7N8n5bZTabc9HtfVdyJB/opZMimEGc5ilaH4JzctCMdEYbJi3U6Ud04BBKLsXUeldiFdJJP7fKNL+1h5sU6uqRSApeYLirP3UrET3YGWGWVNz9WbFYvq6oZ2w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713641550; c=relaxed/simple;
	bh=Gl/zMiP/E/jiQTChvjQ8CL2PbmKbpID9R83tGkJwI5U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gy556U76Xq/nwBTDTnNyGLH8hKPbfobww6pyykTZ2GZxj8Dj5LodQ2HX+HL5mfWQtztgGRrl/tTX2ZYFWDYwcXAwqX6KMSihg+MacWZgSoDUMuEjTJ363ci3NsD034Sl88fJJMFQ68BbPuCPWCCGfUhMWNMw9eSLOECGWxgQRrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QlqdmsXT; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QlqdmsXT"
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-36b2fcd1fb6so11850315ab.3;
        Sat, 20 Apr 2024 12:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713641548; x=1714246348; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gl/zMiP/E/jiQTChvjQ8CL2PbmKbpID9R83tGkJwI5U=;
        b=QlqdmsXTK60cxMKZUZCaaAfWW6VCQXlpU6iCnnQTSRsDUSyXcqNqL2FIbQO+axncm3
         ZnLQYvO/zwidaV1vrwtBweFewFqyVc2BD/QtsbBZqvm0bMVqP1ailWnAWz8QJ8L4u6T6
         HwG0HPjwrHw31Lct0a2I6md/lwov7F9lZpJ9gxeeQangivcrAVLSYczI25n8QphKpdzd
         nIxU24mVowp9WzCyBfChVCoegz1866dqHz70kRZYeUancyikhwVUsl0O+9knHoGtP5Ej
         9sUiflGa9NxIdyisWvu4d0GlxF6hlQDgxkHuGgg0gc7Tj3aldXpqIRY4XPIqt9O3eveo
         rUSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713641548; x=1714246348;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gl/zMiP/E/jiQTChvjQ8CL2PbmKbpID9R83tGkJwI5U=;
        b=pNdhJRXfCyrtnBSs4vht5w1NTDDk9vo/Pqln1vys+eHqsUkoz4ipNhDfNPY3xKC7+f
         v76tjhd18Grn6ZcyRpVV6Q3zN5FnN9KafnfjLHKIbRNqAibqNh72PPEagMBBjK9o9Sql
         qra8lkdloARL6FBHnOlRsYqKPjwM0NvvkvKYt4zbuK/c2GIknzO7YXcFBDhuoVDmOiIo
         BxKZlva4wH9aT42u/XL9reCd20etnR/46PD7l3LSGAjqpBI5FEdLdO+w0EhnBXUtxyM1
         lmlthVKEdN5KOiiacH306GWeUEw8z/fVf6Eh6coJd71KCg+3qsbR7InYiBOYUZcqtCoT
         otOw==
X-Forwarded-Encrypted: i=1; AJvYcCXBDp0pAOZOJEv0eIVNgMMykvDsFh8/K0Q71ItI8Qx3UYJP6zexTZgXD0S1jSJ4osDd7pD8z+LhfVkm1Bv8QuTWXsijhnTqtJh9gg==
X-Gm-Message-State: AOJu0YzgWvVhKwxfi3dmhEBPkDiASeSCXYAMkd8ZAvq/Cs4WD6McTbNb
	sAOvcpJe9VRtELYwKf7774mtrmT1II7G/K6t6EyzY13sxR2kOymEnl6QA19YV/H9bdjG9na69O8
	OJw15VmRLde7rcys+JAu75a4xCA8=
X-Google-Smtp-Source: AGHT+IFbGlJhThZEsRAS8wVpNSo+FZr6L3uxrnFN6iV5vBjUrZkOlnnEMkUZaJmbiIQNdP+O3PKg0Cud07pjLIQsbys=
X-Received: by 2002:a05:6e02:20c1:b0:36b:23d8:81f2 with SMTP id
 1-20020a056e0220c100b0036b23d881f2mr7648583ilq.31.1713641547745; Sat, 20 Apr
 2024 12:32:27 -0700 (PDT)
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
 <95922a2f-07a1-4555-acd2-c745e59bcb8e@samba.org> <CADvbK_eR4++HbR_RncjV9N__M-uTHtmqcC+_Of1RKVw7Uqf9Cw@mail.gmail.com>
In-Reply-To: <CADvbK_eR4++HbR_RncjV9N__M-uTHtmqcC+_Of1RKVw7Uqf9Cw@mail.gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Sat, 20 Apr 2024 15:32:16 -0400
Message-ID: <CADvbK_dEWNNA_i1maRk4cmAB_uk4G4x0eZfZbrVX=zJ+2H9o_A@mail.gmail.com>
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

On Fri, Apr 19, 2024 at 3:19=E2=80=AFPM Xin Long <lucien.xin@gmail.com> wro=
te:
>
> On Fri, Apr 19, 2024 at 2:51=E2=80=AFPM Stefan Metzmacher <metze@samba.or=
g> wrote:
> >
> > Hi Xin Long,
> >
> > >> But I think its unavoidable for the ALPN and SNI fields on
> > >> the server side. As every service tries to use udp port 443
> > >> and somehow that needs to be shared if multiple services want to
> > >> use it.
> > >>
> > >> I guess on the acceptor side we would need to somehow detach low lev=
el
> > >> udp struct sock from the logical listen struct sock.
> > >>
> > >> And quic_do_listen_rcv() would need to find the correct logical list=
ening
> > >> socket and call quic_request_sock_enqueue() on the logical socket
> > >> not the lowlevel udo socket. The same for all stuff happening after
> > >> quic_request_sock_enqueue() at the end of quic_do_listen_rcv.
> > >>
> > > The implementation allows one low level UDP sock to serve for multipl=
e
> > > QUIC socks.
> > >
> > > Currently, if your 3 quic applications listen to the same address:por=
t
> > > with SO_REUSEPORT socket option set, the incoming connection will cho=
ose
> > > one of your applications randomly with hash(client_addr+port) vi
> > > reuseport_select_sock() in quic_sock_lookup().
> > >
> > > It should be easy to do a further match with ALPN between these 3 qui=
c
> > > socks that listens to the same address:port to get the right quic soc=
k,
> > > instead of that randomly choosing.
> >
> > Ah, that sounds good.
> >
> > > The problem is to parse the TLS Client_Hello message to get the ALPN =
in
> > > quic_sock_lookup(), which is not a proper thing to do in kernel, and
> > > might be rejected by networking maintainers, I need to check with the=
m.
> >
> > Is the reassembling of CRYPTO frames done in the kernel or
> > userspace? Can you point me to the place in the code?
> In quic_inq_handshake_tail() in kernel, for Client Initial packet
> is processed when calling accept(), this is the path:
>
> quic_accept()-> quic_accept_sock_init() -> quic_packet_process() ->
> quic_packet_handshake_process() -> quic_frame_process() ->
> quic_frame_crypto_process() -> quic_inq_handshake_tail().
>
> Note that it's with the accept sock, not the listen sock.
>
> >
> > If it's really impossible to do in C code maybe
> > registering a bpf function in order to allow a listener
> > to check the intial quic packet and decide if it wants to serve
> > that connection would be possible as last resort?
> That's a smart idea! man.
> I think the bpf hook in reuseport_select_sock() is meant to do such
> selection.
>
> For the Client initial packet (the only packet you need to handle),
> I double you will need to do the reassembling, as Client Hello TLS messag=
e
> is always less than 400 byte in my env.
>
> But I think you need to do the decryption for the Client initial packet
> before decoding it then parsing the TLS message from its crypto frame.
I created this patch:

https://github.com/lxin/quic/commit/aee0b7c77df3f39941f98bb901c73fdc560befb=
8

to do this decryption in quic_sock_look() before calling
reuseport_select_sock(), so that it provides the bpf selector with
a plain-text QUIC initial packet:

https://datatracker.ietf.org/doc/html/rfc9000#section-17.2.2

If it's complex for you to do the decryption for the initial packet in
the bpf selector, I will apply this patch. Please let me know.

Thanks.

>
> BTW, for the TLS message parse, I have some prototype code for
> TLS Handshake:
> https://github.com/lxin/tls_hs/blob/master/crypto/tls_hs.c#L2084
>
> The path to get ALPN:
> tls_msg_handle() -> tls_msg_ch_handle() -> tls_ext_handle()
>
> Hope it may be helpful to you.
>
> >
> > > Will you be able to work around this by using Unix Domain Sockets pas=
s
> > > the sockfd to another process?
> >
> > Not really. As that would strict coordination between a lot of
> > independent projects.
> >
> > > (Note that we're assuming all your 3 applications are using in-kernel=
 QUIC)
> >
> > Sure, but I guess for servers using port 443 that the only long term op=
tion.
> > and I don't think it will be less performant than a userspace implement=
ation.
> Cool.
