Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8221FE461;
	Mon, 11 Aug 2025 14:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754921723; cv=none; b=Z2L2URM+XxY5b1EbOhrUN3d9+WU1H4BnRlSwNr7AIky6S0qMJBbe8l5RNp4ZsSC7zAvylHGMak4gUAtTTJWovS06JKGi5itCxX4Q7aD5yIDsRzFKhWgI2PkLAaZMY4wHXTavGm+s4xFNgUhm2RZJ9eO/rrxOmStHiEWtRvpMO9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754921723; c=relaxed/simple;
	bh=AlkAyxu1JrupushGlvmKYTy08dYbf7Sm/lANXNsdYiY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=b4sKrlPiuPjclwDTJ3t6wvabq6KIhsKaytLPuKW2Vqdugd5LX9jLYK7IIZ8M8DBH1QMjQIes1iY9f4g7u943yNzeHupCYo4mGias5yffUBm2Q+CPYTUmg1A0U2n0kCLf0/RdN22htUBcHU7HpdMFGi/+anALOSzt1DE5QiKEEe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4c0xVZ2rMwzYQvBs;
	Mon, 11 Aug 2025 22:15:18 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 09B1A1A14F2;
	Mon, 11 Aug 2025 22:15:17 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgBXIBHw+plocdNUDQ--.57266S5;
	Mon, 11 Aug 2025 22:15:14 +0800 (CST)
From: Wang Zhaolong <wangzhaolong@huaweicloud.com>
To: sfrench@samba.org,
	pshilov@microsoft.com
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	chengzhihao1@huawei.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH V3 1/2] smb: client: fix mid_q_entry memleak leak with per-mid locking
Date: Mon, 11 Aug 2025 22:07:37 +0800
Message-Id: <20250811140738.1141817-2-wangzhaolong@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgBXIBHw+plocdNUDQ--.57266S5
X-Coremail-Antispam: 1UD129KBjvJXoW3uw4DZrWxKw13KFWkJr4rGrg_yoWkZr1kpa
	n0q343Gr1rXFn7ZwnrJ3WDu3WrArs5u3W3G3yxGr1ayFZrurn8WryDKryq9FW3Crs0g3sI
	9w4jywsIv3WDX3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Kb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_JFI_Gr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr4
	1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
	67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
	8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAv
	wI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
	v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU7qjgUUUUU
X-CM-SenderInfo: pzdqw6xkdrz0tqj6x35dzhxuhorxvhhfrp/

This is step 4/4 of a patch series to fix mid_q_entry memory leaks
caused by race conditions in callback execution.

In compound_send_recv(), when wait_for_response() is interrupted by
signals, the code attempts to cancel pending requests by changing
their callbacks to cifs_cancelled_callback. However, there's a race
condition between signal interruption and network response processing
that causes both mid_q_entry and server buffer leaks:

```
User foreground process                    cifsd
cifs_readdir
 open_cached_dir
  cifs_send_recv
   compound_send_recv
    smb2_setup_request
     smb2_mid_entry_alloc
      smb2_get_mid_entry
       smb2_mid_entry_alloc
        mempool_alloc // alloc mid
        kref_init(&temp->refcount); // refcount = 1
     mid[0]->callback = cifs_compound_callback;
     mid[1]->callback = cifs_compound_last_callback;
     smb_send_rqst
     rc = wait_for_response
      wait_event_state TASK_KILLABLE
                                  cifs_demultiplex_thread
                                    allocate_buffers
                                      server->bigbuf = cifs_buf_get()
                                    standard_receive3
                                      ->find_mid()
                                        smb2_find_mid
                                          __smb2_find_mid
                                           kref_get(&mid->refcount) // +1
                                      cifs_handle_standard
                                        handle_mid
                                         /* bigbuf will also leak */
                                         mid->resp_buf = server->bigbuf
                                         server->bigbuf = NULL;
                                         dequeue_mid
                                     /* in for loop */
                                    mids[0]->callback
                                      cifs_compound_callback
    /* Signal interrupts wait: rc = -ERESTARTSYS */
    /* if (... || midQ[i]->mid_state == MID_RESPONSE_RECEIVED) *?
    midQ[0]->callback = cifs_cancelled_callback;
    cancelled_mid[i] = true;
                                       /* The change comes too late */
                                       mid->mid_state = MID_RESPONSE_READY
                                    release_mid  // -1
    /* cancelled_mid[i] == true causes mid won't be released
       in compound_send_recv cleanup */
    /* cifs_cancelled_callback won't executed to release mid */
```

The root cause is that there's a race between callback assignment and
execution.

Fix this by introducing per-mid locking:

- Add spinlock_t mid_lock to struct mid_q_entry
- Add mid_execute_callback() for atomic callback execution
- Use mid_lock in cancellation paths to ensure atomicity

This ensures that either the original callback or the cancellation
callback executes atomically, preventing reference count leaks when
requests are interrupted by signals.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220404
Fixes: ee258d79159a ("CIFS: Move credit processing to mid callbacks for SMB3")
Signed-off-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>

Signed-off-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
---
 fs/smb/client/cifsglob.h      | 21 +++++++++++++++++++++
 fs/smb/client/cifstransport.c | 19 +++++++++----------
 fs/smb/client/connect.c       |  8 ++++----
 fs/smb/client/smb2ops.c       |  4 ++--
 fs/smb/client/smb2transport.c |  1 +
 fs/smb/client/transport.c     |  7 +++----
 6 files changed, 40 insertions(+), 20 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index e6830ab3a546..1e64a4fb6af0 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1730,10 +1730,11 @@ struct mid_q_entry {
 	unsigned int resp_buf_size;
 	int mid_state;	/* wish this were enum but can not pass to wait_event */
 	int mid_rc;		/* rc for MID_RC */
 	__le16 command;		/* smb command code */
 	unsigned int optype;	/* operation type */
+	spinlock_t mid_lock;
 	bool wait_cancelled:1;  /* Cancelled while waiting for response */
 	bool deleted_from_q:1;  /* Whether Mid has been dequeued frem pending_mid_q */
 	bool large_buf:1;	/* if valid response, is pointer to large buf */
 	bool multiRsp:1;	/* multiple trans2 responses for one request  */
 	bool multiEnd:1;	/* both received */
@@ -2034,10 +2035,13 @@ require use of the stronger protocol */
  *								init_cached_dir
  * cifsFileInfo->fh_mutex	cifsFileInfo			cifs_new_fileinfo
  * cifsFileInfo->file_info_lock	cifsFileInfo->count		cifs_new_fileinfo
  *				->invalidHandle			initiate_cifs_search
  *				->oplock_break_cancelled
+ * mid_q_entry->mid_lock	mid_q_entry->callback           alloc_mid
+ *								smb2_mid_entry_alloc
+ *				(Any fields of mid_q_entry that will need protection)
  ****************************************************************************/
 
 #ifdef DECLARE_GLOBALS_HERE
 #define GLOBAL_EXTERN
 #else
@@ -2373,10 +2377,27 @@ static inline bool cifs_netbios_name(const char *name, size_t namelen)
 		}
 	}
 	return ret;
 }
 
+/*
+ * Execute mid callback atomically - ensures callback runs exactly once
+ * and prevents sleeping in atomic context.
+ */
+static inline void mid_execute_callback(struct mid_q_entry *mid)
+{
+	void (*callback)(struct mid_q_entry *mid);
+
+	spin_lock(&mid->mid_lock);
+	callback = mid->callback;
+	mid->callback = NULL;  /* Mark as executed, */
+	spin_unlock(&mid->mid_lock);
+
+	if (callback)
+		callback(mid);
+}
+
 #define CIFS_REPARSE_SUPPORT(tcon) \
 	((tcon)->posix_extensions || \
 	 (le32_to_cpu((tcon)->fsAttrInfo.Attributes) & \
 	  FILE_SUPPORTS_REPARSE_POINTS))
 
diff --git a/fs/smb/client/cifstransport.c b/fs/smb/client/cifstransport.c
index 352dafb888dd..e98b95eff8c9 100644
--- a/fs/smb/client/cifstransport.c
+++ b/fs/smb/client/cifstransport.c
@@ -44,10 +44,11 @@ alloc_mid(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 	}
 
 	temp = mempool_alloc(cifs_mid_poolp, GFP_NOFS);
 	memset(temp, 0, sizeof(struct mid_q_entry));
 	kref_init(&temp->refcount);
+	spin_lock_init(&temp->mid_lock);
 	temp->mid = get_mid(smb_buffer);
 	temp->pid = current->pid;
 	temp->command = cpu_to_le16(smb_buffer->Command);
 	cifs_dbg(FYI, "For smb_command %d\n", smb_buffer->Command);
 	/* easier to use jiffies */
@@ -343,20 +344,19 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 		goto out;
 
 	rc = wait_for_response(server, midQ);
 	if (rc != 0) {
 		send_cancel(server, &rqst, midQ);
-		spin_lock(&server->mid_queue_lock);
-		if (midQ->mid_state == MID_REQUEST_SUBMITTED ||
-		    midQ->mid_state == MID_RESPONSE_RECEIVED) {
+		spin_lock(&midQ->mid_lock);
+		if (midQ->callback) {
 			/* no longer considered to be "in-flight" */
 			midQ->callback = release_mid;
-			spin_unlock(&server->mid_queue_lock);
+			spin_unlock(&midQ->mid_lock);
 			add_credits(server, &credits, 0);
 			return rc;
 		}
-		spin_unlock(&server->mid_queue_lock);
+		spin_unlock(&midQ->mid_lock);
 	}
 
 	rc = cifs_sync_mid_result(midQ, server);
 	if (rc != 0) {
 		add_credits(server, &credits, 0);
@@ -525,19 +525,18 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 		}
 
 		rc = wait_for_response(server, midQ);
 		if (rc) {
 			send_cancel(server, &rqst, midQ);
-			spin_lock(&server->mid_queue_lock);
-			if (midQ->mid_state == MID_REQUEST_SUBMITTED ||
-			    midQ->mid_state == MID_RESPONSE_RECEIVED) {
+			spin_lock(&midQ->mid_lock);
+			if (midQ->callback) {
 				/* no longer considered to be "in-flight" */
 				midQ->callback = release_mid;
-				spin_unlock(&server->mid_queue_lock);
+				spin_unlock(&midQ->mid_lock);
 				return rc;
 			}
-			spin_unlock(&server->mid_queue_lock);
+			spin_unlock(&midQ->mid_lock);
 		}
 
 		/* We got the response - restart system call. */
 		rstart = 1;
 		spin_lock(&server->srv_lock);
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 587845a2452d..281ccbeea719 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -333,11 +333,11 @@ cifs_abort_connection(struct TCP_Server_Info *server)
 	cifs_server_unlock(server);
 
 	cifs_dbg(FYI, "%s: issuing mid callbacks\n", __func__);
 	list_for_each_entry_safe(mid, nmid, &retry_list, qhead) {
 		list_del_init(&mid->qhead);
-		mid->callback(mid);
+		mid_execute_callback(mid);
 		release_mid(mid);
 	}
 
 	if (cifs_rdma_enabled(server)) {
 		cifs_server_lock(server);
@@ -917,11 +917,11 @@ is_smb_response(struct TCP_Server_Info *server, unsigned char type)
 			 */
 			list_for_each_entry_safe(mid, nmid, &dispose_list, qhead) {
 				list_del_init(&mid->qhead);
 				mid->mid_rc = mid_rc;
 				mid->mid_state = MID_RC;
-				mid->callback(mid);
+				mid_execute_callback(mid);
 				release_mid(mid);
 			}
 
 			/*
 			 * If reconnect failed then wait two seconds. In most
@@ -1115,11 +1115,11 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
 		/* now walk dispose list and issue callbacks */
 		list_for_each_safe(tmp, tmp2, &dispose_list) {
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
 			cifs_dbg(FYI, "Callback mid %llu\n", mid_entry->mid);
 			list_del_init(&mid_entry->qhead);
-			mid_entry->callback(mid_entry);
+			mid_execute_callback(mid_entry);
 			release_mid(mid_entry);
 		}
 		/* 1/8th of sec is more than enough time for them to exit */
 		msleep(125);
 	}
@@ -1392,11 +1392,11 @@ cifs_demultiplex_thread(void *p)
 								"Share deleted. Reconnect needed");
 					}
 				}
 
 				if (!mids[i]->multiRsp || mids[i]->multiEnd)
-					mids[i]->callback(mids[i]);
+					mid_execute_callback(mids[i]);
 
 				release_mid(mids[i]);
 			} else if (server->ops->is_oplock_break &&
 				   server->ops->is_oplock_break(bufs[i],
 								server)) {
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index ad8947434b71..f7a0f1c81b43 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4803,19 +4803,19 @@ static void smb2_decrypt_offload(struct work_struct *work)
 #endif
 			if (dw->server->ops->is_network_name_deleted)
 				dw->server->ops->is_network_name_deleted(dw->buf,
 									 dw->server);
 
-			mid->callback(mid);
+			mid_execute_callback(mid);
 		} else {
 			spin_lock(&dw->server->srv_lock);
 			if (dw->server->tcpStatus == CifsNeedReconnect) {
 				spin_lock(&dw->server->mid_queue_lock);
 				mid->mid_state = MID_RETRY_NEEDED;
 				spin_unlock(&dw->server->mid_queue_lock);
 				spin_unlock(&dw->server->srv_lock);
-				mid->callback(mid);
+				mid_execute_callback(mid);
 			} else {
 				spin_lock(&dw->server->mid_queue_lock);
 				mid->mid_state = MID_REQUEST_SUBMITTED;
 				mid->deleted_from_q = false;
 				list_add_tail(&mid->qhead,
diff --git a/fs/smb/client/smb2transport.c b/fs/smb/client/smb2transport.c
index ff9ef7fcd010..bc0e92eb2b64 100644
--- a/fs/smb/client/smb2transport.c
+++ b/fs/smb/client/smb2transport.c
@@ -769,10 +769,11 @@ smb2_mid_entry_alloc(const struct smb2_hdr *shdr,
 	}
 
 	temp = mempool_alloc(cifs_mid_poolp, GFP_NOFS);
 	memset(temp, 0, sizeof(struct mid_q_entry));
 	kref_init(&temp->refcount);
+	spin_lock_init(&temp->mid_lock);
 	temp->mid = le64_to_cpu(shdr->MessageId);
 	temp->credits = credits > 0 ? credits : 1;
 	temp->pid = current->pid;
 	temp->command = shdr->Command; /* Always LE */
 	temp->when_alloc = jiffies;
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 32d528b4dd83..a61ba7f3fb86 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1003,19 +1003,18 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 	if (rc != 0) {
 		for (; i < num_rqst; i++) {
 			cifs_server_dbg(FYI, "Cancelling wait for mid %llu cmd: %d\n",
 				 midQ[i]->mid, le16_to_cpu(midQ[i]->command));
 			send_cancel(server, &rqst[i], midQ[i]);
-			spin_lock(&server->mid_queue_lock);
+			spin_lock(&midQ[i]->mid_lock);
 			midQ[i]->wait_cancelled = true;
-			if (midQ[i]->mid_state == MID_REQUEST_SUBMITTED ||
-			    midQ[i]->mid_state == MID_RESPONSE_RECEIVED) {
+			if (midQ[i]->callback) {
 				midQ[i]->callback = cifs_cancelled_callback;
 				cancelled_mid[i] = true;
 				credits[i].value = 0;
 			}
-			spin_unlock(&server->mid_queue_lock);
+			spin_unlock(&midQ[i]->mid_lock);
 		}
 	}
 
 	for (i = 0; i < num_rqst; i++) {
 		if (rc < 0)
-- 
2.39.2

