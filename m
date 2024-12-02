Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584381DF98D
	for <linux-cifs@vger.kernel.org>; Mon,  2 Dec 2024 23:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733181085; cv=none; b=jkSyXj8q4MdJmU8nY1MWBR3H5xa0fDgxoWOU8p0yrCC6Nm9iAFgXhE1Dk1aJrAykm9LiVXMDCCSvr1LL6/wvBn1WbEnPnZljugBqTVatnX/2/Ec6qHFmaIiPOvCVsd1m6w6xRimmAxf53g6fcCYArhktWTrTvTppdT7FclDKVfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733181085; c=relaxed/simple;
	bh=6NEVbfWC+enFz34lIGMTJ9WmSYTuDpZ7CtxOPSgpEZc=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=jEFwrwDad88qujnKsAf6hBULq1sMGhOCYwE7e+c2UkL7wGsL6YVlZrZqnpkh+cer4iPeTKGsbQ+aMuFQVLMtgx+jUvZ4rqkF9Gf+W9BxbyOE45aL81y1/Ggo2b5UqlA9WCOmwzUNo4Nkv5X/Y38z7g3BZ9IFwbKNyQV14/aEKwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fD9Qcxfk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fD9Qcxfk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733181081;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6NEVbfWC+enFz34lIGMTJ9WmSYTuDpZ7CtxOPSgpEZc=;
	b=fD9QcxfkSdsWt3cQsDqVpLIw5WR6lru56xejf7W00gzmdWxtKzUzMiO0HIGjkExsdHiy3q
	daWMlnB0O3/7bzwBTl/Fspq1ao45fqzxtPvWXUY1Ekynv3GVErRN5IRb6apy/KcUjzXut9
	n0vb8/sF339c3OI4paDYKBszaRM9CQA=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-373-J8NISyOjOHWMfQZgTQSiOw-1; Mon,
 02 Dec 2024 18:11:17 -0500
X-MC-Unique: J8NISyOjOHWMfQZgTQSiOw-1
X-Mimecast-MFC-AGG-ID: J8NISyOjOHWMfQZgTQSiOw
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C25651958B13;
	Mon,  2 Dec 2024 23:11:16 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.48])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A6CC71956054;
	Mon,  2 Dec 2024 23:11:15 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CANT5p=pUGYwswgXM-pniMjEWwbLK0cKXPBOJB9cG_cOrkBwQhg@mail.gmail.com>
References: <CANT5p=pUGYwswgXM-pniMjEWwbLK0cKXPBOJB9cG_cOrkBwQhg@mail.gmail.com> <CANT5p=qBwjBm-D8soFVVtswGEfmMtQXVW83=TNfUtvyHeFQZBA@mail.gmail.com>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
    CIFS <linux-cifs@vger.kernel.org>
Subject: Re: null-ptr deref found in netfs code
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <505337.1733181074.1@warthog.procyon.org.uk>
Date: Mon, 02 Dec 2024 23:11:14 +0000
Message-ID: <505338.1733181074@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Shyam Prasad N <nspmangalore@gmail.com> wrote:

> This issue is consistently reproducible for me from at least 6.12.
> It shows up when several reads are in flight in parallel.

Can you get some tracing?

echo 1 >/sys/kernel/debug/tracing/events/netfs/netfs_read/enable
echo 1 >/sys/kernel/debug/tracing/events/netfs/netfs_rreq/enable
echo 1 >/sys/kernel/debug/tracing/events/netfs/netfs_sreq/enable
echo 1 >/sys/kernel/debug/tracing/events/netfs/netfs_failure/enable
echo 1 >/sys/kernel/debug/tracing/events/netfs/netfs_write_iter/enable
echo 1 >/sys/kernel/debug/tracing/events/netfs/netfs_write/enable

Thanks,
David

