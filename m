Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A302309B2
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 16:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756139162; cv=none; b=VBQhhvaHUAhEncAwn93g4iT/WvMHMNMxxwI7ITGdKn3CT3d3oZw5LJu/iIZxuMwrWmvQ8XrldCNioANbH/w6I04+lLyas6nSPqN2oKDX7Cuqa0moE3GEziI10DlLSJH52Ms4Cn0ZIwkjDpoX6Hiv9N6hzW3xOy5mPEkV3vdY75k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756139162; c=relaxed/simple;
	bh=L6GMFi7H8b99yUYfZVZQjWv7R/bF+i4XmOZyP9A0W70=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Il7hPvLxMAJphha0mMCAp9mJDHAPtxOTRuxgf3RrrbSp+IEzuKfbGmODqg4TJmKDMD9hnQMzX+XYstZyY1yEFCHPszu/fxRYpNZj2Y/SNh4r6PJHOXr4p8NczdpbD3VgExYTAz/6Krqop68+KykINXN9eBdXcMVwEbxP+pKmh/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=Asl3tF8U; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="Asl3tF8U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=YWybQVRhIv5ZZnUF9wxhuPNOu9ERzmABI5XXdr97QEQ=; b=Asl3tF8U4nGyS8yg+Zow2fbrPH
	pEV15IBypaQti6OkaT5IuzoJmiKAN8VCeVAthKY35iS66KuoeD78sdNuM/Dwsz0p7dYpCXk9dS9Ma
	POltM+fcqEThmIUb+k32MQ4knmZzSM6UcsPhMxNJKCHgSvIkjES4MpmXK4eHsi/MlTNDC+IEw6pUK
	h9wBEp1kk0EENojPtYmmvBifytcwhXnE1UHJGCFe9Kelt7DstxFeSjLCkQi+oVu/7iwTHSJ+VXprt
	7ptFFU1qY88TKD7KIYvxvz49VmnWALSZsx9TLGqXZ1GOJL4dNiWhIJB7pmjwbizIxwfySxRJU1/2R
	RPiA26pQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.98.2)
	id 1uqZvW-00000000FH6-1yHN;
	Mon, 25 Aug 2025 13:20:10 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: Jean-Baptiste Denis <jbdenis@pasteur.fr>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Frank Sorenson <sorenson@redhat.com>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Scott Mayhew <smayhew@redhat.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH] smb: client: fix data loss due to broken rename(2)
Date: Mon, 25 Aug 2025 13:20:10 -0300
Message-ID: <20250825162010.417958-1-pc@manguebit.org>
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
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: Frank Sorenson <sorenson@redhat.com>
Cc: Olga Kornievskaia <okorniev@redhat.com>
Cc: Benjamin Coddington <bcodding@redhat.com>
Cc: Scott Mayhew <smayhew@redhat.com>
Cc: linux-cifs@vger.kernel.org
---
 fs/smb/client/cifsglob.h  |   5 ++
 fs/smb/client/cifsproto.h |   4 +-
 fs/smb/client/file.c      |  18 ++++-
 fs/smb/client/inode.c     |   6 +-
 fs/smb/client/smb2glob.h  |   1 +
 fs/smb/client/smb2inode.c | 151 +++++++++++++++++++++++++++++++++++++-
 fs/smb/client/smb2ops.c   |   4 +
 fs/smb/client/smb2proto.h |   3 +
 fs/smb/client/trace.h     |   3 +
 9 files changed, 184 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 1e64a4fb6af0..d238b186946b 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1886,6 +1886,9 @@ static inline bool is_replayable_error(int error)
 #define FIND_WR_FSUID_ONLY  1
 #define FIND_WR_WITH_DELETE 2
 
+/* cifs_get_readable_path() flags */
+#define FIND_RD_NO_PENDING_DELETE 1
+
 #define   MID_FREE 0
 #define   MID_REQUEST_ALLOCATED 1
 #define   MID_REQUEST_SUBMITTED 2
@@ -2343,6 +2346,8 @@ struct smb2_compound_vars {
 	struct kvec qi_iov;
 	struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
 	struct kvec si_iov[SMB2_SET_INFO_IOV_SIZE];
+	struct kvec fdis_iov[SMB2_SET_INFO_IOV_SIZE];
+	struct kvec rename_iov[SMB2_SET_INFO_IOV_SIZE];
 	struct kvec close_iov;
 	struct smb2_file_rename_info_hdr rename_info;
 	struct smb2_file_link_info_hdr link_info;
diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index c34c533b2efa..518b4e5126cd 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -176,8 +176,8 @@ extern int cifs_get_writable_path(struct cifs_tcon *tcon, const char *name,
 				  int flags,
 				  struct cifsFileInfo **ret_file);
 extern struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *, bool);
-extern int cifs_get_readable_path(struct cifs_tcon *tcon, const char *name,
-				  struct cifsFileInfo **ret_file);
+int cifs_get_readable_path(struct cifs_tcon *tcon, const char *name,
+			   unsigned int flags, struct cifsFileInfo **ret_file);
 extern int cifs_get_hardlink_path(struct cifs_tcon *tcon, struct inode *inode,
 				  struct file *file);
 extern unsigned int smbCalcSize(void *buf);
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 186e061068be..12e72f08f046 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1000,7 +1000,7 @@ int cifs_open(struct inode *inode, struct file *file)
 	if (OPEN_FMODE(file->f_flags) & FMODE_WRITE) {
 		rc = cifs_get_writable_path(tcon, full_path, FIND_WR_FSUID_ONLY, &cfile);
 	} else {
-		rc = cifs_get_readable_path(tcon, full_path, &cfile);
+		rc = cifs_get_readable_path(tcon, full_path, 0, &cfile);
 	}
 	if (rc == 0) {
 		unsigned int oflags = file->f_flags & ~(O_CREAT|O_EXCL|O_TRUNC);
@@ -2622,9 +2622,8 @@ cifs_get_writable_path(struct cifs_tcon *tcon, const char *name,
 	return -ENOENT;
 }
 
-int
-cifs_get_readable_path(struct cifs_tcon *tcon, const char *name,
-		       struct cifsFileInfo **ret_file)
+int cifs_get_readable_path(struct cifs_tcon *tcon, const char *name,
+			   unsigned int flags, struct cifsFileInfo **ret_file)
 {
 	struct cifsFileInfo *cfile;
 	void *page = alloc_dentry_path();
@@ -2647,6 +2646,17 @@ cifs_get_readable_path(struct cifs_tcon *tcon, const char *name,
 		spin_unlock(&tcon->open_file_lock);
 		free_dentry_path(page);
 		*ret_file = find_readable_file(cinode, 0);
+		if (*ret_file) {
+			spin_lock(&cinode->open_file_lock);
+			if ((flags & FIND_RD_NO_PENDING_DELETE) &&
+			    (*ret_file)->status_file_deleted) {
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
index fe453a4b3dc8..48dbfb451576 100644
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
diff --git a/fs/smb/client/smb2glob.h b/fs/smb/client/smb2glob.h
index 224495322a05..474fddb9c56c 100644
--- a/fs/smb/client/smb2glob.h
+++ b/fs/smb/client/smb2glob.h
@@ -39,6 +39,7 @@ enum smb2_compound_ops {
 	SMB2_OP_GET_REPARSE,
 	SMB2_OP_QUERY_WSL_EA,
 	SMB2_OP_OPEN_QUERY,
+	SMB2_OP_SET_FILE_DISP,
 };
 
 /* Used when constructing chained read requests. */
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 2a0316c514e4..223358e082b3 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -440,7 +440,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 							   ses->Suid, full_path);
 			break;
 		case SMB2_OP_RENAME:
-			rqst[num_rqst].rq_iov = &vars->si_iov[0];
+			rqst[num_rqst].rq_iov = vars->rename_iov;
 			rqst[num_rqst].rq_nvec = 2;
 
 			len = in_iov[i].iov_len;
@@ -594,6 +594,41 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 			trace_smb3_query_wsl_ea_compound_enter(xid, tcon->tid,
 							       ses->Suid, full_path);
 			break;
+		case SMB2_OP_SET_FILE_DISP:
+			rqst[num_rqst].rq_iov = vars->fdis_iov;
+			rqst[num_rqst].rq_nvec = 1;
+
+			size[0] = in_iov[i].iov_len;
+			data[0] = in_iov[i].iov_base;
+
+			if (cfile) {
+				rc = SMB2_set_info_init(tcon, server,
+							&rqst[num_rqst],
+							cfile->fid.persistent_fid,
+							cfile->fid.volatile_fid,
+							current->tgid,
+							FILE_DISPOSITION_INFORMATION,
+							SMB2_O_INFO_FILE, 0,
+							data, size);
+			} else {
+				rc = SMB2_set_info_init(tcon, server,
+							&rqst[num_rqst],
+							COMPOUND_FID,
+							COMPOUND_FID,
+							current->tgid,
+							FILE_DISPOSITION_INFORMATION,
+							SMB2_O_INFO_FILE, 0,
+							data, size);
+			}
+			if (!rc && (!cfile || num_rqst > 1)) {
+				smb2_set_next_command(tcon, &rqst[num_rqst]);
+				smb2_set_related(&rqst[num_rqst]);
+			} else if (rc) {
+				goto finished;
+			}
+			num_rqst++;
+			trace_smb3_set_file_disp_enter(xid, tcon->tid, ses->Suid, full_path);
+			break;
 		default:
 			cifs_dbg(VFS, "Invalid command\n");
 			rc = -EINVAL;
@@ -843,6 +878,13 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 			}
 			SMB2_query_info_free(&rqst[num_rqst++]);
 			break;
+		case SMB2_OP_SET_FILE_DISP:
+			if (!rc)
+				trace_smb3_set_file_disp_done(xid, tcon->tid, ses->Suid);
+			else
+				trace_smb3_set_file_disp_err(xid, tcon->tid, ses->Suid, rc);
+			SMB2_set_info_free(&rqst[num_rqst++]);
+			break;
 		}
 	}
 	SMB2_close_free(&rqst[num_rqst]);
@@ -990,7 +1032,7 @@ int smb2_query_path_info(const unsigned int xid,
 	in_iov[1] = in_iov[0];
 	in_iov[2] = in_iov[0];
 
-	cifs_get_readable_path(tcon, full_path, &cfile);
+	cifs_get_readable_path(tcon, full_path, FIND_RD_NO_PENDING_DELETE, &cfile);
 	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path, FILE_READ_ATTRIBUTES,
 			     FILE_OPEN, create_options, ACL_NO_MODE);
 	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
@@ -1069,7 +1111,8 @@ int smb2_query_path_info(const unsigned int xid,
 				     FILE_READ_EA | SYNCHRONIZE,
 				     FILE_OPEN, create_options |
 				     OPEN_REPARSE_POINT, ACL_NO_MODE);
-		cifs_get_readable_path(tcon, full_path, &cfile);
+		cifs_get_readable_path(tcon, full_path,
+				       FIND_RD_NO_PENDING_DELETE, &cfile);
 		free_rsp_iov(out_iov, out_buftype, ARRAY_SIZE(out_iov));
 		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
 				      &oparms, in_iov, cmds, num_cmds,
@@ -1418,7 +1461,8 @@ int smb2_query_reparse_point(const unsigned int xid,
 
 	cifs_dbg(FYI, "%s: path: %s\n", __func__, full_path);
 
-	cifs_get_readable_path(tcon, full_path, &cfile);
+	cifs_get_readable_path(tcon, full_path,
+			       FIND_RD_NO_PENDING_DELETE, &cfile);
 	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path,
 			     FILE_READ_ATTRIBUTES | FILE_READ_EA | SYNCHRONIZE,
 			     FILE_OPEN, OPEN_REPARSE_POINT, ACL_NO_MODE);
@@ -1438,3 +1482,102 @@ int smb2_query_reparse_point(const unsigned int xid,
 	cifs_free_open_info(&data);
 	return rc;
 }
+
+int smb2_rename_pending_delete(const char *full_path,
+			       struct dentry *dentry,
+			       const unsigned int xid)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(d_inode(dentry)->i_sb);
+	struct cifsInodeInfo *cinode = CIFS_I(d_inode(dentry));
+	__le16 *utf16_path __free(kfree) = NULL;
+	__u32 co = file_create_options(dentry);
+	int cmds[] = {
+		SMB2_OP_SET_INFO,
+		SMB2_OP_RENAME,
+		SMB2_OP_SET_FILE_DISP,
+	};
+	const int num_cmds = ARRAY_SIZE(cmds);
+	char *to_name __free(kfree) = NULL;
+	struct kvec iov[ARRAY_SIZE(cmds)];
+	__u32 attrs = cinode->cifsAttrs;
+	struct cifs_open_parms oparms;
+	static atomic_t sillycounter;
+	struct cifsFileInfo *cfile;
+	struct tcon_link *tlink;
+	__u8 delete_pending = 1;
+	struct cifs_tcon *tcon;
+	const char *ppath;
+	void *page;
+	size_t len;
+	int rc;
+
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		return PTR_ERR(tlink);
+	tcon = tlink_tcon(tlink);
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
+	if (unlikely(len >= PATH_MAX)) {
+		rc = -ENAMETOOLONG;
+		goto out;
+	}
+	to_name = kmalloc(len, GFP_KERNEL);
+	if (!to_name) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	scnprintf(to_name, len, "%s%c.__smb%04X", ppath, CIFS_DIR_SEP(cifs_sb),
+		  atomic_inc_return(&sillycounter) & 0xffff);
+
+	utf16_path = cifs_convert_path_to_utf16(to_name, cifs_sb);
+	if (!utf16_path) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	drop_cached_dir_by_name(xid, tcon, full_path, cifs_sb);
+	oparms = CIFS_OPARMS(cifs_sb, tcon, full_path,
+			     DELETE | FILE_WRITE_ATTRIBUTES,
+			     FILE_OPEN, co, ACL_NO_MODE);
+
+	attrs &= ~ATTR_READONLY;
+	iov[0].iov_base = &(FILE_BASIC_INFO) {
+		.Attributes = cpu_to_le32((attrs ?: ATTR_NORMAL) | ATTR_HIDDEN),
+	};
+	iov[0].iov_len = sizeof(FILE_BASIC_INFO);
+	iov[1].iov_base = utf16_path;
+	iov[1].iov_len = sizeof(*utf16_path) * UniStrnlen((wchar_t *)utf16_path, PATH_MAX);
+	iov[2].iov_base = &delete_pending;
+	iov[2].iov_len = sizeof(delete_pending);
+
+	cifs_get_writable_path(tcon, full_path, FIND_WR_WITH_DELETE, &cfile);
+	rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, &oparms, iov,
+			      cmds, num_cmds, cfile, NULL, NULL, dentry);
+	if (rc == -EINVAL) {
+		cifs_dbg(FYI, "invalid lease key, resending request without lease\n");
+		cifs_get_writable_path(tcon, full_path,
+				       FIND_WR_WITH_DELETE, &cfile);
+		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path, &oparms, iov,
+				      cmds, num_cmds, cfile, NULL, NULL, NULL);
+	}
+	if (!rc) {
+		set_bit(CIFS_INO_DELETE_PENDING, &cinode->flags);
+	} else {
+		cifs_tcon_dbg(VFS, "%s: failed to rename '%s' to '%s': %d\n",
+			      __func__, full_path, to_name, rc);
+		rc = -EIO;
+	}
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
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 6e805ece6a7b..b3f1398c9f79 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -317,5 +317,8 @@ int posix_info_sid_size(const void *beg, const void *end);
 int smb2_make_nfs_node(unsigned int xid, struct inode *inode,
 		       struct dentry *dentry, struct cifs_tcon *tcon,
 		       const char *full_path, umode_t mode, dev_t dev);
+int smb2_rename_pending_delete(const char *full_path,
+			       struct dentry *dentry,
+			       const unsigned int xid);
 
 #endif			/* _SMB2PROTO_H */
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 93e5b2bb9f28..323a82f66d2b 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -675,6 +675,7 @@ DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(set_info_compound_enter);
 DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(set_reparse_compound_enter);
 DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(get_reparse_compound_enter);
 DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(query_wsl_ea_compound_enter);
+DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(set_file_disp_enter);
 DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(delete_enter);
 DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(mkdir_enter);
 DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(tdis_enter);
@@ -716,6 +717,7 @@ DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(set_info_compound_done);
 DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(set_reparse_compound_done);
 DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(get_reparse_compound_done);
 DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(query_wsl_ea_compound_done);
+DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(set_file_disp_done);
 DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(delete_done);
 DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(mkdir_done);
 DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(tdis_done);
@@ -762,6 +764,7 @@ DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(set_info_compound_err);
 DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(set_reparse_compound_err);
 DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(get_reparse_compound_err);
 DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(query_wsl_ea_compound_err);
+DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(set_file_disp_err);
 DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(mkdir_err);
 DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(delete_err);
 DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(tdis_err);
-- 
2.51.0

