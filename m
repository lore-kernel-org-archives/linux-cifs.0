Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3C932B9BA
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093579; cv=none; b=isyGTv4mhdabsJ9NBUi7umPqIEYpownqKbjUVH/tfOYmDmAoAKIr3xjPE3H2pDoAY0lX6OgSgNm1ifex2c17UY51YFLJ7r7EqhN67j1hUaWxCwEV8AotChon0FlLc6c3QhuQ8Eq9Ybd3Xm5ipOdt4nMHHocF+56VuulEBGxgge4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093579; c=relaxed/simple;
	bh=WnX6CqnoJZOcoFbbuKLx173pI02/VXQ3Lize6ykoJV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZMlOI9kvaFRaZKQOj8ftegSOLHuf11zXX70gWTBZI5H02SOwav5x5yaqYHBptTy5ZTzpqkMv40cRi4ZBD9yAbsbgkvfGQKvlBL8ui3/fqAy46hDyCbYnctrupFkeQOQ3SrHYfirYGXtd12oakxDTgKBzAP6etCAvQWKUiub2mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=xZmvco61; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="xZmvco61"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=3vmuNBUlxrWLshbRVDMrGBqpy/riS7SKwetM6TM8DAc=; b=xZmvco61fepMf+tqFFO+UPaHhc
	ZLX19/OLIZeO/IhNOILaAmN3OeWFHsOVCxhWPEEAD+yFDOTtpFp654V/yMqZGiKU1xpD7gL+yvZ2L
	BQ6JtLZfiCZLAhzDR60T+7XElkjCflRXSSqzfs0XxzBIA7W0zgP4cTnXtgsfL+krWkAsvnNjlSNPD
	ixNNzYCV6siPcRGFZJax7rhFjNk6OC13mm839Ex/QQG2u7HSivpltarw/Fj5d9mHNlR2GwyqujqVA
	BrBrIDPeCYhiQ9rbLidnKrp4s+VdpJKTMYLbHUG2aGaSsl7QGp5W/kDbTSAHFeF2JuND+VorGHdpK
	17jVgg0XnFip3Sy6lP3pLqZEMVT9zyAYy/xQbErXZ+jyKnRGZruIZcXci0LPx3DsQBw9XYn8LRsUF
	I0vz07ABFm3Ro4iNFomGJz0Mj4hJU2BfJd4SlPhP5tprOEuTKevamzoZcA+Jj4YC5iVK5ZedThUFB
	Yt2E0oc0fZRXs80EwXY2+mQH;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxK9-00Fcwa-2d;
	Tue, 25 Nov 2025 17:59:33 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 029/145] smb: smbdirect: introduce smbdirect_connection_post_recv_io()
Date: Tue, 25 Nov 2025 18:54:35 +0100
Message-ID: <d7a36ccc311060df0c73e88632dc61fcb305faac.1764091285.git.metze@samba.org>
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
index 6ac4e88da1b0..bc88cbb313ce 100644
--- a/fs/smb/common/smbdirect/smbdirect_connection.c
+++ b/fs/smb/common/smbdirect/smbdirect_connection.c
@@ -641,6 +641,48 @@ static void smbdirect_connection_send_io_done(struct ib_cq *cq, struct ib_wc *wc
 	wake_up(&sc->send_io.pending.dec_wait_queue);
 }
 
+__maybe_unused /* this is temporary while this file is included in others */
+static int smbdirect_connection_post_recv_io(struct smbdirect_recv_io *msg)
+{
+	struct smbdirect_socket *sc = msg->socket;
+	const struct smbdirect_socket_parameters *sp = &sc->parameters;
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
+		smbdirect_socket_schedule_cleanup(sc, ret);
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

