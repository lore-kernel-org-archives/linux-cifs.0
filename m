Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D3C3376A6;
	Mon, 18 Aug 2025 14:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526341; cv=none; b=Y9d1/Qa+L3u+fL7ahF0rdSD3NSYuVpLFvL9JRFkZ3wkDBVYaDe3X82fsJPEJNaFBke2/paKIqr72YebesbhzOPJ88PySq0mo4xj8m/ydd9VxhPQwmLQIiNcpn0D5cgi+dW5dIXAHf5VTzqcb8b8z4aTopgQS8HdptNNH7WCT1bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526341; c=relaxed/simple;
	bh=cqHiKOq8Z1bUAHdglJJuEmFh34PQMeEBZfgGsF7E0I0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=jGpqIVmrxIOWI3K19vJtIccAgDJFMc5N61hvlUqtymdSK2nUpcYj76+48+MAcGDm6k7OTJOHQNdSoXNhSCsx8LbfuTU8UA9XMsLyXJoQFMeIaoIlc3bQIJNnctwS68AgvWr9856PjkmKQEAMmQNKYLsi7Bozn7EksDFaaWBYD4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GajoKcLB; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GajoKcLB"
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e934c8f9751so1231835276.2;
        Mon, 18 Aug 2025 07:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755526338; x=1756131138; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=69VuWJPXtmF2SfyvEIupKxGOjg8zp/LCreDDXU2KJpU=;
        b=GajoKcLBFB4RQif3NyguBTvzUWUYhPhqAvTf4u7kVt/pp8YQIEs+h8WitviGPnZdMF
         L2x+lnNbssWEaECtgOwDeC1H2oSK+J+JKqvhp/lXj6czPlt9icB0EZj5kNrzOjB28Fnd
         RrvRzBG5+PcaE3MRWB1WnU0MGcf3fxnngv2Gqn1bA6k4bzI+nZfTmdjWORuhkXkeQwuM
         OPKornw5UWY3WzdAU4Uf+QZEU6OJAAH2/+YgtCFeHKQjsnX6kAp1C+FNu6fx8XQgvN+x
         x2tC4y0I02ocAT9h5mIFKpCzJ2lOx5G7OmoU6GT481HV6fgT3aWENl5by/nW/7S3cuEn
         e2wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755526338; x=1756131138;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=69VuWJPXtmF2SfyvEIupKxGOjg8zp/LCreDDXU2KJpU=;
        b=f7/22Z9vXEVjjrErqnsU7wD1E0MJHju18f/2P/tACOv0Y41SfVk/Qrful0mToVNmpN
         PWF9DCtA9K94YfsRhSvTFw1f7QKmS5KU4hEYceLsnUpC+uzNt2NlybhrpRy0tT92+Pgb
         0bGYZAAsmdWZEpJLlZ2cY5jnb6w1KqfZ9B7Uj4C7StoHpCaTQsbUiRzTpue+WFa3AVk/
         xzo6JWwECFibMNvoxbKusVbV3qt9IDSBJtTdd1DyOjNAy/lA/KtKxDjpsouoio2arQLd
         GZnkdhnRWixM7AkQ8GnTPLuZ9ZYbEYw5U9A2pG85N14+3DXEXdNcLx2S2BomWVORYd5Z
         uN2w==
X-Forwarded-Encrypted: i=1; AJvYcCWm0Bho0mFJPf9oXq+07Pp13mPnFTuiEVCtAZq4p7JQkL7xRcrE4x88W7Olz2ZZAOQdD/nTtGtrBUUL@vger.kernel.org
X-Gm-Message-State: AOJu0YxZ+sl+e0kdh1V+/PTN9Wf2g6x2Cl4yjyJ0H4aoavOYLim+99q1
	nYUY0d5CDXvyh8xKeh6iulVgHLCPOrSzLpVrwnnKIInej3sYKr7hbtZ1wSwlpvRnbSQ=
X-Gm-Gg: ASbGncvbfK9AMAGph/+Ue/dhHyQB4MDVbxm9Uxn3qJC+ujVmEw20yoXtp4gvp8LElg+
	DmODaBLLBpL9E4zmStu8APgpSs+EfLRCoWgdfXOmuf5Arow/DyaXo3qtjbkEUM+gd7XNSFhdH/z
	fQQzE9GadOICc9b0hW22bqClfxMvUz7aBQDmYfCMidOYd1fWfFzBB4RJaYcX0T5L0xmYsBRc0w+
	/YyefouQbYHpw9bB9L1UeAgld7GZu0sCGBYi3fDnbVL9z3fDSuaY2Adx+M/HR/7VmxNXGyaTmpg
	lDqZO5AIUaEiXVqBrCOFe8v/o4+lcmLb5IjPKtiZly+u4O/XXQKz+LH0kFdLqYPGo4WkLLrwKmZ
	Xl8pCm26gxBilMqv56x/83nGw9BtrbV2EjIdnkRJWWsGbrT4TdFa7gHmEA7kM3rk2gU2H6JVpwg
	==
X-Google-Smtp-Source: AGHT+IHebU1Pd1QE9zSENt8E6w5UiX89C3q4irE9dQFI4S2ekaWnC4Ci02+qahaEMWBnCpAVyiSe4Q==
X-Received: by 2002:a05:6902:1025:b0:e94:d144:d464 with SMTP id 3f1490d57ef6-e94d144d5a4mr3563894276.0.1755526336082;
        Mon, 18 Aug 2025 07:12:16 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e933261c40bsm3157451276.8.2025.08.18.07.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 07:12:15 -0700 (PDT)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Metzmacher <metze@samba.org>,
	Moritz Buhl <mbuhl@openbsd.org>,
	Tyler Fanelli <tfanelli@redhat.com>,
	Pengtao He <hepengtao@xiaomi.com>,
	linux-cifs@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Tom Talpey <tom@talpey.com>,
	kernel-tls-handshake@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Benjamin Coddington <bcodding@redhat.com>,
	Steve Dickson <steved@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Alexander Aring <aahringo@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	"D . Wythe" <alibuda@linux.alibaba.com>,
	Jason Baron <jbaron@akamai.com>,
	illiliti <illiliti@protonmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Daniel Stenberg <daniel@haxx.se>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Subject: [PATCH net-next v2 00/15] net: introduce QUIC infrastructure and core subcomponents
Date: Mon, 18 Aug 2025 10:04:23 -0400
Message-ID: <cover.1755525878.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
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

The QUIC protocol, defined in RFC 9000, is a secure, multiplexed transport
built on top of UDP. It enables low-latency connection establishment,
stream-based communication with flow control, and supports connection
migration across network paths, while ensuring confidentiality, integrity,
and availability.

This implementation introduces QUIC support in Linux Kernel, offering
several key advantages:

- In-Kernel QUIC Support for Subsystems: Enables kernel subsystems
  such as SMB and NFS to operate over QUIC with minimal changes. Once the
  handshake is complete via the net/handshake APIs, data exchange proceeds
  over standard in-kernel transport interfaces.

- Standard Socket API Semantics: Implements core socket operations
  (listen(), accept(), connect(), sendmsg(), recvmsg(), close(),
  getsockopt(), setsockopt(), getsockname(), and getpeername()),
  allowing user space to interact with QUIC sockets in a familiar,
  POSIX-compliant way.

- ALPN-Based Connection Dispatching: Supports in-kernel ALPN
  (Application-Layer Protocol Negotiation) routing, allowing demultiplexing
  of QUIC connections across different user-space processes based
  on the ALPN identifiers.

- Performance Enhancements: Handles all control messages in-kernel
  to reduce syscall overhead, incorporates zero-copy mechanisms such as
  sendfile() minimize data movement, and is also structured to support
  future crypto hardware offloads.

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

The central design is to implement QUIC within the kernel while delegating
the handshake to userspace.

Only the processing and creation of raw TLS Handshake Messages are handled
in userspace, facilitated by a TLS library like GnuTLS. These messages are
exchanged between kernel and userspace via sendmsg() and recvmsg(), with
cryptographic details conveyed through control messages (cmsg).

The entire QUIC protocol, aside from the TLS Handshake Messages processing
and creation, is managed within the kernel. Rather than using a Upper Layer
Protocol (ULP) layer, this implementation establishes a socket of type
IPPROTO_QUIC (similar to IPPROTO_MPTCP), operating over UDP tunnels.

For kernel consumers, they can initiate a handshake request from the kernel
to userspace using the existing net/handshake netlink. The userspace
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
  ──────────────│─│──────────────────│─│──────────────────│───│───────
  Kernel        │ │                  │ │                  │   │
                v │                  v │                  v   │
  ┌──────────────────┬───────────────────────┐       ┌─────────────┐
  │ protocol, timer, │ socket (IPPROTO_QUIC) │<──┐   │ handshake   │
  │                  ├───────────────────────┤   │   │netlink APIs │
  │ common, family,  │ outqueue  |  inqueue  │   │   └─────────────┘
  │                  ├───────────────────────┤   │      │       │
  │ stream, connid,  │         frame         │   │   ┌─────┐ ┌─────┐
  │                  ├───────────────────────┤   │   │     │ │     │
  │ path, pnspace,   │         packet        │   │───│ SMB │ │ NFS │...
  │                  ├───────────────────────┤   │   │     │ │     │
  │ cong, crypto     │       UDP tunnels     │   │   └─────┘ └─────┘
  └──────────────────┴───────────────────────┘   └──────┴───────┘

- User Data Architecture:

  ┌──────┐  ┌──────┐
  │ APP1 │  │ APP2 │ ...
  └──────┘  └──────┘
   {send/recvmsg()}   {set/getsockopt()}              {recvmsg()}
   [CMSG stream_info] [SOCKOPT_KEY_UPDATE]            [EVENT conn update]
                      [SOCKOPT_CONNECTION_MIGRATION]  [EVENT stream update]
                      [SOCKOPT_STREAM_OPEN/RESET/STOP]
                │ ^               │ ^                     ^
  Userspace     │ │               │ │                     │
  ──────────────│─│───────────────│─│─────────────────────│───────────
  Kernel        │ │               │ │                     │
                v │               v │  ┌──────────────────┘
  ┌──────────────────┬───────────────────────┐
  │ protocol, timer, │ socket (IPPROTO_QUIC) │<──┐{kernel_send/recvmsg()}
  │                  ├───────────────────────┤   │{kernel_set/getsockopt()}
  │ common, family,  │ outqueue  |  inqueue  │   │{kernel_recvmsg()}
  │                  ├───────────────────────┤   │
  │ stream, connid,  │         frame         │   │   ┌─────┐ ┌─────┐
  │                  ├───────────────────────┤   │   │     │ │     │
  │ path, pnspace,   │         packet        │   │───│ SMB │ │ NFS │...
  │                  ├───────────────────────┤   │   │     │ │     │
  │ cong, crypto     │       UDP tunnels     │   │   └─────┘ └─────┘
  └──────────────────┴───────────────────────┘   └──────┴───────┘

Interface
=========

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
                                     sockfd = accept(listenfd)
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

Use Cases
=========

- Samba

  Stefan Metzmacher has integrated Linux QUIC into Samba for both client
  and server roles [4].

- tlshd

  The tlshd daemon [2] facilitates Linux QUIC handshake requests from
  kernel sockets. This is essential for enabling protocols like SMB
  and NFS over QUIC.

- curl

  Linux QUIC is being integrated into curl [5] for HTTP/3. Example usage:

  # curl --http3-only https://nghttp2.org:4433/
  # curl --http3-only https://www.google.com/
  # curl --http3-only https://facebook.com/
  # curl --http3-only https://outlook.office.com/
  # curl --http3-only https://cloudflare-quic.com/

- httpd-portable

  Moritz Buhl has deployed an HTTP/3 server over Linux QUIC [6] that is
  accessible via Firefox and curl:

  https://d.moritzbuhl.de/pub

Test Coverage
=============

The Coverage (gcov) of Functional and Interop Tests:

https://d.moritzbuhl.de/lcov

- Functional Tests

  The libquic self-tests (make check) pass on all major architectures:
  x86_64, i386, s390x, aarch64, ppc64le.

- Interop tests

  Interoperability was validated using the QUIC Interop Runner [7] against
  all major userland QUIC stacks. Results are available at:

  https://d.moritzbuhl.de/

- Fuzzing via Syzkaller

  Syzkaller has been running kernel fuzzing with QUIC for weeks using
  tests/syzkaller/ in libquic [3]..

- Performance Testing

  Performance was benchmarked using iperf [8] over a 100G NIC with
  using various MTUs and packet sizes:
  
  - QUIC vs. kTLS:
  
    UNIT        size:1024      size:4096      size:16384     size:65536
    Gbits/sec   QUIC | kTLS    QUIC | kTLS    QUIC | kTLS    QUIC | kTLS
    ────────────────────────────────────────────────────────────────────
    mtu:1500    2.27 | 3.26    3.02 | 6.97    3.36 | 9.74    3.48 | 10.8
    ────────────────────────────────────────────────────────────────────
    mtu:9000    3.66 | 3.72    5.87 | 8.92    7.03 | 11.2    8.04 | 11.4
  
  - QUIC(disable_1rtt_encryption) vs. TCP:
  
    UNIT        size:1024      size:4096      size:16384     size:65536
    Gbits/sec   QUIC | TCP     QUIC | TCP     QUIC | TCP     QUIC | TCP
    ────────────────────────────────────────────────────────────────────
    mtu:1500    3.09 | 4.59    4.46 | 14.2    5.07 | 21.3    5.18 | 23.9
    ────────────────────────────────────────────────────────────────────
    mtu:9000    4.60 | 4.65    8.41 | 14.0    11.3 | 28.9    13.5 | 39.2
  
  
  The performance gap between QUIC and kTLS may be attributed to:

  - The absence of Generic Segmentation Offload (GSO) for QUIC.
  - An additional data copy on the transmission (TX) path.
  - Extra encryption required for header protection in QUIC.
  - A longer header length for the stream data in QUIC.

Patches
=======

Note: This implementation is organized into five parts and submitted across
two patchsets for review. This patchset includes Parts 1–2, while Parts 3–5
will be submitted in a subsequent patchset. For complete series, see [9].

1. Infrastructure (2):

  net: define IPPROTO_QUIC and SOL_QUIC constants
  net: build socket infrastructure for QUIC protocol

2. Subcomponents (13):

  quic: provide common utilities and data structures
  quic: provide family ops for address and protocol
  quic: provide quic.h header files for kernel and userspace
  quic: add stream management
  quic: add connection id management
  quic: add path management
  quic: add congestion control
  quic: add packet number space
  quic: add crypto key derivation and installation
  quic: add crypto packet encryption and decryption
  quic: add timer management
  quic: add frame encoder and decoder base
  quic: add packet builder and parser base

3. Data Processing (7):

  quic: implement outqueue transmission and flow control
  quic: implement outqueue sack and retransmission
  quic: implement inqueue receiving and flow control
  quic: implement frame creation functions
  quic: implement frame processing functions
  quic: implement packet creation functions
  quic: implement packet processing functions

4. Socket APIs (6):

  quic: support bind/listen/connect/accept/close()
  quic: support sendmsg() and recvmsg()
  quic: support socket options related to interaction after handshake
  quic: support socket options related to settings prior to handshake
  quic: support socket options related to setup during handshake
  quic: support socket ioctls and socket dump via procfs

5. Example and Documentation (2):

  quic: create sample test using handshake APIs for kernel consumers
  Documentation: describe QUIC protocol interface in quic.rst

Notice: The QUIC module is currently labeled as "EXPERIMENTAL".

All contributors are recognized in the respective patches with the tag of
'Signed-off-by:'. Special thanks to Moritz Buhl and Stefan Metzmacher whose
practical use cases and insightful feedback, which have been instrumental
in shaping the design and advancing the development.

References
==========

[1] https://datatracker.ietf.org/doc/html/draft-lxin-quic-socket-apis
[2] https://github.com/oracle/ktls-utils
[3] https://github.com/lxin/quic
[4] https://gitlab.com/samba-team/samba/-/merge_requests/4019
[5] https://github.com/moritzbuhl/curl/tree/linux_curl
[6] https://github.com/moritzbuhl/httpd-portable
[7] https://github.com/quic-interop/quic-interop-runner
[8] https://github.com/lxin/iperf
[9] https://github.com/lxin/net-next/commits/quic/

v2:
- Fix a kernel API description warning found by Jakub in patch 5/15.
- Replace uintN_t with __uN, capitalize _UAPI_LINUX_QUIC_H, and
  assign explicit values for QUIC_TRANSPORT_ERROR_ enum in UAPI
  quic.h suggested by David Howells in in patch 5/15.
- Add more checks for addrs in .get_user_addr() and .get_pref_addr()
  in patch 4/15.
- Consider sk_bound_dev_if in .udp_conf_init() and .flow_route() to
  support vrf in patch 4/15.
- Clarify the use of offset field with a union type in struct frame
  in patch 14/15.

Xin Long (15):
  net: define IPPROTO_QUIC and SOL_QUIC constants
  net: build socket infrastructure for QUIC protocol
  quic: provide common utilities and data structures
  quic: provide family ops for address and protocol
  quic: provide quic.h header files for kernel and userspace
  quic: add stream management
  quic: add connection id management
  quic: add path management
  quic: add congestion control
  quic: add packet number space
  quic: add crypto key derivation and installation
  quic: add crypto packet encryption and decryption
  quic: add timer management
  quic: add frame encoder and decoder base
  quic: add packet builder and parser base

 include/linux/quic.h      |   19 +
 include/linux/socket.h    |    1 +
 include/uapi/linux/in.h   |    2 +
 include/uapi/linux/quic.h |  236 ++++++++
 net/Kconfig               |    1 +
 net/Makefile              |    1 +
 net/quic/Kconfig          |   35 ++
 net/quic/Makefile         |    9 +
 net/quic/common.c         |  482 +++++++++++++++
 net/quic/common.h         |  219 +++++++
 net/quic/cong.c           |  700 ++++++++++++++++++++++
 net/quic/cong.h           |  120 ++++
 net/quic/connid.c         |  222 +++++++
 net/quic/connid.h         |  162 +++++
 net/quic/crypto.c         | 1200 +++++++++++++++++++++++++++++++++++++
 net/quic/crypto.h         |   83 +++
 net/quic/family.c         |  686 +++++++++++++++++++++
 net/quic/family.h         |   41 ++
 net/quic/frame.c          |  558 +++++++++++++++++
 net/quic/frame.h          |  195 ++++++
 net/quic/packet.c         |  892 +++++++++++++++++++++++++++
 net/quic/packet.h         |  129 ++++
 net/quic/path.c           |  512 ++++++++++++++++
 net/quic/path.h           |  168 ++++++
 net/quic/pnspace.c        |  224 +++++++
 net/quic/pnspace.h        |  150 +++++
 net/quic/protocol.c       |  404 +++++++++++++
 net/quic/protocol.h       |   58 ++
 net/quic/socket.c         |  431 +++++++++++++
 net/quic/socket.h         |  214 +++++++
 net/quic/stream.c         |  549 +++++++++++++++++
 net/quic/stream.h         |  135 +++++
 net/quic/timer.c          |  196 ++++++
 net/quic/timer.h          |   47 ++
 34 files changed, 9081 insertions(+)
 create mode 100644 include/linux/quic.h
 create mode 100644 include/uapi/linux/quic.h
 create mode 100644 net/quic/Kconfig
 create mode 100644 net/quic/Makefile
 create mode 100644 net/quic/common.c
 create mode 100644 net/quic/common.h
 create mode 100644 net/quic/cong.c
 create mode 100644 net/quic/cong.h
 create mode 100644 net/quic/connid.c
 create mode 100644 net/quic/connid.h
 create mode 100644 net/quic/crypto.c
 create mode 100644 net/quic/crypto.h
 create mode 100644 net/quic/family.c
 create mode 100644 net/quic/family.h
 create mode 100644 net/quic/frame.c
 create mode 100644 net/quic/frame.h
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
 create mode 100644 net/quic/timer.c
 create mode 100644 net/quic/timer.h

-- 
2.47.1

