Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA1B582BB6
	for <linux-cifs@vger.kernel.org>; Wed,  9 Sep 2026 16:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788971710; cv=none; b=N4tN7L0sOLmIiq786H8sthbIcMrDpSZvahW7dcxlRqbhJiPDlcjFYR6P4PBmAmelTsSsJTcolBSWsFJkbYhHrrD9jS70RSJZdumAfaNXB4lOkWV0pxTQ0slZZb3B9vb5P1rX7Z6uWZXAmMbIzb7SnQ/eRrFDcbJiI/OobdnG/6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788971710; c=relaxed/simple;
	bh=60WjLMgFMCrph66eBsvuCqz/GOUvYhoLcWJmyHIMc4Y=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=IloHi+fsQ0OZkqIx7bYxvhwGlTYQGPfwghrnmN0CKswMMv5EaCg7muSu8ovPZOWPZbrgHTxqSYV/45apeRdxoqe9jiW45y4+BwlPKZ+5Dyi7J3J3UBnPyPOpXFjKDzTQPzfayJfPkkayZdjIau5whNfcEIUjk+UkC5rxKf2lIo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QGc0eekE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QGc0eekE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788971707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=60WjLMgFMCrph66eBsvuCqz/GOUvYhoLcWJmyHIMc4Y=;
	b=QGc0eekEODe8TnmxNblRiT9qAQCBMvXj6+0eKUHuBp/0fEYjyIqvEayD/rFOMiZzAEHxHY
	/OaA1babiC8cyiNr79nd5/Zu5LcqEKzYWFz13gOK/4K8Uqiqre1n0Pc0Xsu8d0vRV+ybBs
	4Kye69xfKGFJhN/g+iLrqkg+6hqrZU8=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-121-S15F5c3LOqK5FkAYxjUyhQ-1; Wed,
 09 Sep 2026 12:35:04 -0400
X-MC-Unique: S15F5c3LOqK5FkAYxjUyhQ-1
X-Mimecast-MFC-AGG-ID: S15F5c3LOqK5FkAYxjUyhQ_1788971703
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D927A1954ACF;
	Wed,  9 Sep 2026 16:35:02 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.158])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6BEB230001A2;
	Wed,  9 Sep 2026 16:35:00 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <afd68097-b2b2-47e5-889b-fb077e7a9247@redhat.com>
References: <afd68097-b2b2-47e5-889b-fb077e7a9247@redhat.com> <a385053c-1c4a-4060-a3bb-befa007ddb33@redhat.com> <1714046.1788952509@warthog.procyon.org.uk>
To: sorenson@redhat.com
Cc: dhowells@redhat.com, Paulo Alcantara <pc@manguebit.org>,
    Jeff Layton <jlayton@kernel.org>, linux-fsdevel@vger.kernel.org,
    netfs@lists.linux.dev, CIFS <linux-cifs@vger.kernel.org>,
    linux-kernel@vger.kernel.org
Subject: Re: netfs_read_gaps(): aliased sink folio makes the read destination unreadable, SIGBUS on cifs with signing
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 09 Sep 2026 17:34:58 +0100
Message-ID: <1728242.1788971698@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Frank Sorenson <sorenson@redhat.com> wrote:

> unlocks something that was never locked, and never drops the reference.
>=20
> So should these be folio_put() instead?

Bah... Yes.

> 2) if netfs_alloc_request() fails,=C2=A0the kfree(bvec) at alloc_error is=
 reachable
> before bvec is assigned,

Fair point.

David

