Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C93623182D
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744773; cv=none; b=lvBcWgt0ZVkpblThQo4F8oNz5yrUduBdj8sKIAh/m/MDrwjccifnIyaLzI1q9iIAqks8Fkg71cHc9Te85JXQmUjgb5B5cwL7qNUpxilTffx75aEmUWeQxkyfJdZDh7/H4mU7WlnaapIUF5YSSo6FF+QAqCo5iqHAg0RoRxE05q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744773; c=relaxed/simple;
	bh=dWpyQ9TS0aF4I/PZH4BHMjAKnxkvlwoBTVDowdTbKXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CEIhN7WCqIO1Axh571aMT6furQOi/jLGpKxqJgEPv4Ex/hn138c2E3gO6qH4t7OZGhD60Y6trSH/Bz9K0cdR2Hux3Psy3UCjXtrokSButjUQ6InprBPgPQvtT6FkRVbtkP2cFcrz8UZVQeeJFcrWkx55y8OKF7VJQA4oO3vsi+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Fs8UNaCZ; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Fs8UNaCZ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=z0JBSaWnuPcTZdACIylAQIM6L+wVBx7XIl/YggoemYQ=; b=Fs8UNaCZ57EySCM/8LSkLiHvOU
	mVrhHz9E4sduqe0CgHK0T4zbdsZaKHkBam1GNX/JKWmK/sKRLLhWjmynMQsoD78K8h4BZxhsw02fx
	8/gYB1c27vofPtSIO7XHEdeJZ8s38I5EF8qllJJoSumVRxIlhLfTyMYd93ru0AibwDW9r9Jxmkpk3
	6h0jBPOlyOXlQ+p/xekxadaeMiKPUAr6Bt1Dns81qqMXtkUv3DB2qVbcOkBXWUZW9+yZJHbwms1SM
	jSUYbjDl6631RGttxzIH8Kbn3aesJ80+/A0nQw8tuJGOLeAoEiubwQ3TzkHrAqwu5K4I+2/dHIs34
	mJrLuqyIu/wVzMNDVFT5RwnHLgyrCtIN9zQ+vqImMXRxFsw2wjbtHXStu/cdFIeBMu2oy9wS/Nx0w
	P2eY4gV0UfoMwDT9imiDWVJGeoHdu1biVxDQfN9Yu2GGUqsFXlJO1Ldjk2WAvZrhQ+GEUw4rNpPtz
	dH36ebZxRFqickVpfO0a8G4r;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6IC-00Bco0-0f;
	Wed, 29 Oct 2025 13:32:48 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 102/127] smb: server: make use of smbdirect_connection_send_io_done()
Date: Wed, 29 Oct 2025 14:21:20 +0100
Message-ID: <54dc31facd4cecaf68eec1df2e1e92054e6c1113.1761742839.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1761742839.git.metze@samba.org>
References: <cover.1761742839.git.metze@samba.org>
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
index 50dc87660b25..aff7ac3054bc 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -726,46 +726,6 @@ static void smb_direct_post_recv_credits(struct work_struct *work)
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
-		smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
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
@@ -1068,7 +1028,7 @@ static int post_sendmsg(struct smbdirect_socket *sc,
 					      msg->sge[i].addr, msg->sge[i].length,
 					      DMA_TO_DEVICE);
 
-	msg->cqe.done = send_done;
+	msg->cqe.done = smbdirect_connection_send_io_done;
 	msg->wr.opcode = IB_WR_SEND;
 	msg->wr.sg_list = &msg->sge[0];
 	msg->wr.num_sge = msg->num_sge;
-- 
2.43.0

