Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1553123EA9C
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744273; cv=none; b=IdotgNL6eTT0Xhu9mL8DRWLLiGziOJBdgZdJmyeCkNjpvsBGKI3mc/clLMUDqdRRasrxaOlnOsurmn6Ces1KTLQKdE75DhTzIpKpsZV9FP1CmbiAF6rsriqoPhBFEU+0NIO28Xm3rzD26J8+9GOGqhaPr3YLKjVU2GTZGln1Rek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744273; c=relaxed/simple;
	bh=5NXPiLkftIuNQurxkpX9T9q10PB/Fex9oiI3rE0Y81w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LsORigZh3nFGNBo+mxpdoGVK5n4LFv4mawieRFG5kIAKGl1A2YgnVdtp4EOf50DjFMZRSJpLHXLxlgmt3gzMTHEqrGidYQn1ciKzR32Yk/ualf1fNO+mukAofxA9MfBrOskIbKPGztlIFb9WRP2PpocW6LhtnNf6AXUwe7ikSIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=F9CDmvM1; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="F9CDmvM1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=W25Lc2rBDqaolDVFFyXbWKKD1MzRZBLvvcJSdADQXBk=; b=F9CDmvM1wqunuPRljm0wy5OvkO
	DSFVIeWe2GysAe32Vq/m76x+ihRwHhBYjTwrSiU8JzV5bOYoOs4rCiCjDDksr4fo0Z1YGQBGwd80C
	fPBEUGZtPHHrAZ6OnnFIgTTSZOdAyrsAKJi4we9eslmJ45POYM9Lxi6byXivb3GZfYabwavTJo5id
	hWkQJaRyWHShRC/m8GBnpUyzhgG8I8SlRH95z/fnIz00Y/WobTwgqIGWY/ThQ0raqLPgD0gU3k5j6
	lRpqvos00b+MtF5N5s+U/msS9aEAjMLyYB8HRepfVKhnhO72N73kf8GOqxjz2XySM+HzdqOcyjNYS
	ZLY5/HeqiQVj9HmOQUb03hoXlN8/9kP6SVqrK+MTqAB01F11qqBbt5dh7ad2FIlGs+46+wtXz0nDO
	SPIPabt1rOZg7VzlR5xeEm8wJhkTYAWtgfvSdWEZTagNrA11JBQ5HiMzCQ1G/Opl48sS5efuQW296
	lOEzgcyDKLnacXKrS513w1Lr;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6A9-00BbVL-26;
	Wed, 29 Oct 2025 13:24:29 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 020/127] smb: smbdirect: introduce smbdirect_connection_send_io_done()
Date: Wed, 29 Oct 2025 14:19:58 +0100
Message-ID: <2506202c043d04c50fa500207b5bb57952e577ef.1761742839.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1761742839.git.metze@samba.org>
References: <cover.1761742839.git.metze@samba.org>
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
index e5e8432f88e6..05a68991587c 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -375,3 +375,46 @@ static void smbdirect_connection_idle_timer_work(struct work_struct *work)
 		"schedule send of empty idle message\n");
 	queue_work(sc->workqueue, &sc->idle.immediate_work);
 }
+
+__maybe_unused /* this is temporary while this file is included in orders */
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
+		smbdirect_connection_schedule_disconnect(sc, -ECONNABORTED);
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

