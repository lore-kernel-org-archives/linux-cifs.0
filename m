Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F0621B5AA;
	Sun, 21 Apr 2024 19:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713727642; cv=none; b=BXHSgvFUcniEyqjy9PzwRqJF/9Sv/bDW43U+TGCI/hP668a2yDgOcSgKzI5O3svL3KGY8Y8LYsPwyUxyr4pnQB/9aILPEiqkA4WVVFfUct/qVT6W5igxKZuIBtLCnmgGBj/FJ//rSI6p3EKCMGfBRIe2mJ8meyZJFOzb0QFi+XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713727642; c=relaxed/simple;
	bh=GAiQliUylNkiqA3TIwITFNADrEWrsDeL0XHcKwxrq0I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B1EJHmnLzr2nNpncKl0Sbf/1XHmUw3rTFyE9yxrhGvOnxZ3TcU8RTg6+fWwRGyaG3wEuAm3k2tG+YNjygbiB5u1+ORfq+rYMEn5dbvKgmkkfwbunVvSkUZcm4DVm9Ltn+4bL7E21LrJqjsVffo81jlZFKEY17QoN4Novq02HHb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=KlLXaYox; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="KlLXaYox"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=Lg/qlzZwLKwph3NU6upqfUukKASnvxR4/ZL4TRGp+6o=; b=KlLXaYox3G9F3LYbGJTAvFrxGg
	xBJoadfHfmxcDezhW4BpYBGR9p1Qb6JEHoQIxKPiryqsFy40bGj/1+ul4zmMNygrx8+7/WyLi/JBD
	5RKN11OZOuP7U9XcPSm6QECnWitsinOgGtpNlT23eWSiVgMUNHoWKU/Lz4/WwRPbHj7bT52kXbVm+
	CCIlqihXQj8aYs6kHxczweFkySYWCJHf2ulA6uAt+lIxCUxUs2tK2q4pA+CLv84DuAfRMWO9rEzMi
	foTRb8LxGRFlLehgPvn4Me9vFdwxubEH/H+hCigRqvmTJHxhcQxcJVf2OWAOqYeGajSrO2ba8TYVE
	1/tfZOcvUIxQHWw/YQGRGJti+sOmmz0xywWxsN09stps18tplAPS6n1ivyB4g/mIvA21TwA4Jx9kn
	ZtgWaxNLiXJpTNL39KQbZSBTWiB761oZPvJDpK7+dBTWovqunkfet048tPa9BIUUmgwwMCjtwBNFp
	RU5HH1kgeIfKdpDr5zv7p1nu;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1rycqC-007aLj-0t;
	Sun, 21 Apr 2024 19:27:08 +0000
Message-ID: <dc3815af-5b46-452b-8bcc-30a0934740a2@samba.org>
Date: Sun, 21 Apr 2024 21:27:07 +0200
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
Content-Language: en-US, de-DE
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CADvbK_dEWNNA_i1maRk4cmAB_uk4G4x0eZfZbrVX=zJ+2H9o_A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 20.04.24 um 21:32 schrieb Xin Long:
> On Fri, Apr 19, 2024 at 3:19 PM Xin Long <lucien.xin@gmail.com> wrote:
>>
>> On Fri, Apr 19, 2024 at 2:51 PM Stefan Metzmacher <metze@samba.org> wrote:
>>>
>>> Hi Xin Long,
>>>
>>>>> But I think its unavoidable for the ALPN and SNI fields on
>>>>> the server side. As every service tries to use udp port 443
>>>>> and somehow that needs to be shared if multiple services want to
>>>>> use it.
>>>>>
>>>>> I guess on the acceptor side we would need to somehow detach low level
>>>>> udp struct sock from the logical listen struct sock.
>>>>>
>>>>> And quic_do_listen_rcv() would need to find the correct logical listening
>>>>> socket and call quic_request_sock_enqueue() on the logical socket
>>>>> not the lowlevel udo socket. The same for all stuff happening after
>>>>> quic_request_sock_enqueue() at the end of quic_do_listen_rcv.
>>>>>
>>>> The implementation allows one low level UDP sock to serve for multiple
>>>> QUIC socks.
>>>>
>>>> Currently, if your 3 quic applications listen to the same address:port
>>>> with SO_REUSEPORT socket option set, the incoming connection will choose
>>>> one of your applications randomly with hash(client_addr+port) vi
>>>> reuseport_select_sock() in quic_sock_lookup().
>>>>
>>>> It should be easy to do a further match with ALPN between these 3 quic
>>>> socks that listens to the same address:port to get the right quic sock,
>>>> instead of that randomly choosing.
>>>
>>> Ah, that sounds good.
>>>
>>>> The problem is to parse the TLS Client_Hello message to get the ALPN in
>>>> quic_sock_lookup(), which is not a proper thing to do in kernel, and
>>>> might be rejected by networking maintainers, I need to check with them.
>>>
>>> Is the reassembling of CRYPTO frames done in the kernel or
>>> userspace? Can you point me to the place in the code?
>> In quic_inq_handshake_tail() in kernel, for Client Initial packet
>> is processed when calling accept(), this is the path:
>>
>> quic_accept()-> quic_accept_sock_init() -> quic_packet_process() ->
>> quic_packet_handshake_process() -> quic_frame_process() ->
>> quic_frame_crypto_process() -> quic_inq_handshake_tail().
>>
>> Note that it's with the accept sock, not the listen sock.
>>
>>>
>>> If it's really impossible to do in C code maybe
>>> registering a bpf function in order to allow a listener
>>> to check the intial quic packet and decide if it wants to serve
>>> that connection would be possible as last resort?
>> That's a smart idea! man.
>> I think the bpf hook in reuseport_select_sock() is meant to do such
>> selection.
>>
>> For the Client initial packet (the only packet you need to handle),
>> I double you will need to do the reassembling, as Client Hello TLS message
>> is always less than 400 byte in my env.
>>
>> But I think you need to do the decryption for the Client initial packet
>> before decoding it then parsing the TLS message from its crypto frame.
> I created this patch:
> 
> https://github.com/lxin/quic/commit/aee0b7c77df3f39941f98bb901c73fdc560befb8
> 
> to do this decryption in quic_sock_look() before calling
> reuseport_select_sock(), so that it provides the bpf selector with
> a plain-text QUIC initial packet:
> 
> https://datatracker.ietf.org/doc/html/rfc9000#section-17.2.2
> 
> If it's complex for you to do the decryption for the initial packet in
> the bpf selector, I will apply this patch. Please let me know.

I guess in addition to quic_server_handshake(), which is called
after accept(), there should be quic_server_prepare_listen()
(and something similar for in kernel servers) that setup the reuseport
magic for the socket, so that it's not needed in every application.

It seems there is only a single ebpf program possible per
reuseport group, so there has to be just a single one.

But is it possible for in kernel servers to also register an epbf program?

metze
