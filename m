Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6211F1932
	for <linux-cifs@vger.kernel.org>; Mon, 20 Oct 2025 18:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760985418; cv=none; b=Wmo69GiiU1G3iPwNtHxE3WO/RqugWl5sxPaKvZyVlx54b0WtEIOp7maqy4M6GWsNQqLxRs6DVmcxcGW+++mTCYMMgN3CiE0Dn10HVX5z0kIuxxgdwKv82blv+o+541VueFbeWUiuKYtaleZF45sWid17FHn9fc6kfLb0KvZYeKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760985418; c=relaxed/simple;
	bh=1DY0KABK0kdLObOJtn6sstqWC67vAaUWrwoE3mvvqsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r4V7W6orEa/LsFOeXZi+a2Xdjeu0p/1nYopm5thCDgJQPGzI2iFxHIYRCbOG1ZERMM14M5umHKj8wh/Rt1nI0XZtl2lDRjyvLPsnq3omMYEYWbHIxDi+JE5ovQVQZVJiAIHJVjOdiq0Ftmfl6zfG0Vs3LK9Q4/zNKuledtwWDWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=scAfEXHI; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="scAfEXHI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=iP9W7tAzZiGk2s2HuKpppSSvHyw4gXGudyHcs8/1SnI=; b=scAfEXHIdnHTBkepUYJKotSbj7
	fSrstDEw3dop3ubgBEl3sdYl6JY4gg+CpuCLuMRiQB8Oz2DOSFmZg9juBpCCOvrlhn3/9cCVVmX+a
	LF5dSY3I/PrcTAOYG5Y4AfjTCiMF5otGyIGCBGG2eHtmCd4Cly7Kbrn9cO2Qk7F/UQvE07uZ++hql
	Efwr7swawdj7+isrvX9JoqbyaWmZOWWbWxsSDm1Qguzoru8gVZtU6Xxb0QceaP18QhK9eFPdkuOQ3
	89HjijggSrzsrD1l79liLGSaCXXi55oELxL6UR65ECpXEJkmH+aOdxN0iHENmhAa75rpT/XpaeUs0
	1PW20rJBi6mbb4oS/2G2oFqznvgmkh5TuCeps841no9bXZotyvotIKIYPJ7qT0fui6W1+cp17kT50
	9GX/C0G2Flb4PsnFj9ypoGT/cwZkdXblOohQk4uBLbrgP2g+a7UcVuJ3XBpNDggWF4TMeI3YlFqZt
	mTNW3dsOFb/MtW+4pC9Fhri9;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vAukX-00ACPW-1V;
	Mon, 20 Oct 2025 18:36:53 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 5/5] smb: client: make use of smbdirect_socket.send_io.lcredits.*
Date: Mon, 20 Oct 2025 20:36:02 +0200
Message-ID: <82258f4ad9ee9061b11c609a9e997c8900c7e2d8.1760984605.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1760984605.git.metze@samba.org>
References: <cover.1760984605.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This makes the logic to prevent on overflow of
the send submission queue with ib_post_send() easier.

As we first get a local credit and then a remote credit
before we mark us as pending.

For now we'll keep the logic around smbdirect_socket.send_io.pending.*,
but that will likely change or be removed completely.

The server will get a similar logic soon, so
we'll be able to share the send code in future.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 67 ++++++++++++++++++++++++---------------
 1 file changed, 42 insertions(+), 25 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index b1218ea4aa8b..85a4c55b61b8 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -172,6 +172,7 @@ static void smbd_disconnect_wake_up_all(struct smbdirect_socket *sc)
 	 * in order to notice the broken connection.
 	 */
 	wake_up_all(&sc->status_wait);
+	wake_up_all(&sc->send_io.lcredits.wait_queue);
 	wake_up_all(&sc->send_io.credits.wait_queue);
 	wake_up_all(&sc->send_io.pending.dec_wait_queue);
 	wake_up_all(&sc->send_io.pending.zero_wait_queue);
@@ -495,6 +496,7 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct smbdirect_send_io *request =
 		container_of(wc->wr_cqe, struct smbdirect_send_io, cqe);
 	struct smbdirect_socket *sc = request->socket;
+	int lcredits = 0;
 
 	log_rdma_send(INFO, "smbdirect_send_io 0x%p completed wc->status=%s\n",
 		request, ib_wc_status_msg(wc->status));
@@ -504,22 +506,24 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 			request->sge[i].addr,
 			request->sge[i].length,
 			DMA_TO_DEVICE);
+	mempool_free(request, sc->send_io.mem.pool);
+	lcredits += 1;
 
 	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_SEND) {
 		if (wc->status != IB_WC_WR_FLUSH_ERR)
 			log_rdma_send(ERR, "wc->status=%s wc->opcode=%d\n",
 				ib_wc_status_msg(wc->status), wc->opcode);
-		mempool_free(request, sc->send_io.mem.pool);
 		smbd_disconnect_rdma_connection(sc);
 		return;
 	}
 
+	atomic_add(lcredits, &sc->send_io.lcredits.count);
+	wake_up(&sc->send_io.lcredits.wait_queue);
+
 	if (atomic_dec_and_test(&sc->send_io.pending.count))
 		wake_up(&sc->send_io.pending.zero_wait_queue);
 
 	wake_up(&sc->send_io.pending.dec_wait_queue);
-
-	mempool_free(request, sc->send_io.mem.pool);
 }
 
 static void dump_smbdirect_negotiate_resp(struct smbdirect_negotiate_resp *resp)
@@ -567,6 +571,7 @@ static bool process_negotiation_response(
 		log_rdma_event(ERR, "error: credits_granted==0\n");
 		return false;
 	}
+	atomic_set(&sc->send_io.lcredits.count, sp->send_credit_target);
 	atomic_set(&sc->send_io.credits.count, le16_to_cpu(packet->credits_granted));
 
 	if (le32_to_cpu(packet->preferred_send_size) > sp->max_recv_size) {
@@ -1114,6 +1119,24 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 	struct smbdirect_data_transfer *packet;
 	int new_credits = 0;
 
+wait_lcredit:
+	/* Wait for local send credits */
+	rc = wait_event_interruptible(sc->send_io.lcredits.wait_queue,
+		atomic_read(&sc->send_io.lcredits.count) > 0 ||
+		sc->status != SMBDIRECT_SOCKET_CONNECTED);
+	if (rc)
+		goto err_wait_lcredit;
+
+	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
+		log_outgoing(ERR, "disconnected not sending on wait_credit\n");
+		rc = -EAGAIN;
+		goto err_wait_lcredit;
+	}
+	if (unlikely(atomic_dec_return(&sc->send_io.lcredits.count) < 0)) {
+		atomic_inc(&sc->send_io.lcredits.count);
+		goto wait_lcredit;
+	}
+
 wait_credit:
 	/* Wait for send credits. A SMBD packet needs one credit */
 	rc = wait_event_interruptible(sc->send_io.credits.wait_queue,
@@ -1132,23 +1155,6 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 		goto wait_credit;
 	}
 
-wait_send_queue:
-	wait_event(sc->send_io.pending.dec_wait_queue,
-		atomic_read(&sc->send_io.pending.count) < sp->send_credit_target ||
-		sc->status != SMBDIRECT_SOCKET_CONNECTED);
-
-	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
-		log_outgoing(ERR, "disconnected not sending on wait_send_queue\n");
-		rc = -EAGAIN;
-		goto err_wait_send_queue;
-	}
-
-	if (unlikely(atomic_inc_return(&sc->send_io.pending.count) >
-				sp->send_credit_target)) {
-		atomic_dec(&sc->send_io.pending.count);
-		goto wait_send_queue;
-	}
-
 	request = mempool_alloc(sc->send_io.mem.pool, GFP_KERNEL);
 	if (!request) {
 		rc = -ENOMEM;
@@ -1229,10 +1235,21 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 		     le32_to_cpu(packet->data_length),
 		     le32_to_cpu(packet->remaining_data_length));
 
+	/*
+	 * Now that we got a local and a remote credit
+	 * we add us as pending
+	 */
+	atomic_inc(&sc->send_io.pending.count);
+
 	rc = smbd_post_send(sc, request);
 	if (!rc)
 		return 0;
 
+	if (atomic_dec_and_test(&sc->send_io.pending.count))
+		wake_up(&sc->send_io.pending.zero_wait_queue);
+
+	wake_up(&sc->send_io.pending.dec_wait_queue);
+
 err_dma:
 	for (i = 0; i < request->num_sge; i++)
 		if (request->sge[i].addr)
@@ -1246,14 +1263,14 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 	atomic_sub(new_credits, &sc->recv_io.credits.count);
 
 err_alloc:
-	if (atomic_dec_and_test(&sc->send_io.pending.count))
-		wake_up(&sc->send_io.pending.zero_wait_queue);
-
-err_wait_send_queue:
-	/* roll back send credits and pending */
 	atomic_inc(&sc->send_io.credits.count);
+	wake_up(&sc->send_io.credits.wait_queue);
 
 err_wait_credit:
+	atomic_inc(&sc->send_io.lcredits.count);
+	wake_up(&sc->send_io.lcredits.wait_queue);
+
+err_wait_lcredit:
 	return rc;
 }
 
-- 
2.43.0

