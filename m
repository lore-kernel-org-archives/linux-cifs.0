Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795783343;
	b=cKOu3vguIqowmDFjOoezstvhXD6LupIS/ED33rV4wXZCmjr4XfeSzOuvGkRVrmsVaY6i
	 GUUamRAZNsryrViOFokF4BrskMesEwxaf0/CKDy4QXfqlnNDCVIBOW+FyMyRhItKyA7bl
	 NKx9YHl5AdOin8AQ30npIPHqLQ7Ti92tyXSoAfvIbbwmRR6BbdWNhX2LYR9t6s5jknLFp
	 io0pEom7pNiJn5xGnjuwqQcywyjvKHzRIdKJH3bQ0BAtruOI5uzoe34J8QCTcH8azVyzZ
	 /T2jtimQ1hxbsp+C54HIOCvqZoDIar5uzlDNMNGPzxeh8e8vCrbz2HH5ENB6JGKnbWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795783343;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ElEO5pT8eCzVdJCyxeHQPaq8h0/2ZLOFaGDHJzA0gd0=;
	b=sCwHoM1paqhEGT/s6NC7yTYiQDD/rYAxLSeaUa3PPNy2rYCqAzNK74TND5/jpasdFWtC
	 0rwOfy+EE+IoNQxrFk+A3/MCOiJd0aRORcC3wQugEJmRoDyiQhnYJe+v5kHC7uuXtha+d
	 vuZuFpnC9I6uTMHZO5W7isVyenkN4nKeBYhxVx0azE2Ti9ZNUfcEZKfVvadfvBoboL7BU
	 3XeleDAdif8xRooFpXzy0nvg3Z6IFShnqQf6qwY8Cui2ou28pH8cbBs0KhI7PW1+ZXuAm
	 GpN12tJ9HqCD5d+DGQ12vqpufVUhc1ivQtuqBhFBmj3Dm3CWdht/j2D3PWxkHDo1PiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=b2VGF8gG;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27BE2606A31C;
	Fri, 27 Nov 2026 12:42:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27BE2606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=b2VGF8gG
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=ElEO5pT8eCzVdJCyxeHQPaq8h0/2ZLOFaGDHJzA0gd0=; b=b2VGF8gGxJBr2NJGE7JQ1RhK8u
	biM8MyQHv6v1FEs7v6SWLieFzRVhDET/276r9WzW9GOpZ3DAtZ6h/HpQevpa1sq4MZjp75mJyXqoP
	3YC+L956tqvfc41MTQPZPzDWztDt705Vc5hjY20TqVIJvcjkFApFAVgqKTFU47xck2Ds7mSh3ko8x
	mcA59TnizinOZA/tsd2BZG1O7X1EdSxBA1yItXKjePoAdB/eLVbZ8s9lpmRgdmcEmyDP2QxHwufkB
	DcLwIpyk3ibyfWQQDhSNIGxRReBAjKeSJ9U7NqxAJVbqbe1Bwq8kVAYn5+fcwQNbKZIAoYPndPtIT
	8xF7neFHXez6aRS/q4zDcABh0FsrtQrj7SlqC36jErsH/FYM8cyIQ8VA+SMCS9vbPofAsa3RNd4wU
	AWjOUGS5UexPV6QHeNbySngUyiBD+IfY3g8D4edlgmI6s4S+XVKfbsJRwQq+VDFlrS3JHKgQokXfU
	QUknwthU19+IZ/Z8N1yTwkcu;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWvHP-00000001M92-0oHu;
	Fri, 27 Nov 2026 12:42:19 +0000
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
Subject: [PATCH 4/8] smb: client: pass server to smbd_get_parameters()
Date: Fri, 27 Nov 2026 13:41:37 +0100
Message-ID: <4e00a3fc120965db65bec2c43a69466d84e1cd2a.1795782695.git.metze@samba.org>
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

This is a mechanical change of the prototype of smbd_get_parameters()
to take a struct TCP_Server_Info *server instead of a
struct smbd_connection *, deriving server->smbd_conn inside the
function, with no change in behaviour. A following change uses this to
access server->smbd_conn under server->srv_lock.

smbd_get_connection() is called before the connection is published in
server->smbd_conn, so it uses
smbdirect_socket_get_current_parameters() directly.

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
 fs/smb/client/file.c      | 4 ++--
 fs/smb/client/smb2ops.c   | 4 ++--
 fs/smb/client/smbdirect.c | 8 +++++---
 fs/smb/client/smbdirect.h | 2 +-
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index d272320436b3..f61e80e3d88c 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -393,7 +393,7 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (server->smbd_conn) {
 		const struct smbdirect_socket_parameters *sp =
-			smbd_get_parameters(server->smbd_conn);
+			smbd_get_parameters(server);
 
 		stream->sreq_max_segs = sp->max_frmr_depth;
 	}
@@ -612,7 +612,7 @@ static int cifs_prepare_read(struct netfs_io_subrequest *subreq)
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (server->smbd_conn) {
 		const struct smbdirect_socket_parameters *sp =
-			smbd_get_parameters(server->smbd_conn);
+			smbd_get_parameters(server);
 
 		rreq->io_streams[0].sreq_max_segs = sp->max_frmr_depth;
 	}
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 298f549bd7ed..14383c37ae9e 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -521,7 +521,7 @@ smb3_negotiate_wsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (server->rdma) {
 		const struct smbdirect_socket_parameters *sp =
-			smbd_get_parameters(server->smbd_conn);
+			smbd_get_parameters(server);
 
 		if (server->sign)
 			/*
@@ -572,7 +572,7 @@ smb3_negotiate_rsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (server->rdma) {
 		const struct smbdirect_socket_parameters *sp =
-			smbd_get_parameters(server->smbd_conn);
+			smbd_get_parameters(server);
 
 		if (server->sign)
 			/*
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index e9739f9e36c9..b00224a1d411 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -362,8 +362,10 @@ static struct smbd_connection *_smbd_get_connection(
 	return ERR_PTR(ret);
 }
 
-const struct smbdirect_socket_parameters *smbd_get_parameters(struct smbd_connection *conn)
+const struct smbdirect_socket_parameters *smbd_get_parameters(struct TCP_Server_Info *server)
 {
+	struct smbd_connection *conn = server->smbd_conn;
+
 	if (unlikely(!conn->socket)) {
 		static const struct smbdirect_socket_parameters zero_params;
 
@@ -398,7 +400,7 @@ struct smbd_connection *smbd_get_connection(
 	if (IS_ERR(ret))
 		return ret;
 
-	sp = smbd_get_parameters(ret);
+	sp = smbdirect_socket_get_current_parameters(ret->socket);
 
 	server->rdma_readwrite_threshold =
 		rdma_readwrite_threshold > sp->max_fragmented_send_size ?
@@ -443,7 +445,7 @@ int smbd_send(struct TCP_Server_Info *server,
 {
 	struct smbd_connection *info = server->smbd_conn;
 	struct smbdirect_socket *sc = info->socket;
-	const struct smbdirect_socket_parameters *sp = smbd_get_parameters(info);
+	const struct smbdirect_socket_parameters *sp = smbd_get_parameters(server);
 	struct smb_rqst *rqst;
 	struct iov_iter iter;
 	struct smbdirect_send_batch_storage bstorage;
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 283809a57fb6..81fd6b849ade 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -33,7 +33,7 @@ struct smbd_connection *smbd_get_connection(
 void smbd_set_connection(struct TCP_Server_Info *server,
 			 struct smbd_connection *info);
 
-const struct smbdirect_socket_parameters *smbd_get_parameters(struct smbd_connection *conn);
+const struct smbdirect_socket_parameters *smbd_get_parameters(struct TCP_Server_Info *server);
 
 /* Reconnect SMBDirect session */
 int smbd_reconnect(struct TCP_Server_Info *server);
-- 
2.43.0

