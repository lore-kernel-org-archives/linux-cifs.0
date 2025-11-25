Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BE932B9BA
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093543; cv=none; b=AsmI4IZqg+pY3TuCcweE4+gF6pqaK2eNvHyTDklc0s81spiQ6qY6I530VRaPeDLj4KuYn2cleOtl7O4S85xDvIesyGpJHi+YD0zKZmUQnKJjGX+YVyevbmCIGuhjtJRltggCxzvkwSaRSJ6qopXlGrt/d4AbVxdUGpuK2cUMHCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093543; c=relaxed/simple;
	bh=BNnBFZ5DFaWRhW7gz9cmbi3RJNXMvw+gNBH0rpbjiXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZpjJMf7S8XpFV/isc5ckhMwCm3xPdkulSJVFwlt8G9QnKQXR8KWkMuFn2ajuvAaYPl8pnuPdUeiJkXfuxBbFZ3qkPOM/K9YEU9RU4QfiDWwf9HKWIxdBvB671LuaPmc6uTuc6Bs4jG9m9TmVlx4AUy7rEqYj+rtb1hxrAYuSlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=rT9c1Y+s; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="rT9c1Y+s"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=zIEeuAQWXhWx5bGrN/f/RwSnLgS5KBzfwS1sKBp+gjU=; b=rT9c1Y+shh8XYkMfQjuGROfawD
	g7v/ZTRUOGuVUeGEIlpnkgW5RzIJHQ8zVoVD1/2imrS31E3x2CayS5MM+9mZt3AAPNrBZ4yzMChoN
	wZTdD/sfb1VrC7JE6zM/cLxSTOvVEN+9b8aWh2qfOrFkj/t408tII4Db6R8gtG2sbiZApSCcAXIks
	XHvlO/IX8iTP4uZWT7viINRtQ8P8E4XulVytHwf8CSPVqeWxuNr+PQOt53uSxCHqDGvmGEt2uqVYD
	3bs+L1/7XYnVOPFr6kzA+PrPcmnSzVFsjQGQ1ZV5HmE2VdiQvHp464m2itB0iu7QTEuBcfomwC788
	ryyHkoYBujP+A6+p7FyEW5UAnWaCn40VMqsiNfjIFYSZfqK/x29SLfJJ/4KoYUDYwnKk+tU3KshfD
	TXKym7PUixv0fQJfJ9brlFQF1d9ITrIqrjQuiKs9vdKeuJCjsvLVRsXk2sMAa6yjqjK+b4POtoOvH
	2czzP6qbR6tLk8iYhJdOgIyr;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxJZ-00FcqA-0t;
	Tue, 25 Nov 2025 17:58:57 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 023/145] smb: smbdirect: introduce smbdirect_connection_send_io_done()
Date: Tue, 25 Nov 2025 18:54:29 +0100
Message-ID: <ccf547f423c935b3deab1bab49b09351f811841a.1764091285.git.metze@samba.org>
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

This is a combination of send_done() of client and server.
It will replace both...

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_connection.c   | 43 +++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index 7a2aaa1747dd..9608d153ed1a 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -170,3 +170,46 @@ static void smbdirect_connection_idle_timer_work(struct work_struct *work)
 		"schedule send of empty idle message\n");
 	queue_work(sc->workqueue, &sc->idle.immediate_work);
 }
+
+__maybe_unused /* this is temporary while this file is included in others */
+static void smbdirect_connection_send_io_done(struct ib_cq *cq, struct ib_wc *wc)
+{
+	struct smbdirect_send_io *msg =
+		container_of(wc->wr_cqe, struct smbdirect_send_io, cqe);
+	struct smbdirect_socket *sc = msg->socket;
+	struct smbdirect_send_io *sibling, *next;
+	int lcredits = 0;
+
+	smbdirect_log_rdma_send(sc, SMBDIRECT_LOG_INFO,
+		"smbdirect_send_io completed. status='%s (%d)', opcode=%d\n",
+		ib_wc_status_msg(wc->status), wc->status, wc->opcode);
+
+	/*
+	 * Free possible siblings and then the main send_io
+	 */
+	list_for_each_entry_safe(sibling, next, &msg->sibling_list, sibling_list) {
+		list_del_init(&sibling->sibling_list);
+		smbdirect_connection_free_send_io(sibling);
+		lcredits += 1;
+	}
+	/* Note this frees wc->wr_cqe, but not wc */
+	smbdirect_connection_free_send_io(msg);
+	lcredits += 1;
+
+	if (unlikely(wc->status != IB_WC_SUCCESS || WARN_ON_ONCE(wc->opcode != IB_WC_SEND))) {
+		if (wc->status != IB_WC_WR_FLUSH_ERR)
+			smbdirect_log_rdma_send(sc, SMBDIRECT_LOG_ERR,
+				"wc->status=%s (%d) wc->opcode=%d\n",
+				ib_wc_status_msg(wc->status), wc->status, wc->opcode);
+		smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
+		return;
+	}
+
+	atomic_add(lcredits, &sc->send_io.lcredits.count);
+	wake_up(&sc->send_io.lcredits.wait_queue);
+
+	if (atomic_dec_and_test(&sc->send_io.pending.count))
+		wake_up(&sc->send_io.pending.zero_wait_queue);
+
+	wake_up(&sc->send_io.pending.dec_wait_queue);
+}
-- 
2.43.0

