From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH 1/4] cifs: cleanup cifs_filldir
Date: Sat, 16 Jul 2011 15:23:49 -0400
Message-ID: <20110716192349.GA26925@infradead.org>
References: <20110716192334.GA26847@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110716192334.GA26847-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Use sensible variable names and formatting and remove some superflous
checks on entry.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Index: linux-2.6/fs/cifs/readdir.c
===================================================================
--- linux-2.6.orig/fs/cifs/readdir.c	2011-05-22 13:13:40.748945551 +0200
+++ linux-2.6/fs/cifs/readdir.c	2011-05-22 13:16:29.743946544 +0200
@@ -681,57 +681,49 @@ static int cifs_get_name_from_search_buf
 	return rc;
 }
 
-static int cifs_filldir(char *pfindEntry, struct file *file, filldir_t filldir,
-			void *direntry, char *scratch_buf, unsigned int max_len)
+static int cifs_filldir(char *find_entry, struct file *file, filldir_t filldir,
+		void *dirent, char *scratch_buf, unsigned int max_len)
 {
-	int rc = 0;
-	struct qstr qstring;
-	struct cifsFileInfo *pCifsF;
-	u64    inum;
-	ino_t  ino;
-	struct super_block *sb;
-	struct cifs_sb_info *cifs_sb;
-	struct dentry *tmp_dentry;
+	struct cifsFileInfo *file_info = file->private_data;
+	struct super_block *sb = file->f_path.dentry->d_sb;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifs_fattr fattr;
+	struct dentry *dentry;
+	struct qstr name;
+	int rc = 0;
+	u64 inum;
+	ino_t ino;
 
-	/* get filename and len into qstring */
-	/* get dentry */
-	/* decide whether to create and populate ionde */
-	if ((direntry == NULL) || (file == NULL))
-		return -EINVAL;
-
-	pCifsF = file->private_data;
-
-	if ((scratch_buf == NULL) || (pfindEntry == NULL) || (pCifsF == NULL))
-		return -ENOENT;
-
-	rc = cifs_entry_is_dot(pfindEntry, pCifsF);
 	/* skip . and .. since we added them first */
+	rc = cifs_entry_is_dot(find_entry, file_info);
 	if (rc != 0)
 		return 0;
 
-	sb = file->f_path.dentry->d_sb;
-	cifs_sb = CIFS_SB(sb);
-
-	qstring.name = scratch_buf;
-	rc = cifs_get_name_from_search_buf(&qstring, pfindEntry,
-			pCifsF->srch_inf.info_level,
-			pCifsF->srch_inf.unicode, cifs_sb,
-			max_len, &inum /* returned */);
-
+	name.name = scratch_buf;
+	rc = cifs_get_name_from_search_buf(&name, find_entry,
+					   file_info->srch_inf.info_level,
+					   file_info->srch_inf.unicode,
+					   cifs_sb, max_len, &inum);
 	if (rc)
 		return rc;
 
-	if (pCifsF->srch_inf.info_level == SMB_FIND_FILE_UNIX)
+	switch (file_info->srch_inf.info_level) {
+	case SMB_FIND_FILE_UNIX:
 		cifs_unix_basic_to_fattr(&fattr,
-				 &((FILE_UNIX_INFO *) pfindEntry)->basic,
-				 cifs_sb);
-	else if (pCifsF->srch_inf.info_level == SMB_FIND_FILE_INFO_STANDARD)
-		cifs_std_info_to_fattr(&fattr, (FIND_FILE_STANDARD_INFO *)
-					pfindEntry, cifs_sb);
-	else
-		cifs_dir_info_to_fattr(&fattr, (FILE_DIRECTORY_INFO *)
-					pfindEntry, cifs_sb);
+					 &((FILE_UNIX_INFO *)find_entry)->basic,
+					 cifs_sb);
+		break;
+	case SMB_FIND_FILE_INFO_STANDARD:
+		cifs_std_info_to_fattr(&fattr,
+				       (FIND_FILE_STANDARD_INFO *)find_entry,
+				       cifs_sb);
+		break;
+	default:
+		cifs_dir_info_to_fattr(&fattr,
+				       (FILE_DIRECTORY_INFO *)find_entry,
+				       cifs_sb);
+		break;
+	}
 
 	if (inum && (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
 		fattr.cf_uniqueid = inum;
@@ -750,12 +742,12 @@ static int cifs_filldir(char *pfindEntry
 		fattr.cf_flags |= CIFS_FATTR_NEED_REVAL;
 
 	ino = cifs_uniqueid_to_ino_t(fattr.cf_uniqueid);
-	tmp_dentry = cifs_readdir_lookup(file->f_dentry, &qstring, &fattr);
+	dentry = cifs_readdir_lookup(file->f_dentry, &name, &fattr);
 
-	rc = filldir(direntry, qstring.name, qstring.len, file->f_pos,
-		     ino, fattr.cf_dtype);
+	rc = filldir(dirent, name.name, name.len, file->f_pos, ino,
+		     fattr.cf_dtype);
 
-	dput(tmp_dentry);
+	dput(dentry);
 	return rc;
 }
 
