Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9990A1482EA
	for <linux-cifs@vger.kernel.org>; Tue, 21 May 2024 15:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716306910; cv=none; b=ecLPhV6iOpVlmtNuzkaDjb4R1lSICmpxLoX7XuooI/HHlcVvV5iQ3RsQcwPrJYdvcD4pOGdkuSyCSPfDrUwtheOZEIBD9EMWDNXCOk7lTKlpubKi/74fDYLMktm4ayf+ve6tsfzkM08iU7Fg2e7P0Cr7je0gTO/CjpSskII4BBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716306910; c=relaxed/simple;
	bh=ETMyAjhAyjRrYjH6gWRvwzWDDJXx1j3zk86x7NvOJmw=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=oh/lhU824tttRu9TZWPUIeQfRO+XTMiG19DIyxQIUwq1Q3pptmPoRGYpow/oM18kyee1aU5IpQ/P3tKf7QOOL5X2ReEddJ1NlyNa3eT+IzYgy/2FxbWakUDxrTGCWHptEjWL6pcO2WmgUvF0A2ALQsdufmjJ+tCnmMaCOx/jNtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XyFWH0SP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XyFWH0SP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716306907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ETMyAjhAyjRrYjH6gWRvwzWDDJXx1j3zk86x7NvOJmw=;
	b=XyFWH0SPLajy+3G9QoOdSxrod1/PJvP9puPrhX/xkyEqyrd9qiduWGQoxaLg+V+oYwbw4V
	tz0EjFCsAycZbUYKkBMafs8iXZ303V8ebgxDfOczJa71VZQ5VOeEDYOp4+oaERi1jrNc9T
	7NGFULCjDLyfXYjLq5BfDWPMz8/s2C8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-646-l7H-i_idMlq5SSTveGjq1Q-1; Tue,
 21 May 2024 11:55:02 -0400
X-MC-Unique: l7H-i_idMlq5SSTveGjq1Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7132329AB3E2;
	Tue, 21 May 2024 15:55:01 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.20])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0CB731C09481;
	Tue, 21 May 2024 15:54:59 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <2e73c659-06a3-426c-99c0-eff896eb2323@kernel.dk>
References: <2e73c659-06a3-426c-99c0-eff896eb2323@kernel.dk> <316306.1716306586@warthog.procyon.org.uk>
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
Content-ID: <316427.1716306899.1@warthog.procyon.org.uk>
Date: Tue, 21 May 2024 16:54:59 +0100
Message-ID: <316428.1716306899@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

Jens Axboe <axboe@kernel.dk> wrote:

> However, I'll note that BDP_ASYNC is horribly named, it should be
> BDP_NOWAIT instead. But that's a separate thing, fix looks correct
> as-is.

I thought IOCB_NOWAIT was related to RWF_NOWAIT, but apparently not from the
code.

David

