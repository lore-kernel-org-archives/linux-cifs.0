Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52693531615
	for <linux-cifs@vger.kernel.org>; Wed, 23 Sep 2026 19:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790191220; cv=none; b=KHTwy/bl6l+208lmoNuV1XKKJT3UvSbcA715s8h1afpVH83ObHrVrVXA0YZqj9R/1uugcVh4L0qzCGjNqAhg3R3nomFRHy96rdVYjKEqN0ay6dKlPeXDA0dXzwbLjA5+pkv16YtqjkNgeCBLuGB1V/mqwGOUnYrjvNNnwKsRgZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790191220; c=relaxed/simple;
	bh=UxllgZKkHgfU3vYCxpIVx6Rydy/6I+5aR0X81ISSt/4=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=Z7Zza05yPk1xjT8+BNX5mb3wF5Dfh0YStvcUSAaIcOg3fJcTBNIw2t9Y44yVOwBxowtt5iL5CGQfCd3AJbLEZDZ4vrQz5SG8HK5Yy2Ic6T0bWp69GNuV6BaYXaudP2WjYFl45FiErrf8cNSadoLrlpgA+TokFCm9/41LD1JDuZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BOxalfOK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BOxalfOK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790191218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mwyl63S+xi38os/NnkcbHt6FcrFd5rLnkUiEfosX8mI=;
	b=BOxalfOKOnAWlLVyymnIGRLwfdyq9kpyHjV4EeVv96x089mn7GLtzjzUc/0C9xnG5j8Ewa
	s+tr0GdyGod4m3o/Jji2YrCfRRHcBTtNu8gZW1Usb8vALU1gHh7HDTNHNJkCaUYT3vA1DK
	Dw+wQXP/DpOchWSjtXqkh9vT2UCI54U=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-527-WomQRXq2MxOaulsagakdEQ-1; Wed,
 23 Sep 2026 15:20:12 -0400
X-MC-Unique: WomQRXq2MxOaulsagakdEQ-1
X-Mimecast-MFC-AGG-ID: WomQRXq2MxOaulsagakdEQ_1790191210
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 36FB5195DE5A;
	Wed, 23 Sep 2026 19:20:10 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.54])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id ABCCF18005B8;
	Wed, 23 Sep 2026 19:20:06 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <arHVJ0ihdqmNETMw@casper.infradead.org>
References: <arHVJ0ihdqmNETMw@casper.infradead.org> <20260921230755.1133425-1-pc@manguebit.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: dhowells@redhat.com, Paulo Alcantara <pc@manguebit.org>,
    linux-cifs@vger.kernel.org, netfs@lists.linux.dev,
    Christian Brauner <brauner@kernel.org>,
    Namjae Jeon <linkinjeon@kernel.org>,
    Ronnie Sahlberg <ronniesahlberg@gmail.com>,
    Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
    Bharath SM <bharathsm@microsoft.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/5] netfs: clear post-EOF pagecache when extending a file via write
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1519833.1790191205.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 20:20:05 +0100
Message-ID: <1519834.1790191205@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Matthew Wilcox <willy@infradead.org> wrote:

> > +	int netfs_clear_stale_post_eof(struct inode *inode, unsigned long lo=
ng from,
> > +				       unsigned long long to, bool nowait);
> =

> Should this be uoff_t?  Or even loff_t?

uoff_t please.  There's no reason to have a signed value there.  Also, I h=
ave
a patch queued with Christian for next to convert netfs generally to use
uoff_t where it can.  It's a lot shorter than unsigned long long.

David

