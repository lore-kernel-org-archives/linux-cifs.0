From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH 4/4] cifs: use cifs_dirent in cifs_save_resume_key
Date: Sat, 16 Jul 2011 15:24:37 -0400
Message-ID: <20110716192437.GD26925@infradead.org>
References: <20110716192334.GA26847@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110716192334.GA26847-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Index: linux-2.6/fs/cifs/readdir.c
===================================================================
--- linux-2.6.orig/fs/cifs/readdir.c	2011-06-30 21:47:45.366190671 +0200
+++ linux-2.6/fs/cifs/readdir.c	2011-06-30 21:48:42.076189966 +0200
@@ -478,66 +478,18 @@ static int is_dir_changed(struct file *f
 }
 
 static int cifs_save_resume_key(const char *current_entry,
-	struct cifsFileInfo *cifsFile)
+	struct cifsFileInfo *file_info)
 {
-	int rc = 0;
-	unsigned int len = 0;
-	__u16 level;
-	char *filename;
+	struct cifs_dirent de;
+	int rc;
 
-	if ((cifsFile == NULL) || (current_entry == NULL))
-		return -EINVAL;
-
-	level = cifsFile->srch_inf.info_level;
-
-	if (level == SMB_FIND_FILE_UNIX) {
-		FILE_UNIX_INFO *pFindData = (FILE_UNIX_INFO *)current_entry;
-
-		filename = &pFindData->FileName[0];
-		if (cifsFile->srch_inf.unicode) {
-			len = cifs_unicode_bytelen(filename);
-		} else {
-			/* BB should we make this strnlen of PATH_MAX? */
-			len = strnlen(filename, PATH_MAX);
-		}
-		cifsFile->srch_inf.resume_key = pFindData->ResumeKey;
-	} else if (level == SMB_FIND_FILE_DIRECTORY_INFO) {
-		FILE_DIRECTORY_INFO *pFindData =
-			(FILE_DIRECTORY_INFO *)current_entry;
-		filename = &pFindData->FileName[0];
-		len = le32_to_cpu(pFindData->FileNameLength);
-		cifsFile->srch_inf.resume_key = pFindData->FileIndex;
-	} else if (level == SMB_FIND_FILE_FULL_DIRECTORY_INFO) {
-		FILE_FULL_DIRECTORY_INFO *pFindData =
-			(FILE_FULL_DIRECTORY_INFO *)current_entry;
-		filename = &pFindData->FileName[0];
-		len = le32_to_cpu(pFindData->FileNameLength);
-		cifsFile->srch_inf.resume_key = pFindData->FileIndex;
-	} else if (level == SMB_FIND_FILE_ID_FULL_DIR_INFO) {
-		SEARCH_ID_FULL_DIR_INFO *pFindData =
-			(SEARCH_ID_FULL_DIR_INFO *)current_entry;
-		filename = &pFindData->FileName[0];
-		len = le32_to_cpu(pFindData->FileNameLength);
-		cifsFile->srch_inf.resume_key = pFindData->FileIndex;
-	} else if (level == SMB_FIND_FILE_BOTH_DIRECTORY_INFO) {
-		FILE_BOTH_DIRECTORY_INFO *pFindData =
-			(FILE_BOTH_DIRECTORY_INFO *)current_entry;
-		filename = &pFindData->FileName[0];
-		len = le32_to_cpu(pFindData->FileNameLength);
-		cifsFile->srch_inf.resume_key = pFindData->FileIndex;
-	} else if (level == SMB_FIND_FILE_INFO_STANDARD) {
-		FIND_FILE_STANDARD_INFO *pFindData =
-			(FIND_FILE_STANDARD_INFO *)current_entry;
-		filename = &pFindData->FileName[0];
-		/* one byte length, no name conversion */
-		len = (unsigned int)pFindData->FileNameLength;
-		cifsFile->srch_inf.resume_key = pFindData->ResumeKey;
-	} else {
-		cFYI(1, "Unknown findfirst level %d", level);
-		return -EINVAL;
+	rc = cifs_fill_dirent(&de, current_entry, file_info->srch_inf.info_level,
+			      file_info->srch_inf.unicode);
+	if (!rc) {
+		file_info->srch_inf.presume_name = de.name;
+		file_info->srch_inf.resume_name_len = de.namelen;
+		file_info->srch_inf.resume_key = de.resume_key;
 	}
-	cifsFile->srch_inf.resume_name_len = len;
-	cifsFile->srch_inf.presume_name = filename;
 	return rc;
 }
 
Index: linux-2.6/fs/cifs/cifsglob.h
===================================================================
--- linux-2.6.orig/fs/cifs/cifsglob.h	2011-06-30 21:45:08.449525955 +0200
+++ linux-2.6/fs/cifs/cifsglob.h	2011-06-30 21:48:42.076189966 +0200
@@ -501,7 +501,7 @@ struct cifs_search_info {
 	char *ntwrk_buf_start;
 	char *srch_entries_start;
 	char *last_entry;
-	char *presume_name;
+	const char *presume_name;
 	unsigned int resume_name_len;
 	bool endOfSearch:1;
 	bool emptyDir:1;
