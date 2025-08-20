Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D263527877B;
	Wed, 20 Aug 2025 12:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755691726; cv=none; b=DaMoF4rhhbgl4kMH+6OzEWBix+tpsOjJYsoy72ChRXHUdtCZOnTRZ79PmoaR/2dDgk2W9Ni+uxYVpvzK4Vrpe2LtgYkCYpNegJYmwmZ5Mya70dAs8pThseZ9FFeyWUsuGiQZwJJcRu2OTrsLJPojPdoek4sFtgXaWEqb8wGPq3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755691726; c=relaxed/simple;
	bh=s0lv2UXp8yblsgF0Qbsw03+rd1UZg+LE/tfgGXntx+Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qJhXgfjpNzen2uafZlk2NalZNY0NICxm/J9Z0mdII9SM98JgNbHpFwrxz1EZo20vCOi18gW4KWnXGgpmBAiWQwM58fTZEjU30icXQSlIlRODLA7IbNum6geG0vixpBERoG4hL4hrOTLkgKxCa0Kk72HLxaz9X6sxQai8eEX5jA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4c6QGK2fHmzKHMZj;
	Wed, 20 Aug 2025 20:08:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id CA5DF1A0E87;
	Wed, 20 Aug 2025 20:08:40 +0800 (CST)
Received: from [10.174.178.209] (unknown [10.174.178.209])
	by APP4 (Coremail) with SMTP id gCh0CgDnrxDEuqVoOGlLEQ--.60351S3;
	Wed, 20 Aug 2025 20:08:38 +0800 (CST)
Message-ID: <f0447b4b-3068-4943-a2a8-782308311cfe@huaweicloud.com>
Date: Wed, 20 Aug 2025 20:08:36 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] smb: client: Fix mount deadlock by avoiding super
 block iteration in DFS reconnect
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: sfrench@samba.org, pc@manguebit.org, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
 chengzhihao1@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
References: <20250815031618.3758759-1-wangzhaolong@huaweicloud.com>
 <aKQKsS1Vv8joDjo8@stanley.mountain>
From: Wang Zhaolong <wangzhaolong@huaweicloud.com>
In-Reply-To: <aKQKsS1Vv8joDjo8@stanley.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgDnrxDEuqVoOGlLEQ--.60351S3
X-Coremail-Antispam: 1UD129KBjvJXoW7AF4UAr1UtrW7Aw47AFy3CFg_yoW8trWrpF
	yFkrsrKF4DZr17u3W8Zw1xu3W7tw48G3W5GF1Yqw17ta98Gr92kF4kKr1FgF4xC39Y9a42
	qF4DKFWfKFyjyFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyGb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU17KsUUUUUU==
X-CM-SenderInfo: pzdqw6xkdrz0tqj6x35dzhxuhorxvhhfrp/





> On Fri, Aug 15, 2025 at 11:16:18AM +0800, Wang Zhaolong wrote:
>> diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
>> index f65a8a90ba27..37d83aade843 100644
>> --- a/fs/smb/client/dfs.c
>> +++ b/fs/smb/client/dfs.c
>> @@ -429,11 +429,11 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon)
>>   				       tcon, tcon->ses->local_nls);
>>   		goto out;
>>   	}
>>   
>>   	sb = cifs_get_dfs_tcon_super(tcon);
>> -	if (!IS_ERR(sb))
>> +	if (!IS_ERR_OR_NULL(sb))
>>   		cifs_sb = CIFS_SB(sb);
>>   
> 
> This is a bad or incomplete fix.  When functions return BOTH error
> pointers and NULL it MEANS something.  The NULL return in this case
> is a special kind of success.
> 
> For example, if you look up a file, then the an error means the
> lookup failed because we're not allowed to have filenames '/' so that's
> -EINVAL or maybe there was an allocation failure so that's -ENOMEM or
> maybe you don't have access to the directory so it's -EPERM.  The NULL
> would mean that the lookup succeeded fine, but the file was not found.
> 
> Another common use case is "get the LED functions so I can blink
> them".  -EPROBE_DEFER means the LED subsystem isn't ready yet, but NULL
> means the administrator has deliberately disabled it.  It's not an error
> it's deliberate.
> 
> It needs to be documented what the NULL returns *means*.  The documentation
> is missing here.
> 
> See my blog for more details.
> https://staticthinking.wordpress.com/2022/08/01/mixing-error-pointers-and-null/
> 
> regards,
> dan carpenter


Hi Dan,

Thank you for your valuable feedback and the insightful blog post. You're
absolutely right - mixing error pointers and NULL without clear semantics
is problematic.

I've just posted a v5 patch [1] that takes a completely different approach:

- Removes cifs_get_dfs_tcon_super() entirely (no more ERR_PTR/NULL confusion)
- Directly updates DFS mount prepaths without searching through superblocks
- Eliminates the deadlock by avoiding iterate_supers_type() completely

Thank you again for catching this issue - it led me to a much better
solution.

[1] https://lore.kernel.org/all/20250820113435.2319994-1-wangzhaolong@huaweicloud.com/

Best regards,
Wang Zhaolong

