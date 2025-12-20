Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3787419E7F7
	for <linux-cifs@vger.kernel.org>; Sat, 20 Dec 2025 15:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766243986; cv=none; b=Bz8s5kYp4fk/IiQcbo6K7Jnwmp3gsNQb9q8Hjb7BUPd3a/xd1BXcH9eLl9ae1trBZkTymAXW0PlT9pxaJzQTOyzYGyaFsyH1RGLAP/N4je9Iv5ZLAxDK1DmHLRjzYYHnhnOTvcZObNIv2z8oQy9/9KK14acSo7b4UKJQ8B8GCc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766243986; c=relaxed/simple;
	bh=evPoOtm7dNIOxv3x4tV9sHpYl/1kr7iNZiFAvnI3QCw=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=jWjp0XObHQ/A3Iiv0jN5x4clwcTLp8RNVG2mj/e9L5fKEVl5f+Ph0Hok5o+m/JvOeSYEjc2EYV0Q0VGhNX1prO6csw5RcIEE1cdXwHRNbspOy14TPmsFAE7u0nBScY84TxTv9nYR5OpMvoSoyFIUEdizmYYicXW9EkJQZEtA/NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CxvjNKZU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CxvjNKZU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766243984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rs46RO3J+Dh0yB4UPReHtxz0OpBol1rkZ2vMuLjTUDg=;
	b=CxvjNKZUgflO/SA5VisiSVuRJ7HX4R+g/bsKKQBp1bJE9rlpzpqVEaaPXoZDAQY/3fQg8s
	jD04+5nV6j+7NV4384AjKxuNCSps42cI2SXjU+9gSiJbjO4orxnHH2wZFvmuNro48tuedo
	yE2q5j+FLYu6KJ9ZZwkHHpkJjDXCWYc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-612-a6Mux4A-Or-urxSzLe883Q-1; Sat,
 20 Dec 2025 10:19:40 -0500
X-MC-Unique: a6Mux4A-Or-urxSzLe883Q-1
X-Mimecast-MFC-AGG-ID: a6Mux4A-Or-urxSzLe883Q_1766243978
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 05DA019560B2;
	Sat, 20 Dec 2025 15:19:38 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.5])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3359619560B4;
	Sat, 20 Dec 2025 15:19:34 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20251220132551.351932-3-chenxiaosong.chenxiaosong@linux.dev>
References: <20251220132551.351932-3-chenxiaosong.chenxiaosong@linux.dev> <20251220132551.351932-1-chenxiaosong.chenxiaosong@linux.dev>
To: chenxiaosong.chenxiaosong@linux.dev
Cc: dhowells@redhat.com, sfrench@samba.org, smfrench@gmail.com,
    linkinjeon@kernel.org, linkinjeon@samba.org, pc@manguebit.org,
    ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
    bharathsm@microsoft.com, senozhatsky@chromium.org,
    linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH v4 2/2] smb/server: fix minimum SMB2 PDU size
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <941516.1766243973.1@warthog.procyon.org.uk>
Date: Sat, 20 Dec 2025 15:19:33 +0000
Message-ID: <941517.1766243973@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

chenxiaosong.chenxiaosong@linux.dev wrote:

> The minimum SMB2 PDU size should be updated to the size of
> `struct smb2_pdu` (that is, the size of `struct smb2_hdr` + 2).

smb_hdr + 4.

but, apart from that:

	Reviewed-by: David Howells <dhowells@redhat.com>

to both.

Do you actually need two patches for this?  Though granted, only the first one
is an actual fix.

David

