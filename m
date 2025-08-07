Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFDA195FE8
	for <linux-cifs@vger.kernel.org>; Thu,  7 Aug 2025 06:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754547860; cv=none; b=T0dgXhknPS52LnjUOHRp+LiwX4ztaQxtTSCHbZlAomCvADvzbAoB3mGEXQZlfotEnqBSyaWQ5KtjMHI/4AxNyCV/AwUkHpqVbPFXQF0uaR3XIk3HyNzjt0PXN1AH+hYEhJyaWddn5HwuHKffaMJfZcsOguC6odlBy3i0bx7KsSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754547860; c=relaxed/simple;
	bh=3LQckM2EdoqnAXIB/DASixGzOmzCkzLo06SkipiWqLI=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=mCh0vKOroMnsDrPczcrJT79GqCBYCBQtu+WqVO98WGgbv6EZ9Bv+RCz7QheRPluYFpJzDT3nq76v0yJrX9HoVRfQHgNe07RErbFd7/4tUNtXSW2/6abNqoP+CqUNx+yyYaCwh0ceHUFUsPGWvBoOwS1fJVn77Zo14tCuvMzgVbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ObgdbFZu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ObgdbFZu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754547857;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k1WVOByHGPJSkXieU34Pjmu4LFu0grvMwhqpYIbMzb8=;
	b=ObgdbFZuKQSgOhYboT4yms39pXzpQmmCcJoaDMsJVuJdKETUL41/+9QPkeX9o4F+YQlNli
	EOKeSsTQQWhVL4Q1nKG435PpawqvwSuYPWRbdEp/cKsq0PknDmvS90bSNt5wUS9ExYQc8B
	C1oQnyhOEhBOQKnLYCMvbWp0xSjvvZ8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-590-sGGSZm2HNd6jGHFfZmszKg-1; Thu,
 07 Aug 2025 02:24:14 -0400
X-MC-Unique: sGGSZm2HNd6jGHFfZmszKg-1
X-Mimecast-MFC-AGG-ID: sGGSZm2HNd6jGHFfZmszKg_1754547853
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9B05C1800366;
	Thu,  7 Aug 2025 06:24:12 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.17])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5B00C19560AD;
	Thu,  7 Aug 2025 06:24:09 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <c213ace1-7845-4454-a746-8a5926ab41d0@samba.org>
References: <c213ace1-7845-4454-a746-8a5926ab41d0@samba.org> <20250806203705.2560493-1-dhowells@redhat.com>
To: Stefan Metzmacher <metze@samba.org>
Cc: dhowells@redhat.com, Steve French <sfrench@samba.org>,
    Paulo Alcantara <pc@manguebit.org>,
    Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
    Wang Zhaolong <wangzhaolong@huaweicloud.com>,
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
Content-ID: <2572843.1754547848.1@warthog.procyon.org.uk>
Date: Thu, 07 Aug 2025 07:24:08 +0100
Message-ID: <2572846.1754547848@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Stefan Metzmacher <metze@samba.org> wrote:

> So the current situation is that we memcpy (at least) in sendmsg()
> and with your patches we do a memcpy higher in the stack, but then
> use MSG_SPLICE_PAGES in order to do it twice. Is that correct?

Not twice, no.  MSG_SPLICE_PAGES allows sendmsg() to splice the supplied pages
into the sk_buffs directly, thereby avoiding a copy in the TCP layer and
cutting out the feeder loop in cifs.

However, this is meant to be an intermediate step.  I actually want to
assemble the fragment list in a bvecq in the smb_create_request() as called by
the PDU encoders, with everything aligned for crypto so that the crypto layer
doesn't copy it also.  But cleaning up the transport first should hopefully
reduce the size of the later patches.

David

