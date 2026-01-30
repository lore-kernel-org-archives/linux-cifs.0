Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04092EDD5F
	for <linux-cifs@vger.kernel.org>; Fri, 30 Jan 2026 13:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769780223; cv=none; b=BisLp/VBunMcjFLX9MynbLUU772cVe7rLX+YoR5Do6QcFB4sfoWNTOJxVT4CiO/qYfM/QA4sdm0rP6sl176J/hw1PtJ55iVdlIQVYiReeLv8rdO9ZAm3jSTk7boPL615O1vOTulqrinaXRoBIKCHMv7fD0OW6dIJozud7HfMqaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769780223; c=relaxed/simple;
	bh=iPmy9kCaCWlCx4knb2JNLUT4RnqsAW42EhzxH1Gov8k=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=pKV6myX0raeIzu7eJkH/J/f7GiSAqGXBrnzkj9AU5W15yTIPPEDrhBKeHJ9jBkt1D/jb7sJA555/5awHgWiCYqkqX9el//8oSvhCKhvdh46wDhYtUFzosMTJK+nek3+tYJEy68wqkV1LD8pGdDn5Xe+1gu7BFL1rELWyZ7TMfn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c8XsWs87; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c8XsWs87"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769780220;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oKpcV9V0XeSbL5KkoEEp46UmlZVVKLp4Ee8EeUbrCYc=;
	b=c8XsWs8765YKtgsEumfhMlkLYdN9Yf+ad35OHLHkHPUYvh4r4z5lwyHcmQNr1dyw/Y7bJd
	f6G0nTZ/v15sMCkQVTt7QxjfVEDsZt/h7AlFYB62dFBmXuOi7Xnv8LjCC1EmI5S8/ygufo
	vdE3mkSpobKNVsrA2X4jvoS5i687DME=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-16-2dzTHYG0MC-TVEr-0POGDg-1; Fri,
 30 Jan 2026 08:36:57 -0500
X-MC-Unique: 2dzTHYG0MC-TVEr-0POGDg-1
X-Mimecast-MFC-AGG-ID: 2dzTHYG0MC-TVEr-0POGDg_1769780216
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5663A180047F;
	Fri, 30 Jan 2026 13:36:56 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.33.164])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EE6B11800665;
	Fri, 30 Jan 2026 13:36:53 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260129173725.887651-4-sprasad@microsoft.com>
References: <20260129173725.887651-4-sprasad@microsoft.com> <20260129173725.887651-1-sprasad@microsoft.com>
To: nspmangalore@gmail.com
Cc: dhowells@redhat.com, linux-cifs@vger.kernel.org, smfrench@gmail.com,
    pc@manguebit.org, bharathsm@microsoft.com, netfs@lists.linux.dev,
    Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH v3 4/4] cifs: make retry logic in read/write path consistent with other paths
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2263955.1769780212.1@warthog.procyon.org.uk>
Date: Fri, 30 Jan 2026 13:36:52 +0000
Message-ID: <2263956.1769780212@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

nspmangalore@gmail.com wrote:

> +	unsigned int			retries;	/* number of retries so far */

Is this redundant with netfs_io_subrequest::retry_count?  (This can be changed
from u8 to unsigned int if it helps).  I suspect that there might be a fight
over who gets to increment it, though.

> +				if (is_replayable_error(rc)) {
> +					trace_netfs_sreq(&rdata->subreq, netfs_sreq_trace_io_req_submitted);
> +					__set_bit(NETFS_SREQ_NEED_RETRY, &rdata->subreq.flags);

You didn't see MID_RESPONSE_SUBMITTED, so I would pick a different trace value
there.

David

