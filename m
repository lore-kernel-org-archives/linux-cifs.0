Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D4D189B8F
	for <linux-cifs@vger.kernel.org>; Fri, 23 Aug 2024 16:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724429960; cv=none; b=WJ+dCN0yYpbSbBBoGOVjdG4E8q18Jm8LwYY1kK3dwwftJXOUUrh/HOBmjCuzeQs6E9+QL/1bmMrmihiwQZWtJSBVfyfiUg4uOBBH6TOyl881HTAtdReLsa7pOMnTA5D2WcsfMCO+DIO4jCijMnmLq0Fws5chWq3QEK91qqFJIW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724429960; c=relaxed/simple;
	bh=5vO7pzc8y86vVax8BXK3Xl2hqG8JqjqtPluxEyc5ETA=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=pFoYEqbrgLsiYauNdb29tiTYwyZeoks0iXCJhUbsV+ylGjX7+HC6Da33bGbJHIyMXAWLIv6LKJdTqmqNHgXKXWDccSS1AIoo0ZxTUjL2tLvakj5Qh+bBEC7OoTQ18VHeFbaUmO5P+6WiJYEjJreOG9f4Nj7tq3pnboDKwY2bGvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Uzlt0cQY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uzlt0cQY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724429957;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=a7OM/W0EJtp2+JAIBDghW4ypLqo6G3RHtMu+hNZuDVs=;
	b=Uzlt0cQYkCNTP5BFHfUINnqdFDidliOcRTfLKHO1KuqapfFv17uktJTyQJ9uFYa3AmOu0A
	R8awRazH0RYzaFaXApuK3YFsYp3ACwdFhsvLNtRkysfmg++xrE+I5Om6DP+T0IVuwg/fSD
	OXaUq/1+c5yQnbELMGl8EvmfvG2JjNo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-562-iuW8mKDwMJKn3vMTBBxWRA-1; Fri,
 23 Aug 2024 12:19:14 -0400
X-MC-Unique: iuW8mKDwMJKn3vMTBBxWRA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DDF911955BED;
	Fri, 23 Aug 2024 16:19:11 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.30])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6ACE019560AA;
	Fri, 23 Aug 2024 16:19:07 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20240823161209.434705-1-dhowells@redhat.com>
References: <20240823161209.434705-1-dhowells@redhat.com>
To: Steve French <sfrench@samba.org>, Jeremy Allison <jra@samba.org>,
    samba-technical@lists.samba.org
Cc: dhowells@redhat.com, Paulo Alcantara <pc@manguebit.com>,
    Christian Brauner <christian@brauner.io>,
    Jeff Layton <jlayton@kernel.org>,
    Matthew Wilcox <willy@infradead.org>, netfs@lists.linux.dev,
    linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
    linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
    v9fs@lists.linux.dev, linux-erofs@lists.ozlabs.org,
    linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
    linux-kernel@vger.kernel.org
Subject: Samba llseek bug
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <434991.1724429946.1@warthog.procyon.org.uk>
Date: Fri, 23 Aug 2024 17:19:06 +0100
Message-ID: <434992.1724429946@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Note that whilst testing my cifs fixes with the generic/075 and generic/112
xfstests, the tests occasionally hit a bug in Samba whereby llseek() fails
because there are too many extents in the server file for the server to
report.  I've noted this before:

	https://lore.kernel.org/linux-cifs/349671.1716335639@warthog.procyon.org.uk/

is there a fix for this I can try?

David

