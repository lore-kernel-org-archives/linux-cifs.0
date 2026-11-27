Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795783363;
	b=mVV/aYukfV6Hvrmp/nR1ShgONbmGhLRbx5Yp+MYCwIzKChS+OLwwrdD9ZsazGyadC9fw
	 Tc+NOXoDFvOeUkadAjstJCp3Fd3mwZ/F2OAFrfRaCe1DHH1g88+TeDwjJNPPi+NmfExK/
	 3tVpcfpDJPU9olS4geort9Q2d7qV5M+h+JoUt4T5jqjKW7jonhrd3jXu5tOhKDvLaWaCG
	 6bKJk9KEl9VKKqQ4ttkmTgOawgrRWl/5/tgbCdDPEGesT/IePh8Rf/9T4KFv+mD9NY9dN
	 WWCtox3G9j0/WP7/4WIbbbx1LqHVi36JXRjd6lf0FgE0ihcX8N59lul7URyHnJP2ehg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795783363;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=oCIH/MKvfBEeH1Gt8GXk2NsMmKXIKR8bz50joRoNe/I=;
	b=f48vrbtjt8Mon/NuOryJK22clwPHfa9vBA9QUIzoMMUFkz3GRifyVQxzK+8hhWwD82xJ
	 Gl2M/VkkmYbaR2Yznht2aK+s9PoLnZsCZUJ5nZaCxvqBq4p4HZ1mfZ81dK9YhsxA8UGa8
	 nQXeTEU2QVMLTRRrf7ZWLEfQR9GuIYniPatiKPtYX93MZvCix3ZtiYCHtlyFb8y77Ytxw
	 TANPqLfHq58yAMrKJtPaRC4q71ZsugTlfUGqWlFYSHB1vLeg8Zfx3ygBzG47bgSm5XyeW
	 JaFQ0xGlz7SI3aJZ01hUIiJKSUcu/RbaZ0zuJWN7CuWOBbNnX7f4q3kWI3EXcUzZJXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=LwyJL8i+;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB6D606A31F;
	Fri, 27 Nov 2026 12:42:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CFB6D606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=LwyJL8i+
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=oCIH/MKvfBEeH1Gt8GXk2NsMmKXIKR8bz50joRoNe/I=; b=LwyJL8i+CEoz0SjIFP3AGn/wrT
	u8bSr3ZjnXaXacuhe118HKWfsFe9nu+8T0aQ+gMGd3OaXC1hnPK0T5xZPlp2q1XxyudLz53b58BPD
	Hn1YOZGSsWww7aZueTD8RfqJig/az8Fx4e8cRrDIeiSYnDYg6asfsH8+pL5sN8+D5auOvUx9bECN5
	KVcxhsLboYUh3C9TqcGiqAs0mROlTNlmXsfJVbOYhe1RSYz1Wwdm55mjlG3v2KLydnyuvS22jwVr4
	MLYOE+67IAfOpDsc669F2aicCySrvR7UxOU43txMBmRy/20Bsya2NA9y/NHh7UrwHeYZylUD23VXB
	wg6ECTq+srWG7oC6B3DQU/E5NmHZK136pJbRZVpqSFcFpqBqpIgka7nXgC4FduP51ARxQ5ufpUMXI
	MlQ53NMimy2P8F9sICVLrRf89t3ivbcQSxPQi56TyBZe4EpibJIGJn35/+tZgrq72uVF8VzMhcYW/
	i95cXMGA9Fo1szY08uCeMV/w;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWvHg-00000001MDJ-43jU;
	Fri, 27 Nov 2026 12:42:37 +0000
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
Subject: [PATCH 7/8] smb: client: don't use zero RDMA limits without a connection
Date: Fri, 27 Nov 2026 13:41:40 +0100
Message-ID: <60b73e5e7b74ac01820640ee4bb5385b6b1dc081.1795782695.git.metze@samba.org>
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

smbd_get_parameters() fills the parameters with zeros if there's no
connection (anymore), e.g. during a reconnect. With signing
smb3_negotiate_wsize() and smb3_negotiate_rsize() subtracted the
header sizes from the zero max_fragmented_send_size and
max_fragmented_recv_size, which underflows, so the RDMA limit was
lost, without signing they used the zero max_read_write_size.
cifs_prepare_write() and cifs_prepare_read() used the zero
max_frmr_depth for sreq_max_segs.

Let smbd_get_parameters() return -ENOTCONN in that case and only
apply the RDMA limits if it succeeded. cifs_negotiate_wsize() and
cifs_negotiate_rsize() only lower an already negotiated size, so the
limits of the last connection stay in place until
cifs_renegotiate_iosize() applies the ones of the new connection
after the reconnect.

Fixes: b8aef8c8808c ("smb: client: make use of smbdirect_socket_create_kern()/smbdirect_socket_release()")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-d40006cd-d7c3-4ea8-8ebb-1bf2b55b0db0
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
 fs/smb/client/file.c      |  8 ++++----
 fs/smb/client/smb2ops.c   | 28 ++++++++++++++++++++--------
 fs/smb/client/smbdirect.c | 17 ++++++++++++-----
 fs/smb/client/smbdirect.h |  4 ++--
 4 files changed, 38 insertions(+), 19 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 1ad742fbe23b..e7ed1ad58f37 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -394,8 +394,8 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
 	if (server->smbd_conn) {
 		struct smbdirect_socket_parameters sp;
 
-		smbd_get_parameters(server, &sp);
-		stream->sreq_max_segs = sp.max_frmr_depth;
+		if (smbd_get_parameters(server, &sp) == 0)
+			stream->sreq_max_segs = sp.max_frmr_depth;
 	}
 #endif
 }
@@ -613,8 +613,8 @@ static int cifs_prepare_read(struct netfs_io_subrequest *subreq)
 	if (server->smbd_conn) {
 		struct smbdirect_socket_parameters sp;
 
-		smbd_get_parameters(server, &sp);
-		rreq->io_streams[0].sreq_max_segs = sp.max_frmr_depth;
+		if (smbd_get_parameters(server, &sp) == 0)
+			rreq->io_streams[0].sreq_max_segs = sp.max_frmr_depth;
 	}
 #endif
 	return 0;
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 052596978c2b..0f82fba40b64 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -514,15 +514,21 @@ smb3_negotiate_wsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 {
 	struct TCP_Server_Info *server = tcon->ses->server;
 	unsigned int wsize;
+#ifdef CONFIG_CIFS_SMB_DIRECT
+	struct smbdirect_socket_parameters sp;
+#endif
 
 	/* start with specified wsize, or default */
 	wsize = ctx->got_wsize ? ctx->vol_wsize : SMB3_DEFAULT_IOSIZE;
 	wsize = min_t(unsigned int, wsize, server->max_write);
 #ifdef CONFIG_CIFS_SMB_DIRECT
-	if (server->rdma) {
-		struct smbdirect_socket_parameters sp;
-
-		smbd_get_parameters(server, &sp);
+	/*
+	 * Without a connection there are no RDMA limits, the zeros would
+	 * underflow below. The caller keeps the limits of the last
+	 * connection, see cifs_negotiate_wsize(), and
+	 * cifs_renegotiate_iosize() applies the ones of the next one.
+	 */
+	if (server->rdma && smbd_get_parameters(server, &sp) == 0) {
 		if (server->sign)
 			/*
 			 * Account for SMB2 data transfer packet header and
@@ -565,15 +571,21 @@ smb3_negotiate_rsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 {
 	struct TCP_Server_Info *server = tcon->ses->server;
 	unsigned int rsize;
+#ifdef CONFIG_CIFS_SMB_DIRECT
+	struct smbdirect_socket_parameters sp;
+#endif
 
 	/* start with specified rsize, or default */
 	rsize = ctx->got_rsize ? ctx->vol_rsize : SMB3_DEFAULT_IOSIZE;
 	rsize = min_t(unsigned int, rsize, server->max_read);
 #ifdef CONFIG_CIFS_SMB_DIRECT
-	if (server->rdma) {
-		struct smbdirect_socket_parameters sp;
-
-		smbd_get_parameters(server, &sp);
+	/*
+	 * Without a connection there are no RDMA limits, the zeros would
+	 * underflow below. The caller keeps the limits of the last
+	 * connection, see cifs_negotiate_rsize(), and
+	 * cifs_renegotiate_iosize() applies the ones of the next one.
+	 */
+	if (server->rdma && smbd_get_parameters(server, &sp) == 0) {
 		if (server->sign)
 			/*
 			 * Account for SMB2 data transfer packet header and
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 99f526281909..5cc199fca558 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -403,17 +403,24 @@ static void smbd_put_socket(struct smbdirect_socket *sc)
  * The copy is done under server->srv_lock, which also prevents
  * server->smbd_conn from being destroyed, see smbd_destroy().
  *
- * If there's no connection (anymore), *sp is filled with zeros.
+ * If there's no connection (anymore), *sp is filled with zeros and
+ * -ENOTCONN is returned, the callers must not use the zeros as limits.
  */
-void smbd_get_parameters(struct TCP_Server_Info *server,
-			 struct smbdirect_socket_parameters *sp)
+int smbd_get_parameters(struct TCP_Server_Info *server,
+			struct smbdirect_socket_parameters *sp)
 {
+	int ret = 0;
+
 	spin_lock(&server->srv_lock);
-	if (server->smbd_conn && server->smbd_conn->socket)
+	if (server->smbd_conn && server->smbd_conn->socket) {
 		*sp = *smbdirect_socket_get_current_parameters(server->smbd_conn->socket);
-	else
+	} else {
 		memset(sp, 0, sizeof(*sp));
+		ret = -ENOTCONN;
+	}
 	spin_unlock(&server->srv_lock);
+
+	return ret;
 }
 
 struct smbd_connection *smbd_get_connection(
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 528e2ee81cbd..ba67bddf5907 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -33,8 +33,8 @@ struct smbd_connection *smbd_get_connection(
 void smbd_set_connection(struct TCP_Server_Info *server,
 			 struct smbd_connection *info);
 
-void smbd_get_parameters(struct TCP_Server_Info *server,
-			 struct smbdirect_socket_parameters *sp);
+int smbd_get_parameters(struct TCP_Server_Info *server,
+			struct smbdirect_socket_parameters *sp);
 
 /* Reconnect SMBDirect session */
 int smbd_reconnect(struct TCP_Server_Info *server);
-- 
2.43.0

