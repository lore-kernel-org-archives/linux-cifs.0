Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6309B43B6F5
	for <linux-cifs@vger.kernel.org>; Wed, 12 Aug 2026 13:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786540091; cv=none; b=uXSj8pSKsUaKyIgn0zADgD86OQQLDsPU2QkCUJ4eJ7UCydZn1RuSuB7vzZasGsHWe/VfuCFoptaRz4LdCCSwLJnnVhmeXk8bAJRwVB+8qD07pd0pAoyhW9usiokhsA6Sv4r5PvYOixUd5sydksVflhnnlu06vbqAaBbFezgqAmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786540091; c=relaxed/simple;
	bh=MxtxiHUFGbpG7wyR5W/M29tb30zag0BJASeiKHwLsI0=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=W2bzYQSHzDZz0Gx7F6jVGNBnqoRlg/GhpcqjptHcfFteOyTlsLpbgGe8hJC+uJIz9yCW3lYVzBzdSZu+CczL8iuvsLY92h2D/XQEvHkDaFObgsChnKbZ9iPb+GL2BnbMVdbM6eQsyIdutcnN6qgz8ATMwxkcXpebxFd7xDX6+KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cghVbYLI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cghVbYLI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786540089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I3xqDyj2MmpztW1ops8Nu205Xj6JE2nK9d9TnUz1EEA=;
	b=cghVbYLIfJ/6Rd9eBL6B2CS1AXDiB+EJQ6TbHChN9sF/vDZ+IutaHb2dAMtzxw6sNhGNrS
	Qv9YIDfiTNlLleQ5ZpHzznsXNjB5jyAq80nAYJFbdCvRxpekbQ87+MlGM8CISGKmetwhDv
	Rk3pqdnA7qiqwrdfb6ArKHCTSMvReZo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-588-szUloSf1MwK4mgbg-tv4vQ-1; Wed,
 12 Aug 2026 09:08:04 -0400
X-MC-Unique: szUloSf1MwK4mgbg-tv4vQ-1
X-Mimecast-MFC-AGG-ID: szUloSf1MwK4mgbg-tv4vQ_1786540083
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6A0831800646;
	Wed, 12 Aug 2026 13:08:02 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.44])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9B6A2426;
	Wed, 12 Aug 2026 13:07:57 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260810-jazzfest-unglaubhaft-miene-4d1cf4cf42d3@brauner>
References: <20260810-jazzfest-unglaubhaft-miene-4d1cf4cf42d3@brauner> <20260728141344.1811120-1-dhowells@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>,
    Christian Brauner <christian@brauner.io>,
    Marc Dionne <marc.dionne@auristor.com>,
    Jeffrey Altman <jaltman@auristor.com>,
    Steve French <sfrench@samba.org>, linux-afs@lists.infradead.org,
    openafs-devel@openafs.org, linux-cifs@vger.kernel.org,
    linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] vfs, afs, bash: Fix miscomparison of foreign user IDs in the VFS
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <986589.1786540076.1@warthog.procyon.org.uk>
Date: Wed, 12 Aug 2026 14:07:56 +0100
Message-ID: <986590.1786540076@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

Christian Brauner <brauner@kernel.org> wrote:

> > Note that chown may also need modifying in some way - but that can't
> > necessarily supply the information required (for instance, an AuriStor YFS
> > ID is 64 bits, but chown can only handle a 32-bit integer; CIFS might use
> > a GUID).
> 
> Seems that some other changes are required for this. I'll take a look
> once a new version is out.

If you're referring to the chown thing, can we ignore that for now?  It would
probably need some sort of new system call, but I don't know how that should
look for now.

David

