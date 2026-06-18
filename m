Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C166F2609DC
	for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 14:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781792272; cv=none; b=swz0qCFvCRcyv7eXHzC4Mff0WaybiYbU5oQ8iDdBF1j26ybJllZxYaSTydcNXnzMP6HsEKah5ZQEzmi8fjwDpJu9ro3GrEQnfnwPnLTmHvLXwHnde7hw4JwwCI44B0wE3w3ZWxuMVNSxuXT+5xw70Tp4NlY+HkHjPtp+v6JiXck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781792272; c=relaxed/simple;
	bh=X+M5R2VLHU6zWSF23+qoxsaIaRNpIi3T0AHtZhwhjzI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TO7IJ73gXNDlDRDcRFLaUL2usgW7daSGT1XEXXlzjWvfNGP/ZhMgrS6Wp98T8sgn2P2M1C5LSrJbeSu+lbveZFPWJZJYvTdyrQpAp6+RecEo3AvVwuxk7wF4S4aUKqXn4rwZeMRlLYnJAqWGvYdmR56Q/11cCv1XspzULGbQUgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YX6m+Ryz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YX6m+Ryz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E6611F00A3D;
	Thu, 18 Jun 2026 14:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781792271;
	bh=m5vdDTPu4QlCgSDGZnoIY0568/YaTxRhxl8rRwa8ftg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YX6m+Ryz5RyE6xJ1JyWJ3ozjCs2sEW+vo9Y0v4xVAHi8HaSpOu5Qh610VJWDDWBLf
	 pgnRKjhda1E0t23ltoAi9KDap1WFJeSbfr1X0UNcjPE9uKNKjOsjJjZ5884psIiSJf
	 7GPTJE1lDbdtUUgA418Tc/Hj8QM1aJlXOT3Rp5RQ5+wixFuQtC5kqln9DpJ4IZV0GP
	 D7KdkkmNdtb/zVRuUIbvsBQJF7YdjkPkZssgMe2mVA0GsBdMeBUnMdGxeUSoORvQIC
	 KF4KHBgcQSfFQAcsYI6JiVz+xqAjgU3PCV6O72+8YMGMWPzpAbiJlwxaSnowMqcDrW
	 luzOGv8k5PhLg==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	metze@samba.org,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 04/14] ksmbd: clean up lease response flags and directory leases
Date: Thu, 18 Jun 2026 23:17:29 +0900
Message-Id: <20260618141739.9029-4-linkinjeon@kernel.org>
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

Do not echo reserved v1 lease flags back to clients. For lease v2
responses, only return BREAK_IN_PROGRESS and PARENT_LEASE_KEY_SET when
they are meaningful, and preserve the parent lease key in the response.

Allow directory leases whenever the request is a valid lease v2 request,
and initialize v2 lease epochs from the first server-granted state change.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index cc5eb95ab3f2..8ae6a6afbe04 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -34,6 +34,11 @@ static bool lease_v2_flags_valid(__le32 flags)
 	return !(flags & ~SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE);
 }
 
+static bool lease_has_parent_key(struct lease *lease)
+{
+	return lease->flags & SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE;
+}
+
 /**
  * alloc_opinfo() - allocate a new opinfo object for oplock info
  * @work:	smb work
@@ -126,7 +131,7 @@ static int alloc_lease(struct oplock_info *opinfo, struct lease_ctx_info *lctx)
 	lease->is_dir = lctx->is_dir;
 	memcpy(lease->parent_lease_key, lctx->parent_lease_key, SMB2_LEASE_KEY_SIZE);
 	lease->version = lctx->version;
-	lease->epoch = le16_to_cpu(lctx->epoch) + 1;
+	lease->epoch = lctx->version == 2 ? 1 : 0;
 	INIT_LIST_HEAD(&opinfo->lease_entry);
 	opinfo->o_lease = lease;
 
@@ -1228,9 +1233,7 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 
 	/* Only v2 leases handle the directory */
 	if (S_ISDIR(file_inode(fp->filp)->i_mode)) {
-		if (!lctx || lctx->version != 2 ||
-		    (lctx->flags != SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE &&
-		     !lctx->epoch))
+		if (!lctx || lctx->version != 2)
 			return 0;
 	}
 
@@ -1493,14 +1496,17 @@ void create_lease_buf(u8 *rbuf, struct lease *lease)
 {
 	if (lease->version == 2) {
 		struct create_lease_v2 *buf = (struct create_lease_v2 *)rbuf;
+		__le32 flags = lease->flags & SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE;
 
 		memset(buf, 0, sizeof(struct create_lease_v2));
 		memcpy(buf->lcontext.LeaseKey, lease->lease_key,
 		       SMB2_LEASE_KEY_SIZE);
-		buf->lcontext.LeaseFlags = lease->flags;
+		if (lease_has_parent_key(lease))
+			flags |= SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE;
+		buf->lcontext.LeaseFlags = flags;
 		buf->lcontext.Epoch = cpu_to_le16(lease->epoch);
 		buf->lcontext.LeaseState = lease->state;
-		if (lease->flags == SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE)
+		if (lease_has_parent_key(lease))
 			memcpy(buf->lcontext.ParentLeaseKey, lease->parent_lease_key,
 			       SMB2_LEASE_KEY_SIZE);
 		buf->ccontext.DataOffset = cpu_to_le16(offsetof
@@ -1518,7 +1524,8 @@ void create_lease_buf(u8 *rbuf, struct lease *lease)
 
 		memset(buf, 0, sizeof(struct create_lease));
 		memcpy(buf->lcontext.LeaseKey, lease->lease_key, SMB2_LEASE_KEY_SIZE);
-		buf->lcontext.LeaseFlags = lease->flags;
+		buf->lcontext.LeaseFlags =
+			lease->flags & SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE;
 		buf->lcontext.LeaseState = lease->state;
 		buf->ccontext.DataOffset = cpu_to_le16(offsetof
 				(struct create_lease, lcontext));
@@ -1583,7 +1590,7 @@ struct lease_ctx_info *parse_lease_state(void *open_req)
 
 		memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
 		lreq->req_state = lc->lcontext.LeaseState;
-		lreq->flags = lc->lcontext.LeaseFlags;
+		lreq->flags = 0;
 		lreq->duration = lc->lcontext.LeaseDuration;
 		if (!lease_state_valid(lreq->req_state))
 			goto err_out;
-- 
2.25.1

