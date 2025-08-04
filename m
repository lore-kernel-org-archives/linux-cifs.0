Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40AF426E712;
	Mon,  4 Aug 2025 13:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754315253; cv=none; b=JHlcxaOyQqhzKafSkqnWUXCUDcLAsGZqzbuDOh+lCiszLrxWGIKUT4uYu3HjOHXkllmxgMyzekkk4rXJcLp/NMtFVP7znTCnVCORI1kBVMaSpMwP71v9RqwdBFLTEaMChrLE3fyI91Y5kH6Oa0gJmBVNlefK/PB1+7x9YmQUk2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754315253; c=relaxed/simple;
	bh=OHchsDxfLI6H/RcBK530VV2th9TllWlysNrU6v5xvU4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QqGCYxtKjIDC/thQF39tu/jcXZb+eMX2PbBae8h6WS0/6LEw4GmW0T5/dCwm8519w5qjXbMLVjsnOcRfm2MQxZfAT6kyg/Ek0VWhdpIc7Mb8ggLDyUKmUQV+pH0xlG4Bht/2WEr0AR8NUZjI/GrNq7l40tVLrCcCjajbBilj/UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bwdCZ2l5KzYQv6Y;
	Mon,  4 Aug 2025 21:47:22 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0B3691A0B97;
	Mon,  4 Aug 2025 21:47:21 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHgxPjuZBoXT8zCg--.8001S6;
	Mon, 04 Aug 2025 21:47:20 +0800 (CST)
From: Wang Zhaolong <wangzhaolong@huaweicloud.com>
To: sfrench@samba.org,
	pshilov@microsoft.com
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	chengzhihao1@huawei.com,
	wangzhaolong@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH 2/4] smb: client: add mid_counter_lock to protect the mid counter counter
Date: Mon,  4 Aug 2025 21:40:04 +0800
Message-Id: <20250804134006.3609555-3-wangzhaolong@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250804134006.3609555-1-wangzhaolong@huaweicloud.com>
References: <20250804134006.3609555-1-wangzhaolong@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHgxPjuZBoXT8zCg--.8001S6
X-Coremail-Antispam: 1UD129KBjvAXoW3ury5tFW7Jw4Dtw1kCw47twb_yoW8Ar15Go
	Wvqw13uw4UJryUKr98trn3JF1xX348tFWUJFWjqF1Uua4Fk34UAa48Zr15tFWa93y5tr4Y
	v3yxJa97uas3Ja97n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUYE7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20EY4v20xva
	j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r15M28IrcIa0x
	kI8VCY1x0267AKxVW8JVW5JwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84AC
	jcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr
	1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1l
	e2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI
	8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwAC
	jcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_Jw0_GF
	yl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWU
	JVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7V
	AKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42
	IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUj5Ef7UUUUU=
	=
X-CM-SenderInfo: pzdqw6xkdrz0tqj6x35dzhxuhorxvhhfrp/

This is step 2/4 of a patch series to fix mid_q_entry memory leaks
caused by race conditions in callback execution.

Add a dedicated mid_counter_lock to protect current_mid counter,
separating it from mid_queue_lock which protects pending_mid_q
operations. This reduces lock contention and prepares for finer-
grained locking in subsequent patches.

Changes:
- Add TCP_Server_Info->mid_counter_lock spinlock
- Rename CurrentMid to current_mid for consistency
- Use mid_counter_lock to protect current_mid access
- Update locking documentation in cifsglob.h

This separation allows mid allocation to proceed without blocking
queue operations, improving performance under heavy load.

Signed-off-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
---
 fs/smb/client/cifsglob.h  |  5 +++--
 fs/smb/client/connect.c   |  5 +++--
 fs/smb/client/smb1ops.c   | 11 ++++++-----
 fs/smb/client/smb2ops.c   | 40 +++++++++++++++++++--------------------
 fs/smb/client/transport.c | 12 ++++++------
 5 files changed, 38 insertions(+), 35 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index ecd568793ce7..1844afdf1e41 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -731,10 +731,11 @@ struct TCP_Server_Info {
 	struct net *net;
 #endif
 	wait_queue_head_t response_q;
 	wait_queue_head_t request_q; /* if more than maxmpx to srvr must block*/
 	spinlock_t mid_queue_lock;  /* protect mid queue */
+	spinlock_t mid_counter_lock;
 	struct list_head pending_mid_q;
 	bool noblocksnd;		/* use blocking sendmsg */
 	bool noautotune;		/* do not autotune send buf sizes */
 	bool nosharesock;
 	bool tcp_nodelay;
@@ -768,11 +769,11 @@ struct TCP_Server_Info {
 	unsigned int max_rw;	/* maxRw specifies the maximum */
 	/* message size the server can send or receive for */
 	/* SMB_COM_WRITE_RAW or SMB_COM_READ_RAW. */
 	unsigned int capabilities; /* selective disabling of caps by smb sess */
 	int timeAdj;  /* Adjust for difference in server time zone in sec */
-	__u64 CurrentMid;         /* multiplex id - rotating counter, protected by GlobalMid_Lock */
+	__u64 current_mid;	/* multiplex id - rotating counter, protected by mid_counter_lock */
 	char cryptkey[CIFS_CRYPTO_KEY_SIZE]; /* used by ntlm, ntlmv2 etc */
 	/* 16th byte of RFC1001 workstation name is always null */
 	char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
 	__u32 sequence_number; /* for signing, protected by srv_mutex */
 	__u32 reconnect_instance; /* incremented on each reconnect */
@@ -2006,12 +2007,12 @@ require use of the stronger protocol */
  * GlobalMid_Lock		GlobalMaxActiveXid		init_cifs
  *				GlobalCurrentXid
  *				GlobalTotalActiveXid
  * TCP_Server_Info->srv_lock	(anything in struct not protected by another lock and can change)
  * TCP_Server_Info->mid_queue_lock	TCP_Server_Info->pending_mid_q	cifs_get_tcp_session
- *				->CurrentMid
  *				(any changes in mid_q_entry fields)
+ * TCP_Server_Info->mid_counter_lock    TCP_Server_Info->current_mid    cifs_get_tcp_session
  * TCP_Server_Info->req_lock	TCP_Server_Info->in_flight	cifs_get_tcp_session
  *				->credits
  *				->echo_credits
  *				->oplock_credits
  *				->reconnect_instance
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index e4b577ca48d5..74ad5881ee45 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -356,11 +356,11 @@ static bool cifs_tcp_ses_needs_reconnect(struct TCP_Server_Info *server, int num
 		wake_up(&server->response_q);
 		return false;
 	}
 
 	cifs_dbg(FYI, "Mark tcp session as need reconnect\n");
-	trace_smb3_reconnect(server->CurrentMid, server->conn_id,
+	trace_smb3_reconnect(server->current_mid, server->conn_id,
 			     server->hostname);
 	server->tcpStatus = CifsNeedReconnect;
 
 	spin_unlock(&server->srv_lock);
 	return true;
@@ -1240,11 +1240,11 @@ smb2_add_credits_from_hdr(char *buffer, struct TCP_Server_Info *server)
 		scredits = server->credits;
 		in_flight = server->in_flight;
 		spin_unlock(&server->req_lock);
 		wake_up(&server->request_q);
 
-		trace_smb3_hdr_credits(server->CurrentMid,
+		trace_smb3_hdr_credits(server->current_mid,
 				server->conn_id, server->hostname, scredits,
 				le16_to_cpu(shdr->CreditRequest), in_flight);
 		cifs_server_dbg(FYI, "%s: added %u credits total=%d\n",
 				__func__, le16_to_cpu(shdr->CreditRequest),
 				scredits);
@@ -1821,10 +1821,11 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
 	tcp_ses->lstrp = jiffies;
 	tcp_ses->compression.requested = ctx->compress;
 	spin_lock_init(&tcp_ses->req_lock);
 	spin_lock_init(&tcp_ses->srv_lock);
 	spin_lock_init(&tcp_ses->mid_queue_lock);
+	spin_lock_init(&tcp_ses->mid_counter_lock);
 	INIT_LIST_HEAD(&tcp_ses->tcp_ses_list);
 	INIT_LIST_HEAD(&tcp_ses->smb_ses_list);
 	INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);
 	INIT_DELAYED_WORK(&tcp_ses->reconnect, smb2_reconnect_server);
 	mutex_init(&tcp_ses->reconnect_mutex);
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index a1442f697706..13f600a3d0c4 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -167,14 +167,13 @@ cifs_get_next_mid(struct TCP_Server_Info *server)
 {
 	__u64 mid = 0;
 	__u16 last_mid, cur_mid;
 	bool collision, reconnect = false;
 
-	spin_lock(&server->mid_queue_lock);
-
+	spin_lock(&server->mid_counter_lock);
 	/* mid is 16 bit only for CIFS/SMB */
-	cur_mid = (__u16)((server->CurrentMid) & 0xffff);
+	cur_mid = (__u16)((server->current_mid) & 0xffff);
 	/* we do not want to loop forever */
 	last_mid = cur_mid;
 	cur_mid++;
 	/* avoid 0xFFFF MID */
 	if (cur_mid == 0xffff)
@@ -196,19 +195,21 @@ cifs_get_next_mid(struct TCP_Server_Info *server)
 		collision = false;
 		if (cur_mid == 0)
 			cur_mid++;
 
 		num_mids = 0;
+		spin_lock(&server->mid_queue_lock);
 		list_for_each_entry(mid_entry, &server->pending_mid_q, qhead) {
 			++num_mids;
 			if (mid_entry->mid == cur_mid &&
 			    mid_entry->mid_state == MID_REQUEST_SUBMITTED) {
 				/* This mid is in use, try a different one */
 				collision = true;
 				break;
 			}
 		}
+		spin_unlock(&server->mid_queue_lock);
 
 		/*
 		 * if we have more than 32k mids in the list, then something
 		 * is very wrong. Possibly a local user is trying to DoS the
 		 * box by issuing long-running calls and SIGKILL'ing them. If
@@ -221,16 +222,16 @@ cifs_get_next_mid(struct TCP_Server_Info *server)
 		if (num_mids > 32768)
 			reconnect = true;
 
 		if (!collision) {
 			mid = (__u64)cur_mid;
-			server->CurrentMid = mid;
+			server->current_mid = mid;
 			break;
 		}
 		cur_mid++;
 	}
-	spin_unlock(&server->mid_queue_lock);
+	spin_unlock(&server->mid_counter_lock);
 
 	if (reconnect) {
 		cifs_signal_cifsd_for_reconnect(server, false);
 	}
 
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index c714707249c7..da2cb9585404 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -89,11 +89,11 @@ smb2_add_credits(struct TCP_Server_Info *server,
 		reconnect_detected = true;
 
 	if (*val > 65000) {
 		*val = 65000; /* Don't get near 64K credits, avoid srv bugs */
 		pr_warn_once("server overflowed SMB3 credits\n");
-		trace_smb3_overflow_credits(server->CurrentMid,
+		trace_smb3_overflow_credits(server->current_mid,
 					    server->conn_id, server->hostname, *val,
 					    add, server->in_flight);
 	}
 	if (credits->in_flight_check > 1) {
 		pr_warn_once("rreq R=%08x[%x] Credits not in flight\n",
@@ -134,19 +134,19 @@ smb2_add_credits(struct TCP_Server_Info *server,
 	in_flight = server->in_flight;
 	spin_unlock(&server->req_lock);
 	wake_up(&server->request_q);
 
 	if (reconnect_detected) {
-		trace_smb3_reconnect_detected(server->CurrentMid,
+		trace_smb3_reconnect_detected(server->current_mid,
 			server->conn_id, server->hostname, scredits, add, in_flight);
 
 		cifs_dbg(FYI, "trying to put %d credits from the old server instance %d\n",
 			 add, instance);
 	}
 
 	if (reconnect_with_invalid_credits) {
-		trace_smb3_reconnect_with_invalid_credits(server->CurrentMid,
+		trace_smb3_reconnect_with_invalid_credits(server->current_mid,
 			server->conn_id, server->hostname, scredits, add, in_flight);
 		cifs_dbg(FYI, "Negotiate operation when server credits is non-zero. Optype: %d, server credits: %d, credits added: %d\n",
 			 optype, scredits, add);
 	}
 
@@ -174,11 +174,11 @@ smb2_add_credits(struct TCP_Server_Info *server,
 	default:
 		/* change_conf rebalanced credits for different types */
 		break;
 	}
 
-	trace_smb3_add_credits(server->CurrentMid,
+	trace_smb3_add_credits(server->current_mid,
 			server->conn_id, server->hostname, scredits, add, in_flight);
 	cifs_dbg(FYI, "%s: added %u credits total=%d\n", __func__, add, scredits);
 }
 
 static void
@@ -201,11 +201,11 @@ smb2_set_credits(struct TCP_Server_Info *server, const int val)
 	}
 	scredits = server->credits;
 	in_flight = server->in_flight;
 	spin_unlock(&server->req_lock);
 
-	trace_smb3_set_credits(server->CurrentMid,
+	trace_smb3_set_credits(server->current_mid,
 			server->conn_id, server->hostname, scredits, val, in_flight);
 	cifs_dbg(FYI, "%s: set %u credits\n", __func__, val);
 
 	/* don't log while holding the lock */
 	if (val == 1)
@@ -286,11 +286,11 @@ smb2_wait_mtu_credits(struct TCP_Server_Info *server, size_t size,
 	}
 	scredits = server->credits;
 	in_flight = server->in_flight;
 	spin_unlock(&server->req_lock);
 
-	trace_smb3_wait_credits(server->CurrentMid,
+	trace_smb3_wait_credits(server->current_mid,
 			server->conn_id, server->hostname, scredits, -(credits->value), in_flight);
 	cifs_dbg(FYI, "%s: removed %u credits total=%d\n",
 			__func__, credits->value, scredits);
 
 	return rc;
@@ -314,11 +314,11 @@ smb2_adjust_credits(struct TCP_Server_Info *server,
 				      subreq->subreq.debug_index,
 				      credits->value,
 				      server->credits, server->in_flight,
 				      new_val - credits->value,
 				      cifs_trace_rw_credits_no_adjust_up);
-		trace_smb3_too_many_credits(server->CurrentMid,
+		trace_smb3_too_many_credits(server->current_mid,
 				server->conn_id, server->hostname, 0, credits->value - new_val, 0);
 		cifs_server_dbg(VFS, "R=%x[%x] request has less credits (%d) than required (%d)",
 				subreq->rreq->debug_id, subreq->subreq.debug_index,
 				credits->value, new_val);
 
@@ -336,11 +336,11 @@ smb2_adjust_credits(struct TCP_Server_Info *server,
 				      subreq->subreq.debug_index,
 				      credits->value,
 				      server->credits, server->in_flight,
 				      new_val - credits->value,
 				      cifs_trace_rw_credits_old_session);
-		trace_smb3_reconnect_detected(server->CurrentMid,
+		trace_smb3_reconnect_detected(server->current_mid,
 			server->conn_id, server->hostname, scredits,
 			credits->value - new_val, in_flight);
 		cifs_server_dbg(VFS, "R=%x[%x] trying to return %d credits to old session\n",
 				subreq->rreq->debug_id, subreq->subreq.debug_index,
 				credits->value - new_val);
@@ -356,11 +356,11 @@ smb2_adjust_credits(struct TCP_Server_Info *server,
 	scredits = server->credits;
 	in_flight = server->in_flight;
 	spin_unlock(&server->req_lock);
 	wake_up(&server->request_q);
 
-	trace_smb3_adj_credits(server->CurrentMid,
+	trace_smb3_adj_credits(server->current_mid,
 			server->conn_id, server->hostname, scredits,
 			credits->value - new_val, in_flight);
 	cifs_dbg(FYI, "%s: adjust added %u credits total=%d\n",
 			__func__, credits->value - new_val, scredits);
 
@@ -372,23 +372,23 @@ smb2_adjust_credits(struct TCP_Server_Info *server,
 static __u64
 smb2_get_next_mid(struct TCP_Server_Info *server)
 {
 	__u64 mid;
 	/* for SMB2 we need the current value */
-	spin_lock(&server->mid_queue_lock);
-	mid = server->CurrentMid++;
-	spin_unlock(&server->mid_queue_lock);
+	spin_lock(&server->mid_counter_lock);
+	mid = server->current_mid++;
+	spin_unlock(&server->mid_counter_lock);
 	return mid;
 }
 
 static void
 smb2_revert_current_mid(struct TCP_Server_Info *server, const unsigned int val)
 {
-	spin_lock(&server->mid_queue_lock);
-	if (server->CurrentMid >= val)
-		server->CurrentMid -= val;
-	spin_unlock(&server->mid_queue_lock);
+	spin_lock(&server->mid_counter_lock);
+	if (server->current_mid >= val)
+		server->current_mid -= val;
+	spin_unlock(&server->mid_counter_lock);
 }
 
 static struct mid_q_entry *
 __smb2_find_mid(struct TCP_Server_Info *server, char *buf, bool dequeue)
 {
@@ -458,13 +458,13 @@ smb2_negotiate(const unsigned int xid,
 	       struct cifs_ses *ses,
 	       struct TCP_Server_Info *server)
 {
 	int rc;
 
-	spin_lock(&server->mid_queue_lock);
-	server->CurrentMid = 0;
-	spin_unlock(&server->mid_queue_lock);
+	spin_lock(&server->mid_counter_lock);
+	server->current_mid = 0;
+	spin_unlock(&server->mid_counter_lock);
 	rc = SMB2_negotiate(xid, ses, server);
 	return rc;
 }
 
 static inline unsigned int
@@ -2496,11 +2496,11 @@ smb2_is_status_pending(char *buf, struct TCP_Server_Info *server)
 		scredits = server->credits;
 		in_flight = server->in_flight;
 		spin_unlock(&server->req_lock);
 		wake_up(&server->request_q);
 
-		trace_smb3_pend_credits(server->CurrentMid,
+		trace_smb3_pend_credits(server->current_mid,
 				server->conn_id, server->hostname, scredits,
 				le16_to_cpu(shdr->CreditRequest), in_flight);
 		cifs_dbg(FYI, "%s: status pending add %u credits total=%d\n",
 				__func__, le16_to_cpu(shdr->CreditRequest), scredits);
 	}
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 12dc927aa4a2..8037accc3987 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -395,11 +395,11 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 		 * If we have only sent part of an SMB then the next SMB could
 		 * be taken as the remainder of this one. We need to kill the
 		 * socket so the server throws away the partial SMB
 		 */
 		cifs_signal_cifsd_for_reconnect(server, false);
-		trace_smb3_partial_send_reconnect(server->CurrentMid,
+		trace_smb3_partial_send_reconnect(server->current_mid,
 						  server->conn_id, server->hostname);
 	}
 smbd_done:
 	/*
 	 * there's hardly any use for the layers above to know the
@@ -507,11 +507,11 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int num_credits,
 		*instance = server->reconnect_instance;
 		scredits = *credits;
 		in_flight = server->in_flight;
 		spin_unlock(&server->req_lock);
 
-		trace_smb3_nblk_credits(server->CurrentMid,
+		trace_smb3_nblk_credits(server->current_mid,
 				server->conn_id, server->hostname, scredits, -1, in_flight);
 		cifs_dbg(FYI, "%s: remove %u credits total=%d\n",
 				__func__, 1, scredits);
 
 		return 0;
@@ -540,11 +540,11 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int num_credits,
 				spin_lock(&server->req_lock);
 				scredits = *credits;
 				in_flight = server->in_flight;
 				spin_unlock(&server->req_lock);
 
-				trace_smb3_credit_timeout(server->CurrentMid,
+				trace_smb3_credit_timeout(server->current_mid,
 						server->conn_id, server->hostname, scredits,
 						num_credits, in_flight);
 				cifs_server_dbg(VFS, "wait timed out after %d ms\n",
 						timeout);
 				return -EBUSY;
@@ -583,11 +583,11 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int num_credits,
 					scredits = *credits;
 					in_flight = server->in_flight;
 					spin_unlock(&server->req_lock);
 
 					trace_smb3_credit_timeout(
-							server->CurrentMid,
+							server->current_mid,
 							server->conn_id, server->hostname,
 							scredits, num_credits, in_flight);
 					cifs_server_dbg(VFS, "wait timed out after %d ms\n",
 							timeout);
 					return -EBUSY;
@@ -613,11 +613,11 @@ wait_for_free_credits(struct TCP_Server_Info *server, const int num_credits,
 			}
 			scredits = *credits;
 			in_flight = server->in_flight;
 			spin_unlock(&server->req_lock);
 
-			trace_smb3_waitff_credits(server->CurrentMid,
+			trace_smb3_waitff_credits(server->current_mid,
 					server->conn_id, server->hostname, scredits,
 					-(num_credits), in_flight);
 			cifs_dbg(FYI, "%s: remove %u credits total=%d\n",
 					__func__, num_credits, scredits);
 			break;
@@ -664,11 +664,11 @@ wait_for_compound_request(struct TCP_Server_Info *server, int num,
 		 * Return immediately if no requests in flight since we will be
 		 * stuck on waiting for credits.
 		 */
 		if (server->in_flight == 0) {
 			spin_unlock(&server->req_lock);
-			trace_smb3_insufficient_credits(server->CurrentMid,
+			trace_smb3_insufficient_credits(server->current_mid,
 					server->conn_id, server->hostname, scredits,
 					num, in_flight);
 			cifs_dbg(FYI, "%s: %d requests in flight, needed %d total=%d\n",
 					__func__, in_flight, num, scredits);
 			return -EDEADLK;
-- 
2.39.2

