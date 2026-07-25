Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42125388869
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 03:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784948508; cv=none; b=gXcnlUVDwe7tyk1rLlP7D93SF2oCa2CBAsgX4tH/84IqoYQJ+viSLLEmcDsLJCmyZemH6um9j9pdu39+HXKW/jAFt0+TDnCMD0V/hw45Dry7Ma1lNStoN15c37fRl68a9PdFKmk6SkI/8wGp2eF/Y/DnwzBTof8qpzaFq/+bDVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784948508; c=relaxed/simple;
	bh=xuwzxwFrlqLfjvHeOY1Lq9g3C6CzO/r8tXUXxE0SS4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aXfwl5FYhTN33Efg3zSVp8M+HKgOzpID2bxCX1TjcniRu5YpawvMaUk+dVZ523rNMlEjWHujjxT6zoMPcQeCDTXSjilmBXBp26XwG+lrnt7mrS7rJbl6sTftLjnuou+fq+K4WZsWARSzBCINgAUNCAHXyPERM054gSrug9v3rkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=wSM2S4gQ; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="wSM2S4gQ"
Message-ID: <750e275b-a09b-41fb-a1f5-59797c61b26a@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784948494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wn7W8aj5kgrbQZfgu7GxuK8vgKVxZHld4CB9bjHnMC0=;
	b=wSM2S4gQDkRwIiwGRrOdVCVtJ25W9Qt8zJqwd4+s8paTfmm8UszCaHWsK1jZzKYqyxwwYZ
	Pt8BhGa2Ow08xDLxv2dYexKMNcBU16UBoh4q9TlA4myEc9fw69Z2B0mxYp9zHNGXwBFuoo
	wxu2y3FraLgzTFrwzOCT48eKL/WoE70jiGNoIJ+uDasucr2dVuExOkzI6hjOpPAe5vkOyd
	gV6IynPIe9TIyKAOExuG7dtEOV+wWApdQ8S8ddTG73yAyU68ZcZLsHSF3J3RmDfuQoY+5+
	nB8DD4SI7kHTKnNhP+yYjEW/ugC9NNFv+dsvgmX2GyIZpc0H4O0Mb33gtAV5Rg==
Date: Sat, 25 Jul 2026 11:00:44 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] ksmbd: refactor smb2_notify() to a blocking wait,
 matching smb2_lock()
To: =?UTF-8?Q?Ga=C3=ABl_Blivet-Bailly?= <gael.blivet@gmail.com>,
 linkinjeon@kernel.org
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>,
 senozhatsky@chromium.org, tom@talpey.com
References: <20260724150528.1762-1-g.blivet@me.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260724150528.1762-1-g.blivet@me.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Thanks for your patch.

On 7/24/26 23:05, Gaël Blivet-Bailly wrote:
>   /**
>    * smb2_notify() - handler for smb2 notify request
>    * @work:   smb work containing notify command buffer
>    *
> + * KSMBD does not implement a real change-notification backend yet.
...
> + * wait to be interrupted matters more here.

Are these comments a bit too detailed for the source code? Perhaps it 
would be better to put them in the commit message.

> @@ -10969,54 +10939,26 @@ int smb2_notify(struct ksmbd_work *work)
>   	if (req->VolatileFileId == SMB2_NO_FID &&
>   	    req->PersistentFileId == SMB2_NO_FID) {
...
>   		smb2_send_interim_resp(work, STATUS_PENDING);
> +		rsp->hdr.Status = STATUS_NOTIFY_CLEANUP;
> +		smb2_send_interim_resp(work, STATUS_NOTIFY_CLEANUP);

There is no need to send interim responses STATUS_PENDING and 
STATUS_NOTIFY_CLEANUP, just call smb2_set_err_rsp() with 
STATUS_INVALID_PARAMETER.

> @@ -11024,96 +10966,52 @@ int smb2_notify(struct ksmbd_work *work)
...
> -	in_work->owns_conn_ref = true;

Please delete owns_conn_ref in struct ksmbd_work.

> @@ -650,50 +649,15 @@ static void __ksmbd_close_fd(struct ksmbd_file_table *ft, struct ksmbd_file *fp)
> +	 * Any CHANGE_NOTIFY blocked on this handle is woken by
> +	 * set_close_state_blocked_works() (via ksmbd_close_fd()/
> +	 * ksmbd_mark_fp_closed(), both called before __ksmbd_close_fd() is
> +	 * ever reached), the same generic fp->blocked_works mechanism
> +	 * smb2_lock() uses for a pending byte-range lock -- nothing further
> +	 * to do here. The waiter holds its own reference on fp (from
> +	 * ksmbd_lookup_fd_slow()) until it finishes handling the wake and
> +	 * calls ksmbd_fd_put(), so fp can't be freed out from under it.
>   	 */

These comments can be removed, since a CHANGE_NOTIFY request blocked on 
this handle can also be woken by an event.


-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

