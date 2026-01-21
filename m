Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233933559CD
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 19:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769025129; cv=none; b=uOa/R+MQusNtARlGW19x6DoLC1ZrsJChNSsvjjeAU+8ReXrJblfjOq9ZqOrNuzUcFyXq27CUx4n04dFUQE1rFjkU6G9qzaOngEsfVG3SwFfLI6o8cZTU9tLzkJFdNnPdi8KRHKtc2wVuqsbDzMwFgyZ+ScH3/PSdIaxEI1OQ8OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769025129; c=relaxed/simple;
	bh=id5Ga/ffSiRaXTrTK2fHx5kDivs//M830JAsREzV3r4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMic/21boWYiO8U+vEf4OEhHZ3+HLHS5hUQUPUQGIEzWc8thflybnuMdEhNUHXL8Ux+39py2HXOd+ethWK1BFbh8TVW+WO8teUhj2U1YYiE+1eMxxXrhZSPcd84axQaTreeQFeYWz6OKdnTp8Uc2nlh90f/YyxORuFwZsnQKufs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=g9xAhGmj; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="g9xAhGmj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=GPOLJ/nIa4WFBZEZvTdpdB9104QHzuNKtn+XcgsNCEc=; b=g9xAhGmjsNJBHz0Mb9Lfg3AGd3
	N7b/qD5rBbVd2i4YekW95uZoJt1n6xsvdcltAPEtNRtedpyoAPKPieGzKV9HGYh1aRTr+1G4Rx6Au
	JC4gchTIz6ajeprYiyTbzvOTlCFV7HLuJjtCrMt0tNJFe+BY6iZRn/jiPbXiTva/JTh1nZqjXP1vH
	Doy+Dv61VMHdLxkaZ2w9aaVaqmalUmQtQdX5oK2M82VSC6j9/6ReX4jC0eFF4Vpm5hFNEuVy8ne3Y
	VCVBf+fIbWlB2FGcYeHzgUC+NoanbbbGUQYKlDdieAocFen0N4631ItFlBrKzXUhq0XWgdFVzOV+4
	LpvdLUPpI600F0gabXokt3YrPGKcqaHzo0Tfb9Lf1BtKCV8AMNz1lbsvZolLvZX6KXxXHPztCXIPr
	en0ffC/uiYrvfzbEhimEssm4kPd5OF0BQxHsUWpfLIpLSGpvDFmlUxMngHv/bUSnTFplqWtEuetEZ
	Xb3geispAYa1issOVjGaq28r;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vieFH-00000001e9e-3kD1;
	Wed, 21 Jan 2026 19:52:03 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 13/19] smb: client: port and use the wait_for_credits logic used by server
Date: Wed, 21 Jan 2026 20:50:23 +0100
Message-ID: <483273471271cfa0b443f59cf7eea57d24ea450f.1769024269.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1769024269.git.metze@samba.org>
References: <cover.1769024269.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This simplifies the logic and prepares the use of
smbdirect_send_batch in order to make sure
all messages in a multi fragment send are grouped
together.

We'll add the smbdirect_send_batch processin
in a later patch.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 70 ++++++++++++++++++++++++---------------
 1 file changed, 43 insertions(+), 27 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 7fa0da092f13..3b3d85330bc4 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1137,6 +1137,44 @@ static int smbd_post_send(struct smbdirect_socket *sc,
 	return rc;
 }
 
+static int wait_for_credits(struct smbdirect_socket *sc,
+			    wait_queue_head_t *waitq, atomic_t *total_credits,
+			    int needed)
+{
+	int ret;
+
+	do {
+		if (atomic_sub_return(needed, total_credits) >= 0)
+			return 0;
+
+		atomic_add(needed, total_credits);
+		ret = wait_event_interruptible(*waitq,
+					       atomic_read(total_credits) >= needed ||
+					       sc->status != SMBDIRECT_SOCKET_CONNECTED);
+
+		if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
+			return -ENOTCONN;
+		else if (ret < 0)
+			return ret;
+	} while (true);
+}
+
+static int wait_for_send_lcredit(struct smbdirect_socket *sc)
+{
+	return wait_for_credits(sc,
+				&sc->send_io.lcredits.wait_queue,
+				&sc->send_io.lcredits.count,
+				1);
+}
+
+static int wait_for_send_credits(struct smbdirect_socket *sc)
+{
+	return wait_for_credits(sc,
+				&sc->send_io.credits.wait_queue,
+				&sc->send_io.credits.count,
+				1);
+}
+
 static int smbd_post_send_iter(struct smbdirect_socket *sc,
 			       struct iov_iter *iter,
 			       int *_remaining_data_length)
@@ -1149,41 +1187,19 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 	struct smbdirect_data_transfer *packet;
 	int new_credits = 0;
 
-wait_lcredit:
-	/* Wait for local send credits */
-	rc = wait_event_interruptible(sc->send_io.lcredits.wait_queue,
-		atomic_read(&sc->send_io.lcredits.count) > 0 ||
-		sc->status != SMBDIRECT_SOCKET_CONNECTED);
-	if (rc)
-		goto err_wait_lcredit;
-
-	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
-		log_outgoing(ERR, "disconnected not sending on wait_credit\n");
+	rc = wait_for_send_lcredit(sc);
+	if (rc) {
+		log_outgoing(ERR, "disconnected not sending on wait_lcredit\n");
 		rc = -EAGAIN;
 		goto err_wait_lcredit;
 	}
-	if (unlikely(atomic_dec_return(&sc->send_io.lcredits.count) < 0)) {
-		atomic_inc(&sc->send_io.lcredits.count);
-		goto wait_lcredit;
-	}
 
-wait_credit:
-	/* Wait for send credits. A SMBD packet needs one credit */
-	rc = wait_event_interruptible(sc->send_io.credits.wait_queue,
-		atomic_read(&sc->send_io.credits.count) > 0 ||
-		sc->status != SMBDIRECT_SOCKET_CONNECTED);
-	if (rc)
-		goto err_wait_credit;
-
-	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
+	rc = wait_for_send_credits(sc);
+	if (rc) {
 		log_outgoing(ERR, "disconnected not sending on wait_credit\n");
 		rc = -EAGAIN;
 		goto err_wait_credit;
 	}
-	if (unlikely(atomic_dec_return(&sc->send_io.credits.count) < 0)) {
-		atomic_inc(&sc->send_io.credits.count);
-		goto wait_credit;
-	}
 
 	request = mempool_alloc(sc->send_io.mem.pool, GFP_KERNEL);
 	if (!request) {
-- 
2.43.0

