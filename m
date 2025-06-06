Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDB1289E21;
	Fri,  6 Jun 2025 15:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749224612; cv=none; b=t88Tub6Qipopbr5aVi3um6nFHWyAXeXlP+RdK+RcHCrh5HAP5cyyKvZh7yx6Ra7UIv0DU6twF4IbSqVOJTSDCZUrdq3OwwE06/LpDjiK3xMgdaGb4MJZsWP2JrSOaUCBJ7dyOb0TCUr8b6w5Cvzdp1r37GmdV+0YJEycOHJgVVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749224612; c=relaxed/simple;
	bh=cRWWTdGOHkpP+wzhFsjQg31FebVesIhUyec0aXID2Hk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kIL79nEJvGZExdWuosJ89Zox8D2EJzLdrWfTFyRul7IpJQuOiHBYogaRS1J3eRwTiORDIqQb9nee5i6Zyo0NqnOxUQ3oYIwKYGJQM7rOD6uMHuqmMnSKndXpM11cqaZAmcISNdunYt0BZ0YeDuT2J4NVMqFAtWh/P1ebtSWNAjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IC5umH/8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IC5umH/8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640BFC4CEED;
	Fri,  6 Jun 2025 15:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749224612;
	bh=cRWWTdGOHkpP+wzhFsjQg31FebVesIhUyec0aXID2Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IC5umH/8A7vCBEhWtOtUSJYeA6oEa56C1WowqZ7KM0hQAJWK/uzBRIDQ0H1/bybGm
	 yqrzAyJ14V+4nVKV+TF0kp2LknLl5KLWV3pnB1K3zs4/D2RlwolJAF4LkmtR52ShO4
	 jR7Ad2szmf86yFvaCTj95gKbWQk/2RpfZSiPXDceIZqxA0fGPmTD6tCjd4LBw0jdTr
	 bG+51lpQ/sIxG9Q7byE6QwS3Sgm0FswDOksgzL1AzlQ/SWPElX1bWwCG8WBpYuuAFJ
	 YAx8a+Rhsp1J0Hoe2jrtswzBC9DqnNdcuF+3Jg0s063WNXBLluKlJqF2IPgrOPxO14
	 U5U4MN3QZ5JqA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.6 03/13] cifs: Fix encoding of SMB1 Session Setup NTLMSSP Request in non-UNICODE mode
Date: Fri,  6 Jun 2025 11:43:16 -0400
Message-Id: <20250606154327.547792-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250606154327.547792-1-sashal@kernel.org>
References: <20250606154327.547792-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.93
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 6510ef4230b68c960309e0c1d6eb3e32eb785142 ]

SMB1 Session Setup NTLMSSP Request in non-UNICODE mode is similar to
UNICODE mode, just strings are encoded in ASCII and not in UTF-16.

With this change it is possible to setup SMB1 session with NTLM
authentication in non-UNICODE mode with Windows SMB server.

This change fixes mounting SMB1 servers with -o nounicode mount option
together with -o sec=ntlmssp mount option (which is the default sec=).

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my analysis of both the commit and the kernel source code, I
can now provide a comprehensive assessment: **YES** This commit should
be backported to stable kernel trees. Here's my extensive analysis: ##
Bug Fix Analysis This commit fixes a **functional bug** that prevents
SMB1 sessions from being established when using specific mount options.
The code changes address a critical logic error in the NTLMSSP session
setup for non-UNICODE mode. ### Problem Being Fixed The original code in
`_sess_auth_rawntlmssp_assemble_req()` contains this problematic check:
```c if ((pSMB->req.hdr.Flags2 & SMBFLG2_UNICODE) == 0) { cifs_dbg(VFS,
"NTLMSSP requires Unicode support\n"); return -ENOSYS; } ``` This check
**incorrectly rejects** all non-UNICODE sessions for NTLMSSP
authentication, making it impossible to mount SMB1 servers with: - `-o
nounicode` (non-UNICODE mode) - `-o sec=ntlmssp` (default security mode)
### Technical Solution The fix removes this incorrect validation and
implements proper dual-path handling: ```c if (pSMB->req.hdr.Flags2 &
SMBFLG2_UNICODE) { /bin /bin.usr-is-merged /boot /dev /etc /home /init
/lib /lib.usr-is-merged /lib64 /lost+found /media /mnt /opt /proc /root
/run /sbin /sbin.usr-is-merged /snap /srv /sys /tmp /usr /var unicode
strings must be word aligned */ if
(!IS_ALIGNED(sess_data->iov[0].iov_len + sess_data->iov[1].iov_len, 2))
{ *bcc_ptr = 0; bcc_ptr++; } unicode_oslm_strings(&bcc_ptr,
sess_data->nls_cp); } else { ascii_oslm_strings(&bcc_ptr,
sess_data->nls_cp); } ``` This correctly handles both UNICODE and non-
UNICODE modes by: 1. **UNICODE path**: Uses UTF-16 encoding with proper
alignment 2. **Non-UNICODE path**: Uses ASCII encoding without alignment
requirements ### Why This Qualifies for Backporting 1. **User-Affecting
Bug**: The bug prevents legitimate SMB1 connections with common mount
options, causing mount failures that users would expect to work. 2.
**Small, Contained Fix**: The change is minimal (removes 4 lines, adds 8
lines) and confined to a single function. Risk of regression is very
low. 3. **No Architectural Changes**: This fix doesn't modify the
NTLMSSP protocol implementation or introduce new features—it simply
corrects existing logic. 4. **Similar Pattern to Accepted Backports**:
This closely matches "Similar Commit #1" which was marked "YES" for
backporting. Both commits: - Fix SMB1 Session Setup encoding issues -
Handle UNICODE vs non-UNICODE mode correctly - Extract common code
patterns for consistency - Are small, targeted bugfixes 5. **Legacy
Protocol Support**: While SMB1 is deprecated, it's still supported in
the kernel under `CONFIG_CIFS_ALLOW_INSECURE_LEGACY`, and users who
explicitly enable it deserve working functionality. ### Code Correctness
Verification The fix is technically sound because: -
**`ascii_oslm_strings()`** and **`unicode_oslm_strings()`** are
established functions already used elsewhere in the codebase for
Kerberos authentication (`sess_auth_kerberos()`) - The same dual-path
pattern exists in other session setup functions - The NTLMSSP protocol
itself still uses UNICODE internally (for username/domain encoding), but
the session setup strings can be ASCII - The alignment logic is
correctly applied only to UNICODE mode where it's needed ### Risk
Assessment **Very Low Risk**: - Fix is isolated to SMB1 NTLMSSP session
setup - Only affects the non-UNICODE code path that was previously
broken - No changes to the core NTLMSSP authentication logic - Pattern
matches existing working code in the same file This is a clear bugfix
that restores intended functionality without introducing new features or
architectural changes, making it an ideal candidate for stable tree
backporting.

 fs/smb/client/sess.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index a7ece67ee9630..1d3a1a3ba90b0 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -1737,22 +1737,22 @@ _sess_auth_rawntlmssp_assemble_req(struct sess_data *sess_data)
 	pSMB = (SESSION_SETUP_ANDX *)sess_data->iov[0].iov_base;
 
 	capabilities = cifs_ssetup_hdr(ses, server, pSMB);
-	if ((pSMB->req.hdr.Flags2 & SMBFLG2_UNICODE) == 0) {
-		cifs_dbg(VFS, "NTLMSSP requires Unicode support\n");
-		return -ENOSYS;
-	}
-
 	pSMB->req.hdr.Flags2 |= SMBFLG2_EXT_SEC;
 	capabilities |= CAP_EXTENDED_SECURITY;
 	pSMB->req.Capabilities |= cpu_to_le32(capabilities);
 
 	bcc_ptr = sess_data->iov[2].iov_base;
-	/* unicode strings must be word aligned */
-	if (!IS_ALIGNED(sess_data->iov[0].iov_len + sess_data->iov[1].iov_len, 2)) {
-		*bcc_ptr = 0;
-		bcc_ptr++;
+
+	if (pSMB->req.hdr.Flags2 & SMBFLG2_UNICODE) {
+		/* unicode strings must be word aligned */
+		if (!IS_ALIGNED(sess_data->iov[0].iov_len + sess_data->iov[1].iov_len, 2)) {
+			*bcc_ptr = 0;
+			bcc_ptr++;
+		}
+		unicode_oslm_strings(&bcc_ptr, sess_data->nls_cp);
+	} else {
+		ascii_oslm_strings(&bcc_ptr, sess_data->nls_cp);
 	}
-	unicode_oslm_strings(&bcc_ptr, sess_data->nls_cp);
 
 	sess_data->iov[2].iov_len = (long) bcc_ptr -
 					(long) sess_data->iov[2].iov_base;
-- 
2.39.5

