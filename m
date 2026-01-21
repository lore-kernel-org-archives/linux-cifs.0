Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CF9318B98
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 23:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769038145; cv=none; b=GygdVjAQNtNTod1J/UNyZf4xko3U8EVoV4LyeBKBH/EWi2ZYxzeGiDDhKxCBLDSvgv5P0Y1/EgF/Vlf9pEt+lPap3EPxkj4Ucg8+pLOTMFwaTvfIbHRqlQv30FKg9YV0sXqtA3k4Yh2QsPdIM54FU1YcVpbaHy7W8EeRK0wSGfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769038145; c=relaxed/simple;
	bh=lURQEwIBE+Ecq0CD165gsBMbVKF9WmS9IThus7Xn6b4=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=ppVmrBPv061pLVOFnHvMTdsyOIRdeXqRYJ8rxvXd5kX51WKhAE0MoLBjhWXoTim+EkmBQsCHQFvGI7l7jTG8T20FFS+MUeo4YSBP9jvr11ql8B5vIEJrQOUXugyPNKc6RtYlzQpToUP5JkSE/KxeXKKT06OCyYKpswuS1VWXq/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hZqa43rc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hZqa43rc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769038141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2/54Wo5LPxPCutFDQQR+O3h3aqI+O1nuPLjEE9vUnWs=;
	b=hZqa43rc9kIPJyg/WKwKkWSo6U4qX/9+Z7RI7KeJJcJeL5Z18OvOQN1ToUQGlCkei21GQT
	2zM/5ZJoNYUosHbMiySgKUlgW4j+LanUOFotKJGYF5Woq5BrV896NVSiAOOqnzH8ZBlLCi
	H1uDcGAY1GZ1DEf5/5PEt681ZW3qi5M=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-680-RrCzWyQ7Oxah7jdwvdSHnA-1; Wed,
 21 Jan 2026 18:28:58 -0500
X-MC-Unique: RrCzWyQ7Oxah7jdwvdSHnA-1
X-Mimecast-MFC-AGG-ID: RrCzWyQ7Oxah7jdwvdSHnA_1769038137
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D3F37195609F;
	Wed, 21 Jan 2026 23:28:56 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.2])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4E3161800577;
	Wed, 21 Jan 2026 23:28:55 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260120062152.628822-3-sprasad@microsoft.com>
References: <20260120062152.628822-3-sprasad@microsoft.com> <20260120062152.628822-1-sprasad@microsoft.com>
To: nspmangalore@gmail.com
Cc: dhowells@redhat.com, linux-cifs@vger.kernel.org, smfrench@gmail.com,
    pc@manguebit.com, bharathsm@microsoft.com,
    Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 3/4] cifs: Initialize cur_sleep value if not already done
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1652857.1769038134.1@warthog.procyon.org.uk>
Date: Wed, 21 Jan 2026 23:28:54 +0000
Message-ID: <1652858.1769038134@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

This doesn't affect smb2_async_readv() and smb2_async_writev().  Should
netfslib do some sort of backoff on retrying?

David

