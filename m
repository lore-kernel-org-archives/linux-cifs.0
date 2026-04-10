Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C96833D4FB
	for <linux-cifs@vger.kernel.org>; Fri, 10 Apr 2026 21:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775854957; cv=none; b=Cr4HwEqfmA9YpkCbjcUU+YjLwHkjjVJhVJzn2XCYaoKhI8snKGqtiFON6yd3NVRUJXyQPRs+YWXF/hn+3o/M29EPpV4CCSsW7xB4ORxgACHDVbk8WB7Qz4AfRWYEKVVbvTqr66Uc0ppyGttZ1Xf3AsAiab3zZYAl2NmRtLIxDdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775854957; c=relaxed/simple;
	bh=9xqkXDH3o5aSwWBdUZhXrAzKi7tajxryrTjWmlprNgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fHnb/S3h1N00cSwkoBf0DcTFIKPheLaxxTq3GvVxyHVyXEwrtwYx/CqYuhwWX9ro414YYu4v4DP+w+7mAxzHVYTn4O8xK5T4+RDQRXpieAtKQ5lYq43ty6HXMNRUT609BUPqPBmgwLweIJS+d1vT57CzakjU/IlujdjQc6q3DAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Bhwvc8sK; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Bhwvc8sK"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-488a29e6110so28318805e9.3
        for <linux-cifs@vger.kernel.org>; Fri, 10 Apr 2026 14:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1775854954; x=1776459754; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sun3fsG4LspnWyjkCY2kXfvLourR47k4fQ5gMPWbJRo=;
        b=Bhwvc8sKhlFQsdH8wApTQysPcS2ElTm4M+j7aOkK4XD7tlk0aNxEuH+Qb4v7QpGwd+
         zaJjJ3yTvn/OjBemSfLbsYHRI0otm8kTrGZS/VarAJmAfkee1NyMccmgW6fhTAZFodKk
         5TreADbpFM25aARpWrXgI+Z/pnyHwdO9T+Tyvzv/z8ilcnwGoC+kCNA+cljqQGpNL+Cz
         sb5jUU08YGOgrDvg4iRG2XK86+fCAm0t3RYv29SL2JIwvcf8WQmC96ileomfaSxDDzYR
         HTrF1xwVuVvxF1kJUOWqI95t7DvFUt2Gk/HyBV6eX76flDa1ivAiKEoWb/HXd9dnGlw6
         IjTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775854954; x=1776459754;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sun3fsG4LspnWyjkCY2kXfvLourR47k4fQ5gMPWbJRo=;
        b=TTfqjZ+IHvluodTBBGVXymoUbkeVxlkw+gpFDe10DfWqzc4dFPDqEkiCtMWYXvWcRY
         LzNsgsPP0+StSogBq+ArH8GvQh3Ir4VXCKLqM2LD8erKDbTfJuPjEuf6Or3ld63kHjBQ
         OP2vlpPqemDb+jUolABRAhSsdlhcddncqxQ3e/EF3CB3eVmBKAvD2Xr+PjjDuwPoAfjf
         6vPbn6Yw1/Hon4hM0Y2kVwBMyrbiCNehIynWFkoIv4jTyKh4oB8JOc95n8sFKhLHZAK2
         H7JhPhL4vmcYJ8+l4uhiqdT2LAgMGyNPeZ3fRvqMqF39HaPh91y0QTGSTyDyQLam2U8Z
         THDQ==
X-Gm-Message-State: AOJu0YyjF0CnAbonnUa9gEWe4+bp0B40XmZrW38fHvUKQ6lYVonJn/PP
	lLG2kHZQGr3r85RahjHOMKyigg0zA2/MjrNzRUPz7kxJtV72GOU7zLz6PXQIelY5emI=
X-Gm-Gg: AeBDietz1IrKyIvwTo1Kr03zlumOFHomzGgR/H4w9pdjqGwXWcY0KphYajaphgDbEbg
	LbLy+4g833GTubP9DejR1ts9427s1ZJf3ANL+V54Zi4YDM649xR8+YoyNcKODO2PF8hKpqfXSbj
	hWuCDIXVvJu8nMd0Pcc+HQauHgPhNWh7DNFSAYzGjzOUM/g5sRENljx5OSAVmgG69P7OL52Sk3s
	bOn6U2YuimGvEItkVAXLRDrAvgqTqaukygLrI2WptilHL3O9K9CzCOE7QMXAHG/UhHLMlAseKvt
	Qud3q9nvVZcRourQssclnmSM6D/6WNnwJvCGGOHXy3OOWxhf74egQ+YPKESEYK3Kk7KgcEhlGvJ
	Sxn+X6uGNu/WwnuYF8uNjkA7jVteNNCimHytv3TIlo0xF4CpaxFlkQLuUoTpTlecy3d8qeAgb8b
	YxHx28cwUvBPWnkFXxX3cv95wX0WX/YWFGj3yNFhHfQ5tZCinCi6g/hTQ=
X-Received: by 2002:a05:600c:4f56:b0:480:690e:f14a with SMTP id 5b1f17b1804b1-488d68765fcmr66959155e9.14.1775854954426;
        Fri, 10 Apr 2026 14:02:34 -0700 (PDT)
Received: from precision.tail0b5424.ts.net ([2804:7f0:6400:d040:6795:56c9:49cb:ad88])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c34acb077sm4566350c88.6.2026.04.10.14.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 14:02:33 -0700 (PDT)
Date: Fri, 10 Apr 2026 18:02:28 -0300
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/8] smb: smbdirect: change
 smbdirect_socket_parameters.{initiator_depth,responder_resources} to __u16
Message-ID: <ev3jzzcrkusc5s2rld5vn7myfc2oyamzsdnbh2jki7yodt7t56@is2n4webgeq5>
References: <cover.1775571957.git.metze@samba.org>
 <a72f02560aadca368b8f136d635ff5144b690517.1775571957.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a72f02560aadca368b8f136d635ff5144b690517.1775571957.git.metze@samba.org>

Acked-by: Henrique Carvalho <henrique.carvalho@suse.com>

On Tue, Apr 07, 2026 at 04:46:27PM +0200, Stefan Metzmacher wrote:
> We still limit this to U8_MAX as the rdma api only uses __u8
> and that's also the limit for Infiniband and RoCE*,
> while iWarp would be able to support larger values at
> the protocol level.
> 
> As struct smbdirect_socket_parameters will be part
> of the uapi for IPPROTO_SMBDIRECT in future, change it
> now even if userspace sockets won't be supported yet.
> 
> Cc: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Long Li <longli@microsoft.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Henrique Carvalho <henrique.carvalho@suse.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> ---
>  fs/smb/common/smbdirect/smbdirect.h        | 4 ++--
>  fs/smb/common/smbdirect/smbdirect_socket.c | 5 +++++
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/smb/common/smbdirect/smbdirect.h b/fs/smb/common/smbdirect/smbdirect.h
> index e70a21eb57f0..8fbffe3eb845 100644
> --- a/fs/smb/common/smbdirect/smbdirect.h
> +++ b/fs/smb/common/smbdirect/smbdirect.h
> @@ -32,8 +32,8 @@ struct smbdirect_socket_parameters {
>  	__u32 resolve_route_timeout_msec;
>  	__u32 rdma_connect_timeout_msec;
>  	__u32 negotiate_timeout_msec;
> -	__u8  initiator_depth;
> -	__u8  responder_resources;
> +	__u16 initiator_depth;     /* limited to U8_MAX */
> +	__u16 responder_resources; /* limited to U8_MAX */
>  	__u16 recv_credit_max;
>  	__u16 send_credit_target;
>  	__u32 max_send_size;
> diff --git a/fs/smb/common/smbdirect/smbdirect_socket.c b/fs/smb/common/smbdirect/smbdirect_socket.c
> index 1e3b361728cc..4003753bea26 100644
> --- a/fs/smb/common/smbdirect/smbdirect_socket.c
> +++ b/fs/smb/common/smbdirect/smbdirect_socket.c
> @@ -166,6 +166,11 @@ int smbdirect_socket_set_initial_parameters(struct smbdirect_socket *sc,
>  	if (sp->flags & ~SMBDIRECT_FLAG_PORT_RANGE_MASK)
>  		return -EINVAL;
>  
> +	if (sp->initiator_depth > U8_MAX)
> +		return -EINVAL;
> +	if (sp->responder_resources > U8_MAX)
> +		return -EINVAL;
> +
>  	if (sp->flags & SMBDIRECT_FLAG_PORT_RANGE_ONLY_IB &&
>  	    sp->flags & SMBDIRECT_FLAG_PORT_RANGE_ONLY_IW)
>  		return -EINVAL;
> -- 
> 2.43.0
> 
