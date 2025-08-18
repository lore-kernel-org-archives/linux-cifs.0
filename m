Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D4B246BA5;
	Mon, 18 Aug 2025 16:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755534026; cv=none; b=aEzOhFI+DcZ8YQ3F9zfsSv6EgZEpFL8lrY2u2KF0JGYcb1YYtTs5mHWVnPmJLaYOt5ILbuuAXrVH2G1mhMZEsmWliau0TljWdM/zxPQ0p277KJ6jQaHHJvA+wNfffg9VkZuSzhKnfQZ/fDCsbhQtOLbhk4Utv7ptHZzIJ/NBw8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755534026; c=relaxed/simple;
	bh=QLWmZq+QrIgDqwljTZwNxcT9DrQad9PEJBFvRzUvpNk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h9s+ZZdfJDMfMZvQGfNfuEzgVSUFQ7/S7cF5by3uKb7O0xI4aQ0h4AJRkb6Fjb7Yz+1LOc4iqmeD6btmd4yrJvqzQhttINw6ycqCk33Ej/TlaHpGuxWIjuSl4pHa2+WUgyP3b7cWfSSawZLzGwWdOVU32CHxUbcjJyt2tNwtcBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jgfxb95N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jgfxb95N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC24AC4CEEB;
	Mon, 18 Aug 2025 16:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755534025;
	bh=QLWmZq+QrIgDqwljTZwNxcT9DrQad9PEJBFvRzUvpNk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jgfxb95NOPyjjQ2R490OMS3U+vhxH7yrv/mbYF1ILlAm/PMMPiuDBfkB3IkYokCwa
	 qChtfxpDRiFawCGOMVjBmM5T6AkJeCbTz/9Z2HV+Uxb7q8VBB253WYM8oQp8yBMmb/
	 C5JgwWz2s2VHo4Ael7+rKGjpwvCP1DveZPlyTRGWj9GdYtvKJyzgpZs2aQbItEr/u0
	 WgH1nN77ndefBCBAltc//kVuyuEkX81kLVInBAUQhhwq1oZ/SFsjD73xI7WHbgNJ2B
	 Y3hiLiwG3/kuH+CRAvP/En8jfYKDqarB3hi5iB9wkEmA09l8mtr0XZJiIFuVhWi9w0
	 Lw7h1Mt83+OTQ==
Message-ID: <e4167710-3667-497b-b12e-096fd06217d9@kernel.org>
Date: Mon, 18 Aug 2025 18:20:13 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH net-next v2 01/15] net: define IPPROTO_QUIC and SOL_QUIC
 constants
Content-Language: en-GB, fr-BE
To: Stefan Metzmacher <metze@samba.org>, Xin Long <lucien.xin@gmail.com>,
 network dev <netdev@vger.kernel.org>
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
 <5d5ac074-1790-410e-acf9-0e559cb7eacb@samba.org>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 xsFNBFXj+ekBEADxVr99p2guPcqHFeI/JcFxls6KibzyZD5TQTyfuYlzEp7C7A9swoK5iCvf
 YBNdx5Xl74NLSgx6y/1NiMQGuKeu+2BmtnkiGxBNanfXcnl4L4Lzz+iXBvvbtCbynnnqDDqU
 c7SPFMpMesgpcu1xFt0F6bcxE+0ojRtSCZ5HDElKlHJNYtD1uwY4UYVGWUGCF/+cY1YLmtfb
 WdNb/SFo+Mp0HItfBC12qtDIXYvbfNUGVnA5jXeWMEyYhSNktLnpDL2gBUCsdbkov5VjiOX7
 CRTkX0UgNWRjyFZwThaZADEvAOo12M5uSBk7h07yJ97gqvBtcx45IsJwfUJE4hy8qZqsA62A
 nTRflBvp647IXAiCcwWsEgE5AXKwA3aL6dcpVR17JXJ6nwHHnslVi8WesiqzUI9sbO/hXeXw
 TDSB+YhErbNOxvHqCzZEnGAAFf6ges26fRVyuU119AzO40sjdLV0l6LE7GshddyazWZf0iac
 nEhX9NKxGnuhMu5SXmo2poIQttJuYAvTVUNwQVEx/0yY5xmiuyqvXa+XT7NKJkOZSiAPlNt6
 VffjgOP62S7M9wDShUghN3F7CPOrrRsOHWO/l6I/qJdUMW+MHSFYPfYiFXoLUZyPvNVCYSgs
 3oQaFhHapq1f345XBtfG3fOYp1K2wTXd4ThFraTLl8PHxCn4ywARAQABzSRNYXR0aGlldSBC
 YWVydHMgPG1hdHR0YmVAa2VybmVsLm9yZz7CwZEEEwEIADsCGwMFCwkIBwIGFQoJCAsCBBYC
 AwECHgECF4AWIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZUDpDAIZAQAKCRD2t4JPQmmgcz33
 EACjROM3nj9FGclR5AlyPUbAq/txEX7E0EFQCDtdLPrjBcLAoaYJIQUV8IDCcPjZMJy2ADp7
 /zSwYba2rE2C9vRgjXZJNt21mySvKnnkPbNQGkNRl3TZAinO1Ddq3fp2c/GmYaW1NWFSfOmw
 MvB5CJaN0UK5l0/drnaA6Hxsu62V5UnpvxWgexqDuo0wfpEeP1PEqMNzyiVPvJ8bJxgM8qoC
 cpXLp1Rq/jq7pbUycY8GeYw2j+FVZJHlhL0w0Zm9CFHThHxRAm1tsIPc+oTorx7haXP+nN0J
 iqBXVAxLK2KxrHtMygim50xk2QpUotWYfZpRRv8dMygEPIB3f1Vi5JMwP4M47NZNdpqVkHrm
 jvcNuLfDgf/vqUvuXs2eA2/BkIHcOuAAbsvreX1WX1rTHmx5ud3OhsWQQRVL2rt+0p1DpROI
 3Ob8F78W5rKr4HYvjX2Inpy3WahAm7FzUY184OyfPO/2zadKCqg8n01mWA9PXxs84bFEV2mP
 VzC5j6K8U3RNA6cb9bpE5bzXut6T2gxj6j+7TsgMQFhbyH/tZgpDjWvAiPZHb3sV29t8XaOF
 BwzqiI2AEkiWMySiHwCCMsIH9WUH7r7vpwROko89Tk+InpEbiphPjd7qAkyJ+tNIEWd1+MlX
 ZPtOaFLVHhLQ3PLFLkrU3+Yi3tXqpvLE3gO3LM7BTQRV4/npARAA5+u/Sx1n9anIqcgHpA7l
 5SUCP1e/qF7n5DK8LiM10gYglgY0XHOBi0S7vHppH8hrtpizx+7t5DBdPJgVtR6SilyK0/mp
 9nWHDhc9rwU3KmHYgFFsnX58eEmZxz2qsIY8juFor5r7kpcM5dRR9aB+HjlOOJJgyDxcJTwM
 1ey4L/79P72wuXRhMibN14SX6TZzf+/XIOrM6TsULVJEIv1+NdczQbs6pBTpEK/G2apME7vf
 mjTsZU26Ezn+LDMX16lHTmIJi7Hlh7eifCGGM+g/AlDV6aWKFS+sBbwy+YoS0Zc3Yz8zrdbi
 Kzn3kbKd+99//mysSVsHaekQYyVvO0KD2KPKBs1S/ImrBb6XecqxGy/y/3HWHdngGEY2v2IP
 Qox7mAPznyKyXEfG+0rrVseZSEssKmY01IsgwwbmN9ZcqUKYNhjv67WMX7tNwiVbSrGLZoqf
 Xlgw4aAdnIMQyTW8nE6hH/Iwqay4S2str4HZtWwyWLitk7N+e+vxuK5qto4AxtB7VdimvKUs
 x6kQO5F3YWcC3vCXCgPwyV8133+fIR2L81R1L1q3swaEuh95vWj6iskxeNWSTyFAVKYYVskG
 V+OTtB71P1XCnb6AJCW9cKpC25+zxQqD2Zy0dK3u2RuKErajKBa/YWzuSaKAOkneFxG3LJIv
 Hl7iqPF+JDCjB5sAEQEAAcLBXwQYAQIACQUCVeP56QIbDAAKCRD2t4JPQmmgc5VnD/9YgbCr
 HR1FbMbm7td54UrYvZV/i7m3dIQNXK2e+Cbv5PXf19ce3XluaE+wA8D+vnIW5mbAAiojt3Mb
 6p0WJS3QzbObzHNgAp3zy/L4lXwc6WW5vnpWAzqXFHP8D9PTpqvBALbXqL06smP47JqbyQxj
 Xf7D2rrPeIqbYmVY9da1KzMOVf3gReazYa89zZSdVkMojfWsbq05zwYU+SCWS3NiyF6QghbW
 voxbFwX1i/0xRwJiX9NNbRj1huVKQuS4W7rbWA87TrVQPXUAdkyd7FRYICNW+0gddysIwPoa
 KrLfx3Ba6Rpx0JznbrVOtXlihjl4KV8mtOPjYDY9u+8x412xXnlGl6AC4HLu2F3ECkamY4G6
 UxejX+E6vW6Xe4n7H+rEX5UFgPRdYkS1TA/X3nMen9bouxNsvIJv7C6adZmMHqu/2azX7S7I
 vrxxySzOw9GxjoVTuzWMKWpDGP8n71IFeOot8JuPZtJ8omz+DZel+WCNZMVdVNLPOd5frqOv
 mpz0VhFAlNTjU1Vy0CnuxX3AM51J8dpdNyG0S8rADh6C8AKCDOfUstpq28/6oTaQv7QZdge0
 JY6dglzGKnCi/zsmp2+1w559frz4+IC7j/igvJGX4KDDKUs0mlld8J2u2sBXv7CGxdzQoHaz
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <5d5ac074-1790-410e-acf9-0e559cb7eacb@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Stefan, Xin,

On 18/08/2025 16:31, Stefan Metzmacher wrote:
> Hi,
> 
>> diff --git a/include/linux/socket.h b/include/linux/socket.h
>> index 3b262487ec06..a7c05b064583 100644
>> --- a/include/linux/socket.h
>> +++ b/include/linux/socket.h
>> @@ -386,6 +386,7 @@ struct ucred {
>>   #define SOL_MCTP    285
>>   #define SOL_SMC        286
>>   #define SOL_VSOCK    287
>> +#define SOL_QUIC    288
>>     /* IPX options */
>>   #define IPX_TYPE    1
>> diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
>> index ced0fc3c3aa5..34becd90d3a6 100644
>> --- a/include/uapi/linux/in.h
>> +++ b/include/uapi/linux/in.h
>> @@ -85,6 +85,8 @@ enum {
>>   #define IPPROTO_RAW        IPPROTO_RAW
>>     IPPROTO_SMC = 256,        /* Shared Memory Communications        */
>>   #define IPPROTO_SMC        IPPROTO_SMC
>> +  IPPROTO_QUIC = 261,        /* A UDP-Based Multiplexed and Secure
>> Transport    */
>> +#define IPPROTO_QUIC        IPPROTO_QUIC
>>     IPPROTO_MPTCP = 262,        /* Multipath TCP connection        */
>>   #define IPPROTO_MPTCP        IPPROTO_MPTCP
>>     IPPROTO_MAX
> 
> Can these constants be accepted, soon?
> 
> Samba 4.23.0 to be released early September will ship userspace code to
> use them. It would be good to have them correct when kernel's start to
> support this...
> 
> It would also mean less risk for conflicting projects with the need for
> such numbers.
> 
> I think it's useful to use a value lower than IPPROTO_MAX, because it means
> the kernel module can also be build against older kernels as out of tree
> module
> and still it would be transparent for userspace consumers like samba.
> There are hardcoded checks for IPPROTO_MAX in inet_create, inet6_create,
> inet_diag_register
> and the value of IPPROTO_MAX is 263 starting with commit
> d25a92ccae6bed02327b63d138e12e7806830f78 in 6.11.

I would also recommend not changing IPPROTO_MAX here. When IPPROTO_MAX
got increased to 263, this caused some (small) small issues because it
was hardcoded in some userspace code if I remember well.

It is unclear why IPPROTO_QUIC is using 261 and not 257, but it should
not make any differences I suppose.

Note that for MPTCP, we picked 262, just in case the protocol number was
limited to 8 bits, to fallback to IPPROTO_TCP: 262 & 0xFF = 6. At that
time, we thought it was important, because we were the first ones to use
a value higher than U8_MAX. At the end, it is good for new protocols,
not to increase IPPROTO_MAX each time :)

(@Xin: BTW, thank you for working on this!)

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.

