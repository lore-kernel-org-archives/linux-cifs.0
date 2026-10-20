Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792482366;
	b=ro4n+2msQ/veKXOxfibt3fzOfqTitn2T9Cu/t2cSJyddKeloEeZZkNGI51Jv1EAlAv1v
	 48Oxd1vSPmAipbSt/pscY+rNRNFk3JnaETZLmNh25dVC++o1SKE9DjX4sDlnwTpVGYUzI
	 mD7YQ5xgMwjkvy3DGuCHFrbBxSFyVrayTpj0pcHJ/8WFUUdy6mBD5zRcVa7zXuzU10f+o
	 Keu9PfDVDDHkhQPQPWdoNClayjLi5Se86zSTt/UjjmJR0BhYSfBdgQ1Bea9lrJ/0xZH/H
	 rDS58vM84KvO7cU79HYhGemzzCUFZc8ycVLf+hmSdL//GlnbwDohcZHY0U133gP9XeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792482366;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Organization:From:In-Reply-To:
	 References:To:Cc:Subject:MIME-Version:Content-Type:Content-ID:Date:
	 Message-ID:X-Scanned-By;
	bh=etJHoXzss+lLgalBskXJJBLUzw7KY5e4yuY8e35KdUo=;
	b=JWRbyR6oytqt814AzIHMee3MLo122B8DGB2T9g+Xvxtl6RRM6O1DkqQeoMNP8yVTTufF
	 WKglMYNeOpAjsYY895JthL2N32927QFeJZsiVtzYRtSt8FJ46kFiP1jkd0gZqhxBRWyKf
	 EvrLXDwjeWIkJ8zWWufVZj7i1lQ8p26cKoGWJydac0lZqwbhfgC+kBEwpEvf+pDIOx6Ct
	 j4ba2R9RvVXozDC5CeNp3ZwuzEYxwaIxo5p4CpZAyeRoD4lFda7wPocdL6R3jaMHE7RdU
	 Jye2FhuwNn2QOpimUukwPaZUNaSzTO7oLihTdtMG5c07WheHl9yTy62HRB918q7C8Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA17606A322
	for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 07:46:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7BA17606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792482360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=etJHoXzss+lLgalBskXJJBLUzw7KY5e4yuY8e35KdUo=;
	b=J6bi+HON5JEnEMRX4uOvqdwDXS7ecIx6hyDTRJVovu6FbalX7eAdrSjo4SaufbB99bwMc4
	ZVeQ+FmeBBA3/nGVcanI+wP/2abli5Rs7jPe7x/3Lpjp3gzpF2RvhclPpdKNc3uhx07bQo
	UDuetjF7Rf9bjzFYT7oumkehhE0VOMc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-672-y-UzeCQONTON4CooZ3kcPw-1; Tue,
 20 Oct 2026 07:45:55 +0000
X-MC-Unique: y-UzeCQONTON4CooZ3kcPw-1
X-Mimecast-MFC-AGG-ID: y-UzeCQONTON4CooZ3kcPw_1792482352
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B27DD1955DC3;
	Tue, 20 Oct 2026 07:45:50 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.48.11])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CED701800446;
	Tue, 20 Oct 2026 07:45:43 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1995693.1791971125@warthog.procyon.org.uk>
References: <1995693.1791971125@warthog.procyon.org.uk> <20261013.cachefiles-partial-zeros-trace.pchmelar@innovatrics.com> <20260910220242.2165023-1-dhowells@redhat.com> <20260910220242.2165023-5-dhowells@redhat.com> <20261011.cachefiles-partial-zeros.pchmelar@innovatrics.com> <1655268.1791878098@warthog.procyon.org.uk>
To: Petr Chmelar <petr.chmelar@innovatrics.com>
Cc: dhowells@redhat.com, Christian Brauner <christian@brauner.io>,
    Paulo Alcantara <pc@manguebit.org>,
    Matthew Wilcox <willy@infradead.org>,
    Namjae Jeon <linkinjeon@kernel.org>,
    Marc Dionne <marc.dionne@auristor.com>,
    Stefan Metzmacher <metze@samba.org>,
    Eric Van Hensbergen <ericvh@kernel.org>,
    Dominique Martinet <asmadeus@codewreck.org>,
    Ilya Dryomov <idryomov@gmail.com>, netfs@lists.linux.dev,
    linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
    linux-nfs@vger.kernel.org, ceph-devel@vger.kernel.org,
    v9fs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 4/5] cachefiles: Don't rely on backing fs storage map for most use cases
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2648475.1792482342.1@warthog.procyon.org.uk>
Date: Tue, 20 Oct 2026 08:45:42 +0100
Message-ID: <2648476.1792482342@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Hi Petr,

Note that these patches are now upstream with this change incorporated.

David

