Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98ABB32BF26
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093567; cv=none; b=biY53w1xdepdAsdEaHjB4xUX49rRmRfVNERKdX7xWzIAdQLdr5Zfu4v7dWWKqV1zTjONdCul+gX+CAmme4jxH+0OZiqqd9os8DwdDw0qQPqCsj1vURTz80nDLLLhFDVqUzlMuwXoH/4MEubIhg0XY+qjLRnK7lkiwcsZWLnvqrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093567; c=relaxed/simple;
	bh=51gJ67uVVuA2HOlOF4b4pPx68yUFq6lC2hE8Qk1V56g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBouz4EV4CUDqmmDgx7NBwh4KbeI0/LXzSA4UYedz+lLOr9bgWqPhK6Uaorh25dol4jTmGPHVvOrfA6+OZlFsmikAtnlq7vR3XqFrlOZE1mnDy6+y8aVl1S/GFkDEotQLxAeGTH/+5SFa6Q2Ffh+kovXTI8Gjh5hncBuhsl0JDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=wIjc9+AB; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="wIjc9+AB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=HXvoG2GwCXWzYdNSz7SUOvrjA3WR1SKauRupyhZuMT8=; b=wIjc9+ABPVafyiqLvRHYIo9XzT
	Yxrl2Yd+zc06pRQjUR9vsdUNymTTn23t/QvE81NuDgwtYJpTDZ6XNKAXUXFwcsX6jQlSIkyGCX/jf
	jSfKeigTkQG4fHNlO76H7brZBX0Z1dILxLtKnKaVpcjHX7jYC7pPFMvGdfgk8TpKOr6lI/D3ueRmS
	29FYmC/yFIdI7MP6w7dDQnXXsmnWRUzLyQpnI77MlrCYVttJZrjYYYkYUycxSgW5bc7xOMQ1iip1O
	cIlFP7YpQa07cZgaG3QSJqQ3pPOxhB/iGLAX9TZrpHaWG1aOpUWQhI7W4XOOW264OIq0tF375GEXJ
	/2Ksi+IRqlSoGtGrN1WaVfNeVIXABGxicbLgLHa7EUNdHHKJ0dkIgDxirKFBBHLfuK9OFnNRd2rOq
	1uPJTbpBrTJE3EVC8HP7+hi8qOvOZx0b9m/FglFvkFQJogPpxnuSZ4GY6w3gmVbzr6x9yRwCDVTw1
	T10aWDNRvlj8AFXt3zoBAXhM;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxJy-00FcuL-1Q;
	Tue, 25 Nov 2025 17:59:22 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 027/145] smb: smbdirect: introduce smbdirect_connection_negotiate_rdma_resources()
Date: Tue, 25 Nov 2025 18:54:33 +0100
Message-ID: <e7933b08e740a4c8ecd396889b59f09d9ea3d611.1764091285.git.metze@samba.org>
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

This is a copy of the same logic used in client and server,
it's inlined there, but they will use the new helper function
soon.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_connection.c   | 62 +++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index 989f55993eee..aecd994f5845 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -291,6 +291,68 @@ smbdirect_connection_reassembly_first_recv_io(struct smbdirect_socket *sc)
 	return msg;
 }
 
+__maybe_unused /* this is temporary while this file is included in others */
+static void smbdirect_connection_negotiate_rdma_resources(struct smbdirect_socket *sc,
+							  u8 peer_initiator_depth,
+							  u8 peer_responder_resources,
+							  const struct rdma_conn_param *param)
+{
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
+
+	if (rdma_protocol_iwarp(sc->ib.dev, sc->rdma.cm_id->port_num) &&
+	    param->private_data_len == 8) {
+		/*
+		 * Legacy clients with only iWarp MPA v1 support
+		 * need a private blob in order to negotiate
+		 * the IRD/ORD values.
+		 */
+		const __be32 *ird_ord_hdr = param->private_data;
+		u32 ird32 = be32_to_cpu(ird_ord_hdr[0]);
+		u32 ord32 = be32_to_cpu(ird_ord_hdr[1]);
+
+		/*
+		 * cifs.ko sends the legacy IRD/ORD negotiation
+		 * event if iWarp MPA v2 was used.
+		 *
+		 * Here we check that the values match and only
+		 * mark the client as legacy if they don't match.
+		 */
+		if ((u32)param->initiator_depth != ird32 ||
+		    (u32)param->responder_resources != ord32) {
+			/*
+			 * There are broken clients (old cifs.ko)
+			 * using little endian and also
+			 * struct rdma_conn_param only uses u8
+			 * for initiator_depth and responder_resources,
+			 * so we truncate the value to U8_MAX.
+			 *
+			 * smb_direct_accept_client() will then
+			 * do the real negotiation in order to
+			 * select the minimum between client and
+			 * server.
+			 */
+			ird32 = min_t(u32, ird32, U8_MAX);
+			ord32 = min_t(u32, ord32, U8_MAX);
+
+			sc->rdma.legacy_iwarp = true;
+			peer_initiator_depth = (u8)ird32;
+			peer_responder_resources = (u8)ord32;
+		}
+	}
+
+	/*
+	 * negotiate the value by using the minimum
+	 * between client and server if the client provided
+	 * non 0 values.
+	 */
+	if (peer_initiator_depth != 0)
+		sp->initiator_depth = min_t(u8, sp->initiator_depth,
+					    peer_initiator_depth);
+	if (peer_responder_resources != 0)
+		sp->responder_resources = min_t(u8, sp->responder_resources,
+						peer_responder_resources);
+}
+
 static void smbdirect_connection_idle_timer_work(struct work_struct *work)
 {
 	struct smbdirect_socket *sc =
-- 
2.43.0

