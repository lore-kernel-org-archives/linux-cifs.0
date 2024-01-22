Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9346348CC0
	for <linux-cifs@vger.kernel.org>; Mon, 22 Jan 2024 22:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705960893; cv=none; b=QkeJ2EE0QpiLbzw+PXAINzkNwuInn1mm5PCtyzIPidWQIcTQ+qJU6JxDq6pd9SQejXSuyb2Y0upO/oTEmh97XVaGzLkLaUut/A25Ywle0ANrSo2haqySgoQh0bbykbUt7NrPdhywvm4MXaaaMxZME01K0nRKo8/qEHf97opoYCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705960893; c=relaxed/simple;
	bh=V1yJVFjM67labChbznd10CJnK+mwAgP7GMH9rMtUC+s=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=Cao26OJkhZz+QvTy2lQZbQnl2pB/dUnlpPpY6AY+XivPtoxf/GTQ8uyvcmBcVHc5UYvfVIsMpW4xRZ04sYC1mF6BJknF3V1w68aGdEjJAAJTDyZjfiMgFjMk9JEMvibHA8JLXTPhuZIOqjvv4teVO/bt0/nefrQQXA97UZqSCTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EBEW7/M+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EBEW7/M+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705960890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YgorZ9y1ABigf+8AfYUUWexSMaoGg5QlyfBL6eKu5CY=;
	b=EBEW7/M+Pfow7m19Iy0Z74x+/3j92NkJgVJOUMMJr8ERwaVArtvH3ZQhiGB67GIe75jkyE
	OF8NSeC+yNtIZDdzy0wVOGZk894JpDR4w7DJt3oeoFv83Yrsp3p8riZQ7Pc+X2Rgp7t8UB
	s2N1HaFb+W+S5CLi/oUVY9A8obToKBc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-FVBxaMfkOUaLwqIkj88Zsg-1; Mon, 22 Jan 2024 17:01:24 -0500
X-MC-Unique: FVBxaMfkOUaLwqIkj88Zsg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D9621845E60;
	Mon, 22 Jan 2024 22:01:22 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.67])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 77F78492BC6;
	Mon, 22 Jan 2024 22:01:20 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <7790423f-665e-44cc-b4ae-d3f3d2996af5@linux.alibaba.com>
References: <7790423f-665e-44cc-b4ae-d3f3d2996af5@linux.alibaba.com> <20240122123845.3822570-1-dhowells@redhat.com> <20240122123845.3822570-7-dhowells@redhat.com>
To: Jingbo Xu <jefflexu@linux.alibaba.com>
Cc: dhowells@redhat.com, Christian Brauner <christian@brauner.io>,
    Jeff Layton <jlayton@kernel.org>,
    Matthew Wilcox <willy@infradead.org>, netfs@lists.linux.dev,
    linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
    linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
    v9fs@lists.linux.dev, linux-erofs@lists.ozlabs.org,
    linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
    linux-kernel@vger.kernel.org, Marc Dionne <marc.dionne@auristor.com>,
    Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
    Yue Hu <huyue2@coolpad.com>
Subject: Re: [PATCH 06/10] cachefiles, erofs: Fix NULL deref in when cachefiles is not doing ondemand-mode
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3980815.1705960879.1@warthog.procyon.org.uk>
Date: Mon, 22 Jan 2024 22:01:19 +0000
Message-ID: <3980816.1705960879@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Jingbo Xu <jefflexu@linux.alibaba.com> wrote:

> > -	ret = cachefiles_ondemand_init_object(object);
> > -	if (ret < 0)
> > -		goto err_unuse;
> > +	if (object->ondemand) {
> > +		ret = cachefiles_ondemand_init_object(object);
> > +		if (ret < 0)
> > +			goto err_unuse;
> > +	}
> 
> I'm not sure if object->ondemand shall be checked by the caller or
> inside cachefiles_ondemand_init_object(), as
> cachefiles_ondemand_clean_object() is also called without checking
> object->ondemand. cachefiles_ondemand_clean_object() won't trigger the
> NULL oops as the called cachefiles_ondemand_send_req() will actually
> checks that.

Meh.  The above doesn't actually build if CONFIG_CACHEFILES_ONDEMAND=N.  I
think I have to push the check down into cachefiles_ondemand_init_object()
instead.

David

