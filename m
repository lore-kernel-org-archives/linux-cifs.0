Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71DE72621
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 12:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046179; cv=none; b=I+B4NuadKeA2Q6DTat2sU1xXEdhTame85F1BBpL95IGSjZg+a5eq96UsujS7EMAHtgw3RgDHQjyoGc5qow8E2SWyYsNsYNNj9waqImv0guKrvy5QmpVAYgKI34763YA+29pOno5Q0HpfvONpT/hDAxJDKKHqaeNxsviK86XFLng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046179; c=relaxed/simple;
	bh=5jQ+27wC73d9txbEq6MeWdYhlomS4MU8hUmEYwitQmY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KwhUE0U7yp4n+d40cE70P4xmFvvnH+28x6UV++YhWqlNtMAaLkYvWm/W3wtpelA+fa1N1uuHqYDyPRqCyrmp1u4cCRJdUIAbqeMju3OxOgkxJw/xSzUAqHsZQffxDGwwy4SKu5rsZDy6MYODOmYmGLuf6Bt6RvNfICjQ86FlMdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oGx2V6VX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oGx2V6VX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F361F000E9;
	Sun, 21 Jun 2026 12:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782046178;
	bh=Vvbhj5B5KOmwNHI5xS6k/mFPMYHBZPJ743sN1g0Bhow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oGx2V6VXLc60vMXYx0IotIMH2D3YlNooltzQLDIJyMyY7vnPmQhoy9bKuqhYZ7fXN
	 yj2IKU10mvXl7rTSbCk03UFLWzA2Ej+N8tIWyN3S0fAnK+SZv5w5oCKMxfralhLGg9
	 6TzbgWHVKow95T64nxtdwMET9HlM60Njo9fCItrZXvRHL7VhMPQOba85HG1zJf4z2s
	 v4P4gV4EVUMuD//EE9KcFM6FpxfAnLhyhuYqFRMcRRp6rjJ8fiFdiXLG0pIO9FQwmC
	 cq0Cgk6OQCijvCoal6nL5O11lg466ZjDDP0zB5ht3Wo2u199cbNTEzEOvi6SOnrUc9
	 WQiZRp1D/0BCg==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 24/29] ksmbd: break conflicting-open leases only as far as needed
Date: Sun, 21 Jun 2026 21:48:39 +0900
Message-Id: <20260621124844.6235-24-linkinjeon@kernel.org>
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

smb2.lease.oplock and smb2.lease.breaking1 hold a lease and then issue a
single conflicting open on the same file.  The held lease must break one
step to drop write caching (RWH->RH, RW->R) and then stop, so
lease_break_info.count is 1 and the lease keeps its read/handle caching.

ksmbd instead cascaded the break all the way down to none
(e.g. RWH->RH->R->none), so the break count was 2 or 3 and the reported
lease state ended at 0.  Commit "chain pending lease breaks before waking
waiters" forces break_level to SMB2_OPLOCK_LEVEL_NONE for any non-lease
open against a handle-caching lease, which drives oplock_break()'s retry
loop down to none even when only one open is contending.

Drop that break_level override so a conflicting open breaks a lease only
to its own compatible level (level II, i.e. RH/R).

A deeper break is still required when a truncating open is also waiting
behind the same lease break.  smb2.lease.breaking3 keeps a normal open
pending through RWH->RH and an overwrite open pending behind it, and
expects the lease to continue RH->R->none before either open completes.
The overwrite waiter sets open_trunc on the lease while it blocks on the
pending break, so extend the retry loop to chain another break while that
truncating waiter still needs the lease at none.  The per-break open_trunc
snapshot stays cleared, so the cascade steps down (RH->R->none) instead of
collapsing straight to none, and the normal open stays pending until the
lease is fully broken.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/oplock.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
index b15c0fb0c0c7..fa7efd45b8e5 100644
--- a/fs/smb/server/oplock.c
+++ b/fs/smb/server/oplock.c
@@ -1126,13 +1126,22 @@ static int oplock_break(struct oplock_info *brk_opinfo, int req_op_level,
 		if (wait_ack)
 			wait_lease_breaking(brk_opinfo);
 		/*
-		 * A break caused by a share-mode conflict only drops the
-		 * conflicting caching bit and the triggering open still fails
-		 * with a sharing violation, so it must stay a single break.
-		 * Do not cascade down to req_op_level through the again loop.
+		 * A share-mode conflict break only drops the conflicting
+		 * caching bit; the triggering open fails with a sharing
+		 * violation, so keep it to a single break.
+		 *
+		 * Otherwise chain another break while the lease is still
+		 * incompatible with this open (req_op_level), or while a
+		 * truncating waiter that arrived during the break still needs
+		 * the lease dropped to none.  open_trunc snapshotted for this
+		 * break stays cleared, so the next state is computed from the
+		 * lease state and the cascade steps down (e.g. RH->R->none)
+		 * instead of collapsing straight to none.
 		 */
 		if (wait_ack && !err && !share_break &&
-		    lease_break_needed(brk_opinfo, req_op_level, open_trunc))
+		    (lease_break_needed(brk_opinfo, req_op_level, open_trunc) ||
+		     (brk_opinfo->open_trunc &&
+		      lease->state != SMB2_LEASE_NONE_LE)))
 			goto again;
 
 		wake_up_oplock_break(brk_opinfo);
@@ -1426,10 +1435,6 @@ int smb_grant_oplock(struct ksmbd_work *work, int req_op_level, u64 pid,
 	prev_op_has_lease = prev_opinfo->is_lease;
 	if (prev_op_has_lease)
 		prev_op_state = prev_opinfo->o_lease->state;
-	if (prev_op_has_lease && !lctx &&
-	    prev_op_state & SMB2_LEASE_HANDLE_CACHING_LE)
-		break_level = SMB2_OPLOCK_LEVEL_NONE;
-
 	if (share_ret < 0 &&
 	    prev_opinfo->level == SMB2_OPLOCK_LEVEL_EXCLUSIVE) {
 		err = share_ret;
-- 
2.25.1

