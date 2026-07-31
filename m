Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE093AEF3A
	for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 08:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785485511; cv=none; b=gtcRGdkYxTIzGsF9DKKSuLavf1SPUnwjZ+RKet8x4RPtOmXp/BrH7AmpqApr/KCmI8zy/PUty2aTezwc5EnnP3UmmABf9+L/9wrJmHJx+rSueUvhcbI44/OPc818qiYliUEgKThoWiL4qzWm/S31hC4GAU/Z1T30WKxBTENYhgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785485511; c=relaxed/simple;
	bh=PAhTspuxARsiFdMDzY1HhwSSfPM9vfrBUNFDBPt6bAg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a9EH3Aqy1PExHcRXlwZoixgowVZuAZy9Gn5+W0RwZwYfUC4+UZbpI4pLhoDCakIvaLq7oN4E9E/+iwGbnW0GDGSqrSx8JyI6Xb/qJBNtioa0+XCy0Uy/wWsf/8C9SGjR+H3/EDeiYXhKSD6G0uf57gUXjYwgzVAKz5EC8AyxQ0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Qb9LvaX5; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Qb9LvaX5"
Message-ID: <45781734-3c48-46be-9505-23e4e7580a85@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785485496;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lwWCHq+ivWtpMhnOZYHGtprulMhWyq3kqN0Db8XUKDA=;
	b=Qb9LvaX5R9FnqYC3zdo0EA+ftd0JSfNhvYsECWORosK+rkHTs8dB6KK14OV7itHpIh/IvG
	IgrZCZ0hhMcx9VDEuphQYL13OieuMGa7ckQw59qXLssRQiWtRk1w8BJonhPND3LQ5IGHl3
	2mEtWKWkZ7We61oJZSWjVOQ4vG48UELQjCle124eCZ/cS92INjvj1Q4/SNl+ckUAUiFYhe
	NdwrgQ1CBcPea8+0m0L/vo+FLV32FfJOL8XjymuCos0AB9RthKaVKOO8WZFr9QtCiWULg3
	xhzDtiZoveDJwXoI43ywi7KrA5YSvtd0ZT0hHUwTbwzINxZle3WqXJS09TPQUg==
Date: Fri, 31 Jul 2026 16:10:30 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] ksmbd: preserve STATUS_ACCESS_DENIED for copychunk errors
To: raoxu <raoxu@uniontech.com>, linkinjeon@kernel.org
Cc: smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <2DC5EE1DC892643F+20260731072020.1307022-1-raoxu@uniontech.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <2DC5EE1DC892643F+20260731072020.1307022-1-raoxu@uniontech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>

On 7/31/26 15:20, raoxu wrote:
> From: Xu Rao <raoxu@uniontech.com>
> 
> fsctl_copychunk() maps errors from ksmbd_vfs_copy_file_ranges() to SMB
> status codes. For -EACCES it first sets STATUS_ACCESS_DENIED, but the
> following -EAGAIN test starts a separate if/else-if chain. Because
> -EACCES does not match that chain, its final else immediately overwrites
> the status with STATUS_UNEXPECTED_IO_ERROR.
> 
> MS-SMB2 section 3.3.5.15.6 requires FSCTL_SRV_COPYCHUNK and
> FSCTL_SRV_COPYCHUNK_WRITE to fail with STATUS_ACCESS_DENIED when the
> source open lacks FILE_READ_DATA or the destination open lacks
> FILE_WRITE_DATA or FILE_APPEND_DATA. ksmbd_vfs_copy_file_ranges()
> returns -EACCES when its source or destination access check fails, so the
> current control flow reports a protocol-visible permission failure as an
> unrelated I/O error.
> 
> Make the -EAGAIN condition part of the same else-if chain so the -EACCES
> mapping is preserved.
> 
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: stable@vger.kernel.org
> Signed-off-by: Xu Rao <raoxu@uniontech.com>
> ---
>   fs/smb/server/smb2pdu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index bec692bca1ca..416bf1e55c81 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -8524,7 +8524,7 @@ static int fsctl_copychunk(struct ksmbd_work *work,
>   	if (ret < 0) {
>   		if (ret == -EACCES)
>   			rsp->hdr.Status = STATUS_ACCESS_DENIED;
> -		if (ret == -EAGAIN)
> +		else if (ret == -EAGAIN)
>   			rsp->hdr.Status = STATUS_FILE_LOCK_CONFLICT;
>   		else if (ret == -EBADF)
>   			rsp->hdr.Status = STATUS_INVALID_HANDLE;
> --
> 2.50.1
> 
> 

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

