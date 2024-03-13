Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8C71B277;
	Wed, 13 Mar 2024 08:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710320218; cv=none; b=oH/LoX5OTY6uutQLSSCUjkvZ+AfMgohdFmOgp1CNr8gCbBTakbI7dKm1PvOJncN8mgN2gIVu5JEBDeIAMO9KaNgKDfE2Ce09N1AfOaGFdbjCbdP+BiPs1BxO9eyLgrIBCKoPgBDKeNb6vLq/plTSdNtzb8Tgu1RWgDBJNIFSYk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710320218; c=relaxed/simple;
	bh=f0YlFyPkHWlvhTBYP+sm+BbkzPsVZQaFGDLAO92H5n4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VGHF/76VmSaxS5GvqSD0nvu+pG4sF8OSAPO18OGk4uUcGyagjVb+/38ec3WINdbhTAfMEz3k9soauD6DgU0uVTwQ2+VBdVCJE7UmIhVsAGa+ASt1EduDrwvbI3KDKKWDYmnzlXzAi8GVQ8O2ATzF87kNAAUZZ1R4KQrLzVE+v8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=PrIwJ+KC; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="PrIwJ+KC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=xATN+fNLVBW0nteqrTdPZMmMoa9Qs0vDSOCiZfaH0lg=; b=PrIwJ+KCxV6PSDaxTUgT33tXBI
	VrFziHv26mOylNEZR+pli8jUbx0FO8s8je8jIcW4sMj3AL0CyOD1T9GnV2G5l9/OVZ2dbVWNIpWnj
	wAL98punqFnsGrTMDZLbhmmPHIVP4g0Gn9CZtOyOKX6OMYQF+fFD1Owv2NkiBdiJjPLCjxQHShWSM
	cZPtCc/6qIaYkfccOXpvY6O8CC38Tc63E+9WF0pIzk5q3ouRu3vOZTWpxkjfYGlENxygtS8K0fGF8
	exdgMuDYhDm1TZQaNh2GQG2SN6QXNIb0AmVZY/kfFm9kk+Ei0FAqNjTkzcBrRJLtDtZEg2u9g5MwY
	o3t/sWAQVkgH9sgN/UFoDxTjCqADtRbqE00Uo0MJPH4WleVXAtKLvobTxUhednqiSFZZX4TikZIFE
	Dk8ZmWGBytateOQaH7csYP55mHfBjLj04wiknvGf2k7Ujtgycht7YI2ke6Lf9TkXbRkqv4pKvt5qi
	pIJcbk84ByAHzbr0J6v6XY5d;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1rkKPl-000dql-00;
	Wed, 13 Mar 2024 08:56:45 +0000
Message-ID: <74d5db09-6b5c-4054-b9d3-542f34769083@samba.org>
Date: Wed, 13 Mar 2024 09:56:41 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH net-next 0/5] net: In-kernel QUIC implementation with
 Userspace handshake
To: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>
Cc: davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Steve French <smfrench@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>, Chuck Lever III
 <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>,
 Sabrina Dubroca <sd@queasysnail.net>, Tyler Fanelli <tfanelli@redhat.com>,
 Pengtao He <hepengtao@xiaomi.com>,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
 Samba Technical <samba-technical@lists.samba.org>
References: <cover.1710173427.git.lucien.xin@gmail.com>
Content-Language: en-US, de-DE
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <cover.1710173427.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Xin Long,

first many thanks for working on this topic!

> Usage
> =====
> 
> This implementation supports a mapping of QUIC into sockets APIs. Similar
> to TCP and SCTP, a typical Server and Client use the following system call
> sequence to communicate:
> 
>         Client                    Server
>      ------------------------------------------------------------------
>      sockfd = socket(IPPROTO_QUIC)      listenfd = socket(IPPROTO_QUIC)
>      bind(sockfd)                       bind(listenfd)
>                                         listen(listenfd)
>      connect(sockfd)
>      quic_client_handshake(sockfd)
>                                         sockfd = accecpt(listenfd)
>                                         quic_server_handshake(sockfd, cert)
> 
>      sendmsg(sockfd)                    recvmsg(sockfd)
>      close(sockfd)                      close(sockfd)
>                                         close(listenfd)
> 
> Please note that quic_client_handshake() and quic_server_handshake() functions
> are currently sourced from libquic in the github lxin/quic repository, and might
> be integrated into ktls-utils in the future. These functions are responsible for
> receiving and processing the raw TLS handshake messages until the completion of
> the handshake process.

I see a problem with this design for the server, as one reason to
have SMB over QUIC is to use udp port 443 in order to get through
firewalls. As QUIC has the concept of ALPN it should be possible
let a conumer only listen on a specif ALPN, so that the smb server
and web server on "h3" could both accept connections.

So the server application should have a way to specify the desired
ALPN before or during the bind() call. I'm not sure if the
ALPN is available in cleartext before any crypto is needed,
so if the ALPN is encrypted it might be needed to also register
a server certificate and key together with the ALPN.
Because multiple application may not want to share the same key.

This needs to work indepented of kernel or userspace application.

We may want ksmbd (kernel smb server) and apache or smbd (Samba's userspace smb server)
together with apache. And maybe event ksmbd with one certificate for
ksmbd.example.com and smbd with a certificate for smbd.example.com
both on ALPN "smb", while apache uses "h3" with a certificate for
apache.example.com and nginx with "h3" and a certificate for
nginx.example.com.

But also smbd with "smb" as well as apache with "h3" both using
a certificate for quic.example.com.

I guess TLS Server Name Indication also works for QUIC, correct?

For the client side I guess dynamic udp ports are used and
there's no problem with multiple applications...

metze
