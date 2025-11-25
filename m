Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217011F30A9
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094948; cv=none; b=RS2hkiMwzLdwXX9gEWtNe9Y2BzC4FvTSw3gVdL0grUyUFI+gJ9kp7b8Yo3qSewLmw0QMw4gKVSWes6iwgdxUT0nhfNl0yW99mMDtRKeNzUr2EiHhoMZfod6djt8NF9qCAOF6ep3YmNYRxJ60UdEvJ3HSkn5fEH3PKgRsioFc72k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094948; c=relaxed/simple;
	bh=DmDaJ0bmrOhcShQp0QjxVpmxOuO3G1mu26b6R4EYMOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HcpOJ/7Zecy+5BpeLf4tKG39QutxRucLkHMxv7DFW9eHNIDcKq3tN3t8sxsVTNb4xX1mW12F4AMwqPSUjSArvZqtvqEE9P8msQ8mRCkIBgzU5/2MFaxXxB3x57roZRn2mSIH5C5LV2x7MQu8OHWPZeTrEEe07LNRqdX1kLghka0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=oxNJQL/M; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="oxNJQL/M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=OTU36QBOrI0tsSyTNbhNVAgOQn7cp+DMAM1EIQ5t/Aw=; b=oxNJQL/MvBWsed2yrYwEqLnRR5
	xy/gYp4HaW1z+ilYJGBm8FvJMmYIMLA6FjTCGgMXosbICbGzS+cg8WxJQ14WyLnn3KgJVXBkUVVMH
	FNkMWBLyOMwNIvSYMnkMvBvQjvY2eKp0kGejGndOxOti+JTfpmaPvyEkxcpGCUbDZ3oK/PraQ0vZw
	o1Z7m11du+5w5rDXcxnSSEAhwNzTJLqqkvywFyLGYSMJacc+xd8mU1NGG7t/RH8qKx9gaA4RGKWMN
	EUva8MO6lo6s2v/8vnZOChCWdpk12m0VeuTllhxEkms/BpMnvO1kmsnaxNDTyphqIwpf02qRXj+vw
	e6x/VC3dJUOyyrCc+UdSZh3u6X/l2cfipPrLuujZOo3kqqAhFRpLCBZNVHwNGmIw1Gb9ZtQuZ93P0
	+PN1TjHAKPOv2AOKjoPy9Cje2VdQfMYzqOFovElQXEGpvyB79qSV/vl37Cb69JE13hbA023CQqgIq
	5+KAz3xeMuHfuT7UU3PjhU6N;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxdI-00Fevo-0U;
	Tue, 25 Nov 2025 18:19:20 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 115/145] smb: server: make use of smbdirect_connection_post_recv_io()
Date: Tue, 25 Nov 2025 18:56:01 +0100
Message-ID: <25c1f3279eca2b86a3b5404df72702676decdb45.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The only difference is that smbdirect_connection_post_recv_io()
returns early if the connection is already broken.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 39 ++--------------------------------
 1 file changed, 2 insertions(+), 37 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index e0a39558ebff..70a819fb1187 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -542,41 +542,6 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
 }
 
-static int smb_direct_post_recv(struct smbdirect_socket *sc,
-				struct smbdirect_recv_io *recvmsg)
-{
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	struct ib_recv_wr wr;
-	int ret;
-
-	recvmsg->sge.addr = ib_dma_map_single(sc->ib.dev,
-					      recvmsg->packet,
-					      sp->max_recv_size,
-					      DMA_FROM_DEVICE);
-	ret = ib_dma_mapping_error(sc->ib.dev, recvmsg->sge.addr);
-	if (ret)
-		return ret;
-	recvmsg->sge.length = sp->max_recv_size;
-	recvmsg->sge.lkey = sc->ib.pd->local_dma_lkey;
-
-	wr.wr_cqe = &recvmsg->cqe;
-	wr.next = NULL;
-	wr.sg_list = &recvmsg->sge;
-	wr.num_sge = 1;
-
-	ret = ib_post_recv(sc->ib.qp, &wr, NULL);
-	if (ret) {
-		pr_err("Can't post recv: %d\n", ret);
-		ib_dma_unmap_single(sc->ib.dev,
-				    recvmsg->sge.addr, recvmsg->sge.length,
-				    DMA_FROM_DEVICE);
-		recvmsg->sge.length = 0;
-		smbdirect_socket_schedule_cleanup(sc, ret);
-		return ret;
-	}
-	return ret;
-}
-
 static int smb_direct_read(struct ksmbd_transport *t, char *buf,
 			   unsigned int size, int unused)
 {
@@ -713,7 +678,7 @@ static void smb_direct_post_recv_credits(struct work_struct *work)
 
 			recvmsg->first_segment = false;
 
-			ret = smb_direct_post_recv(sc, recvmsg);
+			ret = smbdirect_connection_post_recv_io(recvmsg);
 			if (ret) {
 				pr_err("Can't post recv: %d\n", ret);
 				smbdirect_connection_put_recv_io(recvmsg);
@@ -1644,7 +1609,7 @@ static int smb_direct_prepare_negotiation(struct smbdirect_socket *sc)
 	if (!recvmsg)
 		return -ENOMEM;
 
-	ret = smb_direct_post_recv(sc, recvmsg);
+	ret = smbdirect_connection_post_recv_io(recvmsg);
 	if (ret) {
 		pr_err("Can't post recv: %d\n", ret);
 		goto out_err;
-- 
2.43.0

