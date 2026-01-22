Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCFF936F439;
	Thu, 22 Jan 2026 17:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769102356; cv=none; b=hEcyKobvzVGFcYLNhZuWtRtjWp4nXVc9tDyPoOqixJBrNKTmowz9Qd4w0PW2PSBen0fJsQhUnHUorVhhS/bBl9IIkgFnzsad3PEXjs8aSTsCnB5zja0lFVMFovPnvN01cbs2T1mYleAwX+PJiwY9ffDkTI90UCrXXEq2riyR7Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769102356; c=relaxed/simple;
	bh=wjxybZ9pk176JlLnE/sph0H6ZXX3NyP0cNB7Xi9C5nE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9CgHQUe6C04AJ80urQT+T+QLV7f7QPLnEMosArLpffpQW+ZUL1Ob8ASATfWhqR2ib3BJbqeKeWDOz4kah8OrPooWDOQQ5pSXgSJzN96MQIeHcYLrMSVIEPLAEJIr/nrlbGMSSRvaLpJ1/vliIO2pJCfei6cRdrxj2Gcjld/KAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=tIMSJ/ob; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="tIMSJ/ob"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=0ccMYmz29kFx+FKKZi4xcwGJanQQsbaim0NJsZZtmZ0=; b=tIMSJ/obKF6hc2zvxmHE8SAEPK
	QceLsOsQW97HNmu7/f9lYIdGm/uMauO9Nb1iXKHzgCyKub3Qp2VxYGMttUVewSnLdB5E6IM3CwGQ1
	Pt6Xu52RgGH7KBfoe3NFCsTrerxYiCJyS3ZvVv0eJmFfvxW6GvCRWYXBs/xnmhixuhNkAy42olm/9
	zwPlNa5AZuWeMltFjfLroeSNkjZmHmRJiNmFpQ1iSi56QC7yx78lMMpvm2i+B3UYLvd+DwSIfJ/Gm
	q61jSE6gX19TYMfYZAF+hegUWkcyrPSd8Mduf1z30ayTWuyEZo1O+qW/Zeb/IX02rOOTTtVaO6OtA
	pPweMKQ1Km4mBYyGlOErJnEwnoiL6RxUzuFxT5CR+KN8pSOcMkBNwh3i49CLDCtq6/haA/tTiQjlr
	g/6/17sIPMLy1kMl/SwRovNeQPGw6xN3IrCgNmaM1c70ro9uNa/QmjeyFlOrLCjHswYTt7mEb1985
	UUdV5da57bLgTEM37l1RQv/E;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1viyKh-00000001pz1-0XHE;
	Thu, 22 Jan 2026 17:18:59 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 19/20] smb: client: let smbd_post_send_negotiate_req() use smbd_post_send()
Date: Thu, 22 Jan 2026 18:16:59 +0100
Message-ID: <06805abd0e74398b93779a0fc8e7a85814d1a48e.1769101771.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1769101771.git.metze@samba.org>
References: <cover.1769101771.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The server has similar logic and it makes sure that
request->wr is used instead of a stack struct ib_send_wr send_wr.

This makes sure send_done can see request->wr.send_flags
as the next commit will check for IB_SEND_SIGNALED

Cc: <stable@vger.kernel.org> # 6.18.x
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 32 +++++++-------------------------
 1 file changed, 7 insertions(+), 25 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 20faa6d7f514..88fefb901c27 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -35,6 +35,10 @@ static void enqueue_reassembly(
 static struct smbdirect_recv_io *_get_first_reassembly(
 		struct smbdirect_socket *sc);
 
+static int smbd_post_send(struct smbdirect_socket *sc,
+			  struct smbdirect_send_batch *batch,
+			  struct smbdirect_send_io *request);
+
 static int smbd_post_recv(
 		struct smbdirect_socket *sc,
 		struct smbdirect_recv_io *response);
@@ -1021,7 +1025,6 @@ static int smbd_ia_open(
 static int smbd_post_send_negotiate_req(struct smbdirect_socket *sc)
 {
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
-	struct ib_send_wr send_wr;
 	int rc;
 	struct smbdirect_send_io *request;
 	struct smbdirect_negotiate_req *packet;
@@ -1052,33 +1055,12 @@ static int smbd_post_send_negotiate_req(struct smbdirect_socket *sc)
 	request->sge[0].length = sizeof(*packet);
 	request->sge[0].lkey = sc->ib.pd->local_dma_lkey;
 
-	ib_dma_sync_single_for_device(
-		sc->ib.dev, request->sge[0].addr,
-		request->sge[0].length, DMA_TO_DEVICE);
-
-	request->cqe.done = send_done;
-
-	send_wr.next = NULL;
-	send_wr.wr_cqe = &request->cqe;
-	send_wr.sg_list = request->sge;
-	send_wr.num_sge = request->num_sge;
-	send_wr.opcode = IB_WR_SEND;
-	send_wr.send_flags = IB_SEND_SIGNALED;
-
-	log_rdma_send(INFO, "sge addr=0x%llx length=%u lkey=0x%x\n",
-		request->sge[0].addr,
-		request->sge[0].length, request->sge[0].lkey);
-
-	atomic_inc(&sc->send_io.pending.count);
-	rc = ib_post_send(sc->ib.qp, &send_wr, NULL);
+	rc = smbd_post_send(sc, NULL, request);
 	if (!rc)
 		return 0;
 
-	/* if we reach here, post send failed */
-	log_rdma_send(ERR, "ib_post_send failed rc=%d\n", rc);
-	atomic_dec(&sc->send_io.pending.count);
-
-	smbd_disconnect_rdma_connection(sc);
+	if (rc == -EAGAIN)
+		rc = -EIO;
 
 dma_mapping_failed:
 	smbd_free_send_io(request);
-- 
2.43.0

