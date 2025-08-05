Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FF5279DA2;
	Tue,  5 Aug 2025 13:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399507; cv=none; b=l29IBxubkBE6hdsc9o+YRnR2Vvwy1JweI5JE2K1PjV3DHGISLkpFZEDVf1rJUfio77GO3XdDKzCBwCFu+lBD7NVuqXLpxodNGRng2UrfcLWKWP/9s76yD8bituHkXUBNpr0B7vLqM/3o9zDsKYqGudD40ptBKcB31ZUNNIYAX6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399507; c=relaxed/simple;
	bh=YWcKw3gOwburG9G3j4ybYgSw/tWOESzdxS4VFIkaHzY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B1pdM1JMb4X/Leu2t15QPsbrUrmM7fyt5TNOUIU5w9k65K3vY3P7P9tHUhS2srJd+xLFc2UaCSM9CP/MHz+nXcIEaaxdReac5jHHcllOCzPaxRdTA60vyfXJgi7er81/+dT+pUfK3XHslpWaEn8Eu+DIT8Xr7CrcTNH3md1CbFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jffjNaSM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jffjNaSM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A11C4CEF0;
	Tue,  5 Aug 2025 13:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399507;
	bh=YWcKw3gOwburG9G3j4ybYgSw/tWOESzdxS4VFIkaHzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jffjNaSMlhw4IEoRuLy0tJHerJXR4/5FpQFVg3tDp8XWLCP8ZLyRjeYBUCI7ZlTVB
	 kOofK4atODwd3DQPjql0Tke2q68wKOa/dZTZvT0EvCGIJPGs92s1uh3SNlPd3cMusw
	 WwFPlbYFVpZxVkX3VRtVF3+ji74ZLCxoIL1ZGTD2LxxftQqgPZgDny8m3pk4+JyuFB
	 dj5ZjtN3OGfq7DTlOrbdMHkQx5qNGzJBDKriilalNUw8KD5m3VNFKfHWbhLl1oepSB
	 +7/hOk5F0M9jDIPUuCJj41BBJ9o6SVAoP6brPZ2GKg0S9LJjOSh0BcuHeHIlblos58
	 pE5+zYMUXcyNg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.16-5.4] cifs: Fix calling CIFSFindFirst() for root path without msearch
Date: Tue,  5 Aug 2025 09:09:29 -0400
Message-Id: <20250805130945.471732-54-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

[ Upstream commit b460249b9a1dab7a9f58483e5349d045ad6d585c ]

To query root path (without msearch wildcard) it is needed to
send pattern '\' instead of '' (empty string).

This allows to use CIFSFindFirst() to query information about root path
which is being used in followup changes.

This change fixes the stat() syscall called on the root path on the mount.
It is because stat() syscall uses the cifs_query_path_info() function and
it can fallback to the CIFSFindFirst() usage with msearch=false.

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis of the commit and the kernel code, here's my
assessment:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

## Bug Fix Analysis

1. **Fixes a real user-visible bug**: The commit explicitly states it
   "fixes the stat() syscall called on the root path on the mount". This
   is a fundamental filesystem operation that users and applications
   rely on. When `stat()` fails on the mount root, it can break many
   applications that query filesystem metadata.

2. **Small and contained change**: The fix is minimal - it only adds two
   small conditional blocks (lines 4023-4026 for Unicode and lines
   4035-4038 for non-Unicode) that handle the special case when
   `searchName` is empty (root path) and `msearch` is false.

3. **Clear bug mechanism**: The code shows that when querying the root
   path without wildcard search (`msearch=false`), the function was
   sending an empty string instead of the required `\` pattern. This is
   evident from the fallback path in `cifs_query_path_info()` at line
   586-588 which calls `CIFSFindFirst()` with `false` for the msearch
   parameter.

4. **Low regression risk**: The change only affects the specific case
   where:
   - `searchName` is empty (root path query)
   - `msearch` is false (no wildcard search)
   - This doesn't change any existing behavior for non-root paths

5. **Follows stable kernel rules**: This is a clear bug fix that:
   - Fixes a real bug that users can hit
   - Is not a theoretical race condition
   - Has minimal lines of code changed
   - Doesn't introduce new features
   - Is isolated to the CIFS/SMB subsystem

6. **Critical path functionality**: The `stat()` syscall is fundamental
   to filesystem operations. Many applications depend on being able to
   query metadata about the filesystem root. This failure could cause
   mount verification scripts, filesystem monitoring tools, and other
   utilities to fail.

## Technical Details

The fix handles both Unicode and non-Unicode cases by setting the
FileName field to contain the directory separator (`\`) when the search
path is empty, ensuring the SMB protocol receives the correct pattern
for querying the root directory. This aligns with SMB protocol
requirements where an empty path is not valid for directory queries but
`\` represents the root.

The commit message clearly identifies this as fixing existing
functionality rather than adding new features, making it an ideal
candidate for stable backporting according to the stable kernel rules.

 fs/smb/client/cifssmb.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 75142f49d65d..3b6bc53ee1c4 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -4020,6 +4020,12 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 			pSMB->FileName[name_len] = 0;
 			pSMB->FileName[name_len+1] = 0;
 			name_len += 2;
+		} else if (!searchName[0]) {
+			pSMB->FileName[0] = CIFS_DIR_SEP(cifs_sb);
+			pSMB->FileName[1] = 0;
+			pSMB->FileName[2] = 0;
+			pSMB->FileName[3] = 0;
+			name_len = 4;
 		}
 	} else {
 		name_len = copy_path_name(pSMB->FileName, searchName);
@@ -4031,6 +4037,10 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 			pSMB->FileName[name_len] = '*';
 			pSMB->FileName[name_len+1] = 0;
 			name_len += 2;
+		} else if (!searchName[0]) {
+			pSMB->FileName[0] = CIFS_DIR_SEP(cifs_sb);
+			pSMB->FileName[1] = 0;
+			name_len = 2;
 		}
 	}
 
-- 
2.39.5

