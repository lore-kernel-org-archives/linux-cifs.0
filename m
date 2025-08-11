Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B911A83F8;
	Mon, 11 Aug 2025 14:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754921723; cv=none; b=mOfaWApp3ug21yGl1SpOW/xOMO3VsohTE0xMGTH56le8rBXHwgiZPz8NrkqLyNSFwVk97vOSB7I2FdzdcIlmqCSRH2bPqIpyHZ81OTLwEcb9xMFqONAKyKpHAC8Jz+ZjUK2E9GvnAHbZQ6CuXHyOq6NuU2CAxYt4FI4d/zyGrug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754921723; c=relaxed/simple;
	bh=ZHPBXXARkxfMnIeg1ZiMsgZlLUb6UJTzndMVRLNHEUg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OPhe6vOGHbb30HURCUZvGRO4fxPyvbeM9SNfLOtZt0gydb7q0I42G0zTY45fDX2uKP24zAzU4mavgYXNFvXhFmkn8c89en6z+rSvxII6iA8gwNJMJyYm7vhRWs2UxV6yt3Au8sjoE2mKoivyM2Yy1WlctzT9hVVD13FBb/JKfi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4c0xVZ5g6RzYQvCD;
	Mon, 11 Aug 2025 22:15:18 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 69F8E1A177F;
	Mon, 11 Aug 2025 22:15:17 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBXIBHw+plocdNUDQ--.57266S6;
	Mon, 11 Aug 2025 22:15:17 +0800 (CST)
From: Wang Zhaolong <wangzhaolong@huaweicloud.com>
To: sfrench@samba.org,
	pshilov@microsoft.com
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	chengzhihao1@huawei.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH V3 2/2] smb: client: Clean up mid_queue_lock usage and standardize mid_state access
Date: Mon, 11 Aug 2025 22:07:38 +0800
Message-Id: <20250811140738.1141817-3-wangzhaolong@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250811140738.1141817-1-wangzhaolong@huaweicloud.com>
References: <20250811140738.1141817-1-wangzhaolong@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXIBHw+plocdNUDQ--.57266S6
X-Coremail-Antispam: 1UD129KBjvAXoWfZFy7Zr1UGF1xKFWrJr17trb_yoW8tFWfGo
	Z3W345Ar4UXr9YkFyYyrn3JF4v9r4q939FqF4FyrW5Aa4Ika10qr18tr45Jay5ZF4ft390
	9aykJFn5ta97Jwn3n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUYL7kC6x804xWl14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK
	8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr
	yl82xGYIkIc2x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AK
	xVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ew
	Av7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY
	6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI4
	8JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xv
	wVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjx
	v20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20E
	Y4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267
	AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU89NVDUUUUU==
X-CM-SenderInfo: pzdqw6xkdrz0tqj6x35dzhxuhorxvhhfrp/

This patch cleans up unnecessary mid_queue_lock usage in several places
where the lock is not actually needed. Many functions were holding
mid_queue_lock to protect mid state updates on mids that are no longer
in the queue, such as in smb2_decrypt_offload() and various callback
functions.

This patch also standardizes mid_state access using READ_ONCE/WRITE_ONCE
throughout the codebase to ensure consistent memory access patterns and
prevent compiler optimizations that could cause issues.

The core insight is that mid_state synchronization doesn't require the
same lock as queue structure protection. Separating these concerns makes
the locking model clearer and reduces unnecessary lock contention.

Signed-off-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
---
 fs/smb/client/cifssmb.c       |  8 +++---
 fs/smb/client/cifstransport.c | 50 ++++++++++++++++++++++++++---------
 fs/smb/client/connect.c       | 17 ++++++------
 fs/smb/client/smb1ops.c       |  5 ++--
 fs/smb/client/smb2ops.c       | 22 +++++++--------
 fs/smb/client/smb2pdu.c       | 10 ++++---
 fs/smb/client/smb2transport.c |  2 +-
 fs/smb/client/transport.c     | 43 +++++++++++++++++-------------
 8 files changed, 95 insertions(+), 62 deletions(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index d20766f664c4..1da3436a52cb 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1309,16 +1309,17 @@ cifs_readv_callback(struct mid_q_entry *mid)
 		.value = 1,
 		.instance = 0,
 		.rreq_debug_id = rdata->rreq->debug_id,
 		.rreq_debug_index = rdata->subreq.debug_index,
 	};
+	int mid_state = READ_ONCE(mid->mid_state);
 
 	cifs_dbg(FYI, "%s: mid=%llu state=%d result=%d bytes=%zu\n",
-		 __func__, mid->mid, mid->mid_state, rdata->result,
+		 __func__, mid->mid, mid_state, rdata->result,
 		 rdata->subreq.len);
 
-	switch (mid->mid_state) {
+	switch (mid_state) {
 	case MID_RESPONSE_RECEIVED:
 		/* result already set, check signature */
 		if (server->sign) {
 			int rc = 0;
 
@@ -1694,12 +1695,13 @@ cifs_writev_callback(struct mid_q_entry *mid)
 		.rreq_debug_id = wdata->rreq->debug_id,
 		.rreq_debug_index = wdata->subreq.debug_index,
 	};
 	ssize_t result;
 	size_t written;
+	int mid_state = READ_ONCE(mid->mid_state);
 
-	switch (mid->mid_state) {
+	switch (mid_state) {
 	case MID_RESPONSE_RECEIVED:
 		result = cifs_check_receive(mid, tcon->ses->server, 0);
 		if (result != 0)
 			break;
 
diff --git a/fs/smb/client/cifstransport.c b/fs/smb/client/cifstransport.c
index e98b95eff8c9..c69aff70c7a4 100644
--- a/fs/smb/client/cifstransport.c
+++ b/fs/smb/client/cifstransport.c
@@ -64,11 +64,11 @@ alloc_mid(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 	temp->creator = current;
 	temp->callback = cifs_wake_up_task;
 	temp->callback_data = current;
 
 	atomic_inc(&mid_count);
-	temp->mid_state = MID_REQUEST_ALLOCATED;
+	WRITE_ONCE(temp->mid_state, MID_REQUEST_ALLOCATED);
 	return temp;
 }
 
 int
 smb_send(struct TCP_Server_Info *server, struct smb_hdr *smb_buffer,
@@ -328,11 +328,11 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 	if (rc) {
 		cifs_server_unlock(server);
 		goto out;
 	}
 
-	midQ->mid_state = MID_REQUEST_SUBMITTED;
+	WRITE_ONCE(midQ->mid_state, MID_REQUEST_SUBMITTED);
 
 	rc = smb_send(server, in_buf, len);
 	cifs_save_when_sent(midQ);
 
 	if (rc < 0)
@@ -362,11 +362,11 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 		add_credits(server, &credits, 0);
 		return rc;
 	}
 
 	if (!midQ->resp_buf || !out_buf ||
-	    midQ->mid_state != MID_RESPONSE_READY) {
+	    READ_ONCE(midQ->mid_state) != MID_RESPONSE_READY) {
 		rc = -EIO;
 		cifs_server_dbg(VFS, "Bad MID state?\n");
 		goto out;
 	}
 
@@ -403,10 +403,40 @@ send_lock_cancel(const unsigned int xid, struct cifs_tcon *tcon,
 
 	return SendReceive(xid, ses, in_buf, out_buf,
 			&bytes_returned, 0);
 }
 
+static inline bool cifs_blocking_lock_should_exit(struct mid_q_entry *midQ,
+					struct TCP_Server_Info *server)
+{
+	int mid_state = READ_ONCE(midQ->mid_state);
+	int tcp_status = READ_ONCE(server->tcpStatus);
+
+	if (mid_state != MID_REQUEST_SUBMITTED &&
+		mid_state != MID_RESPONSE_RECEIVED)
+		return true;
+
+	if (tcp_status != CifsGood && tcp_status != CifsNew)
+		return true;
+
+	return false;
+}
+
+static inline bool cifs_blocking_lock_can_cancel(struct mid_q_entry *midQ,
+					struct TCP_Server_Info *server)
+{
+	int mid_state = READ_ONCE(midQ->mid_state);
+	int tcp_status = READ_ONCE(server->tcpStatus);
+	/* Can only cancel if still pending */
+	bool still_pending = (mid_state == MID_REQUEST_SUBMITTED ||
+			mid_state == MID_RESPONSE_RECEIVED);
+	/* Can only cancel if server connection is good */
+	bool server_good = (tcp_status == CifsGood || tcp_status == CifsNew);
+
+	return still_pending && server_good;
+}
+
 int
 SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	    struct smb_hdr *in_buf, struct smb_hdr *out_buf,
 	    int *pbytes_returned)
 {
@@ -470,11 +500,11 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 		delete_mid(midQ);
 		cifs_server_unlock(server);
 		return rc;
 	}
 
-	midQ->mid_state = MID_REQUEST_SUBMITTED;
+	WRITE_ONCE(midQ->mid_state, MID_REQUEST_SUBMITTED);
 	rc = smb_send(server, in_buf, len);
 	cifs_save_when_sent(midQ);
 
 	if (rc < 0)
 		server->sequence_number -= 2;
@@ -486,22 +516,16 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 		return rc;
 	}
 
 	/* Wait for a reply - allow signals to interrupt. */
 	rc = wait_event_interruptible(server->response_q,
-		(!(midQ->mid_state == MID_REQUEST_SUBMITTED ||
-		   midQ->mid_state == MID_RESPONSE_RECEIVED)) ||
-		((server->tcpStatus != CifsGood) &&
-		 (server->tcpStatus != CifsNew)));
+		cifs_blocking_lock_should_exit(midQ, server));
 
 	/* Were we interrupted by a signal ? */
 	spin_lock(&server->srv_lock);
 	if ((rc == -ERESTARTSYS) &&
-		(midQ->mid_state == MID_REQUEST_SUBMITTED ||
-		 midQ->mid_state == MID_RESPONSE_RECEIVED) &&
-		((server->tcpStatus == CifsGood) ||
-		 (server->tcpStatus == CifsNew))) {
+	     cifs_blocking_lock_can_cancel(midQ, server)) {
 		spin_unlock(&server->srv_lock);
 
 		if (in_buf->Command == SMB_COM_TRANSACTION2) {
 			/* POSIX lock. We send a NT_CANCEL SMB to cause the
 			   blocking lock to return. */
@@ -546,11 +570,11 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 	rc = cifs_sync_mid_result(midQ, server);
 	if (rc != 0)
 		return rc;
 
 	/* rcvd frame is ok */
-	if (out_buf == NULL || midQ->mid_state != MID_RESPONSE_READY) {
+	if (out_buf == NULL || READ_ONCE(midQ->mid_state) != MID_RESPONSE_READY) {
 		rc = -EIO;
 		cifs_tcon_dbg(VFS, "Bad MID state?\n");
 		goto out;
 	}
 
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 281ccbeea719..4cbaf8fe3ccf 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -322,12 +322,12 @@ cifs_abort_connection(struct TCP_Server_Info *server)
 	INIT_LIST_HEAD(&retry_list);
 	cifs_dbg(FYI, "%s: moving mids to private list\n", __func__);
 	spin_lock(&server->mid_queue_lock);
 	list_for_each_entry_safe(mid, nmid, &server->pending_mid_q, qhead) {
 		kref_get(&mid->refcount);
-		if (mid->mid_state == MID_REQUEST_SUBMITTED)
-			mid->mid_state = MID_RETRY_NEEDED;
+		if (READ_ONCE(mid->mid_state) == MID_REQUEST_SUBMITTED)
+			WRITE_ONCE(mid->mid_state, MID_RETRY_NEEDED);
 		list_move(&mid->qhead, &retry_list);
 		mid->deleted_from_q = true;
 	}
 	spin_unlock(&server->mid_queue_lock);
 	cifs_server_unlock(server);
@@ -916,11 +916,11 @@ is_smb_response(struct TCP_Server_Info *server, unsigned char type)
 			 * return code should be read from mid_rc member.
 			 */
 			list_for_each_entry_safe(mid, nmid, &dispose_list, qhead) {
 				list_del_init(&mid->qhead);
 				mid->mid_rc = mid_rc;
-				mid->mid_state = MID_RC;
+				WRITE_ONCE(mid->mid_state, MID_RC);
 				mid_execute_callback(mid);
 				release_mid(mid);
 			}
 
 			/*
@@ -955,19 +955,18 @@ void
 dequeue_mid(struct mid_q_entry *mid, bool malformed)
 {
 #ifdef CONFIG_CIFS_STATS2
 	mid->when_received = jiffies;
 #endif
-	spin_lock(&mid->server->mid_queue_lock);
-	if (!malformed)
-		mid->mid_state = MID_RESPONSE_RECEIVED;
-	else
-		mid->mid_state = MID_RESPONSE_MALFORMED;
+	WRITE_ONCE(mid->mid_state, malformed ? MID_RESPONSE_MALFORMED :
+		   MID_RESPONSE_RECEIVED);
 	/*
 	 * Trying to handle/dequeue a mid after the send_recv()
 	 * function has finished processing it is a bug.
 	 */
+
+	spin_lock(&mid->server->mid_queue_lock);
 	if (mid->deleted_from_q == true) {
 		spin_unlock(&mid->server->mid_queue_lock);
 		pr_warn_once("trying to dequeue a deleted mid\n");
 	} else {
 		list_del_init(&mid->qhead);
@@ -1104,11 +1103,11 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
 		spin_lock(&server->mid_queue_lock);
 		list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
 			cifs_dbg(FYI, "Clearing mid %llu\n", mid_entry->mid);
 			kref_get(&mid_entry->refcount);
-			mid_entry->mid_state = MID_SHUTDOWN;
+			WRITE_ONCE(mid_entry->mid_state, MID_SHUTDOWN);
 			list_move(&mid_entry->qhead, &dispose_list);
 			mid_entry->deleted_from_q = true;
 		}
 		spin_unlock(&server->mid_queue_lock);
 
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 893a1ea8c000..5ef007a0bad0 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -96,11 +96,11 @@ cifs_find_mid(struct TCP_Server_Info *server, char *buffer)
 	struct mid_q_entry *mid;
 
 	spin_lock(&server->mid_queue_lock);
 	list_for_each_entry(mid, &server->pending_mid_q, qhead) {
 		if (compare_mid(mid->mid, buf) &&
-		    mid->mid_state == MID_REQUEST_SUBMITTED &&
+		    READ_ONCE(mid->mid_state) == MID_REQUEST_SUBMITTED &&
 		    le16_to_cpu(mid->command) == buf->Command) {
 			kref_get(&mid->refcount);
 			spin_unlock(&server->mid_queue_lock);
 			return mid;
 		}
@@ -199,11 +199,12 @@ cifs_get_next_mid(struct TCP_Server_Info *server)
 		num_mids = 0;
 		spin_lock(&server->mid_queue_lock);
 		list_for_each_entry(mid_entry, &server->pending_mid_q, qhead) {
 			++num_mids;
 			if (mid_entry->mid == cur_mid &&
-			    mid_entry->mid_state == MID_REQUEST_SUBMITTED) {
+			    READ_ONCE(mid_entry->mid_state) ==
+				      MID_REQUEST_SUBMITTED) {
 				/* This mid is in use, try a different one */
 				collision = true;
 				break;
 			}
 		}
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index f7a0f1c81b43..0938a33a7856 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -402,11 +402,11 @@ __smb2_find_mid(struct TCP_Server_Info *server, char *buf, bool dequeue)
 	}
 
 	spin_lock(&server->mid_queue_lock);
 	list_for_each_entry(mid, &server->pending_mid_q, qhead) {
 		if ((mid->mid == wire_mid) &&
-		    (mid->mid_state == MID_REQUEST_SUBMITTED) &&
+		    (READ_ONCE(mid->mid_state) == MID_REQUEST_SUBMITTED) &&
 		    (mid->command == shdr->Command)) {
 			kref_get(&mid->refcount);
 			if (dequeue) {
 				list_del_init(&mid->qhead);
 				mid->deleted_from_q = true;
@@ -4661,11 +4661,11 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 	if (rdata->result != 0) {
 		cifs_dbg(FYI, "%s: server returned error %d\n",
 			 __func__, rdata->result);
 		/* normal error on read response */
 		if (is_offloaded)
-			mid->mid_state = MID_RESPONSE_RECEIVED;
+			WRITE_ONCE(mid->mid_state, MID_RESPONSE_RECEIVED);
 		else
 			dequeue_mid(mid, false);
 		return 0;
 	}
 
@@ -4688,11 +4688,11 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 		/* data_offset is beyond the end of smallbuf */
 		cifs_dbg(FYI, "%s: data offset (%u) beyond end of smallbuf\n",
 			 __func__, data_offset);
 		rdata->result = -EIO;
 		if (is_offloaded)
-			mid->mid_state = MID_RESPONSE_MALFORMED;
+			WRITE_ONCE(mid->mid_state, MID_RESPONSE_MALFORMED);
 		else
 			dequeue_mid(mid, rdata->result);
 		return 0;
 	}
 
@@ -4707,32 +4707,32 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 			/* data offset is beyond the 1st page of response */
 			cifs_dbg(FYI, "%s: data offset (%u) beyond 1st page of response\n",
 				 __func__, data_offset);
 			rdata->result = -EIO;
 			if (is_offloaded)
-				mid->mid_state = MID_RESPONSE_MALFORMED;
+				WRITE_ONCE(mid->mid_state, MID_RESPONSE_MALFORMED);
 			else
 				dequeue_mid(mid, rdata->result);
 			return 0;
 		}
 
 		if (data_len > buffer_len - pad_len) {
 			/* data_len is corrupt -- discard frame */
 			rdata->result = -EIO;
 			if (is_offloaded)
-				mid->mid_state = MID_RESPONSE_MALFORMED;
+				WRITE_ONCE(mid->mid_state, MID_RESPONSE_MALFORMED);
 			else
 				dequeue_mid(mid, rdata->result);
 			return 0;
 		}
 
 		/* Copy the data to the output I/O iterator. */
 		rdata->result = cifs_copy_folioq_to_iter(buffer, buffer_len,
 							 cur_off, &rdata->subreq.io_iter);
 		if (rdata->result != 0) {
 			if (is_offloaded)
-				mid->mid_state = MID_RESPONSE_MALFORMED;
+				WRITE_ONCE(mid->mid_state, MID_RESPONSE_MALFORMED);
 			else
 				dequeue_mid(mid, rdata->result);
 			return 0;
 		}
 		rdata->got_bytes = buffer_len;
@@ -4747,18 +4747,18 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 	} else {
 		/* read response payload cannot be in both buf and pages */
 		WARN_ONCE(1, "buf can not contain only a part of read data");
 		rdata->result = -EIO;
 		if (is_offloaded)
-			mid->mid_state = MID_RESPONSE_MALFORMED;
+			WRITE_ONCE(mid->mid_state, MID_RESPONSE_MALFORMED);
 		else
 			dequeue_mid(mid, rdata->result);
 		return 0;
 	}
 
 	if (is_offloaded)
-		mid->mid_state = MID_RESPONSE_RECEIVED;
+		WRITE_ONCE(mid->mid_state, MID_RESPONSE_RECEIVED);
 	else
 		dequeue_mid(mid, false);
 	return 0;
 }
 
@@ -4807,18 +4807,16 @@ static void smb2_decrypt_offload(struct work_struct *work)
 
 			mid_execute_callback(mid);
 		} else {
 			spin_lock(&dw->server->srv_lock);
 			if (dw->server->tcpStatus == CifsNeedReconnect) {
-				spin_lock(&dw->server->mid_queue_lock);
-				mid->mid_state = MID_RETRY_NEEDED;
-				spin_unlock(&dw->server->mid_queue_lock);
 				spin_unlock(&dw->server->srv_lock);
+				WRITE_ONCE(mid->mid_state, MID_RETRY_NEEDED);
 				mid_execute_callback(mid);
 			} else {
 				spin_lock(&dw->server->mid_queue_lock);
-				mid->mid_state = MID_REQUEST_SUBMITTED;
+				WRITE_ONCE(mid->mid_state, MID_REQUEST_SUBMITTED);
 				mid->deleted_from_q = false;
 				list_add_tail(&mid->qhead,
 					&dw->server->pending_mid_q);
 				spin_unlock(&dw->server->mid_queue_lock);
 				spin_unlock(&dw->server->srv_lock);
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 2df93a75e3b8..a9aab1207ee4 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4092,13 +4092,14 @@ static void
 smb2_echo_callback(struct mid_q_entry *mid)
 {
 	struct TCP_Server_Info *server = mid->callback_data;
 	struct smb2_echo_rsp *rsp = (struct smb2_echo_rsp *)mid->resp_buf;
 	struct cifs_credits credits = { .value = 0, .instance = 0 };
+	int mid_state = READ_ONCE(mid->mid_state);
 
-	if (mid->mid_state == MID_RESPONSE_RECEIVED
-	    || mid->mid_state == MID_RESPONSE_MALFORMED) {
+	if (mid_state == MID_RESPONSE_RECEIVED
+	    || mid_state == MID_RESPONSE_MALFORMED) {
 		credits.value = le16_to_cpu(rsp->hdr.CreditRequest);
 		credits.instance = server->reconnect_instance;
 	}
 
 	release_mid(mid);
@@ -4531,24 +4532,25 @@ smb2_readv_callback(struct mid_q_entry *mid)
 		.rreq_debug_index = rdata->subreq.debug_index,
 	};
 	struct smb_rqst rqst = { .rq_iov = &rdata->iov[1], .rq_nvec = 1 };
 	unsigned int rreq_debug_id = rdata->rreq->debug_id;
 	unsigned int subreq_debug_index = rdata->subreq.debug_index;
+	int mid_state = READ_ONCE(mid->mid_state);
 
 	if (rdata->got_bytes) {
 		rqst.rq_iter	  = rdata->subreq.io_iter;
 	}
 
 	WARN_ONCE(rdata->server != mid->server,
 		  "rdata server %p != mid server %p",
 		  rdata->server, mid->server);
 
 	cifs_dbg(FYI, "%s: mid=%llu state=%d result=%d bytes=%zu/%zu\n",
-		 __func__, mid->mid, mid->mid_state, rdata->result,
+		 __func__, mid->mid, mid_state, rdata->result,
 		 rdata->got_bytes, rdata->subreq.len - rdata->subreq.transferred);
 
-	switch (mid->mid_state) {
+	switch (mid_state) {
 	case MID_RESPONSE_RECEIVED:
 		credits.value = le16_to_cpu(shdr->CreditRequest);
 		credits.instance = server->reconnect_instance;
 		/* result already set, check signature */
 		if (server->sign && !mid->decrypted) {
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index bc0e92eb2b64..7c4108f1a28b 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -787,11 +787,11 @@ smb2_mid_entry_alloc(const struct smb2_hdr *shdr,
 	temp->creator = current;
 	temp->callback = cifs_wake_up_task;
 	temp->callback_data = current;
 
 	atomic_inc(&mid_count);
-	temp->mid_state = MID_REQUEST_ALLOCATED;
+	WRITE_ONCE(temp->mid_state, MID_REQUEST_ALLOCATED);
 	trace_smb3_cmd_enter(le32_to_cpu(shdr->Id.SyncId.TreeId),
 			     le64_to_cpu(shdr->SessionId),
 			     le16_to_cpu(shdr->Command), temp->mid);
 	return temp;
 }
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index a61ba7f3fb86..28b5b7011017 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -31,12 +31,12 @@
 #include "compress.h"
 
 void
 cifs_wake_up_task(struct mid_q_entry *mid)
 {
-	if (mid->mid_state == MID_RESPONSE_RECEIVED)
-		mid->mid_state = MID_RESPONSE_READY;
+	if (READ_ONCE(mid->mid_state) == MID_RESPONSE_RECEIVED)
+		WRITE_ONCE(mid->mid_state, MID_RESPONSE_READY);
 	wake_up_process(mid->callback_data);
 }
 
 void __release_mid(struct kref *refcount)
 {
@@ -47,18 +47,19 @@ void __release_mid(struct kref *refcount)
 	__u16 smb_cmd = le16_to_cpu(midEntry->command);
 	unsigned long now;
 	unsigned long roundtrip_time;
 #endif
 	struct TCP_Server_Info *server = midEntry->server;
+	int mid_state = READ_ONCE(midEntry->mid_state);
 
 	if (midEntry->resp_buf && (midEntry->wait_cancelled) &&
-	    (midEntry->mid_state == MID_RESPONSE_RECEIVED ||
-	     midEntry->mid_state == MID_RESPONSE_READY) &&
+	    (mid_state == MID_RESPONSE_RECEIVED ||
+	     mid_state == MID_RESPONSE_READY) &&
 	    server->ops->handle_cancelled_mid)
 		server->ops->handle_cancelled_mid(midEntry, server);
 
-	midEntry->mid_state = MID_FREE;
+	WRITE_ONCE(midEntry->mid_state, MID_FREE);
 	atomic_dec(&mid_count);
 	if (midEntry->large_buf)
 		cifs_buf_release(midEntry->resp_buf);
 	else
 		cifs_small_buf_release(midEntry->resp_buf);
@@ -631,17 +632,24 @@ cifs_wait_mtu_credits(struct TCP_Server_Info *server, size_t size,
 	credits->value = 0;
 	credits->instance = server->reconnect_instance;
 	return 0;
 }
 
+static inline bool cifs_mid_response_ready(struct mid_q_entry *mid)
+{
+	int mid_state = READ_ONCE(mid->mid_state);
+
+	return (mid_state != MID_REQUEST_SUBMITTED &&
+		mid_state != MID_RESPONSE_RECEIVED);
+}
+
 int wait_for_response(struct TCP_Server_Info *server, struct mid_q_entry *midQ)
 {
 	int error;
 
 	error = wait_event_state(server->response_q,
-				 midQ->mid_state != MID_REQUEST_SUBMITTED &&
-				 midQ->mid_state != MID_RESPONSE_RECEIVED,
+				 cifs_mid_response_ready(midQ),
 				 (TASK_KILLABLE|TASK_FREEZABLE_UNSAFE));
 	if (error < 0)
 		return -ERESTARTSYS;
 
 	return 0;
@@ -696,11 +704,11 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 
 	mid->receive = receive;
 	mid->callback = callback;
 	mid->callback_data = cbdata;
 	mid->handle = handle;
-	mid->mid_state = MID_REQUEST_SUBMITTED;
+	WRITE_ONCE(mid->mid_state, MID_REQUEST_SUBMITTED);
 
 	/* put it on the pending_mid_q */
 	spin_lock(&server->mid_queue_lock);
 	list_add_tail(&mid->qhead, &server->pending_mid_q);
 	spin_unlock(&server->mid_queue_lock);
@@ -728,18 +736,17 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
 }
 
 int cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 {
 	int rc = 0;
+	int state = READ_ONCE(mid->mid_state);
 
 	cifs_dbg(FYI, "%s: cmd=%d mid=%llu state=%d\n",
-		 __func__, le16_to_cpu(mid->command), mid->mid, mid->mid_state);
+		 __func__, le16_to_cpu(mid->command), mid->mid, state);
 
-	spin_lock(&server->mid_queue_lock);
-	switch (mid->mid_state) {
+	switch (state) {
 	case MID_RESPONSE_READY:
-		spin_unlock(&server->mid_queue_lock);
 		return rc;
 	case MID_RETRY_NEEDED:
 		rc = -EAGAIN;
 		break;
 	case MID_RESPONSE_MALFORMED:
@@ -750,21 +757,21 @@ int cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server
 		break;
 	case MID_RC:
 		rc = mid->mid_rc;
 		break;
 	default:
+		spin_lock(&server->mid_queue_lock);
 		if (mid->deleted_from_q == false) {
 			list_del_init(&mid->qhead);
 			mid->deleted_from_q = true;
 		}
 		spin_unlock(&server->mid_queue_lock);
 		cifs_server_dbg(VFS, "%s: invalid mid state mid=%llu state=%d\n",
-			 __func__, mid->mid, mid->mid_state);
+			 __func__, mid->mid, state);
 		rc = -EIO;
 		goto sync_mid_done;
 	}
-	spin_unlock(&server->mid_queue_lock);
 
 sync_mid_done:
 	release_mid(mid);
 	return rc;
 }
@@ -778,12 +785,12 @@ cifs_compound_callback(struct mid_q_entry *mid)
 		.instance = server->reconnect_instance,
 	};
 
 	add_credits(server, &credits, mid->optype);
 
-	if (mid->mid_state == MID_RESPONSE_RECEIVED)
-		mid->mid_state = MID_RESPONSE_READY;
+	if (READ_ONCE(mid->mid_state) == MID_RESPONSE_RECEIVED)
+		WRITE_ONCE(mid->mid_state, MID_RESPONSE_READY);
 }
 
 static void
 cifs_compound_last_callback(struct mid_q_entry *mid)
 {
@@ -936,11 +943,11 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 			for (j = 0; j < num_rqst; j++)
 				add_credits(server, &credits[j], optype);
 			return PTR_ERR(midQ[i]);
 		}
 
-		midQ[i]->mid_state = MID_REQUEST_SUBMITTED;
+		WRITE_ONCE(midQ[i]->mid_state, MID_REQUEST_SUBMITTED);
 		midQ[i]->optype = optype;
 		/*
 		 * Invoke callback for every part of the compound chain
 		 * to calculate credits properly. Wake up this thread only when
 		 * the last element is received.
@@ -1026,11 +1033,11 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 			cancelled_mid[i] = true;
 			goto out;
 		}
 
 		if (!midQ[i]->resp_buf ||
-		    midQ[i]->mid_state != MID_RESPONSE_READY) {
+		    READ_ONCE(midQ[i]->mid_state) != MID_RESPONSE_READY) {
 			rc = -EIO;
 			cifs_dbg(FYI, "Bad MID state?\n");
 			goto out;
 		}
 
-- 
2.39.2

