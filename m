Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4351F4C99;
	Tue,  5 Aug 2025 16:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754412895; cv=none; b=aak1TCFI6aLpL3ItTgxcD7KAGVIOOfnbpjAE2vXKItWvMLSBva5slUuZQYRmw+2ttRIVWEaMCtsBhe2qjvGRveRYA14V7+prbr3dOn17/W8UH5y5J9dtAvuIaaHZk/NV53U+OLNie3+Y+ypsKgqyRt31PsUE0ttxegNvfuYgsPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754412895; c=relaxed/simple;
	bh=qXmkEdfK/zrsuD2vvJG7L2fd5aUMohVOhUtOW+wgXtQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M0mMOiSgPVNj4g1H9mk5etGQhBt2TsL71iqJFnUlE3nVh/zbcZqLv0R+ScmGxaB0QwkGA38XJBEK9Z+jBfX7iHyJk88Pt0yHcG5ABzxw2BrfS2vF5ZFrtTxvzt6+7d/VasUD1iSldAgr40OlXFiseYpQ2lkauMa8PoXGD1j8dKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bxKKN3dwSzKHM0M;
	Wed,  6 Aug 2025 00:54:48 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8D8A31A1432;
	Wed,  6 Aug 2025 00:54:47 +0800 (CST)
Received: from [10.174.178.209] (unknown [10.174.178.209])
	by APP4 (Coremail) with SMTP id gCh0CgDHjxBSN5Jorj21Cg--.61441S3;
	Wed, 06 Aug 2025 00:54:44 +0800 (CST)
Message-ID: <7210239c-e15b-4c35-b234-c3bc939d4ab6@huaweicloud.com>
Date: Wed, 6 Aug 2025 00:54:42 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 0/4] Fix mid_q_entry memory leaks in SMB client
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: sfrench@samba.org, pshilov@microsoft.com, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
 chengzhihao1@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
References: <20250805064708.332465-1-wangzhaolong@huaweicloud.com>
 <ci3hj5mr7a3qjx7hiuomzq4ankp7kym3sqevkll3pn4r76kb2f@rpxbkf3sqinq>
From: Wang Zhaolong <wangzhaolong@huaweicloud.com>
In-Reply-To: <ci3hj5mr7a3qjx7hiuomzq4ankp7kym3sqevkll3pn4r76kb2f@rpxbkf3sqinq>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHjxBSN5Jorj21Cg--.61441S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGw4ftw1rCw15AF18Jry3CFg_yoWrKw43pr
	4Fqw42kry8Xr1xZFsrAa4DurW8Gw4kC3W3J3y8GFySyw1Uursaqry2qrWFgry7Ar4xXr1D
	Zw1UJwnrZF1DCaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6x
	kF7I0E14v26r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE
	5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeV
	CFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY
	0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I
	0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAI
	cVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcV
	CF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIE
	c7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU17KsUUUUUU==
X-CM-SenderInfo: pzdqw6xkdrz0tqj6x35dzhxuhorxvhhfrp/


> 
> Do you have a reproducer for this?  mids are allocated from kmem cache,
> and a leak should certainly be visible (WARN on rmmod), even without any
> debugging facilities enabled.

Thanks for your reply and review!

Yes, I have the reproducer. I have listed it in the commit message.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220404

> 
> However, I do know that the following problem is quite common in cifs:
> 
> thread 0        | thread 1
> ----------------|----------------
>                  | lock
>                  | check data
>                  | data is valid
>                  | unlock
> lock            |
> invalidate data | lock (spins)
> unlock          | ...
>                  | // assumes data still valid
>                  | use invalid data (not really freed)
>                  | unlock
> 
> You see that no matter how many locks you add to protect data, there's
> still a chance of having this "race condition" feeling.
> 
> So, personally, I'm skeptical about having yet another spinlock with
> questionable or no effect at all.
> 
> But again, if I can reproduce this bug myself, it'll be much easier to
> analyse effectiveness/review your patches.
> 
> Apart from that, cleanup patches always get my +1 :)
> 



The data is interrelated, and updates to the data are protected by per-mid locks
to avoid `race condition`.

For example, in the following scenario, the update and check of
mid->mid_state are protected by the lock spin_lock(&midQ[i]->mid_lock),
which can prevent leakage issues.


```
User foreground process                    cifsd
cifs_readdir
  open_cached_dir
   cifs_send_recv
    compound_send_recv
     smb2_setup_request
      smb2_mid_entry_alloc
       smb2_get_mid_entry
        smb2_mid_entry_alloc
         mempool_alloc // alloc mid
         kref_init(&temp->refcount); // refcount = 1
      mid[0]->callback = cifs_compound_callback;
      mid[1]->callback = cifs_compound_last_callback;
      smb_send_rqst
      rc = wait_for_response
       wait_event_state TASK_KILLABLE
                                   cifs_demultiplex_thread
                                     allocate_buffers
                                       server->bigbuf = cifs_buf_get()
                                     standard_receive3
                                       ->find_mid()
                                         smb2_find_mid
                                           __smb2_find_mid
                                            kref_get(&mid->refcount) // +1
                                       cifs_handle_standard
                                         handle_mid
                                          /* bigbuf will also leak */
                                          mid->resp_buf = server->bigbuf
                                          server->bigbuf = NULL;
                                          dequeue_mid
                                      /* in for loop */
     /* Signal interrupts wait: rc = -ERESTARTSYS */
                                     spin_lock(&midQ[i]->mid_lock);
                                     mids[0]->callback
                                       cifs_compound_callback
                                        /* The change comes too late */
                                        mid->mid_state = MID_RESPONSE_READY
                                     spin_lock(&midQ[i]->mid_lock);
     spin_lock(&midQ[i]->mid_lock);
     /* if (... || midQ[i]->mid_state == MID_RESPONSE_RECEIVED) Not satisfied  *?
     spin_unlock(&midQ[i]->mid_lock);
                                     release_mid  // -1
     release_mid  // -1
```

Or, in the case where the callback is replaced

User foreground process                    cifsd
cifs_readdir
  open_cached_dir
   cifs_send_recv
    compound_send_recv
     smb2_setup_request
      smb2_mid_entry_alloc
       smb2_get_mid_entry
        smb2_mid_entry_alloc
         mempool_alloc // alloc mid
         kref_init(&temp->refcount); // refcount = 1
      mid[0]->callback = cifs_compound_callback;
      mid[1]->callback = cifs_compound_last_callback;
      smb_send_rqst
      rc = wait_for_response
       wait_event_state TASK_KILLABLE
                                   cifs_demultiplex_thread
                                     allocate_buffers
                                       server->bigbuf = cifs_buf_get()
                                     standard_receive3
                                       ->find_mid()
                                         smb2_find_mid
                                           __smb2_find_mid
                                            kref_get(&mid->refcount) // +1
                                       cifs_handle_standard
                                         handle_mid
                                          /* bigbuf will also leak */
                                          mid->resp_buf = server->bigbuf
                                          server->bigbuf = NULL;
                                          dequeue_mid
                                      /* in for loop */
     /* Signal interrupts wait: rc = -ERESTARTSYS */
     spin_lock(&midQ[i]->mid_lock);
     /* if (... || midQ[i]->mid_state == MID_RESPONSE_RECEIVED) Satisfied  *?
     midQ[0]->callback = cifs_cancelled_callback;
     cancelled_mid[i] = true;
     spin_unlock(&midQ[i]->mid_lock);
                                     spin_lock(&midQ[i]->mid_lock);
                                     mids[0]->callback
                                       cifs_cancelled_callback
                                         cifs_compound_callback
                                          /* The change comes too late */
                                          mid->mid_state = MID_RESPONSE_READY
                                         release_mid  // -1
                                     spin_lock(&midQ[i]->mid_lock);
                                     release_mid  // -1


I know this approach is quite ugly, but it is a relatively reliable
method that preserves the historical bugfix logic.

Relevant patches:

d527f51331ca ("cifs: Fix UAF in cifs_demultiplex_thread()")
ee258d79159a ("CIFS: Move credit processing to mid callbacks for SMB3")
8544f4aa9dd1 ("CIFS: Fix credit computation for compounded requests")
d7d7a66aacd6 ("cifs: avoid use of global locks for high contention data")


Thanks again for your reply. I’m looking forward to any further
suggestions you may have to improve the patch.

Best regards,
Wang Zhaolong

