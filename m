Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6B02609DC
	for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 14:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781792284; cv=none; b=C6hdTi84OMRAgA42uuLQ6TbtmJz3lETE+O9Q5oCaGunTrl9xFvDvyeQA4XSzaWRlBUyblNwNLtc01jlRJWWWEtjW03idDrRnVxk6PE0rulWRnVFzT6mrbA8iXTnMpwGdlDrDHn3FdtGgZrfKsPMC6ik1RtZrXOedokjOak53LvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781792284; c=relaxed/simple;
	bh=iJw0BOT+1Tb3oVd3FB91DVAVMEyxbKriWe/wYxARjIM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NgiCFoJmF/uKnrFLGs70yfys7iuXW8PyOZByTRV1fW7Rojur4A6IMSmevFCT5vvSWc3o5EYnXImaDso75rRMRI5uhoa0cPBOUwYBORWueePlSNNxnQCWQIaxxZPiGRZ6OyQZCNckYpYd3JouW11Z/J0spJN33tIpoWZBuaUT7sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bqVTcY32; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bqVTcY32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B091F000E9;
	Thu, 18 Jun 2026 14:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781792282;
	bh=yHc4V/4xs9RlP/5sadKBZr2P6JLp60eLAgcM1/wPVOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bqVTcY32QIjSp2TwpxmpRs5BH6oJy7Gx1CUkne7jExHtHCegzl1WcnrIMhLz/D/lg
	 zdjYwGXbFcI5VgH9SKJUiJwVBFNCzrU9FuhquwzEP9NHeq1v/HZ3MWvDPFRXsJLdqE
	 FksHtSgb9TyxZHBqQyWASdvebFzZVp0HMDSktFTyKFkuOkfYK12gMBfvZ/gDkq4C6v
	 ogjAJaUk/oVzYEsANCPpzPWKOfk1UCF64a4FXawfep086Gxcbvdd354hHiG40WpnNt
	 +ZxzYz7ODJdpMcTkbC04XlybA2bDD3ACrgjWa82Wwzsbw36XasUf1W17X0Bx5EvxxA
	 WHTmrKhPOGrXw==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	metze@samba.org,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 09/14] ksmbd: chain pending lease breaks before waking waiters
Date: Thu, 18 Jun 2026 23:17:34 +0900
Message-Id: <20260618141739.9029-9-linkinjeon@kernel.org>
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

A pending open can require more than one lease break before the existing
lease becomes compatible with the operation that triggered the break.
smb2.lease.breaking3 expects the server to hold the pending normal open
through RWH->RH and RH->R, while a later overwrite waiter must not
collapse that second break directly to RH->NONE.

Keep pending_break held for lease breaks until the current triggering
operation is compatible with the lease state. Snapshot the truncate request
per oplock_break() call so another waiter cannot overwrite the state of
the active break.

Use the requested oplock level when deciding whether to chain another
break. A second lease open only needs RWH->RH, while a normal none-oplock
open can continue down to R and then NONE.

For non-truncating metadata operations, break leases only down to read
caching. Operations such as delete-on-close need to drop handle caching,
but should not send a second R->NONE break after the client acknowledges
RH->R.

Also send STATUS_PENDING for levelII/read-lease break waiters. An async
SMB2 create becomes cancelable only after the server sends
an NT_STATUS_PENDING interim response. A waiter that blocks behind an
already active lease break must receive the interim response before
sleeping on pending_break, otherwise the client can process a later lease
break while the create request is still not marked pending.

Avoid duplicate interim responses when an overwrite first breaks a write
oplock and then scans levelII/read leases.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c | 98 ++++++++++++++++++++++++++++++++----------
 1 file changed, 75 insertions(+), 23 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index b1740fe988e6..34c667003c8e 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -727,6 +727,17 @@ static int oplock_break_pending(struct oplock_info *opinfo, int req_op_level)
 	return 0;
 }
 
+static bool lease_break_needed(struct oplock_info *opinfo, int req_op_level,
+			       bool open_trunc)
+{
+	struct lease *lease = opinfo->o_lease;
+
+	if (open_trunc)
+		return lease->state != SMB2_LEASE_NONE_LE;
+
+	return opinfo->level > req_op_level;
+}
+
 /**
  * __smb2_oplock_break_noti() - send smb2 oplock break cmd from conn
  * to client
@@ -985,6 +996,7 @@ static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level,
 			struct ksmbd_work *in_work)
 {
 	int err = 0;
+	bool sent_interim = false;
 
 	/* Need to break exclusive/batch oplock, write lease or overwrite_if */
 	ksmbd_debug(OPLOCK,
@@ -993,13 +1005,22 @@ static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level,
 
 	if (brk_opinfo->is_lease) {
 		struct lease *lease = brk_opinfo->o_lease;
+		bool open_trunc = brk_opinfo->open_trunc;
+
+		if (in_work && test_bit(0, &brk_opinfo->pending_break)) {
+			setup_async_work(in_work, NULL, NULL);
+			smb2_send_interim_resp(in_work, STATUS_PENDING);
+			release_async_work(in_work);
+			sent_interim = true;
+		}
 
-		atomic_inc(&brk_opinfo->breaking_cnt);
 		err = oplock_break_pending(brk_opinfo, req_op_level);
 		if (err)
 			return err < 0 ? err : 0;
 
-		if (brk_opinfo->open_trunc) {
+again:
+		atomic_inc(&brk_opinfo->breaking_cnt);
+		if (open_trunc) {
 			/*
 			 * Create overwrite break trigger the lease break to
 			 * none.
@@ -1024,17 +1045,31 @@ static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level,
 			}
 		}
 
+		if (in_work && !sent_interim) {
+			setup_async_work(in_work, NULL, NULL);
+			smb2_send_interim_resp(in_work, STATUS_PENDING);
+			release_async_work(in_work);
+			sent_interim = true;
+		}
+
 		if (lease->state & (SMB2_LEASE_WRITE_CACHING_LE |
 				SMB2_LEASE_HANDLE_CACHING_LE)) {
-			if (in_work) {
-				setup_async_work(in_work, NULL, NULL);
-				smb2_send_interim_resp(in_work, STATUS_PENDING);
-				release_async_work(in_work);
-			}
-
 			brk_opinfo->op_state = OPLOCK_ACK_WAIT;
 		} else
 			atomic_dec(&brk_opinfo->breaking_cnt);
+
+		err = smb2_lease_break_noti(brk_opinfo);
+
+		ksmbd_debug(OPLOCK, "oplock granted = %d\n", brk_opinfo->level);
+		if (brk_opinfo->op_state == OPLOCK_CLOSING)
+			err = -ENOENT;
+
+		wait_lease_breaking(brk_opinfo);
+		if (!err && lease_break_needed(brk_opinfo, req_op_level, open_trunc))
+			goto again;
+
+		wake_up_oplock_break(brk_opinfo);
+		return err;
 	} else {
 		err = oplock_break_pending(brk_opinfo, req_op_level);
 		if (err)
@@ -1045,18 +1080,13 @@ static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level,
 			brk_opinfo->op_state = OPLOCK_ACK_WAIT;
 	}
 
-	if (brk_opinfo->is_lease)
-		err = smb2_lease_break_noti(brk_opinfo);
-	else
-		err = smb2_oplock_break_noti(brk_opinfo);
+	err = smb2_oplock_break_noti(brk_opinfo);
 
 	ksmbd_debug(OPLOCK, "oplock granted = %d\n", brk_opinfo->level);
 	if (brk_opinfo->op_state == OPLOCK_CLOSING)
 		err = -ENOENT;
 	wake_up_oplock_break(brk_opinfo);
 
-	wait_lease_breaking(brk_opinfo);
-
 	return err;
 }
 
@@ -1261,6 +1291,7 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 		     struct lease_ctx_info *lctx, int share_ret)
 {
 	int err = 0;
+	int break_level = SMB2_OPLOCK_LEVEL_II;
 	struct oplock_info *opinfo = NULL, *prev_opinfo = NULL;
 	struct ksmbd_inode *ci = fp->f_ci;
 	struct lease_table *new_lb = NULL;
@@ -1325,6 +1356,9 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 	prev_op_has_lease = prev_opinfo->is_lease;
 	if (prev_op_has_lease)
 		prev_op_state = prev_opinfo->o_lease->state;
+	if (prev_op_has_lease && !lctx &&
+	    prev_op_state & SMB2_LEASE_HANDLE_CACHING_LE)
+		break_level = SMB2_OPLOCK_LEVEL_NONE;
 
 	if (share_ret < 0 &&
 	    prev_opinfo->level == SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
@@ -1339,7 +1373,7 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 		goto op_break_not_needed;
 	}
 
-	err = oplock_break(prev_opinfo, SMB2_OPLOCK_LEVEL_II, work);
+	err = oplock_break(prev_opinfo, break_level, work);
 	opinfo_put(prev_opinfo);
 	if (err == -ENOENT)
 		goto set_lev;
@@ -1408,23 +1442,27 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
  * @fp:		ksmbd file pointer
  * @is_trunc:	truncate on open
  */
-static void smb_break_all_write_oplock(struct ksmbd_work *work,
+static bool smb_break_all_write_oplock(struct ksmbd_work *work,
 				       struct ksmbd_file *fp, int is_trunc)
 {
 	struct oplock_info *brk_opinfo;
+	bool sent_break = false;
 
 	brk_opinfo = opinfo_get_list(fp->f_ci);
 	if (!brk_opinfo)
-		return;
+		return false;
 	if (brk_opinfo->level != SMB2_OPLOCK_LEVEL_BATCH &&
 	    brk_opinfo->level != SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
 		opinfo_put(brk_opinfo);
-		return;
+		return false;
 	}
 
 	brk_opinfo->open_trunc = is_trunc;
 	oplock_break(brk_opinfo, SMB2_OPLOCK_LEVEL_II, work);
+	sent_break = true;
 	opinfo_put(brk_opinfo);
+
+	return sent_break;
 }
 
 /**
@@ -1434,12 +1472,14 @@ static void smb_break_all_write_oplock(struct ksmbd_work *work,
  * @fp:		ksmbd file pointer
  * @is_trunc:	truncate on open
  */
-void smb_break_all_levII_oplock(struct ksmbd_work *work, struct ksmbd_file *fp,
-				int is_trunc)
+static void __smb_break_all_levII_oplock(struct ksmbd_work *work,
+					 struct ksmbd_file *fp, int is_trunc,
+					 bool send_interim)
 {
 	struct oplock_info *op, *brk_op;
 	struct ksmbd_inode *ci;
 	struct ksmbd_conn *conn = work->conn;
+	bool sent_interim = false;
 
 	if (!test_share_config_flag(work->tcon->share_conf,
 				    KSMBD_SHARE_FLAG_OPLOCKS))
@@ -1481,7 +1521,11 @@ void smb_break_all_levII_oplock(struct ksmbd_work *work, struct ksmbd_file *fp,
 			    SMB2_LEASE_KEY_SIZE))
 			goto next;
 		brk_op->open_trunc = is_trunc;
-		oplock_break(brk_op, SMB2_OPLOCK_LEVEL_NONE, NULL);
+		oplock_break(brk_op,
+			     brk_op->is_lease && !is_trunc ?
+			     SMB2_OPLOCK_LEVEL_II : SMB2_OPLOCK_LEVEL_NONE,
+			     send_interim && !sent_interim ? work : NULL);
+		sent_interim = true;
 next:
 		opinfo_put(brk_op);
 	}
@@ -1491,6 +1535,12 @@ void smb_break_all_levII_oplock(struct ksmbd_work *work, struct ksmbd_file *fp,
 		opinfo_put(op);
 }
 
+void smb_break_all_levII_oplock(struct ksmbd_work *work, struct ksmbd_file *fp,
+				int is_trunc)
+{
+	__smb_break_all_levII_oplock(work, fp, is_trunc, true);
+}
+
 /**
  * smb_break_all_oplock() - break both batch/exclusive and level2 oplock
  * @work:	smb work
@@ -1498,12 +1548,14 @@ void smb_break_all_levII_oplock(struct ksmbd_work *work, struct ksmbd_file *fp,
  */
 void smb_break_all_oplock(struct ksmbd_work *work, struct ksmbd_file *fp)
 {
+	bool sent_break;
+
 	if (!test_share_config_flag(work->tcon->share_conf,
 				    KSMBD_SHARE_FLAG_OPLOCKS))
 		return;
 
-	smb_break_all_write_oplock(work, fp, 1);
-	smb_break_all_levII_oplock(work, fp, 1);
+	sent_break = smb_break_all_write_oplock(work, fp, 1);
+	__smb_break_all_levII_oplock(work, fp, 1, !sent_break);
 }
 
 /**
-- 
2.25.1

