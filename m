Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C348197A9F
	for <linux-cifs@vger.kernel.org>; Fri,  9 Aug 2024 15:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723215635; cv=none; b=RyRNPrYfyvQcVhjyNfg7gkKBOeqGdsVqHhhscwuYPtzPyY7MCPqHCnR+cTqq7xuWYYOtVxXFK29PPk+qo2qFnqZvCjs57SNtkZ39DQ6sqqjLWkZLnR5yUnYYNiC4/GqgPohtF3qwB2L9suBM1zzYlPq8zUm++202CoSRP/YgXF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723215635; c=relaxed/simple;
	bh=dawj/tBNKTzYnHcU/KDys36vwXq748o8gOQyRKuQV4o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IytObKhDp1X89hy7891RsZlIYzPsY35p1y0ee5ZIy1SbK6izZl0UHHrHsSa8Dwp++A0MCpNzy8YfDFgerv8xQqD+4Zvan33xRIIdam2PUdy6oRNlDRCx9ji1rLp57XxW7ST986l8uCQilWQ8W6Fwv0TwlAgb4nqXVkDH+30rhV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pu6jsVFx; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pu6jsVFx"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a728f74c23dso246799666b.1
        for <linux-cifs@vger.kernel.org>; Fri, 09 Aug 2024 08:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723215632; x=1723820432; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=H0rn7UZ3HG/DD0FX2FGCBFvCYFqEktL4MovS3L/vtSM=;
        b=pu6jsVFxeu9KHsfCJ0Bb4BP1fBJoncgmFgHbvZM9htHbwGrgalwHtfMZ5z8dtJ8tLz
         2dg03SMNiXWLyOqeL7MgrOaca7zj+stUs2ZHgQbz3M8TMJx/kAgKVXjpY905D5CSqDCI
         CfVNF44RByA2FFI9srO+1iGac47Pff0Ly6e+CPwyJpnaJ3QrUWH3cGglfEXvVXtREY41
         ceFoqBXRkmP4EqhoBHl6lutSbP6YTGmzh8yHr5wTqzLqcRhhOgvRctitUN3SmbM2D6NX
         UKilkjLbU42L2Vx+dNvAtfR1TzWJw8kun0pGwwIenf2kmb8qP5FX7pxanLFKzoJ1UAwR
         tiqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723215632; x=1723820432;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H0rn7UZ3HG/DD0FX2FGCBFvCYFqEktL4MovS3L/vtSM=;
        b=XAAGdU2zumDYgbZdczHrddpCWM9uPgUcTUFDUXpeVJzKCymoMh07ZqsvWSn6N4ZF/k
         wFjxWY98UDTqUeyz0EekIFuGcj9ua4UuNqWmlHTt26y3r+GlTiG7A73xwoDgP4pl0i7j
         trNnPHsKABZ1PLGahCqSos0NwZ6ADZvps+nH9yu3o/UwKwqpTXjWSTjZ5io5mNCK4z6A
         mGouJKPEEVY0EFDRqVszh4hAed0YAs/EHgN627Dx4Rd/sP0Z/zvaKN8GZ/efKE4In6TX
         BAIyg73sfQ7JMBir9KTXelCoUFMNvbAg+bBFnZblF5INdLbyKNYKCUOHACcJjKj/rw79
         TZiw==
X-Forwarded-Encrypted: i=1; AJvYcCWfrOP5VGFYVExfv0wYKOZS2JmzXYXhl9lMrmVVKlnS23YU6x9iQUuyeGV9bDCHP+zSEiyjgRI1wpbCMVE5EQSHcxRTMHl2G6fcLA==
X-Gm-Message-State: AOJu0Yy0XJO/tYnuBNMKh20o+FAXQjUWHanr6IXGIrrBIY9I8ac4HYV2
	dDZwVXT+UL72bb8xCnwI8yqGlMSc/zI4mxqWqyYY9A6Vv30GGcX5ZpA1+GwlZqQ=
X-Google-Smtp-Source: AGHT+IGimyb61sKhw+mRuQVbC3bE2Obmy5HP7cvL4gIjsSjX8fXY+fkEjJOzQlmt3WtZxu0/FhFwCQ==
X-Received: by 2002:a17:907:c7e2:b0:a7a:1d35:4106 with SMTP id a640c23a62f3a-a80aa557a83mr159871766b.5.1723215631262;
        Fri, 09 Aug 2024 08:00:31 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7dc9bc3c6esm866125566b.15.2024.08.09.08.00.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Aug 2024 08:00:30 -0700 (PDT)
Date: Fri, 9 Aug 2024 18:00:26 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Su Hui <suhui@nfschina.com>, David Howells <dhowells@redhat.com>
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com,
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
	nathan@kernel.org, ndesaulniers@google.com, morbo@google.com,
	justinstitt@google.com, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] smb/client: avoid possible NULL dereference in
 cifs_free_subrequest()
Message-ID: <893f2ebb-2979-4e34-bdab-a7cbb0c7e7b8@stanley.mountain>
References: <20240808122331.342473-1-suhui@nfschina.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240808122331.342473-1-suhui@nfschina.com>

On Thu, Aug 08, 2024 at 08:23:32PM +0800, Su Hui wrote:
> Clang static checker (scan-build) warning:
> 	cifsglob.h:line 890, column 3
> 	Access to field 'ops' results in a dereference of a null pointer.
> 
> Commit 519be989717c ("cifs: Add a tracepoint to track credits involved in
> R/W requests") adds a check for 'rdata->server', and let clang throw this
> warning about NULL dereference.
> 
> When 'rdata->credits.value != 0 && rdata->server == NULL' happens,
> add_credits_and_wake_if() will call rdata->server->ops->add_credits().
> This will cause NULL dereference problem. Add a check for 'rdata->server'
> to avoid NULL dereference.
> 
> Signed-off-by: Su Hui <suhui@nfschina.com>

Needs a Fixes tag.

Also when you add a Fixes tag, then get_maintainer will add the David Howells
automatically.  I've added him manually.

> ---
>  fs/smb/client/file.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index b2405dd4d4d4..45459af5044d 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -315,7 +315,7 @@ static void cifs_free_subrequest(struct netfs_io_subrequest *subreq)
>  #endif
>  	}
>  
> -	if (rdata->credits.value != 0)
> +	if (rdata->credits.value != 0) {
>  		trace_smb3_rw_credits(rdata->rreq->debug_id,
>  				      rdata->subreq.debug_index,
>  				      rdata->credits.value,
> @@ -323,8 +323,12 @@ static void cifs_free_subrequest(struct netfs_io_subrequest *subreq)
>  				      rdata->server ? rdata->server->in_flight : 0,
>  				      -rdata->credits.value,
>  				      cifs_trace_rw_credits_free_subreq);
> +		if (rdata->server)
> +			add_credits_and_wake_if(rdata->server, &rdata->credits, 0);
> +		else
> +			rdata->credits.value = 0;
                        ^^^^^^^^^^^^^^^^^^^^^^^^^
Why do this?

regards,
dan carpenter

