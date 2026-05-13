Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFCF3A71B3
	for <linux-cifs@vger.kernel.org>; Wed, 13 May 2026 18:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778698213; cv=none; b=DLUdeXq3DgVY1NuTaMNiLw9YpP/Ndltfpv+VIwM4PDCCKhP3bgtNY9E0Kx7lb9XJI2aG53CMqCn6kCNm2Ck7tDygxHfdnVYHeF+YMrGMYV8HLic5e3FPPYN5vSc1XVzBHV5v6fwhmZh4xnNHmqo7SurEbtLQlrDxZuZ8KpnLlAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778698213; c=relaxed/simple;
	bh=gDJH/0a4mOQou4JaSqo8Ri+WWQp7zt0QZwW84fcVWGA=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=tOSptfdJxo5rzfE5PvCpOSTjGYIEafNL8JARn9GwpkPwk/9X/Ilax5/cMXVi8dGHLyPH2ilpRZVSPR2/DCNN1+PgcaHe56JiLrDRI99n9ukeleX0ggrei1yViE2sHH21sDsmj+mzLakxuVB7NyJodt4eJa0Ku5TfgBhMvNIYUvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IktEqrnm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IktEqrnm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778698211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0iNq88mUyZEP6TffH0rtiYD2cLTl5N4o4mOd2LcnpEU=;
	b=IktEqrnmTnsNSf+BHctRiLEDIRwnPdWhvt2pBBslxMSin6Iw7sBjB0Yg2jzIQuSKxQVMTI
	uciKOnQSB6GnABrLQkhOXPQMUSnaEyzAjCsRF6Ys9Q1Xq3e1P2NChAalZsxE4YqbAEMZKX
	WKaR1rH5bLasLh4Ci32xY8nqdGEg1fg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-562-jWvLleNhMdaOzsQtQ640lw-1; Wed,
 13 May 2026 14:50:08 -0400
X-MC-Unique: jWvLleNhMdaOzsQtQ640lw-1
X-Mimecast-MFC-AGG-ID: jWvLleNhMdaOzsQtQ640lw_1778698207
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C0B19180035D;
	Wed, 13 May 2026 18:50:06 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.48.83])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5E3B119560A2;
	Wed, 13 May 2026 18:50:04 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Steve French <sfrench@samba.org>,
    Stefan Metzmacher <metze@samba.org>
cc: dhowells@redhat.com, Paulo Alcantara <pc@manguebit.org>,
    Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
    linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] smbdirect: Fix error cleanup in smbdirect_map_sges_from_iter()
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1927247.1778698202.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 13 May 2026 19:50:02 +0100
Message-ID: <1927248.1778698202@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Fix smbdirect_map_sges_from_iter() to use pre-decrement, not post-decremen=
t
so that it cleans up the correct slots.

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
 fs/smb/smbdirect/connection.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/smbdirect/connection.c b/fs/smb/smbdirect/connection.c
index fe9912e53da6..8adf58097534 100644
--- a/fs/smb/smbdirect/connection.c
+++ b/fs/smb/smbdirect/connection.c
@@ -2168,7 +2168,7 @@ static ssize_t smbdirect_map_sges_from_iter(struct i=
ov_iter *iter, size_t len,
 =

 	if (ret < 0) {
 		while (state->num_sge > before) {
-			struct ib_sge *sge =3D &state->sge[state->num_sge--];
+			struct ib_sge *sge =3D &state->sge[--state->num_sge];
 =

 			ib_dma_unmap_page(state->device,
 					  sge->addr,

