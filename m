Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FBA253F12
	for <linux-cifs@vger.kernel.org>; Mon,  4 Aug 2025 12:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754309787; cv=none; b=GqeH2C8+0gie7zLXUeKwECyl8gICD20uD09r1ZeqZidZ5chwUzwfmQ42pGgZaJEqLCjGfRKV8q9k/Jtl+IrLyeD3yHj9QyqiFOU0SABtiOSiqTySaZMBfpu/OzP0cvFHCwZICEuBHUL7tstKMGs9DdMQ1Kofc/Ee4in5b2guxoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754309787; c=relaxed/simple;
	bh=4FH0+cnLs1mBYOlcKL9FR1yjkZdmhUsC3BIcryFYz20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O95CE7swkfHiVY+QaKhGjuXGagwQQrbimwODtfuFN/fNk5OdKF6LsFZkusZDsUDGv2AJeuB0/Uxh81FvHSxGJO+ef3cKVwdQPZZt2M2l5G/0OomV+T/GZ+udA6jJ4BlJpqV8/okOedQn5E50AtcdzyPwt3SnthR+kTNTc6vdVp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ae8clO1O; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ae8clO1O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=FX5K3y/DzC8nTP2YsNI9Z2gYNSevLwX+uD+uP72KP/k=; b=ae8clO1Oh8F0iuEzORkblCeRkP
	mA9885SHq61GJqcF5gpKWNLsV4ntFXd9vTns+sZwU7j8yM0ieT8goFJAYBNR+vpO2DTNxS5vE3GlY
	7Lg5DeariKAa75K1shi7fykEYeZJhR3Vfr7g8vJY6wP+fAYb+G9wJfw+/XDP3UkupoEbRugNvKmta
	7CwMk99WzqQD0zwXUoAdkTRiUO3TtZJtnS2r/joXGmZkI3zlmbc+QoZTB7OpsRyFMyG0LKPuh2Xai
	hclsZt1eenBVQxfZVS+hznKhmkpIXmDOWfAcH1+jopvAfenWsHxPSTny5+/2JfPDHJLnY53132/At
	7fTsOmkzcjN0SaCGX+RDGFRXp16wcDbcALHiRFhPYRTtUNSoXQnIiZ2D2iAbs0+vourduRY6Yue1y
	UiBh5HbFLu+COC/MwE/lrDQxJb1nkk66pGeLdcV3Dc4tSlmKd01PvLsbO9WEiLdveoa0DM2CfmT/C
	fdbiopw7bLPREUXQKV/LCPGO;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uiu75-000wCh-1S;
	Mon, 04 Aug 2025 12:16:23 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH 1/4] smb: server: remove separate empty_recvmsg_queue
Date: Mon,  4 Aug 2025 14:15:50 +0200
Message-ID: <897ac978c2b3fe62d9b3891208342963cdd3f5cc.1754309565.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754309565.git.metze@samba.org>
References: <cover.1754309565.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There's no need to maintain two lists, we can just
have a single list of receive buffers, which are free to use.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Fixes: 0626e6641f6b ("cifsd: add server handler for central processing and tranport layers")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 60 +++++-----------------------------
 1 file changed, 8 insertions(+), 52 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index c6cbe0d56e32..393254109fc4 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -129,9 +129,6 @@ struct smb_direct_transport {
 	spinlock_t		recvmsg_queue_lock;
 	struct list_head	recvmsg_queue;
 
-	spinlock_t		empty_recvmsg_queue_lock;
-	struct list_head	empty_recvmsg_queue;
-
 	int			send_credit_target;
 	atomic_t		send_credits;
 	spinlock_t		lock_new_recv_credits;
@@ -276,32 +273,6 @@ static void put_recvmsg(struct smb_direct_transport *t,
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
@@ -386,9 +357,6 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 	spin_lock_init(&t->recvmsg_queue_lock);
 	INIT_LIST_HEAD(&t->recvmsg_queue);
 
-	spin_lock_init(&t->empty_recvmsg_queue_lock);
-	INIT_LIST_HEAD(&t->empty_recvmsg_queue);
-
 	init_waitqueue_head(&t->wait_send_pending);
 	atomic_set(&t->send_pending, 0);
 
@@ -554,7 +522,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			       wc->opcode);
 			smb_direct_disconnect_rdma_connection(t);
 		}
-		put_empty_recvmsg(t, recvmsg);
+		put_recvmsg(t, recvmsg);
 		return;
 	}
 
@@ -568,7 +536,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 	switch (recvmsg->type) {
 	case SMB_DIRECT_MSG_NEGOTIATE_REQ:
 		if (wc->byte_len < sizeof(struct smb_direct_negotiate_req)) {
-			put_empty_recvmsg(t, recvmsg);
+			put_recvmsg(t, recvmsg);
 			return;
 		}
 		t->negotiation_requested = true;
@@ -585,7 +553,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 
 		if (wc->byte_len <
 		    offsetof(struct smb_direct_data_transfer, padding)) {
-			put_empty_recvmsg(t, recvmsg);
+			put_recvmsg(t, recvmsg);
 			return;
 		}
 
@@ -593,7 +561,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		if (data_length) {
 			if (wc->byte_len < sizeof(struct smb_direct_data_transfer) +
 			    (u64)data_length) {
-				put_empty_recvmsg(t, recvmsg);
+				put_recvmsg(t, recvmsg);
 				return;
 			}
 
@@ -613,7 +581,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			avail_recvmsg_count = t->count_avail_recvmsg;
 			spin_unlock(&t->receive_credit_lock);
 		} else {
-			put_empty_recvmsg(t, recvmsg);
+			put_recvmsg(t, recvmsg);
 
 			spin_lock(&t->receive_credit_lock);
 			receive_credits = --(t->recv_credits);
@@ -811,7 +779,6 @@ static void smb_direct_post_recv_credits(struct work_struct *work)
 	struct smb_direct_recvmsg *recvmsg;
 	int receive_credits, credits = 0;
 	int ret;
-	int use_free = 1;
 
 	spin_lock(&t->receive_credit_lock);
 	receive_credits = t->recv_credits;
@@ -819,18 +786,9 @@ static void smb_direct_post_recv_credits(struct work_struct *work)
 
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
@@ -1806,8 +1764,6 @@ static void smb_direct_destroy_pools(struct smb_direct_transport *t)
 
 	while ((recvmsg = get_free_recvmsg(t)))
 		mempool_free(recvmsg, t->recvmsg_mempool);
-	while ((recvmsg = get_empty_recvmsg(t)))
-		mempool_free(recvmsg, t->recvmsg_mempool);
 
 	mempool_destroy(t->recvmsg_mempool);
 	t->recvmsg_mempool = NULL;
-- 
2.43.0

