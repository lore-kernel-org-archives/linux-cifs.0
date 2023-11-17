Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UgWn8/z0"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDB2FD7A
	for <linux-cifs@vger.kernel.org>; Fri, 17 Nov 2023 12:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700252434;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l+BNmDbrtEyuQCyrbUz9aldF1aT4f1N0gQBae9tgTTs=;
	b=UgWn8/z0ZxVtE8O/a8ip7+Lq2lOlpfYP/UghPohHSzfGdNE8KJfnMAfA1xnGwGcWahIfRV
	JegdxJ07TqLObJTCjjXTnkdXquLf7u//sYjj5cRNXmGBoGO02cfC75uktY3ttgDj0neBn8
	uorNegHiUmCrVG/3FQVz7/mSTYSBQbA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-644-bE-HCbx0Neap455BGMeg-A-1; Fri,
 17 Nov 2023 15:20:30 -0500
X-MC-Unique: bE-HCbx0Neap455BGMeg-A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC6F33C100A2;
	Fri, 17 Nov 2023 20:20:28 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.16])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6CF30C22541;
	Fri, 17 Nov 2023 20:20:26 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <bb0b02b4241da7f486cde28bdc83bb9ce077ee0e.camel@kernel.org>
References: <bb0b02b4241da7f486cde28bdc83bb9ce077ee0e.camel@kernel.org> <20231013160423.2218093-1-dhowells@redhat.com> <20231013160423.2218093-12-dhowells@redhat.com>
To: Jeff Layton <jlayton@kernel.org>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
    Matthew Wilcox <willy@infradead.org>,
    Marc Dionne <marc.dionne@auristor.com>,
    Paulo Alcantara <pc@manguebit.com>,
    Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
    Dominique Martinet <asmadeus@codewreck.org>,
    Ilya Dryomov <idryomov@gmail.com>,
    Christian Brauner <christian@brauner.io>,
    linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
    linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
    v9fs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
    linux-mm@kvack.org, netdev@vger.kernel.org,
    linux-kernel@vger.kernel.org, linux-cachefs@redhat.com
Subject: Re: [RFC PATCH 11/53] netfs: Add support for DIO buffering
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1722478.1700252425.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Nov 2023 20:20:25 +0000
Message-ID: <1722479.1700252425@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

Jeff Layton <jlayton@kernel.org> wrote:

> > +	struct bio_vec		*direct_bv;	/* DIO buffer list (when handling iovec-=
iter) */
> >  	void			*netfs_priv;	/* Private data for the netfs */
> > +	unsigned int		direct_bv_count; /* Number of elements in bv[] */
> =

> nit: "number of elements in direct_bv[]"
> =

> Also, just for better readability, can you swap direct_bv and
> netfs_priv? Then at least the array and count are together.

Yeah - and stick a __counted_by() on too.

David

