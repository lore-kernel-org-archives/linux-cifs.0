Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CED723E358
	for <linux-cifs@vger.kernel.org>; Wed,  6 Aug 2025 14:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754491151; cv=none; b=e9N3NJk7TsndxbjxvynME/Pbfr2iqW+TGk0XOe+NOCy++rEgl/zaHDAieQo0cJcG5hMuy8gOPPnNqfYUUkVXXWw+PEFPXmF0DMSldi4t05tONBNkVpWhQmr1uft0kTFyxqmGkay+r8LZttVluJKjOQdKt4k2CZ4axqh2RgOWBIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754491151; c=relaxed/simple;
	bh=YJ6mdEgeBoXcjvgJA/CR/fmtrg1zaUe1je1DWvu5qcU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oFfnmjuMoevadi6nyPOdAw3puvzMMBpc0XOODpovOH2lBTqim0KHWURUULsH3vZjLigjStdquc8jbJvb2nooV+e3jNqpkh8WZ9hROWZq44QZpbIHgV32gSHr07V4pOau2ErFFRvsVb1XSpZwRge6ELRjBP2fozcUgNvOpNMUZw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GWVUKym0; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GWVUKym0"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3b78310b296so4106287f8f.2
        for <linux-cifs@vger.kernel.org>; Wed, 06 Aug 2025 07:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754491148; x=1755095948; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=t3HkDKyjugPotQJhu78AmOt2Qiqge9F0DpeQ381Qjek=;
        b=GWVUKym0fCODMVtov2Htiy382ptU09zcLmRrnQzQZng39OCVTQad3dv8dta3vohayf
         ch06WjgG+bm88zVBmGc0XuWVH9HU45ht1Gz00tV0XtGcA8YsjnE5rZwrInXI9CLqv/VW
         vx3C9olGUNxjq7Mnyoyv7m+nGalu2hx+0PkLjhB/SVxG7YD7Jb0tv7dDEhak7f+lwsNs
         +ohH+xBal9kRVFOFkt4FYFwKzOy2a4t7RikGnlyUrZ1mTxGvNBY3CNJkPuedQlGA2DE2
         2p0jt2RkHO8N52ey+BUApiuXncZ3jFu4nz3C4HTkIblcSrVUh4BO1c3Yd+5Z20NHfqR8
         0DRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754491148; x=1755095948;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t3HkDKyjugPotQJhu78AmOt2Qiqge9F0DpeQ381Qjek=;
        b=ACuwrIEvaCrPdeTLH7xqOHKRg9wVVu6+Ok6iyqUhqTPbILZ2HGorQzXE3v0h1oFx4D
         LfqVZwEk1xPOU9B5GG35KZdbPe1oYrsEpciIHbXnBjxbzpkiqNDxi39lBWLAFe4woLJT
         mTHdI6nmArn4Q04Qs7taO2nsCjw1VKIfyA5dMXXYvXQxgQIuCIomio5vpxD50/YfBG4d
         O6x1g8uotvP6u1SbWzuglITQuuKuCfzdCKFlClj0lQqJBjlkS9r9A5EWVfN+WyS3y/Jq
         9FLE9yHdjj0/sPVdUKOrPAVpLDumIsUnTq9LoVqrFuws0EGM+QwIdkT7KxSuGBWWTkXB
         chlA==
X-Forwarded-Encrypted: i=1; AJvYcCW9y6K6tQ7nzHha2jKQZ5E/VQYjB9bXFwcWoTqcr+AKzY9UVYoyCaty1/9XwIaKgywIIAtsCk0DuuEx@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/CkKTRZsxBtcXKKCEsynq9ZO5YtLjYsq8l7kj/dx3g3M4eyGb
	sDV6DPT9soNEFDkkGQB+mlG9+HxPtsNv8LnrVNjpGd5hgfc6a8uq3cp329uldsM5rf4wNcdc6AL
	BxbRy
X-Gm-Gg: ASbGncuSP3CpLUMq6ydpZLULtmeKmZhpu3Lkex7CxLTHeVC82s6Ff6qvH5VeW3o4U7R
	shHIz+9cX8HuScYn/i18KVnSUN1yOWIBSnm6tWEIalU/S95VWSWgyaifZQanVwsBXnlBWH14MAB
	C8vQsBbBrQQCPO6xYLvyxmhR+ZD0Q5Hi3VqIfSltPJC7iuB03yilgVsKqQJtkrPnySKKmlAUBaa
	3MxyjLRR92xV6oxszN+uWTenu9gA9okkOA0LH89by4ec5cKU1gSMHozjV/LgEDFFXHwr7SwUQz6
	88lFVSs8r5608nGTA+/yQzHJF/jJkzsNdH+9p482KmmjbBJyDK9H0QHiwZNU9AQ4AKQSW6dMyCM
	9Up4kHjX6xAu3rHejapw43DYB2D+T33r2ZJdWRg==
X-Google-Smtp-Source: AGHT+IFXtbxOaD74GotqT9R0CD1sqY91sieSs3SIFRrIbH0jr4lRcbg1q493FHWof4NReZYFSRDp7g==
X-Received: by 2002:a05:6000:24c6:b0:3a4:cfbf:51a0 with SMTP id ffacd0b85a97d-3b8f41bbb72mr2459659f8f.21.1754491147334;
        Wed, 06 Aug 2025 07:39:07 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e583f9fcsm50543105e9.4.2025.08.06.07.39.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 07:39:06 -0700 (PDT)
Date: Wed, 6 Aug 2025 17:39:04 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Stefan Metzmacher <metze@samba.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH next] smb: client: Fix use after free in send_done()
Message-ID: <a1a0046c-f47f-4e8a-ae3c-85db58a6cb2f@suswa.mountain>
References: <aJNASZzOWtg8aljM@stanley.mountain>
 <ad2e9d94-2d95-4351-b800-627f20672209@samba.org>
 <87646c67-78b8-41c5-9b72-361cb3b733d1@suswa.mountain>
 <e291d925-bfd9-4202-b5d4-de5bf30ab870@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e291d925-bfd9-4202-b5d4-de5bf30ab870@samba.org>

On Wed, Aug 06, 2025 at 04:17:41PM +0200, Stefan Metzmacher wrote:
> > > What was the test that triggered the problem?
> > > Or did you only noticed it by looking at the code?
> > 
> > This was a Smatch static checker warning.  You need to have the cross
> > function DB to detect it.
> 
> Ok, I'll try to integrate it into my build flow...
> 
> Does it replace sparse or does it run in addition?

In addition.  I find the Sparse endianness checks especially useful.

> If it replaces sparse I guess a small script would
> run them both?
> 
> $ cat mychecker.sh:
> #!/bin/bash
> set -e
> sparse $@
> smatch $@
> 
> And maybe all others from
> https://gautammenghani.com/linux,/c/2022/05/19/static-analysis-tools-linux-kernel.html
> 
> How often do I need to run smatch_scripts/build_kernel_data.sh on the whole kernel?

The cross function database is really useful for just information
purposes and looking at how functions are called.  You probably
would need to rebuild it four or five times to get useful
information, unfortunately.  I rebuild my every night on the latest
linux-next.

But for other people, I normally say don't bother with the cross
function DB.  It takes a long time to build and it only slightly
improves the output.

regards,
dan carpenter
