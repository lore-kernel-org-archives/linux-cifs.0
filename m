Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9CC376A14
	for <linux-cifs@vger.kernel.org>; Fri, 10 Jul 2026 06:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783666188; cv=none; b=jhMqV3gqZRPvV2v+R4sJktFYWC225+mr5JrJz+b6HHw1EMbxcT2SjkiGeVwxi7PT6gGjLP7I4esnr/XwSjkfEhEizoDFnnTw7S4iFuuK98kg6ox20RsB1iuMHR8HJiWVoEIdLotlL+oBKey0HvmowAH+jqJ4t78MGYFRg+5+4Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783666188; c=relaxed/simple;
	bh=rCGWX2N/006Q9e5rNSiRH0ZjTO5Beb8Z2zb7f4MDzIQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iLbao02Dnc5t/uvhR4/xsZyeN58BtKfYRsxvHEWpLJp89pMtXQkK4kc5Fckf8FE1bnslrQx48OIBSnIk+/Jb2MFzuPbqJh8HxxLUMZJSMhGTRJ0oX5c7mTPcT1DkFrrVCdQmhJ4SbAu6ix4CKR96xMTzLqqNXq8LdPNiIFWEIYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=BzjKCL3p; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="BzjKCL3p"
Message-ID: <882a42e8-bf41-4f7c-a30f-e9d2fe44c49d@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1783666182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tE9BCyYRs2RfsB/Ynu9AsWIpgqcBFEbroZIxksOLJ3A=;
	b=BzjKCL3pNL77mr055v9tHqoNJFUYr4WoiG02wSC1ZNOzUA2Ue9cTcpD9AfvEtVH5JwP/mN
	zi0S7pmfOaPdvsP8o4hqspEfyTk4457HWNZR7Ww/NmCNvUZRM5KOxDnAIZt7OZZDCxgAUv
	d5TgrWP4nl+peMeUR8Qs5Q5Qx0FBL/6wpszhOu3X/Rhr3CnUTPpE+ZzPRV5gHKGOOI5Tww
	aPsVo5P4dERgSkckLjPwhI3so0RG/VO4/Ir+nDPzTCiW+TAaZUjQF2ltqCS8nk80PVnlnE
	W61bUP2LkypNpadYoO4ookzh2q7NWG9HCNgpAV7fVTluBKDmKScBYk+i/p8Apw==
Date: Fri, 10 Jul 2026 14:48:50 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 4/6] ksmbd: defer CHANGE_NOTIFY completion instead of
 STATUS_NOT_IMPLEMENTED
To: =?UTF-8?Q?Ga=C3=ABl_Blivet?= <gael.blivet@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org
References: <20260709000618.66534-1-g.blivet@me.com>
 <20260709000618.66534-5-g.blivet@me.com>
 <cb3e2376-88ae-4020-9417-ff925cadd8c0@chenxiaosong.com>
 <36FFCEFB-8E41-4EB6-B835-0B440C9F4A52@gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <36FFCEFB-8E41-4EB6-B835-0B440C9F4A52@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Gaël,

Thanks for your patches.

I mean sending STATUS_CANCELLED in smb2_notify() (not in 
smb2_notify_cancel_fn()). The event notification and STATUS_CANCELLED 
response should be handled in smb2_notify().

You can refer to the implementation of smb2_lock():

```
int smb2_lock()
{
     smb2_send_interim_resp(work, STATUS_PENDING);
     ksmbd_vfs_posix_lock_wait(flock); // woken up by 
smb2_remove_blocked_lock()

     smb2_send_interim_resp(work, STATUS_CANCELLED);
     work->send_no_response = 1
}
```

I have already implemented the complete notify feature, but since my 
patch series is quite large, I still need to make some changes and split 
it into smaller patches that are easier to review.

On 7/10/26 13:59, Gaël Blivet wrote:
> Because cancel_fn runs under conn->request_lock, smb2_cancel() holds it as a spinlock while walking async_requests, so cancel_fn can’t sleep. ksmbd_conn_write() takes conn->srv_mutex and can block on the actual socket write too, so calling it there directly would mean sleeping under a spinlock.
> 
> smb2_notify_cancel_fn() only does the non-sleeping parts inline (list removal, freeing cancel_argv, releasing the async id), same as smb2_remove_blocked_lock() elsewhere in this file, and pushes the actual response send to a workqueue.

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

