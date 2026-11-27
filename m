Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795797672;
	b=xffh4zHovQjHufkI/58Jb+dVxdSmSVh7vcfByz8Gx+njFYj6Coco/+YJGxRH/jX30gMN
	 ysoEQvurW0XkpCzJ+bf7WhIuzG4aIdf7hFbNAK6YtRLWTpjE0xQYLiit5bc4ShAFKrMZ5
	 PY9b9JoAkRV1qGkJUfyQzc5jt/RlkadyUVx1CW3UMS6XjSDfuO2db8ShnjWTw4Z6jdHYE
	 OeIwTfHSXNNAUEiI7pokpVAO+l976n37oqh4P6L3pCjk2Nqx+hY9LYrszPfyjT4sv7pWQ
	 cGMrAkvfz1MkJkRPW+A5zCIBcm1R2SVYg+jeFAcEFn3GoO/spjfTgqHVLhKZNyE9jjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795797672;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=A7Pg+4shoItKe/1MaRxLmt07mBcYhAmwoW6bc30XGHo=;
	b=ScatfmtH8jwvKM86WaE2u2NElks++ACDPe4wt6VmsnlS0Qj9pyTqfccl88ORc7cwyR4x
	 rkkfBF9i3bAE8bdJra1iPTxa4iHSTjqc2EH/cmJVeufHRHQ9m1yVk8EHtLu0kGxBsebxf
	 wxvwR0csBt23NHPJjseX5QkCqC2Ra8lk1F4LOvFEmeSL4lirMofdnOz4ZsxCobf3WG5QZ
	 WgYxwzrw1FLoDr1rSct9YxCI/JU23+9K2OCMM4LYu2wOL5wL+glyxXBfjCcIQiTCfK8r7
	 KORIjZ1SFmPJCSQIQBJHgAYSzSnZps4DBiAaNRKD4CW9oaLjYLgBKDaP8qrWqYhYtQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=tl+BWU94;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51961606A69E;
	Fri, 27 Nov 2026 16:41:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51961606A69E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=tl+BWU94
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=A7Pg+4shoItKe/1MaRxLmt07mBcYhAmwoW6bc30XGHo=; b=tl+BWU948kK7otR0nZucfHaC5l
	Y9rvbdd6GnyTgKjUmG1MTHP63qXA86KhY9WHvncl2jLcS6RLxjPcZ/qbsTTo3cBUvmE2ETV4IVami
	wdCMoyzGI1oYd5bGR14uieJrSe5T9H1EDTrZo+U0q4FMFOfRb6iPFoUwHKQQegJKgKOpRvcAI4T0l
	+QReMxuE1xg2TUbEx7q96zfdJDZ0LBiRPffVEJJgCEMH2Z08gk9zZobWy/V47jcI4qielCn8nrIFB
	ZunYKeoKSTskL7bo84qcElkUqQpwE0ekDMXg7j7LA+0GnCR9OBfNh0I+xg3hDEokMv/MvYoQzC1Jx
	GPi1BPJ6EnJDqSl944HXtzs/0cZTP0Q+f3WrVg/5prWjkc7mbhw65mRW6BmXxuyu01MzqJxbtwcMa
	hbG2L4Z0UbCFs+rK8L6sfHAwoMqitdb1mNRGtrdQF7vFk7kql5EwW/NVqLB2FInT5YYmCGvL/jYia
	jwVavtjARsfvenNeclCQPPtP;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xWz0U-00000001Pwf-2JHO;
	Fri, 27 Nov 2026 16:41:06 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	stable@vger.kernel.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Tom Talpey <tom@talpey.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH v2 05/13] smb: smbdirect: don't post a partial PDU after a send error
Date: Fri, 27 Nov 2026 17:40:24 +0100
Message-ID: <50fbfcadfda21fbc55980884221729998f2154c1.1795794871.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1795794871.git.metze@samba.org>
References: <cover.1795794871.git.metze@samba.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All fragments of a PDU are built into the same smbdirect_send_batch
by smbdirect_connection_send_single_iter(). If building a fragment
failed, e.g. because a credit wait was interrupted by a fatal signal
or a DMA mapping failed, smbdirect_connection_send_iter() and the
smbd_send() of the client still flushed the batch with is_last=true.

That posts the fragments built so far, the last of them with a
remaining_data_length that is never satisfied, fragments may also
have been posted already by a flush with is_last=false. The peer
then appends the next PDU to the incomplete one: cifs reconnects
asynchronously, ksmbd keeps the connection and its next response
continues the truncated one.

Add smbdirect_connection_send_batch_abort() and use it instead of
the final flush after an error: if nothing of the PDU was built yet,
it only gives back the batch credit, otherwise it frees the messages
not posted yet and tears down the connection, as the peer can no
longer get a consistent stream.

smbdirect_connection_send_wait_zero_pending() now also waits for all
posted messages if the connection is broken, before it returned as
soon as the status changed, which happens right away in
smbdirect_connection_send_batch_abort(), while the device could still
read the pages of the caller for fragments posted by a flush with
is_last=false. They complete with IB_WC_WR_FLUSH_ERR once the teardown
moved the QP to the error state.

smbdirect_connection_send_single_iter() gives back the batch credit
itself on its error paths, without waking up the waiters, so
smbdirect_connection_send_batch_abort() doesn't see it, that is fixed
by "smb: smbdirect: wake up the credit waiters after a failed send".

Fixes: 2c1ac39ce9cd ("smb: client: use smbdirect_send_batch processing")
Fixes: 54abc694ebb8 ("smb: smbdirect: introduce smbdirect_connection_send_iter() and related functions")
Cc: stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c     | 14 +++++-
 fs/smb/smbdirect/connection.c | 81 ++++++++++++++++++++++++++++++++---
 fs/smb/smbdirect/socket.h     |  7 +++
 include/linux/smbdirect.h     |  3 ++
 4 files changed, 98 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 563ef488a225..64d27d00079d 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -485,9 +485,19 @@ int smbd_send(struct TCP_Server_Info *server,
 
 	} while (++rqst_idx < num_rqst);
 
-	rc = smbdirect_connection_send_batch_flush(sc, batch, true);
-	if (unlikely(!rc && error))
+	if (unlikely(error)) {
+		/*
+		 * Don't post a partial PDU, if some of it was
+		 * already built, this tears down the connection.
+		 * Fragments may have been posted already, so we
+		 * still wait for them below, they may use the
+		 * pages of the request.
+		 */
+		smbdirect_connection_send_batch_abort(sc, batch);
 		rc = error;
+	} else {
+		rc = smbdirect_connection_send_batch_flush(sc, batch, true);
+	}
 
 	/*
 	 * As an optimization, we don't wait for individual I/O to finish
diff --git a/fs/smb/smbdirect/connection.c b/fs/smb/smbdirect/connection.c
index c50096e605ee..9a824f4f76c5 100644
--- a/fs/smb/smbdirect/connection.c
+++ b/fs/smb/smbdirect/connection.c
@@ -925,6 +925,7 @@ static void smbdirect_connection_send_batch_init(struct smbdirect_send_batch *ba
 	batch->need_invalidate_rkey = need_invalidate_rkey;
 	batch->remote_key = remote_key;
 	batch->credit = 0;
+	batch->msg_cnt = 0;
 }
 
 int smbdirect_connection_send_batch_flush(struct smbdirect_socket *sc,
@@ -988,6 +989,58 @@ int smbdirect_connection_send_batch_flush(struct smbdirect_socket *sc,
 }
 EXPORT_SYMBOL_GPL(smbdirect_connection_send_batch_flush);
 
+/*
+ * Abort the PDU of a batch after an error, instead of flushing it with
+ * is_last=true.
+ *
+ * All fragments of a PDU use the same batch. If some of them were
+ * already added to the batch, possibly posted by a flush with
+ * is_last=false, the peer can no longer get a complete PDU, its
+ * remaining_data_length would just continue with the next PDU. So the
+ * messages not posted yet are freed and the connection is torn down.
+ *
+ * If nothing of the PDU was built yet, e.g. the wait for the first
+ * credit failed, only the batch credit is given back.
+ */
+void smbdirect_connection_send_batch_abort(struct smbdirect_socket *sc,
+					   struct smbdirect_send_batch *batch)
+{
+	struct smbdirect_send_io *msg, *next;
+	u32 freed = 0;
+
+	list_for_each_entry_safe(msg, next, &batch->msg_list, sibling_list) {
+		list_del_init(&msg->sibling_list);
+		smbdirect_connection_free_send_io(msg);
+		freed++;
+	}
+	batch->wr_cnt = 0;
+
+	/*
+	 * Each message took a local and a send credit,
+	 * see smbdirect_connection_send_single_iter().
+	 */
+	if (freed) {
+		atomic_add(freed, &sc->send_io.credits.count);
+		wake_up(&sc->send_io.credits.wait_queue);
+		atomic_add(freed, &sc->send_io.lcredits.count);
+		wake_up(&sc->send_io.lcredits.wait_queue);
+	}
+
+	if (batch->credit) {
+		atomic_add(batch->credit, &sc->send_io.bcredits.count);
+		batch->credit = 0;
+		wake_up(&sc->send_io.bcredits.wait_queue);
+	}
+
+	if (batch->msg_cnt) {
+		smbdirect_log_write(sc, SMBDIRECT_LOG_ERR,
+			"aborting a partial PDU after %u message(s)\n",
+			batch->msg_cnt);
+		smbdirect_socket_schedule_cleanup(sc, -ECONNABORTED);
+	}
+}
+EXPORT_SYMBOL_GPL(smbdirect_connection_send_batch_abort);
+
 struct smbdirect_send_batch *
 smbdirect_init_send_batch_storage(struct smbdirect_send_batch_storage *storage,
 				  bool need_invalidate_rkey,
@@ -1097,6 +1150,7 @@ static int smbdirect_connection_post_send_io(struct smbdirect_socket *sc,
 		}
 		list_add_tail(&msg->sibling_list, &batch->msg_list);
 		batch->wr_cnt++;
+		batch->msg_cnt++;
 		return 0;
 	}
 
@@ -1303,9 +1357,15 @@ int smbdirect_connection_send_wait_zero_pending(struct smbdirect_socket *sc)
 	 * that means all the I/Os have been out and we are good to return
 	 */
 
+	/*
+	 * Also wait if the connection is broken: the device may still
+	 * read the pages of the caller for posted messages, e.g. earlier
+	 * fragments of a PDU that smbdirect_connection_send_batch_abort()
+	 * gave up. Once the teardown moved the QP to the error state,
+	 * they complete with IB_WC_WR_FLUSH_ERR.
+	 */
 	wait_event(sc->send_io.pending.zero_wait_queue,
-		   atomic_read(&sc->send_io.pending.count) == 0 ||
-		   sc->status != SMBDIRECT_SOCKET_CONNECTED);
+		   atomic_read(&sc->send_io.pending.count) == 0);
 	if (sc->status != SMBDIRECT_SOCKET_CONNECTED) {
 		smbdirect_log_write(sc, SMBDIRECT_LOG_ERR,
 			"status=%s first_error=%1pe => %1pe\n",
@@ -1382,9 +1442,20 @@ int smbdirect_connection_send_iter(struct smbdirect_socket *sc,
 		}
 	}
 
-	ret = smbdirect_connection_send_batch_flush(sc, &batch, true);
-	if (unlikely(ret && !error))
-		error = ret;
+	if (unlikely(error)) {
+		/*
+		 * Don't post a partial PDU, see
+		 * smbdirect_connection_send_batch_abort().
+		 * Fragments may have been posted already, so we
+		 * still wait for them below, they may use the
+		 * pages of the caller.
+		 */
+		smbdirect_connection_send_batch_abort(sc, &batch);
+	} else {
+		ret = smbdirect_connection_send_batch_flush(sc, &batch, true);
+		if (unlikely(ret))
+			error = ret;
+	}
 
 	/*
 	 * As an optimization, we don't wait for individual I/O to finish
diff --git a/fs/smb/smbdirect/socket.h b/fs/smb/smbdirect/socket.h
index 14114a2567a2..dc1e906316ff 100644
--- a/fs/smb/smbdirect/socket.h
+++ b/fs/smb/smbdirect/socket.h
@@ -783,6 +783,13 @@ struct smbdirect_send_batch {
 	u32 remote_key;
 
 	int credit;
+
+	/*
+	 * Number of messages added to the batch,
+	 * unlike wr_cnt not reset by a flush, see
+	 * smbdirect_connection_send_batch_abort().
+	 */
+	u32 msg_cnt;
 };
 
 struct smbdirect_recv_io {
diff --git a/include/linux/smbdirect.h b/include/linux/smbdirect.h
index 97f5ba730fa7..74fff00cdf88 100644
--- a/include/linux/smbdirect.h
+++ b/include/linux/smbdirect.h
@@ -115,6 +115,9 @@ int smbdirect_connection_send_batch_flush(struct smbdirect_socket *sc,
 					  struct smbdirect_send_batch *batch,
 					  bool is_last);
 
+void smbdirect_connection_send_batch_abort(struct smbdirect_socket *sc,
+					   struct smbdirect_send_batch *batch);
+
 /*
  * This is only temporary and only needed
  * as long as the client still requires
-- 
2.43.0

