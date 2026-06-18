Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D362EC083
	for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 14:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781792270; cv=none; b=BDPyGbJCxc7T1ZXnQEGjnnQVdaSaGKXDsyHGwalVwEIlYex9QeXCKV+zq3VoahdocMeMth0eR60/XcsWf+atkIp8/Z42vmczGEVeoMFkXnoPZe6AyD0NM5aW/N6c335gk4Pff6txthVDYbNQJpsH0PJccSqp6vrkDv3NOZF5G5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781792270; c=relaxed/simple;
	bh=qaCGCYeNyQ5mVQzXeG5FRXCJf/AUiblzLCSLia6e7+U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rnQ/z9YGQNTA430ftPZ4qe50s3qbO5YEKpknUz30uC2RmXPXKD2/9rdVFaIrx6M6MuxcdviPF+hUYsBag31FMtc053aSH1CcF4273bYz2HGksVkbITASpdV4RN1bYdyq8TfK/1kAANzPBmLlA7NCP0yg02jDIMLalgIMSL+EArA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B0FBngu3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B0FBngu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDB91F000E9;
	Thu, 18 Jun 2026 14:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781792269;
	bh=DhpJpG4Fh+ZAfPRmYxwX0VT8WlVcvUYJMSn0bxxoghA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B0FBngu3HyUXKzUX6nq/VAAAJZTqSyL3aXpw8sj4JqXkaZ236r3O0K0ogGjMqN8Zd
	 g1yFvaokRJeW4+cJKjF9fs0TUC8vNcoQk3oJTMh/giPaErGuQQlE+hjOdpNcVDHFZ0
	 ACQ2xFEapvrDzL+mpo+rkqkSvWp3XUuCITRjHWuUxUd+EN65J1RV2euAKoKmnynYyk
	 41bR/qC8xTByltxZf+70FdhU6fxPHz3g3kJ4cAb0FuYKdAJ8a6p4yUs/cafDTieqVl
	 U+U3nmWq57lK3HqqLL/C3ZmKqYuGL0xvHE2ZPUf8lTMM3LnydF0xTcuu2Jk777rVaJ
	 OBQ9w9gghg3Lw==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	metze@samba.org,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 03/14] ksmbd: fix lease break and ack state handling
Date: Thu, 18 Jun 2026 23:17:28 +0900
Message-Id: <20260618141739.9029-3-linkinjeon@kernel.org>
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

Do not skip valid lease states containing WRITE_CACHING when breaking
level-II/read leases for writes and truncates.

Handle lease break acknowledgments according to the SMB2 rule that the
acknowledged state must be a subset of the server's break target. Apply
the acknowledged state directly and keep the break pending on failed ACKs.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c  |  24 +++------
 fs/smb/server/smb2pdu.c | 106 ++++++++++------------------------------
 2 files changed, 34 insertions(+), 96 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 627cea7fd7ea..cc5eb95ab3f2 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1419,14 +1419,8 @@ void smb_break_all_levII_oplock(struct ksmbd_work *work, struct ksmbd_file *fp,
 			continue;
 		}
 
-		if (brk_op->is_lease && (brk_op->o_lease->state &
-		    (~(SMB2_LEASE_READ_CACHING_LE |
-				SMB2_LEASE_HANDLE_CACHING_LE)))) {
-			ksmbd_debug(OPLOCK, "unexpected lease state(0x%x)\n",
-				    brk_op->o_lease->state);
-			goto next;
-		} else if (brk_op->level !=
-				SMB2_OPLOCK_LEVEL_II) {
+		if (!brk_op->is_lease &&
+		    brk_op->level != SMB2_OPLOCK_LEVEL_II) {
 			ksmbd_debug(OPLOCK, "unexpected oplock(0x%x)\n",
 				    brk_op->level);
 			goto next;
@@ -1478,15 +1472,13 @@ void smb_break_all_oplock(struct ksmbd_work *work, struct ksmbd_file *fp)
  */
 __u8 smb2_map_lease_to_oplock(__le32 lease_state)
 {
-	if (lease_state == (SMB2_LEASE_HANDLE_CACHING_LE |
-			    SMB2_LEASE_READ_CACHING_LE |
-			    SMB2_LEASE_WRITE_CACHING_LE)) {
+	if ((lease_state & SMB2_LEASE_WRITE_CACHING_LE) &&
+	    (lease_state & SMB2_LEASE_HANDLE_CACHING_LE)) {
 		return SMB2_OPLOCK_LEVEL_BATCH;
-	} else if (lease_state != SMB2_LEASE_WRITE_CACHING_LE &&
-		 lease_state & SMB2_LEASE_WRITE_CACHING_LE) {
-		if (!(lease_state & SMB2_LEASE_HANDLE_CACHING_LE))
-			return SMB2_OPLOCK_LEVEL_EXCLUSIVE;
-	} else if (lease_state & SMB2_LEASE_READ_CACHING_LE) {
+	} else if (lease_state & SMB2_LEASE_WRITE_CACHING_LE) {
+		return SMB2_OPLOCK_LEVEL_EXCLUSIVE;
+	} else if (lease_state & (SMB2_LEASE_READ_CACHING_LE |
+				  SMB2_LEASE_HANDLE_CACHING_LE)) {
 		return SMB2_OPLOCK_LEVEL_II;
 	}
 	return 0;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 3b4355c6a146..6e211618c207 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -9019,16 +9019,17 @@ static void smb20_oplock_break_ack(struct ksmbd_work *work)
 	ksmbd_fd_put(work, fp);
 }
 
-static int check_lease_state(struct lease *lease, __le32 req_state)
+static bool smb2_lease_state_valid(__le32 state)
 {
-	if ((lease->new_state ==
-	     (SMB2_LEASE_READ_CACHING_LE | SMB2_LEASE_HANDLE_CACHING_LE)) &&
-	    !(req_state & SMB2_LEASE_WRITE_CACHING_LE)) {
-		lease->new_state = req_state;
-		return 0;
-	}
+	return !(state & ~(SMB2_LEASE_READ_CACHING_LE |
+			   SMB2_LEASE_HANDLE_CACHING_LE |
+			   SMB2_LEASE_WRITE_CACHING_LE));
+}
 
-	if (lease->new_state == req_state)
+static int check_lease_state(struct lease *lease, __le32 req_state)
+{
+	if (smb2_lease_state_valid(req_state) &&
+	    !(req_state & ~lease->new_state))
 		return 0;
 
 	return 1;
@@ -9046,9 +9047,7 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 	struct smb2_lease_ack *req;
 	struct smb2_lease_ack *rsp;
 	struct oplock_info *opinfo;
-	__le32 err = 0;
 	int ret = 0;
-	unsigned int lease_change_type;
 	__le32 lease_state;
 	struct lease *lease;
 
@@ -9072,80 +9071,23 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 		goto err_out;
 	}
 
-	if (check_lease_state(lease, req->LeaseState)) {
-		rsp->hdr.Status = STATUS_REQUEST_NOT_ACCEPTED;
-		ksmbd_debug(OPLOCK,
-			    "req lease state: 0x%x, expected state: 0x%x\n",
-			    req->LeaseState, lease->new_state);
-		goto err_out;
-	}
-
 	if (!atomic_read(&opinfo->breaking_cnt)) {
 		rsp->hdr.Status = STATUS_UNSUCCESSFUL;
 		goto err_out;
 	}
 
-	/* check for bad lease state */
-	if (req->LeaseState &
-	    (~(SMB2_LEASE_READ_CACHING_LE | SMB2_LEASE_HANDLE_CACHING_LE))) {
-		err = STATUS_INVALID_OPLOCK_PROTOCOL;
-		if (lease->state & SMB2_LEASE_WRITE_CACHING_LE)
-			lease_change_type = OPLOCK_WRITE_TO_NONE;
-		else
-			lease_change_type = OPLOCK_READ_TO_NONE;
-		ksmbd_debug(OPLOCK, "handle bad lease state 0x%x -> 0x%x\n",
-			    le32_to_cpu(lease->state),
-			    le32_to_cpu(req->LeaseState));
-	} else if (lease->state == SMB2_LEASE_READ_CACHING_LE &&
-		   req->LeaseState != SMB2_LEASE_NONE_LE) {
-		err = STATUS_INVALID_OPLOCK_PROTOCOL;
-		lease_change_type = OPLOCK_READ_TO_NONE;
-		ksmbd_debug(OPLOCK, "handle bad lease state 0x%x -> 0x%x\n",
-			    le32_to_cpu(lease->state),
-			    le32_to_cpu(req->LeaseState));
-	} else {
-		/* valid lease state changes */
-		err = STATUS_INVALID_DEVICE_STATE;
-		if (req->LeaseState == SMB2_LEASE_NONE_LE) {
-			if (lease->state & SMB2_LEASE_WRITE_CACHING_LE)
-				lease_change_type = OPLOCK_WRITE_TO_NONE;
-			else
-				lease_change_type = OPLOCK_READ_TO_NONE;
-		} else if (req->LeaseState & SMB2_LEASE_READ_CACHING_LE) {
-			if (lease->state & SMB2_LEASE_WRITE_CACHING_LE)
-				lease_change_type = OPLOCK_WRITE_TO_READ;
-			else
-				lease_change_type = OPLOCK_READ_HANDLE_TO_READ;
-		} else {
-			lease_change_type = 0;
-		}
-	}
-
-	switch (lease_change_type) {
-	case OPLOCK_WRITE_TO_READ:
-		ret = opinfo_write_to_read(opinfo);
-		break;
-	case OPLOCK_READ_HANDLE_TO_READ:
-		ret = opinfo_read_handle_to_read(opinfo);
-		break;
-	case OPLOCK_WRITE_TO_NONE:
-		ret = opinfo_write_to_none(opinfo);
-		break;
-	case OPLOCK_READ_TO_NONE:
-		ret = opinfo_read_to_none(opinfo);
-		break;
-	default:
-		ksmbd_debug(OPLOCK, "unknown lease change 0x%x -> 0x%x\n",
-			    le32_to_cpu(lease->state),
-			    le32_to_cpu(req->LeaseState));
-	}
-
-	if (ret < 0) {
-		rsp->hdr.Status = err;
+	if (check_lease_state(lease, req->LeaseState)) {
+		rsp->hdr.Status = STATUS_REQUEST_NOT_ACCEPTED;
+		ksmbd_debug(OPLOCK,
+			    "req lease state: 0x%x, expected state: 0x%x\n",
+			    req->LeaseState, lease->new_state);
 		goto err_out;
 	}
 
-	lease_state = lease->state;
+	lease_state = req->LeaseState;
+	lease->state = lease_state;
+	lease->new_state = SMB2_LEASE_NONE_LE;
+	opinfo->level = smb2_map_lease_to_oplock(lease_state);
 
 	rsp->StructureSize = cpu_to_le16(36);
 	rsp->Reserved = 0;
@@ -9154,16 +9096,20 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 	rsp->LeaseState = lease_state;
 	rsp->LeaseDuration = 0;
 	ret = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_lease_ack));
-	if (ret) {
-err_out:
-		smb2_set_err_rsp(work);
-	}
+	if (ret)
+		goto err_out;
 
 	opinfo->op_state = OPLOCK_STATE_NONE;
 	wake_up_interruptible_all(&opinfo->oplock_q);
 	atomic_dec(&opinfo->breaking_cnt);
 	wake_up_interruptible_all(&opinfo->oplock_brk);
 	opinfo_put(opinfo);
+	return;
+
+err_out:
+	smb2_set_err_rsp(work);
+	opinfo_put(opinfo);
+	return;
 }
 
 /**
-- 
2.25.1

