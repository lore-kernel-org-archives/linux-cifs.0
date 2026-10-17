Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA22D31E83B
	for <linux-cifs@vger.kernel.org>; Sat, 17 Oct 2026 01:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792199042; cv=none; b=crOZT2o9duGZyKX7OTiT4C+69dEKSb0EVzG8ZFd7b3KLVbXlSZslyX2gSk/mktgyqwQjUOQCvpG5+j7re5AP4eeai8SfsuKWKlKIoAW1kDywfn5ctChSczf5YJu3LtnRthXRX+iJor1JI0ROHnubJajQ+MNb98XBPbfe8y/JnoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792199042; c=relaxed/simple;
	bh=/Zhkrgmp9KHgkhAhvJugpX7QAgnC0su+v/QIgdvCdys=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=vGfOcv1MRBJIWgYWu5H82LiLgVqP410zKJ42KqzANCC5H4dc6u6EmIhcw7TW7RLUuoSCFkOwRF6ZomRHTVnsZUAGptrF4K542XtZy8mykGNlNrxsq7tJVClGNefZCMqy68cvSrTQVemUBf9+jUgoipnfxT6V1yZg51RJ2MkR86Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LYyC2PMa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LYyC2PMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0971F000C5;
	Sat, 17 Oct 2026 01:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792199040;
	bh=cNkLNJkElrkbFo6SQFQ2G0JhkdcRBmtORlnOSokhseM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LYyC2PMaLHfzvLsIf/CVXFyi6gCRbs41gO8kltNfDPBZ4UsF4Nbsq19vW0BcECJ4u
	 QEMXdbMpf9elSCm9/NFQ0ZN7QFmY+W5uarrsz5x1imrqiX/bCrruXR+SN65hdJNfhD
	 bQVhoPB6yJkKp2HetIVuN+kmUuX+GG+XOEYUGOJHwmvaKMbTuTDcGh22tdJ1K/iry8
	 zlqvFr/0OMHWsPtHNihDWflzqRUQkUPTi8XyFbMHWuH/wbYEBknWQO6Nwnk03DbO77
	 k9auBAoW6Aw3aZU5BMfGt0l4tUkgQWQYUBJmNGL2f1bZfm7ASFdnnyU9D/+3z1lsMT
	 KBGBpxFDBkhcA==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	chenxiaosong@chenxiaosong.com,
	chenxiaosong@kylinos.cn,
	Namjae Jeon <linkinjeon@kernel.org>,
	Pan Guihua <pan.guihua@datatom.com>
Subject: [PATCH 02/22] ksmbd: serialize oplock break ACK state updates
Date: Sat, 17 Oct 2026 10:03:24 +0900
Message-Id: <20261017010344.11478-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261017010344.11478-1-linkinjeon@kernel.org>
References: <20261017010344.11478-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ACK handling updates lease or oplock levels and wakes break waiters.
Without state_lock across validation and publication, timeout or break
completion can observe a partially updated state.

Serialize ACK validation and state changes under state_lock. Publish NONE
after lease levels are updated, then wake waiters after unlocking.

Reported-by: Pan Guihua <pan.guihua@datatom.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 64 +++++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 35 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index aca51f54a38d..b45453a29fbb 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -11919,6 +11919,8 @@ static void smb20_oplock_break_ack(struct ksmbd_work *work)
 		return;
 	}
 
+	/* Serialize the level update with break completion and timeout. */
+	spin_lock(&opinfo->state_lock);
 	if (opinfo->op_state != OPLOCK_ACK_WAIT) {
 		ksmbd_debug(SMB, "unexpected oplock state 0x%x\n",
 			    opinfo->op_state);
@@ -11930,6 +11932,7 @@ static void smb20_oplock_break_ack(struct ksmbd_work *work)
 			rsp->Reserved2 = 0;
 			rsp->VolatileFid = volatile_id;
 			rsp->PersistentFid = persistent_id;
+			spin_unlock(&opinfo->state_lock);
 			ret = ksmbd_iov_pin_rsp(work, rsp,
 						 sizeof(struct smb2_oplock_break));
 			if (ret)
@@ -11986,6 +11989,9 @@ static void smb20_oplock_break_ack(struct ksmbd_work *work)
 		rsp_oplevel = req_oplevel;
 
 	opinfo->level = rsp_oplevel;
+	opinfo->op_state = OPLOCK_STATE_NONE;
+	spin_unlock(&opinfo->state_lock);
+	wake_up_interruptible_all(&opinfo->oplock_q);
 
 	rsp->StructureSize = cpu_to_le16(24);
 	rsp->OplockLevel = rsp_oplevel;
@@ -11997,18 +12003,15 @@ static void smb20_oplock_break_ack(struct ksmbd_work *work)
 	if (ret)
 		ksmbd_debug(SMB, "failed to pin oplock break response: %d\n",
 			    ret);
-	goto out;
+	goto out_no_state_change;
 
 err_out:
-	rsp->hdr.Status = status;
-	smb2_set_err_rsp(work);
-
-out:
-	spin_lock(&opinfo->state_lock);
 	if (opinfo->op_state != OPLOCK_CLOSING)
 		opinfo->op_state = OPLOCK_STATE_NONE;
 	spin_unlock(&opinfo->state_lock);
 	wake_up_interruptible_all(&opinfo->oplock_q);
+	rsp->hdr.Status = status;
+	smb2_set_err_rsp(work);
 out_no_state_change:
 	opinfo_put(opinfo);
 	ksmbd_fd_put(work, fp);
@@ -12042,7 +12045,7 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 	struct smb2_lease_ack *req;
 	struct smb2_lease_ack *rsp;
 	struct oplock_info *opinfo;
-	int ret = 0;
+	int ret;
 	__le32 lease_state;
 	struct lease *lease;
 
@@ -12053,26 +12056,27 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 	opinfo = lookup_lease_in_table(conn, req->LeaseKey);
 	if (!opinfo) {
 		ksmbd_debug(OPLOCK, "file not opened\n");
-		smb2_set_err_rsp(work);
 		rsp->hdr.Status = STATUS_UNSUCCESSFUL;
+		smb2_set_err_rsp(work);
 		return;
 	}
 	lease = opinfo->o_lease;
 
-	if (opinfo->op_state == OPLOCK_STATE_NONE) {
-		pr_err("unexpected lease break state 0x%x\n",
-		       opinfo->op_state);
-		if (smb3_hdr_replay(&req->hdr))
+	/* Publish NONE only after the lease state and all open levels are updated. */
+	spin_lock(&opinfo->state_lock);
+	if (opinfo->op_state != OPLOCK_ACK_WAIT) {
+		if (opinfo->op_state == OPLOCK_STATE_NONE &&
+		    smb3_hdr_replay(&req->hdr))
 			goto replay_rsp;
 		rsp->hdr.Status = STATUS_UNSUCCESSFUL;
-		goto err_out;
+		goto err_unlock;
 	}
 
 	if (!atomic_read(&opinfo->breaking_cnt)) {
 		if (smb3_hdr_replay(&req->hdr))
 			goto replay_rsp;
 		rsp->hdr.Status = STATUS_UNSUCCESSFUL;
-		goto err_out;
+		goto err_unlock;
 	}
 
 	if (check_lease_state(lease, req->LeaseState)) {
@@ -12080,40 +12084,29 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 		ksmbd_debug(OPLOCK,
 			    "req lease state: 0x%x, expected state: 0x%x\n",
 			    req->LeaseState, lease->new_state);
-		goto err_out;
+		goto err_unlock;
 	}
 
 	lease_state = req->LeaseState;
 	lease->state = lease_state;
 	lease->new_state = SMB2_LEASE_NONE_LE;
 	lease_update_oplock_levels(lease);
-
-	rsp->StructureSize = cpu_to_le16(36);
-	rsp->Reserved = 0;
-	rsp->Flags = 0;
-	memcpy(rsp->LeaseKey, req->LeaseKey, 16);
-	rsp->LeaseState = lease_state;
-	rsp->LeaseDuration = 0;
-	ret = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_lease_ack));
-	if (ret)
-		goto err_out;
-
-	spin_lock(&opinfo->state_lock);
-	if (opinfo->op_state != OPLOCK_CLOSING)
-		opinfo->op_state = OPLOCK_STATE_NONE;
+	opinfo->op_state = OPLOCK_STATE_NONE;
+	atomic_dec_if_positive(&opinfo->breaking_cnt);
 	spin_unlock(&opinfo->state_lock);
 	wake_up_interruptible_all(&opinfo->oplock_q);
-	atomic_dec_if_positive(&opinfo->breaking_cnt);
 	wake_up_interruptible_all(&opinfo->oplock_brk);
-	opinfo_put(opinfo);
-	return;
+	goto response;
 
 replay_rsp:
+	lease_state = lease->state;
+	spin_unlock(&opinfo->state_lock);
+response:
 	rsp->StructureSize = cpu_to_le16(36);
 	rsp->Reserved = 0;
 	rsp->Flags = 0;
-	memcpy(rsp->LeaseKey, req->LeaseKey, 16);
-	rsp->LeaseState = lease->state;
+	memcpy(rsp->LeaseKey, req->LeaseKey, SMB2_LEASE_KEY_SIZE);
+	rsp->LeaseState = lease_state;
 	rsp->LeaseDuration = 0;
 	ret = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_lease_ack));
 	if (ret)
@@ -12121,10 +12114,11 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 	opinfo_put(opinfo);
 	return;
 
+err_unlock:
+	spin_unlock(&opinfo->state_lock);
 err_out:
 	smb2_set_err_rsp(work);
 	opinfo_put(opinfo);
-	return;
 }
 
 /**
-- 
2.25.1

