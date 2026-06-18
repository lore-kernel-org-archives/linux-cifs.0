Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8F12609DC
	for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 14:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781792288; cv=none; b=bR2IqmCRy8HlLpWyeLBulTk75buQ11gqlDXKeTLU8sXoWO83Jv3JfOvu3naWo9mXokuCo7Oh4yb3Lhy3bqH5BdSJ2J/TaWqN34XTpbFV470a37FEipM79aeNCmYiOr51vsFjnW+5rsm0cyP3AiScgzAvEUFFRjVHHp1cTZODz08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781792288; c=relaxed/simple;
	bh=62qzi6q5Zxk8ZumOEnIcI9g8GP3T7gmbff6EaSWaapo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tGa/n29mmGdt+DspqYIhZwA3TfKjv9EBsUbTuLh135N31oXi/xYHJeWUQDe1T5Nmxa8fw+0XouSx9jg+s3+3sNiBe1r5kjGB2UoRRVM9yEqb3T1CvCCtZpfNFqQtv7GPp3hOW1lshOemQyWGRvG+rcKFkywWbny+2QrMyC7F+eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GN/MyYFw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GN/MyYFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 835701F000E9;
	Thu, 18 Jun 2026 14:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781792286;
	bh=1rCZW+osAMF9bBeiqDNILLqeHZT4AgTuzRcjfaMFt+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GN/MyYFwbfS3mbP0HIcHgRMdriiVe25MWd6YdjVmCAIXM0NFwd0WGbYyVdrWqUbET
	 Q84SYndf1vjXOmD396P6nzUn6hrjiF0fUHRXbJGxcmk5lZSDuMcY8ZEGcAApDl+J4A
	 PFNa9QxSpWepltONKydmBFbkeYSB3M/SA6w+WjmKG0CZCQumU1QrezjaK/XfmXtxI+
	 GcLuijjwJUa33jiFUiffgmVUoD4TpvxG+yNxZpzSq65NYukhy6NLPyEg1pJWN6D6ot
	 uEbB2wtFiksrYi2Ql+OEUdAyWh3Y7m5e+3tlVNdpLIT968FWRqq9Ec9fmKDTLvQspF
	 x849tY680s1dA==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	metze@samba.org,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 10/14] ksmbd: do not wait for RH lease break ack on overwrite
Date: Thu, 18 Jun 2026 23:17:35 +0900
Message-Id: <20260618141739.9029-10-linkinjeon@kernel.org>
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

smb2.lease.breaking4 expects an overwrite against an RH lease to send
RH->NONE lease break notification but complete the triggering create
without waiting for the break ack.

Keep the lease in break-in-progress state until the client eventually
acknowledges the downgrade, but do not hold the overwrite request behind
that ack.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 34c667003c8e..f5a2ac927898 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -927,7 +927,7 @@ static void __smb2_lease_break_noti(struct work_struct *wk)
  *
  * Return:	0 on success, otherwise error
  */
-static int smb2_lease_break_noti(struct oplock_info *opinfo)
+static int smb2_lease_break_noti(struct oplock_info *opinfo, bool wait_ack)
 {
 	struct ksmbd_conn *conn;
 	struct ksmbd_work *work;
@@ -964,7 +964,8 @@ static int smb2_lease_break_noti(struct oplock_info *opinfo)
 	if (opinfo->op_state == OPLOCK_ACK_WAIT) {
 		INIT_WORK(&work->work, __smb2_lease_break_noti);
 		ksmbd_queue_work(work);
-		wait_for_break_ack(opinfo);
+		if (wait_ack)
+			wait_for_break_ack(opinfo);
 	} else {
 		__smb2_lease_break_noti(&work->work);
 		if (opinfo->o_lease->new_state == SMB2_LEASE_NONE_LE) {
@@ -1006,6 +1007,7 @@ static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level,
 	if (brk_opinfo->is_lease) {
 		struct lease *lease = brk_opinfo->o_lease;
 		bool open_trunc = brk_opinfo->open_trunc;
+		bool wait_ack;
 
 		if (in_work && test_bit(0, &brk_opinfo->pending_break)) {
 			setup_async_work(in_work, NULL, NULL);
@@ -1058,14 +1060,19 @@ static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level,
 		} else
 			atomic_dec(&brk_opinfo->breaking_cnt);
 
-		err = smb2_lease_break_noti(brk_opinfo);
+		wait_ack = !(open_trunc &&
+			     lease->state == (SMB2_LEASE_READ_CACHING_LE |
+					      SMB2_LEASE_HANDLE_CACHING_LE));
+		err = smb2_lease_break_noti(brk_opinfo, wait_ack);
 
 		ksmbd_debug(OPLOCK, "oplock granted = %d\n", brk_opinfo->level);
 		if (brk_opinfo->op_state == OPLOCK_CLOSING)
 			err = -ENOENT;
 
-		wait_lease_breaking(brk_opinfo);
-		if (!err && lease_break_needed(brk_opinfo, req_op_level, open_trunc))
+		if (wait_ack)
+			wait_lease_breaking(brk_opinfo);
+		if (wait_ack && !err &&
+		    lease_break_needed(brk_opinfo, req_op_level, open_trunc))
 			goto again;
 
 		wake_up_oplock_break(brk_opinfo);
-- 
2.25.1

