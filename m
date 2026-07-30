Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2007C35E92B
	for <linux-cifs@vger.kernel.org>; Thu, 30 Jul 2026 02:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785380113; cv=none; b=p+ragVfsRXGlqehI/NmVbzTjukDnDjNDTgjljCmgoQG92OlI8p99+KE7onltaVV8NQPhW/xvlR8RUP4Ef1p8A+ZW5M2TLiXXB4tLdvtcpX0vHq3qciuHfyfQAZpZhBJnn2ziCzM14M9Kadw2edfbbRu/8Dak0rVDPYXfeBtPF8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785380113; c=relaxed/simple;
	bh=q8LS4ZFA0J6q/fbUZXy5U4h9/4idGkkRYCKOYrg9z+8=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=l1xkZkuxWWZNpbwNpTT81mZbs9JNbDO366bD8TdkagP7gaWYkQbdSzSEp8GOtfTt0T2GmhWaMHwXjumn1hwtEAwUrhzh4IhFkj9743FxheqoaYo9MDh+YqkDFd+VZTpfjC+Nmgp9bWgmiLQTw1psFgu2KXF7k6X37pBJYjWFZTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ItKNUgZ5; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ItKNUgZ5"
Message-ID: <14eb0939-3150-4a72-9c89-f3377b0b260d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785380106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dIipHbXFlFzu6I7kzKahZJddMz0GojU5LRzCzQoMPpg=;
	b=ItKNUgZ5ilDtcI+nvBpoydI/6PqgeGTLzMLLG3v1misNmqewYn4AEbN7d/36C11aw1qXFI
	xYATH6zujkDkxJaylUlKJM6Bu9Bui/9mJDNojgm1HM1RDHxgOSUvUTema1jWTU/LF5/gF8
	pJuWQBWo8jtaZV/IsjFhcq2mH9cnk7c=
Date: Thu, 30 Jul 2026 10:54:08 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v8 5/5] smb/client: refresh allocation after EOF-extending
 fallocate
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: hehuiwen <huiwen.he@linux.dev>
To: Paulo Alcantara <pc@manguebit.org>, smfrench@gmail.com,
 linkinjeon@kernel.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
 dhowells@redhat.com, metze@samba.org, chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
 Roberto Bergantinos Corpas <rbergant@redhat.com>
References: <20260703053300.913371-1-huiwen.he@linux.dev>
 <20260703053300.913371-6-huiwen.he@linux.dev>
 <97c0ca61c2bed2d2559b32b7ed967121@manguebit.org>
 <e0e87dba-ea62-4175-b14c-34bc3753bec9@linux.dev>
Content-Language: en-US
In-Reply-To: <e0e87dba-ea62-4175-b14c-34bc3753bec9@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Paulo and Steve，

The current patch series does introduce this regression because it adds 
real server-side allocation for EOF-extending fallocate.

I reproduced the failure using Paulo's reproducer and got the following 
results:

   Samba strict allocate + 15G XFS    -> ENOSPC
   Samba strict allocate + 15G Btrfs  -> PASS
   ksmbd                 + 15G XFS    -> PASS

Samba handles the requests as follows:

   SetAllocation -> fallocate(KEEP_SIZE, 0, 8G)
   SetEOF        -> fallocate(0, 0, 8G)

On XFS, the first call allocates 8 GiB. The second call tries to
reserve nearly 8 GiB again before checking the existing extents,
so it fails with ENOSPC.

ksmbd does not have this problem:

   SetAllocation -> fallocate(KEEP_SIZE, 0, 8G)
   SetEOF        -> truncate(8G)

This appears to be an interaction between Samba strict allocation and
XFS. Since SetAllocation has already allocated the range, fixing Samba
to avoid the second allocation seems more appropriate. What do
you think?

Thanks,
Huiwen

在 2026/7/30 10:17, hehuiwen 写道:
> Hi Paulo,
> 
> Thanks for the report.
> 
> The generic/103 failure is expected because it allocates almost all free 
> space. Using separate filesystems for the test and scratch shares avoids 
> it.
> 
> I have reproduced the generic/590 failure and am investigating it.
> 
> Thanks,
> Huiwen
> 
> 
> 在 2026/7/30 06:54, Paulo Alcantara 写道:
>> Huiwen He <huiwen.he@linux.dev> writes:
>>
>>> From: Huiwen He <hehuiwen@kylinos.cn>
>>>
>>> Before this change, xfstests generic/496 was not supported on ksmbd:
>>>
>>>          generic/496 ... [not run] fallocated swap not supported here
>>>
>>> ksmbd handles SetEOF as truncate, so EOF extension alone does not
>>> allocate backing blocks. A fallocated swapfile can therefore still
>>> look sparse to swapon.
>>>
>>> Request allocation for EOF-extending fallocate ranges that can be
>>> represented by FILE_ALLOCATION_INFORMATION, and refresh the allocation
>>> state afterwards.
>>>
>>> With this change, xfstests generic/496 and generic/701 pass on ksmbd.
>>>
>>> However, Samba "strict allocate = no" now exposes the real generic/701
>>> failure: the old pass came from inflated local i_blocks, not from
>>> server allocation. generic/213 also fails in that case because an
>>> oversized allocation request may not return ENOSPC.
>>>
>>> Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
>>> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>
>> This patch regressed fstests generic/103 and generic/590 against samba
>> 4.24 (strict allocate = yes) with a 15G xfs partition for both test and
>> scratch shares.  The tests now fail with -ENOSPC.
>>
>> A simple reproducer
>>
>>     $ mount.cifs //samba-fs0/scratch2 /mnt/1 -o username=xxx,password=yyy
>>          $ df -h /mnt/1
>>     Filesystem            Size  Used Avail Use% Mounted on
>>     //samba-fs0/scratch2   15G  326M   15G   3% /mnt/1
>>     $ xfs_io -c "falloc 0 8G" -f /mnt/1/file
>>     fallocate: No space left on device
> 

