Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAEE32B9B3
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093584; cv=none; b=aBtW4njeB272OWprM2vKvz3Vd9hT0Ezsf+TZc5OyB2Gvd2Cfk6+FhjWSDwPNl2rkrXLlI9rfGarOtscO7fxoXs8WohNg4lyV4BXZYINW8qYILm4VLGJeI4LADN7F7sCf4S6PZF6yH2gsq4suu+bJOt3HR9jVyMD/pVdCcpUc1no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093584; c=relaxed/simple;
	bh=j1Ysv0VvLUPB/5tJBt1jeyTjv5fbBRi2WQ53BbDttKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=StKb07b9BkwpVHRWO8lLTLo0NMp+gzFb9+htX8hU3Pvv0DM6q76qfZJFsG7lYfbqVF7ro3SnY+7otDtXyS8s6++0uOl2EUOeOPDZyQtTXL39WIzZprTO6oCyZNfiRN4pa+OE/CF+evrgA0hVA2TT9Kn2U6oecCYLcYikyZcesCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=HFfXNtFp; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="HFfXNtFp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=uKgJg9/E4iDotawwGC0HRol7AJp9JRDRoEELjviSTVk=; b=HFfXNtFpxtPVgJy6hFPxSWobty
	2wsN4knMm90Zku4U3nUASKkd02EOL8S9fzpgCpEOaJsXoMbI5inEfB9/vkByDNLFsAqDrow89U/uY
	Mu0IWCcz5cXwntFo30/Qld6A61e6Zc3xrDT6Zw2bWEUaqv75auv7ls6hyQQQwTX75Qxdiv/wk20IK
	cbCduw5djRwVNKtN6vEsh0SXZIF8ph2ynhwPDASfEbC1VqfzCB6oIszNV4RFkZan3UOfb/trHf9cn
	5y7J4BJFkMbE4gKIQSmjmsUpUi3scDBynzGg6kf82N3o98Nddj0pXm5W8YpSgTZxy6Wx2hYK+Oo+s
	CSwpd2RSmoZvC98euOfRMilEgL7eTmZExmUJBEQFgh77sFGk7K0IzIz2olLrndf4lbQSE0JgdCS4A
	2kRtIuNhbCk4nfiz+cuGiHe+m/+usVz+b8KPD0DddcIRnBBgCgu6cAT0LoHyEB4wB540IfGXn3iFc
	NS0OSa14rXisEi4C7U+X2TgP;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxKF-00Fcx9-1T;
	Tue, 25 Nov 2025 17:59:39 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 030/145] smb: smbdirect: introduce smbdirect_connection_recv_io_refill_work()
Date: Tue, 25 Nov 2025 18:54:36 +0100
Message-ID: <ca94d20bd219eaf6ff1bb308cbfecea733b1145d.1764091285.git.metze@samba.org>
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

This is basically a copy of smbd_post_send_credits() in the client
and smb_direct_post_recv_credits() in the server.

There are several improvements compared to the existing functions:

1. We calculate the number of missing posted buffers by getting the
   difference between recv_io.credits.target and recv_io.posted.count.

   Instead of the difference between recv_io.credits.target
   and recv_io.credits.count, because recv_io.credits.count is
   only updated once a message is send to the peer.

   It was not really a problem before, because we have
   a fixed number smbdirect_recv_io buffers, so the
   loop terminated when smbdirect_connection_get_recv_io()
   returns NULL.

   But using recv_io.posted.count makes it easier to
   understand.

2. In order to tell the peer about the newly posted buffer
   and grant the credits, we only trigger the send immediate
   when we're not granting only the last possible credit.

   This is mostly a difference relative to the servers
   smb_direct_post_recv_credits() implementation,
   which should avoid useless ping pong messages.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_connection.c   | 92 +++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index bc88cbb313ce..f260d50a561b 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -683,6 +683,98 @@ static int smbdirect_connection_post_recv_io(struct smbdirect_recv_io *msg)
 	return ret;
 }
 
+__maybe_unused /* this is temporary while this file is included in others */
+static void smbdirect_connection_recv_io_refill_work(struct work_struct *work)
+{
+	struct smbdirect_socket *sc =
+		container_of(work, struct smbdirect_socket, recv_io.posted.refill_work);
+	int missing;
+	int posted = 0;
+
+	if (unlikely(sc->first_error))
+		return;
+
+	/*
+	 * Find out how much smbdirect_recv_io buffers we should post.
+	 *
+	 * Note that sc->recv_io.credits.target is the value
+	 * from the peer and it can in theory change over time,
+	 * but it is forced to be at least 1 and at max
+	 * sp->recv_credit_max.
+	 *
+	 * So it can happen that missing will be lower than 0,
+	 * which means the peer has recently lowered its desired
+	 * tarted, while be already granted a higher number of credits.
+	 *
+	 * Note 'posted' is the number of smbdirect_recv_io buffers
+	 * posted within this function, while sc->recv_io.posted.count
+	 * is the overall value of posted smbdirect_recv_io buffers.
+	 *
+	 * We try to post as much buffers as missing, but
+	 * this is limited if a lot of smbdirect_recv_io buffers
+	 * are still in the sc->recv_io.reassembly.list instead of
+	 * the sc->recv_io.free.list.
+	 *
+	 */
+	missing = (int)sc->recv_io.credits.target - atomic_read(&sc->recv_io.posted.count);
+	while (posted < missing) {
+		struct smbdirect_recv_io *recv_io;
+		int ret;
+
+		/*
+		 * It's ok if smbdirect_connection_get_recv_io()
+		 * returns NULL, it means smbdirect_recv_io structures
+		 * are still be in the reassembly.list.
+		 */
+		recv_io = smbdirect_connection_get_recv_io(sc);
+		if (!recv_io)
+			break;
+
+		recv_io->first_segment = false;
+
+		ret = smbdirect_connection_post_recv_io(recv_io);
+		if (ret) {
+			smbdirect_log_rdma_recv(sc, SMBDIRECT_LOG_ERR,
+				"smbdirect_connection_post_recv_io failed rc=%d (%s)\n",
+				ret, errname(ret));
+			smbdirect_connection_put_recv_io(recv_io);
+			return;
+		}
+
+		atomic_inc(&sc->recv_io.posted.count);
+		posted += 1;
+	}
+
+	/* If nothing was posted we're done */
+	if (posted == 0)
+		return;
+
+	/*
+	 * If we posted at least one smbdirect_recv_io buffer,
+	 * we need to inform the peer about it and grant
+	 * additional credits.
+	 *
+	 * However there is one case where we don't want to
+	 * do that.
+	 *
+	 * If only a single credit was missing before
+	 * reaching the requested target, we should not
+	 * post an immediate send, as that would cause
+	 * endless ping pong once a keep alive exchange
+	 * is started.
+	 *
+	 * However if sc->recv_io.credits.target is only 1,
+	 * the peer has no credit left and we need to
+	 * grant the credit anyway.
+	 */
+	if (missing == 1 && sc->recv_io.credits.target != 1)
+		return;
+
+	smbdirect_log_keep_alive(sc, SMBDIRECT_LOG_INFO,
+		"schedule send of an empty message\n");
+	queue_work(sc->workqueue, &sc->idle.immediate_work);
+}
+
 static bool smbdirect_map_sges_single_page(struct smbdirect_map_sges *state,
 					   struct page *page, size_t off, size_t len)
 {
-- 
2.43.0

