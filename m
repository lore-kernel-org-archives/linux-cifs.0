Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02EC1C27
	for <linux-cifs@vger.kernel.org>; Wed, 25 Jun 2025 08:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750838466; cv=none; b=G3QUkHgd1paXKCNEfrObITpm7Hqfh8ViV1HZ6V7BdZSlnUjotnMlokGeVVZrNOqz1rRMmnB9HPDa70o3QlIkwwkpiZsaD6WBV3JcQoBa9tTO4fwyZJwxJsqCTq7wvCy0eC9svIZ/BlL3qNJtNuEe94N+D+osYFFvybJY+XaF034=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750838466; c=relaxed/simple;
	bh=DkFiKf77DtqGJ2DeykHyDMYQ2KDTYkQysaJCdVJbFPI=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=LUhb0NB/xm8BtItDvQOPPmXUhJM7IZF3WcFGj8qe5SS3hN6OnKCVf7BufbynNAijr8GW6J319i3lHJ1oeLkhdUiAitq5oORYOyopak3nsgKiAL4icpU7KV0HMXxDUS0Bw2WaD8hXi81Ojp31ebSVXe1m9eRtwYKt3EI3shb81CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HsDmbiYp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HsDmbiYp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750838463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DkFiKf77DtqGJ2DeykHyDMYQ2KDTYkQysaJCdVJbFPI=;
	b=HsDmbiYpgTEOpPFXYxPFl3HbfIzbPMgAOpqNhSp02rpb1hYflnwtiJkvCjrnCEm5D6yviQ
	DtlK46VYk22nq3Wx2yTIIi/GaIUVsgMIyHvoyKl4lz6NX574q/ReLJKc+WKWbivVPJs7qR
	//EWl6MUBULMlIIJ8QcI+SJ/CRN9SIA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-322-I8l2EzCFPUmE0f-v0HLlqQ-1; Wed,
 25 Jun 2025 04:00:59 -0400
X-MC-Unique: I8l2EzCFPUmE0f-v0HLlqQ-1
X-Mimecast-MFC-AGG-ID: I8l2EzCFPUmE0f-v0HLlqQ_1750838458
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DB48219560B2;
	Wed, 25 Jun 2025 08:00:57 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.81])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 56B8B3000221;
	Wed, 25 Jun 2025 08:00:56 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <8ecf5dc585af7abb37f3fabac6eb0f9f3273da85.1750264849.git.metze@samba.org>
References: <8ecf5dc585af7abb37f3fabac6eb0f9f3273da85.1750264849.git.metze@samba.org> <cover.1750264849.git.metze@samba.org>
To: Stefan Metzmacher <metze@samba.org>
Cc: dhowells@redhat.com, linux-cifs@vger.kernel.org,
    Steve French <sfrench@samba.org>, Tom Talpey <tom@talpey.com>
Subject: Re: [PATCH 2/2] smb: client: let smbd_post_send_iter() respect the peers max_send_size and transmit all data
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1283577.1750838454.1@warthog.procyon.org.uk>
Date: Wed, 25 Jun 2025 09:00:54 +0100
Message-ID: <1283578.1750838454@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Tested-by: David Howells <dhowells@redhat.com>

