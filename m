Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B27823B7;
	Mon, 29 Apr 2024 15:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714404035; cv=none; b=g7VZv5WxYiaXAZ4j8cQdaK3UIqXDQuTlYIk6lskpCCBnKOsv0VX61Udq1vOgx1fyZP47DvoPPDv/xk402YgeUvWmx1ROqbOK0l6xStG92WKJFOWkqAR9sJC9LZain4ogrixvIsB1F17mPVSS1XtNXOwnlGVP0F/UhOgCaMjhPvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714404035; c=relaxed/simple;
	bh=PKPAWpRk72Gmqc3xXY6xgd8eKht2/V+7i35EFFUDGpM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i++10RNHdPLSxAKV59Brjr6YQ3wsOPwNTgSnAOHG6zk/D5Y/t6Z7uMnTYCErpN/Rk8k5Q67zBjBp70G0p3yBK3HCY3e1BTg4IVj5Zm7ZzKTjBQrRWUz8bPu01pTxSRnrzMukEXUCRU5S3qBIJu1Ns4KYrChGmEvy8tsg+MhWc/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=zpGPjFtn; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="zpGPjFtn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=A9ktU0Nf4obPdWQwapwO4Fue1aOYnmHa/ofJdgBDRUs=; b=zpGPjFtnZ6GaKQKZXq10ucwhLa
	VtWqH5hnkxprC+3k6fB9xaso9eMcly2wLESyp0c3jeqr+FDBkGrf4KA826rEe5bgeeAWyHm/1bCaV
	c3Dbuc9KRF9o6QxxdqZGbz1oxJ5h5iG9JqJT2iHL662kdkfqfQ4qf9LQgZrKaIc5+yGQvMnpXnBnY
	lx02FXgcCQH0zOCSIFLs0k5MA5RaTZyLkG9Q/9n2WpVTHbHtFMM+ZhWZQzMkUpTvetstaVzQOQFZT
	8ravFC28+1TzSrjmri3stsdv6t6nOoVdbvqrCJ6b0WyDVkNLfnsXCBsNhBoFCeQ0uZRdhhMlQ7jLX
	3UE51s8mvFl1xn4CA23bNBN1eYeyhUdME1u3Gymq/elQsggrCstgeG3vX8B8bH1r/HuaBhtaXSbSp
	chjmGOmRHh0BR7+z3IwE9VswiihPuEgnJ8bmZIk5bUY2mx3GUM4NZNhz9hB7CYFlZqLQK1lrDiXFv
	qmpIWBbP36Ms89qytcWuukrU;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1s1Snn-008ww2-0f;
	Mon, 29 Apr 2024 15:20:23 +0000
Message-ID: <2365b657-bea4-4527-9fce-ad11c690bde3@samba.org>
Date: Mon, 29 Apr 2024 17:20:22 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH net-next 0/5] net: In-kernel QUIC implementation with
 Userspace handshake
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, davem@davemloft.net,
 kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Steve French <smfrench@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>, Chuck Lever III
 <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>,
 Sabrina Dubroca <sd@queasysnail.net>, Tyler Fanelli <tfanelli@redhat.com>,
 Pengtao He <hepengtao@xiaomi.com>,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
 Samba Technical <samba-technical@lists.samba.org>
References: <cover.1710173427.git.lucien.xin@gmail.com>
 <74d5db09-6b5c-4054-b9d3-542f34769083@samba.org>
 <CADvbK_dzVcDKsJ9RN9oc0K1Jwd+kYjxgE6q=ioRbVGhJx7Qznw@mail.gmail.com>
 <f427b422-6cfc-45ac-88eb-3e7694168b63@samba.org>
 <CADvbK_cA-RCLiUUWkyNsS=4OhkWrUWb68QLg28yO2=8PqNuGBQ@mail.gmail.com>
 <438496a6-7f90-403d-9558-4a813e842540@samba.org>
 <CADvbK_fkbOnhKL+Rb+pp+NF+VzppOQ68c=nk_6MSNjM_dxpCoQ@mail.gmail.com>
 <1456b69c-4ffd-4a08-b120-6a00abf1eb05@samba.org>
 <CADvbK_cQRpyzHG4UUOzfgmqLndvpx5Cd+d59rrqGRp0ic3PyxA@mail.gmail.com>
 <95922a2f-07a1-4555-acd2-c745e59bcb8e@samba.org>
 <CADvbK_eR4++HbR_RncjV9N__M-uTHtmqcC+_Of1RKVw7Uqf9Cw@mail.gmail.com>
 <CADvbK_dEWNNA_i1maRk4cmAB_uk4G4x0eZfZbrVX=zJ+2H9o_A@mail.gmail.com>
 <dc3815af-5b46-452b-8bcc-30a0934740a2@samba.org>
 <CADvbK_e__qpCa44uF+J2Z+2Lhb2suktTNT+CeQayk_uhckVYqQ@mail.gmail.com>
Content-Language: en-US, de-DE
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CADvbK_e__qpCa44uF+J2Z+2Lhb2suktTNT+CeQayk_uhckVYqQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Xin Long,

>>
> Just confirmed from other ebpf experts, there are no in-kernel interfaces
> for loading and interacting with BPF maps/programs(other than from BPF itself).
> 
> It seems that we have to do this match in QUIC stack. In the latest QUIC
> code, I added quic_packet_get_alpn(), a 59-line function, to parse ALPNs
> and then it will search for the listen sock with these ALPNs in
> quic_sock_lookup().
> 
> I introduced 'alpn_match' module param, and it can be enabled when loading
> the module QUIC by:
> 
>    # modprobe quic alpn_match=1
> 
> You can test it by tests/sample_test in the latest code:
> 
>    Start 3 servers:
> 
>      # ./sample_test server 0.0.0.0 1234 \
>          ./keys/server-key.pem ./keys/server-cert.pem smbd
>      # ./sample_test server 0.0.0.0 1234 \
>          ./keys/server-key.pem ./keys/server-cert.pem h3
>      # ./sample_test server 0.0.0.0 1234 \
>          ./keys/server-key.pem ./keys/server-cert.pem ksmbd
> 
>    Try to connect on clients with:
> 
>      # ./sample_test client 127.0.0.1 1234 ksmbd
>      # ./sample_test client 127.0.0.1 1234 smbd
>      # ./sample_test client 127.0.0.1 1234 h3
> 
>    to see if the corresponding server responds.
> 
> There might be some concerns but it's also a useful feature that can not
> be implemented in userland QUICs. The commit is here:
> 
> https://github.com/lxin/quic/commit/de82f8135f4e9196b503b4ab5b359d88f2b2097f
> 
> Please check if this is enough for SMB applications.

It look great thanks!

> Note as a listen socket is now identified by [address + port + ALPN] when
> alpn_match=1, this feature does NOT require SO_REUSEPORT socket option to
> be set, unless one wants multiple sockets to listen to
> the same [address + port + ALPN].

I'd argue that this should be the default and be required before listen()
or maybe before bind(), so that it can return EADDRINUSE. As EADDRINUSE should only
happen for servers it might be useful to have a QUIC_SOCKOPT_LISTEN_ALPN instead of
QUIC_SOCKOPT_ALPN. As QUIC_SOCKOPT_ALPN on a client socket should not generate let
bind() care about the alpn value at all.

For listens on tcp you also need to specify an explicit port (at least in order
to be useful).

And it would mean that all application would use it and not block other applications
from using an explicit alpn.

Also an module parameter for this means the administrator would have to take care
of it, which means it might be unuseable if loaded with it.

I hope to find some time in the next weeks to play with this.
Should be relatively trivial create a prototype for samba's smbd.

Thanks!
metze
