Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458CC211700
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jan 2025 16:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737649919; cv=none; b=hMZXaN9ie9mgqK6qIAtnQKQCNrArbTSM5Kbp38xzXNRYQPX/1I7p1yRM4JnbfNgPmRFHyGpWWp5F2zebZIs/zWGyVewpdrm0OIFQXSDqSmprvvQiSk2OsjBSjsRyV0m2biSBRVLqJkoLniJMji8zueV2BSLKdx36RNoFytOz0ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737649919; c=relaxed/simple;
	bh=/bUtW6hMwrEG2dn2NFmhKabAvL9HPwgGP31FobUYzDA=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=uxyhYBP1bnFOFRvr+EmTUc8DmNpY0uM+nAZW/dj5K4/h3Yo7uHVDl2w6rv+TpEpVUHT4gV+0V3f+s31qSUc/SdYukyYMci6yO0W3BlLi5pbXUSM93lwLB0I7/HtldPXy5neerdjLBkIftrZi5BxsxS9EHNl0WYsVgazqxJVUWjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZdGAVnmJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZdGAVnmJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737649916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=90kDIZbIPZR8LclIILYErH2AuCR6R7uS1QNeYpHNJHg=;
	b=ZdGAVnmJlk+oPHyysEYLnQakuvQOEacW1rPXq1MxMuSAFhVyyPXZ9RBHaneoPRrHxJRRU4
	dbaeNAxRg03VgpL5sDF1b1cuu+qM/BoLOGlAGy3Bzx9xD6FgEfdggHWn8wpxwCXwORkHXH
	mXE+LRH/AgQF7khPxFIygDRJ7bBkT/o=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-388-WPK8im1EMvWGj3YH7_KLPA-1; Thu,
 23 Jan 2025 11:31:52 -0500
X-MC-Unique: WPK8im1EMvWGj3YH7_KLPA-1
X-Mimecast-MFC-AGG-ID: WPK8im1EMvWGj3YH7_KLPA
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B32F419560B1;
	Thu, 23 Jan 2025 16:31:51 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.5])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6E815195608E;
	Thu, 23 Jan 2025 16:31:50 +0000 (UTC)
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
Content-ID: <2194114.1737649909.1@warthog.procyon.org.uk>
Date: Thu, 23 Jan 2025 16:31:49 +0000
Message-ID: <2194115.1737649909@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Hi Shyam,

Do you have any particular way of reproducing this?  It's been a while since I
looked at this bug.

David

