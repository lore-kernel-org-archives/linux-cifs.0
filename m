Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCA8C12881F
	for <linux-cifs@vger.kernel.org>; Tue,  6 Feb 2024 07:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707204770; cv=none; b=khL0DqerfchD7rYGZKI1WpARoK+c2IOgRDNx9oYw/6hJCXdmP+mVi76F+4oC9TcS8ztipBBwu6FUXks96bFxlLhSj/Y6qDTxOh+rvNKsWwslrkNQaz07+zc9peoHlfzCkdo9zxLTfJgzr79aJxoCbPGTI5RQX+VYcp8uJphLJdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707204770; c=relaxed/simple;
	bh=+roW5Z22oktJ1dnTMoskbRsgoukqXu9MqkBJjQ4KZjA=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=a5mgZq4VbzrmychlibKUFsc1DA5WxEULocht3/ALExcEMx8dauylLSbUIc8eh/fti9ZXZGgzwT/SjxDA7x8j5wSXTIZ0o3+xmTzRj5iiA1FfWt25YWdBFPkFwU70njfjURitQ0lMxWpEZ37eCpvQoHlpGk6YxZZeTIr3esPsdEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AavjgCA9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AavjgCA9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707204767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6ERQOxwgfmj5IrUo16Nl+eGWIaMPIYDxIBZ9mphpQt8=;
	b=AavjgCA94V6Xc4YcxJlNr40P5VQdXudu0CKPfXSfw2KjtmiextqUh0hKga4fmz4yO78j3k
	9pzvALYqsDig1KVnzL738txHfee7EfVAdfd4D92gon0ajp6l0wOW+DK28bFkxjbCxKfZeg
	FUZnWTvnd9PrObQVg+HXbM2hUc3yixY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-195-MLXbBhbHMLSBo52qWTLNeg-1; Tue,
 06 Feb 2024 02:32:44 -0500
X-MC-Unique: MLXbBhbHMLSBo52qWTLNeg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CDFDC380662C;
	Tue,  6 Feb 2024 07:32:43 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.245])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0462A1C060AF;
	Tue,  6 Feb 2024 07:32:42 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <262547e6-72e1-436f-8683-86f7a861f219@rd10.de>
References: <262547e6-72e1-436f-8683-86f7a861f219@rd10.de> <3003956.1707125148@warthog.procyon.org.uk> <CAH2r5mtYF4MgTz8v3DGfYiDycMMaGywuyPxF9-61d4575-S0bw@mail.gmail.com> <a356847f-afa0-446a-b896-fd2b9af2e393@rd10.de> <3004197.1707125484@warthog.procyon.org.uk>
To: "R. Diez" <rdiez-2006@rd10.de>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
    linux-cifs@vger.kernel.org
Subject: Re: SMB 1.0 broken between Kernel versions 6.2 and 6.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3113885.1707204762.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Tue, 06 Feb 2024 07:32:42 +0000
Message-ID: <3113886.1707204762@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

Out of interest, are you able to try an arbitrary kernel?  If so, would it=
 be
possible to see if:

	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log=
/?h=3Dcifs-netfs

fixes it?

Thanks,
David

