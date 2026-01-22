Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61401371050;
	Thu, 22 Jan 2026 17:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769102346; cv=none; b=uweCQ/jO5BqvpDXaAHltslHfBD9LMAN4B99pXX0TBtHBCFfSPQP5bvtD0bWSk9R1ovq3NPaHkHJz8hvJbhTOueKaN6YF5FrgX3REi3m6BrGuh6jpp28yYqlMq9DpoCzVrkXE/WHdCmH97s/xoERfxI5hZ+6mjDSgd93XneNYJ/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769102346; c=relaxed/simple;
	bh=/C6JO1rW291F/COModVj/B9OYYWL+s6oSPojcMpq6EQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOlJjbLG3CgElNQdqnFEVQYlx1CLbGGixsfKpikxDb35/PT2nI+57aErUYndCudxosEWVwRRbp8XcIAVRIG7NSaNjI8XJSzAiOUPGkHftpXNVPtKAKvabq/1pgJ6yRM5fzytrBK5bwY8ACe8XZEUQkVGLaBY1gHt851H9B0K+90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=3/S4kyfj; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="3/S4kyfj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=fB6hn63mLLzO6lL5KJV3hGVI3in2m996tptpChguW+g=; b=3/S4kyfjLvY8viTPFoQBmDHFQW
	C+5EmBHVyqnuoMUQvLd39XVzTWJ5xIVU3vNzUMU3Dz6jvWshrQtMaf/q6UTzIHTGqrl6bGyEmQPDA
	1rm9CdUr+Ogdplo61/78JLISTQ7gyjORb6ic6HxgqKNlbuBEhOAOMzW4sods4Du8ZBHsS8q0VaTlg
	cuU3P24ap9K0W1O2IssOtzKlYsv9aeAUf3uCEaTfo+gQ6V1e5qETWL0oCj/+FuScdNk4uG7kgWwM4
	p37itQ7Itk+EiDqEqFQY1DjPKRyrdDctZRoimXQDlWp+nTrS1Bc4s1KCR2TSOE2sFJ+GI8OXyRePs
	6opiPaq4WpGH27hucN2eVniN5CMfjT1CEAX+7giwxja/I8T82t46qrsD4htrW6VN4LtqJOM92OrGF
	jyyGkLu52DjTAUTtBhku8OdyaF2kChEOS/TPNnH5PXRpLyQZIH3/Qit0wKpQNYn5w3xElf4WimoWD
	4b0TZWFnZ2yR13t3zLmPV9mi;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1viyKV-00000001pyA-3lkr;
	Thu, 22 Jan 2026 17:18:47 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 17/20] smb: client: make use of smbdirect_socket.send_io.bcredits
Date: Thu, 22 Jan 2026 18:16:57 +0100
Message-ID: <7f702293a1033e642c288e5f9f87b70741bb85bb.1769101771.git.metze@samba.org>
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

It turns out that our code will corrupt the stream of
reassabled data transfer messages when we trigger an
immendiate (empty) send.

In order to fix this we'll have a single 'batch' credit per
connection. And code getting that credit is free to use
as much messages until remaining_length reaches 0, then
the batch credit it given back and the next logical send can
happen.

Cc: <stable@vger.kernel.org> # 6.18.x
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 58 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index ef3b237bccc1..dbb2d939bc44 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -657,6 +657,7 @@ static bool process_negotiation_response(
 			sp->max_frmr_depth * PAGE_SIZE);
 	sp->max_frmr_depth = sp->max_read_write_size / PAGE_SIZE;
 
+	atomic_set(&sc->send_io.bcredits.count, 1);
 	sc->recv_io.expected = SMBDIRECT_EXPECT_DATA_TRANSFER;
 	return true;
 }
@@ -1214,6 +1215,7 @@ static void smbd_send_batch_init(struct smbdirect_send_batch *batch,
 	batch->wr_cnt = 0;
 	batch->need_invalidate_rkey = need_invalidate_rkey;
 	batch->remote_key = remote_key;
+	batch->credit = 0;
 }
 
 static int smbd_send_batch_flush(struct smbdirect_socket *sc,
@@ -1224,7 +1226,7 @@ static int smbd_send_batch_flush(struct smbdirect_socket *sc,
 	int ret = 0;
 
 	if (list_empty(&batch->msg_list))
-		return 0;
+		goto release_credit;
 
 	first = list_first_entry(&batch->msg_list,
 				 struct smbdirect_send_io,
@@ -1266,6 +1268,13 @@ static int smbd_send_batch_flush(struct smbdirect_socket *sc,
 		smbd_free_send_io(last);
 	}
 
+release_credit:
+	if (is_last && !ret && batch->credit) {
+		atomic_add(batch->credit, &sc->send_io.bcredits.count);
+		batch->credit = 0;
+		wake_up(&sc->send_io.bcredits.wait_queue);
+	}
+
 	return ret;
 }
 
@@ -1291,6 +1300,25 @@ static int wait_for_credits(struct smbdirect_socket *sc,
 	} while (true);
 }
 
+static int wait_for_send_bcredit(struct smbdirect_socket *sc,
+				 struct smbdirect_send_batch *batch)
+{
+	int ret;
+
+	if (batch->credit)
+		return 0;
+
+	ret = wait_for_credits(sc,
+			       &sc->send_io.bcredits.wait_queue,
+			       &sc->send_io.bcredits.count,
+			       1);
+	if (ret)
+		return ret;
+
+	batch->credit = 1;
+	return 0;
+}
+
 static int wait_for_send_lcredit(struct smbdirect_socket *sc,
 				 struct smbdirect_send_batch *batch)
 {
@@ -1338,6 +1366,19 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 	struct smbdirect_send_io *request;
 	struct smbdirect_data_transfer *packet;
 	int new_credits = 0;
+	struct smbdirect_send_batch _batch;
+
+	if (!batch) {
+		smbd_send_batch_init(&_batch, false, 0);
+		batch = &_batch;
+	}
+
+	rc = wait_for_send_bcredit(sc, batch);
+	if (rc) {
+		log_outgoing(ERR, "disconnected not sending on wait_bcredit\n");
+		rc = -EAGAIN;
+		goto err_wait_bcredit;
+	}
 
 	rc = wait_for_send_lcredit(sc, batch);
 	if (rc) {
@@ -1432,8 +1473,14 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 		     le32_to_cpu(packet->remaining_data_length));
 
 	rc = smbd_post_send(sc, batch, request);
-	if (!rc)
-		return 0;
+	if (!rc) {
+		if (batch != &_batch)
+			return 0;
+
+		rc = smbd_send_batch_flush(sc, batch, true);
+		if (!rc)
+			return 0;
+	}
 
 err_dma:
 	smbd_free_send_io(request);
@@ -1447,6 +1494,11 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 	wake_up(&sc->send_io.lcredits.wait_queue);
 
 err_wait_lcredit:
+	atomic_add(batch->credit, &sc->send_io.bcredits.count);
+	batch->credit = 0;
+	wake_up(&sc->send_io.bcredits.wait_queue);
+
+err_wait_bcredit:
 	return rc;
 }
 
-- 
2.43.0

