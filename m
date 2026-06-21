Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C131172621
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 12:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046171; cv=none; b=uZxlaMGHNdC5GDyv+gQtCijP835tl2JAArF93DPE/qGkA+ovo8KYlH/pB6hcUgRUyYSmTnoZeazr7SptNSy55alFS/eaQDbtQ0nD+s1iVJJQsmLd7cHeVDV5276Jjd8aPnWfaFjhGRra4YPt+rvtHF22SxH8UX93hCr5g5Vw5+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046171; c=relaxed/simple;
	bh=mafJn2GoxlVr8yXmNqOnsErkuE0oxssCEuXtrrv5N30=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FTa4bcW6MgVr3MD4v9V+1KZTU/hrRiClCR1Ep/TtszdwyOAHySRgm7cGTy+C/Tvkp1xpeKzFcxQ0DC4FmOjisI/VjElfxCFTsSSS1cmHXabnMEC1phfUXfNtvRjdYrLCamADHLzVPnFqtrs0QxDqCSgTjJmZtMA+pDbNETlSCOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hSvp0NhF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hSvp0NhF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B419C1F000E9;
	Sun, 21 Jun 2026 12:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782046170;
	bh=s9dGipsKNr0qd4Zi7sPb5n4TvOVssqQL0CbQcVaHolQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hSvp0NhFiYBT/KAuhOnHm3b3/w5eb2p/BSCn4vdsV6CkLX9dqHYzb6fAmt2o48Mla
	 Isd4VQlC2i5geBL5YbY83zZHR32rPOP5r732F/y92pfPvmcKUzyUnUKjOMjOU1i/WK
	 VwB35lO14+WTfOkA9Y1IiCSpwUjvZdvhKiFxODD2Wma3szspFzQLQHlxpjyr5bA/ul
	 TK0TTN9DEBrakQa7yiwSJsPqPPR7cE87N0eIxOWAON4WHaIZfy3rl5sUO7nB8PKrp2
	 w6VBlmTL9UaV+DWp809b2ShTad0Na9y1PxtgaXCKzLzO7uQw/bJYVxkRZhqE5QBbzF
	 HMoLy3alDviag==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 20/29] ksmbd: avoid level II oplock break notification on unlink
Date: Sun, 21 Jun 2026 21:48:35 +0900
Message-Id: <20260621124844.6235-20-linkinjeon@kernel.org>
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

smb2_util_unlink() opens the target with FILE_DELETE_ON_CLOSE and then
closes that handle.  Other clients can also mark a file for delete with
SMB2 SET_INFO FileDispositionInformation.

When these unlink paths break existing SMB2 level II oplocks, ksmbd sends
an unsolicited SMB2_OPLOCK_BREAK notification to none.  This races with the
synchronous CREATE or SET_INFO response expected by the client, and
smbtorture reports NT_STATUS_INVALID_NETWORK_RESPONSE while running
smb2.oplock.exclusive2.

SMB2 level II oplock breaks do not require an acknowledgment in the delete
path.  Keep lease handling unchanged, but drop plain SMB2 level II oplocks
locally for unlink requests without sending a break notification.  Normal
write/truncate paths still send the level II to none notification,
preserving the behavior covered by smb2.oplock.levelII500.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c  | 31 ++++++++++++++++++++++++-------
 fs/smb/server/oplock.h  |  4 ++++
 fs/smb/server/smb2pdu.c |  4 ++--
 3 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index a8e1a08d457e..23e97bddf28d 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1544,7 +1544,7 @@ static bool smb_break_all_write_oplock(struct ksmbd_work *work,
  */
 static void __smb_break_all_levII_oplock(struct ksmbd_work *work,
 					 struct ksmbd_file *fp, int is_trunc,
-					 bool send_interim)
+					 bool send_interim, bool send_oplock_break)
 {
 	struct oplock_info *op, *brk_op;
 	struct ksmbd_inode *ci;
@@ -1591,10 +1591,15 @@ static void __smb_break_all_levII_oplock(struct ksmbd_work *work,
 			    SMB2_LEASE_KEY_SIZE))
 			goto next;
 		brk_op->open_trunc = is_trunc;
-		oplock_break(brk_op,
-			     brk_op->is_lease && !is_trunc ?
-			     SMB2_OPLOCK_LEVEL_II : SMB2_OPLOCK_LEVEL_NONE,
-			     send_interim && !sent_interim ? work : NULL);
+		if (!brk_op->is_lease && !send_oplock_break) {
+			brk_op->level = SMB2_OPLOCK_LEVEL_NONE;
+			brk_op->op_state = OPLOCK_STATE_NONE;
+		} else {
+			oplock_break(brk_op,
+				     brk_op->is_lease && !is_trunc ?
+				     SMB2_OPLOCK_LEVEL_II : SMB2_OPLOCK_LEVEL_NONE,
+				     send_interim && !sent_interim ? work : NULL);
+		}
 		sent_interim = true;
 next:
 		opinfo_put(brk_op);
@@ -1608,7 +1613,19 @@ static void __smb_break_all_levII_oplock(struct ksmbd_work *work,
 void smb_break_all_levII_oplock(struct ksmbd_work *work, struct ksmbd_file *fp,
 				int is_trunc)
 {
-	__smb_break_all_levII_oplock(work, fp, is_trunc, true);
+	__smb_break_all_levII_oplock(work, fp, is_trunc, true, true);
+}
+
+void smb_break_all_levII_oplock_no_interim(struct ksmbd_work *work,
+					   struct ksmbd_file *fp, int is_trunc)
+{
+	__smb_break_all_levII_oplock(work, fp, is_trunc, false, true);
+}
+
+void smb_break_all_levII_oplock_for_delete(struct ksmbd_work *work,
+					   struct ksmbd_file *fp)
+{
+	__smb_break_all_levII_oplock(work, fp, 0, false, false);
 }
 
 /**
@@ -1625,7 +1642,7 @@ void smb_break_all_oplock(struct ksmbd_work *work, struct ksmbd_file *fp)
 		return;
 
 	sent_break = smb_break_all_write_oplock(work, fp, 1);
-	__smb_break_all_levII_oplock(work, fp, 1, !sent_break);
+	__smb_break_all_levII_oplock(work, fp, 1, !sent_break, true);
 }
 
 /**
diff --git a/fs/smb/server/oplock.h b/fs/smb/server/oplock.h
index 8d1943586246..3f581d22bb67 100644
--- a/fs/smb/server/oplock.h
+++ b/fs/smb/server/oplock.h
@@ -99,6 +99,10 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level,
 		     struct lease_ctx_info *lctx, int share_ret);
 void smb_break_all_levII_oplock(struct ksmbd_work *work,
 				struct ksmbd_file *fp, int is_trunc);
+void smb_break_all_levII_oplock_no_interim(struct ksmbd_work *work,
+					   struct ksmbd_file *fp, int is_trunc);
+void smb_break_all_levII_oplock_for_delete(struct ksmbd_work *work,
+					   struct ksmbd_file *fp);
 int opinfo_write_to_read(struct oplock_info *opinfo);
 int opinfo_read_handle_to_read(struct oplock_info *opinfo);
 int opinfo_write_to_none(struct oplock_info *opinfo);
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 526d5be97364..97dc24c5c44b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3809,7 +3809,7 @@ int smb2_open(struct ksmbd_work *work)
 	}
 
 	if (req->CreateOptions & FILE_DELETE_ON_CLOSE_LE) {
-		smb_break_all_levII_oplock(work, fp, 0);
+		smb_break_all_levII_oplock_for_delete(work, fp);
 		ksmbd_fd_set_delete_on_close(fp, file_info);
 	}
 
@@ -6796,7 +6796,7 @@ static int set_file_disposition_info(struct ksmbd_work *work,
 		if (S_ISDIR(inode->i_mode) &&
 		    ksmbd_vfs_empty_dir(fp) == -ENOTEMPTY)
 			return -EBUSY;
-		smb_break_all_levII_oplock(work, fp, 0);
+		smb_break_all_levII_oplock_for_delete(work, fp);
 		ksmbd_set_inode_pending_delete(fp);
 	} else {
 		ksmbd_clear_inode_pending_delete(fp);
-- 
2.25.1

