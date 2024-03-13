Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF65626B2;
	Wed, 13 Mar 2024 17:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710350898; cv=none; b=J3bTpkI6Ufnb2bN+bRs4r5doyitRt1QQySGPwicmXmq1JePIl8P9LnM+8PvJ/PFlLzppgImX6yNne+yWO4AVVm2LLfaltyOYZh/ioXbrfwhu/fDyNQWnN5rcC4pLfVVUM4wgQK/zAwW5vWDmAp+n1jSsRyr5rGDA95JiZXACgoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710350898; c=relaxed/simple;
	bh=LV6VKRT5soJLrhgCPMpDOpyj6fJQRFbnlywftUZYw0w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qnpaE8pBWALQfreujlgQFcvghQb0+XmUxKZWGcLQtZbTiIv2ovuuQkPpcPFPPKKbmTJ82YYwhAYbU5uBCy8sqSfi0iMekyZgdp0p74ZyFslD/mWk9YiICfbd+2Dfkqrp4CCJJ4tgyXrC7q1t7DpQvXXcxhAFGXA48GM4RtdVq9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=tYH4Gbfc; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="tYH4Gbfc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=MA6F1oWervV4yTf9sdlRkmUY6JHezIhU/a2seVqV4Nw=; b=tYH4GbfcnX8vIOFaJujG/xZs3O
	/H02qGW95JLKQr81gqbjOMgSuxku9rOkREOwFPuwb6z47CR6XSaJXD81dIFYWFxZpKftfPCX6cq/m
	zmCfVWzN0zSMMS6yXE9DNFBNT452OIYODoZI6I416a5o02oukVi0I3ZZ8KtOhZM4qtQ2gcfRUD7QY
	/W92+LqdLBDfpIcGYHK8N7Uwx7d1rRkrw+DkdWk6mHDA2vh3XWfotzSUhUGPBzcf5JHTnrS2EGVBk
	kz0GP8LzFD6ryMSvEY10WcVVHLjFRUgmEz8XAcJKcvEQFhpIBIvoZckv8vmfEpwx/7vMl5CAGROvK
	xREV2zBpRYnmxBefpvLllEKM9eGx9MaiAqtEKfjkihNRsF2I75ruEmLt5w9aDF+PEokwW+JkwrJws
	Q3c0U87dxmVrBbkqRxDXL9ef3cFXO6In/rS93Srik3sHlgOPt3UzMYBX4J+VkWg3GSKHHr1SO9SI4
	zs45MTnCloPIma+S6pKqy5Pl;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1rkSOf-000ibz-1q;
	Wed, 13 Mar 2024 17:28:09 +0000
Message-ID: <f427b422-6cfc-45ac-88eb-3e7694168b63@samba.org>
Date: Wed, 13 Mar 2024 18:28:06 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH net-next 0/5] net: In-kernel QUIC implementation with
 Userspace handshake
Content-Language: en-US, de-DE
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
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CADvbK_dzVcDKsJ9RN9oc0K1Jwd+kYjxgE6q=ioRbVGhJx7Qznw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 13.03.24 um 17:03 schrieb Xin Long:
> On Wed, Mar 13, 2024 at 4:56 AM Stefan Metzmacher <metze@samba.org> wrote:
>>
>> Hi Xin Long,
>>
>> first many thanks for working on this topic!
>>
> Hi, Stefan
> 
> Thanks for the comment!
> 
>>> Usage
>>> =====
>>>
>>> This implementation supports a mapping of QUIC into sockets APIs. Similar
>>> to TCP and SCTP, a typical Server and Client use the following system call
>>> sequence to communicate:
>>>
>>>          Client                    Server
>>>       ------------------------------------------------------------------
>>>       sockfd = socket(IPPROTO_QUIC)      listenfd = socket(IPPROTO_QUIC)
>>>       bind(sockfd)                       bind(listenfd)
>>>                                          listen(listenfd)
>>>       connect(sockfd)
>>>       quic_client_handshake(sockfd)
>>>                                          sockfd = accecpt(listenfd)
>>>                                          quic_server_handshake(sockfd, cert)
>>>
>>>       sendmsg(sockfd)                    recvmsg(sockfd)
>>>       close(sockfd)                      close(sockfd)
>>>                                          close(listenfd)
>>>
>>> Please note that quic_client_handshake() and quic_server_handshake() functions
>>> are currently sourced from libquic in the github lxin/quic repository, and might
>>> be integrated into ktls-utils in the future. These functions are responsible for
>>> receiving and processing the raw TLS handshake messages until the completion of
>>> the handshake process.
>>
>> I see a problem with this design for the server, as one reason to
>> have SMB over QUIC is to use udp port 443 in order to get through
>> firewalls. As QUIC has the concept of ALPN it should be possible
>> let a conumer only listen on a specif ALPN, so that the smb server
>> and web server on "h3" could both accept connections.
> We do provide a sockopt to set ALPN before bind or handshaking:
> 
>    https://github.com/lxin/quic/wiki/man#quic_sockopt_alpn
> 
> But it's used more like to verify if the ALPN set on the server
> matches the one received from the client, instead of to find
> the correct server.

Ah, ok.

> So you expect (k)smbd server and web server both to listen on UDP
> port 443 on the same host, and which APP server accepts the request
> from a client depends on ALPN, right?

yes.

> Currently, in Kernel, this implementation doesn't process any raw TLS
> MSG/EXTs but deliver them to userspace after decryption, and the accept
> socket is created before processing handshake.
> 
> I'm actually curious how userland QUIC handles this, considering
> that the UDP sockets('listening' on the same IP:PORT) are used in
> two different servers' processes. I think socket lookup with ALPN
> has to be done in Kernel Space. Do you know any userland QUIC
> implementation for this?

I don't now, but I guess QUIC is only used for http so
far and maybe dns, but that seems to use port 853.

So there's no strict need for it and the web server
would handle all relevant ALPNs.

>>
>> So the server application should have a way to specify the desired
>> ALPN before or during the bind() call. I'm not sure if the
>> ALPN is available in cleartext before any crypto is needed,
>> so if the ALPN is encrypted it might be needed to also register
>> a server certificate and key together with the ALPN.
>> Because multiple application may not want to share the same key.
> On send side, ALPN extension is in raw TLS messages created in userspace
> and passed into the kernel and encoded into QUIC crypto frame and then
> *encrypted* before sending out.

Ok.

> On recv side, after decryption, the raw TLS messages are decoded from
> the QUIC crypto frame and then delivered to userspace, so in userspace
> it processes certificate validation and also see cleartext ALPN.
> 
> Let me know if I don't make it clear.

But the first "new" QUIC pdu from will trigger the accept() to
return and userspace (or the kernel helper function) will to
all crypto? Or does the first decryption happen in kernel (before accept returns)?

Maybe it would be possible to optionally have socket option to
register ALPNs with certificates so that tls_server_hello_x509()
could be called automatically before accept returns (even for
userspace consumers).

It may mean the tlshd protocol needs to be extended...

metze
