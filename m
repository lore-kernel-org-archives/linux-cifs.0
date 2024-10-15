Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FDC1C302E
	for <linux-cifs@vger.kernel.org>; Tue, 15 Oct 2024 10:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728989137; cv=none; b=BGpz/jZRUi5KTz66d6Ru7tMwl8C1hTyNSt+O3XT3wzT7WNQMN81eoXSh9bz3eGu68EEaL4STCa323NpSUP92dpbs5MaUtcQEG1cO5/g8OntIYMqT/OMEjU6I8glWTUNuUVEiBraUy+6TuKU3J6g7qhm/NBEba/6kSFtrOj0UkkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728989137; c=relaxed/simple;
	bh=2RUa+Wp78UJcnBTaHrcjGmfuvysTndxMqeQSnUj1y4c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NKzb6JkAgp+Vzu/xYn9Ss2yVulYim6nRhPD2c9M1RJVK+Bdcfj96/cSzEVn8OnkjrGrXenduzxie7N70JIpbbigVA3568gy+sueiTT5I68FOQ49bJNxffbmkrsdUJFfwFimW4+8NRDGLgRiUBQs1uctpHvQuDd8v9Q+XgBC90ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TKpc3woS; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TKpc3woS"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a99f1fd20c4so456097966b.0
        for <linux-cifs@vger.kernel.org>; Tue, 15 Oct 2024 03:45:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1728989133; x=1729593933; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=TCL9tE7kD/pEAlw/bIpW3296DIJpWExNiDbcmpjDgj8=;
        b=TKpc3woSI8G0lsZy7MRjDx4BQlq1YfNnEb0d2nI5J4oviCb6w6SbqWbTOjJmkmXAye
         vwIyo4fu6JgF7+ub8nAAOAZHhoSZIuPuLe46RRvZcVAUlSBDZqKe4QU1qyeEOzmiTAZQ
         FLoSkdbEDp7TtfTnw13mAj9jVbK9Bbi4XpofaLtZlo6OAE6uq80aTPug7i4t2ko7bxIV
         A6J7SU094mreEuxcTImfKFgxGvBg5CoDGcBS4+ipaqIot7FI8GlK7QPBMqyT7YhvdixT
         cKedhCqcoapObKdIXS+6ZUu6AR4wXMg2dofdx02YE5gvmqoKF1Y/s7V771sb3CNcmRVE
         TOVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728989133; x=1729593933;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TCL9tE7kD/pEAlw/bIpW3296DIJpWExNiDbcmpjDgj8=;
        b=da41KsCqK+/fo/+S5GtO/UJ83r2hZglpNk3hy6JWPOr/l7fbOrqvGK1XBVO98G0+lp
         GIm6Z554Wz2/6IXmTTQ04ANHMXCsCJYQ1Qs7RwjY9kSVJrs8inFOqNKai5+6kXlWuy39
         Mnx1ZtenQGVQbqOK5w6/fHyKE7kRBkCrOzk8nJKtDcPz+auPtlDmhxrsmUA+HPta9tyg
         dd3U3H5K7dPXVggWnGVSISmL8AymbLzvXqOq8FrAPik7q9Ni7TJwOQLJPgXHGwmDVkG3
         eYWnEPFPMJ+wWTehZQscFnjLw2Yuza0gLCawNMMt36kvBFHeyYVtPuiRdty2hBGC1tMC
         YdvA==
X-Forwarded-Encrypted: i=1; AJvYcCXrPW+9v91GF8yHRub7J66kQYTLrytOmdL+k3sbOWltf3ztJsNw1FdQnHiFkQTklHoX3RLKfmMXTrVE@vger.kernel.org
X-Gm-Message-State: AOJu0YwUQaD9ycXDCd9tx3Y3Q07eioYW0LCv0lxvpg4hAfRIOOY97wH4
	lyPesG7ccFlw/Ta+h3hb4ypIt7V3cZYiLNz7qnPf+MFQ7ZKp1lyQ2aDD8U/g5eQ=
X-Google-Smtp-Source: AGHT+IGr2iqgWL4Av+20XWPNQ/ZE7fyuLmJsKSn2ZOfDWIZori+kUOfJFFddL5wMKnYz/zgwCRipDQ==
X-Received: by 2002:a17:907:7e8e:b0:a9a:61d:7084 with SMTP id a640c23a62f3a-a9a061d7325mr751772566b.50.1728989133267;
        Tue, 15 Oct 2024 03:45:33 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a29843318sm56079066b.150.2024.10.15.03.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2024 03:45:32 -0700 (PDT)
Date: Tue, 15 Oct 2024 13:45:28 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Su Hui <suhui@nfschina.com>
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com,
	sprasad@microsoft.com, stfrench@microsoft.com, tom@talpey.com,
	bharathsm@microsoft.com, nathan@kernel.org, ndesaulniers@google.com,
	morbo@google.com, justinstitt@google.com,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] smb: client: fix possible double free in smb2_set_ea()
Message-ID: <c0afa02b-991c-4601-bacb-13ace9cb96f2@stanley.mountain>
References: <20241015102036.2882322-1-suhui@nfschina.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20241015102036.2882322-1-suhui@nfschina.com>

On Tue, Oct 15, 2024 at 06:20:37PM +0800, Su Hui wrote:
> Clang static checker(scan-build) warning：
> fs/smb/client/smb2ops.c:1304:2: Attempt to free released memory.
>  1304 |         kfree(ea);
>       |         ^~~~~~~~~
> 
> There is a double free in such case:
> 'ea is initialized to NULL' -> 'first successful memory allocation for
> ea' -> 'something failed, goto sea_exit' -> 'first memory release for ea'
> -> 'goto replay_again' -> 'second goto sea_exit before allocate memory
> for ea' -> 'second memory release for ea resulted in double free'.
> 
> Re-initialie 'ea' to NULL near to the replay_again label, it can fix this
> double free problem.
> 
> Fixes: 4f1fffa23769 ("cifs: commands that are retried should have replay flag set")
> Signed-off-by: Su Hui <suhui@nfschina.com>
> ---
> v2: 
> - Move 'ea = NULL' near to the replay_again label.(Dan's suggestion)

Thanks!

Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>

regards,
dan carpenter

