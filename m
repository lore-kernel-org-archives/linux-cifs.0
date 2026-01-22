Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B374E378806;
	Thu, 22 Jan 2026 17:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769102327; cv=none; b=VdGozk8BFdIUtMcYInhfor1OXFbLi793kF9Xaul9tiB+5XDY5ElsE2lvWyzcKSihdZEnXgN7xBVkmBLFMMYYWXzIS+9V4cgG2sx+2LLpUukdPzPzFzfNoO55GWwYXN0BXMjmK5G87h5MRY2xGepMIfLdEG3Bj9TAlwuNCYiG0iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769102327; c=relaxed/simple;
	bh=0zyHZNMXLx+4tQid41uWinN2pDmj3fIP8mnd/z+E4Ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MkSA6tNB6zehjQtJBogof+AGWwto1nd19Zn+p7loBs4hB9Jwo1u5u9iDwJwdQuG/azdAEKTYHJH0oST89FOoivcpKwD9oOdnzmGlGIuNtxkDLNmgCvCCarUT724yCIGOYMgl8F5R7jKy+i2WDrXNAB6NTOCR5BOCGWJmEjME+WI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=fWb/wT/r; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="fWb/wT/r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=8ELjeOy9TCtrZDUWgJaY3WV0ZLvPCRBiivQWKKLXXmM=; b=fWb/wT/rg8R6QnnfuxMBAbe1im
	4C7peMDRpXs9FZpnbQsJA5nzoR05WWVOZdqmsVgw+igZgtPxslUoVJNr0TNzlHZBlccTRiXAT91wK
	zBdCoFeWlU8knKq1NV8uJmQIMfSEZs4MwbtN7NV2LasBDBwb8wohi4hyFwrGKofgE7dTdaitXjBKL
	QZXmzeun26cz7CdG+wBRNE1zLM661cA5MPlrZouoiimzAP5PUrGvE+C4ahxeTlvDPiMBsG4cE8ghr
	W4M5VUDqwiIoLTBJV6EHrV/0KbYgUilM82oknCa8r2OMEIi2KtE/nb/ATWo/Rh5okpWqiGeiInZ06
	Ikm4xdzB2BdVyYhp1cZfu+3o+ZHg+IRbo9PJOUozOA6PzoJDCtRgyq+Zs7PRPvZtv9HyTrU9wYHCz
	Z1sZ3m/sCK782fWq6+htLUpcLzdFyQyq4c/HHl+y54/J9UGm6pAUjZfvOACghrFLaIJ/eu0dwBbuI
	ihnPZRiSPpklo1rw/8gpPVzw;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1viyKF-00000001pv5-05tu;
	Thu, 22 Jan 2026 17:18:31 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 14/20] smb: client: split out smbd_ib_post_send()
Date: Thu, 22 Jan 2026 18:16:54 +0100
Message-ID: <553402ec2f0b0b450f69c0547e020bde50d87972.1769101771.git.metze@samba.org>
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

This is like smb_direct_post_send() in the server
and will simplify porting the smbdirect_send_batch
and credit related logic from the server.

Cc: <stable@vger.kernel.org> # 6.18.x
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
index 405931ce3978..75c0ac9cc65c 100644
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
@@ -1280,12 +1287,6 @@ static int smbd_post_send_iter(struct smbdirect_socket *sc,
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

