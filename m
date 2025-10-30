Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B10230BF6;
	Thu, 30 Oct 2025 14:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761833862; cv=none; b=kjscqqu3Ks+92ONn2dtWx0K6HAfm7eFJSNo8fDEpBZWg5GU51K7kHvI1TqMKvptKcSTcpinjdtd6Yb4bSvOhuUjTBSjCCZsyU2cwdQ/5SxW6YqWuPeMhR+14DoGi+PD9KsopPTyLJSv0tlAQu8Xx6jRvRcJrmDEHXdKMha619MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761833862; c=relaxed/simple;
	bh=R+GvhhLFU19b10Tdq5kIw32BFllSPYd5lwWkrl9YrIQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nr+xdxLXOCylDzJutXnusz9c8HGb/MWzgBvoyDza3FBP9yt6DbsBQVdeBIMptbkwYqoQxL7icyGJ01nXuMvTWlTbmFCTofWYWd6qiYg8QtW/d5YepAF0FTK7HvapG5s2HPwQq2bUCCOXQEpGwc/6bOSekt/0H615QTNgLb3+jGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=tN5zEl3R; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="tN5zEl3R"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=GOFQjZMXDAf0a1O7jmFyB/fr+4q45QtkkWjti6G0Zs4=; b=tN5zEl3RtFms7dgEhKUlTBgDbp
	qRgwbPBbk0g+xRo6kFJYbcIX/CJMexWmfPflwbLal/R05l4jUh2PmV3sNuZ0gwuYR8+vG8Ai8Mrjn
	O92KABbjJFFnYfC+6B0YMEBCp+HcYlKasbYw/jOOENfdmZL+lEhke0Dch/6zeqXS3YfSeO31SPHAT
	4bNzBfnDgPYGXQIBXh8auPdIkYZiwIdXNfV5ZhE5SjAFXrBEq2r6StssE25PuC2WW6MiOOS2xETGD
	f1MnhlWFurIqDM31ona061jQgD0+LjkyeuD+iFm43I4VJaQrt51YjfxyMjowllbaFf/R8dYFaqDQI
	GjXvbIB31r6nHloizCOR4AUorZbKK785K/ExcSYnaXM3wNnV4fclMcWghyE77+e5qFMSx3fjiqZSX
	cqsNLRVcImKcaxJvnONn46eYPIzlwY0S0i0/cDoODFxu/5RgzR7VwaUn8KBaGGXuJxUGOyi5co/9Q
	nFb4pfO9WXzV7Oi8S7H0Jxcc;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vETT4-00BrJD-3C;
	Thu, 30 Oct 2025 14:17:35 +0000
Message-ID: <0b65e74c-71bb-494d-9b05-0ee20f27e840@samba.org>
Date: Thu, 30 Oct 2025 15:17:33 +0100
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v4 02/15] net: build socket infrastructure for
 QUIC protocol
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev,
 davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>,
 Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz <dreibh@simula.no>,
 linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>, Paulo Alcantara <pc@manguebit.com>,
 Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev,
 Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>,
 Benjamin Coddington <bcodding@redhat.com>, Steve Dickson
 <steved@redhat.com>, Hannes Reinecke <hare@suse.de>,
 Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>,
 Matthieu Baerts <matttbe@kernel.org>, John Ericson <mail@johnericson.me>,
 Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe"
 <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>,
 illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Daniel Stenberg <daniel@haxx.se>,
 Andy Gospodarek <andrew.gospodarek@broadcom.com>
References: <cover.1761748557.git.lucien.xin@gmail.com>
 <91ff36185099cd97626a7a8782d756cf3e963c82.1761748557.git.lucien.xin@gmail.com>
 <67b38b36-b6fa-4cab-b14f-8ba271f02065@samba.org>
 <CADvbK_f4rN-7bvvwWDVm-B+h6QiSwQbK7EKsWh5kTuHJjuGjTA@mail.gmail.com>
 <b9300291-e828-47fa-b4d1-66934636bd7b@samba.org>
 <CADvbK_f=E11=dszeJos98RvBY5POXujgT0dFo-LG6QQuGW20Kg@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CADvbK_f=E11=dszeJos98RvBY5POXujgT0dFo-LG6QQuGW20Kg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 30.10.25 um 15:13 schrieb Xin Long:
> On Thu, Oct 30, 2025 at 7:29 AM Stefan Metzmacher <metze@samba.org> wrote:
>>
>> Am 29.10.25 um 20:57 schrieb Xin Long:
>>> On Wed, Oct 29, 2025 at 12:22 PM Stefan Metzmacher <metze@samba.org> wrote:
>>>>
>>>> Hi Xin,
>>>>
>>>>> This patch lays the groundwork for QUIC socket support in the kernel.
>>>>> It defines the core structures and protocol hooks needed to create
>>>>> QUIC sockets, without implementing any protocol behavior at this stage.
>>>>>
>>>>> Basic integration is included to allow building the module via
>>>>> CONFIG_IP_QUIC=m.
>>>>>
>>>>> This provides the scaffolding necessary for adding actual QUIC socket
>>>>> behavior in follow-up patches.
>>>>>
>>>>> Signed-off-by: Pengtao He <hepengtao@xiaomi.com>
>>>>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
>>>>
>>>> ...
>>>>
>>>>> +module_init(quic_init);
>>>>> +module_exit(quic_exit);
>>>>> +
>>>>> +MODULE_ALIAS("net-pf-" __stringify(PF_INET) "-proto-261");
>>>>> +MODULE_ALIAS("net-pf-" __stringify(PF_INET6) "-proto-261");
>>>>
>>>> Shouldn't this use MODULE_ALIAS_NET_PF_PROTO(PF_INET, IPPROTO_QUIC)
>>>> instead?
>>>>
>>> Hi, Stefan,
>>>
>>> If we switch to using MODULE_ALIAS_NET_PF_PROTO(), we still need to
>>> keep using the numeric value 261:
>>>
>>>     MODULE_ALIAS_NET_PF_PROTO(PF_INET, 261);
>>>     MODULE_ALIAS_NET_PF_PROTO(PF_INET6, 261);
>>>
>>> IPPROTO_QUIC is defined as an enum, not a macro. Since
>>> MODULE_ALIAS_NET_PF_PROTO() relies on __stringify(proto), it can’t
>>> stringify enum values correctly, and it would generate:
>>>
>>>     alias:          net-pf-10-proto-IPPROTO_QUIC
>>>     alias:          net-pf-2-proto-IPPROTO_QUIC
>>
>> Yes, now I remember...
>>
>> Maybe we can use something like this:
>>
>> -  IPPROTO_QUIC = 261,          /* A UDP-Based Multiplexed and Secure Transport */
>> +#define __IPPROTO_QUIC 261     /* A UDP-Based Multiplexed and Secure Transport */
>> +  IPPROTO_QUIC = __IPPROTO_QUIC,
>>
>> and then
>>
>> MODULE_ALIAS_NET_PF_PROTO(PF_INET, __IPPROTO_QUIC)
>>
>> In order to make things clearer.
>>
>> What do you think?
>>
> That might be a good idea to make things clearer later on.
> 
> But for now, I’d prefer not to add something special just for QUIC in
> include/uapi/linux/in.h.  We can revisit it later together with SCTP,
> L2TP, and SMC to keep things consistent.

Ok, maybe this would do it for now?

MODULE_ALIAS_NET_PF_PROTO(PF_INET, 261); /* IPPROTO_QUIC == 261 */

I'll do the same for IPPROTO_SMBDIRECT...

metze
