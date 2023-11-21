Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="A9mm6rk5"
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA25E97
	for <linux-cifs@vger.kernel.org>; Tue, 21 Nov 2023 15:13:18 -0800 (PST)
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700608397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ji4+ahOvS8M4dU41GB8m91a4Z6TH23q9ypTuE0Oz5MU=;
	b=A9mm6rk59/LDX8U52oC4okZzy8KqXkk01E3/A8wyj7/Zktf0wLQp3bPsqz8HZGNz7F5rM0
	fKfGpuYdeR5Bw2v95QlQp9+BoX4TwPiqUS0mMQI9H0f2v8BhWWQTrR6hLbwU2FbS/v5C6b
	JtandOshUUaIS9JFTmAD0M7e3KYiGN1TfXuoup4vo+z5GjZAhDZeKPdemuFjbFryw8DoR2
	pAZArtOc/6iVMx6lD+5jkdV5DfUWG0LiLITEFtoqu1aQhOZKs0BCs5FLAkeug81MPMA9r4
	SWoCS9NpoUXAOpLrK+sFBiRgllj68/e/s03VVYtBSoLQFSXa3Mo+z3waAt8NvQ==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1700608397; a=rsa-sha256;
	cv=none;
	b=WZnc/HLbsplPwNQ4YrNjgeHMqL9IzJ6K7A8PWnMbx3fA99vgjBo8cTuZtBxhg0KNLsgD5N
	q8eFYhrncdNiVx8nzNrSIkoxrqQ4o28qox815+QHI2PqN0NUsV3A1+B1TLL8NYGvICTedR
	dGk6LtS+2HWeBOJtxTTofsP/C2cigOdTBxoSh+Mhf2FZ2sQDQdCliPckfjkqcn0acgblYI
	LksdbeLx/4zy2m5ufBcy549P4XoOPlsbl/4Vgxdj4pendF5yK5ANMFAAL44dbYKoHfhDzb
	QgdWF5fECG05p3q40Yp6JcuZf3IHI+cq3JPnpi0yaJPuXKU7n3ixm5Hp5XVE/g==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700608397; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ji4+ahOvS8M4dU41GB8m91a4Z6TH23q9ypTuE0Oz5MU=;
	b=h/2DurWpQLB9L0SvKVgs3GJPUumpFV3kss25v5KveZVN4vxVqKQn0MzVVCxgEsayqnfd/5
	5tLZWv6i03xap9XwcyRm3mDfzEUqpdWzQ956LEm/JnNdvjuxOUi28U4dHNH3WFC4duO4n5
	58SN2Pr1g+e5IuAtTqhlvTA5O0m9Wrg0CuqNHdbEu82RHLEq5rvloWo9jLhrtiAZ1gu4uU
	sPplXuW4QEzJDESAAm1IDCc5nHoPLiwvGPWOQQNVrXfAY34Imj9D/jSFxkv6qaAvWEYwz8
	DUJ9MqDuAOmLsdI3VM//K2JdBkTe9kFHDWa9AiSoBuhCpneHMMbL0LHKlMNdiQ==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 7/7] smb: client: handle reparse points over SMB3 POSIX
Date: Tue, 21 Nov 2023 20:12:58 -0300
Message-ID: <20231121231258.29562-7-pc@manguebit.com>
In-Reply-To: <20231121231258.29562-1-pc@manguebit.com>
References: <20231119182209.5140-1-pc@manguebit.com>
 <20231121231258.29562-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for creating and listing special files via reparse points
when using SMB3 POSIX extensions.

Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
---
 fs/smb/client/cifsproto.h |  8 +++--
 fs/smb/client/dir.c       |  7 ++--
 fs/smb/client/file.c      | 10 +++---
 fs/smb/client/inode.c     | 71 ++++++++++++++++++++++++++-------------
 fs/smb/client/link.c      | 10 +++---
 fs/smb/client/smb2inode.c | 21 ++++++++----
 6 files changed, 84 insertions(+), 43 deletions(-)

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
index 88b7cf23348c..7baa02940bce 100644
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
@@ -1100,7 +1102,10 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
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
@@ -1151,7 +1156,8 @@ static int cifs_get_fattr(struct cifs_open_info_data *data,
 		 */
 		if (cifs_open_data_reparse(data)) {
 			rc = reparse_info_to_fattr(data, sb, xid, tcon,
-						   full_path, fattr);
+						   full_path, fattr,
+						   NULL, NULL);
 		} else {
 			cifs_open_info_to_fattr(fattr, data, sb);
 		}
@@ -1289,12 +1295,13 @@ int cifs_get_inode_info(struct inode **inode,
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
@@ -1308,12 +1315,14 @@ static int smb311_posix_get_fattr(struct cifs_fattr *fattr,
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
@@ -1321,7 +1330,14 @@ static int smb311_posix_get_fattr(struct cifs_fattr *fattr,
 
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
@@ -1352,12 +1368,15 @@ static int smb311_posix_get_fattr(struct cifs_fattr *fattr,
 
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
@@ -1367,7 +1386,7 @@ int smb311_posix_get_inode_info(struct inode **inode, const char *full_path,
 		return 0;
 	}
 
-	rc = smb311_posix_get_fattr(&fattr, full_path, sb, xid);
+	rc = smb311_posix_get_fattr(data, &fattr, full_path, sb, xid);
 	if (rc)
 		goto out;
 
@@ -1515,7 +1534,7 @@ struct inode *cifs_root_iget(struct super_block *sb)
 
 	convert_delimiter(path, CIFS_DIR_SEP(cifs_sb));
 	if (tcon->posix_extensions)
-		rc = smb311_posix_get_fattr(&fattr, path, sb, xid);
+		rc = smb311_posix_get_fattr(NULL, &fattr, path, sb, xid);
 	else
 		rc = cifs_get_fattr(NULL, sb, xid, NULL, &fattr, &inode, path);
 
@@ -1888,16 +1907,18 @@ cifs_mkdir_qinfo(struct inode *parent, struct dentry *dentry, umode_t mode,
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
@@ -2578,13 +2599,15 @@ int cifs_revalidate_dentry_attr(struct dentry *dentry)
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
index 5c91376d1c1f..82fb069c6ce4 100644
--- a/fs/smb/client/link.c
+++ b/fs/smb/client/link.c
@@ -619,14 +619,16 @@ cifs_symlink(struct mnt_idmap *idmap, struct inode *inode,
 	}
 
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
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index c09da386a36b..0d2c58e5051b 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -540,14 +540,23 @@ struct inode *smb2_get_reparse_inode(struct cifs_open_info_data *data,
 	struct inode *new = NULL;
 	int rc;
 
+	/*
+	 * Since we know it is a reparse point already, query info it
+	 * directly and provide cached file metadata to *get_inode_info() calls
+	 * in order to avoid extra roundtrips.
+	 */
 	if (tcon->posix_extensions) {
-		rc = smb311_posix_get_inode_info(&new, full_path, sb, xid);
+		cifs_get_readable_path(tcon, full_path, &cfile);
+		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
+				      FILE_READ_ATTRIBUTES, FILE_OPEN,
+				      OPEN_REPARSE_POINT, ACL_NO_MODE, data,
+				      SMB2_OP_POSIX_QUERY_INFO, cfile, NULL,
+				      NULL, NULL, NULL);
+		if (rc)
+			return ERR_PTR(rc);
+		rc = smb311_posix_get_inode_info(&new, full_path,
+						 data, sb, xid);
 	} else {
-		/*
-		 * Since we know it is a reparse point already, query info it
-		 * directly and provide cached file metadata to
-		 * cifs_get_inode_info() in order to avoid extra roundtrips.
-		 */
 		cifs_get_readable_path(tcon, full_path, &cfile);
 		rc = smb2_compound_op(xid, tcon, cifs_sb, full_path,
 				      FILE_READ_ATTRIBUTES, FILE_OPEN,
-- 
2.42.1

