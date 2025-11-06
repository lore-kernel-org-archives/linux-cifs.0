Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71137283C8E
	for <linux-cifs@vger.kernel.org>; Thu,  6 Nov 2025 16:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762446151; cv=none; b=iXO6+OkUYeqgPr5HyAaNuX4mcL4Pw2NnSkt87Tsyr6fIunBLHkKZW0zlUzX8p0Y0VWBC13Vdoxza4MvUePq3xs5XSNy/kBJiWG/kTdQ4bYY1uma0EsNvFo0+hdVirclGV+NFsPovlLlKC8WYMztDtSGLvXrmlgwxZk0GERNC2Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762446151; c=relaxed/simple;
	bh=oMIXAhXBK50A0foL+VcLMbf5Muim0c5m1Jpp0WshdJo=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=SeJq2xmqF3nRPh2auGxU1NDd0XpxGa76vM62JvDNTWjvDNd5al35qZ7M8YcbzfUzW5i5x6WRmhb9yzLBoGn/ZqqELVR2UhI7gdAd1BZ8IZKmXO0/aFnEaeqPcpo/aOQdjOXhICKqtcfBRfr+TOScaXYp+G4TcmFjxvkZKopxVxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cZ1Ugrq1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cZ1Ugrq1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762446149;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OzDFqYN0+M3+Uq/kOIy0BrfelGuUl1D3Ez7hT9exkMo=;
	b=cZ1Ugrq1lhbebLwsAhiBjcj47GQ21fPeXXbq/nzMzvDbjKvfv6SPVINV9a/gOMDteRQ5qW
	CutP7LNXATEKgenunxK1bjyV8wuf3tBxzdmzbmrQmd0DkEhOb890h8FzthIk7ZLG6Loljk
	IOdsDtAobr3sKFIErDnfSzzkDlfRC/4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-369-5VAxIv08Mg67O91MIogkJQ-1; Thu,
 06 Nov 2025 11:22:28 -0500
X-MC-Unique: 5VAxIv08Mg67O91MIogkJQ-1
X-Mimecast-MFC-AGG-ID: 5VAxIv08Mg67O91MIogkJQ_1762446147
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9A4ED1944AB4;
	Thu,  6 Nov 2025 16:22:26 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.6])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1623018002A6;
	Thu,  6 Nov 2025 16:22:23 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAGypqWw0bnE7_=49HSxgExouk4s5PVFQ6gVH50wrE8_=4b5vAg@mail.gmail.com>
References: <CAGypqWw0bnE7_=49HSxgExouk4s5PVFQ6gVH50wrE8_=4b5vAg@mail.gmail.com> <YT1PR01MB9451424C6870795133FB7C96B3A72@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM> <36fb31bf2c854cdc930a3415f5551dcd@izw-berlin.de> <CAH2r5mtNtyqZBpT8hL2xvZ8QYWAymrPR-5LmpZbeTHr_1ATPWg@mail.gmail.com> <uildcjpqxzc5nckupgdeeifkrqwrau2qxuc2df2uxuyys3i2k2@iz2bmi6yojyu> <YT1PR01MB945191C652AEE173CEADBA3EB3A12@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM> <aaloi77h2f5xolhrnegxsxntqp2jopwisunmjfp45idsoockpy@cy5agf2oqjop> <YT1PR01MB9451A0F623371F50E77CC1C9B3AD2@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: dhowells@redhat.com, Mark A Whiting <whitingm@opentext.com>,
    henrique.carvalho@suse.com, Enzo Matsumiya <ematsumiya@suse.de>,
    Steve French <smfrench@gmail.com>,
    Shyam Prasad <nspmangalore@gmail.com>,
    Paulo Alcantara <pc@manguebit.org>,
    "Heckmann,
                         Ilja" <heckmann@izw-berlin.de>,
    "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Re: [[ EXT ]] [BUG REPORT] cifs/smb data corruption when writing, x86_64, kernel 6.6.71
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <10022.1762446142.1@warthog.procyon.org.uk>
Date: Thu, 06 Nov 2025 16:22:22 +0000
Message-ID: <10023.1762446142@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Bharath SM <bharathsm.hsk@gmail.com> wrote:

> We are noticing the similar behavior with the 6.6 kernel, can you
> please submit a patch to the 6.6 stable kernel.

What range of kernels is this patch aimed at?  Pre-netfslib conversion cifs
only?

David

