Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE96912D1E8;
	Fri, 19 Apr 2024 14:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713535683; cv=none; b=Ar5ysudYtni1y/d8McRkASClXMOpT9bUJ1nAa7itC04XDZEV/I8IMQ2H0Y0SY8vI+3BqAXOfFjZbJg+OT56iymdUT5Z/Qjq8BqnmMgzqIW8eG54Z/gm6xFynZF7wIjpLEzHJz4xEqIHAcJN2CmhlGjE/weatiZ6jKACNLbaUYoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713535683; c=relaxed/simple;
	bh=XB1NbjTeqeLEZXFch9O0h0mxeBwFTtHIXYC6eK7awDU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nAHOjZbILkZKdtnALZ/1W0C1N5fezWz+wxS1UCU+PvgBvN/WfnvN/WNQQsipcmyQuFCGniAqIoy85NEokX8RkGb7D4gMYxfyyGG7UN/PqfnD31KzwFZlFxXgd9t20+Nhokda5ciacFO2pRqFrrAXBrwonemzAKHx03yahbTHch0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=YMZqx1Fo; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="YMZqx1Fo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=grps+hyJYghqEXjJl9/6rpNw9fYgIgcNBX8UbDtQZxQ=; b=YMZqx1FoEEZDkv/+nWLSfYOhY6
	QBmF93bWpNheUW02oFPoQFukhxeOTp8eyxziLdlVZTawlnaqtyIrGEu6knGDYFUZdyGytiguxlU1F
	BPvSyUt665vmfBThp6rDCUguW8WEqf1vy9b7D4YryWmfJFIpBDzXhGK6W2RwkaeMG67gJVDoY37B9
	kBGb31LgaqhzZUmLBv+GJCItq0ju74AwLb2vx96E+/6KRkw0fGMrAVRW6CoT4CrH8B3wkYfO5QY19
	jv1cARcLZuvnwLBGBeCERW9cyCnBzwM0KXp151dgoEswui4IddfmGGnyo2Y9ncssPcY+2SrpNP09x
	3st38ZJsWz2Jic9b+EoMHn9lezoi/vMfUapg71panqUyIR7WsQnSiH6zDQQLCplMUbmjM3cQRCg6I
	Six7gE3UJ4BE9BzNdAe8+zIMsfKL8onTxMkiPzSglnfc+wb/d5hR31GWs+De1FIhRnjs2m7e0GzIs
	Q7RzrP3JTWhQ8tfWLAwjCWoD;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1rxou7-007Gf8-2B;
	Fri, 19 Apr 2024 14:07:52 +0000
Message-ID: <1456b69c-4ffd-4a08-b120-6a00abf1eb05@samba.org>
Date: Fri, 19 Apr 2024 16:07:50 +0200
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
Content-Language: en-US, de-DE
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CADvbK_fkbOnhKL+Rb+pp+NF+VzppOQ68c=nk_6MSNjM_dxpCoQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Xin Long,

>>>>>> first many thanks for working on this topic!
>>>>>>
>>>>> Hi, Stefan
>>>>>
>>>>> Thanks for the comment!
>>>>>
>>>>>>> Usage
>>>>>>> =====
>>>>>>>
>>>>>>> This implementation supports a mapping of QUIC into sockets APIs. Similar
>>>>>>> to TCP and SCTP, a typical Server and Client use the following system call
>>>>>>> sequence to communicate:
>>>>>>>
>>>>>>>            Client                    Server
>>>>>>>         ------------------------------------------------------------------
>>>>>>>         sockfd = socket(IPPROTO_QUIC)      listenfd = socket(IPPROTO_QUIC)
>>>>>>>         bind(sockfd)                       bind(listenfd)
>>>>>>>                                            listen(listenfd)
>>>>>>>         connect(sockfd)
>>>>>>>         quic_client_handshake(sockfd)
>>>>>>>                                            sockfd = accecpt(listenfd)
>>>>>>>                                            quic_server_handshake(sockfd, cert)
>>>>>>>
>>>>>>>         sendmsg(sockfd)                    recvmsg(sockfd)
>>>>>>>         close(sockfd)                      close(sockfd)
>>>>>>>                                            close(listenfd)
>>>>>>>
>>>>>>> Please note that quic_client_handshake() and quic_server_handshake() functions
>>>>>>> are currently sourced from libquic in the github lxin/quic repository, and might
>>>>>>> be integrated into ktls-utils in the future. These functions are responsible for
>>>>>>> receiving and processing the raw TLS handshake messages until the completion of
>>>>>>> the handshake process.
>>>>>>
>>>>>> I see a problem with this design for the server, as one reason to
>>>>>> have SMB over QUIC is to use udp port 443 in order to get through
>>>>>> firewalls. As QUIC has the concept of ALPN it should be possible
>>>>>> let a conumer only listen on a specif ALPN, so that the smb server
>>>>>> and web server on "h3" could both accept connections.
>>>>> We do provide a sockopt to set ALPN before bind or handshaking:
>>>>>
>>>>>      https://github.com/lxin/quic/wiki/man#quic_sockopt_alpn
>>>>>
>>>>> But it's used more like to verify if the ALPN set on the server
>>>>> matches the one received from the client, instead of to find
>>>>> the correct server.
>>>>
>>>> Ah, ok.
>>> Just note that, with a bit change in the current libquic, it still
>>> allows users to use ALPN to find the correct function or thread in
>>> the *same* process, usage be like:
>>>
>>> listenfd = socket(IPPROTO_QUIC);
>>> /* match all during handshake with wildcard ALPN */
>>> setsockopt(listenfd, QUIC_SOCKOPT_ALPN, "*");
>>> bind(listenfd)
>>> listen(listenfd)
>>>
>>> while (1) {
>>>     sockfd = accept(listenfd);
>>>     /* the alpn from client will be set to sockfd during handshake */
>>>     quic_server_handshake(sockfd, cert);
>>>
>>>     getsockopt(sockfd, QUIC_SOCKOPT_ALPN, alpn);
>>
>> Would quic_server_handshake() call setsockopt()?
> Yes, I just made a bit change in the userspace libquic:
> 
>    https://github.com/lxin/quic/commit/9c75bd42769a8cbc1652e2f4c8d77780f23afde6
> 
> So you can set up multple ALPNs on listen sock:
> 
>    setsockopt(listenfd, QUIC_SOCKOPT_ALPN, "smbd, h3, ksmbd");
> 
> Then during handshake, the matched ALPN from client will be set into
> the accept socket, then users can get it later after handshake.
> 
> Note that userspace libquic is a very light lib (a couple of hundred lines
> of code), you can add more TLS related support without touching Kernel code,
> including the SNI support you mentioned.
> 
>>
>>>     switch (alpn) {
>>>       case "smbd": smbd_thread(sockfd);
>>>       case "h3": h3_thread(sockfd);
>>>       case "ksmbd": ksmbd_thread(sockfd);
>>>     }
>>> }
>>
>> Ok, but that would mean all application need to be aware of each other,
>> but it would be possible and socket fds could be passed to other
>> processes.
> It doesn't sound common to me, but yes, I think Unix Domain Sockets
> can pass it to another process.

I think it will be extremely common to have multiple services
based on udp port 443.

People will expect to find web services, smb and maybe more
behind the same dnshost name. And multiple dnshostnames pointing
to the same ip address is also very likely.

With plain tcp/udp it's also possible to independent sockets
per port. There's no single userspace daemon that listens on
'tcp' and will dispatch into different process base on the port.

And with QUIC the port space is the ALPN and/or SNI
combination.

And I think this should be addressed before this becomes an
unchangeable kernel ABI, written is stone.

>>>>> So you expect (k)smbd server and web server both to listen on UDP
>>>>> port 443 on the same host, and which APP server accepts the request
>>>>> from a client depends on ALPN, right?
>>>>
>>>> yes.
>>> Got you. This can be done by also moving TLS 1.3 message exchange to
>>> kernel where we can get the ALPN before looking up the listening socket.
>>> However, In-kernel TLS 1.3 Handshake had been NACKed by both kernel
>>> netdev maintainers and userland ssl lib developers with good reasons.
>>>
>>>>
>>>>> Currently, in Kernel, this implementation doesn't process any raw TLS
>>>>> MSG/EXTs but deliver them to userspace after decryption, and the accept
>>>>> socket is created before processing handshake.
>>>>>
>>>>> I'm actually curious how userland QUIC handles this, considering
>>>>> that the UDP sockets('listening' on the same IP:PORT) are used in
>>>>> two different servers' processes. I think socket lookup with ALPN
>>>>> has to be done in Kernel Space. Do you know any userland QUIC
>>>>> implementation for this?
>>>>
>>>> I don't now, but I guess QUIC is only used for http so
>>>> far and maybe dns, but that seems to use port 853.
>>>>
>>>> So there's no strict need for it and the web server
>>>> would handle all relevant ALPNs.
>>> Honestly, I don't think any userland QUIC can use ALPN to lookup for
>>> different sockets used by different servers/processes. As such thing
>>> can be only done in Kernel Space.
>>>
>>>>
>>>>>>
>>>>>> So the server application should have a way to specify the desired
>>>>>> ALPN before or during the bind() call. I'm not sure if the
>>>>>> ALPN is available in cleartext before any crypto is needed,
>>>>>> so if the ALPN is encrypted it might be needed to also register
>>>>>> a server certificate and key together with the ALPN.
>>>>>> Because multiple application may not want to share the same key.
>>>>> On send side, ALPN extension is in raw TLS messages created in userspace
>>>>> and passed into the kernel and encoded into QUIC crypto frame and then
>>>>> *encrypted* before sending out.
>>>>
>>>> Ok.
>>>>
>>>>> On recv side, after decryption, the raw TLS messages are decoded from
>>>>> the QUIC crypto frame and then delivered to userspace, so in userspace
>>>>> it processes certificate validation and also see cleartext ALPN.
>>>>>
>>>>> Let me know if I don't make it clear.
>>>>
>>>> But the first "new" QUIC pdu from will trigger the accept() to
>>>> return and userspace (or the kernel helper function) will to
>>>> all crypto? Or does the first decryption happen in kernel (before accept returns)?
>>> Good question!
>>>
>>> The first "new" QUIC pdu will cause to create a 'request sock' (contains
>>> 4-tuple and connection IDs only) and queue up to reqsk list of the listen
>>> sock (if validate_peer_address param is not set), and this pdu is enqueued
>>> in the inq->backlog_list of the listen sock.
>>>
>>> When accept() is called, in Kernel, it dequeues the "request sock" from the
>>> reqsk list of the listen sock, and creates the accept socket based on this
>>> reqsk. Then it processes the pdu for this new accept socket from the
>>> inq->backlog_list of the listen sock, including *decrypting* QUIC packet
>>> and decoding CRYPTO frame, then deliver the raw/cleartext TLS message to
>>> the Userspace libquic.
>>
>> Ok, when the kernel already decrypts it could already
>> look find the ALPN. It doesn't mean it should do the full
>> handshake, but parse enough to find the ALPN.
> Correct, in-kernel QUIC should only do the QUIC related things,
> and all TLS handshake msgs must be handled in Userspace.
> This won't cause "layering violation", as Nick Banks said.

But I think its unavoidable for the ALPN and SNI fields on
the server side. As every service tries to use udp port 443
and somehow that needs to be shared if multiple services want to
use it.

I guess on the acceptor side we would need to somehow detach low level
udp struct sock from the logical listen struct sock.

And quic_do_listen_rcv() would need to find the correct logical listening
socket and call quic_request_sock_enqueue() on the logical socket
not the lowlevel udo socket. The same for all stuff happening after
quic_request_sock_enqueue() at the end of quic_do_listen_rcv.

>> But I don't yet understand how the kernel gets the key to
>> do the initlal decryption, I'd assume some call before listen()
>> need to tell the kernel about the keys.
> For initlal decryption, the keys can be derived with the initial packet.
> basically, it only needs the dst_connection_id from the client initial
> packet. see:
> 
>    https://datatracker.ietf.org/doc/html/rfc9001#name-initial-secrets
> 
> so we don't need to set up anything to kernel for initial's keys.

I got it thanks!

metze

