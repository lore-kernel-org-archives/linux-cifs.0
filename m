Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8273448B9F
	for <linux-cifs@vger.kernel.org>; Thu, 17 Sep 2026 08:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789634131; cv=none; b=JRUvveE+0nZxah4SdOxYpDaysNtPRZXvU5gi9/lh7OCB95+S9wO2enOOoe/9T3wlqxRNlZn1pMK/yTJejp+t9Ejiy11h/9NlnsUI5K9fMb8w/D0LoVXU/W9aAJ/KegSEmaL6+Wt8rt2rHTiIqxK2h7q1xDTRKzF+kGU20q78ye0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789634131; c=relaxed/simple;
	bh=Kju81U6fWagFrYImpbLYaoKLdVcWsbvRqhAOk3rRGek=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sZn2GRAia+kDcxhk1JPYkqyEgevXjEEL21MDllMYpmuZkGDScETefe3wbY76xyJ3D53VULE2N7uCPfAlOCKWOc+x/XkH3up9E0dYwK/nzSgdkepPXVMVTNCAZWdXDlh7T3IvJewhF8/U0lM47gUiEjdFfoIXyeNDs97R5BtbTLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QB1rAqOE; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=SvvjOSkq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QB1rAqOE";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="SvvjOSkq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789634111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dppe6Hmmck6aOeZbA583cRNICOEkLAcckJMXxDTqtY8=;
	b=QB1rAqOEo/8ss1FqZjZgZB9W9Oi/FAD5GPLoPteXRdu3tLc1+fNfoZI7QcxqJPsTrOlxya
	rPXdy9Wm3SmXBQwKL+gqy6CVxJe52brKtms7cazuN+Me7rHClXr8gX+Oc0aDwSsXuUAYzF
	oqbY2d9iTIQ08+Mj62ugWu1xkHbZeh8=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-g3tgCyKvNsCx306LNpBgqw-1; Thu, 17 Sep 2026 04:35:09 -0400
X-MC-Unique: g3tgCyKvNsCx306LNpBgqw-1
X-Mimecast-MFC-AGG-ID: g3tgCyKvNsCx306LNpBgqw_1789634109
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-485866e0066so190572f8f.2
        for <linux-cifs@vger.kernel.org>; Thu, 17 Sep 2026 01:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789634109; x=1790238909; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dppe6Hmmck6aOeZbA583cRNICOEkLAcckJMXxDTqtY8=;
        b=SvvjOSkqoh3G9tUNlokcRXFveynnqnMMjJittM51MSaYmUEhHgMbu+gnHSmW1pvbBA
         uKY4RJ5UEH89IFmrK6uxmpw0Se/HSMOriLZoIlh33UdUNGuN6liTQh6gzB0V19QXF49x
         LhsmWw4pg1sQdMbmaVj+iydlFCak92mItNcTCLVzxCVyFLRlADbVhtBos/SylLIvzK5+
         aeO3gKraBAxQ2142Vt3P9saUp0jVjffFPO1u6TW6hPzVncPFqjIyTSGswMgsA03914R4
         fIkLUD8oyOKXY4bTcbRoOkHz48AAzAFwEYsTjVJylOUS4WJbAVLR2LqT9ktN/QdBNUr1
         Xb9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789634109; x=1790238909;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dppe6Hmmck6aOeZbA583cRNICOEkLAcckJMXxDTqtY8=;
        b=q/BK0FPzcajDrp6zavSPVdvo5gKx9IsVbbPhyjXa3/JH+4/FHvnNBvMnr3NYQIUmLn
         oehfLLN4U8fHFfmoZVKXNlxUmc14phZ0d3PJfOfSyLGs6wPV36QMiFv3IZsFLpx9IhiT
         iWdoQcf2NoCJ4GLe4FMd6vkjz8WSI4aDI72Y2IYOTu/Nec9O1wPDei/wq27PQlc4eg4l
         Xnov3EX33UKPqjlExkdkui/gcnBhOQQPTjg3fI6Tc1iRTp7TVlsTCk484CcLmSqqnD7g
         GgtdMV/x2BNrFtTbYQW+zqGiAqR9ALfQfteFN1/BIENKlGIdAA9LZmDt7Jd4r74TLanX
         36HQ==
X-Forwarded-Encrypted: i=1; AKwUvBxmMEyNuKndZxoClL3vj6rk3jGvIysaDweoeBSOaPDY5XsWuX0ed+AHLFp6n6VkKUMyr6KrUdPRjCZ1@vger.kernel.org
X-Gm-Message-State: AFuF++k0QbNh2LMCoCntbuzU5nhfbfimUAnRvPNlAB3JndtIXVa7/xAw
	nKbnjFn0zgshvsR8DOPL1MJr2pz7D+WAbMOQgxb5y7cp6JgeweXm0XEZXOs+v7u/V90vbhZlc6i
	hSog3skwXFCkojdZOEEziZGIyKJx+TVattxvqKB2vjAKux0CJvXsdmTx4gozGgFI=
X-Gm-Gg: AYBFou3eNBltg/QlA5+dU1YwHs9GanMfrv9LrKwoQ1benAWevBkUbK+KJSrX0ONLg/W
	NTGZO6zoZies1jEZwPz0RolqswOKAvSHjDLMUVy+OeTJOUspMFZXBPnC5YDXV29vCFxog0Ft46q
	EQYe4jUA2O/Yl9YMlXB019j4uiKcfNAsABM63fa4dvKTPsYOGYFzP0rQ2OoV4wO5JzjJqUb34YP
	3SNY6errkMFsTFTE3CTiyF29gliiulLH3PwGRyQAR0Sg4R/I7vzKX2RldfatbPBNKW2ksgTTNDK
	lKjcxl/81gGdfkyFBeOoY/p8agDLL0QGxJKF/T6TizIN39c/PwvWqWtJPuUZRwaS1cgrgcfJ2ij
	fAOSuPOVhIFPLJwuCBdlXolemu6WfU1Y+H/QHkq7meYtMCm/5DDfgHbnwWUv/GiIx+TX5ORJmCg
	==
X-Received: by 2002:a05:6000:27ce:b0:487:ee6:b76c with SMTP id ffacd0b85a97d-4870ee6b9a4mr4677934f8f.56.1789634108415;
        Thu, 17 Sep 2026 01:35:08 -0700 (PDT)
X-Received: by 2002:a05:6000:27ce:b0:487:ee6:b76c with SMTP id ffacd0b85a97d-4870ee6b9a4mr4677910f8f.56.1789634107890;
        Thu, 17 Sep 2026 01:35:07 -0700 (PDT)
Received: from [192.168.188.234] (ip232-47-231-195.pool-bba.aruba.it. [195.231.47.232])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bf43542sm12931034f8f.32.2026.09.17.01.35.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2026 01:35:06 -0700 (PDT)
Message-ID: <31ebf88a-9d33-4e5a-bb38-c98881457739@redhat.com>
Date: Thu, 17 Sep 2026 10:35:04 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v15 00/15] net: introduce QUIC infrastructure and
 core subcomponents
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>,
 quic@lists.linux.dev
Cc: davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
 Simon Horman <horms@kernel.org>, Stefan Metzmacher <metze@samba.org>,
 Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>,
 Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz <dreibh@simula.no>,
 linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.org>,
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
References: <cover.1789393775.git.lucien.xin@gmail.com>
 <CADvbK_cMQ7psJQQkaa6LLcjYc2M2jt60FY+rJgW6YG7hgdwSRA@mail.gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <CADvbK_cMQ7psJQQkaa6LLcjYc2M2jt60FY+rJgW6YG7hgdwSRA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/16/26 20:33, Xin Long wrote:
> On Mon, Sep 14, 2026 at 9:52 AM Xin Long <lucien.xin@gmail.com> wrote:
>>
>> Introduction
>> ============
>>
>> The QUIC protocol, defined in RFC 9000, is a secure, multiplexed transport
>> built on top of UDP. It enables low-latency connection establishment,
>> stream-based communication with flow control, and supports connection
>> migration across network paths, while ensuring confidentiality, integrity,
>> and availability.
>>
>> This implementation introduces QUIC support in Linux Kernel, offering
>> several key advantages:
>>
>> - In-Kernel QUIC Support for Subsystems: Enables kernel subsystems
>>    such as SMB and NFS to operate over QUIC with minimal changes. Once the
>>    handshake is complete via the net/handshake APIs, data exchange proceeds
>>    over standard in-kernel transport interfaces.
>>
>> - Standard Socket API Semantics: Implements core socket operations
>>    (listen(), accept(), connect(), sendmsg(), recvmsg(), close(),
>>    getsockopt(), setsockopt(), getsockname(), and getpeername()),
>>    allowing user space to interact with QUIC sockets in a familiar,
>>    POSIX-compliant way.
>>
>> - ALPN-Based Connection Dispatching: Supports in-kernel ALPN
>>    (Application-Layer Protocol Negotiation) routing, allowing demultiplexing
>>    of QUIC connections across different user-space processes based
>>    on the ALPN identifiers.
>>
>> - Performance Enhancements: Handles all control messages in-kernel
>>    to reduce syscall overhead, incorporates zero-copy mechanisms such as
>>    sendfile() to minimize data movement, and is also structured to support
>>    future crypto hardware offloads.
>>
>> This implementation offers fundamental support for the following RFCs:
>>
>> - RFC9000 - QUIC: A UDP-Based Multiplexed and Secure Transport
>> - RFC9001 - Using TLS to Secure QUIC
>> - RFC9002 - QUIC Loss Detection and Congestion Control
>> - RFC9221 - An Unreliable Datagram Extension to QUIC
>> - RFC9287 - Greasing the QUIC Bit
>> - RFC9368 - Compatible Version Negotiation for QUIC
>> - RFC9369 - QUIC Version 2
>>
>> The socket APIs for QUIC follow the RFC draft [1]:
>>
>> - The Sockets API Extensions for In-kernel QUIC Implementations
>>
>> Implementation
>> ==============
>>
>> The central design is to implement QUIC within the kernel while delegating
>> the handshake to userspace.
>>
>> Only the processing and creation of raw TLS Handshake Messages are handled
>> in userspace, facilitated by a TLS library like GnuTLS. These messages are
>> exchanged between kernel and userspace via sendmsg() and recvmsg(), with
>> cryptographic details conveyed through control messages (cmsg).
>>
>> The entire QUIC protocol, aside from the TLS Handshake Messages processing
>> and creation, is managed in the kernel. Rather than using an Upper Layer
>> Protocol (ULP) layer, this implementation establishes a socket of type
>> IPPROTO_QUIC (similar to IPPROTO_MPTCP), operating over UDP tunnels.
>>
>> For kernel consumers, they can initiate a handshake request from the kernel
>> to userspace using the existing net/handshake netlink. The userspace
>> component, such as tlshd service [2], then manages the processing
>> of the QUIC handshake request.
>>
>> - Handshake Architecture:
>>
>>    ┌──────┐  ┌──────┐
>>    │ APP1 │  │ APP2 │ ...
>>    └──────┘  └──────┘
>>    ┌──────────────────────────────────────────┐
>>    │     {quic_client/server_handshake()}     │<─────────────┐
>>    └──────────────────────────────────────────┘       ┌─────────────┐
>>     {send/recvmsg()}      {set/getsockopt()}          │    tlshd    │
>>     [CMSG handshake_info] [SOCKOPT_CRYPTO_SECRET]     └─────────────┘
>>                           [SOCKOPT_TRANSPORT_PARAM_EXT]    │   ^
>>                  │ ^                  │ ^                  │   │
>>    Userspace     │ │                  │ │                  │   │
>>    ──────────────│─│──────────────────│─│──────────────────│───│───────
>>    Kernel        │ │                  │ │                  │   │
>>                  v │                  v │                  v   │
>>    ┌──────────────────┬───────────────────────┐       ┌─────────────┐
>>    │ protocol, timer, │ socket (IPPROTO_QUIC) │<──┐   │ handshake   │
>>    │                  ├───────────────────────┤   │   │netlink APIs │
>>    │ common, family,  │ outqueue  |  inqueue  │   │   └─────────────┘
>>    │                  ├───────────────────────┤   │      │       │
>>    │ stream, connid,  │         frame         │   │   ┌─────┐ ┌─────┐
>>    │                  ├───────────────────────┤   │   │     │ │     │
>>    │ path, pnspace,   │         packet        │   │───│ SMB │ │ NFS │...
>>    │                  ├───────────────────────┤   │   │     │ │     │
>>    │ cong, crypto     │       UDP tunnels     │   │   └─────┘ └─────┘
>>    └──────────────────┴───────────────────────┘   └──────┴───────┘
>>
>> - User Data Architecture:
>>
>>    ┌──────┐  ┌──────┐
>>    │ APP1 │  │ APP2 │ ...
>>    └──────┘  └──────┘
>>     {send/recvmsg()}   {set/getsockopt()}              {recvmsg()}
>>     [CMSG stream_info] [SOCKOPT_KEY_UPDATE]            [EVENT conn update]
>>                        [SOCKOPT_CONNECTION_MIGRATION]  [EVENT stream update]
>>                        [SOCKOPT_STREAM_OPEN/RESET/STOP]
>>                  │ ^               │ ^                     ^
>>    Userspace     │ │               │ │                     │
>>    ──────────────│─│───────────────│─│─────────────────────│───────────
>>    Kernel        │ │               │ │                     │
>>                  v │               v │  ┌──────────────────┘
>>    ┌──────────────────┬───────────────────────┐
>>    │ protocol, timer, │ socket (IPPROTO_QUIC) │<──┐{kernel_send/recvmsg()}
>>    │                  ├───────────────────────┤   │{kernel_set/getsockopt()}
>>    │ common, family,  │ outqueue  |  inqueue  │   │{kernel_recvmsg()}
>>    │                  ├───────────────────────┤   │
>>    │ stream, connid,  │         frame         │   │   ┌─────┐ ┌─────┐
>>    │                  ├───────────────────────┤   │   │     │ │     │
>>    │ path, pnspace,   │         packet        │   │───│ SMB │ │ NFS │...
>>    │                  ├───────────────────────┤   │   │     │ │     │
>>    │ cong, crypto     │       UDP tunnels     │   │   └─────┘ └─────┘
>>    └──────────────────┴───────────────────────┘   └──────┴───────┘
>>
>> Interface
>> =========
>>
>> This implementation supports a mapping of QUIC into sockets APIs. Similar
>> to TCP and SCTP, a typical Server and Client use the following system call
>> sequence to communicate:
>>
>>      Client                             Server
>>    ──────────────────────────────────────────────────────────────────────
>>    sockfd = socket(IPPROTO_QUIC)      listenfd = socket(IPPROTO_QUIC)
>>    bind(sockfd)                       bind(listenfd)
>>                                       listen(listenfd)
>>    connect(sockfd)
>>    quic_client_handshake(sockfd)
>>                                       sockfd = accept(listenfd)
>>                                       quic_server_handshake(sockfd, cert)
>>
>>    sendmsg(sockfd)                    recvmsg(sockfd)
>>    close(sockfd)                      close(sockfd)
>>                                       close(listenfd)
>>
>> Please note that quic_client_handshake() and quic_server_handshake()
>> functions are currently sourced from libquic [3]. These functions are
>> responsible for receiving and processing the raw TLS handshake messages
>> until the completion of the handshake process.
>>
>> For utilization by kernel consumers, it is essential to have tlshd
>> service [2] installed and running in userspace. This service receives
>> and manages kernel handshake requests for kernel sockets. In the kernel,
>> the APIs closely resemble those used in userspace:
>>
>>      Client                             Server
>>    ────────────────────────────────────────────────────────────────────────
>>    __sock_create(IPPROTO_QUIC, &sock)  __sock_create(IPPROTO_QUIC, &sock)
>>    kernel_bind(sock)                   kernel_bind(sock)
>>                                        kernel_listen(sock)
>>    kernel_connect(sock)
>>    tls_client_hello_x509(args:{sock})
>>                                        kernel_accept(sock, &newsock)
>>                                        tls_server_hello_x509(args:{newsock})
>>
>>    kernel_sendmsg(sock)                kernel_recvmsg(newsock)
>>    sock_release(sock)                  sock_release(newsock)
>>                                        sock_release(sock)
>>
>> Please be aware that tls_client_hello_x509() and tls_server_hello_x509()
>> are APIs from net/handshake/. They are used to dispatch the handshake
>> request to the userspace tlshd service and subsequently block until the
>> handshake process is completed.
>>
>> Use Cases
>> =========
>>
>> - Samba
>>
>>    Stefan Metzmacher has integrated Linux QUIC into Samba for both client
>>    and server roles [4].
>>
>> - tlshd
>>
>>    The tlshd daemon [2] facilitates Linux QUIC handshake requests from
>>    kernel sockets. This is essential for enabling protocols like SMB
>>    and NFS over QUIC.
>>
>> - curl
>>
>>    Linux QUIC is being integrated into curl [5] for HTTP/3. Example usage:
>>
>>    # curl --http3-only https://nghttp2.org:4433/
>>    # curl --http3-only https://www.google.com/
>>    # curl --http3-only https://facebook.com/
>>    # curl --http3-only https://outlook.office.com/
>>    # curl --http3-only https://cloudflare-quic.com/
>>
>> - httpd-portable
>>
>>    Moritz Buhl has deployed an HTTP/3 server over Linux QUIC [6] that is
>>    accessible via Firefox and curl:
>>
>>    https://d.moritzbuhl.de/pub
>>
>> - NetPerfMeter
>>
>>    The latest NetPerfMeter release supports Linux QUIC and can be used to
>>    run performance evaluations [10].
>>
>> Test Coverage
>> =============
>>
>> The Coverage (gcov) of Functional and Interop Tests:
>>
>> https://d.moritzbuhl.de/lcov
>>
>> - Functional Tests
>>
>>    The libquic self-tests (make check) pass on all major architectures:
>>    x86_64, i386, s390x, aarch64, ppc64le.
>>
>> - Interop tests
>>
>>    Interoperability was validated using the QUIC Interop Runner [7] against
>>    all major userland QUIC stacks. Results are available at:
>>
>>    https://d.moritzbuhl.de/
>>
>> - Fuzzing via Syzkaller
>>
>>    Syzkaller has been running kernel fuzzing with QUIC for weeks using
>>    tests/syzkaller/ in libquic [3].
>>
>> - Performance Testing
>>
>>    Performance was benchmarked using iperf [8] over a 100G NIC using
>>    various MTUs and packet sizes:
>>
>>    - QUIC vs. kTLS:
>>
>>      UNIT        size:1024      size:4096      size:16384     size:65536
>>      Gbits/sec   QUIC | kTLS    QUIC | kTLS    QUIC | kTLS    QUIC | kTLS
>>      ────────────────────────────────────────────────────────────────────
>>      mtu:1500    2.27 | 3.26    3.02 | 6.97    3.36 | 9.74    3.48 | 10.8
>>      ────────────────────────────────────────────────────────────────────
>>      mtu:9000    3.66 | 3.72    5.87 | 8.92    7.03 | 11.2    8.04 | 11.4
>>
>>    - QUIC(disable_1rtt_encryption) vs. TCP:
>>
>>      UNIT        size:1024      size:4096      size:16384     size:65536
>>      Gbits/sec   QUIC | TCP     QUIC | TCP     QUIC | TCP     QUIC | TCP
>>      ────────────────────────────────────────────────────────────────────
>>      mtu:1500    3.09 | 4.59    4.46 | 14.2    5.07 | 21.3    5.18 | 23.9
>>      ────────────────────────────────────────────────────────────────────
>>      mtu:9000    4.60 | 4.65    8.41 | 14.0    11.3 | 28.9    13.5 | 39.2
>>
>>
>>    The performance gap between QUIC and kTLS may be attributed to:
>>
>>    - The absence of Generic Segmentation Offload (GSO) for QUIC.
>>    - An additional data copy on the transmission (TX) path.
>>    - Extra encryption required for header protection in QUIC.
>>    - A longer header length for the stream data in QUIC.
>>
>> Patches
>> =======
>>
>> Note: This implementation is organized into five parts and submitted across
>> two patchsets for review. This patchset includes Parts 1–2, while Parts 3–5
>> will be submitted in a subsequent patchset. For complete series, see [9].
>>
>> 1. Infrastructure (2):
>>
>>    net: define IPPROTO_QUIC and SOL_QUIC constants
>>    net: build socket infrastructure for QUIC protocol
>>
>> 2. Subcomponents (13):
>>
>>    quic: provide common utilities and data structures
>>    quic: provide family ops for address and protocol
>>    quic: provide quic.h header files for kernel and userspace
>>    quic: add stream management
>>    quic: add connection id management
>>    quic: add path management
>>    quic: add congestion control
>>    quic: add packet number space
>>    quic: add crypto key derivation and installation
>>    quic: add crypto packet encryption and decryption
>>    quic: add timer management
>>    quic: add packet builder base
>>    quic: add packet parser base
>>
>> 3. Data Processing (8):
>>
>>    quic: add frame encoder and decoder base
>>    quic: implement outqueue transmission and flow control
>>    quic: implement outqueue sack and retransmission
>>    quic: implement inqueue receiving and flow control
>>    quic: implement frame creation functions
>>    quic: implement frame processing functions
>>    quic: implement packet creation functions
>>    quic: implement packet processing functions
>>
>> 4. Socket APIs (6):
>>
>>    quic: support bind/listen/connect/accept/close()
>>    quic: support sendmsg() and recvmsg()
>>    quic: support socket options related to interaction after handshake
>>    quic: support socket options related to settings prior to handshake
>>    quic: support socket options related to setup during handshake
>>    quic: support socket ioctls and socket dump via procfs
>>
>> 5. Documentation and Selftests (3):
>>
>>    Documentation: describe QUIC protocol interface in quic.rst
>>    quic: create sample test using handshake APIs for kernel consumers
>>    selftests: net: add tests for QUIC protocol
>>
>> Notice: The QUIC module is currently labeled as "EXPERIMENTAL".
>>
>> All contributors are recognized in the respective patches with the tag of
>> 'Signed-off-by:'. Special thanks to Moritz Buhl and Stefan Metzmacher whose
>> practical use cases and insightful feedback have been instrumental in
>> shaping the design and advancing the development.
>>
>> References
>> ==========
>>
>> [1]  https://datatracker.ietf.org/doc/html/draft-lxin-quic-socket-apis
>> [2]  https://github.com/oracle/ktls-utils
>> [3]  https://github.com/lxin/quic
>> [4]  https://gitlab.com/samba-team/samba/-/merge_requests/4019
>> [5]  https://github.com/moritzbuhl/curl/tree/linux_curl
>> [6]  https://github.com/moritzbuhl/httpd-portable
>> [7]  https://github.com/quic-interop/quic-interop-runner
>> [8]  https://github.com/lxin/iperf
>> [9]  https://github.com/lxin/net-next/commits/quic/
>> [10] https://www.nntb.no/~dreibh/netperfmeter/
>>
>> Changes in v2-v15: See individual patch changelogs for details.
>>
>> Xin Long (15):
>>    net: define IPPROTO_QUIC and SOL_QUIC constants
>>    net: build socket infrastructure for QUIC protocol
>>    quic: provide common utilities and data structures
>>    quic: provide family ops for address and protocol
>>    quic: provide quic.h header files for kernel and userspace
>>    quic: add stream management
>>    quic: add connection id management
>>    quic: add path management
>>    quic: add congestion control
>>    quic: add packet number space
>>    quic: add crypto key derivation and installation
>>    quic: add crypto packet encryption and decryption
>>    quic: add timer management
>>    quic: add packet builder base
>>    quic: add packet parser base
>>
>>   Documentation/networking/ip-sysctl.rst        |   39 +
>>   MAINTAINERS                                   |    9 +
>>   include/linux/quic.h                          |   38 +
>>   include/linux/socket.h                        |    1 +
>>   include/trace/events/sock.h                   |    3 +-
>>   include/uapi/linux/in.h                       |    2 +
>>   include/uapi/linux/quic.h                     |  241 ++++
>>   net/Kconfig                                   |    1 +
>>   net/Makefile                                  |    1 +
>>   net/quic/Kconfig                              |   35 +
>>   net/quic/Makefile                             |    9 +
>>   net/quic/common.c                             |  565 ++++++++
>>   net/quic/common.h                             |  220 +++
>>   net/quic/cong.c                               |  340 +++++
>>   net/quic/cong.h                               |  132 ++
>>   net/quic/connid.c                             |  283 ++++
>>   net/quic/connid.h                             |  183 +++
>>   net/quic/crypto.c                             | 1251 +++++++++++++++++
>>   net/quic/crypto.h                             |   88 ++
>>   net/quic/family.c                             |  446 ++++++
>>   net/quic/family.h                             |   44 +
>>   net/quic/packet.c                             | 1055 ++++++++++++++
>>   net/quic/packet.h                             |  123 ++
>>   net/quic/path.c                               |  589 ++++++++
>>   net/quic/path.h                               |  192 +++
>>   net/quic/pnspace.c                            |  273 ++++
>>   net/quic/pnspace.h                            |  201 +++
>>   net/quic/protocol.c                           |  403 ++++++
>>   net/quic/protocol.h                           |   57 +
>>   net/quic/socket.c                             |  654 +++++++++
>>   net/quic/socket.h                             |  242 ++++
>>   net/quic/stream.c                             |  416 ++++++
>>   net/quic/stream.h                             |  133 ++
>>   net/quic/timer.c                              |  154 ++
>>   net/quic/timer.h                              |   45 +
>>   tools/include/uapi/linux/in.h                 |    2 +
>>   .../perf/trace/beauty/include/linux/socket.h  |    1 +
>>   usr/include/Makefile                          |    1 +
>>   38 files changed, 8471 insertions(+), 1 deletion(-)
>>   create mode 100644 include/linux/quic.h
>>   create mode 100644 include/uapi/linux/quic.h
>>   create mode 100644 net/quic/Kconfig
>>   create mode 100644 net/quic/Makefile
>>   create mode 100644 net/quic/common.c
>>   create mode 100644 net/quic/common.h
>>   create mode 100644 net/quic/cong.c
>>   create mode 100644 net/quic/cong.h
>>   create mode 100644 net/quic/connid.c
>>   create mode 100644 net/quic/connid.h
>>   create mode 100644 net/quic/crypto.c
>>   create mode 100644 net/quic/crypto.h
>>   create mode 100644 net/quic/family.c
>>   create mode 100644 net/quic/family.h
>>   create mode 100644 net/quic/packet.c
>>   create mode 100644 net/quic/packet.h
>>   create mode 100644 net/quic/path.c
>>   create mode 100644 net/quic/path.h
>>   create mode 100644 net/quic/pnspace.c
>>   create mode 100644 net/quic/pnspace.h
>>   create mode 100644 net/quic/protocol.c
>>   create mode 100644 net/quic/protocol.h
>>   create mode 100644 net/quic/socket.c
>>   create mode 100644 net/quic/socket.h
>>   create mode 100644 net/quic/stream.c
>>   create mode 100644 net/quic/stream.h
>>   create mode 100644 net/quic/timer.c
>>   create mode 100644 net/quic/timer.h
>>
>> --
>> 2.47.1
>>
> 
> I've looked into the Sashiko reviews:
> 
> [Sashiko-Gemini]
> (https://sashiko.dev/#/patchset/cover.1789393775.git.lucien.xin%40gmail.com)
> 
> - 0 issues reported. I'm not sure whether the workflow still uses this report.

FYI, the results from the public sashiko instance are integreated into 
the nipa one and validated by other models. The nipa instance is the 
most relevant entry point.

