Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813864334AC
	for <linux-cifs@vger.kernel.org>; Sat,  1 Aug 2026 10:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785578461; cv=none; b=by+MbL6lkGMbdHhsd5yGSKSMtNDeJJdTgy0SoaJGyLKZiDI0+8dbNQIKh9fph9Sn9nCeVev+FshmXNsOar1DDg6tVvOULlhT08D3HbOcaMym6dk/VLaJ/Yzes/ITufADMnv95X8wGwdx1DhbzIXgIgFm5RmLr8wIooVTsrSTBp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785578461; c=relaxed/simple;
	bh=84sFYpWQohbdOxYAKl2x077gQ6yCA/HHyyV2Jlieqmc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MJeK1h8GwE/9qT4XdBSDGITLTRkvwXvNRTRBNBlJthG32xbt4B3cK7HbckxnBQvE7lzQcDHIXga3xXjVkgKFh13u08UWeGr07dn695Sa2Ud76fxmKppvo4vNED+1eZMR3W/UfZcanHnfyavi2Ame55NC877J7nD8FU3mTYGH/sI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=LaJU7OvU; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="LaJU7OvU"
Message-ID: <e467c520-a2a6-47f0-8b82-626ef1cad26b@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785578454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ePVhJxZCOPwOORxFsyBf+B9mCI3Q7NZfAL69S47na/o=;
	b=LaJU7OvUwfzMJpbX43Mif0KAHohlQCotnrkmYmvoutgZzZ91H80+A7J7Cam0MobpKgRpO2
	+iuUyi84zptzcR4Df6AAgfciLgclwo21PHLA2HvkQMar8gc2B/PplmjvhcSlAd4Bpnhk9W
	/hVcJwidyJoRt4si1VOjAouG+Rnq03n6J+OhsWqaUVHOVQhHDHu9bcJCQPAR2OpmMOyvDP
	1kQUR6TTkdDZC4DtYrsDlFyCwE1NZJLU29Skoyg1gnH5XF+6z4oKI45yxgKxLeHeny1V6X
	nsH4dR+8dVzSTCz3V/w1GBQlXj8+qQlSL+0ZAuwzL3dGwb0EWZvjzgS3bFvY+Q==
Date: Sat, 1 Aug 2026 18:00:54 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] ksmbd: validate compression Flags before kvmalloc
To: Anatolii Shumak <anatoliy.shumak@gmail.com>, linkinjeon@kernel.org
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>,
 Tom Talpey <tom@talpey.com>, Sergey Senozhatsky <senozhatsky@chromium.org>
References: <20260801051953.74245-1-anatoliy.shumak@gmail.com>
 <20260801051953.74245-3-anatoliy.shumak@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260801051953.74245-3-anatoliy.shumak@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Fixes: a08de24c2b85 ("ksmbd: negotiate and decode SMB2 compression")

在 2026/8/1 13:19, Anatolii Shumak 写道:
> ksmbd_decompress_request() allocated the decompressed request buffer
> before smb_compression_decompress() rejected unknown transform Flags or
> chained mode when it was not negotiated. A remote peer could force a
> transient multi-megabyte allocation that was immediately freed on
> -EINVAL.
> 
> Validate CHAINED/NONE Flags and compress_chained before kvmalloc.
> 
> Link: https://github.com/namjaejeon/ksmbd/issues/529
> Signed-off-by: Anatolii Shumak <anatoliy.shumak@gmail.com>
> ---
>   fs/smb/server/compress.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/smb/server/compress.c b/fs/smb/server/compress.c
> index 821299888ad3..7e13cae705e2 100644
> --- a/fs/smb/server/compress.c
> +++ b/fs/smb/server/compress.c
> @@ -46,13 +46,22 @@ int ksmbd_decompress_request(struct ksmbd_conn *conn)
>   		return -EINVAL;
>   
>   	orig_size = le32_to_cpu(hdr->OriginalCompressedSegmentSize);
> +	/*
> +	 * For chained transforms the top-level header is only eight bytes; the
> +	 * Flags field overlays the first payload header. Reject unknown Flags
> +	 * and unnegotiated chained mode before allocating the output buffer.
> +	 */
>   	if (hdr->Flags == cpu_to_le16(SMB2_COMPRESSION_FLAG_CHAINED)) {
> +		if (!conn->compress_chained)
> +			return -EINVAL;
>   		out_size = orig_size;
> -	} else {
> +	} else if (hdr->Flags == cpu_to_le16(SMB2_COMPRESSION_FLAG_NONE)) {
>   		offset = le32_to_cpu(hdr->Offset);
>   		if (offset > pdu_size - sizeof(*hdr) ||
>   		    check_add_overflow(orig_size, offset, &out_size))
>   			return -EINVAL;
> +	} else {
> +		return -EINVAL;
>   	}
>   
>   	max_allowed_pdu_size = SMB3_MAX_MSGSIZE + conn->vals->max_write_size;

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

