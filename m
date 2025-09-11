Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74984322536
	for <linux-cifs@vger.kernel.org>; Thu, 11 Sep 2025 16:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757608330; cv=none; b=XUhFyE4EmxdT3GRhuorfRGa2K793b86CAy5wDtgOJsVXMLJpNljiJw+X8PxukbGAZizOVBBFl/78Dk09+AfWYBwcvwm/QvTbW/t26i5vmhvPQ0KLg7bxiOwH+A6fDqaPcyXN81FMCB+i5rTJTseoZW2L2Dtuw+Suq9CXFWBEO5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757608330; c=relaxed/simple;
	bh=srxHJhhiDdL6phJrQcSzmrUkW9hOG/BKDUogbzi+Hmw=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=gWMUJTDhYibRSOCbYO8J7H5h9Xi8NgUjeRzpdkr6y4kU1xQaugkGvD8OR6/u6Y0vX5wvOShYMV+XCOatyasTA22GpxTxccA01gRzX9NjfPA7ekffmFNdFhXmdlGq0Pv2Tf75/W6z0+G+s3zcmBV1IJaWfbu8m4Uu3t6rTxyTIgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XnvukVUo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XnvukVUo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757608327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=srxHJhhiDdL6phJrQcSzmrUkW9hOG/BKDUogbzi+Hmw=;
	b=XnvukVUo2rc/kmRqoq7kdQGeKinaFd6uy+qUu5OF7R0s7Vt+VvudBNhVOsBgLyhOi5XpxD
	emZ2x0c+PadweU8nP/Uby24W+iWzgVGqqVMoacvIuagFy8KO/ZziOII6tW2Td2NIgYQYMO
	13JwbuENnRqt5q+SJ4VMBbl4TVWIbuA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-371-VZAKZYXcNOGnZ5IeFPJMnw-1; Thu,
 11 Sep 2025 12:32:04 -0400
X-MC-Unique: VZAKZYXcNOGnZ5IeFPJMnw-1
X-Mimecast-MFC-AGG-ID: VZAKZYXcNOGnZ5IeFPJMnw_1757608322
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D1EC61944F03;
	Thu, 11 Sep 2025 16:32:01 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.6])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D99611800576;
	Thu, 11 Sep 2025 16:31:57 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <2025091109-happiness-cussed-d869@gregkh>
References: <2025091109-happiness-cussed-d869@gregkh> <20250911030120.1076413-1-yangerkun@huawei.com> <2780505c-b531-7731-3c3d-910a22bf0802@huawei.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: dhowells@redhat.com, yangerkun <yangerkun@huawei.com>,
    sfrench@samba.org, pc@manguebit.com, lsahlber@redhat.com,
    sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org,
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
Content-ID: <1955890.1757608316.1@warthog.procyon.org.uk>
Date: Thu, 11 Sep 2025 17:31:56 +0100
Message-ID: <1955891.1757608316@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Greg KH <gregkh@linuxfoundation.org> wrote:

> Yes, please include the info as to why this is not a backport from
> upstream, and why it can only go into this one specific tree and get the
> developers involved to agree with this.

Backporting the massive amount of changes to netfslib, fscache, cifs, afs, 9p,
ceph and nfs would kind of diminish the notion that this is a stable
kernel;-).

David

