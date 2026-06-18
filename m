Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A472609DC
	for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 14:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781792290; cv=none; b=qapoQpAu7FUcDIkNbZpZ4Ht9cSzf9n2L6IPRXqyMQvRIl1gAyxEZJ8GdrEjTeCa445JLyG2sJw2lE0aTanCqcjGmkAaKbqkLDs6hazL0JTe13iiO85wyReE6SCvJg2Dc1RQVPYe/QWJb16SCj0EX4ZM/GcGm3T7iTlT3OXb+vj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781792290; c=relaxed/simple;
	bh=F0gQffvptd+40BBAM48QKvkjFMeJT4EHALyX3IbhA0A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PsVJHQcNDx1q/Mfs9eaLZzvAlpkmd5NpjKwISt8lnx7yeCVK6HQNxwlB3tOuT1A3VSdb2lh+DSGuGLZ2nXGsgyObGJsCBtFMQS9TOnxuLzNFcIo9dUC+iI9FomZeZ6nBGPOw4pkMvI+d3UawW4lpUEDxIC+rJtfpipskkH/kKn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S2gYFsCV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S2gYFsCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B029A1F00A3A;
	Thu, 18 Jun 2026 14:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781792289;
	bh=QFfLmDFL0+7rBTOND/tAivKWBJdVJ6FWK/LhYRDcW4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S2gYFsCVt6CFRd1m+mVujJv3/wEpW8XLqlmSPEfofswTMA5XC5vkRad98JHAvyCAl
	 Ou5dqQ2eClqobz3TwBqGD/aWufGgtHJDuBsTEV/09VtcHX8bdu3VokNXMuO26+3aB1
	 08qOgacG+GNqU+12CSPnoznE6E8Ru/yGiV8OpqDEYWTsAfwEZAJA1CxCEwpE+nu3kZ
	 DsBI+RnCqpmgk/RBT+26ci2bFOyTzCUSURKyZmBU+pNKir669WpMR+hQnJ8d8FOSjM
	 tdiuwpiDLcsZcZNbH1lAB4FP00X9NMWZSmEEKkGroi1HtMaOFIyr3nli5n75nSNU43
	 RFd4OzSqhY95w==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	metze@samba.org,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 11/14] ksmbd: honor SMB2 v2 lease epochs
Date: Thu, 18 Jun 2026 23:17:36 +0900
Message-Id: <20260618141739.9029-11-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260618141739.9029-1-linkinjeon@kernel.org>
References: <20260618141739.9029-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2 lease responses should continue from the client supplied epoch.
Initialize a new v2 lease from the requested epoch plus one so create
responses match the epoch returned by Windows and expected by smbtorture.

For a single chained break sequence, increment the epoch only for the first
break notification. Follow-up breaks such as RH->R and R->NONE in
smb2.lease.v2_breaking3 reuse the same epoch.

Record when a waiter slept behind pending_break and let the later
truncate/open overwrite break consume that marker to reuse the current
epoch instead of assigning a new one.

Do not increment the epoch when a same-client, same-key create asks for
the already granted RH state. The epoch changes only when the granted lease
state changes.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c | 39 +++++++++++++++++++++++++++++----------
 fs/smb/server/oplock.h |  1 +
 2 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index f5a2ac927898..9efc66fef2e6 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -163,8 +163,9 @@ static struct lease *alloc_lease(struct lease_ctx_info *lctx,
 	lease->is_dir = lctx->is_dir;
 	memcpy(lease->parent_lease_key, lctx->parent_lease_key, SMB2_LEASE_KEY_SIZE);
 	lease->version = lctx->version;
-	lease->epoch = lctx->version == 2 ? 1 : 0;
+	lease->epoch = lctx->version == 2 ? le16_to_cpu(lctx->epoch) + 1 : 0;
 	lease->ci = ci;
+	lease->reuse_epoch = false;
 	lease->l_lb = NULL;
 	INIT_LIST_HEAD(&lease->l_entry);
 	INIT_LIST_HEAD(&lease->open_list);
@@ -645,9 +646,11 @@ static struct oplock_info *same_client_has_lease(struct ksmbd_inode *ci,
 				if (lctx->req_state ==
 				    (SMB2_LEASE_READ_CACHING_LE |
 				     SMB2_LEASE_HANDLE_CACHING_LE)) {
-					lease->epoch++;
-					lease->state = lctx->req_state;
-					lease_update_oplock_levels(lease);
+					if (lease->state != lctx->req_state) {
+						lease->epoch++;
+						lease->state = lctx->req_state;
+						lease_update_oplock_levels(lease);
+					}
 				}
 			}
 
@@ -694,6 +697,9 @@ static void wake_up_oplock_break(struct oplock_info *opinfo)
 static int oplock_break_pending(struct oplock_info *opinfo, int req_op_level)
 {
 	while (test_and_set_bit(0, &opinfo->pending_break)) {
+		if (opinfo->is_lease)
+			opinfo->o_lease->reuse_epoch = true;
+
 		wait_on_bit(&opinfo->pending_break, 0, TASK_UNINTERRUPTIBLE);
 
 		/* Not immediately break to none. */
@@ -927,7 +933,8 @@ static void __smb2_lease_break_noti(struct work_struct *wk)
  *
  * Return:	0 on success, otherwise error
  */
-static int smb2_lease_break_noti(struct oplock_info *opinfo, bool wait_ack)
+static int smb2_lease_break_noti(struct oplock_info *opinfo, bool wait_ack,
+				 bool inc_epoch)
 {
 	struct ksmbd_conn *conn;
 	struct ksmbd_work *work;
@@ -950,10 +957,13 @@ static int smb2_lease_break_noti(struct oplock_info *opinfo, bool wait_ack)
 
 	br_info->curr_state = lease->state;
 	br_info->new_state = lease->new_state;
-	if (lease->version == 2)
-		br_info->epoch = cpu_to_le16(++lease->epoch);
-	else
+	if (lease->version == 2) {
+		if (inc_epoch)
+			lease->epoch++;
+		br_info->epoch = cpu_to_le16(lease->epoch);
+	} else {
 		br_info->epoch = 0;
+	}
 	memcpy(br_info->lease_key, lease->lease_key, SMB2_LEASE_KEY_SIZE);
 
 	work->request_buf = (char *)br_info;
@@ -1007,9 +1017,11 @@ static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level,
 	if (brk_opinfo->is_lease) {
 		struct lease *lease = brk_opinfo->o_lease;
 		bool open_trunc = brk_opinfo->open_trunc;
+		bool was_pending = test_bit(0, &brk_opinfo->pending_break);
 		bool wait_ack;
+		bool inc_epoch = true;
 
-		if (in_work && test_bit(0, &brk_opinfo->pending_break)) {
+		if (in_work && was_pending) {
 			setup_async_work(in_work, NULL, NULL);
 			smb2_send_interim_resp(in_work, STATUS_PENDING);
 			release_async_work(in_work);
@@ -1019,6 +1031,8 @@ static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level,
 		err = oplock_break_pending(brk_opinfo, req_op_level);
 		if (err)
 			return err < 0 ? err : 0;
+		if (was_pending)
+			open_trunc = brk_opinfo->open_trunc;
 
 again:
 		atomic_inc(&brk_opinfo->breaking_cnt);
@@ -1063,7 +1077,12 @@ static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level,
 		wait_ack = !(open_trunc &&
 			     lease->state == (SMB2_LEASE_READ_CACHING_LE |
 					      SMB2_LEASE_HANDLE_CACHING_LE));
-		err = smb2_lease_break_noti(brk_opinfo, wait_ack);
+		if (lease->reuse_epoch) {
+			inc_epoch = false;
+			lease->reuse_epoch = false;
+		}
+		err = smb2_lease_break_noti(brk_opinfo, wait_ack, inc_epoch);
+		inc_epoch = false;
 
 		ksmbd_debug(OPLOCK, "oplock granted = %d\n", brk_opinfo->level);
 		if (brk_opinfo->op_state == OPLOCK_CLOSING)
diff --git a/fs/smb/server/oplock.h b/fs/smb/server/oplock.h
index 30bad6d65048..1dd52b44557f 100644
--- a/fs/smb/server/oplock.h
+++ b/fs/smb/server/oplock.h
@@ -49,6 +49,7 @@ struct lease {
 	int			version;
 	unsigned short		epoch;
 	bool			is_dir;
+	bool			reuse_epoch;
 	struct ksmbd_inode	*ci;
 	struct lease_table	*l_lb;
 	struct list_head	l_entry;
-- 
2.25.1

