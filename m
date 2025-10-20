Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359261F1932
	for <linux-cifs@vger.kernel.org>; Mon, 20 Oct 2025 18:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760985397; cv=none; b=nohPjlQM2HzjPZIwZSoJhp+s7C+fn2t/Km3/TmCD4x2v176s+bLrJuJF2n1P6FpdyE/CwrnSWPbbEQtO/8yMB1O6aUrT3iYNsBdAdLF8nWyoqjMMNaHOHRdTJSu1lAMAIcJnykC2gKTOPL1BOO5lE5WDX9whDAvXW+jr4GsDKY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760985397; c=relaxed/simple;
	bh=apn3/UEwqK5r63afnV4WZvwmKt0TxNsfTNdu3DkMdo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQ7viILgt5y9VqxV1Uq9XywmFfjl9+dQp+DyKUAZmr8A7WvEuAuHJUPG5X3rYXX4v2eHjhUxHwQT5aj5L31y+EEX0L8D+xIsilTbITWaDP1Bg7fyxnUPHHwnDTFYzk/P1fVjzaXU24k05xFBYSg3QsqASDGAQ1kNh9wApS9kZTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=iFu7INZu; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="iFu7INZu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=d+jnfWr2Lel3tWjcjOhIZ+FJyHVY7JNrtQclNWKs2EQ=; b=iFu7INZuwnzH5RW3NF0URr8YFW
	jvQNKNSsPj5j/04lHYrFmA4UkUCr2Rqs5WwfWfS+p8tPk7cmUetT8xjFy904ylEESzWZzh/W1Ridm
	N3rVVKqvTgntoLphAnrD3ZMw5QG7u2ratDRihyabsddJm7kLSXAzDrjKSKygnbQ10x+2Dd9M2Xhs5
	bWb4ZHUhMXPZ7qircQaOX+XBcCobv+JdtzHgu1fhWHn5WWKnvixC4oFm8t1yYYAe/Dg7BrgVyFfz2
	fQb9E2Npc9b1lmCm/QG0Z5hXotVsFU2rxbNX3BU/i7NMq5PNMfUkMr/4AofXsROC2dM8IjrtOlMZ2
	CeAnnMULkIeVfFj6HUfJxpGgVOeWdSt0tCcVxpnPQfiF/BomufjN48I/5r6m8OjdX+GrqYWmuxZ5H
	SXkWU/6jiTdQgpvJnkR6qV0qcb4oFQReO0t3ObAi7vqeGkGD474OTH/1+DX11HhML9HMimZiOm/D9
	jEfUCvT1F7pbIY9KoGFinDOG;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vAukC-00ACOK-10;
	Mon, 20 Oct 2025 18:36:32 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 3/5] smb: server: simplify sibling_list handling in smb_direct_flush_send_list/send_done
Date: Mon, 20 Oct 2025 20:36:00 +0200
Message-ID: <4de5385dc318ff44a391528a49e4fc8710ba4693.1760984605.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1760984605.git.metze@samba.org>
References: <cover.1760984605.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We have a list handling that is much easier to understand:

1. Before smb_direct_flush_send_list() is called all
   struct smbdirect_send_io messages are part of
   send_ctx->msg_list

2. Before smb_direct_flush_send_list() calls
   smb_direct_post_send() we remove the last
   element in send_ctx->msg_list and move all
   others into last->sibling_list. As only
   last has IB_SEND_SIGNALED and gets a completion
   vis send_done().

3. send_done() has an easy way to free all others
   in sendmsg->sibling_list (if there are any).
   And use list_for_each_entry_safe() instead of
   a complex custom logic.

This will help us to share send_done() in common
code soon, as it will work fine for the client too,
where last->sibling_list is currently always an empty list.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/server/transport_rdma.c | 60 +++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 22 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index c4df1328342d..e7e2388c00c2 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -524,6 +524,12 @@ static void smb_direct_free_sendmsg(struct smbdirect_socket *sc,
 {
 	int i;
 
+	/*
+	 * The list needs to be empty!
+	 * The caller should take care of it.
+	 */
+	WARN_ON_ONCE(!list_empty(&msg->sibling_list));
+
 	if (msg->num_sge > 0) {
 		ib_dma_unmap_single(sc->ib.dev,
 				    msg->sge[0].addr, msg->sge[0].length,
@@ -909,9 +915,8 @@ static void smb_direct_post_recv_credits(struct work_struct *work)
 
 static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 {
-	struct smbdirect_send_io *sendmsg, *sibling;
+	struct smbdirect_send_io *sendmsg, *sibling, *next;
 	struct smbdirect_socket *sc;
-	struct list_head *pos, *prev, *end;
 
 	sendmsg = container_of(wc->wr_cqe, struct smbdirect_send_io, cqe);
 	sc = sendmsg->socket;
@@ -920,27 +925,26 @@ static void send_done(struct ib_cq *cq, struct ib_wc *wc)
 		    ib_wc_status_msg(wc->status), wc->status,
 		    wc->opcode);
 
+	/*
+	 * Free possible siblings and then the main send_io
+	 */
+	list_for_each_entry_safe(sibling, next, &sendmsg->sibling_list, sibling_list) {
+		list_del_init(&sibling->sibling_list);
+		smb_direct_free_sendmsg(sc, sibling);
+	}
+	/* Note this frees wc->wr_cqe, but not wc */
+	smb_direct_free_sendmsg(sc, sendmsg);
+
 	if (wc->status != IB_WC_SUCCESS || wc->opcode != IB_WC_SEND) {
 		pr_err("Send error. status='%s (%d)', opcode=%d\n",
 		       ib_wc_status_msg(wc->status), wc->status,
 		       wc->opcode);
 		smb_direct_disconnect_rdma_connection(sc);
+		return;
 	}
 
 	if (atomic_dec_and_test(&sc->send_io.pending.count))
 		wake_up(&sc->send_io.pending.zero_wait_queue);
-
-	/* iterate and free the list of messages in reverse. the list's head
-	 * is invalid.
-	 */
-	for (pos = &sendmsg->sibling_list, prev = pos->prev, end = sendmsg->sibling_list.next;
-	     prev != end; pos = prev, prev = prev->prev) {
-		sibling = container_of(pos, struct smbdirect_send_io, sibling_list);
-		smb_direct_free_sendmsg(sc, sibling);
-	}
-
-	sibling = container_of(pos, struct smbdirect_send_io, sibling_list);
-	smb_direct_free_sendmsg(sc, sibling);
 }
 
 static int manage_credits_prior_sending(struct smbdirect_socket *sc)
@@ -1030,17 +1034,29 @@ static int smb_direct_flush_send_list(struct smbdirect_socket *sc,
 	last->wr.send_flags = IB_SEND_SIGNALED;
 	last->wr.wr_cqe = &last->cqe;
 
+	/*
+	 * Remove last from send_ctx->msg_list
+	 * and splice the rest of send_ctx->msg_list
+	 * to last->sibling_list.
+	 *
+	 * send_ctx->msg_list is a valid empty list
+	 * at the end.
+	 */
+	list_del_init(&last->sibling_list);
+	list_splice_tail_init(&send_ctx->msg_list, &last->sibling_list);
+	send_ctx->wr_cnt = 0;
+
 	ret = smb_direct_post_send(sc, &first->wr);
-	if (!ret) {
-		smb_direct_send_ctx_init(send_ctx,
-					 send_ctx->need_invalidate_rkey,
-					 send_ctx->remote_key);
-	} else {
-		list_for_each_entry_safe(first, last, &send_ctx->msg_list,
-					 sibling_list) {
-			smb_direct_free_sendmsg(sc, first);
+	if (ret) {
+		struct smbdirect_send_io *sibling, *next;
+
+		list_for_each_entry_safe(sibling, next, &last->sibling_list, sibling_list) {
+			list_del_init(&sibling->sibling_list);
+			smb_direct_free_sendmsg(sc, sibling);
 		}
+		smb_direct_free_sendmsg(sc, last);
 	}
+
 	return ret;
 }
 
-- 
2.43.0

