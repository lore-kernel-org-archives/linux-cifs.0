Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39FF2C0F65
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744708; cv=none; b=rFogVKFYHGtGxtHiOZaC/Kqqw4sTrJiFBXNze8NnJ0z9ctZ3TBTrkZhVU7xXxSm3kl6G1INUGf6ihWzdfeiQV6BtbSADUSYptz+ezaxxo1sDu190ryi9O7KMfPv6g+Wg4mjPzPRTSFz0cK8AFlJbEptGrzY/pxTx0z2o0hMzkBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744708; c=relaxed/simple;
	bh=XXyBM++HIPcYxUl257dGkYE8L6Fy6TdBQfCDkxyXObc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lnL99TV4FU/XMyNcN4/oWaiSdiU/DIh0VUcnmc5KWGsUR+JiBOG9jAcCi2q99twIX3P+7PD4eo9i7WjObongLZlLz1Kql7o1BSFbuKqvA6Hu3VBgtzztF01cClYHXzjBJuTEawAYjopQXA2V1i6RsFzQP3bOwdEuUb/64bbYNmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=pO9q8OJb; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="pO9q8OJb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=L8FTnyEHkZ7qfPqM15XDKUFuftXacxejlrWlqNb7SNs=; b=pO9q8OJbZnaXK5wB1VZbSPJcBV
	qRHwDOtHxst5NXNy69EbumEoHiVQ3AD3xW3QflyOq28w9XQCtK05XRYlscRNMYk83s4C8Qn6MOTiJ
	d3xjCD+vdFXRcT20+NEEOKVaVeOZH31fwf06TXaYCjmD/ALcY1w5ag2KD+owivHsr6+FH/Zvnirtn
	NRz8Co8sD+rdLRJY+umVwvtljdsZkSlz/gXE4fOeDtCU/9kl9hmMV+1Sy0RWx6YgfoQ73PHe+a6vM
	3Usp6PbPMSh7Fc38zqBIrm4s/22Kv5Pox6225fqsaF+40oVcyAEQDJuDVH4bKZJXevTCiW4bRO6Sn
	3k4dRJJJWtlamdoC+aK+mXM2VjsQslWuiBRnrBLLeog/WRiOwPI9wDC4FGHOiv3+7Kr4wmNukudYK
	p6/qGk8Bi5NhZ8W5PAhqQ01HpS/2Z+ZuktN/MpuhecwAiHhKXmV8SIMIyndJWH37hkeefJwLWYWI/
	+tQ1QHrjT2dIiYRuQQ2RabHY;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6HA-00Bcd4-0g;
	Wed, 29 Oct 2025 13:31:44 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 092/127] smb: server: make use of smbdirect_socket_prepare_create()
Date: Wed, 29 Oct 2025 14:21:10 +0100
Message-ID: <f4ad4a6c9da518220174ee41e1017635dd53946a.1761742839.git.metze@samba.org>
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
index 9bf023b797ad..bcc584884f29 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -397,20 +397,14 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
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
@@ -423,6 +417,18 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
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

