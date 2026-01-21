Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A6F2D4B77
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 23:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769037845; cv=none; b=XYuU7V+PnzWpOdRL0mxJsqpyedpEr+9RQNhnH+2Ua0H/joHjgyp3FrR1HP2XP6kqJbicOf+4by0GMPwsBfN0p03euZuJfgJbvILzo2AkcnBrgXBauVHqeLScBPMsZCS77CWFO4k+f3hnx+MKArYehTEcbQP7fhgttYhpNLN/PUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769037845; c=relaxed/simple;
	bh=kB1QfplxOrTCnrrAfAx3sr2+P0ZHJLYbM20PMSAXInQ=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=EcIF/udMtYmcmpOMSSQHW+pgRuFAhLi3eaSqynF4U+/178C4UYpHKTIyarEDEJ07zHKmDlcLoYTkjHDpuE/Q09LZbV3Ff3A6UP1HZ+zrKfUJJb7h2lyv1x0YNyoj/xeY6Qmnqfmk2vjcYiAUdnOm58FMWOf7lXx1helyNnWagZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ahibeyA3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ahibeyA3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769037841;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kB1QfplxOrTCnrrAfAx3sr2+P0ZHJLYbM20PMSAXInQ=;
	b=ahibeyA3FPxQ3RZWC/N63/X9yFkFORGGolMnNkmdk2vXT0KSQsY2Bhn8XCgmn50g530YKq
	1ikC7XURxJIC7GpbZt2BzWyosDhKBUX42IVXieDV+wqDtbQWz2OUvnLvcGq2DJ5qSBfOqE
	/aq1/y+qPXVLjSQk94jav/nKUnUznaM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-533-xbdNfklgPlaEKrdp6A23WA-1; Wed,
 21 Jan 2026 18:23:57 -0500
X-MC-Unique: xbdNfklgPlaEKrdp6A23WA-1
X-Mimecast-MFC-AGG-ID: xbdNfklgPlaEKrdp6A23WA_1769037836
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 935871800451;
	Wed, 21 Jan 2026 23:23:56 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.2])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E57E81800577;
	Wed, 21 Jan 2026 23:23:54 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260120062152.628822-2-sprasad@microsoft.com>
References: <20260120062152.628822-2-sprasad@microsoft.com> <20260120062152.628822-1-sprasad@microsoft.com>
To: nspmangalore@gmail.com
Cc: dhowells@redhat.com, linux-cifs@vger.kernel.org, smfrench@gmail.com,
    pc@manguebit.com, bharathsm@microsoft.com,
    Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 2/4] netfs: avoid double increment of retry_count in subreq
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1652654.1769037833.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Jan 2026 23:23:53 +0000
Message-ID: <1652655.1769037833@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

nspmangalore@gmail.com wrote:

> From: Shyam Prasad N <sprasad@microsoft.com>
> =

> This change fixes the instance of double incrementing of
> retry_count. The increment of this count already happens
> when netfs_reissue_write gets called. Incrementing this
> value before is not necessary.
> =

> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>

Fixes: 4acb665cf4f3 ("netfs: Work around recursion by abandoning retry if =
nothing read")
Acked-by: David Howells <dhowells@redhat.com>

