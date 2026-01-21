Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1B136656E
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 23:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769036944; cv=none; b=d/Pg4rTkEPgYjGa89QlQ6/+zAEvBhbhoCZ3xucOrjU6aH2vU3Nl9Ubei3zqEXjCg5Zk0aZqDa8C3YeB6hGyz52/kpmA9TzyIB9cDkAHMQ3Qt51J84X0/bTPmz9ob3s0t8AocaGDlXdRoYK/kE8bvqhgKwyvTZqN+/Hm7YT/XT+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769036944; c=relaxed/simple;
	bh=LFvSWxgdVZ9zNx58IMHfqRHkz5Y1Fnf+ZqpCtHfe3TE=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=m9cw5a14tAMCJLVniyMelE4hLIcL0XoKdSeOIgn7ZYnMSaX1KUJZmu8LMCAeSLmlE8WJndiWx3c+pcoGp0qO10P5CUW0FI2HQUXG5rqjP2iXFbDUOFR3Dyg/OqfdVoyUn1+8IQo9yB5p1Q2k6u65YrwakMvy1zP687jMHCwSxTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XnR0sz5M; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XnR0sz5M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769036941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LFvSWxgdVZ9zNx58IMHfqRHkz5Y1Fnf+ZqpCtHfe3TE=;
	b=XnR0sz5MEkG8/OBF8mr492mvQ09zLZrNaLjLu5rUca5UUBrUvjDM+/Hzd9J671oU071YdV
	M88SNj8eLARvZ0tu/FyY9Vy3pzbbt47H9hyREy/RFZSlFOAEtn97ZpnvSebUbncRaR3zEJ
	UawJ+brpqkFmeiie+9lJd2UooV4tYHk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-490-SsjG-NEtMRKNx7rSU8Hulg-1; Wed,
 21 Jan 2026 18:08:58 -0500
X-MC-Unique: SsjG-NEtMRKNx7rSU8Hulg-1
X-Mimecast-MFC-AGG-ID: SsjG-NEtMRKNx7rSU8Hulg_1769036937
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3F6DE1956053;
	Wed, 21 Jan 2026 23:08:57 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.2])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9C08E19560AB;
	Wed, 21 Jan 2026 23:08:55 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260120062152.628822-1-sprasad@microsoft.com>
References: <20260120062152.628822-1-sprasad@microsoft.com>
To: nspmangalore@gmail.com
Cc: dhowells@redhat.com, linux-cifs@vger.kernel.org, smfrench@gmail.com,
    pc@manguebit.com, bharathsm@microsoft.com,
    Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 1/4] netfs: when subreq is marked for retry, do not check if it faced an error
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1652133.1769036934.1@warthog.procyon.org.uk>
Date: Wed, 21 Jan 2026 23:08:54 +0000
Message-ID: <1652134.1769036934@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Btw, can you cc netfs@lists.linux.dev? (see the MAINTAINERS file)

