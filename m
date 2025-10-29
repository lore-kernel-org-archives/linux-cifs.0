Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E951D355811
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744691; cv=none; b=EF0KsnMHo9BnLiTJzSXDu91Dg6M5rSOKpb4Z6MfIYYUzyenhiUQ1o0ZdiSVaIsUsQyioox9zK7CrivBdsn6lUvskrwa6LR158bHCRHASYBRwWHgy005mgPGLRknuuUeB/7qiIHf9y6GVhbKIt1xUdSrXI1lFNEKyHMwvVPg7oAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744691; c=relaxed/simple;
	bh=zs7gb427am+bio1vceTcaBrgTWqqsb5Q8g2rmjjLoKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mqv7/LY9xr14JU6/+l70c4bd7bEROsVbLJCrk+Hnz5DMGSaRCes8V/Btd2x7A8E63wE60yYxSE0G+LkF7TNDvCynL1wPypanlKe/cSXeEqSj5jpTFfak1PA8XMdnYw6538scBRR/gJp5cpOjTmkx9uHx/bNy1yL0fKCmvoONzxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=3nGnTAye; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="3nGnTAye"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=zlXmm6gfr+yqahdXPGxeVCyKsXwmj51zHahfEo2Yf08=; b=3nGnTAyeK2lRKTQkTA55hw5cQX
	cA8J8+7HzBOgayVcmVbmV+2Hyjqp7XRExyhztkdRfmntotuK+9g8OlmHjJVpBKrwVS/GzJLZfGNSv
	JL0AVLSJcG7M0buaqSXaTkHfy8QlDioSF3O2PVh+Dzv3+A4anUUUvWfIjs1Sg34WkCQRTP+TUwFf4
	+asb+M/nB8HwxHqQNavV4RuKbKN++WTPlychXv4bRtNKZz/Q43HvMTgyoa4xIANDC1WuMVqmgRAPH
	iObjmjRBuwNG/HZR5Av9NJ5+WQzqpYNpxhqo/a6vxNYv3BSVMFrMzNuf7hG8z8LEj1XVJLhlmLx/W
	FueuUNrnsLQ+hhrnkZSmonPUdBQLQRqj4BvtnXS9bPUOfhMWwt4tp/ZOEvoa7IgUE2ygIFvIZ946G
	PqbcrYdg2pyxFAEYwoEx99S1JMUBJUyFARNgguetOK8kPIUxcOCs91SVtGk0RwFVip8TUhNGaophe
	1u4WHugO1mGq4NAIzan2CYGl;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6Gt-00BcZS-16;
	Wed, 29 Oct 2025 13:31:27 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 089/127] smb: client: make use of smbdirect_socket_create_kern()/smbdirect_socket_release()
Date: Wed, 29 Oct 2025 14:21:07 +0100
Message-ID: <78aa10af43434cc6e342f2302aed38b2cd540a49.1761742839.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1761742839.git.metze@samba.org>
References: <cover.1761742839.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With this we no longer embed struct smbdirect_socket, which will allow
us to make it private in the following commits.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 30 ++++++++++++++----------------
 fs/smb/client/smbdirect.h |  2 +-
 2 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 922001875d9b..1efbc15879f4 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -200,15 +200,13 @@ static int smbd_post_send_full_iter(struct smbdirect_socket *sc,
 void smbd_destroy(struct TCP_Server_Info *server)
 {
 	struct smbd_connection *info = server->smbd_conn;
-	struct smbdirect_socket *sc;
 
 	if (!info) {
 		log_rdma_event(INFO, "rdma session already destroyed\n");
 		return;
 	}
-	sc = &info->socket;
 
-	smbdirect_connection_destroy_sync(sc);
+	smbdirect_socket_release(info->socket);
 
 	destroy_workqueue(info->workqueue);
 	kfree(info);
@@ -288,8 +286,7 @@ static struct smbd_connection *_smbd_get_connection(
 	info->workqueue = create_workqueue(wq_name);
 	if (!info->workqueue)
 		goto create_wq_failed;
-	sc = &info->socket;
-	ret = smbdirect_socket_init_new(net, sc);
+	ret = smbdirect_socket_create_kern(net, &sc);
 	if (ret)
 		goto socket_init_failed;
 	smbdirect_socket_set_logging(sc, NULL, smbd_logging_needed, smbd_logging_vaprintf);
@@ -317,17 +314,14 @@ static struct smbd_connection *_smbd_get_connection(
 		goto connect_failed;
 	}
 
+	info->socket = sc;
 	return info;
 
 connect_failed:
 set_workqueue_failed:
 set_settings_failed:
 set_params_failed:
-	/* At this point, need to a full transport shutdown */
-	server->smbd_conn = info;
-	smbd_destroy(server);
-	return NULL;
-
+	smbdirect_socket_release(sc);
 socket_init_failed:
 	destroy_workqueue(info->workqueue);
 create_wq_failed:
@@ -337,9 +331,13 @@ static struct smbd_connection *_smbd_get_connection(
 
 const struct smbdirect_socket_parameters *smbd_get_parameters(struct smbd_connection *conn)
 {
-	struct smbdirect_socket *sc = &conn->socket;
+	if (unlikely(!conn->socket)) {
+		static const struct smbdirect_socket_parameters zero_params;
+
+		return &zero_params;
+	}
 
-	return smbdirect_socket_get_current_parameters(sc);
+	return smbdirect_socket_get_current_parameters(conn->socket);
 }
 
 struct smbd_connection *smbd_get_connection(
@@ -386,7 +384,7 @@ struct smbd_connection *smbd_get_connection(
  */
 int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
 {
-	struct smbdirect_socket *sc = &info->socket;
+	struct smbdirect_socket *sc = info->socket;
 
 	if (!smbdirect_connection_is_connected(sc))
 		return -ENOTCONN;
@@ -404,7 +402,7 @@ int smbd_send(struct TCP_Server_Info *server,
 	int num_rqst, struct smb_rqst *rqst_array)
 {
 	struct smbd_connection *info = server->smbd_conn;
-	struct smbdirect_socket *sc = &info->socket;
+	struct smbdirect_socket *sc = info->socket;
 	const struct smbdirect_socket_parameters *sp = smbd_get_parameters(info);
 	struct smb_rqst *rqst;
 	struct iov_iter iter;
@@ -500,7 +498,7 @@ struct smbdirect_mr_io *smbd_register_mr(struct smbd_connection *info,
 				 struct iov_iter *iter,
 				 bool writing, bool need_invalidate)
 {
-	struct smbdirect_socket *sc = &info->socket;
+	struct smbdirect_socket *sc = info->socket;
 
 	if (!smbdirect_connection_is_connected(sc))
 		return NULL;
@@ -535,7 +533,7 @@ void smbd_debug_proc_show(struct TCP_Server_Info *server, struct seq_file *m)
 		return;
 	}
 
-	smbdirect_connection_legacy_debug_proc_show(&server->smbd_conn->socket,
+	smbdirect_connection_legacy_debug_proc_show(server->smbd_conn->socket,
 						    server->rdma_readwrite_threshold,
 						    m);
 }
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 3f623a37aedc..35172076f2ee 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -37,7 +37,7 @@ extern int smbd_receive_credit_max;
  * 5. mempools for allocating packets
  */
 struct smbd_connection {
-	struct smbdirect_socket socket;
+	struct smbdirect_socket *socket;
 	struct workqueue_struct *workqueue;
 };
 
-- 
2.43.0

