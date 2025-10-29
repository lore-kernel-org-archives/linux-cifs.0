Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50083358D6
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 13:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761744865; cv=none; b=i9shZQce6jWY1FeZu6W0buAAGpVDJpc/CgOD4m9FAM5XwUbhSVOhcQMSg18kWSHKiK/vW6blRAJKVooVVTQBl15c2wEezfiGCxhxJOP3pOAs+dzn0k/HartqKewSAUIffYC4RWZQSiQUdaFSNF4qN6VELPuV+pS3Yo0jj7f7xaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761744865; c=relaxed/simple;
	bh=WxQPaAnVhsxv1jbfD2xCw3UFS+iKuwjWqmjeP3znTfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXJjWTfmQ/6kUuuwXaEhM2uQwVNIObNGHGavp5sq5ZqCZJ8rNuE4DHnAV139sxojTJGqBnPxEHWqhO/oP9WRRCJZSBajxiEdqovSEKQq+Tn00LkmQRR1dyvKYEybmMXtmfoJw2R50AIjdYDJbUXz6eO6ieUd4uptjNVa/d5nzLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=rZTsmSaw; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="rZTsmSaw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=y3OC2I69Nu94woFuy2lhNEk6zy4FhBHMwV02dbW9/VM=; b=rZTsmSawmmFdrTU1Xzw/rYbAGS
	1Xdmj1BOBSXhdFZmRmYS03OHM/l/ztRxBRKRiF4Xm8DMWwD9LnIidGw795qJ3WTrN5CPcM3IdypEE
	N8gBjOY1IpEEt7BvJEfKVJSH4+2vbsDYVc4yOES1U4gwcoz0lbGh/pZA+vNSzip5QsCzHalGtcVef
	u0PORyVF8xeR/UcBwmo6NbnjwgWBUDCJ778TgEastIJHy9f6vpgMyZjDzgJvyOxZGuLQ3oWP44ocx
	hBaiLVGEAK0ldgjMl3I+MxAU+lCDSP7j710o9rig1kuIgzSrsom7gh8V/uu2871O0ySyI9/7NkgyE
	NeHQoVcmq2VlJTKTuzXl8YxIfmFL1mt11DW4fDmvMmEtljmEzKe2xgAqcbqlrq198SHcEoti1HqsD
	NVWWpGk3paEbZHV+5obu6gbmI7X+5CnB2FdKkrLGGMSLFIUibQUYlEeO2jtrHGqnma46k3oQ/WzKR
	mgzrGpseBAkjmf8BJHA5qGMc;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vE6Jg-00Bd2s-1I;
	Wed, 29 Oct 2025 13:34:20 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v2 118/127] smb: server: move iov_iter_kvec() out of smb_direct_post_send_data()
Date: Wed, 29 Oct 2025 14:21:36 +0100
Message-ID: <da50121e7074821e3660a902366620637008f5d5.1761742839.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1761742839.git.metze@samba.org>
References: <cover.1761742839.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will allow us to make the code more generic in order
to move it to common with the client.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 38 ++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index 72cd64149785..03aedfa92c88 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -198,8 +198,8 @@ unsigned int get_smbd_max_read_write_size(struct ksmbd_transport *kt)
 
 static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 				     struct smbdirect_send_batch *send_ctx,
-				     struct kvec *iov, int niov,
-				     int remaining_data_length);
+				     struct iov_iter *iter,
+				     size_t *remaining_data_length);
 
 static void smb_direct_send_immediate_work(struct work_struct *work)
 {
@@ -209,7 +209,7 @@ static void smb_direct_send_immediate_work(struct work_struct *work)
 	if (sc->status != SMBDIRECT_SOCKET_CONNECTED)
 		return;
 
-	smb_direct_post_send_data(sc, NULL, NULL, 0, 0);
+	smb_direct_post_send_data(sc, NULL, NULL, NULL);
 }
 
 static struct smb_direct_transport *alloc_transport(struct rdma_cm_id *cm_id)
@@ -712,12 +712,13 @@ static int post_sendmsg(struct smbdirect_socket *sc,
 
 static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 				     struct smbdirect_send_batch *send_ctx,
-				     struct kvec *iov, int niov,
-				     int remaining_data_length)
+				     struct iov_iter *iter,
+				     size_t *_remaining_data_length)
 {
-	int i, ret;
 	struct smbdirect_send_io *msg;
-	int data_length;
+	u32 remaining_data_length = 0;
+	u32 data_length = 0;
+	int ret;
 
 	ret = wait_for_send_lcredit(sc, send_ctx);
 	if (ret)
@@ -727,16 +728,20 @@ static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 	if (ret)
 		goto credit_failed;
 
-	data_length = 0;
-	for (i = 0; i < niov; i++)
-		data_length += iov[i].iov_len;
+	if (iter)
+		data_length = iov_iter_count(iter);
+
+	if (_remaining_data_length) {
+		*_remaining_data_length -= data_length;
+		remaining_data_length = *_remaining_data_length;
+	}
 
 	ret = smb_direct_create_header(sc, data_length, remaining_data_length,
 				       &msg);
 	if (ret)
 		goto header_failed;
 
-	if (data_length) {
+	if (iter) {
 		struct smbdirect_map_sges extract = {
 			.num_sge	= msg->num_sge,
 			.max_sge	= ARRAY_SIZE(msg->sge),
@@ -745,11 +750,8 @@ static int smb_direct_post_send_data(struct smbdirect_socket *sc,
 			.local_dma_lkey	= sc->ib.pd->local_dma_lkey,
 			.direction	= DMA_TO_DEVICE,
 		};
-		struct iov_iter iter;
-
-		iov_iter_kvec(&iter, ITER_SOURCE, iov, niov, data_length);
 
-		ret = smbdirect_map_sges_from_iter(&iter, data_length, &extract);
+		ret = smbdirect_map_sges_from_iter(iter, data_length, &extract);
 		if (ret < 0)
 			goto err;
 		if (WARN_ON_ONCE(ret != data_length)) {
@@ -809,6 +811,7 @@ static int smb_direct_writev(struct ksmbd_transport *t,
 		size_t possible_vecs;
 		size_t bytes = 0;
 		size_t nvecs = 0;
+		struct iov_iter iter;
 
 		/*
 		 * For the last message remaining_data_length should be
@@ -889,11 +892,10 @@ static int smb_direct_writev(struct ksmbd_transport *t,
 			}
 		}
 
-		remaining_data_length -= bytes;
+		iov_iter_kvec(&iter, ITER_SOURCE, vecs, nvecs, bytes);
 
 		ret = smb_direct_post_send_data(sc, &send_ctx,
-						vecs, nvecs,
-						remaining_data_length);
+						&iter, &remaining_data_length);
 		if (unlikely(ret)) {
 			error = ret;
 			goto done;
-- 
2.43.0

