Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4E229CB58;
	Mon, 14 Jul 2025 23:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752534491; cv=none; b=WaT+vY/eEbylshA1kaJK1EKggUL7BDMOcC1I8zaQ9RjvD/sO0cptKi/3SWU8lK9qiH0MeFEtmJJ06YQ3o2IdIGxQMNDf39PND8UEEZIjG96oTyWG9hi9YpHwr0T+bj7fzFE7oV19OZXqp+LihgKyOQejCYv2yp6Pa+JAgrXe6B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752534491; c=relaxed/simple;
	bh=AqiPT8XXFfGA33M/IreuwUURLhP9JSskrKmOJIGLc3Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=avg6oEh+fInTKlMhcpaKgOCROOEoszRIU9LHcS3oO3Y0B9dLt0YbhoXFtxEtKbxzx5hCyfQqVl4+PkAYMfDJXBY+NB0SHSAf9KJurjRQ721P+1QEj/iBb1B3TQqyt7zxOITi0qV9PUwIBzh0x8buP827+g0GrXaCCfBSfWwPDTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=feJGyymi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="feJGyymi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D713C4CEED;
	Mon, 14 Jul 2025 23:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752534491;
	bh=AqiPT8XXFfGA33M/IreuwUURLhP9JSskrKmOJIGLc3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=feJGyymiPWqcKfqyvOfjn5/evxh/lLY6fPMcnqXb1I+ZnFYmrnWe8bYHdceLYXjN+
	 jEwV29P32di46DjbGY+8JbOTcESbuQW9yU9TaSVcF+eODaxmMCgYZTsBlPiZYkQ1bz
	 209eZeeU06UJZOScoN0kh4cF58F3+LxhJvv8S2Sp0HHDSGMaefo+UEM8WuH9L+NHBw
	 bCVR7sBNwdd/se4px0HMfmIaAxdJlWHxrDz/gLId700xvqeDWqgHpvu5UBXgRcBAn3
	 38+4DWGHRcJnNUd1QK/z1F97v/zhe8vTUw4Y/hJ+3qWzS0tD7E8m26WBMCDYN89vlE
	 0ORsHEL/nt34Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Ziyan Xu <research@securitygossip.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 4/4] ksmbd: fix potential use-after-free in oplock/lease break ack
Date: Mon, 14 Jul 2025 19:07:58 -0400
Message-Id: <20250714230759.3710404-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250714230759.3710404-1-sashal@kernel.org>
References: <20250714230759.3710404-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.145
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
index 899285bba8dda..a04413095b23b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8144,11 +8144,6 @@ static void smb20_oplock_break_ack(struct ksmbd_work *work)
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
@@ -8156,16 +8151,15 @@ static void smb20_oplock_break_ack(struct ksmbd_work *work)
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
@@ -8295,11 +8289,6 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
 	}
 
 	lease_state = lease->state;
-	opinfo->op_state = OPLOCK_STATE_NONE;
-	wake_up_interruptible_all(&opinfo->oplock_q);
-	atomic_dec(&opinfo->breaking_cnt);
-	wake_up_interruptible_all(&opinfo->oplock_brk);
-	opinfo_put(opinfo);
 
 	rsp->StructureSize = cpu_to_le16(36);
 	rsp->Reserved = 0;
@@ -8308,16 +8297,16 @@ static void smb21_lease_break_ack(struct ksmbd_work *work)
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

