Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A4345010;
	Tue, 25 Jun 2024 02:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719283193; cv=none; b=jg5awcM102PGYmry4yq/o099HdkBMyEftxNGokwGAz/sXxjbgtsLMRLZpkQFECx5ZFVlm/Ys6inEN2//9KO3R9cXj2B3O4E5hx1NC0g+W4q6uoCyLC8FGxEcjhtEvUdicz5gAlvjFfsGENBi6faSYZFprEUTOBT2oBIkycea0Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719283193; c=relaxed/simple;
	bh=zxUylimfg9YquQ0fVp0lv45GHnDmOpG4Uq0Inj3iK2o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AEsR898W2knMZLbVtEnu+0qT3fstO8VfU8GBZuEf7yXmjw9/zqbHdIJikEv/mCMX0LlTvKNUwnde6VvSWCFJFRiPJScKA/yDsxFUKf02UrI9lF6UL7VwR2N51ovPiJji8yjh3fy21eLAKdZSQFm/sK14qkLTUIYxMyORGpQUDx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4W7TYs2p1Yz4f3lfp;
	Tue, 25 Jun 2024 10:39:29 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 765931A0181;
	Tue, 25 Jun 2024 10:39:41 +0800 (CST)
Received: from [10.174.177.210] (unknown [10.174.177.210])
	by APP2 (Coremail) with SMTP id Syh0CgBn0YbjLXpm5bsQAQ--.59262S3;
	Tue, 25 Jun 2024 10:39:39 +0800 (CST)
Message-ID: <e4c0a9d5-95f1-2abe-a0b7-00ab3224f2d6@huaweicloud.com>
Date: Tue, 25 Jun 2024 10:39:31 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 6.6~6.9] cifs: fix pagecache leak when do writepages
To: Greg KH <gregkh@linuxfoundation.org>, Yang Erkun <yangerkun@huawei.com>
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 dhowells@redhat.com, linux-cifs@vger.kernel.org, stable@vger.kernel.org,
 stable-commits@vger.kernel.org
References: <20240624042815.2242201-1-yangerkun@huawei.com>
 <2024062422-imaging-evaluate-3f85@gregkh>
From: yangerkun <yangerkun@huaweicloud.com>
In-Reply-To: <2024062422-imaging-evaluate-3f85@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBn0YbjLXpm5bsQAQ--.59262S3
X-Coremail-Antispam: 1UD129KBjvJXoW7urWxAFyfAw17Cr17Zr47Arb_yoW8WrWUpF
	WUC3Z8Ar4jyryakFnIyayqvFy5t3y8Jry5WFy3J3W293WFqryagry0g3yq9FZrG3s3Wr4I
	qF4jyF9Yg3W8XaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvIb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IE
	e2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxV
	Aqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q
	6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6x
	kF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE
	14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf
	9x07UX4SrUUUUU=
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/



在 2024/6/24 22:57, Greg KH 写道:
> On Mon, Jun 24, 2024 at 12:28:15PM +0800, Yang Erkun wrote:
>> After commit f3dc1bdb6b0b("cifs: Fix writeback data corruption"), the
>> writepages for cifs will find all folio needed writepage with two phase.
>> The first folio will be found in cifs_writepages_begin, and the latter
>> various folios will be found in cifs_extend_writeback.
>>
>> All those will first get folio, and for normal case, once we set page
>> writeback and after do really write, we should put the reference, folio
>> found in cifs_extend_writeback do this with folio_batch_release. But the
>> folio found in cifs_writepages_begin never get the chance do it. And
>> every writepages call, we will leak a folio(found this problem while do
>> xfstests over cifs).
>>
>> Besides, the exist path seem never handle this folio correctly, fix it too
>> with this patch.
>>
>> The problem does not exist in mainline since writepages path for cifs
>> has changed to netfs. It's had to backport all related change, so try fix
>> this problem with this single patch.
>>
>> Fixes: f3dc1bdb6b0b ("cifs: Fix writeback data corruption")
>> Signed-off-by: Yang Erkun <yangerkun@huawei.com>
>> ---
>>   fs/smb/client/file.c | 16 +++++++++++++---
>>   1 file changed, 13 insertions(+), 3 deletions(-)
>>
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>      https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
> 
> </formletter>

Thanks for your reminder, will do it in v2!

