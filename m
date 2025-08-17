Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F7A20ADEE;
	Sun, 17 Aug 2025 14:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755440937; cv=none; b=R+C1PwNRRZsVaZbkys2Q65jmhlMnN1ziyEwLMZZpPY1v+eBHMau7fy0SZGdHEMa7kLCQd4HLzSMvzu4lRUnp9vw9ZXSUIsAUnNmo1tIYhm2OXhlW9YyEXQzQe9OCYY66CDl2zNDmM8zeuqwSKClPcwvr7wbBghf/Gfcso62CRG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755440937; c=relaxed/simple;
	bh=b+ELeGOz6T/licyByWHv1vGQsVxj2cVvYRJZn4r01q0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P36G53qgWEnqi6YosgcNPrJMtCR3JKR4vxlHJ1mihHC326R1zMD8NePZFDsHbEEPheKOEPwJg7qc8jTdnLuybjWX6Wdg6JDFvPk0X5+AhSKk/BLrVLzu75XfIjRVZb+WjNwhwNPKLMVxxAEDSjT5/nXamDoR+tDa7l8t+rfduXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=omFQUKIj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="omFQUKIj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BE9C4CEEB;
	Sun, 17 Aug 2025 14:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755440937;
	bh=b+ELeGOz6T/licyByWHv1vGQsVxj2cVvYRJZn4r01q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=omFQUKIjqnYA/bLi3YIS+Qh+njhrI20F4jKYoNeJi0fSU0C0qh3gU5R3XlsqmmIpN
	 1Obb978mM6AhqEjeOzgm+lz3eQMDjRJjuUSX+oGh1JUpOMSrhopo+NNKXU+FIOEMSR
	 NdtLciYoSP3IMWmrEiCKnQEI0TYs7MORYIezZTHSc3e1KMu+1cFg7TbT/SId7eECNe
	 5CkTNEbV87KQu7H/PNLIuYG+WFZrwIuTiqcCYrMM6m1J9Vuh3CgOsdS+f4kceIBl3U
	 grpMk6iQ3MYkz/hrjuk1VvmEEZUaQVJ3jTQVckFmfND/uf9DbKIhBTrFJs0D9tP6uD
	 LdjghMQfC4sBA==
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
Subject: [PATCH 5.15.y] smb: client: let send_done() cleanup before calling smbd_disconnect_rdma_connection()
Date: Sun, 17 Aug 2025 10:28:54 -0400
Message-ID: <20250817142854.1544197-1-sashal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <2025081753-revolver-radiated-4b75@gregkh>
References: <2025081753-revolver-radiated-4b75@gregkh>
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
index a9a5d27b8d38..c45914cba3ed 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -273,18 +273,21 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
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

