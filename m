Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40DD28BAA6
	for <linux-cifs@vger.kernel.org>; Wed,  6 Aug 2025 12:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754484500; cv=none; b=uCZCzFoijYH4+/PujE1Y776K+2/Mx7pDtgLBtSSr5iPlvikO02s0W/hPFR6FhBfPoEmbLoCYZdV1spGcm0ycbnHZvz5gYBRqNNMytPvVv4iVZHhMvsbtimeod48r1gtTbiCtq8um87vk1dWKSVYqJqm1gyrcYBdTHlP73YL3LzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754484500; c=relaxed/simple;
	bh=HfI/zx9XDbVgQ0otqTbAOpA5i4S/wWlfQ7OSkosJO10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KlG2u0nICOW5X611KVFXINtMs7ALaedKdz9iI5LlVYkxdGNsF07QvpiG5rdjzbW8LyOx/Lquc9duX1w2UZAqJd6wMxP7IJQ5RIB4XXpCqNGJSJlLqmR6xrRNwCqa4LPtB3RSH3K4CDM8GImK6wdvN++a2WPYGg0o+7deEP/6bnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=imzq8hEa; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="imzq8hEa"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-45994a72356so7590675e9.0
        for <linux-cifs@vger.kernel.org>; Wed, 06 Aug 2025 05:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1754484496; x=1755089296; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jFXnqIPRbV3BB6pjp/TTF7phDE5SLRKlO1oZx1A596Q=;
        b=imzq8hEaQBpaEeYBfp44rNq4dTIj4SrxeqxANKEtK3ajHy8UdWmInIe96u7qAnHC0C
         yRe+FekfmJ7V1aA5yt1Xu2+3TmL8deEKqe49J9hXWvsf++BWmndxW49sdLPjSjTY6s7s
         cWuZ0k38qMWS4VPjnBCFVq6KBfsewMfXFO9Q67lyDmMK0Dty1jbhGGNEo+hOvmCTw+10
         NiJdZlMvBb0pdTXXYJFl0/Dpno5MCzU764fyYH9nx1N+insNmrcV09rDDMuUrJS1IxH0
         icWPVTmY2ZBe/4UTa+ZcUc1ro+Uni28FoKE6JjvlVQQqTjbdlhxDbDV90DvjDcv9vJXm
         KIDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754484496; x=1755089296;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jFXnqIPRbV3BB6pjp/TTF7phDE5SLRKlO1oZx1A596Q=;
        b=rcONj4ar7ouJoYUij8IpjJYeb+/L5qfTZftvzIxwA/Yu95kLtQa1CJHYU+br0FwqUf
         EXBLBEhbhHHQzXTVhxM7OJ1nxF+ddf639zMtsi8RY/FSe7bp1qkLotkQ4h72C9Vs+xeW
         N2Xwu9UsBCkpdSKXO3VB72EMwBG43uXJ67wCBjs4tumPcDx7HnPcGGw++5a5AVzC00MP
         Vl+jCS5iKkuGHJbH6bQkAujMh9ikYgWYniCFMlfMpHbf7ozbKTwmInYeKo4NJVtBZmVr
         dKMI3WgzF7S1X1j6K8/kYwUZlxOhY/BPO5cV4Adaoc92fx2Da5qDxpVNiwFP3quEt1t6
         o3ng==
X-Forwarded-Encrypted: i=1; AJvYcCXYKq5L0F+LsBcEfj48iqqfNZY+HjGk5Fj3zxGR6UUhL8BSAiLsTFBh1TKXskgt96sxw5h9fLzty046@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8vAa8jJVJM81hezhyev0eqjpCCwLYn+NOH72dcGJxoznN4zmS
	0h/aswQlj/3JdplcyqqWF4BG9o+AQug3MXVt4OmYEyxv1X2G8kYfX71sdNgTRucZ8k8=
X-Gm-Gg: ASbGncuyJP6Jo+JwPks41oR+9ubzZSPHQa0VZq+TF0TFh5zyXkIN/FS8UI3cINJbRe+
	+DSaM1bd8Ktwi5qcUUIZfu1ORfPRonHuTg6BgE4t8E8LQwcd6Wu/U/k/p9JndovqMftHpL9Y7ql
	Y6l8mrwmeiCZaHJ6NXbwMWp0TyRZPADvUTK63AF+aDeJjM9DtBoa8HMwfj930CentCvmkS5nDgi
	a4D+BmGz1kTOQQ1m7dgtEjG6GXIvH0BdnHmxurw7JDMnC5X9Mt5f5Gs9s8IvtGocYJcW+uCm5gV
	MGcgnwltOB5nakn2XSfayaLWgPifKDEALw1fREvRYVyTPWafsPPjIjCU/fiop2bqIwgaz0qc1XR
	H5Ta7a8lKhdt2a/yrxI2B8I3wzuEkiUmzZI2Drw==
X-Google-Smtp-Source: AGHT+IHNdtNiD0VN2ibLWx44aT6ddin7+JcHP84VGabSPvwF+bE3cWHRcZxCTSkZKPKy4kZcasPWeA==
X-Received: by 2002:a05:600c:3e08:b0:458:b608:509f with SMTP id 5b1f17b1804b1-459e711e039mr25952315e9.14.1754484496042;
        Wed, 06 Aug 2025 05:48:16 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4595cfea56fsm95238275e9.1.2025.08.06.05.48.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 05:48:15 -0700 (PDT)
Date: Wed, 6 Aug 2025 15:48:11 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Stefan Metzmacher <metze@samba.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH next] smb: client: Fix use after free in send_done()
Message-ID: <87646c67-78b8-41c5-9b72-361cb3b733d1@suswa.mountain>
References: <aJNASZzOWtg8aljM@stanley.mountain>
 <ad2e9d94-2d95-4351-b800-627f20672209@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad2e9d94-2d95-4351-b800-627f20672209@samba.org>

On Wed, Aug 06, 2025 at 02:20:56PM +0200, Stefan Metzmacher wrote:
> Hi Dan,
> 
> > The mempool_free() function frees "request".  Don't free the request
> > until after smbd_disconnect_rdma_connection() to avoid a use after free
> > bug.
> > 
> > Fixes: 5e65668c75c0 ("smb: client: let send_done() cleanup before calling smbd_disconnect_rdma_connection()")
> > Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> > ---
> >   fs/smb/client/smbdirect.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
> > index 58321e483a1a..162f8d1c548a 100644
> > --- a/fs/smb/client/smbdirect.c
> > +++ b/fs/smb/client/smbdirect.c
> > @@ -286,8 +286,8 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
> >   	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_SEND) {
> >   		log_rdma_send(ERR, "wc->status=%d wc->opcode=%d\n",
> >   			wc->status, wc->opcode);
> > -		mempool_free(request, request->info->request_mempool);
> >   		smbd_disconnect_rdma_connection(request->info);
> > +		mempool_free(request, request->info->request_mempool);
> 
> The correct fix is to use 'info' instead of 'request->info'
> other than that the order needs to stay that way.
> 
> I already asked Steve to squash such a change into the
> original commit (which is not yet upstream).
> 
> See:
> https://lore.kernel.org/linux-cifs/cover.1754308712.git.metze@samba.org/T/#m98a8607d7b83a11fd78547306836a872a2a27192
> 
> What was the test that triggered the problem?
> Or did you only noticed it by looking at the code?

This was a Smatch static checker warning.  You need to have the cross
function DB to detect it.

regards,
dan carpenter

