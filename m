Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com [209.85.221.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8FA1DACB1
	for <linux-cifs@vger.kernel.org>; Wed,  2 Jul 2025 16:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751475518; cv=none; b=LaVD4bnWSB1OKShBSJ9IBxxGM+o589tZUOAQMQOZn827OJsK8wnvB2pfjsxuOfDRrtlBrREKpzGAWPOLwnejpytmqYLtgQfsA4RZwiYZ+uCAQQ1kYRWkw6MKG19zJOGMbpGzzud29SfqIsQJQxH7GdTdC+jCTtcd79GFN4RQ650=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751475518; c=relaxed/simple;
	bh=NrFQix9JKRWhdVhFAASa2lVFMF/owDzHAD1AuPt4rf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Np7XOWPJJ9023jNVxkVXT0JQt/0XTlE1/6PyeGwv+uHS4jJUFG6/dka/IzuYU7Uxp+ErCO+5Lh6kdoPB5C+0vaYYZd2AftcUR9TefIwIkQA2aHRrULyMQa0hQ9FEcWqF57bGsdZFjBUeN6vBtTkyK6J0OQmPKbdzEcd0GWVog0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XjSdCdRl; arc=none smtp.client-ip=209.85.221.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XjSdCdRl"
Received: by mail-wr1-f65.google.com with SMTP id ffacd0b85a97d-3a6d1369d4eso3953452f8f.2
        for <linux-cifs@vger.kernel.org>; Wed, 02 Jul 2025 09:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1751475514; x=1752080314; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CCK4GH47/qZS8k592FStcjtjSEYqGvfvMdMtR9Y7PjQ=;
        b=XjSdCdRlOdbAkQA99HFtostjSA4wTh2e//C/Kmv7S6fzopQYME1c/6A9HbhmCN9njp
         Ox3FoHaH9v/IBmHZpevRMO8H1CnNMX+Jf3I0Evwub6Uj7TEeP+vWRtOcz6pkgt+0OqP6
         /Pno98Cgi1+OxosMiSV2gWkASt/wOaLKy38+A6gr1//vrQzkJAzEoK1/LAoPn2mFWV4o
         x+s5Z9OdhyUYg5ufYpz43/y92z45djN3it3QyEWRA0pGXXX+/9Sod1MXg900ABylXg9o
         L3Rk4Sqil4itJK8mMqnZ4OjdAgvvM9kWvcYYnAk+3sdvGJiwr8Qbgia1t0lKXh9EIgze
         rQew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751475514; x=1752080314;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CCK4GH47/qZS8k592FStcjtjSEYqGvfvMdMtR9Y7PjQ=;
        b=kz/V7jCHiCjT1ohVEs1y/N5u2LKhZAwt0EUwitTp4TAvCqhRVF7O/rMnucIny/iGUM
         k7u5C/Jc02j1TA/7TeeG1rvfpQj4NMkGOYU0i8FuVvCWpWxunsxmfFHDK+7YcGqI8yDc
         98OKjHmTnmEy+WKSiKP7MX7tMzdXdqeycU+Sdy6AdaDKgMUuEa6ojiTXKhvtgMSX8IYK
         f6diUegioSmRKdBjTN87QuVqKaWl5kKlNgGMInaASg0daXW9TJRzejt0ORyFa+qD5rLG
         a0Toq7Z4I0/MKeE7Cg4AdRWoMG+YWVUZxzAKbZAQddpuQ0nzyCCGlKA/ddgXtlpSiWAS
         VQ8g==
X-Gm-Message-State: AOJu0YwGGkPhOepc3TYtNFfljxsZr5MvT3+XzRyB5RFuEKdM5HegbO45
	vCIsTE9G6LfS8VGeRzvSMAEqNuoB+0dJDvqem83kvHak3AIFQ+/mzWz/17iwe8ppGEWErML0qMd
	XMIrfR/8ZCA==
X-Gm-Gg: ASbGncs1JrVQZs5ZXX8QiUKSTa4RzFCuoZSzvU5lp06hx5b75bYGfxhHWoU1PuLeIxw
	ItrQT3L+bHxt9Yd8fry3pAlAxYaFiE6lKckC0xBqXXKOZgtcDi4dHdEMJ1e5F6JKCIA8OTlU5Xr
	/3gon4xfsexbotrderH7jcM9xoTK5e2Mwl8HygH6CphxLFHYgYhtx1G641vawtuJe/Ev6XHWLki
	Zlqq8kEZ5f5DVcKt74njpT7dQSzmaZbIVJ+HFq6e98qoZUqpBCOchPZ0W3xpgkN1tKLNZfy/S+z
	uWwS502c3YJHipW2CjWPG/xNnzd8U+i5ZSVOPikkvy7qtOchgxmhbIxJoEGJVXw1pGU=
X-Google-Smtp-Source: AGHT+IHgXBVIFLwJvjPJXTi6QDqtXqw+6CcWDngIXix860AQraAi/n9xgb+GXIVxbgQt3buJMFwhVA==
X-Received: by 2002:a05:6000:21c8:b0:3a4:e672:deef with SMTP id ffacd0b85a97d-3b2000b0a5cmr1959325f8f.36.1751475513976;
        Wed, 02 Jul 2025 09:58:33 -0700 (PDT)
Received: from precision ([189.79.155.93])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af57ee760sm14114767b3a.155.2025.07.02.09.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 09:58:32 -0700 (PDT)
Date: Wed, 2 Jul 2025 13:55:47 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.com,
	sprasad@microsoft.com, paul@darkrain42.org,
	Bharath SM <bharathsm@microsoft.com>
Subject: Re: [PATCH 2/2] smb: invalidate and close cached directory when
 creating child entries
Message-ID: <aGVkk8LT_RSwElO1@precision>
References: <20250630185303.12087-1-bharathsm@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250630185303.12087-1-bharathsm@microsoft.com>

Hi Bharath,

On Tue, Jul 01, 2025 at 12:23:03AM +0530, Bharath SM wrote:
> @@ -190,6 +190,7 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
>  	int disposition;
>  	struct TCP_Server_Info *server = tcon->ses->server;
>  	struct cifs_open_parms oparms;
> +	struct cached_fid *parent_cfid = NULL;
>  	int rdwr_for_fscache = 0;
>  	__le32 lease_flags = 0;
>
> @@ -313,10 +314,10 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
>  	if (!tcon->unix_ext && (mode & S_IWUGO) == 0)
>  		create_options |= CREATE_OPTION_READONLY;
>  
> +
>  retry_open:
>  	if (tcon->cfids && direntry->d_parent && server->dialect >= SMB30_PROT_ID) {
> -		struct cached_fid *parent_cfid;
> -
> +		parent_cfid = NULL;

I believe setting to NULL here is unnecessary, no?

>  		spin_lock(&tcon->cfids->cfid_list_lock);
>  		list_for_each_entry(parent_cfid, &tcon->cfids->entries, entry) {
>  			if (parent_cfid->dentry == direntry->d_parent) {
> @@ -327,6 +328,7 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
>  					memcpy(fid->parent_lease_key,
>  					       parent_cfid->fid.lease_key,
>  					       SMB2_LEASE_KEY_SIZE);
> +					parent_cfid->dirents.is_valid = false;

Shouldn't we set dirents.is_valid to false only after the open is
successful?

>  				}
>  				break;
>  			}
> @@ -355,6 +357,10 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
>  		}
>  		goto out;
>  	}
> +
> +	if (parent_cfid && !parent_cfid->dirents.is_valid)
> +		close_cached_dir(parent_cfid);
> +
>  	if (rdwr_for_fscache == 2)
>  		cifs_invalidate_cache(inode, FSCACHE_INVAL_DIO_WRITE);
>

Apart from the above,

Reviewed-by: Henrique Carvalho <henrique.carvalho@suse.com>

