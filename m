Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2632B2C0F81
	for <linux-cifs@vger.kernel.org>; Fri, 30 Jan 2026 13:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769779521; cv=none; b=bpGNH4qWMaRUNWqS4u85v0giRifTUR8qPe0rI4x1rtEV5rapzu+3dvoK/vmh6d5VuJCTDSrRRpeM1VnGQzzNxr7rapSs6BcLPHbcn83+ZauS+cIqkFWXwwEFbzKfjObQXBTpnhmcOE5QhHERzFjB8elHLUEorpjNm1kjxJWYxiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769779521; c=relaxed/simple;
	bh=WZGMNfNruIXXFLc2dWj75psQlv4t6gLOFIULtfNiq+I=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=Sf47QkFRbzC2gpq7JHXdUhJ/Iro3Oq5a7R2BWcJkxWWGurOM/VFS9q+NtNBgM9Hg9gTVTC4ZDoPrASeaK7NfNqXkENp5RabFh8XWJrpI50JZBe0GUEdxswNwjvc1XfW1x+ox9P/B9qmQzmX3LkOB9eU7e0jd/Ai+Wb2aKhlcMSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JkPnjASu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JkPnjASu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769779517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WZGMNfNruIXXFLc2dWj75psQlv4t6gLOFIULtfNiq+I=;
	b=JkPnjASupeCr2GmJpBBbpYRxMgRBu0HeWRuUCoNHraBpRcRw8mV7TncAo820sVwjFcI5jk
	ae5Ui4VSFBeOE+V8e5z53vvHsWo9v81iOhsf0MT3fqkQ2WZ4ZJGvULadioM/pHRrgsc3/L
	x8iNZc8OHUIs6Rz6ZoPd220O/BNjrv8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-306-SOpuJ3WKNSu-5dLkxknLtw-1; Fri,
 30 Jan 2026 08:25:13 -0500
X-MC-Unique: SOpuJ3WKNSu-5dLkxknLtw-1
X-Mimecast-MFC-AGG-ID: SOpuJ3WKNSu-5dLkxknLtw_1769779511
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AB1CB180045C;
	Fri, 30 Jan 2026 13:25:11 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.33.164])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 40D49180009E;
	Fri, 30 Jan 2026 13:25:09 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260129173725.887651-3-sprasad@microsoft.com>
References: <20260129173725.887651-3-sprasad@microsoft.com> <20260129173725.887651-1-sprasad@microsoft.com>
To: nspmangalore@gmail.com
Cc: dhowells@redhat.com, linux-cifs@vger.kernel.org, smfrench@gmail.com,
    pc@manguebit.org, bharathsm@microsoft.com, netfs@lists.linux.dev,
    Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH v3 3/4] netfs: avoid double increment of retry_count in subreq
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2263623.1769779507.1@warthog.procyon.org.uk>
Date: Fri, 30 Jan 2026 13:25:07 +0000
Message-ID: <2263624.1769779507@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

nspmangalore@gmail.com wrote:

> Cc: David Howells <dhowells@redhat.com>
> Acked-by: David Howells <dhowells@redhat.com>

Don't need the cc as well ;-)

