Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37BD21CC64
	for <linux-cifs@vger.kernel.org>; Tue, 29 Apr 2025 21:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745962391; cv=none; b=YYajU9uyWTDQ8wZe1BITyqeIRPDAKGOKw6gzKYb9+4zpjVRFQwyMruEk7Urs1mF4S0khKxuYEWnt6/hifijXzkRJ4Xvp55VgpTpJ9XdDI8XfnZmzbWPZh7u5R/YH4Jp5kZHyBzZtGMQEQMoDkFQEPx/k2oTzl2lIMUtzBeunLGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745962391; c=relaxed/simple;
	bh=ofBLhpdYq1LDANi0+1M1NVSgd24ARQA1JB17qr7Fdls=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=cvMCY3ZbkHLkNYIAnS4CNp+giFWFR5XlPw72OY0newv+xTexbfPq0TcKKk2nOwam+W3ZyQufFI6fTVSpiae2Wlu2MeAELi8V93RnmbrpQ+3nnAyVKBdsbi0Gus0bcvEnif7uAnBmLGKT+11zCH44cERmz2WAdQGQQz3c6y3qrl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gkj5FCKz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gkj5FCKz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745962388;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BB4MDHOuFDW1EmZQElJQLKL/8AM55S3+jZd4JxT0iyU=;
	b=gkj5FCKzYuB/F4hJ0nNaAXDdU7SDumBQKR+bZyxV6SE2IklAyuTzxgeATkzRngnczLYcfa
	nga1znijO2zBPra2LZAYOLxCLMr1L323cIbOWzPc/w3XNPQ552L1FQWaHi0FtMyIiCQ5Pd
	msmj1nNpon7yk4enp3tL2EXk+HdC5Xo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-518-2wY1IdrtNkqHr5uJJvRXEQ-1; Tue,
 29 Apr 2025 17:33:04 -0400
X-MC-Unique: 2wY1IdrtNkqHr5uJJvRXEQ-1
X-Mimecast-MFC-AGG-ID: 2wY1IdrtNkqHr5uJJvRXEQ_1745962383
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 54E2C18001CA;
	Tue, 29 Apr 2025 21:33:03 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.188])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2F6CD19560B7;
	Tue, 29 Apr 2025 21:33:02 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20250429151827.1677612-1-pc@manguebit.com>
References: <20250429151827.1677612-1-pc@manguebit.com>
To: Paulo Alcantara <pc@manguebit.com>
Cc: dhowells@redhat.com, smfrench@gmail.com, linux-cifs@vger.kernel.org
Subject: Re: [PATCH] smb: client: ensure aligned IO sizes
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <442318.1745962381.1@warthog.procyon.org.uk>
Date: Tue, 29 Apr 2025 22:33:01 +0100
Message-ID: <442319.1745962381@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Paulo Alcantara <pc@manguebit.com> wrote:

> -	if (ctx->rsize == 0)
> -		ctx->rsize = cifs_sb->ctx->rsize;
> -	if (ctx->wsize == 0)
> -		ctx->wsize = cifs_sb->ctx->wsize;
> -
> +	ctx->rsize = !rsize ? cifs_sb->ctx->rsize : CIFS_IO_ALIGN(rsize);
> +	ctx->wsize = !wsize ? cifs_sb->ctx->wsize : CIFS_IO_ALIGN(wsize);

I would flip the logic:

	ctx->rsize = rsize ? CIFS_IO_ALIGN(rsize) : cifs_sb->ctx->rsize;
	ctx->wsize = wsize ? CIFS_IO_ALIGN(wsize) : cifs_sb->ctx->wsize;

that puts the default last.

>  	case Opt_wsize:
> -		ctx->wsize = result.uint_32;
> +		ctx->wsize = CIFS_IO_ALIGN(result.uint_32);
>  		ctx->got_wsize = true;
> -		if (ctx->wsize % PAGE_SIZE != 0) {
> -			ctx->wsize = round_down(ctx->wsize, PAGE_SIZE);
> -			if (ctx->wsize == 0) {
> -				ctx->wsize = PAGE_SIZE;
> -				cifs_dbg(VFS, "wsize too small, reset to minimum %ld\n", PAGE_SIZE);
> -			} else {
> -				cifs_dbg(VFS,
> -					 "wsize rounded down to %d to multiple of PAGE_SIZE %ld\n",
> -					 ctx->wsize, PAGE_SIZE);
> -			}
> -		}
>  		ctx->vol_wsize = ctx->wsize;
>  		break;

Are you sure you want to get rid of the warning for the misconfiguration?

David

