From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH 2/4] cifs: introduce cifs_dirent
Date: Sat, 16 Jul 2011 15:24:05 -0400
Message-ID: <20110716192405.GB26925@infradead.org>
References: <20110716192334.GA26847@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110716192334.GA26847-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Introduce a generic directory entry structure, and factor the parsing
of the various on the wire structures that can represent one into
a common helper.  Switch cifs_entry_is_dot over to use it as a start.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Index: linux-2.6/fs/cifs/readdir.c
===================================================================
--- linux-2.6.orig/fs/cifs/readdir.c	2011-05-22 13:16:29.743946544 +0200
+++ linux-2.6/fs/cifs/readdir.c	2011-05-22 13:23:51.096946749 +0200
@@ -4,6 +4,7 @@
  *   Directory search handling
  *
  *   Copyright (C) International Business Machines  Corp., 2004, 2008
+ *   Copyright (C) Red Hat, Inc., 2011
  *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
  *
  *   This library is free software; you can redistribute it and/or modify
@@ -290,10 +291,10 @@ error_exit:
 }
 
 /* return length of unicode string in bytes */
-static int cifs_unicode_bytelen(char *str)
+static int cifs_unicode_bytelen(const char *str)
 {
 	int len;
-	__le16 *ustr = (__le16 *)str;
+	const __le16 *ustr = (const __le16 *)str;
 
 	for (len = 0; len <= PATH_MAX; len++) {
 		if (ustr[len] == 0)
@@ -334,78 +335,128 @@ static char *nxt_dir_entry(char *old_ent
 
 }
 
+struct cifs_dirent {
+	const char	*name;
+	size_t		namelen;
+	u32		resume_key;
+	u64		ino;
+};
+
+static void cifs_fill_dirent_unix(struct cifs_dirent *de,
+		const FILE_UNIX_INFO *info, bool is_unicode)
+{
+	de->name = &info->FileName[0];
+	if (is_unicode)
+		de->namelen = cifs_unicode_bytelen(de->name);
+	else
+		de->namelen = strnlen(de->name, PATH_MAX);
+	de->resume_key = info->ResumeKey;
+	de->ino = le64_to_cpu(info->basic.UniqueId);
+}
+
+static void cifs_fill_dirent_dir(struct cifs_dirent *de,
+		const FILE_DIRECTORY_INFO *info)
+{
+	de->name = &info->FileName[0];
+	de->namelen = le32_to_cpu(info->FileNameLength);
+	de->resume_key = info->FileIndex;
+}
+
+static void cifs_fill_dirent_full(struct cifs_dirent *de,
+		const FILE_FULL_DIRECTORY_INFO *info)
+{
+	de->name = &info->FileName[0];
+	de->namelen = le32_to_cpu(info->FileNameLength);
+	de->resume_key = info->FileIndex;
+}
+
+static void cifs_fill_dirent_search(struct cifs_dirent *de,
+		const SEARCH_ID_FULL_DIR_INFO *info)
+{
+	de->name = &info->FileName[0];
+	de->namelen = le32_to_cpu(info->FileNameLength);
+	de->resume_key = info->FileIndex;
+	de->ino = le64_to_cpu(info->UniqueId);
+}
+
+static void cifs_fill_dirent_both(struct cifs_dirent *de,
+		const FILE_BOTH_DIRECTORY_INFO *info)
+{
+	de->name = &info->FileName[0];
+	de->namelen = le32_to_cpu(info->FileNameLength);
+	de->resume_key = info->FileIndex;
+}
+
+static void cifs_fill_dirent_std(struct cifs_dirent *de,
+		const FIND_FILE_STANDARD_INFO *info)
+{
+	de->name = &info->FileName[0];
+	/* one byte length, no endianess conversion */
+	de->namelen = info->FileNameLength;
+	de->resume_key = info->ResumeKey;
+}
+
+static int cifs_fill_dirent(struct cifs_dirent *de, const void *info,
+		u16 level, bool is_unicode)
+{
+	memset(de, 0, sizeof(*de));
+
+	switch (level) {
+	case SMB_FIND_FILE_UNIX:
+		cifs_fill_dirent_unix(de, info, is_unicode);
+		break;
+	case SMB_FIND_FILE_DIRECTORY_INFO:
+		cifs_fill_dirent_dir(de, info);
+		break;
+	case SMB_FIND_FILE_FULL_DIRECTORY_INFO:
+		cifs_fill_dirent_full(de, info);
+		break;
+	case SMB_FIND_FILE_ID_FULL_DIR_INFO:
+		cifs_fill_dirent_search(de, info);
+		break;
+	case SMB_FIND_FILE_BOTH_DIRECTORY_INFO:
+		cifs_fill_dirent_both(de, info);
+		break;
+	case SMB_FIND_FILE_INFO_STANDARD:
+		cifs_fill_dirent_std(de, info);
+		break;
+	default:
+		cFYI(1, "Unknown findfirst level %d", level);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 #define UNICODE_DOT cpu_to_le16(0x2e)
 
 /* return 0 if no match and 1 for . (current directory) and 2 for .. (parent) */
-static int cifs_entry_is_dot(char *current_entry, struct cifsFileInfo *cfile)
+static int cifs_entry_is_dot(struct cifs_dirent *de, bool is_unicode)
 {
 	int rc = 0;
-	char *filename = NULL;
-	int len = 0;
 
-	if (cfile->srch_inf.info_level == SMB_FIND_FILE_UNIX) {
-		FILE_UNIX_INFO *pFindData = (FILE_UNIX_INFO *)current_entry;
-		filename = &pFindData->FileName[0];
-		if (cfile->srch_inf.unicode) {
-			len = cifs_unicode_bytelen(filename);
-		} else {
-			/* BB should we make this strnlen of PATH_MAX? */
-			len = strnlen(filename, 5);
-		}
-	} else if (cfile->srch_inf.info_level == SMB_FIND_FILE_DIRECTORY_INFO) {
-		FILE_DIRECTORY_INFO *pFindData =
-			(FILE_DIRECTORY_INFO *)current_entry;
-		filename = &pFindData->FileName[0];
-		len = le32_to_cpu(pFindData->FileNameLength);
-	} else if (cfile->srch_inf.info_level ==
-			SMB_FIND_FILE_FULL_DIRECTORY_INFO) {
-		FILE_FULL_DIRECTORY_INFO *pFindData =
-			(FILE_FULL_DIRECTORY_INFO *)current_entry;
-		filename = &pFindData->FileName[0];
-		len = le32_to_cpu(pFindData->FileNameLength);
-	} else if (cfile->srch_inf.info_level ==
-			SMB_FIND_FILE_ID_FULL_DIR_INFO) {
-		SEARCH_ID_FULL_DIR_INFO *pFindData =
-			(SEARCH_ID_FULL_DIR_INFO *)current_entry;
-		filename = &pFindData->FileName[0];
-		len = le32_to_cpu(pFindData->FileNameLength);
-	} else if (cfile->srch_inf.info_level ==
-			SMB_FIND_FILE_BOTH_DIRECTORY_INFO) {
-		FILE_BOTH_DIRECTORY_INFO *pFindData =
-			(FILE_BOTH_DIRECTORY_INFO *)current_entry;
-		filename = &pFindData->FileName[0];
-		len = le32_to_cpu(pFindData->FileNameLength);
-	} else if (cfile->srch_inf.info_level == SMB_FIND_FILE_INFO_STANDARD) {
-		FIND_FILE_STANDARD_INFO *pFindData =
-			(FIND_FILE_STANDARD_INFO *)current_entry;
-		filename = &pFindData->FileName[0];
-		len = pFindData->FileNameLength;
-	} else {
-		cFYI(1, "Unknown findfirst level %d",
-			 cfile->srch_inf.info_level);
-	}
+	if (!de->name)
+		return 0;
 
-	if (filename) {
-		if (cfile->srch_inf.unicode) {
-			__le16 *ufilename = (__le16 *)filename;
-			if (len == 2) {
-				/* check for . */
-				if (ufilename[0] == UNICODE_DOT)
-					rc = 1;
-			} else if (len == 4) {
-				/* check for .. */
-				if ((ufilename[0] == UNICODE_DOT)
-				   && (ufilename[1] == UNICODE_DOT))
-					rc = 2;
-			}
-		} else /* ASCII */ {
-			if (len == 1) {
-				if (filename[0] == '.')
-					rc = 1;
-			} else if (len == 2) {
-				if ((filename[0] == '.') && (filename[1] == '.'))
-					rc = 2;
-			}
+	if (is_unicode) {
+		__le16 *ufilename = (__le16 *)de->name;
+		if (de->namelen == 2) {
+			/* check for . */
+			if (ufilename[0] == UNICODE_DOT)
+				rc = 1;
+		} else if (de->namelen == 4) {
+			/* check for .. */
+			if (ufilename[0] == UNICODE_DOT &&
+			    ufilename[1] == UNICODE_DOT)
+				rc = 2;
+		}
+	} else /* ASCII */ {
+		if (de->namelen == 1) {
+			if (de->name[0] == '.')
+				rc = 1;
+		} else if (de->namelen == 2) {
+			if (de->name[0] == '.' && de->name[1] == '.')
+				rc = 2;
 		}
 	}
 
@@ -687,6 +738,7 @@ static int cifs_filldir(char *find_entry
 	struct cifsFileInfo *file_info = file->private_data;
 	struct super_block *sb = file->f_path.dentry->d_sb;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	struct cifs_dirent de = { NULL, };
 	struct cifs_fattr fattr;
 	struct dentry *dentry;
 	struct qstr name;
@@ -694,9 +746,13 @@ static int cifs_filldir(char *find_entry
 	u64 inum;
 	ino_t ino;
 
+	rc = cifs_fill_dirent(&de, find_entry, file_info->srch_inf.info_level,
+			      file_info->srch_inf.unicode);
+	if (rc)
+		return rc;
+
 	/* skip . and .. since we added them first */
-	rc = cifs_entry_is_dot(find_entry, file_info);
-	if (rc != 0)
+	if (cifs_entry_is_dot(&de, file_info->srch_inf.unicode))
 		return 0;
 
 	name.name = scratch_buf;
