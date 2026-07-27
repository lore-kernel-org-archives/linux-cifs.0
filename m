Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC45270540
	for <linux-cifs@vger.kernel.org>; Mon, 27 Jul 2026 13:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785159042; cv=none; b=m5CGz/qpOJWd5WzIc42LIWftfe2mgZkUBQ2Qne1vx7iwk/uvkgme/oRMBxC+C6lcuBWrGC5h4Gw7S003LrATuLKZHX7tJY0yK32FeRWMngKmwrGumDBF0WrSnWnjgR/VKzPg7e0mrC0hWuCpTyRZNJ8ZthlTxitFAMFy8d/FDeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785159042; c=relaxed/simple;
	bh=tw8mWDAdFoS6B5c1gd9DQWUBypy+ZmSSsSwcfuQk42A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d4EJV97vNyvfmn1jCAlwFa4npRQpJLDbc85A6gvHYbnBbwNqtHUVixvLywQodOSlxEsrAtOzXt875K/u8x2afXLXTHmReIHIF0qzj8C53Z5byI5Uc5GpzSBKINLyhw++/JY8sl4E3ZLoxUrBjBpIDx1QgduR6mHaMTr3mDwMzyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=UoP2/gY8; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="UoP2/gY8"
Message-ID: <02e13173-b4b1-4de2-a58a-b5627799b94d@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785159026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cn3U9SUi7cQpdQpK0cbUf6QZl6pCgdH3mtPucanWDXI=;
	b=UoP2/gY8Olm4YKhbfadDIBYSxGE/Ah3xJauYLJ80LffJg+HZxcv2+suW4Lem1gAABnV7Ru
	ExlwjG+uTvlLZLPoH6+6NjDHhs25F82BbEIKCFvkcWar17fU5SK2gF9SqPoGDB7cqjirsB
	V1DuBr/FKYaBStS9/vOovTBOrk4fT6NnpxdJRiNKRHLJ3vbifFWlfJSeW3hegafOiU0lv7
	X7KyVTWDPFzRcf/zNIxUeG4u06sLZ3TqC2v7mS3cbciTDCWEnPJEBU5YRr4vpIRBve2Zj0
	R3sjkgEq1YhOEap2ZGL7mzNf1bzXsg4JtRfbY7zxhiubl+ECuIXQ/TGkOunbYg==
Date: Mon, 27 Jul 2026 21:30:25 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] smb: client: free partially allocated transform folio
 queue
To: Yichong Chen <chenyichong@uniontech.com>, Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
References: <20260704052714.428561-1-chenyichong@uniontech.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260704052714.428561-1-chenyichong@uniontech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>

在 2026/7/4 13:27, Yichong Chen 写道:
> netfs_alloc_folioq_buffer() may leave a partially allocated folio
> queue attached to the caller's buffer pointer when it returns an error.
> 
> smb3_init_transform_rq() stores the buffer in the request only after
> allocation succeeds, so the common error path cannot free a partial
> allocation. Store the buffer pointer before checking the return value so
> err_free releases it.
> 
> Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
> ---
>   fs/smb/client/smb2ops.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 199f6aeb7b33..3fe9f0534e42 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -4882,10 +4882,10 @@ smb3_init_transform_rq(struct TCP_Server_Info *server, int num_rqst,
>   			size_t cur_size = 0;
>   			rc = netfs_alloc_folioq_buffer(NULL, &buffer, &cur_size,
>   						       size, GFP_NOFS);
> +			new->rq_buffer = buffer;
>   			if (rc < 0)
>   				goto err_free;
>   
> -			new->rq_buffer = buffer;
>   			iov_iter_folio_queue(&new->rq_iter, ITER_SOURCE,
>   					     buffer, 0, 0, size);
>   

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

