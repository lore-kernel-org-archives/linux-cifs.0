Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D98248880
	for <linux-cifs@vger.kernel.org>; Sun, 26 Jul 2026 08:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785054345; cv=none; b=ba+zRqj17aCENQuY+6FmoOyejruv/kM9XBhAGgRAER0cBGqMl+hChilMq97obAzeuF0IBLPx0EKBZa+5H41nyen/Dtz1MLoQGtJhbdcqOIFAybN7m93q0MEZBuAiSv+NcRCTNp6uCAn09X9ymsD028UycJGnY9z0IVvyte8u26E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785054345; c=relaxed/simple;
	bh=dNGCx1QMdn3hK3+SWsAiv1FR70COGZNDt5UodkLcXSQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=INB3pd//b1vZJtYNynIQBrYpvy4VuEHpFJ5VVjKYFUCf8KssnPDuHVLd6HSSaTgMIlXGqH7J1O1zp7e55x9ThykpGC4l+gH6PjRv/BiGM8UEozsrureanZE21FXoJvSh+UH35d+ggN71ImVzHUrRRxSQwgYALlNJe3jm9jeOrCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Mn0ZcAs0; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Mn0ZcAs0"
Message-ID: <627eb275-ca13-468c-87fa-f40c4e887145@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785054338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nHCEBajOi+E4/eqrgmq95734zrgdRT00bLBVczrxDTw=;
	b=Mn0ZcAs0klcDN+SEa15UbCU+Fc8bb6dZYPM2YvCOwghNYnsfB+DpvWntNLeAOqY9/M2ca7
	yTSpmJdC4VgQFR8FsZwns5vKo+u5YKSWjq4avhqvnReJafSwOEB8SZ3qPs4eCISaxdhKHc
	gc6OuVpgRhKPxfHkGO5v6w0ITXMsRJFE4Mt9aSABPpwRw0+gKnVP/4iCuwcQJP9ytC5/zv
	ceW8e7bCvulGdIYFbvfgwOcfrCp39WrhhDHKvO1o0GXsUDluOiiwicsSTPnG8StNS9SEWa
	VucaZSgg/WwFzI9EyrAP2WPX5izPPOFiHNd3Qqw7GayYgsfHJdgFtYYMfvf1GA==
Date: Sun, 26 Jul 2026 16:24:42 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2] ksmbd: refactor smb2_notify() to a blocking wait,
 matching smb2_lock()
To: =?UTF-8?Q?Ga=C3=ABl_Blivet-Bailly?= <gael.blivet@gmail.com>,
 linkinjeon@kernel.org
Cc: linux-cifs@vger.kernel.org, chenxiaosong@kylinos.cn,
 Steve French <smfrench@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>
References: <20260725102737.33616-1-g.blivet@me.com>
 <6813f121-5fe0-4542-85fa-7f06e093c24a@chenxiaosong.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <6813f121-5fe0-4542-85fa-7f06e093c24a@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Gaël,

I tested the macOS client, and it seems that this check is not needed 
either. What issue did you add this check to fix?

On 7/25/26 21:12, ChenXiaoSong wrote:
> When Windows is used as the client, this check must be removed because 
> Windows sends a compound request:
>    CREATE dir; CHANGE_NOTIFY, fid = compound fid (FFFF...FFFF)
> 
> However, I am not yet sure whether skipping this check could cause any 
> issues when macOS is used as the client. I will test it with a macOS 
> client tomorrow.
> 
> 在 2026/7/25 18:26, Gaël Blivet-Bailly 写道:
>> @@ -10967,56 +10908,17 @@ int smb2_notify(struct ksmbd_work *work)
>>       }
>> ...
>> +     * macOS backupd sends CHANGE_NOTIFY with FileId=FFFF...FFFF
>> +     * (share-root sentinel) to watch for changes on the share root
>> +     * without holding an open handle.
>>        */
>>       if (req->VolatileFileId == SMB2_NO_FID &&
>>           req->PersistentFileId == SMB2_NO_FID) {
>> ...
>> +        rsp->hdr.Status = STATUS_INVALID_PARAMETER;
>> +        smb2_set_err_rsp(work);
>>           return 0;
>>       }
> 

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

