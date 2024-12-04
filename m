Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE7E17335C
	for <linux-cifs@vger.kernel.org>; Wed,  4 Dec 2024 20:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733345207; cv=none; b=M9Mmt2Bqwe7yvH41nJ+TxFocbF0kc6amfW6/eCtsSzB+pUtx8ivieQJDwckZmsBsKNrsDX1ZOgNqK0Y5o88QlZ6serh8mm4/yqlciA0f7QKxaZpxlbN26LmSdHlHTvgKAcF4oor09egV7GO6s7/Wp07Bv11+Ck/Ljchs3pCAEfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733345207; c=relaxed/simple;
	bh=WuFJHAWYzdEKnh8Rrn0G4etrhXGZlOXOGLNaz6t4VWw=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=twhjqGRbWEKA5hKZ81gDb0AZ1065gGdtVm/JlxOgCiW1Ff5lIOCvDdIfc4cJBws8i3u48pcBoCI0eOz6qtrHqpi97hg7lirkOGVqj/5Exc1ydnHS0uPdiJHlJuV1OvH5tDLG5S1AhUj7+AY7VqINHU5y4/HmYLrMK6n0zgOWIdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MQFOmPFp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MQFOmPFp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733345204;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WuFJHAWYzdEKnh8Rrn0G4etrhXGZlOXOGLNaz6t4VWw=;
	b=MQFOmPFpATB/E2q79SE/PugmKA2kI7BAgGdaaWpzPCP3n/2HXGVGe6NF0h5EcQ+wAeZoGz
	zgFi/t/AjX9RmZEyG5QGjUdFuZZtEdiL55mOQnMVVo0tNqT7/gMSX+iYYr91hMd+rtKPXl
	fIz0v8QUqelsA6bNLZpYsaSu77iMOw0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-505-rHjzXAWrN8ukeiyxZzaA-g-1; Wed,
 04 Dec 2024 15:46:41 -0500
X-MC-Unique: rHjzXAWrN8ukeiyxZzaA-g-1
X-Mimecast-MFC-AGG-ID: rHjzXAWrN8ukeiyxZzaA-g
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AB48B1955F38;
	Wed,  4 Dec 2024 20:46:40 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.48])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 997571956054;
	Wed,  4 Dec 2024 20:46:39 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CANT5p=qc97-Ncs4E6_KfcYVxBYU5cw5LnPJoccb3gePa8OuCKg@mail.gmail.com>
References: <CANT5p=qc97-Ncs4E6_KfcYVxBYU5cw5LnPJoccb3gePa8OuCKg@mail.gmail.com> <CANT5p=pUGYwswgXM-pniMjEWwbLK0cKXPBOJB9cG_cOrkBwQhg@mail.gmail.com> <CANT5p=qBwjBm-D8soFVVtswGEfmMtQXVW83=TNfUtvyHeFQZBA@mail.gmail.com> <505338.1733181074@warthog.procyon.org.uk> <526707.1733224486@warthog.procyon.org.uk> <CANT5p=pO28C+XEC44taAT-Z6W_spB-QzJb+MOXv68bDRGqJn=w@mail.gmail.com>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
    CIFS <linux-cifs@vger.kernel.org>
Subject: Re: null-ptr deref found in netfs code
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1425546.1733345198.1@warthog.procyon.org.uk>
Date: Wed, 04 Dec 2024 20:46:38 +0000
Message-ID: <1425547.1733345198@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Can you try running it under KASAN?

David

