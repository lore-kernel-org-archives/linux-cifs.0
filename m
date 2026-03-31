Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7180741323C
	for <linux-cifs@vger.kernel.org>; Tue, 31 Mar 2026 21:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774991007; cv=none; b=f75kkBNWusbcIzlCvwb60ypI7v3DSOk/lYL/09HhWfLQfDnqTvRYwNWe+1IaMyJPWULC2nt9sHgccvjk3FlTc/tLE5Boxm/IYkuctVM6xDrSJSWRTEq6tEslPs4W3rzVz1IlRoZ6L2mo/VL0FVJd5Exaf/9JlGyfKnb1dALSHQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774991007; c=relaxed/simple;
	bh=Grj4Aj7t4qYD4NAnKZxMJasDukyJQLioxZv0EOq+uyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UKMYvD/pgvbNdm7lsdKU87U+lUEsAH5ZeJNP7Dm0mnYkIxQryBhs8Nr0ejg/jXH0TZ2srDmBtljGvtEpqgIg7+Ngun5JiVTD3W/CFVw27BeEFFR4fiJ+CKAOStk2/4mDe9nKctlQ7AGYFV3leed6GA4sa2ye1xgM61MM+lcFsGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=DYYZZt7m; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="DYYZZt7m"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4888375f735so1643265e9.3
        for <linux-cifs@vger.kernel.org>; Tue, 31 Mar 2026 14:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774991004; x=1775595804; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jgm/WXZTBXhjWvNoLSnETxQrx97NfCmvRMmWqMUc/g0=;
        b=DYYZZt7mbKB/LynLca9VMAYmIZOOJxaV1MAjAoCa4xfNjtLqB+wOkRsoBJ1xZwsr3G
         2pJCQHuhub+UAhOW2QdOYmrtLXj2H0HmpcsYjNNuGzxzSrvUK1hWe3sZcflLqbcCTOOK
         75hPqunl0iNrLDvWIQfGYlofSZlubG6nVUv3FNDzzI8mEgY9M5oeI5kwMKQaZL/kskDO
         Wh5tElu9HqXZtSEHjfMbH93RhUoNmBXioJXcRpqZOPndumcQHVTPIY1x4Oe3GdUvMl4x
         XeUPiW4GqFpf56E/OxhK1OXVZq8sJrQoO1BdNIkDZ1PrJGv8YRzQ2tn1Zws5nGI9WJV7
         3x5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774991004; x=1775595804;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jgm/WXZTBXhjWvNoLSnETxQrx97NfCmvRMmWqMUc/g0=;
        b=LBSRhEMjX9S+VfMx7A1zWnEQKi48/+N7qL2oSsrHa/SdHPY+ynd7i9gP2ELf6441sy
         L5K8dXfN1aS3NsAyDrWp6mFMaOpZ0HM9PDFt/rx/9fPF3ozjtp7G7OtUADRv3f3pV2lF
         EiZ6pKigJblpnqKmjnPFCoRXSq7MhsChuT7d3EhPyyIuMGC8tkFatPgezmwYeUnvTb48
         idV/+p3w+HL2wy8GBSFexRRGQPhbz81XyNi+aUUHwram6V3USpu0+19Q0x3chQD5cyFf
         ay8Zj9tFNl9FKvXXYK0uVxNf3gDFm4uvmJGi6ILql3SjeiwR5Wc/cFBjSdBv2BwnVXRn
         ZOtA==
X-Forwarded-Encrypted: i=1; AJvYcCV2csxAk3lQJyP09xNSNnjE40CZWFx59rD3r/6us9jjU/H4NV6e2/TPtxcXdGWf4s2WzbX4Auvfbiwf@vger.kernel.org
X-Gm-Message-State: AOJu0YxV6XRsgNrv90sdPEdgKbMxWBJby54NJiWjr98o9HYeeDxTMkwd
	mfuS6FiOECDmO5trAlwhNN0/8STiEqL1bgePVOfW1rC8Sf6jtQsjI9zMJ/364UgjZew=
X-Gm-Gg: ATEYQzy3RWgblz63QkhsXFhCNj1PLV7V2A0gWH9hv8Oca1YjiH+NyK2/JWPat1Xr5s1
	Twa9xf/+h+0pBHkYGBZSdXwzx2czNVVQzA598TVX90wBJrHKZKc3j//iWlkYb7XER7/trLrBVZU
	h3BGeFf397biO/yTRQ3KMXe3SrnxHtVuGxadc2eoXQPnx/29Rk++Arw5KKypcPI5VdO0xRULmI6
	thBKy0EDxm+uj112+WYa9s4qrmR//hewfxDe03+ij19GWbzGN6e8/FdfZD/HnrqgiRoMrATkLDX
	cGLtplQjCBvzuvu6vLWaj3GAR5/SPorE3rz6+NC/miX+weeh6r2iswwec2NoXpkBJFK/sNaURVp
	yVUD5SNxw83QJ0+xtSBPBZHy2ijuytt9jgJ0okXCsOAZqsVquUN6ZI6imx4gxYRMZEfDMnBc42M
	b5lHciWhC0uqmholkPvamte3HNBssQMWijFGhq+CF++XmNFBQvWfV0tYk=
X-Received: by 2002:a05:600c:a16:b0:480:3ad0:93bf with SMTP id 5b1f17b1804b1-4888359ddf2mr13216685e9.24.1774991003701;
        Tue, 31 Mar 2026 14:03:23 -0700 (PDT)
Received: from precision.tail0b5424.ts.net ([2804:7f0:6400:80bf:5df9:f3dc:e523:9865])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-56d58a33bf3sm13981268e0c.14.2026.03.31.14.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 14:03:22 -0700 (PDT)
Date: Tue, 31 Mar 2026 18:03:18 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: FredTheDude <FredTheDude@proton.me>
Cc: "sfrench@samba.org" <sfrench@samba.org>, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] fs/smb/client: fix out-of-bounds read in
  cifs_sanitize_prepath
Message-ID: <m3gezmqwah6abgto32onma3n4h4n3cnpfhjsr6xhczunk5ad3y@gmktkcnzjaiy>
References: <f6jyHqZ0Ycp1KP50Nf0K6QULaw7WbojZIPK4NrYYw6zNoj93MvpecYMT0xE5mjChSgdLhieKk9rpjUDjWtY73UAjwFGS85VxlkO4yJuEInE=@proton.me>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6jyHqZ0Ycp1KP50Nf0K6QULaw7WbojZIPK4NrYYw6zNoj93MvpecYMT0xE5mjChSgdLhieKk9rpjUDjWtY73UAjwFGS85VxlkO4yJuEInE=@proton.me>

Reviewed-by: Henrique Carvalho <henrique.carvalho@suse.com>

On Mon, Mar 30, 2026 at 09:10:14PM +0000, FredTheDude wrote:
> 
> When cifs_sanitize_prepath is called with an empty string or a string
> containing only delimiters (e.g., "/"), the current logic attempts to
> check *(cursor2 - 1) before cursor2 has advanced. This results in an
> out-of-bounds read.
> 
> This patch adds an early exit check after stripping prepended
> delimiters. If no path content remains, the function returns NULL.
> 
> The bug was identified via manual audit and verified using a
> standalone test case compiled with AddressSanitizer, which
> triggered a SEGV on affected inputs.
> 
> Signed-off-by: Fredric Cover <FredTheDude@proton.me>
> 
> ---
> 
> If I made any stupid mistakes, let me know.
> I am just a high-school freshman, and I have a lot to learn, especially in C.
> Thanks for taking your time to look at my patch.
> ---
>  fs/smb/client/fs_context.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index 03c112f4d..3f0faae99 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -588,6 +588,10 @@ char *cifs_sanitize_prepath(char *prepath, gfp_t gfp)
>         while (IS_DELIM(*cursor1))
>                 cursor1++;
> 
> +       /* exit in case of only delimiters */
> +       if (!*cursor1)
> +               return NULL;
> +
>         /* copy the first letter */
>         *cursor2 = *cursor1;
> 
> --
> 2.43.0
> 
