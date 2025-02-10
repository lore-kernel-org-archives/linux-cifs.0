Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0045D222586
	for <linux-cifs@vger.kernel.org>; Mon, 10 Feb 2025 13:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739192714; cv=none; b=RQcL0bJ9Llbi/lmcCdKJ/mt4iUzhaW95dG7Wtl+CXl4+ePIftW25LQFoAljesU32npNBIRGvJ1XMxRknQc82gpY3y9g6FnXOG43a0tgP8wQAGG/dJwOnRNQNozE7vWK+jYyOEAKnxX9Fa/wzJVw3uvD7jwlQvw9B+31hfNB1bHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739192714; c=relaxed/simple;
	bh=dJY6FF+SXGDXT3/s4HkOYygQhgGqnCqkBjPdqKPssQs=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=OZxRuISLGSx4UdEsg6rMSFQ0Cxupfef0FYaHRhvZvFhuyioBuWLjdzNdSuQeToKCdWpmq7WZDxlXivbmW3pdXx7WTiCBXpAphdPXpqOHcyFS6G49YVyT1SjcezQxWaU4xELtm+EC60Kzsy/wxfRo6SXDcZNxpM8f7X+IDJ/5zAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JbDSe0ec; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JbDSe0ec"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739192710;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ziu5bYfChbk63QB3eLjGTLuS2tRlNRKizVuNnFhCyoI=;
	b=JbDSe0ec2roWCiQ+2oU3IU0JVBPTkPUQpP1wfGgQr2Y8ZcLhuhSZX7hlhox4celVIYw0lf
	pfdcvxqvanW9/0hWbbkw1BOnd5zAGYsVupM0J6fhtZOTS6cfEh3PB998gm4kv/vKchokS7
	LYzwV6zdl+SSGH3oXSdVDS04rBVcLko=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-128-Ugwu3jE6PvmfWYrAi4VCGQ-1; Mon,
 10 Feb 2025 08:05:07 -0500
X-MC-Unique: Ugwu3jE6PvmfWYrAi4VCGQ-1
X-Mimecast-MFC-AGG-ID: Ugwu3jE6PvmfWYrAi4VCGQ
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EAB7B1956088;
	Mon, 10 Feb 2025 13:05:04 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.92])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 869601800570;
	Mon, 10 Feb 2025 13:05:02 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAH2r5mv4N9zFOKTxwdvk6ahAyjgpYULQp8iw2NMu3eB6FEXh0A@mail.gmail.com>
References: <CAH2r5mv4N9zFOKTxwdvk6ahAyjgpYULQp8iw2NMu3eB6FEXh0A@mail.gmail.com> <3bd10acc-2d7f-019a-3182-82ab647bc15a@huawei.com>
To: Steve French <smfrench@gmail.com>
Cc: dhowells@redhat.com, Wang Zhaolong <wangzhaolong1@huawei.com>,
    stable@vger.kernel.org, linux-cifs@vger.kernel.org,
    yangerkun <yangerkun@huawei.com>, yi zhang <yi.zhang@huawei.com>,
    Paulo Alcantara <pc@manguebit.com>
Subject: Re: [BUG REPORT] cifs: Deadlock due to network reconnection during file writing
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3049254.1739192701.1@warthog.procyon.org.uk>
Date: Mon, 10 Feb 2025 13:05:01 +0000
Message-ID: <3049256.1739192701@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

This is before cifs moved over to using netfslib (v6.9) and netfslib took over
all the dealing with the VFS/VM for I/O and the handling of pages/folios.  Do
you know if the same problem occurs after that point?

David

