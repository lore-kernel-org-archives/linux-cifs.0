Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB2D37F33A
	for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 19:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787600871; cv=none; b=cPd141AOJ1ajFLVXurldtFdWeAQC2GYfZwkS7WmuvnCcIDFsjP4EO/hVHEqDpAZ62xHEczL2OASME4snWhvdC1ykvYlHxtrGf1o34rqiQ0vXqsl2KXHLvmRSVHgITjvoAn9rj6QewkMDjQDQdyNv5+tMtF1fuxPVhPA0JhQd8+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787600871; c=relaxed/simple;
	bh=ls9gAniDaxU60S488EwFx+HIbvW54OfMRM5lR9rJRqY=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=lLILCpSUBKhzqXjeA8aJ7KOuy0NowqaaQfm53xgrfBWhs115cYteYorjdKsLOh41yOtR/BdpzlOwbjO0ilO+f+MHEfL9gxHMjIUdv4Of+hZkmMt/Bo4NEgXdLXryeiqXOoCDBk1Dda5BYwwbHgFJ05sTMwnXYDLg5BJC6HPbhDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a5o4wDBO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a5o4wDBO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787600869;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HWkfuD+RoHFHnIf8MPWKdp7sPrGB/v7hQ704zJ+2+Ds=;
	b=a5o4wDBOBre11mftYqA5SxevqFlmM2occ7Dyr/uipd+d+D4MkTiLzLeywbAsnn0VktKGcI
	qsnD93b8xJYdsHsH15tQPqe9KyD3O7iVAi6GXWR412j/ifD8On4kWHRFI6HLW6pTiEc3ds
	NHvCUuCYkORpGBtxENgxbo2yWpJLMzI=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-635-9XFVDZNVN-aHPcQHKQgWyA-1; Mon,
 24 Aug 2026 15:47:45 -0400
X-MC-Unique: 9XFVDZNVN-aHPcQHKQgWyA-1
X-Mimecast-MFC-AGG-ID: 9XFVDZNVN-aHPcQHKQgWyA_1787600862
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5D45F184B396;
	Mon, 24 Aug 2026 19:47:40 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.15])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C8E871944B2A;
	Mon, 24 Aug 2026 19:47:31 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CA+1jF5qPZUhCevwbu7zQDEVWss6gMdoDMhqKqH3k7v=WStRtEA@mail.gmail.com>
References: <CA+1jF5qPZUhCevwbu7zQDEVWss6gMdoDMhqKqH3k7v=WStRtEA@mail.gmail.com> <20260824144130.759997-1-dhowells@redhat.com> <20260824144130.759997-31-dhowells@redhat.com>
To: =?us-ascii?Q?=3D=3FUTF-8=3FQ=3FAur=3DC3=3DA9lien=5FCouderc=3F=3D?= <aurelien.couderc2002@gmail.com>
Cc: dhowells@redhat.com, Paulo Alcantara <pc@manguebit.org>,
    Christian Brauner <christian@brauner.io>,
    Matthew Wilcox <willy@infradead.org>,
    Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
    Leon Romanovsky <leon@kernel.org>,
    Namjae Jeon <linkinjeon@kernel.org>,
    ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
    Marc Dionne <marc.dionne@auristor.com>,
    Stefan Metzmacher <metze@samba.org>,
    Eric Van Hensbergen <ericvh@kernel.org>,
    Dominique Martinet <asmadeus@codewreck.org>,
    Ilya Dryomov <idryomov@gmail.com>, netfs@lists.linux.dev,
    linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
    Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
    ceph-devel@vger.kernel.org, v9fs@lists.linux.dev,
    linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: Re: READ_PLUS in NetFS? Re: [PATCH v10 30/35] netfs: Simplify read abandonment
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 24 Aug 2026 20:47:30 +0100
Message-ID: <771538.1787600850@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Aur=C3=A9lien Couderc <aurelien.couderc2002@gmail.com> wrote:

> What about READ_PLUS, i.e. sparse file reads? If you do this kind of
> work of handling partial abandonment, can such a work also benefit
> READ_PLUS?

READ_PLUS is NFS, right?

I'm not sure it would particularly help or hinder.

The VFS/VM only asks to read contiguous regions and netfslib breaks that up
into subrequests, but currently netfslib doesn't know anything about sparse
reads.  What I'm looking at with Ceph, for example, is that Ceph knows where
the gaps are and will clear them before terminating the subrequest.

Partial abandonment is for when some sort of fatal error occurs and we cann=
ot
finish the request.

David

