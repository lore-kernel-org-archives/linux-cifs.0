Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2131637A3A6
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744623; cv=none; b=iTOFdhGsFqa4FSaI18yEbGf9A4m8MpFr3MLSJNSlJ5Gp4EThIEYmDLqm7zADsf4ae62fHQvY+czbaKuaYyKo+2/8hpq+8v9u8lR2O54rJrv87M0g+qCDqN6wQ9q25iumGcbPmg1iglYJJt77AYOugTGNkdvIbMaIcd9qw+ICTck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744623; c=relaxed/simple;
	bh=yvxK1FI4CpTgluTuY5hNHrpahB4mghQoJl0Mb83dE4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MxLlNgs6ru4S2LAglAJGvqe2yOqpPQCjtVtnIUMNMSjekkDyuQ57/FvMI23yZizGCkZbV6oU7d7022sUDxAoltXgLxshHEg1JgFmSOQKlMDPxGpiiNHPCLSnGOJlX0QWKDzwbZIcLbJfRuP3bNeAGZ6k9/AOroM34s27e0M/nno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=EUIw0JrN; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="EUIw0JrN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=qYVFIP4D8wpWTdKmc06AXstkxo8olWxGnecaSifkGdc=; b=EUIw0JrNNSxPXnNC1tgaDs+nO1
	BeJ9uTNJJ8Rs6tlbeIwOPH6JvYz5yN6pAnVNPNBxowSBy84xOM9iaEHr+7951IEj9WM7Vq5ZAqhML
	2FlAkaJtJtlrSKS/WYr5IQdGfcqYM3652NpvC1LgHWRtUIaduNaRGAnPpt+6Q3VeJWNSQorxlnkZB
	xGVtf0OAayCBOPsA7oE47MLsHLH78s1mfAX/WRPHV/wdwRZefym9gjkNexL6xK16+R7TICvMNBNet
	nz+40cG9kpbKSw6C9dMF0xkyfo1VbobDVzJ3bw251kwFuk1u9USf7FdMebG3Me8d3q45kInAUJNIZ
	CFeebUndRaYxCfAORhq87rwXUw4CSjZPsjClQLDVWO5wZUlof4o5kiWEuOcnfZmNk9aVV4jOyeLbf
	c0xB9HERpL4WEpRd+GsqXCFK+7p/7RiyEokUwH/H5cOdX6csdAvQhGkucAxyvh+fU9tqd8uTpt/V9
	ImggF4I//SShdVsPE+tNYBB7;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6Fk-00BcNe-33;
	Wed, 29 Oct 2025 13:30:17 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 079/127] smb: client: let smbd_post_send() make use of request->wr
Date: Wed, 29 Oct 2025 14:20:57 +0100
Message-ID: <6464bc9d29a384891701c79c5ab4843e349da55f.1761742839.git.metze@samba.org>
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

We don't need a stack variable in addition.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 2860f9c5502c..e2f93d4af0a7 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -786,7 +786,6 @@ static int manage_keep_alive_before_sending(struct smbdirect_socket *sc)
 static int smbd_post_send(struct smbdirect_socket *sc,
 		struct smbdirect_send_io *request)
 {
-	struct ib_send_wr send_wr;
 	int rc, i;
 
 	for (i = 0; i < request->num_sge; i++) {
@@ -802,14 +801,14 @@ static int smbd_post_send(struct smbdirect_socket *sc,
 
 	request->cqe.done = smbdirect_connection_send_io_done;
 
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
 		smbdirect_connection_schedule_disconnect(sc, rc);
-- 
2.43.0

