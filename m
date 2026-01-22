Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD2434F466;
	Thu, 22 Jan 2026 17:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769102317; cv=none; b=Pweno2/HZEWI59LGTKO0GGFrdlQy9eaH+WBHO7yIkK5nASdsD0LqJxu6OA794/3JWmCR7UO6Vn3Ob6pXzMprB/WBTeT4ciMBANOMw+B7YhFL2Wy9yHAD/rUF4vX4+CfMsX5vhLbM959ZrUg8leWM13uBsBOZ5bQPH1+3TvgRIjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769102317; c=relaxed/simple;
	bh=4AS6etI/id+yvn4TnCWCC0+f7fgIDbO9K5166ySgx9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPLxlecWlMNKGR0bOpHGKKe8gn6ZWnG+m8aHilldK5B824C+RZC2L8sArpcISQfjTPVJmKUesZaGSQjFb4epzbL22d1vo9Fo+Ms2dIqJK9gBTqAf5TBi+lCfOBygC7j1OBtECvEkl9y0m6lrZdxhat58VcB80eNkV5GrWdEzp9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=c7GZkr2B; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="c7GZkr2B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=XJ7BK4KmAhETWUL9nCeoWozjGkk4cBrbdW6JqQf61DE=; b=c7GZkr2Bo65NzC+MU4/VxXhd6f
	xVEmzPFnwL1XJM1jErrLAaLfMF41vcHI+opWaz4HAVK6aZSc+Q+5Yn8EjmY1B4aY76A68sk9MF5Wh
	CzONq7H51WYW/McoAJqxiQXiO0rtF8oc16zqNqOIm43IiyA8JeawmECseHqVHl5fS7OFo+mAInp2e
	s4WZYfXKHCwea42pBUsjXqtl1BSHdCpCaeO9e9fA2k+ECS/EpDlqSLdprEsply9Wiy9u0iJPaHM86
	FEcOco0DdV+iVAl4HfpleUZNK8b96O107Q0B1WOoc3ssD54hpCEKPAfVm4QZCLbVVhL6p937lY/mF
	g0mkoxY73Q3N8s9eb8jLj/GnSYx/1neORe0xMTSObipARMabXWojoxRhChp0lj89zYuBY/zjvMXGj
	smtctU3uQP+4xx1MRsFZ/TurPKuCaQYpXCQA53MzCCRxQhISUCHR0HfHynS0KDE3IXyMImExkbaHf
	lyzaElHKeTu7DFmjsmc1Mdgw;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1viyK9-00000001puA-1GpK;
	Thu, 22 Jan 2026 17:18:25 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 13/20] smb: client: port and use the wait_for_credits logic used by server
Date: Thu, 22 Jan 2026 18:16:53 +0100
Message-ID: <be3023bc8f3267b01a6c10c67c899484a9abfadc.1769101771.git.metze@samba.org>
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

This simplifies the logic and prepares the use of
smbdirect_send_batch in order to make sure
all messages in a multi fragment send are grouped
together.

We'll add the smbdirect_send_batch processin
in a later patch.

Cc: <stable@vger.kernel.org> # 6.18.x
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
index cfbe8ce0db42..405931ce3978 100644
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

