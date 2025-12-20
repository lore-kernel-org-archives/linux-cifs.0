Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBE742222C0
	for <linux-cifs@vger.kernel.org>; Sat, 20 Dec 2025 08:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766220454; cv=none; b=eriUb1XCpum/cqrfqUEJtOcNETl+yxp/7F/A/0DwF3h5kht1sQiJe8LG1718eUUjQf8jIMrpBy9+ukL+8wgK4v28QVv3F0x+IdLTKZTTeYUSjzmx8dbqWZgq9qyXXjHGYsUk/kM491lLoRetTidW0uNUbaKzo8p+yfVrY1ycM4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766220454; c=relaxed/simple;
	bh=I+8N5Eal/3x3j67eZgdDqHBzDQy3xED8sdF8tvHYzlE=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=MZFwfp2nmbVd5zj/ycpXeGSEko+BdTzd/MlwlffMSoHWR2ZXhRjPi7uCLiM9/VdbcAh4JutaWnfziousw6lOAvpVeE7D17YYrzm6sveeaK6HPAmJIxcD84tGT53t0y30RXC2nMkFIAq7aNG1b/C2/+HTyu3GeksDPux814X6YmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cohJjPcf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cohJjPcf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766220450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tgd46aGjFd8FzCshNivRiNSAD79JJCDYdbl17QgyP5c=;
	b=cohJjPcfQxEYAdHSDrbCs/Dz/ji7VYycfOlKFE/vU63ZyuSQVoYuUC4lrXbM6YPhwTmKDw
	tNvrzllbfLYhdLt9vopuK78x2TEYxU39Jd06S+WD8FaQhFLo+WGgix4k6MaXuB5baW1d0l
	NnyrRU28czOoDIV0f7ZSKnPKAuReNPM=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-541-YMfLakNwNp6WFfG6M-vgpw-1; Sat,
 20 Dec 2025 03:47:24 -0500
X-MC-Unique: YMfLakNwNp6WFfG6M-vgpw-1
X-Mimecast-MFC-AGG-ID: YMfLakNwNp6WFfG6M-vgpw_1766220442
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 19698195608D;
	Sat, 20 Dec 2025 08:47:21 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.5])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3CEC519560B4;
	Sat, 20 Dec 2025 08:47:17 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAKYAXd_bhyFYSB_tmXGTczjgMPsEyVnSQUKztNfRzJH0bTdHvA@mail.gmail.com>
References: <CAKYAXd_bhyFYSB_tmXGTczjgMPsEyVnSQUKztNfRzJH0bTdHvA@mail.gmail.com> <20251219235419.338880-1-chenxiaosong.chenxiaosong@linux.dev> <20251219235419.338880-4-chenxiaosong.chenxiaosong@linux.dev>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: dhowells@redhat.com, chenxiaosong.chenxiaosong@linux.dev,
    sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org,
    pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
    tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
    linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH RFC v3 3/3] smb: use sizeof() to get __SMB2_HEADER_STRUCTURE_SIZE
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <931180.1766220436.1@warthog.procyon.org.uk>
Date: Sat, 20 Dec 2025 08:47:16 +0000
Message-ID: <931181.1766220436@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Namjae Jeon <linkinjeon@kernel.org> wrote:

> > +#define __SMB2_HEADER_STRUCTURE_SIZE   (sizeof(struct smb2_hdr))
> > +#define SMB2_HEADER_STRUCTURE_SIZE                             \
> > +       cpu_to_le16(__SMB2_HEADER_STRUCTURE_SIZE)
> > +

You don't want to use this SMB2_HEADER_STRUCTURE_SIZE for your comparison as
it's little-endian if that's your intent.

David

