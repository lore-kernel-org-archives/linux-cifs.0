Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3529E2E2DDD
	for <linux-cifs@vger.kernel.org>; Mon,  5 Oct 2026 18:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791226060; cv=none; b=sO5TaKun4rUzmosDRQmQNCTdNcf69XnKReUun4dvGbAPS9qPyc6qz75alycvVRVHIGMFnqVbQguG6GTMup+RgqfafjzHZal+F+ZNf3jPrbYuogP9eqiNRKO35eGPXVv5ph+6iwDGpDRg5Eioh9mEE/VGs0u8+yG5/5pufNWVF0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791226060; c=relaxed/simple;
	bh=fROKtTtRsbdjydjxvmdIQUDoz9juvQqkZxbJ6cIdUF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TS5to0LQfF4N+NRsIcD4vJqMC+GMF8TqaBQprs+4xwPFIMop1FmHfXtvFhYPrkWpC2ji/2ySm71vFc3LiwRdJk+XDCOgUylbg6O9CxKUgRHG2oYyKwn7fCcLBIemAksCxuJ5RC2HswBOTe+g2S/Br9bNukUhz5Ot+lKNX5yyOTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=heDr3qlM; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="heDr3qlM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=3aOWgiS2O/q/4NHrfJNBvl5hQwTYJQWZk4C/AAFeDE0=; b=heDr3qlMI/v9jVwdfXCmkk31hZ
	WnftrfSz8ahAiiUmD3hBiDRrfeQJvkK0SzcALXjgtAeXxy98qx988IOYUHlz/WNc7FTkNl9xXArMU
	RLmT1UIL5pjlhfdMqCtfrHYs525moNppQsw/E0WmszhF4WZlSmDtkAQiX8pKUKgIcAgOG+ChylwWp
	JArSOV04GdBlkE2zIV6mw+tND/ASgBi+IdZ74RjmxaaQjT93BEN4gJ9NDBx51C0o8o9QNGG4Qj8Jc
	bLqcTENbNgIESj2tj/Q3tkDgZdx/H9u+HpNGzrBQCuNe+GDNlYOj6mJG0LePkoOFSmvT1HGyLnIjr
	hrQXb4CsB+p9NI043LNgc96D+MRapwQqOP8puxs1F5+xysh8fMSs+hdwwFkOHhlOtK7Muxjz+Mngf
	TflkrFYzkR2cdNiuzKwrcsx7+antntzQpLyXU9yzu79Hz3kjN6HW6EgfA+YyIqqq4Srgi1gBaJgEx
	L2aGRY8LAVPOvRN4mnKP3PK/;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xDnip-00000005fAJ-0LWF;
	Mon, 05 Oct 2026 18:47:35 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH 4/5] smb: client: pass server to smbd_register_mr()
Date: Mon,  5 Oct 2026 20:46:59 +0200
Message-ID: <c044ca015a96959a4efa4115816f12c69c25d446.1791225453.git.metze@samba.org>
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

This is a mechanical change of the prototype of smbd_register_mr()
to take a struct TCP_Server_Info *server instead of a
struct smbd_connection *, deriving server->smbd_conn inside the
function, with no change in behaviour. A following change uses this to
take a reference on server->smbd_conn's socket under server->srv_lock.

Fixes: b8aef8c8808c ("smb: client: make use of smbdirect_socket_create_kern()/smbdirect_socket_release()")
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smb2pdu.c   | 4 ++--
 fs/smb/client/smbdirect.c | 3 ++-
 fs/smb/client/smbdirect.h | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 880ce12f50c4..aa5a33ca5d08 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4598,7 +4598,7 @@ smb2_new_read_req(void **buf, unsigned int *total_len,
 		struct smbdirect_buffer_descriptor_v1 *v1;
 		bool need_invalidate = server->dialect == SMB30_PROT_ID;
 
-		rdata->mr = smbd_register_mr(server->smbd_conn, &rdata->subreq.io_iter,
+		rdata->mr = smbd_register_mr(server, &rdata->subreq.io_iter,
 					     true, need_invalidate);
 		if (!rdata->mr) {
 			rc = -EAGAIN;
@@ -5200,7 +5200,7 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 		struct smbdirect_buffer_descriptor_v1 *v1;
 		bool need_invalidate = server->dialect == SMB30_PROT_ID;
 
-		wdata->mr = smbd_register_mr(server->smbd_conn, &wdata->subreq.io_iter,
+		wdata->mr = smbd_register_mr(server, &wdata->subreq.io_iter,
 					     false, need_invalidate);
 		if (!wdata->mr) {
 			rc = -EAGAIN;
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 41856261c372..942763789335 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -537,10 +537,11 @@ int smbd_send(struct TCP_Server_Info *server,
  * need_invalidate: true if this MR needs to be locally invalidated after I/O
  * return value: the MR registered, NULL if failed.
  */
-struct smbdirect_mr_io *smbd_register_mr(struct smbd_connection *info,
+struct smbdirect_mr_io *smbd_register_mr(struct TCP_Server_Info *server,
 				 struct iov_iter *iter,
 				 bool writing, bool need_invalidate)
 {
+	struct smbd_connection *info = server->smbd_conn;
 	struct smbdirect_socket *sc = info->socket;
 
 	if (!smbdirect_connection_is_connected(sc))
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 84fab8b6d1f0..1e1cf9a0104c 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -47,7 +47,7 @@ int smbd_send(struct TCP_Server_Info *server,
 
 /* Interfaces to register and deregister MR for RDMA read/write */
 struct smbdirect_mr_io *smbd_register_mr(
-	struct smbd_connection *info, struct iov_iter *iter,
+	struct TCP_Server_Info *server, struct iov_iter *iter,
 	bool writing, bool need_invalidate);
 void smbd_mr_fill_buffer_descriptor(struct smbdirect_mr_io *mr,
 				    struct smbdirect_buffer_descriptor_v1 *v1);
-- 
2.43.0

