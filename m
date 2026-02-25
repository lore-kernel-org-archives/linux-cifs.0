Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7C83E8C45
	for <linux-cifs@vger.kernel.org>; Wed, 25 Feb 2026 16:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772038200; cv=none; b=juuXsxDGe2WOt4UKGP2KwlgrUJiTdIcbXpxAGIn55IAKlEmkMy39l0bL8LeVDtg0uYIO52ZItPf4a2IYHQIyNE8InlpQlnpBiucJE54hjb9E9r6sV5OeESQPajsWu8/Yp7VpB2ddKA3eGaSUvB7VZg1+3jsnj39feIasZqZzrWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772038200; c=relaxed/simple;
	bh=FkYpPYnCpizXz06xGA6Rez+sR7b+2iPrse9OvaUwAwM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HSWwb7N6/xt3k839k/GsTPoRer44chJ5OFeHFahbwz1iBL5p3g5hA1KF8w9XhhIxV9NuBBxDXqjAXBkrBBnGw2FmNQ/K+Mm4shlvxpvVpUVP8UGOPgw9x8+1tx5ykLxlt1VmTvfm3QRP722Z09uWCHMLX4etaNCLTv2TQE/DWxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dMjISKWn; arc=none smtp.client-ip=74.125.82.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dMjISKWn"
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-12758ce1e8dso1002322c88.0
        for <linux-cifs@vger.kernel.org>; Wed, 25 Feb 2026 08:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772038198; x=1772642998; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0gT3Brz5SkDMo/RA3FDp7Ea/ZKHRMvaWFqhCGPHZH80=;
        b=dMjISKWnE4qrjQz0FM+TH6eyuvWmRecpJ/yHAAbj1fWal2yi0qPJjyVMDjQ4sbRLva
         UsHZJzKwLV18+I1U49exeluvFgx6dScYKNnysly624cVmYh+yTpGn3nMeGzXeiJ2K1mV
         Tyn9TtaqknmDJea/jmPDexbbG8YAacmrcK79V0asz7FGxIi1y/PwpF3QvnAVC/9bAWQu
         QTybpyHfPInuFzX4TfqU9K4YY2S1HMIoMMf+cDxN9sFJpA+wdzE9zBSiiTVGO7wseMCT
         ndIcwjMoWZ7JAuP1v4kkeGec7Sog5+JItpp1/LnsquNczHZxUSqcHXd1VR+Y0zN4Tcm4
         k7fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772038198; x=1772642998;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0gT3Brz5SkDMo/RA3FDp7Ea/ZKHRMvaWFqhCGPHZH80=;
        b=YzFSi/1LsJf3CFfxKPdSLxetSt6bEkr2wrFIfPInhbY9eLnxTTKthNwREo3v3Cp/4F
         tO/xPkaig1M6dwLn61dWasmXZEQVn6ONKLuzcVVClPYk41aKKTp7Ix6NTuxai2z8HsEG
         QBMiGURDZBZE6oO2c9iJYjXn8XFNZ+TVH+jGdGxaDmry6y9tYk1v6K/K5Ilv2Q6z73eM
         c8S+Ez3XweowhjAc86oqSWME1sMysIGSitUVjVRrO5tskW++/DaYkj9VGszIkzS4IpFA
         EqcGtBqe7v8Aw3wV2tvsmfBk0m4y2mLVktNfH6FVIVnea2UK++J8V0zOb7/GEX3M0jDY
         4I0A==
X-Forwarded-Encrypted: i=1; AJvYcCVLq3R/pkr0v/bTf2yiANjuuq70y3oWluwBrAONfszGaYaOLuBk5oGPzeP5/k39N2e4KHjc2SdpQAIa@vger.kernel.org
X-Gm-Message-State: AOJu0YybM0cir7aPXzPWaLjToKki0kVB6zrwlk/W37A+1ZWh4jZad3D5
	b9exO4Oo2gccJNKRb4pLX8rPs1Nf7as778maIyMhugY5OxbwzrVDE/SA
X-Gm-Gg: ATEYQzxzWvPO0hhD3NkKUq7HMwkwWucZ9/lSuOoZTEdhaqi5Zcvgs2PNXgOLVl4aq/9
	2RQyTuJAzhD1jQxhuzo9i9/N95fqE7ZIdD3ppE4xGwlAcxhjCHTavP6MOtYJMAKJixq4NLgalL3
	x63rq0h7ulsl8NjXQpAFnwC6/2v4OS+CHDKm677ZBtJnvPfDsnJT03r9MJ8L4+8gZTMrmH6P+Ql
	0oMNTkVNU4mf74Js7BFGBF/3VKpl3++/dhUV63+AJ5tGmCb6hqq2/LqAUwrWo8LsZ3NvPJ9K11w
	oJaiGXolaRfjMB0TL9yt7KFjiwDcaCeoCpSOyFNegyXs3nvt6IR89MtdGitAi3sXU3/Od97lq52
	YU0sAGqK6xOrSDMArc16VblpjxtytRvsYEycKbAk5Ut3NFRiuGNTKFlI55nETXWZavUWlIEb1e6
	l1H9erjJndPW5EYUK5jHSOzbg/fl6BOHLKUSeJs3NHik8iSsQ=
X-Received: by 2002:a05:7022:524:b0:119:e569:fbb3 with SMTP id a92af1059eb24-1276ad7b9c4mr8511362c88.34.1772038197849;
        Wed, 25 Feb 2026 08:49:57 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1276afa0bedsm14167584c88.16.2026.02.25.08.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 08:49:57 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Wed, 25 Feb 2026 08:49:55 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: chenxiaosong.chenxiaosong@linux.dev
Cc: smfrench@gmail.com, linkinjeon@kernel.org, pc@manguebit.org,
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
	bharathsm@microsoft.com, senozhatsky@chromium.org,
	dhowells@redhat.com, linux-cifs@vger.kernel.org,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH v2 1/1] smb/server: fix refcount leak in smb2_open()
Message-ID: <97979f06-7dd2-46bd-9bdd-3a9c45fc5b1d@roeck-us.net>
References: <20251229031518.1027240-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251229031518.1027240-2-chenxiaosong.chenxiaosong@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251229031518.1027240-2-chenxiaosong.chenxiaosong@linux.dev>

Hi,

On Mon, Dec 29, 2025 at 11:15:18AM +0800, chenxiaosong.chenxiaosong@linux.dev wrote:
> From: ZhangGuoDong <zhangguodong@kylinos.cn>
> 
> When ksmbd_vfs_getattr() fails, the reference count of ksmbd_file
> must be released.
> 
> Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
> Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/server/smb2pdu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index 6a966c696f7d..dc730fe348e4 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -3007,10 +3007,10 @@ int smb2_open(struct ksmbd_work *work)
>  			file_info = FILE_OPENED;
>  
>  			rc = ksmbd_vfs_getattr(&fp->filp->f_path, &stat);
> +			ksmbd_put_durable_fd(fp);
>  			if (rc)
>  				goto err_out2;
>  
> -			ksmbd_put_durable_fd(fp);
>  			goto reconnected_fp;
>  		}
>  	} else if (req_op_level == SMB2_OPLOCK_LEVEL_LEASE)
> -- 

Running an experimental AI agent on this patch produced the following
feedback:

This isn't a bug introduced by your patch, but it looks like there is still a
resource leak here. If ksmbd_override_fsids() fails, we jump to err_out2.
At that point, fp is NULL because it hasn't been assigned dh_info.fp yet,
so ksmbd_fd_put(work, fp) will not be called. However, dh_info.fp was
already inserted into the session file table by ksmbd_reopen_durable_fd(),
so it will leak in the session file table until the session is closed.
Should fp = dh_info.fp; be moved before the ksmbd_override_fsids() check?

PTAL and let me know if it has a point or if it is missing something.

Thanks!

Guenter
