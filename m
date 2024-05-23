Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C9A187F
	for <linux-cifs@vger.kernel.org>; Thu, 23 May 2024 06:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716445272; cv=none; b=uFxLUxLQ+kunSwtBW9cHd1dwXMVyamsB6KJt9DFJYSY2ECND23e9ZoamyTxayFvZFgyzzt0KnTwTWSK9eSU6Cda6g02CZXnCcr3d+dw7EZ4G8OnuWYWUTRW4rkTqmQfSyHskjtZG92/FUYbmTj/p9rfjJefYF1CfbpBL4HyXJV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716445272; c=relaxed/simple;
	bh=t1w/JWiqyLXDFudQqivd03bkdORyefXmrWXUGRwboAs=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=D1sCguDVGAFJxbSYeEZtrPa+LckqyuiVMlupKmvPEyn+jiPkAhwyqwDdtrTg3rLbxrv2ej/taXelyWxL4aLdYxL9fC+XpBM1nKeTqP/KKUqqpZZbFb9h/ZuTKUGEioTG4wy+EaJiUqSHqKGC5Uez0O3GRCyhOcshhmoQV8semP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YXRKCqui; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YXRKCqui"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716445269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MFCH5FHHlTKbviZWd8Klg1mfh/OtMCPKAMqc25553Vs=;
	b=YXRKCquikVhEWZ+NFzanbBH6g55z87671zRwIUHTPu/QRZ+K3rN36rJS3xcHCdx0X0rlqx
	CL/3uk9AR8wnAD/Au6P9llONR2y2gFvTu8uo80NLcb9UlZki+dg+MuWxFL9We6+YFpRrWc
	GON6ppwph6ZjQi/pYirHAfbhWjw229c=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-493-biU3tiwgMGiB4UiYOxk82A-1; Thu,
 23 May 2024 02:21:03 -0400
X-MC-Unique: biU3tiwgMGiB4UiYOxk82A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 59F003C000A8;
	Thu, 23 May 2024 06:21:03 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.20])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 751A0C15BED;
	Thu, 23 May 2024 06:21:02 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAN05THRuP4_7FvOOrTxHcZXC4dWjjqStRLqS7G_iCAwU5MUNwQ@mail.gmail.com>
References: <CAN05THRuP4_7FvOOrTxHcZXC4dWjjqStRLqS7G_iCAwU5MUNwQ@mail.gmail.com> <20240522185305.69e04dab@echidna> <349671.1716335639@warthog.procyon.org.uk> <370800.1716374185@warthog.procyon.org.uk> <20240523145420.5bf49110@echidna>
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: dhowells@redhat.com, David Disseldorp <ddiss@samba.org>,
    David Howells via samba-technical <samba-technical@lists.samba.org>,
    Steve French <sfrench@samba.org>, Jeremy Allison <jra@samba.org>,
    linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: Re: Bug in Samba's implementation of FSCTL_QUERY_ALLOCATED_RANGES?
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <476488.1716445261.1@warthog.procyon.org.uk>
Date: Thu, 23 May 2024 07:21:01 +0100
Message-ID: <476489.1716445261@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

ronnie sahlberg <ronniesahlberg@gmail.com> wrote:

> On Thu, 23 May 2024 at 14:54, David Disseldorp <ddiss@samba.org> wrote:
> It might be best to just ignore tests that fail in this area. And just
> accept that some things, at best, is a best-effort approximation.
> (as long as dataloss does not happen, of course. That is never acceptable)
> At the end of the day it is a lot of guesswork and trying to fit a
> square peg (unpredictable ntfs behavior) into a round hole (linux vfs
> api).

The problem is that it essentially renders SEEK_DATA/SEEK_HOLE unusable for
applications on cifs.  If there's more than one extent above the starting
position, they'll fail with EIO.  The only way to do it is to provide for a
sufficiently large buffer to accommodate however many extents that there are
(and there could be millions, in theory) in order to get just the first one.

David

