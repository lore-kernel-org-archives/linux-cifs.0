Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF5B13AA2F
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744791; cv=none; b=ekeZ8bq8fnvd7KjIOw6D4gJdrjL6hGQIoMkUfColWOuZUMDrBfg39RdU/zjGOswxKhdTb2eCsI+/4JZBEBj2FdPgxEq1ZeTrKK8EvEkkQmn0Ny9PPhoFuPiKfyCV8oactf7TNzu0icbZ9Bu+lLAzDWOxUiEEtvLZ9tWMsBVPMIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744791; c=relaxed/simple;
	bh=l+UPt/Qqzcj9BFgxuNzf9hIos4IWONuYoxYnp28/T0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srIe79bv51dwYSg84vzL0pDdx0dHTXkEfNDUzTWKubtOjAO0rH8RG/2oZ41qiSMJR8oB4rmOfUvWgqApOBdu4iedv9sTo8NF9iktUbzo2glskrvg/UI7kMZhv6d2h/0FPLfrQ+5PV8+g/pjRwvsuCssWtYqO5hAURMVrA8CDDCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=2R4gz3d/; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="2R4gz3d/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=9SZeRZuBMhokmfuG2hpfqaanzSPgbJAXddn7qMR27ek=; b=2R4gz3d/3Hgxy49liGe/LFvuv4
	jWg6Rt1ZVFIPQl6ZH5g8aD1A2C9hpeB4Pi7hCbK1BKqoWfAEpI2ix06eavcyvQvXyme4M1X0itgY5
	frBF4OVe6wUxOxxxyHK9zpVsBcffMkzCggPTn72URmzPP9HBLvgvtQpQR29Ix/2/fphmdXb1BhOo/
	822FtD3p4wzZSqCtRbeAawXRBEKRT34dKDVVNHUz0XDmjUUq3BV+1p3d2sWVaJ1yCj9fi35ptP8lt
	1NisXep+cD38coMrc6RWHwHzOmQ7OUA2Sla9Qluhvbb8IzIbgZ2s/kYE1K7MQ6Bptg1jtJNYrO7w+
	9lAMD5k5TWDdi3y2DnQ6EsVPJCrH01qeMFo3i8zUSZpb4txCCVcbJCcIQA/Q78Hn0JtrpDwswp51Y
	4XoyjntYkXt3P+9kZXzZRe1s17e3JuHAsd9tKrAo/L+EccohpbCyEWWfwmJAMujFCAMqcyQZj233T
	v/ZK6wHnNm3M4o6CXUVojDwg;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6IS-00BcrI-36;
	Wed, 29 Oct 2025 13:33:05 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 105/127] smb: server: make use of smbdirect_connection_qp_event_handler()
Date: Wed, 29 Oct 2025 14:21:23 +0100
Message-ID: <060d46c9679fe9a675d24eb28a9b414c48e59c9f.1761742839.git.metze@samba.org>
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

This is a copy of smb_direct_qpair_handler()...

It will allow more code to be moved to common functions
soon.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 4e2de2664e31..ef2de6302768 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1501,23 +1501,6 @@ static int smb_direct_cm_handler(struct rdma_cm_id *cm_id,
 	return 0;
 }
 
-static void smb_direct_qpair_handler(struct ib_event *event, void *context)
-{
-	struct smbdirect_socket *sc = context;
-
-	ksmbd_debug(RDMA, "Received QP event. cm_id=%p, event=%s (%d)\n",
-		    sc->rdma.cm_id, ib_event_msg(event->event), event->event);
-
-	switch (event->event) {
-	case IB_EVENT_CQ_ERR:
-	case IB_EVENT_QP_FATAL:
-		smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
-		break;
-	default:
-		break;
-	}
-}
-
 static int smb_direct_send_negotiate_response(struct smbdirect_socket *sc,
 					      int failed)
 {
@@ -1857,7 +1840,7 @@ static int smb_direct_create_qpair(struct smbdirect_socket *sc)
 	 * again if max_rdma_ctxs is not 0.
 	 */
 	memset(&qp_attr, 0, sizeof(qp_attr));
-	qp_attr.event_handler = smb_direct_qpair_handler;
+	qp_attr.event_handler = smbdirect_connection_qp_event_handler;
 	qp_attr.qp_context = sc;
 	qp_attr.cap = qp_cap;
 	qp_attr.sq_sig_type = IB_SIGNAL_REQ_WR;
-- 
2.43.0

