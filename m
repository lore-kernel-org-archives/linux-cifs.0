Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98352309DDD
	for <linux-cifs@vger.kernel.org>; Wed,  3 Dec 2025 21:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764798837; cv=none; b=Zmn4aiErSvHDUBxKtfOf+x93/K0IwLwBhl1+s6uYk3tEIVkrBjG+lq0PNCvnu7PJzBoBzudi7unQaMSc/BfXm0FOLEvKVXYQOWgbiYC3shfTfEH8MIp3BrEk+2FIMZFG9LZObZnsYYBy6MQ4prFRlt4UywFj/AYK8WGP1EJrM0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764798837; c=relaxed/simple;
	bh=FFHKi9Im5BxmBxxjGUPxBN+w0nKUjbtj+132MOA4zJk=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=fGFZ0iV3NFBNMMcRH6QMF7fGfdjVuCIxR1jXJAX/9SVqWsyIZGPenRZIkkmW9bIFgA8pIaixtJiguhdl8j5MezLCeIqjbm0G5OWjAsDgHY/2ovLglu1PGBuzj1UwGeuUrmjXzrg7OJjDJYAZsWhTo+WmfmhEDyrTfF81DVRIJtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h2rn/bYn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h2rn/bYn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764798832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FFHKi9Im5BxmBxxjGUPxBN+w0nKUjbtj+132MOA4zJk=;
	b=h2rn/bYnKqmy785KiOOjnu2fzj/AAw7zUVCqq7ULRcmnGiAlI3fImYnD+6hJn7Bq36CYQw
	xR7UBWaNiWToPtUagsxmxEf3tJnN0BXo9aGt7JxFrD3iRB10tl0o1Kr1/0S7iGFL5b2fGc
	yhMz99nIcGezaNESdGG7oHj/RDcXZ4w=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-59-HdvppySeP9yspwQ-uUk38w-1; Wed,
 03 Dec 2025 16:53:47 -0500
X-MC-Unique: HdvppySeP9yspwQ-uUk38w-1
X-Mimecast-MFC-AGG-ID: HdvppySeP9yspwQ-uUk38w_1764798825
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9A10B1800378;
	Wed,  3 Dec 2025 21:53:45 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.14])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 43A4019560A7;
	Wed,  3 Dec 2025 21:53:43 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <0cf36b63a8f7c807a785f3cbee41beb2@manguebit.org>
References: <0cf36b63a8f7c807a785f3cbee41beb2@manguebit.org> <1597479.1764697506@warthog.procyon.org.uk>
To: Paulo Alcantara <pc@manguebit.org>
Cc: dhowells@redhat.com, Steve French <sfrench@samba.org>,
    Shyam Prasad N <sprasad@microsoft.com>, linux-cifs@vger.kernel.org,
    netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org,
    stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cifs: Fix handling of a beyond-EOF DIO/unbuffered read over SMB1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1961751.1764798821.1@warthog.procyon.org.uk>
Date: Wed, 03 Dec 2025 21:53:41 +0000
Message-ID: <1961752.1764798821@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Paulo Alcantara <pc@manguebit.org> wrote:

> Dave, looks like we're missing a similar fix for smb2_readv_callback()
> as well.

I couldn't reproduce the problem with smb2/3, but it's probably worth fixing
by analogy.

David

