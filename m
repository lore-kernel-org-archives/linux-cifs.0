Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CB0305688
	for <linux-cifs@vger.kernel.org>; Mon,  5 Oct 2026 18:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791226043; cv=none; b=NsFQF1o2BK4OMy+QjIHjaCXpVYBwiAzxds93VmN36CR/eurzmjOj5Fksi+zTL9nH3W00vHPrPcLlosSIqASlaODEWvjrHVFl0+nLLj6Tozmwx19MUorxp0qFDmtu7F9jBR6aYZNLMZuIzd28xV5x0EdvqdBISkxU/s669MIWhbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791226043; c=relaxed/simple;
	bh=a3lTyWTjWxJBBScxkdIrMoDeDuYBsT57/EpwVGlyyoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lrQcPsNyPVDZdMGsYHqdJoCwSWMj9FDomMLeVNCO9WAYhhKwRXe8qVk6K6xz05Uw2HV7qjuDcim8koggcRckuQja/PVqfzO/2X0NSJ9iJgjQpgenuOlBZic3KkVtXceQl5FFc5EI6WiBmMbLOaXbhJ/sZ3qqaULs/88+ieN7b0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=G49v7TlB; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="G49v7TlB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=87rUrxsIrEovC1DjzhGyYKyfhatbtolKT79e53cOyBs=; b=G49v7TlBGcxzqD+WmwHCEkdvCt
	KMeeJfvFEy/SXJnIfBND22Y8jBhj9k72+8gxHQ8JgJI9Tro3xPgvtXYQRrY4xqyC+bBt8dLn6ogsl
	weqGqZQwF4ciiZAJtw0CPyP4BjFOv0iUKQY07YcQG5sjvMb4JjuTZr2RGFQO9blgHI1uu+EUUjKBn
	qjsfWTZzzm7j/Q1+bgudOLXFG4433A/5pAQ5BuNKPhZzPsfgjT7Kf3UMYbg3tFX5t5BekYS3dA4QE
	EKNNVhf44lAP64L6Q6/m0ifFWt+wiWkYc2nnU6FehRASttB4/oqybIM7aMDkZuCVObM9RG8p5wjGQ
	ZcHC5rO/VFKvR8+PP4IIIzviLo+TbxcMnodhhgmcjmHyhc/EE7eImV8YlUpFCCQ6pKra5uw4itFe9
	JiwPTJFgYj4IYun1bvH1UqYBIsLS6Xa4/LuLbOxPDylhW/xzNkD3wnQ7D892Y1eDXgI+x4iVU6qVY
	cIcNkK7/Mym/T6ZdHMO6wydd;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xDniY-00000005f8R-2Ozq;
	Mon, 05 Oct 2026 18:47:18 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH 1/5] smb: client: change server->smbd_conn only under server->srv_lock
Date: Mon,  5 Oct 2026 20:46:56 +0200
Message-ID: <c112553d31de7473516e06abebf2b10fcc181e83.1791225453.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791225453.git.metze@samba.org>
References: <cover.1791225453.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smbd_get_parameters(), smbd_register_mr() and smbd_debug_proc_show()
use server->smbd_conn without holding cifs_server_lock(), while
cifs_abort_connection() can destroy it via smbd_destroy() at any time,
which frees the smbd_connection and releases the smbdirect socket.
smbd_debug_proc_show() is called with cifs_tcp_ses_lock held, so
cifs_server_lock() can't be used there.

Change server->smbd_conn only under server->srv_lock, via the new
smbd_set_connection() and in smbd_destroy(), which now clears the
pointer under the lock before releasing the socket. This allows
readers to use server->smbd_conn under server->srv_lock.

cifs_get_tcp_session() calls smbd_destroy() on failure, also for
early failures before server->srv_lock is initialized, so only call
it if server->smbd_conn is set.

Fixes: b8aef8c8808c ("smb: client: make use of smbdirect_socket_create_kern()/smbdirect_socket_release()")
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/connect.c   | 12 +++++++++---
 fs/smb/client/smbdirect.c | 29 +++++++++++++++++++++++++----
 fs/smb/client/smbdirect.h |  4 ++++
 3 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 28e1ddeb6182..a45411037253 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1858,8 +1858,9 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 		rc = -ENOENT;
 		goto out_err_crypto_release;
 #endif
-		tcp_ses->smbd_conn = smbd_get_connection(
-			tcp_ses, (struct sockaddr *)&ctx->dstaddr);
+		smbd_set_connection(tcp_ses,
+				    smbd_get_connection(tcp_ses,
+							(struct sockaddr *)&ctx->dstaddr));
 		if (tcp_ses->smbd_conn) {
 			cifs_dbg(VFS, "RDMA transport established\n");
 			rc = 0;
@@ -1934,7 +1935,12 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 		kfree(tcp_ses->leaf_fullpath);
 		if (tcp_ses->ssocket)
 			sock_release(tcp_ses->ssocket);
-		smbd_destroy(tcp_ses);
+		/*
+		 * srv_lock is not initialized yet for
+		 * the early gotos, but smbd_conn is NULL then.
+		 */
+		if (tcp_ses->smbd_conn)
+			smbd_destroy(tcp_ses);
 		kfree(tcp_ses);
 	}
 	return ERR_PTR(rc);
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 563ef488a225..3ecf34c7379a 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -201,7 +201,17 @@ static int smbd_post_send_full_iter(struct smbdirect_socket *sc,
  */
 void smbd_destroy(struct TCP_Server_Info *server)
 {
-	struct smbd_connection *info = server->smbd_conn;
+	struct smbd_connection *info;
+
+	/*
+	 * server->smbd_conn is changed under server->srv_lock,
+	 * so that readers which don't hold cifs_server_lock()
+	 * can use it under server->srv_lock.
+	 */
+	spin_lock(&server->srv_lock);
+	info = server->smbd_conn;
+	server->smbd_conn = NULL;
+	spin_unlock(&server->srv_lock);
 
 	if (!info) {
 		log_rdma_event(INFO, "rdma session already destroyed\n");
@@ -211,7 +221,17 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	smbdirect_socket_release(info->socket);
 
 	kfree(info);
-	server->smbd_conn = NULL;
+}
+
+/*
+ * Publish a new connection, see smbd_destroy()
+ */
+void smbd_set_connection(struct TCP_Server_Info *server,
+			 struct smbd_connection *info)
+{
+	spin_lock(&server->srv_lock);
+	server->smbd_conn = info;
+	spin_unlock(&server->srv_lock);
 }
 
 /*
@@ -236,8 +256,9 @@ int smbd_reconnect(struct TCP_Server_Info *server)
 
 create_conn:
 	log_rdma_event(INFO, "creating rdma session\n");
-	server->smbd_conn = smbd_get_connection(
-		server, (struct sockaddr *) &server->dstaddr);
+	smbd_set_connection(server,
+			    smbd_get_connection(server,
+						(struct sockaddr *) &server->dstaddr));
 
 	if (server->smbd_conn) {
 		cifs_dbg(VFS, "RDMA transport re-established\n");
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index be205ec02077..54ee49f9cfc6 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -30,6 +30,8 @@ struct smbd_connection {
 /* Create a SMBDirect session */
 struct smbd_connection *smbd_get_connection(
 	struct TCP_Server_Info *server, struct sockaddr *dstaddr);
+void smbd_set_connection(struct TCP_Server_Info *server,
+			 struct smbd_connection *info);
 
 const struct smbdirect_socket_parameters *smbd_get_parameters(struct smbd_connection *conn);
 
@@ -58,6 +60,8 @@ void smbd_debug_proc_show(struct TCP_Server_Info *server, struct seq_file *m);
 struct smbd_connection {};
 static inline void *smbd_get_connection(
 	struct TCP_Server_Info *server, struct sockaddr *dstaddr) {return NULL;}
+static inline void smbd_set_connection(struct TCP_Server_Info *server,
+				       struct smbd_connection *info) {}
 static inline int smbd_reconnect(struct TCP_Server_Info *server) {return -1; }
 static inline void smbd_destroy(struct TCP_Server_Info *server) {}
 static inline int smbd_recv(struct smbd_connection *info, struct msghdr *msg) {return -1; }
-- 
2.43.0

