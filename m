Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810A228ECF9;
	Sun, 17 Aug 2025 13:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755438680; cv=none; b=V0/LAbhpShyBjcsJPQuAepP0WR04y8G1V8lV8QGRXcabyA4XsPWnoUoCUGsKznVOlf4kb0OIsQQnZafGl7dapxm1qbYy3NcBNqFfAcBH0pc9k8K1NGi70xmG9rfAYrl2pYluiiPr8lHgYoMcMHnH1TzvIolq0/pTM3TZHZzNQPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755438680; c=relaxed/simple;
	bh=2iXWa7hwO2t88PD+wbv+GpbMBV06YRmCt2vdXsEX3ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+1ARm0YOFQ7RFGbFZ5FUUq8spEqlHZKBRqqe1MuxxObJvaobJTcKdVvFbWjeHwszFecE2tJqJNkn1AKdUDH+2ey8G9dGOyffA9Goa6hgLgSQ+H3UQiuNFy9dq4F4WyIN8RnZPcDfXZ0NAMbEyMEYuMnINZwa3B60iRzDMhl/sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kLrRscUG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kLrRscUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4697DC4CEEB;
	Sun, 17 Aug 2025 13:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755438680;
	bh=2iXWa7hwO2t88PD+wbv+GpbMBV06YRmCt2vdXsEX3ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kLrRscUGoscmWLHDVwGDD1ImiR8vFWNbfknhrRc5byvNqvKZsqJsrnLHWfzO56K4c
	 daFpJZLq3SWxlW/lJu5gRdNhOslan3bjG2c6OlmhKJGZb3i5lR1h2bxC50cz2zrQ2l
	 fryItI0c8wWMA0Hh+gqAYG7O+qqK9DsFP5S9+o1m1ATB/MzP8+gMtgWQH2a1luk0RA
	 5773/S9kMdqXjxi6D0VMvRfM9ItbRDM7m3Y5g65yFYvg5I+eYOv2hTQQmw2oeFyAw9
	 KXDF50ekLB/lzqJjULc7wXD/O5cC9Pnmjd8IgHns2vMQm+2893ISkfOv/XQN5TxKe5
	 ev+ZLjwq1TZ4g==
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
Subject: [PATCH 6.1.y] smb: client: let send_done() cleanup before calling smbd_disconnect_rdma_connection()
Date: Sun, 17 Aug 2025 09:51:13 -0400
Message-ID: <20250817135113.1474958-1-sashal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <2025081751-drench-clammy-f8dd@gregkh>
References: <2025081751-drench-clammy-f8dd@gregkh>
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
[ Replaced `info` with `request->info` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smbdirect.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index d47eae133a20..f50cddd256bb 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -273,18 +273,21 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 	log_rdma_send(INFO, "smbd_request 0x%p completed wc->status=%d\n",
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

