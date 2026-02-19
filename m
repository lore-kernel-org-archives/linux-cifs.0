Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E0A2E62D9
	for <linux-cifs@vger.kernel.org>; Thu, 19 Feb 2026 11:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771499126; cv=none; b=JSMxHE/An0W8pRknTPSRbzCQdsCZH5pfFcC285ENarIAwSHbv7zAAGIRRDn7NxPh9K2nS0ml8ZN1jSeIb44zKHtuMVOEMzt+GXCUFfACGu0xUpr7SEz9hoAEzSgVvnkqCtvSCh3Ml+iCIAJdYjjkXsVvT27ctrzSU9eXQypkuHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771499126; c=relaxed/simple;
	bh=RzmhYy1YRr6bYXScEiWZshagml89M/jfklX0W3SwmQ0=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=s8shji4537F/i4sUjDrLTfh9QL0GIDUTK1PXM2KXqTKhx5BF1P5L25TcCSklDJ4Bo5d9Hsr0tYaSNZ/Blkt+VCFMO5s9g6l2g0Votw2CjiRwJ0gTIU4GdZyycBj4qFDkSig4yraNQxdC0KZPtTgBvHD1ghdBb3c5NVHASvRzqc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gpbtpYq2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gpbtpYq2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771499124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RzmhYy1YRr6bYXScEiWZshagml89M/jfklX0W3SwmQ0=;
	b=gpbtpYq2GM8/JEQRIi4L5MwTwP1mVPMCU4gqdzuHGht/C4NUEImwN/dfsPtjVLJKMRrr4R
	26zO9THlGc2MTiUQX2UWXXQvprUB50W0jEUUnbYPB8pM8a8mHv+03m/9qRcVIUtuh+VKxp
	u+CTgsBbB61/6+NbnmjXZO14WQHEf48=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-186-nWpZEArGNse9g-kdbLVlmQ-1; Thu,
 19 Feb 2026 06:05:20 -0500
X-MC-Unique: nWpZEArGNse9g-kdbLVlmQ-1
X-Mimecast-MFC-AGG-ID: nWpZEArGNse9g-kdbLVlmQ_1771499119
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3635E18002E2;
	Thu, 19 Feb 2026 11:05:19 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.45.225.173])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6371A1800361;
	Thu, 19 Feb 2026 11:05:16 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAGypqWyDOfspVUMe3fm5bfQtC_wH2eEzRgppYvWUVDe1RHLy9Q@mail.gmail.com>
References: <CAGypqWyDOfspVUMe3fm5bfQtC_wH2eEzRgppYvWUVDe1RHLy9Q@mail.gmail.com>
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: dhowells@redhat.com, Shyam Prasad N <sprasad@microsoft.com>,
    Shyam Prasad <Shyam.Prasad@microsoft.com>,
    Steve French <smfrench@gmail.com>, CIFS <linux-cifs@vger.kernel.org>,
    Paulo Alcantara <pc@manguebit.com>,
    Enzo Matsumiya <ematsumiya@suse.de>,
    Henrique Carvalho <henrique.carvalho@suse.com>,
    Bharath S M <bharathsm@microsoft.com>
Subject: Re: [BUG] [~6.6 Kernel] Corruption when retrying encrypted sync writes
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1982282.1771499115.1@warthog.procyon.org.uk>
Date: Thu, 19 Feb 2026 11:05:15 +0000
Message-ID: <1982283.1771499115@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Bharath SM <bharathsm.hsk@gmail.com> wrote:

> We are noticing a data corruption issue in kernels based on stable
> 6.6.y. Especially, when a synchronous writes retried after a
> connection reset.
> ...
> When SMB3 encryption is enabled, partial-page buffered writes hit the
> synchronous write path in cifs_write_end()

This is pre-netfslib, right?

David

