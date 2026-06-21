Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36F572621
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 12:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046139; cv=none; b=oe0XTBo3ErKsW+YzoCD33WmGSQHrLGZK2zaNpMfrvhu02N2hsfCVI23L9Co4Af8Pq/U3hESEZzMpko0yJsktmKaMJ9jj7mcsOrsb+nvXj09nCjox9Qj1LKCDb+BIC6S4t4QMChCYOy0RXthW8bekBM3v6r3wZpS1pJeWTqc2U28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046139; c=relaxed/simple;
	bh=lkCmmY5UWwcKAX9pbcUXOpLsrRwxo/9Ar2AtKGF+OW8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Fg7/jeCxTtrz359vkg1yz1reGefxp/my+qo9YTDXUgPtR8/7MoNBhCt2SgvfxZjmcLGVfctioPUPp6289ZE6MIoj9LqkcH884a8s4xCJZrmvKbxh5VXUJbGjTzKyYKboe0BqBOgbHz9oUbwqsUtjPMqf7HlQWxzEnAmsmP53e1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RRHVgoz+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RRHVgoz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E481F000E9;
	Sun, 21 Jun 2026 12:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782046136;
	bh=y3W4uLe3owP89nm3eVdcLwaBVAvrfC/wXfI+I5rijaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RRHVgoz+igEBwVSNXSg2x3EXx6VeWbRpilARIOFTrx6oZtUxIdvfVS76zTG77l1US
	 Fkdmfnl/NoZxk2GQqRXFHndP6zYuAkBMEOp95fxh5Md0Q4I3Cwh9fMhd5FZ911yxzC
	 ZWFSN9OkbS29LEh3qEla0XUS9cdw3JCJHoGKKDHowt6Iow+d4TlvtR1IUtn93nfHhz
	 q3brKgoFB1LprUTd6VnMq7IsUF5zWQ0yT2/XLGoKC0lEoFEkHJKBX0eM7RfUW/88Q6
	 WYNQyhkKkgcoIBVhiQhBTITBg3vfKR42SpHBUPk/XqXtRUBEGYHzYuE/owcLy72e+i
	 KTZDLU9zduBQQ==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 03/29] ksmbd: invalidate durable handles on oplock break
Date: Sun, 21 Jun 2026 21:48:18 +0900
Message-Id: <20260621124844.6235-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260621124844.6235-1-linkinjeon@kernel.org>
References: <20260621124844.6235-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a durable handle is preserved after a disconnect, its oplock state
can still block later opens. If another client opens the same file and
the preserved oplock or lease has to be broken, the old durable handle
must no longer be reconnectable after the break cannot be acknowledged.

ksmbd was treating a missing connection, or an oplock break timeout, as a
successful break only by downgrading the oplock state.  The old durable
handle remained reconnectable, so a later durable reconnect for that
stale handle could succeed.

The open path can also see a detached durable handle before the break
notification helpers fully dispose of it. Invalidate such a preserved
durable handle directly when a competing open has to break its batch or
exclusive oplock, while leaving ordinary durable reconnects without a
competing open untouched.

If the old handle still reaches the reconnect path, reject it when the
same inode already has another active open. This matches the
smb2.durable-open.open2-lease/open2-oplock sequence where a later open
replaces the disconnected durable owner and the stale first handle must
not be reclaimed.

Also, reconnect lookup used only the persistent id. A new durable open
can get a persistent id that matches the stale reconnect request after
the old durable state is invalidated. Preserve the disconnected
handle's old volatile id and require durable reconnect contexts to match
it, so a stale reconnect cannot attach to a different durable open.

Windows allows the later open to proceed and rejects the old reconnect
with STATUS_OBJECT_NAME_NOT_FOUND. The smbtorture
smb2.durable-open.oplock test covers this case.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c    | 40 +++++++++++++++++++++++++------
 fs/smb/server/smb2pdu.c   | 14 +++++++++++
 fs/smb/server/vfs_cache.c | 50 ++++++++++++++++++++++++++++++++++++++-
 fs/smb/server/vfs_cache.h |  4 ++++
 4 files changed, 100 insertions(+), 8 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 0a97d86cabf5..50cc067696d3 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -676,7 +676,7 @@ static struct oplock_info *same_client_has_lease(struct ksmbd_inode *ci,
 	return m_opinfo;
 }
 
-static void wait_for_break_ack(struct oplock_info *opinfo)
+static bool wait_for_break_ack(struct oplock_info *opinfo)
 {
 	int rc = 0;
 
@@ -693,7 +693,10 @@ static void wait_for_break_ack(struct oplock_info *opinfo)
 		}
 		opinfo->level = SMB2_OPLOCK_LEVEL_NONE;
 		opinfo->op_state = OPLOCK_STATE_NONE;
+		return true;
 	}
+
+	return false;
 }
 
 static void wake_up_oplock_break(struct oplock_info *opinfo)
@@ -843,7 +846,7 @@ static int smb2_oplock_break_noti(struct oplock_info *opinfo)
 
 	conn = READ_ONCE(opinfo->conn);
 	if (!conn)
-		return 0;
+		return ksmbd_invalidate_durable_fd(opinfo->fid);
 
 	work = ksmbd_alloc_work_struct();
 	if (!work)
@@ -868,7 +871,8 @@ static int smb2_oplock_break_noti(struct oplock_info *opinfo)
 		INIT_WORK(&work->work, __smb2_oplock_break_noti);
 		ksmbd_queue_work(work);
 
-		wait_for_break_ack(opinfo);
+		if (wait_for_break_ack(opinfo))
+			ret = ksmbd_invalidate_durable_fd(opinfo->fid);
 	} else {
 		__smb2_oplock_break_noti(&work->work);
 		if (opinfo->level == SMB2_OPLOCK_LEVEL_II)
@@ -950,13 +954,14 @@ static int smb2_lease_break_noti(struct oplock_info *opinfo, bool wait_ack,
 	struct ksmbd_work *work;
 	struct lease_break_info *br_info;
 	struct lease *lease = opinfo->o_lease;
+	int ret = 0;
 
 	conn = READ_ONCE(opinfo->conn);
 	if (lease->version == 2 && lease->l_lb && lease->l_lb->conn &&
 	    !ksmbd_conn_releasing(lease->l_lb->conn))
 		conn = lease->l_lb->conn;
 	if (!conn)
-		return 0;
+		return ksmbd_invalidate_durable_fd(opinfo->fid);
 
 	work = ksmbd_alloc_work_struct();
 	if (!work)
@@ -987,8 +992,10 @@ static int smb2_lease_break_noti(struct oplock_info *opinfo, bool wait_ack,
 	if (opinfo->op_state == OPLOCK_ACK_WAIT) {
 		INIT_WORK(&work->work, __smb2_lease_break_noti);
 		ksmbd_queue_work(work);
-		if (wait_ack)
-			wait_for_break_ack(opinfo);
+		if (wait_ack) {
+			if (wait_for_break_ack(opinfo))
+				ret = ksmbd_invalidate_durable_fd(opinfo->fid);
+		}
 	} else {
 		__smb2_lease_break_noti(&work->work);
 		if (opinfo->o_lease->new_state == SMB2_LEASE_NONE_LE) {
@@ -996,7 +1003,7 @@ static int smb2_lease_break_noti(struct oplock_info *opinfo, bool wait_ack,
 			lease_update_oplock_levels(opinfo->o_lease);
 		}
 	}
-	return 0;
+	return ret;
 }
 
 static void wait_lease_breaking(struct oplock_info *opinfo)
@@ -1335,6 +1342,9 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 	struct ksmbd_inode *ci = fp->f_ci;
 	struct lease_table *new_lb = NULL;
 	bool prev_op_has_lease;
+	bool prev_durable_open = false;
+	bool prev_durable_detached = false;
+	unsigned long long prev_fid = KSMBD_NO_FID;
 	bool new_lease = false;
 	__le32 prev_op_state = 0;
 
@@ -1412,7 +1422,17 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 		goto op_break_not_needed;
 	}
 
+	if (prev_opinfo->o_fp && prev_opinfo->o_fp != fp &&
+	    prev_opinfo->o_fp->is_durable) {
+		prev_durable_open = true;
+		prev_durable_detached = !prev_opinfo->o_fp->conn ||
+					!prev_opinfo->o_fp->tcon;
+		prev_fid = prev_opinfo->fid;
+	}
+
 	err = oplock_break(prev_opinfo, break_level, work);
+	if (prev_durable_detached || (prev_durable_open && err == -ENOENT))
+		ksmbd_invalidate_durable_fd(prev_fid);
 	opinfo_put(prev_opinfo);
 	if (err == -ENOENT)
 		goto set_lev;
@@ -2027,6 +2047,12 @@ int smb2_check_durable_oplock(struct ksmbd_conn *conn,
 	if (!opinfo)
 		return 0;
 
+	if (ksmbd_has_other_active_fd(fp)) {
+		ksmbd_debug(SMB, "Durable handle reconnect failed: competing open\n");
+		ret = -EBADF;
+		goto out;
+	}
+
 	if (ksmbd_vfs_compare_durable_owner(fp, user) == false) {
 		ksmbd_debug(SMB, "Durable handle reconnect failed: owner mismatch\n");
 		ret = -EBADF;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 37a20c5740cd..f700f2f94ff2 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2861,6 +2861,13 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 				goto out;
 			}
 
+			if (dh_info->fp->durable_volatile_id !=
+			    recon_v2->dcontext.Fid.VolatileFileId) {
+				err = -EBADF;
+				ksmbd_put_durable_fd(dh_info->fp);
+				goto out;
+			}
+
 			if (memcmp(dh_info->fp->create_guid, recon_v2->dcontext.CreateGuid,
 				   SMB2_CREATE_GUID_SIZE)) {
 				err = -EBADF;
@@ -2901,6 +2908,13 @@ static int parse_durable_handle_context(struct ksmbd_work *work,
 				goto out;
 			}
 
+			if (dh_info->fp->durable_volatile_id !=
+			    recon->Data.Fid.VolatileFileId) {
+				err = -EBADF;
+				ksmbd_put_durable_fd(dh_info->fp);
+				goto out;
+			}
+
 			dh_info->type = dh_idx;
 			dh_info->reconnected = true;
 			ksmbd_debug(SMB, "reconnect Persistent-id from reconnect = %llu\n",
diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 96fa3f160d5b..3546d95df76f 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -731,7 +731,8 @@ struct ksmbd_file *ksmbd_lookup_durable_fd(unsigned long long id)
 	struct ksmbd_file *fp;
 
 	fp = __ksmbd_lookup_fd(&global_ft, id);
-	if (fp && (fp->conn ||
+	if (fp && (fp->durable_reconnect_disabled ||
+		   fp->conn ||
 		   (fp->durable_scavenger_timeout &&
 		    (fp->durable_scavenger_timeout <
 		     jiffies_to_msecs(jiffies))))) {
@@ -750,6 +751,52 @@ void ksmbd_put_durable_fd(struct ksmbd_file *fp)
 	__ksmbd_close_fd(NULL, fp);
 }
 
+bool ksmbd_has_other_active_fd(struct ksmbd_file *fp)
+{
+	struct ksmbd_file *lfp;
+	struct ksmbd_inode *ci = fp->f_ci;
+	bool ret = false;
+
+	down_read(&ci->m_lock);
+	list_for_each_entry(lfp, &ci->m_fp_list, node) {
+		if (lfp == fp)
+			continue;
+
+		if (lfp->f_state == FP_INITED &&
+		    (READ_ONCE(lfp->conn) || READ_ONCE(lfp->tcon))) {
+			ret = true;
+			break;
+		}
+	}
+	up_read(&ci->m_lock);
+
+	return ret;
+}
+
+int ksmbd_invalidate_durable_fd(unsigned long long id)
+{
+	struct ksmbd_file *fp;
+
+	fp = ksmbd_lookup_global_fd(id);
+	if (!fp)
+		return -ENOENT;
+
+	fp->durable_reconnect_disabled = true;
+
+	if (fp->conn) {
+		ksmbd_put_durable_fd(fp);
+		return -ENOENT;
+	}
+
+	fp->durable_timeout = 1;
+	fp->durable_scavenger_timeout = jiffies_to_msecs(jiffies);
+	ksmbd_put_durable_fd(fp);
+	if (waitqueue_active(&dh_wq))
+		wake_up(&dh_wq);
+
+	return -ENOENT;
+}
+
 struct ksmbd_file *ksmbd_lookup_fd_cguid(char *cguid)
 {
 	struct ksmbd_file	*fp = NULL;
@@ -990,6 +1037,7 @@ __close_file_table_ids(struct ksmbd_session *sess,
 			 * global_ft.
 			 */
 			idr_remove(ft->idr, id);
+			fp->durable_volatile_id = fp->volatile_id;
 			fp->volatile_id = KSMBD_NO_FID;
 			write_unlock(&ft->lock);
 
diff --git a/fs/smb/server/vfs_cache.h b/fs/smb/server/vfs_cache.h
index 21c24956c7c2..4803f41a91ef 100644
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -81,6 +81,7 @@ struct ksmbd_file {
 	struct file			*filp;
 	u64				persistent_id;
 	u64				volatile_id;
+	u64				durable_volatile_id;
 
 	spinlock_t			f_lock;
 
@@ -122,6 +123,7 @@ struct ksmbd_file {
 	bool				is_durable;
 	bool				is_persistent;
 	bool				is_resilient;
+	bool				durable_reconnect_disabled;
 
 	bool                            is_posix_ctxt;
 	struct durable_owner		owner;
@@ -164,6 +166,8 @@ bool ksmbd_close_disconnected_durable_delete_on_close(struct dentry *dentry);
 struct ksmbd_file *ksmbd_lookup_global_fd(unsigned long long id);
 struct ksmbd_file *ksmbd_lookup_durable_fd(unsigned long long id);
 void ksmbd_put_durable_fd(struct ksmbd_file *fp);
+int ksmbd_invalidate_durable_fd(unsigned long long id);
+bool ksmbd_has_other_active_fd(struct ksmbd_file *fp);
 struct ksmbd_file *ksmbd_lookup_fd_cguid(char *cguid);
 struct ksmbd_file *ksmbd_lookup_fd_inode(struct dentry *dentry);
 unsigned int ksmbd_open_durable_fd(struct ksmbd_file *fp);
-- 
2.25.1

