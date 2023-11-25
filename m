Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="IUxRolgi"
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A3CC5
	for <linux-cifs@vger.kernel.org>; Sat, 25 Nov 2023 14:08:31 -0800 (PST)
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700950110;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ASn7MPpX45MTA6pb9S4q5N63BdZZEwDudBfiOd0n6jI=;
	b=IUxRolgiFugdi7xkMTzZyKHsNdnzxOoOoaXhZO7zEiqPQJ6176zRnCmLDLCNzLyrADTDtn
	eg1kLYQ1U+1dyY5klnOAjsFbwh52zeF+8tydy8oIdfTviTtGyPqoiNM+LenfF8fb1SY0sw
	xpvYm0HOhIzIW5pSrihY9Zuv/ATaG+/D7caZk+3gtRoKXxIQ5ewqufPXMufvjkub+lxYsb
	4O6Ao8oIgJVcMi1hSEBBpE+D5TeMLgFkBAPoUrpPBaRuz3zGo4UCmYezFM2Y1gU3y8ApIt
	OWCwAckjldXzhb3vzdBBJMecMBLJ3JxsNymT0FXuxt6Bcexi6+nk/P1iFbtlqg==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1700950110; a=rsa-sha256;
	cv=none;
	b=nVevavmE9P3J25YcZJzz5xkptrbs8hm6ecAGNjorchcCXzwbR1M4LEO6Lh88cD0MetHzL9
	vjHgouDyzWChylfpfCVgwTSDHG6fUpANYJwz9gJ3hJ5hHM1Jpv2No3k0J1+A/VWJ9ew7e+
	/nZ6AT/keqsouLouRnIH/HM5ifzKchWb8CGzY++gULW+0/UxWHWWAkDyH5tIZunCJy8RcG
	x/ukJ8qku65WVa3A2WJU88hPMplxWj2zT7my6fjqTn/XWW52Ohlas+333lFqlsMvbVqMa+
	uD7ldbskhk+j2Vo7GU6jNAObNS8y2rWk+pmZ+PrH0yFvsSr/s1BjCw3a1Wc1kw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700950110; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ASn7MPpX45MTA6pb9S4q5N63BdZZEwDudBfiOd0n6jI=;
	b=qU30wf2n16z/lfE8c6igSGni1H0z87woBhIoKO1tJR/QOJSEVd6WcEjzDSZEez5k/L+aQW
	M2JWrvZL5vN9qoprfP/RAHbWjfSR8H8jgiFG8+1PyQly/koUebH2rkbMq+ZK8TKu9nPFBi
	vksdErmlK7XLsGd5O+L3ecBp5fdd8fZ6JSznzh4txGYNQSIS/TIaTE5wJdY/bCs9YnWYh0
	f0pt1bK+b6YJaPUlOLI9fS7xfyKQ/rNRbPTk0JggIrmwbLlaYzzojzLMOiTRTtvYiY7U+Y
	OT/S2NiaFB3JsonSymXZ0KLXZE+z2cLFS9tEUmkhJ84fy4I4NVJ+rJab+3iT7g==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 2/8] smb: client: allow creating special files via reparse points
Date: Sat, 25 Nov 2023 19:08:07 -0300
Message-ID: <20231125220813.30538-3-pc@manguebit.com>
In-Reply-To: <20231125220813.30538-1-pc@manguebit.com>
References: <20231125220813.30538-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for creating special files (e.g. char/block devices,
sockets, fifos) via NFS reparse points on SMB2+, which are fully
supported by most SMB servers and documented in MS-FSCC.

smb2_get_reparse_inode() creates the file with a corresponding reparse
point buffer set in @iov through a single roundtrip to the server.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/cifsproto.h |  8 +++-
 fs/smb/client/dir.c       |  7 +--
 fs/smb/client/file.c      | 10 +++--
 fs/smb/client/inode.c     | 74 +++++++++++++++++++-----------
 fs/smb/client/link.c      | 10 +++--
 fs/smb/client/smb2glob.h  | 25 ++++++-----
 fs/smb/client/smb2inode.c | 75 +++++++++++++++++++++++++++++++
 fs/smb/client/smb2ops.c   | 94 +++++++++++++++++++++++++++++++++++----
 fs/smb/client/smb2proto.h |  7 +++
 fs/smb/client/trace.h     |  4 +-
 10 files changed, 255 insertions(+), 59 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 46feaa0880bd..0adeaa84b662 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -211,8 +211,12 @@ int cifs_get_inode_info(struct inode **inode, const char *full_path,
 bool cifs_reparse_point_to_fattr(struct cifs_sb_info *cifs_sb,
 				 struct cifs_fattr *fattr,
 				 struct cifs_open_info_data *data);
-extern int smb311_posix_get_inode_info(struct inode **pinode, const char *search_path,
-			struct super_block *sb, unsigned int xid);
+
+extern int smb311_posix_get_inode_info(struct inode **inode,
+				       const char *full_path,
+				       struct cifs_open_info_data *data,
+				       struct super_block *sb,
+				       const unsigned int xid);
 extern int cifs_get_inode_info_unix(struct inode **pinode,
 			const unsigned char *search_path,
 			struct super_block *sb, unsigned int xid);
diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index 580a27a3a7e6..89333d9bce36 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -680,9 +680,10 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 		 full_path, d_inode(direntry));
 
 again:
-	if (pTcon->posix_extensions)
-		rc = smb311_posix_get_inode_info(&newInode, full_path, parent_dir_inode->i_sb, xid);
-	else if (pTcon->unix_ext) {
+	if (pTcon->posix_extensions) {
+		rc = smb311_posix_get_inode_info(&newInode, full_path, NULL,
+						 parent_dir_inode->i_sb, xid);
+	} else if (pTcon->unix_ext) {
 		rc = cifs_get_inode_info_unix(&newInode, full_path,
 					      parent_dir_inode->i_sb, xid);
 	} else {
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index cf17e3dd703e..2b69c4e79b17 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1020,14 +1020,16 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flush)
 		if (!is_interrupt_error(rc))
 			mapping_set_error(inode->i_mapping, rc);
 
-		if (tcon->posix_extensions)
-			rc = smb311_posix_get_inode_info(&inode, full_path, inode->i_sb, xid);
-		else if (tcon->unix_ext)
+		if (tcon->posix_extensions) {
+			rc = smb311_posix_get_inode_info(&inode, full_path,
+							 NULL, inode->i_sb, xid);
+		} else if (tcon->unix_ext) {
 			rc = cifs_get_inode_info_unix(&inode, full_path,
 						      inode->i_sb, xid);
-		else
+		} else {
 			rc = cifs_get_inode_info(&inode, full_path, NULL,
 						 inode->i_sb, xid, NULL);
+		}
 	}
 	/*
 	 * Else we are writing out data to server already and could deadlock if
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 47f49be69ced..7baa02940bce 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1059,7 +1059,9 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
 				 const unsigned int xid,
 				 struct cifs_tcon *tcon,
 				 const char *full_path,
-				 struct cifs_fattr *fattr)
+				 struct cifs_fattr *fattr,
+				 struct cifs_sid *owner,
+				 struct cifs_sid *group)
 {
 	struct TCP_Server_Info *server = tcon->ses->server;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
@@ -1090,7 +1092,8 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
 		rc = 0;
 		goto out;
 	default:
-		if (data->symlink_target) {
+		/* Check for cached reparse point data */
+		if (data->symlink_target || data->reparse.buf) {
 			rc = 0;
 		} else if (server->ops->parse_reparse_point) {
 			rc = server->ops->parse_reparse_point(cifs_sb,
@@ -1099,7 +1102,10 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
 		break;
 	}
 
-	cifs_open_info_to_fattr(fattr, data, sb);
+	if (tcon->posix_extensions)
+		smb311_posix_info_to_fattr(fattr, data, owner, group, sb);
+	else
+		cifs_open_info_to_fattr(fattr, data, sb);
 out:
 	free_rsp_buf(rsp_buftype, rsp_iov.iov_base);
 	return rc;
@@ -1150,7 +1156,8 @@ static int cifs_get_fattr(struct cifs_open_info_data *data,
 		 */
 		if (cifs_open_data_reparse(data)) {
 			rc = reparse_info_to_fattr(data, sb, xid, tcon,
-						   full_path, fattr);
+						   full_path, fattr,
+						   NULL, NULL);
 		} else {
 			cifs_open_info_to_fattr(fattr, data, sb);
 		}
@@ -1288,12 +1295,13 @@ int cifs_get_inode_info(struct inode **inode,
 	return rc;
 }
 
-static int smb311_posix_get_fattr(struct cifs_fattr *fattr,
+static int smb311_posix_get_fattr(struct cifs_open_info_data *data,
+				  struct cifs_fattr *fattr,
 				  const char *full_path,
 				  struct super_block *sb,
 				  const unsigned int xid)
 {
-	struct cifs_open_info_data data = {};
+	struct cifs_open_info_data tmp_data = {};
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifs_tcon *tcon;
 	struct tcon_link *tlink;
@@ -1307,12 +1315,14 @@ static int smb311_posix_get_fattr(struct cifs_fattr *fattr,
 	tcon = tlink_tcon(tlink);
 
 	/*
-	 * 1. Fetch file metadata
+	 * 1. Fetch file metadata if not provided (data)
 	 */
-
-	rc = smb311_posix_query_path_info(xid, tcon, cifs_sb,
-					  full_path, &data,
-					  &owner, &group);
+	if (!data) {
+		rc = smb311_posix_query_path_info(xid, tcon, cifs_sb,
+						  full_path, &tmp_data,
+						  &owner, &group);
+		data = &tmp_data;
+	}
 
 	/*
 	 * 2. Convert it to internal cifs metadata (fattr)
@@ -1320,7 +1330,14 @@ static int smb311_posix_get_fattr(struct cifs_fattr *fattr,
 
 	switch (rc) {
 	case 0:
-		smb311_posix_info_to_fattr(fattr, &data, &owner, &group, sb);
+		if (cifs_open_data_reparse(data)) {
+			rc = reparse_info_to_fattr(data, sb, xid, tcon,
+						   full_path, fattr,
+						   &owner, &group);
+		} else {
+			smb311_posix_info_to_fattr(fattr, data,
+						   &owner, &group, sb);
+		}
 		break;
 	case -EREMOTE:
 		/* DFS link, no metadata available on this server */
@@ -1351,12 +1368,15 @@ static int smb311_posix_get_fattr(struct cifs_fattr *fattr,
 
 out:
 	cifs_put_tlink(tlink);
-	cifs_free_open_info(&data);
+	cifs_free_open_info(data);
 	return rc;
 }
 
-int smb311_posix_get_inode_info(struct inode **inode, const char *full_path,
-				struct super_block *sb, const unsigned int xid)
+int smb311_posix_get_inode_info(struct inode **inode,
+				const char *full_path,
+				struct cifs_open_info_data *data,
+				struct super_block *sb,
+				const unsigned int xid)
 {
 	struct cifs_fattr fattr = {};
 	int rc;
@@ -1366,7 +1386,7 @@ int smb311_posix_get_inode_info(struct inode **inode, const char *full_path,
 		return 0;
 	}
 
-	rc = smb311_posix_get_fattr(&fattr, full_path, sb, xid);
+	rc = smb311_posix_get_fattr(data, &fattr, full_path, sb, xid);
 	if (rc)
 		goto out;
 
@@ -1514,7 +1534,7 @@ struct inode *cifs_root_iget(struct super_block *sb)
 
 	convert_delimiter(path, CIFS_DIR_SEP(cifs_sb));
 	if (tcon->posix_extensions)
-		rc = smb311_posix_get_fattr(&fattr, path, sb, xid);
+		rc = smb311_posix_get_fattr(NULL, &fattr, path, sb, xid);
 	else
 		rc = cifs_get_fattr(NULL, sb, xid, NULL, &fattr, &inode, path);
 
@@ -1887,16 +1907,18 @@ cifs_mkdir_qinfo(struct inode *parent, struct dentry *dentry, umode_t mode,
 	int rc = 0;
 	struct inode *inode = NULL;
 
-	if (tcon->posix_extensions)
-		rc = smb311_posix_get_inode_info(&inode, full_path, parent->i_sb, xid);
+	if (tcon->posix_extensions) {
+		rc = smb311_posix_get_inode_info(&inode, full_path,
+						 NULL, parent->i_sb, xid);
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
-	else if (tcon->unix_ext)
+	} else if (tcon->unix_ext) {
 		rc = cifs_get_inode_info_unix(&inode, full_path, parent->i_sb,
 					      xid);
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
-	else
+	} else {
 		rc = cifs_get_inode_info(&inode, full_path, NULL, parent->i_sb,
 					 xid, NULL);
+	}
 
 	if (rc)
 		return rc;
@@ -2577,13 +2599,15 @@ int cifs_revalidate_dentry_attr(struct dentry *dentry)
 		 dentry, cifs_get_time(dentry), jiffies);
 
 again:
-	if (cifs_sb_master_tcon(CIFS_SB(sb))->posix_extensions)
-		rc = smb311_posix_get_inode_info(&inode, full_path, sb, xid);
-	else if (cifs_sb_master_tcon(CIFS_SB(sb))->unix_ext)
+	if (cifs_sb_master_tcon(CIFS_SB(sb))->posix_extensions) {
+		rc = smb311_posix_get_inode_info(&inode, full_path,
+						 NULL, sb, xid);
+	} else if (cifs_sb_master_tcon(CIFS_SB(sb))->unix_ext) {
 		rc = cifs_get_inode_info_unix(&inode, full_path, sb, xid);
-	else
+	} else {
 		rc = cifs_get_inode_info(&inode, full_path, NULL, sb,
 					 xid, NULL);
+	}
 	if (rc == -EAGAIN && count++ < 10)
 		goto again;
 out:
diff --git a/fs/smb/client/link.c b/fs/smb/client/link.c
index a1da50e66fbb..5ce0f74be4ec 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -614,14 +614,16 @@ cifs_symlink(struct mnt_idmap *idmap, struct inode *inode,
 					cifs_sb_target->local_nls); */
 
 	if (rc == 0) {
-		if (pTcon->posix_extensions)
-			rc = smb311_posix_get_inode_info(&newinode, full_path, inode->i_sb, xid);
-		else if (pTcon->unix_ext)
+		if (pTcon->posix_extensions) {
+			rc = smb311_posix_get_inode_info(&newinode, full_path,
+							 NULL, inode->i_sb, xid);
+		} else if (pTcon->unix_ext) {
 			rc = cifs_get_inode_info_unix(&newinode, full_path,
 						      inode->i_sb, xid);
-		else
+		} else {
 			rc = cifs_get_inode_info(&newinode, full_path, NULL,
 						 inode->i_sb, xid, NULL);
+		}
 
 		if (rc != 0) {
 			cifs_dbg(FYI, "Create symlink ok, getinodeinfo fail rc = %d\n",
diff --git a/fs/smb/client/smb2glob.h b/fs/smb/client/smb2glob.h
index 82e916ad167c..ca87a0011c33 100644
--- a/fs/smb/client/smb2glob.h
+++ b/fs/smb/client/smb2glob.h
@@ -23,17 +23,20 @@
  * Identifiers for functions that use the open, operation, close pattern
  * in smb2inode.c:smb2_compound_op()
  */
-#define SMB2_OP_SET_DELETE 1
-#define SMB2_OP_SET_INFO 2
-#define SMB2_OP_QUERY_INFO 3
-#define SMB2_OP_QUERY_DIR 4
-#define SMB2_OP_MKDIR 5
-#define SMB2_OP_RENAME 6
-#define SMB2_OP_DELETE 7
-#define SMB2_OP_HARDLINK 8
-#define SMB2_OP_SET_EOF 9
-#define SMB2_OP_RMDIR 10
-#define SMB2_OP_POSIX_QUERY_INFO 11
+enum smb2_compound_ops {
+	SMB2_OP_SET_DELETE = 1,
+	SMB2_OP_SET_INFO,
+	SMB2_OP_QUERY_INFO,
+	SMB2_OP_QUERY_DIR,
+	SMB2_OP_MKDIR,
+	SMB2_OP_RENAME,
+	SMB2_OP_DELETE,
+	SMB2_OP_HARDLINK,
+	SMB2_OP_SET_EOF,
+	SMB2_OP_RMDIR,
+	SMB2_OP_POSIX_QUERY_INFO,
+	SMB2_OP_SET_REPARSE
+};
 
 /* Used when constructing chained read requests. */
 #define CHAINED_REQUEST 1
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 98fa4f02fbd3..d662bad3b703 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -347,6 +347,22 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 			smb2_set_related(&rqst[num_rqst++]);
 			trace_smb3_hardlink_enter(xid, ses->Suid, tcon->tid, full_path);
 			break;
+		case SMB2_OP_SET_REPARSE:
+			rqst[num_rqst].rq_iov = vars->io_iov;
+			rqst[num_rqst].rq_nvec = ARRAY_SIZE(vars->io_iov);
+
+			rc = SMB2_ioctl_init(tcon, server, &rqst[num_rqst],
+					     COMPOUND_FID, COMPOUND_FID,
+					     FSCTL_SET_REPARSE_POINT,
+					     in_iov[i].iov_base,
+					     in_iov[i].iov_len, 0);
+			if (rc)
+				goto finished;
+			smb2_set_next_command(tcon, &rqst[num_rqst]);
+			smb2_set_related(&rqst[num_rqst++]);
+			trace_smb3_set_reparse_compound_enter(xid, ses->Suid,
+							      tcon->tid, full_path);
+			break;
 		default:
 			cifs_dbg(VFS, "Invalid command\n");
 			rc = -EINVAL;
@@ -503,6 +519,16 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 								  tcon->tid);
 			SMB2_set_info_free(&rqst[num_rqst++]);
 			break;
+		case SMB2_OP_SET_REPARSE:
+			if (rc) {
+				trace_smb3_set_reparse_compound_err(xid,  ses->Suid,
+								    tcon->tid, rc);
+			} else {
+				trace_smb3_set_reparse_compound_done(xid, ses->Suid,
+								     tcon->tid);
+			}
+			SMB2_ioctl_free(&rqst[num_rqst++]);
+			break;
 		}
 	}
 	SMB2_close_free(&rqst[num_rqst]);
@@ -887,3 +913,52 @@ smb2_set_file_info(struct inode *inode, const char *full_path,
 	cifs_put_tlink(tlink);
 	return rc;
 }
+
+struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
+				     struct super_block *sb,
+				     const unsigned int xid,
+				     struct cifs_tcon *tcon,
+				     const char *full_path,
+				     struct kvec *iov)
+{
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	struct cifsFileInfo *cfile;
+	struct inode *new = NULL;
+	struct kvec in_iov[2];
+	int cmds[2];
+	int da, co, cd;
+	int rc;
+
+	da = SYNCHRONIZE | DELETE |
+		FILE_READ_ATTRIBUTES |
+		FILE_WRITE_ATTRIBUTES;
+	co = CREATE_NOT_DIR | OPEN_REPARSE_POINT;
+	cd = FILE_CREATE;
+	cmds[0] = SMB2_OP_SET_REPARSE;
+	in_iov[0] = *iov;
+	in_iov[1].iov_base = data;
+	in_iov[1].iov_len = sizeof(*data);
+
+	if (tcon->posix_extensions) {
+		cmds[1] = SMB2_OP_POSIX_QUERY_INFO;
+		cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
+		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
+				      da, cd, co, ACL_NO_MODE, in_iov,
+				      cmds, 2, cfile, NULL, NULL, NULL, NULL);
+		if (!rc) {
+			rc = smb311_posix_get_inode_info(&new, full_path,
+							 data, sb, xid);
+		}
+	} else {
+		cmds[1] = SMB2_OP_QUERY_INFO;
+		cifs_get_writable_path(tcon, full_path, FIND_WR_ANY, &cfile);
+		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
+				      da, cd, co, ACL_NO_MODE, in_iov,
+				      cmds, 2, cfile, NULL, NULL, NULL, NULL);
+		if (!rc) {
+			rc = cifs_get_inode_info(&new, full_path,
+						 data, sb, xid, NULL);
+		}
+	}
+	return rc ? ERR_PTR(rc) : new;
+}
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 82ab62fd0040..c1fe7ba02f6f 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5133,11 +5133,88 @@ int cifs_sfu_make_node(unsigned int xid, struct inode *inode,
 	return rc;
 }
 
+static inline u64 mode_nfs_type(mode_t mode)
+{
+	switch (mode & S_IFMT) {
+	case S_IFBLK: return NFS_SPECFILE_BLK;
+	case S_IFCHR: return NFS_SPECFILE_CHR;
+	case S_IFIFO: return NFS_SPECFILE_FIFO;
+	case S_IFSOCK: return NFS_SPECFILE_SOCK;
+	}
+	return 0;
+}
+
+static int nfs_set_reparse_buf(struct reparse_posix_data *buf,
+			       mode_t mode, dev_t dev,
+			       struct kvec *iov)
+{
+	u64 type;
+	u16 len, dlen;
+
+	len = sizeof(*buf);
+
+	switch ((type = mode_nfs_type(mode))) {
+	case NFS_SPECFILE_BLK:
+	case NFS_SPECFILE_CHR:
+		dlen = sizeof(__le64);
+		break;
+	case NFS_SPECFILE_FIFO:
+	case NFS_SPECFILE_SOCK:
+		dlen = 0;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	buf->ReparseTag = cpu_to_le32(IO_REPARSE_TAG_NFS);
+	buf->Reserved = 0;
+	buf->InodeType = cpu_to_le64(type);
+	buf->ReparseDataLength = cpu_to_le16(len + dlen -
+					     sizeof(struct reparse_data_buffer));
+	*(__le64 *)buf->DataBuffer = cpu_to_le64(((u64)MAJOR(dev) << 32) |
+						 MINOR(dev));
+	iov->iov_base = buf;
+	iov->iov_len = len + dlen;
+	return 0;
+}
+
+static int nfs_make_node(unsigned int xid, struct inode *inode,
+			 struct dentry *dentry, struct cifs_tcon *tcon,
+			 const char *full_path, umode_t mode, dev_t dev)
+{
+	struct cifs_open_info_data data;
+	struct reparse_posix_data *p;
+	struct inode *new;
+	struct kvec iov;
+	__u8 buf[sizeof(*p) + sizeof(__le64)];
+	int rc;
+
+	p = (struct reparse_posix_data *)buf;
+	rc = nfs_set_reparse_buf(p, mode, dev, &iov);
+	if (rc)
+		return rc;
+
+	data = (struct cifs_open_info_data) {
+		.reparse_point = true,
+		.reparse = { .tag = IO_REPARSE_TAG_NFS, .posix = p, },
+	};
+
+	new = smb2_get_reparse_inode(&data, inode->i_sb, xid,
+				     tcon, full_path, &iov);
+	if (!IS_ERR(new))
+		d_instantiate(dentry, new);
+	else
+		rc = PTR_ERR(new);
+	cifs_free_open_info(&data);
+	return rc;
+}
+
 static int smb2_make_node(unsigned int xid, struct inode *inode,
 			  struct dentry *dentry, struct cifs_tcon *tcon,
 			  const char *full_path, umode_t mode, dev_t dev)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	int rc;
 
 	/*
 	 * Check if mounted with mount parm 'sfu' mount parm.
@@ -5145,15 +5222,14 @@ static int smb2_make_node(unsigned int xid, struct inode *inode,
 	 * supports block and char device (no socket & fifo),
 	 * and was used by default in earlier versions of Windows
 	 */
-	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
-		return -EPERM;
-	/*
-	 * TODO: Add ability to create instead via reparse point. Windows (e.g.
-	 * their current NFS server) uses this approach to expose special files
-	 * over SMB2/SMB3 and Samba will do this with SMB3.1.1 POSIX Extensions
-	 */
-	return cifs_sfu_make_node(xid, inode, dentry, tcon,
-				  full_path, mode, dev);
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
+		rc = cifs_sfu_make_node(xid, inode, dentry, tcon,
+					full_path, mode, dev);
+	} else {
+		rc = nfs_make_node(xid, inode, dentry, tcon,
+				   full_path, mode, dev);
+	}
+	return rc;
 }
 
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
diff --git a/fs/smb/client/smb2proto.h b/fs/smb/client/smb2proto.h
index 46eff9ec302a..d4b2b339fdc3 100644
--- a/fs/smb/client/smb2proto.h
+++ b/fs/smb/client/smb2proto.h
@@ -56,6 +56,12 @@ extern int smb3_handle_read_data(struct TCP_Server_Info *server,
 extern int smb2_query_reparse_tag(const unsigned int xid, struct cifs_tcon *tcon,
 				struct cifs_sb_info *cifs_sb, const char *path,
 				__u32 *reparse_tag);
+struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
+				     struct super_block *sb,
+				     const unsigned int xid,
+				     struct cifs_tcon *tcon,
+				     const char *full_path,
+				     struct kvec *iov);
 int smb2_query_path_info(const unsigned int xid,
 			 struct cifs_tcon *tcon,
 			 struct cifs_sb_info *cifs_sb,
@@ -287,4 +293,5 @@ int smb311_posix_query_path_info(const unsigned int xid,
 int posix_info_parse(const void *beg, const void *end,
 		     struct smb2_posix_info_parsed *out);
 int posix_info_sid_size(const void *beg, const void *end);
+
 #endif			/* _SMB2PROTO_H */
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index de199ec9f726..34f507584274 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -370,11 +370,11 @@ DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(rename_enter);
 DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(rmdir_enter);
 DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(set_eof_enter);
 DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(set_info_compound_enter);
+DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(set_reparse_compound_enter);
 DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(delete_enter);
 DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(mkdir_enter);
 DEFINE_SMB3_INF_COMPOUND_ENTER_EVENT(tdis_enter);
 
-
 DECLARE_EVENT_CLASS(smb3_inf_compound_done_class,
 	TP_PROTO(unsigned int xid,
 		__u32	tid,
@@ -408,6 +408,7 @@ DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(rename_done);
 DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(rmdir_done);
 DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(set_eof_done);
 DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(set_info_compound_done);
+DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(set_reparse_compound_done);
 DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(delete_done);
 DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(mkdir_done);
 DEFINE_SMB3_INF_COMPOUND_DONE_EVENT(tdis_done);
@@ -451,6 +452,7 @@ DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(rename_err);
 DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(rmdir_err);
 DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(set_eof_err);
 DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(set_info_compound_err);
+DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(set_reparse_compound_err);
 DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(mkdir_err);
 DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(delete_err);
 DEFINE_SMB3_INF_COMPOUND_ERR_EVENT(tdis_err);
-- 
2.43.0

