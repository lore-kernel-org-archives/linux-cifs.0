Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795783355;
	b=is15bdSgYKINVQQUKJu+6OWC8dP2WreJx/BSiGT3U/ztbQpx9wmQPpCG9OtCcNafrfAH
	 1qpjwk4YgfbQXpBl0+3R8sM36T4xKgeHVSQlnN4vJ//ZoekKu4cyx1KLHgafbHKu6bs+g
	 GA9xqXfR8w1W5TKC/UvlxYlU6QeZMnoWP06alXbxa73l2u28GCnD+Kx9olwrZNIXPt3Zg
	 l3vBkV6mtSrWfqYrXMKVUGPRzsQytr91pepf74y+Eykb5MBften02pKhh635yAhlxLi6Q
	 01+vrs+3rF0jQey2MK7530TmfL2YGPGAwLEfLl9xX12iz1RnGeZWA4sOjeC6Gy2EGeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795783355;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=OHDZ8hU4UDPJYNRMy7hZCyDXcnAt7Ny8xuUR6sb8AbY=;
	b=TWn3AJhhVre9roeytK0eDldhnDUXuioldq+Mr6GgqJnJ5URNlXNHb7eEIeER7VcFneSD
	 A4Wz1/Pf70z5tYwTWuDD2gtOzuSzzr/n5KJXirbMSAJAvZRDM5aJjZwfREkyaJSWTmUBW
	 oeK+salUn+TvbSGyIIdjXfFc6sUfz/v+CLcMbNJLmj9i5Iw3kNQwOZnquvm5/5A3ZP8pY
	 ufx30VoIrbjhLsqK6/HhLnHQ/NKWtKhqvQ0M0CKQ9CoeVRvVlG07FXA+lvn4mUhRKOnLU
	 4QE/q7m2+ggtQ1KjciSHnOokW5u70c6DvWrsDe4kRARR8+1pAA+AQC+EO9cCxxTjeDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=aRyHJIMn;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7ED606A31C;
	Fri, 27 Nov 2026 12:42:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F7ED606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=aRyHJIMn
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=OHDZ8hU4UDPJYNRMy7hZCyDXcnAt7Ny8xuUR6sb8AbY=; b=aRyHJIMn5z8cO8jW2mspKMlQoE
	G2Mf/VSDuk4l7UOCuI9f9+aF06BuuvUk4Xuqb0zQUI9vf9ujICx0cYNHOK6y6yJ8Ap0qZXyly8PNC
	Hj2sG2jZ4LJjCuIBf+IiLQy29d+HVubKMK9lVti+TAbTZVTXGwsjqf3UvK4m3xaJnHzJEYSUgkXFU
	tYtoEDXqIJmorldEvvAbFWHPYq7A1RAbQG4OPOx2D75iELxAYbRIluNdR9A8Oh11R6VJU3XDP3hyA
	ooj7JlIa8qUjOnwszVnf0IR/3bV4duNoLgrTUKL5tBNOXfQtAnzHVEkMZGgDlqKoDaluNd7OsRa58
	oaZu8uOxV3OQXIdleSsPx8fpON15rXQjw7s665R1BApUN63VDPSxaEj46g0MZCbQUEYcHP21Wp41O
	MjJ/3hShqI/6EDsgBwN1mnZNW5f33nVcop4Rl4f8GY/x2pDZjRk31owi6m0Aa+AK/r/rUYY0gggxM
	bsk9/UHi39GM+l3FBs0GI+Sq;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWvHa-00000001MC8-33yp;
	Fri, 27 Nov 2026 12:42:31 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Tom Talpey <tom@talpey.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 6/8] smb: client: don't use server->smbd_conn without a reference or lock
Date: Fri, 27 Nov 2026 13:41:39 +0100
Message-ID: <9526552341ea5d4d46eb7f0e39a95744f1d8c63d.1795782695.git.metze@samba.org>
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
used server->smbd_conn without any locking, while
cifs_abort_connection() can destroy it via smbd_destroy() at any
time, which frees the smbd_connection and releases the smbdirect
socket.

smbd_register_mr() now uses the new smbd_get_socket() and
smbd_put_socket(), which take and drop a reference on the socket of
server->smbd_conn under server->srv_lock via smbdirect_socket_get()
and smbdirect_socket_put(). Once the connection is destroyed, the
socket is no longer connected, so
smbdirect_connection_register_mr_io() fails gracefully. A registered
mr has its own reference counting.

smbd_debug_proc_show() is called with cifs_tcp_ses_lock held, so it
holds server->srv_lock instead, which prevents server->smbd_conn from
being destroyed.

smbd_get_parameters() returned a pointer into the socket, which can't
be kept valid for the callers. Now it copies the parameters into a
caller-provided struct under server->srv_lock, so each caller gets its
own stable snapshot. If there's no connection (anymore), the snapshot
is filled with zeros. This also fixes a possible NULL pointer
dereference in smb2_negotiate_wsize() and smb2_negotiate_rsize(),
which called smbd_get_parameters(server->smbd_conn) without checking
server->smbd_conn, e.g. during a reconnect. The per-caller snapshot
also avoids a torn read, where a concurrent connection drop could zero
the parameters mid-use, e.g. underflowing a zero
max_fragmented_send_size in those functions or reading max_frmr_depth
as 0.

smbd_send() is called under cifs_server_lock(), so it uses
smbdirect_socket_get_current_parameters() directly.

Fixes: b8aef8c8808c ("smb: client: make use of smbdirect_socket_create_kern()/smbdirect_socket_release()")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
Closes: https://sashiko.dev/#/patchset/cover.1791225453.git.metze%40samba.org
Closes: https://sashiko.dev/#/bug/linux-211bb822-8907-4243-9dd3-da2595595552
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
 fs/smb/client/file.c      | 12 +++---
 fs/smb/client/smb2ops.c   | 16 +++----
 fs/smb/client/smbdirect.c | 91 +++++++++++++++++++++++++++++++++------
 fs/smb/client/smbdirect.h |  3 +-
 4 files changed, 94 insertions(+), 28 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index f61e80e3d88c..1ad742fbe23b 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -392,10 +392,10 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
 
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (server->smbd_conn) {
-		const struct smbdirect_socket_parameters *sp =
-			smbd_get_parameters(server);
+		struct smbdirect_socket_parameters sp;
 
-		stream->sreq_max_segs = sp->max_frmr_depth;
+		smbd_get_parameters(server, &sp);
+		stream->sreq_max_segs = sp.max_frmr_depth;
 	}
 #endif
 }
@@ -611,10 +611,10 @@ static int cifs_prepare_read(struct netfs_io_subrequest *subreq)
 
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (server->smbd_conn) {
-		const struct smbdirect_socket_parameters *sp =
-			smbd_get_parameters(server);
+		struct smbdirect_socket_parameters sp;
 
-		rreq->io_streams[0].sreq_max_segs = sp->max_frmr_depth;
+		smbd_get_parameters(server, &sp);
+		rreq->io_streams[0].sreq_max_segs = sp.max_frmr_depth;
 	}
 #endif
 	return 0;
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 14383c37ae9e..052596978c2b 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -520,9 +520,9 @@ smb3_negotiate_wsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 	wsize = min_t(unsigned int, wsize, server->max_write);
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (server->rdma) {
-		const struct smbdirect_socket_parameters *sp =
-			smbd_get_parameters(server);
+		struct smbdirect_socket_parameters sp;
 
+		smbd_get_parameters(server, &sp);
 		if (server->sign)
 			/*
 			 * Account for SMB2 data transfer packet header and
@@ -530,12 +530,12 @@ smb3_negotiate_wsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 			 */
 			wsize = min_t(unsigned int,
 				wsize,
-				sp->max_fragmented_send_size -
+				sp.max_fragmented_send_size -
 					SMB2_READWRITE_PDU_HEADER_SIZE -
 					sizeof(struct smb2_transform_hdr));
 		else
 			wsize = min_t(unsigned int,
-				wsize, sp->max_read_write_size);
+				wsize, sp.max_read_write_size);
 	}
 #endif
 	if (!(server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU))
@@ -571,9 +571,9 @@ smb3_negotiate_rsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 	rsize = min_t(unsigned int, rsize, server->max_read);
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (server->rdma) {
-		const struct smbdirect_socket_parameters *sp =
-			smbd_get_parameters(server);
+		struct smbdirect_socket_parameters sp;
 
+		smbd_get_parameters(server, &sp);
 		if (server->sign)
 			/*
 			 * Account for SMB2 data transfer packet header and
@@ -581,12 +581,12 @@ smb3_negotiate_rsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 			 */
 			rsize = min_t(unsigned int,
 				rsize,
-				sp->max_fragmented_recv_size -
+				sp.max_fragmented_recv_size -
 					SMB2_READWRITE_PDU_HEADER_SIZE -
 					sizeof(struct smb2_transform_hdr));
 		else
 			rsize = min_t(unsigned int,
-				rsize, sp->max_read_write_size);
+				rsize, sp.max_read_write_size);
 	}
 #endif
 
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 9fe92db606ad..99f526281909 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -362,17 +362,58 @@ static struct smbd_connection *_smbd_get_connection(
 	return ERR_PTR(ret);
 }
 
-const struct smbdirect_socket_parameters *smbd_get_parameters(struct TCP_Server_Info *server)
+/*
+ * server->smbd_conn can be destroyed by cifs_abort_connection()
+ * at any time, so we take a reference on its socket while we use
+ * it. server->smbd_conn is changed under server->srv_lock,
+ * see smbd_set_connection() and smbd_destroy().
+ *
+ * Once the connection is destroyed, the socket is no longer
+ * connected, so the smbdirect functions fail gracefully.
+ *
+ * smbd_put_socket() may free the socket, so this
+ * can only be used in process context.
+ */
+static struct smbdirect_socket *smbd_get_socket(struct TCP_Server_Info *server)
 {
-	struct smbd_connection *conn = server->smbd_conn;
-
-	if (unlikely(!conn->socket)) {
-		static const struct smbdirect_socket_parameters zero_params;
+	struct smbdirect_socket *sc = NULL;
 
-		return &zero_params;
+	spin_lock(&server->srv_lock);
+	if (server->smbd_conn && server->smbd_conn->socket) {
+		sc = server->smbd_conn->socket;
+		smbdirect_socket_get(sc);
 	}
+	spin_unlock(&server->srv_lock);
 
-	return smbdirect_socket_get_current_parameters(conn->socket);
+	return sc;
+}
+
+static void smbd_put_socket(struct smbdirect_socket *sc)
+{
+	if (sc)
+		smbdirect_socket_put(sc);
+}
+
+/*
+ * Copy the current smbdirect socket parameters into *sp, so each caller
+ * gets its own stable snapshot. server->smbd_conn and its socket can be
+ * destroyed at any time, so we can't return a pointer into the socket,
+ * and a single shared copy would be torn by a concurrent update.
+ *
+ * The copy is done under server->srv_lock, which also prevents
+ * server->smbd_conn from being destroyed, see smbd_destroy().
+ *
+ * If there's no connection (anymore), *sp is filled with zeros.
+ */
+void smbd_get_parameters(struct TCP_Server_Info *server,
+			 struct smbdirect_socket_parameters *sp)
+{
+	spin_lock(&server->srv_lock);
+	if (server->smbd_conn && server->smbd_conn->socket)
+		*sp = *smbdirect_socket_get_current_parameters(server->smbd_conn->socket);
+	else
+		memset(sp, 0, sizeof(*sp));
+	spin_unlock(&server->srv_lock);
 }
 
 struct smbd_connection *smbd_get_connection(
@@ -400,6 +441,9 @@ struct smbd_connection *smbd_get_connection(
 	if (IS_ERR(ret))
 		return ret;
 
+	/*
+	 * ret is not published in server->smbd_conn yet
+	 */
 	sp = smbdirect_socket_get_current_parameters(ret->socket);
 
 	server->rdma_readwrite_threshold =
@@ -445,7 +489,13 @@ int smbd_send(struct TCP_Server_Info *server,
 {
 	struct smbd_connection *info = server->smbd_conn;
 	struct smbdirect_socket *sc = info->socket;
-	const struct smbdirect_socket_parameters *sp = smbd_get_parameters(server);
+	/*
+	 * We're called under cifs_server_lock(), so
+	 * server->smbd_conn can't be destroyed while
+	 * we use it.
+	 */
+	const struct smbdirect_socket_parameters *sp =
+		smbdirect_socket_get_current_parameters(sc);
 	struct smb_rqst *rqst;
 	struct iov_iter iter;
 	struct smbdirect_send_batch_storage bstorage;
@@ -549,13 +599,19 @@ struct smbdirect_mr_io *smbd_register_mr(struct TCP_Server_Info *server,
 				 struct iov_iter *iter,
 				 bool writing, bool need_invalidate)
 {
-	struct smbd_connection *info = server->smbd_conn;
-	struct smbdirect_socket *sc = info->socket;
+	struct smbdirect_socket *sc = smbd_get_socket(server);
+	struct smbdirect_mr_io *mr = NULL;
 
-	if (!smbdirect_connection_is_connected(sc))
-		return NULL;
+	/*
+	 * The mr has its own reference counting
+	 * and doesn't need the socket reference
+	 * once registered.
+	 */
+	if (sc && smbdirect_connection_is_connected(sc))
+		mr = smbdirect_connection_register_mr_io(sc, iter, writing, need_invalidate);
+	smbd_put_socket(sc);
 
-	return smbdirect_connection_register_mr_io(sc, iter, writing, need_invalidate);
+	return mr;
 }
 
 void smbd_mr_fill_buffer_descriptor(struct smbdirect_mr_io *mr,
@@ -580,7 +636,15 @@ void smbd_debug_proc_show(struct TCP_Server_Info *server, struct seq_file *m)
 	if (!server->rdma)
 		return;
 
+	/*
+	 * We're called with cifs_tcp_ses_lock held, so we
+	 * can't use smbd_get_socket(), but holding
+	 * server->srv_lock prevents server->smbd_conn
+	 * from being destroyed, see smbd_destroy().
+	 */
+	spin_lock(&server->srv_lock);
 	if (!server->smbd_conn) {
+		spin_unlock(&server->srv_lock);
 		seq_puts(m, "\nSMBDirect transport not available");
 		return;
 	}
@@ -588,6 +652,7 @@ void smbd_debug_proc_show(struct TCP_Server_Info *server, struct seq_file *m)
 	smbdirect_connection_legacy_debug_proc_show(server->smbd_conn->socket,
 						    server->rdma_readwrite_threshold,
 						    m);
+	spin_unlock(&server->srv_lock);
 }
 
 MODULE_IMPORT_NS("SMBDIRECT");
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 7d99797de6fa..528e2ee81cbd 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -33,7 +33,8 @@ struct smbd_connection *smbd_get_connection(
 void smbd_set_connection(struct TCP_Server_Info *server,
 			 struct smbd_connection *info);
 
-const struct smbdirect_socket_parameters *smbd_get_parameters(struct TCP_Server_Info *server);
+void smbd_get_parameters(struct TCP_Server_Info *server,
+			 struct smbdirect_socket_parameters *sp);
 
 /* Reconnect SMBDirect session */
 int smbd_reconnect(struct TCP_Server_Info *server);
-- 
2.43.0

