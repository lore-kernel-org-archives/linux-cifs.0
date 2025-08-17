Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD662D661E;
	Sun, 17 Aug 2025 15:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755443890; cv=none; b=CDdxVrhgRYj/EG0LNmps8RkHc/Oz1vmC77Aa4/TIv+gS6Y7lMxXXVYuTwA80fAJx/f+0WpVPWaIUc3oQe8syttL7HJBf4ByXcfjO7qGl4A1DiItQF35FMXbKaR5pZ+1iQjo62sSB/tImAC751VJd7G00DmkMhnJ5gIYbbWlBmeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755443890; c=relaxed/simple;
	bh=LyPfSJ08gXe2Mafj0QxOtH639p2yKbJSlC+RMG8P6eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVhwK+Nxct4r6fMFxUjocyRQpfEyLCaAwOKoAEcRENYjT3pV3c6MWcmNbWbKO8b4EX8v9/YasV4uMyDVd+ZstypVIKb5EUo8oDtaiFy5SMdW4D7hEM5UbJEtvkRRSpwpZ3IxFV+IVt1EOvTKRBU0GI//crAaD1DHSonMhhYUsno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LF44GdGx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LF44GdGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E5EC4CEF1;
	Sun, 17 Aug 2025 15:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755443890;
	bh=LyPfSJ08gXe2Mafj0QxOtH639p2yKbJSlC+RMG8P6eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LF44GdGx52EouSBrPYTvuovh6THAXziEiidagpgL5IH06thCiJhO0coahZ5dCkfoo
	 SQvC26dvHqY/8kGbUmwyCpL4t2aeIYgq6Z4l9rQWts5AfQLKWPd7DLbJy0u/OwZDnr
	 8pcXYWvbmWTes6lwkr45FQaCqxlMtVIsHNEaSbIxHaQKiTtIHB/I7JyHPcKmZm1Sgw
	 W8/bWenlECKBT0sZ1Mx+9E4hU9e4Q2IrNPvWL4xtxKUOJ+35SFSwBzTXErQee4tOg+
	 nzSVHn9snv2jfdZqmuvrzI7Ba0bk5n+LeCIOhDgyQ9NxAdrEGHprws6pIVzLLBsvH4
	 wBoB0ggmjX0nw==
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
Subject: [PATCH 5.4.y] smb: client: let send_done() cleanup before calling smbd_disconnect_rdma_connection()
Date: Sun, 17 Aug 2025 11:18:07 -0400
Message-ID: <20250817151807.1835667-1-sashal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <2025081755-subdivide-astound-6aef@gregkh>
References: <2025081755-subdivide-astound-6aef@gregkh>
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
index 0842a1af0b98..c8ab767ab138 100644
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
 	if (request->has_payload) {
 		if (atomic_dec_and_test(&request->info->send_payload_pending))
 			wake_up(&request->info->wait_send_payload_pending);
-- 
2.50.1

