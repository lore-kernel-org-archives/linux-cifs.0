Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I8iW/8co"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3E410CB
	for <linux-cifs@vger.kernel.org>; Fri, 24 Nov 2023 15:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700868430;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2RrwbTeSbC5XCVA4N2cHN28MMNgejQdbSfaWFJUoo78=;
	b=I8iW/8co0gJtpjiDOseH8h6eexIsPkT/TLrEZme9U9wanDfb3kzLnW3jNLGSohmZBizg+0
	BLbPgS5XO4Cz54xDddeur8C20X/lsghi09Ou+8usZ9bgea0AA3026LS01EPAulIgPZ6Iuk
	D6iYKVQ7J3/qRnCMPK3qoA6DU4HCDTg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-228-RHCueqjrPQOc_2qATkB3tQ-1; Fri, 24 Nov 2023 18:27:07 -0500
X-MC-Unique: RHCueqjrPQOc_2qATkB3tQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 047CA101A529;
	Fri, 24 Nov 2023 23:27:07 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.161])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1A6EA1C060B0;
	Fri, 24 Nov 2023 23:27:05 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1297339.1700862676@warthog.procyon.org.uk>
References: <1297339.1700862676@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, Steve French <sfrench@samba.org>,
    Shyam Prasad N <nspmangalore@gmail.com>,
    Rohith Surabattula <rohiths.msft@gmail.com>,
    Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Set the file size after doing copychunk_range
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1335876.1700868425.1@warthog.procyon.org.uk>
Date: Fri, 24 Nov 2023 23:27:05 +0000
Message-ID: <1335877.1700868425@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

David Howells <dhowells@redhat.com> wrote:

> +	truncate_inode_pages_range(&target_inode->i_data, destoff, len);

That should actually be:

	truncate_inode_pages_range(&target_inode->i_data, destoff, destoff + len);

David

