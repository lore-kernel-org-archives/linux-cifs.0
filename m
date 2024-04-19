Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15C28562E;
	Fri, 19 Apr 2024 18:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713552698; cv=none; b=uNPrWLp9QewA7u7Bmze+DHxpnJ2ZL+jvg9cS/tQ2WmtDc2wDhG2B7/VTOqLtJQI+P8MoU+OHqPVdnKjHw0AqRwLBQ0I1AaR6cI9NBU1ZnDVO69dVQ12K4FzZb6Ab2oLzFZrN28kvPKHDVuf5VbTZGUMlKjhQheG7KpoJ1NaeAU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713552698; c=relaxed/simple;
	bh=A3lVg1JfLpjASQyaw0uVc6r+gN6qmDyIxGL/8HkpcC0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O2GJiEx1+cJi2BLTzX5r0DeZYS3VitYB6G7LcQ7uTJnPUltEKlCVfgvWL7l9rpl88OukFUPa/IrDUAvK26EJxh0dkCC5FE00tD9U/IrGJdl1gBWEgtvb38Eo3Lpxxg65f1ESPkKcrfh2f1jtU3pPKoC1csO/5TLXFpxHo0qYGpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=hkHRmyCr; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="hkHRmyCr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=tl/VLQ/5yMD25OAHeaSWFERWgpOCQAbMx/26ApeSk1U=; b=hkHRmyCrrjJSybWSu88cRcys8a
	0FQuwQbfeyW/cXI0T4aPJtCx5MoQxEiPDBoa1EjsNLsKuGHiLch1A30yrqm6mJT5PxJQiCzeh9410
	DbeUyCGH/keP2HNgZ/rsZiprSEV9i/b0h1Qvq7WC2IzIjiJR1ipaIv8ZP1Us3bPgnSfp4o6yc2WIa
	pQSAA3PbgCSsZv6ExYjm/08qD6an9rKfbI29twZ+3jT8H38oXPP/i/WeN624vfxpCYwUZSC4mcZ8u
	+nt+m+KVDvDBITm6wxAJbGD4ODVtzXPvJGhqgdDYZxpRx9HPq3NRvXMGUoIdX+na5SFIiri7KHRyL
	1SSxFsfCHgaeTTsfbt23bbDu7zU/L8uqCh5hvWsdR/s7Jy5mc4t0yN3ScQursD9h4d2BrKBGoIUPK
	AogJR0tykns6l0O0H4TykKQOAsSkTjvSyuJxCYR4rbarjpWEuLGz6YKA7O/D0KBTVEA+XLrdeAdsb
	599BdI4W5TthaV1bigzDlD08;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1rxtKe-007IwV-05;
	Fri, 19 Apr 2024 18:51:32 +0000
Message-ID: <95922a2f-07a1-4555-acd2-c745e59bcb8e@samba.org>
Date: Fri, 19 Apr 2024 20:51:31 +0200
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
Content-Language: en-US, de-DE
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CADvbK_cQRpyzHG4UUOzfgmqLndvpx5Cd+d59rrqGRp0ic3PyxA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Xin Long,

>> But I think its unavoidable for the ALPN and SNI fields on
>> the server side. As every service tries to use udp port 443
>> and somehow that needs to be shared if multiple services want to
>> use it.
>>
>> I guess on the acceptor side we would need to somehow detach low level
>> udp struct sock from the logical listen struct sock.
>>
>> And quic_do_listen_rcv() would need to find the correct logical listening
>> socket and call quic_request_sock_enqueue() on the logical socket
>> not the lowlevel udo socket. The same for all stuff happening after
>> quic_request_sock_enqueue() at the end of quic_do_listen_rcv.
>>
> The implementation allows one low level UDP sock to serve for multiple
> QUIC socks.
> 
> Currently, if your 3 quic applications listen to the same address:port
> with SO_REUSEPORT socket option set, the incoming connection will choose
> one of your applications randomly with hash(client_addr+port) vi
> reuseport_select_sock() in quic_sock_lookup().
> 
> It should be easy to do a further match with ALPN between these 3 quic
> socks that listens to the same address:port to get the right quic sock,
> instead of that randomly choosing.

Ah, that sounds good.

> The problem is to parse the TLS Client_Hello message to get the ALPN in
> quic_sock_lookup(), which is not a proper thing to do in kernel, and
> might be rejected by networking maintainers, I need to check with them.

Is the reassembling of CRYPTO frames done in the kernel or
userspace? Can you point me to the place in the code?

If it's really impossible to do in C code maybe
registering a bpf function in order to allow a listener
to check the intial quic packet and decide if it wants to serve
that connection would be possible as last resort?

> Will you be able to work around this by using Unix Domain Sockets pass
> the sockfd to another process?

Not really. As that would strict coordination between a lot of
independent projects.

> (Note that we're assuming all your 3 applications are using in-kernel QUIC)

Sure, but I guess for servers using port 443 that the only long term option.
and I don't think it will be less performant than a userspace implementation.

Thanks!
metze

