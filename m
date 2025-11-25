Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0960230DD2E
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094920; cv=none; b=bBO4nBeEqZK2QkyvUfweok8Jub1+JpTcM0vOg8GWjQ7G0PopmgOMEOSHIlss6jj+Y/N8dSLfJZM8NRcuCD0pZLZ5uaLQst5wgoYKm14W8dK6hbCN9iZPyLjKuXhyDL/LcElEuLcDhWVAKeQ8RTb8sm+hg9P3QOyroreS4vQLdjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094920; c=relaxed/simple;
	bh=aL9/sAiAuGO3UuVXlluP6kvmvXdAwujBj0HdcR2j0QA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kgosUsQs69zs0SsII6pNGpaYa1UMiQwfhLqrYHWXdTNr7uMxkl+Z/tZHwEIbQ674YFBqAdw66+ZwqxNJJRPfPsV8gRumqnL6NmLCUDuwljTs9cJFSLx4fT9tNnwDg1LddD3YkX8qQemlntWkSFdLMvfrMuPu8jKIBIFoVY5p1vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=nUR4kppC; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="nUR4kppC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=fXzlpZXbrr+gX9JmmQQartKr1LuvYfprAitARsxc3Z4=; b=nUR4kppCJ6kF6q2ZYKZeOIBaSt
	9TjABFqGwlH7klh3Tg73HGUQ2P7uYF/fXn6IVHpJC92nCTp1JMKfV4Sa6C6Jmx7tvA/qwZnRHNbRT
	4KJJsbQ9JAj4ZCF5ORWgAzf1srV+yDDwdtqZCXvdabTZlSLIo5fEnHGqbcRz/6EOgnI3kc9MiLKia
	clxlhX4CroM/sPz4SoLlXMGNb4RekCgvZVjuesyRUtpqBjWJ2G1yZjzVSqivTWfvgG0jq9oRVQgIv
	0m5qe4WJXL4GvqTmuWE0yXNBcKZ6Hc9FkIb3irXLe1ovfXPDfU3USmvGan4HQoKgrMkRihCUJuiMy
	v4FuZM4f9t422mwx7cIgAjxBAPsniofGk2Bmi+wRWPGbcyn6UEkVq9HpR5rvq5G5BunXzLlmEUvJE
	7FcZ5NuttibLdwimLhJwuD2/FocE9MhOlFqTyKAxtbizokRRRc+WwivM+cdBvOV2BNFaYWMa28/uA
	MHqbymyDuvAxNg7vsqAb5rtO;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxYI-00FeV2-0G;
	Tue, 25 Nov 2025 18:14:11 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 112/145] smb: server: make use of smbdirect_connection_negotiate_rdma_resources()
Date: Tue, 25 Nov 2025 18:55:58 +0100
Message-ID: <f4145cc9e00a6c4561c388e3177d35d95308178f.1764091285.git.metze@samba.org>
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

It's good to have this logic in a central place, it will allow us
share more code soon.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 62 ++++------------------------------
 1 file changed, 7 insertions(+), 55 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 4da8247337a8..ed8c59bc25bf 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -2051,66 +2051,18 @@ static int smb_direct_handle_connect_request(struct rdma_cm_id *new_cm_id,
 	sc = &t->socket;
 	sp = &sc->parameters;
 
-	peer_initiator_depth = event->param.conn.initiator_depth;
-	peer_responder_resources = event->param.conn.responder_resources;
-	if (rdma_protocol_iwarp(new_cm_id->device, new_cm_id->port_num) &&
-	    event->param.conn.private_data_len == 8) {
-		/*
-		 * Legacy clients with only iWarp MPA v1 support
-		 * need a private blob in order to negotiate
-		 * the IRD/ORD values.
-		 */
-		const __be32 *ird_ord_hdr = event->param.conn.private_data;
-		u32 ird32 = be32_to_cpu(ird_ord_hdr[0]);
-		u32 ord32 = be32_to_cpu(ird_ord_hdr[1]);
-
-		/*
-		 * cifs.ko sends the legacy IRD/ORD negotiation
-		 * event if iWarp MPA v2 was used.
-		 *
-		 * Here we check that the values match and only
-		 * mark the client as legacy if they don't match.
-		 */
-		if ((u32)event->param.conn.initiator_depth != ird32 ||
-		    (u32)event->param.conn.responder_resources != ord32) {
-			/*
-			 * There are broken clients (old cifs.ko)
-			 * using little endian and also
-			 * struct rdma_conn_param only uses u8
-			 * for initiator_depth and responder_resources,
-			 * so we truncate the value to U8_MAX.
-			 *
-			 * smb_direct_accept_client() will then
-			 * do the real negotiation in order to
-			 * select the minimum between client and
-			 * server.
-			 */
-			ird32 = min_t(u32, ird32, U8_MAX);
-			ord32 = min_t(u32, ord32, U8_MAX);
-
-			sc->rdma.legacy_iwarp = true;
-			peer_initiator_depth = (u8)ird32;
-			peer_responder_resources = (u8)ord32;
-		}
-	}
-
 	/*
 	 * First set what the we as server are able to support
 	 */
 	sp->initiator_depth = min_t(u8, sp->initiator_depth,
-				   new_cm_id->device->attrs.max_qp_rd_atom);
+				    sc->ib.dev->attrs.max_qp_rd_atom);
 
-	/*
-	 * negotiate the value by using the minimum
-	 * between client and server if the client provided
-	 * non 0 values.
-	 */
-	if (peer_initiator_depth != 0)
-		sp->initiator_depth = min_t(u8, sp->initiator_depth,
-					   peer_initiator_depth);
-	if (peer_responder_resources != 0)
-		sp->responder_resources = min_t(u8, sp->responder_resources,
-					       peer_responder_resources);
+	peer_initiator_depth = event->param.conn.initiator_depth;
+	peer_responder_resources = event->param.conn.responder_resources;
+	smbdirect_connection_negotiate_rdma_resources(sc,
+						      peer_initiator_depth,
+						      peer_responder_resources,
+						      &event->param.conn);
 
 	ret = smb_direct_connect(sc);
 	if (ret)
-- 
2.43.0

