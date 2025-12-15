Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A942FD684;
	Mon, 15 Dec 2025 00:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765759326; cv=none; b=RfgnYgDoHDMJQhoqnEEunBlCnWXV+vst9bKpCDBzazcoMindLp/OX1JuBWSi8QNg7hkTUKXs5xBfMAPuhy55ugyw2vL0OgjalJsmYso2O7hRPczRJAQBPizJSpdwJNSaPyzG/MK/dWc7pLLzsrC85DiyuinlZ5J0YJ9t564p8vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765759326; c=relaxed/simple;
	bh=H7yrdNOUtFMYVZYDaZKM1ggTU+UQEDy1CXvjJIhboB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uYxBBkF5MXoQpD2HFGNARJUCP1hxgd3pUTEKyzDFyF2HhWJYp7AzN/zNIJTsbup/Q7GBG835bkk+PBG7wFGrcSDN+C4Z8u49xbqCORuhsvM1gsQ/v9mVAD+vPUCeyyNq1dRTwuCAYhgAcq3OQCyCVB6DTKGi72VZBmYbW307U+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mUv/1YUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mUv/1YUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E80CCC19421;
	Mon, 15 Dec 2025 00:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765759326;
	bh=H7yrdNOUtFMYVZYDaZKM1ggTU+UQEDy1CXvjJIhboB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUv/1YUbbgSqX9hJz5sWssk1Ilci1Nadf79o8yM+vlTCsjp0RVzEFKuu7+2mQx2Th
	 PMvKAcz9nK47Hofhk70FEfLbkDKxHyhjVvDPbc1rqzjOawniJX/seHlSHLrpPR9iSX
	 r4L+e9BK+3CrLf8jvwqSE2kQ+Uc72gFHqEJyulJfS0pqHNu9Z0gCszVMF7NkQlao83
	 axI3y3zv3Su8VevMQAJlJxGdQgl73gZk3oCIFgXe5Rr+V9GnnkrNZxOeQcUy0kpT+q
	 5OvK+3fjZ2FDy82YhqWzthPFjN8bS9EsnjAzRPjsDohMfQx6OIHbTsuGdHUqj8Y6hq
	 EFIvJSTNO+FTg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: ChenXiaoSong <chenxiaosong@kylinos.cn>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.18-6.1] smb/client: fix NT_STATUS_UNABLE_TO_FREE_VM value
Date: Sun, 14 Dec 2025 19:41:26 -0500
Message-ID: <20251215004145.2760442-9-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251215004145.2760442-1-sashal@kernel.org>
References: <20251215004145.2760442-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit 9f99caa8950a76f560a90074e3a4b93cfa8b3d84 ]

This was reported by the KUnit tests in the later patches.

See MS-ERREF 2.3.1 STATUS_UNABLE_TO_FREE_VM. Keep it consistent with the
value in the documentation.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of smb/client: fix NT_STATUS_UNABLE_TO_FREE_VM value

### 1. COMMIT MESSAGE ANALYSIS

The commit explicitly states it's a "fix" for an incorrect NT status
code value. Key points:
- Found by KUnit tests (systematic testing uncovered the issue)
- References MS-ERREF 2.3.1 documentation as the authoritative source
- Acked by Paulo Alcantara (Red Hat) - a key SMB/CIFS maintainer
- Committed by Steve French - the SMB subsystem maintainer

### 2. CODE CHANGE ANALYSIS

The change is a single-line modification in `fs/smb/client/nterr.h`:

```c
-#define NT_STATUS_UNABLE_TO_FREE_VM 0x80000000 | 0x001a
+#define NT_STATUS_UNABLE_TO_FREE_VM 0xC0000000 | 0x001a
```

In NT status codes, the high bits encode severity:
- `0x00000000` = Success
- `0x40000000` = Informational
- `0x80000000` = Warning
- `0xC0000000` = Error

The bug: `NT_STATUS_UNABLE_TO_FREE_VM` was incorrectly defined as a
"Warning" (`0x80000000`) instead of "Error" (`0xC0000000`). Looking at
the context, **all surrounding status codes** use `0xC0000000`, making
this one obvious outlier.

Per Microsoft's MS-ERREF documentation, STATUS_UNABLE_TO_FREE_VM
(0xC000001A) is indeed an error status, not a warning.

### 3. CLASSIFICATION

- **Bug type:** Incorrect constant value (data bug)
- **Not a feature:** Simply corrects an existing definition to match
  specification
- **Not a security issue:** Though incorrect error handling could have
  unexpected effects

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed:** 1
- **Files touched:** 1 (header file)
- **Complexity:** Minimal - single character change (`8` → `C`)
- **Risk:** Essentially zero - corrects an obvious typo/error to match:
  1. The official Microsoft documentation
  2. The pattern used by all surrounding definitions

### 5. USER IMPACT

If an SMB server returns this status code, the client would fail to
properly match and handle it due to the incorrect value. This could
cause:
- Failure to recognize error conditions
- Incorrect error messages to users
- Potential mishandling of this error scenario

While this specific status code may be rarely encountered in practice,
when it does occur, the current code would misbehave.

### 6. STABILITY INDICATORS

- **Reviewed by maintainers:** Acked by Paulo Alcantara, committed by
  Steve French
- **Testing:** Found through KUnit tests (automated testing)
- **Pattern consistency:** All other NT_STATUS_* codes in the same
  numerical range use `0xC0000000`

### 7. DEPENDENCY CHECK

This is a completely standalone fix. The header file has existed for a
long time, and this is just correcting an incorrect value within it. No
dependencies on other commits.

---

### Summary

**Should this be backported?**

This commit is an excellent backport candidate:

1. **Obviously correct:** The fix makes the value match both official
   Microsoft documentation and the pattern used by all surrounding
   definitions
2. **Fixes a real bug:** Incorrect status code would cause mismatched
   error handling
3. **Minimal scope:** One-character change in a single header file
4. **Zero regression risk:** This is purely a correctness fix to a
   constant
5. **No new features:** Just corrects existing code
6. **No dependencies:** Standalone fix
7. **Well-reviewed:** Acked by key SMB maintainer

This is exactly the type of safe, surgical, low-risk fix that stable
trees should include. The change is so minimal and so obviously correct
that there's essentially no risk, while the benefit is ensuring correct
SMB protocol handling.

**YES**

 fs/smb/client/nterr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
index 180602c22355e..e3a607b45e719 100644
--- a/fs/smb/client/nterr.h
+++ b/fs/smb/client/nterr.h
@@ -70,7 +70,7 @@ extern const struct nt_err_code_struct nt_errs[];
 #define NT_STATUS_NO_MEMORY 0xC0000000 | 0x0017
 #define NT_STATUS_CONFLICTING_ADDRESSES 0xC0000000 | 0x0018
 #define NT_STATUS_NOT_MAPPED_VIEW 0xC0000000 | 0x0019
-#define NT_STATUS_UNABLE_TO_FREE_VM 0x80000000 | 0x001a
+#define NT_STATUS_UNABLE_TO_FREE_VM 0xC0000000 | 0x001a
 #define NT_STATUS_UNABLE_TO_DELETE_SECTION 0xC0000000 | 0x001b
 #define NT_STATUS_INVALID_SYSTEM_SERVICE 0xC0000000 | 0x001c
 #define NT_STATUS_ILLEGAL_INSTRUCTION 0xC0000000 | 0x001d
-- 
2.51.0

