Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3CA3B185
	for <linux-cifs@vger.kernel.org>; Tue, 16 Apr 2024 22:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713307255; cv=none; b=FQ3KqHFFIbKs9g8+57DJtbEtHulRq3Tc6HOjBisBtQD4NCqzmocadFjkiBNMf4gXJYmud4GZTLCp+QQy9oWipoLHI2nssocMELoMWN31SrmOCokfzlSvKIwJp/sXCuG5EqIsmuaObiWp2szs+AL4sykOBZP2QY5lXARBa9Agd/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713307255; c=relaxed/simple;
	bh=N5nwDmbhe++pDB3bapq0vGCRdzBr3y4GS9c/nfTtZFY=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=s5EyytHEGhi9qkFbnXIQvkpGa5mVTFo7DFex/eekbFHwXNadHjBDCzeZos85Xn0SotoVIr9fzN+EuYYzVgkFe9tm9MYnNMi4sAJV15vaTFXiGjzIZdfRxX1AnFRau7V/umPT6f1iHhN8ALMFehk5leyrVxYA8lideb03l+/y8JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hmM74P3Y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hmM74P3Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713307252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N5nwDmbhe++pDB3bapq0vGCRdzBr3y4GS9c/nfTtZFY=;
	b=hmM74P3Y/OovFx7/GjqIahJ/jdeMdiRD6KUPxU8peL2pEkkX/CFmVVXyoOMD581p0N8LwY
	SzOyBrShGG811S94XPt+R7TJ3sjBZuEQz5Fn5e8n0Ii7U16311YX2NWSrGlML3v6R76XsZ
	9kfWxxMt34LwBWWoNgN1IGFuZCQB8Xw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-282-Ck5vkIIGNTuza5woUV3wRQ-1; Tue,
 16 Apr 2024 18:40:49 -0400
X-MC-Unique: Ck5vkIIGNTuza5woUV3wRQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F39E21C05149;
	Tue, 16 Apr 2024 22:40:47 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.10])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6583339DCA;
	Tue, 16 Apr 2024 22:40:44 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAH2r5msFoGAE79pS5bEt5T8a60LU82mdjNdpfe0bG4YpvY8t-g@mail.gmail.com>
References: <CAH2r5msFoGAE79pS5bEt5T8a60LU82mdjNdpfe0bG4YpvY8t-g@mail.gmail.com> <20240328163424.2781320-1-dhowells@redhat.com> <20240328163424.2781320-2-dhowells@redhat.com> <39de1e2ac2ae6a535e23faccd304d7c5459054a2.camel@kernel.org> <2345944.1713186234@warthog.procyon.org.uk>
To: Steve French <smfrench@gmail.com>
Cc: dhowells@redhat.com, Jeff Layton <jlayton@kernel.org>,
    Christian Brauner <christian@brauner.io>,
    Gao Xiang <hsiangkao@linux.alibaba.com>,
    Dominique Martinet <asmadeus@codewreck.org>,
    Matthew Wilcox <willy@infradead.org>,
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
    linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>,
    Shyam Prasad N <nspmangalore@gmail.com>,
    Rohith Surabattula <rohiths.msft@gmail.com>
Subject: Re: [PATCH 01/26] cifs: Fix duplicate fscache cookie warnings
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2754965.1713307239.1@warthog.procyon.org.uk>
Date: Tue, 16 Apr 2024 23:40:39 +0100
Message-ID: <2754966.1713307239@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

Steve French <smfrench@gmail.com> wrote:

> Should this be merged independently (and sooner? in rc5?)

It's already upstream through the cifs tree and I've dropped it from my
branch.

David

