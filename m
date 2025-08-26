Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC951E5B88;
	Tue, 26 Aug 2025 13:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215982; cv=none; b=c3UJSMYkF4YHyLgG7W57WEI5N0lXN6DACJfilt08jfQ44oFCKIpUZbkaI4Z5ey6LUBRSFdx43y5fqlWic61/ucaCiAHDvC6FZDUj08eRxIQD6xfYH+TawEIRwvCCQDiphvXyNrEv9AIaGjbA2vi0PoLtceXDPx93ct/XFntZ8cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215982; c=relaxed/simple;
	bh=R0HaYsFGO0GaGWzoOyhI7bQbdevKaB4Yg8zHxGpKWSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXJMTM9CZ06k4IepWll3ODzwyPM3fjIoPgL6AVsLoiXroRmWZ1Q4IXiOn4Xkum6o/T3cdTcZfD8eUKFaX7PEGgInVsSHC1/pI7Gb9eMTLMH1mnUrvE6LRQ/M/gkbZxr98vYdC4pW9tO4N6a96T0rIWDRlFKDkF9k7iuixoU9qrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HrS3ebJu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HrS3ebJu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C087CC4CEF1;
	Tue, 26 Aug 2025 13:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215982;
	bh=R0HaYsFGO0GaGWzoOyhI7bQbdevKaB4Yg8zHxGpKWSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HrS3ebJuWv93DBLma1KRUISyD6j1wN8zuwz04Xom2ov6RCXPSdV7F/yXWXPDUB/7Q
	 hnduBVHiL9mUMLIg+EBT10yYhz/ORc3sagZBQErVBcjqwMYfREddpd8C2f//4f6qVz
	 qpwUQpsuEn+mOADKG/OIPPnESB38NSLpjcUnZAGU=
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
Subject: [PATCH 5.15 240/644] smb: server: make sure we call ib_dma_unmap_single() only if we called ib_dma_map_single already
Date: Tue, 26 Aug 2025 13:05:31 +0200
Message-ID: <20250826110952.349077836@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 fs/ksmbd/transport_rdma.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 2644117305c2..dd37cabe8cbc 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
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



