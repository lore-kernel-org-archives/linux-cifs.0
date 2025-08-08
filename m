Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8AC9186E2D
	for <linux-cifs@vger.kernel.org>; Fri,  8 Aug 2025 16:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754671753; cv=none; b=Qx5t2i+6eU+66rg66mcZYwDOuqCXhpycyQbEf4tWjuRC8tUP4QhQ+xXme21EJt9ks9+Hm1Pc9fIw9UqdZpTctRfoJ7R4qJFjVW917Y301ks+Qs/8SIvQUK8nZpr1PWOu0YwPT8cs0z1L/uaxb/Z6OuWFoD91Nc3lUgZoBqYokTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754671753; c=relaxed/simple;
	bh=ucqx9auDyIGuKsCVKY4cA1AqxJEz/sgPKmu2DF2u2rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rA/aHuwETVE83Aj9p/VyA448SOjogsrgyfAqvlfLTtvcmti94Xgs0Hq3f610DSag0ENyeH17M2c6EfOOWxKxTS/0NVjK0KphNKJNM4fmp5aaWzAFvUu78zdLYOetWBSJmZFNTFGVFmDVOCweVMKT/kY2BHEeKFyARP39JSB6O78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=MtM4+fiq; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="MtM4+fiq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=+UwOO1gDW3I6VxCVrEoRKgVs96VVzirvh51i6MRhwmM=; b=MtM4+fiqj8rC9nXQ3gDOOFXORE
	e8ZT4xfirIUcDIMiYbF1LpZRkLiQmOyv9174JyI9v9sekhgiUvtLwsyXSt+sWwbc5fw8/2qDUlZq2
	1P9vV/mncdc360heHZTUTOdrukdikwoB7NIhB22VzPidXf3YxWlfwdDNOm98EyKLmqbDrnvUsyFj7
	BUTyfBmYxwfZCU5T0u/TuVbafBns/ODYc1aNUCtVicUbxHMRaEoAzMzTjY4Di8rA0t+8hO+UXvzhJ
	Ers1PVN55B8bvx2mWp2yJ6KWKEHqrGUj+GvlGz5wUvDi1Yqn/3ycoTHYridcOVmb7lHlMta1H/IKS
	WlE9g2FV4YL61koiNaZQAmDpOWwIQ71xZIaODjVMoA6abyJVqNzMcZnww0bFwN031sV/m1aDF7qDv
	LGE8Xn3kgJuNlyrmr4onvJ/VVhWSy0D5yuaWqrtE1B4j9GqKco0FhdkY/26uI/N5MTO+V8amEznG/
	bBJls2Rx1isKi5fDXjmgobX2;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ukQHE-001qSi-2p;
	Fri, 08 Aug 2025 16:49:08 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v3 6/9] smb: client: use status_wait and SMBDIRECT_SOCKET_NEGOTIATE_RUNNING for completion
Date: Fri,  8 Aug 2025 18:48:14 +0200
Message-ID: <b1c2247da09b819091197c6bd195b9e8f4e04789.1754671444.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754671444.git.metze@samba.org>
References: <cover.1754671444.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We can use the state change from SMBDIRECT_SOCKET_NEGOTIATE_RUNNING to
SMBDIRECT_SOCKET_CONNECTED or SMBDIRECT_SOCKET_NEGOTIATE_FAILED in order
to notify the caller if the negotiation is over.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/client/smbdirect.c | 19 ++++++++++---------
 fs/smb/client/smbdirect.h |  3 ---
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 1337d35a22f9..b3fc87886972 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -497,6 +497,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	struct smbd_connection *info =
 		container_of(sc, struct smbd_connection, socket);
 	int data_length = 0;
+	bool negotiate_done = false;
 
 	log_rdma_recv(INFO, "response=0x%p type=%d wc status=%d wc opcode %d byte_len=%d pkey_index=%u\n",
 		      response, sc->recv_io.expected, wc->status, wc->opcode,
@@ -519,16 +520,16 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	case SMBDIRECT_EXPECT_NEGOTIATE_REP:
 		dump_smbdirect_negotiate_resp(smbdirect_recv_io_payload(response));
 		sc->recv_io.reassembly.full_packet_received = true;
-		info->negotiate_done =
+		negotiate_done =
 			process_negotiation_response(response, wc->byte_len);
 		put_receive_buffer(info, response);
 		WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_NEGOTIATE_RUNNING);
-		if (!info->negotiate_done)
+		if (!negotiate_done)
 			sc->status = SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
 		else
 			sc->status = SMBDIRECT_SOCKET_CONNECTED;
 
-		complete(&info->negotiate_completion);
+		wake_up_interruptible(&info->status_wait);
 		return;
 
 	/* SMBD data transfer packet */
@@ -1151,17 +1152,17 @@ static int smbd_negotiate(struct smbd_connection *info)
 	if (rc)
 		return rc;
 
-	init_completion(&info->negotiate_completion);
-	info->negotiate_done = false;
 	rc = smbd_post_send_negotiate_req(info);
 	if (rc)
 		return rc;
 
-	rc = wait_for_completion_interruptible_timeout(
-		&info->negotiate_completion, SMBD_NEGOTIATE_TIMEOUT * HZ);
-	log_rdma_event(INFO, "wait_for_completion_timeout rc=%d\n", rc);
+	rc = wait_event_interruptible_timeout(
+		info->status_wait,
+		sc->status != SMBDIRECT_SOCKET_NEGOTIATE_RUNNING,
+		secs_to_jiffies(SMBD_NEGOTIATE_TIMEOUT));
+	log_rdma_event(INFO, "wait_event_interruptible_timeout rc=%d\n", rc);
 
-	if (info->negotiate_done)
+	if (sc->status == SMBDIRECT_SOCKET_CONNECTED)
 		return 0;
 
 	if (rc == 0)
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index e45aa9ddd71d..82505df4a751 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -49,9 +49,6 @@ struct smbd_connection {
 	struct completion ri_done;
 	wait_queue_head_t status_wait;
 
-	struct completion negotiate_completion;
-	bool negotiate_done;
-
 	struct work_struct disconnect_work;
 	struct work_struct post_send_credits_work;
 
-- 
2.43.0

