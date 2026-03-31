Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59E2401A22
	for <linux-cifs@vger.kernel.org>; Tue, 31 Mar 2026 17:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774979063; cv=none; b=UWRu0tNQDEPsynjxz77tJh9cFtOg9yWsGqSS/1deuL1hKe7mPor3ZP6QuySsqM1ADQlfO+QT9UwrGhs2aKCjyFmu+XZt9TErTdS+2goCNXhPsFi6C6Oxk1tJlckT3fVnRzjX3vxlfMEh7kRpNq0ADnHQwGt+ckK4GEf4MzhHuJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774979063; c=relaxed/simple;
	bh=oZd3hPK9L/0mL/z9u7Qet+0p4vFG6xvJVtBKgJRh1SA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YaGB4ilSjbo3R46vAsHevsKoRHYtpAAXKUHcAXtKTJ0yNaJNyR1dcq6zUW27nqrKb1dhIhh5wDs/EDISB6gRZpdXEVTi+NgzdX4OeKcEUYeZAecSHM8b5HLwrr8FmOtuZVVee+V1GoKq63oDJEdKQlWxd5IkKMK2vzF+TQ2gIkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KWBLHyFq; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KWBLHyFq"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-486fc4725f0so1459535e9.1
        for <linux-cifs@vger.kernel.org>; Tue, 31 Mar 2026 10:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774979058; x=1775583858; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mKzfVYqCgbOQnSriQplParufelLcSKqa365dNwu6KE4=;
        b=KWBLHyFq1o0TS9rsIBly+Tz4e5t6RyWrpOAqHkZQblgKTp3hGWv89hzQ33mjTcgdyg
         pbmRD/cZLF4U5dKhDx4onD1fw0s3bwchNjQqKxJ1mrsL4S5SzTsFiP/tUlXUYmH/ScyP
         OfXFbEDyNV1SLy3yAfZeO4DG4MChTQ268hkpf8Lpqo/huRvOQgnkJeZ8x5Vjd8cuDhc+
         rwqveon+CgNZgFfO6eyOdSNjgnf0ZawF9SHvgYMsBSnkSmSfn48b8jNqZPX3WQq0QKig
         T761cyOrYSCWJ6D7OMmuONfk/6X3PQ2RHJo3gH02nRcGOg5q1n9DtB73HTBjMffAKY0w
         67Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774979058; x=1775583858;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mKzfVYqCgbOQnSriQplParufelLcSKqa365dNwu6KE4=;
        b=WjzL2r0ZqeFZzzwNn9GXZ5/l7i8CiFjBacAl4QTrBLxsR7He82luWA5UitxD95JImI
         i+0LhFcQtoGiHlhT/jXf+ihRDCKYBmQXcPCsAEQRttt5Rplz4Yw/l1D1i3sygyoFC+rC
         Av/ueIyil6DXkUGqxwzUsdrzIM5KTPNtO590K9QiQRtBgewjaQ4g9IrYOcF+KM6C1s3E
         vKFGsWGvCqbpGb29rczmeHW8PfblTrywb5d1DSYZs+7FkJAkfWUg3S+3f1HkaURf5uPd
         RRTAmnUqlThdouZ+lKq9JRjHQkaURyJU1qDoGdQvB9AILdcBuYvnIcEgkFxAKjl4IgC7
         FIVg==
X-Gm-Message-State: AOJu0YzNueqtqRbp/6ITr24P5HRonpeGa8GXdB/Rb3lH118YIEiihhfa
	4jof3p8EqEU8mZeFltp+vvqrPpnVpyGr25JZHFcMjo+c6UqjiVii/JUw9mCFdhGz4w5kliOF53m
	TXfqgKrc=
X-Gm-Gg: ATEYQzxsRgEqdSYypaXMeKgkL2+tB22SzeBSyC80oaaWx3PGDw252k6deKuCpOEs03e
	OSwp+nEjlt3H12tXAz2xanlQQwlEg/E2ILwPAFOVklOsZ402LOBQaXZ8y6LOunFbo2TNCDjnCQ+
	JFQ0jHNKhRvZ6PZm4rXlZzGVukPtelZJZIO4HHsmUsDmDR0kU2rtx+gmpkk/0C40MMQJMEQJbuB
	9xN1AqbDBciJynfG27Xq8NBYj3oc6f+TRZrXWupOkJFaT5LKd54Xhpk8pz7Ky7jvZSJkUrQVbBe
	Qos4xpFmqKKBfvNAj6dR8nIPz6xTsR2pqD/CpRp8zvz94fH28TLywm26CopbdDnywwWV4G56Bi5
	lbgljD2hEdBOphZQ4gEZLOh9m7MQ1QWtdXuRlVInEEGlHhMFi+9vwRjJ3cxNjKPq3Bp+1gUD5gl
	liI/AzhXW7FS/ZTgeFsVH73Ioi+44YMAAs6YxkQewZISSeoZuqGvCrcj4=
X-Received: by 2002:a05:600c:300b:b0:486:fcc7:6811 with SMTP id 5b1f17b1804b1-488783d24aemr49172815e9.10.1774979058252;
        Tue, 31 Mar 2026 10:44:18 -0700 (PDT)
Received: from precision.tail0b5424.ts.net ([2804:7f0:6400:80bf:5df9:f3dc:e523:9865])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-56d58893d37sm14086712e0c.3.2026.03.31.10.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 10:44:17 -0700 (PDT)
Date: Tue, 31 Mar 2026 14:44:12 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: David Disseldorp <ddiss@suse.de>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>, 
	Bruno Bierbaumer <bruno@bierbaumer.net>
Subject: Re: [PATCH] mount.cifs: fix buffer overrun in set_password
Message-ID: <gbcm4vg7zuypkhcec2hrb6mpxh5nallpyp33s2wbwlzbwzvbpj@aeg3rweqrmyu>
References: <20260331000911.16062-1-ddiss@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331000911.16062-1-ddiss@suse.de>

Reviewed-by: Henrique Carvalho <henrique.carvalho@suse.com>

On Tue, Mar 31, 2026 at 11:09:11AM +1100, David Disseldorp wrote:
> The existing (j > pass_length) check is insufficient to avoid dst buffer
> overrun into the start of the adjacent struct parsed_mount_info field.
> Check for overrun before writing to dst, and account for comma-expansion
> and null-termination.
> 
> Bug: https://bugzilla.samba.org/show_bug.cgi?id=16044
> 
> Reported-by: Bruno Bierbaumer <bruno@bierbaumer.net>
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>  mount.cifs.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 1923913..d41ca6a 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -350,13 +350,13 @@ set_password(struct parsed_mount_info *parsed_info, const char *src,
>  	unsigned int i = 0, j = 0;
>  
>  	while (src[i]) {
> -		if (src[i] == ',')
> -			dst[j++] = ',';
> -		dst[j++] = src[i++];
> -		if (j > pass_length) {
> +		if (j + 2 >= pass_length) {
>  			fprintf(stderr, "Converted password too long!\n");
>  			return EX_USAGE;
>  		}
> +		if (src[i] == ',')
> +			dst[j++] = ',';
> +		dst[j++] = src[i++];
>  	}
>  	dst[j] = '\0';
>  	if (is_pass2)
> -- 
> 2.51.0
> 
> 
