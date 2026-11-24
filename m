Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795506871;
	b=C0GjVHsopbY/SOI7Q1lE/FXqRFfpCqF+IiPV36p00DeAltcmE9T6zAjlxizQcNEb6v6Q
	 zK03KC4OvzgxjDXGfTaGSQdyhpV4+xTty8nin0GyWXhvrrcgVFuwmVQkkOyGP1XRj3Bka
	 0Yx6N7Xk/c8F6pSn/A5yyr5ZAgnygneQsoW4iiyQVayaSM6FHw/GNdt145hrfsrFZ+gbm
	 Lw6biJKo1RhSGZ/jn4pbtaP7H+00ZxhReh5vK2ZoMWIErXBegzBcwDTMCEmcHsQ5iJ7m+
	 ZyS9RnVU92nkiI3K78KUg9fDLm1yZ4UdBJLLWaz/lWjvWYcg8pSkHvwU8MP4jeIpiVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795506871;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=pm5nfXlVeVpwPa2Wc9rokgWvYNTQbycynWybOMPTt3c=;
	b=co91hRXmnIReBE/16J2AvKv8f/HxXKQfRz8VGgbTJTVDrdM/9nCVz+jjScxC/0wdeLd3
	 aIitD7uYtUjBfi1u9/7pmSvxfLNeGvY3hLQzyc3co3VwoQBKzCDckE5ZgRnp9xszU+C4u
	 p3DM7jGkJVBgh2Hc6nnVtx7PNkxvvnW2XqtLud0J/WDVWulDBv/ioJj6FdrN5Qjgu/wZF
	 51jco41VB7gz+WSgGmmzgUxBW0g2R5l7MSYBB/+LUDSOkcSqXsc1jdRwdK4/4ZjOckYNO
	 XgKyz217LUDjvA3OVnn6+Ihr80lFPMxtO1N0kfy9xN61Z9CxNglcFKYSRR0KmTBn1IA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cZAZnNPW;
	arc=none smtp.remote-ip=209.85.215.182
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E2C606A321
	for <linux-cifs@vger.kernel.org>; Tue, 24 Nov 2026 07:54:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79E2C606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cZAZnNPW
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cde827b7b95so936342a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 23 Nov 2026 23:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795506870; x=1796111670; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pm5nfXlVeVpwPa2Wc9rokgWvYNTQbycynWybOMPTt3c=;
        b=cZAZnNPWcN4A0rYf0FjgprvFJNWXxzQK4xJWWNmFpmE99zsgyhkmGFPYKyL2S+kPUK
         +4zIsAE5C8GedNgIZPFwhRtJVG3pth4cNQVY6tepwXA+8O6yzmm0lcogaKynuX1/pO9M
         bljmpABohnrS1bsmGBaBSwdL62hCnDatZ/SJMQbofn7nfcqLSsZ1kj6DjGWSkfraCufd
         XhEesmwhTnQMSF4o7jBoIwiDA2u8LRsTtk0fqFedbzNjWBq7zANdFa+jWdvB3zOyqA5s
         1mp24cGu5GJa6FpK0KhaxupcUgLxNQaJgrw3NsyZI9KBPMXypmpJm/u5Aby6bVRK6ymg
         69ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795506870; x=1796111670;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pm5nfXlVeVpwPa2Wc9rokgWvYNTQbycynWybOMPTt3c=;
        b=OzrHC9tUE510HOULxxii0n4RM1fa30cxpUkZiC690CM92uvFzRu8awlpI+UMpmfEch
         dSXRLCyZ/fLuAzAXsnKlB4Moyec31pJAhte8vgJbK9q32DrKsGaWEhtJmD4/kxLOmtIj
         qbkWDQYeeRYyXidO3RzJxGmnMjw+KvennA3OQ49Lh4SnduhuxpL4KqPdXfFWvK9WI+Jy
         d1UIKg5EoKZfV5cKpLFokCMlnTuJg78qn2c+YcSxC8eF8w/KbT7rJgt53MWvM2SZFh+n
         Os9J/dbcgTXgI+yemmQKsX81xSgua7mXbeZeW03ufd4iuDYYu2TPSjfTkENiIuws3jrF
         NGdg==
X-Forwarded-Encrypted: i=1; AL+hErHPNDHHS16vDADjLDOBQwHPxCH9cnD7FEq1C1cW3ESUiy+9gbO8j9HelnxcFDM7cm2hPRiL6vo3ZU9R@vger.kernel.org
X-Gm-Message-State: APuU4Z+oUKuM2OBzTww0qzgCtvzqGxGlWzLMKDclp+eJvTWlv84Zlj08
	SWbuZm6hJj67WRh29jdav9tnkXlTDGUpHhM3l2UsIIGNUvvdO6n2qwyS
X-Gm-Gg: AZFdTZfwUiRd8VpohyPyU0j9ImCncX940bTF3ub9g4PBLgwbZfrZDwMukLB34nf30Fa
	rEgASecMFfdtqEE2kR149zvFmRh5yAv9fblbOyUIDuMepI1awaOJkt0Ek7S/Izt07E67+OaDTKF
	W/qJHSNAiBemwoF9itl6OIqzBDlDSz6nqkoO8PhTAi21pn4/mzmu/+ZOHJAk1TiMdXwn9L5vhdy
	/JPMbxcygnscSOolu7PsDTzMlxgom7I3yuqg9jRfMSezLgt5dHTB1Rrapvl2QvU9z8iUgaPI3tM
	FpVyD+PK4kqR2uC+yH7i76/UcViRizC2k7AEiSsgZx2XB0xADQS1cD67TywaPfTHWbsg//QpcQ/
	Qs6Gdg8++PDatRKEVzlhAZKVW/o/I4QQkTgh1beaDCzZbtXZmbOMLhbd7PoVEAqT485lK7k/+ot
	+DJcB5TOWP+2UAOhbmOeOQYAgNxsK9j1nSrDZSFAN3nSaZjtLOX769dLCODYO0g2ikFlQIauHM4
	TyXoutcE6sZdUAD+ZccLgXQjCrsDjSmBOLnsksXjR96uYgvpedDccnTo1an/ZLLu7OA9lZRnSPe
	GPaxtunEIGL/hYhjsW0jYL9+I8ZNMHB37/cIb/Utm7ZrkCm5+g/wxEHFvX3/yOWp5zAkcjCn9Ku
	yoabNyg1JDC4ptShGE/r5c9RgO26eSoAa5GzG
X-Received: by 2002:a17:90b:3d92:b0:3b3:a74d:f848 with SMTP id 98e67ed59e1d1-3b41c8e1711mr9835237a91.15.1795506869742;
        Mon, 23 Nov 2026 23:54:29 -0800 (PST)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([43.224.245.233])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41aab4729sm21462307a91.0.2026.11.23.23.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 23:54:29 -0800 (PST)
From: Qican Ma <goonsomeway@gmail.com>
To: linkinjeon@kernel.org, pc@manguebit.org
Cc: metze@samba.org, tom@talpey.com, ronniesahlberg@gmail.com, sprasad@microsoft.com, bharathsm@microsoft.com, linux-cifs@vger.kernel.org
Subject: [PATCH v2] smb: client: protect server->smbd_conn with RCU and refcounting
Date: Tue, 24 Nov 2026 15:54:24 +0800
Message-ID: <179550686494.38773.3803244405772043954@gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Several paths check and dereference server->smbd_conn without holding a
lock that serializes against smbd_destroy() during reconnect or teardown
(including smb2_new_read_req(), smb2_async_writev(), smbd_send(),
cifs_readv_from_socket(), cifs_prepare_read/write(),
smb3_negotiate_r/wsize(), and smbd_debug_proc_show()). Meanwhile
smbd_destroy() releases the underlying socket and calls kfree(info)
before clearing server->smbd_conn = NULL, exposing a use-after-free
window to concurrent readers.

Annotate server->smbd_conn with __rcu and add a refcount and completion
to struct smbd_connection. Readers acquire a short-lived reference via
smbd_conn_get() under rcu_read_lock() and drop it with smbd_conn_put().
In smbd_destroy(), clear server->smbd_conn first, shut down the socket to
wake any blocked callers, wait for active references and an RCU grace
period to complete, and then release the socket and free info in process
context. Pass server directly to smbd_recv() and smbd_register_mr() so
connection pinning stays encapsulated inside smbdirect.c.

Found with an LLM-assisted code review tool and verified by inspection on
v7.4-rc4 (b6a9fa34ce4). Build-tested with CONFIG_CIFS_SMB_DIRECT=y and
CONFIG_CIFS_SMB_DIRECT=n; not runtime-tested due to lack of an SMBDirect
RDMA test setup.

Fixes: f198186aa9bb ("CIFS: SMBD: Establish SMB Direct connection")
Cc: stable@vger.kernel.org
Signed-off-by: Qican Ma <goonsomeway@gmail.com>
---
v2: resend via direct SMTP without line-wrapping corruption in the diff.

 fs/smb/client/cifsglob.h  |   2 +-
 fs/smb/client/connect.c   |  11 ++--
 fs/smb/client/file.c      |  26 ++++++---
 fs/smb/client/smb2ops.c   |  72 ++++++++++++++-----------
 fs/smb/client/smb2pdu.c   |   6 +--
 fs/smb/client/smbdirect.c | 111 ++++++++++++++++++++++++++++----------
 fs/smb/client/smbdirect.h |  16 ++++--
 fs/smb/client/transport.c |   4 +-
 8 files changed, 165 insertions(+), 83 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 4e16347886e..c0f75f756de 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -760,7 +760,7 @@ struct TCP_Server_Info {
 	/* use SMBD connection instead of socket */
 	bool	rdma;
 	/* point to the SMBD connection if RDMA is used instead of socket */
-	struct smbd_connection *smbd_conn;
+	struct smbd_connection __rcu *smbd_conn;
 	struct delayed_work	echo; /* echo ping workqueue job */
 	char	*smallbuf;	/* pointer to current "small" buffer */
 	char	*bigbuf;	/* pointer to current "big" buffer */
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 750b5bb72dc..03072d7a790 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -774,8 +774,8 @@ cifs_readv_from_socket(struct TCP_Server_Info *server, struct msghdr *smb_msg)
 
 		if (server_unresponsive(server))
 			return -ECONNABORTED;
-		if (cifs_rdma_enabled(server) && server->smbd_conn)
-			length = smbd_recv(server->smbd_conn, smb_msg);
+		if (cifs_rdma_enabled(server))
+			length = smbd_recv(server, smb_msg);
 		else
 			length = sock_recvmsg(server->ssocket, smb_msg, 0);
 
@@ -1888,9 +1888,10 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 		rc = -ENOENT;
 		goto out_err_crypto_release;
 #endif
-		tcp_ses->smbd_conn = smbd_get_connection(
-			tcp_ses, (struct sockaddr *)&ctx->dstaddr);
-		if (tcp_ses->smbd_conn) {
+		rcu_assign_pointer(tcp_ses->smbd_conn,
+				   smbd_get_connection(tcp_ses,
+						       (struct sockaddr *)&ctx->dstaddr));
+		if (rcu_access_pointer(tcp_ses->smbd_conn)) {
 			cifs_dbg(VFS, "RDMA transport established\n");
 			rc = 0;
 			goto smbd_connected;
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index d272320436b..a842695f2f0 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -391,11 +391,16 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
 			      cifs_trace_rw_credits_write_prepare);
 
 #ifdef CONFIG_CIFS_SMB_DIRECT
-	if (server->smbd_conn) {
-		const struct smbdirect_socket_parameters *sp =
-			smbd_get_parameters(server->smbd_conn);
+	{
+		struct smbd_connection *conn = smbd_conn_get(server);
 
-		stream->sreq_max_segs = sp->max_frmr_depth;
+		if (conn) {
+			const struct smbdirect_socket_parameters *sp =
+				smbd_get_parameters(conn);
+
+			stream->sreq_max_segs = sp->max_frmr_depth;
+			smbd_conn_put(conn);
+		}
 	}
 #endif
 }
@@ -610,11 +615,16 @@ static int cifs_prepare_read(struct netfs_io_subrequest *subreq)
 			      cifs_trace_rw_credits_read_submit);
 
 #ifdef CONFIG_CIFS_SMB_DIRECT
-	if (server->smbd_conn) {
-		const struct smbdirect_socket_parameters *sp =
-			smbd_get_parameters(server->smbd_conn);
+	{
+		struct smbd_connection *conn = smbd_conn_get(server);
 
-		rreq->io_streams[0].sreq_max_segs = sp->max_frmr_depth;
+		if (conn) {
+			const struct smbdirect_socket_parameters *sp =
+				smbd_get_parameters(conn);
+
+			rreq->io_streams[0].sreq_max_segs = sp->max_frmr_depth;
+			smbd_conn_put(conn);
+		}
 	}
 #endif
 	return 0;
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 298f549bd7e..1e07557a42d 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -520,22 +520,26 @@ smb3_negotiate_wsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 	wsize = min_t(unsigned int, wsize, server->max_write);
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (server->rdma) {
-		const struct smbdirect_socket_parameters *sp =
-			smbd_get_parameters(server->smbd_conn);
-
-		if (server->sign)
-			/*
-			 * Account for SMB2 data transfer packet header and
-			 * possible encryption header
-			 */
-			wsize = min_t(unsigned int,
-				wsize,
-				sp->max_fragmented_send_size -
-					SMB2_READWRITE_PDU_HEADER_SIZE -
-					sizeof(struct smb2_transform_hdr));
-		else
-			wsize = min_t(unsigned int,
-				wsize, sp->max_read_write_size);
+		struct smbd_connection *conn = smbd_conn_get(server);
+
+		if (conn) {
+			const struct smbdirect_socket_parameters *sp =
+				smbd_get_parameters(conn);
+
+			if (server->sign)
+				/*
+				 * Account for SMB2 data transfer packet header and
+				 * possible encryption header
+				 */
+				wsize = min_t(unsigned int, wsize,
+					      sp->max_fragmented_send_size -
+					      SMB2_READWRITE_PDU_HEADER_SIZE -
+					      sizeof(struct smb2_transform_hdr));
+			else
+				wsize = min_t(unsigned int, wsize,
+					      sp->max_read_write_size);
+			smbd_conn_put(conn);
+		}
 	}
 #endif
 	if (!(server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU))
@@ -571,22 +575,26 @@ smb3_negotiate_rsize(struct cifs_tcon *tcon, struct smb3_fs_context *ctx)
 	rsize = min_t(unsigned int, rsize, server->max_read);
 #ifdef CONFIG_CIFS_SMB_DIRECT
 	if (server->rdma) {
-		const struct smbdirect_socket_parameters *sp =
-			smbd_get_parameters(server->smbd_conn);
-
-		if (server->sign)
-			/*
-			 * Account for SMB2 data transfer packet header and
-			 * possible encryption header
-			 */
-			rsize = min_t(unsigned int,
-				rsize,
-				sp->max_fragmented_recv_size -
-					SMB2_READWRITE_PDU_HEADER_SIZE -
-					sizeof(struct smb2_transform_hdr));
-		else
-			rsize = min_t(unsigned int,
-				rsize, sp->max_read_write_size);
+		struct smbd_connection *conn = smbd_conn_get(server);
+
+		if (conn) {
+			const struct smbdirect_socket_parameters *sp =
+				smbd_get_parameters(conn);
+
+			if (server->sign)
+				/*
+				 * Account for SMB2 data transfer packet header and
+				 * possible encryption header
+				 */
+				rsize = min_t(unsigned int, rsize,
+					      sp->max_fragmented_recv_size -
+					      SMB2_READWRITE_PDU_HEADER_SIZE -
+					      sizeof(struct smb2_transform_hdr));
+			else
+				rsize = min_t(unsigned int, rsize,
+					      sp->max_read_write_size);
+			smbd_conn_put(conn);
+		}
 	}
 #endif
 
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 7b7d25364e2..d407ec7c3b7 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4651,7 +4651,7 @@ static inline bool smb3_use_rdma_offload(struct cifs_io_parms *io_parms)
 		return false;
 
 	/* we can only offload on an rdma connection */
-	if (!server->rdma || !server->smbd_conn)
+	if (!server->rdma || !rcu_access_pointer(server->smbd_conn))
 		return false;
 
 	/* we don't support signed offload yet */
@@ -4721,7 +4721,7 @@ int smb2_new_read_req(void **buf, unsigned int *total_len,
 		struct smbdirect_buffer_descriptor_v1 *v1;
 		bool need_invalidate = server->dialect == SMB30_PROT_ID;
 
-		rdata->mr = smbd_register_mr(server->smbd_conn, &rdata->subreq.io_iter,
+		rdata->mr = smbd_register_mr(server, &rdata->subreq.io_iter,
 					     true, need_invalidate);
 		if (!rdata->mr) {
 			rc = -EAGAIN;
@@ -5362,7 +5362,7 @@ smb2_async_writev(struct cifs_io_subrequest *wdata)
 		struct smbdirect_buffer_descriptor_v1 *v1;
 		bool need_invalidate = server->dialect == SMB30_PROT_ID;
 
-		wdata->mr = smbd_register_mr(server->smbd_conn, &wdata->subreq.io_iter,
+		wdata->mr = smbd_register_mr(server, &wdata->subreq.io_iter,
 					     false, need_invalidate);
 		if (!wdata->mr) {
 			rc = -EAGAIN;
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 563ef488a22..936988bad5d 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -194,6 +194,25 @@ static int smbd_post_send_full_iter(struct smbdirect_socket *sc,
 	return bytes;
 }
 
+struct smbd_connection *smbd_conn_get(struct TCP_Server_Info *server)
+{
+	struct smbd_connection *info;
+
+	rcu_read_lock();
+	info = rcu_dereference(server->smbd_conn);
+	if (info && !refcount_inc_not_zero(&info->refcount))
+		info = NULL;
+	rcu_read_unlock();
+
+	return info;
+}
+
+void smbd_conn_put(struct smbd_connection *info)
+{
+	if (info && refcount_dec_and_test(&info->refcount))
+		complete(&info->destroy_done);
+}
+
 /*
  * Destroy the transport and related RDMA and memory resources
  * Need to go through all the pending counters and make sure on one is using
@@ -201,17 +220,22 @@ static int smbd_post_send_full_iter(struct smbdirect_socket *sc,
  */
 void smbd_destroy(struct TCP_Server_Info *server)
 {
-	struct smbd_connection *info = server->smbd_conn;
+	struct smbd_connection *info =
+		rcu_dereference_protected(server->smbd_conn, 1);
 
 	if (!info) {
 		log_rdma_event(INFO, "rdma session already destroyed\n");
 		return;
 	}
 
-	smbdirect_socket_release(info->socket);
+	RCU_INIT_POINTER(server->smbd_conn, NULL);
+	smbdirect_socket_shutdown(info->socket);
+	if (!refcount_dec_and_test(&info->refcount))
+		wait_for_completion(&info->destroy_done);
+	synchronize_rcu();
 
+	smbdirect_socket_release(info->socket);
 	kfree(info);
-	server->smbd_conn = NULL;
 }
 
 /*
@@ -222,7 +246,7 @@ int smbd_reconnect(struct TCP_Server_Info *server)
 {
 	log_rdma_event(INFO, "reconnecting rdma session\n");
 
-	if (!server->smbd_conn) {
+	if (!rcu_access_pointer(server->smbd_conn)) {
 		log_rdma_event(INFO, "rdma session already destroyed\n");
 		goto create_conn;
 	}
@@ -236,10 +260,11 @@ int smbd_reconnect(struct TCP_Server_Info *server)
 
 create_conn:
 	log_rdma_event(INFO, "creating rdma session\n");
-	server->smbd_conn = smbd_get_connection(
-		server, (struct sockaddr *) &server->dstaddr);
+	rcu_assign_pointer(server->smbd_conn,
+			   smbd_get_connection(server,
+					       (struct sockaddr *)&server->dstaddr));
 
-	if (server->smbd_conn) {
+	if (rcu_access_pointer(server->smbd_conn)) {
 		cifs_dbg(VFS, "RDMA transport re-established\n");
 		trace_smb3_smbd_connect_done(server->hostname, server->conn_id, &server->dstaddr);
 		return 0;
@@ -303,6 +328,8 @@ static struct smbd_connection *_smbd_get_connection(
 	info = kzalloc_obj(*info);
 	if (!info)
 		return NULL;
+	refcount_set(&info->refcount, 1);
+	init_completion(&info->destroy_done);
 	ret = smbdirect_socket_create_kern(net, &sc);
 	if (ret)
 		goto socket_init_failed;
@@ -393,14 +420,23 @@ struct smbd_connection *smbd_get_connection(
  * consumed. But this will require more changes to upper layer code, and also
  * need to consider packet boundaries while they still being reassembled.
  */
-int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
+int smbd_recv(struct TCP_Server_Info *server, struct msghdr *msg)
 {
-	struct smbdirect_socket *sc = info->socket;
+	struct smbd_connection *info = smbd_conn_get(server);
+	struct smbdirect_socket *sc;
+	int rc;
 
-	if (!smbdirect_connection_is_connected(sc))
+	if (!info)
 		return -ENOTCONN;
 
-	return smbdirect_connection_recvmsg(sc, msg, 0);
+	sc = info->socket;
+	if (!smbdirect_connection_is_connected(sc))
+		rc = -ENOTCONN;
+	else
+		rc = smbdirect_connection_recvmsg(sc, msg, 0);
+
+	smbd_conn_put(info);
+	return rc;
 }
 
 /*
@@ -412,9 +448,9 @@ int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
 int smbd_send(struct TCP_Server_Info *server,
 	int num_rqst, struct smb_rqst *rqst_array)
 {
-	struct smbd_connection *info = server->smbd_conn;
-	struct smbdirect_socket *sc = info->socket;
-	const struct smbdirect_socket_parameters *sp = smbd_get_parameters(info);
+	struct smbd_connection *info = smbd_conn_get(server);
+	const struct smbdirect_socket_parameters *sp;
+	struct smbdirect_socket *sc;
 	struct smb_rqst *rqst;
 	struct iov_iter iter;
 	struct smbdirect_send_batch_storage bstorage;
@@ -423,9 +459,16 @@ int smbd_send(struct TCP_Server_Info *server,
 	int rc, i, rqst_idx;
 	int error = 0;
 
-	if (!smbdirect_connection_is_connected(sc))
+	if (!info)
 		return -EAGAIN;
 
+	sc = info->socket;
+	sp = smbd_get_parameters(info);
+	if (!smbdirect_connection_is_connected(sc)) {
+		error = -EAGAIN;
+		goto out;
+	}
+
 	/*
 	 * Add in the page array if there is one. The caller needs to set
 	 * rq_tailsz to PAGE_SIZE when the buffer has multiple pages and
@@ -439,7 +482,8 @@ int smbd_send(struct TCP_Server_Info *server,
 		/* assertion: payload never exceeds negotiated maximum */
 		log_write(ERR, "payload size %d > max size %d\n",
 			remaining_data_length, sp->max_fragmented_send_size);
-		return -EINVAL;
+		error = -EINVAL;
+		goto out;
 	}
 
 	log_write(INFO, "num_rqst=%d total length=%u\n",
@@ -501,10 +545,9 @@ int smbd_send(struct TCP_Server_Info *server,
 	if (unlikely(rc && !error))
 		error = -EAGAIN;
 
-	if (unlikely(error))
-		return error;
-
-	return 0;
+out:
+	smbd_conn_put(info);
+	return error;
 }
 
 /*
@@ -514,16 +557,24 @@ int smbd_send(struct TCP_Server_Info *server,
  * need_invalidate: true if this MR needs to be locally invalidated after I/O
  * return value: the MR registered, NULL if failed.
  */
-struct smbdirect_mr_io *smbd_register_mr(struct smbd_connection *info,
-				 struct iov_iter *iter,
-				 bool writing, bool need_invalidate)
+struct smbdirect_mr_io *smbd_register_mr(struct TCP_Server_Info *server,
+					 struct iov_iter *iter,
+					 bool writing, bool need_invalidate)
 {
-	struct smbdirect_socket *sc = info->socket;
+	struct smbd_connection *info = smbd_conn_get(server);
+	struct smbdirect_mr_io *mr = NULL;
+	struct smbdirect_socket *sc;
 
-	if (!smbdirect_connection_is_connected(sc))
+	if (!info)
 		return NULL;
 
-	return smbdirect_connection_register_mr_io(sc, iter, writing, need_invalidate);
+	sc = info->socket;
+	if (smbdirect_connection_is_connected(sc))
+		mr = smbdirect_connection_register_mr_io(sc, iter, writing,
+							 need_invalidate);
+
+	smbd_conn_put(info);
+	return mr;
 }
 
 void smbd_mr_fill_buffer_descriptor(struct smbdirect_mr_io *mr,
@@ -545,17 +596,21 @@ void smbd_deregister_mr(struct smbdirect_mr_io *mr)
 
 void smbd_debug_proc_show(struct TCP_Server_Info *server, struct seq_file *m)
 {
+	struct smbd_connection *info;
+
 	if (!server->rdma)
 		return;
 
-	if (!server->smbd_conn) {
+	info = smbd_conn_get(server);
+	if (!info) {
 		seq_puts(m, "\nSMBDirect transport not available");
 		return;
 	}
 
-	smbdirect_connection_legacy_debug_proc_show(server->smbd_conn->socket,
+	smbdirect_connection_legacy_debug_proc_show(info->socket,
 						    server->rdma_readwrite_threshold,
 						    m);
+	smbd_conn_put(info);
 }
 
 MODULE_IMPORT_NS("SMBDIRECT");
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index be205ec0207..e8cf8f901ca 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -12,6 +12,9 @@
 
 #include "cifsglob.h"
 
+#include <linux/completion.h>
+#include <linux/rcupdate.h>
+#include <linux/refcount.h>
 #include <linux/smbdirect.h>
 
 extern int rdma_readwrite_threshold;
@@ -25,8 +28,13 @@ extern int smbd_receive_credit_max;
 
 struct smbd_connection {
 	struct smbdirect_socket *socket;
+	refcount_t refcount;
+	struct completion destroy_done;
 };
 
+struct smbd_connection *smbd_conn_get(struct TCP_Server_Info *server);
+void smbd_conn_put(struct smbd_connection *info);
+
 /* Create a SMBDirect session */
 struct smbd_connection *smbd_get_connection(
 	struct TCP_Server_Info *server, struct sockaddr *dstaddr);
@@ -39,13 +47,13 @@ int smbd_reconnect(struct TCP_Server_Info *server);
 void smbd_destroy(struct TCP_Server_Info *server);
 
 /* Interface for carrying upper layer I/O through send/recv */
-int smbd_recv(struct smbd_connection *info, struct msghdr *msg);
+int smbd_recv(struct TCP_Server_Info *server, struct msghdr *msg);
 int smbd_send(struct TCP_Server_Info *server,
 	int num_rqst, struct smb_rqst *rqst);
 
 /* Interfaces to register and deregister MR for RDMA read/write */
 struct smbdirect_mr_io *smbd_register_mr(
-	struct smbd_connection *info, struct iov_iter *iter,
+	struct TCP_Server_Info *server, struct iov_iter *iter,
 	bool writing, bool need_invalidate);
 void smbd_mr_fill_buffer_descriptor(struct smbdirect_mr_io *mr,
 				    struct smbdirect_buffer_descriptor_v1 *v1);
@@ -60,8 +68,10 @@ static inline void *smbd_get_connection(
 	struct TCP_Server_Info *server, struct sockaddr *dstaddr) {return NULL;}
 static inline int smbd_reconnect(struct TCP_Server_Info *server) {return -1; }
 static inline void smbd_destroy(struct TCP_Server_Info *server) {}
-static inline int smbd_recv(struct smbd_connection *info, struct msghdr *msg) {return -1; }
+static inline int smbd_recv(struct TCP_Server_Info *server, struct msghdr *msg) {return -1; }
 static inline int smbd_send(struct TCP_Server_Info *server, int num_rqst, struct smb_rqst *rqst) {return -1; }
+static inline struct smbd_connection *smbd_conn_get(struct TCP_Server_Info *server) {return NULL; }
+static inline void smbd_conn_put(struct smbd_connection *info) {}
 #endif
 
 #endif
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 375b821ab3e..63d6700e5bd 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -257,9 +257,7 @@ int __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	cifs_in_send_inc(server);
 	if (cifs_rdma_enabled(server)) {
 		/* return -EAGAIN when connecting or reconnecting */
-		rc = -EAGAIN;
-		if (server->smbd_conn)
-			rc = smbd_send(server, num_rqst, rqst);
+		rc = smbd_send(server, num_rqst, rqst);
 		goto smbd_done;
 	}
 
-- 
2.50.1 (Apple Git-155)

