Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O9dbYV0z"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19684BA
	for <linux-cifs@vger.kernel.org>; Tue,  5 Dec 2023 01:39:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701769188;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=o/7QNpl+o3++WlXZ53pi5zU7K9qsD8TgZ3XJeC4u0Is=;
	b=O9dbYV0zfQM7/p7Sj9NieeGsgI7na+k/Nq9OwoRVZ6rnWMWcnvr4rGBwfPmZ747T4/6asB
	IliCIQwvmMpAIvernzS/vsl/WBAtJoY4xzA9liuHvJninh62LiEeyWvdXcV9Vqk9AH6U7f
	6C0LjpbZdZckwM1sQHmHAfMLxfbm31k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-652-6PnFNsaEONyiNsakdJ4hUQ-1; Tue, 05 Dec 2023 04:39:45 -0500
X-MC-Unique: 6PnFNsaEONyiNsakdJ4hUQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9789B101A52A;
	Tue,  5 Dec 2023 09:39:44 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.161])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C16B43C25;
	Tue,  5 Dec 2023 09:39:43 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAKYAXd9ijC1ypq=JUgkmtgaN6KDUxLiUr_RT+Ju7kXNadRwhrw@mail.gmail.com>
References: <CAKYAXd9ijC1ypq=JUgkmtgaN6KDUxLiUr_RT+Ju7kXNadRwhrw@mail.gmail.com> <3755038.1701447306@warthog.procyon.org.uk>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: dhowells@redhat.com, Steve French <sfrench@samba.org>,
    ronniesahlberg@gmail.com, aaptel@samba.org,
    linux-cifs@vger.kernel.org
Subject: Re: cifs hardlink misbehaviour in generic/002?
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <315463.1701769183.1@warthog.procyon.org.uk>
Date: Tue, 05 Dec 2023 09:39:43 +0000
Message-ID: <315464.1701769183@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

Namjae Jeon <linkinjeon@kernel.org> wrote:

> We have already sent the fixes on this week, So It has been in the
> latest linus master.
> Could you please check it on the latest master or after applying
> commit 4274a9dc6aeb "ksmbd: separately allocate ci per dentry" ?

Yep.  That fixes it.

David

