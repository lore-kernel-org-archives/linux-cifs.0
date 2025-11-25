Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E0C32D0F2
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094192; cv=none; b=uiOfG2yFNHoQqqvC92Wu7AD3ePn1C/J55DQ9i6uwquMK6pJ483pWB68JfaCiMSXrPR4EsVmuO2g1IWHBiprfqyTt2jqv0TMgzPjWX1nik1+e14yZ5tVm4OTiamW6r/IUrr9l5B+rtLk0Zh7ONvOihHETouhwqgTk2K76gbpQOvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094192; c=relaxed/simple;
	bh=lly6xHf7Tp0SKa10qODuD8fUGWT4Puqqm3lb/VbHRmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jEr4acAD5cE0Dtqu/q70uxie2xDWdVI4XxrBhLWb3rMJmL13ROrrxI972ORrdmlBFR5iQw17CmCRBBQdWu9fKGaY/ELwUoCkGNHVnm7a6gaBrlM6tpko+2vXnnxJ5T007gkfq4QMHOSHKca5PGBNTFsjrLvV9w3K2mrO7in49CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=qAQwZOtv; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="qAQwZOtv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Wcm+DkST9X8Z5uIvlrOrjlhwuuIMAlhtD+9a0FDATLs=; b=qAQwZOtvDpHYJGCLSkyM34Lb8W
	rlhGMbM5gXlriakEsuUCsyQ/5aIyPdFrk7uXuuGeDuvAg2z4IUMfB926bFBrAsDtnLN5mU+mcIOY5
	kDz68GWm3QqcrQ6nG+0OZFMHeO+/iVTBTcucQNv4RuypF/snz/tM8Hk/y7bf0BY3rxOXeHz86W8oL
	PdeCj3ojhdm8JXfAWFNX9jcKoGC7yWLbq1c9+ZZ85BQa6nwZ8koHI2HiswDBh1ObHYjAOSRY/y5tC
	Mm460swcObsaq4paHBP2R71QhRQ9dwR6a/f0tdvXRS00BQGoapqilunl7kODJWhFY+TFlQ4EIS5gN
	D7Ynj4Ts1PNjoMN7EpLuCDLVLm3dyyuarDpTz0Kgr47bvZFBaeBEVu57d2Pyn+QhsmsQhz+Z2M3UM
	w2U+uY4cEHrzwKi+hA9YDnzzby5aZ8mXFmPOU7MQsrvpIiLCZMDW3ueniFbMMalidds43McPC7gdn
	8qaJzJHvvilUOiLQifNufDvn;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxR5-00Fdne-38;
	Tue, 25 Nov 2025 18:06:44 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 079/145] smb: client: make use of smbdirect_connection_post_recv_io()
Date: Tue, 25 Nov 2025 18:55:25 +0100
Message-ID: <2af6681839e633530321ee980fbba5220c58bd7e.1764091285.git.metze@samba.org>
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

And that the error code from ib_dma_mapping_error() (currently only -ENOMEM
is possible) is returned instead of -EIO.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 46 ++-------------------------------------
 1 file changed, 2 insertions(+), 44 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 9e3557476b4c..ee753f6dffd8 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -23,10 +23,6 @@ const struct smbdirect_socket_parameters *smbd_get_parameters(struct smbd_connec
 	return &sc->parameters;
 }
 
-static int smbd_post_recv(
-		struct smbdirect_socket *sc,
-		struct smbdirect_recv_io *response);
-
 static int smbd_post_send_empty(struct smbdirect_socket *sc);
 
 static void destroy_mr_list(struct smbdirect_socket *sc);
@@ -403,7 +399,7 @@ static void smbd_post_send_credits(struct work_struct *work)
 				break;
 
 			response->first_segment = false;
-			rc = smbd_post_recv(sc, response);
+			rc = smbdirect_connection_post_recv_io(response);
 			if (rc) {
 				log_rdma_recv(ERR,
 					"post_recv failed rc=%d\n", rc);
@@ -1059,44 +1055,6 @@ static int smbd_post_send_full_iter(struct smbdirect_socket *sc,
 	return rc;
 }
 
-/*
- * Post a receive request to the transport
- * The remote peer can only send data when a receive request is posted
- * The interaction is controlled by send/receive credit system
- */
-static int smbd_post_recv(
-		struct smbdirect_socket *sc, struct smbdirect_recv_io *response)
-{
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	struct ib_recv_wr recv_wr;
-	int rc = -EIO;
-
-	response->sge.addr = ib_dma_map_single(
-				sc->ib.dev, response->packet,
-				sp->max_recv_size, DMA_FROM_DEVICE);
-	if (ib_dma_mapping_error(sc->ib.dev, response->sge.addr))
-		return rc;
-
-	response->sge.length = sp->max_recv_size;
-	response->sge.lkey = sc->ib.pd->local_dma_lkey;
-
-	recv_wr.wr_cqe = &response->cqe;
-	recv_wr.next = NULL;
-	recv_wr.sg_list = &response->sge;
-	recv_wr.num_sge = 1;
-
-	rc = ib_post_recv(sc->ib.qp, &recv_wr, NULL);
-	if (rc) {
-		ib_dma_unmap_single(sc->ib.dev, response->sge.addr,
-				    response->sge.length, DMA_FROM_DEVICE);
-		response->sge.length = 0;
-		smbdirect_socket_schedule_cleanup(sc, rc);
-		log_rdma_recv(ERR, "ib_post_recv failed rc=%d\n", rc);
-	}
-
-	return rc;
-}
-
 /* Perform SMBD negotiate according to [MS-SMBD] 3.1.5.2 */
 static int smbd_negotiate(struct smbdirect_socket *sc)
 {
@@ -1108,7 +1066,7 @@ static int smbd_negotiate(struct smbdirect_socket *sc)
 	sc->status = SMBDIRECT_SOCKET_NEGOTIATE_RUNNING;
 
 	sc->recv_io.expected = SMBDIRECT_EXPECT_NEGOTIATE_REP;
-	rc = smbd_post_recv(sc, response);
+	rc = smbdirect_connection_post_recv_io(response);
 	log_rdma_event(INFO, "smbd_post_recv rc=%d iov.addr=0x%llx iov.length=%u iov.lkey=0x%x\n",
 		       rc, response->sge.addr,
 		       response->sge.length, response->sge.lkey);
-- 
2.43.0

