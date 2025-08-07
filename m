Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E29231830
	for <linux-cifs@vger.kernel.org>; Thu,  7 Aug 2025 07:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754550790; cv=none; b=IfUG1DURpyg6DBIqMiJ2XPmBnLyBPAokEcFEI+jo83pN/IuPOMesmnBWDxvOEO/mO8ugNzsZbZS+QvP62YMkc8KDN7SGia9H3ASa6v3AYtOiEizDVBWTpRkiKIxLr9PJBgcXPLfMTJ0DIwWOajiAj0c/n5pFYnR6Mp80nNrY8fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754550790; c=relaxed/simple;
	bh=7qzIfJ2L9nGiid7kAWJriiXEYS7021OFu3DhwRGi3oU=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=qn6ACfMMAlAzEF4A8J9DNzarGQvfjiZXtacoFTBMN3iV1uL7xZbnKgqS3yRzaGqMAwS0JE9Q9/UW19+kAZ0M2S8I32wr316WdkLr3Jaoyr33FO+0LwDK1pozRf7FE2sgGEa4vYsi6ADz+FwZ3+8p21G1FIqEp3bFp3wagXnGXZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Hny+Q+TE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hny+Q+TE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754550787;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WK22s4SVCLJoZJSJWhvgu24NEJGE5iXkCiG4gIgbRQo=;
	b=Hny+Q+TEsbXuH41O/zsWahtuC5qqLEPqh6xpIaF47tNinP+p1OOvx13PTsqkkv6fXQCreW
	n2VhYwo8QMLXUrplHkJ2EXlwy9xlIASMMPbfzOTfwI3GMfuRrIHnT7lJK6TarQ/IZXCc/L
	3kqVU/wTaH+7d9GLaTE03dGTV+0U4fo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-rzehe_U4O2eXokTWpeGl4A-1; Thu,
 07 Aug 2025 03:13:04 -0400
X-MC-Unique: rzehe_U4O2eXokTWpeGl4A-1
X-Mimecast-MFC-AGG-ID: rzehe_U4O2eXokTWpeGl4A_1754550783
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6DEE01800297;
	Thu,  7 Aug 2025 07:13:02 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.17])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A74F63001454;
	Thu,  7 Aug 2025 07:12:59 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <40d1f78c-d437-4ab4-8e5e-8708af6486ab@samba.org>
References: <40d1f78c-d437-4ab4-8e5e-8708af6486ab@samba.org> <c213ace1-7845-4454-a746-8a5926ab41d0@samba.org> <20250806203705.2560493-1-dhowells@redhat.com> <2572846.1754547848@warthog.procyon.org.uk>
To: Stefan Metzmacher <metze@samba.org>
Cc: dhowells@redhat.com, Steve French <sfrench@samba.org>,
    Paulo Alcantara <pc@manguebit.org>,
    Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
    Wang Zhaolong <wangzhaolong@huaweicloud.com>,
    Mina Almasry <almasrymina@google.com>, linux-cifs@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/31] netfs: [WIP] Allow the use of MSG_SPLICE_PAGES and use netmem allocator
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2573494.1754550778.1@warthog.procyon.org.uk>
Date: Thu, 07 Aug 2025 08:12:58 +0100
Message-ID: <2573495.1754550778@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Stefan Metzmacher <metze@samba.org> wrote:

> >> So the current situation is that we memcpy (at least) in sendmsg()
> >> and with your patches we do a memcpy higher in the stack, but then
> >> use MSG_SPLICE_PAGES in order to do it twice. Is that correct?
> > Not twice, no.  MSG_SPLICE_PAGES allows sendmsg() to splice the supplied
> > pages
> > into the sk_buffs directly, thereby avoiding a copy in the TCP layer and
> > cutting out the feeder loop in cifs.
> 
> Yes, and we must be careful to not touch the pages after
> calling sendmsg(MSG_SPLICE_PAGES).

Until we get a response from the server, yes, but for the protocol info that
shouldn't be an issue.  And if we're going to encrypt, we'll have to do a copy
anyway for something like Write, but we can get the encryption algo to do that
for us by giving it a separate destination buffer.

> And unlike MSG_ZEROCOPY tcp_sendmsg_locked() has no
> no struct ubuf_info *uarg when MSG_SPLICE_PAGES is used
> and there's no way to know when the pages are no longer
> used by the tcp stack.

Correct (and this is something we'll need to address), but for the moment we
can rely on page refcounts.  MSG_SPLICE_PAGES takes a ref on each page - which
is why you can't use it with slab memory.  However, if we pass in
netmem-allocated memory, that works by refcounting, so that should work.

> Can you explain how/where we allocate the memory and where
> we unreference it in the caller of sendmsg(MSG_SPLICE_PAGES).

Currently, we allocate the buffer in fs/netfs/buffer.c in
netfs_alloc_bvecq_buffer().  That just bulk allocates a bunch of pages and
adds them into a bvecq.  As they're untyped pages, we can use the refcount.  I
want to allocate netmem instead, but I haven't done that yet.

We then call sendmsg(MSG_SPLICE_PAGES) and then drop our ref on the pages.
TCP will have taken its own ref which it will drop in due course when the
skbuffs are cleaned up.

David

