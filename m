Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257C53AEF4A
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 15:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777391766; cv=none; b=BLX2mhfHqWVT4oHXAqjN1BXld/uGP04XVca/Jbx7WZsDUiwYFgcbXD6qmhT6Edb0Mip8afBThQ0oHhnHX/q5TmwgmSH7kVseIqTj/aIAYe6j+/rfK5p2zKACrjK/PP1cS7RMCHIabD8XkibZ3VZWFurn7WWmfgbT3Mx8JH5O9Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777391766; c=relaxed/simple;
	bh=HzBrtan3XMzaHpanhKmqmsH4mAx5s9caerQyGxymO08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Drnp7gWxKFGMrB4L4qZJLJT+qKR3/lCQTDNh0WRO8QFHIIPIzJsdwWRqfBioyo2J/bt+bYIYPmbQ9hZGmddt2/VLA6CXN5dqnvBj90MbEsXSZSG1cZor7NxcmZtEdblTG7zGUdQICVcRnK2WdGDoR8x9SGnkAd1E7riTp5++940=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MGgF6aur; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MGgF6aur"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4891cd41959so99281265e9.3
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 08:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777391763; x=1777996563; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L/zHGpSjGM0CV+0mm24nsl5EoKH85EC1QlGcwmBMwDk=;
        b=MGgF6aur1laMIrpQtstOyxf1N78IyqTtI2ITlsNf2D89R9/+6fnzQIDn2RB7I9xtUv
         NVJWBAH2EJkGynpBDzoZRUyab4MkH30XTkIQrDVGYACGymXDL669GZbPwRnbLruUx/CE
         GRV6NViZ/kECfOu08rXcmgz90qDAZFPNYdTrXCyj42q6loJIxF4UDMK9biZ2ddhrqLF1
         a/KWalKkXAzyAnMtPm7tDUzjIXFAOCiwHCQkp7BKD2Dhs33Bn1q+z6vJvjJ0y+0gVDIe
         ebRIPSHweB2uch8TkFtml4iy/j1xku9L/n/Td9KkGQeztEj368CvVb9iDog8271l0Mu7
         RzYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777391763; x=1777996563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L/zHGpSjGM0CV+0mm24nsl5EoKH85EC1QlGcwmBMwDk=;
        b=AfvV9sO21Yf8Dre+S5+hCsZQRoevfhmlb+XP2zuFYT/BhPIqRWHHNzYxPnwLlhWBRl
         /xM25w4NrG42FSAHtwvEwMP+SMc3Hov33t3Gz4MhJza7MWBZiEsqnUqVT8ay6OsPkFnz
         xG86l+tMPfx6magcCprZ7mQSuVcgz9JW/6iV4SlYv03asJA1vrhNFabILraD2yDlN1U7
         poIxrRWq8cSEe1krTGFspT26wJPf+McKCO69+fS5fFbKHP4JGM8hwwguYiEpCDaglFiM
         vn1MFXWu4udg6+0ljvo3bULrI6pFsKnKZ2TPf4RiROPYeVreFH8ESpHLtFOEL36amUYe
         bn6g==
X-Gm-Message-State: AOJu0YyzXYdyKEpCDugCUGoymx5lOXa3EsUiN1yy6wX5yboTDOhYI0gg
	TOwRSu3V6/lj9tkPGEEtNQ7xHfardKn+r41C3pMuscinDNalVZVNAOc6z5h/SHNjrMbbi3k2Hyi
	jwt7cHyxhbg==
X-Gm-Gg: AeBDievs052lk2MjYVKK5ACoilGY0wCsZ7FxdU97NrheLW+t227WR8jdksfYMd16fEr
	de47VAUagfEJi6rvn6hrp0zmbdXLb237DDzdc1vFhQLGPo/jSu9PrfdHgbSjYMcQoUMG+GBv1P7
	TktqG1SkYvVBKkG5XEIxtEjWDbGCc7dgKJm6melwxrQ8U+l4rmOZ13E6yJRgXNbkE0S7qflftZf
	CbO4iwLq/NkLhBE8zlE5lesjM81Zy/DrFbusl2OZUJyzrbU0nMdrneGhvpbBOuCV1BCH0pRJhCl
	r2ZQzwitbwMz29iH2fFxzrTYKrNV8MYGQj+QyK2PLAAPAzk7eUa+Zlgt/aMEN7PHxZp46M2A93m
	iWhjqDu5YSmI2oBBfp3hAEiTNyOCUbS1oX4G8P9YUHO8VlXzNzSk7tQbT2UuyQDwFVZeTEIXvhW
	1hSaquljTJLX0dT+NskD7R11d3IhBFma2Wq/El7n6ySsdH
X-Received: by 2002:a05:600c:4c95:b0:485:30d4:6b9e with SMTP id 5b1f17b1804b1-48a77b0e999mr36081735e9.21.1777391763162;
        Tue, 28 Apr 2026 08:56:03 -0700 (PDT)
Received: from precision ([2a01:4b00:c007:bb00:be9d:a3c4:18b1:4a25])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a775f56fcsm23475685e9.25.2026.04.28.08.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 08:56:02 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: linux-cifs@vger.kernel.org
Cc: sfrench@samba.org,
	linkinjeon@kernel.org,
	metze@samba.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH v2 03/11] smb: client: prepare connect path for QUIC transport
Date: Tue, 28 Apr 2026 12:55:41 -0300
Message-ID: <20260428155542.226234-4-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428155542.226234-1-henrique.carvalho@suse.com>
References: <20260428155542.226234-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the connect path to ease introducing QUIC as an alternative
transport alongside TCP and RDMA.

No functional change intended.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/connect.c | 56 ++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 17 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 92962d63d256..33d619007905 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -62,11 +62,18 @@ static int ip_connect(struct TCP_Server_Info *server);
 static int generic_ip_connect(struct TCP_Server_Info *server);
 static void tlink_rb_insert(struct rb_root *root, struct tcon_link *new_tlink);
 static void cifs_prune_tlinks(struct work_struct *work);
+static void smb_sock_release(struct TCP_Server_Info *server);
 
 static struct mchan_mount *mchan_mount_alloc(struct cifs_ses *ses);
 static void mchan_mount_free(struct mchan_mount *mchan_mount);
 static void mchan_mount_work_fn(struct work_struct *work);
 
+static void smb_sock_release(struct TCP_Server_Info *server)
+{
+	sock_release(server->ssocket);
+	server->ssocket = NULL;
+}
+
 /*
  * Resolve hostname and set ip addr in tcp ses. Useful for hostnames that may
  * get their ip addresses changed at some point.
@@ -311,8 +318,7 @@ cifs_abort_connection(struct TCP_Server_Info *server)
 		kernel_sock_shutdown(server->ssocket, SHUT_WR);
 		cifs_dbg(FYI, "Post shutdown state: 0x%x Flags: 0x%lx\n", server->ssocket->state,
 			 server->ssocket->flags);
-		sock_release(server->ssocket);
-		server->ssocket = NULL;
+		smb_sock_release(server);
 	}
 	server->sequence_number = 0;
 	server->session_estab = false;
@@ -1077,10 +1083,8 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
 	wake_up_all(&server->request_q);
 	/* give those requests time to exit */
 	msleep(125);
-	if (server->ssocket) {
-		sock_release(server->ssocket);
-		server->ssocket = NULL;
-	}
+
+	smb_sock_release(server);
 
 	if (!list_empty(&server->pending_mid_q)) {
 		struct mid_q_entry *mid_entry;
@@ -1778,7 +1782,11 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	tcp_ses->noblocksnd = ctx->noblocksnd || ctx->rootfs;
 	tcp_ses->noautotune = ctx->noautotune;
 	tcp_ses->tcp_nodelay = ctx->sockopt_tcp_nodelay;
-	tcp_ses->ipproto = ctx->rdma ? IPPROTO_SMBDIRECT : IPPROTO_TCP;
+	if (ctx->rdma)
+		tcp_ses->ipproto = IPPROTO_SMBDIRECT;
+	else
+		tcp_ses->ipproto = IPPROTO_TCP;
+
 	tcp_ses->in_flight = 0;
 	tcp_ses->max_in_flight = 0;
 	tcp_ses->credits = 1;
@@ -1895,8 +1903,7 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 			cifs_put_tcp_session(tcp_ses->primary_server, false);
 		kfree(tcp_ses->hostname);
 		kfree(tcp_ses->leaf_fullpath);
-		if (tcp_ses->ssocket)
-			sock_release(tcp_ses->ssocket);
+		smb_sock_release(tcp_ses);
 		kfree(tcp_ses);
 	}
 	return ERR_PTR(rc);
@@ -3297,13 +3304,29 @@ ip_rfc1001_connect(struct TCP_Server_Info *server)
 	return 0;
 }
 
+static inline const char *
+get_protocol_name(struct TCP_Server_Info *server)
+{
+	switch (server->ipproto) {
+	case IPPROTO_TCP:
+		return "tcp";
+	case IPPROTO_QUIC:
+		return "quic";
+	case IPPROTO_SMBDIRECT:
+		return "smbdirect";
+	default:
+		cifs_dbg(VFS, "Unknown ipproto value: %d", server->ipproto);
+		return "unknown";
+	}
+}
+
 static int
 generic_ip_connect(struct TCP_Server_Info *server)
 {
 	struct sockaddr *saddr;
 	struct socket *socket;
 	int slen, sfamily;
-	const char *pname = cifs_rdma_enabled(server) ? "smbdirect" : "tcp";
+	const char *pname = get_protocol_name(server);
 	__be16 sport;
 	int rc = 0;
 
@@ -3327,10 +3350,7 @@ generic_ip_connect(struct TCP_Server_Info *server)
 			 __func__, pname, &ipv4->sin_addr, ntohs(sport));
 	}
 
-	if (server->ssocket) {
-		sock_release(server->ssocket);
-		server->ssocket = NULL;
-	}
+	smb_sock_release(server);
 
 	{
 		struct net *net = cifs_net_ns(server);
@@ -3383,7 +3403,7 @@ generic_ip_connect(struct TCP_Server_Info *server)
 	if (server->tcp_nodelay)
 		tcp_sock_set_nodelay(socket->sk);
 
-	if (server->ipproto == IPPROTO_SMBDIRECT) {
+	if (cifs_rdma_enabled(server)) {
 		rc = smbd_prepare_socket(server, ntohs(sport));
 		if (rc < 0) {
 			cifs_dbg(FYI, "Error %d from smbd_prepare_socket(port=%u)\n",
@@ -3431,8 +3451,7 @@ generic_ip_connect(struct TCP_Server_Info *server)
 
 close_socket:
 	trace_smb3_connect_err(server->hostname, server->conn_id, &server->dstaddr, rc);
-	sock_release(socket);
-	server->ssocket = NULL;
+	smb_sock_release(server);
 	return rc;
 }
 
@@ -3465,6 +3484,9 @@ ip_connect(struct TCP_Server_Info *server)
 		if (rc >= 0)
 			return rc;
 
+		if (!port2)
+			return rc;
+
 		/* if it failed, try with port2 */
 		*sport = htons(port2);
 	}
-- 
2.53.0

