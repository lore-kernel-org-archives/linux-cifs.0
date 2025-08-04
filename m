Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9ED217332C
	for <linux-cifs@vger.kernel.org>; Mon,  4 Aug 2025 12:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754309795; cv=none; b=HTocADn7MoSHbFr4EEb2V+FBQ5zPyGDxo8bOZicWNqkpcjHCKok6EpELtcJ4xql/+uHK1lMvggK6uPrU0ln04+T2SA1s918NAFhWc6I1cYoHQvakmRscXB9yfeQKNuO95HW+vbGwEBAkkWMqMUNa6iMJ5InAPyuv1I8DtEyLxUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754309795; c=relaxed/simple;
	bh=WoSD2xuleOxVGDJcPGA0rPw1s+1zs+dsUM+qMLmSYgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOokWLLI/RqYlaiL737FXimxNtGgyD2hbClpp+YK9p7TRZ0EzvMUxsFTUyTkGuh17Nh4IDYZzRikrBsmEQh1SpVzeQuZTEqdsSz01Vg9jabN3nPfat64hnwllwg07UgYWYcpt9jtdJS8x+g5m3NrcWlU+V5V3h7+mQLE6xvJC80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=RnqPU51P; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="RnqPU51P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=pQpTV+DYgQ7E7wDXixzm7t+Czo/aPc6CDk/yw94DBE4=; b=RnqPU51PHySIyTUF/cSbYEIBOa
	Y4o/y+sUTUcMGxHL9hKJp0smdoWEhL/k3tNRdnQt0/JF5wNTJUcJadTQ1cW0BTmuljH8Zba5hQA8I
	D9nnAogSyGjW7ljyMgW44brjnzD8D8WV5LDvI5ccTb3tvcda2L3YyQXz4Bb06KsklMYjLDwAIixme
	M4SudGLccHnKXTSnYJkKuvLQdkpkQ2pGK0xDwLSJA3TRySX584uZwaLXTbTlqk64D3eYECModquxD
	yWwMuoVambsKurdfD/vgzkheFyohhHOpEaQubdlynqeyzWoEgKXsCr6+M67D3x0iDU3LOUjMnKcFZ
	C0TYxHWyPP6/NFYbYJQ/A/i5IR/sMijOuUAChVeXy6z3Lz7PfPMaozvh3lZHZrk1XfPh/AOkMxwUA
	BeMg4c29SZBEfSlVcmMoqmZrJ6baTqglJLfyD5eE14ne8VCHZJwUZ/Yy3T7MuZbz7wia1P8EAmEyf
	4ZrWrY8ywJicwjQS88kuideG;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uiu7D-000wEQ-0D;
	Mon, 04 Aug 2025 12:16:31 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH 2/4] smb: server: make sure we call ib_dma_unmap_single() only if we called ib_dma_map_single already
Date: Mon,  4 Aug 2025 14:15:51 +0200
Message-ID: <887cc1b3931b16c2c11062fecb51e9899498fa15.1754309565.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754309565.git.metze@samba.org>
References: <cover.1754309565.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In case of failures either ib_dma_map_single() might not be called yet
or ib_dma_unmap_single() was already called.

We should make sure put_recvmsg() only calls ib_dma_unmap_single() if needed.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 393254109fc4..fac82e60ff80 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -265,8 +265,13 @@ smb_direct_recvmsg *get_free_recvmsg(struct smb_direct_transport *t)
 static void put_recvmsg(struct smb_direct_transport *t,
 			struct smb_direct_recvmsg *recvmsg)
 {
-	ib_dma_unmap_single(t->cm_id->device, recvmsg->sge.addr,
-			    recvmsg->sge.length, DMA_FROM_DEVICE);
+	if (likely(recvmsg->sge.length != 0)) {
+		ib_dma_unmap_single(t->cm_id->device,
+				    recvmsg->sge.addr,
+				    recvmsg->sge.length,
+				    DMA_FROM_DEVICE);
+		recvmsg->sge.length = 0;
+	}
 
 	spin_lock(&t->recvmsg_queue_lock);
 	list_add(&recvmsg->list, &t->recvmsg_queue);
@@ -638,6 +643,7 @@ static int smb_direct_post_recv(struct smb_direct_transport *t,
 		ib_dma_unmap_single(t->cm_id->device,
 				    recvmsg->sge.addr, recvmsg->sge.length,
 				    DMA_FROM_DEVICE);
+		recvmsg->sge.length = 0;
 		smb_direct_disconnect_rdma_connection(t);
 		return ret;
 	}
@@ -1819,6 +1825,7 @@ static int smb_direct_create_pools(struct smb_direct_transport *t)
 		if (!recvmsg)
 			goto err;
 		recvmsg->transport = t;
+		recvmsg->sge.length = 0;
 		list_add(&recvmsg->list, &t->recvmsg_queue);
 	}
 	t->count_avail_recvmsg = t->recv_credit_max;
-- 
2.43.0

