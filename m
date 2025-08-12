Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106D42F6573;
	Tue, 12 Aug 2025 18:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025200; cv=none; b=VQ8Z0jsPaVpWBMzibkX5pQty2kXhtHaUsCcy2Aa4eG+6URuS58yDJI7yw3M04dWDhzJ/1e+53Que/Mwp3d+w9aUAbQMcYmSm+SZO0umZJR8iVx6Rtg1xmVslY9i6EV5jyrZihu/z2qh0E9x78BhwAPhrdxoe8pYHDN/BBQ1ZhVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025200; c=relaxed/simple;
	bh=15rJ+WGdrOPt/LoRRruCTn5PRPHYhBnbByyknBPTJQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3YbouC21AMkqtsnJ+Tr8WcpMz9ubpJOuUkAr0d2oHHrO1PEHt58UCYeKdNVPGhc9a66zh0a1uvm4yI412ot7K0KzeyhMLA1wD1WDJS6nqWwMd2kWWpecgMuh2VdL9oZnzz6ZXwbSqkLTBQplV+def+pVX75Ho+KwkrSqMGPIPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xWgYcWit; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xWgYcWit"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C81C4CEF0;
	Tue, 12 Aug 2025 18:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025199;
	bh=15rJ+WGdrOPt/LoRRruCTn5PRPHYhBnbByyknBPTJQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xWgYcWituB6Fx6Ix4dnORMg6DXJriUAQca4NDnamk9SV3ikRwEf/TeF3W8X9LZKRf
	 KCmFeoefPRAj7cBfBZbjFrt9c015WktFp0iXiZdfPQZe0iptILE2cjW0d+DE+RTlko
	 CrlD6yjZDumVLNvbrK2VIRXBe5Y9iaX/WnQqp7So=
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
Subject: [PATCH 6.16 565/627] smb: client: make sure we call ib_dma_unmap_single() only if we called ib_dma_map_single already
Date: Tue, 12 Aug 2025 19:34:20 +0200
Message-ID: <20250812173453.380523675@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

[ Upstream commit 047682c370b6f18fec818b57b0ed8b501bdb79f8 ]

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
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smbdirect.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 0ab490c0a9b0..5690e8b3d101 100644
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
2.39.5



