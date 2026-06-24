Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F79A3A1B5
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 10:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782298753; cv=none; b=BN4Ad0bxDbKJF2+sKyPKokPFYy4OpqI4Pr6bKwZgnAbkZ7RcWryDqM+UxYMBt6wRydd+QARsoQsVZMKEgBq9y9O9lQK9MHz4E4x1qwKclWBAnWc4lF05FmixvBcd/NV+3+5LX9P95cMD4MVfKBUvXzbxtYWFX7lKeF4g08rxMcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782298753; c=relaxed/simple;
	bh=F84yGQUDkbH98vHWjzmZYErLQPjTxVtksTNdkueSsUg=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=bBp5duxoMd8N52wQdovrbm/kS3BRXMj0RwUDx+1jU4WColAgq1Gt1s9y3SSDtheFZWDLA0crdeRw8+9SKtp4vS5cVqJMdNHw5E4rGSBpnyXoUNkauTFAMZQvf64trrGBNO+NEBY7lyhmt9S6IM3m9kK9Tbojb1fMB8Y6l2ko1Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=S0h8Imxo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="S0h8Imxo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782298751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LG6pXrc0sR0IcEnF7n9P/5Vk8UAhFYpfZl8nu7N/p6s=;
	b=S0h8ImxoUTyWfnc9ClH6XqsO6iGzrztevVO/nwpoPx8M6m0ESKJcjHIgXzSMK5mU3fpxdQ
	rLO5IUJcr/W3oUFVfw7R41iyP8q5nz4/ZpeQs1y6zu0NJUAWkPtid1DS7hq89Fb+8erO0x
	POQE8FXu4rOhc9x9uBUE8NOQ7CW/hxg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-608-H4IlkNbCM0CR5UarK_yzqg-1; Wed,
 24 Jun 2026 06:59:10 -0400
X-MC-Unique: H4IlkNbCM0CR5UarK_yzqg-1
X-Mimecast-MFC-AGG-ID: H4IlkNbCM0CR5UarK_yzqg_1782298748
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 710961805C0A;
	Wed, 24 Jun 2026 10:59:07 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.49.152])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1402B19560A0;
	Wed, 24 Jun 2026 10:59:03 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <498534d3-e82e-40ce-bc7d-230580b2fcae@chenxiaosong.com>
References: <498534d3-e82e-40ce-bc7d-230580b2fcae@chenxiaosong.com> <33cc8eb4-8831-49b0-80d6-b06544a37920@chenxiaosong.com> <FA1EF9EEE4C1415E+20260530011403.1686344-1-hongao@uniontech.com> <2912807.1782231053@warthog.procyon.org.uk>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: dhowells@redhat.com, hongao <hongao@uniontech.com>,
    Paulo Alcantara <pc@manguebit.org>, netfs@lists.linux.dev,
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
    syzbot+3c74b1f0c372e98efc32@syzkaller.appspotmail.com,
    Steve French <smfrench@gmail.com>,
    Namjae Jeon <linkinjeon@kernel.org>,
    "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] netfs: Fix UAF in netfs_unbuffered_write() on failed preparation
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2961242.1782298742.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 11:59:02 +0100
Message-ID: <2961243.1782298742@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Actually, this shows what happened:

 a.out-717 : netfs_sreq: R=3D00000001[13] UPLD RETRY f=3D210 s=3D240000 1f=
ac0/20000 s=3D160 e=3D-11
 a.out-717 : netfs_sreq: R=3D00000001[13] UPLD SUBMT f=3D100 s=3D240000 0/=
dbfac0 s=3D192 e=3D0
 a.out-717 : netfs_failure: R=3D00000001[13] UPLD f=3D500 s=3D240000 0/dbf=
ac0 write e=3D-5
 a.out-717 : netfs_rreq: R=3D00000001 UW PAUSE   f=3D1801
 a.out-717 : netfs_sreq: R=3D00000001[13] UPLD TERM  f=3D500 s=3D240000 0/=
dbfac0 s=3D192 e=3D-5
 a.out-717 : netfs_rreq: R=3D00000001 UW WAKE-Q  f=3D1805
 a.out-717 : netfs_failure: R=3D00000001[13] UPLD f=3D400 s=3D240000 0/dbf=
ac0 write e=3D-5
 a.out-717 : netfs_rreq: R=3D00000001 UW PAUSE   f=3D1805
 a.out-717 : netfs_sreq: R=3D00000001[13] UPLD TERM  f=3D400 s=3D240000 0/=
dbfac0 s=3D192 e=3D-5
 a.out-717 : netfs_rreq: R=3D00000001 UW WAKE-Q  f=3D1805
 a.out-717 : netfs_sreq: R=3D00000001[13] UPLD FREE  f=3D400 s=3D240000 0/=
dbfac0 s=3D192 e=3D-5

There are two calls to netfs_write_subrequest_terminated().  You can see t=
he
IN_PROGRESS bit has been cleared by the second one (f=3D500 -> f=3D400).

David

