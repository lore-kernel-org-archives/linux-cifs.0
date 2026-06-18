Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA592F1FC7
	for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 14:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781792282; cv=none; b=uQTOFoE5HLaYuZ6Z7tgKNB2clSQlzhSAV0mzGdcS8Azz2yI3JJySn85x/lf/eDjIYQ6/ejiXyz3irqJXcnQijJpU+qCEWxtxy47JxnjRjQenHIpD43ujNXrihHxBC9bC84SzRvu6609WPLDwZCB3Mrwu69FQOIhHUxcuCCZDjb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781792282; c=relaxed/simple;
	bh=pX4DkmttiY1QfWMQNRKOoo+9OsEK1kfaQKsHcf+5oWE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AevENL1hbk2+UfZv1NE24NPKMJjdZ1tp90aLnMY0RNb3ycJ50zLFhwv06Gs8oW+j+X1rjOt04KK23Kq+M+rZShwtXMw+yBlW/nvKAFgyMlFRkXLzxRrONFsUmwxT0Zx+0N32/cuAMPFajUuknb15+MVF1hGY1VmqhXvViN7UZzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uf6srseH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uf6srseH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CAF21F00A3D;
	Thu, 18 Jun 2026 14:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781792280;
	bh=p0wKmSa/g3I0e9ZPiD+k+Dh/udDZu4/z9CHWo2Kg2As=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uf6srseHZ5apxI/LoYcLnvb0cheKPi343z7TFS9ds7/Nackx3yladhHUsSnp27Wdt
	 lVdND8U7+WchD4hP6IAnFt1rJXLRmrR2G2K8/jQXgs8XS+V/B/0Eld82l3amcW6EbT
	 q7l26juYWEo7lkku5u2SJO7JdMx3twZlOIE2qrNJLVx4618Kbf3lx40dSwUdbtqM6M
	 EgLDmjQdVFdJfiUC/moGJeYFtrIeprKlSXSKKxd/3U6baVcI8zwKpdYM3OQ8w2sQ6D
	 D4Eh25TBxxncm1vMDwzEW/6WU5/aOV+0b+Lx54/2LHZ9Jdp+qbrXM/i//iQcjU6ikY
	 NCH9dAuzzNJWw==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	metze@samba.org,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 08/14] ksmbd: compute lease break-in-progress flag on response
Date: Thu, 18 Jun 2026 23:17:33 +0900
Message-Id: <20260618141739.9029-8-linkinjeon@kernel.org>
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

SMB2_LEASE_FLAG_BREAK_IN_PROGRESS is a transient create response flag,
not persistent lease state.

Do not store the flag in lease->flags when a same-key open is granted
during a pending break. Instead, derive it from lease opens that are still
waiting for a break ACK while building the lease create response, and keep
lease->flags for persistent lease flags such as the parent lease key.

This clears the flag naturally after the break ACK completes and fixes
reopen responses that report BREAK_IN_PROGRESS after the lease is no
longer breaking.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c | 41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index 81716317bb61..b1740fe988e6 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -39,6 +39,23 @@ static bool lease_has_parent_key(struct lease *lease)
 	return lease->flags & SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE;
 }
 
+static bool lease_break_in_progress(struct lease *lease)
+{
+	struct oplock_info *opinfo;
+	bool ret = false;
+
+	spin_lock(&lease->lock);
+	list_for_each_entry(opinfo, &lease->open_list, lease_entry) {
+		if (opinfo->op_state == OPLOCK_ACK_WAIT) {
+			ret = true;
+			break;
+		}
+	}
+	spin_unlock(&lease->lock);
+
+	return ret;
+}
+
 /**
  * alloc_opinfo() - allocate a new opinfo object for oplock info
  * @work:	smb work
@@ -1292,15 +1309,12 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 		if (m_opinfo) {
 			lease_put(opinfo->o_lease);
 			lease_get(m_opinfo->o_lease);
-			opinfo->o_lease = m_opinfo->o_lease;
-			opinfo->level = m_opinfo->level;
-			new_lease = false;
-			if (atomic_read(&m_opinfo->breaking_cnt))
-				opinfo->o_lease->flags |=
-					SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE;
-			opinfo_put(m_opinfo);
-			goto out;
-		}
+				opinfo->o_lease = m_opinfo->o_lease;
+				opinfo->level = m_opinfo->level;
+				new_lease = false;
+				opinfo_put(m_opinfo);
+				goto out;
+			}
 	}
 	prev_opinfo = opinfo_get_list(ci);
 	if (!prev_opinfo ||
@@ -1521,13 +1535,15 @@ void create_lease_buf(u8 *rbuf, struct lease *lease)
 {
 	if (lease->version == 2) {
 		struct create_lease_v2 *buf = (struct create_lease_v2 *)rbuf;
-		__le32 flags = lease->flags & SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE;
+		__le32 flags = 0;
 
 		memset(buf, 0, sizeof(struct create_lease_v2));
 		memcpy(buf->lcontext.LeaseKey, lease->lease_key,
 		       SMB2_LEASE_KEY_SIZE);
 		if (lease_has_parent_key(lease))
 			flags |= SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE;
+		if (lease_break_in_progress(lease))
+			flags |= SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE;
 		buf->lcontext.LeaseFlags = flags;
 		buf->lcontext.Epoch = cpu_to_le16(lease->epoch);
 		buf->lcontext.LeaseState = lease->state;
@@ -1549,8 +1565,9 @@ void create_lease_buf(u8 *rbuf, struct lease *lease)
 
 		memset(buf, 0, sizeof(struct create_lease));
 		memcpy(buf->lcontext.LeaseKey, lease->lease_key, SMB2_LEASE_KEY_SIZE);
-		buf->lcontext.LeaseFlags =
-			lease->flags & SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE;
+		if (lease_break_in_progress(lease))
+			buf->lcontext.LeaseFlags =
+				SMB2_LEASE_FLAG_BREAK_IN_PROGRESS_LE;
 		buf->lcontext.LeaseState = lease->state;
 		buf->ccontext.DataOffset = cpu_to_le16(offsetof
 				(struct create_lease, lcontext));
-- 
2.25.1

