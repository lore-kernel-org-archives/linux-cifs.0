Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914314562AC
	for <linux-cifs@vger.kernel.org>; Fri, 18 Sep 2026 19:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789761580; cv=pass; b=oDpTOoY33Sulhqky/iPsrnHgYJVGRORUNTsAm9ZOZ06lQOFnCeHZBo1GpLVcQvjlPoC96TBG9zmmFaAVieYLjr1xriUVuHgbgrX7UchuQivrfH8T8Ce23s1IgyBTxCANVEt/5JVlEnhXmxz9Kf6yDlySQew/XyMXSFoXkLOkuDY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789761580; c=relaxed/simple;
	bh=jCF476RySwYSqITrGDiqkFKVDJvm2/7DsHLCoSAKcQQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=elha1koCkPeLqwGJ7Ff/Ru1q+tr6GDM/hBcT7axtPvHD7DxIgPrieeC4QeQfKwvr8sN4iwNVckT9Kgu5gCmesAunQWmCMUG/iMWqDMhgMdQTMAwMwviZAr16YZyI9GHW6CT9naUdEc3Kq3AmdnSbQ9Wbhjpjpy+l5seD57TZ7rc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kf1iyZKm; arc=pass smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kf1iyZKm"
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-8693af0d7c4so1385328b3a.3
        for <linux-cifs@vger.kernel.org>; Fri, 18 Sep 2026 12:59:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789761578; cv=none;
        d=google.com; s=arc-20260327;
        b=ch5+JDxFw3vkVPUzmlMJGUyPvh3daONXWC55qoPgJkQdL50a11sHLSaN3MK5bgHPWK
         dVlSDcygUYL99ujCKITHxJ8cWmYNZZIhzhbayehCr+fbnSDKFtWwqbcgybPjHr8jPXS9
         NpJYaVje59TolFxWtiOPN9sbriHV5NHIo+jqSLJB7Sk3//uEFMLVj8D+aAcN23z9p9OU
         91qKrz6zUx3XbSlU0HE/nkukKjE4HnNccXj+V27GeMFbjw5edOD3xU2XOTBDgDbSR85F
         JO+iaJs0EzU6dtuI5HppkILxIBpIMMkVfIbvBOlEiTmxrlnnV2S00TOyE/+l4PyUlhdp
         rXaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DDo5fVJZwtBSB653D/Zb4ircxwAHfAv5i0dPXUACjGQ=;
        fh=EeG8XCstbQ7kQboZX7OkqVRcUfFcsIMYTif+xf8x7zA=;
        b=M3qSaKLXKufM1k+6RpqemJQ26pJoIk/1CgQXbIn/iztuIPIF1TSxCcqMxUO7l7bv0P
         XFSFXTGPmQRJ+EAoxjJ0hb+nYuZauRzoJJ8XRU+JcgR6Y3SqAWA87pv0LhpkwKpTJ2Jk
         vwrXG0CsCVbmlGSnafM6mWU+Z9IFIfkPa95vuAlWNrim27KKLu1T9v/nlK+a4I5LUSGg
         7p9Mx3SP+vqrHNSJtt5P8+/WFgYgsmpUMWjfCDCP6uPeFQg1HjsKHx2XDFjkQMKVvr4M
         D/odw2X9pk/+h7sAtMLo4CI8jHFc9IsfmwDp9rpfiWv7ClP2+6yPWQxteEipV/4DeLeU
         swSA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789761578; x=1790366378; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DDo5fVJZwtBSB653D/Zb4ircxwAHfAv5i0dPXUACjGQ=;
        b=kf1iyZKmtiseEmv7OBU2XW6ugBhtxeiigA98OxDkzoK3eLe4IC5cSeEDbWEYJnOCsK
         EbafOBrOA5EQJVD/ae4UMq9nn4yJsCLrjwhEEdPX4o7CjoSo+hujypzmAlZDKvoth0XW
         puc7TbY6sdQXmmE6MFV2VCZwlpy6dNSLV6OXJkgf3GmVeWUSXt1RiYxastiQXDAFFhq1
         CxJeD81hdNFFjcfmMIEfPAGbUfPfrv+vGOY79SuAhg9eRZftosYH9mFtcFLJFLY4KtrT
         E6G0jLypEnvmJoyYv9s1lDw61x6Z+EdNBnBvBW1PW759Xf2qgQodL/os3V1DScTNZTSx
         cmcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789761578; x=1790366378;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DDo5fVJZwtBSB653D/Zb4ircxwAHfAv5i0dPXUACjGQ=;
        b=kgf1mpaq1iL/PlmUF1mU5orAkYx94pTDbQ98vVnvHpveMuzJuXZdwvK74eWVkDj6EX
         DPKTv96cPoIyLyBGDhSaYf3TxS5Rqo7ROre+0keUD0fcePxTOuXSfxL+5FlFRsi3RCsP
         ANRAK1xEFpzUiX2/LLZeZXeFwS2BXLckRM1TkDi2k7JhRZDdau5Z5KGt9m/7Bg7rZq0i
         xgMxWy0ZAOQJTgrU0iaLme4iQR3g5u98bhUszoH3xcvYHoRFY4kRJRgW8kdaNFTsrlyP
         XoA8ycA0d/m1w1HuQUR3vC/wXv9yoNhf629A4zfC0zldtzXedPgj2K9V40StPdBFzEbx
         JWKQ==
X-Forwarded-Encrypted: i=1; AKwUvBw7Xifj2Ego/V0bgQBOMxcnXwgoaXTN8+Mqa8Mu+Py+stjqh73eLjlB42V+umfSWwazYpYYxKTBwQQf@vger.kernel.org
X-Gm-Message-State: AFuF++nfZKQa1sLqSpqN4L057urZUmtC23oxkpvAV5lLR4GBdon3wvKj
	XzPRBdNlmrV6WWnhM1WkbVTBGO/QfNexsV5hOTNSfhQhGfTiYKMMNCbRflcLtYvTNhuTv4tMUpT
	2EZ5X2tU81GFR565RW6U0HpYUZ/dKz8I=
X-Gm-Gg: AYBFou1aQtDVz+SMHpdNB1yewerml2xSP+OVRwDDtrnc+ZDKKOyjicpbYsaKsxrD/Ef
	GGNOU7vA/vQ1AQTjkADbK8YspwRdwj331RTx5H/c7ib2MSStwWow0WNrs/1T2DefW/ya3Uedntr
	NGUyK7IN9sBMDyd0fkLra3a6jxPuNg2hs942Py1Qsot0y2eyJGk/VLHByAyH0GxE4AzCkVKLUKX
	p3K0vcy3CQaB6p2MugUzUROeCsJ5toAG+JJOJIbsRcVFbepqIC4QbYV2Xwy28kMrqipbt4Ih052
	b4Eun287yBmB32o52eXRthc+kA4Nd0wuNONODhebt96sRGEAVviVOJxWyqEdfg0OQHVM8oDUJ+I
	aLCSpHl300XOq151XWEQRXQoZL+alIo9LIYFNLV6N6L7AbpEpfzJFvOm1
X-Received: by 2002:a05:6a00:4b14:b0:86f:2d2f:48ef with SMTP id
 d2e1a72fcca58-874dbee3cbbmr6012573b3a.1.1789761577824; Fri, 18 Sep 2026
 12:59:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1789393775.git.lucien.xin@gmail.com> <CADvbK_cMQ7psJQQkaa6LLcjYc2M2jt60FY+rJgW6YG7hgdwSRA@mail.gmail.com>
 <31ebf88a-9d33-4e5a-bb38-c98881457739@redhat.com>
In-Reply-To: <31ebf88a-9d33-4e5a-bb38-c98881457739@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 18 Sep 2026 15:59:26 -0400
X-Gm-Features: AcwNN1WO4IIGGlC8phbPtNjbAHHEjYsbPjmCraD_yVvAOltVw3QRcZ9E_TPUwdQ
Message-ID: <CADvbK_drW3dUFy_kv1opvwwjCyCXQeLGyO2ounscbwxegCzn7Q@mail.gmail.com>
Subject: Re: [PATCH net-next v15 00/15] net: introduce QUIC infrastructure and
 core subcomponents
To: Paolo Abeni <pabeni@redhat.com>, sashiko@lists.linux.dev
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev, davem@davemloft.net, 
	kuba@kernel.org, Eric Dumazet <edumazet@google.com>, Simon Horman <horms@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>, 
	Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz <dreibh@simula.no>, linux-cifs@vger.kernel.org, 
	Paulo Alcantara <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>, 
	kernel-tls-handshake@lists.linux.dev, Chuck Lever <chuck.lever@oracle.com>, 
	Jeff Layton <jlayton@kernel.org>, Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, 
	Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>, 
	Matthieu Baerts <matttbe@kernel.org>, John Ericson <mail@johnericson.me>, 
	Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe" <alibuda@linux.alibaba.com>, 
	Jason Baron <jbaron@akamai.com>, illiliti <illiliti@protonmail.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Daniel Stenberg <daniel@haxx.se>, Andy Gospodarek <andrew.gospodarek@broadcom.com>, 
	mef@scarletmail.rutgers.edu, paul@jakma.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 17, 2026 at 4:35=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> On 9/16/26 20:33, Xin Long wrote:
> > On Mon, Sep 14, 2026 at 9:52=E2=80=AFAM Xin Long <lucien.xin@gmail.com>=
 wrote:
> >>
> >> Introduction
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >> The QUIC protocol, defined in RFC 9000, is a secure, multiplexed trans=
port
> >> built on top of UDP. It enables low-latency connection establishment,
> >> stream-based communication with flow control, and supports connection
> >> migration across network paths, while ensuring confidentiality, integr=
ity,
> >> and availability.
> >>
> >> This implementation introduces QUIC support in Linux Kernel, offering
> >> several key advantages:
> >>
> >> - In-Kernel QUIC Support for Subsystems: Enables kernel subsystems
> >>    such as SMB and NFS to operate over QUIC with minimal changes. Once=
 the
> >>    handshake is complete via the net/handshake APIs, data exchange pro=
ceeds
> >>    over standard in-kernel transport interfaces.
> >>
> >> - Standard Socket API Semantics: Implements core socket operations
> >>    (listen(), accept(), connect(), sendmsg(), recvmsg(), close(),
> >>    getsockopt(), setsockopt(), getsockname(), and getpeername()),
> >>    allowing user space to interact with QUIC sockets in a familiar,
> >>    POSIX-compliant way.
> >>
> >> - ALPN-Based Connection Dispatching: Supports in-kernel ALPN
> >>    (Application-Layer Protocol Negotiation) routing, allowing demultip=
lexing
> >>    of QUIC connections across different user-space processes based
> >>    on the ALPN identifiers.
> >>
> >> - Performance Enhancements: Handles all control messages in-kernel
> >>    to reduce syscall overhead, incorporates zero-copy mechanisms such =
as
> >>    sendfile() to minimize data movement, and is also structured to sup=
port
> >>    future crypto hardware offloads.
> >>
> >> This implementation offers fundamental support for the following RFCs:
> >>
> >> - RFC9000 - QUIC: A UDP-Based Multiplexed and Secure Transport
> >> - RFC9001 - Using TLS to Secure QUIC
> >> - RFC9002 - QUIC Loss Detection and Congestion Control
> >> - RFC9221 - An Unreliable Datagram Extension to QUIC
> >> - RFC9287 - Greasing the QUIC Bit
> >> - RFC9368 - Compatible Version Negotiation for QUIC
> >> - RFC9369 - QUIC Version 2
> >>
> >> The socket APIs for QUIC follow the RFC draft [1]:
> >>
> >> - The Sockets API Extensions for In-kernel QUIC Implementations
> >>
> >> Implementation
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >> The central design is to implement QUIC within the kernel while delega=
ting
> >> the handshake to userspace.
> >>
> >> Only the processing and creation of raw TLS Handshake Messages are han=
dled
> >> in userspace, facilitated by a TLS library like GnuTLS. These messages=
 are
> >> exchanged between kernel and userspace via sendmsg() and recvmsg(), wi=
th
> >> cryptographic details conveyed through control messages (cmsg).
> >>
> >> The entire QUIC protocol, aside from the TLS Handshake Messages proces=
sing
> >> and creation, is managed in the kernel. Rather than using an Upper Lay=
er
> >> Protocol (ULP) layer, this implementation establishes a socket of type
> >> IPPROTO_QUIC (similar to IPPROTO_MPTCP), operating over UDP tunnels.
> >>
> >> For kernel consumers, they can initiate a handshake request from the k=
ernel
> >> to userspace using the existing net/handshake netlink. The userspace
> >> component, such as tlshd service [2], then manages the processing
> >> of the QUIC handshake request.
> >>
> >> - Handshake Architecture:
> >>
> >>    =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=90  =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=90
> >>    =E2=94=82 APP1 =E2=94=82  =E2=94=82 APP2 =E2=94=82 ...
> >>    =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=98  =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=98
> >>    =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=90
> >>    =E2=94=82     {quic_client/server_handshake()}     =E2=94=82<=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
> >>    =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=98       =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=90
> >>     {send/recvmsg()}      {set/getsockopt()}          =E2=94=82    tls=
hd    =E2=94=82
> >>     [CMSG handshake_info] [SOCKOPT_CRYPTO_SECRET]     =E2=94=94=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
> >>                           [SOCKOPT_TRANSPORT_PARAM_EXT]    =E2=94=82  =
 ^
> >>                  =E2=94=82 ^                  =E2=94=82 ^             =
     =E2=94=82   =E2=94=82
> >>    Userspace     =E2=94=82 =E2=94=82                  =E2=94=82 =E2=94=
=82                  =E2=94=82   =E2=94=82
> >>    =E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=82=E2=94=
=80=E2=94=82=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=82=E2=94=80=E2=94=82=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=82=E2=
=94=80=E2=94=80=E2=94=80=E2=94=82=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80
> >>    Kernel        =E2=94=82 =E2=94=82                  =E2=94=82 =E2=94=
=82                  =E2=94=82   =E2=94=82
> >>                  v =E2=94=82                  v =E2=94=82             =
     v   =E2=94=82
> >>    =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=90       =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=90
> >>    =E2=94=82 protocol, timer, =E2=94=82 socket (IPPROTO_QUIC) =E2=94=
=82<=E2=94=80=E2=94=80=E2=94=90   =E2=94=82 handshake   =E2=94=82
> >>    =E2=94=82                  =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=A4   =E2=94=82   =E2=94=82netlink APIs =
=E2=94=82
> >>    =E2=94=82 common, family,  =E2=94=82 outqueue  |  inqueue  =E2=94=
=82   =E2=94=82   =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=98
> >>    =E2=94=82                  =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=A4   =E2=94=82      =E2=94=82       =E2=
=94=82
> >>    =E2=94=82 stream, connid,  =E2=94=82         frame         =E2=94=
=82   =E2=94=82   =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=90 =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
> >>    =E2=94=82                  =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=A4   =E2=94=82   =E2=94=82     =E2=94=82 =
=E2=94=82     =E2=94=82
> >>    =E2=94=82 path, pnspace,   =E2=94=82         packet        =E2=94=
=82   =E2=94=82=E2=94=80=E2=94=80=E2=94=80=E2=94=82 SMB =E2=94=82 =E2=94=82=
 NFS =E2=94=82...
> >>    =E2=94=82                  =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=A4   =E2=94=82   =E2=94=82     =E2=94=82 =
=E2=94=82     =E2=94=82
> >>    =E2=94=82 cong, crypto     =E2=94=82       UDP tunnels     =E2=94=
=82   =E2=94=82   =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=98 =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
> >>    =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=98   =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=98
> >>
> >> - User Data Architecture:
> >>
> >>    =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=90  =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=90
> >>    =E2=94=82 APP1 =E2=94=82  =E2=94=82 APP2 =E2=94=82 ...
> >>    =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=98  =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=98
> >>     {send/recvmsg()}   {set/getsockopt()}              {recvmsg()}
> >>     [CMSG stream_info] [SOCKOPT_KEY_UPDATE]            [EVENT conn upd=
ate]
> >>                        [SOCKOPT_CONNECTION_MIGRATION]  [EVENT stream u=
pdate]
> >>                        [SOCKOPT_STREAM_OPEN/RESET/STOP]
> >>                  =E2=94=82 ^               =E2=94=82 ^                =
     ^
> >>    Userspace     =E2=94=82 =E2=94=82               =E2=94=82 =E2=94=82=
                     =E2=94=82
> >>    =E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=82=E2=94=
=80=E2=94=82=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=82=E2=94=80=E2=94=82=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=82=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80
> >>    Kernel        =E2=94=82 =E2=94=82               =E2=94=82 =E2=94=82=
                     =E2=94=82
> >>                  v =E2=94=82               v =E2=94=82  =E2=94=8C=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=98
> >>    =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=90
> >>    =E2=94=82 protocol, timer, =E2=94=82 socket (IPPROTO_QUIC) =E2=94=
=82<=E2=94=80=E2=94=80=E2=94=90{kernel_send/recvmsg()}
> >>    =E2=94=82                  =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=A4   =E2=94=82{kernel_set/getsockopt()}
> >>    =E2=94=82 common, family,  =E2=94=82 outqueue  |  inqueue  =E2=94=
=82   =E2=94=82{kernel_recvmsg()}
> >>    =E2=94=82                  =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=A4   =E2=94=82
> >>    =E2=94=82 stream, connid,  =E2=94=82         frame         =E2=94=
=82   =E2=94=82   =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=90 =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
> >>    =E2=94=82                  =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=A4   =E2=94=82   =E2=94=82     =E2=94=82 =
=E2=94=82     =E2=94=82
> >>    =E2=94=82 path, pnspace,   =E2=94=82         packet        =E2=94=
=82   =E2=94=82=E2=94=80=E2=94=80=E2=94=80=E2=94=82 SMB =E2=94=82 =E2=94=82=
 NFS =E2=94=82...
> >>    =E2=94=82                  =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=A4   =E2=94=82   =E2=94=82     =E2=94=82 =
=E2=94=82     =E2=94=82
> >>    =E2=94=82 cong, crypto     =E2=94=82       UDP tunnels     =E2=94=
=82   =E2=94=82   =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=98 =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
> >>    =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=98   =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=98
> >>
> >> Interface
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >> This implementation supports a mapping of QUIC into sockets APIs. Simi=
lar
> >> to TCP and SCTP, a typical Server and Client use the following system =
call
> >> sequence to communicate:
> >>
> >>      Client                             Server
> >>    =E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80
> >>    sockfd =3D socket(IPPROTO_QUIC)      listenfd =3D socket(IPPROTO_QU=
IC)
> >>    bind(sockfd)                       bind(listenfd)
> >>                                       listen(listenfd)
> >>    connect(sockfd)
> >>    quic_client_handshake(sockfd)
> >>                                       sockfd =3D accept(listenfd)
> >>                                       quic_server_handshake(sockfd, ce=
rt)
> >>
> >>    sendmsg(sockfd)                    recvmsg(sockfd)
> >>    close(sockfd)                      close(sockfd)
> >>                                       close(listenfd)
> >>
> >> Please note that quic_client_handshake() and quic_server_handshake()
> >> functions are currently sourced from libquic [3]. These functions are
> >> responsible for receiving and processing the raw TLS handshake message=
s
> >> until the completion of the handshake process.
> >>
> >> For utilization by kernel consumers, it is essential to have tlshd
> >> service [2] installed and running in userspace. This service receives
> >> and manages kernel handshake requests for kernel sockets. In the kerne=
l,
> >> the APIs closely resemble those used in userspace:
> >>
> >>      Client                             Server
> >>    =E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80
> >>    __sock_create(IPPROTO_QUIC, &sock)  __sock_create(IPPROTO_QUIC, &so=
ck)
> >>    kernel_bind(sock)                   kernel_bind(sock)
> >>                                        kernel_listen(sock)
> >>    kernel_connect(sock)
> >>    tls_client_hello_x509(args:{sock})
> >>                                        kernel_accept(sock, &newsock)
> >>                                        tls_server_hello_x509(args:{new=
sock})
> >>
> >>    kernel_sendmsg(sock)                kernel_recvmsg(newsock)
> >>    sock_release(sock)                  sock_release(newsock)
> >>                                        sock_release(sock)
> >>
> >> Please be aware that tls_client_hello_x509() and tls_server_hello_x509=
()
> >> are APIs from net/handshake/. They are used to dispatch the handshake
> >> request to the userspace tlshd service and subsequently block until th=
e
> >> handshake process is completed.
> >>
> >> Use Cases
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >> - Samba
> >>
> >>    Stefan Metzmacher has integrated Linux QUIC into Samba for both cli=
ent
> >>    and server roles [4].
> >>
> >> - tlshd
> >>
> >>    The tlshd daemon [2] facilitates Linux QUIC handshake requests from
> >>    kernel sockets. This is essential for enabling protocols like SMB
> >>    and NFS over QUIC.
> >>
> >> - curl
> >>
> >>    Linux QUIC is being integrated into curl [5] for HTTP/3. Example us=
age:
> >>
> >>    # curl --http3-only https://nghttp2.org:4433/
> >>    # curl --http3-only https://www.google.com/
> >>    # curl --http3-only https://facebook.com/
> >>    # curl --http3-only https://outlook.office.com/
> >>    # curl --http3-only https://cloudflare-quic.com/
> >>
> >> - httpd-portable
> >>
> >>    Moritz Buhl has deployed an HTTP/3 server over Linux QUIC [6] that =
is
> >>    accessible via Firefox and curl:
> >>
> >>    https://d.moritzbuhl.de/pub
> >>
> >> - NetPerfMeter
> >>
> >>    The latest NetPerfMeter release supports Linux QUIC and can be used=
 to
> >>    run performance evaluations [10].
> >>
> >> Test Coverage
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >> The Coverage (gcov) of Functional and Interop Tests:
> >>
> >> https://d.moritzbuhl.de/lcov
> >>
> >> - Functional Tests
> >>
> >>    The libquic self-tests (make check) pass on all major architectures=
:
> >>    x86_64, i386, s390x, aarch64, ppc64le.
> >>
> >> - Interop tests
> >>
> >>    Interoperability was validated using the QUIC Interop Runner [7] ag=
ainst
> >>    all major userland QUIC stacks. Results are available at:
> >>
> >>    https://d.moritzbuhl.de/
> >>
> >> - Fuzzing via Syzkaller
> >>
> >>    Syzkaller has been running kernel fuzzing with QUIC for weeks using
> >>    tests/syzkaller/ in libquic [3].
> >>
> >> - Performance Testing
> >>
> >>    Performance was benchmarked using iperf [8] over a 100G NIC using
> >>    various MTUs and packet sizes:
> >>
> >>    - QUIC vs. kTLS:
> >>
> >>      UNIT        size:1024      size:4096      size:16384     size:655=
36
> >>      Gbits/sec   QUIC | kTLS    QUIC | kTLS    QUIC | kTLS    QUIC | k=
TLS
> >>      =E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80
> >>      mtu:1500    2.27 | 3.26    3.02 | 6.97    3.36 | 9.74    3.48 | 1=
0.8
> >>      =E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80
> >>      mtu:9000    3.66 | 3.72    5.87 | 8.92    7.03 | 11.2    8.04 | 1=
1.4
> >>
> >>    - QUIC(disable_1rtt_encryption) vs. TCP:
> >>
> >>      UNIT        size:1024      size:4096      size:16384     size:655=
36
> >>      Gbits/sec   QUIC | TCP     QUIC | TCP     QUIC | TCP     QUIC | T=
CP
> >>      =E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80
> >>      mtu:1500    3.09 | 4.59    4.46 | 14.2    5.07 | 21.3    5.18 | 2=
3.9
> >>      =E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80
> >>      mtu:9000    4.60 | 4.65    8.41 | 14.0    11.3 | 28.9    13.5 | 3=
9.2
> >>
> >>
> >>    The performance gap between QUIC and kTLS may be attributed to:
> >>
> >>    - The absence of Generic Segmentation Offload (GSO) for QUIC.
> >>    - An additional data copy on the transmission (TX) path.
> >>    - Extra encryption required for header protection in QUIC.
> >>    - A longer header length for the stream data in QUIC.
> >>
> >> Patches
> >> =3D=3D=3D=3D=3D=3D=3D
> >>
> >> Note: This implementation is organized into five parts and submitted a=
cross
> >> two patchsets for review. This patchset includes Parts 1=E2=80=932, wh=
ile Parts 3=E2=80=935
> >> will be submitted in a subsequent patchset. For complete series, see [=
9].
> >>
> >> 1. Infrastructure (2):
> >>
> >>    net: define IPPROTO_QUIC and SOL_QUIC constants
> >>    net: build socket infrastructure for QUIC protocol
> >>
> >> 2. Subcomponents (13):
> >>
> >>    quic: provide common utilities and data structures
> >>    quic: provide family ops for address and protocol
> >>    quic: provide quic.h header files for kernel and userspace
> >>    quic: add stream management
> >>    quic: add connection id management
> >>    quic: add path management
> >>    quic: add congestion control
> >>    quic: add packet number space
> >>    quic: add crypto key derivation and installation
> >>    quic: add crypto packet encryption and decryption
> >>    quic: add timer management
> >>    quic: add packet builder base
> >>    quic: add packet parser base
> >>
> >> 3. Data Processing (8):
> >>
> >>    quic: add frame encoder and decoder base
> >>    quic: implement outqueue transmission and flow control
> >>    quic: implement outqueue sack and retransmission
> >>    quic: implement inqueue receiving and flow control
> >>    quic: implement frame creation functions
> >>    quic: implement frame processing functions
> >>    quic: implement packet creation functions
> >>    quic: implement packet processing functions
> >>
> >> 4. Socket APIs (6):
> >>
> >>    quic: support bind/listen/connect/accept/close()
> >>    quic: support sendmsg() and recvmsg()
> >>    quic: support socket options related to interaction after handshake
> >>    quic: support socket options related to settings prior to handshake
> >>    quic: support socket options related to setup during handshake
> >>    quic: support socket ioctls and socket dump via procfs
> >>
> >> 5. Documentation and Selftests (3):
> >>
> >>    Documentation: describe QUIC protocol interface in quic.rst
> >>    quic: create sample test using handshake APIs for kernel consumers
> >>    selftests: net: add tests for QUIC protocol
> >>
> >> Notice: The QUIC module is currently labeled as "EXPERIMENTAL".
> >>
> >> All contributors are recognized in the respective patches with the tag=
 of
> >> 'Signed-off-by:'. Special thanks to Moritz Buhl and Stefan Metzmacher =
whose
> >> practical use cases and insightful feedback have been instrumental in
> >> shaping the design and advancing the development.
> >>
> >> References
> >> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >> [1]  https://datatracker.ietf.org/doc/html/draft-lxin-quic-socket-apis
> >> [2]  https://github.com/oracle/ktls-utils
> >> [3]  https://github.com/lxin/quic
> >> [4]  https://gitlab.com/samba-team/samba/-/merge_requests/4019
> >> [5]  https://github.com/moritzbuhl/curl/tree/linux_curl
> >> [6]  https://github.com/moritzbuhl/httpd-portable
> >> [7]  https://github.com/quic-interop/quic-interop-runner
> >> [8]  https://github.com/lxin/iperf
> >> [9]  https://github.com/lxin/net-next/commits/quic/
> >> [10] https://www.nntb.no/~dreibh/netperfmeter/
> >>
> >> Changes in v2-v15: See individual patch changelogs for details.
> >>
> >> Xin Long (15):
> >>    net: define IPPROTO_QUIC and SOL_QUIC constants
> >>    net: build socket infrastructure for QUIC protocol
> >>    quic: provide common utilities and data structures
> >>    quic: provide family ops for address and protocol
> >>    quic: provide quic.h header files for kernel and userspace
> >>    quic: add stream management
> >>    quic: add connection id management
> >>    quic: add path management
> >>    quic: add congestion control
> >>    quic: add packet number space
> >>    quic: add crypto key derivation and installation
> >>    quic: add crypto packet encryption and decryption
> >>    quic: add timer management
> >>    quic: add packet builder base
> >>    quic: add packet parser base
> >>
> >>   Documentation/networking/ip-sysctl.rst        |   39 +
> >>   MAINTAINERS                                   |    9 +
> >>   include/linux/quic.h                          |   38 +
> >>   include/linux/socket.h                        |    1 +
> >>   include/trace/events/sock.h                   |    3 +-
> >>   include/uapi/linux/in.h                       |    2 +
> >>   include/uapi/linux/quic.h                     |  241 ++++
> >>   net/Kconfig                                   |    1 +
> >>   net/Makefile                                  |    1 +
> >>   net/quic/Kconfig                              |   35 +
> >>   net/quic/Makefile                             |    9 +
> >>   net/quic/common.c                             |  565 ++++++++
> >>   net/quic/common.h                             |  220 +++
> >>   net/quic/cong.c                               |  340 +++++
> >>   net/quic/cong.h                               |  132 ++
> >>   net/quic/connid.c                             |  283 ++++
> >>   net/quic/connid.h                             |  183 +++
> >>   net/quic/crypto.c                             | 1251 +++++++++++++++=
++
> >>   net/quic/crypto.h                             |   88 ++
> >>   net/quic/family.c                             |  446 ++++++
> >>   net/quic/family.h                             |   44 +
> >>   net/quic/packet.c                             | 1055 ++++++++++++++
> >>   net/quic/packet.h                             |  123 ++
> >>   net/quic/path.c                               |  589 ++++++++
> >>   net/quic/path.h                               |  192 +++
> >>   net/quic/pnspace.c                            |  273 ++++
> >>   net/quic/pnspace.h                            |  201 +++
> >>   net/quic/protocol.c                           |  403 ++++++
> >>   net/quic/protocol.h                           |   57 +
> >>   net/quic/socket.c                             |  654 +++++++++
> >>   net/quic/socket.h                             |  242 ++++
> >>   net/quic/stream.c                             |  416 ++++++
> >>   net/quic/stream.h                             |  133 ++
> >>   net/quic/timer.c                              |  154 ++
> >>   net/quic/timer.h                              |   45 +
> >>   tools/include/uapi/linux/in.h                 |    2 +
> >>   .../perf/trace/beauty/include/linux/socket.h  |    1 +
> >>   usr/include/Makefile                          |    1 +
> >>   38 files changed, 8471 insertions(+), 1 deletion(-)
> >>   create mode 100644 include/linux/quic.h
> >>   create mode 100644 include/uapi/linux/quic.h
> >>   create mode 100644 net/quic/Kconfig
> >>   create mode 100644 net/quic/Makefile
> >>   create mode 100644 net/quic/common.c
> >>   create mode 100644 net/quic/common.h
> >>   create mode 100644 net/quic/cong.c
> >>   create mode 100644 net/quic/cong.h
> >>   create mode 100644 net/quic/connid.c
> >>   create mode 100644 net/quic/connid.h
> >>   create mode 100644 net/quic/crypto.c
> >>   create mode 100644 net/quic/crypto.h
> >>   create mode 100644 net/quic/family.c
> >>   create mode 100644 net/quic/family.h
> >>   create mode 100644 net/quic/packet.c
> >>   create mode 100644 net/quic/packet.h
> >>   create mode 100644 net/quic/path.c
> >>   create mode 100644 net/quic/path.h
> >>   create mode 100644 net/quic/pnspace.c
> >>   create mode 100644 net/quic/pnspace.h
> >>   create mode 100644 net/quic/protocol.c
> >>   create mode 100644 net/quic/protocol.h
> >>   create mode 100644 net/quic/socket.c
> >>   create mode 100644 net/quic/socket.h
> >>   create mode 100644 net/quic/stream.c
> >>   create mode 100644 net/quic/stream.h
> >>   create mode 100644 net/quic/timer.c
> >>   create mode 100644 net/quic/timer.h
> >>
> >> --
> >> 2.47.1
> >>
> >
> > I've looked into the Sashiko reviews:
> >
> > [Sashiko-Gemini]
> > (https://sashiko.dev/#/patchset/cover.1789393775.git.lucien.xin%40gmail=
.com)
> >
> > - 0 issues reported. I'm not sure whether the workflow still uses this =
report.
>
> FYI, the results from the public sashiko instance are integreated into
> the nipa one and validated by other models. The nipa instance is the
> most relevant entry point.
>
Got it.

Does anyone know how Sashiko is deployed to support this
=E2=80=9Ccross-review=E2=80=9D with multiple AI modes?

(As shown on: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/cover.178=
9393775.git.lucien.xin%40gmail.com)

Thanks.
