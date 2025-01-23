Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11545F4F1
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jan 2025 16:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737650112; cv=none; b=F+5c8JsMY+n0G/l+4qmb8trnf0WyqOcOhB0A+aLPoYqL1ApgBFnMtTjaNdnOGi8ibLKEGoBW7lHVftW/2H+uyynDHMVAPi4M4IZBTjLABDuIhQSXHK9qyTuSiZ4QFMzfm4xxTQyNX6Ad5oCvbjLMAJwozmFch3RyaSQcSKkL1cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737650112; c=relaxed/simple;
	bh=4s8arKEzKFcw11WEeaT51lV0rCLvy/X9TFO9s/w3jr4=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=EGCSiu5RNUZ6iVazeDxnlMPduaSmmLWjtWb6wru7mc4OtuAq5t6jpON+5pAMBf/IETn6GIJcQbAcQ7rfDjQAHW/yHPgqvmL7YAEw9MTWGYPiazyBMhWip4wN7tgsE+Y5IlMa+2Yec1KEfrptus5hjZG6PohFmgqCW5Ce51Z+Qjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XPzrmAJd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XPzrmAJd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737650110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Q73QoaoamFs4RRlWa4WN0Q+HIVuWllUe8vbGo74uYpI=;
	b=XPzrmAJdo4iRTDi5NEJWtABeV7zebVUWIbGgp6m72POLZT90R+MvqAHyKhdQq3wN+Ffqqf
	VtismKewhC5AR9W/HmElwjhqoXUbxBvYyG8OGoQZozv8z1qzF+RSJplJYCc1ePaXgzLxEj
	xGaae86SVbAWm39e9aEKItUYUxZy96k=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-339-yr9ZROtBMZGc6TMUEL0IyQ-1; Thu,
 23 Jan 2025 11:35:05 -0500
X-MC-Unique: yr9ZROtBMZGc6TMUEL0IyQ-1
X-Mimecast-MFC-AGG-ID: yr9ZROtBMZGc6TMUEL0IyQ
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2A65819560A2;
	Thu, 23 Jan 2025 16:35:02 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.5])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D573B19560A7;
	Thu, 23 Jan 2025 16:35:00 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CANT5p=peKRDJi6XHKpuDKx82sJdJKVwa-gW_KGUOcyh_rt0tWQ@mail.gmail.com>
References: <CANT5p=peKRDJi6XHKpuDKx82sJdJKVwa-gW_KGUOcyh_rt0tWQ@mail.gmail.com> <CANT5p=pUGYwswgXM-pniMjEWwbLK0cKXPBOJB9cG_cOrkBwQhg@mail.gmail.com> <CANT5p=qBwjBm-D8soFVVtswGEfmMtQXVW83=TNfUtvyHeFQZBA@mail.gmail.com> <505338.1733181074@warthog.procyon.org.uk> <526707.1733224486@warthog.procyon.org.uk> <CANT5p=pO28C+XEC44taAT-Z6W_spB-QzJb+MOXv68bDRGqJn=w@mail.gmail.com> <CANT5p=qc97-Ncs4E6_KfcYVxBYU5cw5LnPJoccb3gePa8OuCKg@mail.gmail.com> <CAN05THTXWKGDynqPLzSfT2j0vvQ9At0YKBHYWMm0KM4mCgyOxA@mail.gmail.com> <CANT5p=rFSLgCyZ8D1CUcSBzmyW+voAbxbOwRHH+=vPgxhLaRfw@mail.gmail.com> <CANT5p=rw_mewxPrp0xxQcBRY8Z7Zwg6RQMCXyc7vwWvDur5dHQ@mail.gmail.com>
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
Content-ID: <2194784.1737650099.1@warthog.procyon.org.uk>
Date: Thu, 23 Jan 2025 16:34:59 +0000
Message-ID: <2194785.1737650099@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Shyam Prasad N <nspmangalore@gmail.com> wrote:

> I tried this again with 6.13-rc1 and the null-ptr deref seems to be
> slightly different (same function).

Note that v6.13-rc1 doesn't include my patch.  You need to be on v6.13-rc7 for
that.  There are a number of other patches that went in too that might affect
what you're seeing.

David

