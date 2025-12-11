Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7432749E4
	for <linux-cifs@vger.kernel.org>; Thu, 11 Dec 2025 15:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765465910; cv=none; b=N7EchZIyy5hDfj20tIE2X6anYSuKcN+bsDHOYcVozaU2CM6Ir8nGWjwizuV2pYs+pETKhqgjQSlw4EY28NqwEqRKk+xb2jVJ5GHmyu/vYTrYXtVAzYAntoIkX6n0aYEM6vcQ/1JQgu6rVQ+4awuXA2OnryNwrVwlIypqaAlZxz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765465910; c=relaxed/simple;
	bh=mf4aiRb2E7qFXeCxInvXa7IIYY0fJOqJ3rJ1qwXutMk=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=nd2F7vXXKwL83x1VzFfhHqxZwuzvyH6FItkd5xcCn2wb6YhC4WyHy3JlHPNYGENrbrLL4KZzluPOp9lYWlmMaR6s+J/Nx2mWftbs3FcPUM1TyERS7o0NgNCNlzSQyKBbD6Lm+0Z8jiGmib8ntNMIctaVaH3bJz8tS/MfV5k79HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KKgbeLRX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KKgbeLRX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765465906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Xm6hoLnk6DUDhd133ea9qLQ060wrEfjaUbWpiddFAfA=;
	b=KKgbeLRXHCcPCL3MpomAv4Aa0tP9pKJFiv1FbAWf8F7YAEG0yuZoF3ia/rak5njvWXa7sM
	vC20NTtyUOYjqs41D1DP8fq577QRWyxb+OO59MZD4JEeb9xgESGyKKPQljeOcYGbyrnoDR
	CY5/rW5STnnEf3CohkXbsz1YdmBqvV8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-563-TKAKSpnpMceLvLflI2PRpA-1; Thu,
 11 Dec 2025 10:11:39 -0500
X-MC-Unique: TKAKSpnpMceLvLflI2PRpA-1
X-Mimecast-MFC-AGG-ID: TKAKSpnpMceLvLflI2PRpA_1765465897
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B64DC18001DD;
	Thu, 11 Dec 2025 15:11:36 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.14])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 843EF180049F;
	Thu, 11 Dec 2025 15:11:32 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <db17608e-8e3f-4740-9189-6d310c77105c@linux.dev>
References: <db17608e-8e3f-4740-9189-6d310c77105c@linux.dev> <650896.1765407799@warthog.procyon.org.uk> <693d276d-6e0e-4457-9ace-ac1291fe2df5@linux.dev> <CAH2r5msTSRvKRwQYjuVP62KB5beoS99e4eYKYHQ9ZPTYejykRA@mail.gmail.com>
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Cc: dhowells@redhat.com, Steve French <sfrench@samba.org>,
    liuzhengyuan@kylinos.cn, huhai@kylinos.cn, liuyun01@kylinos.cn,
    Paulo Alcantara <pc@manguebit.org>,
    CIFS <linux-cifs@vger.kernel.org>,
    ChenXiaoSong <chenxiaosong@kylinos.cn>,
    Steve French <smfrench@gmail.com>
Subject: Re: Can we autogenerate smb2_error_map_table[]?
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <782960.1765465891.1@warthog.procyon.org.uk>
Date: Thu, 11 Dec 2025 15:11:31 +0000
Message-ID: <782961.1765465891@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Hi ChenXiaoSong,

Here's a first go at it.  I went for putting the code and error in a macro in
smb2status.h, but it might be better to put the error in the comment.  The
perl script doesn't care either way.

It does discard synonyms from the stringified versions - is that important to
keep? - but they could be glued together with " and " between by the perl
script.

Actually - I might have my sort wrong as they may need to be sorted by
little-endiannised status code.

Also, I'd very much like to turn all the status constants into cpu-endian and
put them in a big enum as that's better for the compiler.  This would mean
converting them to cpu-endian at point of extraction from protocol or
insertion into protocol, but I suspect it wouldn't make that much of a
difference performance wise.

David

