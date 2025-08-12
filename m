Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054471EBFE0;
	Tue, 12 Aug 2025 18:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022987; cv=none; b=Epq0GJLq6xblhZmc62l6ZW+mI3QPFST1YvMlzUQa9ATLKyByA4viAWG2mmJfmnol3A5aG/Dp2yEpiFZXxCfGFd59TV13+8WPL9MjUQP+98ZRnMalsTy7CGCLpPmBVazSJcnjgcExAW4sNA3qDBCsLGn42DrClm3SWR7gugzi1oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022987; c=relaxed/simple;
	bh=1ZMXanmFcdJVzqUl0qbysP6TMcLSsO/W9EP9NRLLmJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HVWKyRD2Osn/vrJmEtHhG6IoZV9WbUfqY2WIHzhdodl7B4RGKBAKJnlyrvaz8dDsE7xnqYejex+8KI1wZdwnSs7OZIdeH1p8TU/9++sLW3BU9MCkOxUpUA+UxDMWFIpnoFfPNxuHMqS3M9Dw8VKNXCUufstqmW4hV0cKlNYbNKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SW0jTAl4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SW0jTAl4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E81C4CEF6;
	Tue, 12 Aug 2025 18:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022986;
	bh=1ZMXanmFcdJVzqUl0qbysP6TMcLSsO/W9EP9NRLLmJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SW0jTAl4QuCFh1ky4IOvara+HJrZlBxauKTb/nktXRC3tqZ0TPlwqK2OUV91ld7PT
	 ACitfzoFLZ+MnVaqIQg7YFfN1KPl90vni1krKNL+Z72l5FwSrPsaQKrsUUYRSeM7Tr
	 q17kURX4FFef5mCBQGHkpdGfDyLfuqI++hPYzelE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 315/369] smb: client: let send_done() cleanup before calling smbd_disconnect_rdma_connection()
Date: Tue, 12 Aug 2025 19:30:12 +0200
Message-ID: <20250812173028.572992070@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smbdirect.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 754e94a0e07f..e99e783f1b0e 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -281,18 +281,20 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 	log_rdma_send(INFO, "smbd_request 0x%p completed wc->status=%d\n",
 		request, wc->status);
 
-	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_SEND) {
-		log_rdma_send(ERR, "wc->status=%d wc->opcode=%d\n",
-			wc->status, wc->opcode);
-		smbd_disconnect_rdma_connection(request->info);
-	}
-
 	for (i = 0; i < request->num_sge; i++)
 		ib_dma_unmap_single(sc->ib.dev,
 			request->sge[i].addr,
 			request->sge[i].length,
 			DMA_TO_DEVICE);
 
+	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_SEND) {
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
2.39.5



