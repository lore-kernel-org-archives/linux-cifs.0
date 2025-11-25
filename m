Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095842264D3
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094921; cv=none; b=CBn6J9XzbfWHgsvpzXFnUwEREoxVaxx3OHY+UvI7HcI0ZkooAjMAy9UUqaia/X9A/NvsvTBNKlzV2Rn7A1R0sCjuxI1SEo1+husDEEA5wWHNp8ypwem4djoBGj8mpe7H25D5J22O6frXRhRvl6cI1mcVhZ25UPjAXFcexB23Igc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094921; c=relaxed/simple;
	bh=GtSeGs1RNJDKEPmEUk4lsgPYrnr4WWHtBC2fYJUsXag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dsv50X+3AaBQaOIGLIJfHVf0jvXtWOmOC6/CJfRIkNBc5zoBeMQL6f+pNF2DGJSdk9GoPAbgM3uPx5pOo7Tj6PAI9d4l5cjNAmWVTFmtTQrGvCw6+M6+8p2BE1CYUlulGUEJ2HW2wQ7b5hm0z7IL9ck9o7F4oP/drhP5SV6joCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=pBJvHpyU; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="pBJvHpyU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=hmRwZUoQ/EaIceqRQmxEW7bZGegj6eJg/5jjhUI7fF8=; b=pBJvHpyUrL7cGep0s1mDRMz02X
	BFf5wuCn27JgUmnHZ4gN/pLpwhXPf9T1NtReNeGvI1TSFBAu1kZU1cLG7ZfrfmZmOgE0JWGofdneo
	6Yo8uC0P7xJqLaKRFD0EbJm1zhDCNVE1MYzNdXdv/qifS0oNVnf2eHm7F2hoGPkj58U8FBQRPgiv7
	giWMnV3qnuZkZIfaGwfUwk61h5fivfVTwD07APEtqywkUNJS1Ye5Qk1cFfMflAlMTs4rX/rBBv1Fz
	X2i/78iK1njEo4DYSbAwjjFMUnepzjhECvqisu/NYhI9yyIK/lv3tMogbO2EiDXadD1LKtiqBtiD/
	qTokn/AuTj+hgovxGoKIrRN8/jKksgRitfuTR7d68ZYMvoQcm2SZm/iwkszlf39pb9q1sFVJ+kI9d
	0UNQyGFgN9IQJw/lkJr0oAOjaDrly0rypcRQyFJREp1wrXW5gnXNCwMD/EE1jERPYbSnFVTSQ2GH9
	CnZGGtWmKGDfSha87bNXwMtB;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxWv-00FeUq-0a;
	Tue, 25 Nov 2025 18:12:45 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 111/145] smb: server: make use of smbdirect_connection_qp_event_handler()
Date: Tue, 25 Nov 2025 18:55:57 +0100
Message-ID: <39f6ebba097d99b06ff068ec361e0887d92a9a2a.1764091285.git.metze@samba.org>
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
index c8839d73a7a1..4da8247337a8 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -1523,23 +1523,6 @@ static int smb_direct_cm_handler(struct rdma_cm_id *cm_id,
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
-		smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
-		break;
-	default:
-		break;
-	}
-}
-
 static int smb_direct_send_negotiate_response(struct smbdirect_socket *sc,
 					      int failed)
 {
@@ -1888,7 +1871,7 @@ static int smb_direct_create_qpair(struct smbdirect_socket *sc)
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

