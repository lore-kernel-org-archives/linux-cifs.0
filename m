Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F2923CB;
	Wed,  6 Aug 2025 14:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754489866; cv=none; b=PTIK1sFqk8ZMt4n2UQb4gF7ZA9ySqEtQAsCv5NtX2o3p99/ZvifoTYiltWTGp+iqjK280gV4mv8X3v194vaXm7zA8i8sqsWVcharPiyZ0752whI0GEn6LDutmfaVnmdp9u7Js/GDShA5v81G5uRqH0T/TusC8bvBBUAVORDuipA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754489866; c=relaxed/simple;
	bh=P/E43kYSMKKJYqIlbPjwcWoMM4XvKvj8QeNIlOLcD0k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M0J+OTakbVBPHbRaDvVOZOMfW0ch7Srl4DSNU0uL+mn65itm17/bVLv32TXrVVasMjXkmlQ+E7ztYg+z5ytm0GGJmlq6vzwMOajdJtopCDVpm3O80q0PAMbH/Dgwn2rs2In6hlIRDUJoiE6zYt9MhUNMzkMgJPVUg1qb/2NagUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=t+TFmpEo; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="t+TFmpEo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=CvozvUvb2mLHLQoVpvw783zCOBflJqrngDv1NwUXoAs=; b=t+TFmpEop/qSe2NZe4S50iZ+W+
	nWgMdh/C173rax/xvJ/aC+EePCbkgwPdr8XMtckQU4WzRNCO4qFRdn3Y6mBys6Z9mQOHMmLWHPhT+
	rJ+MuOYvShJXJfncSop2CcdUbNhufbMHEPWJnb0ShZ4Rkc3FtV591zUVXHFnb74m70oppGaMpybnp
	7+0Z5zsmJi9E8OA1rGliL3hFpAsNK7R54KQ/5MlC+rgpPEza/WTZ1arc3EgODoisDaKNVDO3/2Jkf
	81oi3xat+alh1fRcxDNvddwTAHeh54BrUBOAYAFMh+IwRw4t7NTbHYgpGcu+huGtaxOYhaC5IJYTR
	kVREPtWDDfKdaAaXXwPpYBKTv7tvZvxjXVW84tICvqcJFgRViDwcP345x1vQU59f+Yyal9aVf/uwW
	yBweZI0LFjtBuh0IzFz3+9Oibht4ZM3b3ZyrxoGDNvp3xDPfyjmhJfXa+1JVobXcIZQCt4s2lzBAI
	FPI0lzWkJadreHtKz5Cu4JNb;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ujexa-001MkB-06;
	Wed, 06 Aug 2025 14:17:42 +0000
Message-ID: <e291d925-bfd9-4202-b5d4-de5bf30ab870@samba.org>
Date: Wed, 6 Aug 2025 16:17:41 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next] smb: client: Fix use after free in send_done()
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org
References: <aJNASZzOWtg8aljM@stanley.mountain>
 <ad2e9d94-2d95-4351-b800-627f20672209@samba.org>
 <87646c67-78b8-41c5-9b72-361cb3b733d1@suswa.mountain>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <87646c67-78b8-41c5-9b72-361cb3b733d1@suswa.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 06.08.25 um 14:48 schrieb Dan Carpenter:
> On Wed, Aug 06, 2025 at 02:20:56PM +0200, Stefan Metzmacher wrote:
>> Hi Dan,
>>
>>> The mempool_free() function frees "request".  Don't free the request
>>> until after smbd_disconnect_rdma_connection() to avoid a use after free
>>> bug.
>>>
>>> Fixes: 5e65668c75c0 ("smb: client: let send_done() cleanup before calling smbd_disconnect_rdma_connection()")
>>> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
>>> ---
>>>    fs/smb/client/smbdirect.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
>>> index 58321e483a1a..162f8d1c548a 100644
>>> --- a/fs/smb/client/smbdirect.c
>>> +++ b/fs/smb/client/smbdirect.c
>>> @@ -286,8 +286,8 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
>>>    	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_SEND) {
>>>    		log_rdma_send(ERR, "wc->status=%d wc->opcode=%d\n",
>>>    			wc->status, wc->opcode);
>>> -		mempool_free(request, request->info->request_mempool);
>>>    		smbd_disconnect_rdma_connection(request->info);
>>> +		mempool_free(request, request->info->request_mempool);
>>
>> The correct fix is to use 'info' instead of 'request->info'
>> other than that the order needs to stay that way.
>>
>> I already asked Steve to squash such a change into the
>> original commit (which is not yet upstream).
>>
>> See:
>> https://lore.kernel.org/linux-cifs/cover.1754308712.git.metze@samba.org/T/#m98a8607d7b83a11fd78547306836a872a2a27192
>>
>> What was the test that triggered the problem?
>> Or did you only noticed it by looking at the code?
> 
> This was a Smatch static checker warning.  You need to have the cross
> function DB to detect it.

Ok, I'll try to integrate it into my build flow...

Does it replace sparse or does it run in addition?
If it replaces sparse I guess a small script would
run them both?

$ cat mychecker.sh:
#!/bin/bash
set -e
sparse $@
smatch $@

And maybe all others from
https://gautammenghani.com/linux,/c/2022/05/19/static-analysis-tools-linux-kernel.html

How often do I need to run smatch_scripts/build_kernel_data.sh on the whole kernel?

Thanks!
metze
