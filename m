Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04252FE581
	for <linux-cifs@vger.kernel.org>; Tue, 11 Nov 2025 09:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762854867; cv=none; b=N0p9dqYWPt4b+jyqZgAzgjAfIFvggTDzVL9fHfdDo3DKfl5fvQ5Nm2V9K3sxp4+BGHC54fnmy3GEr7FGPVb3yEXI82a/ExzmQmT/dO4zQC7EiKqLQHLdM6ruPbgOG0X2b7rsrOs5AEr9cs3EkvLZZYqBPuElywU3c7bedvrx2uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762854867; c=relaxed/simple;
	bh=EJdDjhImozdW7IdZ3kTSU704p4CBNXhkKy5TYb/uSeM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rAgqcR7+7mmKehcGNtI6pNdvmO3d1jxf3744yipHi8P5JIOjEXhd0AZa0HkyNS5vZBNgfYCtzP1kA52Xk0kfojt1c44R1sELRXliUwPcImxol2CFcnNzXh6Q093mAhYK5E1SWgkZyP0S07fiTMLNT/GGwd72TLE7l//a8dZ+Qgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com; spf=none smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong-com.20230601.gappssmtp.com header.i=@chenxiaosong-com.20230601.gappssmtp.com header.b=jAVEIDGR; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong-com.20230601.gappssmtp.com header.i=@chenxiaosong-com.20230601.gappssmtp.com header.b="jAVEIDGR"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b9f1d0126e6so480234a12.1
        for <linux-cifs@vger.kernel.org>; Tue, 11 Nov 2025 01:54:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chenxiaosong-com.20230601.gappssmtp.com; s=20230601; t=1762854865; x=1763459665; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Hk5BFBpp1u5WXCaMFe/o0o3qPx8QHj09GEzO1frMoAw=;
        b=jAVEIDGRoyOB9XFdPDTChAzx/d1Ov3XPcFHCRBibPJ7YTyQC8W19t7PMUk8jOolvq+
         DyfXJ9PMFgJQNo3qB99uYrvMXqGBpeWTdyLIrvVP87U6n+zBJGFPr6xa1h3P6CWVOZfo
         c78v96VLVQts7jAonx4wh8QZMHDN9igzCMvIu3QZxTUIKAZpHR/nPFN7huh20w803+Dc
         wtQ4sWnyGieGULVL7S6cqGMuv9Pd1pLdZxVEc7wgJILQ9aJ2B2bOXIp0rkxKN5Qy+BXt
         d8xptEpyb4AnvAx5JZ4uXnPV41s59k7upRzxPTpqnj13soSA0zyh8hlLtqnF/kWP2Qaq
         wuIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762854865; x=1763459665;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hk5BFBpp1u5WXCaMFe/o0o3qPx8QHj09GEzO1frMoAw=;
        b=wDvYRx15icKZmAdDq65oFOz+l7VwOkUXjj+mHgOvoLOVnlJ0jkPbhYGgnPawpHs6eB
         Ka7eH7aMxMBRvvLqyowvf5tDB7xN/QNKT9S3LYtgBsJLpE3FAd0friSVOht3kczuuQH1
         Flv+EbrYeSCiJWHQalJCNFoIfkrB3Zs4dqWPagI4GLssJYILMbmA/hX0D16/xBdbbbo4
         iv35rCcbrDHy36DPsf6/7LouQpbmDw9tjqmr2ERl8trr8f540mwYi2oe71oqr21tCGvc
         WY1xqH6404TtHX8Ay36EjYMAzY0a8dCnZ3GrCBveO+OAISVmxgVvriU7aFL0DYxstccf
         Ov+w==
X-Gm-Message-State: AOJu0YzQa3gJd4oTb04D1GgmLUe6l5aazLsgRkM5wUwQ2zqyHD2zhcBc
	vp7TsK8FyguyH1RirSuufKaDhM3SgWNOH/9uMmqobAResC6EFS9r/ROQhRJ4B0JNojfz
X-Gm-Gg: ASbGncvdnvuVbbJbRW0zjlVuoTA+x/W2lMPQs2ZLnFoEyBLz7O4CdRqY7HT5aacNeQa
	OP3paB1w5qGiijssG2MVCWt9KdQHziTEz3Ayvfo80aLOa+TdEeC2pLUg2CbXIE0ZJ8/Y0+o8mN4
	Vd/CPSRfHzHXm4FZD/2AG1sAAg9F2B63i9yCIIf2dyTYuq9/IXwELMdKIrmZYjy4hzpmoe2cQ26
	pEfLdPpiFaYS1RDDM5y0CoVFdugBO8lL2NY84MgjkynuiWWMwHYegKJryVpA+34NMn4JZqbZr7j
	6IyVGZinqIZUZPrgYH054A5XRU8kcXaoU4p59DwtK81RnxLKt8OEcgC/mXbgf9wpwEdAiOeK+LY
	qsZt8vr3GPHq9kkjC3qQ+sIIKi1GSVoFdhzJ9fA0C8T+rTSQcdYq9CNQmtyqc0j40SXWaGRBgzq
	m9bS0ffLczxdmf8vWt/kUbqb1ogOCUZg==
X-Google-Smtp-Source: AGHT+IGicarsuDwLnGTWT91xUJNjECmoMxmxNsfpkxfNWnuZbEKbG6ntUwD1I5H+OPspzqZw01jytg==
X-Received: by 2002:a17:902:f785:b0:297:dd99:ff13 with SMTP id d9443c01a7336-29840842ef6mr38141055ad.17.1762854864631;
        Tue, 11 Nov 2025 01:54:24 -0800 (PST)
Received: from [192.168.3.223] ([116.128.244.171])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29846334db5sm8225685ad.32.2025.11.11.01.54.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 01:54:24 -0800 (PST)
Message-ID: <a7809257-9125-4e08-80c5-8c7a22b6207b@chenxiaosong.com>
Date: Tue, 11 Nov 2025 17:54:11 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/6] smb/server: fix return value of smb2_notify()
To: sfrench@samba.org, smfrench@gmail.com, linkinjeon@kernel.org,
 linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20251017104613.3094031-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251017104613.3094031-3-chenxiaosong.chenxiaosong@linux.dev>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20251017104613.3094031-3-chenxiaosong.chenxiaosong@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steve and Namjae,

https://chenxiaosong.com/en/smb2-change-notify.html

The link above is my analysis of the change notify feature, and my 
progress on developing this feature will be posted at this link. This 
link will remain permanently accessible.

I will complete the implementation of this feature as soon as possible.

Thanks,
ChenXiaoSong.

On 10/17/25 6:46 PM, chenxiaosong.chenxiaosong@linux.dev wrote:
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> smb2_notify() should return error code when an error occurs,
> __process_request() will print the error messages.
> 
> I may implement the SMB2 CHANGE_NOTIFY response (see MS-SMB2 2.2.36)
> in the future.
> 
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>   fs/smb/server/smb2pdu.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index f80a3dbb2d4e..5b5f25a2eb8a 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -8787,7 +8787,7 @@ int smb2_oplock_break(struct ksmbd_work *work)
>    * smb2_notify() - handler for smb2 notify request
>    * @work:   smb work containing notify command buffer
>    *
> - * Return:      0
> + * Return:      0 on success, otherwise error
>    */
>   int smb2_notify(struct ksmbd_work *work)
>   {
> @@ -8801,12 +8801,12 @@ int smb2_notify(struct ksmbd_work *work)
>   	if (work->next_smb2_rcv_hdr_off && req->hdr.NextCommand) {
>   		rsp->hdr.Status = STATUS_INTERNAL_ERROR;
>   		smb2_set_err_rsp(work);
> -		return 0;
> +		return -EIO;
>   	}
>   
>   	smb2_set_err_rsp(work);
>   	rsp->hdr.Status = STATUS_NOT_IMPLEMENTED;
> -	return 0;
> +	return -EOPNOTSUPP;
>   }
>   
>   /**

