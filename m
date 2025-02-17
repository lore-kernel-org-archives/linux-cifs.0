Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29A418787F
	for <linux-cifs@vger.kernel.org>; Mon, 17 Feb 2025 22:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739830343; cv=none; b=hmEzci36fZNClcPq5Xeq2Cx/YPtU4Mff2K0oeicECGqLGjvaDpFl+11QXs0KdZzjKE0d3JxH4TXjioqmLcTE7j3YgvpCFwQBz9uCwpPYiSXzLskoOPWWfHSQtjWbYxUNkGVqBIFURBwTQZuRwhyCk0Fj0eb4jCBs+jxz5aCYOQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739830343; c=relaxed/simple;
	bh=2gwpUGIGY9cP557Y6T0zqnIarLt15xsJusknccnkpMQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MZ1zorvDouI+Pg68bkXF6JheXdGhPm8fdmLZlZt8xGXezsUdGNjZBloBXozaa4CaQpOSuXS5F3zAY3MzDplHP9kZuMbz+PAZYBGnwILGIOzXoxfokxaAusspfULnFfct+dXC5xrfS/7eeqJy8EZe4Dh9TiGJcxY0+meN8t723CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=PJuBfhn7; arc=none smtp.client-ip=67.231.154.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="PJuBfhn7"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 169206C0066;
	Mon, 17 Feb 2025 22:12:13 +0000 (UTC)
Received: from [10.20.38.223] (hirgnt03.hicv.net [173.197.107.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail3.candelatech.com (Postfix) with ESMTPSA id D6F9E13C2B0;
	Mon, 17 Feb 2025 14:12:11 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com D6F9E13C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1739830332;
	bh=2gwpUGIGY9cP557Y6T0zqnIarLt15xsJusknccnkpMQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PJuBfhn7KMs8oev8h9Ju1fWZWnFmwrPx94qlYBKALDiVp3+HEiDi2smoTvl8cM5e8
	 vRICQM0Esh0whibqdKI1l2qZlA0VXRkSw9Wq6q+OL/Ru5hFYCVyRUzuj0LRi1PtHAt
	 ZDtK8y0JUYsBWRhQJDkOBwxQ+UAm7QgWIAUZgCOU=
Message-ID: <336ca66d-8655-4acd-b1d7-3f87016ac602@candelatech.com>
Date: Mon, 17 Feb 2025 14:12:10 -0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: If source address specified on mount, it should force destination
 address to be same type (IPv4 vs IPv6)
To: Tom Talpey <tom@talpey.com>, Steve French <smfrench@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.com>, David Howells <dhowells@redhat.com>,
 CIFS <linux-cifs@vger.kernel.org>
References: <CAH2r5mtxd=2Qz-ABKbGJ3FeghR6jBb+P5ZsMo7E=V6UXwpXokQ@mail.gmail.com>
 <069e1547-8006-4c7e-9f82-3c0178aa81b8@talpey.com>
 <CAH2r5mvf8iCpcp0bj29=1y=bDceEPjZiTGZEx9U2=9yYYgAKhg@mail.gmail.com>
 <35d4423c-9714-4446-ba55-a278103584e7@talpey.com>
Content-Language: en-MW
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
In-Reply-To: <35d4423c-9714-4446-ba55-a278103584e7@talpey.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-MDID: 1739830334-mACCFhR7qE7w
X-MDID-O:
 us5;at1;1739830334;mACCFhR7qE7w;<greearb@candelatech.com>;440927dc43c7cb3aaf47f588366827eb
X-PPE-TRUSTED: V=1;DIR=OUT;

On 2/17/25 1:28 PM, Tom Talpey wrote:
> On 2/17/2025 4:18 PM, Steve French wrote:
>> On Mon, Feb 17, 2025 at 3:08 PM Tom Talpey <tom@talpey.com> wrote:
>>>
>>> On 2/17/2025 1:27 PM, Steve French wrote:
>>>> Noticed this old bug today when cleaning up emails.
>>>>
>>>> When the user specifies a srcaddr on mount, the DNS resolution of the
>>>> host name should only look for the same type of address (ie IPv4 if
>>>> srcaddr is IPv4, IPv6 if IPv6) right?
>>>>
>>>> Any thoughts on how this was handled in other protocols?
>>>
>>> What is this "srcaddr" witchcraft that thou dost utter? :)
>>
>> The original patch which added it was this, and apparently is needed in some
>> cases where the subnet the request comes from is restricted:
>>
>> commit 3eb9a8893a76cf1cda3b41c3212eb2cfe83eae0e
>> Author: Ben Greear <greearb@candelatech.com>
>> Date:   Wed Sep 1 17:06:02 2010 -0700
>>
>>      cifs: Allow binding to local IP address.
>>
>>      When using multi-homed machines, it's nice to be able to specify
>>      the local IP to use for outbound connections.  This patch gives
>>      cifs the ability to bind to a particular IP address.
>>
>>         Usage:  mount -t cifs -o srcaddr=192.168.1.50,user=foo, ...
>>         Usage:  mount -t cifs -o srcaddr=2002::100:1,user=foo, ...
>>
>>      Acked-by: Jeff Layton <jlayton@redhat.com>
>>      Acked-by: Dr. David Holder <david.holder@erion.co.uk>
>>      Signed-off-by: Ben Greear <greearb@candelatech.com>
> 
> I still think this is a hack, and unlikely to work reliably.

Except for that DNS issue, it works as intended as far as I can tell, and someone that doesn't want
the behaviour can just not use it.

I guess we never run CIFS in mixed ipv4/6 environment with DNS.

>>> There isn't such an option in mount.nfs that I'm aware of.
>>> And, it isn't documented in mount.cifs either.
>>
>> NFS man page does show "clientaddr=" mount option,
>> and it is necessary apparently in some cases (e.g.
>> https://forum.proxmox.com/threads/nfs-mounts-using-wrong-source-ip-interface.70754/)
> 
> The NFSv4.0 clientaddr is totally different, that protocol requires
> the client to inform the server which address to establish a
> callback channel to. This horribly broken protocol architecture
> was corrected in NFSv4.1.

NFS requires a small pile of patches to have a similar behaviour...they are in
our kernel (github.com greearb) in case anyone wants them, but were never accepted upstream.

Thanks,
Ben

> 
> Tom.
> 
>>
>>
>>> It seems like a hack on top of a hack to match the DNS result
>>> to the type of the specified srcaddr. If the server supports
>>> both IP versions and the DNS record exposes them, won't the
>>> same issue occur on "normal" mounts?
>>>
>>> I would not see this playing nicely with multichannel, btw.
>>> Or RDMA. Probably other scenarios.
>>>
>>> Tom.
>>>
>>>
>>>>
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=218523
>>
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
