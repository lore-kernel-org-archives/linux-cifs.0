Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD96361668
	for <linux-cifs@vger.kernel.org>; Wed,  8 Apr 2026 05:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775627974; cv=none; b=OrFXUseaO3MwwmfceduEI+JGJ85JgInnhcOREUktTNPdAo0hc+I3u/c3z3yZ42dKrz1xYUPm+5y4kDeXDVH5L5PTEMI9V3LiV/3li8vsjkVtRsk+98Qo930vfw6fWUoROqbigN8zrOWDNmWaWKSDfl3tPGaJWfpjhOw0hid2eog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775627974; c=relaxed/simple;
	bh=xVIxbtIea2Zy2XrpkRKCbatOYUs0i15XfkSqs6z80Lg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MGpHQaOUQjHC0HLP6WuzNqJyeulb+LQ25g9RueDoR1ISHKlWzNuJH1RvxNK5PDs5vbQJAPzgSDv4XnvesCkePtmjvZczYOEIdR0kLVR0Hth7ousSI9A3+OHvJY9hsXKjfdZM0K/lzJ9aXEf6X/xEriycbt6U/0xpBohFca9qh9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=hgzBT5Q3; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="hgzBT5Q3"
Message-ID: <68bc86cc-1c57-4734-9c75-14c9de80bd71@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1775627960;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kyizpbPf2SethJLAQustHYCjGlsy/KWMQjDIkCTOE2E=;
	b=hgzBT5Q3PyhXBEPxettMPAjFiAW0z0nPmKwzFioY+x7KR0NROPbZLxDGPAcmdXTt8phAo/
	NPS3j2HZF6kmOibTRlzkXUiSLovhdx8rF5G6pPjze6BQnaH+enF0RZysjPmLKUaECsdyA3
	c/GZHvcM5ScTgQ6nw54RWW0bpupxfX0LqHhySG4t5q+TwCYQDjZP4SnkUCZB1ZRI3TWEk+
	GtqhxM4qgGPHoZUZWqRYWKKqch1dcN0kc4uaJn2UoNIsDdZT84kTUqgifGdXMh70CENUnD
	p46EGshgi9px2ENwxUBQgfy2DWzooG8JCKOdEttxUdpq+5SofkTpj4ciZCMtXg==
Date: Wed, 8 Apr 2026 13:58:27 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] smb: client: fix off-by-8 bounds check in
 check_wsl_eas()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>, samba-technical@lists.samba.org,
 stable <stable@kernel.org>
References: <2026040635-banking-unsoiled-3250@gregkh>
 <2026040636-unsigned-jackal-e239@gregkh>
 <d998240c-aca9-420d-9dbd-f5ba24af19e0@chenxiaosong.com>
 <2026040822-shortly-chump-8518@gregkh>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <2026040822-shortly-chump-8518@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

The for loop does not seem to catch cases where `outlen` is excessively 
large. In such cases, smb2_compound_op() would use this large `outlen` 
to `memcpy()`, which could lead to OOB.

```
smb2_compound_op()
{
	...
	size[0] = outlen; // very large
	check_wsl_eas()
	memcpy(..., outlen) // out-of-bounds
	...
}
```

On 4/8/26 13:39, Greg Kroah-Hartman wrote:
> On Wed, Apr 08, 2026 at 10:51:12AM +0800, ChenXiaoSong wrote:
>> Sashiko reported another out-of-bounds issue:
>> https://sashiko.dev/#/patchset/2026040635-banking-unsoiled-3250@gregkh
>>
>> Should we add the following checks in check_wsl_eas()?
>>
>> ```
>> --- a/fs/smb/client/smb2inode.c
>> +++ b/fs/smb/client/smb2inode.c
>> @@ -121,6 +121,9 @@ static int check_wsl_eas(struct kvec *rsp_iov)
>>          ea = (void *)((u8 *)rsp_iov->iov_base +
>>                        le16_to_cpu(rsp->OutputBufferOffset));
>>          end = (u8 *)rsp_iov->iov_base + rsp_iov->iov_len;
>> +       if (ea + outlen > end)
>> +               return -EINVAL;
> 
> Then you would miss any "first" structures here, as I think the for loop
> catches this later on with the line:
> 
> 
>> +
>>          for (;;) {
>>                  if ((u8 *)ea > end - sizeof(*ea))
>>                          return -EINVAL;
> 
> That one, right?
> 
> Or am I misreading this?
> 
> Pointer math is "fun" :(
> 
> thanks,
> 
> greg k-h

-- 
ChenXiaoSong <chenxiaosong@kylinos.cn>
Chinese Homepage: chenxiaosong.com
English Homepage: chenxiaosong.com/en

