Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64547393DE3
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155405; cv=none; b=Tadilr74wNQ+6oDSREitEy1lKyEkG/rnhZBDaN9mQBl/PJRK22p4oX1Yo42y9Ga+kaD6BgrGimuSpxBQ7t8WAwpfKThXQw4sdj7ux6glan62pO5PI18OstvPQj/dVbabcYDFGlOlSObV6iB+Q9xXntHJ+tq04OXV+t+GYv130Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155405; c=relaxed/simple;
	bh=Ki/z02I/6ctbPrXkY3kPLkZ7SXQ05XvJxLL3TxvvOHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHjQgmPr+F40MOrIFI/YoVS2K5tBQgZPHvCyD7HY3e4oR8RgJpMuMMEv8GP7tUnVeY0x/Bt50Hy6JMSFmj1gdVlC2rz9vcnL6rpGAFv2CudkFeX8DviYktvrRp8eR6bWwgldDB5+dmOAbOGf8k3lMZhPmec34OSAweolyqfCTtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ymhI99WY; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ymhI99WY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=A4ULFBRLD9davKya2gTn7SSKhqEMJROGRGOjwwKIHC4=; b=ymhI99WYeCEiScAaTMhp/miyRn
	Nm86dtlCA30mDHw6FMK1nG1vEJ9YSboKf2hZNWcbkzdXMNiFzkqeWstSmeefXi8vwdLH/pi5+2/tL
	5QGnfldsbRCY5t46heyqzcD2O2YaiJpgDXveqdW8xWJXCdqP713slpIv2eDaCfCvNc7XKGtcjUPMI
	NPahi0ibbRlhqIpj/wlITxGALSNE3DcK5/25kk8H93di531orMUS0E/694rhaXJyI8kBlTIqe7I0Y
	oAb3l1pwJLOysdSV1ah6fONB15610a7y9gno82GVwC2VbI14bCwD1Y39Z7vmrmna2pW/mwcY7PJTH
	5ssfjM1sZF4YnHtXGsbc4mneZut/wrAUQLdYt9NDAp+V22eVA1b3whv5KT4tno5PWPzKvGxQyMMuo
	LI2/YVZY23412Y7m09L7cH9Uld1YkW8sDJ6EhUsHBZAanPiLuysY7D0qOtTSzM5W13tU5VMf+acIL
	PnT9ihot1ydcyteCIaJjrcYV;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeF6-000mC6-30;
	Mon, 25 Aug 2025 20:56:41 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 089/142] smb: server: don't use delayed_work for post_recv_credits_work
Date: Mon, 25 Aug 2025 22:40:50 +0200
Message-ID: <74b9647b882ec7749f5a8ea65ab1a61d51d90c72.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If we are using a hardcoded delay of 0 there's no point in
using delayed_work it only adds confusion.

The client also uses a normal work_struct and now
it is easier to move it to the common smbdirect_socket.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 5e773da90316..85e0d2ea37ec 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -112,7 +112,7 @@ struct smb_direct_transport {
 	wait_queue_head_t	wait_send_pending;
 	atomic_t		send_pending;
 
-	struct delayed_work	post_recv_credits_work;
+	struct work_struct	post_recv_credits_work;
 	struct work_struct	send_immediate_work;
 	struct work_struct	disconnect_work;
 
@@ -330,8 +330,8 @@ static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
 
 	spin_lock_init(&t->lock_new_recv_credits);
 
-	INIT_DELAYED_WORK(&t->post_recv_credits_work,
-			  smb_direct_post_recv_credits);
+	INIT_WORK(&t->post_recv_credits_work,
+		  smb_direct_post_recv_credits);
 	INIT_WORK(&t->send_immediate_work, smb_direct_send_immediate_work);
 	INIT_WORK(&t->disconnect_work, smb_direct_disconnect_rdma_work);
 
@@ -364,7 +364,7 @@ static void free_transport(struct smb_direct_transport *t)
 		   atomic_read(&t->send_pending) == 0);
 
 	cancel_work_sync(&t->disconnect_work);
-	cancel_delayed_work_sync(&t->post_recv_credits_work);
+	cancel_work_sync(&t->post_recv_credits_work);
 	cancel_work_sync(&t->send_immediate_work);
 
 	if (sc->ib.qp) {
@@ -578,8 +578,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 			wake_up(&t->wait_send_credits);
 
 		if (is_receive_credit_post_required(receive_credits, avail_recvmsg_count))
-			mod_delayed_work(smb_direct_wq,
-					 &t->post_recv_credits_work, 0);
+			queue_work(smb_direct_wq, &t->post_recv_credits_work);
 
 		if (data_length) {
 			enqueue_reassembly(t, recvmsg, (int)data_length);
@@ -743,8 +742,7 @@ static int smb_direct_read(struct ksmbd_transport *t, char *buf,
 		st->count_avail_recvmsg += queue_removed;
 		if (is_receive_credit_post_required(st->recv_credits, st->count_avail_recvmsg)) {
 			spin_unlock(&st->receive_credit_lock);
-			mod_delayed_work(smb_direct_wq,
-					 &st->post_recv_credits_work, 0);
+			queue_work(smb_direct_wq, &st->post_recv_credits_work);
 		} else {
 			spin_unlock(&st->receive_credit_lock);
 		}
@@ -771,7 +769,7 @@ static int smb_direct_read(struct ksmbd_transport *t, char *buf,
 static void smb_direct_post_recv_credits(struct work_struct *work)
 {
 	struct smb_direct_transport *t = container_of(work,
-		struct smb_direct_transport, post_recv_credits_work.work);
+		struct smb_direct_transport, post_recv_credits_work);
 	struct smbdirect_recv_io *recvmsg;
 	int receive_credits, credits = 0;
 	int ret;
@@ -1676,7 +1674,7 @@ static int smb_direct_prepare_negotiation(struct smb_direct_transport *t)
 		goto out_err;
 	}
 
-	smb_direct_post_recv_credits(&t->post_recv_credits_work.work);
+	smb_direct_post_recv_credits(&t->post_recv_credits_work);
 	return 0;
 out_err:
 	put_recvmsg(t, recvmsg);
-- 
2.43.0

