Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400F330F7FB
	for <linux-cifs@vger.kernel.org>; Thu, 11 Dec 2025 15:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765467827; cv=none; b=XG5FOhjaHNt9wYpxsH0+QvTkDMFhAUxWVD/a/XAjvTOHW64tsK9eNNcNnz3QXfv2Nl8LG5hKdb2FmQuqIMVuItMtQ1NugW3isaoEPo4jd+ziGCVyoqtw+ARU7bAcdSS7UM+O/uIMQB3v+3++MvUCGKR1xGUA8UVIvYExIxYTIqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765467827; c=relaxed/simple;
	bh=ilnAXuWOLAFvv+OdUW1wEi8XOZ4s+XNFiN3LipVmKXE=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=X6cfAZUacVODfIncy9WsjQ/kchOOKb/R7++uYhAZ4NUekRH9Wnlyz6gygpCa4dEnHnnfleuPWIaiQ7cDRZG1qW2WPeN+tMWIcESeBr9Ru1aJY5xoTdaydEL0NWy/0gCrbK1PnZoC+3OcrPbMFVSOdIy8osELLU+yNvBVted3fi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ayVEc/sk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ayVEc/sk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765467824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ilnAXuWOLAFvv+OdUW1wEi8XOZ4s+XNFiN3LipVmKXE=;
	b=ayVEc/skJecqPVNs2C/mG7kr55TAomqI9z2hbpofW61kX8Di74sYf/TvJn14xrrZsBzJRS
	HEKdkMEZQhurmlPF/3eWHX2QE7OUmHzjPiW531y/Zo8ifZynViI9xLuGgnF7HrD+sWRMbx
	/nSUmR1tvNvbYBabNjYQm+iGfxaTYw0=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-440-7SuUl1uhN2mlmc8mJjXJwg-1; Thu,
 11 Dec 2025 10:43:40 -0500
X-MC-Unique: 7SuUl1uhN2mlmc8mJjXJwg-1
X-Mimecast-MFC-AGG-ID: 7SuUl1uhN2mlmc8mJjXJwg_1765467819
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8497D18002C9;
	Thu, 11 Dec 2025 15:43:38 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.14])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BE8D8180035F;
	Thu, 11 Dec 2025 15:43:35 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <e0c39a29-03ea-42dd-bc17-0483d74a0951@linux.dev>
References: <e0c39a29-03ea-42dd-bc17-0483d74a0951@linux.dev> <db17608e-8e3f-4740-9189-6d310c77105c@linux.dev> <650896.1765407799@warthog.procyon.org.uk> <693d276d-6e0e-4457-9ace-ac1291fe2df5@linux.dev> <CAH2r5msTSRvKRwQYjuVP62KB5beoS99e4eYKYHQ9ZPTYejykRA@mail.gmail.com> <782578.1765465450@warthog.procyon.org.uk>
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Cc: dhowells@redhat.com, Steve French <sfrench@samba.org>,
    liuzhengyuan@kylinos.cn, huhai@kylinos.cn, liuyun01@kylinos.cn,
    Paulo Alcantara <pc@manguebit.org>,
    CIFS <linux-cifs@vger.kernel.org>, Steve French <smfrench@gmail.com>
Subject: Re: [PATCH 2/2] cifs: Autogenerate SMB2 error mapping table
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <783996.1765467814.1@warthog.procyon.org.uk>
Date: Thu, 11 Dec 2025 15:43:34 +0000
Message-ID: <783997.1765467814@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev> wrote:

> These two patches look good. Thanks for your patches.

Note that that there's a bit at the second patch which should've been merged
into the first, modifying fs/smb/common/smb2status.h.

David

