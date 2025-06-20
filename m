Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD9F220696
	for <linux-cifs@vger.kernel.org>; Fri, 20 Jun 2025 12:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750422596; cv=none; b=bTt06inaPWAw/McNzv0uqxzWfYwjVWG30f9kakTTU64O8xkCqwyAW3pO4MSmTRSguDJOKkf1yZtIy8o2fgkFde6xJJfc1kihwRa/f3TZZv11oHqgKgriOOhB+XGdwRNWJff7KTnyJeCLH1g7FcqRV6qN0BBIW4/YSwT6H4rkRI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750422596; c=relaxed/simple;
	bh=ZKM2xo8M9z0UxncSxVp3Up9i0TZfb5hbLBEhRSo1sBQ=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=cORy9ghHVRpi3U221WCdE0z+dJy5VW2GFiUkwCc7ak3h4W/2iCQUCumOunyCbQVQFkC3ZRI2MurfVNHJixRpx7BKCji+2JwYoUursmHjfi/pvW9DU3Gk8iwPhcMR4LF2VghD/FxaOmZVQylWQiV+fRUUoLdxqjOMol7eRY1hXn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W0vfwpEN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W0vfwpEN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750422592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=syH/W1OTI1ffnprrqGQp0ft+4wv2Ew6lwZTNXW2pKGM=;
	b=W0vfwpENzxahzFojQA4w47IDf1INbDu77vE4yTtCE4dzKw6avz6yNlE32kTJZ5zXiOMunn
	EMgcWr+fWn9uvw2WG6/iKbaRqEa0jvtUet4NSt6zB3AqvYSvXcoyrqi70xF8fy1vmTUwXb
	WzbXO0LS1nHcjSNiBENzyBlCk5oaxjA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-74-byqskAeQNoyMWQ_TuGOr7A-1; Fri,
 20 Jun 2025 08:29:50 -0400
X-MC-Unique: byqskAeQNoyMWQ_TuGOr7A-1
X-Mimecast-MFC-AGG-ID: byqskAeQNoyMWQ_TuGOr7A_1750422589
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4B3D319560AD;
	Fri, 20 Jun 2025 12:29:49 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.211])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7FD0D19560A3;
	Fri, 20 Jun 2025 12:29:47 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <e07c9bab-5750-4a50-8b38-4ce8c1a214d6@talpey.com>
References: <e07c9bab-5750-4a50-8b38-4ce8c1a214d6@talpey.com> <cover.1750264849.git.metze@samba.org> <8ecf5dc585af7abb37f3fabac6eb0f9f3273da85.1750264849.git.metze@samba.org>
To: Tom Talpey <tom@talpey.com>
Cc: dhowells@redhat.com, Stefan Metzmacher <metze@samba.org>,
    linux-cifs@vger.kernel.org, Steve French <sfrench@samba.org>
Subject: Re: [PATCH 2/2] smb: client: let smbd_post_send_iter() respect the peers max_send_size and transmit all data
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <962035.1750422586.1@warthog.procyon.org.uk>
Date: Fri, 20 Jun 2025 13:29:46 +0100
Message-ID: <962036.1750422586@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Tom Talpey <tom@talpey.com> wrote:

> > +		if (iter && iov_iter_count(iter) > 0) {
> > +			/*
> > +			 * There is more data to send
> > +			 */
> > +			goto wait_credit;
> 
> But, shouldn't the caller have done this overflow check, and looped on
> the fragments and credits? It seems wrong to push the credit check down
> to this level.

Fair point.  There's retry handling in the netfs layer - though that only
applies to reads and writes that go through that.  Can RDMA be used to
transfer data for other large calls?  Dir enumeration or ioctl, for instance.

David

