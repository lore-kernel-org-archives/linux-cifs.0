Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E311C5D46
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744309; cv=none; b=aA07WYIFiirhKfEJ6TUbuN8ojdb0O9vot/pzjb2F4UMm6zJZ5g+bh6MMqXoJhgBemsd1qdqkGhvhr6ZD/VT63OSYSoCb4omMRu5L8gWAv4CTzMzVQlJLG6gqYoK/B6FNMrBjbOFEhNxySaddSE235ZFk4uVJ/dIhXK0ZUX50xmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744309; c=relaxed/simple;
	bh=lTQ2WE69e0/6jG4f6EQHLCOUiAll9DhTqs3xaYe7FzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bf7rvnoGe0ixQCMUcoRzZW6LtEi7N9eChRhg/Oap5N5/4SrT+mbFE3CmoTwqe9nGPnKEsdppPlaQViriRZijMZ3OANFz5bVXgxccqgiE98tTW8KTXzQBW0/CTQXMNysqoU+WEotz4wNpk6HnMJfL9UgeY81/D7uYWtJG+7zp4XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=3fm6AIMs; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="3fm6AIMs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=zlbU6R3ZmLjT6Xl5IZ0R2/9PwvjosVdqU8P5D/TS5Us=; b=3fm6AIMs1eW95xKee63NSbbYxY
	9rx9RnMzRvY/92MmxVtQXskqBRsACRu/IhSBZ4ciC5qwRAshGMzAFEcmj7e9uBduSAg/TvVYb95ua
	s/kLvzIWgphNPkcxaJFc8ekqCnVi/2b92u/WlQzlJUmYOffnpbbH7Nn9ymZQ1Uxwux9/Zbf4H2fBb
	YjgW5c5p2Wk9NmGLk/m7TqirOYh2Oum7dXeqm9nzwVPHF8qgCd1S7al25Z46u5e0rzba4L0DSO4m+
	A634z9b4Upmg7ufZMdg37+kpHZWT4JNma6z7akhs5RHAlMb19o3u7SX/98C0rtd1Ks+zD7/+Q5mBL
	gf79dMdmnLnFeGK44y6W7U6PyVGiBxQHn38ooyQGfVnyPS+Ovv/eLjW4idTA7PdhYs7i6cq3gsmjf
	I/d78QIIPKCZlex/UaJFbIEAm1WlgL3tzhY45Omzy+4aDytPgQAxutv3VWXopYnUcHGDXaLQG1MxP
	qSESc+ljzp3b7i2lK/EN2uJ0;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6Ai-00BbaW-1P;
	Wed, 29 Oct 2025 13:25:04 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v2 026/127] smb: smbdirect: introduce smbdirect_connection_post_recv_io()
Date: Wed, 29 Oct 2025 14:20:04 +0100
Message-ID: <ba5b2506daf831e8e0ab00ea53024ba2cd63120d.1761742839.git.metze@samba.org>
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

This is basically a copy of smbd_post_recv() in the client and
smb_direct_post_recv() in the server.

The only difference is that this returns early if the connection
is already broken.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 .../common/smbdirect/smbdirect_connection.c   | 42 +++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect_connection.c b/fs/smb/common/smbdirect/smbdirect_connection.c
index 448723d438af..959b0c49857f 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -839,6 +839,48 @@ static void smbdirect_connection_send_io_done(struct ib_cq *cq, struct ib_wc *wc
 	wake_up(&sc->send_io.pending.dec_wait_queue);
 }
 
+__maybe_unused /* this is temporary while this file is included in orders */
+static int smbdirect_connection_post_recv_io(struct smbdirect_recv_io *msg)
+{
+	struct smbdirect_socket *sc = msg->socket;
+	struct smbdirect_socket_parameters *sp = &sc->parameters;
+	struct ib_recv_wr recv_wr = {
+		.wr_cqe = &msg->cqe,
+		.sg_list = &msg->sge,
+		.num_sge = 1,
+	};
+	int ret;
+
+	if (unlikely(sc->first_error))
+		return sc->first_error;
+
+	msg->sge.addr = ib_dma_map_single(sc->ib.dev,
+					  msg->packet,
+					  sp->max_recv_size,
+					  DMA_FROM_DEVICE);
+	ret = ib_dma_mapping_error(sc->ib.dev, msg->sge.addr);
+	if (ret)
+		return ret;
+
+	msg->sge.length = sp->max_recv_size;
+	msg->sge.lkey = sc->ib.pd->local_dma_lkey;
+
+	ret = ib_post_recv(sc->ib.qp, &recv_wr, NULL);
+	if (ret) {
+		smbdirect_log_rdma_recv(sc, SMBDIRECT_LOG_ERR,
+			"ib_post_recv failed ret=%d (%s)\n",
+			ret, errname(ret));
+		ib_dma_unmap_single(sc->ib.dev,
+				    msg->sge.addr,
+				    msg->sge.length,
+				    DMA_FROM_DEVICE);
+		msg->sge.length = 0;
+		smbdirect_connection_schedule_disconnect(sc, ret);
+	}
+
+	return ret;
+}
+
 static bool smbdirect_map_sges_single_page(struct smbdirect_map_sges *state,
 					   struct page *page, size_t off, size_t len)
 {
-- 
2.43.0

