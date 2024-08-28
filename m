Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4409816C44C
	for <linux-cifs@vger.kernel.org>; Wed, 28 Aug 2024 10:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724840752; cv=none; b=Zm5s7mG02Hmn6qgoFKntLNxTkSliehTSXqRoFUthBj884ENuY5Wt19+Jc6v8rvKcQmUj2XtSb1Ai4/AdbELIouvstx+FOdTxs+BcZ1S2XkSBJSlynaAmQ82MVXcvkV5hhvrDrtXPCMQm4MEcZN5md40X0IG0ymYdZwHrBMgJopU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724840752; c=relaxed/simple;
	bh=5xlbXm8qZ6ErRw1OGSgNd5WSVvQYZOaGdvxwIq/+wos=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=aOOTzuEbSVmdiRHB9q2yMR/juhbz8pQkneZxBGpRwdyZSg3pT1p8MN3yzzeHSOj5gdqG3zuI/CQ6M4y3/wJGhCw7mPIdd1pXXgr23/BM8IojY+LsEj1yN1RM+pt+rE1xGoyWHbh4aPym2BHbX3yAf8J43O1Ku2JW7Zhpt6O9DGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SG9hKLd+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SG9hKLd+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724840750;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LIA5XOnOJBX+w2ruOqm+kbWk2vXV02oxBTBE8OSAOCg=;
	b=SG9hKLd+bgUE1mEXiXFz3Dk+6IvTf7wWzkTm1ut+VMJwc4llY5vugjEDsWDxfIA17sppRU
	ev17tduGZ1dfWNr4v9tl4Lvju/1bJS9cDDcb8Bjgv27MH+ZoaQrgQd18C21jNbQuuLKFgy
	U7TNBjds7ZX4+q29G4iycamMN/l9/48=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-70-4kX-rALdOvOQwzUKJ44Phg-1; Wed,
 28 Aug 2024 06:25:47 -0400
X-MC-Unique: 4kX-rALdOvOQwzUKJ44Phg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 512581955D4E;
	Wed, 28 Aug 2024 10:25:45 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.30])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 39BD519560AA;
	Wed, 28 Aug 2024 10:25:42 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20240823132052.3f591f2f.ddiss@samba.org>
References: <20240823132052.3f591f2f.ddiss@samba.org> <Zk/ID+Ma3rlbCM1e@jeremy-HP-Z840-Workstation> <CAN05THTB+7B0W8fbe_KPkF0C1eKfi_sPWYyuBVDrjQVbufN8Jg@mail.gmail.com> <20240522185305.69e04dab@echidna> <349671.1716335639@warthog.procyon.org.uk> <370800.1716374185@warthog.procyon.org.uk> <20240523145420.5bf49110@echidna> <CAN05THRuP4_7FvOOrTxHcZXC4dWjjqStRLqS7G_iCAwU5MUNwQ@mail.gmail.com> <476489.1716445261@warthog.procyon.org.uk> <477167.1716446208@warthog.procyon.org.uk> <6ea739f6-640a-4f13-a9a9-d41538be9111@talpey.com> <af49124840aa5960107772673f807f88@manguebit.com> <319947.1724365560@warthog.procyon.org.uk>
To: David Disseldorp <ddiss@samba.org>
Cc: dhowells@redhat.com, Jeremy Allison <jra@samba.org>,
    Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>,
    ronnie sahlberg <ronniesahlberg@gmail.com>,
    David Howells via samba-technical <samba-technical@lists.samba.org>,
    Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
Subject: Re: Bug in Samba's implementation of FSCTL_QUERY_ALLOCATED_RANGES?
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <951876.1724840740.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Aug 2024 11:25:40 +0100
Message-ID: <951877.1724840740@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Hi David,

I tried to apply the patch to the Fedora samba rpm, but I get:

mold: error: undefined symbol: torture_assert_size_equal
>>> referenced by <artificial>
>>>               /tmp/ccVA4FUD.ltrans35.ltrans.o:(test_ioctl_sparse_qar_t=
runcated.lto_priv.0)
>>> referenced by <artificial>
>>>               /tmp/ccVA4FUD.ltrans35.ltrans.o:(test_ioctl_sparse_qar_t=
runcated.lto_priv.0)
>>> referenced by <artificial>
>>>               /tmp/ccVA4FUD.ltrans35.ltrans.o:(test_ioctl_sparse_qar_t=
runcated.lto_priv.0)
collect2: error: ld returned 1 exit status


Do I actually need the torture test patch?

David

