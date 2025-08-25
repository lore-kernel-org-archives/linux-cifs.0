Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8EF1DE4C4
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155077; cv=none; b=lAYfw+nkhWpIO+h3VrL+QpVS9Cl2sYl4pdUHAdWEcsJv/aFTGKHzkA6H/CQfCvVvFgJ9yKUefhJbbvlA5NyLpNpKxVwNTYy8URCWkonAFBBzwbtWzEkrqUXLekhX4u7Pi/ZG/45GMduYqRMor3NDymLD/0QATI9NTXX2FXmPNNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155077; c=relaxed/simple;
	bh=8AT1V8z8Kx6Y3XsXJmKMPtnAbXijvai2BIV9qpBM6+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CoT2b5FEU3G4OPh06UgTJyOvkzFOYXC7kGXn7xYKDytzKyTOasyWYAHMQHts57OAYazs6DDgQAfLsdeZmHVvi/auz+tC5eimoJd1deavLub6bmVPTInG8kPEtiuM7BoRshCuYgAUw/GUqIxXPxj9fLPD/yhCnsTVR6vj+jJ1Plg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=dgpZZ/VA; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="dgpZZ/VA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=TFKF4fFajYdrmh+hos6tBoUXD19ijvUBLvq5P/aeR0w=; b=dgpZZ/VAVvfQBG8stXN+dRwk/k
	3Cmv5Pr4KiOpNu1L4nhBZRMzGGwuB+krjxLRy+SL9Kzg/Q5QJELt/8c8y2/nyOtsuhaLBgd6YjhvZ
	R2n60yJQ1nAdOByVisElxYUSBJWBten7x5v6jgreUCsQ62HdkeSA92neVZCyYje4OhwTzVT1JoyYZ
	Zt+pEr9uyx1GmxYPjupPgSTx5Sw7SHtZ/wV+5rw2/CJCYDvftX/STAL7oIz56ZS9gN/kuY4HLX5wA
	rK3GkcUzxK0vAydaqYKxj+H5IW6qhjQW4h8gYrKqB049hH5nmow21kZuitd5NydS7oU7vHyAaWY9A
	XPpDGQaGCHM66GGSU/aFrVJlcoOqgBDV7m8QJD1CfSkgGOXaQMkcxlrBbghXvOJe7cNYHUpXZMZ0i
	SjhCnzwpNQ+CKaOiKFPbu5xRJhA5Wf2a2hQnfnfccbaisXj9IH2rZrzBZ7EJ5GsRLw+klRJJbttCc
	EgCHXFa8uo/EaSd1BXPy/fzx;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe9n-000l3c-2a;
	Mon, 25 Aug 2025 20:51:12 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 056/142] smb: client: pass struct smbdirect_socket to {allocate,destroy}_receive_buffers()
Date: Mon, 25 Aug 2025 22:40:17 +0200
Message-ID: <52fc1266851b014a6e1418121c4ee789beb95464.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will make it easier to move function to the common code
in future.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 01f4b1ee727a..b23e9d8fd9c4 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -25,8 +25,8 @@ static struct smbdirect_recv_io *get_receive_buffer(
 static void put_receive_buffer(
 		struct smbdirect_socket *sc,
 		struct smbdirect_recv_io *response);
-static int allocate_receive_buffers(struct smbd_connection *info, int num_buf);
-static void destroy_receive_buffers(struct smbd_connection *info);
+static int allocate_receive_buffers(struct smbdirect_socket *sc, int num_buf);
+static void destroy_receive_buffers(struct smbdirect_socket *sc);
 
 static void enqueue_reassembly(
 		struct smbd_connection *info,
@@ -1363,9 +1363,8 @@ static void put_receive_buffer(
 }
 
 /* Preallocate all receive buffer on transport establishment */
-static int allocate_receive_buffers(struct smbd_connection *info, int num_buf)
+static int allocate_receive_buffers(struct smbdirect_socket *sc, int num_buf)
 {
-	struct smbdirect_socket *sc = &info->socket;
 	struct smbdirect_recv_io *response;
 	int i;
 
@@ -1393,9 +1392,8 @@ static int allocate_receive_buffers(struct smbd_connection *info, int num_buf)
 	return -ENOMEM;
 }
 
-static void destroy_receive_buffers(struct smbd_connection *info)
+static void destroy_receive_buffers(struct smbdirect_socket *sc)
 {
-	struct smbdirect_socket *sc = &info->socket;
 	struct smbdirect_recv_io *response;
 
 	while ((response = get_receive_buffer(sc)))
@@ -1507,7 +1505,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	sc->recv_io.reassembly.data_length = 0;
 
 	log_rdma_event(INFO, "free receive buffers\n");
-	destroy_receive_buffers(info);
+	destroy_receive_buffers(sc);
 
 	/*
 	 * For performance reasons, memory registration and deregistration
@@ -1585,7 +1583,7 @@ static void destroy_caches_and_workqueue(struct smbd_connection *info)
 {
 	struct smbdirect_socket *sc = &info->socket;
 
-	destroy_receive_buffers(info);
+	destroy_receive_buffers(sc);
 	destroy_workqueue(sc->workqueue);
 	mempool_destroy(sc->recv_io.mem.pool);
 	kmem_cache_destroy(sc->recv_io.mem.cache);
@@ -1646,7 +1644,7 @@ static int allocate_caches_and_workqueue(struct smbd_connection *info)
 	if (!sc->workqueue)
 		goto out4;
 
-	rc = allocate_receive_buffers(info, sp->recv_credit_max);
+	rc = allocate_receive_buffers(sc, sp->recv_credit_max);
 	if (rc) {
 		log_rdma_event(ERR, "failed to allocate receive buffers\n");
 		goto out5;
-- 
2.43.0

