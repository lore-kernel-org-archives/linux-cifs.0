Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F17513FD6D
	for <linux-cifs@vger.kernel.org>; Thu, 11 Apr 2024 07:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712819407; cv=none; b=s2xX173tTq1ehBPRTR8Sxxl/eGzZuobwI+h9R2G49xYvsXvWhP7akz/W9UMTJeM2JPLJQxj43lEIVQZQVgNwQ3c04NZLB6XXTwUu/Ivv1D6jQclon4iVL45N3SOjogAxSQHL3bh10+VKBTTzzMx97UdC0pOuH7lEKPa2degiJKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712819407; c=relaxed/simple;
	bh=wH6i3JfODjwBAUH9Z8++yMSzU4HiqQg5BInTQ+RTfj8=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=fMtWB7zPpSSaOY1omrodICCIcfmUALvW3BbGnG1QUj0jYF/az9XKoisf0RtD5oaizCvTGw1OSWhifzvgkz6IIchBG+jh/MacUFIHKXW7S7fbZ+LRxa4VC/c8y9j4LEND7VZhVuExSsDB+IeOhvWlWV8+DdjhGuATppDuEJ4piug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HwVp1qjf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HwVp1qjf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712819405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5NgjUa+lwKskPLBb4G2miG3MSH6bZPhgAN2v8MXqMrQ=;
	b=HwVp1qjfm1QCyrLGRjmeh6ZaO70vQ8Z4QhFm+RYy5yAk/WRKa81uwIb7+PpcQ9tJgM00YP
	CFSMFge5ZZDLe2p+AKzHpdogfoS5Bw1lxrLwM4FSZIWeNJM2riAO6n9HYKubgzho0MoNMW
	W4+fmDn02klzVDw6Zm/A0qvBCtcw4OA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-19-Lr1cEV93NVGDpSocSvNLIw-1; Thu, 11 Apr 2024 03:09:56 -0400
X-MC-Unique: Lr1cEV93NVGDpSocSvNLIw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CA3F310499A0;
	Thu, 11 Apr 2024 07:09:54 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.146])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3F2182166B34;
	Thu, 11 Apr 2024 07:09:51 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20240410173815.GA514426@kernel.org>
References: <20240410173815.GA514426@kernel.org> <20240401135351.GD26556@kernel.org> <20240328163424.2781320-1-dhowells@redhat.com> <20240328163424.2781320-27-dhowells@redhat.com> <3002686.1712046757@warthog.procyon.org.uk>
To: Simon Horman <horms@kernel.org>
Cc: dhowells@redhat.com, Christian Brauner <christian@brauner.io>,
    Jeff Layton <jlayton@kernel.org>,
    Gao Xiang <hsiangkao@linux.alibaba.com>,
    Dominique Martinet <asmadeus@codewreck.org>,
    Matthew Wilcox <willy@infradead.org>,
    Steve French <smfrench@gmail.com>,
    Marc Dionne <marc.dionne@auristor.com>,
    Paulo Alcantara <pc@manguebit.com>,
    Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
    Eric Van Hensbergen <ericvh@kernel.org>,
    Ilya Dryomov <idryomov@gmail.com>, netfs@lists.linux.dev,
    linux-cachefs@redhat.com, linux-afs@lists.infradead.org,
    linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
    ceph-devel@vger.kernel.org, v9fs@lists.linux.dev,
    linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
    linux-mm@kvack.org, netdev@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH 26/26] netfs, afs: Use writeback retry to deal with alternate keys
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1780363.1712819386.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 11 Apr 2024 08:09:46 +0100
Message-ID: <1780364.1712819386@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

Simon Horman <horms@kernel.org> wrote:

> On Tue, Apr 02, 2024 at 09:32:37AM +0100, David Howells wrote:
> > Simon Horman <horms@kernel.org> wrote:
> > =

> > > > +	op->store.size		=3D len,
> > > =

> > > nit: this is probably more intuitively written using len;
> > =

> > I'm not sure it makes a difference, but switching 'size' to 'len' in k=
afs is a
> > separate thing that doesn't need to be part of this patchset.
> =

> Sorry, I meant, using ';' rather than ',' at the end of the line.

Ah, yes.  That makes a lot more sense!

David

