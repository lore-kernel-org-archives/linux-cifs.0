Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF33249EB
	for <linux-cifs@vger.kernel.org>; Mon,  5 Feb 2024 13:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707138734; cv=none; b=JvVGA6pPRy06R8LMg1qQoeISrNL6kV1nZbDV9G35m6SsVF8nbFjt1yJsCCOQBSov9DmX5QOgeJamiGWRTkVmOcLO5ITJVIB1skltx5f9zzU7zdDlzbDSQj7zqnWMrO9wrf3M2smb5LmCoirgy0SqmDmb3vYN14Wudf0EH8pr3jE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707138734; c=relaxed/simple;
	bh=NgQELpPpt9/O3+vUcZYkPORr/iT9FFmyju0mdWvHzo0=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=RsstPuMrznLUwLn2py42hJK+21Np+BMuhLs3f7g7242xyAYeC4rLgr2A7UYG99SAdUnqoJIW7lHbHxbQvyhCUsRFCGbz+fQaPBzaTJRLVZx7PY7kUT2qDo05tQ15foJh1tZx2AGiLYtbOARbRDZSJMg7sPsJtzkUDdijHzWXQCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ASnnXux3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ASnnXux3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707138731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NgQELpPpt9/O3+vUcZYkPORr/iT9FFmyju0mdWvHzo0=;
	b=ASnnXux3Fe3GL+CgBzh0B2cf0gDgaKw+fxXu2UWkoyAiJsKaOJ1dVYYY/6Cctj1vDooQR+
	pyOzVYnqMvIIDR8y7Pj/upl8C0aKZqqP0EwtpiRdPSZ/ZTTY0AbPUB4Bv3YZpOFcIgPLMD
	V5mWdOXKKvDO9dZSQvySxhgXfn+lf1s=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-452-aI1aWVQjMeSF3pG6UfuWwQ-1; Mon,
 05 Feb 2024 08:12:08 -0500
X-MC-Unique: aI1aWVQjMeSF3pG6UfuWwQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EE61F383CCEE;
	Mon,  5 Feb 2024 13:12:07 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.245])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6E91B492BC6;
	Mon,  5 Feb 2024 13:12:07 +0000 (UTC)
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
Content-ID: <3011688.1707138726.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 05 Feb 2024 13:12:06 +0000
Message-ID: <3011689.1707138726@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

R. Diez <rdiez-2006@rd10.de> wrote:

> >> Unlikely as you didn't take them for the last merge window, let alone=
 6.2.
> > That said, you did take my iteratorisation patches in 6.3 - but that
> > shouldn't
> > affect 6.2 unless someone backported them.
> =

> Please note that 6.2 is not affected, the breakage occurred afterwards. =
See
> the bug report here for more information:

Ah, right - so the 6.2 in the subject is the last definitely working versi=
on.

David

