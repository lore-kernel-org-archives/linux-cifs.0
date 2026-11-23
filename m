Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795393801;
	b=0QJv64E6MmmizfRA0kLU4wqj6V63yAhvYSNj3Wzq0QP5DTrFGO0F4tKYFzIc6Wm5nKws
	 04YePrKxViHFeYOoYhst8b/LYPyBUvp/g2ShHJYptexUJ6P2s+pwCsK9j9Fo6gfWynnbf
	 5cTDsDgsH2IBGK+fOcx1ebqwZ1F7Cqq5bYNiVuyWLY2cRWgjsMYWSkT+mNYuYVEipwM/t
	 61gvKO/6Q2uyb+sBTAQrZjFzAxVmw2z/E95SxXy/wrmU5ef4DHHsGEEojga23G+kN1COY
	 /LWT5sQXIChmlvRRMEfq0QDmX/pk7h1GI8+WiigMJlAOxCUTfFAEEenDdxsApXWulVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795393801;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=gqq5Q3pHbdTkh0uMHkBDt+w3HMjR+Ba/8LkxQasZsOA=;
	b=JLyRo5hY1NU/Hs+JrzFMllSWrghkUqrVukDTG/GcR8GaSjXWfCMru4GpzjcD2GynB0av
	 eeHrcJNCN1pwwK/cKz2l09sZH12FcLmAj8rAk9ttFj/RaSgfbbrKcGO7OP/A4iQvwOsK3
	 dYdk4sniiNQ8yFt9OAlZHhgpPQrERQstXCyjCq5+nbND9LRrO2pk5RAuNGEtCbGpdIwuZ
	 p/tqEjnNOySfIHVjkEPHPUnguGvpZ57uG0s2YlrLKyUhNuCZNIJJr0LKAtF+I9XtH3jKn
	 dOwBbqBXZAB4p+rOg35sBki39GhYLtufNCRX461AtclUM0Iq8ISXtzu1qO5kUj3IYZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tpYpsT8C;
	arc=none smtp.remote-ip=209.85.219.48
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA75606A31A
	for <linux-cifs@vger.kernel.org>; Mon, 23 Nov 2026 00:30:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AFA75606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tpYpsT8C
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-920fed989b2so28535936d6.2
        for <linux-cifs@vger.kernel.org>; Sun, 22 Nov 2026 16:30:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795393799; x=1795998599; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gqq5Q3pHbdTkh0uMHkBDt+w3HMjR+Ba/8LkxQasZsOA=;
        b=tpYpsT8COAYojgL7u4/yB5JFJEm6eFXUM8RdEK4VBeO3U4dsgpn0DRBH3WWWukZc+I
         eSczNaHJP6ufqUFjqb/8EuafkxhFq6j4CkfEtq0vDMRF1ELw7jH/LBJxdN7LthM7hRzE
         rM8d01BVbgzo57JlguUsp93xrGXhHKrpFSp9RIXJmZGP5rOE9j75VREHGriyqVv2qPB/
         VJ97+VjYjBz3BVmmgDpSJdCoYhgGwNsDt8I4ev7fODc5j7C9bF2LEBeH7CoTALJVWF4O
         7tARRARGZBoigW4rVRQGh3heBPzvkLnElikIS5mp76fkYRU5/+zHqjoAY5XeF3XDb6Kt
         u6Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795393799; x=1795998599;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gqq5Q3pHbdTkh0uMHkBDt+w3HMjR+Ba/8LkxQasZsOA=;
        b=TX3CF9y2ZCtntYpw7j+PdHSwuFYbPLCsuURv4dmVNYVshMxPmUdZCLcMbzX0jCFRGA
         QZSvBaTnZNZwRvBnUPZiwDefIJ62UBubNhn7xYXDG7T/MQbHD52wqqO9Sdrqhd4ZTsAI
         Q6/BzZoEqoiPT2hy35k4daKCzsUbQjU5bG0ST39Mxn+GOji9/czJ8YqlPQKEa7eBc+1x
         EJ5eQjPdpnAHqFezvq5OrSt5o7gMXe6LqPz2CUCI9ACcgFHHQyxahdklRa9CKtszsdJR
         JhRVYbcI2mjPMt6lEC6sg3QMDjpUZKUavy0yIP5jax19q88rpZ5njn60nrB/D3mCTxgB
         787A==
X-Forwarded-Encrypted: i=1; AL+hErGiet/l1GhdSpbkpGc4nXXwzgoKkdxYPUx11EL1Mwm+g1WUsyzq97ALU7LsCl1KCqYeWwG3Ox03WC0T@vger.kernel.org
X-Gm-Message-State: APuU4Z+O1wWKDFB4TBLmsNOwF06RhYv9zXOAjDPbmq+4djElPFcBCn7O
	3UpZ3PPZSEieemtGuT3ynslU2hLkTv3TAma6Z+bgT/+k75o1o6vXDL75
X-Gm-Gg: AZFdTZd1i2nUhopVh3+UY/NnNqPLOJDbKaRiBOSCcjgSO/0oSHEgAc+wlQJHwNv8Uyd
	0EDZT2blzIhSrrJh/wxtLZPZB9SOQa7Je7CNQHXvCb/zO6HpZ3YiZYyquCZAtAOiCN2czRPA9Ac
	dpyM8ptrXl1Ee41WgBRB8MXbfENNiZN/LvxMAkCQx6+cLbGNuzH5JhuHkkrvlNArKyRkuS7OZnp
	yMybY5kC4p3XpcqrG+soL2vSgP2R/h7p5/FLwkYFvTSr+uKDrC6L0dfB6iYMbxAWZncZOV8NoCZ
	TZzeSlTZ23C1rXt4pVxfvU8/Zc/jD42mmY+zFBkpo0XFMsm0FikgSUSeufjdCDxGT0JbUhsbCCG
	UWC8UHh/1jeYeo4C/YvMlxPpzl/CW9+8fTHZyna7iVFHJy9iN/0LAYxul9CO+hPmwsuPGraaS3g
	n1zdV0jienkedp92pQsbyGpHtSrZczEaQGljX+tqixdrZsQYVeASskUA2H0GxBZAk2ZCbI8d3+u
	SL54H6U7Ha+3R9b7kikcYB2k4AYV0w2OdSdFeCCftRTGtMFzibr0EwFa0LhG7TkFVBxvlYZ0vBZ
	wfhyho+G+cw4rUOpmdPKMShYix0FRWrQllQpHuhwQ/8SCb9VGl8Z2gkO/8S20vOnU9ZwgXQHaXo
	Uvo9XSHVacrwYT3+tCGMRUVYMiR5dnoXGaDVA1HLqrkXc+HcNxK80scTYL7MD7vlhQeIA6aQ=
X-Received: by 2002:a05:6214:21ec:b0:91b:a0ab:824 with SMTP id 6a1803df08f44-92134bb7d97mr184599036d6.56.1795393799412;
        Sun, 22 Nov 2026 16:29:59 -0800 (PST)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921349d0f6bsm91433716d6.21.2026.11.22.16.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 16:29:58 -0800 (PST)
From: Xin Long <lucien.xin@gmail.com>
To: network dev <netdev@vger.kernel.org>,
	quic@lists.linux.dev
Cc: davem@davemloft.net,
	kuba@kernel.org,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Metzmacher <metze@samba.org>,
	Moritz Buhl <mbuhl@openbsd.org>,
	Tyler Fanelli <tfanelli@redhat.com>,
	Pengtao He <hepengtao@xiaomi.com>,
	Thomas Dreibholz <dreibh@simula.no>,
	Jamie Bainbridge <jamie.bainbridge@gmail.com>,
	linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Tom Talpey <tom@talpey.com>,
	kernel-tls-handshake@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Steve Dickson <steved@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Alexander Aring <aahringo@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Matthieu Baerts <matttbe@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	"D . Wythe" <alibuda@linux.alibaba.com>,
	Jason Baron <jbaron@akamai.com>,
	illiliti <illiliti@protonmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Daniel Stenberg <daniel@haxx.se>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	mef@scarletmail.rutgers.edu,
	paul@jakma.org,
	Kuniyuki Iwashima <kuniyu@google.com>
Subject: [PATCH net-next v19 00/15] net: introduce QUIC infrastructure and core subcomponents
Date: Sun, 22 Nov 2026 19:27:56 -0500
Message-ID: <cover.1795393690.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.47.1
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
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
  sendfile() to minimize data movement, and is also structured to support
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
and creation, is managed in the kernel. Rather than using an Upper Layer
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

- NetPerfMeter

  The latest NetPerfMeter release supports Linux QUIC and can be used to
  run performance evaluations [10].

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
  tests/syzkaller/ in libquic [3].

- Performance Testing

  Performance was benchmarked using iperf [8] over a 100G NIC using
  various MTUs and packet sizes:

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
  quic: add packet builder base
  quic: add packet parser base

3. Data Processing (8):

  quic: add frame encoder and decoder base
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

5. Documentation and Selftests (3):

  Documentation: describe QUIC protocol interface in quic.rst
  quic: create sample test using handshake APIs for kernel consumers
  selftests: net: add tests for QUIC protocol

Notice: The QUIC module is currently labeled as "EXPERIMENTAL".

All contributors are recognized in the respective patches with the tag of
'Signed-off-by:'. Special thanks to Moritz Buhl and Stefan Metzmacher whose
practical use cases and insightful feedback have been instrumental in
shaping the design and advancing the development.

References
==========

[1]  https://datatracker.ietf.org/doc/html/draft-lxin-quic-socket-apis
[2]  https://github.com/oracle/ktls-utils
[3]  https://github.com/lxin/quic
[4]  https://gitlab.com/samba-team/samba/-/merge_requests/4019
[5]  https://github.com/moritzbuhl/curl/tree/linux_curl
[6]  https://github.com/moritzbuhl/httpd-portable
[7]  https://github.com/quic-interop/quic-interop-runner
[8]  https://github.com/lxin/iperf
[9]  https://github.com/lxin/net-next/commits/quic/
[10] https://www.nntb.no/~dreibh/netperfmeter/

Changes in v2-v19: See individual patch changelogs for details.

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
  quic: add packet builder base
  quic: add packet parser base

 Documentation/networking/ip-sysctl.rst        |   39 +
 MAINTAINERS                                   |    9 +
 include/linux/quic.h                          |   38 +
 include/linux/socket.h                        |    1 +
 include/trace/events/sock.h                   |    3 +-
 include/uapi/linux/in.h                       |    2 +
 include/uapi/linux/quic.h                     |  242 +++
 net/Kconfig                                   |    1 +
 net/Makefile                                  |    1 +
 net/quic/Kconfig                              |   37 +
 net/quic/Makefile                             |    9 +
 net/quic/common.c                             |  567 +++++++
 net/quic/common.h                             |  220 +++
 net/quic/cong.c                               |  292 ++++
 net/quic/cong.h                               |  144 ++
 net/quic/connid.c                             |  313 ++++
 net/quic/connid.h                             |  191 +++
 net/quic/crypto.c                             | 1324 +++++++++++++++++
 net/quic/crypto.h                             |  104 ++
 net/quic/family.c                             |  441 ++++++
 net/quic/family.h                             |   48 +
 net/quic/packet.c                             | 1093 ++++++++++++++
 net/quic/packet.h                             |  109 ++
 net/quic/path.c                               |  608 ++++++++
 net/quic/path.h                               |  192 +++
 net/quic/pnspace.c                            |  273 ++++
 net/quic/pnspace.h                            |  201 +++
 net/quic/protocol.c                           |  405 +++++
 net/quic/protocol.h                           |   57 +
 net/quic/socket.c                             |  693 +++++++++
 net/quic/socket.h                             |  243 +++
 net/quic/stream.c                             |  426 ++++++
 net/quic/stream.h                             |  133 ++
 net/quic/timer.c                              |  154 ++
 net/quic/timer.h                              |   45 +
 tools/include/uapi/linux/in.h                 |    2 +
 .../perf/trace/beauty/include/linux/socket.h  |    1 +
 usr/include/Makefile                          |    1 +
 38 files changed, 8661 insertions(+), 1 deletion(-)
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

