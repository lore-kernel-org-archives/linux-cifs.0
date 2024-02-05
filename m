Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEF312B88
	for <linux-cifs@vger.kernel.org>; Mon,  5 Feb 2024 09:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707125496; cv=none; b=j4UaUo0A3+EQg/JTlhhCjO8zs9rb4JOmxcOLSwigdPbmhMsHPnCXhtYNUwtqavyJgjEPWbJ1jxedJRR12LN2wIW3FwYSDjsC9SIWyOool4K4D+RqoSa9k6nm/Bbel5TN3z00sLWPJT9l2Ov25dBJUqbKooW1DJRLPgX/4B08sk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707125496; c=relaxed/simple;
	bh=OzU6mnPFCY7KfvfMk7jsVNmV+vAstFImvWZgLIIZdI0=;
	h=From:In-Reply-To:References:Cc:Subject:MIME-Version:Content-Type:
	 Date:Message-ID; b=Mq6uvcU6TTSHfLdmK9/SnQ/wWeI2tUV2AWfPqatMkDQPCkBjHQ5xWUCjpTrBt+jDBHOTe3caVG2PX6k1hIDW1erkoxmKboLFyfYv+2x/sxjGLDPjK+PTZslKstcY2a2gMmgG9iggqMlpIq0RHyKcIr2kLuw9VL5y9PcEiXV8CLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hikkN9I6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hikkN9I6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707125493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fxXxV+DkikhaqBYK6PKix9OBGmQ2q8tBOhsrX/dj7zA=;
	b=hikkN9I68XElTrDX8DMZXSpZnzLDvVSaq56YjWR2raeph+2PjFu1aKG98QGbo++Y2kCkH3
	0b6moc5DKCEENMCOaXT091HI4RcMpDUg38ZKee0WD10gVaD1iQYja/+dRXSwmhEcCPJL+o
	2y+lgo5mKt+FzNN0z/KKx36owczQnnE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-ytrP5gwBPcOAPPw75N3mGw-1; Mon, 05 Feb 2024 04:31:26 -0500
X-MC-Unique: ytrP5gwBPcOAPPw75N3mGw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 00D7D185A784;
	Mon,  5 Feb 2024 09:31:26 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.245])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 757F02026D66;
	Mon,  5 Feb 2024 09:31:25 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <3003956.1707125148@warthog.procyon.org.uk>
References: <3003956.1707125148@warthog.procyon.org.uk> <CAH2r5mtYF4MgTz8v3DGfYiDycMMaGywuyPxF9-61d4575-S0bw@mail.gmail.com> <a356847f-afa0-446a-b896-fd2b9af2e393@rd10.de>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
    "R. Diez" <rdiez-2006@rd10.de>, linux-cifs@vger.kernel.org
Subject: Re: SMB 1.0 broken between Kernel versions 6.2 and 6.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3004196.1707125484.1@warthog.procyon.org.uk>
Date: Mon, 05 Feb 2024 09:31:24 +0000
Message-ID: <3004197.1707125484@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

David Howells <dhowells@redhat.com> wrote:

> > any thoughts whether this could be related to folios/netfs changes?
> 
> Unlikely as you didn't take them for the last merge window, let alone 6.2.

That said, you did take my iteratorisation patches in 6.3 - but that shouldn't
affect 6.2 unless someone backported them.

David

