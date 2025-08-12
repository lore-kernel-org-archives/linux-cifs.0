Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513C7221FAC;
	Tue, 12 Aug 2025 17:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021196; cv=none; b=E/YiyYqQXBcVw0QhkEqMI/iiX4k9P8vGbnkcNWUedySBuy7vqSDYp/vv2eFCvDj2avts9t1pbg3VikcHSkGdX7Ny0oQ+Xv9BFc0zCvXEjz5bds5EneR9sm6Pmh2UI3VDQBSrGBVrIB4FrO5YL2C51Z1dRaEturCHepKLxd3EHs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021196; c=relaxed/simple;
	bh=oEalpkgdU01IY9RnN19YES9qLUwU5jQ+JbKZGwgZffU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKIM76ggPqNGmEntUa9Xoc0nH1AwL7RHNGR4UL8K46VySHEoDSYD4++SggpWySwhdknKVt/f6NduW7N3kIRi+lYVjeNuHrkjNKA/vMgC9cacjAqnMKX9tUW0taMF71+kx66gRGwWJQDP7B7I0Po6QbgnJSVB/Ecsp1ZFw2ftw/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hoT4JXlY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hoT4JXlY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B161BC4CEF0;
	Tue, 12 Aug 2025 17:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021196;
	bh=oEalpkgdU01IY9RnN19YES9qLUwU5jQ+JbKZGwgZffU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hoT4JXlYZyXTE0dEy8jbaxYbkFLuPlHRAJlLD9LidCoQsli+zVS2W2YSLKsJoiwnK
	 nXPYmJeY9kSs3BqZo+/Y8oYGxv++3p9j3IiBE/W2trZoM/zK9bHrk3zJcKJBsPNGPo
	 HDReHIl1Yzb/i6otkY0oGb1044mDrQcdVCTdR4ts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 228/253] smb: server: make sure we call ib_dma_unmap_single() only if we called ib_dma_map_single already
Date: Tue, 12 Aug 2025 19:30:16 +0200
Message-ID: <20250812172958.530525350@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit afb4108c92898350e66b9a009692230bcdd2ac73 ]

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
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/transport_rdma.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 0a6fedac59f0..71a12953089c 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -263,8 +263,13 @@ smb_direct_recvmsg *get_free_recvmsg(struct smb_direct_transport *t)
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
@@ -632,6 +637,7 @@ static int smb_direct_post_recv(struct smb_direct_transport *t,
 		ib_dma_unmap_single(t->cm_id->device,
 				    recvmsg->sge.addr, recvmsg->sge.length,
 				    DMA_FROM_DEVICE);
+		recvmsg->sge.length = 0;
 		smb_direct_disconnect_rdma_connection(t);
 		return ret;
 	}
@@ -1813,6 +1819,7 @@ static int smb_direct_create_pools(struct smb_direct_transport *t)
 		if (!recvmsg)
 			goto err;
 		recvmsg->transport = t;
+		recvmsg->sge.length = 0;
 		list_add(&recvmsg->list, &t->recvmsg_queue);
 	}
 	t->count_avail_recvmsg = t->recv_credit_max;
-- 
2.39.5



