Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A23576EB4;
	Thu, 17 Sep 2026 14:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789653724; cv=none; b=cu9QUG84MIO/6hJ5sWPUAOofgrheDuu5iLg8BiSugnJlK2pEinJk6J8Sws2AHBvj6YS0bSTIX4U+6rzRBqVid9eb2U5sxTL15DCVm0wkNWZg59xli8aGnQYVawW3RUZTJCr0EgIqfcMtiVWA4Tj1wURwH+tsPlcvUWCLkP3YB9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789653724; c=relaxed/simple;
	bh=+Ezlt7bKQk8mmk1GcozCiOc90oHaO8e4W6LnUi1E1hE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FR5aGBzWy5ghvNxtAN/7tYwSApoGdwdFmMJ0oGGHxCV7H0S9YwtOEP8qSkUgqa602+9jQ5vaon4sHdzSMKFWmgZ0SfnSO5hAfRYCHf8gzF/QTBK+Zyr7tb0ERH/j0+Rlj94LQRqOL+b8KKENpiNZWplBIZQG5ngSO0ZqYHwrV10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VLTtcLT1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VLTtcLT1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644051F000FF;
	Thu, 17 Sep 2026 14:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789653723;
	bh=sHHUwxwtr89BIjp6ZvA/1aejJmpC+2OU2Acx9RyQhTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VLTtcLT1K8Uwy4xD5Pd66UOKjYWqluTWbKr8rar6118V6w16KqVyC3JLRoMbvbpTw
	 K561lq98MVemY9daPpGb6dR7u6m6wyrP1925ri2zi+0ZYwIxR0YoJ+qm62wXgnSGu6
	 YJbJPt9y65ttTgXGnieMAdAbGw/1tRnXHIHY6lfIqIFMlVXJE5A4pm2GDxYxEGC/JP
	 D6cjaZbCnE0CJBK0fLR6dFTtqRwp/0oesw819BTA9AVMKiRP4IQTIf38j4yer1HG7R
	 hRtPbwVPuYlAtnd0VmtivVqeYsA24evFt7ZA+f0cBXob8hXQtctvlsY1Yd2NX4DRS2
	 3cqlB3g8vx+8g==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6.y 2/3] smb: client: use atomic_t for mnt_cifs_flags
Date: Thu, 17 Sep 2026 10:01:57 -0400
Message-ID: <20260917140158.504356-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260917140158.504356-1-sashal@kernel.org>
References: <2026091653-repaying-rockslide-b109@gregkh>
 <20260917140158.504356-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 4fc3a433c13944ee5766ec5b9bf6f1eb4d29b880 ]

Use atomic_t for cifs_sb_info::mnt_cifs_flags as it's currently
accessed locklessly and may be changed concurrently in mount/remount
and reconnect paths.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>

[ Stable dependency adaptation for cd2b2b57921d:
  The 6.6 WSL parser already matches the target's preimage. Keep only the
  cifs_sb_flags interface needed by that fix and its WSL uid/gid callers.
  Implement the accessor as a READ_ONCE macro over the existing unsigned
  mount flags, without adding functions. Drop the atomic_t conversion,
  generic CIFS_SB accessors and unrelated client-wide refactoring, which
  depend on newer SMB code absent from this tree. This is preparation for
  the WSL ownership fix, not a backport of the full flag-writer race fix. ]

[ sashal: Reduced backport -- upstream 4fc3a433c1394 touches 27 file(s), this
  backport carries 2. Not backported here:
  fs/smb/client/cached_dir.c
  fs/smb/client/cifsacl.c
  fs/smb/client/cifsfs.c
  fs/smb/client/cifs_fs_sb.h
  fs/smb/client/cifs_ioctl.h
  fs/smb/client/cifs_unicode.c
  fs/smb/client/cifs_unicode.h
  fs/smb/client/connect.c
  ... and 17 more
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: cd2b2b57921d ("smb: client: fix WSL reparse point uid/gid override")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h | 3 +++
 fs/smb/client/reparse.h  | 4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index a4e0618c58efc..61ebd6d8eb41e 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1603,6 +1603,9 @@ CIFS_FILE_SB(struct file *file)
 	return CIFS_SB(file_inode(file)->i_sb);
 }
 
+/* Read mount flags once for paths that need a consistent snapshot. */
+#define cifs_sb_flags(cifs_sb) READ_ONCE((cifs_sb)->mnt_cifs_flags)
+
 static inline char CIFS_DIR_SEP(const struct cifs_sb_info *cifs_sb)
 {
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
diff --git a/fs/smb/client/reparse.h b/fs/smb/client/reparse.h
index ff05b0e75c928..c15e4541cca06 100644
--- a/fs/smb/client/reparse.h
+++ b/fs/smb/client/reparse.h
@@ -32,7 +32,7 @@ static inline kuid_t wsl_make_kuid(struct cifs_sb_info *cifs_sb,
 {
 	u32 uid = le32_to_cpu(*(__le32 *)ptr);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_UID)
 		return cifs_sb->ctx->linux_uid;
 	return make_kuid(current_user_ns(), uid);
 }
@@ -42,7 +42,7 @@ static inline kgid_t wsl_make_kgid(struct cifs_sb_info *cifs_sb,
 {
 	u32 gid = le32_to_cpu(*(__le32 *)ptr);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_GID)
 		return cifs_sb->ctx->linux_gid;
 	return make_kgid(current_user_ns(), gid);
 }
-- 
2.53.0

