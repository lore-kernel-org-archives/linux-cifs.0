Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1627359A91
	for <linux-cifs@vger.kernel.org>; Fri, 24 Apr 2026 09:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777024582; cv=none; b=Vje95XADGIFIwYls/M9a86VpEPmi65OpzoeuPaMjj6k++oVUIB7NGujgbUYHWK2WSpFRRYO0m7E/VJH5MPmikJ/xQCuDSbtixBteow3k7BjB2cA+dfWe93Y5aPz+5rhEJzEsyfktyIxIMd/Y3TMSA9Ig1/49LSJPbsQb+5K2yeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777024582; c=relaxed/simple;
	bh=vDVy4HSCuAzyuVuqYNYZG/345V3jt15pH76kXLi/aj8=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=GzibML7Wir6L79FIeRDgcAg+wdOeYqfROzDi5QLaVEwatXYAimKY0LUZdnNZzH8cZ+dddy5//jCfOW1PdTcFT9tiEskqb1JAliRrvxMs5akMKRSZXleD4i9hJCziEU4EB7bAggxxvYAhB8iVM0ghFwM381V1leHTPlTChRaDwS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y4BXNqlq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y4BXNqlq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777024580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6oe4iP+qDM4VqrJwNPRfPMrmTeINxzNdTw84PQgwZL8=;
	b=Y4BXNqlqnXhR+6OZMlwe9eUK2qQPAtmXJ8okEaba8OF9MgZZcEfi3cFu2uIR+ZyKisSGkJ
	xTGWfBjAMBXOC/tIJvogKrDiqcR2FNI9In7bqrMRhSSF3xAr/+JKUG0BUpv+krBwSPTZrL
	vPsauTxnhbCVc45dWK6+NaRzY4Z3+DA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-634-wbknyXtUNnC4Ju8FXtvWGQ-1; Fri,
 24 Apr 2026 05:56:16 -0400
X-MC-Unique: wbknyXtUNnC4Ju8FXtvWGQ-1
X-Mimecast-MFC-AGG-ID: wbknyXtUNnC4Ju8FXtvWGQ_1777024575
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1C49219540D1;
	Fri, 24 Apr 2026 09:56:15 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.48.17])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 606561944CED;
	Fri, 24 Apr 2026 09:56:12 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>,
    Stefan Metzmacher <metze@samba.org>
cc: dhowells@redhat.com, Paulo Alcantara <pc@manguebit.org>,
    Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
    stable@vger.kernel.org
Subject: [PATCH] smb: client: Fix error cleanup in smb_extract_iter_to_rdma()
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3418417.1777024571.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Apr 2026 10:56:11 +0100
Message-ID: <3418418.1777024571@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

    =

Fix smb_extract_iter_to_rdma() to use pre-decrement, not post-decrement, s=
o
that it cleans up the correct slots.

Fixes: e5fbdde43017 ("cifs: Add a function to build an RDMA SGE list from =
an iterator")
Closes: https://sashiko.dev/#/patchset/20260326104544.509518-1-dhowells%40=
redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Steve French <sfrench@samba.org>
cc: Stefan Metzmacher <metze@samba.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Tom Talpey <tom@talpey.com>
cc: linux-cifs@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
---
 fs/smb/client/smbdirect.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 7d5f66bdbb30..4978755c035c 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -3394,7 +3394,7 @@ static ssize_t smb_extract_iter_to_rdma(struct iov_i=
ter *iter, size_t len,
 =

 	if (ret < 0) {
 		while (rdma->nr_sge > before) {
-			struct ib_sge *sge =3D &rdma->sge[rdma->nr_sge--];
+			struct ib_sge *sge =3D &rdma->sge[--rdma->nr_sge];
 =

 			ib_dma_unmap_single(rdma->device, sge->addr, sge->length,
 					    rdma->direction);

