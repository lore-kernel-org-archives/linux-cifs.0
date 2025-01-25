Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9A41CD3F
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jan 2025 19:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737832409; cv=none; b=YUmJbdKBY+Dqkvse0qm48sh58NQMDeVO3PfoBg8eEweyL7mWnfwUvXwMuKc60J8nRRVF5HTbsWKxF0Xfe5aKo0wYzqjHMBz9h1Nh6zo6yVxJlgzRCcqby0QGIcY02h0DFGfTdEspkq2O9tDxcp2wgAUafbNvcwmHnMv0Q13KH4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737832409; c=relaxed/simple;
	bh=uEAqHALv9jm3tIyuT8/pzN4T87bt0/r3RzDVEWe3NpU=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=VgrL075J7wZQhMve/K5Dq6H1kIAHHjam6xV92YjHGFBwg45H2kW+b/ci7g6amOCc5UPs7SpD3DGREIkodHiQWUAqDbjRxMcPDIBhLskr5UGgl26pYd1eCD/jmQzLI0wvXzWmY1qrIYtR1yG6U4iuWPfQUnUnFkxUbm73Mg13uiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SdrBpIvu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SdrBpIvu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737832406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t4auuM+gRkH6XArHeITXiQdSx2SBGpYHUM9PVbfE8WM=;
	b=SdrBpIvu9M88fhId5bEdt47qg7k5NU5OK4Uc7XF6BakpBsfkg3/ccM1aZOcckaOSVWpcuv
	h/dWsWBr3Krwa1LbUvrJBUTrYv1qfLLrXc8tr8XAsGmSovE0gl4xwT5n0vLX4mxa31L+IM
	QlF44MldKEcUO2FoEdMDGulxKpMqnwM=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-643-ZY4eqW5mPi-C2Y5l_erkXw-1; Sat,
 25 Jan 2025 14:13:22 -0500
X-MC-Unique: ZY4eqW5mPi-C2Y5l_erkXw-1
X-Mimecast-MFC-AGG-ID: ZY4eqW5mPi-C2Y5l_erkXw
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9BF4F19560BB;
	Sat, 25 Jan 2025 19:13:21 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.5])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 33AE119560AD;
	Sat, 25 Jan 2025 19:13:20 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CANT5p=pgD_jM6y1VRUHZRRfSkQWm3juW3oLOVpqFMzW1hMOgOQ@mail.gmail.com>
References: <CANT5p=pgD_jM6y1VRUHZRRfSkQWm3juW3oLOVpqFMzW1hMOgOQ@mail.gmail.com> <CANT5p=pUGYwswgXM-pniMjEWwbLK0cKXPBOJB9cG_cOrkBwQhg@mail.gmail.com> <CANT5p=qBwjBm-D8soFVVtswGEfmMtQXVW83=TNfUtvyHeFQZBA@mail.gmail.com> <505338.1733181074@warthog.procyon.org.uk> <526707.1733224486@warthog.procyon.org.uk> <CANT5p=pO28C+XEC44taAT-Z6W_spB-QzJb+MOXv68bDRGqJn=w@mail.gmail.com> <CANT5p=qc97-Ncs4E6_KfcYVxBYU5cw5LnPJoccb3gePa8OuCKg@mail.gmail.com> <CAN05THTXWKGDynqPLzSfT2j0vvQ9At0YKBHYWMm0KM4mCgyOxA@mail.gmail.com> <CANT5p=rFSLgCyZ8D1CUcSBzmyW+voAbxbOwRHH+=vPgxhLaRfw@mail.gmail.com> <CANT5p=rw_mewxPrp0xxQcBRY8Z7Zwg6RQMCXyc7vwWvDur5dHQ@mail.gmail.com> <CANT5p=peKRDJi6XHKpuDKx82sJdJKVwa-gW_KGUOcyh_rt0tWQ@mail.gmail.com> <2194785.1737650099@warthog.procyon.org.uk>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: dhowells@redhat.com, ronnie sahlberg <ronniesahlberg@gmail.com>,
    Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>
Subject: Re: null-ptr deref found in netfs code
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2727966.1737832399.1@warthog.procyon.org.uk>
Date: Sat, 25 Jan 2025 19:13:19 +0000
Message-ID: <2727967.1737832399@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Shyam Prasad N <nspmangalore@gmail.com> wrote:

> >> netfs: R=00005a08[a] s=2600000-29fffff ctl=200000/400000/400000 sl=5
> But based on the OOPS that I attached in my last email, slot number is
> 5, which explains why folio at that slot is NULL.
> 
> I don't understand the donation logic well enough to understand why
> slot could have overflowed like this. Maybe you can?

Can you get a trace with the following tracepoints turned on:

netfs_read
netfs_rreq
netfs_sreq
netfs_donate

Thanks,
David

