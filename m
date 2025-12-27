Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 591FF299920
	for <linux-cifs@vger.kernel.org>; Sat, 27 Dec 2025 02:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766801979; cv=none; b=cmTqqj17cUNZ/6IxW6BCgCbpTcbbVrIoLLQc38rFgDfEU5BKtkSUAVh3IwZXs0x/ywm4rlTfKQDze93DHoWH5X41RVEFIqXwVtWi0SAgqkUrkhAnI31+N+N72J6fBGYZ7FyIpW3BAtk0+/ZcArPxXe3cYqFO1uccp/kfueLi8Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766801979; c=relaxed/simple;
	bh=SfGA8P2jF1Ji3nG+Ebgags9WP23vGGoVuNDho29JbrE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RPTzN1nL2VHjioFnCNsmVIH4f63d5ACOf9Bf2MJMtoAEn3p8L8SglMPue3f5UZiTdBRskm6iH1TM9g09UMzmNiJkwaYgd4oZP0ZyOHjX3xZXAGeo/gvFubY0C9YPGPxXfzAXfYQFO4iP/ekgVaMaBsevLa+jo2qMfdPn8MIPG7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UFuB3UM7; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UFuB3UM7"
Message-ID: <f0740fbf-1142-42f8-b56f-937fa915a4bb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766801961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BwZx1cPxGGlIWByDMf3r4pZQKjEat4Yq+hSpzdW9mFM=;
	b=UFuB3UM7Vf5Esngpkxjrzwg1yCapfkYBh+5R2Lq0bGl2qOCDHRTRAnuO6EMat2jZCS4kPe
	qgGaJUWwWnaRGEHrdQUM33T4HxFAYYxaknnLn93yeVpvtaor0SEtM70yA7OrHcJFlCa3SZ
	TFOEQhPxTgd+KHTHce3Vdfx/XXZiEb0=
Date: Sat, 27 Dec 2025 10:18:47 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v6 4/5] smb/client: use bsearch() to find target in
 smb2_error_map_table
To: David Howells <dhowells@redhat.com>, Steve French <smfrench@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>
Cc: pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
 linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251225021035.656639-5-chenxiaosong.chenxiaosong@linux.dev>
 <20251225021035.656639-1-chenxiaosong.chenxiaosong@linux.dev>
 <1236711.1766750798@warthog.procyon.org.uk>
 <e64b6e2d-6ad8-43b0-bca3-fbeae76f6306@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <e64b6e2d-6ad8-43b0-bca3-fbeae76f6306@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi David,

Your second suggestion looks good. Should we change it to the following 
code? If you are okay with these changes, I can send the next version.

```
__inline_bsearch((const void *)(unsigned long)smb2_status, ...);

static __always_inline int cmp_smb2_status(const void *_key, const void 
*_pivot)
{
         __le32 key = (unsigned long)_key;
         const struct status_to_posix_error *pivot = _pivot;

         if (key < pivot->smb2_status)
                 return -1;
         if (key > pivot->smb2_status)
                 return 1;
         return 0;
}
```

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 12/26/25 11:28 PM, ChenXiaoSong wrote:
> Hi David,
> 
> We cannot use "return b->smb2_status - a->smb2_status".
> 
> For example:
> 
>      a_status = 0xC0000005
>      b_status = 0x00000001
> 
> The subtraction is evaluated in an unsigned type:
> 
>      a_status - b_status = 0xC0000004 > 0
> 
> But the comparison function returns int, so the value is converted:
> 
>      (int)(a_status - b_status) < 0
> 
> Thanks,
> ChenXiaoSong.
> 
> On 12/26/25 8:06 PM, David Howells wrote:
>>
>> Actually...  It's probably sufficient to do:
>>
>>     static __always_inline
>>     int cmp_smb2_status(const void *_a, const void *_b)
>>     {
>>         const struct status_to_posix_error *a = _a, *b = _b;
>>
>>         return b->smb2_status - a->smb2_status;
>>     }
>>
>> as __inline_bsearch() only cares about the zeroness or sign of the return
>> value.  (Note the arguments to the subtraction might need to be flipped).
>>
>> It might even better just to cast the smb status you're looking for to 
>> the key
>> parameter:
>>
>>     __inline_bsearch((const void *)(long)status, ...);
>>
>> and then do this in the comparison function:
>>
>>     static __always_inline
>>     int cmp_smb2_status(const void *key, const void *_b)
>>     {
>>         const struct status_to_posix_error *b = _b;
>>         int status = (long)key;
>>
>>         return b->smb2_status - status;
>>     }
>>
>> as __inline_bsearch() doesn't attempt to dereference key.
>>
>> David
> 

