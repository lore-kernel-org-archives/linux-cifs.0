Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FCA1607A4
	for <linux-cifs@vger.kernel.org>; Wed, 18 Sep 2024 10:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726653830; cv=none; b=mc4MnIvUQFygqTD2bvJvm11d09SjoQ75sjHW+mhTiGWoirU50hGdfjy6siGqy5XyLh92R8hxYoWQC+huFD7CmxM2owEtP9FRXHqRz9wb/XaEVcQGuabw9uLH3yWXAZuMccFA6K5KGyg32ED3FcLUkVBbdzIst/MrZ4ZYctRY6qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726653830; c=relaxed/simple;
	bh=GT+qDvazephouxO2toPfg63SFAYGVfcGr1NBWXRgXAU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VQJRv7vc9bBJUDuB86x/S9Uit0KNFWRG1RfE2s1p4jbJfHipVJoYNJtd/HOaTS6QA9pBiO5Ksrvb4ooKBli1a4d1n5FscY2bwpbTHTlIeJhOFLj13Q6Eyd5nQceDJTVuIEX5vqNM0Abszq5lss+WvC+QouJplBroXSoc10SODS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tUjEQzcR; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tUjEQzcR"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-42cba8340beso3574745e9.1
        for <linux-cifs@vger.kernel.org>; Wed, 18 Sep 2024 03:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726653827; x=1727258627; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GW4Fd9tCXZGsjydPgCjpG1qyhvpAqh4fPt0ifMlVFyQ=;
        b=tUjEQzcR6Bzl+auZ/px/Uz2ig0dEsp2bMyWGzrn4+N1GsezVxTIMoowJOA1HHJtAV9
         mhIyLsajfaSn3oFUYCmXQYxp3Fv/zXNSXHw76Jj6ZYcW5eltOERGZ3ffPqeDXzcUyVa/
         MLkmpp/+mdhJrxwGwYpS2ipCGI65GeEYH0yPToGQnKMVUwU9YHwqzQtdSO0FEJusn9SS
         /SQTzDWCHBkOsGo92ZFjucj02Pk5JxY0Ge+GApNfmypJETp6zybvzt2IvskTntLKL7q7
         4VAE48yyXhnsu291J89mYJ+DibEQy3NRO4T8k49F5J2/Naeddy0nncia0JTY54XyALLr
         uWUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726653827; x=1727258627;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GW4Fd9tCXZGsjydPgCjpG1qyhvpAqh4fPt0ifMlVFyQ=;
        b=eBIByxGqhfMJ811zHyBUOHe6ExFm4PboelQjhC8zG84PlZCDl+REQpQnx2pLcd/gt7
         kjW3oFFwMMp2PIGWSwsTFNt9PHKrjdoCiC+0bTiZTTcog1yQ15zql8pzjZ5o91JiEyiD
         0zpV7+BTCrS5e+5zfECdktMEPyBqpxIYs/IqgEY1tblCiqTd5/v1JeS73GmliEZ9ouLC
         GFJrLhkzPGtqhCyrwjmqLjtx62h0feGudCNvE3EN3UE3MFWvRGHQctuc3Knf9odYh7kJ
         hQFT8RqBR42h1Vd26dLvKGCLCwJXqRdPCkIlyL1xcH66UchJ70celVj+wU2LnD06RzOq
         zYKw==
X-Gm-Message-State: AOJu0Yyt/OzyqE+qUu+iJ3CaoD0osUVrgFN3wcU5dG5CBex/d6UBG1qz
	9FsjNNV/rWECi/E1Y3PicMWs2OTz66fvEv6A+tvCbmeKgkEdE8BKIZyHn98ZBc8=
X-Google-Smtp-Source: AGHT+IElrBwnMMU1gZkrlKo8Rsgl/P/hTRrzNx5o4Wp1v0aHM39vtM/amCLrDBe0QhcIqJTdvHvqJA==
X-Received: by 2002:adf:fdc7:0:b0:374:bfd8:eeee with SMTP id ffacd0b85a97d-378c27a8612mr13464745f8f.10.1726653826573;
        Wed, 18 Sep 2024 03:03:46 -0700 (PDT)
Received: from localhost ([83.68.141.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-378e73e837csm11986981f8f.27.2024.09.18.03.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 03:03:46 -0700 (PDT)
Date: Wed, 18 Sep 2024 13:03:44 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.com,
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
	bharathsm@microsoft.com, henrique.carvalho@suse.com
Subject: Re: [PATCH] smb: client: fix compression heuristic functions
Message-ID: <df90d4cd-a5e4-4e86-9359-03b2b37740a1@suswa.mountain>
References: <20240916163049.287477-1-ematsumiya@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240916163049.287477-1-ematsumiya@suse.de>

On Mon, Sep 16, 2024 at 01:30:49PM -0300, Enzo Matsumiya wrote:
> -static int is_compressible(const struct iov_iter *data)
> +static bool is_compressible(const struct iov_iter *data)
>  {
>  	const size_t read_size = SZ_2K, bkt_size = 256, max = SZ_4M;
>  	struct bucket *bkt = NULL;
> -	int i = 0, ret = 0;
>  	size_t len;
>  	u8 *sample;
> +	bool ret = false;
> +	int i;
>  
> +	/* Preventive double check -- already checked in should_compress(). */
>  	len = iov_iter_count(data);
> -	if (len < read_size)
> -		return 0;
> +	if (unlikely(len < read_size))
> +		return ret;
>  
>  	if (len - read_size > max)
>  		len = max;
>  
>  	sample = kvzalloc(len, GFP_KERNEL);
> -	if (!sample)
> -		return -ENOMEM;
> +	if (!sample) {
> +		WARN_ON_ONCE(1);

Don't do this.  kvzalloc() will already print a warning.

> +
> +		return ret;

Style nit: better to "return false;" here.

> +	}
>  bool should_compress(const struct cifs_tcon *tcon, const struct smb_rqst *rq)
> @@ -305,7 +310,7 @@ bool should_compress(const struct cifs_tcon *tcon, const struct smb_rqst *rq)
>  	if (shdr->Command == SMB2_WRITE) {
>  		const struct smb2_write_req *wreq = rq->rq_iov->iov_base;
>  
> -		if (wreq->Length < SMB_COMPRESS_MIN_LEN)
> +		if (le32_to_cpu(wreq->Length) < SMB_COMPRESS_MIN_LEN)

This seems like a bugfix.  Could you put that in a separate patch.

>  			return false;
>  
>  		return is_compressible(&rq->rq_iter);

regards,
dan carpenter
