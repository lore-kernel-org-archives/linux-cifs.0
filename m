Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2035130BF70
	for <linux-cifs@vger.kernel.org>; Fri,  5 Sep 2025 09:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757062972; cv=none; b=uCVYXU5v0hfokGgBVRelpKaxL2kiKc92izbgPy6NIhGlFKQFIlPsvKI6a3cw8cT2x12MFqB9rL/zM0amKW8UsIIEQVYT3ozZXrVZjyjuLzWJcJj6AuC7MYvktY9pIGt1EGH85xmf0GcTTwtqbO0QiljT6Znx2wRS+R3dkLlEdUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757062972; c=relaxed/simple;
	bh=8HPNZcdhm1lzk/j8xVP5HxX8nNi2kh6YT5QMoEAh2jw=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=NeOSlCdTzz97HVRCejlbTM/oXCiOFHYTVzCRD4tZGvP8Cci5obxmf/ZQLeZxZiYdG70Mo6/LiAZ7sQjtrEcc5nBHpViEP272rrWbB/ryi0jSjOBMN3jdeqC3Yp5IM4UlXw/9BwpS0nSEAeMZBCXQFMEZsPusvGRDaxQGlDlI4Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fo0VkHDW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fo0VkHDW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757062970;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8HPNZcdhm1lzk/j8xVP5HxX8nNi2kh6YT5QMoEAh2jw=;
	b=fo0VkHDW1ilpV6RQlY7h3q1MMYJlg07yqYGFVxnCLPL4y0GbvxJgvuBNFi8/d2shfqnXM3
	JVDEwz+EJH975mwJ8ZHXRh5AXqfskavL4mHBT2YzYPc92e4TtIRzY/Wma9FnnemYAJTbiN
	jxiqLUn4B+5CNeWadLoInwLJvcYpqdc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-29-Vfi6Ixx7OgykW5Spc0rUCw-1; Fri,
 05 Sep 2025 05:02:44 -0400
X-MC-Unique: Vfi6Ixx7OgykW5Spc0rUCw-1
X-Mimecast-MFC-AGG-ID: Vfi6Ixx7OgykW5Spc0rUCw_1757062963
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3DC3418002C6;
	Fri,  5 Sep 2025 09:02:43 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.6])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 594DB1800451;
	Fri,  5 Sep 2025 09:02:41 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CANT5p=ofG-CQF_Rmv15+HAe0Jd1u1r=uqa-nYyDFOBOJ-0-jng@mail.gmail.com>
References: <CANT5p=ofG-CQF_Rmv15+HAe0Jd1u1r=uqa-nYyDFOBOJ-0-jng@mail.gmail.com>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: dhowells@redhat.com, Paulo Alcantara <pc@manguebit.com>,
    Matthew Wilcox <willy@infradead.org>,
    Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>,
    Bharath SM <bharathsm.hsk@gmail.com>
Subject: Re: Growing memory usage on 6.6 kernel
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1221911.1757062960.1@warthog.procyon.org.uk>
Date: Fri, 05 Sep 2025 10:02:40 +0100
Message-ID: <1221912.1757062960@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Shyam Prasad N <nspmangalore@gmail.com> wrote:

> Is there a known fix in more recent kernels that you're aware of which
> needs to be backported?

Just to note that the cut-over point at which cifs was converted to use
netfslib was v6.10-rc1 (commit 3ee1a1fc39819906f04d6c62c180e760cd3a689d), so
after that memory handling is completely different in cifs and not trivially
backportable.

That said, are they using transport encryption (-o seal) and are they using
fscache (-o fsc)?

David

