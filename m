Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6101C8603
	for <linux-cifs@vger.kernel.org>; Wed,  8 Apr 2026 02:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775616737; cv=none; b=TKwxMEeG8pF/ZbU1I7dgUTxjXeHBxCyEMeKPsJG9v8g7JFTk7ja8PiWfSyQQH8oe+Cbxx8b0YD66BPZ67L3YagaOe1P4kYkj7g3Adyqpp2lbGog3LGRXKzDcf53mbYiizbgnH5mhlSSrAkZIqmnwJrlOD5ptoHOQf+K5VgaZBII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775616737; c=relaxed/simple;
	bh=nme6FxSTc7mbRbT3LshL26jQ/13hHiD9tkseTjOp5VA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t/e+PGmU5xRQmonBkDbNdrS/JdlIX7xPDwugAm1UTOsXTrpNVkxLME78wMbgiDcXglV94xD6lu6Q7rILpS72+Z8XznC/V2S43Clx6HDw8kd4FwlGYXfdNuy3HtJfIu35jJ0imzBK9jqLWdxMLM8oYBo2d/c28L4LPc3VuTjHaUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=K3gra1ms; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="K3gra1ms"
Message-ID: <d998240c-aca9-420d-9dbd-f5ba24af19e0@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1775616723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VZeZ/621orAKRtRcih+/9fcqr8O8xVLcE0ya2RhxK08=;
	b=K3gra1msscHwZphZX7LSr6dVxFD8tU0jkMMJB5ci9nLjTA1DAelpdoyFPQonDyX5QrJtGx
	qrk9CcVDuvaryef9hGD1IHvMgwm6enRx9zIaZGKxc51e/2BD4ugTrXQQIzMRrShck98E7z
	Q+sSmM/fOBX6Atr5iMX5ULs6GlctktMlsg2EPZzojH+ZP7citxN9BIas3VMgQnv3cNUi0L
	JXrglFsbUdOpROw8TlUnfZXc00unqp4maKtXlS9made9tYHunCMcZ5aWG3g5ZEQOX0hQg2
	8TlB0V1rXDQtanCJfrK0hSW8CUr1YMQw7GOJCPx/zBrpkt/zLjQD7z+1lZJwJQ==
Date: Wed, 8 Apr 2026 10:51:12 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] smb: client: fix off-by-8 bounds check in
 check_wsl_eas()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-cifs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>,
 Paulo Alcantara <pc@manguebit.org>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>, samba-technical@lists.samba.org,
 stable <stable@kernel.org>
References: <2026040635-banking-unsoiled-3250@gregkh>
 <2026040636-unsigned-jackal-e239@gregkh>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <2026040636-unsigned-jackal-e239@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Sashiko reported another out-of-bounds issue: 
https://sashiko.dev/#/patchset/2026040635-banking-unsoiled-3250@gregkh

Should we add the following checks in check_wsl_eas()?

```
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -121,6 +121,9 @@ static int check_wsl_eas(struct kvec *rsp_iov)
         ea = (void *)((u8 *)rsp_iov->iov_base +
                       le16_to_cpu(rsp->OutputBufferOffset));
         end = (u8 *)rsp_iov->iov_base + rsp_iov->iov_len;
+       if (ea + outlen > end)
+               return -EINVAL;
+
         for (;;) {
                 if ((u8 *)ea > end - sizeof(*ea))
                         return -EINVAL;
```

On 4/6/26 21:49, Greg Kroah-Hartman wrote:
> The bounds check uses (u8 *)ea + nlen + 1 + vlen as the end of the EA
> name and value, but ea_data sits at offset sizeof(struct
> smb2_file_full_ea_info) = 8 from ea, not at offset 0.  The strncmp()
> later reads ea->ea_data[0..nlen-1] and the value bytes follow at
> ea_data[nlen+1..nlen+vlen], so the actual end is ea->ea_data + nlen + 1
> + vlen.  Isn't pointer math fun?
> 
> The earlier check (u8 *)ea > end - sizeof(*ea) only guarantees the
> 8-byte header is in bounds, but since the last EA is placed within 8
> bytes of the end of the response, the name and value bytes are read past
> the end of iov.
> 
> Fix this mess all up by using ea->ea_data as the base for the bounds
> check.
> 
> An "untrusted" server can use this to leak up to 8 bytes of kernel heap
> into the EA name comparison and influence which WSL xattr the data is
> interpreted as.
> 
> Cc: Steve French <sfrench@samba.org>
> Cc: Paulo Alcantara <pc@manguebit.org>
> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> Cc: Shyam Prasad N <sprasad@microsoft.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Bharath SM <bharathsm@microsoft.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Cc: stable <stable@kernel.org>
> Assisted-by: gregkh_clanker_t1000
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   fs/smb/client/smb2inode.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index 364bdcff9c9d..fe1c9d776580 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -128,7 +128,7 @@ static int check_wsl_eas(struct kvec *rsp_iov)
>   		nlen = ea->ea_name_length;
>   		vlen = le16_to_cpu(ea->ea_value_length);
>   		if (nlen != SMB2_WSL_XATTR_NAME_LEN ||
> -		    (u8 *)ea + nlen + 1 + vlen > end)
> +		    (u8 *)ea->ea_data + nlen + 1 + vlen > end)
>   			return -EINVAL;
>   
>   		switch (vlen) {

-- 
ChenXiaoSong <chenxiaosong@kylinos.cn>
Chinese Homepage: chenxiaosong.com
English Homepage: chenxiaosong.com/en

