Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D84194A76
	for <linux-cifs@vger.kernel.org>; Wed, 24 Dec 2025 08:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766564545; cv=none; b=T5SDVjtYM8IsfChkKIiKqQUab9jnF11LMgiPOAZRjP8II/hCtk4N2eTstUw4ze3rxmuiWyIb8LHPY0PfHmevVCBl0qDOWRVmVGPh0tYIusz+mVG9nIm1biTr2leO8LRm4aN8x5QjIuEdFQ/3u64n/qSa2H0dDRTluS6KlL5FFis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766564545; c=relaxed/simple;
	bh=N9GMDCUS7WqBIfDHYf0+ylVp9o+u4RsN7BKq6Pc2al0=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=hdud4SNPe+nLubzD17fJ1K9NQ1lraOdLf/KV20/6DCILLpcN8UNjse8M5eby8PdFfTjaskNJz+w5Hhv87YIauz0YPBNURQSfVnT9BoRJRF19EJKYe9Yt7x/y1YzZ2O2dmBmOW7hUWJSv54110QYpIs7hiovKAlE9XDcdzoBBalE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HOKYhYhT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HOKYhYhT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766564542;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KjiB9LN6Mpt3ks6jzEpBe8gko+0pAQsSxS4oVXjcOfA=;
	b=HOKYhYhTB9xbApgrvIucu/w8OGGoPwOWmq7B5JLMnvb0kwfcWxoKKfHSVEXIQlwNiJ3T5J
	71fXt6y+t7gSPTfREevRzOEZZjrYS57rcLQhJ2OHOvxwrhW7H+I2nV8665nLzIuBntKxyW
	PM81Xu49HpEmVqlHpADwYLyvkHM0YmU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-161-gSqV5_ckPC-QHWGEt0ddvA-1; Wed,
 24 Dec 2025 03:22:17 -0500
X-MC-Unique: gSqV5_ckPC-QHWGEt0ddvA-1
X-Mimecast-MFC-AGG-ID: gSqV5_ckPC-QHWGEt0ddvA_1766564535
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 448EC1956050;
	Wed, 24 Dec 2025 08:22:15 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.4])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7073B18004D4;
	Wed, 24 Dec 2025 08:22:11 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20251224023145.608165-6-chenxiaosong.chenxiaosong@linux.dev>
References: <20251224023145.608165-6-chenxiaosong.chenxiaosong@linux.dev> <20251224023145.608165-1-chenxiaosong.chenxiaosong@linux.dev>
To: chenxiaosong.chenxiaosong@linux.dev
Cc: dhowells@redhat.com, smfrench@gmail.com, linkinjeon@kernel.org,
    pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
    tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
    linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH v5 5/5] smb/client: introduce KUnit test to check search result of smb2_error_map_table
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1168034.1766564530.1@warthog.procyon.org.uk>
Date: Wed, 24 Dec 2025 08:22:10 +0000
Message-ID: <1168035.1766564530@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

chenxiaosong.chenxiaosong@linux.dev wrote:

> +
> +#if IS_ENABLED(CONFIG_SMB_KUNIT_TESTS)
> +#include "smb2maperror_test.c"
> +#endif /* CONFIG_SMB_KUNIT_TESTS */

This feels weird, but I think I can see what you're doing.  I guess it's not a
kunit test in loadable module form?

> +	for (i = 0; i < err_map_num; i++) {

ARRAY_SIZE(smb2_error_map_table).

David

