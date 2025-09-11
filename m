Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4389A313E32
	for <linux-cifs@vger.kernel.org>; Thu, 11 Sep 2025 11:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757588977; cv=none; b=OIssVEFsnIP+/KoKKkWgyKb3wmW70TBnOnuNKedYRlmphYm/Fr4ivvIGdYFoD8i6mpSr3NhRG6p9zCSBuGT7Zusm4d9pUUr0L+1kbIbZTDG7d3o1zFIwtBQjfZnAOYzQ43dKSAWO395ViP2lBT0I0jL4rvum62RvpFxfqCo9UTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757588977; c=relaxed/simple;
	bh=ukhOyZ356nsB3HBh5fjQxuOL3K4Fx0ZiTLRajrNttlM=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=EfkaMUfQdFQMSu8/RWm1s0mU2zDx19aUHlQepCVgf6hLQIwGCfE9bc4xqImUGZkRBOJaup8J4aBHyIQiQhDO/34hJ6F9JdqOMQ9OqhAwj3yRzMlm/uH3ewjGJ0z/1YVcFd5ZN2LnPjDZ0gQvxxJisD/JWQHsPMu+7Qrr66SZDmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cMvts23cGztTSV;
	Thu, 11 Sep 2025 19:08:37 +0800 (CST)
Received: from kwepemf100006.china.huawei.com (unknown [7.202.181.220])
	by mail.maildlp.com (Postfix) with ESMTPS id 39DE81402DB;
	Thu, 11 Sep 2025 19:09:32 +0800 (CST)
Received: from [10.174.177.210] (10.174.177.210) by
 kwepemf100006.china.huawei.com (7.202.181.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 11 Sep 2025 19:09:31 +0800
Message-ID: <ff670765-d3e2-bc0a-5cef-c18757fe3ee0@huawei.com>
Date: Thu, 11 Sep 2025 19:09:30 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v3] cifs: fix pagecache leak when do writepages
To: Greg KH <gregkh@linuxfoundation.org>
CC: <sfrench@samba.org>, <pc@manguebit.com>, <lsahlber@redhat.com>,
	<sprasad@microsoft.com>, <tom@talpey.com>, <dhowells@redhat.com>,
	<linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
	<stable@kernel.org>, <nspmangalore@gmail.com>, <ematsumiya@suse.de>,
	<yangerkun@huaweicloud.com>
References: <20250911030120.1076413-1-yangerkun@huawei.com>
 <2780505c-b531-7731-3c3d-910a22bf0802@huawei.com>
 <2025091109-happiness-cussed-d869@gregkh>
From: yangerkun <yangerkun@huawei.com>
In-Reply-To: <2025091109-happiness-cussed-d869@gregkh>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemf100006.china.huawei.com (7.202.181.220)



在 2025/9/11 18:53, Greg KH 写道:
> On Thu, Sep 11, 2025 at 11:22:57AM +0800, yangerkun wrote:
>> Hello,
>>
>> In stable version 6.6, IO operations for CIFS cause system memory leaks
>> shortly after starting; our test case triggers this issue, and other users
>> have reported it as well [1].
>>
>> This problem does not occur in the mainline kernel after commit 3ee1a1fc3981
>> ("cifs: Cut over to using netfslib") (v6.10-rc1), but backporting this fix
>> to stable versions 6.6 through 6.9 is challenging. Therefore, I have decided
>> to address the issue with a separate patch.
>>
>> Hi Greg,
>>
>> I have reviewed [2] to understand the process for submitting patches to
>> stable branches. However, this patch may not fit their criteria since it is
>> not a backport from mainline. Is there anything else I should do to make
>> this patch appear more formal?
> 
> Yes, please include the info as to why this is not a backport from
> upstream, and why it can only go into this one specific tree and get the
> developers involved to agree with this.

Alright, the reason I favor this single patch is that the mainline 
solution involves a major refactor [1] to change the I/O path to 
netfslib. Backporting it would cause many conflicts, and such a large 
patch set would introduce numerous KABI changes. Therefore, this single 
patch is provided here instead...

[1]. 
https://lore.kernel.org/all/20240328165845.2782259-1-dhowells@redhat.com/

> 
> But why not submit the upstream changes instead?  That should be much
> simpler and is always preferred as that way the code can be maintained
> easier over time.  Whenever we have these one-off changes, they are
> almost always wrong and incur additional development efforts for future
> changes in the same area.
> 
> So please, do the backports first.
> 
> thanks,
> 
> greg k-h
> 
