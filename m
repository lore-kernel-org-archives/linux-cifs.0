Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF322225403
	for <linux-cifs@vger.kernel.org>; Tue, 19 Aug 2025 05:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755581112; cv=none; b=LwnvkV7W+fc2MREkJtvdo9Jmhen+GrlyEbc3Yv+kFCTEiGuoV92N0DJZOPe/uPSPN/Qp8EMkq7kDQXJigjsNvfyYotkdIxxm5Bog4Gczf5DqdFMYN31xDN75u8dUXDk55KL33/WL9v2473PJv3hwxZov6k+mMznap+doUh1qzyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755581112; c=relaxed/simple;
	bh=8VWnIw8OMW4m2SkxianySdGuIW4HjoawAYYxrqElj8M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RcQ1hDDrbJ1B6cYajZCiNCWv2LkZgmfYNMQ79CIG/N3+8GOFb6y9cQxjYyxQzCzvOt2I1LozdzbYW/mlBdC+4qwIgbsexsH/7p1AVJ4h0yqua0DyrmfGEZmqWjo3sXpXkHzwWgp0nodyzeoHWUcK2t24yJkpr/9LOXzRUMXUEP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=umvsuBi4; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="umvsuBi4"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45a1b0d231eso26957265e9.3
        for <linux-cifs@vger.kernel.org>; Mon, 18 Aug 2025 22:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755581109; x=1756185909; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AV/OooNGHPqLagZxjCjPrmrhDMj3BpKXfdIAYN7P2zY=;
        b=umvsuBi4iUQI3vZZLTdMC4RFwHQAV0ObMJFhf6x20OPuDTgCP2n5Tq3uAbuNBpLKwi
         ckTaVoiNTPCkCZwelwYAFi2IFCoh6pjfpjrZYkoQnP6DUCzhXKTpvfnlNEU4GXrI8m5f
         SUzI4l/C5sPsFQWIF0wNmTQ9u0aNyqeLO24tqaIsxhfYo0m5+JuUxalGdwiNwy63xi8x
         Ah57wa3TetiLcPWz5oLksafcAjFoE+N2FDGFo4//jpjEcZLPB9eD7S5tXF0PZLXdvyAh
         kKcWrBGwUgn2CU0wF3TC5CyzsU5kCzcukvLg9IutK0nq+yEfjCvrlcGvhabWu5xZpGWa
         bbCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755581109; x=1756185909;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AV/OooNGHPqLagZxjCjPrmrhDMj3BpKXfdIAYN7P2zY=;
        b=kkQbSkIgCW0ZM7WpWBy2YoMTUCTV7PaBJobgB574tEVb+c/3YW0zQVYGnh0CYRsvWu
         4kGw8K+YTFdeWTblFZoiKML45bagjpHXZcjrXTWoR0x5sZwD/aNUlT8z+aojhh6zZsGC
         lo/M03dVKn7CPx6RD16xPoKAJcQzNrelxI8daxTX5MYGHcEilwz8hGURleIpbIZkjUX1
         A+jAQ/lvSf0aSNCL6QFG4ktDEhft26c0kywrFUAwJTxCFHHtk+qqMPfBsrkm8h3szE9Q
         eDg1wAdm7zmCXpkWlfCDCzzIWguJIEL3kZvratGxlg/VcbBmaH5/54Xbjzi3OHwS5WLP
         w/wg==
X-Forwarded-Encrypted: i=1; AJvYcCUcq3ECydmmroxajnfI0D8xUR/XSP3NGJYx/vAQqkrEKFpB3w7AlK0YTvH5iSO1B4g6dexnVrb/9L74@vger.kernel.org
X-Gm-Message-State: AOJu0YykRo89HnolWycGzvj26fh3k0gfg8fft1jld1SaoyRFrRa4cDz9
	Dgdxgf37E3hsTSnFIin5wIY4vmljWgCw2A9TMLDzJoIiZ35ik1z1xHB4mtZd72b5OIa1FhCzxdt
	l18k7
X-Gm-Gg: ASbGncuLsc6SBn2/voohnxRW5ydjMgQE68dU86H2gN8cm4MPKCBcdNHxQwJXD9Up/DD
	1ur5VOGKwOdmZJ6k8m9zmsEpng9+pCtL9Nf1KLkJkEAOD8+IfPHAqNaf7TSIucPIjBtmBk5DQpD
	kQH8c85IFLevyEvb0NflZ3SLlcEZe1kvVVC0aQtPdVtA5l9vaIVcTa8521qT7mymBnMDtvQp+Nz
	YtpzaHkwCKcSUNFESYjrIyClQ40nAoHnm7/5nBt6I/lu0X2m7jRJ/ZhCECG+nc5ZlwZKDAeLEr7
	b+A6/Gb+wCQSIj1HnGf48R0YMTkdYR6Ej3MJsPyfcWf/C08mxy9sCSzC8RE3th3s/1L+Fr2Lp/3
	QZc4A32/KhWExOPgmQDrO/mfTrs4=
X-Google-Smtp-Source: AGHT+IHIiam/qjt8oskXB9TmvpyuJV3YNW8Fc5vo+kIONJNHr/RadS5xUia24l7fuZR0OAkgVqai7w==
X-Received: by 2002:a05:600c:5249:b0:456:24aa:958e with SMTP id 5b1f17b1804b1-45b43d464e9mr9178205e9.0.1755581109065;
        Mon, 18 Aug 2025 22:25:09 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45a1c6cf151sm200043865e9.8.2025.08.18.22.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 22:25:08 -0700 (PDT)
Date: Tue, 19 Aug 2025 08:25:05 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Wang Zhaolong <wangzhaolong@huaweicloud.com>
Cc: sfrench@samba.org, pc@manguebit.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	chengzhihao1@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v4] smb: client: Fix mount deadlock by avoiding super
 block iteration in DFS reconnect
Message-ID: <aKQKsS1Vv8joDjo8@stanley.mountain>
References: <20250815031618.3758759-1-wangzhaolong@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250815031618.3758759-1-wangzhaolong@huaweicloud.com>

On Fri, Aug 15, 2025 at 11:16:18AM +0800, Wang Zhaolong wrote:
> diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
> index f65a8a90ba27..37d83aade843 100644
> --- a/fs/smb/client/dfs.c
> +++ b/fs/smb/client/dfs.c
> @@ -429,11 +429,11 @@ int cifs_tree_connect(const unsigned int xid, struct cifs_tcon *tcon)
>  				       tcon, tcon->ses->local_nls);
>  		goto out;
>  	}
>  
>  	sb = cifs_get_dfs_tcon_super(tcon);
> -	if (!IS_ERR(sb))
> +	if (!IS_ERR_OR_NULL(sb))
>  		cifs_sb = CIFS_SB(sb);
>  

This is a bad or incomplete fix.  When functions return BOTH error
pointers and NULL it MEANS something.  The NULL return in this case
is a special kind of success.

For example, if you look up a file, then the an error means the
lookup failed because we're not allowed to have filenames '/' so that's
-EINVAL or maybe there was an allocation failure so that's -ENOMEM or
maybe you don't have access to the directory so it's -EPERM.  The NULL
would mean that the lookup succeeded fine, but the file was not found.

Another common use case is "get the LED functions so I can blink
them".  -EPROBE_DEFER means the LED subsystem isn't ready yet, but NULL
means the administrator has deliberately disabled it.  It's not an error
it's deliberate.

It needs to be documented what the NULL returns *means*.  The documentation
is missing here.

See my blog for more details.
https://staticthinking.wordpress.com/2022/08/01/mixing-error-pointers-and-null/

regards,
dan carpenter
