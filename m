Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43BB92AE90
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154982; cv=none; b=bgBnZz67xE7G+ZSYOvciwAYVp5SL7rYN5rmP2o5PnuyFWKJweZ/VqYMH4joNH6P4qfQS8hkR2U8q9ajlHNu6b5tL/CTx/AJB9W0FU+M7mXNC0hEdFVDVd+w81n2uuegusgYNyqBc9gRDYFGP3t4PkAUe+piEpUWJ5WBDIbyU4L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154982; c=relaxed/simple;
	bh=hSiMf5YtCCx0OORY14wQ6rv2vtMUfinsl3A1R5uxQgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYEzlXhc4loFg4CnCuTYm8Gz3oQtbg8LKKm/nmOY1KCdwX823ckiN68Pg75W3pUaoYLIijqpU18zLwfdDg1sQKigznuma5vNk0yjdMRYXPPs/ofvb5VwEGV1S3GX1XH5o1ymT5JxpjXUovr/Iwy/GdyV0Fx5AphSndPkp1ipOkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=ywnPNelf; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="ywnPNelf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=thLcxBK9S6VvvzO0EqmiVTt5P5yvBYBINv8wnIbjN/4=; b=ywnPNelfUnQrG4jj1wNhCAZOfe
	D7nvnMcDsS62mXbKbzaAV0UyFVPzaxR7epUsHiRiIsYcbDi/jEKA1f1kXVJMFKxp5dl5veztUOBag
	gNfUyKt+UCN1xvGz6rUcvURzTSvPD7pAJd1Rbibu8iACY+fOPCgcTpFwhVy2zfYIqaQHCejiMDXtO
	2U/BfTP3mXBags7r997AFJxUQJt6eOVHPRxgjS7i5M13MHCALostbxYoAwMb8MZ0hCkkMmRIdbSms
	V8J+I2wzms/6JBrwLvbhb3JuWsExrRQCZEbO5FxY0EOkIWhXNKZHgEYeqUkoBpkhgkbC2QGH3zStj
	fO6NjRHBFMiJR2VgeKmXfEje6q21karMFdCQCKWEjHQ5McgdLwRmpOtwitzW4w5SJvu0QIlU7N6wY
	JRmeyQ/u0CU2Mze6krEUVJadbjpDrrlGL/MDtgW+okbjXhg0eS2uPPsFOUFTYGsz06ofVDq0GPJyk
	pF1B4oufLDhFVl2VzvTm0c3A;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe8D-000km9-2A;
	Mon, 25 Aug 2025 20:49:33 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 047/142] smb: client: make use of smbdirect_socket.statistics
Date: Mon, 25 Aug 2025 22:40:08 +0200
Message-ID: <70c1f459fab31f9a31de1281de952ab8c4ec3bea.1756139607.git.metze@samba.org>
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

This will allow us to use common functions soon.

Note this generates the following warnings from
scripts/checkpatch.pl --quiet:

 WARNING: quoted string split across lines
 #40: FILE: fs/smb/client/cifs_debug.c:464:
 +               seq_printf(m, "\nDebug count_get_receive_buffer: %llx "
 +                       "count_put_receive_buffer: %llx count_send_empty: %llx",

 WARNING: quoted string split across lines
 #47: FILE: fs/smb/client/cifs_debug.c:469:
                 seq_printf(m, "\nRead Queue "
 +                       "count_enqueue_reassembly_queue: %llx "

 WARNING: quoted string split across lines
 #48: FILE: fs/smb/client/cifs_debug.c:470:
 +                       "count_enqueue_reassembly_queue: %llx "
 +                       "count_dequeue_reassembly_queue: %llx "

 total: 0 errors, 3 warnings, 83 lines checked
 scripts/checkpatch.pl: FAILED

But I left them in there, because it matches the code
arround it...

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/cifs_debug.c | 18 +++++++++---------
 fs/smb/client/smbdirect.c  | 11 ++++++-----
 fs/smb/client/smbdirect.h  |  7 -------
 3 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 35c90d494cd9..bb6bb1e3b723 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -460,18 +460,18 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 			sp->keepalive_interval_msec * 1000,
 			sp->max_read_write_size,
 			server->smbd_conn->rdma_readwrite_threshold);
-		seq_printf(m, "\nDebug count_get_receive_buffer: %x "
-			"count_put_receive_buffer: %x count_send_empty: %x",
-			server->smbd_conn->count_get_receive_buffer,
-			server->smbd_conn->count_put_receive_buffer,
-			server->smbd_conn->count_send_empty);
+		seq_printf(m, "\nDebug count_get_receive_buffer: %llx "
+			"count_put_receive_buffer: %llx count_send_empty: %llx",
+			sc->statistics.get_receive_buffer,
+			sc->statistics.put_receive_buffer,
+			sc->statistics.send_empty);
 		seq_printf(m, "\nRead Queue "
-			"count_enqueue_reassembly_queue: %x "
-			"count_dequeue_reassembly_queue: %x "
+			"count_enqueue_reassembly_queue: %llx "
+			"count_dequeue_reassembly_queue: %llx "
 			"reassembly_data_length: %x "
 			"reassembly_queue_length: %x",
-			server->smbd_conn->count_enqueue_reassembly_queue,
-			server->smbd_conn->count_dequeue_reassembly_queue,
+			sc->statistics.enqueue_reassembly_queue,
+			sc->statistics.dequeue_reassembly_queue,
 			sc->recv_io.reassembly.data_length,
 			sc->recv_io.reassembly.queue_length);
 		seq_printf(m, "\nCurrent Credits send_credits: %x "
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index a597b0bbd521..2eaddf190354 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1168,9 +1168,10 @@ static int smbd_post_send_iter(struct smbd_connection *info,
  */
 static int smbd_post_send_empty(struct smbd_connection *info)
 {
+	struct smbdirect_socket *sc = &info->socket;
 	int remaining_data_length = 0;
 
-	info->count_send_empty++;
+	sc->statistics.send_empty++;
 	return smbd_post_send_iter(info, NULL, &remaining_data_length);
 }
 
@@ -1307,7 +1308,7 @@ static void enqueue_reassembly(
 	virt_wmb();
 	sc->recv_io.reassembly.data_length += data_length;
 	spin_unlock(&sc->recv_io.reassembly.lock);
-	info->count_enqueue_reassembly_queue++;
+	sc->statistics.enqueue_reassembly_queue++;
 }
 
 /*
@@ -1346,7 +1347,7 @@ static struct smbdirect_recv_io *get_receive_buffer(struct smbd_connection *info
 			&sc->recv_io.free.list,
 			struct smbdirect_recv_io, list);
 		list_del(&ret->list);
-		info->count_get_receive_buffer++;
+		sc->statistics.get_receive_buffer++;
 	}
 	spin_unlock_irqrestore(&sc->recv_io.free.lock, flags);
 
@@ -1375,7 +1376,7 @@ static void put_receive_buffer(
 
 	spin_lock_irqsave(&sc->recv_io.free.lock, flags);
 	list_add_tail(&response->list, &sc->recv_io.free.list);
-	info->count_put_receive_buffer++;
+	sc->statistics.put_receive_buffer++;
 	spin_unlock_irqrestore(&sc->recv_io.free.lock, flags);
 
 	queue_work(info->workqueue, &sc->recv_io.posted.refill_work);
@@ -2034,7 +2035,7 @@ int smbd_recv(struct smbd_connection *info, struct msghdr *msg)
 						&sc->recv_io.reassembly.lock);
 				}
 				queue_removed++;
-				info->count_dequeue_reassembly_queue++;
+				sc->statistics.dequeue_reassembly_queue++;
 				put_receive_buffer(info, response);
 				offset = 0;
 				log_read(INFO, "put_receive_buffer offset=0\n");
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index bc72634f5433..39a56a54f8b6 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -65,13 +65,6 @@ struct smbd_connection {
 	wait_queue_head_t wait_post_send;
 
 	struct workqueue_struct *workqueue;
-
-	/* for debug purposes */
-	unsigned int count_get_receive_buffer;
-	unsigned int count_put_receive_buffer;
-	unsigned int count_enqueue_reassembly_queue;
-	unsigned int count_dequeue_reassembly_queue;
-	unsigned int count_send_empty;
 };
 
 /* Create a SMBDirect session */
-- 
2.43.0

