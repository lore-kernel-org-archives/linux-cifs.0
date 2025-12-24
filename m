Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59123A8F7
	for <linux-cifs@vger.kernel.org>; Wed, 24 Dec 2025 08:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766563858; cv=none; b=OmaPO2/drrcuBaUbSrez5f+GecGeO4TFvQdc1HReh1mT4exh0oujAAWpGVcwHLHGn3oxKsqpxbRS0X0UKW075kIUMdFn/jhSAJSZZ8wDl0hnuOCuz99mpPE1jD/HsrOlAbC7kJIHCmaX59s8+Pvh3mRgK3IQPWQ8CamylTVPbfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766563858; c=relaxed/simple;
	bh=IinfhsZZjUoG15iry3k2KkQWrLg15aqgPy+w4YihZF8=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=o65MTE+2lyNuu9HokU0OZPbmHL6wWJgxNapdhym8Lmpy69/hGqfac7rhvY5USPQ9YnRPzIZk0hMHruHiF20thE6OQqGo595taKtmVn1a7nzuf1H3zK6BITF8bOhGs0+TOokDD5KH075pCcv/NvDaY9zGEjCXiHEqxsshihSYUhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dd+E8Umi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dd+E8Umi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766563855;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8AjSp1IZ4yyNSroIixhWmx5nNQyPZdTQIjwCKG5E+i0=;
	b=Dd+E8UmiVdLwwkzPB1DFZHyVMgAinPJIkmD+TqZxrF0qxBaDrtHGNp3NmQQCtT+0muvxq0
	RfNyfHaczfzzYzKSc4dbbyCNlKHhMLuPghva6KHfNso6J+c6H0D3e+tm04lRWg+oVdZeLP
	AGAdh/+2ND6KFxWwDl4x1JNQauYHlxo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-584-R-5P4XUbM1mWt3NTR78mJA-1; Wed,
 24 Dec 2025 03:10:52 -0500
X-MC-Unique: R-5P4XUbM1mWt3NTR78mJA-1
X-Mimecast-MFC-AGG-ID: R-5P4XUbM1mWt3NTR78mJA_1766563850
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 24C6C195605B;
	Wed, 24 Dec 2025 08:10:50 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.4])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C469030001A2;
	Wed, 24 Dec 2025 08:10:46 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20251224023145.608165-4-chenxiaosong.chenxiaosong@linux.dev>
References: <20251224023145.608165-4-chenxiaosong.chenxiaosong@linux.dev> <20251224023145.608165-1-chenxiaosong.chenxiaosong@linux.dev>
To: chenxiaosong.chenxiaosong@linux.dev
Cc: dhowells@redhat.com, smfrench@gmail.com, linkinjeon@kernel.org,
    pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
    tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
    linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH v5 3/5] smb/client: check whether smb2_error_map_table is sorted in ascending order
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1167781.1766563845.1@warthog.procyon.org.uk>
Date: Wed, 24 Dec 2025 08:10:45 +0000
Message-ID: <1167782.1766563845@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

chenxiaosong.chenxiaosong@linux.dev wrote:

> +static unsigned int err_map_num = ARRAY_SIZE(smb2_error_map_table);
> +

That's not what I meant.  err_map_num should be removed entirely and replaced
with ARRAY_SIZE().  The size of smb2_error_map_table[] is a compile-time
constant, e.g.:

> +	for (i = 1; i < err_map_num; i++) {

	for (i = 1; i < ARRAY_SIZE(smb2_error_map_table); i++) {

> +int smb2_init_maperror(void)

__init

> +extern int smb2_init_maperror(void);

No extern.  __init.

Looks good otherwise.

David

