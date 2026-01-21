Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F853A4F52
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 19:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769025135; cv=none; b=HND2CFYg2m9EJ0UPfW67oMmDT/95A4FtIdUw6D83PPovI6IHNyDf4Zs1hViKRxDcWrf0ts4wJa4DsgZMrnzlsu+WRwqAravv2hZZmCp16okF+wlZOYJcJRzSuqB8GLRB+GbfT5FazGgjTdpPmxqAHxs84d4k59LKOLyLT2kSXf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769025135; c=relaxed/simple;
	bh=MF6YDZP4ORtQMrtn8k07d9NSjWfdVYDGuL4cHA02QNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PkFdmmv5pgS8Y4f+Z3WQsHw6pWW7lSDCl3Oh3W4f3KkbYAvglqNBzE34dRdd2g/oZeKrIIt5wg6stTffZGK9s3fHx6HGfa3leb/ma2kShImBOechW/1/ar7L1iAdXMtq6eErKgJoI9OvigY4MuKsF39qJIpVgw9GpQkNMwTpztY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=LN9aD9bh; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="LN9aD9bh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=+pv7LN/Y9wvSc3SVV++iCWN+XWv9stLlzFCpd69W7v4=; b=LN9aD9bhFFMY7m7XgLtlyT+hLv
	VFM0l4AS+riupfz4HFe1SuNR3ES1dYjPq/HnlNrX32q0skv3kEaI/tEfU2vJ9+TokhNC8hKQ8tH9m
	oeePkyTSiLGHS36ulwc6GZNhH6mBZtJvvqt0qr03xo7hxWsXbmsKr7Trk6nGQ6jKmbakWaCXe4Az/
	vbuljm2Aqdt/a/V7MLK3EO1sGV0uk9JdRc3lpKtcvMvFV4Hy1Ty7A9ThEJqL7rf1jq/mdza0dfp1E
	gBTMtok5IeINz8gf9VqwmkT+4vPzE+I0psyKE07vlgxwM662D8F/ck807zVHy6lT24KKk5hbzqP05
	Wfk3jFK+Cq0taIK7SRBPULCn5W9jCTzLsy1w1UVxvmFX+UrpeZ9Dje+v2qKsDOnwwmYzUZR9Y+0S0
	DRHqMUCMdg6OzOMhwG2umiQZCCuk7f3EoiPw7NhxaaYf+eJlMyxi5q1SsRXJ1k/iOq4FGg9dp9h5r
	mUrQQPBj+0UcUHcrz+h1Ogh9;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vieFN-00000001eA8-2lcZ;
	Wed, 21 Jan 2026 19:52:09 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 14/19] smb: client: split out smbd_ib_post_send()
Date: Wed, 21 Jan 2026 20:50:24 +0100
Message-ID: <c03354af9f24f6c868ae224d59e399a532129864.1769024269.git.metze@samba.org>
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

This is like smb_direct_post_send() in the server
and will simplify porting the smbdirect_send_batch
and credit related logic from the server.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 3b3d85330bc4..aca3f514e9d9 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1101,11 +1101,26 @@ static int manage_keep_alive_before_sending(struct smbdirect_socket *sc)
 	return 0;
 }
 
+static int smbd_ib_post_send(struct smbdirect_socket *sc,
+			     struct ib_send_wr *wr)
+{
+	int ret;
+
+	atomic_inc(&sc->send_io.pending.count);
+	ret = ib_post_send(sc->ib.qp, wr, NULL);
+	if (ret) {
+		pr_err("failed to post send: %d\n", ret);
+		smbd_disconnect_rdma_connection(sc);
+		ret = -EAGAIN;
+	}
+	return ret;
+}
+
 /* Post the send request */
 static int smbd_post_send(struct smbdirect_socket *sc,
 		struct smbdirect_send_io *request)
 {
-	int rc, i;
+	int i;
 
 	for (i = 0; i < request->num_sge; i++) {
 		log_rdma_send(INFO,
@@ -1126,15 +1141,7 @@ static int smbd_post_send(struct smbdirect_socket *sc,
 	request->wr.num_sge = request->num_sge;
 	request->wr.opcode = IB_WR_SEND;
 	request->wr.send_flags = IB_SEND_SIGNALED;
-
-	rc = ib_post_send(sc->ib.qp, &request->wr, NULL);
-	if (rc) {
-		log_rdma_send(ERR, "ib_post_send failed rc=%d\n", rc);
-		smbd_disconnect_rdma_connection(sc);
-		rc = -EAGAIN;
-	}
-
-	return rc;
+	return smbd_ib_post_send(sc, &request->wr);
 }
 
 static int wait_for_credits(struct smbdirect_socket *sc,
@@ -1281,12 +1288,6 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
 		     le32_to_cpu(packet->data_length),
 		     le32_to_cpu(packet->remaining_data_length));
 
-	/*
-	 * Now that we got a local and a remote credit
-	 * we add us as pending
-	 */
-	atomic_inc(&sc->send_io.pending.count);
-
 	rc = smbd_post_send(sc, request);
 	if (!rc)
 		return 0;
-- 
2.43.0

