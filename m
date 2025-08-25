Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DF829A326
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155087; cv=none; b=osS8COLELRkmGFRLRcpEIpDENq5b4bqfWu+7c1oDwFhsbtfnB4qWqHodQ284DU/OeKum/DxtF7BLfDONlJEX+oViKszriws9e6jHBPRweXiJYXMH1Tiy0FLdfjcH78U1COXMAZEU6E0tZ7tKH/hu1J7bIw0maHHMPHhB0lmIXtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155087; c=relaxed/simple;
	bh=jETr4K4nwpvhEx57VBR6i992FwPDLBG47Qw3xM0JgMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RZMr4yohu4pzzYealbUeo7ULVoZSU+dGNTId0ObGyCPDrfUYJHn0ija7TXW5F5O7iNwOgo8meQAgf3cD5BSCv1xwAjMSuofwrjLcwcXOobgkxkpA97u1CNqd/LdTEOQ6gab30cnl7+Lt996BIXYa7FL6gH1fR6is2RjaKde7lvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=xee8lry2; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="xee8lry2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=b6QrtdE2zFPaI+c7nHpgDGlX4yspyEGgSHb0WNqTt+U=; b=xee8lry2qqpVnMKOMxlmzHL3oF
	aQNKncKNCqidyOdgJkxwZogJPKdMBzYys2OFCIkDJsiSDHpmdvA5r+8Qs9k8uq32hfW5f/qJ+MR58
	duxdzy/mTr6n84vXQmQAHns3gcM4Yyrkc5utVRBf99h2WRy2lhNSJFE0zMPVzjSpGwWpvahjHqssH
	IeYRUExZyCjOU+bSa8nsIzTLd4AvRADoQvSgdSYSlVsMZgTbiHBxiuESxxuezvZlm4jOzPzhtzOKj
	nN01mYw8UCERZaDgC2p3M1GYxXNFK/sPJg95eSeoBEkRokAi9kfktWaXeRe/kCHIpo+urUEU7VJji
	hVylwgc0xEOpdse7SF1Yr3e4z46O5MUYWJiOzEXIQTl7vLG7/OiNCczR9dgNc8GnWPyQYQp3wysT3
	Zu8crO2leY4UXMYfEX6MHkuQE1UBLqnwhxLn1NQfSTspgxkj+ENk7JHCosr2dGz8IddggwvPYZwuB
	9jaa2Fcd8FdbEsqASu0w0nZ1;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe9y-000l71-1N;
	Mon, 25 Aug 2025 20:51:22 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 057/142] smb: client: pass struct smbdirect_socket to {allocate,destroy}_caches_and_workqueue()
Date: Mon, 25 Aug 2025 22:40:18 +0200
Message-ID: <0fab296f447ca4cec527375430e39ccfd58ea286.1756139607.git.metze@samba.org>
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
 fs/smb/client/smbdirect.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index b23e9d8fd9c4..d7ed5534669a 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1579,10 +1579,8 @@ int smbd_reconnect(struct TCP_Server_Info *server)
 	return -ENOENT;
 }
 
-static void destroy_caches_and_workqueue(struct smbd_connection *info)
+static void destroy_caches_and_workqueue(struct smbdirect_socket *sc)
 {
-	struct smbdirect_socket *sc = &info->socket;
-
 	destroy_receive_buffers(sc);
 	destroy_workqueue(sc->workqueue);
 	mempool_destroy(sc->recv_io.mem.pool);
@@ -1592,9 +1590,8 @@ static void destroy_caches_and_workqueue(struct smbd_connection *info)
 }
 
 #define MAX_NAME_LEN	80
-static int allocate_caches_and_workqueue(struct smbd_connection *info)
+static int allocate_caches_and_workqueue(struct smbdirect_socket *sc)
 {
-	struct smbdirect_socket *sc = &info->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	char name[MAX_NAME_LEN];
 	int rc;
@@ -1602,7 +1599,7 @@ static int allocate_caches_and_workqueue(struct smbd_connection *info)
 	if (WARN_ON_ONCE(sp->max_recv_size < sizeof(struct smbdirect_data_transfer)))
 		return -ENOMEM;
 
-	scnprintf(name, MAX_NAME_LEN, "smbdirect_send_io_%p", info);
+	scnprintf(name, MAX_NAME_LEN, "smbdirect_send_io_%p", sc);
 	sc->send_io.mem.cache =
 		kmem_cache_create(
 			name,
@@ -1618,7 +1615,7 @@ static int allocate_caches_and_workqueue(struct smbd_connection *info)
 	if (!sc->send_io.mem.pool)
 		goto out1;
 
-	scnprintf(name, MAX_NAME_LEN, "smbdirect_recv_io_%p", info);
+	scnprintf(name, MAX_NAME_LEN, "smbdirect_recv_io_%p", sc);
 
 	struct kmem_cache_args response_args = {
 		.align		= __alignof__(struct smbdirect_recv_io),
@@ -1639,7 +1636,7 @@ static int allocate_caches_and_workqueue(struct smbd_connection *info)
 	if (!sc->recv_io.mem.pool)
 		goto out3;
 
-	scnprintf(name, MAX_NAME_LEN, "smbd_%p", info);
+	scnprintf(name, MAX_NAME_LEN, "smbd_%p", sc);
 	sc->workqueue = create_workqueue(name);
 	if (!sc->workqueue)
 		goto out4;
@@ -1825,7 +1822,7 @@ static struct smbd_connection *_smbd_get_connection(
 
 	log_rdma_event(INFO, "rdma_connect connected\n");
 
-	rc = allocate_caches_and_workqueue(info);
+	rc = allocate_caches_and_workqueue(sc);
 	if (rc) {
 		log_rdma_event(ERR, "cache allocation failed\n");
 		goto allocate_cache_failed;
@@ -1865,7 +1862,7 @@ static struct smbd_connection *_smbd_get_connection(
 
 negotiation_failed:
 	disable_delayed_work_sync(&sc->idle.timer_work);
-	destroy_caches_and_workqueue(info);
+	destroy_caches_and_workqueue(sc);
 	sc->status = SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
 	rdma_disconnect(sc->rdma.cm_id);
 	wait_event(sc->status_wait,
-- 
2.43.0

