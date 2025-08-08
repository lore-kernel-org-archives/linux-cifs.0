Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFADF35948
	for <linux-cifs@vger.kernel.org>; Fri,  8 Aug 2025 17:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754673950; cv=none; b=kju6iCDtM67l16nnroZsx7iBcInkDlAkbnDEVYDLef2f5UHwNPREGiQXa3UynD9rql3iqHQHWT2JAlZLG/gkLKwNWKZFMHxzqOLryEf78MpJoDVyfX4oCEj0z90of9PCheR6JeKm2CbcEE7w3oXFPmBxzYq6RVrGMZaFYv/+AWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754673950; c=relaxed/simple;
	bh=cKWON+MNVCEnFy9/lmYI3igEZSr+GnOQq6Q+TJmTu14=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=CMH/zl5F6VAFStnuS0YgtyjM0DCWOySuUWn6N9x9wbkNeN1Brmq2M40zH3dJby/OMbrqDRSMAYehuQvTzNycLAICMFlYSAhlzHpFPvqFQLlFXx3YT/2OYLgjpIxibGqD+mob3PCtODgddi2rX2GYf7QWzBtaRGprPw4Eq2jGXNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BfYgKS0Y; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BfYgKS0Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754673947;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=79lZqFsCw1oT9Q6mp5jk4aDocHiI3mHPJRRd8ro+mY8=;
	b=BfYgKS0YonD7XHN30EFj85+9FwXCekLxZvG8wid/+G/p+Gop/hUrvwKzY6fvwXomO9eI+A
	QAA05ddY+Fietn8PwzaM63yeDSKh6YgmUp6ZKttypjCLyTt8SLlFn7k0AXjVn8xwo9ev+5
	ePyMi/gQUhvtzSizE6LOCJOQC6PZYlg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-321-zLjUtnEaP0qG5uCumLZAPQ-1; Fri,
 08 Aug 2025 13:25:44 -0400
X-MC-Unique: zLjUtnEaP0qG5uCumLZAPQ-1
X-Mimecast-MFC-AGG-ID: zLjUtnEaP0qG5uCumLZAPQ_1754673942
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F0B601800342;
	Fri,  8 Aug 2025 17:25:41 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.17])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A68783001455;
	Fri,  8 Aug 2025 17:25:38 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <nok4rlj33npje4jwyo3cytuqapcffa4jzomibiyspxcrbc6qg6@77axvtbjzbfm>
References: <nok4rlj33npje4jwyo3cytuqapcffa4jzomibiyspxcrbc6qg6@77axvtbjzbfm> <20250806203705.2560493-1-dhowells@redhat.com>
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: dhowells@redhat.com, Steve French <sfrench@samba.org>,
    Paulo Alcantara <pc@manguebit.org>,
    Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
    Wang Zhaolong <wangzhaolong@huaweicloud.com>,
    Stefan Metzmacher <metze@samba.org>,
    Mina Almasry <almasrymina@google.com>, linux-cifs@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/31] netfs: [WIP] Allow the use of MSG_SPLICE_PAGES and use netmem allocator
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2938702.1754673937.1@warthog.procyon.org.uk>
Date: Fri, 08 Aug 2025 18:25:37 +0100
Message-ID: <2938703.1754673937@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hi Enzo,

> >     (d) Compression should be a matter of vmap()'ing these pages to form
> >     	 the source buffer, allocating a second buffer of pages to form a
> >     	 dest buffer, also in a bvecq, vmapping that and then doing the
> >     	 compression.  The first buffer can then just be replaced by the
> >     	 second.
> 
> OTOH, compression can't be in-place because SMB2 says that if
> compression fails, the original uncompressed request must be sent (i.e.
> src must be left untouched until smb_compress() finishes).

I've got a change which should achieve this, but it seems I can't test it.
None of ksmbd, samba and azure seem to support it:-/

David

