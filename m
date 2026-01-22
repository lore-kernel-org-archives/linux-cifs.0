Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E627036072B;
	Thu, 22 Jan 2026 17:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769102307; cv=none; b=GNNW24lycrn5oSad4cDwqUwELafJSVkhVEUjfTW9HvgoWwsG+jh09qBxj2i91iDijbod+/aLP1KlVMa4PqyzBlvC5LeRXr0RPAr9csZufVQ/cHOcdUB3HPX1WkDYnX2yWS3L/+mYoafGuAnfrbKC6ioVWeEzqNw5qUvsD6eUjg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769102307; c=relaxed/simple;
	bh=Oz665qBnc/lJ5RqzyXr8NzOc8nwLwyB+rXLSbA1cnr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYf6GSS7eiAuqIDbtt0s3Xq6xD6m5ylVlyrBZocrPit6Gwv07QEbLN0dD5hOMAKXGCRS3+PXzyJlVdajJ27ukEULwQ4vWQF6gWSkH1MKsWp/q4Nh+Hq9tuHWNAyRuPfGXBIBFkCqWrd7wfl/uSfl44njmXnOTHZxg0S40xm4qpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=WBqpQdFq; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="WBqpQdFq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=yVouT8/ezY0NrtEFoEjaXMgjxEfRO7ZMgGF10Fyuq4s=; b=WBqpQdFqrHPa9RiKotoDkYSm89
	4kva5q1BMPgeRZedMht4ttQhUpK0Z6jCKycdtZDrpolKbTZU9jWTS+3NVivYkhDz8nKXSU5gGMDhl
	iwKj1Oz1RcBOH4zVt9WTAwlLd1A3yIX1ZYhVRd5nLKsO9edBJyuix858S2UkVgvyylHF91EOWy4Tz
	HJzay9QchAqe4XIuvf/DdRS8+uc6pfxVTz/NI+y5BMkqWhnpO9MkpAeHNaPyn49pl0Clgubcd693a
	MEp/E9ZMsAToK3ghQg7X+ixkTIfknFZWgaakIjRRieZ0JI1ke/a60TYANvdlgBr2JQk7uZ5GW68G4
	qjMkP/Q8ShhE6OeBfNgvIH9OssE98+4GLTBxDmCSk85jCwo37Yo3zHOpMMva1B4FYHUEIwn0TboxW
	RtoRi/K/qvd3Pn+8HvkG3Own1O+VwEBUTCFOIvDdtTA8MLn6iZrqkIUm8nqIEQd2ySDqGMsWRNQVz
	WsbzBE6MggfsBPadNQ3AvaVp;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1viyJq-00000001pqO-3bgV;
	Thu, 22 Jan 2026 17:18:07 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 10/20] smb: client: let smbd_post_send() make use of request->wr
Date: Thu, 22 Jan 2026 18:16:50 +0100
Message-ID: <4c95fd07e6abb620719eaa0b3210e12d6acfc321.1769101771.git.metze@samba.org>
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

We don't need a stack variable in addition.

Cc: <stable@vger.kernel.org> # 6.18.x
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 61693b4a83fc..f2ae35a9f047 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1105,7 +1105,6 @@ static int manage_keep_alive_before_sending(struct smbdirect_socket *sc)
 static int smbd_post_send(struct smbdirect_socket *sc,
 		struct smbdirect_send_io *request)
 {
-	struct ib_send_wr send_wr;
 	int rc, i;
 
 	for (i = 0; i < request->num_sge; i++) {
@@ -1121,14 +1120,14 @@ static int smbd_post_send(struct smbdirect_socket *sc,
 
 	request->cqe.done = send_done;
 
-	send_wr.next = NULL;
-	send_wr.wr_cqe = &request->cqe;
-	send_wr.sg_list = request->sge;
-	send_wr.num_sge = request->num_sge;
-	send_wr.opcode = IB_WR_SEND;
-	send_wr.send_flags = IB_SEND_SIGNALED;
+	request->wr.next = NULL;
+	request->wr.wr_cqe = &request->cqe;
+	request->wr.sg_list = request->sge;
+	request->wr.num_sge = request->num_sge;
+	request->wr.opcode = IB_WR_SEND;
+	request->wr.send_flags = IB_SEND_SIGNALED;
 
-	rc = ib_post_send(sc->ib.qp, &send_wr, NULL);
+	rc = ib_post_send(sc->ib.qp, &request->wr, NULL);
 	if (rc) {
 		log_rdma_send(ERR, "ib_post_send failed rc=%d\n", rc);
 		smbd_disconnect_rdma_connection(sc);
-- 
2.43.0

