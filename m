Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155AB2206A9
	for <linux-cifs@vger.kernel.org>; Thu, 11 Sep 2025 16:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757607923; cv=none; b=Oqnzq3R0mcxVRSOJb7LHCHL3s2cN2EkqrfsGEU37cis9aRxdPEg9kfEtsK+490ENYs4hEQDEIixQEkD4Y2idRAzSQJL8rmtSwQEboDMJf+Y9H+Sh7hl8OEjC9qhtjb22qMUFyr/2HzKBOhpwcrvtOcCEx8vL/fzGVk93v4mbP5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757607923; c=relaxed/simple;
	bh=PR52AW0jMRA9Md4fiLVlHH2qtbQtKTkdmats5dfyD60=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=CED+CZRm9abUPpAyeX10IHlH5n3X/+T74IfFb6CVZDKur/bHntqXHRCVTyIdxzxd6rXtsajtRXYAcwp/TtNj5FUwyc0KKOPzl4t/YslHSQTqyZeEToc7VXnRWZjdA8PNvgWlZpEfMxwidcy3Aan3bMcErNp7ZpVk21EpeMNhROs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KoYZXo/0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KoYZXo/0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757607920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R0g49O2ePZuKTHbko+2wbGHRgCoDqRTUsVjaYJFlrjw=;
	b=KoYZXo/02nmqZA5q8OyL/SMp/vlEYsvOYoaRnE3y4H43HiP1Vzx/U3MZczTZGNhrH+DjHt
	Tdf51YfuzMxIesUiM70BYf2zz0KolSJ7OidX+xWLTi0gSo21hHHvHdsa9JpnizffOqlqa3
	1ImNQvo8Oq95y1NFw3VJFECpVfjC0qk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-421-hpBmv8mXPpuLQpNsCpmnpQ-1; Thu,
 11 Sep 2025 12:25:14 -0400
X-MC-Unique: hpBmv8mXPpuLQpNsCpmnpQ-1
X-Mimecast-MFC-AGG-ID: hpBmv8mXPpuLQpNsCpmnpQ_1757607912
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B98E4180057D;
	Thu, 11 Sep 2025 16:25:11 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.6])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 89DAB18004A3;
	Thu, 11 Sep 2025 16:25:07 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <2780505c-b531-7731-3c3d-910a22bf0802@huawei.com>
References: <2780505c-b531-7731-3c3d-910a22bf0802@huawei.com> <20250911030120.1076413-1-yangerkun@huawei.com>
To: yangerkun <yangerkun@huawei.com>
Cc: dhowells@redhat.com, sfrench@samba.org, gregkh@linuxfoundation.org,
    pc@manguebit.com, lsahlber@redhat.com, sprasad@microsoft.com,
    tom@talpey.com, willy@infradead.org, linux-cifs@vger.kernel.org,
    samba-technical@lists.samba.org, stable@kernel.org,
    nspmangalore@gmail.com, ematsumiya@suse.de,
    yangerkun@huaweicloud.com
Subject: Re: [PATCH v3] cifs: fix pagecache leak when do writepages
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1955608.1757607906.1@warthog.procyon.org.uk>
Date: Thu, 11 Sep 2025 17:25:06 +0100
Message-ID: <1955609.1757607906@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

yangerkun <yangerkun@huawei.com> wrote:

> >     	if (folio->mapping != mapping ||
> >   	    !folio_test_dirty(folio)) {
> >   		start += folio_size(folio);
> > +		folio_put(folio);
> >   		folio_unlock(folio);
> >   		goto search_again;

I wonder if the put should be prior to the unlock.  It probably doesn't matter
as we keep control of the folio until both have happened.

David

