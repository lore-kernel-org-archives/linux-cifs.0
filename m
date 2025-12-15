Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4ED42FD68C;
	Mon, 15 Dec 2025 00:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765759324; cv=none; b=GO9ZIv55LAATVXDkwcAwtulZm0JTeoiHg2wD0WBXD6+cSIhgeE15o6+F+keixj4WOGKWnxrQnOj6BMcjE6x/ETSl47Utq75bGP0eWhxCVOdQojXaoaLxTwv4KWofDCaEluNq4sOFUBbHJ4Eupw8BBzfHTRJ1X9vjLyrIVeAlqac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765759324; c=relaxed/simple;
	bh=Exx19kNqscoPiqkjyL+qj80xYlvnVO4kglWg+jprW5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kwJ/qPkLFQkGDQ2k5L5pNrVSoU8WBJS3EfD3RGwNbPL/8jk/JCX0ch+q6TunDbvBVSsNOHUl7IWx5znNISeTwodYsIQiOq/thY73UAPcKSbLstsV6UIAIUAVbwdARUNw/1x5r0q/yZvm+SqdMLJewz4t17UD/UgjRoayb0jTsyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=elgCEVsM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="elgCEVsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D339C4CEFB;
	Mon, 15 Dec 2025 00:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765759324;
	bh=Exx19kNqscoPiqkjyL+qj80xYlvnVO4kglWg+jprW5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=elgCEVsMX0nph+AR8rGMojDuRyvZpkaBcCaNNyCDA/5PsPxuevl5Y5GhPyRDFh/lT
	 JyvZUWEa6apRq9fVNS1XihRB9+QZLQMh0HgI2UMW6PnCSf7E+iSl4f2oPtgusJE77w
	 LhafBVUge7SVq0Q2WTd+79p6dADTPTOFnBH7dNgyVJQQPriR58iuN7+isTdUVq2dJQ
	 ufxvJ7z50wdsGz/RvaGa7urlkIn5DmmHYBC+5HMN3VXRPoeQObea2lvD7j7VSQ8tpu
	 /s67y9pmCTt2v88R/WGsLiR2FlBZymSy5F6YSkH6CxshVTAeZvRTYqjda1ev6GD1Pc
	 /hKmI7hZNfUjA==
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
Subject: [PATCH AUTOSEL 6.18-6.1] smb/client: fix NT_STATUS_DEVICE_DOOR_OPEN value
Date: Sun, 14 Dec 2025 19:41:25 -0500
Message-ID: <20251215004145.2760442-8-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

[ Upstream commit b2b50fca34da5ec231008edba798ddf92986bd7f ]

This was reported by the KUnit tests in the later patches.

See MS-ERREF 2.3.1 STATUS_DEVICE_DOOR_OPEN. Keep it consistent with the
value in the documentation.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Commit Analysis: smb/client: fix NT_STATUS_DEVICE_DOOR_OPEN value

### 1. COMMIT MESSAGE ANALYSIS

The commit message clearly indicates this is fixing an incorrect
constant value:
- A KUnit test caught the bug
- References Microsoft documentation (MS-ERREF 2.3.1
  STATUS_DEVICE_DOOR_OPEN)
- Goal is to align with official Microsoft specification

### 2. CODE CHANGE ANALYSIS

The change is a single-line fix in `fs/smb/client/nterr.h`:

```c
-#define NT_STATUS_DEVICE_DOOR_OPEN 0x80000288
+#define NT_STATUS_DEVICE_DOOR_OPEN 0x80000289
```

**The Bug:** Looking at the context, I can see the critical issue:
- `NT_STATUS_DEVICE_REQUIRES_CLEANING` = `0x80000288`
- `NT_STATUS_DEVICE_DOOR_OPEN` = `0x80000288` (WRONG - duplicate value!)

Both status codes had the same value, which is clearly incorrect. These
are NT status codes that should be unique. According to Microsoft's MS-
ERREF specification, the correct values should be:
- `NT_STATUS_DEVICE_REQUIRES_CLEANING` = `0x80000288`
- `NT_STATUS_DEVICE_DOOR_OPEN` = `0x80000289`

This is a classic copy-paste error or transcription mistake when the
values were originally added.

### 3. CLASSIFICATION

- **Bug fix**: Yes - correcting a wrong constant value
- **Feature addition**: No
- **Exception category**: N/A - this is a straightforward data
  correction

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed**: 1
- **Files touched**: 1 (header file with constant definitions)
- **Complexity**: Trivial
- **Risk of regression**: Virtually zero - only changes which error code
  is mapped to which value

The fix is as minimal and surgical as possible. Changing a constant from
an incorrect value to the correct documented value cannot introduce new
bugs.

### 5. USER IMPACT

These status codes relate to device media handling (tape drives,
removable media):
- `NT_STATUS_DEVICE_REQUIRES_CLEANING` - device needs cleaning
- `NT_STATUS_DEVICE_DOOR_OPEN` - device door is open

Without this fix, SMB clients receiving `NT_STATUS_DEVICE_DOOR_OPEN`
from a server would incorrectly interpret it as
`NT_STATUS_DEVICE_REQUIRES_CLEANING`. While these are relatively obscure
errors, correct protocol implementation matters for:
- Proper error reporting to users
- Automated error handling systems
- Protocol compliance

### 6. STABILITY INDICATORS

- **Acked-by**: Paulo Alcantara (Red Hat) - well-known SMB subsystem
  reviewer
- **Signed-off-by**: Steve French - SMB/CIFS maintainer
- **Testing**: Found by KUnit tests, indicating solid test coverage

### 7. DEPENDENCY CHECK

- No dependencies on other commits
- The header file exists in all stable trees with SMB client support
- Will apply cleanly

### CONCLUSION

This is an ideal stable backport candidate:

1. **Obviously correct**: Just fixing a wrong constant to match official
   documentation
2. **Fixes a real bug**: Duplicate/incorrect NT status code values
3. **Small and contained**: Single line change to a constant definition
4. **No new features**: Pure correction
5. **Zero regression risk**: The worst case is unchanged behavior for
   code that was incorrectly handling the duplicate value
6. **Properly reviewed**: Acked by maintainer

The fix ensures correct SMB protocol behavior by aligning NT status
codes with Microsoft's official specification. It's a textbook example
of what belongs in stable trees.

**YES**

 fs/smb/client/nterr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/nterr.h b/fs/smb/client/nterr.h
index e3a607b45e719..b3516c71cff77 100644
--- a/fs/smb/client/nterr.h
+++ b/fs/smb/client/nterr.h
@@ -44,7 +44,7 @@ extern const struct nt_err_code_struct nt_errs[];
 #define NT_STATUS_NO_DATA_DETECTED 0x8000001c
 #define NT_STATUS_STOPPED_ON_SYMLINK 0x8000002d
 #define NT_STATUS_DEVICE_REQUIRES_CLEANING 0x80000288
-#define NT_STATUS_DEVICE_DOOR_OPEN 0x80000288
+#define NT_STATUS_DEVICE_DOOR_OPEN 0x80000289
 #define NT_STATUS_UNSUCCESSFUL 0xC0000000 | 0x0001
 #define NT_STATUS_NOT_IMPLEMENTED 0xC0000000 | 0x0002
 #define NT_STATUS_INVALID_INFO_CLASS 0xC0000000 | 0x0003
-- 
2.51.0

