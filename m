Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD4A336889
	for <linux-cifs@vger.kernel.org>; Sat, 11 Apr 2026 09:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775898275; cv=none; b=Ba511R2sXjFX6lnM5cf2YCgyvrvtGLCRyxEQLpHFGJBFZcanNG2l13zGmiQ0f+MU6495UXXEHEftWIy0Lh02vNP3F8z7KtshhQqxtgFSaQAONwQi3eLW6kP+0W9kl8rTEL826EG6FD4W7LQ1/X4o+5yM393FxV2pjNfD/Zv2+iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775898275; c=relaxed/simple;
	bh=OoXsiXJFYoAT9cC085Xd3G5+lSv37YH35GHqonO/aQ0=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=rGTpZtZ/rfM8S2hXojbU2RaChCbbDQpkSz6Ko+50MEhztSmxAXknSo0EcA40aUuE0nZTvxLLUZ9fOM2bN2p6LFrTmaxdqw12DdhGIDJmjmr+10Ew/Bxt5yo4/ZwA02Lf9loV0qkQy+xmxh2+H9CDjKQwjGfMDzCWLID6FZHJyXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YSO0w+po; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YSO0w+po"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775898273;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OoXsiXJFYoAT9cC085Xd3G5+lSv37YH35GHqonO/aQ0=;
	b=YSO0w+poB9jP8ir6UY06S0A7T8HmhKRSN4YZiblmqTZZG/XZtz/M2fZW3Z87Ip0/z4d9Lh
	Ls7lNwBt2Yc06gnueJayE550c/yyugpePKP5ITTKKILhdkQLgVZXph3jZH1MOOCUWRCtcw
	n+eXYxLokw/P4KU0e4pXBM6xki0dvlA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-25-XFkmtC5PMfuMvL4R4ZQAdw-1; Sat,
 11 Apr 2026 05:04:28 -0400
X-MC-Unique: XFkmtC5PMfuMvL4R4ZQAdw-1
X-Mimecast-MFC-AGG-ID: XFkmtC5PMfuMvL4R4ZQAdw_1775898266
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6A59C19560AA;
	Sat, 11 Apr 2026 09:04:26 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.48.47])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3B23E19560B7;
	Sat, 11 Apr 2026 09:04:22 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260411085643.3221565-2-dhowells@redhat.com>
References: <20260411085643.3221565-2-dhowells@redhat.com> <20260411085643.3221565-1-dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: dhowells@redhat.com, Paulo Alcantara <pc@manguebit.com>,
    netfs@lists.linux.dev, linux-afs@lists.infradead.org,
    linux-cifs@vger.kernel.org, ceph-devel@vger.kernel.org,
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
    Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
    "Paulo Alcantara (Red Hat)" <pc@manguebit.org>
Subject: Re: [PATCH 1/4] netfs: fix VM_BUG_ON_FOLIO() issue in netfs_write_begin() call
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3222521.1775898261.1@warthog.procyon.org.uk>
Date: Sat, 11 Apr 2026 10:04:21 +0100
Message-ID: <3222522.1775898261@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")

