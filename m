Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB673149C4D
	for <linux-cifs@vger.kernel.org>; Tue, 21 May 2024 20:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716321961; cv=none; b=ZHLjmAV/S7O0pnFZ1dJT4zxP2dLEmh00DLswCiiUwP2o5g0yliSkNN7s9GyWxPhSdE1H4/y868KTP9H5VNd2tAdFjGNY29ZHItTg8CvnURNQKPs2SdjJSL6PY6H7GYpLJsOPCNZ0m+q5ZNSVBVBLIL6wh9PVDkhlUVzx0S0PsHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716321961; c=relaxed/simple;
	bh=n1XYT0f8NZ7GY+qdmS7k5N3aMcsAOCFt6lECER9tD1I=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=tM50pscGjyGKIppaUPzBj+HWXDxdNTvYL21ZEq4ZydTxLxlQu12s2p/MANvVta8aR3WJB7gNcouLEY6+N53lRIlB9RsjD+rA1xI9jKPcoht5mdiDilQaLbKMiC+3IeExFolwvqvgCXK+k1ka9SiCD0Orabt0aB6pq6VUKq37As4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c32Nxvon; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c32Nxvon"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716321959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kUcZx+GYvnpd0qagpN08S3w0mckRV0Hazws3JBEBOHw=;
	b=c32NxvonXxQFWykPb7suqx+rM3E6HLEyDFMiI8Gh1ApbIEy4AjnhMhHQyA4XXzyNYAy5Qs
	B4MY+PcCKWS9GzWp6J77YiRxx6mRdRp2e6lANrGrG3nA2dKHemk7aI2OmgpmxR3lpYxm87
	guBEgq8wCG3iKh7hdR8KSTx0fO24Bw8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-504-g-ZkIjQxPvWuKP4dSTmyWw-1; Tue, 21 May 2024 16:05:52 -0400
X-MC-Unique: g-ZkIjQxPvWuKP4dSTmyWw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB112101A52C;
	Tue, 21 May 2024 20:05:51 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.20])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6178A51BF;
	Tue, 21 May 2024 20:05:48 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <110d2995-f473-4781-9412-30f7f96858dd@kernel.dk>
References: <110d2995-f473-4781-9412-30f7f96858dd@kernel.dk> <2e73c659-06a3-426c-99c0-eff896eb2323@kernel.dk> <316306.1716306586@warthog.procyon.org.uk> <316428.1716306899@warthog.procyon.org.uk>
To: Jens Axboe <axboe@kernel.dk>
Cc: dhowells@redhat.com, Steve French <stfrench@microsoft.com>,
    Jeff Layton <jlayton@kernel.org>,
    Enzo Matsumiya <ematsumiya@suse.de>,
    Matthew Wilcox <willy@infradead.org>,
    Christian Brauner <brauner@kernel.org>, netfs@lists.linux.dev,
    v9fs@lists.linux.dev, linux-afs@lists.infradead.org,
    linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfs: Fix setting of BDP_ASYNC from iocb flags
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <322228.1716321947.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 May 2024 21:05:47 +0100
Message-ID: <322229.1716321947@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

Jens Axboe <axboe@kernel.dk> wrote:

> On 5/21/24 9:54 AM, David Howells wrote:
> > Jens Axboe <axboe@kernel.dk> wrote:
> > =

> >> However, I'll note that BDP_ASYNC is horribly named, it should be
> >> BDP_NOWAIT instead. But that's a separate thing, fix looks correct
> >> as-is.
> > =

> > I thought IOCB_NOWAIT was related to RWF_NOWAIT, but apparently not fr=
om the
> > code.
> =

> It is, something submitted with RWF_NOWAIT should have IOCB_NOWAIT set.
> But RWF_NOWAIT isn't the sole user of IOCB_NOWAIT, and no assumptions
> should be made about whether something is sync or async based on whether
> or not RWF_NOWAIT is set. Those aren't related other than _some_ proper
> async IO will have IOCB_NOWAIT set, and others will not.

Are you sure?  RWF_NOWAIT seems to set IOCB_NOIO.

David

