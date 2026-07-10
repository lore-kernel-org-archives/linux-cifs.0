Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5DD449988
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 07:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783667079; cv=none; b=bC6ocl5fKYeSXEuSd1TwFRnCg/4LrYIJOgBBtZTr7Q1ZURcGZp19aZFLFat5M/+l9jmInACD1S1MZjLk4VQL7xZmHx35LJPRjBEN3fgUafcGyNzA9UeFM870EYL1NQyoynFERyuCzEfBKDm7xWaP7vTjFiY9Ri39NdIKKCstHN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783667079; c=relaxed/simple;
	bh=a/iBLADqUDfya8e+6SeStIL3yodO/v6e4WmVFMuvXUI=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=VFgSVBsG/7oSdtb0wvg4HAp7EWfsicfy3yqctEgCs7tStS9xSqPh/me8rEowIxKYPuk+thc0EEAdORF7mHQ4F8vjvNLt7all9J5E8XkHDWOUgl4ialst3WphnJbLUU/zcg+SrBzV1bObuGlghc3BCu+dAgocWBXDwfg5pgPy+DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=XRhAXc+X; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="XRhAXc+X"
Message-ID: <c9a3fe37-c999-4d0d-8ee8-a34157c8a09e@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1783667072;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O74x5Y02fp4ossnS5YgjnjclRLrW5WqIcWvGe6Mg1JI=;
	b=XRhAXc+XBRh3WbDnHBBmb1Jla1rzmWNZTxjyiO4iEUeLXcOT1Gn+ki2rf+zea1HTD4nBWt
	CnwdxUFb1PwytqPUHPvCiGNZjZg+WFzzXDEdt4FVRMyQh1yeHzXCBbtltf1qThFqOIwqeO
	FtRi04GzV0HRccbmNbGx1Hc2bqNqgiP7VmfqnuaxQm+6sCN2EiXrFWRZEMzhwa7m3DTnvK
	IWfave//TRNAnzFACUAyKRnfVWZybLCug4d7k81FmX3YlqgdA+MlsyATtNYXutfXyv3Wje
	XuddurHlC1m66EDkYJiSsJjzH2mMXuG38hPv8aa+M5BrdT2VN36Aggl7Mt7L8A==
Date: Fri, 10 Jul 2026 15:04:26 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 4/6] ksmbd: defer CHANGE_NOTIFY completion instead of
 STATUS_NOT_IMPLEMENTED
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: =?UTF-8?Q?Ga=C3=ABl_Blivet?= <gael.blivet@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
References: <20260709000618.66534-1-g.blivet@me.com>
 <20260709000618.66534-5-g.blivet@me.com>
 <cb3e2376-88ae-4020-9417-ff925cadd8c0@chenxiaosong.com>
 <36FFCEFB-8E41-4EB6-B835-0B440C9F4A52@gmail.com>
 <882a42e8-bf41-4f7c-a30f-e9d2fe44c49d@chenxiaosong.com>
Content-Language: en-US
In-Reply-To: <882a42e8-bf41-4f7c-a30f-e9d2fe44c49d@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Would it be better to do it like the following?

```
int smb2_notify()
{
     setup_async_work(..., smb2_notify_cancel_fn, ...);

     smb2_send_interim_resp(work, STATUS_PENDING);
     wait_for_completion_interruptible(); // woken up by 
smb2_notify_cancel_fn()

     if (work->state == KSMBD_WORK_CANCELLED) {
         smb2_send_interim_resp(work, STATUS_CANCELLED);
         work->send_no_response = 1;
         goto out;
     }

     // Add my implementation of notification events here.
}
```

On 7/10/26 14:48, ChenXiaoSong wrote:
> Hi Gaël,
> 
> Thanks for your patches.
> 
> I mean sending STATUS_CANCELLED in smb2_notify() (not in 
> smb2_notify_cancel_fn()). The event notification and STATUS_CANCELLED 
> response should be handled in smb2_notify().
> 
> You can refer to the implementation of smb2_lock():
> 
> ```
> int smb2_lock()
> {
>      smb2_send_interim_resp(work, STATUS_PENDING);
>      ksmbd_vfs_posix_lock_wait(flock); // woken up by 
> smb2_remove_blocked_lock()
> 
>      smb2_send_interim_resp(work, STATUS_CANCELLED);
>      work->send_no_response = 1
> }
> ```
> 
> I have already implemented the complete notify feature, but since my 
> patch series is quite large, I still need to make some changes and split 
> it into smaller patches that are easier to review.
> 
> On 7/10/26 13:59, Gaël Blivet wrote:
>> Because cancel_fn runs under conn->request_lock, smb2_cancel() holds 
>> it as a spinlock while walking async_requests, so cancel_fn can’t 
>> sleep. ksmbd_conn_write() takes conn->srv_mutex and can block on the 
>> actual socket write too, so calling it there directly would mean 
>> sleeping under a spinlock.
>>
>> smb2_notify_cancel_fn() only does the non-sleeping parts inline (list 
>> removal, freeing cancel_argv, releasing the async id), same as 
>> smb2_remove_blocked_lock() elsewhere in this file, and pushes the 
>> actual response send to a workqueue.
> 

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

