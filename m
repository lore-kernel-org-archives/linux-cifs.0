Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572E52797AD
	for <linux-cifs@vger.kernel.org>; Tue,  5 Aug 2025 16:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754410378; cv=none; b=dH0do7VbCA3kbcVh8xjRFGo7UtVvqd3NQfwEmG1e+qtt7OCtaW+87g0yjawGquByXP7Ry+dmp7XoCdIh2rseSgsPodsuXIvApgx9/ukl2Fqkqztr0Ue2h6DP3HtZ6dBQG+/mBlYdALHKhgsNYk5//7gb7nt7cAe63Xq4pJjbRQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754410378; c=relaxed/simple;
	bh=1c8Q2QpFRAeHvbauQVAzjJZLbQNK87SKN1EtNR2kMno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A2b0NoQvKXnKJ2Hk3lGQiYYA3XMY9L8OWV2OS+gG0W74oiEEJX9m49gffMoBZxtQcrx2oCcfUFA1G4A3N2HPwmbYbX/nZfDVsA+P0Y+rI/6ZaaA7K3r7dDCIhfwvE5vfPweFmWH3F03RrOOm3KYylpc1n7BtO++xbmlU79Ny5Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=22V071kR; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="22V071kR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=7ZUYw2KN3MmaGoR8XDrR+AIYxQ/rjC1QK4D1iB91K2k=; b=22V071kR3C3SOEhWz0vC1E1Cb0
	Q6wMDW6fqtqqa9s1IU3Tv+x/44r0b+9bAo9ILnB4RTuKCFrkRa5M2nEJMCyrJVLvENrwi6YkvWzwG
	H56QyNj3bJCmkT6LxUqS+cBpBwusgIJ2cgFnfR0nUAUmpZijUMnX79whH3i4qMt4VjPgFRwYPtSCq
	+5A3ep8i2W/YOrH18Arn6AoLDNdNdrnBormQE2CVp71RxLyn0PahmL1o4yvk41IaUYPHrwBZsBIjM
	86Nw7cTDneu2cSH24v4AYETOufI/nis4yasFpi0MFDrUmKWfaX2T+qWC/nk5l0WUTf+XqV6yH3dJr
	JVtfREpjSG1RXQOW+BO+cTUvaFvjE3U1tWlzKVp+Tro5QYZB63ztgU+4H1OL1esF3/oLhiT9s/v0D
	cKP9s9ox9PV0GWoVxYOQRI1zvLx6SDOY1KBJO+55Y5iKVq7XqgpzYo2V4CzyyCKe1FqRwQeD259/G
	in/MWJsbxxI0p2YFMuEjHHah;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1ujKHU-0019j0-1z;
	Tue, 05 Aug 2025 16:12:52 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH 07/17] smb: client: make use of smb: smbdirect_socket.recv_io.free.{list,lock}
Date: Tue,  5 Aug 2025 18:11:35 +0200
Message-ID: <d54cb6488a04cffaa470842567d785a67dd91e23.1754409478.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754409478.git.metze@samba.org>
References: <cover.1754409478.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will be used by the server too in order to have common
helper functions in future.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 25 +++++++++++++------------
 fs/smb/client/smbdirect.h |  3 ---
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 0acd576863a6..2f225635e869 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1165,19 +1165,20 @@ static struct smbdirect_recv_io *_get_first_reassembly(struct smbd_connection *i
  */
 static struct smbdirect_recv_io *get_receive_buffer(struct smbd_connection *info)
 {
+	struct smbdirect_socket *sc = &info->socket;
 	struct smbdirect_recv_io *ret = NULL;
 	unsigned long flags;
 
-	spin_lock_irqsave(&info->receive_queue_lock, flags);
-	if (!list_empty(&info->receive_queue)) {
+	spin_lock_irqsave(&sc->recv_io.free.lock, flags);
+	if (!list_empty(&sc->recv_io.free.list)) {
 		ret = list_first_entry(
-			&info->receive_queue,
+			&sc->recv_io.free.list,
 			struct smbdirect_recv_io, list);
 		list_del(&ret->list);
 		info->count_receive_queue--;
 		info->count_get_receive_buffer++;
 	}
-	spin_unlock_irqrestore(&info->receive_queue_lock, flags);
+	spin_unlock_irqrestore(&sc->recv_io.free.lock, flags);
 
 	return ret;
 }
@@ -1202,11 +1203,11 @@ static void put_receive_buffer(
 		response->sge.length = 0;
 	}
 
-	spin_lock_irqsave(&info->receive_queue_lock, flags);
-	list_add_tail(&response->list, &info->receive_queue);
+	spin_lock_irqsave(&sc->recv_io.free.lock, flags);
+	list_add_tail(&response->list, &sc->recv_io.free.list);
 	info->count_receive_queue++;
 	info->count_put_receive_buffer++;
-	spin_unlock_irqrestore(&info->receive_queue_lock, flags);
+	spin_unlock_irqrestore(&sc->recv_io.free.lock, flags);
 
 	queue_work(info->workqueue, &info->post_send_credits_work);
 }
@@ -1223,8 +1224,8 @@ static int allocate_receive_buffers(struct smbd_connection *info, int num_buf)
 	info->reassembly_data_length = 0;
 	info->reassembly_queue_length = 0;
 
-	INIT_LIST_HEAD(&info->receive_queue);
-	spin_lock_init(&info->receive_queue_lock);
+	INIT_LIST_HEAD(&sc->recv_io.free.list);
+	spin_lock_init(&sc->recv_io.free.lock);
 	info->count_receive_queue = 0;
 
 	init_waitqueue_head(&info->wait_receive_queues);
@@ -1236,16 +1237,16 @@ static int allocate_receive_buffers(struct smbd_connection *info, int num_buf)
 
 		response->socket = sc;
 		response->sge.length = 0;
-		list_add_tail(&response->list, &info->receive_queue);
+		list_add_tail(&response->list, &sc->recv_io.free.list);
 		info->count_receive_queue++;
 	}
 
 	return 0;
 
 allocate_failed:
-	while (!list_empty(&info->receive_queue)) {
+	while (!list_empty(&sc->recv_io.free.list)) {
 		response = list_first_entry(
-				&info->receive_queue,
+				&sc->recv_io.free.list,
 				struct smbdirect_recv_io, list);
 		list_del(&response->list);
 		info->count_receive_queue--;
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index f53781f98e64..3381e01f5b83 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -105,10 +105,7 @@ struct smbd_connection {
 	wait_queue_head_t wait_post_send;
 
 	/* Receive queue */
-	struct list_head receive_queue;
 	int count_receive_queue;
-	spinlock_t receive_queue_lock;
-
 	wait_queue_head_t wait_receive_queues;
 
 	/* Reassembly queue */
-- 
2.43.0

