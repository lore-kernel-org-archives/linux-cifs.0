Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71463FC2;
	Tue, 10 Sep 2024 03:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725939047; cv=none; b=k2DUL0i/44rDQ7/T8L+pzn9Vj6CKhe4pCaNzpw0NSCa7AygRQS60xlr1BzNJUONOh/pTrchiTwhrBRGq11w4hLSBQigV3TGzELkHXAJ5gdAojHDvwdDKPBk3FqmIpebLWmb8bm2IR5iibTl6K3dtsLghXyBvGnw2uMTR47Phh9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725939047; c=relaxed/simple;
	bh=3N8SjM9TtiMmJrysF8VNmteOPW6PkPRNMIAGePEFBlQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VzbGa5WzInKvM/kASeVZAkU6VuwtSvRTlrB3ptoWO3kYm6JDSYSdiiLDTwbn8tnh03WbSSCzo34zh1k0DVm4hkfRsrgKyosccjVWTXXzROv5ukhfznYk6MaVPdTAM95xeqIsRPYjhLY3FeoyJIzj4EpDWKuZMib7nrAuaAHQjhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Fvo1vsS4; arc=none smtp.client-ip=115.124.30.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Fvo1vsS4"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1725939042; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=EM2hYPwz9Ery4O4R9Te+TtP9slxaZBsSh5owFNBpRr4=;
	b=Fvo1vsS4MgIl8/ZgHo4wLDft2TmGYDgri2cNXxoA1Y3NRAhPoyCVfPYpFnKF9UYGuVWptmUsGAgcxgmDCHLImPfVKbQsCYeB6C7l5hL1GkHUCx218tD/6eWXh0FIDQafb7UfEqQLAenWutWaRNbifLqTqLRBrP0EVxMsQnTPcSw=
Received: from 30.221.149.60(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0WEiq3Tr_1725939040)
          by smtp.aliyun-inc.com;
          Tue, 10 Sep 2024 11:30:41 +0800
Message-ID: <98474d13-a5c3-44c3-b847-cac662affe26@linux.alibaba.com>
Date: Tue, 10 Sep 2024 11:30:39 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next 3/5] net: implement QUIC protocol code in
 net/quic directory
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>
Cc: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski
 <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Moritz Buhl <mbuhl@openbsd.org>,
 Tyler Fanelli <tfanelli@redhat.com>, Pengtao He <hepengtao@xiaomi.com>,
 linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>, Stefan Metzmacher <metze@samba.org>,
 Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>,
 kernel-tls-handshake@lists.linux.dev, Chuck Lever <chuck.lever@oracle.com>,
 Jeff Layton <jlayton@kernel.org>, Steve Dickson <steved@redhat.com>,
 Hannes Reinecke <hare@suse.de>, Alexander Aring <aahringo@redhat.com>,
 Sabrina Dubroca <sd@queasysnail.net>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Daniel Stenberg <daniel@haxx.se>,
 Andy Gospodarek <andrew.gospodarek@broadcom.com>
References: <cover.1725935420.git.lucien.xin@gmail.com>
 <263f1674317f7e3b511bde44ae62a4ff32c2e00b.1725935420.git.lucien.xin@gmail.com>
Content-Language: en-US
From: "D. Wythe" <alibuda@linux.alibaba.com>
In-Reply-To: <263f1674317f7e3b511bde44ae62a4ff32c2e00b.1725935420.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 9/10/24 10:30 AM, Xin Long wrote:
> This commit adds the initial implementation of the QUIC protocol code.
> The new net/quic directory contains the necessary source files to
> handle QUIC functionality within the networking subsystem:
>
> - protocol.c: module init/exit and family_ops for inet and inet6.
> - socket.c: definition of functions within the 'quic_prot' struct.
> - connid.c: management of source and dest connection IDs.
> - stream.c: bidi/unidirectional stream handling and management.
> - cong.c: RTT measurement and congestion control mechanisms.
> - timer.c: definition of essential timers including RTX/PROBE/IDLE/ACK.
> - packet.c: creation and processing of various of short/long packets.
> - frame.c: creation and processing of diverse types of frames.
> - crypto.c: key derivation/update and header/payload de/encryption.
> - pnspace.c: packet number namespaces and SACK range handling.
> - input.c: socket lookup and stream/event frames enqueuing to userspace.
> - output.c: frames enqueuing for send/resend as well as acknowledgment.
> - path.c: src/dst path management including UDP tunnels and PLPMTUD.
> - test/unit_test.c: tests for APIs defined in some of the above files.
> - test/sample_test.c: a sample showcasing usage from the kernel space.
>

Hi Xin,

I was intended to review your implementation, but I didn't know where to 
start. All your implementations
are in one patch, making it quite difficult to review, so I gave up. 🙁

I think maybe you could consider adding interoperability tests with 
other variants of QUIC implementations.
When we were working on xquic, this helped us discover many 
implementation issues, and it might be
beneficial for you as well.

You can check it out from https://interop.seemann.io/.
