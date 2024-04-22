Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8AA1D545;
	Mon, 22 Apr 2024 20:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713819507; cv=none; b=le1sjgeqeCx0caWA3xhhoX3HtmFVpEOwmbdHVNmabhORd5ZNbO+yNX8tyAj3f0w4KFlmr7N4TTSOsHq8bgCFmfa92maJGyAfexvVbqqeF2DkJt3dCZAqRY3+9TtuZLHLrCaNJ7/sFr1qW8nQnTNmG+2DHj6gGoit5RfshS4kd1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713819507; c=relaxed/simple;
	bh=BwnqGMnVETwc0KXdR3xkHpOq8Kccp1bF5FE6wwjmlG4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bdIf2K/50XEf7vpQN+V1qfEY/7cBMGXOLkTKFx0yUC+IEn9pj1CtnJBHlh+tiT9o95gK2JtnJeV6RXrefP/2NzQDAkfx+5e77R1dachS+DD/NAQwP1L65y/KI5tC8b9g6vfz/BUU4jW72yKYq26QrYyxEXPdRwh+3sD/MKfF658=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EFiV1A11; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EFiV1A11"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-36a06a409caso25654225ab.3;
        Mon, 22 Apr 2024 13:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713819504; x=1714424304; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BwnqGMnVETwc0KXdR3xkHpOq8Kccp1bF5FE6wwjmlG4=;
        b=EFiV1A11vdztVbSQyXjQCb2v1ERGmn2IGvQFBBswiQjfDvBQYkZj/pz5gxchtJOmk/
         T8suoRZDL+IJR/jADTIrm4dKprPSclYg3L3X4K6eH4GCn86ZvR1kyIfxMOmftYUKF3z+
         N6thhJGMG5cyJjkzzOPcuhMjrA1P0Srg4cW6lUmhB+NJ3qfKfg+Qbb7bnQgthg1Uz7KR
         m+5ZdcUmsig016d74Ty2F/7HkYQoP261UUA9ZnptDi3USJw0pL9/XO74eFHxY9WnuaWf
         F3y4o2qn08Bbc81j1v7iALFMkb4A54EYRQU2kZgnXSjzVy92t6xfHA7U1jvRD9vkGU99
         JvGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713819504; x=1714424304;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BwnqGMnVETwc0KXdR3xkHpOq8Kccp1bF5FE6wwjmlG4=;
        b=uU1pWQp0OpyUsA4m61RDK7bLKJMtUV9Uhaa3G3iL1RfXW3divoUrLA9ogG1dW/Skgf
         kPXzkXTqBg8wOspzgLnn2AII8pfYwDJp7fGMQVIXkHZ/DhmKr6aYL20ETXd01eXLaDM+
         SGUrWNy9H5c+PF6N+/+7R+cnz4IKyjsWkqetByV5gHL4ifbvgGbmId3C8DAv6N70seSy
         jM2QmKkX3mtu5rPH/k+fD/0DTuJ7fkzWe48J0zwoPuSg014mNoKTDqqVk6LHJNwPAy7s
         VzZrpGc1wMfWspNIEFWETXIf2lbJ4r/b5XqLkFpkvWv8s1ojMME60WMmA4h4dDiBTL+7
         9hhA==
X-Forwarded-Encrypted: i=1; AJvYcCX54nd5wtl/A4rgCmCH8yMpyDNmto5D3TA/Z6Hca3VPvbl+wLer/sAoFQVUY9IwoQ7Y5nWmO57dZscssXdVswhnUlACHM8B+hNuoQ==
X-Gm-Message-State: AOJu0YwjKktXnFT357TT58HFksC9bLAxnCbWIWECkoubQXiP6cs0d+jE
	Hh5mhmdqErKngYgXCR3B25czE4pi0F70k0+AaEcCA4TnNErrfHgaUyZEMGppqEZ7WMa1j0WEhEj
	eLfWD1UR2NJ6iShEOW/5dp2e9na4=
X-Google-Smtp-Source: AGHT+IGRzFPzanVbdKTkjs+7WbgWV7Jna9PHJzH4lPSB8bJtMM4YppisUzmtRljQeTDF2p1jdE9qhiCDzku+geR5RtQ=
X-Received: by 2002:a05:6e02:1a6d:b0:36c:cda:e2fc with SMTP id
 w13-20020a056e021a6d00b0036c0cdae2fcmr6998387ilv.16.1713819504551; Mon, 22
 Apr 2024 13:58:24 -0700 (PDT)
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
 <CADvbK_dEWNNA_i1maRk4cmAB_uk4G4x0eZfZbrVX=zJ+2H9o_A@mail.gmail.com> <dc3815af-5b46-452b-8bcc-30a0934740a2@samba.org>
In-Reply-To: <dc3815af-5b46-452b-8bcc-30a0934740a2@samba.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 22 Apr 2024 16:58:13 -0400
Message-ID: <CADvbK_e7i08GAiOenJNTP_m+-MeYjSf7J-vkF+hgRfYGNCjkwQ@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/5] net: In-kernel QUIC implementation with
 Userspace handshake
To: Stefan Metzmacher <metze@samba.org>, Martin KaFai Lau <kafai@fb.com>
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

On Sun, Apr 21, 2024 at 3:27=E2=80=AFPM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Am 20.04.24 um 21:32 schrieb Xin Long:
> > On Fri, Apr 19, 2024 at 3:19=E2=80=AFPM Xin Long <lucien.xin@gmail.com>=
 wrote:
> >>
> >> On Fri, Apr 19, 2024 at 2:51=E2=80=AFPM Stefan Metzmacher <metze@samba=
.org> wrote:
> >>>
> >>> Hi Xin Long,
> >>>
> >>>>> But I think its unavoidable for the ALPN and SNI fields on
> >>>>> the server side. As every service tries to use udp port 443
> >>>>> and somehow that needs to be shared if multiple services want to
> >>>>> use it.
> >>>>>
> >>>>> I guess on the acceptor side we would need to somehow detach low le=
vel
> >>>>> udp struct sock from the logical listen struct sock.
> >>>>>
> >>>>> And quic_do_listen_rcv() would need to find the correct logical lis=
tening
> >>>>> socket and call quic_request_sock_enqueue() on the logical socket
> >>>>> not the lowlevel udo socket. The same for all stuff happening after
> >>>>> quic_request_sock_enqueue() at the end of quic_do_listen_rcv.
> >>>>>
> >>>> The implementation allows one low level UDP sock to serve for multip=
le
> >>>> QUIC socks.
> >>>>
> >>>> Currently, if your 3 quic applications listen to the same address:po=
rt
> >>>> with SO_REUSEPORT socket option set, the incoming connection will ch=
oose
> >>>> one of your applications randomly with hash(client_addr+port) vi
> >>>> reuseport_select_sock() in quic_sock_lookup().
> >>>>
> >>>> It should be easy to do a further match with ALPN between these 3 qu=
ic
> >>>> socks that listens to the same address:port to get the right quic so=
ck,
> >>>> instead of that randomly choosing.
> >>>
> >>> Ah, that sounds good.
> >>>
> >>>> The problem is to parse the TLS Client_Hello message to get the ALPN=
 in
> >>>> quic_sock_lookup(), which is not a proper thing to do in kernel, and
> >>>> might be rejected by networking maintainers, I need to check with th=
em.
> >>>
> >>> Is the reassembling of CRYPTO frames done in the kernel or
> >>> userspace? Can you point me to the place in the code?
> >> In quic_inq_handshake_tail() in kernel, for Client Initial packet
> >> is processed when calling accept(), this is the path:
> >>
> >> quic_accept()-> quic_accept_sock_init() -> quic_packet_process() ->
> >> quic_packet_handshake_process() -> quic_frame_process() ->
> >> quic_frame_crypto_process() -> quic_inq_handshake_tail().
> >>
> >> Note that it's with the accept sock, not the listen sock.
> >>
> >>>
> >>> If it's really impossible to do in C code maybe
> >>> registering a bpf function in order to allow a listener
> >>> to check the intial quic packet and decide if it wants to serve
> >>> that connection would be possible as last resort?
> >> That's a smart idea! man.
> >> I think the bpf hook in reuseport_select_sock() is meant to do such
> >> selection.
> >>
> >> For the Client initial packet (the only packet you need to handle),
> >> I double you will need to do the reassembling, as Client Hello TLS mes=
sage
> >> is always less than 400 byte in my env.
> >>
> >> But I think you need to do the decryption for the Client initial packe=
t
> >> before decoding it then parsing the TLS message from its crypto frame.
> > I created this patch:
> >
> > https://github.com/lxin/quic/commit/aee0b7c77df3f39941f98bb901c73fdc560=
befb8
> >
> > to do this decryption in quic_sock_look() before calling
> > reuseport_select_sock(), so that it provides the bpf selector with
> > a plain-text QUIC initial packet:
> >
> > https://datatracker.ietf.org/doc/html/rfc9000#section-17.2.2
> >
> > If it's complex for you to do the decryption for the initial packet in
> > the bpf selector, I will apply this patch. Please let me know.
>
> I guess in addition to quic_server_handshake(), which is called
> after accept(), there should be quic_server_prepare_listen()
> (and something similar for in kernel servers) that setup the reuseport
> magic for the socket, so that it's not needed in every application.
It's done when calling listen(), see quic_inet_listen()->quic_hash()
where only listening sockets with its sk_reuseport set will be
added into the reuseport group.

It means SO_REUSEPORT sockopt must be set for every socket
before calling listen().

>
> It seems there is only a single ebpf program possible per
> reuseport group, so there has to be just a single one.
Yes, a single ebpf program per reuseport group should work.
see prepare_sk_fds() in kernel selftests for select_reuseport bfp.

>
> But is it possible for in kernel servers to also register an epbf program=
?
Good question. TBH, I don't really know much about epbf programming.
I guess the real problem is how you pass the .o file to kernel space?

Another question is, in the selftests:
tools/testing/selftests/bpf/prog_tests/select_reuseport.c
tools/testing/selftests/bpf/progs/test_select_reuseport_kern.c

it created a global reuseport_array, and then added these sockets
into this array for the later lookup, but these sockets are all created
in the same process.

But your case is that the sockets are created in different processes.
I'm not sure if it's possible to add sockets from different processes
into the same reuseport_array?

Added Martin who introduced BPF_PROG_TYPE_SK_REUSEPORT,
I guess he may know the answers.

Thanks.
