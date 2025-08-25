Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5CC2AE90
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154996; cv=none; b=jHQaBVrHck27vJRhpZ3u8xN6eDnriQkhBhL23Fi9spv752aHiVlPJcq+IyGzy04Gaxm3RfEXUJ+gVAN4lUC7wclMqzGaexR4MkKqqbik/WlrYBRry6ew/lnFO8Xw8Em1TQJaLg60vvYbPY+RZf70IW7QPiBX4HlERC9YCTg2Bbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154996; c=relaxed/simple;
	bh=O5Spwrv6jnHSQtXpAe6S0qkkUzO62KtaZ2DeaZGTrjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRT4dfQjRUghSOaoI7iYnJYzyey8T+rkkvic39OpogmtlzTgGHfpAiCiUOiQmVu1We3IQWfunrpARWQ0DS9/9L9YRLzY8ppEFmCZhnI5EktS6H+d+MXQpkCAGAu+Kixg1JWP+4iw8XuQJR/qeCY05+CPw7d6a8Sb4zaxkrah2xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=MunEwPXD; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="MunEwPXD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=+BkAtarVbo/Pg7POrei8KmWlwGi/T9mvQ78+nC2JiIw=; b=MunEwPXDt3bJVpMVvxHOUw4CQi
	iTvr57SMs6VyWfD7/03WOaSJv5t1/JlKVPvJd7gH3wSQx5U0SL9tgvRHQ/fX+jTc7CIWarTrmJ1Fp
	C59UopBg9MAJe6hylTS0hQYVBcBGYtrJmjvl0J68QPMPv55aSSNfjsNDcylwErSSOKo/P90tC2dVd
	TaOIm3l+Pzl0TRGfXrE8tSVpv2wGf2HL7KG/7lmL16SjVBZj+TQqLo7CUvuwlPvhlaPgKWwW56NRd
	MFE14gwrzfJupcbVvOKWYpDgF8ItpEwGmhOOHa3CKwnSM2/bEEd/N+6FR9KpHGFtHNpdMzW5gXlsW
	qnhO0Nhq34B+p3qK5knX4D1WbsjheV3BoDf/ZBDwfNjottOaIWR991ejLSA2yh7U42cxpK3jzRNDD
	/5EGe87J8eTmjG0tZAHhbog/jEzxTbPnVfuhkLqc+uSn/MS8Uq/gjdPnDJlE+vKX1PHTLuHys0xzd
	5DS/nAcIrBAAyFbkjihS4CV4;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe8V-000kpe-39;
	Mon, 25 Aug 2025 20:49:52 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 049/142] smb: client: move rdma_readwrite_threshold from smbd_connection to TCP_Server_Info
Date: Mon, 25 Aug 2025 22:40:10 +0200
Message-ID: <1e537c128aa175137fd2cb69bd11f4eef0745f6a.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This belongs to the SMB layer not to the transport layer, it
just uses the negotiated transport parameters to adjust the
value if needed.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/cifs_debug.c |  2 +-
 fs/smb/client/cifsglob.h   |  7 +++++++
 fs/smb/client/smb2pdu.c    |  2 +-
 fs/smb/client/smbdirect.c  | 15 +++++++++++----
 fs/smb/client/smbdirect.h  |  7 -------
 5 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index bb6bb1e3b723..eca7bd0df7d3 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -459,7 +459,7 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 			"max_readwrite_size: %x rdma_readwrite_threshold: %x",
 			sp->keepalive_interval_msec * 1000,
 			sp->max_read_write_size,
-			server->smbd_conn->rdma_readwrite_threshold);
+			server->rdma_readwrite_threshold);
 		seq_printf(m, "\nDebug count_get_receive_buffer: %llx "
 			"count_put_receive_buffer: %llx count_send_empty: %llx",
 			sc->statistics.get_receive_buffer,
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 1e64a4fb6af0..f87a1ca33592 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -814,6 +814,13 @@ struct TCP_Server_Info {
 	unsigned int	max_read;
 	unsigned int	max_write;
 	unsigned int	min_offload;
+	/*
+	 * If payload is less than or equal to the threshold,
+	 * use RDMA send/recv to send upper layer I/O.
+	 * If payload is more than the threshold,
+	 * use RDMA read/write through memory registration for I/O.
+	 */
+	unsigned int	rdma_readwrite_threshold;
 	unsigned int	retrans;
 	struct {
 		bool requested; /* "compress" mount option set*/
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 2df93a75e3b8..0dedea47bf96 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4411,7 +4411,7 @@ static inline bool smb3_use_rdma_offload(struct cifs_io_parms *io_parms)
 		return false;
 
 	/* offload also has its overhead, so only do it if desired */
-	if (io_parms->length < server->smbd_conn->rdma_readwrite_threshold)
+	if (io_parms->length < server->rdma_readwrite_threshold)
 		return false;
 
 	return true;
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 220ebd00a9d7..0eb46b01da32 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -489,10 +489,6 @@ static bool process_negotiation_response(
 	}
 	sp->max_fragmented_send_size =
 		le32_to_cpu(packet->max_fragmented_size);
-	info->rdma_readwrite_threshold =
-		rdma_readwrite_threshold > sp->max_fragmented_send_size ?
-		sp->max_fragmented_send_size :
-		rdma_readwrite_threshold;
 
 
 	sp->max_read_write_size = min_t(u32,
@@ -1898,6 +1894,7 @@ struct smbd_connection *smbd_get_connection(
 	struct TCP_Server_Info *server, struct sockaddr *dstaddr)
 {
 	struct smbd_connection *ret;
+	const struct smbdirect_socket_parameters *sp;
 	int port = SMBD_PORT;
 
 try_again:
@@ -1908,6 +1905,16 @@ struct smbd_connection *smbd_get_connection(
 		port = SMB_PORT;
 		goto try_again;
 	}
+	if (!ret)
+		return NULL;
+
+	sp = &ret->socket.parameters;
+
+	server->rdma_readwrite_threshold =
+		rdma_readwrite_threshold > sp->max_fragmented_send_size ?
+		sp->max_fragmented_send_size :
+		rdma_readwrite_threshold;
+
 	return ret;
 }
 
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 8ebbbc0b0499..4eec2ac4ba80 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -43,13 +43,6 @@ struct smbd_connection {
 	/* Memory registrations */
 	/* Maximum number of pages in a single RDMA write/read on this connection */
 	int max_frmr_depth;
-	/*
-	 * If payload is less than or equal to the threshold,
-	 * use RDMA send/recv to send upper layer I/O.
-	 * If payload is more than the threshold,
-	 * use RDMA read/write through memory registration for I/O.
-	 */
-	int rdma_readwrite_threshold;
 	enum ib_mr_type mr_type;
 	struct list_head mr_list;
 	spinlock_t mr_list_lock;
-- 
2.43.0

