Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5833D47D9
	for <linux-cifs@vger.kernel.org>; Tue, 28 Jul 2026 13:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785244681; cv=none; b=lnYXqZSNBFAHZatx3N9bvAhnJhRiGNIujX19VMg3inYzU4RdSW3JOvQYfDv0H/XzpPBeROHK0slc1kvgLG/55XikYsIpkhm9LFpjwL8ESL6qU+hKqZGDwFFmVceJGhq8zJ227pmt6YMrvHihifNlDE8ZwMouf5cisjP2nbPQ44Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785244681; c=relaxed/simple;
	bh=lFn3pGe3gWPn9kOA+U7QnGTvl4jRvD2k7Df9Rn6eeZc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U8AHaWsLdIQGvqX7vCbE1+ER8rICKTbQhENmWsaS2NOznp6ikORooxVxivxJH8YtA4VzXz28swkIHJb8DOOWtSLD5lk+5MxTgetQl5nWKCupnF/omvpVoR4i0TL+8h58kQ2ahBXXGV7qESrvyQlo7PLpJ6fAbRYd3V2NrZscRaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XAznCufX; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cy78Suaq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XAznCufX";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cy78Suaq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785244677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LZXde2S6X4gZRfxeRQHauy+S960gD6Ms5fIejZtqbaI=;
	b=XAznCufXaQ7QspOxcEVe2dZ2qz+A4kI9zixwCCi85mLi3Y2zGLFe5A8wx99qDbIwDEcjtc
	Iw4gOOfzCA6RFMz9yV8PSNNOb4o96XgLeHXrCnUA9JZl9jax8wRM+wRxiq/P1DGRyGqSsR
	ITj9grkDGoegBprfttAVOyEIjLTL4kc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-457-nOSK-EpwNrOBClINBfOYdw-1; Tue, 28 Jul 2026 09:17:55 -0400
X-MC-Unique: nOSK-EpwNrOBClINBfOYdw-1
X-Mimecast-MFC-AGG-ID: nOSK-EpwNrOBClINBfOYdw_1785244674
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4954fe32d6eso19570885e9.1
        for <linux-cifs@vger.kernel.org>; Tue, 28 Jul 2026 06:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1785244674; x=1785849474; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LZXde2S6X4gZRfxeRQHauy+S960gD6Ms5fIejZtqbaI=;
        b=cy78SuaqivirH22jE5E+uAJ1fD+iENqdmPEB5C8XDVySKqatkS0jZaTrlCeSlMccln
         wA6DlsFwQpELR7gSF8BryJ2KscVCMlCUdkpW7npHuaflcSPjfD6XEcmt2JIlE0FG0uSS
         6PtEjig1vUH8nvutdRF8Bj+6JLY7qoei7DKVH1hpg9S3SEVEEYz6DK0ZliEiA+MqsCPH
         Tu++QkeapD/pqkyXuJfLx9V3LjUhwi59PK72yOwVJi2LckIiwxXqADzFob18vHOD7xpr
         alyQw40ugD8cl8V8GioMMpTnic2G+pV/ldzbFM0rou7S/OKTSwa0I0Z04/AMqWPDfILo
         S/cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785244674; x=1785849474;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LZXde2S6X4gZRfxeRQHauy+S960gD6Ms5fIejZtqbaI=;
        b=otYxneTUyOtLu66t+QhnLtxrxJZvCi0TbHZb3RVLMOgJLXJ8btn6w18S+YXlsEfxj1
         0SMRHu0PB5dIuqxecXcwdZDzhKoxA8RJaiO5sBkgnjk+X99dxNr3cKTbb411ZL+Gn6XV
         E0EnaeHmtwgkaqHjM24frbniEp1zGczAYSAnADuRl+LdoAgS/HVdpwNz9HXLHyCiF6wK
         HcLkoHzJ73Cv/lqHHD1Mw4Pv8gjeWuaWbAxJOEH6TUvjjrErsVyRPQLML2tYzF/G6jvD
         H6LJMMQ6kGzcnUB0Na5xncmN7LfryQi17et2glDnBewSx9yN4zbdiu+PkDzTcKmGeWF4
         t1Dg==
X-Forwarded-Encrypted: i=1; AHgh+Rr87udwGsAz5Pyg921lx6qorMXixbHwA8rAfPipZ3rCkhLmRWk3Qc1flCXFG67E96nESVmlCr5CS6Bt@vger.kernel.org
X-Gm-Message-State: AOJu0YwlsPKI7RNo5HLh6670Y1z0UdP/BJSj1yWMhL5Mp9ui7MbPFrTU
	ydWlY+n6PeFhCm1eiMGAsHzGPPe7quxtAR0DZ9RFJJWbJDSbs6k/0VIvLUOErxbd8/8vL4VCJbw
	BJc4JmhFMMpObOeqFstrM4oM/OsevwDWzofCzTqzvlBx0gUeMLyveszQ7qwk6dns=
X-Gm-Gg: AR+sD10HHIKevjC1BqkyWG9VJzQqelihOLUgFrg4ds/JxpByqfAV0NoEmwYu946QOKX
	sDfxptXNykYc3qV/Rai0akFpUlTN6O37GfjxCttB5ENjknwQO79zzjxr+3xCwm56cJWcSUT2+oZ
	YPi3It/qAIiFuByv9ViqM9jlhOBwdfbL74dmRjjY6GtDPEeG4ZgjGTe/n/oQsB98q/+DfeqwMMM
	JYUwmdgv+1m0Rolt+f5ZJbujJqDm5+37qgKauwR4FiAeWEmbAa+GSfPPPTJo2XsJePleKUZPSYA
	ZKA60KNzlB+Brb+PUkfkqy76d1NRj2YGXT275XYXVVFTkIIwvLBV5PuMyZ6O0xSgXOXLoy4VjDT
	swVx1CYjd4tArq7Iox8zo5qQR5rPnX6LqLwWTcZPcxwBa38ND+ICOsPORrqJmfgZHqTTCF7bDoQ
	Xz+A==
X-Received: by 2002:a05:600c:1f85:b0:495:5b02:23b0 with SMTP id 5b1f17b1804b1-496c65738fdmr26962625e9.26.1785244673970;
        Tue, 28 Jul 2026 06:17:53 -0700 (PDT)
X-Received: by 2002:a05:600c:1f85:b0:495:5b02:23b0 with SMTP id 5b1f17b1804b1-496c65738fdmr26961715e9.26.1785244673388;
        Tue, 28 Jul 2026 06:17:53 -0700 (PDT)
Received: from ?IPV6:2a0d:3344:5521:6b10:58fd:68f:7756:389d? ([2a0d:3344:5521:6b10:58fd:68f:7756:389d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496c45cb67esm82058135e9.8.2026.07.28.06.17.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2026 06:17:51 -0700 (PDT)
Message-ID: <aa172687-48bc-41ca-85c8-d6d87495a8bc@redhat.com>
Date: Tue, 28 Jul 2026 15:17:49 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v14 00/15] net: introduce QUIC infrastructure and
 core subcomponents
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>,
 quic@lists.linux.dev
Cc: davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
 Simon Horman <horms@kernel.org>, Stefan Metzmacher <metze@samba.org>,
 Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>,
 Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz <dreibh@simula.no>,
 linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
 kernel-tls-handshake@lists.linux.dev, Chuck Lever <chuck.lever@oracle.com>,
 Jeff Layton <jlayton@kernel.org>, Steve Dickson <steved@redhat.com>,
 Hannes Reinecke <hare@suse.de>, Alexander Aring <aahringo@redhat.com>,
 David Howells <dhowells@redhat.com>, Matthieu Baerts <matttbe@kernel.org>,
 John Ericson <mail@johnericson.me>, Cong Wang <xiyou.wangcong@gmail.com>,
 "D . Wythe" <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>,
 illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Daniel Stenberg <daniel@haxx.se>,
 Andy Gospodarek <andrew.gospodarek@broadcom.com>,
 mef@scarletmail.rutgers.edu, paul@jakma.org
References: <cover.1784147238.git.lucien.xin@gmail.com>
From: Paolo Abeni <pabeni@redhat.com>
Content-Language: en-US
In-Reply-To: <cover.1784147238.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 7/15/26 10:27 PM, Xin Long wrote:
> Introduction
> ============
> 
> The QUIC protocol, defined in RFC 9000, is a secure, multiplexed transport
> built on top of UDP. It enables low-latency connection establishment,
> stream-based communication with flow control, and supports connection
> migration across network paths, while ensuring confidentiality, integrity,
> and availability.
> 
> This implementation introduces QUIC support in Linux Kernel, offering
> several key advantages:
> 
> - In-Kernel QUIC Support for Subsystems: Enables kernel subsystems
>   such as SMB and NFS to operate over QUIC with minimal changes. Once the
>   handshake is complete via the net/handshake APIs, data exchange proceeds
>   over standard in-kernel transport interfaces.
> 
> - Standard Socket API Semantics: Implements core socket operations
>   (listen(), accept(), connect(), sendmsg(), recvmsg(), close(),
>   getsockopt(), setsockopt(), getsockname(), and getpeername()),
>   allowing user space to interact with QUIC sockets in a familiar,
>   POSIX-compliant way.
> 
> - ALPN-Based Connection Dispatching: Supports in-kernel ALPN
>   (Application-Layer Protocol Negotiation) routing, allowing demultiplexing
>   of QUIC connections across different user-space processes based
>   on the ALPN identifiers.
> 
> - Performance Enhancements: Handles all control messages in-kernel
>   to reduce syscall overhead, incorporates zero-copy mechanisms such as
>   sendfile() to minimize data movement, and is also structured to support
>   future crypto hardware offloads.
> 
> This implementation offers fundamental support for the following RFCs:
> 
> - RFC9000 - QUIC: A UDP-Based Multiplexed and Secure Transport
> - RFC9001 - Using TLS to Secure QUIC
> - RFC9002 - QUIC Loss Detection and Congestion Control
> - RFC9221 - An Unreliable Datagram Extension to QUIC
> - RFC9287 - Greasing the QUIC Bit
> - RFC9368 - Compatible Version Negotiation for QUIC
> - RFC9369 - QUIC Version 2
> 
> The socket APIs for QUIC follow the RFC draft [1]:
> 
> - The Sockets API Extensions for In-kernel QUIC Implementations
> 
> Implementation
> ==============
> 
> The central design is to implement QUIC within the kernel while delegating
> the handshake to userspace.
> 
> Only the processing and creation of raw TLS Handshake Messages are handled
> in userspace, facilitated by a TLS library like GnuTLS. These messages are
> exchanged between kernel and userspace via sendmsg() and recvmsg(), with
> cryptographic details conveyed through control messages (cmsg).
> 
> The entire QUIC protocol, aside from the TLS Handshake Messages processing
> and creation, is managed in the kernel. Rather than using an Upper Layer
> Protocol (ULP) layer, this implementation establishes a socket of type
> IPPROTO_QUIC (similar to IPPROTO_MPTCP), operating over UDP tunnels.
> 
> For kernel consumers, they can initiate a handshake request from the kernel
> to userspace using the existing net/handshake netlink. The userspace
> component, such as tlshd service [2], then manages the processing
> of the QUIC handshake request.
> 
> - Handshake Architecture:
> 
>   ┌──────┐  ┌──────┐
>   │ APP1 │  │ APP2 │ ...
>   └──────┘  └──────┘
>   ┌──────────────────────────────────────────┐
>   │     {quic_client/server_handshake()}     │<─────────────┐
>   └──────────────────────────────────────────┘       ┌─────────────┐
>    {send/recvmsg()}      {set/getsockopt()}          │    tlshd    │
>    [CMSG handshake_info] [SOCKOPT_CRYPTO_SECRET]     └─────────────┘
>                          [SOCKOPT_TRANSPORT_PARAM_EXT]    │   ^
>                 │ ^                  │ ^                  │   │
>   Userspace     │ │                  │ │                  │   │
>   ──────────────│─│──────────────────│─│──────────────────│───│───────
>   Kernel        │ │                  │ │                  │   │
>                 v │                  v │                  v   │
>   ┌──────────────────┬───────────────────────┐       ┌─────────────┐
>   │ protocol, timer, │ socket (IPPROTO_QUIC) │<──┐   │ handshake   │
>   │                  ├───────────────────────┤   │   │netlink APIs │
>   │ common, family,  │ outqueue  |  inqueue  │   │   └─────────────┘
>   │                  ├───────────────────────┤   │      │       │
>   │ stream, connid,  │         frame         │   │   ┌─────┐ ┌─────┐
>   │                  ├───────────────────────┤   │   │     │ │     │
>   │ path, pnspace,   │         packet        │   │───│ SMB │ │ NFS │...
>   │                  ├───────────────────────┤   │   │     │ │     │
>   │ cong, crypto     │       UDP tunnels     │   │   └─────┘ └─────┘
>   └──────────────────┴───────────────────────┘   └──────┴───────┘
> 
> - User Data Architecture:
> 
>   ┌──────┐  ┌──────┐
>   │ APP1 │  │ APP2 │ ...
>   └──────┘  └──────┘
>    {send/recvmsg()}   {set/getsockopt()}              {recvmsg()}
>    [CMSG stream_info] [SOCKOPT_KEY_UPDATE]            [EVENT conn update]
>                       [SOCKOPT_CONNECTION_MIGRATION]  [EVENT stream update]
>                       [SOCKOPT_STREAM_OPEN/RESET/STOP]
>                 │ ^               │ ^                     ^
>   Userspace     │ │               │ │                     │
>   ──────────────│─│───────────────│─│─────────────────────│───────────
>   Kernel        │ │               │ │                     │
>                 v │               v │  ┌──────────────────┘
>   ┌──────────────────┬───────────────────────┐
>   │ protocol, timer, │ socket (IPPROTO_QUIC) │<──┐{kernel_send/recvmsg()}
>   │                  ├───────────────────────┤   │{kernel_set/getsockopt()}
>   │ common, family,  │ outqueue  |  inqueue  │   │{kernel_recvmsg()}
>   │                  ├───────────────────────┤   │
>   │ stream, connid,  │         frame         │   │   ┌─────┐ ┌─────┐
>   │                  ├───────────────────────┤   │   │     │ │     │
>   │ path, pnspace,   │         packet        │   │───│ SMB │ │ NFS │...
>   │                  ├───────────────────────┤   │   │     │ │     │
>   │ cong, crypto     │       UDP tunnels     │   │   └─────┘ └─────┘
>   └──────────────────┴───────────────────────┘   └──────┴───────┘
> 
> Interface
> =========
> 
> This implementation supports a mapping of QUIC into sockets APIs. Similar
> to TCP and SCTP, a typical Server and Client use the following system call
> sequence to communicate:
> 
>     Client                             Server
>   ──────────────────────────────────────────────────────────────────────
>   sockfd = socket(IPPROTO_QUIC)      listenfd = socket(IPPROTO_QUIC)
>   bind(sockfd)                       bind(listenfd)
>                                      listen(listenfd)
>   connect(sockfd)
>   quic_client_handshake(sockfd)
>                                      sockfd = accept(listenfd)
>                                      quic_server_handshake(sockfd, cert)
> 
>   sendmsg(sockfd)                    recvmsg(sockfd)
>   close(sockfd)                      close(sockfd)
>                                      close(listenfd)
> 
> Please note that quic_client_handshake() and quic_server_handshake()
> functions are currently sourced from libquic [3]. These functions are
> responsible for receiving and processing the raw TLS handshake messages
> until the completion of the handshake process.
> 
> For utilization by kernel consumers, it is essential to have tlshd
> service [2] installed and running in userspace. This service receives
> and manages kernel handshake requests for kernel sockets. In the kernel,
> the APIs closely resemble those used in userspace:
> 
>     Client                             Server
>   ────────────────────────────────────────────────────────────────────────
>   __sock_create(IPPROTO_QUIC, &sock)  __sock_create(IPPROTO_QUIC, &sock)
>   kernel_bind(sock)                   kernel_bind(sock)
>                                       kernel_listen(sock)
>   kernel_connect(sock)
>   tls_client_hello_x509(args:{sock})
>                                       kernel_accept(sock, &newsock)
>                                       tls_server_hello_x509(args:{newsock})
> 
>   kernel_sendmsg(sock)                kernel_recvmsg(newsock)
>   sock_release(sock)                  sock_release(newsock)
>                                       sock_release(sock)
> 
> Please be aware that tls_client_hello_x509() and tls_server_hello_x509()
> are APIs from net/handshake/. They are used to dispatch the handshake
> request to the userspace tlshd service and subsequently block until the
> handshake process is completed.
> 
> Use Cases
> =========
> 
> - Samba
> 
>   Stefan Metzmacher has integrated Linux QUIC into Samba for both client
>   and server roles [4].
> 
> - tlshd
> 
>   The tlshd daemon [2] facilitates Linux QUIC handshake requests from
>   kernel sockets. This is essential for enabling protocols like SMB
>   and NFS over QUIC.
> 
> - curl
> 
>   Linux QUIC is being integrated into curl [5] for HTTP/3. Example usage:
> 
>   # curl --http3-only https://nghttp2.org:4433/
>   # curl --http3-only https://www.google.com/
>   # curl --http3-only https://facebook.com/
>   # curl --http3-only https://outlook.office.com/
>   # curl --http3-only https://cloudflare-quic.com/
> 
> - httpd-portable
> 
>   Moritz Buhl has deployed an HTTP/3 server over Linux QUIC [6] that is
>   accessible via Firefox and curl:
> 
>   https://d.moritzbuhl.de/pub
> 
> - NetPerfMeter
> 
>   The latest NetPerfMeter release supports Linux QUIC and can be used to
>   run performance evaluations [10].
> 
> Test Coverage
> =============
> 
> The Coverage (gcov) of Functional and Interop Tests:
> 
> https://d.moritzbuhl.de/lcov
> 
> - Functional Tests
> 
>   The libquic self-tests (make check) pass on all major architectures:
>   x86_64, i386, s390x, aarch64, ppc64le.
> 
> - Interop tests
> 
>   Interoperability was validated using the QUIC Interop Runner [7] against
>   all major userland QUIC stacks. Results are available at:
> 
>   https://d.moritzbuhl.de/
> 
> - Fuzzing via Syzkaller
> 
>   Syzkaller has been running kernel fuzzing with QUIC for weeks using
>   tests/syzkaller/ in libquic [3].
> 
> - Performance Testing
> 
>   Performance was benchmarked using iperf [8] over a 100G NIC using
>   various MTUs and packet sizes:
> 
>   - QUIC vs. kTLS:
> 
>     UNIT        size:1024      size:4096      size:16384     size:65536
>     Gbits/sec   QUIC | kTLS    QUIC | kTLS    QUIC | kTLS    QUIC | kTLS
>     ────────────────────────────────────────────────────────────────────
>     mtu:1500    2.27 | 3.26    3.02 | 6.97    3.36 | 9.74    3.48 | 10.8
>     ────────────────────────────────────────────────────────────────────
>     mtu:9000    3.66 | 3.72    5.87 | 8.92    7.03 | 11.2    8.04 | 11.4
> 
>   - QUIC(disable_1rtt_encryption) vs. TCP:
> 
>     UNIT        size:1024      size:4096      size:16384     size:65536
>     Gbits/sec   QUIC | TCP     QUIC | TCP     QUIC | TCP     QUIC | TCP
>     ────────────────────────────────────────────────────────────────────
>     mtu:1500    3.09 | 4.59    4.46 | 14.2    5.07 | 21.3    5.18 | 23.9
>     ────────────────────────────────────────────────────────────────────
>     mtu:9000    4.60 | 4.65    8.41 | 14.0    11.3 | 28.9    13.5 | 39.2
> 
> 
>   The performance gap between QUIC and kTLS may be attributed to:
> 
>   - The absence of Generic Segmentation Offload (GSO) for QUIC.
>   - An additional data copy on the transmission (TX) path.
>   - Extra encryption required for header protection in QUIC.
>   - A longer header length for the stream data in QUIC.
> 
> Patches
> =======
> 
> Note: This implementation is organized into five parts and submitted across
> two patchsets for review. This patchset includes Parts 1–2, while Parts 3–5
> will be submitted in a subsequent patchset. For complete series, see [9].
> 
> 1. Infrastructure (2):
> 
>   net: define IPPROTO_QUIC and SOL_QUIC constants
>   net: build socket infrastructure for QUIC protocol
> 
> 2. Subcomponents (13):
> 
>   quic: provide common utilities and data structures
>   quic: provide family ops for address and protocol
>   quic: provide quic.h header files for kernel and userspace
>   quic: add stream management
>   quic: add connection id management
>   quic: add path management
>   quic: add congestion control
>   quic: add packet number space
>   quic: add crypto key derivation and installation
>   quic: add crypto packet encryption and decryption
>   quic: add timer management
>   quic: add packet builder base
>   quic: add packet parser base
> 
> 3. Data Processing (8):
> 
>   quic: add frame encoder and decoder base
>   quic: implement outqueue transmission and flow control
>   quic: implement outqueue sack and retransmission
>   quic: implement inqueue receiving and flow control
>   quic: implement frame creation functions
>   quic: implement frame processing functions
>   quic: implement packet creation functions
>   quic: implement packet processing functions
> 
> 4. Socket APIs (6):
> 
>   quic: support bind/listen/connect/accept/close()
>   quic: support sendmsg() and recvmsg()
>   quic: support socket options related to interaction after handshake
>   quic: support socket options related to settings prior to handshake
>   quic: support socket options related to setup during handshake
>   quic: support socket ioctls and socket dump via procfs
> 
> 5. Documentation and Selftests (3):
> 
>   Documentation: describe QUIC protocol interface in quic.rst
>   quic: create sample test using handshake APIs for kernel consumers
>   selftests: net: add tests for QUIC protocol
> 
> Notice: The QUIC module is currently labeled as "EXPERIMENTAL".
> 
> All contributors are recognized in the respective patches with the tag of
> 'Signed-off-by:'. Special thanks to Moritz Buhl and Stefan Metzmacher whose
> practical use cases and insightful feedback have been instrumental in
> shaping the design and advancing the development.
> 
> References
> ==========
> 
> [1]  https://datatracker.ietf.org/doc/html/draft-lxin-quic-socket-apis
> [2]  https://github.com/oracle/ktls-utils
> [3]  https://github.com/lxin/quic
> [4]  https://gitlab.com/samba-team/samba/-/merge_requests/4019
> [5]  https://github.com/moritzbuhl/curl/tree/linux_curl
> [6]  https://github.com/moritzbuhl/httpd-portable
> [7]  https://github.com/quic-interop/quic-interop-runner
> [8]  https://github.com/lxin/iperf
> [9]  https://github.com/lxin/net-next/commits/quic/
> [10] https://www.nntb.no/~dreibh/netperfmeter/
> 
> Changes in v2-v14: See individual patch changelogs for details.
I see that the possible UaF reported by claude are supposedly avoided by
a follow-up patch, as per discussion on v13. I would have been better to
at least explicitly note such fact in the commit message. Is the
relevant code path reachable with the current series?

Generally speaking it would be helpful a more fine grained discussion of
the actually reported issues. i.e. it's not obvious to me why the
potentianl UaF reported by sashiko gemini in patch 8 for netns do not
apply, nor could I find trivially a relevant discussion in the past few
revision.

Thanks,

Paolo

