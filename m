Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EDE821D590;
	Tue,  5 Aug 2025 06:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754376868; cv=none; b=blwVa/wIb7zFfur3KPiklVS0udGnnuxDgghTmWZVzIfSuQ7k4Zx6GJ2JLDxV07siNwT5qYogd9NUx4Jy/cK189qN6VNtSPDrmBp2SvsKybM7dWw1qtQ9HG+Qg7ATKOVUwlTp4tyrznoZeABlo9F8aEVR0F2ESfx5LVvvgG/NpOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754376868; c=relaxed/simple;
	bh=imkFBcLfKj6csPi/5yH3WtYODf8JhyeTHuCgCeD5WwU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RyaoPcVLHk9yETanzr0ldnyJOAlAn2pzXt00535Eg3mOfN/aK6WMBcdRkqD+KxoksZ1QaZ9gf1kyQb9bxbGwfoVfvARsfQXUIjs2DiQbGG1y6dBuz6BNQTS4211zFoUyUJYdD6dfHseRdjIku/8zL0KPHGV6kE8qEnpebw/wpvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bx40c5rvNzKHMXZ;
	Tue,  5 Aug 2025 14:54:24 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D3E651A0F2B;
	Tue,  5 Aug 2025 14:54:23 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgD3chObqpForbmECg--.23530S7;
	Tue, 05 Aug 2025 14:54:23 +0800 (CST)
From: Wang Zhaolong <wangzhaolong@huaweicloud.com>
To: sfrench@samba.org,
	pshilov@microsoft.com
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	chengzhihao1@huawei.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH V2 3/4] smb: client: smb: client: eliminate mid_flags field
Date: Tue,  5 Aug 2025 14:47:07 +0800
Message-Id: <20250805064708.332465-4-wangzhaolong@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250805064708.332465-1-wangzhaolong@huaweicloud.com>
References: <20250805064708.332465-1-wangzhaolong@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3chObqpForbmECg--.23530S7
X-Coremail-Antispam: 1UD129KBjvJXoW3Xr1rXFW3uFykZr18Xr4DCFg_yoWfAF1DpF
	WFqFW7Cr4rJa9rZ397Ja18Aw4rZwn5uFnrGrWfGry3tFZ7urn8Xrn7KryY9Fy3WFZIg3sa
	9F4jy3yqv3W0qaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Kb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUWw
	A2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr4
	1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
	67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
	8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAv
	wI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
	v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUwhFxUUUUU
X-CM-SenderInfo: pzdqw6xkdrz0tqj6x35dzhxuhorxvhhfrp/

This is step 3/4 of a patch series to fix mid_q_entry memory leaks
caused by race conditions in callback execution.

Replace the mid_flags bitmask with dedicated boolean fields to
simplify locking logic and improve code readability:

- Replace MID_DELETED with bool deleted_from_q
- Replace MID_WAIT_CANCELLED with bool wait_cancelled
- Remove mid_flags field entirely

The new boolean fields have clearer semantics:
- deleted_from_q: whether mid has been removed from pending_mid_q
- wait_cancelled: whether request was cancelled during wait

This change reduces memory usage (from 4-byte bitmask to 2 boolean
flags) and eliminates confusion about which lock protects which
flag bits, preparing for per-mid locking in the next patch.

Signed-off-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
---
 fs/smb/client/cifsglob.h  |  9 +++------
 fs/smb/client/connect.c   | 10 +++++-----
 fs/smb/client/smb2ops.c   |  4 ++--
 fs/smb/client/transport.c | 12 ++++++------
 4 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 1844afdf1e41..536dff5b4a9c 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1728,13 +1728,14 @@ struct mid_q_entry {
 	struct task_struct *creator;
 	void *resp_buf;		/* pointer to received SMB header */
 	unsigned int resp_buf_size;
 	int mid_state;	/* wish this were enum but can not pass to wait_event */
 	int mid_rc;		/* rc for MID_RC */
-	unsigned int mid_flags;
 	__le16 command;		/* smb command code */
 	unsigned int optype;	/* operation type */
+	bool wait_cancelled:1;  /* Cancelled while waiting for response */
+	bool deleted_from_q:1;  /* Whether Mid has been dequeued frem pending_mid_q */
 	bool large_buf:1;	/* if valid response, is pointer to large buf */
 	bool multiRsp:1;	/* multiple trans2 responses for one request  */
 	bool multiEnd:1;	/* both received */
 	bool decrypted:1;	/* decrypted entry */
 };
@@ -1892,14 +1893,10 @@ static inline bool is_replayable_error(int error)
 #define   MID_RESPONSE_MALFORMED 0x10
 #define   MID_SHUTDOWN		 0x20
 #define   MID_RESPONSE_READY 0x40 /* ready for other process handle the rsp */
 #define   MID_RC             0x80 /* mid_rc contains custom rc */
 
-/* Flags */
-#define   MID_WAIT_CANCELLED	 1 /* Cancelled while waiting for response */
-#define   MID_DELETED            2 /* Mid has been dequeued/deleted */
-
 /* Types of response buffer returned from SendReceive2 */
 #define   CIFS_NO_BUFFER        0    /* Response buffer not returned */
 #define   CIFS_SMALL_BUFFER     1
 #define   CIFS_LARGE_BUFFER     2
 #define   CIFS_IOVEC            4    /* array of response buffers */
@@ -2007,11 +2004,11 @@ require use of the stronger protocol */
  * GlobalMid_Lock		GlobalMaxActiveXid		init_cifs
  *				GlobalCurrentXid
  *				GlobalTotalActiveXid
  * TCP_Server_Info->srv_lock	(anything in struct not protected by another lock and can change)
  * TCP_Server_Info->mid_queue_lock	TCP_Server_Info->pending_mid_q	cifs_get_tcp_session
- *				(any changes in mid_q_entry fields)
+ *				mid_q_entry->deleted_from_q
  * TCP_Server_Info->mid_counter_lock    TCP_Server_Info->current_mid    cifs_get_tcp_session
  * TCP_Server_Info->req_lock	TCP_Server_Info->in_flight	cifs_get_tcp_session
  *				->credits
  *				->echo_credits
  *				->oplock_credits
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 74ad5881ee45..587845a2452d 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -325,11 +325,11 @@ cifs_abort_connection(struct TCP_Server_Info *server)
 	list_for_each_entry_safe(mid, nmid, &server->pending_mid_q, qhead) {
 		kref_get(&mid->refcount);
 		if (mid->mid_state == MID_REQUEST_SUBMITTED)
 			mid->mid_state = MID_RETRY_NEEDED;
 		list_move(&mid->qhead, &retry_list);
-		mid->mid_flags |= MID_DELETED;
+		mid->deleted_from_q = true;
 	}
 	spin_unlock(&server->mid_queue_lock);
 	cifs_server_unlock(server);
 
 	cifs_dbg(FYI, "%s: issuing mid callbacks\n", __func__);
@@ -886,11 +886,11 @@ is_smb_response(struct TCP_Server_Info *server, unsigned char type)
 			 */
 			spin_lock(&server->mid_queue_lock);
 			list_for_each_entry_safe(mid, nmid, &server->pending_mid_q, qhead) {
 				kref_get(&mid->refcount);
 				list_move(&mid->qhead, &dispose_list);
-				mid->mid_flags |= MID_DELETED;
+				mid->deleted_from_q = true;
 			}
 			spin_unlock(&server->mid_queue_lock);
 
 			/* Now try to reconnect once with NetBIOS session. */
 			server->with_rfc1001 = true;
@@ -964,16 +964,16 @@ dequeue_mid(struct mid_q_entry *mid, bool malformed)
 		mid->mid_state = MID_RESPONSE_MALFORMED;
 	/*
 	 * Trying to handle/dequeue a mid after the send_recv()
 	 * function has finished processing it is a bug.
 	 */
-	if (mid->mid_flags & MID_DELETED) {
+	if (mid->deleted_from_q == true) {
 		spin_unlock(&mid->server->mid_queue_lock);
 		pr_warn_once("trying to dequeue a deleted mid\n");
 	} else {
 		list_del_init(&mid->qhead);
-		mid->mid_flags |= MID_DELETED;
+		mid->deleted_from_q = true;
 		spin_unlock(&mid->server->mid_queue_lock);
 	}
 }
 
 static unsigned int
@@ -1106,11 +1106,11 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
 			mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
 			cifs_dbg(FYI, "Clearing mid %llu\n", mid_entry->mid);
 			kref_get(&mid_entry->refcount);
 			mid_entry->mid_state = MID_SHUTDOWN;
 			list_move(&mid_entry->qhead, &dispose_list);
-			mid_entry->mid_flags |= MID_DELETED;
+			mid_entry->deleted_from_q = true;
 		}
 		spin_unlock(&server->mid_queue_lock);
 
 		/* now walk dispose list and issue callbacks */
 		list_for_each_safe(tmp, tmp2, &dispose_list) {
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index da2cb9585404..2643d86a5b5f 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -407,11 +407,11 @@ __smb2_find_mid(struct TCP_Server_Info *server, char *buf, bool dequeue)
 		    (mid->mid_state == MID_REQUEST_SUBMITTED) &&
 		    (mid->command == shdr->Command)) {
 			kref_get(&mid->refcount);
 			if (dequeue) {
 				list_del_init(&mid->qhead);
-				mid->mid_flags |= MID_DELETED;
+				mid->deleted_from_q = true;
 			}
 			spin_unlock(&server->mid_queue_lock);
 			return mid;
 		}
 	}
@@ -4815,11 +4815,11 @@ static void smb2_decrypt_offload(struct work_struct *work)
 				spin_unlock(&dw->server->srv_lock);
 				mid->callback(mid);
 			} else {
 				spin_lock(&dw->server->mid_queue_lock);
 				mid->mid_state = MID_REQUEST_SUBMITTED;
-				mid->mid_flags &= ~(MID_DELETED);
+				mid->deleted_from_q = false;
 				list_add_tail(&mid->qhead,
 					&dw->server->pending_mid_q);
 				spin_unlock(&dw->server->mid_queue_lock);
 				spin_unlock(&dw->server->srv_lock);
 			}
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 8037accc3987..ca9358c24ceb 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -87,11 +87,11 @@ void __release_mid(struct kref *refcount)
 	unsigned long now;
 	unsigned long roundtrip_time;
 #endif
 	struct TCP_Server_Info *server = midEntry->server;
 
-	if (midEntry->resp_buf && (midEntry->mid_flags & MID_WAIT_CANCELLED) &&
+	if (midEntry->resp_buf && (midEntry->wait_cancelled) &&
 	    (midEntry->mid_state == MID_RESPONSE_RECEIVED ||
 	     midEntry->mid_state == MID_RESPONSE_READY) &&
 	    server->ops->handle_cancelled_mid)
 		server->ops->handle_cancelled_mid(midEntry, server);
 
@@ -159,13 +159,13 @@ void __release_mid(struct kref *refcount)
 
 void
 delete_mid(struct mid_q_entry *mid)
 {
 	spin_lock(&mid->server->mid_queue_lock);
-	if (!(mid->mid_flags & MID_DELETED)) {
+	if (mid->deleted_from_q == false) {
 		list_del_init(&mid->qhead);
-		mid->mid_flags |= MID_DELETED;
+		mid->deleted_from_q = true;
 	}
 	spin_unlock(&mid->server->mid_queue_lock);
 
 	release_mid(mid);
 }
@@ -896,13 +896,13 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 		break;
 	case MID_RC:
 		rc = mid->mid_rc;
 		break;
 	default:
-		if (!(mid->mid_flags & MID_DELETED)) {
+		if (mid->deleted_from_q == false) {
 			list_del_init(&mid->qhead);
-			mid->mid_flags |= MID_DELETED;
+			mid->deleted_from_q = true;
 		}
 		spin_unlock(&server->mid_queue_lock);
 		cifs_server_dbg(VFS, "%s: invalid mid state mid=%llu state=%d\n",
 			 __func__, mid->mid, mid->mid_state);
 		rc = -EIO;
@@ -1212,11 +1212,11 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
 		for (; i < num_rqst; i++) {
 			cifs_server_dbg(FYI, "Cancelling wait for mid %llu cmd: %d\n",
 				 midQ[i]->mid, le16_to_cpu(midQ[i]->command));
 			send_cancel(server, &rqst[i], midQ[i]);
 			spin_lock(&server->mid_queue_lock);
-			midQ[i]->mid_flags |= MID_WAIT_CANCELLED;
+			midQ[i]->wait_cancelled = true;
 			if (midQ[i]->mid_state == MID_REQUEST_SUBMITTED ||
 			    midQ[i]->mid_state == MID_RESPONSE_RECEIVED) {
 				midQ[i]->callback = cifs_cancelled_callback;
 				cancelled_mid[i] = true;
 				credits[i].value = 0;
-- 
2.39.2

