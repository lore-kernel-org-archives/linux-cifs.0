Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79E739281B
	for <linux-cifs@vger.kernel.org>; Thu, 30 Jul 2026 02:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785377891; cv=none; b=kqE6Ckjr2gZandzfQ5D8RP7HIMuKegdP+SL+QtF1drKskbKXZBcmbjtAOF0QV6poJxO/Qu08rYQSst/DcgB1rmz90UZ/UvhtACGa2O/INeGAHOkx0uxJ8Fv6PCY8ar8WqFpTjWcHl9L8828oGp4j5ZlmfQCjnwVhcWcgI6UwjhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785377891; c=relaxed/simple;
	bh=SFZ3rL7464h1lO4+zL+ggC7T0wM0ym/ECFlgszOLzTs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BfAUSZWgU5UXNO0L1BUAbFPgUITB5l2iWs6C7WmWsHkT0h5v6ESGe4WU+9TE+FemvtAbyzt+MbM3WHORGHWbaBQlLE8CA073P9mGh/OG/kGmD9mVxhY2ADAnMukuv2ecz+6Kc2XE6GjvwL8W74DISxaBt+hM+NlAY0d7v5wwsx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oMOgNv7G; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oMOgNv7G"
Message-ID: <e0e87dba-ea62-4175-b14c-34bc3753bec9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785377878;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pgPNiJk1vpm1fTtJCKVOvkh+5JiIlmzd9fP1sGBXaEM=;
	b=oMOgNv7Ge1rkU34g/1shs32iNJW9cvRyldH5wVhq08dOedhJLC/p122brJzOkyvE2uF5EY
	gxf0ACscCxuY89IfUFmfRw1Kccv8g/NAmfBx32Wcd7jcMeyIp8EBsqxQeNdjiF6YTaJcwy
	+7PpBSuVLFehwxefB/T5sb0zs2fxYm0=
Date: Thu, 30 Jul 2026 10:17:36 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v8 5/5] smb/client: refresh allocation after EOF-extending
 fallocate
To: Paulo Alcantara <pc@manguebit.org>, smfrench@gmail.com,
 linkinjeon@kernel.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
 dhowells@redhat.com, metze@samba.org, chenxiaosong@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
 Roberto Bergantinos Corpas <rbergant@redhat.com>
References: <20260703053300.913371-1-huiwen.he@linux.dev>
 <20260703053300.913371-6-huiwen.he@linux.dev>
 <97c0ca61c2bed2d2559b32b7ed967121@manguebit.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: hehuiwen <huiwen.he@linux.dev>
In-Reply-To: <97c0ca61c2bed2d2559b32b7ed967121@manguebit.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Paulo,

Thanks for the report.

The generic/103 failure is expected because it allocates almost all free 
space. Using separate filesystems for the test and scratch shares avoids it.

I have reproduced the generic/590 failure and am investigating it.

Thanks,
Huiwen


在 2026/7/30 06:54, Paulo Alcantara 写道:
> Huiwen He <huiwen.he@linux.dev> writes:
> 
>> From: Huiwen He <hehuiwen@kylinos.cn>
>>
>> Before this change, xfstests generic/496 was not supported on ksmbd:
>>
>>          generic/496 ... [not run] fallocated swap not supported here
>>
>> ksmbd handles SetEOF as truncate, so EOF extension alone does not
>> allocate backing blocks. A fallocated swapfile can therefore still
>> look sparse to swapon.
>>
>> Request allocation for EOF-extending fallocate ranges that can be
>> represented by FILE_ALLOCATION_INFORMATION, and refresh the allocation
>> state afterwards.
>>
>> With this change, xfstests generic/496 and generic/701 pass on ksmbd.
>>
>> However, Samba "strict allocate = no" now exposes the real generic/701
>> failure: the old pass came from inflated local i_blocks, not from
>> server allocation. generic/213 also fails in that case because an
>> oversized allocation request may not return ENOSPC.
>>
>> Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
>> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> This patch regressed fstests generic/103 and generic/590 against samba
> 4.24 (strict allocate = yes) with a 15G xfs partition for both test and
> scratch shares.  The tests now fail with -ENOSPC.
> 
> A simple reproducer
> 
> 	$ mount.cifs //samba-fs0/scratch2 /mnt/1 -o username=xxx,password=yyy
>          $ df -h /mnt/1
> 	Filesystem            Size  Used Avail Use% Mounted on
> 	//samba-fs0/scratch2   15G  326M   15G   3% /mnt/1
> 	$ xfs_io -c "falloc 0 8G" -f /mnt/1/file
> 	fallocate: No space left on device

