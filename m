Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A5532C33A
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094176; cv=none; b=tjMEL/drffDNSrHCeZqjpJhN03iMmZqYpvFZn6kakR0hJpNv6I2GAgInlLWjhNF+c0vfHdsoxdxiIYPC8k4SdsQj0dFkMKm7ZuTBtcwvAU2K9sAzmNxRS4qtDvTQvZnHoXBDkWtBDnM0313u1qLloqunQwgDsIldRe2vLQOD0mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094176; c=relaxed/simple;
	bh=2GGiQKdoRBvwj8vJpknBJVQfUMt1WRcP25StKEtEK1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ICxPXjnS5+vOyqY1v63U5EYxAWSQO+YVhY4Q/w7mixZiOIPprJbowKqz+C0gWMzN9lDG0l8kVJL5vdcCE2jiXD+G5ZwkiGsFIr0JkGYD16T1/r6WOVmHlodV0enHf3etVFXYMdKr5UzJzc/kUnSR0drPrmyt13kE9/uNh1IBb6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=zHYyK6uo; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="zHYyK6uo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=4O/7IhTj/MfgsCNrvItn5W/yNUxzxGdc8zscH2saYU0=; b=zHYyK6uorIoxhOA9tQd30okThd
	dGei7eOgdGQyCTtpyo762NlllhVmyJL4W6Fp1OhB9JHIZZsh3cwYDjqG8KcnIQosOysPdik697HY0
	fT0++2YnCRjYCk/lv5CA12PC2bK4sOE1pJ0Fc5DBW82crNbjlMqPJkGKP2Pir8ArFCxwyXerGM4vJ
	B8OqdeBv97c7T+/NtpAJlN2zQ56uGX6PnlkUYE26xNFGa22EatuB+dwcQdDiCNCB/W+RkyuaftayM
	44d7SHxrozyyLqvR60uypW6Cbe2nV6KnDy56f+2EEnCm/f+Ct03A2umNm5UtZzOyycu2VE+l2QVJx
	0X0thE1AnOshTn6E/4LrkPKpw1q2wNvRZScV7AaQjwKVHHUFxox+0vdhu5NSbA01gtExqTvlx6fHt
	60VLkl0dVOsuNB3zbTU8WpTuhPYHBQ7cXJXvRv8ZNoGZgstN9T41ayxolnUNw49GhBkOPAVVfJWJ+
	j5ybq9Q7FkxL1L9kZSM9ZKW3;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxQk-00Fdkb-04;
	Tue, 25 Nov 2025 18:06:22 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 076/145] smb: client: make use of smbdirect_connection_negotiate_rdma_resources()
Date: Tue, 25 Nov 2025 18:55:22 +0100
Message-ID: <e2b204b8cde8f71ea8418f81e266d32fbc275b06.1764091285.git.metze@samba.org>
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

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 59 +++------------------------------------
 1 file changed, 4 insertions(+), 55 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 0d5674461058..8d5af639ae1f 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -193,7 +193,6 @@ static int smbd_conn_upcall(
 		struct rdma_cm_id *id, struct rdma_cm_event *event)
 {
 	struct smbdirect_socket *sc = id->context;
-	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	const char *event_name = rdma_event_msg(event->event);
 	u8 peer_initiator_depth;
 	u8 peer_responder_resources;
@@ -254,60 +253,10 @@ static int smbd_conn_upcall(
 			peer_initiator_depth = event->param.conn.initiator_depth;
 			peer_responder_resources = event->param.conn.responder_resources;
 		}
-		if (rdma_protocol_iwarp(id->device, id->port_num) &&
-		    event->param.conn.private_data_len == 8) {
-			/*
-			 * Legacy clients with only iWarp MPA v1 support
-			 * need a private blob in order to negotiate
-			 * the IRD/ORD values.
-			 */
-			const __be32 *ird_ord_hdr = event->param.conn.private_data;
-			u32 ird32 = be32_to_cpu(ird_ord_hdr[0]);
-			u32 ord32 = be32_to_cpu(ird_ord_hdr[1]);
-
-			/*
-			 * cifs.ko sends the legacy IRD/ORD negotiation
-			 * event if iWarp MPA v2 was used.
-			 *
-			 * Here we check that the values match and only
-			 * mark the client as legacy if they don't match.
-			 */
-			if ((u32)event->param.conn.initiator_depth != ird32 ||
-			    (u32)event->param.conn.responder_resources != ord32) {
-				/*
-				 * There are broken clients (old cifs.ko)
-				 * using little endian and also
-				 * struct rdma_conn_param only uses u8
-				 * for initiator_depth and responder_resources,
-				 * so we truncate the value to U8_MAX.
-				 *
-				 * smb_direct_accept_client() will then
-				 * do the real negotiation in order to
-				 * select the minimum between client and
-				 * server.
-				 */
-				ird32 = min_t(u32, ird32, U8_MAX);
-				ord32 = min_t(u32, ord32, U8_MAX);
-
-				sc->rdma.legacy_iwarp = true;
-				peer_initiator_depth = (u8)ird32;
-				peer_responder_resources = (u8)ord32;
-			}
-		}
-
-		/*
-		 * negotiate the value by using the minimum
-		 * between client and server if the client provided
-		 * non 0 values.
-		 */
-		if (peer_initiator_depth != 0)
-			sp->initiator_depth =
-					min_t(u8, sp->initiator_depth,
-					      peer_initiator_depth);
-		if (peer_responder_resources != 0)
-			sp->responder_resources =
-					min_t(u8, sp->responder_resources,
-					      peer_responder_resources);
+		smbdirect_connection_negotiate_rdma_resources(sc,
+							      peer_initiator_depth,
+							      peer_responder_resources,
+							      &event->param.conn);
 
 		if (SMBDIRECT_CHECK_STATUS_DISCONNECT(sc, SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING))
 			break;
-- 
2.43.0

