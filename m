Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90782E6CA6
	for <linux-cifs@vger.kernel.org>; Mon,  5 Oct 2026 18:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791226054; cv=none; b=sD5B1Od1aC8Potr0zP/fHIJKl98ex4G/6QL7hMFIckt9Z5QVNwSKtJTB5la5EeJ6Nd3Ok13JY7B1mKWbkJxcSFRrzq1Ksl6SxwQ5RGaiIiuuxvp+mFcGUQyvI3TBfXLLVncqsXTLGPFSnJLCU03DcwMoXu/pZ38mmw3Ufs+WbXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791226054; c=relaxed/simple;
	bh=0qq2AY2E8u2l2VXWuiFlrlgu/xI4UrxYc2UmOuxYn2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PgZ28Hc6pwJqwzLycAJ+FkI6VrQU5r7GagVcgT8qtBXFsIdm5EW27I9qguQgEr5YfUqJQJ45VqbgQygLDxfmZHUk9gDAJW6Y5GoxqnYxHgZd3vGYLO+SNN5WTb3ZB+BlUoBw7RlIObluJgUXSmmCFyP6LHtFuFqGjdcfVryBuz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=P71A+L57; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="P71A+L57"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=RCtWaNC96WBDkOwR5YypNjtrLqWo1aWiDr5v5HDSeqU=; b=P71A+L57Y35Z0ijvTBGBil4clR
	r3+Y0hO4nzMOJA5OTDMow5RPAZle1cMWRsYuWxSN07B9nHWzwCAB2P5PnibiEcazV60rrSFZhdLrZ
	jvLukueh3KuXubsEEaDJXElmmQcpKYom4yBN/GHE9cn0YxgiHdrlRzT5m928qWlanHmE2Lht2zw4A
	NGQ0vLM4KbWcq2trudzpCqffLKu0jJXmsjroGD5HrsoTblytZjMk6bD/bdhTAhUNQXluoEqJfY2+q
	j8ffCck1xWU/AsuMMhWGyXqw5VdgPE8NxYehgVRxAbp7QXF2YMOJVRFXQGAtvzwccC/q+T3k4AgA0
	BHdTjOwS1gCQWFCTYozq1L4IbvvUqZxkH+ZhHiIBeXZB4p7G85PzRvm8UbyMXuYR1vGDI4T9IdzXp
	eIRwdV2qUYehT09Ebvp05v6y0VL7UTqUyd2vGg9m2Xs1mycUo0SYxEQbUznAR4iSoU4fhMlrArwg8
	+6hrVN/aiRJIlHAxa5Oc+/VA;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xDnij-00000005f9E-2Epp;
	Mon, 05 Oct 2026 18:47:29 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH 3/5] smb: client: pass server to smbd_get_parameters()
Date: Mon,  5 Oct 2026 20:46:58 +0200
Message-ID: <bcdba9e174829650c4b4796cc5f1268ae927a195.1791225453.git.metze@samba.org>
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

This is a mechanical change of the prototype of smbd_get_parameters()
to take a struct TCP_Server_Info *server instead of a
struct smbd_connection *, deriving server->smbd_conn inside the
function, with no change in behaviour. A following change uses this to
access server->smbd_conn under server->srv_lock.

smbd_get_connection() is called before the connection is published in
server->smbd_conn, so it uses
smbdirect_socket_get_current_parameters() directly.

Fixes: b8aef8c8808c ("smb: client: make use of smbdirect_socket_create_kern()/smbdirect_socket_release()")
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/file.c      | 4 ++--
 fs/smb/client/smb2ops.c   | 4 ++--
 fs/smb/client/smbdirect.c | 8 +++++---
 fs/smb/client/smbdirect.h | 2 +-
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 0d428517f454..632d1f24e36b 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -98,7 +98,7 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (server->smbd_conn) {
 		const struct smbdirect_socket_parameters *sp =
-			smbd_get_parameters(server->smbd_conn);
+			smbd_get_parameters(server);
 
 		stream->sreq_max_segs = sp->max_frmr_depth;
 	}
@@ -192,7 +192,7 @@ static int cifs_prepare_read(struct netfs_io_subrequest *subreq)
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (server->smbd_conn) {
 		const struct smbdirect_socket_parameters *sp =
-			smbd_get_parameters(server->smbd_conn);
+			smbd_get_parameters(server);
 
 		rreq->io_streams[0].sreq_max_segs = sp->max_frmr_depth;
 	}
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 3464470d3297..1b2ef128810f 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -516,7 +516,7 @@ smb3_negotiate_wsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (server->rdma) {
 		const struct smbdirect_socket_parameters *sp =
-			smbd_get_parameters(server->smbd_conn);
+			smbd_get_parameters(server);
 
 		if (server->sign)
 			/*
@@ -567,7 +567,7 @@ smb3_negotiate_rsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (server->rdma) {
 		const struct smbdirect_socket_parameters *sp =
-			smbd_get_parameters(server->smbd_conn);
+			smbd_get_parameters(server);
 
 		if (server->sign)
 			/*
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 3ecf34c7379a..41856261c372 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -361,8 +361,10 @@ static struct smbd_connection *_smbd_get_connection(
 	return NULL;
 }
 
-const struct smbdirect_socket_parameters *smbd_get_parameters(struct smbd_connection *conn)
+const struct smbdirect_socket_parameters *smbd_get_parameters(struct TCP_Server_Info *server)
 {
+	struct smbd_connection *conn = server->smbd_conn;
+
 	if (unlikely(!conn->socket)) {
 		static const struct smbdirect_socket_parameters zero_params;
 
@@ -390,7 +392,7 @@ struct smbd_connection *smbd_get_connection(
 	if (!ret)
 		return NULL;
 
-	sp = smbd_get_parameters(ret);
+	sp = smbdirect_socket_get_current_parameters(ret->socket);
 
 	server->rdma_readwrite_threshold =
 		rdma_readwrite_threshold > sp->max_fragmented_send_size ?
@@ -435,7 +437,7 @@ int smbd_send(struct TCP_Server_Info *server,
 {
 	struct smbd_connection *info = server->smbd_conn;
 	struct smbdirect_socket *sc = info->socket;
-	const struct smbdirect_socket_parameters *sp = smbd_get_parameters(info);
+	const struct smbdirect_socket_parameters *sp = smbd_get_parameters(server);
 	struct smb_rqst *rqst;
 	struct iov_iter iter;
 	struct smbdirect_send_batch_storage bstorage;
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 54ee49f9cfc6..84fab8b6d1f0 100644
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

