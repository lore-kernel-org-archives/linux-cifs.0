Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 177A526E701;
	Sun, 31 Aug 2025 12:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643800; cv=none; b=R8mXl9kHu2kY5LIsn7pK2iOyWF6bpahJsAhCSIH7oEC9RdiQ8PlkED8tyqN6FnUhwI45KpgH95QRbrNdaHnIC+M123+Z8kDbZkH3191zFIaeGibYe/OO1bUW/Q6IOQdqroqGgGqHmgjhHY/Jf8RAjizPNZD584VRpmornhOb9Dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643800; c=relaxed/simple;
	bh=kkY3dV4+g16/UFiBKJIvabwDCXuiAib+78j5fAdmQGk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WbAy0u6+LSdhuBrZmpxQ4X4BToW80nZ90Qzj5Miyu80X4BWztvEFyXRWgbkR0pHvYMqymgNYXYWzMPYBMeEOe4zpHfX5MxXPeVLMyx+FX6VZAPdLDpPZnbb64AIrawd2KmPASH1rXD0SukBKnV2RQ/B0shu0rnHWlsjdKjZlOSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZhUQU/nk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZhUQU/nk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99044C4CEED;
	Sun, 31 Aug 2025 12:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643799;
	bh=kkY3dV4+g16/UFiBKJIvabwDCXuiAib+78j5fAdmQGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZhUQU/nkFV1VGPa+BR723dyJm889IfogsIyd4x3KT69Ku0A24WNDuHz3j9n1aiQ7s
	 FAYaLOGuyPZ968/itVi6IlJMLKinLr1sN2ZmBRWk/4bPxZKZXwFpe2uwhp6zjR+1wn
	 btM+H1g9hSCNCu+LG0qJ7utoZ3XNUY7ARQ4yJ1j6tQlsBwPVcucTjwiAWz8wE90OjF
	 T67s7K4dJNnN72fuCU1A9Q2vyhUHelq29vN1HrUxPUi4A9lS7jOJTVoZPeG3EAEj8U
	 5/1yOiSGF648h81skCiE6B/WohXCZOni7vU8jrUtvNgR0lvst271MzrBwUitz2mlVv
	 IBx3bzMu/fqsQ==
Received: by pali.im (Postfix)
	id 1BD58EB3; Sun, 31 Aug 2025 14:36:36 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 26/35] cifs: Add SMB2+ support into cifs_rename_pending_delete() function.
Date: Sun, 31 Aug 2025 14:35:53 +0200
Message-Id: <20250831123602.14037-27-pali@kernel.org>
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

Currently the cifs_rename_pending_delete() function calls directly the SMB1
functions and therefore cannot be used by SMB2+ dialects.

Change cifs_rename_pending_delete() code to use tcon->ses->server->ops->
callbacks instead of direct SMB1 functions. This allows to use this
function also by SMB2 and SMB3 dialects.

Mark the function cifs_rename_pending_delete() as static in inode.c and
calls it directly. As it is now dialect neutral, remove it from struct
smb_version_operations callback list.

This change allows to use silly rename in SMB2+ by follow up changes.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifsglob.h  |  3 ---
 fs/smb/client/cifsproto.h |  3 ---
 fs/smb/client/inode.c     | 56 +++++++++++++++++----------------------
 fs/smb/client/smb1ops.c   |  1 -
 4 files changed, 24 insertions(+), 39 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index ec5608924ce7..592a4faa3440 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -453,9 +453,6 @@ struct smb_version_operations {
 	/* unlink file */
 	int (*unlink)(const unsigned int, struct cifs_tcon *, const char *,
 		      struct cifs_sb_info *, struct dentry *);
-	/* open, rename and delete file */
-	int (*rename_pending_delete)(const char *, struct dentry *,
-				     const unsigned int);
 	/* send rename request */
 	int (*rename)(const unsigned int xid,
 		      struct cifs_tcon *tcon,
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index f248b18f1cf3..a29662a4d83d 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -242,9 +242,6 @@ extern int cifs_get_inode_info_unix(struct inode **pinode,
 			struct super_block *sb, unsigned int xid);
 extern int cifs_set_file_info(struct inode *inode, struct iattr *attrs,
 			      unsigned int xid, const char *full_path, __u32 dosattr);
-extern int cifs_rename_pending_delete(const char *full_path,
-				      struct dentry *dentry,
-				      const unsigned int xid);
 extern int sid_to_id(struct cifs_sb_info *cifs_sb, struct smb_sid *psid,
 				struct cifs_fattr *fattr, uint sidtype);
 extern int cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb,
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 9a5504a3406d..c3f101d10488 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1684,7 +1684,6 @@ cifs_set_file_info(struct inode *inode, struct iattr *attrs, unsigned int xid,
 	return server->ops->set_file_info(inode, full_path, &info_buf, xid);
 }
 
-#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 /*
  * Open the given file (if it isn't already), set the DELETE_PENDING bit
  * and rename it to a random name that hopefully won't conflict with
@@ -1697,9 +1696,11 @@ cifs_set_file_info(struct inode *inode, struct iattr *attrs, unsigned int xid,
 #define SILLYNAME_LEN (SILLYNAME_PREFIX_LEN + \
 		SILLYNAME_FILEID_LEN + \
 		SILLYNAME_COUNTER_LEN)
-int
-cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
-			   const unsigned int xid)
+static int
+cifs_rename_pending_delete(const unsigned int xid,
+			   struct cifs_tcon *tcon,
+			   const char *full_path,
+			   struct dentry *dentry)
 {
 	int oplock = 0;
 	int rc;
@@ -1708,8 +1709,6 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 	struct inode *inode = d_inode(dentry);
 	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
-	struct tcon_link *tlink;
-	struct cifs_tcon *tcon;
 	__u32 dosattr, origattr;
 	char *sillyname_full_path = NULL;
 	bool can_rename_opened_file = true;
@@ -1719,11 +1718,6 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 	const char *dirpath_end;
 	size_t dirpath_len;
 
-	tlink = cifs_sb_tlink(cifs_sb);
-	if (IS_ERR(tlink))
-		return PTR_ERR(tlink);
-	tcon = tlink_tcon(tlink);
-
 	/* construct random name ".smb<inodenum><counter>" */
 	while (true) {
 		static unsigned int sillycounter; /* globally unique */
@@ -1753,8 +1747,10 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 	/*
 	 * We cannot rename the opened file if the SMB1 server doesn't
 	 * support CAP_INFOLEVEL_PASSTHRU. But we can rename file via path.
+	 * SMB2+ always supports renaming of the opened file.
 	 */
-	if (!(tcon->ses->capabilities & CAP_INFOLEVEL_PASSTHRU))
+	if (tcon->ses->server->vals->protocol_id == SMB10_PROT_ID &&
+	    !(tcon->ses->capabilities & CAP_INFOLEVEL_PASSTHRU))
 		can_rename_opened_file = false;
 
 	dirpath_end = strrchr(full_path, CIFS_DIR_SEP(cifs_sb));
@@ -1821,16 +1817,16 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 		.fid = &fid,
 	};
 
-	rc = CIFS_open(xid, &oparms, &oplock, NULL);
+	rc = tcon->ses->server->ops->open(xid, &oparms, &oplock, NULL);
 	if (rc != 0)
 		goto undo_rename_path;
 
 	/* rename the opened file (if it was not already renamed before the open) */
 	if (can_rename_opened_file) {
-		rc = CIFSSMBRenameOpenFile(xid, tcon, fid.netfid, sillyname,
+		rc = tcon->ses->server->ops->rename_opened_file(
+				   xid, tcon, &fid, sillyname_full_path,
 				   false /* overwrite */,
-				   cifs_sb->local_nls,
-				   cifs_remap(cifs_sb));
+				   cifs_sb);
 		if (rc != 0) {
 			rc = -EBUSY;
 			goto undo_close;
@@ -1839,8 +1835,7 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 
 	/* try to set DELETE_PENDING */
 	if (!test_bit(CIFS_INO_DELETE_PENDING, &cifsInode->flags)) {
-		rc = CIFSSMBSetFileDisposition(xid, tcon, true, fid.netfid,
-					       current->tgid);
+		rc = tcon->ses->server->ops->set_file_disp(xid, tcon, &fid, true);
 		/*
 		 * some samba versions return -ENOENT when we try to set the
 		 * file disposition here. Likely a samba bug, but work around
@@ -1856,11 +1851,10 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 		set_bit(CIFS_INO_DELETE_PENDING, &cifsInode->flags);
 	}
 
-	CIFSSMBClose(xid, tcon, fid.netfid);
+	tcon->ses->server->ops->close(xid, tcon, &fid);
 
 out:
 	kfree(sillyname_full_path);
-	cifs_put_tlink(tlink);
 	return rc;
 
 	/*
@@ -1870,14 +1864,16 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 	 */
 undo_rename_opened_file:
 	if (can_rename_opened_file)
-		CIFSSMBRenameOpenFile(xid, tcon, fid.netfid, dentry->d_name.name,
+		tcon->ses->server->ops->rename_opened_file(
+				xid, tcon, &fid, full_path,
 				true /* overwrite */,
-				cifs_sb->local_nls, cifs_remap(cifs_sb));
+				cifs_sb);
 undo_close:
-	CIFSSMBClose(xid, tcon, fid.netfid);
+	tcon->ses->server->ops->close(xid, tcon, &fid);
 undo_rename_path:
 	if (!can_rename_opened_file)
-		CIFSSMBRename(xid, tcon, dentry,
+		tcon->ses->server->ops->rename(
+				xid, tcon, dentry,
 				sillyname_full_path,
 				full_path,
 				cifs_sb);
@@ -1888,7 +1884,6 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 	}
 	goto out;
 }
-#endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
 
 /* copied from fs/nfs/dir.c with small changes */
 static void
@@ -1981,13 +1976,10 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
 	} else if (rc == -ENOENT) {
 		d_drop(dentry);
 	} else if (rc == -EBUSY) {
-		if (server->ops->rename_pending_delete) {
-			rc = server->ops->rename_pending_delete(full_path,
-								dentry, xid);
-			if (rc == 0) {
-				cifs_mark_open_handles_for_deleted_file(inode, full_path);
-				cifs_drop_nlink(inode);
-			}
+		rc = cifs_rename_pending_delete(xid, tcon, full_path, dentry);
+		if (rc == 0) {
+			cifs_mark_open_handles_for_deleted_file(inode, full_path);
+			cifs_drop_nlink(inode);
 		}
 	} else if ((rc == -EACCES) && (dosattr == 0) && inode) {
 		attrs = kzalloc(sizeof(*attrs), GFP_KERNEL);
diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 26798db5c00b..746dd9aa6b1b 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -1422,7 +1422,6 @@ struct smb_version_operations smb1_operations = {
 	.mkdir_setinfo = cifs_mkdir_setinfo,
 	.rmdir = CIFSSMBRmDir,
 	.unlink = CIFSSMBDelFile,
-	.rename_pending_delete = cifs_rename_pending_delete,
 	.rename = CIFSSMBRename,
 	.rename_opened_file = cifs_rename_opened_file,
 	.create_hardlink = CIFSCreateHardLink,
-- 
2.20.1

