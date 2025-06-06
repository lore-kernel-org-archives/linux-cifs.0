Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C2BDEEB5;
	Fri,  6 Jun 2025 15:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749224550; cv=none; b=ceu8lHq18Dx21fmY7+yBtECVSYk78rE4srr2o69Mgz5hoxwMZ2eXMro9ethKYKDI5iqErC0TETrDjUoQ4KAS4S9WHGrBXO59GjemFyhRwH6maISEMBhK2uHWHR0ephiSjTbUw4q4QFSrXjPxJMJsFLJUcuHYQ3mJtyRzBWwPVv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749224550; c=relaxed/simple;
	bh=/daKLeljhQCLwFbUpg+T3BXnm4eP/oSDyNjs1VvwAKQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T61g/Xu6IAXvV7wnYABxXTKWTz7gDV2E2ZH9aYlOI46lrqJ/D96bMv4pwwSj9mDlqoM5L2CDAdiV1RBEchacEdL2/XlZ5ZqEeoBrVW9EHejuG+PlJ0S5+l72hHsnXcsz0v4fD0Bf9cpvnxBJrqIT5Fd/CrnfH8eFLU2B2l4vDL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qxrQ4EWb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qxrQ4EWb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9077CC4CEED;
	Fri,  6 Jun 2025 15:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749224549;
	bh=/daKLeljhQCLwFbUpg+T3BXnm4eP/oSDyNjs1VvwAKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qxrQ4EWb4uH3gsJL5SL9Ca9VqhQCr6LJGMHOhubUjQnuBQUuFeaA50fqWkUPElF54
	 s2/t9sKV0bwGrw+67JgvhbMrWuHpK6z89ZZhIfGJOmomZ8fsGWsYpeXmRwj1qE18oi
	 2ktF4l7XiJH9oJ2yEaQAQq8TCCrNlV809PyRfUN2PbRImr2A/0Uisndv+AX7snxvdr
	 Wb9afnea4f2wuLhiPuxyneIfDWUQM3AACpW7rrdoa8Ta8gv29t02SDIvtb3dCNNx8k
	 WiDep42/PQrJXrK8DzWuU4vlfaPkE4LzM5RepojJJJj3bWQbQvifhzgNw5UzGWIjgJ
	 p0L3xZkg7QoRA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.14 02/19] cifs: Fix cifs_query_path_info() for Windows NT servers
Date: Fri,  6 Jun 2025 11:42:08 -0400
Message-Id: <20250606154225.546969-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250606154225.546969-1-sashal@kernel.org>
References: <20250606154225.546969-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.10
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

[ Upstream commit a3e771afbb3bce91c8296828304903e7348003fe ]

For TRANS2 QUERY_PATH_INFO request when the path does not exist, the
Windows NT SMB server returns error response STATUS_OBJECT_NAME_NOT_FOUND
or ERRDOS/ERRbadfile without the SMBFLG_RESPONSE flag set. Similarly it
returns STATUS_DELETE_PENDING when the file is being deleted. And looks
like that any error response from TRANS2 QUERY_PATH_INFO does not have
SMBFLG_RESPONSE flag set.

So relax check in check_smb_hdr() for detecting if the packet is response
for this special case.

This change fixes stat() operation against Windows NT SMB servers and also
all operations which depends on -ENOENT result from stat like creat() or
mkdir().

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. Here's
my extensive analysis: ## Backport Recommendation: YES ### Nature of the
Fix This is a **targeted bug fix** that addresses a specific protocol
compliance issue with Windows NT SMB servers. The commit fixes a
fundamental problem where basic file operations (`stat()`, `creat()`,
`mkdir()`) fail against Windows NT servers due to overly strict SMB
header validation. ### Code Change Analysis The fix is remarkably
**simple and contained** - only 8 lines of code in a single function:
```c /bin /bin.usr-is-merged /boot /dev /etc /home /init /lib /lib.usr-
is-merged /lib64 /lost+found /media /mnt /opt /proc /root /run /sbin
/sbin.usr-is-merged /snap /srv /sys /tmp /usr /var * Windows NT server
returns error resposne (e.g. STATUS_DELETE_PENDING * or
STATUS_OBJECT_NAME_NOT_FOUND or ERRDOS/ERRbadfile or any other) * for
some TRANS2 requests without the RESPONSE flag set in header. */ if
(smb->Command == SMB_COM_TRANSACTION2 && smb->Status.CifsError != 0)
return 0; ``` The change is in the `check_smb_hdr()` function in
`fs/smb/client/misc.c`, which validates SMB packet headers. The fix
**relaxes validation** only for a very specific case: TRANS2 commands
returning errors from Windows NT servers. ### Risk Assessment: LOW 1.
**Surgical precision**: Only affects SMB1 TRANS2 error responses,
leaving normal operation paths untouched 2. **Conservative approach**:
The condition `smb->Status.CifsError != 0` ensures this only applies to
actual error responses 3. **No behavioral changes** for compliant
servers that properly set the RESPONSE flag 4. **Well-established code
path**: The `check_smb_hdr()` function is mature and stable ### Impact
Assessment: HIGH 1. **Fixes broken functionality**: Without this fix,
basic file operations fail completely against Windows NT servers 2.
**Backward compatibility**: Restores support for legacy but still-used
server environments 3. **User-visible improvement**: Directly fixes
`stat()`, `creat()`, and `mkdir()` operations 4. **No regressions**:
Modern SMB servers continue to work as before ### Comparison with
Similar Commits Looking at the provided similar commits: - **Similar
Commit #2** (Status: YES): Also adds new status code mappings for better
server compatibility - **Similar Commit #3** (Status: YES): Reduces
unnecessary network roundtrips by improving error handling - **Similar
Commit #4** (Status: YES): Fixes WSL reparse point querying over SMB1 -
**Similar Commit #5** (Status: YES): Fixes missing resource cleanup This
commit follows the **same pattern** as these approved backports: small,
targeted fixes that improve compatibility and fix real-world issues
without introducing new features or architectural changes. ### Technical
Justification The Windows NT server behavior described in the commit is
**non-compliant but real**: these servers return error responses for
TRANS2 QUERY_PATH_INFO requests without setting the `SMBFLG_RESPONSE`
flag. The current strict validation incorrectly treats these as invalid
packets, causing the CIFS client to fail when it should handle the
errors properly. The fix is **protocol-aware** and **conservative** - it
only relaxes validation for the specific case where we know Windows NT
behaves differently, ensuring no impact on standard-compliant servers.
### Stable Tree Suitability This commit perfectly fits stable tree
criteria: - ✅ **Important bug fix** affecting real-world usage - ✅
**Minimal and contained** change with clear scope - ✅ **No new
features** - purely fixes existing broken functionality - ✅ **Low
regression risk** due to targeted nature - ✅ **Production-ready** code
following established patterns This should be backported to all stable
kernels that support SMB1 client functionality, as it fixes a
fundamental compatibility issue without any meaningful risk of
regression.

 fs/smb/client/misc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/smb/client/misc.c b/fs/smb/client/misc.c
index b328dc5c7988d..2d8ea4d6488ae 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -324,6 +324,14 @@ check_smb_hdr(struct smb_hdr *smb)
 	if (smb->Command == SMB_COM_LOCKING_ANDX)
 		return 0;
 
+	/*
+	 * Windows NT server returns error resposne (e.g. STATUS_DELETE_PENDING
+	 * or STATUS_OBJECT_NAME_NOT_FOUND or ERRDOS/ERRbadfile or any other)
+	 * for some TRANS2 requests without the RESPONSE flag set in header.
+	 */
+	if (smb->Command == SMB_COM_TRANSACTION2 && smb->Status.CifsError != 0)
+		return 0;
+
 	cifs_dbg(VFS, "Server sent request, not response. mid=%u\n",
 		 get_mid(smb));
 	return 1;
-- 
2.39.5

