Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3BB3451B3
	for <linux-cifs@vger.kernel.org>; Fri, 27 Feb 2026 04:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772165333; cv=none; b=b6C+uyvgTzGaoZ+xSnwLFDLiPtSjLm3mFma9sZfY5HZC8OwLwU3tCq3a9BTOJiHRkVybCDjXSC3Lm9FSoj8ClS5wCLrhYuP/WpIoR4lHO6RYkMV/E5pLnt04ZMqkOQjzrd1tSN/5Z9nck3KcRhw5/oiKvikFbb8Hy2Gls56zHhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772165333; c=relaxed/simple;
	bh=nODrtvLmVVhMO+f0q8gayDVbU7HrFLWMl61xbWoymBo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rvdh6oLqETzfMIPsUNImISFaUrcdidRQRze2WKW3oZN8C711wumQ8qaJfNQOWNJMq9d18oWdeZMtoC8f60vOxAIS08ppFockNVeZsJBrlO26cbnN7WNzfQgi/ArdvxbsSsQ/TM5bIg7G4KOkE7+y1n7hs0tb4gB+ZFi+oQxzam0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=ibQzzZtI; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="ibQzzZtI"
Message-ID: <f3604a74-3caa-4737-bfc0-d93feb988176@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1772165327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ANhl16UQX9s/ubY5XDKWQjefXS+3qQZo0aDYkOyLavY=;
	b=ibQzzZtI6emil3OMLJFqgROumyPGOytXhpm8UNSs8crFhE6u7XRRZlTX3zXV7aiLCVIO0Y
	3GTRk2kqGGgt//AJGw2afbhA1HHJyGz6ZKFBI/dlTw/7Yor8IgrYrUOaH6TPvo78OsDUGp
	u95L49h7iC1BJCq5MAzQLmat7JljTKK3vgfYVWNSLNUj1na3pxKe8Basu+WIxVog/zM51U
	cW0OK4OL4NOfkbmKUxv2YXcCTTjYY5aKSNkHDnAq76HoPHYVNN8+eLd0yIth5vL3Rr4nxF
	RjkvjcSeOB7CZZqjGMoW4GL9cyisreVlgsz2HL/wQ3GAIY0CqvTLmyDP5oFLqw==
Date: Fri, 27 Feb 2026 12:07:44 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/1] smb/server: fix refcount leak in smb2_open()
To: Guenter Roeck <linux@roeck-us.net>
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org, dhowells@redhat.com,
 linux-cifs@vger.kernel.org, ZhangGuoDong <zhangguodong@kylinos.cn>,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251229031518.1027240-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251229031518.1027240-2-chenxiaosong.chenxiaosong@linux.dev>
 <97979f06-7dd2-46bd-9bdd-3a9c45fc5b1d@roeck-us.net>
 <d3d93c04-fdd1-4b96-90f2-293a2d45f647@chenxiaosong.com>
 <59d5c1a6-7a7f-464a-aa62-e53daff8870d@roeck-us.net>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <59d5c1a6-7a7f-464a-aa62-e53daff8870d@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Guenter,

Sorry for the late reply. I had some family matters to take care of 
yesterday.

Please see the following process:

```
smb2_open
   smb2_check_durable_oplock
     opinfo_get(fp) // inc refcount
   ksmbd_reopen_durable_fd
     __open_id(&work->sess->file_table, fp,
       idr_alloc_cyclic(ft->idr, fp, ...)
       __open_id_set(fp, id, type); // insert into file table
   ksmbd_override_fsids // fail
   ksmbd_put_durable_fd
     __ksmbd_close_fd
       __ksmbd_remove_fd  // remove dh_info.fp from file table
   // dh_info.fp has already been removed from the file table
   ksmbd_fd_put(..., fp) // fp == NULL
```

Thanks,
ChenXiaoSong <chenxiaosong@chenxiaosong.com>

On 2026/2/26 13:09, Guenter Roeck wrote:
> Hi,
> 
> On 2/25/26 20:12, ChenXiaoSong wrote:
>> Hi Guenter,
>>
>> Thank you for taking the time to look into this issue.
>>
>> I reviewed the relevant code in more detail and did not find any leak.
>>
>> Both `ksmbd_put_durable_fd()` and `ksmbd_fd_put()` will eventually 
>> call `__ksmbd_remove_fd()` (remove fd from file table).
>>
> 
> Sorry for bothering you again. Are you sure ?
> 
> ksmbd_put_durable_fd() calls __ksmbd_close_fd() with NULL first parameter.
> __ksmbd_close_fd() only calls __ksmbd_remove_fd() if ft (the first 
> parameter)
> is not NULL.
> 
> ksmbd_fd_put() does call __ksmbd_remove_fd() with first parameter, but ...
> 
>> If my understanding is incorrect, please let me know.
>>
>> Thanks,
>> ChenXiaoSong <chenxiaosong@chenxiaosong.com>
>>
>> 在 2026/2/26 00:49, Guenter Roeck 写道:
>>> Running an experimental AI agent on this patch produced the following
>>> feedback:
>>>
>>> This isn't a bug introduced by your patch, but it looks like there is 
>>> still a
>>> resource leak here. If ksmbd_override_fsids() fails, we jump to 
>>> err_out2.
>>> At that point, fp is NULL because it hasn't been assigned dh_info.fp 
>>> yet,
>>> so ksmbd_fd_put(work, fp) will not be called. However, dh_info.fp was
> 
> the AI is trying to make the point that ksmbd_fd_put() will not be called
> because fp == NULL.
> 
> Thanks,
> Guenter
> 
>>> already inserted into the session file table by 
>>> ksmbd_reopen_durable_fd(),
>>> so it will leak in the session file table until the session is closed.
>>> Should fp = dh_info.fp; be moved before the ksmbd_override_fsids() 
>>> check?
>>>
>>> PTAL and let me know if it has a point or if it is missing something.
>>
