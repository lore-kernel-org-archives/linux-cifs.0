Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E7E13790B
	for <linux-cifs@vger.kernel.org>; Fri, 20 Jun 2025 14:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750431431; cv=none; b=FD2UYBkPQfMBUHZo3/+UTNukpg41nMKqy1QS8QOvJHKAfNriONCrvbh2j6NzuwZw6q/QAOWD3KbJzjpv6G05AvR4iy4nOWoDVwPW/80S3hra45n5bf7EfHs1tTw2oXg8CwH3pv/dNgQodm4Iwh/8Fo+yXKUWnJMkqNV5ULQQYVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750431431; c=relaxed/simple;
	bh=BHnGtCOG1TuIRLb4gFjkY2lll8tOR59dJZQCzp9VMZE=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=e83zMoZxrvGKBwcJWr2bbw9AoHROEH3iWOVJTO0P+XsGP6kYXq13ySszfflfvzXhAUzKKUhrKYNQe7UcKHhNit5G7+N+YDbrAVfdwNAeprQbbrsgaFkiSK/H98YdbkCXlvsgkCgDVQHmSdfadU9G0n+ba5DCOheEGN9727JkhLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SfjdWvfl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SfjdWvfl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750431428;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5fM9mX/U1lIPSzZz8ULPINyANLFwXqvdj3ejss2AyLs=;
	b=SfjdWvfllAFM/nWg2rtO0Ebpca6C7BmqsKNAtUuwrNaacZQE1Oj/MC+tIgdufIBQdBjCIP
	TFHGs2zz6U7dAkBe/5640J4CDzNijmijHtOgPw0z7tvx/SYpyafsI0K7yG3GBCs2eiILRR
	3avgOZ/n7x28fPVdO6lQZ86Y3scWfd0=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-668-e4MD5WCJNeq6DSuwl_vlcQ-1; Fri,
 20 Jun 2025 10:57:03 -0400
X-MC-Unique: e4MD5WCJNeq6DSuwl_vlcQ-1
X-Mimecast-MFC-AGG-ID: e4MD5WCJNeq6DSuwl_vlcQ_1750431422
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D8E0B19560B0;
	Fri, 20 Jun 2025 14:57:01 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.211])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id ED4E51956094;
	Fri, 20 Jun 2025 14:56:59 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1a05a3ed-87ae-453c-a205-f621262e4fea@talpey.com>
References: <1a05a3ed-87ae-453c-a205-f621262e4fea@talpey.com> <e07c9bab-5750-4a50-8b38-4ce8c1a214d6@talpey.com> <cover.1750264849.git.metze@samba.org> <8ecf5dc585af7abb37f3fabac6eb0f9f3273da85.1750264849.git.metze@samba.org> <962036.1750422586@warthog.procyon.org.uk>
To: Tom Talpey <tom@talpey.com>
Cc: dhowells@redhat.com, Stefan Metzmacher <metze@samba.org>,
    linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>
Subject: Re: [PATCH 2/2] smb: client: let smbd_post_send_iter() respect the peers max_send_size and transmit all data
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <965635.1750431418.1@warthog.procyon.org.uk>
Date: Fri, 20 Jun 2025 15:56:58 +0100
Message-ID: <965636.1750431418@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Tom Talpey <tom@talpey.com> wrote:

> My comment on the layering was because the code did not used to do
> this, therefore it seems this is a fundamental change, which I'd greatly
> prefer to avoid.

Yeah.  Ideally, we'd have each netfs subrequest corresponding to one RDMA
operation.  I try to size the subreqs appropriately, both in terms of the
maximum size in bytes and the maximum number of segments in
cifs_prepare_read() and cifs_prepare_write().

David

