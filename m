Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB19C26B771;
	Sun, 31 Aug 2025 12:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643798; cv=none; b=W/WBxiM+MUNn5fC0m+KnSj5ivjn5VRwLoU8dqqe9TDkeiyUtfh41s4uDx2Nv6lgaZetznqKlujYHMfpk+3rJilZ8869SZ3A0RdOb7ebM1VG+zTmLTDfyCVmadKOjDwTOuPqCBYplN9dL+9GJV1R5ErP6NzaK4v2qGGD7v1gP9Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643798; c=relaxed/simple;
	bh=Evg3ZKUpfOo+CCek78zw3g7JYbEmPfCRAo9GGRXMLTw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nx1JOYhXWfmUHv7heziQx9I+LLUjuVkBoprnU7u4gNHLRt+t1aLvuOMyWSbaMD4Zxv0oHYpPLkk/sOuEx+PveUOdcAKCbK/0tiHg0k33/GTLkBKFfyTB393HsDpJP8/oEA0mFc/bRAJP6l3jII2scePSi3SpEo+05beE9ALVoTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MYb5lgmR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MYb5lgmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0D2C4CEF9;
	Sun, 31 Aug 2025 12:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643798;
	bh=Evg3ZKUpfOo+CCek78zw3g7JYbEmPfCRAo9GGRXMLTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MYb5lgmRvtWY30A8xQ33KjLRglLvOpPYDMTaw3jUz1gUtjDqbgHsNYyuO4PmoqMTp
	 f8v4agv2MOU4cBodeybsBF7oHJE0Zt06P9cagsNA58dAxBoO+xS3WacTbvUpjaSQxH
	 5uiL4NYTNJX/ZjEQ7juPAt+lNLozEfmtunWTtjwuiS/Hm1kWScpTxHhnl2IDBgZkxW
	 w1zFHsOD2YTAJyXohsmfMfofVXBXZjrJ/xrCwaDlBUcbfzArynKvMFRoZXJnIOlbVR
	 RUVPq9iq10NOVoM8a7DiySuLdc47SQM+qkYYaVk+zkRdV8lW1x/XgjJNthqt3sIsgD
	 DrtZDaXigdC2Q==
Received: by pali.im (Postfix)
	id 51A591308; Sun, 31 Aug 2025 14:36:37 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 32/35] cifs: Use cifs_rename_pending_delete() fallback also for rmdir()
Date: Sun, 31 Aug 2025 14:35:59 +0200
Message-Id: <20250831123602.14037-33-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250831123602.14037-1-pali@kernel.org>
References: <20250831123602.14037-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When ->rmdir() callback fails on the -EBUSY error then use the silly rename
functionality fallback. Removing of directories has exactly same problem
with DELETE_PENDING state as removal of the files.

Empty directory which is opened on Windows server will stay in
DELETE_PENDING state until the last user on server does not close it.
Directory itself is not immediately unlinked at remove call, like file.

Note that currently the ->rmdir() callbacks do not return -EBUSY error.
This will be implemented in follow up changes.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/inode.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 545964cac9cd..abe3108e4963 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1700,6 +1700,7 @@ static int
 cifs_rename_pending_delete(const unsigned int xid,
 			   struct cifs_tcon *tcon,
 			   const char *full_path,
+			   bool is_dir,
 			   struct dentry *dentry)
 {
 	int oplock = 0;
@@ -1811,7 +1812,8 @@ cifs_rename_pending_delete(const unsigned int xid,
 		.tcon = tcon,
 		.cifs_sb = cifs_sb,
 		.desired_access = DELETE,
-		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR),
+		.create_options = cifs_create_options(cifs_sb,
+					is_dir ? CREATE_NOT_FILE : CREATE_NOT_DIR),
 		.disposition = FILE_OPEN,
 		.path = full_path,
 		.fid = &fid,
@@ -1962,7 +1964,7 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
 	} else if (rc == -ENOENT) {
 		d_drop(dentry);
 	} else if (rc == -EBUSY) {
-		rc = cifs_rename_pending_delete(xid, tcon, full_path, dentry);
+		rc = cifs_rename_pending_delete(xid, tcon, full_path, false /* is_dir */, dentry);
 		if (rc == 0) {
 			cifs_mark_open_handles_for_deleted_file(inode, full_path);
 			cifs_drop_nlink(inode);
@@ -2298,6 +2300,9 @@ int cifs_rmdir(struct inode *inode, struct dentry *direntry)
 	}
 
 	rc = server->ops->rmdir(xid, tcon, full_path, cifs_sb);
+	if (rc == -EBUSY)
+		rc = cifs_rename_pending_delete(xid, tcon, full_path, true /* is_dir */, direntry);
+
 	cifs_put_tlink(tlink);
 
 	if (!rc) {
-- 
2.20.1

