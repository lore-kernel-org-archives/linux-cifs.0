Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5698817996
	for <linux-cifs@vger.kernel.org>; Mon, 23 Sep 2024 07:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727075349; cv=none; b=KDcQK9rw2H8StU/eT2FQjVSSqM3FKuZ4OEoiDmnzeVy1ppfIKpRjoRtqri/rMSaBSNrV/l2DW9pGPnln8nvWziYlJExg0/D5L0vcAQgOAkFFGwxfcRgkfm6Zh16OCvQvKKqB0BIq5DI3hLHAnvYJokM3vA/y45APq6LmCnfAwS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727075349; c=relaxed/simple;
	bh=hZH13fAXbYrHAr50QAy+Lg/Y6fOdPgqVNG/4BceNtg8=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=dOomWYJbbq0sYlphsBYtf9g/Q3c5quZPMAGP+6M31DOYZLXR1h75agRjJyKXWf3/Ale0CbR76ehwFw7RiJTqtaDLVqRnMRC4oCLyseuoUDu1YR2YiTuusIY6ArEM5w+Rbi3iW+zX6yZOB2P3k0J2BuooO2gzTzfOr+i7/d9AVbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W/0QgyXc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W/0QgyXc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727075347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2lDimM0Uis4sHfBgBpHSwx2c5/VL/mJyvDIOhdl/yb8=;
	b=W/0QgyXcr6HIHJb7tHzCYXTDnar5iTJzf6l1xabOSDwtEp0if9z60TsmCVs5vRbTLGfK44
	giOOCKmC/vjnCE9LWhgEf/LrdRYjTO3IPTBHRWNpRZyrLNf9BJu7am76vruXX8zK4zcfYL
	gatHwsT4Qqf6agxItVWNRoboFmo2lMA=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-682-BUxCkdedMSymFuojPHzqnQ-1; Mon,
 23 Sep 2024 03:09:03 -0400
X-MC-Unique: BUxCkdedMSymFuojPHzqnQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7142C19054EE;
	Mon, 23 Sep 2024 07:09:01 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.145])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1AA241956052;
	Mon, 23 Sep 2024 07:08:56 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <202409221711.b537f7a8-oliver.sang@intel.com>
References: <202409221711.b537f7a8-oliver.sang@intel.com>
To: kernel test robot <oliver.sang@intel.com>
Cc: dhowells@redhat.com, oe-lkp@lists.linux.dev, lkp@intel.com,
    linux-kernel@vger.kernel.org,
    Linus Torvalds <torvalds@linux-foundation.org>,
    Steve French <stfrench@microsoft.com>,
    Paulo Alcantara <pc@manguebit.com>,
    "Christian
 Brauner" <brauner@kernel.org>,
    Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org,
    samba-technical@lists.samba.org
Subject: Re: [linus:master] [cifs] 43a64bd02f: xfstests.generic.465.fail
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <743743.1727075336.1@warthog.procyon.org.uk>
Date: Mon, 23 Sep 2024 08:08:56 +0100
Message-ID: <743744.1727075336@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

kernel test robot <oliver.sang@intel.com> wrote:

> kernel test robot noticed "xfstests.generic.465.fail" on:

It works fine for me.  Can you grab the contents of /proc/fs/netfs/stats after
it has failed?

David

