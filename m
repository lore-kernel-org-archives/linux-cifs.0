Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BC627FD7C
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094716; cv=none; b=rdnz+jLyngRN/afXVYpola0xHvIkCRHAF3aNYg1X+YBTC6BeB9F5GEIQ7HWsr3T740isKGtbg4v/mgqkMm40JfPZnkAv4PjgnJno/ww1wH1WoKsCHApeFjB1XDAkZanFWyq6jVSxRAPzdKAPh8YiMpco0NWkz4AqJ+ML7uPcX0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094716; c=relaxed/simple;
	bh=2GEKmvKOy97K9/eO3bVTFjK554BnYh8ksyr7527SRhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZKymlVlSRRqBQsTSsBDUbM6ANFsxPm1SspLKoiEMtS6qJn1MJATKl4UFQbTrwglh0G4ZYr/3ZKD8BZKRUNcxo4p1yqwHmHumMJOV5cZSHPuwIb8FQ3RfzsphX9qDg2yDDwggxS4zj2pIjqyhY1dIvcX2vSXtzccxLCF63E7u4Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=C8GeLNTz; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="C8GeLNTz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=BBlgRAmIgpvsORmw7/6n6m0OSdIW8edI3Jt9yySA3ts=; b=C8GeLNTzSuzr6GDJdRasGpW6MT
	tTpeZPmJqB4iMD/Tf6QuzA5mnjqWR4TGAXoX0Ie7Iw88bBrsbnJEbaopLFgO495ybGyH+RaGvUGd+
	D/sZ3vUeDz/TYVXDTzQa3VLnEPqqcSP5GA+IZ41WGkrX+1xCeVQMsBFUwT2XzcWEPGPFjpaH2gNaX
	2mT5wydb+4tUeXxpLDKbQHbR56pirEmYHSh/4RoFcF/WpL7MP+U9LDYOnymqbn5RnTVrCYEDA/2i3
	oMk581DlA05Mg0sDfzWEioYvKc1kWFLzC5i0SwIlwMuoqg1cxq0uNJPoOx+DKMTyVlpTEX3dZezvk
	SBbLLc1DIfVMX/BFzlkYdM20r5+Z9o+JL9LzyK3dOuQOhRAJ1TU6JrfrobFoUqAMD+GHHK9EzADwX
	JYncX/CFLG05fWL+6fLAoV6noERs1TwWXd2KnUBU8gqhnS5CXWHjOBhs3o9NL8HMGqDeAqMkdIEwF
	2VDDZ0ghW4/wln1WDIo1D0gw;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxUe-00FeEt-0B;
	Tue, 25 Nov 2025 18:10:24 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 097/145] smb: server: make use of smbdirect_socket_prepare_create()
Date: Tue, 25 Nov 2025 18:55:43 +0100
Message-ID: <56a65a77045d989742acba2e8ff80ff8438894c3.1764091285.git.metze@samba.org>
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

This prepares the use of functions from smbdirect_connection.c.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index d656dbf9f7ae..343e2bd7ee2a 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -404,20 +404,14 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 {
 	struct smb_direct_transport *t;
 	struct smbdirect_socket *sc;
+	struct smbdirect_socket_parameters init_params = {};
 	struct smbdirect_socket_parameters *sp;
 	struct ksmbd_conn *conn;
 
-	t = kzalloc(sizeof(*t), KSMBD_DEFAULT_GFP);
-	if (!t)
-		return NULL;
-	sc = &t->socket;
-	smbdirect_socket_init(sc);
-	sp = &sc->parameters;
-
-	sc->workqueue = smb_direct_wq;
-
-	INIT_WORK(&sc->disconnect_work, smb_direct_disconnect_rdma_work);
-
+	/*
+	 * Create the initial parameters
+	 */
+	sp = &init_params;
 	sp->negotiate_timeout_msec = SMB_DIRECT_NEGOTIATE_TIMEOUT * 1000;
 	sp->initiator_depth = SMB_DIRECT_CM_INITIATOR_DEPTH;
 	sp->responder_resources = 1;
@@ -430,6 +424,18 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 	sp->keepalive_interval_msec = SMB_DIRECT_KEEPALIVE_SEND_INTERVAL * 1000;
 	sp->keepalive_timeout_msec = SMB_DIRECT_KEEPALIVE_RECV_TIMEOUT * 1000;
 
+	t = kzalloc(sizeof(*t), KSMBD_DEFAULT_GFP);
+	if (!t)
+		return NULL;
+	sc = &t->socket;
+	smbdirect_socket_prepare_create(sc, sp, smb_direct_wq);
+	/*
+	 * from here we operate on the copy.
+	 */
+	sp = &sc->parameters;
+
+	INIT_WORK(&sc->disconnect_work, smb_direct_disconnect_rdma_work);
+
 	sc->rdma.cm_id = cm_id;
 	cm_id->context = sc;
 
-- 
2.43.0

