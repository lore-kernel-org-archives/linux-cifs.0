Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1403261FFE;
	Tue, 12 Aug 2025 18:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022973; cv=none; b=qDHu1OsXnG1K3Ep4E43LT7pcBDtDM0uBAAyW7ue9JMAeS1MqozS2GRrI8JXhqn9KonE8bgpHNYcjjkMNewpAwedFjELIwANBtjMEBlReC3DdkIfYMvzdYT59A3tyMtD1lyLeOlMNZM7gtRdkXAqhj2iatB9ItcnzNgXn+5AUikw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022973; c=relaxed/simple;
	bh=PDRxAaY3FSBp63BwcT1Kxldiiou9b4OY7xok2khKTdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IAMMr+TcV8RfouB1RxYtvpCmXKAbf5ZdEUe3QGW3R/mZSSK4/K8A+7am4IHJPFVpHtrBD4QwEHOqO7tlRVvE07Cia41xY5kacC3zImXhpHfWwcR5xYQnnPMIGSgTguCiQooZ3E/rABXfbx5cDwbHmVEo4VF2iosGCzWdSK1/dw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YC3fm/HR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YC3fm/HR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DB4C4CEF6;
	Tue, 12 Aug 2025 18:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022972;
	bh=PDRxAaY3FSBp63BwcT1Kxldiiou9b4OY7xok2khKTdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YC3fm/HRQf3tXT0ELM7Me/eljR/uocIdrhPgxcy/WRNE1k6ffL/DjSQ/4QRma+1Wo
	 TWJmZ8daRtqGyb341F4vo3fyE0bdJn8SLIXqUEwk2iqolnyyg9MFsh6Rq/yNAKldHg
	 6i9TzpqYHXUDfn5wkX5cbWX8Y85XOYh8u9qzAbuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 311/369] smb: server: remove separate empty_recvmsg_queue
Date: Tue, 12 Aug 2025 19:30:08 +0200
Message-ID: <20250812173028.426238895@linuxfoundation.org>
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

[ Upstream commit 01027a62b508c48c762096f347de925eedcbd008 ]

There's no need to maintain two lists, we can just
have a single list of receive buffers, which are free to use.

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
 fs/smb/server/transport_rdma.c | 60 +++++-----------------------------
 1 file changed, 8 insertions(+), 52 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 3ab8c04f72e4..fd78d24e96f4 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -128,9 +128,6 @@ struct smb_direct_transport {
 	spinlock_t		recvmsg_queue_lock;
 	struct list_head	recvmsg_queue;
 
-	spinlock_t		empty_recvmsg_queue_lock;
-	struct list_head	empty_recvmsg_queue;
-
 	int			send_credit_target;
 	atomic_t		send_credits;
 	spinlock_t		lock_new_recv_credits;
@@ -275,32 +272,6 @@ static void put_recvmsg(struct smb_direct_transport *t,
 	spin_unlock(&t->recvmsg_queue_lock);
 }
 
-static struct
-smb_direct_recvmsg *get_empty_recvmsg(struct smb_direct_transport *t)
-{
-	struct smb_direct_recvmsg *recvmsg = NULL;
-
-	spin_lock(&t->empty_recvmsg_queue_lock);
-	if (!list_empty(&t->empty_recvmsg_queue)) {
-		recvmsg = list_first_entry(&t->empty_recvmsg_queue,
-					   struct smb_direct_recvmsg, list);
-		list_del(&recvmsg->list);
-	}
-	spin_unlock(&t->empty_recvmsg_queue_lock);
-	return recvmsg;
-}
-
-static void put_empty_recvmsg(struct smb_direct_transport *t,
-			      struct smb_direct_recvmsg *recvmsg)
-{
-	ib_dma_unmap_single(t->cm_id->device, recvmsg->sge.addr,
-			    recvmsg->sge.length, DMA_FROM_DEVICE);
-
-	spin_lock(&t->empty_recvmsg_queue_lock);
-	list_add_tail(&recvmsg->list, &t->empty_recvmsg_queue);
-	spin_unlock(&t->empty_recvmsg_queue_lock);
-}
-
 static void enqueue_reassembly(struct smb_direct_transport *t,
 			       struct smb_direct_recvmsg *recvmsg,
 			       int data_length)
@@ -385,9 +356,6 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 	spin_lock_init(&t->recvmsg_queue_lock);
 	INIT_LIST_HEAD(&t->recvmsg_queue);
 
-	spin_lock_init(&t->empty_recvmsg_queue_lock);
-	INIT_LIST_HEAD(&t->empty_recvmsg_queue);
-
 	init_waitqueue_head(&t->wait_send_pending);
 	atomic_set(&t->send_pending, 0);
 
@@ -553,7 +521,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			       wc->opcode);
 			smb_direct_disconnect_rdma_connection(t);
 		}
-		put_empty_recvmsg(t, recvmsg);
+		put_recvmsg(t, recvmsg);
 		return;
 	}
 
@@ -567,7 +535,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	switch (recvmsg->type) {
 	case SMB_DIRECT_MSG_NEGOTIATE_REQ:
 		if (wc->byte_len < sizeof(struct smb_direct_negotiate_req)) {
-			put_empty_recvmsg(t, recvmsg);
+			put_recvmsg(t, recvmsg);
 			return;
 		}
 		t->negotiation_requested = true;
@@ -584,7 +552,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 
 		if (wc->byte_len <
 		    offsetof(struct smb_direct_data_transfer, padding)) {
-			put_empty_recvmsg(t, recvmsg);
+			put_recvmsg(t, recvmsg);
 			return;
 		}
 
@@ -592,7 +560,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		if (data_length) {
 			if (wc->byte_len < sizeof(struct smb_direct_data_transfer) +
 			    (u64)data_length) {
-				put_empty_recvmsg(t, recvmsg);
+				put_recvmsg(t, recvmsg);
 				return;
 			}
 
@@ -612,7 +580,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			avail_recvmsg_count = t->count_avail_recvmsg;
 			spin_unlock(&t->receive_credit_lock);
 		} else {
-			put_empty_recvmsg(t, recvmsg);
+			put_recvmsg(t, recvmsg);
 
 			spin_lock(&t->receive_credit_lock);
 			receive_credits = --(t->recv_credits);
@@ -810,7 +778,6 @@ static void smb_direct_post_recv_credits(struct work_struct *work)
 	struct smb_direct_recvmsg *recvmsg;
 	int receive_credits, credits = 0;
 	int ret;
-	int use_free = 1;
 
 	spin_lock(&t->receive_credit_lock);
 	receive_credits = t->recv_credits;
@@ -818,18 +785,9 @@ static void smb_direct_post_recv_credits(struct work_struct *work)
 
 	if (receive_credits < t->recv_credit_target) {
 		while (true) {
-			if (use_free)
-				recvmsg = get_free_recvmsg(t);
-			else
-				recvmsg = get_empty_recvmsg(t);
-			if (!recvmsg) {
-				if (use_free) {
-					use_free = 0;
-					continue;
-				} else {
-					break;
-				}
-			}
+			recvmsg = get_free_recvmsg(t);
+			if (!recvmsg)
+				break;
 
 			recvmsg->type = SMB_DIRECT_MSG_DATA_TRANSFER;
 			recvmsg->first_segment = false;
@@ -1805,8 +1763,6 @@ static void smb_direct_destroy_pools(struct smb_direct_transport *t)
 
 	while ((recvmsg = get_free_recvmsg(t)))
 		mempool_free(recvmsg, t->recvmsg_mempool);
-	while ((recvmsg = get_empty_recvmsg(t)))
-		mempool_free(recvmsg, t->recvmsg_mempool);
 
 	mempool_destroy(t->recvmsg_mempool);
 	t->recvmsg_mempool = NULL;
-- 
2.39.5



