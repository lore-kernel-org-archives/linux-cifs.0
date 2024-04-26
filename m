Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D6D13C8FF
	for <linux-cifs@vger.kernel.org>; Fri, 26 Apr 2024 08:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714118443; cv=none; b=KsGQUsr/ug/13gE5QMxtvewg9JJTA85fZ/ybxuNVhTt2mhtT9eyse75Zz8KCLyTozUhSjdFMtgDHP4TCMUckep8g5csBdHcmm4kmzIIxvEp/lOa01AG41Ldjkopl6IbkIlg+xBzTDsU/yLTlw5qrLZ+H1bwiPw184Aowjhj/UTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714118443; c=relaxed/simple;
	bh=8moJHIF915kF9JPZZi2hSy1ahaIWtygA+5VPkH7e8r8=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=aWuzMSHhNscN/BDQkNx5RmG0/8wo3Fo10I+/NrIa15mXE0Phmw74AKRbQZq1ysfWapBcEzJZYazp9pmJJEeotKX4sRir5icCcXg8q0ii3D+EoU/JjeJUd5BJYtmMgGaMn4qBTvzzwW81zJ1fiF/uV9OjoJV15bXlgtJBWBmxM/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K9t+9G+a; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K9t+9G+a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714118441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xIFFxT8ZyW309/4jPgibBUS9mKjAZgteIkx/pxryLuo=;
	b=K9t+9G+aPTmZZzoQ5tlhaJveJfAzj+Dvd+earc8OJXle0oqywfSGxlVAfhfzV6//8YdWs9
	D53/QBYZWd+fIDjpGRaTA0dNEIBPWbtVUhR2fGLSvH+uUFsHeysWWsSmi7lxwrgC+WGvS7
	expAfT1edy4rM7EC5b6JOD7OqcE3DzE=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-573-mr3uO8cZOamc3ageCNO_lw-1; Fri,
 26 Apr 2024 04:00:37 -0400
X-MC-Unique: mr3uO8cZOamc3ageCNO_lw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BE0893811701;
	Fri, 26 Apr 2024 08:00:36 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.200])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 16B5016D93;
	Fri, 26 Apr 2024 08:00:34 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20240425084537.6e406d86@kernel.org>
References: <20240425084537.6e406d86@kernel.org> <1967121.1714034372@warthog.procyon.org.uk>
To: Jakub Kicinski <kuba@kernel.org>
Cc: dhowells@redhat.com, netdev@vger.kernel.org,
    Jeff Layton <jlayton@kernel.org>, Steve French <sfrench@samba.org>,
    Herbert Xu <herbert@gondor.apana.org.au>,
    "David S.
 Miller" <davem@davemloft.net>,
    Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
    netfs@lists.linux.dev, linux-crypto@vger.kernel.org,
    linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] Fix a potential infinite loop in extract_user_to_sg()
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2101063.1714118434.1@warthog.procyon.org.uk>
Date: Fri, 26 Apr 2024 09:00:34 +0100
Message-ID: <2101064.1714118434@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

Jakub Kicinski <kuba@kernel.org> wrote:

> On Thu, 25 Apr 2024 09:39:32 +0100 David Howells wrote:
> > Fix extract_user_to_sg() so that it will break out of the loop if
> > iov_iter_extract_pages() returns 0 rather than looping around forever.
> 
> Is "goto fail" the right way to break out here?
> My intuition would be "break".
> 
> On a quick read it seems like res = 0 may occur if we run out of
> iterator, is passing maxsize > iter->count illegal?

I would say that you're not allowed to ask for more than is in the iterator.
In a number of places this is called, it's a clear failure if you can't get
that the requested amount out of it - for example, if we're building a cifs
message and have set all the fields in the header and are trying to encrypt
the message.

David

