Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442CF28C01C;
	Mon, 14 Jul 2025 23:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752534395; cv=none; b=D36g8wtzAnsayAbmgSNnUdnh3z/1L6RC1ZzocryPevOE3pASvazaj2kUkZBCAkdm4m1n95ywjTE4XCd6v6n1fh/jL41MFTkru2nU5pZFY6mhwV1xkxh2NtiwP5/ftQtjEcJA5DXl+rPlCvuzLzeitejJBe5x64UTkQkXmrQnz58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752534395; c=relaxed/simple;
	bh=Q9laU8u8o/o/hYgzMcPM0W6xLkogyliHcux3hJjDXuM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rbxX1UyzkCJWJ9M7IlUut6dovOQlbPyi9ZJwJz7fDBLH9/NT1XjwYTudQOQ7AyOhW4ss3X+VXVkVX3PTXohHrJIRMPXDY4YAyJxUGU55IZ9iLW33oJ0iGuyDBxP4I+ACnXyLH/FpCxt3KZt0qijPZL/4cuPZks2TMp+yolyCWkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mF+saykt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mF+saykt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D1B5C4CEF0;
	Mon, 14 Jul 2025 23:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752534395;
	bh=Q9laU8u8o/o/hYgzMcPM0W6xLkogyliHcux3hJjDXuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mF+sayktg8KgkwvxXJ8T9havypL8quBcsQ2Q4vrvl/4zd/UkA/TZjwQeignDFnKsq
	 cv8Td89SEEmv4LMdfQH8XLe5t3jvn31fdGX/vGj+2MnFsuOVzLUHxXg6xrkOgzvdTX
	 vqvnhyislB5jFoMTWPRPko14fXD7/FJNDtjOjS1Z/Go9f2qd8dfE0/VD8G/OMro8tq
	 7zkhhCiLAepYq7J98r9PAzaI9GHePcPPm8hFV7ORZGmtRR6IWEXLs4/dAOJhsvAL90
	 gGyNt7pyeGGXZp1a2Dt+YyDiApq9gSFsI+lTxjaxifEko7g+7Rg5M61bAKyK/IO4Kg
	 VLGGH5LH+y8vQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Ziyan Xu <research@securitygossip.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 09/15] ksmbd: fix potential use-after-free in oplock/lease break ack
Date: Mon, 14 Jul 2025 19:06:10 -0400
Message-Id: <20250714230616.3709521-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250714230616.3709521-1-sashal@kernel.org>
References: <20250714230616.3709521-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.6
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 50f930db22365738d9387c974416f38a06e8057e ]

If ksmbd_iov_pin_rsp return error, use-after-free can happen by
accessing opinfo->state and opinfo_put and ksmbd_fd_put could
called twice.

Reported-by: Ziyan Xu <research@securitygossip.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

**YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Security Impact Analysis

This commit fixes a critical **use-after-free vulnerability** in the
oplock/lease break acknowledgment handling code paths in ksmbd (kernel
SMB server). This is a serious security issue that can lead to:

1. **Memory corruption** - Accessing freed memory can corrupt kernel
   memory
2. **Kernel crashes** - Dereferencing freed pointers can cause kernel
   panics
3. **Potential privilege escalation** - UAF vulnerabilities can
   potentially be exploited for privilege escalation

## Code Analysis

The commit addresses a race condition where:

1. **Double-free issue**: Both `opinfo_put()` and `ksmbd_fd_put()` could
   be called twice on error paths
2. **Use-after-free of opinfo->op_state**: The code was accessing
   `opinfo->op_state` after potentially freeing the opinfo structure

### Specific Code Changes

In both `smb20_oplock_break_ack()` and `smb21_lease_break_ack()`, the
fix reorganizes the cleanup logic:

**Before (vulnerable pattern):**
```c
opinfo->op_state = OPLOCK_STATE_NONE;
wake_up_interruptible_all(&opinfo->oplock_q);
opinfo_put(opinfo);
ksmbd_fd_put(work, fp);

// ... response setup ...
ret = ksmbd_iov_pin_rsp(work, rsp, sizeof(...));
if (!ret)
    return;

err_out:
opinfo->op_state = OPLOCK_STATE_NONE;  // UAF: opinfo may be freed
wake_up_interruptible_all(&opinfo->oplock_q);
opinfo_put(opinfo);  // Double-free
ksmbd_fd_put(work, fp);  // Double-free
```

**After (fixed pattern):**
```c
// ... response setup ...
ret = ksmbd_iov_pin_rsp(work, rsp, sizeof(...));
if (ret) {
err_out:
    smb2_set_err_rsp(work);
}

// Single cleanup path
opinfo->op_state = OPLOCK_STATE_NONE;
wake_up_interruptible_all(&opinfo->oplock_q);
opinfo_put(opinfo);
ksmbd_fd_put(work, fp);
```

## Stable Kernel Criteria

This commit meets all the stable kernel requirements:

1. **Fixes a real bug**: UAF vulnerabilities are serious security bugs
2. **Small and contained**: The fix is minimal, only reorganizing
   cleanup logic
3. **No new features**: Only fixes the bug, no functional changes
4. **Low regression risk**: The change is straightforward and doesn't
   modify core logic
5. **Clear fix**: The commit clearly addresses the specific UAF issue

## Historical Context

Looking at similar commits in ksmbd:
- Multiple UAF fixes have been backported (e.g., commits 18b4fac5ef17,
  21a4e47578d4, a1f46c99d9ea)
- All have "Cc: stable@vger.kernel.org" tags
- This follows the same pattern of fixing race conditions and UAF issues
  in SMB protocol handling

## Conclusion

This commit should be backported because:
1. It fixes a critical security vulnerability (UAF)
2. The fix is minimal and low-risk
3. It follows the pattern of other ksmbd UAF fixes that were backported
4. The vulnerability was reported by a security researcher (Ziyan Xu)
5. It prevents potential kernel crashes and exploitation

The commit follows stable tree rules perfectly - it's a targeted fix for
an important bug with minimal changes and no architectural
modifications.

 fs/smb/server/smb2pdu.c | 29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index ad2b15ec3b561..f1c7ed1a6ca59 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8535,11 +8535,6 @@ static void smb20_oplock_break_ack(struct ksmbd_work *work)
 		goto err_out;
 	}
 
-	opinfo->op_state = OPLOCK_STATE_NONE;
-	wake_up_interruptible_all(&opinfo->oplock_q);
-	opinfo_put(opinfo);
-	ksmbd_fd_put(work, fp);
-
 	rsp->StructureSize = cpu_to_le16(24);
 	rsp->OplockLevel = rsp_oplevel;
 	rsp->Reserved = 0;
@@ -8547,16 +8542,15 @@ static void smb20_oplock_break_ack(struct ksmbd_work *work)
 	rsp->VolatileFid = volatile_id;
 	rsp->PersistentFid = persistent_id;
 	ret = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_oplock_break));
-	if (!ret)
-		return;
-
+	if (ret) {
 err_out:
+		smb2_set_err_rsp(work);
+	}
+
 	opinfo->op_state = OPLOCK_STATE_NONE;
 	wake_up_interruptible_all(&opinfo->oplock_q);
-
 	opinfo_put(opinfo);
 	ksmbd_fd_put(work, fp);
-	smb2_set_err_rsp(work);
 }
 
 static int check_lease_state(struct lease *lease, __le32 req_state)
@@ -8686,11 +8680,6 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 	}
 
 	lease_state = lease->state;
-	opinfo->op_state = OPLOCK_STATE_NONE;
-	wake_up_interruptible_all(&opinfo->oplock_q);
-	atomic_dec(&opinfo->breaking_cnt);
-	wake_up_interruptible_all(&opinfo->oplock_brk);
-	opinfo_put(opinfo);
 
 	rsp->StructureSize = cpu_to_le16(36);
 	rsp->Reserved = 0;
@@ -8699,16 +8688,16 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 	rsp->LeaseState = lease_state;
 	rsp->LeaseDuration = 0;
 	ret = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_lease_ack));
-	if (!ret)
-		return;
-
+	if (ret) {
 err_out:
+		smb2_set_err_rsp(work);
+	}
+
+	opinfo->op_state = OPLOCK_STATE_NONE;
 	wake_up_interruptible_all(&opinfo->oplock_q);
 	atomic_dec(&opinfo->breaking_cnt);
 	wake_up_interruptible_all(&opinfo->oplock_brk);
-
 	opinfo_put(opinfo);
-	smb2_set_err_rsp(work);
 }
 
 /**
-- 
2.39.5

