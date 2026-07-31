Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A116231F99E
	for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 22:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785537461; cv=none; b=I3OtG+C2N2OJtDkgjotL99mVsvOf/pEPKWuO4624L/5qhvOxauyhyE0kz6bSk+K8T0LVUTJK5yrUKfoWil51MYjCN4DhMI4kQsfdegFd0Lqynj6Iogjdm91Xfx4jj1ebiQ33U88gNKOAzwD03l3k4JeEGWnZPw4b5nLr+im5PRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785537461; c=relaxed/simple;
	bh=TSVgvFj0/icrx/szPlPXOYgXUV2Uwol62Yl9ah+6OoA=;
	h=In-Reply-To:References:To:Cc:Subject:MIME-Version:Content-Type:
	 From:Date:Message-ID; b=XArFeehKv/ULuGtz8X5KM1lch98cc9YCmWK53BBKy19xMO9s0cX16KdNF1T9XMXpj5kpGDjFPlnF1bdL++zImJdvMt2tWu37/NPBCoYWcDPw9s4BQNNiEhXW3nYbsOFdq3Yg7qHr+u/V7R190T/k1ROGY/v5ig+Tb9lRpl0MFOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=exNcN/eD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="exNcN/eD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785537458;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xTBgDSaLEff4TGeFqCwhbOPoKS67aTdWTUTNBaO+1vk=;
	b=exNcN/eD4YZSRSPuZP1jtjQoqa4fdUNSRdZw87W5+BRZxRTMLVxxUGCBHyQ/tmRdehHmCW
	tLinqsQY4J2BVytMKT8JRYLR1f+/vfz+HwdcuRVwpQD1mhoeEXe98WXuKiEQ0FIFDK+l4D
	G7XCQTR+d/Ad9y0kPnYrPpA/4noaIrI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-345-lmu1UXCoPrK-2l6FeYyZLA-1; Fri,
 31 Jul 2026 18:37:35 -0400
X-MC-Unique: lmu1UXCoPrK-2l6FeYyZLA-1
X-Mimecast-MFC-AGG-ID: lmu1UXCoPrK-2l6FeYyZLA_1785537454
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 89D4A180059A;
	Fri, 31 Jul 2026 22:37:33 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.44])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EB7E1180056E;
	Fri, 31 Jul 2026 22:37:30 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
In-Reply-To: <20260731153500.660569-2-sorenson@redhat.com>
References: <20260731153500.660569-2-sorenson@redhat.com> <20260731153500.660569-1-sorenson@redhat.com>
To: Frank Sorenson <sorenson@redhat.com>
Cc: dhowells@redhat.com, linux-cifs@vger.kernel.org, pc@manguebit.org,
    stfrench@microsoft.com, hehuiwen@kylinos.cn, stable@vger.kernel.org,
    Paulo Alcantara <pc@manguebit.com>
Subject: Re: [PATCH v2 1/4] cifs: use cifs_invalidate_cache() in cifs_do_truncate() for O_TRUNC
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2259548.1785537396.1@warthog.procyon.org.uk>
From: David Howells <dhowells@redhat.com>
Date: Fri, 31 Jul 2026 23:37:29 +0100
Message-ID: <2259642.1785537449@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Frank Sorenson <sorenson@redhat.com> wrote:

> cifs_do_truncate() is invoked from cifs_open() without i_rwsem, so it
> cannot use cifs_resize_file_locked() to perform a proper fscache cookie
> resize.  Instead, add cifs_invalidate_cache() after cifs_setsize().
> 
> cifs_invalidate_cache() calls fscache_invalidate(), which works without
> holding i_rwsem: it unconditionally increments inval_counter and sets
> FSCACHE_COOKIE_NO_DATA_TO_READ, ensuring that stale cached data is not
> served once the cookie is later activated by fscache_use_cookie().
> Truncation to zero leaves no valid cached data, making invalidation the
> correct semantic here.

What happens if there's a concurrent read or write in another thread?
truncate(), buffered read/write and direct read/write() will play reasonably
with each other through a combination of i_rwsem and the stuff in
fs/netfs/locking.c.

But apart from that, I think that invalidating the cache should work.  It may
be slower, but since you're getting rid of all the data anyway...

David

