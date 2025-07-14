Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B959E292B5D;
	Mon, 14 Jul 2025 23:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752534452; cv=none; b=HkWmqiordYlo4eaF/Rj0JcTbP9Fey/5kVzcZKjBz9murJ1DOZ2qUmRH9LSJ9pZsQSI4JK2uzuB5UATxsmQ9Qic9tKtlrU26wDCkeIGv9fGvLgZ5by4k+BoH0iPNVSypzd31Wk+z1bMMAxBLGHVJKoV4C7P/CNdffH4FFL6soloY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752534452; c=relaxed/simple;
	bh=VSGgKy7CKq9N01hf1600cDEzaGt31fZ/DGmwPuj5G4o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=s2cXxPWriXfRK+OBUknOmASXOfWW+lziT3ItGOx0effB0GahIDxXz7T25pd7z5q0iR2TYI5ggJ4xSg/sPzhsObW1WFFIjIdigXu92/tXAixU3rFRhW9DfdA89wCsO5xnHVAzAca9vQLPob2Mho5/E0Lfycq+H/16SrPyG+2/fc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JJt3tOjm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JJt3tOjm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48594C4CEED;
	Mon, 14 Jul 2025 23:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752534452;
	bh=VSGgKy7CKq9N01hf1600cDEzaGt31fZ/DGmwPuj5G4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JJt3tOjmGUy53LN3kxljgQ6r1/FpU6m3AYKy4hKFvmYIt4LHROF0zWe9AK0udX9/r
	 J+ZtnBhXLtXqiULkYXs3Lwb8AxxTihM07d7r83SAT40tZxlSamyEnZMOQnilAjg2s2
	 E1ggab3s4iIlUSyCnsvLQQKyfoGtRYl6xhOKGrt2AkQFmH4Eu/IVdsiMxiAWDazCJB
	 pQH01MfkV8+ESSFYhBUwdRzBpT2f+sQD0U4O20RzhZW09ZNeElsd+gcw1cVv4OcmFo
	 BpHURHUep+V3/2BJjYd7sD7rjH2vlfigIhfD7GPU3v8PAIWg5H9009cFUv+4p+haop
	 vobgm0ACMCeSQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Ziyan Xu <research@securitygossip.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 08/12] ksmbd: fix potential use-after-free in oplock/lease break ack
Date: Mon, 14 Jul 2025 19:07:11 -0400
Message-Id: <20250714230715.3710039-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250714230715.3710039-1-sashal@kernel.org>
References: <20250714230715.3710039-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.38
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
index 5d2324c09a070..a97a2885730da 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8517,11 +8517,6 @@ static void smb20_oplock_break_ack(struct ksmbd_work *work)
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
@@ -8529,16 +8524,15 @@ static void smb20_oplock_break_ack(struct ksmbd_work *work)
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
@@ -8668,11 +8662,6 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 	}
 
 	lease_state = lease->state;
-	opinfo->op_state = OPLOCK_STATE_NONE;
-	wake_up_interruptible_all(&opinfo->oplock_q);
-	atomic_dec(&opinfo->breaking_cnt);
-	wake_up_interruptible_all(&opinfo->oplock_brk);
-	opinfo_put(opinfo);
 
 	rsp->StructureSize = cpu_to_le16(36);
 	rsp->Reserved = 0;
@@ -8681,16 +8670,16 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
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

