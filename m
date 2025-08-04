Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5676253F3A
	for <linux-cifs@vger.kernel.org>; Mon,  4 Aug 2025 12:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754309513; cv=none; b=kf0nA+7r8kzFnsn4sxki41AC4DmZn2fW35F21zeHJEETv/mtAtATS24bhPIGmABwpitDNORuHJ/2xWxW6P5LjJc7tLNSUbBSEw1TW5RhEuBQwaJmISiWnlu3e4C1P66xc9hujAvvku6AKmlJKplKcWuCYw6fCr9sHdtA91MuVxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754309513; c=relaxed/simple;
	bh=Kz6tefrvpmNgKzSIeDVtRQ06uYLpJa4yN71EADftU9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAv1FRb4JnAIU5jvOP2eSq33GaOjWv654y6NCOHI+MOzCuSNV3UIpRnSvkGTndACfp7DTa82cwWUg7kDYBt0oCq4Gv4WSF5vKCeOMxx6Dn1joMZ9DBJzUFM/GMhCqUqTNstZoQN+C8qcQxp/eCEz96CZjJ3EoXubE/q7Nt4/i0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=GxGS5hJt; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="GxGS5hJt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=iIftbjQoYLTTZiWwDWtcmyqSWAYPNz8FLhXJFTOEmfI=; b=GxGS5hJtgKg6xkxQOpWJSnGp97
	A8vVcQYhjh8iMrmRFvizsjE74oVXCUHCCTVRWW8rkMpkl4Nmr5LvMH2iQ84uCbW84ixg5ber4zDf6
	DH9GXcbrdlHzyrhSOo43gvm+BwWDYmdr0p1siE7UfeyQapCJtdkdvvJqpDwv2/cY1JzZfv8ZGwUIr
	Eg0JQaL2W8H4fZmdPITkwW6VYa2asv9RZ6HvFVUg3QrNDEnf9xoVfKQ4uuDk6p2j2qdsmFHLlVgC+
	9DOM+L3nCzRFSkPiGZjeLPmOcb//3NEIdiBQMNJW8l8DoYxJCxRrCnT5LXItKpdaqNOSwWOBh14l1
	7dca562tNVK/t4DPuQn/NIYkZbbtn5VXHdoVW26MlhdGayyXHTQhwb3l1m/9iAGzCUcivYDsKT6Yq
	p30UQl19eZVLUFUMe1zfc249HsEFSIQj9/WAPOdsCVC5c2ODTXOKEQhUC7tcl/YQJnBz5jyOTiCMf
	HZ3yb44MLRIt7BcxsFvBZ+in;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uiu2e-000vvB-1o;
	Mon, 04 Aug 2025 12:11:49 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH 3/5] smb: client: make sure we call ib_dma_unmap_single() only if we called ib_dma_map_single already
Date: Mon,  4 Aug 2025 14:10:14 +0200
Message-ID: <04f3ed65f8f1a04d231c7dad2f25624dbc6bc48b.1754308712.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754308712.git.metze@samba.org>
References: <cover.1754308712.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In case of failures either ib_dma_map_single() might not be called yet
or ib_dma_unmap_single() was already called.

We should make sure put_receive_buffer() only calls
ib_dma_unmap_single() if needed.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Fixes: f198186aa9bb ("CIFS: SMBD: Establish SMB Direct connection")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index b18e2bc6c8ed..a32ebb4d48a2 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1057,6 +1057,7 @@ static int smbd_post_recv(
 	if (rc) {
 		ib_dma_unmap_single(sc->ib.dev, response->sge.addr,
 				    response->sge.length, DMA_FROM_DEVICE);
+		response->sge.length = 0;
 		smbd_disconnect_rdma_connection(info);
 		log_rdma_recv(ERR, "ib_post_recv failed rc=%d\n", rc);
 	}
@@ -1186,8 +1187,13 @@ static void put_receive_buffer(
 	struct smbdirect_socket *sc = &info->socket;
 	unsigned long flags;
 
-	ib_dma_unmap_single(sc->ib.dev, response->sge.addr,
-		response->sge.length, DMA_FROM_DEVICE);
+	if (likely(response->sge.length != 0)) {
+		ib_dma_unmap_single(sc->ib.dev,
+				    response->sge.addr,
+				    response->sge.length,
+				    DMA_FROM_DEVICE);
+		response->sge.length = 0;
+	}
 
 	spin_lock_irqsave(&info->receive_queue_lock, flags);
 	list_add_tail(&response->list, &info->receive_queue);
@@ -1221,6 +1227,7 @@ static int allocate_receive_buffers(struct smbd_connection *info, int num_buf)
 			goto allocate_failed;
 
 		response->info = info;
+		response->sge.length = 0;
 		list_add_tail(&response->list, &info->receive_queue);
 		info->count_receive_queue++;
 	}
-- 
2.43.0

