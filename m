Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03B2935F602;
	Wed, 23 Sep 2026 01:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790127597; cv=none; b=tckXD4vU/slAV3x3NynOsRYqh6C+Y9qC3Gwni4uKXQhtpUY1KZsKNdNEmNl6xL4yykMLNelYiPioLZeyag7ymJFijhZfPhoHoAvZ3yTtcSqGepXbgmibMeWOFcnQEXrzNm15KrV/67xp63i1BhZMNGnlXyI66iUVGAww9eo0iGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790127597; c=relaxed/simple;
	bh=5RiZ8qJrlS0ckRVS4ECM+GbeZe5686I1svgoPeBjTp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJqsIATkn57PKzkcsBx0tvmQHv3cIXdT9M3/a0WT4yIuG1PUvnuWIUUTjXI3YthRAmn0/ySXLeOY1EbUXlQgvec8GPwkBW/j43MtgZrHuWY8tx0lzbKFoUU45QEgSnJVgY83sMxBb7Ycd0zRDzhUzXzB1Z8FqOppzY9mbm18jpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ef8b5JXk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ef8b5JXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF7F1F000FF;
	Wed, 23 Sep 2026 01:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790127595;
	bh=x+8a0p0krsFJtmKfkARlnFZBg22hMExmumCWCYIWndU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ef8b5JXkTGUn0OaCuSwR+hqkWhRqD5X3Vb8QEd+ILK+q4PmIkkf62Vv3NYjvT7kVw
	 65YYP3qJe5ecYLbzy69P/1uiNahF8RErOQyr0gTUiQnIVO8XdB2vpMzxVtvfRGD1j+
	 kXPSH7dOpmzb9C414rQwWQTQyDEmFuUvRSNTvifrOHwD5gN3anUbztor86ype0HSIN
	 N9tZ/oXMoG80owk/ZOjwgQl7xhgWtxsAivXuBaZrj+pV/q8CdVaQtiSzh0IA52e5J8
	 kpeAIl+tguK8tjXsEfKsfrX96Ujoo++A6R7Xn5/PXnRPnmfCsCaoeoFvuI4ROmsWcq
	 2pNCdL0X5M6Bw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6.y 1/2] smb: client: use atomic_t for mnt_cifs_flags
Date: Tue, 22 Sep 2026 21:39:52 -0400
Message-ID: <20260923013953.878249-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026092250-moneywise-parameter-6a1d@gregkh>
References: <2026092250-moneywise-parameter-6a1d@gregkh>
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

Stable dependency adaptation for e1253a82bb4c0fed6706a5839fc8b6e01be1abe2:

Retain the cifs_sb_flags interface needed by the WSL parser, implemented
as a READ_ONCE macro over the existing unsigned mount flags. Drop the
client-wide atomic_t conversion, generic CIFS_SB helpers, and unrelated
symlink/refactoring hunks that depend on newer SMB client code. This
stable adaptation does not implement the upstream atomic write changes.
No functions are added.

Prepare the existing wsl_to_fattr implementation to match the target's
preimage: include the UID/GID defaults and forceuid/forcegid checks from
cd2b2b57921d4, file-type clearing from fa7a2cfcf1e61, and unaligned WSL
reads from e1aeaf79dea51. Use asm/unaligned.h as required by 6.6. Keep
the target's transactional fattr update for the target commit itself.

The target patch applies unchanged after this dependency adaptation.

[ sashal: Reduced backport -- upstream 4fc3a433c1394 touches 27 file(s), this
  backport carries 3. Not backported here:
  fs/smb/client/cached_dir.c
  fs/smb/client/cifsacl.c
  fs/smb/client/cifsfs.c
  fs/smb/client/cifs_fs_sb.h
  fs/smb/client/cifs_ioctl.h
  fs/smb/client/cifs_unicode.c
  fs/smb/client/cifs_unicode.h
  fs/smb/client/connect.c
  ... and 16 more
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: e1253a82bb4c ("smb: client: fix fattr leaking on wsl_to_fattr() failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsglob.h |  3 +++
 fs/smb/client/reparse.c  | 21 ++++++++++++++-------
 fs/smb/client/reparse.h  | 11 ++++++-----
 3 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index a4e0618c58efc..82d33e4739702 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1603,6 +1603,9 @@ CIFS_FILE_SB(struct file *file)
 	return CIFS_SB(file_inode(file)->i_sb);
 }
 
+/* Mount and reconnect paths may update these flags concurrently. */
+#define cifs_sb_flags(cifs_sb) READ_ONCE((cifs_sb)->mnt_cifs_flags)
+
 static inline char CIFS_DIR_SEP(const struct cifs_sb_info *cifs_sb)
 {
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 4d45c31336df1..872b3a520c9a4 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -678,10 +678,15 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 			 struct cifs_sb_info *cifs_sb,
 			 u32 tag, struct cifs_fattr *fattr)
 {
+	unsigned int sbflags = cifs_sb_flags(cifs_sb);
 	struct smb2_file_full_ea_info *ea;
 	bool have_xattr_dev = false;
 	u32 next = 0;
 
+	fattr->cf_uid = cifs_sb->ctx->linux_uid;
+	fattr->cf_gid = cifs_sb->ctx->linux_gid;
+
+	fattr->cf_mode &= ~S_IFMT;
 	switch (tag) {
 	case IO_REPARSE_TAG_LX_SYMLINK:
 		fattr->cf_mode |= S_IFLNK;
@@ -718,15 +723,17 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 		nlen = ea->ea_name_length;
 		v = (void *)((u8 *)ea->ea_data + ea->ea_name_length + 1);
 
-		if (!strncmp(name, SMB2_WSL_XATTR_UID, nlen))
-			fattr->cf_uid = wsl_make_kuid(cifs_sb, v);
-		else if (!strncmp(name, SMB2_WSL_XATTR_GID, nlen))
-			fattr->cf_gid = wsl_make_kgid(cifs_sb, v);
-		else if (!strncmp(name, SMB2_WSL_XATTR_MODE, nlen)) {
+		if (!strncmp(name, SMB2_WSL_XATTR_UID, nlen)) {
+			if (!(sbflags & CIFS_MOUNT_OVERR_UID))
+				fattr->cf_uid = wsl_make_kuid(cifs_sb, v);
+		} else if (!strncmp(name, SMB2_WSL_XATTR_GID, nlen)) {
+			if (!(sbflags & CIFS_MOUNT_OVERR_GID))
+				fattr->cf_gid = wsl_make_kgid(cifs_sb, v);
+		} else if (!strncmp(name, SMB2_WSL_XATTR_MODE, nlen)) {
 			/* File type in reparse point tag and in xattr mode must match. */
-			if (S_DT(fattr->cf_mode) != S_DT(le32_to_cpu(*(__le32 *)v)))
+			if (S_DT(fattr->cf_mode) != S_DT(get_unaligned_le32(v)))
 				return false;
-			fattr->cf_mode = (umode_t)le32_to_cpu(*(__le32 *)v);
+			fattr->cf_mode = (umode_t)get_unaligned_le32(v);
 		} else if (!strncmp(name, SMB2_WSL_XATTR_DEV, nlen)) {
 			fattr->cf_rdev = reparse_mkdev(v);
 			have_xattr_dev = true;
diff --git a/fs/smb/client/reparse.h b/fs/smb/client/reparse.h
index ff05b0e75c928..5b8b8addab89a 100644
--- a/fs/smb/client/reparse.h
+++ b/fs/smb/client/reparse.h
@@ -9,6 +9,7 @@
 #include <linux/fs.h>
 #include <linux/stat.h>
 #include <linux/uidgid.h>
+#include <asm/unaligned.h>
 #include "fs_context.h"
 #include "cifsglob.h"
 
@@ -22,7 +23,7 @@
 
 static inline dev_t reparse_mkdev(void *ptr)
 {
-	u64 v = le64_to_cpu(*(__le64 *)ptr);
+	u64 v = get_unaligned_le64(ptr);
 
 	return MKDEV(v & 0xffffffff, v >> 32);
 }
@@ -30,9 +31,9 @@ static inline dev_t reparse_mkdev(void *ptr)
 static inline kuid_t wsl_make_kuid(struct cifs_sb_info *cifs_sb,
 				   void *ptr)
 {
-	u32 uid = le32_to_cpu(*(__le32 *)ptr);
+	u32 uid = get_unaligned_le32(ptr);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_UID)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_UID)
 		return cifs_sb->ctx->linux_uid;
 	return make_kuid(current_user_ns(), uid);
 }
@@ -40,9 +41,9 @@ static inline kuid_t wsl_make_kuid(struct cifs_sb_info *cifs_sb,
 static inline kgid_t wsl_make_kgid(struct cifs_sb_info *cifs_sb,
 				   void *ptr)
 {
-	u32 gid = le32_to_cpu(*(__le32 *)ptr);
+	u32 gid = get_unaligned_le32(ptr);
 
-	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_OVERR_GID)
+	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_GID)
 		return cifs_sb->ctx->linux_gid;
 	return make_kgid(current_user_ns(), gid);
 }
-- 
2.53.0

