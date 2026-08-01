Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D390414A22
	for <linux-cifs@vger.kernel.org>; Sat,  1 Aug 2026 09:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785577383; cv=none; b=DMee/RyESu05skQpRLskZPSaiH5b19hEwuAxiOPseW8NLp+SengGTH4oCy68zBzK+dof9MOh+umlla2fncCjKuxskYVrVBaVpHXZMWe8DHQeB+OK5qEocUQkLD/Rrpk8jyJMDTi+bHMCUDoHcF84bQMq84h/4YmsgQt1nvDGFMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785577383; c=relaxed/simple;
	bh=zAZGFJqgFsQbSYsYliZQdBgmzCknospK+ybzqxrqZI0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mvcF33lZdoH6X+Aa30fJSmKtNzL6C5xZ2I4YDXznm3+22CYHRblBpLY8hswCAzWuD6HdXGADF8rcmSFClV5jNq/IDih9pVRgQ8Igyww9XduQOD6g4SDZor76tKWnrMWCP3zjICfyKcO1+qQW4MqG8kzyFy9b4d8xnKXheEyAKd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Xu7KCAa+; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Xu7KCAa+"
Message-ID: <1b144bd5-4161-423f-84da-9b7072f56349@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785577372;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ic/4EzoPTgKxyStooPtt6w74ibgeMGHVpTzbc2OIAH0=;
	b=Xu7KCAa+yQ16HQlsAvEi66oSCuP/61SYpFExTPuz+enq4/achOEMMO7+8Bh6gFyzcVqKlK
	dKcOg/1v0k4VVqMwmwECDtEeXdfVH3h2hqP38oci4kKTxTUF60XEDtsxGXyPn9mL9/ADyx
	v6qd4BkLCRnRxGQeKojDhTu2++o31q+bVluQUDGlFiFu/+oVS+F7rY/YqxODPwqZH0dYFP
	0KxkXLepKKKdP7iYYGA8DgUvM6Xs9mvRgQUjqhyMQ04jURwTfVAmOP4g/W6KAWu8Q6AQlo
	oklUtWMH9XARz5A1jhj9+EOcTQNxsOuFutJLcN9B65Bg2pAqUxwEa6NroFbrUw==
Date: Sat, 1 Aug 2026 17:42:28 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] smb: compress: reject Pattern_V1 when not negotiated
To: Anatolii Shumak <anatoliy.shumak@gmail.com>, linkinjeon@kernel.org
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>,
 Tom Talpey <tom@talpey.com>, Sergey Senozhatsky <senozhatsky@chromium.org>
References: <20260801051953.74245-1-anatoliy.shumak@gmail.com>
 <20260801051953.74245-2-anatoliy.shumak@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260801051953.74245-2-anatoliy.shumak@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Fixes: a08de24c2b85 ("ksmbd: negotiate and decode SMB2 compression")

See MS-SMB2 3.3.5.2.1.2

By the way, smb_compression_decompress() has too many parameters, 
perhaps we can put them into a structure in the future.

在 2026/8/1 13:19, Anatolii Shumak 写道:
> Pattern_V1 is an optional chained payload type selected during SMB 3.1.1
> compression negotiate. conn->compress_pattern was only consulted when
> building responses, so a peer that negotiated LZ77 with chained support
> could still submit Pattern payloads on the receive path.
> 
> Pass allow_pattern through smb_compression_decompress() and reject
> SMB3_COMPRESS_PATTERN in the chained decoder when it is false.
> 
> Link: https://github.com/namjaejeon/ksmbd/issues/529
> Signed-off-by: Anatolii Shumak <anatoliy.shumak@gmail.com>
> ---
>   fs/smb/common/compress/compress.c | 11 ++++++++---
>   fs/smb/common/compress/compress.h |  3 ++-
>   fs/smb/server/compress.c          |  1 +
>   3 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/smb/common/compress/compress.c b/fs/smb/common/compress/compress.c
> index b07a317597a4..a4123c8f1c0a 100644
> --- a/fs/smb/common/compress/compress.c
> +++ b/fs/smb/common/compress/compress.c
> @@ -95,6 +95,7 @@ static int smb_decompress_lz77_payload(const u8 **src, u32 *slen, u8 **dst,
>   }
>   
>   static int smb_decompress_chained(__le16 alg, bool allow_chained,
> +				  bool allow_pattern,
>   				  const struct smb2_compression_hdr *hdr,
>   				  u32 slen, void *dst, u32 dlen)
>   {
> @@ -143,6 +144,8 @@ static int smb_decompress_chained(__le16 alg, bool allow_chained,
>   			rc = smb_decompress_none(&src, &remaining, &out,
>   						 &out_remaining, len);
>   		} else if (payload_alg == SMB3_COMPRESS_PATTERN) {
> +			if (!allow_pattern)
> +				return -EINVAL;
>   			rc = smb_decompress_pattern(&src, &remaining, &out,
>   						    &out_remaining, len);
>   		} else if (payload_alg == alg && alg == SMB3_COMPRESS_LZ77) {
> @@ -185,6 +188,7 @@ static int smb_decompress_unchained(__le16 alg,
>    * smb_compression_decompress() - decode an SMB2 compression transform
>    * @alg: negotiated general-purpose compression algorithm
>    * @allow_chained: whether chained transforms were negotiated
> + * @allow_pattern: whether Pattern_V1 payloads were negotiated
>    * @src: transform header followed by compressed payload data
>    * @slen: total number of bytes available at @src
>    * @dst: output buffer for the reconstructed SMB2 message
> @@ -197,7 +201,8 @@ static int smb_decompress_unchained(__le16 alg,
>    * Return: 0 on success, otherwise a negative errno.
>    */
>   int smb_compression_decompress(__le16 alg, bool allow_chained,
> -			       const void *src, u32 slen, void *dst, u32 dlen)
> +			       bool allow_pattern, const void *src, u32 slen,
> +			       void *dst, u32 dlen)
>   {
>   	const struct smb2_compression_hdr *hdr = src;
>   
> @@ -207,8 +212,8 @@ int smb_compression_decompress(__le16 alg, bool allow_chained,
>   		return -EINVAL;
>   
>   	if (hdr->Flags == cpu_to_le16(SMB2_COMPRESSION_FLAG_CHAINED))
> -		return smb_decompress_chained(alg, allow_chained, hdr, slen,
> -					      dst, dlen);
> +		return smb_decompress_chained(alg, allow_chained, allow_pattern,
> +					      hdr, slen, dst, dlen);
>   
>   	if (hdr->Flags != cpu_to_le16(SMB2_COMPRESSION_FLAG_NONE))
>   		return -EINVAL;
> diff --git a/fs/smb/common/compress/compress.h b/fs/smb/common/compress/compress.h
> index 7ace3bf4b664..d6916669f887 100644
> --- a/fs/smb/common/compress/compress.h
> +++ b/fs/smb/common/compress/compress.h
> @@ -20,7 +20,8 @@ static __always_inline bool smb_compress_alg_valid(__le16 alg, bool valid_none)
>   }
>   
>   int smb_compression_decompress(__le16 alg, bool allow_chained,
> -			       const void *src, u32 slen, void *dst, u32 dlen);
> +			       bool allow_pattern, const void *src, u32 slen,
> +			       void *dst, u32 dlen);
>   int smb_compression_compress_chained(__le16 alg, bool allow_pattern,
>   				     const void *src, u32 slen,
>   				     void *dst, u32 *dlen);
> diff --git a/fs/smb/server/compress.c b/fs/smb/server/compress.c
> index 95e48fa6b448..821299888ad3 100644
> --- a/fs/smb/server/compress.c
> +++ b/fs/smb/server/compress.c
> @@ -69,6 +69,7 @@ int ksmbd_decompress_request(struct ksmbd_conn *conn)
>   	*(__be32 *)out = cpu_to_be32(out_size);
>   	rc = smb_compression_decompress(conn->compress_algorithm,
>   					conn->compress_chained,
> +					conn->compress_pattern,
>   					buf, pdu_size, out + 4, out_size);
>   	if (rc) {
>   		kvfree(out);

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

