Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A92973451
	for <linux-cifs@vger.kernel.org>; Mon,  6 Jan 2025 09:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736154792; cv=none; b=pSRVVTXO7v7f6r6dciKRe/OH3zQWfDx28Oe4fpYQIyrVlsPphKvxKItldgqr2H2vC4CfGukYzf+D/c4hR05JeKtQHCT+cStrlwgbi+k9t6EQX1nGDJn5njKneELawiuvFX1caYwdLJ+JPuRK08oR5v6i2SHhwGz+7ulKF045eVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736154792; c=relaxed/simple;
	bh=WlctL6iEmC+CnmuIlnrEi9kSEGynZ/ym4TLRNfaGLyY=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=LZl25ewhsWIEYba53Nj4UO63/4iU5KNcpOlr9z9GAbxV2e6MrIsohBNhB0XTRkAwCdgHNgIGG9NgB9Ec3EbkrxK2Vlgc3NKdLPLpnyDewrfQDgJFeW6c7609X2Xg0ifsNwrbbB78adZcb/qY2ZwMNRBATFiTsJnQIZ5VLZDK0fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MEwkC0aU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MEwkC0aU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736154790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jcXNwyTxD0A2L3ejmRcIqG2UamM3lFSKxVSJR7a7+9w=;
	b=MEwkC0aUMlAnjcq5STYQW8FPmGA5U+Bwb30SrTCnJ4n6kd8qn42Xg6GU8Gp4neTitZaBUB
	f2xCXEbIj3lVq7rQNbBTB/glJLyPHxMxLqtreJuByZ9Ck3tfcyu/CeLp3jje0jaGSiW21b
	V1zM+nKpa/BBwK/1nvX2QzMqwAhOWhk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-364-ibuqVuDfNM6d2_S3wHKSEQ-1; Mon,
 06 Jan 2025 04:13:06 -0500
X-MC-Unique: ibuqVuDfNM6d2_S3wHKSEQ-1
X-Mimecast-MFC-AGG-ID: ibuqVuDfNM6d2_S3wHKSEQ
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 108CF195609E;
	Mon,  6 Jan 2025 09:13:05 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 539FC3000197;
	Mon,  6 Jan 2025 09:13:03 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Z3uENYsAlKhUdQgY@infradead.org>
References: <Z3uENYsAlKhUdQgY@infradead.org> <669f22fc89e45dd4e56d75876dc8f2bf@3xo.fr> <fedd8a40d54b2969097ffa4507979858@3xo.fr>
To: Christoph Hellwig <hch@infradead.org>
Cc: dhowells@redhat.com, nicolas.baranger@3xo.fr,
    linux-cifs@vger.kernel.org, netfs@lists.linux.dev
Subject: Re: Losetup Direct I/O breaks BACK-FILE filesystem on CIFS share (Appears in Linux 6.10 and reproduced on mainline)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <278654.1736154782.1@warthog.procyon.org.uk>
Date: Mon, 06 Jan 2025 09:13:02 +0000
Message-ID: <278655.1736154782@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Christoph Hellwig <hch@infradead.org> wrote:

> > I think the new way CIFS is using NETFS could be one of the cause of the
> > issue, as doing :
> 
> The poblem is that netfs_extract_user_iter rejects iter types other than
> ubuf and iovec, which breaks loop which is using bvec iters.  It would
> also break other things like io_uring pre-registered buffers, and all
> of these are regressions compared to the old cifs code.

Okay, I can reproduce it trivially.  Question is, do I need to copy the
bio_vec array (or kvec array or folio_queue list) or can I rely on that being
maintained till the end of the op?  (Obviously, I can't rely on the iov_iter
struct itself being maintained).  I think I have to copy the contents, just in
case.

David

