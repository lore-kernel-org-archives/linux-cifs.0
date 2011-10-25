From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 36/53] CIFS: Add readdir support for SMB2
Date: Tue, 25 Oct 2011 10:12:09 +0400
Message-ID: <1319523146-2859-37-git-send-email-piastry@etersoft.ru>
References: <1319523146-2859-1-git-send-email-piastry@etersoft.ru>
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319523146-2859-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsproto.h   |    4 +
 fs/cifs/file.c        |   68 ++++---
 fs/cifs/readdir.c     |    4 +-
 fs/cifs/smb2dir.c     |    2 +-
 fs/cifs/smb2glob.h    |    1 -
 fs/cifs/smb2pdu.c     |   20 +-
 fs/cifs/smb2proto.h   |    7 +-
 fs/cifs/smb2readdir.c |  592 +++++++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 652 insertions(+), 46 deletions(-)
 create mode 100644 fs/cifs/smb2readdir.c

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index f2c04b8..c0afafd 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -216,6 +216,10 @@ extern int cifs_writepages_generic(struct address_space *mapping,
 				   struct writeback_control *wbc,
 				   awritev_callback_t *async_writev);
 extern int cifs_writepage(struct page *page, struct writeback_control *wbc);
+extern int is_dir_changed(struct file *file);
+extern struct dentry *cifs_readdir_lookup(struct dentry *parent,
+					  struct qstr *name,
+					  struct cifs_fattr *fattr);
 void cifs_proc_init(void);
 void cifs_proc_clean(void);
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index d090b6b..22cf18b 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -658,47 +658,55 @@ int cifs_closedir(struct inode *inode, struct file *file)
 {
 	int rc = 0;
 	int xid;
-	struct cifsFileInfo *pCFileStruct = file->private_data;
-	char *ptmp;
+	struct cifsFileInfo *cfile = file->private_data;
+	struct cifs_tcon *tcon;
+	char *buf;
 
 	cFYI(1, "Closedir inode = 0x%p", inode);
 
+	if (cfile == NULL)
+		return rc;
+
 	xid = GetXid();
+	tcon = tlink_tcon(cfile->tlink);
 
-	if (pCFileStruct) {
-		struct cifs_tcon *pTcon = tlink_tcon(pCFileStruct->tlink);
+	cFYI(1, "Freeing private data in close dir");
+	spin_lock(&cifs_file_list_lock);
+	if (!cfile->srch_inf.endOfSearch && !cfile->invalidHandle) {
+		cfile->invalidHandle = true;
+		spin_unlock(&cifs_file_list_lock);
+#ifdef CONFIG_CIFS_SMB2
+		if (tcon->ses->server->is_smb2)
+			rc = SMB2_close(xid, tcon, cfile->persist_fid,
+					cfile->volatile_fid);
+		else
+#endif
+			rc = CIFSFindClose(xid, tcon, cfile->netfid);
+		cFYI(1, "Closing uncompleted readdir with rc %d", rc);
+		/* not much we can do if it fails anyway, ignore rc */
+		rc = 0;
+	} else
+		spin_unlock(&cifs_file_list_lock);
 
-		cFYI(1, "Freeing private data in close dir");
-		spin_lock(&cifs_file_list_lock);
-		if (!pCFileStruct->srch_inf.endOfSearch &&
-		    !pCFileStruct->invalidHandle) {
-			pCFileStruct->invalidHandle = true;
-			spin_unlock(&cifs_file_list_lock);
-			rc = CIFSFindClose(xid, pTcon, pCFileStruct->netfid);
-			cFYI(1, "Closing uncompleted readdir with rc %d",
-				 rc);
-			/* not much we can do if it fails anyway, ignore rc */
-			rc = 0;
-		} else
-			spin_unlock(&cifs_file_list_lock);
-		ptmp = pCFileStruct->srch_inf.ntwrk_buf_start;
-		if (ptmp) {
-			cFYI(1, "closedir free smb buf in srch struct");
-			pCFileStruct->srch_inf.ntwrk_buf_start = NULL;
-			if (pCFileStruct->srch_inf.smallBuf)
-				cifs_small_buf_release(ptmp);
-			else
-				cifs_buf_release(ptmp);
-		}
-		cifs_put_tlink(pCFileStruct->tlink);
-		kfree(file->private_data);
-		file->private_data = NULL;
+	buf = cfile->srch_inf.ntwrk_buf_start;
+	if (buf) {
+		cFYI(1, "closedir free smb buf in srch struct");
+		cfile->srch_inf.ntwrk_buf_start = NULL;
+		if (cfile->srch_inf.smallBuf)
+			cifs_small_buf_release(buf);
+		else
+			cifs_buf_release(buf);
 	}
+
+	cifs_put_tlink(cfile->tlink);
+	kfree(file->private_data);
+	file->private_data = NULL;
 	/* BB can we lock the filestruct while this is going on? */
 	FreeXid(xid);
 	return rc;
 }
 
+
 loff_t cifs_llseek(struct file *file, loff_t offset, int origin)
 {
 	/*
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 5de03ec..fbc4374 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -69,7 +69,7 @@ static inline void dump_cifs_file_struct(struct file *file, char *label)
  * Find the dentry that matches "name". If there isn't one, create one. If it's
  * a negative dentry or the uniqueid changed, then drop it and recreate it.
  */
-static struct dentry *
+struct dentry *
 cifs_readdir_lookup(struct dentry *parent, struct qstr *name,
 		    struct cifs_fattr *fattr)
 {
@@ -465,7 +465,7 @@ static int cifs_entry_is_dot(struct cifs_dirent *de, bool is_unicode)
 
 /* Check if directory that we are searching has changed so we can decide
    whether we can use the cached search results from the previous search */
-static int is_dir_changed(struct file *file)
+int is_dir_changed(struct file *file)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct cifsInodeInfo *cifsInfo = CIFS_I(inode);
diff --git a/fs/cifs/smb2dir.c b/fs/cifs/smb2dir.c
index 957338c..2ae2fcd 100644
--- a/fs/cifs/smb2dir.c
+++ b/fs/cifs/smb2dir.c
@@ -36,7 +36,7 @@
 #include "smb2proto.h"
 
 const struct file_operations smb2_dir_ops = {
-	.readdir = cifs_readdir,
+	.readdir = smb2_readdir,
 	.release = cifs_closedir,
 	.read    = generic_read_dir,
 	.unlocked_ioctl  = cifs_ioctl,
diff --git a/fs/cifs/smb2glob.h b/fs/cifs/smb2glob.h
index 1fe5813..55d76ad 100644
--- a/fs/cifs/smb2glob.h
+++ b/fs/cifs/smb2glob.h
@@ -31,7 +31,6 @@
 
 #define SMB2_MIN_RCV_POOL 4
 
-
 /*
  *****************************************************************
  * Except the SMB2 PDUs themselves all the
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index d682fa5..5f91f5e 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1450,7 +1450,7 @@ num_entries(char *bufstart, char *end_of_buf, char **lastentry)
  */
 int SMB2_query_directory(const int xid, struct cifs_tcon *tcon,
 		u64 persistent_fid, u64 volatile_fid, int index,
-		struct smb2_search *psrch_inf)
+		struct cifs_search_info *psrch_inf)
 {
 	struct query_directory_req *pSMB2;
 	struct query_directory_rsp *pSMB2r = NULL;
@@ -1525,24 +1525,24 @@ int SMB2_query_directory(const int xid, struct cifs_tcon *tcon,
 		(char *)&pSMB2r->hdr +	le16_to_cpu(pSMB2r->OutputBufferOffset);
 	end_of_smb = be32_to_cpu(pSMB2r->hdr.smb2_buf_length) +
 				4 /* RFC1001len field */ + (char *)&pSMB2r->hdr;
-	psrch_inf->entries_in_buf = num_entries(psrch_inf->srch_entries_start,
-						end_of_smb,
-						&psrch_inf->last_entry);
-	psrch_inf->index_of_last_entry += psrch_inf->entries_in_buf;
+	psrch_inf->entries_in_buffer =
+			num_entries(psrch_inf->srch_entries_start, end_of_smb,
+				    &psrch_inf->last_entry);
+	psrch_inf->index_of_last_entry += psrch_inf->entries_in_buffer;
 	cFYI(1, "num entries %d last_index %lld srch start %p srch end %p",
-		psrch_inf->entries_in_buf, psrch_inf->index_of_last_entry,
+		psrch_inf->entries_in_buffer, psrch_inf->index_of_last_entry,
 		psrch_inf->srch_entries_start, psrch_inf->last_entry);
 	if (resp_buftype == CIFS_LARGE_BUFFER)
-		psrch_inf->small_buf = false;
+		psrch_inf->smallBuf = false;
 	else if (resp_buftype == CIFS_SMALL_BUFFER)
-		psrch_inf->small_buf = true;
+		psrch_inf->smallBuf = true;
 	else
 		cERROR(1, "illegal search buffer type");
 
 	if (le32_to_cpu(pSMB2r->hdr.Status) == STATUS_NO_MORE_FILES)
-		psrch_inf->search_end = 1;
+		psrch_inf->endOfSearch = 1;
 	else
-		psrch_inf->search_end = 0;
+		psrch_inf->endOfSearch = 0;
 
 	return rc;
 
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index d846117..070eec9 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -155,6 +155,8 @@ extern int smb2_mkdir(struct inode *inode, struct dentry *direntry, int mode);
 extern int smb2_rmdir(struct inode *inode, struct dentry *direntry);
 extern int smb2_unlink(struct inode *dir, struct dentry *dentry);
 
+extern int smb2_readdir(struct file *file, void *direntry, filldir_t filldir);
+
 /* extern char *smb2_compose_mount_options(const char *sb_mountdata,
 			const char *fullpath, const struct dfs_info3_param *ref,
 			char **devname);
@@ -192,8 +194,9 @@ extern int SMB2_oplock_break(struct cifs_tcon *ptcon, __u64 netfid);
 extern int SMB2_query_info(const int xid, struct cifs_tcon *tcon,
 			   u64 persistent_file_id, u64 volatile_file_id,
 			   FILE_ALL_INFO_SMB2 *pFindData);
-int SMB2_query_directory(const int xid, struct cifs_tcon *tcon,
-	 u64 persistent_fid, u64 volatile_fid, int index, struct smb2_search *);
+extern int SMB2_query_directory(const int xid, struct cifs_tcon *tcon,
+				 u64 persistent_fid, u64 volatile_fid,
+				 int index, struct cifs_search_info *);
 extern int SMB2_set_info(const int xid, struct cifs_tcon *tcon,
 			   u64 persistent_file_id, u64 volatile_file_id,
 			   FILE_BASIC_INFO *pFindData);
diff --git a/fs/cifs/smb2readdir.c b/fs/cifs/smb2readdir.c
new file mode 100644
index 0000000..02be0f9
--- /dev/null
+++ b/fs/cifs/smb2readdir.c
@@ -0,0 +1,592 @@
+/*
+ *   fs/cifs/smb2readdir.c
+ *
+ *   Directory search handling
+ *
+ *   Copyright (C) International Business Machines  Corp., 2004, 2010
+ *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
+ *
+ *   This library is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU Lesser General Public License as published
+ *   by the Free Software Foundation; either version 2.1 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This library is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
+ *   the GNU Lesser General Public License for more details.
+ *
+ *   You should have received a copy of the GNU Lesser General Public License
+ *   along with this library; if not, write to the Free Software
+ *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#include <linux/fs.h>
+#include <linux/pagemap.h>
+#include <linux/stat.h>
+#include "cifsglob.h"
+#include "cifsproto.h"
+#include "cifs_unicode.h"
+#include "cifs_debug.h"
+#include "cifs_fs_sb.h"
+#include "cifsfs.h"
+#include "smb2glob.h"
+#include "smb2pdu.h"
+#include "smb2proto.h"
+
+/*
+ * To be safe - for UCS to UTF-8 with strings loaded with the rare long
+ * characters alloc more to account for such multibyte target UTF-8
+ * characters.
+ */
+#define UNICODE_NAME_MAX ((4 * NAME_MAX) + 2)
+
+#define UNICODE_DOT cpu_to_le16('.')
+
+/* return 0 if no match and 1 for . (current directory) and 2 for .. (parent) */
+static int smb2_entry_is_dot(char *current_entry, struct cifsFileInfo *sfile)
+{
+	int rc = 0;
+	char *filename = NULL;
+	int len = 0;
+
+	struct file_full_directory_info *pFindData =
+			(struct file_full_directory_info *)current_entry;
+	filename = &pFindData->filename[0];
+	len = le32_to_cpu(pFindData->filename_length);
+	cFYI(1, "filename len of entry %d", len);
+	if (filename) {
+		__le16 *ufilename = (__le16 *)filename;
+		if (len == 2) {
+			/* check for . */
+			if (ufilename[0] == UNICODE_DOT)
+				rc = 1;
+		} else if (len == 4) {
+			/* check for .. */
+			if ((ufilename[0] == UNICODE_DOT)
+			   && (ufilename[1] == UNICODE_DOT))
+				rc = 2;
+		}
+	}
+
+	return rc;
+}
+
+static char *nxt_dir_entry(char *old_entry, char *end_of_smb)
+{
+	char *new_entry;
+	struct file_full_directory_info *pDirInfo =
+		(struct file_full_directory_info *)old_entry;
+
+	new_entry = old_entry + le32_to_cpu(pDirInfo->next_entry_offset);
+
+	cFYI(1, "new entry %p old entry %p", new_entry, old_entry);
+	/* validate that new_entry is not past end of SMB */
+	if (new_entry >= end_of_smb) {
+		cERROR(1,
+		       "search entry %p began after end of SMB %p old entry %p",
+			new_entry, end_of_smb, old_entry);
+		return NULL;
+	}
+
+	return new_entry;
+}
+
+static int smb2_save_resume_key(const char *current_entry,
+	struct cifsFileInfo *smb2file)
+{
+	int rc = 0;
+	unsigned int len = 0;
+	char *filename;
+	struct file_full_directory_info *pFindData;
+
+	if ((smb2file == NULL) || (current_entry == NULL))
+		return -EINVAL;
+
+	pFindData = (struct file_full_directory_info *)current_entry;
+
+	filename = &pFindData->filename[0];
+	len = le32_to_cpu(pFindData->filename_length);
+
+	if (len > SMB2_MAX_MSGSIZE)
+		return -EINVAL;
+
+	smb2file->srch_inf.resume_key = pFindData->file_index;
+	smb2file->srch_inf.resume_name_len = len;
+	smb2file->srch_inf.presume_name = filename;
+	return rc;
+}
+
+/* inode num, inode type and filename returned */
+static int smb2_get_name_from_search_buf(struct qstr *pqst,
+	char *current_entry,
+	struct cifs_sb_info *smb2_sb, unsigned int max_len, __u64 *pinum)
+{
+	int rc = 0;
+	unsigned int len = 0;
+	char *filename;
+	struct nls_table *nlt = smb2_sb->local_nls;
+	struct file_full_directory_info *pfinddata;
+
+	*pinum = 0;
+
+	pfinddata = (struct file_full_directory_info *)current_entry;
+
+	filename = &pfinddata->filename[0];
+	len = le32_to_cpu(pfinddata->filename_length);
+	cFYI(1, "find in search buf entry of length %d", len);
+	if (len > max_len) {
+		cERROR(1, "bad search response length %d past smb end", len);
+		return -EINVAL;
+	}
+
+	/* cifs_dump_mem("search entry filename: ", filename, len); */
+
+	pqst->len = cifs_from_ucs2((char *) pqst->name,
+				   (__le16 *) filename,
+				   UNICODE_NAME_MAX,
+				   min(len, max_len), nlt,
+				   smb2_sb->mnt_cifs_flags &
+					CIFS_MOUNT_MAP_SPECIAL_CHR);
+
+	pqst->hash = full_name_hash(pqst->name, pqst->len);
+	cFYI(1, "filldir on %s of len %d", pqst->name, pqst->len);
+	return rc;
+}
+
+static void
+smb2_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *smb2_sb)
+{
+	fattr->cf_uid = smb2_sb->mnt_uid;
+	fattr->cf_gid = smb2_sb->mnt_gid;
+
+	if (fattr->cf_cifsattrs & FILE_ATTRIBUTE_DIRECTORY) {
+		fattr->cf_mode = S_IFDIR | smb2_sb->mnt_dir_mode;
+		fattr->cf_dtype = DT_DIR;
+	} else {
+		fattr->cf_mode = S_IFREG | smb2_sb->mnt_file_mode;
+		fattr->cf_dtype = DT_REG;
+	}
+
+	if (fattr->cf_cifsattrs & FILE_ATTRIBUTE_READONLY)
+		fattr->cf_mode &= ~S_IWUGO;
+}
+
+static void
+smb2_dir_info_to_fattr(struct cifs_fattr *fattr,
+			struct file_full_directory_info *info,
+			struct cifs_sb_info *smb2_sb)
+{
+	memset(fattr, 0, sizeof(*fattr));
+	fattr->cf_cifsattrs = le32_to_cpu(info->file_attribute);
+	fattr->cf_eof = le64_to_cpu(info->end_of_file);
+	fattr->cf_bytes = le64_to_cpu(info->allocation_size);
+	fattr->cf_atime = cifs_NTtimeToUnix(info->last_access_time);
+	fattr->cf_ctime = cifs_NTtimeToUnix(info->change_time);
+	fattr->cf_mtime = cifs_NTtimeToUnix(info->last_write_time);
+	cFYI(1, "eof: %lld alloc_size %lld", fattr->cf_eof, fattr->cf_bytes);
+
+	smb2_fill_common_info(fattr, smb2_sb);
+}
+
+/*
+ * To be safe - for UCS to UTF-8 with strings loaded with the rare long
+ * characters alloc more to account for such multibyte target UTF-8
+ * characters.
+ */
+
+static int smb2_filldir(char *pfindEntry, struct file *file, filldir_t filldir,
+			void *direntry, char *scratch_buf, unsigned int max_len)
+{
+	int rc = 0;
+	struct qstr qstring;
+	struct cifsFileInfo *psmb2f;
+	u64    inum;
+	ino_t  ino;
+	struct super_block *sb;
+	struct cifs_sb_info *smb2_sb;
+	struct dentry *tmp_dentry;
+	struct cifs_fattr fattr;
+
+	/* get filename and len into qstring */
+	/* get dentry */
+	/* decide whether to create and populate inode */
+	if ((direntry == NULL) || (file == NULL))
+		return -EINVAL;
+
+	psmb2f = file->private_data;
+
+	if ((scratch_buf == NULL) || (pfindEntry == NULL) || (psmb2f == NULL))
+		return -ENOENT;
+
+	rc = smb2_entry_is_dot(pfindEntry, psmb2f);
+	/* skip . and .. since we added them first */
+	if (rc != 0)
+		return 0;
+
+	sb = file->f_path.dentry->d_sb;
+	smb2_sb = CIFS_SB(sb);
+
+	qstring.name = scratch_buf;
+	rc = smb2_get_name_from_search_buf(&qstring, pfindEntry,
+			 smb2_sb, max_len, &inum /* returned */);
+
+	if (rc)
+		return rc;
+
+	smb2_dir_info_to_fattr(&fattr, (struct file_full_directory_info *)
+					pfindEntry, smb2_sb);
+
+	if (inum)
+		fattr.cf_uniqueid = inum;
+	else
+		fattr.cf_uniqueid = iunique(sb, ROOT_I);
+
+	ino = cifs_uniqueid_to_ino_t(fattr.cf_uniqueid);
+	tmp_dentry = cifs_readdir_lookup(file->f_dentry, &qstring, &fattr);
+
+	rc = filldir(direntry, qstring.name, qstring.len, file->f_pos,
+		     ino, fattr.cf_dtype);
+
+	/*
+	 * we can not return filldir errors to the caller since they are
+	 * "normal" when the stat blocksize is too small - we return remapped
+	 * error instead
+	 *
+	 * FIXME: This looks bogus. filldir returns -EOVERFLOW in the above
+	 * case already. Why should we be clobbering other errors from it?
+	 */
+	if (rc) {
+		cFYI(1, "filldir rc = %d", rc);
+		rc = -EOVERFLOW;
+	}
+	dput(tmp_dentry);
+	return rc;
+}
+
+static int initiate_smb2_search(const int xid, struct file *file);
+
+/* find the corresponding entry in the search */
+/*
+ * Note that the SMB server returns search entries for . and .. which
+ * complicates logic here if we choose to parse for them and we do not
+ * assume that they are located in the findfirst return buffer.
+ */
+/*
+ * We start counting in the buffer with entry 2 and increment for every
+ * entry (do not increment for . or .. entry).
+ */
+static int find_smb2_entry(const int xid, struct cifs_tcon *tcon,
+	struct file *file, char **ppcurrent_entry, int *num_to_ret)
+{
+	int rc = 0;
+	int pos_in_buf = 0;
+	loff_t first_entry_in_buffer;
+	loff_t index_to_find = file->f_pos;
+	struct cifsFileInfo *smb2file = file->private_data;
+	/* check if index in the buffer */
+
+	if ((smb2file == NULL) || (ppcurrent_entry == NULL) ||
+	   (num_to_ret == NULL))
+		return -ENOENT;
+
+	*ppcurrent_entry = NULL;
+	first_entry_in_buffer =
+		smb2file->srch_inf.index_of_last_entry -
+			smb2file->srch_inf.entries_in_buffer;
+
+	/*
+	 * if first entry in buf is zero then is first buffer
+	 * in search response data which means it is likely . and ..
+	 * will be in this buffer, although some servers do not return
+	 * . and .. for the root of a drive and for those we need
+	 * to start two entries earlier.
+	 */
+
+	if (((index_to_find < smb2file->srch_inf.index_of_last_entry) &&
+	     is_dir_changed(file)) || (index_to_find < first_entry_in_buffer)) {
+		/* close and restart search */
+		cFYI(1, "search backing up - close and restart search");
+		spin_lock(&cifs_tcp_ses_lock);
+		if (!smb2file->srch_inf.endOfSearch &&
+		    !smb2file->invalidHandle) {
+			smb2file->invalidHandle = true;
+			spin_unlock(&cifs_tcp_ses_lock);
+			SMB2_close(xid, tcon, smb2file->persist_fid, smb2file->volatile_fid);
+		} else
+			spin_unlock(&cifs_tcp_ses_lock);
+		if (smb2file->srch_inf.ntwrk_buf_start) {
+			cFYI(1, "freeing SMB ff cache buf on search rewind");
+			if (smb2file->srch_inf.smallBuf)
+				cifs_small_buf_release(smb2file->srch_inf.
+						ntwrk_buf_start);
+			else
+				cifs_buf_release(smb2file->srch_inf.
+						ntwrk_buf_start);
+			smb2file->srch_inf.ntwrk_buf_start = NULL;
+		}
+		rc = initiate_smb2_search(xid, file);
+		if (rc) {
+			cFYI(1, "error %d reinitiating a search on rewind",
+				 rc);
+			return rc;
+		}
+		smb2_save_resume_key(smb2file->srch_inf.last_entry, smb2file);
+	}
+
+
+	while ((index_to_find >= smb2file->srch_inf.index_of_last_entry) &&
+	      (rc == 0) && !smb2file->srch_inf.endOfSearch) {
+		cFYI(1, "calling findnext2");
+		rc = SMB2_query_directory(xid, tcon, smb2file->persist_fid,
+					  smb2file->volatile_fid, 0,
+					  &smb2file->srch_inf);
+		smb2_save_resume_key(smb2file->srch_inf.last_entry, smb2file);
+		if (rc)
+			return -ENOENT;
+	}
+	cFYI(1, "index to find %lld last %lld", index_to_find,
+		smb2file->srch_inf.index_of_last_entry);
+
+	if (index_to_find < smb2file->srch_inf.index_of_last_entry) {
+		/* we found the buffer that contains the entry */
+		/* scan and find it */
+		int i;
+		char *current_entry;
+		char *end_of_smb = smb2file->srch_inf.ntwrk_buf_start +
+			smb2_calc_size((struct smb2_hdr *)
+				smb2file->srch_inf.ntwrk_buf_start);
+		current_entry = smb2file->srch_inf.srch_entries_start;
+		first_entry_in_buffer = smb2file->srch_inf.index_of_last_entry
+					- smb2file->srch_inf.entries_in_buffer;
+		pos_in_buf = index_to_find - first_entry_in_buffer;
+		cFYI(1, "found entry - pos_in_buf %d", pos_in_buf);
+
+		for (i = 0;
+			(i < (pos_in_buf)) && (current_entry != NULL); i++) {
+			/* go entry by entry figuring out which is first */
+			current_entry = nxt_dir_entry(current_entry,
+								end_of_smb);
+		}
+		if ((current_entry == NULL) && (i < pos_in_buf)) {
+			/* BB fixme - check if we should flag this error */
+			cERROR(1, "reached end of buf searching for pos in buf"
+			  " %d index to find %lld rc %d",
+			  pos_in_buf, index_to_find, rc);
+		}
+		rc = 0;
+		*ppcurrent_entry = current_entry;
+	} else {
+		cFYI(1, "index not in buffer - could not findnext into it");
+		return 0;
+	}
+
+	if (pos_in_buf >= smb2file->srch_inf.entries_in_buffer) {
+		cFYI(1, "can not return entries pos_in_buf beyond last");
+		*num_to_ret = 0;
+	} else
+		*num_to_ret = smb2file->srch_inf.entries_in_buffer - pos_in_buf;
+
+	return rc;
+}
+
+static int initiate_smb2_search(const int xid, struct file *file)
+{
+	int rc = 0;
+	__le16 *full_path;
+	struct cifsFileInfo *smb2_file;
+	struct cifs_sb_info *smb2_sb;
+	struct cifs_tcon *tcon;
+	struct tcon_link *tlink;
+	u64 persistent_fid, volatile_fid;
+
+	smb2_sb = CIFS_SB(file->f_path.dentry->d_sb);
+	tlink = cifs_sb_tlink(smb2_sb);
+	if (IS_ERR(tlink)) {
+		FreeXid(xid);
+		return PTR_ERR(tlink);
+	}
+	tcon = tlink_tcon(tlink);
+
+	full_path = build_ucspath_from_dentry(file->f_path.dentry);
+	if (full_path == NULL)
+		return -ENOMEM;
+
+	cifs_dump_mem("about to search on name: ", full_path, 4);
+	rc = SMB2_open(xid, tcon, full_path, &persistent_fid, &volatile_fid,
+			FILE_READ_ATTRIBUTES | FILE_READ_DATA, FILE_OPEN, 0, 0);
+	if (rc) {
+		cERROR(1, "open of dir failed before readdir with rc = %d", rc);
+		goto initiate_search_exit;
+	}
+
+	if (file->private_data == NULL)
+		file->private_data =
+			kzalloc(sizeof(struct cifsFileInfo), GFP_KERNEL);
+
+	if (file->private_data == NULL) {
+		rc = -ENOMEM;
+		goto initiate_search_exit;
+	}
+
+	smb2_file = file->private_data;
+	smb2_file->srch_inf.entries_in_buffer = 0;
+	smb2_file->srch_inf.index_of_last_entry = 0;
+	smb2_file->persist_fid = persistent_fid;
+	smb2_file->volatile_fid = volatile_fid;
+	smb2_file->invalidHandle = false;
+	smb2_file->tlink = cifs_get_tlink(tlink);
+	mutex_init(&smb2_file->fh_mutex);
+	INIT_WORK(&smb2_file->oplock_break, cifs_oplock_break);
+	smb2_file->count = 1;
+
+	rc = SMB2_query_directory(xid, tcon, persistent_fid, volatile_fid,
+				  0 /* index */, &smb2_file->srch_inf);
+	if (rc)
+		cERROR(1, "query of dir failed");
+
+	/*
+	 * BB add following call to handle readdir on new NTFS symlink errors
+	if (rc == cpu_to_le32(STATUS_STOPPED_ON_SYMLINK))
+		call get_symlink_reparse_path and retry with new path
+	*/
+
+initiate_search_exit:
+	kfree(full_path);
+	cifs_put_tlink(tlink);
+	return rc;
+}
+
+
+int smb2_readdir(struct file *file, void *direntry, filldir_t filldir)
+{
+	int rc = 0;
+	int xid;
+	int i;
+	struct cifs_sb_info *smb2_sb;
+	struct cifs_tcon *tcon;
+	struct tcon_link *tlink;
+	struct cifsFileInfo *smb2_file = NULL;
+	int num_to_fill = 0;
+	char *tmp_buf = NULL;
+	char *end_of_smb;
+	unsigned int max_len;
+	char *current_entry;
+
+	xid = GetXid();
+
+	cFYI(1, "readdir on pos %d", (int) file->f_pos);
+	switch ((int) file->f_pos) {
+	case 0:
+		if (filldir(direntry, ".", 1, file->f_pos,
+			    file->f_path.dentry->d_inode->i_ino, DT_DIR) < 0) {
+			cERROR(1, "Filldir for current dir failed");
+			rc = -ENOMEM;
+			break;
+		}
+		file->f_pos++;
+	case 1:
+		if (filldir(direntry, "..", 2, file->f_pos,
+			    parent_ino(file->f_path.dentry), DT_DIR) < 0) {
+			cERROR(1, "Filldir for parent dir failed");
+			rc = -ENOMEM;
+			break;
+		}
+		file->f_pos++;
+	default:
+		/*
+		 * 1) If search is active,
+		 *       is in current search buffer?
+		 *       if it before then restart search
+		 *       if after then keep searching till find it
+		 */
+
+		if (file->private_data == NULL) {
+			rc = initiate_smb2_search(xid, file);
+			cFYI(1, "initiate smb2 search rc %d", rc);
+			if (rc)
+				goto rddir2_exit;
+		}
+		if (file->private_data == NULL) {
+			rc = -EINVAL;
+			goto rddir2_exit;
+		}
+		smb2_file = file->private_data;
+		if (smb2_file->srch_inf.endOfSearch) {
+			if (smb2_file->srch_inf.emptyDir) {
+				cFYI(1, "End of search, empty dir");
+				rc = 0;
+				break;
+			}
+		}
+
+		smb2_sb = CIFS_SB(file->f_path.dentry->d_sb);
+		tlink = cifs_sb_tlink(smb2_sb);
+		if (IS_ERR(tlink)) {
+			FreeXid(xid);
+			return PTR_ERR(tlink);
+		}
+		tcon = tlink_tcon(tlink);
+
+		rc = find_smb2_entry(xid, tcon, file, &current_entry,
+				     &num_to_fill);
+		cifs_put_tlink(tlink);
+
+		if (rc) {
+			cFYI(1, "find smb2 entry error %d", rc);
+			goto rddir2_exit;
+		} else if (current_entry != NULL) {
+			cFYI(1, "found entry %lld", file->f_pos);
+		} else {
+			cFYI(1, "could not find dir entry");
+			goto rddir2_exit;
+		}
+		cFYI(1, "loop through %d times filling dir with buf %p",
+			num_to_fill, smb2_file->srch_inf.ntwrk_buf_start);
+
+		max_len = smb2_calc_size((struct smb2_hdr *)
+				smb2_file->srch_inf.ntwrk_buf_start);
+		end_of_smb = smb2_file->srch_inf.ntwrk_buf_start + max_len;
+
+		tmp_buf = kmalloc(UNICODE_NAME_MAX, GFP_KERNEL);
+		if (tmp_buf == NULL) {
+			rc = -ENOMEM;
+			break;
+		}
+
+		for (i = 0; (i < num_to_fill) && (rc == 0); i++) {
+			if (current_entry == NULL) {
+				/* evaluate whether this case is an error */
+				cERROR(1, "past SMB end,  num to fill %d i %d",
+					  num_to_fill, i);
+				break;
+			}
+			/*
+			 * if buggy server returns . and .. late do
+			 * we want to check for that here?
+			 */
+			rc = smb2_filldir(current_entry, file,
+					filldir, direntry, tmp_buf, max_len);
+			if (rc == -EOVERFLOW) {
+				rc = 0;
+				break;
+			}
+
+			file->f_pos++;
+			if (file->f_pos ==
+				smb2_file->srch_inf.index_of_last_entry) {
+				cFYI(1, "last entry in buf at pos %lld %s",
+					file->f_pos, tmp_buf);
+				smb2_save_resume_key(current_entry, smb2_file);
+				break;
+			} else
+				current_entry =
+				nxt_dir_entry(current_entry, end_of_smb);
+		}
+		kfree(tmp_buf);
+		break;
+	} /* end switch */
+
+rddir2_exit:
+	FreeXid(xid);
+	return rc;
+}
-- 
1.7.1
