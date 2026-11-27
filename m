Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795783337;
	b=1IP8whOkey0o6TYEFM8xEt5Ixeqc478K8Cvvd+D4W1ncVdM+vz0aR7Y0h7dhBE0kJdgc
	 C/nputlsGbwXkp4GBYERdT63ogTx1Y2XEKiDaXadi6hV2TSLFjJjSCFk4ivtmt/RziJPG
	 EmIkIOlqUy47/IUQEM7POifH+ixMy2GqPUM7RTycifc4qNdkvEr+KZL0m9/FV/iEt03cG
	 4nAb8FuILYz5AUEs+ZH52/GnmmzgYkw4Dt2ImNn6hyieLHnK64EMP7fBtU5GbYOTeXp7X
	 Gnjb/3rx/3/vhH/a2uWg/Iq3uLeN4k89iYpOzVgQ6OLQw/uM/jt6zAA3Xf7H277cOLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795783337;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=MHMN0/hLqnyXIU6W6rOUIIoDLki2Hv2yDSarNft7IX4=;
	b=fUvv4Im7CNGRhDDO0w63bhNUYGjwcIVRRnPBb84Aiq7TAGf6gO1zLvnrjjXPb8B2yb6E
	 r/w/W/3vHzRRklDG5jXpMw96SIfaGiCtv+8a8cPKv4XqTl+UK/nWIoLGKcO1zIyrEVQOR
	 ZATn8hklnORV3DA4GXiHMO0TeV84GvXAHfScznK4rGdjv3z8buYnUa2/i+fwZ20XwF74i
	 IVQcH4q3e8ZeATdulECKLeKTl10BWzdvWKcKzRmchcgAElmUvlgB5uQ6JLAAkaDVUnFtZ
	 p77SC5nKrWCVBqn4LNaIRl1tPiSnQkRvCo7jC9q5sOGyaTz8N3lhey1tqnld2ZQITiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=jx9uspbD;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90971606A31C;
	Fri, 27 Nov 2026 12:42:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90971606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=jx9uspbD
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=MHMN0/hLqnyXIU6W6rOUIIoDLki2Hv2yDSarNft7IX4=; b=jx9uspbDBoMyU947FV3U7YH8TV
	eD48REbS12SQ1waatJR0l/6rtfadikTOpqucmq+7ftHWU+HnbV5ifnZpFNX8IQEBgE0pj+jtFiE1a
	loy9C6S90OilfcYGqGEi/UIfAA2627aG/oTJog4yiwTP54I7/mVDPA1LXSLeJEksuvN5orPjtXJDr
	Sy9oXZVTX/qO3wPY0jZ36gL9QKjUnnN7ssdGbytdnJ0EW5nFhBXIN/J087d9jOftF57Z64HDPgM0Y
	4ALVOc3Khm4YyAYODoQVvrgxQ165dsD8UKK2QFw4WqtTzasuAf+eSoMQEVqQ5CXju//bbr3Bcocmn
	E/1rkPH8bCLD8OoZi1ui9SqFEPo/4DxpvSL540YJ0dNU57znzyKPMzPtgJJBYCQMsDMLfcdSPiAyT
	D47mqHIEAmviE2xH4w4ozAFOcVLpfrW6Jqjx37Lqoow22lDdMR5X2LaxxqE0JuYEM25LovJ+OeJ/T
	TZgRTnQFDEGPxwFyriw9vy80;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWvHJ-00000001M7s-2pbU;
	Fri, 27 Nov 2026 12:42:13 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Tom Talpey <tom@talpey.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 3/8] smb: client: change server->smbd_conn only under server->srv_lock
Date: Fri, 27 Nov 2026 13:41:36 +0100
Message-ID: <880f90d637facadf1fd5979bb22181e7792d3b8e.1795782695.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1795782695.git.metze@samba.org>
References: <cover.1795782695.git.metze@samba.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
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
Cc: stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/connect.c   | 19 +++++++++++++------
 fs/smb/client/smbdirect.c | 27 +++++++++++++++++++++++----
 fs/smb/client/smbdirect.h |  4 ++++
 3 files changed, 40 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index e79f9afe4128..064b70bf1fdf 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1883,20 +1883,22 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	tcp_ses->echo_interval = ctx->echo_interval * HZ;
 
 	if (tcp_ses->rdma) {
+		struct smbd_connection *conn;
+
 #ifndef CONFIG_CIFS_SMB_DIRECT
 		cifs_dbg(VFS, "CONFIG_CIFS_SMB_DIRECT is not enabled\n");
 		rc = -ENOENT;
 		goto out_err_crypto_release;
 #endif
-		tcp_ses->smbd_conn = smbd_get_connection(
-			tcp_ses, (struct sockaddr *)&ctx->dstaddr);
-		if (!IS_ERR(tcp_ses->smbd_conn)) {
+		conn = smbd_get_connection(tcp_ses,
+					   (struct sockaddr *)&ctx->dstaddr);
+		if (!IS_ERR(conn)) {
+			smbd_set_connection(tcp_ses, conn);
 			cifs_dbg(VFS, "RDMA transport established\n");
 			rc = 0;
 			goto smbd_connected;
 		} else {
-			rc = PTR_ERR(tcp_ses->smbd_conn);
-			tcp_ses->smbd_conn = NULL;
+			rc = PTR_ERR(conn);
 			goto out_err_crypto_release;
 		}
 	}
@@ -1967,7 +1969,12 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
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
index d05d90482e74..e9739f9e36c9 100644
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
@@ -240,12 +260,11 @@ int smbd_reconnect(struct TCP_Server_Info *server)
 	log_rdma_event(INFO, "creating rdma session\n");
 	conn = smbd_get_connection(server, (struct sockaddr *)&server->dstaddr);
 	if (IS_ERR(conn)) {
-		server->smbd_conn = NULL;
 		trace_smb3_smbd_connect_err(server->hostname, server->conn_id, &server->dstaddr);
 		return PTR_ERR(conn);
 	}
 
-	server->smbd_conn = conn;
+	smbd_set_connection(server, conn);
 	cifs_dbg(VFS, "RDMA transport re-established\n");
 	trace_smb3_smbd_connect_done(server->hostname, server->conn_id, &server->dstaddr);
 	return 0;
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 52fef7354f2a..283809a57fb6 100644
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
 	struct TCP_Server_Info *server, struct sockaddr *dstaddr) {return ERR_PTR(-EOPNOTSUPP); }
+static inline void smbd_set_connection(struct TCP_Server_Info *server,
+				       struct smbd_connection *info) {}
 static inline int smbd_reconnect(struct TCP_Server_Info *server) {return -1; }
 static inline void smbd_destroy(struct TCP_Server_Info *server) {}
 static inline int smbd_recv(struct smbd_connection *info, struct msghdr *msg) {return -1; }
-- 
2.43.0

