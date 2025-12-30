Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E7B2F290B
	for <linux-cifs@vger.kernel.org>; Tue, 30 Dec 2025 21:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767129303; cv=none; b=u0q4B8lgCJJdJfQc3FTANVuyGOzjOMlvCGHtk5jkR6hWDMCBS4HNLXCKkCFPIUWLMJjhlD6sPbdVmptLcmhx4HQ7JgLF8sMzsIGA3uEMcbAryGxaYiIJjMstBdNMSBlbAm+ZgnWhwDJHlRtpOKjn0QyrpVxDzPNFTCw88xkCXgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767129303; c=relaxed/simple;
	bh=jQtXx7rfttznbaFkCyLXJ0WcnYaJY7Du1Rtzd5AylmA=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=EmN8VAyWCDWzOSh10xz+eH7q9v7na6EvojfV+Hix+zn8nU6TFx1E5HBpIj1a89rFlfiwBQrEL2XJe7puzhEieWIfGItQKqG9rY98J6PHbUbOmVzEI3xmln0O+vx/l01HrEuE0+DZdmjzTooSu08ABx10cxAH58SPRrQny7kDGVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XnwZn018; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XnwZn018"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767129300;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SPnN+QRccYwBCGvlV8wop5ggg6r6if2lTY8/+SxRg8U=;
	b=XnwZn018YUOY5NGg33ZPfb9OjuRvKzylkG0n//W+QMSuemkTwNdABm9Fy0udbkh+qsdt0b
	mu0Rlbx+COUVjejDQcP1SjpbadgZfS9Uokr+Xqe7c/7CX6xQ5eJo3S2bcdEtxCVsP3vBq2
	ecDpd73Lj5gaDHolmOwvvafPEIbVZ8s=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-690-6cbCq3VSN9miFBnFc4XcfA-1; Tue,
 30 Dec 2025 16:14:51 -0500
X-MC-Unique: 6cbCq3VSN9miFBnFc4XcfA-1
X-Mimecast-MFC-AGG-ID: 6cbCq3VSN9miFBnFc4XcfA_1767129289
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 85FF3195DE56;
	Tue, 30 Dec 2025 21:14:49 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.4])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E7D4330001A2;
	Tue, 30 Dec 2025 21:14:46 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <00150dea-4a30-49e3-a1c2-cd6e6561e238@linux.dev>
References: <00150dea-4a30-49e3-a1c2-cd6e6561e238@linux.dev> <5b74f84d-3de5-40fd-b0c8-f2743834bc1a@linux.dev> <93b7f27c-ed92-4169-912a-c83088c85df9@linux.dev> <20251225021035.656639-1-chenxiaosong.chenxiaosong@linux.dev> <20251225021035.656639-3-chenxiaosong.chenxiaosong@linux.dev> <1266596.1766836803@warthog.procyon.org.uk> <1276266.1766850638@warthog.procyon.org.uk> <1692b7a8-c208-4aa7-a9f4-02fea6d31733@linux.dev>
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
    linkinjeon@kernel.org, pc@manguebit.org, ronniesahlberg@gmail.com,
    sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
    senozhatsky@chromium.org, linux-cifs@vger.kernel.org
Subject: Re: [PATCH v6 2/5] cifs: Autogenerate SMB2 error mapping table
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1369033.1767129285.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Tue, 30 Dec 2025 21:14:45 +0000
Message-ID: <1369034.1767129285@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev> wrote:

> David, what do you think of the modifications? Call le32_to_cpu() to get=
 a
> cpu-endian value before comparison.

In fact, you could store the cpu-endian values in the table.  It's only
accessed by this routine (and the kunit test).  Either:

+    print(OUT_FILE "{ /*$code*/ le32_to_cpu($status), $error, \"$full_sta=
tus\" },\n");

or:

+    print(OUT_FILE "{ $code, $error, \"$full_status\" },\n");

as $code is the hex status value.  You don't really need to include $statu=
s -
except that that uses the enum symbol - as the corresponding status name(s=
)
are included in $full_status.

David

