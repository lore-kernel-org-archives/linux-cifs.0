Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE832AE90
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154759; cv=none; b=C+Pc+Zz0VwQXM6VaznalH1FKFBjUmtQ1JK9PsvN93d4wwDUnGDoZgPPfJAHwYZ1xj+H6nrLpzSjP8YXw989WvvZdCjYjN/zrfMGzIy+vF59nQLLVP+9g4QU+47+WbMYUzyXDG7ysoIBiNSsV506VVAcsPrb09RLkeQhK1bpF4DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154759; c=relaxed/simple;
	bh=ApFprtbODBUB4sEwFy9ixomTN0QRaNHUnCqKb6GNaLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CCZ/841esPzzTEEGe5iYSth4MyzzPs2m0aoz9YBGZsjvUIHDFb4xE7Michpz27pP6RTybrJLwB3MjQy6+v0B82yiYELbiow4nTzQNbMsosEnFpJ3+T/VrVXRGspDtPRtaXd4qblQpDBVXn0kaUIcvKtPXCVXxaJu2MwvHdumgzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=lnOCNgCC; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="lnOCNgCC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=/H284UBY38VuuHhorIJQb1wax+TSkIL1Zc+xja+LQXU=; b=lnOCNgCCUUwTVk9J3j8UkgbijO
	N11wmazso2vBF6fvDRiGsmo5KnFGS0SQ99HorVjygSZvhT2CmyOCFW2bao2Kh3lzoOKqCsY7SqrBB
	I+fcqXrdSCyPU+IdQI0mRxFtcC+HJsssoWrJ/NaL9krXhevmdTYliN8k8JuxHBQ+Fjr5Te9iQldde
	qXnYAa1Goy39e6YkLzQztXyHE6N/UWmTL11ZzfhUxad6mQNUgSCivg/32XNeTgmIWzJJQx/fO+HBP
	T2VPiZYQJeEr9sGUiNHCdvum++MzlPuHbImuoJE+vmIwriawBvgh1tbIh+2MiVg1ad6gzmBmqUMVk
	AK/dMaKl9QW8Y5BpJHmo8WiuqoDETNe9YjlLdtJDsOlzg2dmw+Z9nR4FTLuGEPW0F+WsfZRFhfS1X
	FUDUM6DZk6Mayhnr+8zQYV4W4VA9sF5GV0m30TKxhswPZon4Tt0bQveWtXEzL7fJx9rvrm/KmpUZx
	aaGb8Q1MUIsgUVPJ7l+Wfexg;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe4f-000jxJ-2k;
	Mon, 25 Aug 2025 20:45:54 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 024/142] smb: client: make use of smbdirect_socket_init()
Date: Mon, 25 Aug 2025 22:39:45 +0200
Message-ID: <56c4be7b1d6f1fb5cd30e1fb3b22efec36e62c61.1756139607.git.metze@samba.org>
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

It's much safer to initialize the whole structure at
the beginning than doing it all over the place
and then miss to move it if code changes.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index b67a264a6030..ded912e904f0 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1351,13 +1351,6 @@ static int allocate_receive_buffers(struct smbd_connection *info, int num_buf)
 	struct smbdirect_recv_io *response;
 	int i;
 
-	INIT_LIST_HEAD(&sc->recv_io.reassembly.list);
-	spin_lock_init(&sc->recv_io.reassembly.lock);
-	sc->recv_io.reassembly.data_length = 0;
-	sc->recv_io.reassembly.queue_length = 0;
-
-	INIT_LIST_HEAD(&sc->recv_io.free.list);
-	spin_lock_init(&sc->recv_io.free.lock);
 	info->count_receive_queue = 0;
 
 	init_waitqueue_head(&info->wait_receive_queues);
@@ -1656,14 +1649,12 @@ static struct smbd_connection *_smbd_get_connection(
 	if (!info)
 		return NULL;
 	sc = &info->socket;
+	smbdirect_socket_init(sc);
 	sp = &sc->parameters;
 
 	info->initiator_depth = 1;
 	info->responder_resources = SMBD_CM_RESPONDER_RESOURCES;
 
-	init_waitqueue_head(&sc->status_wait);
-
-	sc->status = SMBDIRECT_SOCKET_CREATED;
 	rc = smbd_ia_open(info, dstaddr, port);
 	if (rc) {
 		log_rdma_event(INFO, "smbd_ia_open rc=%d\n", rc);
@@ -1773,8 +1764,6 @@ static struct smbd_connection *_smbd_get_connection(
 	log_rdma_event(INFO, "connecting to IP %pI4 port %d\n",
 		&addr_in->sin_addr, port);
 
-	init_waitqueue_head(&sc->recv_io.reassembly.wait_queue);
-
 	WARN_ON_ONCE(sc->status != SMBDIRECT_SOCKET_RDMA_CONNECT_NEEDED);
 	sc->status = SMBDIRECT_SOCKET_RDMA_CONNECT_RUNNING;
 	rc = rdma_connect(sc->rdma.cm_id, &conn_param);
-- 
2.43.0

