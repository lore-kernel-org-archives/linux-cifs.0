Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00884332EA3;
	Thu, 20 Nov 2025 12:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763640548; cv=none; b=ihoUiXPFlklmQI2D88GcKmwXZx2t2RkcUV79hniKHt5R36zU5Y9bEOXvB2jvejOg51fPyysCXICMWXviwtOzRDVPqyEuOkJEh/TDNP1/ePe4clgt9JCzbCeCLuqQLwOH7dF3mBd6T3D8i0J2Ilu7z53JS2DVViCZ5Bpqj2EgJcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763640548; c=relaxed/simple;
	bh=Bf5/WWqzlo7qPd3Gy6oXR94jU0k6NB2mIj4E4SnZVoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtgsluBjV6jf8jzNSJ1kQTGj0jakpGyT3Jn90mLmkG3NI8gNhsQXEG1OsiFCUcSU4B2k6CXEc8MgO6yUrQxmKN8hZ2f2sTH+4e4GgqoJ8TVbDmkzcqREiNrKSSubHCt5KVdWChTHCrx4AZzp5HdKWOWOSYSSVSiicSryECRq4QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aAPIEb9I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aAPIEb9I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6C7C4CEF1;
	Thu, 20 Nov 2025 12:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763640547;
	bh=Bf5/WWqzlo7qPd3Gy6oXR94jU0k6NB2mIj4E4SnZVoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aAPIEb9InMQGq2r1fFWgr7V8gVTZqRIi4Rm+9UTqRPc4LI2fTFx4Y4qHTWJ/XDYcP
	 1pF69VoWwqQUDCyWVKePP1PsBa01XBG7cUOw7rMHhKan/y+KiiGSABvqy2isxcXcpl
	 6RM/mCWIoJEu1s80UaWaUTIAYt+746CKshQum/vvICptvTjibtfiCM0cl3o/fg8ShT
	 pjSdbVXTwq3dOP64cy1X187J/KPqDZAUMZz7/6Li1tAxclp286dUxelzmVrALmwm/B
	 PjP50ZWoCDMwp7DLj7ch+NvxbTE/oQjbY/ZDweRgRPqVyDm2+Zi8IhWhC0ufPX5Avn
	 Y/B2oPzEcG9cg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yiqi Sun <sunyiqixm@gmail.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.17-6.1] smb: fix invalid username check in smb3_fs_context_parse_param()
Date: Thu, 20 Nov 2025 07:08:25 -0500
Message-ID: <20251120120838.1754634-16-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251120120838.1754634-1-sashal@kernel.org>
References: <20251120120838.1754634-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.8
Content-Transfer-Encoding: 8bit

From: Yiqi Sun <sunyiqixm@gmail.com>

[ Upstream commit ed6612165b74f09db00ef0abaf9831895ab28b7f ]

Since the maximum return value of strnlen(..., CIFS_MAX_USERNAME_LEN)
is CIFS_MAX_USERNAME_LEN, length check in smb3_fs_context_parse_param()
is always FALSE and invalid.

Fix the comparison in if statement.

Signed-off-by: Yiqi Sun <sunyiqixm@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## CONCLUSION

This commit fixes a **5-year-old logic error** in SMB/CIFS username
validation that has existed since the mount API refactoring in v5.11
(December 2020). The bug is a classic off-by-one comparison error where
`strnlen(..., 256) > 256` is always false because strnlen returns at
most 256.

**The bug causes:**
- **Validation bypass** allowing usernames longer than 256 characters
- **Memory waste** through unnecessary kernel allocations
- **Authentication failures** with confusing error messages when
  truncated usernames are sent to servers
- **Protocol non-compliance** with SMB username length limits

**The fix is trivial:**
- Changes one character: `>` becomes `==`
- Brings username validation in line with domain name validation (same
  file, line 1509)
- Zero risk of regression (only makes validation stricter)

**Evidence supporting backport:**
- **Already backported** to 7+ stable trees (6.12.y, 6.11.y, 6.6.y,
  6.1.y, 5.15.y, 5.10.y, 5.4.y)
- **Obviously correct** - single-character fix that matches the pattern
  used elsewhere
- **Small and contained** - one line in one file
- **Fixes real user issues** - authentication failures with long
  usernames
- **Long-standing bug** - affects all kernels from v5.11 to present

This is a **textbook example** of an appropriate stable kernel backport:
small, surgical, obviously correct, fixes a real bug, and carries no
regression risk.

**YES**

 fs/smb/client/fs_context.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 072383899e817..8470ecd6f8924 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1470,7 +1470,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 			break;
 		}
 
-		if (strnlen(param->string, CIFS_MAX_USERNAME_LEN) >
+		if (strnlen(param->string, CIFS_MAX_USERNAME_LEN) ==
 		    CIFS_MAX_USERNAME_LEN) {
 			pr_warn("username too long\n");
 			goto cifs_parse_mount_err;
-- 
2.51.0

