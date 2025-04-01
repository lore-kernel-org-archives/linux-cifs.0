Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583CC20F07E
	for <linux-cifs@vger.kernel.org>; Tue,  1 Apr 2025 19:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743536100; cv=none; b=ErQm/dAszs6VOYMaXSPHuzQ8imu9uD+z1t2qLgqVAosCdoXyZi+UpIHooOaaUEeUiR3gMdCKEOI7nrtTSPTmW1AZSZOtdyDBQnIHDHAwfTg8aHSELpQ0r6Pf38qTp2vT2ggZxF4ghvcRGbXoiPas0uYq8d1b5f1m5X+dboe3gTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743536100; c=relaxed/simple;
	bh=P4i+0HwPhVM3ErME0GIAt5+Qwf05DYej3zOIW60qbMI=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=lrNbsZ3XquRga9XFatgh6Ns4Tu02+go27hj3jfpjgjpz/e7uoYRYUU0n/hTHQbauI34/rqPWddagczarp2ZZQ2VbZZOxJ7U12BSi0EuFJvf36uGu8X5PwF0YzdI64pD/3Z7mw7v4yTP8piBz2nS4/XrSrWfl7TENEq3DVmITNvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HhViRkEE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HhViRkEE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743536097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PePBBWjLDURrq/6U6v5H63WOmSM+zySD04XhQheN+DQ=;
	b=HhViRkEEKgD2tykWSZekrxkk2WJSbs8HbIrpnuGpH0tIp7sMxSg7DdH2tQcRliQ+XeK3Ij
	RDx2Mj4cxCpRsgQKbed2RZAuOWLexXP2FwChrNT7JZkzJGQkbyxHEW2X2ntZxdQIS53eH7
	4GZ42tctrqaglmjAeTo9kZQArv3gdVk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-205-fB-OFlUUMPmfS91806BZZw-1; Tue,
 01 Apr 2025 15:34:52 -0400
X-MC-Unique: fB-OFlUUMPmfS91806BZZw-1
X-Mimecast-MFC-AGG-ID: fB-OFlUUMPmfS91806BZZw_1743536091
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E253A1800260;
	Tue,  1 Apr 2025 19:34:50 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.40])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 97FA21955BF1;
	Tue,  1 Apr 2025 19:34:48 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <78c910b0-3391-484e-aa44-42e2f9ff4637@talpey.com>
References: <78c910b0-3391-484e-aa44-42e2f9ff4637@talpey.com> <563557.1743526559@warthog.procyon.org.uk>
To: Tom Talpey <tom@talpey.com>
Cc: dhowells@redhat.com, Steve French <sfrench@samba.org>,
    Stefan Metzmacher <metze@samba.org>,
    Paulo Alcantara <pc@manguebit.com>,
    Matthew Wilcox <willy@infradead.org>, linux-cifs@vger.kernel.org
Subject: Re: cifs RDMA restrictions
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <659108.1743536087.1@warthog.procyon.org.uk>
Date: Tue, 01 Apr 2025 20:34:47 +0100
Message-ID: <659109.1743536087@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Tom Talpey <tom@talpey.com> wrote:

> A single sge is just a hunk of memory that is registered with the RDMA
> provider. The routine you're quoting is generating the dma_addr that
> the provider (adapter) will use to access the data so it's passing what
> the ib_dma stuff wants.

The issue is that currently, we pass individual page fragments to the RDMA
layer, and none of them will cross a page boundary and they will be at most
PAGE_SIZE in size.

However, in order to better support large folios and large bvec descriptors, I
could in theory set a segment much larger than PAGE_SIZE.

But, will the device handle that?  And can the DMA API map a single buffer
that big with the IOMMU?  And does it need aligning to a larger pow-of-2
granule?

David

