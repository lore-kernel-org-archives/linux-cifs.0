Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150E514E2F6;
	Thu, 25 Apr 2024 18:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714068410; cv=none; b=KuEWH01+tJYYEre8X5BhoNoaN4dHPBP7xxWULca4YQztJIHxVOKcnFZ6kR4SwNiHPO0L3+ZgJb/4qxMrkNuIfmY8NGB9YgtPgUXwXkEkf1/LCeEHrnZJcVZuO38ROKkI8FjlT2AU2SKmCk8+FXZeKpT7XOHLD38D6o6XVILVLR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714068410; c=relaxed/simple;
	bh=HLVPte3htRUiG1/LHuXLRzG4ghMzVVsHXis72sFvld8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c2tuCLlNJGkc+oRE4LTJxuGtbbEu0Z/pncDcUank4FSqliDQV4wPM7f3yV70kY8+FRFf+pm6u6TylvhaUvEaX/1Ykze1WSHM2CuETlPPm8Z6estRZH8YU9zjz5ik37HqRasfvx1IRTxwdxQo5SmpRfKW/ABessjkH1VTwSsxy/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XTozCVXS; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XTozCVXS"
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7dad4456a99so102282839f.1;
        Thu, 25 Apr 2024 11:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714068408; x=1714673208; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=igTliIWkCqWpfFI06TPlrat2q6efBWyOrCqIVAs5P0A=;
        b=XTozCVXSaYxRbKyLRDIym3LYrBWreoESRVtcgEilsm1P7oH4jFY2uYntmBELC1yIPv
         Vp+RnCvgWiQYcEi1c4UjkijoSMj4WywVnNYhlsndiifZOdT7padv7TqyeXobFtLoFI/G
         /usuM+0/UKM5Y0XMgN1uFMTFOuYIT63PeogejYABleGH4KK3Oz4beK4BdVYCO2vjyqYq
         kpq06vFTj6aKWiPnOM95SBK6YaB2JqTAfGzhuIPPBrBM2rA7KN1RVbcYvriHF/4Nf0lp
         LeI0NDMa6Mq00YU1msT9PpY0rMOJlAYhHsR6bl0E0ekkx5KKQDLF8+zJwDFntFdai3mN
         NjuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714068408; x=1714673208;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=igTliIWkCqWpfFI06TPlrat2q6efBWyOrCqIVAs5P0A=;
        b=b6SeBCQNdNDHVE2EpEWbnO2p8kX5nxQbfQ0VbXr/igFlqbTPsVJkuqAI4HOoZYU0cJ
         b8rGmGhoNmENTIqYtq/EstZR69C3fzs7rpG/51jXUzWRxQ5dGaNluLxI9k7Hw73ZCRGx
         KSu0aI/Nc1mRIUWgqdOD3Qhjv8yrq+uJVwfzHxtwzAdxfzym6lG1MErdaWImOV5jhEhs
         P2T2S/Mmw6u81sX1TsIVpr4+dRQrd7TJH9BJhJugpnenFs9q4rOqiWRQk3wG4DP3FL75
         uNr0H45PBWJeM3/nz/1UwgkIKJL4I39SE6UYimiXAiZmuu+62qpnm+g48zR6afOfJAuI
         Astw==
X-Forwarded-Encrypted: i=1; AJvYcCXQ9mHMBwnxixqp3USPu8JOXj66nkdy8XKIXHtW402VIVNsqD8wrDbW5CgStmhB+/3bT2Fg/TX+hS91VB3t/5RR1YQysNNavjKoBw==
X-Gm-Message-State: AOJu0YwaIVJkb9CY5q469vMMZ/wOpxMgc7pa8zkjWBUE6/+06e66jkjk
	bZ+j+MqSA6+BtTaB/ORkhxW8fNTJzy0yYaWTHMI/GawVsV0am2mOoMGKYD7L5K+QaGBrIvcxdeZ
	6MjjJavUta/CQ7gP0Yu+FqMXp1JY=
X-Google-Smtp-Source: AGHT+IH33r2B00w5mSCCIxD8zZRe6KQ4ngdDG3PJrHjXxUuiJAlT7xJTFr+Kk/ddGuqDddBhCRA9e5VzTNr5YSrEHmg=
X-Received: by 2002:a92:cd87:0:b0:36b:aae:613 with SMTP id r7-20020a92cd87000000b0036b0aae0613mr665657ilb.10.1714068408085;
 Thu, 25 Apr 2024 11:06:48 -0700 (PDT)
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
Date: Thu, 25 Apr 2024 14:06:36 -0400
Message-ID: <CADvbK_e__qpCa44uF+J2Z+2Lhb2suktTNT+CeQayk_uhckVYqQ@mail.gmail.com>
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
>
> It seems there is only a single ebpf program possible per
> reuseport group, so there has to be just a single one.
>
> But is it possible for in kernel servers to also register an epbf program=
?
>
Just confirmed from other ebpf experts, there are no in-kernel interfaces
for loading and interacting with BPF maps/programs(other than from BPF itse=
lf).

It seems that we have to do this match in QUIC stack. In the latest QUIC
code, I added quic_packet_get_alpn(), a 59-line function, to parse ALPNs
and then it will search for the listen sock with these ALPNs in
quic_sock_lookup().

I introduced 'alpn_match' module param, and it can be enabled when loading
the module QUIC by:

  # modprobe quic alpn_match=3D1

You can test it by tests/sample_test in the latest code:

  Start 3 servers:

    # ./sample_test server 0.0.0.0 1234 \
        ./keys/server-key.pem ./keys/server-cert.pem smbd
    # ./sample_test server 0.0.0.0 1234 \
        ./keys/server-key.pem ./keys/server-cert.pem h3
    # ./sample_test server 0.0.0.0 1234 \
        ./keys/server-key.pem ./keys/server-cert.pem ksmbd

  Try to connect on clients with:

    # ./sample_test client 127.0.0.1 1234 ksmbd
    # ./sample_test client 127.0.0.1 1234 smbd
    # ./sample_test client 127.0.0.1 1234 h3

  to see if the corresponding server responds.

There might be some concerns but it's also a useful feature that can not
be implemented in userland QUICs. The commit is here:

https://github.com/lxin/quic/commit/de82f8135f4e9196b503b4ab5b359d88f2b2097=
f

Please check if this is enough for SMB applications.

Note as a listen socket is now identified by [address + port + ALPN] when
alpn_match=3D1, this feature does NOT require SO_REUSEPORT socket option to
be set, unless one wants multiple sockets to listen to
the same [address + port + ALPN].

Thanks.
