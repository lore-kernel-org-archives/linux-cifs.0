Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5433B346A1F
	for <linux-cifs@vger.kernel.org>; Tue, 24 Mar 2026 07:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774336606; cv=none; b=X8zR2SvtgpX4F0K3rf4NwPa3mCP05I/+3Dr3lCwN5jcpyU2vclASbAwbaC6C5cz8D8usTqakVVTs8NhY7jt+ZPFoT/Po/8JkRXwEzjbbk+YhKqdQp96nWxQ0BJ/nHVKEnbmgi4DbnCyjTcDkeJI4yo5QO1GYmguBATDK76On8XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774336606; c=relaxed/simple;
	bh=PBVX1N2R3/W/l111+TonSytoIMzWFKGCCwwoAJdItIY=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=LrUETkDQGtMDLXbzdEs8mZvaD18jZpj07FlxscpVtIUXo7qQr9Z5cwfiO8h/xKtEss9JovAioVOdzPG3jNtJy2C3kqLrlCJ8k5omqeuAI7o9+SCLUnCjaP2HoHYFVpP7NkAIdZBfY0ekomSfSLW7BOGwj4cgte+gvyXYDwNCoQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P+WQCovI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P+WQCovI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774336597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PBVX1N2R3/W/l111+TonSytoIMzWFKGCCwwoAJdItIY=;
	b=P+WQCovIFcJgcJPGHYvwl+7hQx3FjYVse843ttlaXRyVvv4Dn4F1pZUZWe/EyfRX0Ahz1O
	YZ2HhASJwmFrv3P7IXuwWl+dAt6Ik4weYBQuqstJh5encuxIERuIBxfk0+yAqBuCp8EwjZ
	HxuEXZvbdOpaiEBH96xP2Cp09dOjqgQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-600-zO6vSdySMAq3GDoE2zgKUg-1; Tue,
 24 Mar 2026 03:16:31 -0400
X-MC-Unique: zO6vSdySMAq3GDoE2zgKUg-1
X-Mimecast-MFC-AGG-ID: zO6vSdySMAq3GDoE2zgKUg_1774336587
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6BBCE195605E;
	Tue, 24 Mar 2026 07:16:19 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.33.121])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 50E0F1955D71;
	Tue, 24 Mar 2026 07:16:13 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <a1949f85-2e92-429e-83eb-91a7691b9a9b@chenxiaosong.com>
References: <a1949f85-2e92-429e-83eb-91a7691b9a9b@chenxiaosong.com> <20260304140328.112636-1-dhowells@redhat.com> <20260304140328.112636-18-dhowells@redhat.com> <2d8ce118-2f7a-4b7f-8786-4581b29cb74e@chenxiaosong.com> <63655684a778145167a549b4a6251ccf@manguebit.org>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: dhowells@redhat.com, Paulo Alcantara <pc@manguebit.org>,
    Matthew Wilcox <willy@infradead.org>,
    Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
    Leon Romanovsky <leon@kernel.org>, Steve French <smfrench@gmail.com>,
    Christian Brauner <christian@brauner.io>, netfs@lists.linux.dev,
    linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
    linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
    v9fs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 17/17] netfs: Combine prepare and issue ops and grab the buffers on request
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3597848.1774336571.1@warthog.procyon.org.uk>
Date: Tue, 24 Mar 2026 07:16:11 +0000
Message-ID: <3597849.1774336571@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

ChenXiaoSong <chenxiaosong@chenxiaosong.com> wrote:

> In netfs_writeback_single(), on the failure path, should we call
> netfs_put_failed_request() instead of netfs_put_request()?

It doesn't matter exactly, as the only difference really is whether it gets
bumped over to a workqueue, but it's probably better to avoid that if we can.

David

