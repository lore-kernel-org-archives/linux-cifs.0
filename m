Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0832EA496;
	Thu, 21 Aug 2025 08:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755764681; cv=none; b=Q4RkyjLWqQixRdTaMfi3NMlQn1+eaVBVKGELP0634g9Yqxt9F5o/X2Vz+3Tlh6cqV7fwi+/y2gtOoNpF53bqZ2nFHyE6JzjqeO/CaSIysDWDs1m729rii0w3zs6xJW0IA+2VCF428ktvKbeigzB40Na7Zh+FYp1yjL9hB75O1/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755764681; c=relaxed/simple;
	bh=scHGrOC8eE1WmWFXS9WzmAtynz/lWXfDXS5O62Lq58U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LX5J2NGX6Boyv9/DONyubAbrQWuGj8TV5RIpoR42SKaF6zj3YQvEB8fbIbv2phhK+w4aj2bB2x+faIcVwGiFxGS6Bxb1LEqlDQEURBaaSVE2NkdLi1Sg7gNYzR8kYWqjfZ7HJaAwb0rWYGrVtpwfcygB/+IRvbscBGmjhdyw/Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=JaLclXCl; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="JaLclXCl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=a9NwOEZ9E0uWkOujSpLzh89ug+qWlu/+wzfesTRczEI=; b=JaLclXCl25bBTMGj/D8BHmqVtH
	VH0qmicgBBqjFi8uUH3YApkvWnvx1EEJOSz31ttFGERSKZl2R7PqyoXgtAi9nBmMgPkUrmqvJtdr7
	5oBPPD9WXzQBI93K6P1YiSL8NylQ73gyZ4KWMnHj3c/thSApsAWpUnfShWD1riCpnm1qHR6aw0xw2
	e8sQ2D6B97nZEXNT2OIsQC0Ph15HIHJHDPSvX0dZVnJ9xuCLOAtd02Lwurp/CnjXSAq7ExsCtUUrg
	LYSMyDOPgNYrAdxHJKWYbHQAXrGmgEv6G+nSc0UuUUBB564k86BJWETjupNlTpDTp6feQHC7Hi6UO
	xtdO5GcGuUTu+o1iRLCwGmSWc0AHkrOalq0lWAJm+Ux0y9STp90kWmGBbCAFhdVBlignScX5XzzFS
	dG6JSK6XGlMd3Vz3xMLmihfV61fsiblTMCq2atNfqSiQV9lzbs/pGAiIZ3ggNTuG1VTUSj1X+z/5v
	zQR3NcZtxgc9vkuUkKs3EXqI;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1up0b1-0002Ee-2a;
	Thu, 21 Aug 2025 08:24:31 +0000
Message-ID: <c604d959-61f6-4d6e-97fb-2c74ef07334a@samba.org>
Date: Thu, 21 Aug 2025 10:24:31 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v2 01/15] net: define IPPROTO_QUIC and SOL_QUIC
 constants
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Xin Long <lucien.xin@gmail.com>, network dev <netdev@vger.kernel.org>,
 davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>,
 Pengtao He <hepengtao@xiaomi.com>, linux-cifs@vger.kernel.org,
 Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@manguebit.com>,
 Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev,
 Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>,
 Benjamin Coddington <bcodding@redhat.com>, Steve Dickson
 <steved@redhat.com>, Hannes Reinecke <hare@suse.de>,
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
 <CAKYAXd-L12tTQyMtTG9+8=XjWY0NDKbYybGXUjPrGin5yYtx3A@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAKYAXd-L12tTQyMtTG9+8=XjWY0NDKbYybGXUjPrGin5yYtx3A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Namjae,

>>> diff --git a/include/linux/socket.h b/include/linux/socket.h
>>> index 3b262487ec06..a7c05b064583 100644
>>> --- a/include/linux/socket.h
>>> +++ b/include/linux/socket.h
>>> @@ -386,6 +386,7 @@ struct ucred {
>>>    #define SOL_MCTP    285
>>>    #define SOL_SMC             286
>>>    #define SOL_VSOCK   287
>>> +#define SOL_QUIC     288
>>>
>>>    /* IPX options */
>>>    #define IPX_TYPE    1
>>> diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
>>> index ced0fc3c3aa5..34becd90d3a6 100644
>>> --- a/include/uapi/linux/in.h
>>> +++ b/include/uapi/linux/in.h
>>> @@ -85,6 +85,8 @@ enum {
>>>    #define IPPROTO_RAW         IPPROTO_RAW
>>>      IPPROTO_SMC = 256,                /* Shared Memory Communications         */
>>>    #define IPPROTO_SMC         IPPROTO_SMC
>>> +  IPPROTO_QUIC = 261,                /* A UDP-Based Multiplexed and Secure Transport */
>>> +#define IPPROTO_QUIC         IPPROTO_QUIC
>>>      IPPROTO_MPTCP = 262,              /* Multipath TCP connection             */
>>>    #define IPPROTO_MPTCP               IPPROTO_MPTCP
>>>      IPPROTO_MAX
>>
>> Can these constants be accepted, soon?
>>
>> Samba 4.23.0 to be released early September will ship userspace code to
>> use them. It would be good to have them correct when kernel's start to
>> support this...
> I'd like to test ksmbd with smbclient of samba, which includes quic support.
> Which Samba branch should I use? How do I enable quic in Samba?
> Do I need to update smb.conf?

With master or 4.23 the simplest way would be

smbclient //ksmbd-server/share \
    -Uuser%Passw0rd \
    --option='client smb transports = quic' \
    --option='tls verify peer = no_check' \
    -I 10.0.0.1

Note it only works with a name in the unc otherwise
quic can't work.

For development you may want to use
SSLKEYLOGFILE=/dev/shm/sslkeylogfile.txt smbclient ...

And point wireshark to /dev/shm/sslkeylogfile.txt with

wireshark -o tls.keylog_file:/dev/shm/sslkeylogfile.txt

Or you merge it into a pcapng file like this:

editcap --inject-secrets tls,/dev/shm/sslkeylogfile.txt capture.pcap.gz capture.pcapng.gz

Then 'wireshark capture.pcapng.gz' will have everything to decrypt.

metze

