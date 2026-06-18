Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C9422609DC
	for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 14:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781792275; cv=none; b=G1SMuBmPAT/t8iE5M7rIjNWKlDtt+c9pKl51V54hJC1q4rxDTxyX04po8tPweU9H2Ixccxv2gAbH6S8p1e4fTF1a04jQcKR/2CdwIbiElDGJBUnXMJtwVHNki+qdWtMlbWmqxNVFZCQDtkZJjBR3PHAVnAwKZQr8L4zW+MvOta4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781792275; c=relaxed/simple;
	bh=GoIVRsxPUxEyggm4IUhlCJshqmJFgC25pHz7bLOjtn4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gY4EqbHJhJfOmh2gl1qm7Xmuda0sIw3+JNXOIrzFHJHZJlpl/sfDzZLJ6j6Flh9UpTrXRnQ+sEmzcceeBoP1zQTTrKT7VGI8N7QodxwLfaH3vMlas312DKxUckepliTnxDk/TuSZPRKWKu4c/pQSf7R2xH+8yuG0b/u2zp3ElAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SRLz5V/K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SRLz5V/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACF51F000E9;
	Thu, 18 Jun 2026 14:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781792273;
	bh=9iU886Es2DTdEC3PYeNO0K4jumxhLlQFfQov/etoy28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SRLz5V/KmAELc/lJA8VtV+JIF19maYTM73f19Scbr/nZCYjKrDoyhDPTuubWE6NmR
	 AOQsgycotVJU1YwxR26Ik2Bsf1+M/lF12QCTWpamHCsr/In9GeozIBiULwvBbZorEq
	 Fw+OFPcvW4khVWItChGLdkthC670zxKNZdTpWhy33+KK1RIwC+asI8R1EjnBTLeu+g
	 NBfjsa1JW8AReOYNir8Gt9L9BSR9PszxrMoY7YByp5m6e6QBE5U2SbI1tDQuOP3uiG
	 70QAnGsmzvscbCbIg438JNHQMnLSVdhaWIKhbdKd1W+f7dx9+yjbg7aPCg3wp1soOt
	 eMIm7viVOWu3Q==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	metze@samba.org,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 05/14] ksmbd: share SMB2 lease state across opens
Date: Thu, 18 Jun 2026 23:17:30 +0900
Message-Id: <20260618141739.9029-5-linkinjeon@kernel.org>
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

Model SMB2 leases as per-client/per-key objects instead of keeping a
separate lease copy in every oplock_info. The lease table now stores
lease objects and each lease tracks the opens that reference it.

This makes same ClientGuid/LeaseKey opens observe a single lease state,
so lease upgrades, breaks, ACKs, and close teardown do not diverge across
per-open copies. Keep one reference for the lease table entry and one
reference for each open, and remove the table entry when the last open is
detached.

Update lease break ACK handling to refresh all open oplock levels from
the shared lease state.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c  | 262 ++++++++++++++++++++++------------------
 fs/smb/server/oplock.h  |   6 +
 fs/smb/server/smb2pdu.c |   2 +-
 3 files changed, 151 insertions(+), 119 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 8ae6a6afbe04..81716317bb61 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -65,6 +65,7 @@ static struct oplock_info *alloc_opinfo(struct ksmbd_work *work,
 	opinfo->fid = id;
 	opinfo->Tid = Tid;
 	INIT_LIST_HEAD(&opinfo->op_entry);
+	INIT_LIST_HEAD(&opinfo->lease_entry);
 	init_waitqueue_head(&opinfo->oplock_q);
 	init_waitqueue_head(&opinfo->oplock_brk);
 	atomic_set(&opinfo->refcount, 1);
@@ -73,31 +74,44 @@ static struct oplock_info *alloc_opinfo(struct ksmbd_work *work,
 	return opinfo;
 }
 
-static void lease_add_list(struct oplock_info *opinfo)
+static void lease_get(struct lease *lease)
+{
+	atomic_inc(&lease->refcount);
+}
+
+static void lease_put(struct lease *lease)
 {
-	struct lease_table *lb = opinfo->o_lease->l_lb;
+	if (lease && atomic_dec_and_test(&lease->refcount))
+		kfree(lease);
+}
 
+static void lease_add_table(struct lease *lease, struct lease_table *lb)
+{
+	lease_get(lease);
+	lease->l_lb = lb;
 	spin_lock(&lb->lb_lock);
-	list_add_rcu(&opinfo->lease_entry, &lb->lease_list);
+	list_add_rcu(&lease->l_entry, &lb->lease_list);
 	spin_unlock(&lb->lb_lock);
 }
 
-static void lease_del_list(struct oplock_info *opinfo)
+static void lease_del_table(struct lease *lease)
 {
-	struct lease_table *lb = opinfo->o_lease->l_lb;
+	struct lease_table *lb = lease->l_lb;
 
 	if (!lb)
 		return;
 
 	spin_lock(&lb->lb_lock);
-	if (list_empty(&opinfo->lease_entry)) {
+	if (list_empty(&lease->l_entry)) {
 		spin_unlock(&lb->lb_lock);
 		return;
 	}
 
-	list_del_init(&opinfo->lease_entry);
-	opinfo->o_lease->l_lb = NULL;
+	list_del_init(&lease->l_entry);
+	lease->l_lb = NULL;
 	spin_unlock(&lb->lb_lock);
+
+	lease_put(lease);
 }
 
 static struct lease_table *alloc_lease_table(struct oplock_info *opinfo)
@@ -115,13 +129,14 @@ static struct lease_table *alloc_lease_table(struct oplock_info *opinfo)
 	return lb;
 }
 
-static int alloc_lease(struct oplock_info *opinfo, struct lease_ctx_info *lctx)
+static struct lease *alloc_lease(struct lease_ctx_info *lctx,
+				 struct ksmbd_inode *ci)
 {
 	struct lease *lease;
 
 	lease = kmalloc_obj(struct lease, KSMBD_DEFAULT_GFP);
 	if (!lease)
-		return -ENOMEM;
+		return NULL;
 
 	memcpy(lease->lease_key, lctx->lease_key, SMB2_LEASE_KEY_SIZE);
 	lease->state = lctx->req_state;
@@ -132,18 +147,48 @@ static int alloc_lease(struct oplock_info *opinfo, struct lease_ctx_info *lctx)
 	memcpy(lease->parent_lease_key, lctx->parent_lease_key, SMB2_LEASE_KEY_SIZE);
 	lease->version = lctx->version;
 	lease->epoch = lctx->version == 2 ? 1 : 0;
-	INIT_LIST_HEAD(&opinfo->lease_entry);
-	opinfo->o_lease = lease;
+	lease->ci = ci;
+	lease->l_lb = NULL;
+	INIT_LIST_HEAD(&lease->l_entry);
+	INIT_LIST_HEAD(&lease->open_list);
+	spin_lock_init(&lease->lock);
+	atomic_set(&lease->refcount, 1);
+
+	return lease;
+}
 
-	return 0;
+static void lease_add_open(struct lease *lease, struct oplock_info *opinfo)
+{
+	spin_lock(&lease->lock);
+	list_add(&opinfo->lease_entry, &lease->open_list);
+	spin_unlock(&lease->lock);
 }
 
-static void free_lease(struct oplock_info *opinfo)
+static void lease_del_open(struct oplock_info *opinfo)
 {
-	struct lease *lease;
+	struct lease *lease = opinfo->o_lease;
+	bool remove_table = false;
+
+	if (!lease)
+		return;
+
+	spin_lock(&lease->lock);
+	if (!list_empty(&opinfo->lease_entry)) {
+		list_del_init(&opinfo->lease_entry);
+		remove_table = list_empty(&lease->open_list);
+	}
+	spin_unlock(&lease->lock);
+
+	if (remove_table) {
+		write_lock(&lease_list_lock);
+		lease_del_table(lease);
+		write_unlock(&lease_list_lock);
+	}
+}
 
-	lease = opinfo->o_lease;
-	kfree(lease);
+static void free_lease(struct oplock_info *opinfo)
+{
+	lease_put(opinfo->o_lease);
 }
 
 static void __free_opinfo(struct oplock_info *opinfo)
@@ -166,6 +211,21 @@ static void free_opinfo(struct oplock_info *opinfo)
 	call_rcu(&opinfo->rcu, free_opinfo_rcu);
 }
 
+void lease_update_oplock_levels(struct lease *lease)
+{
+	struct oplock_info *opinfo;
+	__u8 level;
+
+	if (!lease)
+		return;
+
+	level = smb2_map_lease_to_oplock(lease->state);
+	spin_lock(&lease->lock);
+	list_for_each_entry(opinfo, &lease->open_list, lease_entry)
+		opinfo->level = level;
+	spin_unlock(&lease->lock);
+}
+
 struct oplock_info *opinfo_get(struct ksmbd_file *fp)
 {
 	struct oplock_info *opinfo;
@@ -226,11 +286,9 @@ static void opinfo_del(struct oplock_info *opinfo)
 {
 	struct ksmbd_inode *ci = opinfo->o_fp->f_ci;
 
-	if (opinfo->is_lease) {
-		write_lock(&lease_list_lock);
-		lease_del_list(opinfo);
-		write_unlock(&lease_list_lock);
-	}
+	if (opinfo->is_lease)
+		lease_del_open(opinfo);
+
 	down_write(&ci->m_lock);
 	list_del(&opinfo->op_entry);
 	up_write(&ci->m_lock);
@@ -279,8 +337,10 @@ int opinfo_write_to_read(struct oplock_info *opinfo)
 	}
 	opinfo->level = SMB2_OPLOCK_LEVEL_II;
 
-	if (opinfo->is_lease)
+	if (opinfo->is_lease) {
 		lease->state = lease->new_state;
+		lease_update_oplock_levels(lease);
+	}
 	return 0;
 }
 
@@ -295,7 +355,7 @@ int opinfo_read_handle_to_read(struct oplock_info *opinfo)
 	struct lease *lease = opinfo->o_lease;
 
 	lease->state = lease->new_state;
-	opinfo->level = SMB2_OPLOCK_LEVEL_II;
+	lease_update_oplock_levels(lease);
 	return 0;
 }
 
@@ -317,8 +377,10 @@ int opinfo_write_to_none(struct oplock_info *opinfo)
 		return -EINVAL;
 	}
 	opinfo->level = SMB2_OPLOCK_LEVEL_NONE;
-	if (opinfo->is_lease)
+	if (opinfo->is_lease) {
 		lease->state = lease->new_state;
+		lease_update_oplock_levels(lease);
+	}
 	return 0;
 }
 
@@ -339,8 +401,10 @@ int opinfo_read_to_none(struct oplock_info *opinfo)
 		return -EINVAL;
 	}
 	opinfo->level = SMB2_OPLOCK_LEVEL_NONE;
-	if (opinfo->is_lease)
+	if (opinfo->is_lease) {
 		lease->state = lease->new_state;
+		lease_update_oplock_levels(lease);
+	}
 	return 0;
 }
 
@@ -361,10 +425,7 @@ int lease_read_to_write(struct oplock_info *opinfo)
 
 	lease->new_state = SMB2_LEASE_NONE_LE;
 	lease->state |= SMB2_LEASE_WRITE_CACHING_LE;
-	if (lease->state & SMB2_LEASE_HANDLE_CACHING_LE)
-		opinfo->level = SMB2_OPLOCK_LEVEL_BATCH;
-	else
-		opinfo->level = SMB2_OPLOCK_LEVEL_EXCLUSIVE;
+	lease_update_oplock_levels(lease);
 	return 0;
 }
 
@@ -386,15 +447,7 @@ static int lease_none_upgrade(struct oplock_info *opinfo, __le32 new_state)
 
 	lease->new_state = SMB2_LEASE_NONE_LE;
 	lease->state = new_state;
-	if (lease->state & SMB2_LEASE_HANDLE_CACHING_LE)
-		if (lease->state & SMB2_LEASE_WRITE_CACHING_LE)
-			opinfo->level = SMB2_OPLOCK_LEVEL_BATCH;
-		else
-			opinfo->level = SMB2_OPLOCK_LEVEL_II;
-	else if (lease->state & SMB2_LEASE_WRITE_CACHING_LE)
-		opinfo->level = SMB2_OPLOCK_LEVEL_EXCLUSIVE;
-	else if (lease->state & SMB2_LEASE_READ_CACHING_LE)
-		opinfo->level = SMB2_OPLOCK_LEVEL_II;
+	lease_update_oplock_levels(lease);
 
 	return 0;
 }
@@ -577,6 +630,7 @@ static struct oplock_info *same_client_has_lease(struct ksmbd_inode *ci,
 				     SMB2_LEASE_HANDLE_CACHING_LE)) {
 					lease->epoch++;
 					lease->state = lctx->req_state;
+					lease_update_oplock_levels(lease);
 				}
 			}
 
@@ -603,8 +657,10 @@ static void wait_for_break_ack(struct oplock_info *opinfo)
 
 	/* is this a timeout ? */
 	if (!rc) {
-		if (opinfo->is_lease)
+		if (opinfo->is_lease) {
 			opinfo->o_lease->state = SMB2_LEASE_NONE_LE;
+			lease_update_oplock_levels(opinfo->o_lease);
+		}
 		opinfo->level = SMB2_OPLOCK_LEVEL_NONE;
 		opinfo->op_state = OPLOCK_STATE_NONE;
 	}
@@ -884,8 +940,8 @@ static int smb2_lease_break_noti(struct oplock_info *opinfo)
 	} else {
 		__smb2_lease_break_noti(&work->work);
 		if (opinfo->o_lease->new_state == SMB2_LEASE_NONE_LE) {
-			opinfo->level = SMB2_OPLOCK_LEVEL_NONE;
 			opinfo->o_lease->state = SMB2_LEASE_NONE_LE;
+			lease_update_oplock_levels(opinfo->o_lease);
 		}
 	}
 	return 0;
@@ -990,7 +1046,7 @@ static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level,
 void destroy_lease_table(struct ksmbd_conn *conn)
 {
 	struct lease_table *lb, *lbtmp;
-	struct oplock_info *opinfo;
+	struct lease *lease, *ltmp;
 
 	write_lock(&lease_list_lock);
 	if (list_empty(&lease_table_list)) {
@@ -1002,15 +1058,8 @@ void destroy_lease_table(struct ksmbd_conn *conn)
 		if (conn && memcmp(lb->client_guid, conn->ClientGUID,
 				   SMB2_CLIENT_GUID_SIZE))
 			continue;
-again:
-		rcu_read_lock();
-		list_for_each_entry_rcu(opinfo, &lb->lease_list,
-					lease_entry) {
-			rcu_read_unlock();
-			lease_del_list(opinfo);
-			goto again;
-		}
-		rcu_read_unlock();
+		list_for_each_entry_safe(lease, ltmp, &lb->lease_list, l_entry)
+			lease_del_table(lease);
 		list_del(&lb->l_entry);
 		kfree(lb);
 	}
@@ -1020,7 +1069,7 @@ void destroy_lease_table(struct ksmbd_conn *conn)
 int find_same_lease_key(struct ksmbd_conn *conn, struct ksmbd_inode *ci,
 			struct lease_ctx_info *lctx)
 {
-	struct oplock_info *opinfo;
+	struct lease *lease;
 	int err = 0;
 	struct lease_table *lb;
 
@@ -1043,70 +1092,40 @@ int find_same_lease_key(struct ksmbd_conn *conn, struct ksmbd_inode *ci,
 	return 0;
 
 found:
-	rcu_read_lock();
-	list_for_each_entry_rcu(opinfo, &lb->lease_list, lease_entry) {
-		if (!atomic_inc_not_zero(&opinfo->refcount))
+	list_for_each_entry(lease, &lb->lease_list, l_entry) {
+		if (lease->ci == ci)
 			continue;
-		rcu_read_unlock();
-		if (opinfo->o_fp->f_ci == ci)
-			goto op_next;
-		err = compare_guid_key(opinfo, conn->ClientGUID,
-				       lctx->lease_key);
-		if (err) {
+		if (!memcmp(lease->lease_key, lctx->lease_key,
+			    SMB2_LEASE_KEY_SIZE)) {
 			err = -EINVAL;
 			ksmbd_debug(OPLOCK,
 				    "found same lease key is already used in other files\n");
-			opinfo_put(opinfo);
 			goto out;
 		}
-op_next:
-		opinfo_put(opinfo);
-		rcu_read_lock();
 	}
-	rcu_read_unlock();
 
 out:
 	read_unlock(&lease_list_lock);
 	return err;
 }
 
-static void copy_lease(struct oplock_info *op1, struct oplock_info *op2)
-{
-	struct lease *lease1 = op1->o_lease;
-	struct lease *lease2 = op2->o_lease;
-
-	op2->level = op1->level;
-	lease2->state = lease1->state;
-	memcpy(lease2->lease_key, lease1->lease_key,
-	       SMB2_LEASE_KEY_SIZE);
-	lease2->duration = lease1->duration;
-	lease2->flags = lease1->flags;
-	lease2->epoch = lease1->epoch;
-	lease2->version = lease1->version;
-	lease2->is_dir = lease1->is_dir;
-	memcpy(lease2->parent_lease_key, lease1->parent_lease_key,
-	       SMB2_LEASE_KEY_SIZE);
-}
-
-static void add_lease_global_list(struct oplock_info *opinfo,
+static void add_lease_global_list(struct lease *lease, struct ksmbd_conn *conn,
 				  struct lease_table *new_lb)
 {
 	struct lease_table *lb;
 
 	write_lock(&lease_list_lock);
 	list_for_each_entry(lb, &lease_table_list, l_entry) {
-		if (!memcmp(lb->client_guid, opinfo->conn->ClientGUID,
+		if (!memcmp(lb->client_guid, conn->ClientGUID,
 			    SMB2_CLIENT_GUID_SIZE)) {
-			opinfo->o_lease->l_lb = lb;
-			lease_add_list(opinfo);
+			lease_add_table(lease, lb);
 			write_unlock(&lease_list_lock);
 			kfree(new_lb);
 			return;
 		}
 	}
 
-	opinfo->o_lease->l_lb = new_lb;
-	lease_add_list(opinfo);
+	lease_add_table(lease, new_lb);
 	list_add(&new_lb->l_entry, &lease_table_list);
 	write_unlock(&lease_list_lock);
 }
@@ -1229,6 +1248,7 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 	struct ksmbd_inode *ci = fp->f_ci;
 	struct lease_table *new_lb = NULL;
 	bool prev_op_has_lease;
+	bool new_lease = false;
 	__le32 prev_op_state = 0;
 
 	/* Only v2 leases handle the directory */
@@ -1242,10 +1262,13 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 		return -ENOMEM;
 
 	if (lctx) {
-		err = alloc_lease(opinfo, lctx);
-		if (err)
+		opinfo->o_lease = alloc_lease(lctx, ci);
+		if (!opinfo->o_lease) {
+			err = -ENOMEM;
 			goto err_out;
+		}
 		opinfo->is_lease = 1;
+		new_lease = true;
 	}
 
 	/* ci does not have any oplock */
@@ -1267,7 +1290,11 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 		m_opinfo = same_client_has_lease(ci, work->conn->ClientGUID,
 						 lctx);
 		if (m_opinfo) {
-			copy_lease(m_opinfo, opinfo);
+			lease_put(opinfo->o_lease);
+			lease_get(m_opinfo->o_lease);
+			opinfo->o_lease = m_opinfo->o_lease;
+			opinfo->level = m_opinfo->level;
+			new_lease = false;
 			if (atomic_read(&m_opinfo->breaking_cnt))
 				opinfo->o_lease->flags |=
 					SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE;
@@ -1330,17 +1357,13 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 
 out:
 	/*
-	 * Set o_fp before any publication so that concurrent readers
-	 * (e.g. find_same_lease_key() on the lease list) that
-	 * dereference opinfo->o_fp don't hit a NULL pointer.
-	 *
 	 * Keep the original publication order so concurrent opens can
 	 * still observe the in-flight grant via ci->m_op_list, but make
 	 * everything after opinfo_add() no-fail by preallocating any new
 	 * lease_table first.
 	 */
 	opinfo->o_fp = fp;
-	if (opinfo->is_lease) {
+	if (new_lease) {
 		new_lb = alloc_lease_table(opinfo);
 		if (!new_lb) {
 			err = -ENOMEM;
@@ -1351,8 +1374,10 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 	opinfo_count_inc(fp);
 	opinfo_add(opinfo, fp);
 
+	if (new_lease)
+		add_lease_global_list(opinfo->o_lease, opinfo->conn, new_lb);
 	if (opinfo->is_lease)
-		add_lease_global_list(opinfo, new_lb);
+		lease_add_open(opinfo->o_lease, opinfo);
 
 	rcu_assign_pointer(fp->f_opinfo, opinfo);
 
@@ -1834,8 +1859,8 @@ struct oplock_info *lookup_lease_in_table(struct ksmbd_conn *conn,
 					  char *lease_key)
 {
 	struct oplock_info *opinfo = NULL, *ret_op = NULL;
+	struct lease *lease;
 	struct lease_table *lt;
-	int ret;
 
 	read_lock(&lease_list_lock);
 	list_for_each_entry(lt, &lease_table_list, l_entry) {
@@ -1848,29 +1873,30 @@ struct oplock_info *lookup_lease_in_table(struct ksmbd_conn *conn,
 	return NULL;
 
 found:
-	rcu_read_lock();
-	list_for_each_entry_rcu(opinfo, &lt->lease_list, lease_entry) {
-		if (!atomic_inc_not_zero(&opinfo->refcount))
+	list_for_each_entry(lease, &lt->lease_list, l_entry) {
+		if (memcmp(lease->lease_key, lease_key, SMB2_LEASE_KEY_SIZE))
 			continue;
-		rcu_read_unlock();
-		if (!opinfo->op_state || opinfo->op_state == OPLOCK_CLOSING)
-			goto op_next;
-		if (!(opinfo->o_lease->state &
-		      (SMB2_LEASE_HANDLE_CACHING_LE |
-		       SMB2_LEASE_WRITE_CACHING_LE)))
-			goto op_next;
-		ret = compare_guid_key(opinfo, conn->ClientGUID,
-				       lease_key);
-		if (ret) {
-			ksmbd_debug(OPLOCK, "found opinfo\n");
+		if (!(lease->state & (SMB2_LEASE_HANDLE_CACHING_LE |
+				      SMB2_LEASE_WRITE_CACHING_LE)))
+			break;
+
+		spin_lock(&lease->lock);
+		list_for_each_entry(opinfo, &lease->open_list, lease_entry) {
+			if (!opinfo->op_state ||
+			    opinfo->op_state == OPLOCK_CLOSING)
+				continue;
+			if (!atomic_inc_not_zero(&opinfo->refcount))
+				continue;
 			ret_op = opinfo;
+			break;
+		}
+		spin_unlock(&lease->lock);
+		if (ret_op) {
+			ksmbd_debug(OPLOCK, "found opinfo\n");
 			goto out;
 		}
-op_next:
-		opinfo_put(opinfo);
-		rcu_read_lock();
+		break;
 	}
-	rcu_read_unlock();
 
 out:
 	read_unlock(&lease_list_lock);
diff --git a/fs/smb/server/oplock.h b/fs/smb/server/oplock.h
index 795a9119dad9..30bad6d65048 100644
--- a/fs/smb/server/oplock.h
+++ b/fs/smb/server/oplock.h
@@ -49,7 +49,12 @@ struct lease {
 	int			version;
 	unsigned short		epoch;
 	bool			is_dir;
+	struct ksmbd_inode	*ci;
 	struct lease_table	*l_lb;
+	struct list_head	l_entry;
+	struct list_head	open_list;
+	spinlock_t		lock;
+	atomic_t		refcount;
 };
 
 struct oplock_info {
@@ -105,6 +110,7 @@ void opinfo_put(struct oplock_info *opinfo);
 void create_lease_buf(u8 *rbuf, struct lease *lease);
 struct lease_ctx_info *parse_lease_state(void *open_req);
 __u8 smb2_map_lease_to_oplock(__le32 lease_state);
+void lease_update_oplock_levels(struct lease *lease);
 int lease_read_to_write(struct oplock_info *opinfo);
 
 /* Durable related functions */
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6e211618c207..a2c397f4dd8b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -9087,7 +9087,7 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 	lease_state = req->LeaseState;
 	lease->state = lease_state;
 	lease->new_state = SMB2_LEASE_NONE_LE;
-	opinfo->level = smb2_map_lease_to_oplock(lease_state);
+	lease_update_oplock_levels(lease);
 
 	rsp->StructureSize = cpu_to_le16(36);
 	rsp->Reserved = 0;
-- 
2.25.1

