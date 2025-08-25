Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22A522128B
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155413; cv=none; b=GVDI7nM9XAqa7YUQGxn0o7aKS1RGLYUsR8zbWS31N+iyy4Lyu1IYRWDv7NrdLlVSDBvc0il5z6E80HwGtxk7EJsPeR7fzTSahjqMD0Rp+aqrI86MB3xzZtaUaDHSFB5Xijuj05i5jc4KtJDV6AfCLqSaOGvEhuP3mHGXHvV2z7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155413; c=relaxed/simple;
	bh=CZx0v2CzvnWIcDEeFDPiAIf9hG7FlbXLAvpU0Fwxi3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FF1WZHmbkvUzB/Z4jf6g0QwFyM+MVarWbPwPHt8bgYbQvoRTVf4fGPsH3U8GQOSzBn/iNhEoXd2UFgerv4pu8uWailzxrO5Qv4s1rCash3BjG1hCy4Y3QI2a8KX+uZv2QRCdZ5+y85ZC738nCnJ1Plq+B+qHtU4EbYDOrH1/xVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=aXtB56z5; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="aXtB56z5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=EtFimAgiGA1SYwm6XyzylwiLTTbxjUukcWd42kx1XIk=; b=aXtB56z5MKXoGLnmOfc+5f8lbE
	/YHW6e6AtjToXa8Meyrqy3nevU6T1XRv0RVCAo1IvanoIe5tCYtSyGAxGeEJMsG55f6Kod6zLcEVn
	f/yHsqBvxXLfmqrRbc6YmqZEJ9hjQmI/OVIxhn4j4FJkgP/iqi78n91hdPOiUlHfYjZGqu7+ThJni
	Ag+TsE4SZRqi24VIq6ZIBF+Nl4rpS3mR9PEAQdhAdxEaGNpe395oTnKG9ESaoPirLFDvp/5mngYmS
	tTeONOGgRbNHXARD/R2+JG5hPR1MMrM0J3B0vGbqxoPyUUkVcwBgKAGRzUzmKW0L1LSUdzDpHsvit
	aYBecQzjh9SVMzGdNU2buwqU+zJy/uYsJC7lYHnlq/QPDyuFY82GY840gMmMYP+oWE/YyHzGKmLSN
	v+XFcZ1Tf8FNwxAuWQG+iKu6U9a8peCl2xdQJETFOMOIUmKd4ocz2UZps5iWrxJgQWXXDStTWbDKI
	VkmaL9s29jAlmzhtNGqs7LnS;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeFF-000mET-0U;
	Mon, 25 Aug 2025 20:56:49 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 090/142] smb: server: queue post_recv_credits_work in put_recvmsg() and avoid count_avail_recvmsg
Date: Mon, 25 Aug 2025 22:40:51 +0200
Message-ID: <2e7fbb45f696b56e69aacc1ce67f417c099dd653.1756139607.git.metze@samba.org>
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

This is basically what the client is doing in put_receive_buffer().

It means we don't need complicated work to maintain count_avail_recvmsg.

But we keep the logic to queue post_recv_credits_work if the
peer raises the requested credit_target and put_receive_buffer()
is not called.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 45 +++++++++-------------------------
 1 file changed, 11 insertions(+), 34 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 85e0d2ea37ec..4f0c7c8cb041 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -96,7 +96,6 @@ struct smb_direct_transport {
 
 	spinlock_t		receive_credit_lock;
 	int			recv_credits;
-	int			count_avail_recvmsg;
 	int			recv_credit_target;
 
 	atomic_t		send_credits;
@@ -183,13 +182,6 @@ static inline void
 	return (void *)recvmsg->packet;
 }
 
-static inline bool is_receive_credit_post_required(int receive_credits,
-						   int avail_recvmsg_count)
-{
-	return receive_credits <= (smb_direct_receive_credit_max >> 3) &&
-		avail_recvmsg_count >= (receive_credits >> 2);
-}
-
 static struct
 smbdirect_recv_io *get_free_recvmsg(struct smb_direct_transport *t)
 {
@@ -223,6 +215,8 @@ static void put_recvmsg(struct smb_direct_transport *t,
 	spin_lock(&sc->recv_io.free.lock);
 	list_add(&recvmsg->list, &sc->recv_io.free.list);
 	spin_unlock(&sc->recv_io.free.lock);
+
+	queue_work(smb_direct_wq, &t->post_recv_credits_work);
 }
 
 static void enqueue_reassembly(struct smb_direct_transport *t,
@@ -528,7 +522,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		struct smbdirect_data_transfer *data_transfer =
 			(struct smbdirect_data_transfer *)recvmsg->packet;
 		unsigned int data_length;
-		int avail_recvmsg_count, receive_credits;
+		int old_recv_credit_target;
 
 		if (wc->byte_len <
 		    offsetof(struct smbdirect_data_transfer, padding)) {
@@ -553,18 +547,13 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 				sc->recv_io.reassembly.full_packet_received = false;
 			else
 				sc->recv_io.reassembly.full_packet_received = true;
-
-			spin_lock(&t->receive_credit_lock);
-			receive_credits = --(t->recv_credits);
-			avail_recvmsg_count = t->count_avail_recvmsg;
-			spin_unlock(&t->receive_credit_lock);
-		} else {
-			spin_lock(&t->receive_credit_lock);
-			receive_credits = --(t->recv_credits);
-			avail_recvmsg_count = ++(t->count_avail_recvmsg);
-			spin_unlock(&t->receive_credit_lock);
 		}
 
+		spin_lock(&t->receive_credit_lock);
+		t->recv_credits -= 1;
+		spin_unlock(&t->receive_credit_lock);
+
+		old_recv_credit_target = t->recv_credit_target;
 		t->recv_credit_target =
 				le16_to_cpu(data_transfer->credits_requested);
 		atomic_add(le16_to_cpu(data_transfer->credits_granted),
@@ -577,10 +566,10 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		if (atomic_read(&t->send_credits) > 0)
 			wake_up(&t->wait_send_credits);
 
-		if (is_receive_credit_post_required(receive_credits, avail_recvmsg_count))
-			queue_work(smb_direct_wq, &t->post_recv_credits_work);
-
 		if (data_length) {
+			if (t->recv_credit_target > old_recv_credit_target)
+				queue_work(smb_direct_wq, &t->post_recv_credits_work);
+
 			enqueue_reassembly(t, recvmsg, (int)data_length);
 			wake_up(&sc->recv_io.reassembly.wait_queue);
 		} else
@@ -738,15 +727,6 @@ static int smb_direct_read(struct ksmbd_transport *t, char *buf,
 		sc->recv_io.reassembly.queue_length -= queue_removed;
 		spin_unlock_irq(&sc->recv_io.reassembly.lock);
 
-		spin_lock(&st->receive_credit_lock);
-		st->count_avail_recvmsg += queue_removed;
-		if (is_receive_credit_post_required(st->recv_credits, st->count_avail_recvmsg)) {
-			spin_unlock(&st->receive_credit_lock);
-			queue_work(smb_direct_wq, &st->post_recv_credits_work);
-		} else {
-			spin_unlock(&st->receive_credit_lock);
-		}
-
 		sc->recv_io.reassembly.first_entry_offset = offset;
 		ksmbd_debug(RDMA,
 			    "returning to thread data_read=%d reassembly_data_length=%d first_entry_offset=%d\n",
@@ -798,7 +778,6 @@ static void smb_direct_post_recv_credits(struct work_struct *work)
 
 	spin_lock(&t->receive_credit_lock);
 	t->recv_credits += credits;
-	t->count_avail_recvmsg -= credits;
 	spin_unlock(&t->receive_credit_lock);
 
 	spin_lock(&t->lock_new_recv_credits);
@@ -1757,7 +1736,6 @@ static int smb_direct_init_params(struct smb_direct_transport *t,
 	}
 
 	t->recv_credits = 0;
-	t->count_avail_recvmsg = 0;
 
 	sp->recv_credit_max = smb_direct_receive_credit_max;
 	t->recv_credit_target = 10;
@@ -1845,7 +1823,6 @@ static int smb_direct_create_pools(struct smb_direct_transport *t)
 		recvmsg->sge.length = 0;
 		list_add(&recvmsg->list, &sc->recv_io.free.list);
 	}
-	t->count_avail_recvmsg = sp->recv_credit_max;
 
 	return 0;
 err:
-- 
2.43.0

