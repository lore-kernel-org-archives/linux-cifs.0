Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA4A1DD877
	for <linux-cifs@vger.kernel.org>; Tue,  2 Sep 2025 17:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756832411; cv=none; b=e/GIaoxZN9F9fGP6sBdEk5dmZ+WmWgucWmC3EiMBaLMwSPbkzAtQtUaO10DWmIrznVDtF9ylNLWdh7ZPRxupOntsaDVqSV4rs2ZvCiR3dNlF+QL654yGeqilQ6m7JeMyHj/eNEEhGvu5bjpC3re2t7WxTnfG+gZiQ037AD85AAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756832411; c=relaxed/simple;
	bh=XUYUqKVjsxBgZ+XAMzweB9M3Vv4aqHpsLOJYH+yH43U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kp1xNQ0upZIYY51eX2wTPqz83fXvT5E77FarQc4zW9JvJLzuHUjwfqgheC0d+QSTWg7uwuccij712iQ//ePTZHj2FbZg0x5CoFZdZO+U3EmhKK1PhHGyGw7a3Bh94LA9Rsgi/Gi/Wd9NZoFT3IqikNG7H+B+MoPVjaUwQyImNSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=oVv2Ou8C; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="oVv2Ou8C"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=4XchncF1rQUDZwl5Zyy+9kcbl/MG/KsO7ZowmKpc5Uk=; b=oVv2Ou8CxVNooMHyf17vZRA7xy
	7UaDDAkRYOsnXo2zuEvJyIPi2orShXjh2x5CxC5m1XsSj2PP3/3OaeDS/8zE1+uo2cEuwQJeSaNod
	4QZYN4rg1Xo26Noo0VGSIDhPV91ogilKRFmAh+//XEU4Z8PEC2vUD139vA006ybG0zq/iG9No2rQL
	WbgobLluEYIxJvA/BdRZknc0r5NCrkumgO1OptybA0WpjYxSNUpsNjU+i61jm6+4FOXEI7ua3XYno
	GYSc4bwveZLcfx6Tmt1VwBX5KS+Gwy7Vl1x9MHuz1j7sJNu3kGdAJByi5w4cuC7Cr7YEkXlxjQrUk
	pgEesZTg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1utUHT-00000000hsI-20Um;
	Tue, 02 Sep 2025 13:54:51 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: Jean-Baptiste Denis <jbdenis@pasteur.fr>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Frank Sorenson <sorenson@redhat.com>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Scott Mayhew <smayhew@redhat.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH v2] smb: client: fix data loss due to broken rename(2)
Date: Tue,  2 Sep 2025 13:54:51 -0300
Message-ID: <20250902165451.892165-1-pc@manguebit.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename of open files in SMB2+ has been broken for a very long time,
resulting in data loss as the CIFS client would fail the rename(2)
call with -ENOENT and then removing the target file.

Fix this by implementing ->rename_pending_delete() for SMB2+, which
will rename busy files to random filenames (e.g. silly rename) during
unlink(2) or rename(2), and then marking them to delete-on-close.

Besides, introduce a FIND_RD_NO_PENDING_DELETE flag for
cifs_get_readable_path() to be used in smb2_query_path_info() and
smb2_query_reparse_point() so we don't end up reusing open handles of
files that were already removed.

Reported-by: Jean-Baptiste Denis <jbdenis@pasteur.fr>
Closes: https://marc.info/?i=16aeb380-30d4-4551-9134-4e7d1dc833c0@pasteur.fr
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: Frank Sorenson <sorenson@redhat.com>
Cc: Olga Kornievskaia <okorniev@redhat.com>
Cc: Benjamin Coddington <bcodding@redhat.com>
Cc: Scott Mayhew <smayhew@redhat.com>
Cc: linux-cifs@vger.kernel.org
---
v1 -> v2:
  * Reworked patch to perform the silly rename + delete-pending
    setting without compounding due to an Azure bug (compound limit of
    4?).
  * Fixed generic/023 generic/024 generic/035 with SMB2+ against Samba
    (+posix), Azure, ksmbd, and Windows Server.
  * Prevent the client from re-fetching metadata from files that had
    been marked with CIFS_INO_DELETE_PENDING or by reusing open
    handles that have delete pending.

 fs/smb/client/cifsglob.h  |   9 ++-
 fs/smb/client/file.c      |  18 +++++-
 fs/smb/client/inode.c     |  75 +++++++++++++++++-----
 fs/smb/client/smb2inode.c | 132 ++++++++++++++++++++++++++++++++++++++
 fs/smb/client/smb2ops.c   |   4 ++
 fs/smb/client/smb2pdu.c   |  27 ++++----
 fs/smb/client/smb2proto.h |   7 ++
 7 files changed, 238 insertions(+), 34 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 1e64a4fb6af0..92df62e69946 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1882,9 +1882,12 @@ static inline bool is_replayable_error(int error)
 
 
 /* cifs_get_writable_file() flags */
-#define FIND_WR_ANY         0
-#define FIND_WR_FSUID_ONLY  1
-#define FIND_WR_WITH_DELETE 2
+enum cifs_writable_file_flags {
+	FIND_WR_ANY			= 0U,
+	FIND_WR_FSUID_ONLY		= (1U << 0),
+	FIND_WR_WITH_DELETE		= (1U << 1),
+	FIND_WR_NO_PENDING_DELETE	= (1U << 2),
+};
 
 #define   MID_FREE 0
 #define   MID_REQUEST_ALLOCATED 1
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 186e061068be..cb907e18cc35 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -998,7 +998,10 @@ int cifs_open(struct inode *inode, struct file *file)
 
 	/* Get the cached handle as SMB2 close is deferred */
 	if (OPEN_FMODE(file->f_flags) & FMODE_WRITE) {
-		rc = cifs_get_writable_path(tcon, full_path, FIND_WR_FSUID_ONLY, &cfile);
+		rc = cifs_get_writable_path(tcon, full_path,
+					    FIND_WR_FSUID_ONLY |
+					    FIND_WR_NO_PENDING_DELETE,
+					    &cfile);
 	} else {
 		rc = cifs_get_readable_path(tcon, full_path, &cfile);
 	}
@@ -2530,6 +2533,9 @@ cifs_get_writable_file(struct cifsInodeInfo *cifs_inode, int flags,
 			continue;
 		if (with_delete && !(open_file->fid.access & DELETE))
 			continue;
+		if ((flags & FIND_WR_NO_PENDING_DELETE) &&
+		    open_file->status_file_deleted)
+			continue;
 		if (OPEN_FMODE(open_file->f_flags) & FMODE_WRITE) {
 			if (!open_file->invalidHandle) {
 				/* found a good writable file */
@@ -2647,6 +2653,16 @@ cifs_get_readable_path(struct cifs_tcon *tcon, const char *name,
 		spin_unlock(&tcon->open_file_lock);
 		free_dentry_path(page);
 		*ret_file = find_readable_file(cinode, 0);
+		if (*ret_file) {
+			spin_lock(&cinode->open_file_lock);
+			if ((*ret_file)->status_file_deleted) {
+				spin_unlock(&cinode->open_file_lock);
+				cifsFileInfo_put(*ret_file);
+				*ret_file = NULL;
+			} else {
+				spin_unlock(&cinode->open_file_lock);
+			}
+		}
 		return *ret_file ? 0 : -ENOENT;
 	}
 
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index fe453a4b3dc8..6538ed024129 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2003,7 +2003,11 @@ int cifs_unlink(struct inode *dir, struct dentry *dentry)
 		goto psx_del_no_retry;
 	}
 
-	rc = server->ops->unlink(xid, tcon, full_path, cifs_sb, dentry);
+	if (server->vals->protocol_id > SMB10_PROT_ID &&
+	    d_is_positive(dentry) && d_count(dentry) > 2)
+		rc = -EBUSY;
+	else
+		rc = server->ops->unlink(xid, tcon, full_path, cifs_sb, dentry);
 
 psx_del_no_retry:
 	if (!rc) {
@@ -2358,14 +2362,16 @@ int cifs_rmdir(struct inode *inode, struct dentry *direntry)
 	rc = server->ops->rmdir(xid, tcon, full_path, cifs_sb);
 	cifs_put_tlink(tlink);
 
+	cifsInode = CIFS_I(d_inode(direntry));
+
 	if (!rc) {
+		set_bit(CIFS_INO_DELETE_PENDING, &cifsInode->flags);
 		spin_lock(&d_inode(direntry)->i_lock);
 		i_size_write(d_inode(direntry), 0);
 		clear_nlink(d_inode(direntry));
 		spin_unlock(&d_inode(direntry)->i_lock);
 	}
 
-	cifsInode = CIFS_I(d_inode(direntry));
 	/* force revalidate to go get info when needed */
 	cifsInode->time = 0;
 
@@ -2458,8 +2464,11 @@ cifs_do_rename(const unsigned int xid, struct dentry *from_dentry,
 	}
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
 do_rename_exit:
-	if (rc == 0)
+	if (rc == 0) {
 		d_move(from_dentry, to_dentry);
+		/* Force a new lookup */
+		d_drop(from_dentry);
+	}
 	cifs_put_tlink(tlink);
 	return rc;
 }
@@ -2591,19 +2600,51 @@ cifs_rename2(struct mnt_idmap *idmap, struct inode *source_dir,
 
 unlink_target:
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
-
-	/* Try unlinking the target dentry if it's not negative */
-	if (d_really_is_positive(target_dentry) && (rc == -EACCES || rc == -EEXIST)) {
-		if (d_is_dir(target_dentry))
-			tmprc = cifs_rmdir(target_dir, target_dentry);
-		else
-			tmprc = cifs_unlink(target_dir, target_dentry);
-		if (tmprc)
-			goto cifs_rename_exit;
-		rc = cifs_do_rename(xid, source_dentry, from_name,
-				    target_dentry, to_name);
-		if (!rc)
-			rehash = false;
+	if (d_really_is_positive(target_dentry)) {
+		if (!rc) {
+			struct inode *inode = d_inode(target_dentry);
+			/*
+			 * Samba and ksmbd servers allow renaming a target
+			 * directory that is open, so make sure to update
+			 * ->i_nlink and then mark it as delete pending.
+			 */
+			if (S_ISDIR(inode->i_mode)) {
+				drop_cached_dir_by_name(xid, tcon, to_name, cifs_sb);
+				spin_lock(&inode->i_lock);
+				i_size_write(inode, 0);
+				clear_nlink(inode);
+				spin_unlock(&inode->i_lock);
+				set_bit(CIFS_INO_DELETE_PENDING, &CIFS_I(inode)->flags);
+				CIFS_I(inode)->time = 0; /* force reval */
+				inode_set_ctime_current(inode);
+				inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
+			}
+		} else if (rc == -EACCES || rc == -EEXIST) {
+			/*
+			 * Rename failed, possibly due to a busy target.
+			 * Retry it by unliking the target first.
+			 */
+			if (d_is_dir(target_dentry))
+				tmprc = cifs_rmdir(target_dir, target_dentry);
+			else
+				tmprc = cifs_unlink(target_dir, target_dentry);
+			if (tmprc) {
+				/*
+				 * Some servers will return STATUS_ACCESS_DENIED
+				 * or STATUS_DIRECTORY_NOT_EMPTY when failing to
+				 * rename a non-empty directory.  Make sure to
+				 * propagate the appropriate error back to
+				 * userspace.
+				 */
+				if (tmprc == -EEXIST || tmprc == -ENOTEMPTY)
+					rc = tmprc;
+				goto cifs_rename_exit;
+			}
+			rc = cifs_do_rename(xid, source_dentry, from_name,
+					    target_dentry, to_name);
+			if (!rc)
+				rehash = false;
+		}
 	}
 
 	/* force revalidate to go get info when needed */
@@ -2629,6 +2670,8 @@ cifs_dentry_needs_reval(struct dentry *dentry)
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 	struct cached_fid *cfid = NULL;
 
+	if (test_bit(CIFS_INO_DELETE_PENDING, &cifs_i->flags))
+		return false;
 	if (cifs_i->time == 0)
 		return true;
 
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 31c13fb5b85b..74c870a9d921 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1441,3 +1441,135 @@ int smb2_query_reparse_point(const unsigned int xid,
 	cifs_free_open_info(&data);
 	return rc;
 }
+
+static inline __le16 *utf16_smb2_path(struct cifs_sb_info *cifs_sb,
+				      const char *name, size_t namelen)
+{
+	int len;
+
+	if (*name == '\\' ||
+	    (cifs_sb_master_tlink(cifs_sb) &&
+	     cifs_sb_master_tcon(cifs_sb)->posix_extensions && *name == '/'))
+		name++;
+	return cifs_strndup_to_utf16(name, namelen, &len,
+				     cifs_sb->local_nls,
+				     cifs_remap(cifs_sb));
+}
+
+int smb2_rename_pending_delete(const char *full_path,
+			       struct dentry *dentry,
+			       const unsigned int xid)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(d_inode(dentry)->i_sb);
+	struct cifsInodeInfo *cinode = CIFS_I(d_inode(dentry));
+	__le16 *utf16_from_path __free(kfree) = NULL;
+	__le16 *utf16_to_path __free(kfree) = NULL;
+	__u32 co = file_create_options(dentry);
+	__u8 oplock = SMB2_OPLOCK_LEVEL_NONE;
+	char *to_name __free(kfree) = NULL;
+	__u32 attrs = cinode->cifsAttrs;
+	struct TCP_Server_Info *server;
+	struct cifs_open_parms oparms;
+	static atomic_t sillycounter;
+	struct tcon_link *tlink;
+	__u8 delete_pending = 1;
+	struct cifs_tcon *tcon;
+	unsigned int size[2];
+	struct cifs_fid fid;
+	const char *ppath;
+	void *data[2];
+	void *page;
+	size_t len;
+	int rc;
+
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	tcon = tlink_tcon(tlink);
+	server = tcon->ses->server;
+
+	page = alloc_dentry_path();
+
+	ppath = build_path_from_dentry(dentry->d_parent, page);
+	if (IS_ERR(ppath)) {
+		rc = PTR_ERR(ppath);
+		goto out;
+	}
+
+	len = strlen(ppath) + strlen("/.__smb1234") + 1;
+	to_name = kmalloc(len, GFP_KERNEL);
+	if (!to_name) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	scnprintf(to_name, len, "%s%c.__smb%04X", ppath, CIFS_DIR_SEP(cifs_sb),
+		  atomic_inc_return(&sillycounter) & 0xffff);
+
+	utf16_to_path = utf16_smb2_path(cifs_sb, to_name, len);
+	if (!utf16_to_path) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	utf16_from_path = cifs_convert_path_to_utf16(full_path, cifs_sb);
+	if (!utf16_from_path) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	drop_cached_dir_by_name(xid, tcon, full_path, cifs_sb);
+	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path,
+			     DELETE | FILE_WRITE_ATTRIBUTES,
+			     FILE_OPEN, co, ACL_NO_MODE);
+	oparms.fid = &fid;
+
+	if (cinode->lease_granted && server->ops->get_lease_key) {
+		oplock = SMB2_OPLOCK_LEVEL_LEASE;
+		server->ops->get_lease_key(d_inode(dentry), &fid);
+	}
+
+	rc = SMB2_open(xid, &oparms, utf16_from_path,
+		       &oplock, NULL, NULL, NULL, NULL);
+	if (rc)
+		goto out;
+
+	data[0] = &(FILE_BASIC_INFO) {
+		.Attributes = cpu_to_le32((attrs ?: ATTR_NORMAL) | ATTR_HIDDEN),
+	};
+	size[0] = sizeof(FILE_BASIC_INFO);
+	rc = smb2_set_info(xid, tcon, fid.persistent_fid, fid.volatile_fid,
+			   current->tgid, FILE_BASIC_INFORMATION,
+			   SMB2_O_INFO_FILE, 0, 1, data, size);
+	if (rc)
+		goto out_close;
+
+	len = sizeof(*utf16_to_path) * UniStrlen((wchar_t *)utf16_to_path);
+	data[0] = &(struct smb2_file_rename_info_hdr) {
+		.ReplaceIfExists = 1,
+		.FileNameLength = cpu_to_le32(len),
+	};
+	size[0] = sizeof(struct smb2_file_rename_info);
+	data[1] = utf16_to_path;
+	size[1] = len + sizeof(__le16);
+	rc = smb2_set_info(xid, tcon, fid.persistent_fid, fid.volatile_fid,
+			   current->tgid, FILE_RENAME_INFORMATION,
+			   SMB2_O_INFO_FILE, 0, 2, data, size);
+	if (rc)
+		goto out_close;
+
+	data[0] = &delete_pending;
+	size[0] = sizeof(delete_pending);
+	rc = smb2_set_info(xid, tcon, fid.persistent_fid, fid.volatile_fid,
+			   current->tgid, FILE_DISPOSITION_INFORMATION,
+			   SMB2_O_INFO_FILE, 0, 1, data, size);
+	if (!rc)
+		set_bit(CIFS_INO_DELETE_PENDING, &cinode->flags);
+
+out_close:
+	SMB2_close(xid, tcon, fid.persistent_fid, fid.volatile_fid);
+out:
+	cifs_put_tlink(tlink);
+	free_dentry_path(page);
+	return rc;
+}
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 94b1d7a395d5..aa604c9c683b 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5376,6 +5376,7 @@ struct smb_version_operations smb20_operations = {
 	.llseek = smb3_llseek,
 	.is_status_io_timeout = smb2_is_status_io_timeout,
 	.is_network_name_deleted = smb2_is_network_name_deleted,
+	.rename_pending_delete = smb2_rename_pending_delete,
 };
 #endif /* CIFS_ALLOW_INSECURE_LEGACY */
 
@@ -5481,6 +5482,7 @@ struct smb_version_operations smb21_operations = {
 	.llseek = smb3_llseek,
 	.is_status_io_timeout = smb2_is_status_io_timeout,
 	.is_network_name_deleted = smb2_is_network_name_deleted,
+	.rename_pending_delete = smb2_rename_pending_delete,
 };
 
 struct smb_version_operations smb30_operations = {
@@ -5597,6 +5599,7 @@ struct smb_version_operations smb30_operations = {
 	.llseek = smb3_llseek,
 	.is_status_io_timeout = smb2_is_status_io_timeout,
 	.is_network_name_deleted = smb2_is_network_name_deleted,
+	.rename_pending_delete = smb2_rename_pending_delete,
 };
 
 struct smb_version_operations smb311_operations = {
@@ -5713,6 +5716,7 @@ struct smb_version_operations smb311_operations = {
 	.llseek = smb3_llseek,
 	.is_status_io_timeout = smb2_is_status_io_timeout,
 	.is_network_name_deleted = smb2_is_network_name_deleted,
+	.rename_pending_delete = smb2_rename_pending_delete,
 };
 
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 2df93a75e3b8..7cc0003bc7f8 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5642,11 +5642,10 @@ SMB2_set_info_free(struct smb_rqst *rqst)
 		cifs_buf_release(rqst->rq_iov[0].iov_base); /* request */
 }
 
-static int
-send_set_info(const unsigned int xid, struct cifs_tcon *tcon,
-	       u64 persistent_fid, u64 volatile_fid, u32 pid, u8 info_class,
-	       u8 info_type, u32 additional_info, unsigned int num,
-		void **data, unsigned int *size)
+int smb2_set_info(const unsigned int xid, struct cifs_tcon *tcon,
+		  u64 persistent_fid, u64 volatile_fid, u32 pid, u8 info_class,
+		  u8 info_type, u32 additional_info, unsigned int num,
+		  void **data, unsigned int *size)
 {
 	struct smb_rqst rqst;
 	struct smb2_set_info_rsp *rsp = NULL;
@@ -5730,9 +5729,9 @@ SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,
 
 	trace_smb3_set_eof(xid, persistent_fid, tcon->tid, tcon->ses->Suid, new_eof);
 
-	return send_set_info(xid, tcon, persistent_fid, volatile_fid,
-			pid, FILE_END_OF_FILE_INFORMATION, SMB2_O_INFO_FILE,
-			0, 1, &data, &size);
+	return smb2_set_info(xid, tcon, persistent_fid, volatile_fid,
+			     pid, FILE_END_OF_FILE_INFORMATION, SMB2_O_INFO_FILE,
+			     0, 1, &data, &size);
 }
 
 int
@@ -5740,9 +5739,9 @@ SMB2_set_acl(const unsigned int xid, struct cifs_tcon *tcon,
 		u64 persistent_fid, u64 volatile_fid,
 		struct smb_ntsd *pnntsd, int pacllen, int aclflag)
 {
-	return send_set_info(xid, tcon, persistent_fid, volatile_fid,
-			current->tgid, 0, SMB2_O_INFO_SECURITY, aclflag,
-			1, (void **)&pnntsd, &pacllen);
+	return smb2_set_info(xid, tcon, persistent_fid, volatile_fid,
+			     current->tgid, 0, SMB2_O_INFO_SECURITY, aclflag,
+			     1, (void **)&pnntsd, &pacllen);
 }
 
 int
@@ -5750,9 +5749,9 @@ SMB2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 	    u64 persistent_fid, u64 volatile_fid,
 	    struct smb2_file_full_ea_info *buf, int len)
 {
-	return send_set_info(xid, tcon, persistent_fid, volatile_fid,
-		current->tgid, FILE_FULL_EA_INFORMATION, SMB2_O_INFO_FILE,
-		0, 1, (void **)&buf, &len);
+	return smb2_set_info(xid, tcon, persistent_fid, volatile_fid,
+			     current->tgid, FILE_FULL_EA_INFORMATION,
+			     SMB2_O_INFO_FILE, 0, 1, (void **)&buf, &len);
 }
 
 int
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 6e805ece6a7b..b11318faa161 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -233,6 +233,10 @@ extern int SMB2_query_directory_init(unsigned int xid, struct cifs_tcon *tcon,
 				     u64 persistent_fid, u64 volatile_fid,
 				     int index, int info_level);
 extern void SMB2_query_directory_free(struct smb_rqst *rqst);
+int smb2_set_info(const unsigned int xid, struct cifs_tcon *tcon,
+		  u64 persistent_fid, u64 volatile_fid, u32 pid, u8 info_class,
+		  u8 info_type, u32 additional_info, unsigned int num,
+		  void **data, unsigned int *size);
 extern int SMB2_set_eof(const unsigned int xid, struct cifs_tcon *tcon,
 			u64 persistent_fid, u64 volatile_fid, u32 pid,
 			loff_t new_eof);
@@ -317,5 +321,8 @@ int posix_info_sid_size(const void *beg, const void *end);
 int smb2_make_nfs_node(unsigned int xid, struct inode *inode,
 		       struct dentry *dentry, struct cifs_tcon *tcon,
 		       const char *full_path, umode_t mode, dev_t dev);
+int smb2_rename_pending_delete(const char *full_path,
+			       struct dentry *dentry,
+			       const unsigned int xid);
 
 #endif			/* _SMB2PROTO_H */
-- 
2.51.0

