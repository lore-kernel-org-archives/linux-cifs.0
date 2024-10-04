Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6BC823DF
	for <linux-cifs@vger.kernel.org>; Fri,  4 Oct 2024 18:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728064821; cv=none; b=ssY8ONjQgMK0LMEMdnw666kqrr7FtQo/MRuUJNaAMds5+SwV/k1nLZ6mMszP/OK/CjjklsVehifuhD8Mq4B87ImrNQnlHLxrAsn2mAWW14QxZMKP84eYwwBnnk7TCWeJh25x/TfYVqqN+m6B/mOcf2nRV6prF3IkRndjwlMk2Cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728064821; c=relaxed/simple;
	bh=AKgWleQXsqUtRgxRq8FQGbytk/DBw8m+PGBDZzP2I8U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d+8/EyD95nyF+Tdo8y0AjaKUyPRlUZUqAbIgYSFfjE+bETsylDvkIraiId5xRLEIJaqDYmUOZrZlRWpBTUMCL2uCAo/Vuem8bXBK6H0uE3Ott/IJPiDj6HGRMUNbIP3HO7DA9c5F8Ef7fqp6m/ZaiRiYqknKZaUdWBJJLR4hMFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JSGu+z+q; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JSGu+z+q"
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-8323b555a68so125931839f.2
        for <linux-cifs@vger.kernel.org>; Fri, 04 Oct 2024 11:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1728064819; x=1728669619; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vQ85Gcszgmm6jvoSXWqfFY4Qb9EJuVBgdczRX/KgxR8=;
        b=JSGu+z+qozOGY0gla2tHCeHCXz6evyAVQcMmXO2oJ9cHnv60++IBmI0IvK6sfYlE4E
         t58RL6OzBPQLH3nJZn3IqGRzJRJ3Tva7CadnYZ2w192esOQJTdrBp8FOTSRNFuxifRvI
         FwUXrxgPEdbOX6x0XZFaYEhrSCmiQ+3UdGVfA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728064819; x=1728669619;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vQ85Gcszgmm6jvoSXWqfFY4Qb9EJuVBgdczRX/KgxR8=;
        b=uXXeeSrbziJLdvHjt5yp3OejZxg7BnYh2VyMonSGjbMPY5KXDG7tkAFQ3pDW0fTlFX
         k82eJKdMuYw4XMOWeH+0cfoxiZWRWsU8acZgnxy7NUF8jHzCzvFEN8eo6UTtJR7QcUBN
         8/zzUCE22K7GM/6P9UVjpS0U8GOCgNEQMfH8y8icz7AooAJ4qx0zbiIDBdHxUyNxGREG
         VVExnolIdot98ZEk0cpb1PV6sfQqfa8pCwH+I341XHA6KBTVOYIB3r7csJuhV9vdwE8D
         ZoBrnDaNsc6TjSUGQmWlcTx9a/UigivuBoN64N7NeVOVPu8KtpYWWTqlktcKWcLlEVqD
         B/wQ==
X-Gm-Message-State: AOJu0Yxs8xcVgjVHCuE/RyLS/uaDxgUQQxNrOzDU8Wk1X1txc+bRkd6v
	0znMJDU/k4ce5M1a/3hthRL7pQ/TE/DY+8KfH/YDAt0sokgKO8tG50yuJdhmPSc=
X-Google-Smtp-Source: AGHT+IF2I4rItE9aUfPspe/FBeg94Anm12YHdLMAp6Y6QRvIm89/uCoRoCskO+t/z4jJ4yH9Sji3/w==
X-Received: by 2002:a05:6602:1689:b0:82d:79b:ee8d with SMTP id ca18e2360f4ac-834f7c64115mr351778639f.4.1728064819044;
        Fri, 04 Oct 2024 11:00:19 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-83503b15397sm5390639f.39.2024.10.04.11.00.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Oct 2024 11:00:18 -0700 (PDT)
Message-ID: <b04634a4-1301-4f73-a6eb-05ef79954aee@linuxfoundation.org>
Date: Fri, 4 Oct 2024 12:00:14 -0600
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Fix logically dead code
To: Advait Dhamorikar <advaitdhamorikar@gmail.com>,
 Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>, David Howells <dhowells@redhat.com>,
 Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 linux-kernel@vger.kernel.org, anupnewsmail@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241004103051.43862-1-advaitdhamorikar@gmail.com>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241004103051.43862-1-advaitdhamorikar@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/4/24 04:30, Advait Dhamorikar wrote:
> The if condition in collect_sample: can never be satisfied
> because of a logical contradiction.

Add a better change log explaining how you found the problem.

Also your short log is missing subsystem information.
Check submitting patches document for details on how
to write shot logs and change logs.

> 
> Fixes: 94ae8c3fee94 ("smb: client: compress: LZ77 code improvements cleanup")
> Signed-off-by: Advait Dhamorikar <advaitdhamorikar@gmail.com>
> ---
>   fs/smb/client/compress.c | 4 ----
>   1 file changed, 4 deletions(-)
> 
> diff --git a/fs/smb/client/compress.c b/fs/smb/client/compress.c
> index 63b5a55b7a57..766b4de13da7 100644
> --- a/fs/smb/client/compress.c
> +++ b/fs/smb/client/compress.c
> @@ -166,7 +166,6 @@ static int collect_sample(const struct iov_iter *iter, ssize_t max, u8 *sample)
>   	loff_t start = iter->xarray_start + iter->iov_offset;
>   	pgoff_t last, index = start / PAGE_SIZE;
>   	size_t len, off, foff;
> -	ssize_t ret = 0;
>   	void *p;
>   	int s = 0;
>   
> @@ -193,9 +192,6 @@ static int collect_sample(const struct iov_iter *iter, ssize_t max, u8 *sample)
>   				memcpy(&sample[s], p, len2);
>   				kunmap_local(p);
>   
> -				if (ret < 0)
> -					return ret;
> -

The change itself looks good to me - unless the intent is to
check the return from kunmap_local() and take action based on
it instead of removing the conditional that checks the ret value.

>   				s += len2;
>   
>   				if (len2 < SZ_2K || s >= max - SZ_2K)

thanks,
-- Shuah
