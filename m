Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64BE40D595
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jun 2026 02:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782181703; cv=none; b=oiIaBTVm0IWyGB5kCSg0wnR3DyhfylBw9jZ2uJPMa+HlmQQ2JyYbH94vlWT5aU5IL+Zjgzt2NkALrvti0DolH7Hcju1QzMc2JSkNVQz4Fg4q4So01Zf/BRHFaxFhgbEzTk/ci2LSTS4zGCirsl5Tj8oxz7eHne67+LviaiAatYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782181703; c=relaxed/simple;
	bh=GWBy7cpn2+ObhKq2KqIQ615EYHC4snFPB/EXbyKC2jA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WbZZs2mRFm/UE09EaeTn0MUoHzisNQKWQNMmDq+YJWD8Tha+NSzsYhFNbBKC+HQdetvSRnOyR5Pemd730v/EVtU5BeVf4N0IQQjH8XSDajaT3zV0P2ClILjQy1jqWJcn1eNVkZAiUX/K2mfmfE6hvMwF3o4lfiiICcBd++JmLJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=H5TDoyrJ; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="H5TDoyrJ"
Message-ID: <ac33d658-0ef3-48f8-b934-dfe2623ed5a7@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1782181696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IEyX7V049evcsx3LrlsBWOFe+iMI08Sx5c7HetYH/ao=;
	b=H5TDoyrJNlgGFdguvDU+MjaqGxsbVsH3igydeM8GxrBPo/Emf6xQ2kIrwPGfXzx+JxCbxp
	j+EpUd6Phcp7SCngLIzLfm53WYO8CTGe1xGjJynk4ZDVbkWumAP9ahFEht4KgILLU0FwcG
	QqS0ertBJuyMlPYz3m2l66PAmEqN4wwWIX4f4JtIcA68IvYH2xaI5tPBNMr6xB2hWJFSrZ
	kVW/62AGHKZYvOXRSrP9NPIsHRPdpY2z2uWvJD406IJbJzqqjIfT5vifoy4fdELW0AU0wX
	c880bTNBsDzuRWZPR9N3llUHvLEABgbq108pphAzJ74p9cXeKatTvMzNXi10tg==
Date: Tue, 23 Jun 2026 10:28:02 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] ksmbd: fix sd_ndr.data memory leak in
 ksmbd_vfs_set_sd_xattr
To: liuqiangneo@163.com, linkinjeon@kernel.org, smfrench@gmail.com,
 senozhatsky@chromium.org, tom@talpey.com
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 Qiang Liu <liuqiang@kylinos.cn>
References: <20260623021240.34722-1-liuqiangneo@163.com>
 <20260623021240.34722-2-liuqiangneo@163.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260623021240.34722-2-liuqiangneo@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Looks good. Feel free to add:
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>

On 6/23/26 10:12, liuqiangneo@163.com wrote:
> From: Qiang Liu <liuqiang@kylinos.cn>
> 
> Move kfree(sd_ndr.data) into the out cleanup path to avoid memory
> leak on error.
> 
> Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
> ---
>   fs/smb/server/vfs.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
> index 74b0307cb100..febe9f7b54c3 100644
> --- a/fs/smb/server/vfs.c
> +++ b/fs/smb/server/vfs.c
> @@ -1479,8 +1479,8 @@ int ksmbd_vfs_set_sd_xattr(struct ksmbd_conn *conn,
>   	if (rc < 0)
>   		pr_err("Failed to store XATTR ntacl :%d\n", rc);
>   
> -	kfree(sd_ndr.data);
>   out:
> +	kfree(sd_ndr.data);
>   	kfree(acl_ndr.data);
>   	kfree(smb_acl);
>   	kfree(def_smb_acl);

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

