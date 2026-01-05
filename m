Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E841C28E
	for <linux-cifs@vger.kernel.org>; Mon,  5 Jan 2026 08:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767600151; cv=none; b=T6n2k7RFRf8NOMAjrI88yqjFphj4PIFrAY+F+QP2DVMSXhh5IB3TBrhNH0p8TGNqwj355SPOR7mvWpXpWVdAb8UfalO/R+tvJ9jWdBS9dT8PJiEP1OYYDjD0fLMk2lL12ymtW9nBi6tHrpwYaOAqoabxpOLE+TU2R7wKAnSUyb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767600151; c=relaxed/simple;
	bh=sz3nkOrpHTUuhwl6UOiHfOlp14jZK4WYg50rqWXUXao=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=oY83cAQf/wer54JYb9IwbfVIX9mlAuZ5RlHMEBW+qh9IKCIkG3XTxfpzx0f0+lh8rzMd6C99BKGLItalYE9d8c63ii6lwdGYrnu2WsFGr1FAwIa14jQYpx84oyH7wBAnEh+Pf16VFkieggUHD78x9FSVL4xR/56nKHnmSZzqMe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KTQVYV3k; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KTQVYV3k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767600148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p8tL2klaybdErBSlfKbPtDytXnRdFzd/DduuzJFKlbs=;
	b=KTQVYV3kEfQEgVDAZdpo8OvHG6ietihQ0BHIJYGJ/NvrK5cxL2SlxcErddsAcqKr+hGVBl
	Kg2ff2dscOFDOMcHGtdGLY2Q93a7cn/6CctkUHLKlOzhFEAN3l3SrI+d1NTIFiS8p6w9N1
	SyN37im4cwcBhiEmKkzKpAuszcn3gbY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-9-xLriC3ezPo2aqWgfiKE7-A-1; Mon,
 05 Jan 2026 03:02:25 -0500
X-MC-Unique: xLriC3ezPo2aqWgfiKE7-A-1
X-Mimecast-MFC-AGG-ID: xLriC3ezPo2aqWgfiKE7-A_1767600144
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 44103195609D;
	Mon,  5 Jan 2026 08:02:23 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.4])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DD54530001A7;
	Mon,  5 Jan 2026 08:02:19 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20251231130918.1168557-5-chenxiaosong.chenxiaosong@linux.dev>
References: <20251231130918.1168557-5-chenxiaosong.chenxiaosong@linux.dev> <20251231130918.1168557-1-chenxiaosong.chenxiaosong@linux.dev>
To: chenxiaosong.chenxiaosong@linux.dev
Cc: dhowells@redhat.com, smfrench@gmail.com, linkinjeon@kernel.org,
    pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
    tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
    linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH v7 4/5] smb/client: use bsearch() to find target in smb2_error_map_table
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1696949.1767600138.1@warthog.procyon.org.uk>
Date: Mon, 05 Jan 2026 08:02:18 +0000
Message-ID: <1696950.1767600138@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

chenxiaosong.chenxiaosong@linux.dev wrote:

> +static struct status_to_posix_error *smb2_get_err_map(__u32 smb2_status)
> +{
> +	struct status_to_posix_error *err_map;

const status_to_posix_error * for both.

> +	struct status_to_posix_error *err_map;

Ditto.

David

