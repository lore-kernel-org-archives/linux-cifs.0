Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C306D29CB24
	for <linux-cifs@vger.kernel.org>; Fri, 19 Sep 2025 09:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758273396; cv=none; b=te+x4NUCXPTwAzPR7XywrNTI/2aS35hdYCMPrjGCR0OKJv6FCse2L4bZhZT4QlzXTqSeccVa2KqfkGvbc86UvDvFRGA0ajxM0q5CBjbjk7Mpssg68J3x6pbzeVed0E8Sl3Cuozoe4T3cviFc8DwGlqKI4qLyFg50w1ms6hFopZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758273396; c=relaxed/simple;
	bh=3NSAuKg48kDucBl+lQY28yZrJW6O+JKtv/vQq7ZLJw4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oIITJt9/zXUm21NUwtUmOki3gQMSYAXQ744blzd4EPFcB5sf5lXDsJOETocRTpH0TP0bwSGKgmTWpb1qgoxjYDa1rPOXI37YNqC6F47+lXVBA8YOCbbdJvAuMC/pIiD6k8PSARecSeSG/+Xa9F7BOfsvskg1boJFrY7yoU53Go0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=jIkfBxWS; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="jIkfBxWS"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4b7a40c7fc2so26838141cf.2
        for <linux-cifs@vger.kernel.org>; Fri, 19 Sep 2025 02:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1758273393; x=1758878193; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3NSAuKg48kDucBl+lQY28yZrJW6O+JKtv/vQq7ZLJw4=;
        b=jIkfBxWSlkjW5STzq37DPgVopUzsqLgx+5lZ5mRKt851bD5CPQ0b1Ki7IlmlwQiMYE
         H0xpl3LtCSTR/KGE26rJ4q7NsTw9tNEXpOp8fC4wELhU7PtsLQc8OnrHXMG5PofxzC+m
         GybeLzX+nLQQYDz1fGSuf4OPCRHsRuuf5BOEg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758273393; x=1758878193;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3NSAuKg48kDucBl+lQY28yZrJW6O+JKtv/vQq7ZLJw4=;
        b=qUMjGm2zjoICphnhaAyvX8Qy/aWM6QL/uXegqDGzNNBp6CoKBDbcFXfhoAlXI01TMN
         2amYBlUM5gUYhv4kc5lVRJ9fpFrBExWik/9SUnLYh6kHKeIhTYpzoXp6deVkLSmJRVIZ
         IUE/YE3tFmmCiP/eAuze55ktFHL7df68jehL8+KPTpCB+17Rk7xEtJiGsgjWHKp5y/V4
         vJBPT6gGf80CzKC4PQpiwECNH6gEPLedZ1xuEjz2OmekgIgx8fThx56GCqVC7hHvz2eu
         Xs5C8TTUMeC2H9jVGT1xjJuJESq1DtX+3DdvmQe4wt2lBb6XkSfIvFZrpPtLmJDZSaVk
         uMGA==
X-Forwarded-Encrypted: i=1; AJvYcCXTBAriyDWMQFoeKOoAaPOH3KedmYFDIUyIi7Oz3vtnWaxLJRiqtcAiui3lk0RSTiJ+Qvk76LxCbRny@vger.kernel.org
X-Gm-Message-State: AOJu0YwEvtmCwWw3JomZ7oOi6txodOhNcpVE+ipZIXkC9BYGylzJqq2F
	UiI9YQuBS/Wa1HzBUzTwnx+4H0/K2CVUJZs1TN+Pt4gi64HU9cMe3zmpZie7f2pdwmHa/fRyxDo
	xG83fDoH8oa+DFybXSfr1WUs/AQvVSVEb9RaKYLQhxQ==
X-Gm-Gg: ASbGncudUDdtc/vSS/7mv/aI1+14Qj0F8F86AolGJV4fUouy9AhEos1bYKVk6AtrlEa
	3SzZgBBfrj1PXW75T1FgDl8gjKi5Aervu3vMgqiA7pOcn7b/rXlsKbLhf7Db8UYz38SBxaiDZHI
	MmumFPoOcvtDViylunTxr6N+0KO+DmLf//sglXmZ2wY/ojkN/B8FD/gujxRd5amuiSZEjlt9J9W
	hVUey8AnnpdmdvZwJvgc4A40hCK50v0e5zOoyk=
X-Google-Smtp-Source: AGHT+IEC7DaOiqsDhZ6el+nJAXMCR2LZLpubNGOPgEov0Yiqge6V0MP8FIeK9NIu4a3q26iz/ROtYZA/OmdKQK0CbyY=
X-Received: by 2002:a05:622a:1189:b0:4b5:ee26:5371 with SMTP id
 d75a77b69052e-4c06e7cec5emr25872751cf.26.1758273392530; Fri, 19 Sep 2025
 02:16:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250917232416.GG39973@ZenIV> <20250917232736.2556586-1-viro@zeniv.linux.org.uk>
 <20250917232736.2556586-7-viro@zeniv.linux.org.uk>
In-Reply-To: <20250917232736.2556586-7-viro@zeniv.linux.org.uk>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 19 Sep 2025 11:16:21 +0200
X-Gm-Features: AS18NWBdR2wSIkWeUQEoOiuG4V2oEtZ00-2g_l56ym-IbHqMpDho5hZu73hYZtE
Message-ID: <CAJfpegsxUQzZaXKFAOBmThP6e5F=XT=oDn1BDBUO0R35D39P=Q@mail.gmail.com>
Subject: Re: [PATCH 7/9] simplify fuse_atomic_open()
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, v9fs@lists.linux.dev, agruenba@redhat.com, 
	linux-nfs@vger.kernel.org, hansg@kernel.org, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 18 Sept 2025 at 01:27, Al Viro <viro@zeniv.linux.org.uk> wrote:

Some explanation about the dput() removal would be useful, e.g.:

Non-null res implies either an error or a positive dentry, hence the
dput(res) cleanup is unnecessary, since at that point res will always
be NULL.

> Reviewed-by: NeilBrown <neil@brown.name>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Reviewed-by: Miklos Szeredi <mszeredi@redhat.com>
