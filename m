Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2F21F2C45;
	Mon,  4 Aug 2025 13:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754315247; cv=none; b=jFy5QmuaJTU5HXsqMrnIAG6sqAMdSQusFQOftUk5MhFBaECk9aZPyyKn15h+nGf/OJp4A5W11aWX/Ouvvp9eQLfA5TwXTAArWmVHazYXqpQ+UGAJhZjZl9PYhPblW/4t6GpLnYPNSSWcIjWhq3r/l0XzNTiQuYE90KKFxN07GQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754315247; c=relaxed/simple;
	bh=sU1WSI6K0LVwwD59jB2LP5tJAS+FcxiDHZr8Oh6mGPU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=S5L6lQ06Z1A39GiSVwsnVrfBdkChowJ0Nyd6UrYrY+AnHWBQnv5th3qeOkRP2mz5sgoZkFPyGjVsKDKw/TPU8wTbAozhqla4wKB+bRi7d3DRSOlnkENW45R2fzllXUfFh+8LR+cc7LjCZsX8//B5uUJUzeCvAE0VMFcvk/5ShGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bwdCZ6NhZzKHMwF;
	Mon,  4 Aug 2025 21:47:22 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E136C1A0359;
	Mon,  4 Aug 2025 21:47:21 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAHgxPjuZBoXT8zCg--.8001S8;
	Mon, 04 Aug 2025 21:47:21 +0800 (CST)
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
Subject: [PATCH 4/4] smb: client: fix mid_q_entry memleak leak with per-mid locking
Date: Mon,  4 Aug 2025 21:40:06 +0800
Message-Id: <20250804134006.3609555-5-wangzhaolong@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAHgxPjuZBoXT8zCg--.8001S8
X-Coremail-Antispam: 1UD129KBjvAXoW3uw4DZrWfCF43GF45ZrykuFg_yoW8CryDuo
	Z7X3s5Zr4UWr92yFy0yFnxtFZ7XFyqgay7Zrs5Cr45Z3ZayFWjqryUtw45Jay5Zr48AwsI
	v3yxJFnYqa9rJrn5n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUOU7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20EY4v20xva
	j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r126s0DM28Irc
	Ia0xkI8VCY1x0267AKxVW5JVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l
	84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4UJV
	WxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE
	3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2I
	x0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8
	JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_Jw
	0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AK
	xVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrx
	kI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v2
	6r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJw
	CI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUbPC7UUU
	UUU==
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

The callback assignment (mid->callback = cifs_cancelled_callback) and
callback execution (mid->callback(mid)) are not atomic, allowing the
network thread to execute the old callback even after cancellation.

Solution:
Add per-mid locking to ensure atomic callback execution:

- Add spinlock_t mid_lock to struct mid_q_entry
- Protect mid_state, callback, and related fields with mid_lock
- Add mid_execute_callback() wrapper for safe callback execution
- Use mid_lock in compound_send_recv() cancellation logic

Key changes:
- Initialize mid_lock in alloc_mid() and smb2_mid_entry_alloc()
- Replace direct mid->callback() calls with mid_execute_callback()
- Protect all mid state changes with appropriate locks
- Update locking documentation

This ensures that either the original callback or the cancellation
callback executes atomically, preventing reference count leaks when
requests are interrupted by signals.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220404
Fixes: ee258d79159a ("CIFS: Move credit processing to mid callbacks for SMB3")
Signed-off-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
---
 fs/smb/client/cifs_debug.c    |  4 ++++
 fs/smb/client/cifsglob.h      |  5 +++++
 fs/smb/client/connect.c       | 22 ++++++++++++++++++----
 fs/smb/client/smb1ops.c       |  6 ++++++
 fs/smb/client/smb2ops.c       | 15 +++++++++------
 fs/smb/client/smb2transport.c |  1 +
 fs/smb/client/transport.c     | 29 ++++++++++++++++++-----------
 7 files changed, 61 insertions(+), 21 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 80d6a51b8c11..4708afc9106c 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -60,10 +60,11 @@ void cifs_dump_mids(struct TCP_Server_Info *server)
 		return;
 
 	cifs_dbg(VFS, "Dump pending requests:\n");
 	spin_lock(&server->mid_queue_lock);
 	list_for_each_entry(mid_entry, &server->pending_mid_q, qhead) {
+		spin_lock(&mid_entry->mid_lock);
 		cifs_dbg(VFS, "State: %d Cmd: %d Pid: %d Cbdata: %p Mid %llu\n",
 			 mid_entry->mid_state,
 			 le16_to_cpu(mid_entry->command),
 			 mid_entry->pid,
 			 mid_entry->callback_data,
@@ -80,10 +81,11 @@ void cifs_dump_mids(struct TCP_Server_Info *server)
 		if (mid_entry->resp_buf) {
 			cifs_dump_detail(mid_entry->resp_buf, server);
 			cifs_dump_mem("existing buf: ",
 				mid_entry->resp_buf, 62);
 		}
+		spin_unlock(&mid_entry->mid_lock);
 	}
 	spin_unlock(&server->mid_queue_lock);
 #endif /* CONFIG_CIFS_DEBUG2 */
 }
 
@@ -672,16 +674,18 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 
 				seq_printf(m, "\n\tServer ConnectionId: 0x%llx",
 					   chan_server->conn_id);
 				spin_lock(&chan_server->mid_queue_lock);
 				list_for_each_entry(mid_entry, &chan_server->pending_mid_q, qhead) {
+					spin_lock(&mid_entry->mid_lock);
 					seq_printf(m, "\n\t\tState: %d com: %d pid: %d cbdata: %p mid %llu",
 						   mid_entry->mid_state,
 						   le16_to_cpu(mid_entry->command),
 						   mid_entry->pid,
 						   mid_entry->callback_data,
 						   mid_entry->mid);
+					spin_unlock(&mid_entry->mid_lock);
 				}
 				spin_unlock(&chan_server->mid_queue_lock);
 			}
 			spin_unlock(&ses->chan_lock);
 			seq_puts(m, "\n--\n");
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 536dff5b4a9c..430163a878d9 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1357,10 +1357,11 @@ struct tcon_link {
 	struct cifs_tcon	*tl_tcon;
 };
 
 extern struct tcon_link *cifs_sb_tlink(struct cifs_sb_info *cifs_sb);
 extern void smb3_free_compound_rqst(int num_rqst, struct smb_rqst *rqst);
+extern inline void mid_execute_callback(struct mid_q_entry *mid);
 
 static inline struct cifs_tcon *
 tlink_tcon(struct tcon_link *tlink)
 {
 	return tlink->tl_tcon;
@@ -1730,10 +1731,11 @@ struct mid_q_entry {
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
@@ -2034,10 +2036,13 @@ require use of the stronger protocol */
  *								init_cached_dir
  * cifsFileInfo->fh_mutex	cifsFileInfo			cifs_new_fileinfo
  * cifsFileInfo->file_info_lock	cifsFileInfo->count		cifs_new_fileinfo
  *				->invalidHandle			initiate_cifs_search
  *				->oplock_break_cancelled
+ * mid_q_entry->mid_lock	mid_q_entry->mid_state		alloc_mid
+ *				mid_q_entry->callback		smb2_mid_entry_alloc
+ *				(Ensure that mid->callback is executed atomically)
  ****************************************************************************/
 
 #ifdef DECLARE_GLOBALS_HERE
 #define GLOBAL_EXTERN
 #else
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 587845a2452d..2d85554b8041 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -288,10 +288,18 @@ cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server,
 		}
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
 }
 
+inline void mid_execute_callback(struct mid_q_entry *mid)
+{
+	spin_lock(&mid->mid_lock);
+	if (mid->callback)
+		mid->callback(mid);
+	spin_unlock(&mid->mid_lock);
+}
+
 static void
 cifs_abort_connection(struct TCP_Server_Info *server)
 {
 	struct mid_q_entry *mid, *nmid;
 	struct list_head retry_list;
@@ -322,22 +330,24 @@ cifs_abort_connection(struct TCP_Server_Info *server)
 	INIT_LIST_HEAD(&retry_list);
 	cifs_dbg(FYI, "%s: moving mids to private list\n", __func__);
 	spin_lock(&server->mid_queue_lock);
 	list_for_each_entry_safe(mid, nmid, &server->pending_mid_q, qhead) {
 		kref_get(&mid->refcount);
+		spin_lock(&mid->mid_lock);
 		if (mid->mid_state == MID_REQUEST_SUBMITTED)
 			mid->mid_state = MID_RETRY_NEEDED;
+		spin_unlock(&mid->mid_lock);
 		list_move(&mid->qhead, &retry_list);
 		mid->deleted_from_q = true;
 	}
 	spin_unlock(&server->mid_queue_lock);
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
@@ -917,11 +927,11 @@ is_smb_response(struct TCP_Server_Info *server, unsigned char type)
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
@@ -956,14 +966,16 @@ dequeue_mid(struct mid_q_entry *mid, bool malformed)
 {
 #ifdef CONFIG_CIFS_STATS2
 	mid->when_received = jiffies;
 #endif
 	spin_lock(&mid->server->mid_queue_lock);
+	spin_lock(&mid->mid_lock);
 	if (!malformed)
 		mid->mid_state = MID_RESPONSE_RECEIVED;
 	else
 		mid->mid_state = MID_RESPONSE_MALFORMED;
+	spin_unlock(&mid->mid_lock);
 	/*
 	 * Trying to handle/dequeue a mid after the send_recv()
 	 * function has finished processing it is a bug.
 	 */
 	if (mid->deleted_from_q == true) {
@@ -1104,22 +1116,24 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
 		spin_lock(&server->mid_queue_lock);
 		list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
 			cifs_dbg(FYI, "Clearing mid %llu\n", mid_entry->mid);
 			kref_get(&mid_entry->refcount);
+			spin_lock(&mid_entry->mid_lock);
 			mid_entry->mid_state = MID_SHUTDOWN;
+			spin_unlock(&mid_entry->mid_lock);
 			list_move(&mid_entry->qhead, &dispose_list);
 			mid_entry->deleted_from_q = true;
 		}
 		spin_unlock(&server->mid_queue_lock);
 
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
@@ -1392,11 +1406,11 @@ cifs_demultiplex_thread(void *p)
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
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 13f600a3d0c4..6a6b09cfcefa 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -95,17 +95,20 @@ cifs_find_mid(struct TCP_Server_Info *server, char *buffer)
 	struct smb_hdr *buf = (struct smb_hdr *)buffer;
 	struct mid_q_entry *mid;
 
 	spin_lock(&server->mid_queue_lock);
 	list_for_each_entry(mid, &server->pending_mid_q, qhead) {
+		spin_lock(&mid->mid_lock);
 		if (compare_mid(mid->mid, buf) &&
 		    mid->mid_state == MID_REQUEST_SUBMITTED &&
 		    le16_to_cpu(mid->command) == buf->Command) {
+			spin_unlock(&mid->mid_lock);
 			kref_get(&mid->refcount);
 			spin_unlock(&server->mid_queue_lock);
 			return mid;
 		}
+		spin_unlock(&mid->mid_lock);
 	}
 	spin_unlock(&server->mid_queue_lock);
 	return NULL;
 }
 
@@ -198,16 +201,19 @@ cifs_get_next_mid(struct TCP_Server_Info *server)
 
 		num_mids = 0;
 		spin_lock(&server->mid_queue_lock);
 		list_for_each_entry(mid_entry, &server->pending_mid_q, qhead) {
 			++num_mids;
+			spin_lock(&mid_entry->mid_lock);
 			if (mid_entry->mid == cur_mid &&
 			    mid_entry->mid_state == MID_REQUEST_SUBMITTED) {
+				spin_unlock(&mid_entry->mid_lock);
 				/* This mid is in use, try a different one */
 				collision = true;
 				break;
 			}
+			spin_unlock(&mid_entry->mid_lock);
 		}
 		spin_unlock(&server->mid_queue_lock);
 
 		/*
 		 * if we have more than 32k mids in the list, then something
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 2643d86a5b5f..14c572e04894 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4803,27 +4803,30 @@ static void smb2_decrypt_offload(struct work_struct *work)
 #endif
 			if (dw->server->ops->is_network_name_deleted)
 				dw->server->ops->is_network_name_deleted(dw->buf,
 									 dw->server);
 
-			mid->callback(mid);
+			mid_execute_callback(mid);
 		} else {
 			spin_lock(&dw->server->srv_lock);
 			if (dw->server->tcpStatus == CifsNeedReconnect) {
-				spin_lock(&dw->server->mid_queue_lock);
-				mid->mid_state = MID_RETRY_NEEDED;
-				spin_unlock(&dw->server->mid_queue_lock);
 				spin_unlock(&dw->server->srv_lock);
-				mid->callback(mid);
+				spin_lock(&mid->mid_lock);
+				mid->mid_state = MID_RETRY_NEEDED;
+				if (mid->callback)
+					mid->callback(mid);
+				spin_unlock(&mid->mid_lock);
 			} else {
+				spin_unlock(&dw->server->srv_lock);
 				spin_lock(&dw->server->mid_queue_lock);
+				spin_lock(&mid->mid_lock);
 				mid->mid_state = MID_REQUEST_SUBMITTED;
+				spin_unlock(&mid->mid_lock);
 				mid->deleted_from_q = false;
 				list_add_tail(&mid->qhead,
 					&dw->server->pending_mid_q);
 				spin_unlock(&dw->server->mid_queue_lock);
-				spin_unlock(&dw->server->srv_lock);
 			}
 		}
 		release_mid(mid);
 	}
 
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
index ca9358c24ceb..8bbcecf2225d 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -52,10 +52,11 @@ alloc_mid(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
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
@@ -875,17 +876,17 @@ SendReceiveNoRsp(const unsigned int xid, struct cifs_ses *ses,
 static int
 cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 {
 	int rc = 0;
 
+	spin_lock(&mid->mid_lock);
 	cifs_dbg(FYI, "%s: cmd=%d mid=%llu state=%d\n",
 		 __func__, le16_to_cpu(mid->command), mid->mid, mid->mid_state);
 
-	spin_lock(&server->mid_queue_lock);
 	switch (mid->mid_state) {
 	case MID_RESPONSE_READY:
-		spin_unlock(&server->mid_queue_lock);
+		spin_unlock(&mid->mid_lock);
 		return rc;
 	case MID_RETRY_NEEDED:
 		rc = -EAGAIN;
 		break;
 	case MID_RESPONSE_MALFORMED:
@@ -896,21 +897,25 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 		break;
 	case MID_RC:
 		rc = mid->mid_rc;
 		break;
 	default:
+		cifs_server_dbg(VFS, "%s: invalid mid state mid=%llu state=%d\n",
+			 __func__, mid->mid, mid->mid_state);
+		spin_unlock(&mid->mid_lock);
+
+		spin_lock(&server->mid_queue_lock);
 		if (mid->deleted_from_q == false) {
 			list_del_init(&mid->qhead);
 			mid->deleted_from_q = true;
 		}
 		spin_unlock(&server->mid_queue_lock);
-		cifs_server_dbg(VFS, "%s: invalid mid state mid=%llu state=%d\n",
-			 __func__, mid->mid, mid->mid_state);
+
 		rc = -EIO;
 		goto sync_mid_done;
 	}
-	spin_unlock(&server->mid_queue_lock);
+	spin_unlock(&mid->mid_lock);
 
 sync_mid_done:
 	release_mid(mid);
 	return rc;
 }
@@ -1212,17 +1217,19 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		for (; i < num_rqst; i++) {
 			cifs_server_dbg(FYI, "Cancelling wait for mid %llu cmd: %d\n",
 				 midQ[i]->mid, le16_to_cpu(midQ[i]->command));
 			send_cancel(server, &rqst[i], midQ[i]);
 			spin_lock(&server->mid_queue_lock);
+			spin_lock(&midQ[i]->mid_lock);
 			midQ[i]->wait_cancelled = true;
 			if (midQ[i]->mid_state == MID_REQUEST_SUBMITTED ||
 			    midQ[i]->mid_state == MID_RESPONSE_RECEIVED) {
 				midQ[i]->callback = cifs_cancelled_callback;
 				cancelled_mid[i] = true;
 				credits[i].value = 0;
 			}
+			spin_unlock(&midQ[i]->mid_lock);
 			spin_unlock(&server->mid_queue_lock);
 		}
 	}
 
 	for (i = 0; i < num_rqst; i++) {
@@ -1421,20 +1428,20 @@ SendReceive(const unsigned int xid, struct cifs_ses *ses,
 		goto out;
 
 	rc = wait_for_response(server, midQ);
 	if (rc != 0) {
 		send_cancel(server, &rqst, midQ);
-		spin_lock(&server->mid_queue_lock);
+		spin_lock(&midQ->mid_lock);
 		if (midQ->mid_state == MID_REQUEST_SUBMITTED ||
 		    midQ->mid_state == MID_RESPONSE_RECEIVED) {
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
@@ -1603,19 +1610,19 @@ SendReceiveBlockingLock(const unsigned int xid, struct cifs_tcon *tcon,
 		}
 
 		rc = wait_for_response(server, midQ);
 		if (rc) {
 			send_cancel(server, &rqst, midQ);
-			spin_lock(&server->mid_queue_lock);
+			spin_lock(&midQ->mid_lock);
 			if (midQ->mid_state == MID_REQUEST_SUBMITTED ||
 			    midQ->mid_state == MID_RESPONSE_RECEIVED) {
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
-- 
2.39.2

