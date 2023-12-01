Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SPv3fJ3y"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775C9D3
	for <linux-cifs@vger.kernel.org>; Fri,  1 Dec 2023 09:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701452565;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z47hL4KpWk+c3Hdq11pVRx/NLPdCpAYc/wSjG9tjP6M=;
	b=SPv3fJ3yX1Ah32xDoDV0vQ42axzZH9weTA8grBAC6X/EIvKp8BiAwW8SIXlu5y8lWZOCl6
	vq5AT7p8OJYpNvGIbHmoSNxcqjrI0mS/2+XYTSfhDCOLCy7Y92NdKyE4uqXmfKULbX2bO+
	aIBq8ZVTy2ph5Fn/nvmNubD7MN7klwM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-L5MVXWwrPYy-9u2rKNZW6w-1; Fri, 01 Dec 2023 12:42:41 -0500
X-MC-Unique: L5MVXWwrPYy-9u2rKNZW6w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4FE53185A784;
	Fri,  1 Dec 2023 17:42:41 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.161])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 84059492BE0;
	Fri,  1 Dec 2023 17:42:40 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <d5c487188936f998eeedc2e2e3e726ba@manguebit.com>
References: <d5c487188936f998eeedc2e2e3e726ba@manguebit.com> <3755038.1701447306@warthog.procyon.org.uk>
To: Paulo Alcantara <pc@manguebit.com>
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
Content-ID: <3812668.1701452559.1@warthog.procyon.org.uk>
Date: Fri, 01 Dec 2023 17:42:39 +0000
Message-ID: <3812669.1701452559@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Paulo Alcantara <pc@manguebit.com> wrote:

> David Howells <dhowells@redhat.com> writes:
> 
> > I've seeing some weird behaviour in the upstream Linux cifs filesystem
> > that's causing generic/002 to fail.  The test case makes a file and
> > creates a number of hardlinks to it, then deletes those hardlinks in
> > reverse order, checking the link count on the original file each time it
> > removes one.
> 
> I could also reproduce it in ksmbd but not in Windows Server 2022 or
> samba v4.19.

Yeah - works for me with samba also; just not with ksmbd.

David

