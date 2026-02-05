Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817353382EB
	for <linux-cifs@vger.kernel.org>; Thu,  5 Feb 2026 16:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770308093; cv=none; b=bY25aYk0NRkNaW6C7mkHBFkDRzSH94PyRTBbDEFjzQKKj8tftOVkF1lerfpGlhR8iXRGrtPOWOemvPoLVTKpYL5HgznqR1l4dv0XfdObn3AkJL8zbC3NfXhcCGvWYZouwxxUIBCiXIeBssJhmIZaX8Lj1YIarcBLAm/Mo1x8ph0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770308093; c=relaxed/simple;
	bh=oWG/rMve+wgn0ZJzdr9e/SN6oGIye22icKKha+rdY7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RL3SryiU9wxvV1GFeAYxmDiMs6YSasZmkeFqcBYqyNX1/mGsSR2Wp3+e8NN/7QKd2/ZYCMA9ByVUbPeFQ0t8J7aAB9cqfRtrqvGVzSTyVCz8SI+uPjh0YPQyKBkzHw9E1Ma+YK0NI+6Cg/zoS/asUV2BhwtjCsF67bYBhGl/D/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ow66QOyR; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ow66QOyR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=RFKStCJZsASx65u2G/IUSqzCYQWNBZAs0nX6YYBICSM=; b=ow66QOyRER68urPktj8xrbTfvl
	jIHBWE/tLamXd4AQlHrJpNk1rIhl1DDEVHSEPf3yoRGZa/MSvQ4GmtqHneJ2cQYlDDndD2dvfcoco
	5JS+B+BJ3O3SP7J7qTmhbWr+up45OHxajm0mhs+vL69xlK6iartn3x4//agehWerjcGB2Dey5p88S
	WvNyk4inAKO7IPAK639HKdzEnpJrPIfRkPpoDDntBsCf0Y06cIFG/2wS87Ast2EwbWBEMzTpHQVNs
	LB6L/jJHbcOW8IIQo3cN5KmJeHhLe7sH7lC+tIbh+VZaAJnZYM3uTGDEpmnADAHC2lJWvh8zX0QPw
	7D9eg76Vu8vxwRX0YjVPp/VduOXpmKKdCXXxZo+wamxqUQMSVLv72sQTtRdXgaBsh5KNTcle0kWVu
	Vuz5OpQn9InjbT9cNfShwhRvDJwE14KB6Xc9VOmgN1ccgQsT9UYeAu7oXqjWFrTE81fjIr69MbiMC
	UJxJGg5eYanpsc5RWaovjT/V;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vo20H-00000004THv-3Qtd;
	Thu, 05 Feb 2026 16:14:49 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH 2/2] smb: server: correct value for smb_direct_max_fragmented_recv_size
Date: Thu,  5 Feb 2026 17:14:15 +0100
Message-ID: <2e28ef145e4d88216e52f156ad592085adc55e61.1770307237.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1770307237.git.metze@samba.org>
References: <cover.1770307237.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We should make it clear that we use this strange value
instead of hiding it in same code flow.

Note this value is mainly ignored currently,
as we do the calculation again with
the negotiated max_recv_size in smb_direct_prepare().
So this is only a cosmetic change in order to
avoid confusion.

In future we may change the logic and
adjust the number of recv buffers instead
of the max_fragmented_recv_size.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 42 ++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 188f6c9c07d6..fb36fb9d5214 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -70,8 +70,23 @@ static int smb_direct_send_credit_target = 255;
 /* The maximum single message size can be sent to remote peer */
 static int smb_direct_max_send_size = 1364;
 
-/*  The maximum fragmented upper-layer payload receive size supported */
-static int smb_direct_max_fragmented_recv_size = 1024 * 1024;
+/*
+ * The maximum fragmented upper-layer payload receive size supported
+ *
+ * Assume max_payload_per_credit is
+ * smb_direct_receive_credit_max - 24 = 1340
+ *
+ * The maximum number would be
+ * smb_direct_receive_credit_max * max_payload_per_credit
+ *
+ *                       1340 * 255 = 341700 (0x536C4)
+ *
+ * The minimum value from the spec is 131072 (0x20000)
+ *
+ * For now we use the logic we used before:
+ *                 (1364 * 255) / 2 = 173910 (0x2A756)
+ */
+static int smb_direct_max_fragmented_recv_size = (1364 * 255) / 2;
 
 /*  The maximum single-message size which can be received */
 static int smb_direct_max_receive_size = 1364;
@@ -2531,6 +2546,29 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
 				  le32_to_cpu(req->max_receive_size));
 	sp->max_fragmented_send_size =
 		le32_to_cpu(req->max_fragmented_size);
+	/*
+	 * The maximum fragmented upper-layer payload receive size supported
+	 *
+	 * Assume max_payload_per_credit is
+	 * smb_direct_receive_credit_max - 24 = 1340
+	 *
+	 * The maximum number would be
+	 * smb_direct_receive_credit_max * max_payload_per_credit
+	 *
+	 *                       1340 * 255 = 341700 (0x536C4)
+	 *
+	 * The minimum value from the spec is 131072 (0x20000)
+	 *
+	 * For now we use the logic we used before:
+	 *                 (1364 * 255) / 2 = 173910 (0x2A756)
+	 *
+	 * We need to adjust this here in case the peer
+	 * lowered sp->max_recv_size.
+	 *
+	 * TODO: instead of adjusting max_fragmented_recv_size
+	 * we should adjust the number of available buffers,
+	 * but for now we keep the current logic.
+	 */
 	sp->max_fragmented_recv_size =
 		(sp->recv_credit_max * sp->max_recv_size) / 2;
 	sc->recv_io.credits.target = le16_to_cpu(req->credits_requested);
-- 
2.43.0

