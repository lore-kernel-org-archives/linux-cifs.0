Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11A3366804
	for <linux-cifs@vger.kernel.org>; Fri,  6 Mar 2026 19:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772825601; cv=none; b=emLpZjCFjqpGuNoYSBWhQajPwm5OJhDGfqIHKjHjhPsq0pJn/3CSO65rQY1BffOGeXAESbPkZAdrBvqmllk1VANB/Lw9V6WklB9kpPueb/Rao8viBph1ooZm2qJIiQm7Qbr/XfQw/txpQiEI8Zfw5vl4YeJ5oDqQ4iNFFLbF5C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772825601; c=relaxed/simple;
	bh=IROdmGyEAzVr2yFiikSwntP9m21zsnQy/XxqTLusAzE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EU39cIstqSJ3bJuSRu7z0AtuD5XDbFVlS5gqbk5peBgadwJZbXNEw/eO1ohaamVSHvFocPcqt+ql++xe6lhWRU0MBL5lTB5dQFnVtsSE4Puq0UxusmaPf8Tstfkr73hy8S7ledbipBMlCgxriG6voqotRKEpeaHQrrGAXZpYG+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KA7pV4SS; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KA7pV4SS"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4852b81c73aso2941625e9.3
        for <linux-cifs@vger.kernel.org>; Fri, 06 Mar 2026 11:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772825598; x=1773430398; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MAHLJKAJtyM24CDiIlJtLVqFqt8qV70IncQ0oyS87N0=;
        b=KA7pV4SS9DcWAFvGE59qAW/QNxeXo2ulD+xocap5/0Rh7gqVgyeJ34Asloou9iJV2G
         pw1UcWNiTSKdaNKnS5j4hhLuBnBgjVZ4u0ZFu98IhB5rsp8xb84V7MpjEVSfBtFtgqVh
         wfYHwLsaKVwKpxIDFLO0B5nMURHK2Vi+cVFLH3TzqlCUf0HMiGtazwsyxp+N5sDVr9Qa
         pitk+5MC+QWQXv4ADqSaSdT7/LWh5N06DkzvtQvdWOEZR1PaBnC77d97qSU9/tdTxNyl
         nDp1/blIcenZpxH6MTJivoGeMm5hb9kcZzNF+fYNog4wvLuwFf+26+pURdQGIcIH2otC
         qVtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772825598; x=1773430398;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MAHLJKAJtyM24CDiIlJtLVqFqt8qV70IncQ0oyS87N0=;
        b=GUi2V8xIIBLSELP9THixiRtUlr85jwyxYCzvTL7+e8WNhtT+E/yFkpGRHq9JJd9ndN
         gMOyo8Rq2ueYnusFNbciVNoN5EtBbLDZa7VC/ZWByck2+KWLg5xGpMze29F3NWJqI7RJ
         zBRWgeidXDVEk5wWp0wZQlznIKfgb0cX1CIqrDZv3PUZl4sipGJT4Ug4YMj9X0Njg1js
         n/9v1JTjk3QJk/xo4h/EvUVAEwGuKVl+7mZXoo6EOhQyfKYxM0zW5Gr/8vSuHiqY+b1O
         Wmnbj5pkgIq5LrFgP8u9I3w/rTLBeEbhZV3c/DahgURqt5l0ZFhQwJcrrrmCOQpq/Pob
         rYQw==
X-Forwarded-Encrypted: i=1; AJvYcCXnraMfwG+5Sl/Mfc9oIYFa8kQjJ6i3/VrWn9yWvMg3KPYbwk0q1QX/+vtcG50UOy5FWcyqjtZK9TTf@vger.kernel.org
X-Gm-Message-State: AOJu0YwPKEK8YKd5Ffbej7xPj80zRz19MZE9C3/UdDjfVGLuIClslfLN
	6V37Lge/IGuRtWxQaAkAWPfW6iXAQHU16fyHeIhWsJdgXxezfENmisBgIR2iVq2AeEA=
X-Gm-Gg: ATEYQzyyFkZ6yN7+JowKwd1MD0DjW0HjiFnz307mRvRpkPUeNiuw4wzD9iK8if3XcpE
	kj+rReXTyZ3NGGNo6E52t40wgxBegp5CMqAJmTpICTgYaWpTQfhOOdkI8PMLjsrThky1Imz5S7d
	CXUbMqsgAHgcCejXXOBWP290JzE+cPX3FNJOQ9eRcvRnH8v1+ppxabExbLJYwsDHJKR/AmrXkNn
	JBrKrj+ZmRu6Qv/HnJQZ0OyNMlSE/u4QvMcjGH67CtvAfu0E0OQy1gbIlSZ+xCsK134GSyJVa7A
	ZwcQ7llwxp3BqxsxaVCSHNUVeyKsvLijty1hNc/EeWdQyNnZcBxKuKuqtMevvg6z3gCY93kbyEZ
	6rGmFRCXnW9gs0Zx30yIKa4ZONZ76icg7IuZlyAdb5bT40lIjEU48VKipVWvcStslJhlg0S053w
	1SGIyEdi1PqjCjD4hnl54U8RdtmrHuIdr2QGHObVszgiIMP2op01qx1iv9uVoW90N/Lg==
X-Received: by 2002:a05:600c:3d90:b0:480:4d38:7abc with SMTP id 5b1f17b1804b1-485269304aamr51419315e9.11.1772825598302;
        Fri, 06 Mar 2026 11:33:18 -0800 (PST)
Received: from precision.tail0b5424.ts.net ([2804:7f0:6401:b8d7:ea6d:8ea1:ec5a:953d])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-94e7b5581e5sm2512719241.12.2026.03.06.11.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 11:33:17 -0800 (PST)
Date: Fri, 6 Mar 2026 16:33:13 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Paulo Alcantara <pc@manguebit.org>
Cc: smfrench@gmail.com, Thiago Becker <tbecker@redhat.com>, 
	David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] smb: client: fix oops due to uninitialised var in
 smb2_unlink()
Message-ID: <r7ojhnxu3jkr42oczp2o5w3hp5bs24ft5yav6nnlcohsybqeuv@zjvwndvvxayc>
References: <20260306005706.830672-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306005706.830672-1-pc@manguebit.org>

Reviewed-by: Henrique Carvalho <henrique.carvalho@suse.com>

We got a lot of those replay uninitialised bugs. Maybe we should prevent
them by having a replay(func, cond) so we can take advantage of a clean
stack. Opinions?

On Thu, Mar 05, 2026 at 09:57:06PM -0300, Paulo Alcantara wrote:
> If SMB2_open_init() or SMB2_close_init() fails (e.g. reconnect), the
> iovs set @rqst will be left uninitialised, hence calling
> SMB2_open_free(), SMB2_close_free() or smb2_set_related() on them will
> oops.
> 
> Fix this by initialising @close_iov and @open_iov before setting them
> in @rqst.
> 
> Reported-by: Thiago Becker <tbecker@redhat.com>
> Fixes: 1cf9f2a6a544 ("smb: client: handle unlink(2) of files open by different clients")
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: stable@vger.kernel.org
> ---
>  fs/smb/client/smb2inode.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
> index 1c4663ed7e69..5280c5c869ad 100644
> --- a/fs/smb/client/smb2inode.c
> +++ b/fs/smb/client/smb2inode.c
> @@ -1216,6 +1216,7 @@ smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
>  	memset(resp_buftype, 0, sizeof(resp_buftype));
>  	memset(rsp_iov, 0, sizeof(rsp_iov));
>  
> +	memset(open_iov, 0, sizeof(open_iov));
>  	rqst[0].rq_iov = open_iov;
>  	rqst[0].rq_nvec = ARRAY_SIZE(open_iov);
>  
> @@ -1240,14 +1241,15 @@ smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
>  	creq = rqst[0].rq_iov[0].iov_base;
>  	creq->ShareAccess = FILE_SHARE_DELETE_LE;
>  
> +	memset(&close_iov, 0, sizeof(close_iov));
>  	rqst[1].rq_iov = &close_iov;
>  	rqst[1].rq_nvec = 1;
>  
>  	rc = SMB2_close_init(tcon, server, &rqst[1],
>  			     COMPOUND_FID, COMPOUND_FID, false);
> +	if (rc)
> +		goto err_free;
>  	smb2_set_related(&rqst[1]);
> -	if (rc)
> -		goto err_free;
>  
>  	if (retries) {
>  		/* Back-off before retry */
> -- 
> 2.53.0
> 
> 
