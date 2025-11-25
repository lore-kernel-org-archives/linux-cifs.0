Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309611C5D72
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093696; cv=none; b=VQh23qnI4nQq+o/ixtrg0wgJOLwEdMhPe4O38CPHBrhSaAQItT2QcBSscYBcWXNkklqjNTMG41+4gk2tqkBagBfbFj88zgrFfVDjYm3Zm4x1yjnXc4TcOBXYO9wi4eQc5TVIOSlTcdGtPum3sCrRk637BUwgo7ddOaXzduJhe3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093696; c=relaxed/simple;
	bh=QtnGSymqCUC0hwwx7EO9NiiKDAXvSg/XPhQGX5t9dys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYrXjGvUU0SukYtII3mDHzIuOfwLPhNsvCugqXbzwxzI/slHXce5KzD84VB7Vnt72AqenZK1/yy6pmblzUj/5ZqVsyTJTGvOi1mYR8YG7qSiIu8I0e3oHyYB0wFc1JwOwEvV8htI0guhylV5/8wgKVdAH65lXBXUTpF7cDMkYeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=Pa+0+7hb; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="Pa+0+7hb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=2om9wjKVdZ81jGCMJQ2rHgmpe6rkzOwkCBDni17o95M=; b=Pa+0+7hbLtg05XoLRAX2lnB0ej
	w6JY7TgqlM7kdMh4DDJ3MX4U2/W2pV4n9UdO48XmT9oVGkZh0jlZCDWy4/zN3/b3PIM2F5CE1mOID
	P8KI20vXwPeJEtF4BzicQ4axr4pu7ieO1Jm0YJ4Co8K3x5+wQKrg0DdKzZocpPGPzulBs+fUTKv8T
	azvAIL1aD+b02wFj3wb0lKEYon7EzxpmeTG8RtHvVg23OP1N5mgp1tCD1JC5bVNvpq4HYNm5qH9nS
	LQqYtnCNAALRnvAJGv8ph5+XYi1QCDlAzgjP3POdWzDkeOcMdTwRUgqtrde/MtJLqYsb4RSfyhuBP
	aOKP/f92DPhqGcq5CDgDqXzGTP/eIETwTnPm6cbpXMtTa1nlpYNAi/clSvZ8bq3gj6BccWoibJQE8
	6tekbNEXmfRtQk1CXvQPKLX+6K84iv8XEjw18OXbcDMNQiAlwbkg4UxTG6+kNELKlJ0C72vTiweol
	1Eje3CWJgadkffOut4aEAadY;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxLz-00FdDb-3C;
	Tue, 25 Nov 2025 18:01:28 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 046/145] smb: smbdirect: introduce smbdirect_connection_negotiation_done()
Date: Tue, 25 Nov 2025 18:54:52 +0100
Message-ID: <687931d9c4d99549ac0e26c5e8b48fefbec4dbcb.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will be used by client and server in order to turn the
connection into a usable state.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_connection.c   | 48 ++++++++++++++++++-
 1 file changed, 46 insertions(+), 2 deletions(-)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index 8ee3a1e28f82..3576737ec199 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -19,6 +19,9 @@ struct smbdirect_map_sges {
 static ssize_t smbdirect_map_sges_from_iter(struct iov_iter *iter, size_t len,
 					    struct smbdirect_map_sges *state);
 
+static void smbdirect_connection_recv_io_refill_work(struct work_struct *work);
+static void smbdirect_connection_send_immediate_work(struct work_struct *work);
+
 __maybe_unused /* this is temporary while this file is included in others */
 static void smbdirect_connection_qp_event_handler(struct ib_event *event, void *context)
 {
@@ -154,6 +157,49 @@ static void smbdirect_connection_rdma_established(struct smbdirect_socket *sc)
 	sc->rdma.expected_event = RDMA_CM_EVENT_DISCONNECTED;
 }
 
+__maybe_unused /* this is temporary while this file is included in others */
+static void smbdirect_connection_negotiation_done(struct smbdirect_socket *sc)
+{
+	if (unlikely(sc->first_error))
+		return;
+
+	if (sc->status != SMBDIRECT_SOCKET_NEGOTIATE_RUNNING) {
+		/*
+		 * Something went wrong...
+		 */
+		smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_ERR,
+			"status=%s first_error=%1pe local: %pISpsfc remote: %pISpsfc\n",
+			smbdirect_socket_status_string(sc->status),
+			SMBDIRECT_DEBUG_ERR_PTR(sc->first_error),
+			&sc->rdma.cm_id->route.addr.src_addr,
+			&sc->rdma.cm_id->route.addr.dst_addr);
+		return;
+	}
+
+	/*
+	 * We are done, so we can wake up the waiter.
+	 */
+	WARN_ONCE(sc->status == SMBDIRECT_SOCKET_CONNECTED,
+		  "status=%s first_error=%1pe",
+		  smbdirect_socket_status_string(sc->status),
+		  SMBDIRECT_DEBUG_ERR_PTR(sc->first_error));
+	sc->status = SMBDIRECT_SOCKET_CONNECTED;
+
+	/*
+	 * We need to setup the refill and send immediate work
+	 * in order to get a working connection.
+	 */
+	INIT_WORK(&sc->recv_io.posted.refill_work, smbdirect_connection_recv_io_refill_work);
+	INIT_WORK(&sc->idle.immediate_work, smbdirect_connection_send_immediate_work);
+
+	smbdirect_log_rdma_event(sc, SMBDIRECT_LOG_INFO,
+		"negotiated: local: %pISpsfc remote: %pISpsfc\n",
+		&sc->rdma.cm_id->route.addr.src_addr,
+		&sc->rdma.cm_id->route.addr.dst_addr);
+
+	wake_up(&sc->status_wait);
+}
+
 static u32 smbdirect_rdma_rw_send_wrs(struct ib_device *dev,
 				      const struct ib_qp_init_attr *attr)
 {
@@ -1193,7 +1239,6 @@ static void smbdirect_connection_send_io_done(struct ib_cq *cq, struct ib_wc *wc
 	wake_up(&sc->send_io.pending.dec_wait_queue);
 }
 
-__maybe_unused /* this is temporary while this file is included in others */
 static void smbdirect_connection_send_immediate_work(struct work_struct *work)
 {
 	struct smbdirect_socket *sc =
@@ -1511,7 +1556,6 @@ static int smbdirect_connection_recv_io_refill(struct smbdirect_socket *sc)
 	return posted;
 }
 
-__maybe_unused /* this is temporary while this file is included in others */
 static void smbdirect_connection_recv_io_refill_work(struct work_struct *work)
 {
 	struct smbdirect_socket *sc =
-- 
2.43.0

