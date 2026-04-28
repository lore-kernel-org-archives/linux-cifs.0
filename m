Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2021B3A9638
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 15:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777391204; cv=none; b=nWYJyoeyRvX0ybDHmNCkpA72D6jgn9UoJG62FnN5xke8Mn9UlEy0+GhlNhLWLQy95W/iF8wG14wGQavD8KsqjZHBjNa2PQsfP3DUwbU9hi+hfJPNDwqyf9pXFaAOE9Lev926QJz/6wEMMFgMjtBJBFw2rxAnsW0W0b6DqNpqTys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777391204; c=relaxed/simple;
	bh=HzBrtan3XMzaHpanhKmqmsH4mAx5s9caerQyGxymO08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYf/GoFFkLAOSt5yU/vRRlyu6ezwaWIe+mReuIQfT3X3DmhdUBjcZG52M0XnSfsrBUkDGcfBhs0tG3mhupHV6oLbBO8Qbh0QN7NWDNYoaAuXbqRVBRWD/kjrlcZiVMm3YBE1Lzh0eFiv6/wKHNi2j509eHDanBeBIbJRvAQ2lao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=gTB+404d; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="gTB+404d"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-488b8bc6bc9so83786815e9.3
        for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 08:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777391201; x=1777996001; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L/zHGpSjGM0CV+0mm24nsl5EoKH85EC1QlGcwmBMwDk=;
        b=gTB+404djr1C06ZnaPo/oAbP+OmOTy9w762/lRh1sE/N/nd5/ItDLnewobNFnnRZJa
         xQvwHHGljRqdPz4ogxm3MG66T7Yrm4YIyK8FYJdJBz6ZPfePiiIoVs7UCBcMxl2/sxJO
         WVv+FOdyt49Fx8Ty7XhatKlcQljx6aHmnrhNrM4F/6oC2I6xXBfwCL9HY3yd/dAHwyC1
         HImY/IaJSe/wdlN4cnj8zZ8dogiK42+1n2aQbmi61sWSTJ1C35mMyFltaXWCzATvTC+7
         JiFEn833ykkmh/obPrpoAPnzCi18om7z2Y7leLLIx3+hwSnNkC2NkUUgyIXGYft+VDqm
         +9wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777391201; x=1777996001;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L/zHGpSjGM0CV+0mm24nsl5EoKH85EC1QlGcwmBMwDk=;
        b=gDaT+5Zd+9yMvS8I++CxKR08qqK4r6IGIhtoVkkiGqDISXJPh1KPX8iLL0tFyzW0Ac
         dKhUeFW3yl/3gwqPKg502reZFZ6qmDFoUFLfPAS63x8Vnl1XiiRoRSvoxVyChPU7kqAL
         CIZ4+Rn59vcCUuD1I8w7fFoo8HcceQN0Ar6JIAMtJd9oSDrveKQ83hLLPTKF3CXDlNnF
         rkvfAIRGP11iShTamPlzB3DPQrl5d4gxoNc+KPDv9hWpzu64hau3hHBXCBrTlzNT1GTY
         EX2umNN/IageXQ5Y6HiabfBcfvM2Z+vlqFWz8n1CLvqLh5vDfooabPjFkKWLXAG5+sMR
         7ukA==
X-Gm-Message-State: AOJu0Ywq/HJt0OkY4KRw45dE8tMDpOnqY9WdpU4bgHa2rqU483pmSPl1
	fhASDkkRtZZlHqjptzUR5n4UtwM/K6cFlANL/Y7EbhiTkOnQak9u6MeNP7b+sNbFuF2/RoPY+nb
	lhXM0J/OctA==
X-Gm-Gg: AeBDiesY1qZEhnoJvW5vRt076v+mA7RtmJXiGC8Eo8vfKj+/s3NY7736CgY67i7vReo
	otkYGrguVhymCpCNHZhYnv0b4qAVZQF+Ihd0oEXe6fyBxz7P4GQyhAqitL7vmxyuPf68xzoSwKV
	jI5SwZNSLDVlONPHyyjmVLHZAz24s3gDwcg0+knRJpmwd1FAMkrrYNj+KX4qnaFfBEmrctCAbsA
	cI1Kf96h4BlG2/HS0BZ2CrCUtzkGYFLaKF3Er24c+lANIOo1ItN7eiseGdLwH2ZcATvbK4cMfT9
	8yAPhuirzjS/co6R46rwD3s4mgO+L6MSemCQbmZfpPpWZSHRolmnzluRXl3FUuqlUuw5UREEmzV
	UsE1IHt4T70OX/i7QPvStuzdRlV3KOpSPm4z7hjoFdhOzl9mF6oREThv96LT+tr5FusLW8RDj1M
	P1mZn7EsF2R4JCMwet4ssXZ7IJyAOOjqWOeUfhESbHM1V676MrJhHCWhk=
X-Received: by 2002:a05:600c:c177:b0:48a:5301:bb5c with SMTP id 5b1f17b1804b1-48a77b12a49mr50931355e9.16.1777391201099;
        Tue, 28 Apr 2026 08:46:41 -0700 (PDT)
Received: from precision ([2a01:4b00:c007:bb00:be9d:a3c4:18b1:4a25])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4463d4fa52bsm7725384f8f.15.2026.04.28.08.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 08:46:40 -0700 (PDT)
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
Subject: [PATCH 02/11] smb: client: prepare connect path for QUIC transport
Date: Tue, 28 Apr 2026 12:45:59 -0300
Message-ID: <20260428154604.222551-4-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428154604.222551-1-henrique.carvalho@suse.com>
References: <20260428154604.222551-1-henrique.carvalho@suse.com>
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

