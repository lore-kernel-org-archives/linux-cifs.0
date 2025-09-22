Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDC8318C2C;
	Mon, 22 Sep 2025 19:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570425; cv=none; b=hgxK13D539PPnxJs19noz/7mlvlRmsZa6/9/0RorYSjxOcqX4m2lslUQLZUGyw0MeI6QZS3lvsVXcLIsOohNJVgPGOKw7lFbwawcy4qY3qyXMVfZck8ZeXX7t5lNjNDbuXhcKygaNbY4BcjdcT2l2OUKx1crFU+oqUT30vV8vLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570425; c=relaxed/simple;
	bh=pITBMN7RJZ17FL5BWi6ZOodplkBIZSuUeDX6ThOHkRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fAQt2Kty+ovfhZ1A+0x1N8l9fCBYczxE9AbWhsvxZTuU8wMXsJo/75hBDNqubAYYRm5wKGEQKTQRK1QBzqxCDGAm0vZpoTSegcBodUJQ68UrJzOPnF2rlH2z6jevttjPKcv8D7VIv01U1bWuwSSnvEl77XyYj9YtAPhL+d9l6vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YjGq4Jg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YjGq4Jg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87BAAC4CEF0;
	Mon, 22 Sep 2025 19:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570424;
	bh=pITBMN7RJZ17FL5BWi6ZOodplkBIZSuUeDX6ThOHkRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YjGq4Jg1sL1Dr72S6dPyaOxRRoveighUBHRPmO71tq/Kzh0to5z8a9nbvTGLq7NhR
	 qQ38zOwRCN6EAAyXMHiFgGPuMj7j19BH1Vc/O6qpWPnYICMFCHYosVmMxz27XNF2el
	 uMCsrDo8NJAjbjcOx0dsul91sOGdNOpIAGpXbA94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 132/149] smb: client: use disable[_delayed]_work_sync in smbdirect.c
Date: Mon, 22 Sep 2025 21:30:32 +0200
Message-ID: <20250922192416.200797542@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit bac28f604c7699727b2fecf14c3a54668bbe458e ]

This makes it safer during the disconnect and avoids
requeueing.

It's ok to call disable[delayed_]work[_sync]() more than once.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Fixes: 050b8c374019 ("smbd: Make upper layer decide when to destroy the transport")
Fixes: f198186aa9bb ("CIFS: SMBD: Establish SMB Direct connection")
Fixes: c7398583340a ("CIFS: SMBD: Implement RDMA memory registration")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smbdirect.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 65175ac3d8418..8c6e766078e14 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1341,7 +1341,7 @@ void smbd_destroy(struct TCP_Server_Info *server)
 	sc->ib.qp = NULL;
 
 	log_rdma_event(INFO, "cancelling idle timer\n");
-	cancel_delayed_work_sync(&info->idle_timer_work);
+	disable_delayed_work_sync(&info->idle_timer_work);
 
 	/* It's not possible for upper layer to get to reassembly */
 	log_rdma_event(INFO, "drain the reassembly queue\n");
@@ -1713,7 +1713,7 @@ static struct smbd_connection *_smbd_get_connection(
 	return NULL;
 
 negotiation_failed:
-	cancel_delayed_work_sync(&info->idle_timer_work);
+	disable_delayed_work_sync(&info->idle_timer_work);
 	destroy_caches_and_workqueue(info);
 	sc->status = SMBDIRECT_SOCKET_NEGOTIATE_FAILED;
 	rdma_disconnect(sc->rdma.cm_id);
@@ -2072,7 +2072,7 @@ static void destroy_mr_list(struct smbd_connection *info)
 	struct smbdirect_socket *sc = &info->socket;
 	struct smbd_mr *mr, *tmp;
 
-	cancel_work_sync(&info->mr_recovery_work);
+	disable_work_sync(&info->mr_recovery_work);
 	list_for_each_entry_safe(mr, tmp, &info->mr_list, list) {
 		if (mr->state == MR_INVALIDATED)
 			ib_dma_unmap_sg(sc->ib.dev, mr->sgt.sgl,
-- 
2.51.0



