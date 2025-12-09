Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3BE2C0F62;
	Tue,  9 Dec 2025 00:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765239479; cv=none; b=E8RB/8B8et8MWqdtH7h/ju80cAnS6NW9wCo4ss/klMjD/3V3/NM2kHxadRJzvcT8OgANLzPzOxLGDegihgcgbJ07NiJKZ1Q85v4UWgG0z+9+UsFMij66kQi9pwClqZrkQnPejAx074mKDhc9ikmOIyrX/gsYLt98TqxdES2Su1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765239479; c=relaxed/simple;
	bh=D21DNG/AwzkTcS5+b923mUwVoD/kjUs4AYJ1WUyQV+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LAZ+VLjVXySpraKl9VkpVjapw5p5uGVxz7mHQsquHyzYRHgRfg5WGpMrFawsco4nGLbiTsBtxYWdSCj+YYkrar3OSo0gIGKkiLTfzWwNcJpPPqj4bum8/Q5QhCGHP5iYaxBScISJxFF1G3t4EHOaTNm53m7YFtijBzTDKRBL6iI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qbn7OhdT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qbn7OhdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B3AC113D0;
	Tue,  9 Dec 2025 00:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765239478;
	bh=D21DNG/AwzkTcS5+b923mUwVoD/kjUs4AYJ1WUyQV+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qbn7OhdTd/0kS2I0flCoMf4TW93bhTsFYIKmNb4Tpa0HPPHyiaPKS2dy4Z1wvmpum
	 DUgjHoyycuRGsoYmhzTpH90peiY97492QFTyCoJCkW/1pyUdGKyXU2jQ3dmJyI+3Od
	 uppsQdao0WTU19K67dvTxQVNXDd2c17jaJMEwekZF+8MP2EARSI1/6AkFz9XoRat8B
	 zc1WgCnNyQRmhn0FjomRaWrKkWe7JcEV8PIwuP1ChC4W9LQWJrytWhFY8RQMbGJstR
	 xvtDsyx2UaErR9wXDSlDmsIg0Wj3DQbLFJG64iLRbDNfcKU5Uy9ySMhMWTekWcNtrn
	 l16h6RpG+uy5A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] smb/server: fix return value of smb2_query_dir()
Date: Mon,  8 Dec 2025 19:15:26 -0500
Message-ID: <20251209001610.611575-34-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251209001610.611575-1-sashal@kernel.org>
References: <20251209001610.611575-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit dafe22bc676d4fcb1ccb193c8cc3dda57942509d ]

__process_request() will not print error messages if smb2_query_dir()
always returns 0.

Fix this by returning the correct value at the end of function.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of smb/server: fix return value of smb2_query_dir()

### 1. COMMIT MESSAGE ANALYSIS

The commit message clearly states:
- `__process_request()` will not print error messages if
  `smb2_query_dir()` always returns 0
- The fix returns the correct error value `rc` instead of 0

**Notable absences:**
- No `Cc: stable@vger.kernel.org` tag
- No `Fixes:` tag identifying when the bug was introduced

**Positive signals:**
- Acked by Namjae Jeon (ksmbd maintainer)
- Signed off by Steve French (SMB maintainer)

### 2. CODE CHANGE ANALYSIS

The change is a single-line fix in the error handling path:

```c
- return 0;
+       return rc;
```

**Technical mechanism of the bug:**
Looking at the context, this is in an error handling block where:
1. `rc` contains an error code (-EINVAL, -EACCES, -ENOENT, -EBADF,
   -ENOMEM, -EFAULT, or -EIO)
2. The appropriate SMB status is set in `rsp->hdr.Status`
3. Error response is prepared with `smb2_set_err_rsp(work)`
4. Cleanup is done with `ksmbd_fd_put()` and `ksmbd_revert_fsids()`
5. **BUG**: The function returns 0 (success) instead of `rc` (the actual
   error)

**Root cause:** The caller `__process_request()` uses the return value
to determine if an error occurred. Returning 0 masks all errors,
preventing proper error logging and handling.

### 3. CLASSIFICATION

This is a **bug fix** - incorrect error return value handling. The
function was silently discarding error information that callers need.

### 4. SCOPE AND RISK ASSESSMENT

| Factor | Assessment |
|--------|------------|
| Lines changed | 1 |
| Files touched | 1 |
| Complexity | Trivial |
| Subsystem | ksmbd (kernel SMB server) |
| Risk level | **Very Low** |

The fix is surgical and obviously correct - the `rc` variable already
contains the appropriate error code, it just wasn't being returned.

### 5. USER IMPACT

- **Affected users:** ksmbd server users
- **Severity:** Medium - error conditions in directory queries are not
  properly reported
- **Consequences of the bug:**
  - Error messages not printed when they should be
  - Callers may not handle error conditions properly
  - Debugging ksmbd issues becomes harder

### 6. STABILITY INDICATORS

- Acked by ksmbd maintainer
- Signed off by SMB maintainer
- Simple, self-contained change

### 7. DEPENDENCY CHECK

- No dependencies on other commits
- ksmbd has been in the kernel since 5.15
- The fix applies to existing code paths

### STABLE KERNEL CRITERIA EVALUATION

| Criterion | Met? | Notes |
|-----------|------|-------|
| Obviously correct | ✅ | Trivially correct - return error code instead
of 0 |
| Fixes real bug | ✅ | Error propagation was broken |
| Small and contained | ✅ | Single line change |
| No new features | ✅ | Pure bug fix |
| Tested | ⚠️ | No Tested-by tag, but very low risk |

### RISK VS BENEFIT

**Benefits:**
- Fixes broken error propagation in ksmbd directory queries
- Enables proper error logging for debugging
- Very low risk due to trivial nature of fix

**Risks:**
- Minimal - the change is from "always return 0" to "return actual error
  code"
- Behavior change only affects error paths

### CONCLUSION

This is a straightforward, obviously correct bug fix. The function was
incorrectly returning 0 (success) in all error cases, causing error
information to be lost. The fix is a single line change that returns the
actual error code that was already being computed.

While the commit lacks explicit stable tags, it meets all stable
criteria: obviously correct, fixes a real bug affecting error handling,
trivially small scope, and no new features. The risk is minimal and the
fix improves error handling in ksmbd.

**YES**

 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index f901ae18e68ad..8975b6f2f5800 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4560,7 +4560,7 @@ int smb2_query_dir(struct ksmbd_work *work)
 	smb2_set_err_rsp(work);
 	ksmbd_fd_put(work, dir_fp);
 	ksmbd_revert_fsids(work);
-	return 0;
+	return rc;
 }
 
 /**
-- 
2.51.0

