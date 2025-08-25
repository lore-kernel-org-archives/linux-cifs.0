Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4372AE90
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154893; cv=none; b=h9rb+n02jHmGZi2Z0w9U2rACMygOKbcj2I15rQeO7Hf/3e0qEb8qGlxcbzTW2zsMN2WKt5eeLWUNKJpHjZso1rgBOoPzW2wIxMqQhSwtiz86jAShGjb5yDIbnP4IkDi5EKpYRC+ZE3QlC6KanU18VWuF7VvUbmrH0lzePqQTcNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154893; c=relaxed/simple;
	bh=mS5tFYLioUDqhcpwASO13vG9Gu+2Ag06W810boXNOeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CnBnUSIC/XdgJOjxpUyg6/aHAWLN04E/gb2Sd0OdquuPMT56DUU+n4LrmKEQkgIV55Dkb/EGRGFJs6zp39XYOixE6WQOu4shg0IP+D7e1Hvp2hQHbD1FBNI4j0uEjHbY4eB3PIFYysx0pDxHYNONT2vBxlqwCUwwiDcBnsj5tjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=CqQkxELy; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="CqQkxELy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=uad7l+iLLaR0+CGoyI7eJ2vgNTCv4TZJu8oLnT9f8/c=; b=CqQkxELyyfzIvakxAbbhuA5zTR
	GM2x3UId+9hywgd7ZmVJMVq8oDidm9by2YIRzQLLA6QHSKgy5LKIg4kjz+8IbaIaTD8YRVc/nndX/
	MBG/Jw64bb+5BME9qxWxyBmhpYZc5M7FJxuWkYclmxmPhBb2uZ8DuSsGOftYf/a8WO22NbFhdPfby
	bhS038eWmxxy/Pu8pR8Muq9okvrPhabpkpZX7x6/pk0Bw2GqsNl1MRA9eduzR4O2z7LYFN7peW4SR
	hu5J78QqvOPTbDQWBD8olsKtMma4IuXo26pxiT4cW1ixmeB7DIOWK6RcV8gGLeTY1QFzLviuLOYHw
	l6MEdMDH0GFrC0ZuQ0h6Cyg/mY1GkZ3AtpqmSKcVknprPNdcKavZPz6jyJQIOF93C5w3JeDKjlWr4
	lYbp2+XihXv4P04K4fiHQgPIm1MGXZddpEgl34JNAs2AviKoTJWhsFs5EmDcS/ZZZwcAcb5K2cwTR
	0atkLMrhoyJlP9nnrYgCc6Rs;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe6q-000kTZ-1b;
	Mon, 25 Aug 2025 20:48:08 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 038/142] smb: client: fill smbdirect_socket_parameters at the beginning and use the values from there
Date: Mon, 25 Aug 2025 22:39:59 +0200
Message-ID: <92fd044cebdd5b24d3824110fee3cfeafeefd8cc.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is what we should do and it also simplifies the following changes.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index a65c3a841985..a1ca18dbb758 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1672,37 +1672,37 @@ static struct smbd_connection *_smbd_get_connection(
 
 	INIT_WORK(&sc->disconnect_work, smbd_disconnect_rdma_work);
 
+	sp->recv_credit_max = smbd_receive_credit_max;
+	sp->send_credit_target = smbd_send_credit_target;
+	sp->max_send_size = smbd_max_send_size;
+	sp->max_fragmented_recv_size = smbd_max_fragmented_recv_size;
+	sp->max_recv_size = smbd_max_receive_size;
+	sp->keepalive_interval_msec = smbd_keep_alive_interval * 1000;
+
 	rc = smbd_ia_open(info, dstaddr, port);
 	if (rc) {
 		log_rdma_event(INFO, "smbd_ia_open rc=%d\n", rc);
 		goto create_id_failed;
 	}
 
-	if (smbd_send_credit_target > sc->ib.dev->attrs.max_cqe ||
-	    smbd_send_credit_target > sc->ib.dev->attrs.max_qp_wr) {
+	if (sp->send_credit_target > sc->ib.dev->attrs.max_cqe ||
+	    sp->send_credit_target > sc->ib.dev->attrs.max_qp_wr) {
 		log_rdma_event(ERR, "consider lowering send_credit_target = %d. Possible CQE overrun, device reporting max_cqe %d max_qp_wr %d\n",
-			       smbd_send_credit_target,
+			       sp->send_credit_target,
 			       sc->ib.dev->attrs.max_cqe,
 			       sc->ib.dev->attrs.max_qp_wr);
 		goto config_failed;
 	}
 
-	if (smbd_receive_credit_max > sc->ib.dev->attrs.max_cqe ||
-	    smbd_receive_credit_max > sc->ib.dev->attrs.max_qp_wr) {
+	if (sp->recv_credit_max > sc->ib.dev->attrs.max_cqe ||
+	    sp->recv_credit_max > sc->ib.dev->attrs.max_qp_wr) {
 		log_rdma_event(ERR, "consider lowering receive_credit_max = %d. Possible CQE overrun, device reporting max_cqe %d max_qp_wr %d\n",
-			       smbd_receive_credit_max,
+			       sp->recv_credit_max,
 			       sc->ib.dev->attrs.max_cqe,
 			       sc->ib.dev->attrs.max_qp_wr);
 		goto config_failed;
 	}
 
-	sp->recv_credit_max = smbd_receive_credit_max;
-	sp->send_credit_target = smbd_send_credit_target;
-	sp->max_send_size = smbd_max_send_size;
-	sp->max_fragmented_recv_size = smbd_max_fragmented_recv_size;
-	sp->max_recv_size = smbd_max_receive_size;
-	sp->keepalive_interval_msec = smbd_keep_alive_interval * 1000;
-
 	if (sc->ib.dev->attrs.max_send_sge < SMBDIRECT_SEND_IO_MAX_SGE ||
 	    sc->ib.dev->attrs.max_recv_sge < SMBDIRECT_RECV_IO_MAX_SGE) {
 		log_rdma_event(ERR,
-- 
2.43.0

