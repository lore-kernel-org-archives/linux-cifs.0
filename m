Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22003BD659
	for <linux-cifs@vger.kernel.org>; Mon,  9 Mar 2026 17:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773076739; cv=none; b=SuD4qXFMsYvLzLfmArAJ28N9drkyl59Sho+TZEgMRRVvmOD6JpoxInQbOoXHiZ9CLQ5WXFvBNs6grwVNo3TxoLCtcW36nuzad4vcyWwaS0Ca23ZPlWFmkoePzSU+spSkV704sm1eOKpJ7PFBFDSNvsdJFI6rFl3zyI8D3WWY/WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773076739; c=relaxed/simple;
	bh=LXPNVRwLDXG7DMw6P813qP1/gF0eFehhSZzvYzJcUjc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z6Y/x9DuFw/ThsgGZ510req/Undkb9p+cSP1AzloA8PBSuNIHAxhkrvdurjy4BjGH70d9o8KyQ3wubH6JcWGBBIA9jOMvZXUaXSzVLpcWi2SudwhmppD0/U+Bi5wY8cwrAPXJRFabRJSC44Q8QFkhbtXeBz+FFxcEIa6CpVrC3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=N96n+U84; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="N96n+U84"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4838c15e3cbso109254685e9.3
        for <linux-cifs@vger.kernel.org>; Mon, 09 Mar 2026 10:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773076736; x=1773681536; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cptXPxAdAWXaSBoqhq6AwKwxFicTFTDFRJrNRG70crI=;
        b=N96n+U849zivqSiLo+DHRXCIl/CDi5Jgsad2miJ2EXVLvLBvI5KggInqN3AVmvkweB
         ZjgDHLP1uKI071LWz7W2ihvqgR8PnzcGjXm6iK8US+CwuqRX7G3fjTUdp1RFA9va+DT5
         JyMtMjdvWGKcd1Yc32JeAkR+BBotZiISk7EGOIiuoB5Dff0+aWouhleq7w5R6+/3LIiM
         0Au5JCFXRjwyKCrJ/W+LEbgq985N6LRgWIiF9RJ/o/cFNqsMFVG7HxpSecIlaS59wrvZ
         A5jFA6KhZl8/kjIQs4bBXVvZeBW2L8tLcT0cFP5aRFoOdcPs3/jFoJs+yzUIzlvTKvgC
         KYAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773076736; x=1773681536;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cptXPxAdAWXaSBoqhq6AwKwxFicTFTDFRJrNRG70crI=;
        b=P5IF4oVwqJnSPdVldgpmPxJSeXTfSsR4VvR6adCBLHesrNylrO62gF5WnwR9OHHgt6
         M9pz/a+P+L/nsnYKjMRkagwrP6T1Ef+d/plUtLZIIikRIc8QK37aE61rKHPclRyi2TkD
         0WDHJC6b3s5vFgKivKzPdObuWZrQCtBFDSJlnGVy0bUzZULrX3Jg3XLUcdWMXxNZPdfc
         KwbxJUWbzq87c/Sr1G1LchoqUcWw6tgHHIl/pe6Z8Pd7KhlsAj0fHLkhFBWppBXMTclY
         nK+0FbpywDDJWlN9uuwphTYLY0WEplt4lttVpNRC7RmlXO1c1ycv3qzpsP2/HJLEFcp+
         b1FQ==
X-Forwarded-Encrypted: i=1; AJvYcCXnxeGheIl9UrnG8lgEY7xh3K/3nmEm2+e7JSgw7dSnDh2aIm6YH9U8wTlpaQ0xb9a+EWIrZSJzQ8Tl@vger.kernel.org
X-Gm-Message-State: AOJu0YwWripJxljsTfYxFJTWgYdV16pEzzenpT5ZmNkODEzyDRGyj/ym
	Sy52e7jD9XI+MptKvfQAtp9caeVkTDrE4J6FuYCtKY8mJ38gfWloaitNZAO5tihfXPxN4wpBqga
	gNBrj
X-Gm-Gg: ATEYQzx76ylcadIfiwESJbeTGmWeTLeHCcWFKB2USQCeeFyZnj5K1jkENmD/9mAv6Zo
	0WrlrYhtbOYLb8OZxfQI6eSdeq8iYHtCvtmL4ej6j/Dkfz2VMD9fk+Vh2hAXw2k1iLMOoFK5wXO
	Yh/PjXERxWJfyWisWJMZDSKWyYWtF3XNGN/Ak/SppQJSkcEE7CCAcqWSZPZGJvv7YRTcnqTDcUG
	p6nlnk1wW8QtqwJe0wlkNdEtZ95BU1ZLRccGhrx6fit10M+ZjygpGcTdY+ZLY8cadmpBdST3xox
	S3UTy302awJVgElTCrI1T93BtuKoHEKQUCsiZNSjtXb7thG72prIu6HSEpxk2Ka6IbjHZtE3Glo
	N34kRww4BDHFfTYv1qMWEfRlUbgd9d3k7p35x414MJGByzXFBwUhwIbup81OkbOHknYbYeFEB06
	6cz+RYYCJqflZDoNXNicHPiDo6R6aElkXofn+A0CmPWinjqUMJlThHHhg=
X-Received: by 2002:a05:600c:8708:b0:485:3c8f:e4c5 with SMTP id 5b1f17b1804b1-4853c8fe526mr44746275e9.17.1773076736115;
        Mon, 09 Mar 2026 10:18:56 -0700 (PDT)
Received: from precision.tail0b5424.ts.net ([2804:7f0:6402:5e5c:35f2:2762:2c6d:a7fe])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-94e7b5208basm8541666241.9.2026.03.09.10.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 10:18:55 -0700 (PDT)
Date: Mon, 9 Mar 2026 14:18:51 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Paulo Alcantara <pc@manguebit.org>
Cc: smfrench@gmail.com, David Howells <dhowells@redhat.com>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] smb: client: fix atomic open with O_DIRECT & O_SYNC
Message-ID: <nqw7sckluzinkdiqxcjx67tukzy5torrcniktahhqzyyjtzdkw@gjgrgc3xm37g>
References: <20260307212016.1328931-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260307212016.1328931-1-pc@manguebit.org>

Acked-by: Henrique Carvalho <henrique.carvalho@suse.com>

On Sat, Mar 07, 2026 at 06:20:16PM -0300, Paulo Alcantara wrote:
> When user application requests O_DIRECT|O_SYNC along with O_CREAT on
> open(2), CREATE_NO_BUFFER and CREATE_WRITE_THROUGH bits were missed in
> CREATE request when performing an atomic open, thus leading to
> potentially data integrity issues.
> 
> Fix this by setting those missing bits in CREATE request when
> O_DIRECT|O_SYNC has been specified in cifs_do_create().
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Reviewed-by: David Howells <dhowells@redhat.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: stable@vger.kernel.org
> ---
>  fs/smb/client/cifsglob.h | 10 ++++++++++
>  fs/smb/client/dir.c      |  1 +
>  fs/smb/client/file.c     | 18 +++---------------
>  3 files changed, 14 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
> index 6f9b6c72962b..2f4470f9df58 100644
> --- a/fs/smb/client/cifsglob.h
> +++ b/fs/smb/client/cifsglob.h
> @@ -2375,4 +2375,14 @@ static inline bool cifs_forced_shutdown(const struct cifs_sb_info *sbi)
>  	return cifs_sb_flags(sbi) & CIFS_MOUNT_SHUTDOWN;
>  }
>  
> +static inline int cifs_open_create_options(unsigned int oflags, int opts)
> +{
> +	/* O_SYNC also has bit for O_DSYNC so following check picks up either */
> +	if (oflags & O_SYNC)
> +		opts |= CREATE_WRITE_THROUGH;
> +	if (oflags & O_DIRECT)
> +		opts |= CREATE_NO_BUFFER;
> +	return opts;
> +}
> +
>  #endif	/* _CIFS_GLOB_H */
> diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
> index 953f1fee8cb8..4bc217e9a727 100644
> --- a/fs/smb/client/dir.c
> +++ b/fs/smb/client/dir.c
> @@ -308,6 +308,7 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
>  		goto out;
>  	}
>  
> +	create_options |= cifs_open_create_options(oflags, create_options);
>  	/*
>  	 * if we're not using unix extensions, see if we need to set
>  	 * ATTR_READONLY on the create call
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index cffcf82c1b69..13dda87f7711 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -584,15 +584,8 @@ static int cifs_nt_open(const char *full_path, struct inode *inode, struct cifs_
>   *********************************************************************/
>  
>  	disposition = cifs_get_disposition(f_flags);
> -
>  	/* BB pass O_SYNC flag through on file attributes .. BB */
> -
> -	/* O_SYNC also has bit for O_DSYNC so following check picks up either */
> -	if (f_flags & O_SYNC)
> -		create_options |= CREATE_WRITE_THROUGH;
> -
> -	if (f_flags & O_DIRECT)
> -		create_options |= CREATE_NO_BUFFER;
> +	create_options |= cifs_open_create_options(f_flags, create_options);
>  
>  retry_open:
>  	oparms = (struct cifs_open_parms) {
> @@ -1314,13 +1307,8 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
>  		rdwr_for_fscache = 1;
>  
>  	desired_access = cifs_convert_flags(cfile->f_flags, rdwr_for_fscache);
> -
> -	/* O_SYNC also has bit for O_DSYNC so following check picks up either */
> -	if (cfile->f_flags & O_SYNC)
> -		create_options |= CREATE_WRITE_THROUGH;
> -
> -	if (cfile->f_flags & O_DIRECT)
> -		create_options |= CREATE_NO_BUFFER;
> +	create_options |= cifs_open_create_options(cfile->f_flags,
> +						   create_options);
>  
>  	if (server->ops->get_lease_key)
>  		server->ops->get_lease_key(inode, &cfile->fid);
> -- 
> 2.53.0
> 
> 
