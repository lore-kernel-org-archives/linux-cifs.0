Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795709606;
	b=1xK8p1izVVCdDvRmGrg2Dkw/Szgz0ak9WeEdRVopxKyAZk6mxyH3wUBRvs7YFSqydtBx
	 CK/6t/oMFvMPdlF1W8h0exEFNmL3zr79a4+SndwYyuxvsVce7KBsE2FvkMoLdxvVZ2RkR
	 ILfTFUbKHG8r60UzO4TRh2nA4bZSr7FRXF7Gm0CuJPMtdsfnoXiI5ep815sapCwasi/j4
	 YMnRW86Szp1o08avLAjcNWPquJqy0iWlqQ16OexOmHSvZFepsnZIs8dVwOM9ewcYqsEuc
	 oUADeXmGGAz/tjw+vBR9dEMoz8iewaZor15gSCcPf1tB62Yv6FOIHFlF3ThjB5C0ZYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795709606;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=vLWcuVXHw7/3pDdU781pZXDaraoDyBbUzoCfgXPKW7s=;
	b=MZvFjZRx4igznPy+GxGAxnh7d7BD2kkezS1vfnqRW+rNwgrq/TwIn6F3zxE9kxRb8Am6
	 6Ac0yErNnZEX9PzCZkXvUSaiaQcA7ntlGKuT4q36Od0mPCSjKnv7ipFEVkk6xuFoZXn6b
	 uSqb/JHB1ST+de9d3LdX8YJ0W0bMcQ2Jjo1VZ7KMJw6BDtFDM4/DtCs2Es+R0Irz2JGdB
	 taE7nhhao3exsLRbIpdBwASf4W3YGmRHSZZ9tpeAAwWeFb0TTRqPXlv/vRfAaPX/xdDeo
	 n00VUY7yPhvldFRBXrgS0/tbZ7K/w5sftZTCsBk73kvxEL+NOo7qC2RBB0IplqrtmuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XQGUTndk;
	arc=none smtp.remote-ip=209.85.214.180
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A22C606A31E
	for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 16:13:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7A22C606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XQGUTndk
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2f04fab527eso54744615ad.0
        for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 08:13:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795709605; x=1796314405; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vLWcuVXHw7/3pDdU781pZXDaraoDyBbUzoCfgXPKW7s=;
        b=XQGUTndkN7Rj3nKx/iNthfA2ibbfyPF5+t3eVRGJShWmKfPZJJWTZi8d07HK7CvnYR
         7mgn0JGGgi+CRIvSF2ZuhTGXJuzaugioKm3PnCdFQCP5XEyPdsmaM3zY2cJms9jCvM12
         TBe+NVoGSM/O6y10Tu1YAKjbTfs7HNqcZFOhYqKML3hyiGju+NzfjKx4nx6x2x5K4e9W
         SypHn9UdSO+KYhhXKXckO5aQy0qKs0it6JdQCAR75pLQikZqrsmVduSVK3yl9B7G8xtH
         oAz4FVHo/8wMY4EoA7WgERs9l6O7LvOggE/QdeMgkn4XudHoNh7nu/1O9vEiy24KNLya
         dRjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795709605; x=1796314405;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vLWcuVXHw7/3pDdU781pZXDaraoDyBbUzoCfgXPKW7s=;
        b=EGme6+rvm+2+0Ww3U52qIJqVE03M2ZvQHZrKdHSA3Khlp7svZksJPaPzasop5B1Zrd
         e7EqKJ733RcWbku+Mtqm+DcwbALTQeUDLRTy/ImVyhbgclI9VU8EBlVYQWRDloVp/DsJ
         w2whYLEAdjINYFNOnQ2WWxYxZSueEbqcssvpPf8qbdrRWtny+7P5/gW7NqG2CuYBoMMF
         rlun7BlKHL1j1YHXYVdlzArVPSf4nRqWFPRHkmbuHOh62DczHT9MrHdnSqHhX2ddqV7X
         XXCpp/mHmksexsHvollcgjaO6rrI96OomqiTqxd8hMEAzoDeOVM3d3KfeTr37pvTSX9f
         ZnBA==
X-Forwarded-Encrypted: i=1; AL+hErGImkhfDFlS28uMJD3ulYfy778bBMK4SmmM32xyZx7ZG6cLeh/MOYpuegbgYO1FXzhFcmaGS4BkW4wL@vger.kernel.org
X-Gm-Message-State: APuU4Z+iFIjKmqsZA+rYRPy++e+64F8p6gfIl3kbyGzrugF8eTJ4jfxU
	pm3c+fIDeCPrNS7Ig0uglzQiL91wPlg+i8cBQcy6QWasfkPpe5WROd8G
X-Gm-Gg: AZFdTZclubMbIf9w1AaGO4HA6QEdk1CJBlm+xUTEWGRN9mSR4xjVsn+yiXHYCckmJf0
	nW5dbdTO+zeUppRpu6VFYl2EWcJGDd9RCcI20NV+JS6rBuxRQEWnkb8cuwAkTRYhGdgvfk4YVTV
	A81M+TBMMDA8bIbQEKWV7MnxAtFhtWGaiM7RDvVbir/JoEk8MdpPTFYsyxyoqeqiR1PO9PSpzcE
	0IctiSmmMn2fjUodNlDPypGvUWWTKB8eDbszRo8mmxoKQz4+zsAE6ZhaQQf9Mj6hTyuYFew8YUJ
	BTp2LYAWOQn1j5RkMhpSFW8hlap2AgU0gO4/t9ze/uYnAhq1O6NoM3gv7BNuW18hSgCwwUBIF5L
	Ontek3H86MtBvqOqUJUXUI2bHf1eMmjK6ygIwXtWG7g56mQjXO+LfPzGGlJkLtNRGuCa6MZQQXW
	WmjLhYwaVLKRMiQOiCqICXgar+2d2JRcpdxaWrDYpPpz2j+D1li+fhYJCPW+5AHfcXk8hHiboCs
	+9E/DGQJXIyBhQUwkQLYbOOKf6rmp0MJlqW3Y6gQK0zs0ZDfNgSBSzan+loMXMnfu1PGQbd84X9
	FmKjq/xBd5l/pKhGIfykYN5D/h+0FdONkLECXvon2sR+Vu8Z1k1F4Vj9HPp24lcxps3xzywYRBz
	3TJgl9JYiz4scUA==
X-Received: by 2002:a17:902:f547:b0:2ef:dc8b:7c0c with SMTP id d9443c01a7336-2f03f256468mr259006105ad.52.1795709604314;
        Thu, 26 Nov 2026 08:13:24 -0800 (PST)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([2001:df6:11c0:e720::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03ee84027sm105564825ad.7.2026.11.26.08.13.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 08:13:23 -0800 (PST)
From: Qican Ma <goonsomeway@gmail.com>
To: linkinjeon@kernel.org, pc@manguebit.org
Cc: metze@samba.org, tom@talpey.com, ronniesahlberg@gmail.com, sprasad@microsoft.com, bharathsm@microsoft.com, linux-cifs@vger.kernel.org
Subject: [PATCH v3] smb: client: protect server->smbd_conn with RCU and refcounting
Date: Fri, 27 Nov 2026 00:13:18 +0800
Message-ID: <179570959875.92741.4311009098248753929@gmail.com>
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

In the cifs_prepare_read/write() hot paths, which only need the
negotiated max_frmr_depth value, skip the refcount round trip entirely:
guard on server->rdma and read the parameters under rcu_read_lock(),
which is sufficient because smbd_destroy() waits for synchronize_rcu()
before releasing the socket and freeing the connection.

Found with an LLM-assisted code review tool and verified by inspection on
v7.4-rc4 (b6a9fa34ce4). Build-tested only; no RDMA-capable SMB server was
available for runtime testing.

Fixes: f198186aa9bb ("CIFS: SMBD: Establish SMB Direct connection")
Cc: stable@vger.kernel.org
Signed-off-by: Qican Ma <goonsomeway@gmail.com>
---
v3: cifs_prepare_read/write() no longer bounce conn->refcount on every
    I/O subrequest just to read max_frmr_depth; guard on server->rdma
    and read the parameters under rcu_read_lock() instead, per sashiko's
    review on v2.
v2: resend via direct SMTP without line-wrapping corruption in the diff.

 fs/smb/client/cifsglob.h  |   2 +-
 fs/smb/client/connect.c   |  11 ++--
 fs/smb/client/file.c      |  35 +++++++----
 fs/smb/client/smb2ops.c   |  72 ++++++++++++----------
 fs/smb/client/smb2pdu.c   |   6 +-
 fs/smb/client/smbdirect.c | 111 +++++++++++++++++++++++++----------
 fs/smb/client/smbdirect.h |  16 +++--
 fs/smb/client/transport.c |   4 +-
 8 files changed, 172 insertions(+), 85 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 4e16347886ed..c0f75f756de0 100644
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
index 750b5bb72dc7..03072d7a790a 100644
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
index d272320436b3..5d3cbaeeb0a0 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -391,11 +391,21 @@ static void cifs_prepare_write(struct netfs_io_subrequest *subreq)
 			      cifs_trace_rw_credits_write_prepare);
 
 #ifdef CONFIG_CIFS_SMB_DIRECT
-	if (server->smbd_conn) {
-		const struct smbdirect_socket_parameters *sp =
-			smbd_get_parameters(server->smbd_conn);
-
-		stream->sreq_max_segs = sp->max_frmr_depth;
+	if (server->rdma) {
+		struct smbd_connection *conn;
+
+		/* A plain rcu read is enough here: smbd_destroy() clears
+		 * server->smbd_conn and then waits for synchronize_rcu()
+		 * before releasing the socket and freeing the connection,
+		 * so the parameters memory stays valid for the read-side
+		 * critical section.
+		 */
+		rcu_read_lock();
+		conn = rcu_dereference(server->smbd_conn);
+		if (conn)
+			stream->sreq_max_segs =
+				smbd_get_parameters(conn)->max_frmr_depth;
+		rcu_read_unlock();
 	}
 #endif
 }
@@ -610,11 +620,16 @@ static int cifs_prepare_read(struct netfs_io_subrequest *subreq)
 			      cifs_trace_rw_credits_read_submit);
 
 #ifdef CONFIG_CIFS_SMB_DIRECT
-	if (server->smbd_conn) {
-		const struct smbdirect_socket_parameters *sp =
-			smbd_get_parameters(server->smbd_conn);
-
-		rreq->io_streams[0].sreq_max_segs = sp->max_frmr_depth;
+	if (server->rdma) {
+		struct smbd_connection *conn;
+
+		/* See cifs_prepare_write() for why a plain rcu read is safe. */
+		rcu_read_lock();
+		conn = rcu_dereference(server->smbd_conn);
+		if (conn)
+			rreq->io_streams[0].sreq_max_segs =
+				smbd_get_parameters(conn)->max_frmr_depth;
+		rcu_read_unlock();
 	}
 #endif
 	return 0;
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 298f549bd7ed..1e07557a42de 100644
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
index 7b7d25364e20..d407ec7c3b74 100644
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
index 563ef488a225..936988bad5db 100644
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
index be205ec02077..e8cf8f901cac 100644
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
index 375b821ab3ea..63d6700e5bd7 100644
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
