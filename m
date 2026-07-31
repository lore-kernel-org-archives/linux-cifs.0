Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF313128D7
	for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 08:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785485848; cv=none; b=koCv3grZ6ZfprJqDjhTnDR6mUvgsLB5EqyUA4+DVPx9Va4CLo3VOve9SZTfCHXZZuKsmgeor9gibAh/nNIjeOKsTgg97c1eie3E7h4f3FS86X9CdPN6DdObACFtTLjz3U7eDIcMbZiUXX6jmv3zwrrXQgZ93sOMrB67qvjm/Sk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785485848; c=relaxed/simple;
	bh=9HkJu16Qqme057qDmoBv9OKkWN/cksyuO4OQj9OkXZE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UNsNEB6+JYqjzbi/XZUBpq5I/tqxVoEOMcM/3AkfJM9r9b8+KPiqZSUdQPFOvwrzkVwQiguPD8J7ktXhDZKJe/0h4sIQmna3PYOfN/eYxEmDx5Dk95bvpO4Tp0Q/1V8X844PxuXznBUO61khVO+XNvSwdCGVGgQXaCbvpTFHBpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=rbhOpobG; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="rbhOpobG"
Message-ID: <b6bba308-d5f9-4477-8ad6-a20d8dea1035@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785485831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+0eF+VRa661pICkMt7IXuV/9YFZKNTGER5IeUQ7iSrg=;
	b=rbhOpobGblVU4yvlsbem4CfjuhqD7jETNUarDCkbgHEYA1WWajBwuKYu2Qsqd1WbqWnkZN
	Jqq7jM5JduY9aNwbSDjosAViORSkR6faE91XHP3SFuWC0nX3ON6Ozjs4Xn19F8ZiVe6FNZ
	g2hXu4NGSEZi45fdGWlOtFNiEd5LZGKAPubeSIAv+LKs+aXfu7UAP3q8dp3LOEmx8wfqwR
	2STehkGHr21UmHizvh1mqH5b27ehWttH6I0qEok5/+Ku3aW0M8712M2j4ev9UzXZh+MRQ0
	wpM572jRCXGCvT/k9SeWdaVm2f32PrJH0lDRlvhiH1yNgAvEEv813Mya/xbL3g==
Date: Fri, 31 Jul 2026 16:16:09 +0800
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

Thanks for your patch. This bug has already been fixed in the 
ksmbd-for-next-next branch:
https://github.com/smfrench/smb3-kernel/commit/35e11e324a2f97d2974ef08d308063c9c5f9e9d8

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

