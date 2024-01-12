Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272706E2BC
	for <linux-cifs@vger.kernel.org>; Fri, 12 Jan 2024 14:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h1/GxgxX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705069559;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i8oXZEZKEorjVlrtMjOiU7uBSULn8aeLTkx9aKasfX0=;
	b=h1/GxgxXm3/0ssZg/RpxMtt/m77FcMKA+UFUMvwNyFqKVvPNeaXwNd2QCviDxGuJMieoAW
	cxS9hP8JlFSo04TS90u+fP8cNO8ooqNQmmREqlvKbxwANsvSbq1jbekzKuJJ+rr8Etayhs
	uVFOx2dm1UQNP+tW+0xJASmNvC5D9jc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-558-KxdKTlU2M1KGn0h9hQ4K_A-1; Fri,
 12 Jan 2024 09:25:55 -0500
X-MC-Unique: KxdKTlU2M1KGn0h9hQ4K_A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 396043C00097;
	Fri, 12 Jan 2024 14:25:54 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.67])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 791CA2166B31;
	Fri, 12 Jan 2024 14:25:52 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <2024011115-neatly-trout-5532@gregkh>
References: <2024011115-neatly-trout-5532@gregkh> <2023121124-trifle-uncharted-2622@gregkh> <a76b370f93cb928c049b94e1fde0d2da506dfcb2.camel@amazon.com> <ZZhrpNJ3zxMR8wcU@eldamar.lan> <8e59220d-b0f3-4dae-afc3-36acfa6873e4@leemhuis.info> <ZZk6qA54A-KfzmSz@eldamar.lan> <13a70cc5-78fc-49a4-8d78-41e5479e3023@leemhuis.info> <ZZ7Dy69ZJCEyKhhS@eldamar.lan>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: dhowells@redhat.com, Salvatore Bonaccorso <carnil@debian.org>,
    Paulo Alcantara <pc@manguebit.com>,
    Shyam Prasad N <nspmangalore@gmail.com>,
    Rohith Surabattula <rohiths.msft@gmail.com>,
    Matthew Wilcox <willy@infradead.org>,
    Jeff Layton <jlayton@kernel.org>,
    Steve French <stfrench@microsoft.com>,
    "Jitindar Singh,
 Suraj" <surajjs@amazon.com>,
    "linux-mm@kvack.org" <linux-mm@kvack.org>,
    "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>,
    stable@vger.kernel.org, linux-cifs@vger.kernel.org,
    Linux regressions mailing list <regressions@lists.linux.dev>
Subject: Re: [Regression 6.1.y] From "cifs: Fix flushing, invalidation and file size with copy_file_range()"
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2162048.1705069551.1@warthog.procyon.org.uk>
Date: Fri, 12 Jan 2024 14:25:51 +0000
Message-ID: <2162049.1705069551@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

gregkh@linuxfoundation.org <gregkh@linuxfoundation.org> wrote:

> I guess I can just revert the single commit here?  Can someone send me
> the revert that I need to do so as I get it right?

In cifs_flush_folio() the error check for filemap_get_folio() just needs
changing to check !folio instead of IS_ERR(folio).

David

