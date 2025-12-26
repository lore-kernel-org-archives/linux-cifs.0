Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082132BD5AF
	for <linux-cifs@vger.kernel.org>; Fri, 26 Dec 2025 12:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766750811; cv=none; b=atDea02gj0zfPXNGivfNevTvI7oV6+hnY6dfus/eotMRjl0p9DaEeEMegCP9PTDa8O5BfVvahV5Gamk+0Q2EI6q90/E3SSP/cGuZSq3F8bBq4/3h7dXk9NqW0tk0yrdxE2ll/vYA6jxa+wyCPEMOvfRxI/Ol79XSUHdv/IFQM78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766750811; c=relaxed/simple;
	bh=F1snz0vmw3bS7HHmZTQ26ewjlPBBg8J98SitUhAUiLA=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=jCn/1GASO6x5lYxd/VMwWsFjI1c8f42t1Aq/Oj/uKVTY6Cgb8l574QRr8dVFHlyO0dXmGHyd00gUtJSYU4LKxiXebZdGPrBsXfNEOXH/DoOrvup77DoqevcStk05niNOeqWdV/whgcbNffyBhhNTjfBuwIYKRYCGYNFMbGSUPFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fLAkiQcq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fLAkiQcq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766750807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M5DD5Yxm/LbPWdScs5RvwZ9UchlrLY8ErE/DnLhahn4=;
	b=fLAkiQcqdsSAsfipGOnE2im5jljE3/bvV9/XWCO/0vmYS0dgYqqRZhkC9oOmTB0Z6bd+CY
	D1DYrP7fItcXvfmOVcVIr+npEJ+aXaW59wlW8Up5hkfF7jLWfgRRv/tOfhm8DvCaTnKs/d
	k7j88tOpy5wUgEaWjMDgufMzKoXICWU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-553-ZcPWBN9xPDuLsr4ZBL2Jbg-1; Fri,
 26 Dec 2025 07:06:44 -0500
X-MC-Unique: ZcPWBN9xPDuLsr4ZBL2Jbg-1
X-Mimecast-MFC-AGG-ID: ZcPWBN9xPDuLsr4ZBL2Jbg_1766750803
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B138E1955F34;
	Fri, 26 Dec 2025 12:06:42 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.4])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9A27530001B9;
	Fri, 26 Dec 2025 12:06:39 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20251225021035.656639-5-chenxiaosong.chenxiaosong@linux.dev>
References: <20251225021035.656639-5-chenxiaosong.chenxiaosong@linux.dev> <20251225021035.656639-1-chenxiaosong.chenxiaosong@linux.dev>
To: chenxiaosong.chenxiaosong@linux.dev
Cc: dhowells@redhat.com, smfrench@gmail.com, linkinjeon@kernel.org,
    pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
    tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
    linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH v6 4/5] smb/client: use bsearch() to find target in smb2_error_map_table
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1236710.1766750798.1@warthog.procyon.org.uk>
Date: Fri, 26 Dec 2025 12:06:38 +0000
Message-ID: <1236711.1766750798@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

chenxiaosong.chenxiaosong@linux.dev wrote:

> +static __always_inline int cmp_smb2_status(const void *_a, const void *_b)
> +{
> +	const struct status_to_posix_error *a = _a, *b = _b;
> +
> +	if (a->smb2_status < b->smb2_status)
> +		return -1;
> +	if (a->smb2_status > b->smb2_status)
> +		return 1;
> +	return 0;
> +}

Actually...  It's probably sufficient to do:

	static __always_inline
	int cmp_smb2_status(const void *_a, const void *_b)
	{
		const struct status_to_posix_error *a = _a, *b = _b;

		return b->smb2_status - a->smb2_status;
	}

as __inline_bsearch() only cares about the zeroness or sign of the return
value.  (Note the arguments to the subtraction might need to be flipped).

It might even better just to cast the smb status you're looking for to the key
parameter:

	__inline_bsearch((const void *)(long)status, ...);

and then do this in the comparison function:

	static __always_inline
	int cmp_smb2_status(const void *key, const void *_b)
	{
		const struct status_to_posix_error *b = _b;
		int status = (long)key;

		return b->smb2_status - status;
	}

as __inline_bsearch() doesn't attempt to dereference key.

David

