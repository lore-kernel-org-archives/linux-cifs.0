Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25C19168BD
	for <linux-cifs@vger.kernel.org>; Fri, 12 Sep 2025 01:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757639583; cv=none; b=NEKBE3QbFQ3MRpW7AiSt8w7puTMA0aWSUIrxPBkWalnCTCJN+Ru0CVJLYiTV9qqCnXGi+trc7HR2Z3376SxfdU/X6fl55HFQh87eBjRbf4GrTx12BBRw8BPwGEJmI8Xt9eraTgvx1EIUhFz1UoY4EqZEPGRtHd2mZZaevMRqGo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757639583; c=relaxed/simple;
	bh=lLyZrw2eC1dRC4NgNv7Uqk4TIEyF+RQuSowo4CthPh4=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=CLHx3WSXUUL3u2Ygzk/u6oaWxPYfDLlCScThVbCqtFmMbPfQMulTPdXiCMzamGtIQ51xrNlV2/jBJVP+ewzqaBuF9UzgT4AOUU6edbVsMfVCIE5kXln69bAbgH8qbFym6OYjVqfOFeGGor8J+/ge+/fkRVYZ0WSh6lSyLRVkaAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cNGWr1LtPz2CgZp;
	Fri, 12 Sep 2025 09:08:24 +0800 (CST)
Received: from kwepemf100006.china.huawei.com (unknown [7.202.181.220])
	by mail.maildlp.com (Postfix) with ESMTPS id 203FA1400DC;
	Fri, 12 Sep 2025 09:12:57 +0800 (CST)
Received: from [10.174.177.210] (10.174.177.210) by
 kwepemf100006.china.huawei.com (7.202.181.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 12 Sep 2025 09:12:56 +0800
Message-ID: <fce6ed78-87b4-2656-d8b1-02a83c8e1f91@huawei.com>
Date: Fri, 12 Sep 2025 09:12:55 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v3] cifs: fix pagecache leak when do writepages
To: Matthew Wilcox <willy@infradead.org>, David Howells <dhowells@redhat.com>
CC: <sfrench@samba.org>, <gregkh@linuxfoundation.org>, <pc@manguebit.com>,
	<sprasad@microsoft.com>, <tom@talpey.com>, <linux-cifs@vger.kernel.org>,
	<samba-technical@lists.samba.org>, <stable@kernel.org>,
	<nspmangalore@gmail.com>, <ematsumiya@suse.de>, <yangerkun@huaweicloud.com>
References: <2780505c-b531-7731-3c3d-910a22bf0802@huawei.com>
 <20250911030120.1076413-1-yangerkun@huawei.com>
 <1955609.1757607906@warthog.procyon.org.uk>
 <aMMSNnJA6VknuVMB@casper.infradead.org>
From: yangerkun <yangerkun@huawei.com>
In-Reply-To: <aMMSNnJA6VknuVMB@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemf100006.china.huawei.com (7.202.181.220)



在 2025/9/12 2:17, Matthew Wilcox 写道:
> On Thu, Sep 11, 2025 at 05:25:06PM +0100, David Howells wrote:
>> yangerkun <yangerkun@huawei.com> wrote:
>>
>>>>      	if (folio->mapping != mapping ||
>>>>    	    !folio_test_dirty(folio)) {
>>>>    		start += folio_size(folio);
>>>> +		folio_put(folio);
>>>>    		folio_unlock(folio);
>>>>    		goto search_again;
>>
>> I wonder if the put should be prior to the unlock.  It probably doesn't matter
>> as we keep control of the folio until both have happened.
> 
> Well, folio->mapping != mapping is the condition for 'this folio has
> been truncated', so this folio_put() may well be the last one.  I'd
> put it after the folio_unlock() for safety.
>>
> 

Thanks for pointing this out. Yes, I have check usage from other file
systems; using folio_put after folio_unlock is a better approach.

Thanks,
Erkun.
