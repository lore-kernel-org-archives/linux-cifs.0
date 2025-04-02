Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B011C3C08
	for <linux-cifs@vger.kernel.org>; Wed,  2 Apr 2025 19:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743622029; cv=none; b=mqfauUdh/XfGDCwtSFruW4kRD36rKVvXwnQGQdbifAMcFm6CBBnWOuW4n9LeMFy1ncM6+O2lP3PmwrObXmFaXJDKI9h3Jzonv54GFC5jSsCG9GbqOtc2s3T/SvbqTsF9YBlvpeXfa8/sk1hdDYEswTcuX9Cxr9ttJMuMjOAG6vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743622029; c=relaxed/simple;
	bh=yenz5cBUwwYyXTLBLokTOyBoUz5N3n3Hq12KWdb4zwA=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=Q9KB6fBgjLA0HJCGBHmkS0xrRw/yDDkEfk4BZbqb3WOmaSVN8rhRTYpbp5qq6qUSgL0T8iz/lVjmMuePuhwDYSk6LuXG0FB3ISizWom6m/L718LnBQypoBcB0ThwJSESlljZcaRZVinPytsO7ynJzq7yQyhno1l4/rDzcFnkpxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PHw4CU26; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PHw4CU26"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743622026;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yenz5cBUwwYyXTLBLokTOyBoUz5N3n3Hq12KWdb4zwA=;
	b=PHw4CU26l5Pe2BuYHCNG5LfrRs1Sam9NJzy1gmkBwpiJ3SB7bpSEBDO+PxjNDPiDipIiRW
	FEoGZQqrfJbyfhOOhQBFFFhRd/vKpymfJq+Kax6Nx+QmRyUF5gIgJO7lAVtu3h8aE6cLMD
	CqA3C9Hv3frjl3aWZpyhzUczoRej1e0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-653-pm2d3Ii4OVCl0FqfzYLHUw-1; Wed,
 02 Apr 2025 15:27:04 -0400
X-MC-Unique: pm2d3Ii4OVCl0FqfzYLHUw-1
X-Mimecast-MFC-AGG-ID: pm2d3Ii4OVCl0FqfzYLHUw_1743622023
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0913319560B6;
	Wed,  2 Apr 2025 19:27:02 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.40])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2F9B3180B487;
	Wed,  2 Apr 2025 19:26:58 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <b8dbed47-8824-4b3a-b373-061e139ee7a4@talpey.com>
References: <b8dbed47-8824-4b3a-b373-061e139ee7a4@talpey.com> <78c910b0-3391-484e-aa44-42e2f9ff4637@talpey.com> <563557.1743526559@warthog.procyon.org.uk> <659109.1743536087@warthog.procyon.org.uk> <7e1fc71c-2821-4294-833c-746c5fd7ee69@talpey.com> <803441.1743613785@warthog.procyon.org.uk> <CAH2r5ms2J06tJr4VEVDgmcj_1uqOnhYzbC1ybrMWDm=f8wVDoA@mail.gmail.com>
To: Tom Talpey <tom@talpey.com>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
    Steve French <sfrench@samba.org>,
    Stefan Metzmacher <metze@samba.org>,
    Paulo Alcantara <pc@manguebit.com>,
    Matthew Wilcox <willy@infradead.org>,
    CIFS <linux-cifs@vger.kernel.org>
Subject: Re: cifs RDMA restrictions
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <843600.1743622017.1@warthog.procyon.org.uk>
Date: Wed, 02 Apr 2025 20:26:57 +0100
Message-ID: <843601.1743622017@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Hi Tom,

Btw, in smb_recv_buf(), am I reading it right that it doesn't actually pass
buf off to the RDMA layer, but rather just copies into it from a response
popped off of the reassembly queue?

If that's the case, it should be possible to collapse smbd_recv_buf() and
smbd_recv_page() into smbd_recv() and just replace the memcpy() with
copy_to_iter().

David

