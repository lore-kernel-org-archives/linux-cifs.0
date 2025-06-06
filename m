Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F375128A1E4;
	Fri,  6 Jun 2025 15:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749224583; cv=none; b=VknRxDkVZOtZ7Y0LHOVRHmGz4JWBbS3ee3FQyhxOgRgRFt/PW9Ck45xmoDCMjSin04CRYn9hp2rWrSKr9e8UkX8mxKd/TURZQIgRjDhGc12A7o4b1WVIIr6HgsjqgiZTEOmlLYH64Zyxlj6xyHJtsjoWKF10PO3y/lP0DMtuhQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749224583; c=relaxed/simple;
	bh=niVbLKAGaZf6sr7Al3qfXozwKWv+DrbKImKD8tVTi/A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IjyU8XHCeSuPGm+g8EbswCQv1eJl4PRF/JvHXVmWdXToAL1EYrdTaVJYVpVSmvlAAxzvC93+W5CU+duwenDxqdvr2LBBgc+52UTwOmwqv0Pgz+Xhia8mK3vpJ16Xj9esASr7biaeGXW9SpOaDwv0H4nbADyJmScBWCFaR4cpIK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=giSDnBLv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="giSDnBLv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1CAC4CEEB;
	Fri,  6 Jun 2025 15:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749224582;
	bh=niVbLKAGaZf6sr7Al3qfXozwKWv+DrbKImKD8tVTi/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=giSDnBLvjFcUgKTJC06QdUwr7kwMtj6iTr/z0NPx6FoeKlwcODjmV9AAevz7MEzwj
	 cW9/Xs2eyeX7XRRx0QSOrSRyaToN/KhsmpmYCJWO80p18s0QMvuWGIuGFPW+7CRxqv
	 YcEnvn1YVuwAO5TKmxkZWJADosLK+8cjmgaob8IaLTiwJRpYwxnkKJaPrBcQj9DQ9S
	 uK5/3JbfJgeH9PhNGFValGu6gcoykl8OPUaE73p9i/2YoHGruyxfaGvvKrqGfeIpbU
	 0QqHo4+OGmKwd+O3uL0HfhPUPEkP+FJPTjTk4I7HFJGiZHf9w46J1Ex93+V1Kvedyn
	 JOHLsdrWyl0ew==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.12 02/15] cifs: Fix cifs_query_path_info() for Windows NT servers
Date: Fri,  6 Jun 2025 11:42:45 -0400
Message-Id: <20250606154259.547394-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250606154259.547394-1-sashal@kernel.org>
References: <20250606154259.547394-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.32
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
index 4373dd64b66d4..5122f3895dfc2 100644
--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -323,6 +323,14 @@ check_smb_hdr(struct smb_hdr *smb)
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

