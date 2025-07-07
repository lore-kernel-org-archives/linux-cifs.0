Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3085128C026
	for <linux-cifs@vger.kernel.org>; Mon,  7 Jul 2025 08:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751877678; cv=none; b=npwA2YDoKW9WWWqdRjVgTHuH0dnUZweaREKgeu63uMF4z+/YnwmXe2i2gmM8QsCv5Oai2pFqEj721W9FFb4Ch/XqVIyBzlb37noTMouoB+MBoNFB+/35oXIB5wEr16foRbPQ1klGHRXv/EoRQEn6xJ4MJ/Fz7xS+RAn5v1n51vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751877678; c=relaxed/simple;
	bh=n4K8sTkcd70US6I93sLm1Ycf4p3o5su04bwLYUAnk0U=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=jlz6iQR5RfVvSQdTRonGMfltPnO9RrcRsTRuSJM32FSUi9jBIF99FBM/B1HN0gM/JFWjNHjgO3iIBZFMmatbNlqS7yYpMkg4CMQPZymtRXh5qOginjhMcQKjNHj9Ng2o8Otqlf/tLjYXDMkskhAwF9eJ41Oj5d+bi83onzMdBSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ft1CcBxy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ft1CcBxy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751877674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l3xHQ8BSgPt/jlZ3R6F0MT30EQibaCu2QcMe6rwL1Oo=;
	b=ft1CcBxy3ODyuDmUAAo0bJWM6FZ5d1/eIxxplMDizg+25TPu+vgW5uJ7F9LJ+Lmz69uRtW
	uj1CkqcAfOVC7ZtXf9eDoRkCCBJPiPnyphy0JcjCqrG8xkq23KW4KMTFeVZAU9tRgZLvUU
	89ChQsSWXiy94usT5YxhfRJmNrsmN80=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-18-yY1QVG9mPyijInsNMp77sQ-1; Mon,
 07 Jul 2025 04:41:09 -0400
X-MC-Unique: yY1QVG9mPyijInsNMp77sQ-1
X-Mimecast-MFC-AGG-ID: yY1QVG9mPyijInsNMp77sQ_1751877666
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B5B201809C8A;
	Mon,  7 Jul 2025 08:41:05 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.81])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8287718FFCA6;
	Mon,  7 Jul 2025 08:40:47 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <cover.1751743914.git.lucien.xin@gmail.com>
References: <cover.1751743914.git.lucien.xin@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, davem@davemloft.net,
    kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
    Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
    Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>,
    Tyler Fanelli <tfanelli@redhat.com>,
    Pengtao He <hepengtao@xiaomi.com>, linux-cifs@vger.kernel.org,
    Steve French <smfrench@gmail.com>,
    Namjae Jeon <linkinjeon@kernel.org>,
    Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>,
    kernel-tls-handshake@lists.linux.dev,
    Chuck Lever <chuck.lever@oracle.com>,
    Jeff Layton <jlayton@kernel.org>,
    Benjamin Coddington <bcodding@redhat.com>,
    Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>,
    Alexander Aring <aahringo@redhat.com>,
    Cong Wang <xiyou.wangcong@gmail.com>,
    "D . Wythe" <alibuda@linux.alibaba.com>,
    Jason Baron <jbaron@akamai.com>, illiliti <illiliti@protonmail.com>,
    Sabrina Dubroca <sd@queasysnail.net>,
    Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
    Daniel Stenberg <daniel@haxx.se>,
    Andy Gospodarek <andrew.gospodarek@broadcom.com>
Subject: Re: [PATCH net-next 00/15] net: introduce QUIC infrastructure and core subcomponents
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Jul 2025 09:40:44 +0100
Message-ID: <2334439.1751877644@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17


Xin Long <lucien.xin@gmail.com> wrote:

> Introduction
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> The QUIC protocol, as defined in RFC9000, offers a UDP-based, secure
> transport with flow-controlled streams for efficient communication,
> low-latency connection setup, and network path migration, ensuring
> confidentiality, integrity, and availability across various deployments.
>=20
> This implementation introduces QUIC support in Linux Kernel, offering
> several key advantages:
>=20
> - Seamless Integration for Kernel Subsystems: Kernel subsystems such as
>   SMB and NFS can operate over QUIC seamlessly after the handshake,
>   leveraging the net/handshake APIs.
>=20
> - Standardized Socket APIs for QUIC: This implementation standardizes the
>   socket APIs for QUIC, covering essential operations like listen, accept,
>   connect, sendmsg, recvmsg, close, get/setsockopt, and getsock/peername(=
).
>=20
> - Efficient ALPN Routing: It incorporates ALPN routing within the kernel,
>   efficiently directing incoming requests to the appropriate applications
>   across different processes based on ALPN.
>=20
> - Performance Enhancements: By minimizing data duplication through
>   zero-copy techniques such as sendfile(), and paving the way for crypto
>   offloading in NICs, this implementation enhances performance and prepar=
es
>   for future optimizations.
>=20
> This implementation offers fundamental support for the following RFCs:
>=20
> - RFC9000 - QUIC: A UDP-Based Multiplexed and Secure Transport
> - RFC9001 - Using TLS to Secure QUIC
> - RFC9002 - QUIC Loss Detection and Congestion Control
> - RFC9221 - An Unreliable Datagram Extension to QUIC
> - RFC9287 - Greasing the QUIC Bit
> - RFC9368 - Compatible Version Negotiation for QUIC
> - RFC9369 - QUIC Version 2
>=20
> The socket APIs for QUIC follow the RFC draft [1]:
>=20
> - The Sockets API Extensions for In-kernel QUIC Implementations
>=20
> Implementation
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> The core idea is to implement QUIC within the kernel, using a userspace
> handshake approach.
>=20
> Only the processing and creation of raw TLS Handshake Messages are handled
> in userspace, facilitated by a TLS library like GnuTLS. These messages are
> exchanged between kernel and userspace via sendmsg() and recvmsg(), with
> cryptographic details conveyed through control messages (cmsg).
>=20
> The entire QUIC protocol, aside from the TLS Handshake Messages processing
> and creation, is managed within the kernel. Rather than using a Upper Lay=
er
> Protocol (ULP) layer, this implementation establishes a socket of type
> IPPROTO_QUIC (similar to IPPROTO_MPTCP), operating over UDP tunnels.
>=20
> For kernel consumers, they can initiate a handshake request from the kern=
el
> to userspace using the existing net/handshake netlink. The userspace
> component, such as tlshd service [2], then manages the processing
> of the QUIC handshake request.
>=20
> - Handshake Architecture:
>=20
>   =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=90  =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=90
>   =E2=94=82 APP1 =E2=94=82  =E2=94=82 APP2 =E2=94=82 ...
>   =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=98  =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=98
>   =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=90
>   =E2=94=82     {quic_client/server_handshake()}     =E2=94=82<=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
>   =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=98       =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=90
>    {send/recvmsg()}      {set/getsockopt()}          =E2=94=82    tlshd  =
  =E2=94=82
>    [CMSG handshake_info] [SOCKOPT_CRYPTO_SECRET]     =E2=94=94=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
>                          [SOCKOPT_TRANSPORT_PARAM_EXT]    =E2=94=82   ^
>                 =E2=94=82 ^                  =E2=94=82 ^                 =
 =E2=94=82   =E2=94=82
>   Userspace     =E2=94=82 =E2=94=82                  =E2=94=82 =E2=94=82 =
                 =E2=94=82   =E2=94=82
>   =E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=82=E2=94=80=
=E2=94=82=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=82=E2=94=80=E2=94=82=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=82=E2=94=
=80=E2=94=80=E2=94=80=E2=94=82=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80
>   Kernel        =E2=94=82 =E2=94=82                  =E2=94=82 =E2=94=82 =
                 =E2=94=82   =E2=94=82
>                 v =E2=94=82                  v =E2=94=82                 =
 v   =E2=94=82
>   =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=90       =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=90
>   =E2=94=82 protocol, timer, =E2=94=82 socket (IPPROTO_QUIC) =E2=94=82<=
=E2=94=80=E2=94=80=E2=94=90   =E2=94=82 handshake   =E2=94=82
>   =E2=94=82                  =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=A4   =E2=94=82   =E2=94=82netlink APIs =E2=
=94=82
>   =E2=94=82 common, family,  =E2=94=82 outqueue  |  inqueue  =E2=94=82   =
=E2=94=82   =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
>   =E2=94=82                  =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=A4   =E2=94=82      =E2=94=82       =E2=94=82
>   =E2=94=82 stream, connid,  =E2=94=82         frame         =E2=94=82   =
=E2=94=82   =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90=
 =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
>   =E2=94=82                  =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=A4   =E2=94=82   =E2=94=82     =E2=94=82 =E2=
=94=82     =E2=94=82
>   =E2=94=82 path, pnspace,   =E2=94=82         packet        =E2=94=82   =
=E2=94=82=E2=94=80=E2=94=80=E2=94=80=E2=94=82 SMB =E2=94=82 =E2=94=82 NFS =
=E2=94=82...
>   =E2=94=82                  =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=A4   =E2=94=82   =E2=94=82     =E2=94=82 =E2=
=94=82     =E2=94=82
>   =E2=94=82 cong, crypto     =E2=94=82       UDP tunnels     =E2=94=82   =
=E2=94=82   =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98=
 =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
>   =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=98   =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=98
>=20
> - User Data Architecture:
>=20
>   =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=90  =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=90
>   =E2=94=82 APP1 =E2=94=82  =E2=94=82 APP2 =E2=94=82 ...
>   =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=98  =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=98
>    {send/recvmsg()}   {set/getsockopt()}              {recvmsg()}
>    [CMSG stream_info] [SOCKOPT_KEY_UPDATE]            [EVENT conn update]
>                       [SOCKOPT_CONNECTION_MIGRATION]  [EVENT stream updat=
e]
>                       [SOCKOPT_STREAM_OPEN/RESET/STOP]
>                 =E2=94=82 ^               =E2=94=82 ^                    =
 ^
>   Userspace     =E2=94=82 =E2=94=82               =E2=94=82 =E2=94=82    =
                 =E2=94=82
>   =E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=82=E2=94=80=
=E2=94=82=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=82=E2=94=80=E2=94=82=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=82=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80
>   Kernel        =E2=94=82 =E2=94=82               =E2=94=82 =E2=94=82    =
                 =E2=94=82
>                 v =E2=94=82               v =E2=94=82  =E2=94=8C=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=98
>   =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=AC=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=90
>   =E2=94=82 protocol, timer, =E2=94=82 socket (IPPROTO_QUIC) =E2=94=82<=
=E2=94=80=E2=94=80=E2=94=90{kernel_send/recvmsg()}
>   =E2=94=82                  =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=A4   =E2=94=82{kernel_set/getsockopt()}
>   =E2=94=82 common, family,  =E2=94=82 outqueue  |  inqueue  =E2=94=82   =
=E2=94=82{kernel_recvmsg()}
>   =E2=94=82                  =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=A4   =E2=94=82
>   =E2=94=82 stream, connid,  =E2=94=82         frame         =E2=94=82   =
=E2=94=82   =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90=
 =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90
>   =E2=94=82                  =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=A4   =E2=94=82   =E2=94=82     =E2=94=82 =E2=
=94=82     =E2=94=82
>   =E2=94=82 path, pnspace,   =E2=94=82         packet        =E2=94=82   =
=E2=94=82=E2=94=80=E2=94=80=E2=94=80=E2=94=82 SMB =E2=94=82 =E2=94=82 NFS =
=E2=94=82...
>   =E2=94=82                  =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=A4   =E2=94=82   =E2=94=82     =E2=94=82 =E2=
=94=82     =E2=94=82
>   =E2=94=82 cong, crypto     =E2=94=82       UDP tunnels     =E2=94=82   =
=E2=94=82   =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98=
 =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98
>   =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=98   =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=B4=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=98
>=20
> Interface
> =3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
> This implementation supports a mapping of QUIC into sockets APIs. Similar
> to TCP and SCTP, a typical Server and Client use the following system call
> sequence to communicate:
>=20
>     Client                             Server
>   =E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80
>   sockfd =3D socket(IPPROTO_QUIC)      listenfd =3D socket(IPPROTO_QUIC)
>   bind(sockfd)                       bind(listenfd)
>                                      listen(listenfd)
>   connect(sockfd)
>   quic_client_handshake(sockfd)
>                                      sockfd =3D accecpt(listenfd)
>                                      quic_server_handshake(sockfd, cert)
>=20
>   sendmsg(sockfd)                    recvmsg(sockfd)
>   close(sockfd)                      close(sockfd)
>                                      close(listenfd)
>=20
> Please note that quic_client_handshake() and quic_server_handshake()
> functions are currently sourced from libquic [3]. These functions are
> responsible for receiving and processing the raw TLS handshake messages
> until the completion of the handshake process.
>=20
> For utilization by kernel consumers, it is essential to have tlshd
> service [2] installed and running in userspace. This service receives
> and manages kernel handshake requests for kernel sockets. In the kernel,
> the APIs closely resemble those used in userspace:
>=20
>     Client                             Server
>   =E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=
=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80
>   __sock_create(IPPROTO_QUIC, &sock)  __sock_create(IPPROTO_QUIC, &sock)
>   kernel_bind(sock)                   kernel_bind(sock)
>                                       kernel_listen(sock)
>   kernel_connect(sock)
>   tls_client_hello_x509(args:{sock})
>                                       kernel_accept(sock, &newsock)
>                                       tls_server_hello_x509(args:{newsock=
})
>=20
>   kernel_sendmsg(sock)                kernel_recvmsg(newsock)
>   sock_release(sock)                  sock_release(newsock)
>                                       sock_release(sock)
>=20
> Please be aware that tls_client_hello_x509() and tls_server_hello_x509()
> are APIs from net/handshake/. They are used to dispatch the handshake
> request to the userspace tlshd service and subsequently block until the
> handshake process is completed.

Can you please put this (or something like this) into Documentation/
somewhere?

Thanks,
David

