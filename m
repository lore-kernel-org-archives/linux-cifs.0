Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E4E331219
	for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 19:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769025113; cv=none; b=eoTccy40IAr6SQkKwtUupAQmd2kZBgag+cxYoB4YqVImvX361bhlGrREFVSQuQCwyrWMfp3NZOjRYa9Sx961gQXFEldt83y3iwbrT2jg2eivisrSeEEkiYJ148D2oLK1tkH+II+V9EAMhPKP/IAJ4QMtVW2mow0Wwn+8kbB9kiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769025113; c=relaxed/simple;
	bh=zvfBSqzWdMJxQB/NtmzTyuilF3mISA5qKXGjBfYO6kA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=inERuHu1yC3OPPayM9ja93ZjT/boGq3IKnxIGA9rF0nOJP8zm79s9ZIvJvToR3lO+0ko1HDG5l7ESuH4jeF5Kc9hSCsCYAJGYVIjBoXCwGehubHABoq0hWrE6pIqxangA3xNAV56wCVKPmWqIkEtzorJwSgTrLm2KTfalwhNBLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Ki7iVQif; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Ki7iVQif"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Xge18jOfHry7lIFiZsNCjADIj2Kb1EH5QrsdXKSoAss=; b=Ki7iVQifVgHwAD9ZV6VFioE8da
	8uGi1cTOaX8nCgid0TDdrDrc4XfQrqrNUrdaapC2p4sAj9XOCO3PPnfmmsk8zngleP0lUPgrde2N5
	kxcdPMB74DXYWproyd8zlPjvQI+fy5Pd4+ZlKaCBZIOC3HAnERkX6gXt2IPHeZMqOJQ3DwRJ+7FDY
	5wtM/I9F/sFkwCqixjdq13ebm5NPjAF+d5lfqh1k2dafxzCfd418cdl+2EbwLn+N9RRxsmq59yOuC
	X0dox/VpN4/CPTFW+/pNtOjxBESJB5GcNvUUpIWuWfBGIyhaTrYHt9+HKAF2DdeXbfV0xS7NWZfNL
	f0SgeGbNxdrfh0IRs19mJlvBvAS7JwDixiQD9MyrwExIXItVydJkCMxkTDGpWbZpW1EE37q/TeJ2C
	DDAwHQYANeYbTtblsOuzWkcSgdn0RvoNT35dLIHDD10ZHU+DAXKPEhAS0eIw89DAIy+cnKI7QNVlz
	HcKafJxb9P7r97NdOkjoQ+N5;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vieEz-00000001e4g-3wjM;
	Wed, 21 Jan 2026 19:51:46 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 10/19] smb: client: let smbd_post_send() make use of request->wr
Date: Wed, 21 Jan 2026 20:50:20 +0100
Message-ID: <89ba36dd68324c70f72c9df433a3d04ead254cdf.1769024269.git.metze@samba.org>
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

We don't need a stack variable in addition.

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
index 826fe7cc6ab6..dc1e6656051a 100644
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

