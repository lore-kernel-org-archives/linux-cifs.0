Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF332253E4
	for <linux-cifs@vger.kernel.org>; Wed, 26 Nov 2025 08:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764146124; cv=none; b=Bih8oZLo8grKK1KN5ZSwA+YNdQ1fRJZzTp3aRusOfjxJXxvpCXFdlDUxL9P0xahpRaDsEY42K/NlWYgixa9zKPsYW7qz4KGfSoGfNFPN7X/jFN31SMtcIKCTd0qu6YAAZ/oTiycSTSVZ/Ojmsy2qp3jc56Y9G0pCH2ijyK26tH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764146124; c=relaxed/simple;
	bh=fH3692M1ilX9eBWXmUlT3ZP27Nw/yOe8TaeOQNbcsV8=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=trSQIfvQ+otFX3uN1iw6IszeH1YsGbe0dERUjEQeeKWeYvO+fTe5sG6nsdm9uOofZpuVEhHaOJHyLekn0I1M2zOnFmK/lxtPWxfZa37NuKM5bkk8c+TPoptbC0u2ZL1W//t9tSCdDEjJGTCdDF4ulhxai0jRBMNNHLrW3eo/aaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XCI3xjqh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XCI3xjqh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764146121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fH3692M1ilX9eBWXmUlT3ZP27Nw/yOe8TaeOQNbcsV8=;
	b=XCI3xjqhoGgdXao0K9km0ChdHQxeWTbZ6JW1fldldSnhGVLq/A3XTMWY7Awx46uSQMqQAA
	eA0lioXjQtH7KHxCQGZ2B7X+cQy57QyuxAAW13nFQW4lvbaOeCA+gw5DfMxeFkTg2UVQE+
	97OYm+o5i+3sXoAyU5JBT/31j6CeC5U=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-587-wKo8iuMwN7mL9Dv_gbKYVA-1; Wed,
 26 Nov 2025 03:35:17 -0500
X-MC-Unique: wKo8iuMwN7mL9Dv_gbKYVA-1
X-Mimecast-MFC-AGG-ID: wKo8iuMwN7mL9Dv_gbKYVA_1764146116
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 79000180009D;
	Wed, 26 Nov 2025 08:35:15 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.14])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C519319560A2;
	Wed, 26 Nov 2025 08:35:12 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
To: Stefan Metzmacher <metze@samba.org>
Cc: dhowells@redhat.com, linux-cifs@vger.kernel.org,
    samba-technical@lists.samba.org, Steve French <smfrench@gmail.com>,
    Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>,
    Namjae Jeon <linkinjeon@kernel.org>,
    Paulo Alcantara <pc@manguebit.org>
Subject: Re: [PATCH v4 000/145] smb: smbdirect/client/server: moving to common functions and smbdirect.ko
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4098542.1764146111.1@warthog.procyon.org.uk>
Date: Wed, 26 Nov 2025 08:35:11 +0000
Message-ID: <4098543.1764146111@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Stefan Metzmacher <metze@samba.org> wrote:

> It is based on dhowells-linux-fs/cifs-cleanup
> at commit 1bc2089694a33afb711779dfcb4bbbe10ccbe466,

Btw, I applied the acks I've got to my patches on that branch if you want to
rebase on it; if not, I'm sure Steve will cope:-).

David

