Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC2E288AD;
	Mon, 18 Aug 2025 14:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755527505; cv=none; b=nLekqGI8jjhTO6qfyLUrU9KC/NqyUz0m1EEQmX+d9K5CYud4zcSWHgT2n/PYYSTrZNUi5xD8KQuYQEQS+I8RS3+4JmJVNLfmAeokBZGHaQAM6FyJFltWwsWBidXRLyVJ3rP+F6IlQvLVMsN1ieQrQ9BnNa+t+BC5Cimjz5LkLus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755527505; c=relaxed/simple;
	bh=LZyhNlWErTZfaiOwGWM9+qW3vd841xJv3O1uNo7STb0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gs7S88Z/TvPuGvF5mXAyos1rcpjbxt3UUjKZhDHeVdNzW/ykvRh7IBk0KBcfq6v9jVho8km1kHd4l6P3NOwogOZwil+/NXlEDyP2cJ1qYgZm7FR2AzFOnryLdi99886fcBw4TIPvY4SXM5jN9uAy0ufbDbn2+CbnkIDoXsY0Toc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Zo8Dlfhy; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Zo8Dlfhy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=Q0bC70KYbU70l1V9oWMxOUx91cfUilkZ3/uHXkaudow=; b=Zo8DlfhyeU1M7rWB1dZYh02JUR
	l+yG3/PgxODMGyvWZUmstpfJwh8hhvIlv/bE4Ej34Sr3UYWGuPL5GCppXT99JxuduwqGMAyUOu+Yf
	AGDb3pL8NsajaSJYV8NwwYgivA47QIA0mUmkF8KJAtu02CCylL7Pfc1qEYEVGE6hTdrzXyjQ3R5Xp
	3PQTTPAHwUB26ge5jTo1d8TIp9i9V7zyf78JgEzaNR8DOTsh7xunlKmuNkK3/nxJsYmLtTwZFdnH+
	nmW5RJBZK4bvbyF48XYhxWlmFKj7fvO94ZDfzSs0ylcryK/v00tXybk/e8omEhWENrzKwslyoWG0n
	UyQD/qk8rpNsRmyK9aHSWKSTQCrzCJrL7qr9QEZKzN9Tw/A4UO69uV46+SjDKm8oBkWfpffVyrXys
	iY9TsgQo8PpBOwaAq1A17drwvYsttKoKd497fnf9FT8XxtSiQ51m6o02XdCaYgsUfOxxtsGynpYUm
	TZuPejZFufphslfoJAy0a6UO;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uo0tW-003TUE-2Z;
	Mon, 18 Aug 2025 14:31:30 +0000
Message-ID: <5d5ac074-1790-410e-acf9-0e559cb7eacb@samba.org>
Date: Mon, 18 Aug 2025 16:31:29 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2 01/15] net: define IPPROTO_QUIC and SOL_QUIC
 constants
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>
Cc: davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>,
 Pengtao He <hepengtao@xiaomi.com>, linux-cifs@vger.kernel.org,
 Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>,
 Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>,
 kernel-tls-handshake@lists.linux.dev, Chuck Lever <chuck.lever@oracle.com>,
 Jeff Layton <jlayton@kernel.org>, Benjamin Coddington <bcodding@redhat.com>,
 Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>,
 Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>,
 Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe"
 <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>,
 illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Daniel Stenberg <daniel@haxx.se>,
 Andy Gospodarek <andrew.gospodarek@broadcom.com>
References: <cover.1755525878.git.lucien.xin@gmail.com>
 <50eb7a8c7f567f0a87b6e11d2ad835cdbb9546b4.1755525878.git.lucien.xin@gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <50eb7a8c7f567f0a87b6e11d2ad835cdbb9546b4.1755525878.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

> diff --git a/include/linux/socket.h b/include/linux/socket.h
> index 3b262487ec06..a7c05b064583 100644
> --- a/include/linux/socket.h
> +++ b/include/linux/socket.h
> @@ -386,6 +386,7 @@ struct ucred {
>   #define SOL_MCTP	285
>   #define SOL_SMC		286
>   #define SOL_VSOCK	287
> +#define SOL_QUIC	288
>   
>   /* IPX options */
>   #define IPX_TYPE	1
> diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
> index ced0fc3c3aa5..34becd90d3a6 100644
> --- a/include/uapi/linux/in.h
> +++ b/include/uapi/linux/in.h
> @@ -85,6 +85,8 @@ enum {
>   #define IPPROTO_RAW		IPPROTO_RAW
>     IPPROTO_SMC = 256,		/* Shared Memory Communications		*/
>   #define IPPROTO_SMC		IPPROTO_SMC
> +  IPPROTO_QUIC = 261,		/* A UDP-Based Multiplexed and Secure Transport	*/
> +#define IPPROTO_QUIC		IPPROTO_QUIC
>     IPPROTO_MPTCP = 262,		/* Multipath TCP connection		*/
>   #define IPPROTO_MPTCP		IPPROTO_MPTCP
>     IPPROTO_MAX

Can these constants be accepted, soon?

Samba 4.23.0 to be released early September will ship userspace code to
use them. It would be good to have them correct when kernel's start to
support this...

It would also mean less risk for conflicting projects with the need for such numbers.

I think it's useful to use a value lower than IPPROTO_MAX, because it means
the kernel module can also be build against older kernels as out of tree module
and still it would be transparent for userspace consumers like samba.
There are hardcoded checks for IPPROTO_MAX in inet_create, inet6_create, inet_diag_register
and the value of IPPROTO_MAX is 263 starting with commit
d25a92ccae6bed02327b63d138e12e7806830f78 in 6.11.

Thanks!
metze
