Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67923559F2
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jun 2026 12:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782046145; cv=none; b=dFncCCl+k7i4mqfuKH4l+m7OrTwiGo5LwNBrz6wxaFgZbJ0PJR7n/2lrzj14s0IhHj9lOA80Bmns1UhmjEc283btarZwiBfOXSkNx9HUnNKdW0nXdDEjfJAyYSK0o7TTBzhH8HRmjObRuLItpEdcx8D6rKQ73TyEbZuiWaO4BZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782046145; c=relaxed/simple;
	bh=/Drk12P15fW5hcdvnDdwQPt0VbXAemKwDCP4F8x02IY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uaE9KTjhXnCHk+D/eIve1kj4BLyiXxewIgGq9PDCCcKNL2ucc1NvSCtnWjNKzqztTSNJJn2kh033hvrp3qrqaj2hR6Q6OVRZMr1L5980oXAcccv+9PtHSmj8EkskXmLxSYtSqlOxm5WflKjxcC96MGuJF6VRrkGqn/zcxYW09k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I7qgsqDz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I7qgsqDz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868141F000E9;
	Sun, 21 Jun 2026 12:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782046144;
	bh=oU5aZZiYIAQtqx75EN5+YO9XtK8PZSAy3jsWlP3IApg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I7qgsqDz2OjK2fsSirMH7I/Crz60atPUHXuJkCrasKwNnIw2Fqwqz2gOJPPYHehIO
	 ujHcbjte4gQpIeeCVP3ZXF3ZO7QHU/IZSOsK2Qs/ikxga63Ld84N42uMY/PArZ8WYw
	 CuoFvsV32WRCqkpQ6I637ciqemgAgyI2u5uFYGg8yyGKlpH/WFosJ0EfBalYrA9y7E
	 Y0pGjlW1atsUJ9n2UUb5Rw/q0xe71uvUURPIBBWJz+FYtBCJMaUoyAPCib2QkmKzGR
	 sgCYDYXsd/RUpZ9PIkCwvdarSjFKrhdlULEF6FeQC5oROWKiMGImlOs3J57s61Hct7
	 wWpo0hsIOYeSQ==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 07/29] ksmbd: check parent directory sharing conflicts on rename
Date: Sun, 21 Jun 2026 21:48:22 +0900
Message-Id: <20260621124844.6235-7-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260621124844.6235-1-linkinjeon@kernel.org>
References: <20260621124844.6235-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When renaming a file, some existing opens on the parent directory must
block the rename with STATUS_SHARING_VIOLATION. This includes parent
directory handles opened with DELETE access and handles opened without
FILE_SHARE_DELETE.

ksmbd checked only the parent's desired access for FILE_DELETE.  That
handled smb2.rename.share_delete_and_delete_access, but missed the case
where the parent directory was opened without delete access and without
delete sharing, so smb2.rename.no_share_delete_no_delete_access incorrectly
succeeded.

Attribute-only parent opens, however, must not block the rename.
smb2.rename.msword opens the parent directory with only SYNCHRONIZE and
FILE_READ_ATTRIBUTES, no share access, and then renames an already-open
child file.  Windows allows this pattern.

Reject parent directory handles that request DELETE access, and reject
non-attribute-only parent opens that deny FILE_SHARE_DELETE, while allowing
attribute-only parent opens to coexist with child rename.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/vfs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 74b0307cb100..80fd27752b2c 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -702,8 +702,10 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
 
 	parent_fp = ksmbd_lookup_fd_inode(old_child->d_parent);
 	if (parent_fp) {
-		if (parent_fp->daccess & FILE_DELETE_LE) {
-			pr_err("parent dir is opened with delete access\n");
+		if ((parent_fp->daccess & FILE_DELETE_LE) ||
+		    (!parent_fp->attrib_only &&
+		     !(parent_fp->saccess & FILE_SHARE_DELETE_LE))) {
+			pr_err("parent dir blocks delete sharing\n");
 			err = -ESHARE;
 			ksmbd_fd_put(work, parent_fp);
 			goto out3;
-- 
2.25.1

