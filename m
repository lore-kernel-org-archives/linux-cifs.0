Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AAD51AFEF;
	Thu,  1 Oct 2026 15:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790867272; cv=none; b=HZpMA/0EAJDci2K55eQaIsS/RJUMN5P2xYZ0tc7UemuEFi0pvraeVmg/OW6tOgk3epVvCAD41KcrVpatTI0tu21R9BwleI2/R2zCoc8G2v75cLyfP5qPeOYKaRMcr9FNFbRXnsTfEG6zoiFmbnqGEwWcd6ICTdy119Ep2Ny4AyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790867272; c=relaxed/simple;
	bh=Vc43IMWHplUNJtOfUyoZJ8XglsaC8M3vSlsru1SXVc4=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=dBf/rpWZUHEbEpnAS240YQ5/zZYZSYlFyTnNVqklg5NltoHWrUY6PFT+eJSVlYNPivA80kuLg97//J3Cfkw109/6ijWkVLd/+YYKU7Cn9OlGcmTPHS+LK+KFW47iFMKVnegiJ3o2ZDoN9WnTzUFq6YG538rRfSoncXB7U60hSP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=MqZLQaIH; arc=none smtp.client-ip=162.62.58.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="MqZLQaIH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1790867255; bh=i6buGYmKMdp6JgRwIn6VvXYpH++bJk71QPeQ9y8/2r4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MqZLQaIHAUM0tLyWcuGNovcqOD+7yCuaqxZ58hZF427tIQgYgQbg/ZXkCoQVGzK3/
	 9Da7MleSdgHLxOV6gDaKeAw0jb4D12aEHNvl/dUJAR1DO7O/Me21ZNvg7xQavDG0EU
	 xrGoWlKamvhLNClNXrkWvJ8cceZtvj7AR9jDw220=
Received: from archlinux ([240e:473:7000:116e:7a96:2aa7:e2fe:5e21])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id 1921001C; Thu, 01 Oct 2026 23:06:18 +0800
X-QQ-mid: xmsmtpt1790867178tok77l41k
Message-ID: <tencent_464A86FF7A38FD3620EBF1C6062745316307@qq.com>
X-QQ-XMAILINFO: MRMtjO3A6C9XX5U8+pnogmbMz5+zOU+dM9NBVRw4DsLhXv8Q/0eW30dj+oEEdQ
	 Uq4FrU+ktwDejUTuFRJexNU2DDQFSftPMgfQWAGhekzPIdxyL6STUzkP3zZM0eBsRGAlso3kTRD8
	 5c4oxB3tRr4GunPTdC2jgWhoaZ+wLStzIchFKMFstlTFTDK7o95cEwhafbdjDCTaCGH0kGAj8Yv1
	 UAFADXgXtcBRBAkgyRxNmeKtdctYJTbwy4JdWH+Fo0FmAt26oITnHAr+cXv81WO22Gom06KiOWD5
	 l5SKczSe6OcIujoVD2pX78nD2XaShAAo3mYihkxwaQXu/jBlGw/y0KchkfcwUxwWuP/WgbJivegv
	 o6JCed86yyq6mxsSc/PNZfx9EDxeiP0lsBgnto3kQmzxW8FIisNgq9LWschTFg1OYRl4UqQJQtcU
	 CcyIxR1j5vSjBL+ZUH6b1JjZm50/C1vxm6FJT6aTIXWMQ/3Oo3nR36Jb9bH0cpmAEquoa3DkuUOa
	 hO6ViQekebFVrmmgt192lp9nrmjV3M8e9cQ6LyvheqhXB9nQezm3KAT8A0VR6MCWIldQhpv79Nj0
	 MZUqwF81J9He2562e76yQQLSIOT7j2UfbkMVHZU6yYCqeHDgUYIIQgCFoS8k+p4K5WsP7F9+pVt3
	 JwqsXbdDVb488DQCREikYZ79VZwyApmtQDiOh8pQOC/Ugc70uorEh4BiCZl4YMqNQgJVpUnrjXtX
	 gvhhyWDA6mVV/TOQGv1jfCptNHnvBp8hEx8Yz/D75baEtX1qm9M0g+d/qJ91d0/Tj+I3hrN6DMeV
	 usH1p/FCEIR/jGXDIuP2bqIO2hUj7z7XEtSrjLN3AGy1Et8rfgTIX2npBAAmCrEGT43hW/9zjR3o
	 5EGXrlQe6yMA3TenLCMe/0fxtiT2n7T8UcLgTKXtK6QyN6cezodUfCyoloUMKnBGSbqiw0I82Cci
	 OjQSQqMofzkaSd5p1epky8NFwTdemLOZNuBBg/XzuA7g7srwy93oGc+fXdfqE5KuAwftXDEwzzAV
	 /xwBWFVlNQj9GIZnYLYSJYjdFbGI+pgW4x6oJH4Awn7GXbxUEt9LiLP12ZiBvFLHNWLnTJ+fVOxt
	 ZoILIbs45N1ycZcjY=
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
From: Daijiamu <3058704216@qq.com>
To: linkinjeon@kernel.org,
	sergey.senozhatsky@gmail.com,
	tom@talpey.com
Cc: chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Daijiamu <3058704216@qq.com>
Subject: [PATCH v2] ksmbd: use clear_and_wake_up_bit() directly
Date: Thu,  1 Oct 2026 23:06:14 +0800
X-OQ-MSGID: <20261001150614.5900-1-3058704216@qq.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930183758.32342-1-3058704216@qq.com>
References: <20260930183758.32342-1-3058704216@qq.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

clear_and_wake_up_bit() was introduced by commit 8236b0ae31c8 ("bdi:
wake up concurrent wb_shutdown() callers.") to replace the open-coded
clear_bit_unlock() + smp_mb__after_atomic() + wake_up_bit() sequence.

Replace the sequence and drop the now-trivial wake_up_oplock_break()
wrapper, calling the helper directly at each call site.

Suggested-by: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Signed-off-by: Daijiamu <3058704216@qq.com>
---
Changes in v2:
- Call clear_and_wake_up_bit() directly and remove wake_up_oplock_break(),
  as suggested by ChenXiaoSong.
Link: https://lore.kernel.org/linux-cifs/20260930183758.32342-1-3058704216@qq.com/
---
 fs/smb/server/oplock.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 1b8c3482d1e4..25ff8408f0ba 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -763,14 +763,6 @@ static bool wait_for_break_ack(struct oplock_info *opinfo)
 	return false;
 }
 
-static void wake_up_oplock_break(struct oplock_info *opinfo)
-{
-	clear_bit_unlock(0, &opinfo->pending_break);
-	/* memory barrier is needed for wake_up_bit() */
-	smp_mb__after_atomic();
-	wake_up_bit(&opinfo->pending_break, 0);
-}
-
 static bool oplock_break_set_ack_wait(struct oplock_info *opinfo)
 {
 	bool ret = false;
@@ -826,13 +818,13 @@ static int oplock_break_pending(struct oplock_info *opinfo, int req_op_level)
 
 	if (opinfo->level <= req_op_level) {
 		if (opinfo->is_lease == false) {
-			wake_up_oplock_break(opinfo);
+			clear_and_wake_up_bit(0, &opinfo->pending_break);
 			return 1;
 		}
 		if (opinfo->o_lease->state !=
 		    (SMB2_LEASE_HANDLE_CACHING_LE |
 		     SMB2_LEASE_READ_CACHING_LE)) {
-			wake_up_oplock_break(opinfo);
+			clear_and_wake_up_bit(0, &opinfo->pending_break);
 			return 1;
 		}
 	}
@@ -1260,7 +1252,7 @@ static int oplock_break(struct oplock_info *brk_opinfo, struct ksmbd_inode *ci,
 				SMB2_LEASE_HANDLE_CACHING_LE)) {
 			if (!oplock_break_set_ack_wait(brk_opinfo)) {
 				atomic_dec_if_positive(&brk_opinfo->breaking_cnt);
-				wake_up_oplock_break(brk_opinfo);
+				clear_and_wake_up_bit(0, &brk_opinfo->pending_break);
 				return -ENOENT;
 			}
 		} else
@@ -1309,7 +1301,7 @@ static int oplock_break(struct oplock_info *brk_opinfo, struct ksmbd_inode *ci,
 		      lease->state != SMB2_LEASE_NONE_LE)))
 			goto again;
 
-		wake_up_oplock_break(brk_opinfo);
+		clear_and_wake_up_bit(0, &brk_opinfo->pending_break);
 		return err;
 	} else {
 		err = oplock_break_pending(brk_opinfo, req_op_level);
@@ -1319,7 +1311,7 @@ static int oplock_break(struct oplock_info *brk_opinfo, struct ksmbd_inode *ci,
 		if (brk_opinfo->level == SMB2_OPLOCK_LEVEL_BATCH ||
 		    brk_opinfo->level == SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
 			if (!oplock_break_set_ack_wait(brk_opinfo)) {
-				wake_up_oplock_break(brk_opinfo);
+				clear_and_wake_up_bit(0, &brk_opinfo->pending_break);
 				return -ENOENT;
 			}
 		}
@@ -1342,7 +1334,7 @@ static int oplock_break(struct oplock_info *brk_opinfo, struct ksmbd_inode *ci,
 	ksmbd_debug(OPLOCK, "oplock granted = %d\n", brk_opinfo->level);
 	if (brk_opinfo->op_state == OPLOCK_CLOSING)
 		err = -EAGAIN;
-	wake_up_oplock_break(brk_opinfo);
+	clear_and_wake_up_bit(0, &brk_opinfo->pending_break);
 
 	return err;
 }
-- 
2.55.0

