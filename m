Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 769B220D4F8;
	Sat,  5 Jul 2025 19:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751744329; cv=none; b=MJsmT0mObkVSPN0KqydTwDzRLN28f+2N3rAQmcFy2asmmEfxMecpxjIANitkLo2q/sDmAYR6Pb6PEMYTQm4SmPkTojPsjkZGYP3X0gLJSZs7anDHKz6TnrqM3SxpAM9jux1XR6M+yUSTolB1Kv1RWRhOcUyAlBMryZy0jh0vqOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751744329; c=relaxed/simple;
	bh=36sm89o+0VpGkTlPq0AP8Xv0v15yeMvxWbGJZow6bPE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=KQnjOv7xQOdxmcdwo/BnfvRprX+SM1ByncgoK1Da7TAILMBGe4/8dFsrHTRZL/LROPyx1OMJo6K74Qw/Zd7DGDmTUnSW76IZddAAh2qB9EmW/ECaBnak8GozLx32Z1zNZPIqXm89ei2BAwKkbfciNht008ctbsPMxqCYNzDvqcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OLGb04nT; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OLGb04nT"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7d38b84984dso398230785a.0;
        Sat, 05 Jul 2025 12:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751744326; x=1752349126; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FW+TfYRnZOAormj2kW4oFaSY0R0lZLB2fsJJy86p+l0=;
        b=OLGb04nTD1+7sD0Wk97KiPB27t6bBYb1LRAakh24QqaOOYVCytB2zVo4ayhBmJCAkm
         Tt+fgwsn8KPM/MjKG2AC52jaO5d03so4ptNlZ8Eu7jgu8WJ0FWajF4VupoBNpcNn7j4L
         qLY7FjtZz+cYPDpLVNY5dYpK7pcafcI1mjrdhLzr8bhGCMVmzrGY+TSd/PvNvgMcrTKv
         jdpFgbVC+ws4EjsBNd9aKF+ZimwuJ28RuVnD7BMf/1zz+GtjoYnMsNJc5AegpCTc0NM8
         JEA1IPaARgQMMNHKe9s5kvmhirfbKZpgVaWwCzR31qO3lDAwfTgZIvH1mElSRHHW0Xfm
         3PKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751744326; x=1752349126;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FW+TfYRnZOAormj2kW4oFaSY0R0lZLB2fsJJy86p+l0=;
        b=RMEaoSglaLOKZldTzC1iO3fkRZR/G8aOsXnbVc3UHzj/gK4bJgUsC0XdEQNh0f7EyH
         rx0bEQO6WjJMOQWL/Zsy9T37MnD4AgYUbTJ8fvvW9xpb9kWJ32W9PQAUGvAeiI34Yr2l
         tFD6tADNK8ioHaY0C80RS3hIqc6CEp3jdKLnuUYVBZo5vHnTpf4u34Eomdyg193xb9P4
         AKEaeLy68U8XHZNPa2ImxBvJII/u/xSViRSxR5NrL254m1AMX6iCuIBnIusu6vqAJTXi
         B3FAq/1BprP9q+Xp1wUWyhnZhqym7AwWm5x8qB+0UOPQU2Cha5+LgBmneLOZLw8RZPVp
         tGXg==
X-Forwarded-Encrypted: i=1; AJvYcCUVZgiHzkgS14vBXJd0qR1ipeNHlaOdg1opLM3ovO70adTNS9+ZICAd2fkdXrkzX8ry5xMRMurDgnxW@vger.kernel.org
X-Gm-Message-State: AOJu0YwmLpefp9uxRxZ0igt01RW4zsrS/25clfGvAeGpSQqbYx2Z7cY8
	U/g9DEZzcqhCopew0YD6Rah3yGGosxkR4mtdtbR9Oh+wvN2LJjHb39S9ZNmOyzCm8fE=
X-Gm-Gg: ASbGncvexTfo2umZ4NuQZNETE2s1+QM6yjqmjkN39R7mb533MGk9UtIVP8F/x/u4MJJ
	xFs3aI6KPPgKx2Xz660VmRBnFDmLw6gxmDstBiKY7Axlv3BL5Efs1LfzEbJOI9JK/Ao2nBUqV5D
	q34tp6UDlurQPLkCyTFD6Br7xXLMtf86/CHawxyLFKxVD7Sx9HHE8yzqFv5PFahTDcKY2xIjkat
	uie40EuhO4JDujmXILvj62/PqqhAZKkC38R9JJqNTl6ohpylSMiRkhbwrhNzTec3U5DFWVV8MCA
	g8Fy+HUyF3g8Eg3slnGJPmlfwVv2bDm0vsXGlrRhYjgxVAOsfn3UNXJEFni5rFpxA7kCGdvnlCj
	OixiOTo4Ci8G3sZ3Sm1EQZlgZW8t79BELyNzsjA==
X-Google-Smtp-Source: AGHT+IHgoW8PPd3g4MokcVGHwypEUMNXEus29rsnLY7pXmAoDcwKJaN6U7RAa70caicbLSachIdyBA==
X-Received: by 2002:a05:620a:28ca:b0:7ca:cd16:b433 with SMTP id af79cd13be357-7d5f11f2dbbmr384910385a.31.1751744325888;
        Sat, 05 Jul 2025 12:38:45 -0700 (PDT)
Received: from wsfd-netdev58.anl.eng.rdu2.dc.redhat.com ([66.187.232.140])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-702c4d6019csm32999146d6.106.2025.07.05.12.38.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Jul 2025 12:38:45 -0700 (PDT)
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
	Cong Wang <xiyou.wangcong@gmail.com>,
	"D . Wythe" <alibuda@linux.alibaba.com>,
	Jason Baron <jbaron@akamai.com>,
	illiliti <illiliti@protonmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Daniel Stenberg <daniel@haxx.se>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Subject: [PATCH net-next 00/15] net: introduce QUIC infrastructure and core subcomponents
Date: Sat,  5 Jul 2025 15:31:39 -0400
Message-ID: <cover.1751743914.git.lucien.xin@gmail.com>
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

Use Cases
=========

- Samba

  Stefan Metzmacher has submitted a merge request to integrate Linux QUIC
  into Samba for both client and server roles [4].

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

  The libquic self-tests (make check) ran on all major architectures:
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
    --------------------------------------------------------------------
    mtu:1500    2.27 | 3.26    3.02 | 6.97    3.36 | 9.74    3.48 | 10.8
    --------------------------------------------------------------------
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

Notice:: The QUIC module is currently labeled as "EXPERIMENTAL".

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

 include/linux/quic.h      |   19 +
 include/linux/socket.h    |    1 +
 include/uapi/linux/in.h   |    2 +
 include/uapi/linux/quic.h |  238 ++++++++
 net/Kconfig               |    1 +
 net/Makefile              |    1 +
 net/quic/Kconfig          |   35 ++
 net/quic/Makefile         |    9 +
 net/quic/common.c         |  482 +++++++++++++++
 net/quic/common.h         |  219 +++++++
 net/quic/cong.c           |  700 +++++++++++++++++++++
 net/quic/cong.h           |  120 ++++
 net/quic/connid.c         |  218 +++++++
 net/quic/connid.h         |  162 +++++
 net/quic/crypto.c         | 1201 +++++++++++++++++++++++++++++++++++++
 net/quic/crypto.h         |   83 +++
 net/quic/family.c         |  666 ++++++++++++++++++++
 net/quic/family.h         |   40 ++
 net/quic/frame.c          |  558 +++++++++++++++++
 net/quic/frame.h          |  192 ++++++
 net/quic/packet.c         |  889 +++++++++++++++++++++++++++
 net/quic/packet.h         |  129 ++++
 net/quic/path.c           |  507 ++++++++++++++++
 net/quic/path.h           |  162 +++++
 net/quic/pnspace.c        |  224 +++++++
 net/quic/pnspace.h        |  150 +++++
 net/quic/protocol.c       |  404 +++++++++++++
 net/quic/protocol.h       |   58 ++
 net/quic/socket.c         |  424 +++++++++++++
 net/quic/socket.h         |  221 +++++++
 net/quic/stream.c         |  549 +++++++++++++++++
 net/quic/stream.h         |  135 +++++
 net/quic/timer.c          |  196 ++++++
 net/quic/timer.h          |   47 ++
 34 files changed, 9042 insertions(+)
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

