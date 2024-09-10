Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBFF1DFF0;
	Tue, 10 Sep 2024 02:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725935510; cv=none; b=Q1jcc/oWfXpZrArRQffe76G8YeRsU/q8/tqUuJUzC2N/UKAa/PQNJH3y+M/UInhxN7VDbVWu2jl/bwvkOpLHBKc/hTL2/Ama+3nPPh7SXGlEAxJ1nF2IS/bMhCKtKmrorxTKHJ2w//LHvi3d5IrEoKQR7tvzqh2+S0NbUPxRe7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725935510; c=relaxed/simple;
	bh=QbcRiXAO+yRBGoJotSGkPW5EMEl/CQNIbVnKXqsDLZo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fuGifzKHzVKssTzESZBJEbA1OgbjTgdbwtlz3KCIOd7AShszK9S1UiKVsMyt86R0M0CjtZx7YZM5aMrR89y6P7Kmm4FyeUJ/ywCrbgF9uJ59AWQ+m547propjh0nSQMCqa/3ZjBU5A/IJzGsLsFx1aDDpFQ6yiORF2QQQDQV0ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JFnQr5Io; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JFnQr5Io"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7a99fde9f1dso18927585a.2;
        Mon, 09 Sep 2024 19:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725935507; x=1726540307; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yGOBunRQD9DMT6G0n0e1lQtVboAuyMOhJr5GSFZFoSw=;
        b=JFnQr5Io2H7YFitfjBultO0bn5SL7EkRz5s1ts7tmFAHdIgQ2vJYe1f3zbHSFENmMd
         1/Pn5VSAVq6o7ui24P+GAhaT/QYz7sh9Gn7J2TuZHs/Kk631+JY2Qgu2+88lz9IqiMnL
         Vwq3ga7sQrYea32tt9zqRYxX9xId4US9QVSkwtDfAewxPi4Zpi37rr5hQB6ilY8EkJJc
         g8cEyTZiI0aJ7agazv6y004/m0beLv7rNl4RYrdIX9FMJsdfPSeGgbkyEfommlrzuhvV
         ELDTrFDFKGeGZX1+mhxFMOrDWil6nrIr/qXFX79j72siuJM+sHUe4k/uTdR8Or1WIqGb
         YDUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725935507; x=1726540307;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yGOBunRQD9DMT6G0n0e1lQtVboAuyMOhJr5GSFZFoSw=;
        b=BW0mF1repFrH6rKUkl8IT2EaHqBh0KcFI394rpdBLVmEHltg2IlC5kLTtgU9Rsjjm0
         gAPo9ysPSskcjskm9aLMjbTNj1Fy4nAjizxpqvtloV9mqq0oDPZbT9XoVyXJER3ab5R4
         1rKsHST3vdOJKhqa0O4ER/3nZEmK4I9DE/Nks4MTBqxN6ELaKcBdS3Ihh+vqBRx7iNc3
         xUKv6lGWywi5u4nMoThWITuBdRW1xzfjyiThEDkp+jehvJH9jaESp35wzT1R5zEj3tzN
         t9+pUHT4s8j9HLkg5vhsq5wKv/JWva4y14MQDkJ/glDqjIdaNK+IRX1QoIy+b44JzVi8
         ZtVw==
X-Forwarded-Encrypted: i=1; AJvYcCUkj/Fs4HiNsC2NCOZ9ntGWxm/UZta74Lz9J3IG0tfXZ2MoNznXiPGjyYXJrY7GlPGOmlVfIqc4b0M+@vger.kernel.org
X-Gm-Message-State: AOJu0YyUEcq93dumEmiynNbEPaCTvv07CvTdoTQ1MH7x4V2hVrS93IAI
	62DnAskXoYhweAf0rCsJ0bCw8LkXYKSk9aQPkpbEx0mU0v69BOdmd4y4qIwW
X-Google-Smtp-Source: AGHT+IHhqN8bpHewUKv/4IkvMQrUc+B5kMmFy9GtyhFQo/EhSS+YwBW5LXyDAu8qhM5hFPJdCRy1Hg==
X-Received: by 2002:a05:620a:251:b0:7a9:c0f2:89da with SMTP id af79cd13be357-7a9c0f28a73mr189710585a.43.1725935506545;
        Mon, 09 Sep 2024 19:31:46 -0700 (PDT)
Received: from wsfd-netdev15.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a9a7a1f594sm270429885a.121.2024.09.09.19.31.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Sep 2024 19:31:46 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>
Cc: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Moritz Buhl <mbuhl@openbsd.org>,
	Tyler Fanelli <tfanelli@redhat.com>,
	Pengtao He <hepengtao@xiaomi.com>,
	linux-cifs@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Stefan Metzmacher <metze@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Tom Talpey <tom@talpey.com>,
	kernel-tls-handshake@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Steve Dickson <steved@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Alexander Aring <aahringo@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Daniel Stenberg <daniel@haxx.se>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Subject: [PATCH net-next 0/5] net: implement the QUIC protocol in linux kernel
Date: Mon,  9 Sep 2024 22:30:15 -0400
Message-ID: <cover.1725935420.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Introduction
============

The QUIC protocol, as defined in RFC9000, offers a UDP-based, secure
transport with flow-controlled streams for efficient communication,
low-latency connection setup, and network path migration, ensuring
confidentiality, integrity, and availability across various deployments.

This implementation introduces QUIC support in Linux Kernel, offering
several key advantages:

- Seamless Integration for Kernel Subsystems: Kernel subsystems such as
  SMB and NFS can operate over QUIC seamlessly after the handshake,
  leveraging the net/handshake APIs.

- Standardized Socket APIs for QUIC: This implementation standardizes the
  socket APIs for QUIC, covering essential operations like listen, accept,
  connect, sendmsg, recvmsg, close, get/setsockopt, and getsock/peername().

- Efficient ALPN Routing: It incorporates ALPN routing within the kernel,
  efficiently directing incoming requests to the appropriate applications
  across different processes based on ALPN.

- Performance Enhancements: By minimizing data duplication through
  zero-copy techniques such as sendfile(), and paving the way for crypto
  offloading in NICs, this implementation enhances performance and prepares
  for future optimizations.

This implementation offers fundamental support for the following RFCs:

- RFC9000 - QUIC: A UDP-Based Multiplexed and Secure Transport
- RFC9001 - Using TLS to Secure QUIC
- RFC9002 - QUIC Loss Detection and Congestion Control
- RFC9221 - An Unreliable Datagram Extension to QUIC
- RFC9287 - Greasing the QUIC Bit
- RFC9368 - Compatible Version Negotiation for QUIC
- RFC9369 - QUIC Version 2

The socket APIs for QUIC follow the RFC draft [1]:

- The Sockets API Extensions for In-kernel QUIC Implementations

Implementation
==============

The core idea is to implement QUIC within the kernel, using a userspace
handshake approach.

Only the processing and creation of raw TLS Handshake Messages are handled
in userspace, facilitated by a TLS library like GnuTLS. These messages are
exchanged between kernel and userspace via sendmsg() and recvmsg(), with
cryptographic details conveyed through control messages (cmsg).

The entire QUIC protocol, aside from the TLS Handshake Messages processing
and creation, is managed within the kernel. Rather than using a Upper Layer
Protocol (ULP) layer, this implementation establishes a socket of type
IPPROTO_QUIC (similar to IPPROTO_MPTCP), operating over UDP tunnels.

Kernel consumers can initiate a handshake request from the kernel to
userspace using the existing net/handshake netlink. The userspace
component, such as tlshd service [2], then manages the processing
of the QUIC handshake request.

- Handshake Architecture:

  ┌──────┐  ┌──────┐
  │ APP1 │  │ APP2 │ ...
  └──────┘  └──────┘
  ┌──────────────────────────────────────────┐
  │     {quic_client/server_handshake()}     │<─────────────┐
  └──────────────────────────────────────────┘       ┌─────────────┐
   {send/recvmsg()}      {set/getsockopt()}          │    tlshd    │
   [CMSG handshake_info] [SOCKOPT_CRYPTO_SECRET]     └─────────────┘
                         [SOCKOPT_TRANSPORT_PARAM_EXT]    │   ^
                │ ^                  │ ^                  │   │
  Userspace     │ │                  │ │                  │   │
  ──────────────│─│──────────────────│─│──────────────────│───│────────
  Kernel        │ │                  │ │                  │   │
                v │                  v │                  v   │
  ┌──────────────────────────────────────────┐       ┌─────────────┐
  │ socket (IPPROTO_QUIC) |     protocol     │<──┐   │ handshake   │
  ├──────────────────────────────────────────┤   │   │netlink APIs │
  │ stream | connid | cong  | path  | timer  │   │   └─────────────┘
  ├──────────────────────────────────────────┤   │      │       │
  │  packet  |  frame  |  crypto  |  pnmap   │   │   ┌─────┐ ┌─────┐
  ├──────────────────────────────────────────┤   │   │     │ │     │
  │        input       |       output        │   │───│ SMB │ │ NFS │...
  ├──────────────────────────────────────────┤   │   │     │ │     │
  │                UDP tunnels               │   │   └─────┘ └─────┘
  └──────────────────────────────────────────┘   └──────┴───────┘

- User Data Architecture:

  ┌──────┐  ┌──────┐
  │ APP1 │  │ APP2 │ ...
  └──────┘  └──────┘
   {send/recvmsg()}      {set/getsockopt()}
   [CMSG stream_info]    [SOCKOPT_KEY_UPDATE]
                         [SOCKOPT_CONNECTION_MIGRATION]
                         [SOCKOPT_STREAM_OPEN/RESET/STOP_SENDING]
                │ ^                  │ ^
  Userspace     │ │                  │ │
  ──────────────│─│──────────────────│─│────────────────────────
  Kernel        │ │                  │ │
                v │                  v │
  ┌──────────────────────────────────────────┐
  │ socket (IPPROTO_QUIC) |     protocol     │<──┐{kernel_send/recvmsg()}
  ├──────────────────────────────────────────┤   │{kernel_set/getsockopt()}
  │ stream | connid | cong  | path  | timer  │   │
  ├──────────────────────────────────────────┤   │
  │  packet  |  frame  |  crypto  |  pnmap   │   │   ┌─────┐ ┌─────┐
  ├──────────────────────────────────────────┤   │   │     │ │     │
  │        input       |       output        │   │───│ SMB │ │ NFS │...
  ├──────────────────────────────────────────┤   │   │     │ │     │
  │                UDP tunnels               │   │   └─────┘ └─────┘
  └──────────────────────────────────────────┘   └──────┴───────┘

Usage
=====

This implementation supports a mapping of QUIC into sockets APIs. Similar
to TCP and SCTP, a typical Server and Client use the following system call
sequence to communicate:

    Client                             Server
  ──────────────────────────────────────────────────────────────────────
  sockfd = socket(IPPROTO_QUIC)      listenfd = socket(IPPROTO_QUIC)
  bind(sockfd)                       bind(listenfd)
                                     listen(listenfd)
  connect(sockfd)
  quic_client_handshake(sockfd)
                                     sockfd = accecpt(listenfd)
                                     quic_server_handshake(sockfd, cert)

  sendmsg(sockfd)                    recvmsg(sockfd)
  close(sockfd)                      close(sockfd)
                                     close(listenfd)

Please note that quic_client_handshake() and quic_server_handshake()
functions are currently sourced from libquic [3]. These functions are
responsible for receiving and processing the raw TLS handshake messages
until the completion of the handshake process.

For utilization by kernel consumers, it is essential to have tlshd
service [2] installed and running in userspace. This service receives
and manages kernel handshake requests for kernel sockets. In the kernel,
the APIs closely resemble those used in userspace:

    Client                             Server
  ────────────────────────────────────────────────────────────────────────
  __sock_create(IPPROTO_QUIC, &sock)  __sock_create(IPPROTO_QUIC, &sock)
  kernel_bind(sock)                   kernel_bind(sock)
                                      kernel_listen(sock)
  kernel_connect(sock)
  tls_client_hello_x509(args:{sock})
                                      kernel_accept(sock, &newsock)
                                      tls_server_hello_x509(args:{newsock})

  kernel_sendmsg(sock)                kernel_recvmsg(newsock)
  sock_release(sock)                  sock_release(newsock)
                                      sock_release(sock)

Please be aware that tls_client_hello_x509() and tls_server_hello_x509()
are APIs from net/handshake/. They are used to dispatch the handshake
request to the userspace tlshd service and subsequently block until the
handshake process is completed.

Tests
=====

1. Functional testing

  The testing can be run by `make check` in libquic [3] and include:

  - [Function Tests (PSK)]
  - [Function Tests (Certificate)]
  - [Performance Tests (IPv4)]
  - [Performance Tests (IPv6, Disable 1RTT Encryption)]
  - [Performance Tests (IPv6)]
  - [Performance Tests (IPv4, 10% packet loss on both sides)]
  - [Performance Tests (IPv6, 10% packet loss on both sides)]
  - [InterOperability Tests (IPv4, msquic -> lkquic)]
  - [InterOperability Tests (IPv6, lkquic -> msquic)]
  - [Http/3 Tests (http3_test -> Public Websites)]
  - [Http/3 Tests (http3_test client -> http3_test server)]
  - [Session Resumption Tests]
  - [Sample Tests]
  - [ALPN and Preferred Address Tests]

2. Kernel Consumer Test via tlshd

  The testing can be run using `make check tests=tlshd` in libquic after
  tlshd service [2] is installed and configured. The tests include:

  - [Kernel Tests (kernel -> lkquic, Certificate, Sample)]
  - [Kernel Tests (lkquic -> kernel, Certificate, Sample)]
  - [Kernel Tests (kernel -> lkquic, PSK, Sample)]
  - [Kernel Tests (lkquic -> kernel, PSK, Sample)]
  - [Kernel Tests (kernel -> lkquic, Certificate, Session Resumption)]
  - [Kernel Tests (lkquic -> kernel, Certificate, Session Resumption)]

3. HTTP/3 Interoperability testing via curl

  Linux Kernel QUIC is being integrated for HTTP/3 in curl [4]. Below is
  an overview of connecting to various HTTP/3 servers using different
  QUIC implementations:

  # curl --http3-only --ipv4 https://cloudflare-quic.com/
  # curl --http3-only --ipv4 https://facebook.com/
  # curl --http3-only --ipv4 https://litespeedtech.com/
  # curl --http3-only --ipv4 https://nghttp2.org:4433/
  # curl --http3-only --ipv4 https://outlook.office.com/
  # curl --http3-only --ipv4 https://www.google.com/

4. Performance testing via iperf

  The performance testing was conducted using iperf [5] over a 100G
  physical NIC, evaluating various packet sizes and MTUs:
  
  - QUIC vs. kTLS:
  
    UNIT        size:1024      size:4096      size:16384     size:65536
    Gbits/sec   QUIC | kTLS    QUIC | kTLS    QUIC | kTLS    QUIC | kTLS
    ────────────────────────────────────────────────────────────────────
    mtu:1500    1.67 | 2.16    3.04 | 5.04    3.49 | 7.84    3.83 | 7.95
    ────────────────────────────────────────────────────────────────────
    mtu:9000    2.17 | 2.41    5.47 | 6.19    6.45 | 8.66    7.48 | 8.90
  
  - QUIC(disable_1rtt_encryption) vs. TCP:
  
    UNIT        size:1024      size:4096      size:16384     size:65536
    Gbits/sec   QUIC | TCP     QUIC | TCP     QUIC | TCP     QUIC | TCP
    ────────────────────────────────────────────────────────────────────
    mtu:1500    2.17 | 2.49    3.59 | 8.36    6.09 | 15.1    6.92 | 16.2
    ────────────────────────────────────────────────────────────────────
    mtu:9000    2.47 | 2.54    7.66 | 7.97    14.7 | 20.3    19.1 | 31.3
  
  
  The performance gap between QUIC and kTLS may be attributed to:

  - The absence of Generic Segmentation Offload (GSO) for QUIC.
  - An additional data copy on the transmission (TX) path.
  - Extra encryption required for header protection in QUIC.
  - A longer header length for the stream data in QUIC.

NOTE: The QUIC module is currently labeled as "EXPERIMENTAL".

[1] https://www.ietf.org/archive/id/draft-lxin-quic-socket-apis-00.html
[2] https://github.com/oracle/ktls-utils
[3] https://github.com/lxin/quic
[4] https://github.com/moritzbuhl/curl (-b linux_curl)
[5] https://github.com/lxin/iperf

Xin Long (5):
  net: define IPPROTO_QUIC and SOL_QUIC constants for QUIC protocol
  net: include quic.h in include/uapi/linux for QUIC protocol
  net: implement QUIC protocol code in net/quic directory
  net: integrate QUIC build configuration into Kconfig and Makefile
  Documentation: introduce quic.rst to provide description of QUIC
    protocol

 Documentation/networking/quic.rst |  178 +++
 include/linux/quic.h              |   19 +
 include/linux/socket.h            |    1 +
 include/uapi/linux/in.h           |    2 +
 include/uapi/linux/quic.h         |  192 +++
 net/Kconfig                       |    1 +
 net/Makefile                      |    1 +
 net/quic/Kconfig                  |   34 +
 net/quic/Makefile                 |   19 +
 net/quic/cong.c                   |  630 +++++++++
 net/quic/cong.h                   |  118 ++
 net/quic/connid.c                 |  188 +++
 net/quic/connid.h                 |  120 ++
 net/quic/crypto.c                 |  996 +++++++++++++
 net/quic/crypto.h                 |  153 ++
 net/quic/frame.c                  | 1903 +++++++++++++++++++++++++
 net/quic/frame.h                  |  198 +++
 net/quic/hashtable.h              |  145 ++
 net/quic/input.c                  |  602 ++++++++
 net/quic/input.h                  |  155 ++
 net/quic/number.h                 |  314 +++++
 net/quic/output.c                 |  748 ++++++++++
 net/quic/output.h                 |  199 +++
 net/quic/packet.c                 | 1523 ++++++++++++++++++++
 net/quic/packet.h                 |  125 ++
 net/quic/path.c                   |  422 ++++++
 net/quic/path.h                   |  143 ++
 net/quic/pnspace.c                |  184 +++
 net/quic/pnspace.h                |  209 +++
 net/quic/protocol.c               |  950 +++++++++++++
 net/quic/protocol.h               |   71 +
 net/quic/socket.c                 | 2183 +++++++++++++++++++++++++++++
 net/quic/socket.h                 |  267 ++++
 net/quic/stream.c                 |  252 ++++
 net/quic/stream.h                 |  150 ++
 net/quic/test/sample_test.c       |  615 ++++++++
 net/quic/test/unit_test.c         | 1190 ++++++++++++++++
 net/quic/timer.c                  |  302 ++++
 net/quic/timer.h                  |   43 +
 39 files changed, 15545 insertions(+)
 create mode 100644 Documentation/networking/quic.rst
 create mode 100644 include/linux/quic.h
 create mode 100644 include/uapi/linux/quic.h
 create mode 100644 net/quic/Kconfig
 create mode 100644 net/quic/Makefile
 create mode 100644 net/quic/cong.c
 create mode 100644 net/quic/cong.h
 create mode 100644 net/quic/connid.c
 create mode 100644 net/quic/connid.h
 create mode 100644 net/quic/crypto.c
 create mode 100644 net/quic/crypto.h
 create mode 100644 net/quic/frame.c
 create mode 100644 net/quic/frame.h
 create mode 100644 net/quic/hashtable.h
 create mode 100644 net/quic/input.c
 create mode 100644 net/quic/input.h
 create mode 100644 net/quic/number.h
 create mode 100644 net/quic/output.c
 create mode 100644 net/quic/output.h
 create mode 100644 net/quic/packet.c
 create mode 100644 net/quic/packet.h
 create mode 100644 net/quic/path.c
 create mode 100644 net/quic/path.h
 create mode 100644 net/quic/pnspace.c
 create mode 100644 net/quic/pnspace.h
 create mode 100644 net/quic/protocol.c
 create mode 100644 net/quic/protocol.h
 create mode 100644 net/quic/socket.c
 create mode 100644 net/quic/socket.h
 create mode 100644 net/quic/stream.c
 create mode 100644 net/quic/stream.h
 create mode 100644 net/quic/test/sample_test.c
 create mode 100644 net/quic/test/unit_test.c
 create mode 100644 net/quic/timer.c
 create mode 100644 net/quic/timer.h

-- 
2.43.0

