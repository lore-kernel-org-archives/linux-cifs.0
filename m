Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A4D72621
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 12:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046169; cv=none; b=IDNx0ilZc/ojqC0QxIGKbBO8fb6xH2iyEmM8wgy6g3pjBYGiu26pk8V0LmzuShd4X+9085bUJ59hEyH9CJHEWSgSsF0lRMaAVEIu3iAGCbAh2gbu+UCZ1ngedfZQ6GQDzU9nP02Tt8WF+MEcrAotuh9vETTydDdDGEgIFuV2bKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046169; c=relaxed/simple;
	bh=SvScC3AMsEZT0evVKRemG66z4srILy1qO5q2tfx3+XI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oN09tOmOVyvqAeQDpgUdWmkWk7bFdBHLoLIcXabV/J3yCtc+7ZbsRs82vKso+H5hqsL5KckjUCxKnztJGZk4rwFQ6yfs5/wC/RCaAgaI8bNiO0hW9X86GLNcIMrxlN+djR93tYfVv2PhNoftXc+swqRRjCc+gjRwJTlZKMJEG4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RxioTWmq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RxioTWmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1EC1F00A3A;
	Sun, 21 Jun 2026 12:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782046168;
	bh=0jPNhWyfu0wBDxegZpD8Repb/0Gl4deIDypNm2jvJbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RxioTWmqow+VUZomhmuLGUPC2aXrB3zT2si8OFD7mJKreNeRJkM1KtMhr4BvbZ6jp
	 2u9NesEV5Dec7fBDGQ1y5/3t7maI1Uy6e3CiXXq03bA9VTJZV3p/ZAJUXyW8b6fvUJ
	 z19yReBNA8v1WeONNgcHOJbjc9rpY/qaWMI31DF297CJd2mpDjPONV/kUPkSulGNBr
	 E75kNNf4ddenxDfCSUumDQxsZCFMypu518E6Ny/RoRvrEugxQLDH7CYX6sS7XMaFfx
	 lZI/gnNlPoP+/vztDHB8MZaQQOr2eqVzfkQToSNouQ4P0iy6g7YL0cqHcNTavNDKFV
	 DM5O6P+TzVUfQ==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 19/29] ksmbd: downgrade oplock after break timeout
Date: Sun, 21 Jun 2026 21:48:34 +0900
Message-Id: <20260621124844.6235-19-linkinjeon@kernel.org>
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

smb2.oplock.batch22a opens a file with a batch oplock and then issues a
second open that waits for the oplock break timeout.  After the timeout the
second open should succeed, but the granted oplock level must be level II.

When the break times out, oplock_break() returns -ENOENT after invalidating
the previous opener.  smb_grant_oplock() went straight to set_lev with the
original requested oplock level, so the second open could be granted a new
batch oplock.  Downgrade the requested oplock to level II on the -ENOENT
break-timeout path before granting the oplock to the new open.

A break that completes because the previous owner closed its handle from
the oplock break handler must be distinguished from a real timeout.
smb2.oplock.batch7 closes the first handle during the break wait, and the
second open is then expected to be granted the originally requested batch
oplock.  Return -EAGAIN from the non-lease break path when the previous
opener closed during the break wait, recheck sharing in smb_grant_oplock(),
and grant the requested oplock if the close removed the conflict. Real
break timeouts still return -ENOENT and keep the downgrade to level II.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 50cc067696d3..a8e1a08d457e 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1130,7 +1130,7 @@ static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level,
 
 	ksmbd_debug(OPLOCK, "oplock granted = %d\n", brk_opinfo->level);
 	if (brk_opinfo->op_state == OPLOCK_CLOSING)
-		err = -ENOENT;
+		err = -EAGAIN;
 	wake_up_oplock_break(brk_opinfo);
 
 	return err;
@@ -1434,8 +1434,19 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 	if (prev_durable_detached || (prev_durable_open && err == -ENOENT))
 		ksmbd_invalidate_durable_fd(prev_fid);
 	opinfo_put(prev_opinfo);
-	if (err == -ENOENT)
+	if (err == -EAGAIN) {
+		share_ret = ksmbd_smb_check_shared_mode(fp->filp, fp);
+		if (share_ret < 0) {
+			err = share_ret;
+			goto err_out;
+		}
 		goto set_lev;
+	}
+	if (err == -ENOENT) {
+		if (req_op_level != SMB2_OPLOCK_LEVEL_NONE)
+			req_op_level = SMB2_OPLOCK_LEVEL_II;
+		goto set_lev;
+	}
 	/* Check all oplock was freed by close */
 	else if (err < 0)
 		goto err_out;
-- 
2.25.1

