Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6636620C48A
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094199; cv=none; b=ZJAEqGKTNe9HyBihRGnOEujOQlQNXqoLaVDwNzaSqMYyKhJb8Gqjr6W9/wGpmeNUlJUVCNprP+aFAfwD7YvDYNkbu9HMxai2+sJz/V3FxTaYzijxnnjuYMNxyqciJYnZKMiZ0Ljfiz1LyNe0IaZMroMOPrpZIP3dGflD82SwjlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094199; c=relaxed/simple;
	bh=9sYLPwNU6hVXZXbLZgpUwLqHdIMk0kSfVSG+WCFvzbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pid0q4wB4h758fYSihGFpMDuRC1G/wEyEwmSDZ+SjStFETd16X5aoEk8Kh2FGTQBIUDC8vWMkQtBurhtUEoguE6kULAr1cOS8/5ajk7GMrq7rIPgOXdbilQpoaqjMXphpq+sP05UkgpG10PLyce08EwQu4KrUfa3fb9n7bwEOzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=LjGYFnVP; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="LjGYFnVP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=qXHqg7ppch+jhJwBPUt0ingO7OMwaIkqa3mzwdOtCoU=; b=LjGYFnVPdvtzEGMEkxzBNBX6b/
	uKjvmv+SrdUMOzxGRMz0ZbpIog5vrwxxOklP0WSXt/qPrd7koPbXwnK1auGdpCypQYzxrcdJ/d1VX
	pnfJEjKjxirWfLyP2c9JH9KliFiPjcJTNXcClhcRv4I0gPTlny28LXOZvx1EaS5AJxOKfhTmi1ENg
	eQtYSQzmEXwSfEqPYgWUu1e2bO+kjpyF3JNWuA5rJJ752unWJVcXILV0COekk8D9DspnTkmspfsBI
	Di72/HlTjAhq/dqT8rFagqGmsouJaVaNJHshNd4tmgo0UoS5hl4J78tfFaxG/XtqyvtMQ3eAZ/wQu
	+qQlqNB2l8pHLG1QFoKCutVMqjBEd+oM5tWIrlAucMJRubWv3t5x8WpxY25OHawBpFKSZ1lp/sb+v
	E7QT3LxqwLToddCLw0V9JI2jR5VgdWBrcnE0ODtOfENkMh0GtbPMq2m/+x1+A+k4oDN89wDAZAiG+
	H51nbz4jpPmptHtJMo49hy03;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxRD-00Fdoc-1G;
	Tue, 25 Nov 2025 18:06:51 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 080/145] smb: client: make use of smbdirect_connection_recv_io_refill_work()
Date: Tue, 25 Nov 2025 18:55:26 +0100
Message-ID: <39fdc04791bedb500b411447c3016237529877f8.1764091285.git.metze@samba.org>
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

This is basically a copy of smbd_post_send_credits(), but
there are several improvements compared to the existing function:

  We calculate the number of missing posted buffers by getting the
  difference between recv_io.credits.target and recv_io.posted.count.

  Instead of the difference between recv_io.credits.target
  and recv_io.credits.count, because recv_io.credits.count is
  only updated once a message is send to the peer.

  It was not really a problem before, because we have
  a fixed number smbdirect_recv_io buffers, so the
  loop terminated when smbdirect_connection_get_recv_io()
  returns NULL.

  But using recv_io.posted.count makes it easier to
  understand.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 41 +--------------------------------------
 1 file changed, 1 insertion(+), 40 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index ee753f6dffd8..68b35f541e7f 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -380,45 +380,6 @@ static bool process_negotiation_response(
 	return true;
 }
 
-static void smbd_post_send_credits(struct work_struct *work)
-{
-	int rc;
-	struct smbdirect_recv_io *response;
-	struct smbdirect_socket *sc =
-		container_of(work, struct smbdirect_socket, recv_io.posted.refill_work);
-
-	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
-		return;
-	}
-
-	if (sc->recv_io.credits.target >
-		atomic_read(&sc->recv_io.credits.count)) {
-		while (true) {
-			response = smbdirect_connection_get_recv_io(sc);
-			if (!response)
-				break;
-
-			response->first_segment = false;
-			rc = smbdirect_connection_post_recv_io(response);
-			if (rc) {
-				log_rdma_recv(ERR,
-					"post_recv failed rc=%d\n", rc);
-				smbdirect_connection_put_recv_io(response);
-				break;
-			}
-
-			atomic_inc(&sc->recv_io.posted.count);
-		}
-	}
-
-	/* Promptly send an immediate packet as defined in [MS-SMBD] 3.1.1.1 */
-	if (atomic_read(&sc->recv_io.credits.count) <
-		sc->recv_io.credits.target - 1) {
-		log_keep_alive(INFO, "schedule send of an empty message\n");
-		queue_work(sc->workqueue, &sc->idle.immediate_work);
-	}
-}
-
 /* Called from softirq, when recv is done */
 static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 {
@@ -1362,7 +1323,7 @@ static struct smbd_connection *_smbd_get_connection(
 	mod_delayed_work(sc->workqueue, &sc->idle.timer_work,
 			 msecs_to_jiffies(sp->negotiate_timeout_msec));
 
-	INIT_WORK(&sc->recv_io.posted.refill_work, smbd_post_send_credits);
+	INIT_WORK(&sc->recv_io.posted.refill_work, smbdirect_connection_recv_io_refill_work);
 
 	rc = smbd_negotiate(sc);
 	if (rc) {
-- 
2.43.0

