Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28543BED59;
	Fri, 24 Apr 2026 11:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777030757; cv=none; b=GbOBf02PNtrlf6snmHX+qGQYNGZjbRWXNdpcIS0q2WUDve04BKLdD6KeFlDnF7vEqWy5/K6FL1yNXhQPhyFtN3AySO0dZZIMLKhwmRZIFixnh2eZ7eYrdSAFrUScE/qfCKv66JbbdxyQnKeHMgvwIUYKE1CK9Gkz4oGJa3J5uw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777030757; c=relaxed/simple;
	bh=Vbw15iUuGReYoDg74B4jVuwCsAm3eNad5N4/DaDRt24=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=smnQL6OqJrpLbg1a/3qUKIcBN5l15rIC86KrFO5MyivrsQWn6/kiYQZpNiUF46iWEB/GBzVa2M8budP4Gmc2uEApqAS2QtUeqC9foUPJPo8j+PeQFyxGPLEx0MnyHb7nrUMkmQ2XBCwugP04eYOV09OlKjDNvzr6+hExietqMg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=M+117sDc; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="M+117sDc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=vqWcSThc8pjY0oM9PCXkI0BSkRYzt+6om4JQ2IRTrkM=; b=M+117sDce9Z9GeWcvjlIK7G646
	AFw6i7n4qtNKPYbT7vf0dZsmj68sxKBqeTTIpzxCXPeXQilmWw+aEi8YVSvkrVTTyufHZIvf7kfRz
	U3i4aBqEeFs/aMCaErfktfPQGpWx7TaZMVnwMVaR1+sG0wRzXrbEFMVjIRYaWfpNasHn47JXLDKhf
	G9SWpwBI/neGk4zS4CDmm5SaOMxae17LwBXmhIJ41OMiyo+c1+hpemO8MbP7+2NXz7pAxTK1O77dq
	mrh7dzOzWU3xTN9JmQFMO56J1WCiNsJ+MM0qwRi+lGhBO+lXvADTHuPmv27eGAbJl0fOfTWKN/Zrc
	ZqOwGgYlHYa06QrleGc17rClshzzuljGAilOCJdPUClfypeKeKuLlayyBgs5x2JYRZ75Ey0Aj2lJe
	+M6k7Re1sqZ1c7oSvO10fGh9oWOczCac+857VtdnmPYhrxnrXcVHJfevl0LEW6m4k3zcp6UMcB8hm
	+S8KcGP4Vcmu7G1L7So0g91y;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wGEsG-00000003nNq-2SmM;
	Fri, 24 Apr 2026 11:39:11 +0000
Message-ID: <966208b7-b77a-45b9-9dcb-3c8823429318@samba.org>
Date: Fri, 24 Apr 2026 13:39:06 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: client: Fix error cleanup in
 smb_extract_iter_to_rdma()
To: Greg KH <gregkh@linuxfoundation.org>, David Howells <dhowells@redhat.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
 Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <3418418.1777024571@warthog.procyon.org.uk>
 <2026042426-prance-each-273d@gregkh>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <2026042426-prance-each-273d@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi David,

>> Fix smb_extract_iter_to_rdma() to use pre-decrement, not post-decrement, so
>> that it cleans up the correct slots.
>>
>> Fixes: e5fbdde43017 ("cifs: Add a function to build an RDMA SGE list from an iterator")
>> Closes: https://sashiko.dev/#/patchset/20260326104544.509518-1-dhowells%40redhat.com
>> Signed-off-by: David Howells <dhowells@redhat.com>
>> cc: Steve French <sfrench@samba.org>
>> cc: Stefan Metzmacher <metze@samba.org>
>> cc: Paulo Alcantara <pc@manguebit.org>
>> cc: Tom Talpey <tom@talpey.com>
>> cc: linux-cifs@vger.kernel.org
>> cc: linux-fsdevel@vger.kernel.org
>> ---
>>   fs/smb/client/smbdirect.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
>> index 7d5f66bdbb30..4978755c035c 100644
>> --- a/fs/smb/client/smbdirect.c
>> +++ b/fs/smb/client/smbdirect.c
>> @@ -3394,7 +3394,7 @@ static ssize_t smb_extract_iter_to_rdma(struct iov_iter *iter, size_t len,
>>   
>>   	if (ret < 0) {
>>   		while (rdma->nr_sge > before) {
>> -			struct ib_sge *sge = &rdma->sge[rdma->nr_sge--];
>> +			struct ib_sge *sge = &rdma->sge[--rdma->nr_sge];

Can you please use logic like this?

-               while (state->num_sge > before) {
-                       struct ib_sge *sge = &state->sge[state->num_sge--];
+               for (size_t i = before; i < state->num_sge; i++) {
+                       struct ib_sge *sge = &state->sge[i];

At least for me that is much easier to understand.

And as Greg pointed out we first need a fix for upstream, there
the function is smbdirect_map_sges_from_iter in fs/smb/smbdirect/connection.c

Also the commit message needs to be adjusted for the new name.

Then we need a backportable fix for smb_extract_iter_to_rdma in
fs/smb/client/smbdirect.c with the same logic.

Thanks!
metze

>>   			ib_dma_unmap_single(rdma->device, sge->addr, sge->length,
>>   					    rdma->direction);
>>
>>
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
> 
> </formletter>
