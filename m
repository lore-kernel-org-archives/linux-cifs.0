Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465522F4A02;
	Sun, 17 Aug 2025 14:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755441523; cv=none; b=j72D0fQbUFiwzqDmw/7UsEbQDWuzBCYUIhmc/ggrk8qoadw/fnFLcLmgqO0DJta/tO7x74+OeCc5zhAMOKAWbO9zucHIlLlaYsWqpSLcugVDXCBEL+29GlgfRaUoCjpMDwOJe2Uvj8J/oXF56M+X8ZG5CBgaHD2jPVYr/k5H6Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755441523; c=relaxed/simple;
	bh=KLqM2uYRx2dyK5qVTy+mTpACKI6KUJgQpAVtmTc6YPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cek3a9/OIdrtGW6CrgAguRefdYUm4WZgtxp+dbUOfDpbl9IjEo5EuqU8uZ3cXztBqnbcHnYienMBN37y8hOnaUeO5+QbspptaSYUBo7hOFEKMySF2O3Fedzujayx6R+VB/wsEtq3FVFDUl0VikU4KJV8jdq3paWpRbZUF39I5Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f9fPxEl+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f9fPxEl+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2F7C4CEF1;
	Sun, 17 Aug 2025 14:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755441523;
	bh=KLqM2uYRx2dyK5qVTy+mTpACKI6KUJgQpAVtmTc6YPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f9fPxEl+Gbq5vdOpz9gYm1tai/2EkZ1hCTcYH/ioN0+ckyrFILo6jFMyRTFA/Eo0k
	 JhWDojgSERSzNnYzCGtTOapQpK6LB44rdBkK/Xfu++SrbhSBcJIgbU6z864sF1ZkqO
	 qG2VcaExIIpfVknUcAOCUhly6uq2Lkqxm10kPeKwI6S4w2FRZIR8wlvUxkFP7PDwGA
	 uCYrcZSsd5Y7y5ugcppN1sKrcHO7/nqRaEarjjSU6L/Fza157qT9MriQuSxZLPK0WQ
	 VGiIhSt40ZaauMZRL0VVYPgeApf/7F+eNYwZLa18ZDI/mrOhe9+YF81Pf5vsXEd5KO
	 qniRkvXVIJaOQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Stefan Metzmacher <metze@samba.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10.y] smb: client: let send_done() cleanup before calling smbd_disconnect_rdma_connection()
Date: Sun, 17 Aug 2025 10:38:39 -0400
Message-ID: <20250817143839.1546235-1-sashal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <2025081757-moonwalk-backpedal-fe00@gregkh>
References: <2025081757-moonwalk-backpedal-fe00@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit 5349ae5e05fa37409fd48a1eb483b199c32c889b ]

We should call ib_dma_unmap_single() and mempool_free() before calling
smbd_disconnect_rdma_connection().

And smbd_disconnect_rdma_connection() needs to be the last function to
call as all other state might already be gone after it returns.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Fixes: f198186aa9bb ("CIFS: SMBD: Establish SMB Direct connection")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
[ Use `request->info` instead of `info` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smbdirect.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 7d18b9268817..61aaed0d8746 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -272,18 +272,21 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 	log_rdma_send(INFO, "smbd_request %p completed wc->status=%d\n",
 		request, wc->status);
 
-	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_SEND) {
-		log_rdma_send(ERR, "wc->status=%d wc->opcode=%d\n",
-			wc->status, wc->opcode);
-		smbd_disconnect_rdma_connection(request->info);
-	}
-
 	for (i = 0; i < request->num_sge; i++)
 		ib_dma_unmap_single(request->info->id->device,
 			request->sge[i].addr,
 			request->sge[i].length,
 			DMA_TO_DEVICE);
 
+	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_SEND) {
+		struct smbd_connection *info = request->info;
+		log_rdma_send(ERR, "wc->status=%d wc->opcode=%d\n",
+			wc->status, wc->opcode);
+		mempool_free(request, info->request_mempool);
+		smbd_disconnect_rdma_connection(info);
+		return;
+	}
+
 	if (atomic_dec_and_test(&request->info->send_pending))
 		wake_up(&request->info->wait_send_pending);
 
-- 
2.50.1

