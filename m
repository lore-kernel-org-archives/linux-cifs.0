Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF8A30DD2E
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094716; cv=none; b=k4v1Oghf0HWvK8/93/pTsVdldTWeu10IL58AbFzXC+MQ3Yeib8y+YdYD9oE/PYfiUcD2SCQSy4cckiReURXlQGXvFDpGLT4YqlhXhAHtlammIJsTBh1AUq6AzpJxXuoqW48yfOdycKCChVkoEchspWrCt6SKyMg1MOr8QPkTIhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094716; c=relaxed/simple;
	bh=kPMiegqrW6ztdailnFm5PDoaqmKF87uD1Oni2b8OUAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJnJi0XgrB2E6v6jRapWC0fRygnSMFAJK0G/yASJjz/mDoi59wv5RK4eVW43ri8EnDqGGj72Gw5eVYaI5QPkUF7uMU1pn3zLYLap0cIB5plKfssx92H4BIbsew4ZVMsNHp66RC1Y3Rzb4E3StlRbDHPVvszAjyqx25m8yCF9p4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=hYwSQ7F8; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="hYwSQ7F8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=N2xJslzjp+TDc+te/ezg8kgxyNlp7b0Qs4EzD/FhHvs=; b=hYwSQ7F8dw0zS1/fSL0sOSPH1E
	DilWQ9u7mwGSS5nfMa/ALlLRFQ8zOQbogY0T7XmVnrqAeHC5gtOxwgNDxWIXpY9DT5eCRqoLyYxzD
	Zryt2r4dvUpt0LrU39xfH48F2V5KlcAP1BPtBVrY2Eep33FC31icIGQXOyo5ffstEUTCSU63NQ4Zj
	kfPP34/aiIgFsO73+6eGjHtUomiU1EMoNs7w57agrKEXXrK9N3X0MgSJoGRZ2JlbMFPmcVyAfwbkm
	57XFZYagL2HyNpxVlBt/npJJ5gRQztTi0UxplL3AkoGJRAeaTYjCEw462k6fOcAKLsxGmbMbD/eUK
	yD9CV27BoNpSsSXRfHg0FqRWxjZZ60nSHsEQgW8qEIjo6V8zrhefOENUrk1sdXNY+nYYRdLQOPfv4
	NOBCsd3QhhRprkL63+fX3CCNXhGdprmcjvT5iqN3SPPJNbOdCGYHE0RnW2dtnBJnCeP6S+tsW48Vl
	L1aZQuXBfiR9gjBY3f1MGAKP;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxVy-00FeS9-1Y;
	Tue, 25 Nov 2025 18:11:48 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 108/145] smb: server: make use of smbdirect_connection_send_io_done()
Date: Tue, 25 Nov 2025 18:55:54 +0100
Message-ID: <eb206c9b993b44cfc8b8e1732bb4d5aa09944d14.1764091285.git.metze@samba.org>
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

This also wakes up send_io.pending.dec_wait_queue, which
is currently always empty in the server, but that might
change in future. And we also don't spam the logs on IB_WC_WR_FLUSH_ERR.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 42 +---------------------------------
 1 file changed, 1 insertion(+), 41 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 92ea33be0005..3b324b42d009 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -737,46 +737,6 @@ static void smb_direct_post_recv_credits(struct work_struct *work)
 		queue_work(sc->workqueue, &sc->idle.immediate_work);
 }
 
-static void send_done(struct ib_cq *cq, struct ib_wc *wc)
-{
-	struct smbdirect_send_io *sendmsg, *sibling, *next;
-	struct smbdirect_socket *sc;
-	int lcredits = 0;
-
-	sendmsg = container_of(wc->wr_cqe, struct smbdirect_send_io, cqe);
-	sc = sendmsg->socket;
-
-	ksmbd_debug(RDMA, "Send completed. status='%s (%d)', opcode=%d\n",
-		    ib_wc_status_msg(wc->status), wc->status,
-		    wc->opcode);
-
-	/*
-	 * Free possible siblings and then the main send_io
-	 */
-	list_for_each_entry_safe(sibling, next, &sendmsg->sibling_list, sibling_list) {
-		list_del_init(&sibling->sibling_list);
-		smbdirect_connection_free_send_io(sibling);
-		lcredits += 1;
-	}
-	/* Note this frees wc->wr_cqe, but not wc */
-	smbdirect_connection_free_send_io(sendmsg);
-	lcredits += 1;
-
-	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_SEND) {
-		pr_err("Send error. status='%s (%d)', opcode=%d\n",
-		       ib_wc_status_msg(wc->status), wc->status,
-		       wc->opcode);
-		smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
-		return;
-	}
-
-	atomic_add(lcredits, &sc->send_io.lcredits.count);
-	wake_up(&sc->send_io.lcredits.wait_queue);
-
-	if (atomic_dec_and_test(&sc->send_io.pending.count))
-		wake_up(&sc->send_io.pending.zero_wait_queue);
-}
-
 static int manage_credits_prior_sending(struct smbdirect_socket *sc)
 {
 	int new_credits;
@@ -1079,7 +1039,7 @@ static int post_sendmsg(struct smbdirect_socket *sc,
 					      msg->sge[i].addr, msg->sge[i].length,
 					      DMA_TO_DEVICE);
 
-	msg->cqe.done = send_done;
+	msg->cqe.done = smbdirect_connection_send_io_done;
 	msg->wr.opcode = IB_WR_SEND;
 	msg->wr.sg_list = &msg->sge[0];
 	msg->wr.num_sge = msg->num_sge;
-- 
2.43.0

