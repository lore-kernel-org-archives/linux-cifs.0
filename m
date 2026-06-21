Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E3D3659FB
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 12:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046177; cv=none; b=K4nfeEsoMUCuYaOWoprBOzsPgdQxYVb7RgorMjIlOW2AX0cXeQ6mYRcVI5A2c1cmT07Hp7NYAnd+cG798RVLgYbSKLmVsJSuqrVTcR4nV4G/3cuzi6GqMOAuq7mGSjMEntW7jm+5RB4EnTijWx5wFD23rz8GpVGvSSWRZVrhg30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046177; c=relaxed/simple;
	bh=V5u21UWkD8wBFWC4fzSvmenOsuq5K2fEx8bt/H5UHK8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WAa+M46E0PGE1jQ8INyIPSrY3cSMEGm8Ga7ZusdbRAkiRqHJmX1MOcbDw0TGVmeetCi/kIs3yJ6jyR4FYIAfvxIKmDIHxd/U0eX9Jrc/kRi/DIFiOeOjbRtI9T5Q0hzHR25DD2CkV+lH2Pt6VFmcLKiNNf8i+eXmhv9OIr6Zw4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MYbIs14k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MYbIs14k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C351F00A3A;
	Sun, 21 Jun 2026 12:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782046176;
	bh=53bAMdvb+NZCUSMU71JBZEmlnjS5XmQotVaBzMM4LX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MYbIs14kEDrnK3kCKcKjpQ/8UlDTHsmk0c434V8dryjuppZgdOUZNNc98va9wS9kf
	 daCG5GNUNSB4ZNVNcL8wCRuAvBQfFnf+BpZMQHS46jAtRB7i1AST1ic2qLa5dY6dzB
	 0UtbuSBI3kH/9wfvEZbCb/DadiCzk+fw68/LXKZcSuI8XOXkVOs6Vig7JWrOBvReyE
	 5kZVsxD3sddO9vOSsNTJccE2Th1iAAvPYOAOi/pLLguFEnc0ogBJJbY/czwfKgW+94
	 xr2VbXDkwwLtxEa5xduJJSgfff/eHWe0cm0XRNwRNGPK6vg3YoDAOj8G13W0eDgYLc
	 L5kON/QMx6WBA==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 23/29] ksmbd: break handle caching for share conflicts
Date: Sun, 21 Jun 2026 21:48:38 +0900
Message-Id: <20260621124844.6235-23-linkinjeon@kernel.org>
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

smb2.lease.break_twice first opens a file with an RHW lease and then tries
a second open with restrictive sharing.  That open must fail with a sharing
violation, but the existing lease should be broken from RHW to RW because
only handle caching conflicts with the requested sharing.

ksmbd used the normal write-cache break calculation for this path, so RHW
was broken to RH.  The following successful open then did not generate the
expected second break from RW to R.

Pass share-conflict context into the lease break helper and, for lease
breaks caused by sharing, drop only SMB2_LEASE_HANDLE_CACHING from the
current lease state.  Other break paths keep the existing write/truncate
break behavior.

A share-conflict break must also remain a single break.  The triggering
open fails with a sharing violation and is never granted, so there is no
target oplock level to converge on.  The lease break retry loop, however,
keeps breaking while the lease level is still above req_op_level, which
broke RHW all the way down to R in one open (lease_break_info.count became
2 instead of 1).  Skip the again loop for share-conflict breaks so the
sharing open produces exactly one RHW->RW break and the later successful
open produces the separate RW->R break the test expects.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index ff9a72236b4d..b15c0fb0c0c7 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1035,7 +1035,7 @@ static void wait_lease_breaking(struct oplock_info *opinfo)
 }
 
 static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level,
-			struct ksmbd_work *in_work)
+			struct ksmbd_work *in_work, bool share_break)
 {
 	int err = 0;
 	bool sent_interim = false;
@@ -1073,6 +1073,10 @@ static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level,
 			 * none.
 			 */
 			lease->new_state = SMB2_LEASE_NONE_LE;
+		} else if (share_break &&
+			   lease->state & SMB2_LEASE_HANDLE_CACHING_LE) {
+			lease->new_state =
+				lease->state & ~SMB2_LEASE_HANDLE_CACHING_LE;
 		} else {
 			if (lease->state & SMB2_LEASE_WRITE_CACHING_LE) {
 				if (lease->state & SMB2_LEASE_HANDLE_CACHING_LE)
@@ -1121,7 +1125,13 @@ static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level,
 
 		if (wait_ack)
 			wait_lease_breaking(brk_opinfo);
-		if (wait_ack && !err &&
+		/*
+		 * A break caused by a share-mode conflict only drops the
+		 * conflicting caching bit and the triggering open still fails
+		 * with a sharing violation, so it must stay a single break.
+		 * Do not cascade down to req_op_level through the again loop.
+		 */
+		if (wait_ack && !err && !share_break &&
 		    lease_break_needed(brk_opinfo, req_op_level, open_trunc))
 			goto again;
 
@@ -1281,7 +1291,7 @@ void smb_send_parent_lease_break_noti(struct ksmbd_file *fp,
 				continue;
 			}
 
-			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE, NULL);
+			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE, NULL, false);
 			opinfo_put(opinfo);
 		}
 	}
@@ -1322,7 +1332,7 @@ void smb_lazy_parent_lease_break_close(struct ksmbd_file *fp)
 				continue;
 			}
 
-			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE, NULL);
+			oplock_break(opinfo, SMB2_OPLOCK_LEVEL_NONE, NULL, false);
 			opinfo_put(opinfo);
 		}
 	}
@@ -1441,7 +1451,8 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 		prev_fid = prev_opinfo->fid;
 	}
 
-	err = oplock_break(prev_opinfo, break_level, work);
+	err = oplock_break(prev_opinfo, break_level, work,
+			   share_ret < 0 && prev_opinfo->is_lease);
 	if (prev_durable_detached || (prev_durable_open && err == -ENOENT))
 		ksmbd_invalidate_durable_fd(prev_fid);
 	opinfo_put(prev_opinfo);
@@ -1539,7 +1550,7 @@ static bool smb_break_all_write_oplock(struct ksmbd_work *work,
 	}
 
 	brk_opinfo->open_trunc = is_trunc;
-	oplock_break(brk_opinfo, SMB2_OPLOCK_LEVEL_II, work);
+	oplock_break(brk_opinfo, SMB2_OPLOCK_LEVEL_II, work, false);
 	sent_break = true;
 	opinfo_put(brk_opinfo);
 
@@ -1609,7 +1620,8 @@ static void __smb_break_all_levII_oplock(struct ksmbd_work *work,
 			oplock_break(brk_op,
 				     brk_op->is_lease && !is_trunc ?
 				     SMB2_OPLOCK_LEVEL_II : SMB2_OPLOCK_LEVEL_NONE,
-				     send_interim && !sent_interim ? work : NULL);
+				     send_interim && !sent_interim ? work : NULL,
+				     false);
 		}
 		sent_interim = true;
 next:
-- 
2.25.1

