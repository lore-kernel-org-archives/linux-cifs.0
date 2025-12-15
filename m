Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D5A2F83B0;
	Mon, 15 Dec 2025 00:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765759310; cv=none; b=EYQsFsNE1+87pU0kRpWKWolz2GBSl+Ufb+fLTZw/DSKQKv2lFMKh7+dfDgRjbr7aZR9EAO8QgHSi8LMUw5VjqJv86G/6GfdtNNYyO3SGe0GjTXaHTzjmrieGOVosWqozVVL0B9LTQnHKiwfoLMA797hCp7S5OwQ+dowCQDjWd0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765759310; c=relaxed/simple;
	bh=l6PLGSrfAr2bnC3zFhkGdV6nRMZEaikE9zMrnkeSBLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MOka6A3aBwNM7iqGZdSn2VzaSp+FqFwuCiLQj6NnKOa7eK/GUdO6FRt9X7NlqCexWPXb8uJajtNs4JJbsmpJQk9xTLeo9dgKE7otf9KA0533b5GLBc0UZ9KzmXy7RjD9sa6Q/J4sKvhVbSIOofAhNm0EiB5PVteGf9vyZMSnjBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AzsV5G92; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AzsV5G92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC12C4CEFB;
	Mon, 15 Dec 2025 00:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765759310;
	bh=l6PLGSrfAr2bnC3zFhkGdV6nRMZEaikE9zMrnkeSBLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AzsV5G925o4R4rkqCHz6wpIwXSx+NjO4NVIvJ9wQa+mdo/A8XUmMRSwzHjHACzBMD
	 wmDKxBNgQM1n9W6AMJ+YINDrrMi+Y0FDA2PjbOLEj5n/CNU2iVkgtFTpR8Lv7vGnVp
	 gblZv4fXRZahKTShOos1UTWGRewE8yDtF6rr6yGP17RkcpjqpdylBZLxGNMNTRkAa3
	 BRQFuuSuof8KHmZjpc6r4eoayprBVDwk2veVTOV1WUkJw2L7YWLdrTSOP6nloULfNj
	 p1BrQwMTHuIFhbZQtCOFfF12snSUAUh0jyinV0xFFa9prW2tJgeiiCwKYYccAAr+XV
	 n+iYw89zRsHbg==
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
Subject: [PATCH AUTOSEL 6.18-6.1] smb/client: fix NT_STATUS_NO_DATA_DETECTED value
Date: Sun, 14 Dec 2025 19:41:19 -0500
Message-ID: <20251215004145.2760442-2-sashal@kernel.org>
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

[ Upstream commit a1237c203f1757480dc2f3b930608ee00072d3cc ]

This was reported by the KUnit tests in the later patches.

See MS-ERREF 2.3.1 STATUS_NO_DATA_DETECTED. Keep it consistent with the
value in the documentation.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of Commit: smb/client: fix NT_STATUS_NO_DATA_DETECTED value

### 1. COMMIT MESSAGE ANALYSIS
- Subject clearly states "fix" indicating a bug fix
- References MS-ERREF 2.3.1 (Microsoft's official NTSTATUS
  documentation) as the authoritative source
- Bug was discovered through KUnit tests
- Has Acked-by from Paulo Alcantara (Red Hat SMB maintainer) and Signed-
  off-by from Steve French (primary SMB/CIFS maintainer)

### 2. CODE CHANGE ANALYSIS

The change is a single-line fix in a header file:
```c
-#define NT_STATUS_NO_DATA_DETECTED 0x8000001c
+#define NT_STATUS_NO_DATA_DETECTED 0x80000022
```

**Critical bug identified**: The OLD value `0x8000001c` was
**duplicated** with another constant defined just a few lines above:
```c
#define NT_STATUS_MEDIA_CHANGED    0x8000001c
```

This is clearly a bug - two distinct Windows NT error status codes were
sharing the same numeric value. This would cause:
- Incorrect error code interpretation when servers return
  STATUS_NO_DATA_DETECTED (0x80000022)
- Potential confusion between STATUS_MEDIA_CHANGED and
  STATUS_NO_DATA_DETECTED

The new value `0x80000022` matches the official Microsoft MS-ERREF
specification for STATUS_NO_DATA_DETECTED.

### 3. CLASSIFICATION
- **Bug fix**: Yes - corrects a provably incorrect constant value
- **Feature addition**: No
- **New API**: No
- **Specification compliance fix**: Aligns with official Microsoft
  documentation

### 4. SCOPE AND RISK ASSESSMENT
- **Size**: 1 line changed
- **Files**: 1 header file
- **Risk**: Extremely low - simply correcting a wrong numeric constant
- **Subsystem**: SMB client (commonly used for network file sharing)

This is about as low-risk as a fix can get - it's correcting a single
constant value to match official documentation. The previous value was
demonstrably wrong (duplicate of another constant).

### 5. USER IMPACT
SMB is widely used for file sharing across networks. Having correct
error status codes is important for proper error handling. While the
practical impact depends on how this constant is used, having correct
protocol constants is essential for interoperability.

### 6. STABILITY INDICATORS
- Acked by Red Hat's SMB maintainer
- Signed off by the primary CIFS/SMB maintainer (Steve French)
- KUnit tests caught this issue, indicating testing coverage

### 7. DEPENDENCY CHECK
- No dependencies on other commits
- Standalone fix to a header constant
- SMB client code exists in stable trees

### Summary

**Meets stable criteria:**
- ✅ Obviously correct (matches official MS-ERREF documentation)
- ✅ Fixes a real bug (duplicate constant value)
- ✅ Extremely small and contained (single line change)
- ✅ No new features or APIs
- ✅ Low risk (just correcting a constant value)

**Risk vs Benefit:**
- Risk: Minimal - changing a constant to its documented correct value
- Benefit: Correct SMB error handling, protocol compliance

This is a textbook example of a safe stable backport candidate: an
obviously wrong value is corrected to match official documentation, the
change is tiny, and there's no possibility of regression since the old
value was demonstrably incorrect (it was a duplicate of
NT_STATUS_MEDIA_CHANGED).

**YES**

 fs/smb/client/nterr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
index b3516c71cff77..09263c91d07a4 100644
--- a/fs/smb/client/nterr.h
+++ b/fs/smb/client/nterr.h
@@ -41,7 +41,7 @@ extern const struct nt_err_code_struct nt_errs[];
 #define NT_STATUS_MEDIA_CHANGED    0x8000001c
 #define NT_STATUS_END_OF_MEDIA     0x8000001e
 #define NT_STATUS_MEDIA_CHECK      0x80000020
-#define NT_STATUS_NO_DATA_DETECTED 0x8000001c
+#define NT_STATUS_NO_DATA_DETECTED 0x80000022
 #define NT_STATUS_STOPPED_ON_SYMLINK 0x8000002d
 #define NT_STATUS_DEVICE_REQUIRES_CLEANING 0x80000288
 #define NT_STATUS_DEVICE_DOOR_OPEN 0x80000289
-- 
2.51.0

