Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E5936165A
	for <linux-cifs@vger.kernel.org>; Fri, 27 Feb 2026 05:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772171939; cv=none; b=ouPeXXP/hFKteihulseS+y1VZRZ1WIiVOGIUKcjxnDpuOZ0Mcr1OWAnkU+F//Ef4aI+s7xquwoxX0pI/UyMFiAKrbU8w+yI3A1+n8yVLpBz90IOAoL8uAhoQbbiPn5kWanq/LB6ur5RP35zQQnBe6WJf9zlmbEHBqzVy037Ckgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772171939; c=relaxed/simple;
	bh=R5qG/k+hmAaInYW4Mhrotw0UOHGN70i2u/GB2BLvtNA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fl8IroJ/ZydZwye9JkmGlChq12hhYOoPoa44clYeipv9fxq+TnLwB7tjQlEliOZLLgN3ktdw7vq7PsDedwOM9uIT26xwksvkhxmHXsXVgxaZNsjZM51y7VrBZE63mkUf7dEsKnQtR8bFN924y2GlhyApnaeQS180mRWsiHRZpIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=imcZoEly; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="imcZoEly"
Message-ID: <32c1704c-7c9e-4dbe-b852-0fff0124ddc4@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1772171933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uswi59nYo8LbWJW+6s+aTR6LDVqp79znrM6Xm/t4g5c=;
	b=imcZoEly7Qi68qdIDqi+xrPpEt6K265bwqRpSttZEe5H3W4wcN/vwAh8G0UOmB9u0QdWHS
	RCuOAR568XfDN6OS8DqSyHgIus8iClxF+EZJmcczWt93S4myb12JSifRw2N9xciloHS5gI
	yOU9BAWuZkCO7myrjqt8zrb4Lze3yCTH5EdWGb5r5GKXwFMX14HIR3ORb+35bH08PxMqY6
	D0uybkJJu47xvq8apLWiEQDfvvCAtFTkDxGzyHZnKf1o5qHZSNe6agh59p43BSeznEpS5E
	AxD6IfyD/RfUI/W73zyNw1G3p6fy6HgEFHavsq+VGo6goJXoAgstE/CEpd739Q==
Date: Fri, 27 Feb 2026 13:57:59 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] smb/server: Fix another refcount leak in smb2_open()
To: Guenter Roeck <linux@roeck-us.net>, Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260227055421.1777793-1-linux@roeck-us.net>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260227055421.1777793-1-linux@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Looks good. Feel free to add:
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>

On 2026/2/27 13:54, Guenter Roeck wrote:
> If ksmbd_override_fsids() fails, we jump to err_out2. At that point, fp is
> NULL because it hasn't been assigned dh_info.fp yet, so ksmbd_fd_put(work,
> fp) will not be called. However, dh_info.fp was already inserted into the
> session file table by ksmbd_reopen_durable_fd(), so it will leak in the
> session file table until the session is closed.
> 
> Move fp = dh_info.fp; ahead of the ksmbd_override_fsids() check to fix the
> problem.
> 
> Found by an experimental AI code review agent at Google.
> 
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> Fixes: c8efcc786146a ("ksmbd: add support for durable handles v1/v2")
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>   fs/smb/server/smb2pdu.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index 95901a78951c..8b680c96ee44 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -3011,13 +3011,14 @@ int smb2_open(struct ksmbd_work *work)
>   				goto err_out2;
>   			}
>   
> +			fp = dh_info.fp;
> +
>   			if (ksmbd_override_fsids(work)) {
>   				rc = -ENOMEM;
>   				ksmbd_put_durable_fd(dh_info.fp);
>   				goto err_out2;
>   			}
>   
> -			fp = dh_info.fp;
>   			file_info = FILE_OPENED;
>   
>   			rc = ksmbd_vfs_getattr(&fp->filp->f_path, &stat);
