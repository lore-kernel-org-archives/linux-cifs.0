Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6A8055E6E
	for <linux-cifs@vger.kernel.org>; Mon, 11 Mar 2024 19:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710186853; cv=none; b=s3hmNqQqdzVdK6qAGh/LXlqVbp61u/bWcOBIvyy1OFmzxDByHtZqhEvrxCh4gLuH/bdqTE/C18CCZyqZKUz0jE5m/4ZPNwSNotiWJ9m8rFHRjQA/nNIJZ2w2SQ8M4jzlQmXcxy9c5Y+/xZwjJvmAYJOmZfE4kDAdOOfQGhbBT0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710186853; c=relaxed/simple;
	bh=nijW3vGeA9AMInGZZxdEK9HlxNjoqIbsCSzTOvXlUao=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=dC0FSRiyd7LOaFoMPJ1o07Iiea6wQSxHhwpqPEzE3tC7Q7FSPTihu0aD+BNn6Gx2HlYQS5kuxoSHfALVX1AKIw6cQP8NiiTkb4xPYXFBrmcArDtWWsACnK5xpAx0rsgSOfl0TMQoRrm6L7TcfOAMFGu0OSONGOmx6Ud6cZfW2dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qv/JxY+G; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qv/JxY+G"
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3666307a2f7so1765755ab.2
        for <linux-cifs@vger.kernel.org>; Mon, 11 Mar 2024 12:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710186851; x=1710791651; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N68M4oaI4lhGtHnDFJxrFIYfUle7pEKAqJzAoIVmIRM=;
        b=Qv/JxY+GBq18mMH/1q5dn++V+FbpTBze3pFqGQF0bocMfiiyiSPgTOYOqWenikAvFE
         3HqhUlkuP7BVwewOOrIdgE8d4jWm/4wcBF5/zB1MBFmDe57NLcH3ve4CXacs7I/iT1hz
         bNDuhxiCVwbqN4DXrZuHStuVrWqUlS0HMHEKPTKQ8Pf+T5TkOHZ9zDD/g95ADBcHxpAs
         spod3yuZ9EqtN3GjVx724ivjMoXsU9vIF/zmLDCZ3pCLqeTCcku/jYz1hS2jT0K0RFiE
         5GMFU4eoKwoEJmyZBKegWCD7maMjwfyHC4xDUVWj/5bePOxW2NrG9itwasqzOtcBqhAi
         uriQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710186851; x=1710791651;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N68M4oaI4lhGtHnDFJxrFIYfUle7pEKAqJzAoIVmIRM=;
        b=hhVZbu49vibrq3inVvXxIRWbjzKnnp1fJG2cZBSWljnoZY9R6ZT3cFzFxYDIzTPsCb
         54N79lRcKn4hZsRW7DU3tllQNjR+sy5zJdfx1LKhA0koZ0OHZgUsWbmJioXtbDCbA991
         pXKLaVTmKXn6+3kCIMTRuUrHF5MqmmuZuydYkQKa8D0nyL2gFVS12aYwMS5fUfvJfGgm
         kWtYxMuCtewYoZdNqk0xGsarZE/kBgAae2xSJf8nykwp1nG5ju3ldpR/M0AATZ9PWRol
         AmFPvxJtFmU6ppUg41F6+EQKwTR7FGPcb087wRap28zhqRbqZv5swtw5LciPkUNhwJsR
         DetQ==
X-Forwarded-Encrypted: i=1; AJvYcCUWOyMkjPffHhv003RVLG5y6PoTQcDgiwxWoFkcl2YvpQ4hbQBi7DZJgPri48q/3OvLcw1Jw0KKtNGQWw4e1bZhnUEs0vdf3tDB2g==
X-Gm-Message-State: AOJu0YwpG8xlb9KjBAZ8cucP7sFu58llreEYMQD4HGnyjodHS7oM8CIt
	Yxcabe2qrg9mMhlPSZYnZUYUNMm2c/33Rsj9T7x8sUDhw8n06F0lPdpY97ne/ypUszLd0V5vhJD
	Lvf3kM8chVg07z6XYmZMoNpvvDyM=
X-Google-Smtp-Source: AGHT+IHQyUUDFAXZ6EdAJETH1qFYR5utca7KcXLtaeEk80Qgh5G+JOvSdhojWEalrOkj1HRHqg0nYSL55qXGrZmUOlY=
X-Received: by 2002:a92:c56e:0:b0:365:170a:b288 with SMTP id
 b14-20020a92c56e000000b00365170ab288mr8230253ilj.16.1710186850852; Mon, 11
 Mar 2024 12:54:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1710173427.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1710173427.git.lucien.xin@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 11 Mar 2024 15:53:59 -0400
Message-ID: <CADvbK_d1yEDebPFM-fSeu2i30upruA+fPMN0sZ6Ngg7EGNd1BQ@mail.gmail.com>
Subject: Fwd: [RFC PATCH net-next 0/5] net: In-kernel QUIC implementation with
 Userspace handshake
To: samba-technical@lists.samba.org, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

FYI.

Patchset Link:
https://lore.kernel.org/netdev/cover.1710173427.git.lucien.xin@gmail.com/

Thanks.
---------- Forwarded message ---------
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, Mar 11, 2024 at 12:19=E2=80=AFPM
Subject: [RFC PATCH net-next 0/5] net: In-kernel QUIC implementation
with Userspace handshake
To: network dev <netdev@vger.kernel.org>
Cc: <davem@davemloft.net>, <kuba@kernel.org>, Eric Dumazet
<edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Steve French
<smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, Chuck Lever
III <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>,
Sabrina Dubroca <sd@queasysnail.net>, Tyler Fanelli
<tfanelli@redhat.com>, Pengtao He <hepengtao@xiaomi.com>


Introduction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

This is an implementation of the QUIC protocol as defined in RFC9000. QUIC
is an UDP-Based Multiplexed and Secure Transport protocol, and it provides
applications with flow-controlled streams for structured communication,
low-latency connection establishment, and network path migration. QUIC
includes security measures that ensure confidentiality, integrity, and
availability in a range of deployment circumstances.

This implementation of QUIC in the kernel space enables users to utilize
the QUIC protocol through common socket APIs in user space. Additionally,
kernel subsystems like SMB and NFS can seamlessly operate over the QUIC
protocol after handshake using net/handshake APIs.

Note that In-Kernel QUIC implementation does NOT target Crypto Offload
support for existing Userland QUICs, and Crypto Offload intended for
Userland QUICs can NOT be utilized for Kernel consumers, such as SMB.
Therefore, there is no conflict between In-Kernel QUIC and Crypto
Offload for Userland QUICs.

This implementation offers fundamental support for the following RFCs:

- RFC9000 - QUIC: A UDP-Based Multiplexed and Secure Transport
- RFC9001 - Using TLS to Secure QUIC
- RFC9002 - QUIC Loss Detection and Congestion Control
- RFC9221 - An Unreliable Datagram Extension to QUIC
- RFC9287 - Greasing the QUIC Bit
- RFC9368 - Compatible Version Negotiation for QUIC
- RFC9369 - QUIC Version 2
- Handshake APIs for tlshd Use - SMB/NFS over QUIC

Implementation
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

The central idea is to implement QUIC within the kernel, incorporating an
userspace handshake approach.

Only the processing and creation of raw TLS Handshake Messages, facilitated
by a tls library like gnutls, take place in userspace. These messages are
exchanged through sendmsg/recvmsg() mechanisms, with cryptographic details
carried in the control message (cmsg).

The entirety of QUIC protocol, excluding TLS Handshake Messages processing
and creation, resides in the kernel. Instead of utilizing a User Level
Protocol (ULP) layer, it establishes a socket of IPPROTO_QUIC type (similar
to IPPROTO_MPTCP) operating over UDP tunnels.

Kernel consumers can initiate a handshake request from kernel to userspace
via the existing net/handshake netlink. The userspace component, tlshd from
ktls-utils, manages the QUIC handshake request processing.

- Handshake Architecture:

      +------+  +------+
      | APP1 |  | APP2 | ...
      +------+  +------+
      +-------------------------------------------------+
      |                libquic (ktls-utils)             |<--------------+
      |      {quic_handshake_server/client/param()}     |               |
      +-------------------------------------------------+
+---------------------+
        {send/recvmsg()}         {set/getsockopt()}            | tlshd
(ktls-utils)  |
        [CMSG handshake_info]    [SOCKOPT_CRYPTO_SECRET]
+---------------------+
                                 [SOCKOPT_TRANSPORT_PARAM_EXT]
              | ^                            | ^                        | ^
  Userspace   | |                            | |                        | |
  ------------|-|----------------------------|-|------------------------|-|=
--------------
  Kernel      | |                            | |                        | |
              v |                            v |                        v |
      +--------------------------------------------------+
+-------------+
      |  socket (IPPRTOTO_QUIC)  |       protocol        |<----+   |
handshake   |
      +--------------------------------------------------+     |   |
netlink APIs|
      | inqueue | outqueue | cong | path | connection_id |     |
+-------------+
      +--------------------------------------------------+     |      |    =
  |
      |   packet   |   frame   |   crypto   |   pnmap    |     |
+-----+ +-----+
      +--------------------------------------------------+     |   |
  | |     |
      |         input           |       output           |     |---|
SMB | | NFS | ...
      +--------------------------------------------------+     |   |
  | |     |
      |                   UDP tunnels                    |     |
+-----+ +--+--+
      +--------------------------------------------------+     +-----------=
---|

- Post Handshake Architecture:

      +------+  +------+
      | APP1 |  | APP2 | ...
      +------+  +------+
        {send/recvmsg()}         {set/getsockopt()}
        [CMSG stream_info]       [SOCKOPT_KEY_UPDATE]
                                 [SOCKOPT_CONNECTION_MIGRATION]
                                 [SOCKOPT_STREAM_OPEN/RESET/STOP_SENDING]
                                 [...]
              | ^                            | ^
  Userspace   | |                            | |
  ------------|-|----------------------------|-|----------------
  Kernel      | |                            | |
              v |                            v |
      +--------------------------------------------------+
      |  socket (IPPRTOTO_QUIC)  |       protocol        |<----+
{kernel_send/recvmsg()}
      +--------------------------------------------------+     |
{kernel_set/getsockopt()}
      | inqueue | outqueue | cong | path | connection_id |     |
      +--------------------------------------------------+     |
      |   packet   |   frame   |   crypto   |   pnmap    |     |
+-----+ +-----+
      +--------------------------------------------------+     |   |
  | |     |
      |         input           |       output           |     |---|
SMB | | NFS | ...
      +--------------------------------------------------+     |   |
  | |     |
      |                   UDP tunnels                    |     |
+-----+ +--+--+
      +--------------------------------------------------+     +-----------=
---|

Usage
=3D=3D=3D=3D=3D

This implementation supports a mapping of QUIC into sockets APIs. Similar
to TCP and SCTP, a typical Server and Client use the following system call
sequence to communicate:

       Client                    Server
    ------------------------------------------------------------------
    sockfd =3D socket(IPPROTO_QUIC)      listenfd =3D socket(IPPROTO_QUIC)
    bind(sockfd)                       bind(listenfd)
                                       listen(listenfd)
    connect(sockfd)
    quic_client_handshake(sockfd)
                                       sockfd =3D accecpt(listenfd)
                                       quic_server_handshake(sockfd, cert)

    sendmsg(sockfd)                    recvmsg(sockfd)
    close(sockfd)                      close(sockfd)
                                       close(listenfd)

Please note that quic_client_handshake() and quic_server_handshake() functi=
ons
are currently sourced from libquic in the github lxin/quic repository, and =
might
be integrated into ktls-utils in the future. These functions are responsibl=
e for
receiving and processing the raw TLS handshake messages until the completio=
n of
the handshake process.

For utilization by kernel consumers, it is essential to have the tlshd serv=
ice
(from ktls-utils) installed and running in userspace. This service receives
and manages kernel handshake requests for kernel sockets. In kernel, the AP=
Is
closely resemble those used in userspace:

       Client                    Server
    -----------------------------------------------------------------------=
-
    __sock_create(IPPROTO_QUIC, &sock)  __sock_create(IPPROTO_QUIC, &sock)
    kernel_bind(sock)                   kernel_bind(sock)
                                        kernel_listen(sock)
    kernel_connect(sock)
    tls_client_hello_x509(args:{sock})
                                        kernel_accept(sock, &newsock)
                                        tls_server_hello_x509(args:{newsock=
})

    kernel_sendmsg(sock)                kernel_recvmsg(newsock)
    sock_release(sock)                  sock_release(newsock)
                                        sock_release(sock)

Please be aware that tls_client_hello_x509() and tls_server_hello_x509() ar=
e
APIs from net/handshake/. They are employed to dispatch the handshake reque=
st
to the userspace tlshd service and subsequently block until the handshake
process is completed.

For advanced usage,
see man doc: https://github.com/lxin/quic/wiki/man
and examples: https://github.com/lxin/quic/tree/main/tests

The QUIC module is currently labeled as "EXPERIMENTAL".

Xin Long (5):
  net: define IPPROTO_QUIC and SOL_QUIC constants for QUIC protocol
  net: include quic.h in include/uapi/linux for QUIC protocol
  net: implement QUIC protocol code in net/quic directory
  net: integrate QUIC build configuration into Kconfig and Makefile
  Documentation: introduce quic.rst to provide description of QUIC
    protocol

 Documentation/networking/quic.rst |  160 +++
 include/linux/socket.h            |    1 +
 include/uapi/linux/in.h           |    2 +
 include/uapi/linux/quic.h         |  189 +++
 net/Kconfig                       |    1 +
 net/Makefile                      |    1 +
 net/quic/Kconfig                  |   34 +
 net/quic/Makefile                 |   20 +
 net/quic/cong.c                   |  229 ++++
 net/quic/cong.h                   |   84 ++
 net/quic/connection.c             |  172 +++
 net/quic/connection.h             |  117 ++
 net/quic/crypto.c                 |  979 ++++++++++++++++
 net/quic/crypto.h                 |  140 +++
 net/quic/frame.c                  | 1803 ++++++++++++++++++++++++++++
 net/quic/frame.h                  |  162 +++
 net/quic/hashtable.h              |  125 ++
 net/quic/input.c                  |  693 +++++++++++
 net/quic/input.h                  |  169 +++
 net/quic/number.h                 |  174 +++
 net/quic/output.c                 |  638 ++++++++++
 net/quic/output.h                 |  194 +++
 net/quic/packet.c                 | 1179 +++++++++++++++++++
 net/quic/packet.h                 |   99 ++
 net/quic/path.c                   |  434 +++++++
 net/quic/path.h                   |  131 +++
 net/quic/pnmap.c                  |  217 ++++
 net/quic/pnmap.h                  |  134 +++
 net/quic/protocol.c               |  711 +++++++++++
 net/quic/protocol.h               |   56 +
 net/quic/sample_test.c            |  339 ++++++
 net/quic/socket.c                 | 1823 +++++++++++++++++++++++++++++
 net/quic/socket.h                 |  293 +++++
 net/quic/stream.c                 |  248 ++++
 net/quic/stream.h                 |  147 +++
 net/quic/timer.c                  |  241 ++++
 net/quic/timer.h                  |   29 +
 net/quic/unit_test.c              | 1024 ++++++++++++++++
 38 files changed, 13192 insertions(+)
 create mode 100644 Documentation/networking/quic.rst
 create mode 100644 include/uapi/linux/quic.h
 create mode 100644 net/quic/Kconfig
 create mode 100644 net/quic/Makefile
 create mode 100644 net/quic/cong.c
 create mode 100644 net/quic/cong.h
 create mode 100644 net/quic/connection.c
 create mode 100644 net/quic/connection.h
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
 create mode 100644 net/quic/pnmap.c
 create mode 100644 net/quic/pnmap.h
 create mode 100644 net/quic/protocol.c
 create mode 100644 net/quic/protocol.h
 create mode 100644 net/quic/sample_test.c
 create mode 100644 net/quic/socket.c
 create mode 100644 net/quic/socket.h
 create mode 100644 net/quic/stream.c
 create mode 100644 net/quic/stream.h
 create mode 100644 net/quic/timer.c
 create mode 100644 net/quic/timer.h
 create mode 100644 net/quic/unit_test.c

--
2.43.0
