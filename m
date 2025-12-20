Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CCAE242D67
	for <linux-cifs@vger.kernel.org>; Sat, 20 Dec 2025 03:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766201175; cv=none; b=aXnxCB/mvU6zhI0HOHp+pCOLrSzDuuhGzh+ZVNspvguriDyF2/zOWpdo91AbWrer4UJCrbEtW91g4CkWJXIdJPDXk1kKwOCH3dpZAsJR6rTDabFRhV00iE2uxSabYqCqVg1e92zQy7x+WtFNHkYye9bU0r2RD0NdnI+nFzLKIy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766201175; c=relaxed/simple;
	bh=+L+tFw8jFfJHDMO3dzPfRRS2F2bpDR/3rMAiRgnlyk0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p1QimIwCSpK2gBc0UI7Psbsz5BT8F67iw+pasWuhxr8izccwFEhHbDjw65yZXdiZ7dEWt7mcQisR4aQxwu5KeOObR1NsEEv2c9rPENCkpLQB7BfvE+Lp0JPyS0ofiIpMxnnK3DNyyzndddTbvM4S0LOXtQXdy7LrKWwTr0Pdmw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QKXM6qh2; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QKXM6qh2"
Message-ID: <1534b209-eedc-4cc7-bf7b-ea98dfbed4b2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766201169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rDgXj9lFgnzAV6NHita0m9UqJTXd4laen9wb3d+Syn8=;
	b=QKXM6qh2ocr61CsA4+GK65HlxKsaZVN0FTp5P+P5e9P1VTEwzBjUcTclPGrS1V/hC5Af3j
	Zy7fH4dHGrb+uxrfYW2sAaHne/nn3/IdhasICM2ci+zJJTw4j7lfzAvCSDxuD5dBfGOoXr
	6XpiEJdYm5nGEbDmqjXbqHGBT6Nt8g4=
Date: Sat, 20 Dec 2025 11:25:47 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH RFC v3 2/3] smb/server: fix minimum SMB2 PDU size
To: chenxiaosong.chenxiaosong@linux.dev, sfrench@samba.org,
 smfrench@gmail.com, linkinjeon@kernel.org, linkinjeon@samba.org,
 pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
 dhowells@redhat.com
Cc: linux-cifs@vger.kernel.org
References: <20251219235419.338880-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251219235419.338880-3-chenxiaosong.chenxiaosong@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251219235419.338880-3-chenxiaosong.chenxiaosong@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Namjae,

Thank you for reviewing patch 01 and 03. I will update the patches 
according to your suggestions.

Do you have any suggestions for this patch 02?

Thanks,
ChenXiaoSong.

On 12/20/25 7:54 AM, chenxiaosong.chenxiaosong@linux.dev wrote:
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> The minimum SMB2 PDU size should be updated to the size of
> `struct smb2_pdu`.
> 
> Suggested-by: David Howells <dhowells@redhat.com>
> Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>   fs/smb/server/connection.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
> index f372486ebcc5..4a8eb4fef763 100644
> --- a/fs/smb/server/connection.c
> +++ b/fs/smb/server/connection.c
> @@ -296,7 +296,7 @@ bool ksmbd_conn_alive(struct ksmbd_conn *conn)
>   }
>   
>   #define SMB1_MIN_SUPPORTED_PDU_SIZE (sizeof(struct smb_pdu))
> -#define SMB2_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb2_hdr) + 4)
> +#define SMB2_MIN_SUPPORTED_PDU_SIZE (sizeof(struct smb2_pdu))
>   
>   /**
>    * ksmbd_conn_handler_loop() - session thread to listen on new smb requests
> @@ -396,7 +396,7 @@ int ksmbd_conn_handler_loop(void *p)
>   
>   		if (((struct smb2_hdr *)smb2_get_msg(conn->request_buf))->ProtocolId ==
>   		    SMB2_PROTO_NUMBER) {
> -			if (pdu_size < SMB2_MIN_SUPPORTED_HEADER_SIZE)
> +			if (pdu_size < SMB2_MIN_SUPPORTED_PDU_SIZE)
>   				break;
>   		}
>   

