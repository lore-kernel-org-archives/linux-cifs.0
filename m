Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3012D315777
	for <linux-cifs@vger.kernel.org>; Fri, 12 Dec 2025 09:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765532952; cv=none; b=TZ8q/NLkCwS6Y35wVdWIySJYwByGXZRZtQr6ZYBmSq3UcalkzZXi5xzI8PqaSR5jKtvp4kdSxuxWIpU3sY1lYHgZp2NdAp7ZNwFYP575Myj++Qag0pegFRyPMJ6vanOU/TdkJS0zec5mg7fr+j16FsiZZQLLg8pnqdR04f7YWE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765532952; c=relaxed/simple;
	bh=wpBFBDuDWb9NiXONHazc3uaqXm34+URFYA/aMybgsXI=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=boWk1w1QeumvlB/L/3Lya5F1q/XSN+MOJGlI4wKh6IjFX/bjoqjT0VICk8KuCDHbctp+tGpvrMa9w0xOM7E2f9KS+Rt12OEae+11YDOEHgQ0rx04zf29iGGLO13g8fYZRRDrdseb+yDcq41n4i+ZAAk+vvtT4TbVzvknpiVMJNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TohaTBPI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TohaTBPI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765532949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KyAXgVeEtfxWWcNlohEAxyTXawepOYfe6YL/T7Tr5qs=;
	b=TohaTBPIDlJwmBE9EnFrd24Zh3mbzgNKCidqcu66CJ3Q5UEhra2G1i+amOL6oCEHuHCgKO
	3kP/4gcv4FDvgFgx08ZeNevvCGwTGq5j2JuhrGPaNQh3icHsQifa/s7m47//yj0f3+9EYp
	5N/l539QnqNS/TyINAFb5Pm3+1qKjXg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-517-UHcr-PQWNkW5i9s2YUKnxA-1; Fri,
 12 Dec 2025 04:49:05 -0500
X-MC-Unique: UHcr-PQWNkW5i9s2YUKnxA-1
X-Mimecast-MFC-AGG-ID: UHcr-PQWNkW5i9s2YUKnxA_1765532944
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AD8821956089;
	Fri, 12 Dec 2025 09:49:03 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.14])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A25601956056;
	Fri, 12 Dec 2025 09:49:00 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <8f3290fe-d74c-4cd6-86f4-017c52e1872e@linux.dev>
References: <8f3290fe-d74c-4cd6-86f4-017c52e1872e@linux.dev> <db17608e-8e3f-4740-9189-6d310c77105c@linux.dev> <650896.1765407799@warthog.procyon.org.uk> <693d276d-6e0e-4457-9ace-ac1291fe2df5@linux.dev> <CAH2r5msTSRvKRwQYjuVP62KB5beoS99e4eYKYHQ9ZPTYejykRA@mail.gmail.com> <782578.1765465450@warthog.procyon.org.uk>
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Cc: dhowells@redhat.com, Steve French <sfrench@samba.org>,
    liuzhengyuan@kylinos.cn, huhai@kylinos.cn, liuyun01@kylinos.cn,
    Paulo Alcantara <pc@manguebit.org>,
    CIFS <linux-cifs@vger.kernel.org>, Steve French <smfrench@gmail.com>,
    ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH 2/2] cifs: Autogenerate SMB2 error mapping table
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <812015.1765532939.1@warthog.procyon.org.uk>
Date: Fri, 12 Dec 2025 09:48:59 +0000
Message-ID: <812016.1765532939@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev> wrote:

> Please see my minor suggestions and KUnit test results at this link:
> https://chenxiaosong.com/en/smb-map-error.html

Can we just eliminate nterr.h?  It seems to be duplicate with smb2status.h.

David

