Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795783332;
	b=I36KAXXlohnxNg5gsm/Vsqfe/OrXPhnwmLwnLX8nIr3COL7IWFJkZi6aNsC3DIvwiBi4
	 T+VwtyTkK475z2PWK4Sa4tN6Dnnwxec5AONU0I8DNM0wu/z5vit4/UcNGWsfjF+QsakAA
	 NCmOwmSrGncUtKo9zJecDXfL61bPPpQHzHNHB37uEMGAetCcBGfQwON2DHieirgTi+dLS
	 RUEsDLQIVowX9HfoiZFtNCcC6nNk5hyi3zj1S1x2XYSHBz+vuRfKWWotzAcV3Y2g7Ng/4
	 ai0QbsArW+EtSpGKTXuJ6a1KmJWeE6mJgkz/uUc6i6OQzUvsR5WtTeWiF4M4nc/dlJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795783332;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=nhLqtW4yr/V2OQAAfWHDLl1+FXAP6D0EJ71oMX05gOg=;
	b=Rpg/uUIQzwC009gPxZXGg0vh31/SbY77fRgQaolFmJQKrd4seAAcmyqrhZBPSK+vR35/
	 d5QfQn7hrK3/QA/EPTYX3leSJqnU3VXUQIk33QOJEOV8zup0M5v39nDOcyQEAEHOceUiX
	 ByS/TF1bsyxbd1i8xRT6Ma8mBRU50pQepTWQocZM2WX6h69yblftdGSS/SnBREC8+T5t6
	 TndaEz6wRjpZjTUV5zVX8qAqhvtO+ocCX0LTZB0YiyQEHEvp1RdhYdPBfXn0lUm5XMhG2
	 NlgMCb+XcaGTHtDzqGHrMwlxo3g9X7JoY0sI8Tm2wFXjcltOcPqEO3vCGyvA41oRWjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=afIm95aG;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA36606A32C;
	Fri, 27 Nov 2026 12:42:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7DA36606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=afIm95aG
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=nhLqtW4yr/V2OQAAfWHDLl1+FXAP6D0EJ71oMX05gOg=; b=afIm95aGiwSWujLALNpGBspegt
	/KcleJp7FYA3EJg9C60pcfRMXrBKjHh/BptchhQUmqy0X4+vXnr9SvFejYgb9PdRj6JBnnNI0smNB
	E0WaAReS3pjXIwY8UFqCVdwXTMhgI/1QZIS1RvLhkRyae3l2uWQKI9rJocFRZrbMDnWzX7qUHD3t1
	b0/pzrSldjQRzOWpzoj85sDzMqR1DaKKtIhAnkcfGaUqc/wgKkaor6TPJEzmJ/4DnyI6R9EpK2AXz
	RWa4MB1gz6hQlJry7BKdboqkfNGOXMHzJt3YKizcjcb/e2PP4kjd21SpcVUzHfl1O7/+z6Si/4LBU
	x+H+PQZ8Yekfr8hX7hQErCHAWQZpkIHAj6jnIDEGAGmwrKWnCW7zL3D0VhHhdxNZ8dWw6nr6CyGMB
	9glm5Fzp6xZmqS+m+ZCR/mxNap3KxZ59YdwNxQ2YPbJi/ou0zantSZXgWtNBRbJYBVoMFbJlAGIIG
	bD96aYUpXiiZL6lGhy6jw5eA;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWvHE-00000001M7b-0akk;
	Fri, 27 Nov 2026 12:42:08 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH 2/8] smb: client: return the real error from smbd_get_connection()
Date: Fri, 27 Nov 2026 13:41:35 +0100
Message-ID: <eb86e6bb65e335c824deaf43e9a091a864978a05.1795782695.git.metze@samba.org>
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

smbd_get_connection() returned NULL on failure, so the callers had
to make up an error: mount returned -ENOENT ("No such file or
directory") and smbd_reconnect() as well, which hides the real
reason, e.g. -ECONNREFUSED or -ENODEV if the route to the server
uses a netdev without an RDMA device.

Return an ERR_PTR() instead. If both ports fail, return the error of
SMBD_PORT, unless it's -ENODEV, which is what the attempt with the
wrong device type returns, as SMBD_PORT only allows iWarp devices and
SMB_PORT doesn't allow them.

Fixes: 2f8946464b11 ("CIFS: SMBD: Upper layer connects to SMBDirect session")
Cc: stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/connect.c   |  5 ++--
 fs/smb/client/smbdirect.c | 48 +++++++++++++++++++++++----------------
 fs/smb/client/smbdirect.h |  2 +-
 3 files changed, 33 insertions(+), 22 deletions(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 750b5bb72dc7..e79f9afe4128 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1890,12 +1890,13 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 #endif
 		tcp_ses->smbd_conn = smbd_get_connection(
 			tcp_ses, (struct sockaddr *)&ctx->dstaddr);
-		if (tcp_ses->smbd_conn) {
+		if (!IS_ERR(tcp_ses->smbd_conn)) {
 			cifs_dbg(VFS, "RDMA transport established\n");
 			rc = 0;
 			goto smbd_connected;
 		} else {
-			rc = -ENOENT;
+			rc = PTR_ERR(tcp_ses->smbd_conn);
+			tcp_ses->smbd_conn = NULL;
 			goto out_err_crypto_release;
 		}
 	}
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 563ef488a225..d05d90482e74 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -220,6 +220,8 @@ void smbd_destroy(struct TCP_Server_Info *server)
  */
 int smbd_reconnect(struct TCP_Server_Info *server)
 {
+	struct smbd_connection *conn;
+
 	log_rdma_event(INFO, "reconnecting rdma session\n");
 
 	if (!server->smbd_conn) {
@@ -236,16 +238,17 @@ int smbd_reconnect(struct TCP_Server_Info *server)
 
 create_conn:
 	log_rdma_event(INFO, "creating rdma session\n");
-	server->smbd_conn = smbd_get_connection(
-		server, (struct sockaddr *) &server->dstaddr);
-
-	if (server->smbd_conn) {
-		cifs_dbg(VFS, "RDMA transport re-established\n");
-		trace_smb3_smbd_connect_done(server->hostname, server->conn_id, &server->dstaddr);
-		return 0;
+	conn = smbd_get_connection(server, (struct sockaddr *)&server->dstaddr);
+	if (IS_ERR(conn)) {
+		server->smbd_conn = NULL;
+		trace_smb3_smbd_connect_err(server->hostname, server->conn_id, &server->dstaddr);
+		return PTR_ERR(conn);
 	}
-	trace_smb3_smbd_connect_err(server->hostname, server->conn_id, &server->dstaddr);
-	return -ENOENT;
+
+	server->smbd_conn = conn;
+	cifs_dbg(VFS, "RDMA transport re-established\n");
+	trace_smb3_smbd_connect_done(server->hostname, server->conn_id, &server->dstaddr);
+	return 0;
 }
 
 /* Create a SMBD connection, called by upper layer */
@@ -302,7 +305,7 @@ static struct smbd_connection *_smbd_get_connection(
 
 	info = kzalloc_obj(*info);
 	if (!info)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	ret = smbdirect_socket_create_kern(net, &sc);
 	if (ret)
 		goto socket_init_failed;
@@ -337,7 +340,7 @@ static struct smbd_connection *_smbd_get_connection(
 	smbdirect_socket_release(sc);
 socket_init_failed:
 	kfree(info);
-	return NULL;
+	return ERR_PTR(ret);
 }
 
 const struct smbdirect_socket_parameters *smbd_get_parameters(struct smbd_connection *conn)
@@ -356,18 +359,25 @@ struct smbd_connection *smbd_get_connection(
 {
 	struct smbd_connection *ret;
 	const struct smbdirect_socket_parameters *sp;
-	int port = SMBD_PORT;
 
-try_again:
-	ret = _smbd_get_connection(server, dstaddr, port);
+	ret = _smbd_get_connection(server, dstaddr, SMBD_PORT);
 
 	/* Try SMB_PORT if SMBD_PORT doesn't work */
-	if (!ret && port == SMBD_PORT) {
-		port = SMB_PORT;
-		goto try_again;
+	if (IS_ERR(ret)) {
+		struct smbd_connection *ret2;
+
+		ret2 = _smbd_get_connection(server, dstaddr, SMB_PORT);
+		/*
+		 * SMBD_PORT only allows iWarp devices and SMB_PORT
+		 * doesn't allow them, the attempt with the wrong
+		 * device type fails with -ENODEV, so we return
+		 * the error of the other one.
+		 */
+		if (!IS_ERR(ret2) || PTR_ERR(ret) == -ENODEV)
+			ret = ret2;
 	}
-	if (!ret)
-		return NULL;
+	if (IS_ERR(ret))
+		return ret;
 
 	sp = smbd_get_parameters(ret);
 
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index be205ec02077..52fef7354f2a 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -57,7 +57,7 @@ void smbd_debug_proc_show(struct TCP_Server_Info *server, struct seq_file *m);
 #define cifs_rdma_enabled(server)	0
 struct smbd_connection {};
 static inline void *smbd_get_connection(
-	struct TCP_Server_Info *server, struct sockaddr *dstaddr) {return NULL;}
+	struct TCP_Server_Info *server, struct sockaddr *dstaddr) {return ERR_PTR(-EOPNOTSUPP); }
 static inline int smbd_reconnect(struct TCP_Server_Info *server) {return -1; }
 static inline void smbd_destroy(struct TCP_Server_Info *server) {}
 static inline int smbd_recv(struct smbd_connection *info, struct msghdr *msg) {return -1; }
-- 
2.43.0

