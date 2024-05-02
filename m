Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753BD16FF58;
	Thu,  2 May 2024 18:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714673309; cv=none; b=hREh0qO16XkS9ACIMGGew1gPaNXzzQUaHv9fEqJRKrct5TPn02X9fK8kpyBKt+NxRPpOANcyC+SolwMvl5v91jC4dgtTUp0QpTy8th+B+lqx/+7eEU0Y4AJrmxyToUHliEGZG0mdweE8QjSAZVViTK/tMQpLCVADLMP89eYVDvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714673309; c=relaxed/simple;
	bh=+NYX/Uk8aRS4lwimLUm5uzcNKTLy7VTBDsYnd0X/Y/c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Esg60y1d0yQFH1VMSZqpDfiVdXNGc03kayLCnVAcnis8HMJqu8/YNotJbJUaqAlPO+JaisJCchNxaJzNV+9EruA7KXQCrtNqmz62/iv8kU7jHzF3TMqRJSAU0Cl/1tBZnaI6XfNoI02zyeTyXytFYj1eBubgnboXdQmKCCN6s5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e9xNMoph; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e9xNMoph"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-36bff60429cso33698735ab.2;
        Thu, 02 May 2024 11:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714673306; x=1715278106; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lrMykqractpqdToGF/WwG3h/uxArSE3bzswfGx8XcQ0=;
        b=e9xNMoph/TUd6pg8v63jiODfW0YM8Jv6fO2UGo4bQoujUP5QqnFf/uVmJbf+SSbS96
         2ft3veqoQw5+A60MPM1a4lVDpCtbHhPt38/mHAZSDBsIgDxZZxm8Coc6xpy4ge6RSAEn
         kPBwjzfV7oYMta2LQ5GP5HV32kQNLHLVs0Pnn7ePOIZPMROMbkhB49nmu345EMOVYeRa
         Awdh+OQKw2RvfLnNIduEV3fABiTAHbBV9fZwilA1JSEoVJUuY6hhGUjRBPTto5o573+n
         ebSsM4XxQrBmp0TgeR5ATB4I1eLoHRO9mmmejTs2yznqgrO8npiRqWFI+J1M3W4iUBgJ
         gNKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714673306; x=1715278106;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lrMykqractpqdToGF/WwG3h/uxArSE3bzswfGx8XcQ0=;
        b=DtYojtD70iox9KYzAZHW6C4iGzvuO5dR/1myTWqvu7qwIyUa2PDMdn629m2HiO61ig
         cCHVupD0AZ2vV81KCoptEOxBLqNdZEqp5paJ+KDsK76Dlx+AJ+FGpStbuplATGjvhWdx
         UIBIOaCf44SGxWJz7tyqr+eJSFwdXxcQKIwzHTzV9iqY/VRm7BxqXBn9eDKHSh0K5P8V
         z4hSU/AmMlrUJ9g7PbrbotZjXui1nVU4dwOcy7OwLDr5/+ZwoLng8wytVwYmb76LlAVa
         DoRcA+CHmWB/5poi1q4QFylxF6LBrcH6v1xRHmn/7wJQjgzPqaM3IKGOKo5gMkNmMVpZ
         90Mw==
X-Forwarded-Encrypted: i=1; AJvYcCXf88JFLvx2yQNq6nrW7Eqv5iDvxMu1iAyGoBsiq+ypUyZxbjFHPyny0w+mwpiNWvbS6xCUCywj/P3v8wtxOtfZwlV4Z6BUoT2OOQ==
X-Gm-Message-State: AOJu0YwCWs3Rby4qEOj5DqP0HL2zDh1JriyfB3NNPMan56XuxKdp7Sw6
	ofUaR/Dknc9OidYCCORSvfCmutGuucAMDDelmh5jDA14XncmcbtwU6+Aia1A3pVPU2W4P/la2yv
	8N4/koDV11RoPV+x7vlZ6IfhNFCE=
X-Google-Smtp-Source: AGHT+IEwoAxePWWCTH3+v1pt5QpmbhG3wbojT/iCBAucg6ZbQpy54bSQMW3VV1hrgqQ8h+TTlTyGvZTR8cEj+HooTBk=
X-Received: by 2002:a05:6e02:174b:b0:36a:3c07:9caf with SMTP id
 y11-20020a056e02174b00b0036a3c079cafmr542345ill.30.1714673306455; Thu, 02 May
 2024 11:08:26 -0700 (PDT)
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
 <CADvbK_dEWNNA_i1maRk4cmAB_uk4G4x0eZfZbrVX=zJ+2H9o_A@mail.gmail.com>
 <dc3815af-5b46-452b-8bcc-30a0934740a2@samba.org> <CADvbK_e__qpCa44uF+J2Z+2Lhb2suktTNT+CeQayk_uhckVYqQ@mail.gmail.com>
 <2365b657-bea4-4527-9fce-ad11c690bde3@samba.org>
In-Reply-To: <2365b657-bea4-4527-9fce-ad11c690bde3@samba.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 2 May 2024 14:08:14 -0400
Message-ID: <CADvbK_f-WCKp-_NJYOL=j__kxpFuXraFLst3=aPn6BOvX=o+Qg@mail.gmail.com>
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

On Mon, Apr 29, 2024 at 11:20=E2=80=AFAM Stefan Metzmacher <metze@samba.org=
> wrote:
>
> Hi Xin Long,
>
> >>
> > Just confirmed from other ebpf experts, there are no in-kernel interfac=
es
> > for loading and interacting with BPF maps/programs(other than from BPF =
itself).
> >
> > It seems that we have to do this match in QUIC stack. In the latest QUI=
C
> > code, I added quic_packet_get_alpn(), a 59-line function, to parse ALPN=
s
> > and then it will search for the listen sock with these ALPNs in
> > quic_sock_lookup().
> >
> > I introduced 'alpn_match' module param, and it can be enabled when load=
ing
> > the module QUIC by:
> >
> >    # modprobe quic alpn_match=3D1
> >
> > You can test it by tests/sample_test in the latest code:
> >
> >    Start 3 servers:
> >
> >      # ./sample_test server 0.0.0.0 1234 \
> >          ./keys/server-key.pem ./keys/server-cert.pem smbd
> >      # ./sample_test server 0.0.0.0 1234 \
> >          ./keys/server-key.pem ./keys/server-cert.pem h3
> >      # ./sample_test server 0.0.0.0 1234 \
> >          ./keys/server-key.pem ./keys/server-cert.pem ksmbd
> >
> >    Try to connect on clients with:
> >
> >      # ./sample_test client 127.0.0.1 1234 ksmbd
> >      # ./sample_test client 127.0.0.1 1234 smbd
> >      # ./sample_test client 127.0.0.1 1234 h3
> >
> >    to see if the corresponding server responds.
> >
> > There might be some concerns but it's also a useful feature that can no=
t
> > be implemented in userland QUICs. The commit is here:
> >
> > https://github.com/lxin/quic/commit/de82f8135f4e9196b503b4ab5b359d88f2b=
2097f
> >
> > Please check if this is enough for SMB applications.
>
> It look great thanks!
>
> > Note as a listen socket is now identified by [address + port + ALPN] wh=
en
> > alpn_match=3D1, this feature does NOT require SO_REUSEPORT socket optio=
n to
> > be set, unless one wants multiple sockets to listen to
> > the same [address + port + ALPN].
>
> I'd argue that this should be the default and be required before listen()
> or maybe before bind(), so that it can return EADDRINUSE. As EADDRINUSE s=
hould only
> happen for servers it might be useful to have a QUIC_SOCKOPT_LISTEN_ALPN =
instead of
> QUIC_SOCKOPT_ALPN. As QUIC_SOCKOPT_ALPN on a client socket should not gen=
erate let
> bind() care about the alpn value at all.
The latest patches have made it always do alpn_match in kernel, and also
support multiple ALPNs(split by ',' when setting it via sockopt) on both
server and client side. Feel free to check.

Note that:
1. As you expected, setsockopt(QUIC_SOCKOPT_ALPN) must be called before
   listen(), and it will return EADDRINUSE if there's a socket already
   listening to the same IP + PORT + ALPN.

2. ALPN bind/match is a *listening* sockets thing, so it checks ALPN only
   when adding listening sockets in quic_hash(), and it does ALPN only
   when looking up listening sockets in quic_sock_lookup().

   By setting ALPNs in client sockets it will ONLY pack these ALPNs into
   the Client Initial Packet when starting connecting, no bind/match for
   these regular sockets, as these sockets can be found by 4-tuple or
   a source_connection_id. bind() doesn't need to care about ALPN for
   client/regular socket either.

   So it's fine to use QUIC_SOCKOPT_ALPN sockopt for both listen and
   regular/client sockets, as in kernel it acts differently on ALPNs
   for listening and regular sockets. (sorry for confusing, I could
   have moved created another hashtable for listening sockets)

   In other word, a listen socket is identified by

        local_ip + local_port + ALPN(s)

   while a regular socket (represents a quic connection) is identified by:

       local_ip + local_port + remote_ip + remote_port

   or any of those

       source_connection_ids.

3. SO_REUSEPORT is still applied to do some load balance between multiple
   processes listening to the same IP + PORT + ALPN, like:

   on server:
   process A: skA =3D listen(127.0.0.1:1234:smbd)
   process B: skB =3D listen(127.0.0.1:1234:smbd)
   process C: skC =3D listen(127.0.0.1:1234:smbd)

   on client:
   connect(127.0.0.1:1234:smbd)
   connect(127.0.0.1:1234:smbd)
   ...

   on server it will select the sk among (skA, skB and skC) based on the
   source address + port in the request from client.

4. Not sure if multiple ALPNs support are useful to you, here is some
   example about how it works:
   - Without SO_REUSEPORT set:

     On server:
     process A: skA =3D listen(127.0.0.1:1234:smbd,h3,ksmbd)
     process B: skB =3D listen(127.0.0.1:1234:smbd,h3,ksmbd)

     listen() in process B fails and returns EADDRINUSE.

   - with SO_REUSEPORT set:

     On server:
     process A: skA =3D listen(127.0.0.1:1234:smbd,h3,ksmbd)
     process B: skB =3D listen(127.0.0.1:1234:smbd,h3,ksmbd)

     listen() in process B works.

   - with or without SO_REUSEPORT set:

     On server:
     process A: skA =3D listen(127.0.0.1:1234:h3,ksmbd)
     process B: skB =3D listen(127.0.0.1:1234:h3,smbd).
     (there's overlap on ALPN list but not exact the same ALPNs)

     listen() in process B fails and returns EADDRINUSE.

   - the match priority for multiple ALPNs is based on the order on the
     client ALPN list:

     On server:
     process A: skA =3D listen(127.0.0.1:1234:smbd)
     process B: skB =3D listen(127.0.0.1:1234:h3)
     process C: skC =3D listen(127.0.0.1:1234:ksmbd)

     On client:
     process X: skX =3D connect(27.0.0.1:1234:h3,ksmbd,smbd)

     skB will be the one selected to accept the connection, as h3 is the
     1st ALPN on the client ALPN list 'h3,ksmbd,smbd'.

>
> For listens on tcp you also need to specify an explicit port (at least in=
 order
> to be useful).
>
> And it would mean that all application would use it and not block other a=
pplications
> from using an explicit alpn.
>
> Also an module parameter for this means the administrator would have to t=
ake care
> of it, which means it might be unuseable if loaded with it.
Agree, already dropped this param.

>
> I hope to find some time in the next weeks to play with this.
> Should be relatively trivial create a prototype for samba's smbd.
Sounds Cool!

Thanks.
