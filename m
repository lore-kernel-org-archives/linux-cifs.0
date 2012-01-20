From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 36/50] CIFS: Add readdir support for SMB2
Date: Fri, 20 Jan 2012 12:34:57 +0400
Message-ID: <1327048511-2342-36-git-send-email-piastry@etersoft.ru>
References: <1327048511-2342-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1327048511-2342-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifs_debug.h  |    1 +
 fs/cifs/cifsglob.h    |    7 +
 fs/cifs/cifsproto.h   |    4 +
 fs/cifs/file.c        |   68 ++++---
 fs/cifs/maperror.c    |    3 +-
 fs/cifs/readdir.c     |   23 +--
 fs/cifs/smb2dir.c     |    2 +-
 fs/cifs/smb2misc.c    |    5 +
 fs/cifs/smb2pdu.c     |  155 +++++++++++++++
 fs/cifs/smb2pdu.h     |   45 +++++
 fs/cifs/smb2proto.h   |    4 +
 fs/cifs/smb2readdir.c |  518 +++++++++++++++++++++++++++++++++++++++++++++++++
 12 files changed, 789 insertions(+), 46 deletions(-)
 create mode 100644 fs/cifs/smb2readdir.c

diff --git a/fs/cifs/cifs_debug.h b/fs/cifs/cifs_debug.h
index 8f20c7a..a57f60b 100644
--- a/fs/cifs/cifs_debug.h
+++ b/fs/cifs/cifs_debug.h
@@ -37,6 +37,7 @@ void dump_smb(struct smb_hdr *, int);
 void dump_smb2(struct smb2_hdr *smb_buf, int smb_buf_length);
 void smb2_dump_detail(struct smb2_hdr *);
 #endif
+void dump_cifs_file_struct(struct file *file, char *label);
 #define CIFS_INFO	0x01
 #define CIFS_RC		0x02
 #define CIFS_TIMER	0x04
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 887765c..69d2b31 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -550,6 +550,13 @@ struct cifsLockInfo {
 	__u16 netfid;
 };
 
+struct cifs_dirent {
+	const char	*name;
+	size_t		namelen;
+	u32		resume_key;
+	u64		ino;
+};
+
 /*
  * One of these for each open instance of a file
  */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index b970867..d549a22 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -221,6 +221,10 @@ extern int cifs_writepages_generic(struct address_space *mapping,
 				   struct writeback_control *wbc,
 				   awritev_callback_t *async_writev);
 extern int cifs_writepage(struct page *page, struct writeback_control *wbc);
+extern int cifs_is_dir_changed(struct file *file);
+extern struct dentry *cifs_readdir_lookup(struct dentry *parent,
+					  struct qstr *name,
+					  struct cifs_fattr *fattr);
 void cifs_proc_init(void);
 void cifs_proc_clean(void);
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 61348b2..b5912c2 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -653,47 +653,55 @@ int cifs_closedir(struct inode *inode, struct file *file)
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
diff --git a/fs/cifs/maperror.c b/fs/cifs/maperror.c
index 5b0b72e..4509a64 100644
--- a/fs/cifs/maperror.c
+++ b/fs/cifs/maperror.c
@@ -1807,7 +1807,8 @@ map_smb2_to_linux_error(struct smb2_hdr *smb, int log_err)
 
 	smb2err = le32_to_cpu(smb->Status);
 	/* mask facility */
-	if (log_err && (smb2err != (STATUS_MORE_PROCESSING_REQUIRED)))
+	if (log_err && (smb2err != (STATUS_MORE_PROCESSING_REQUIRED)) &&
+	    (smb2err != STATUS_NO_MORE_FILES))
 		smb2_print_status(smb2err);
 	else if (cifsFYI & CIFS_RC)
 		smb2_print_status(smb2err);
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index e2bbc68..c81eadc 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -41,7 +41,7 @@
 #define UNICODE_NAME_MAX ((4 * NAME_MAX) + 2)
 
 #ifdef CONFIG_CIFS_DEBUG2
-static void dump_cifs_file_struct(struct file *file, char *label)
+void dump_cifs_file_struct(struct file *file, char *label)
 {
 	struct cifsFileInfo *cf;
 
@@ -60,7 +60,7 @@ static void dump_cifs_file_struct(struct file *file, char *label)
 	}
 }
 #else
-static inline void dump_cifs_file_struct(struct file *file, char *label)
+inline void dump_cifs_file_struct(struct file *file, char *label)
 {
 }
 #endif /* DEBUG2 */
@@ -69,7 +69,7 @@ static inline void dump_cifs_file_struct(struct file *file, char *label)
  * Find the dentry that matches "name". If there isn't one, create one. If it's
  * a negative dentry or the uniqueid changed, then drop it and recreate it.
  */
-static struct dentry *
+struct dentry *
 cifs_readdir_lookup(struct dentry *parent, struct qstr *name,
 		    struct cifs_fattr *fattr)
 {
@@ -335,13 +335,6 @@ static char *nxt_dir_entry(char *old_entry, char *end_of_smb, int level)
 
 }
 
-struct cifs_dirent {
-	const char	*name;
-	size_t		namelen;
-	u32		resume_key;
-	u64		ino;
-};
-
 static void cifs_fill_dirent_unix(struct cifs_dirent *de,
 		const FILE_UNIX_INFO *info, bool is_unicode)
 {
@@ -463,9 +456,11 @@ static int cifs_entry_is_dot(struct cifs_dirent *de, bool is_unicode)
 	return rc;
 }
 
-/* Check if directory that we are searching has changed so we can decide
-   whether we can use the cached search results from the previous search */
-static int is_dir_changed(struct file *file)
+/*
+ * Check if directory that we are searching has changed so we can decide
+ * whether we can use the cached search results from the previous search.
+ */
+int cifs_is_dir_changed(struct file *file)
 {
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct cifsInodeInfo *cifsInfo = CIFS_I(inode);
@@ -526,7 +521,7 @@ static int find_cifs_entry(const int xid, struct cifs_tcon *pTcon,
 
 	dump_cifs_file_struct(file, "In fce ");
 	if (((index_to_find < cifsFile->srch_inf.index_of_last_entry) &&
-	     is_dir_changed(file)) ||
+	     cifs_is_dir_changed(file)) ||
 	   (index_to_find < first_entry_in_buffer)) {
 		/* close and restart search */
 		cFYI(1, "search backing up - close and restart search");
diff --git a/fs/cifs/smb2dir.c b/fs/cifs/smb2dir.c
index cf0e966..7fd8ccf 100644
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
diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 52b68fb..5eb69ec 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -250,6 +250,11 @@ char *smb2_get_data_area_len(int *poff, int *plen, struct smb2_hdr *pSMB2)
 				((struct smb2_read_rsp *)pSMB2)->DataLength);
 		break;
 	case SMB2_QUERY_DIRECTORY:
+		*poff = le16_to_cpu(
+		((struct smb2_query_directory_rsp *)pSMB2)->OutputBufferOffset);
+		*plen = le32_to_cpu(
+		((struct smb2_query_directory_rsp *)pSMB2)->OutputBufferLength);
+		break;
 	case SMB2_IOCTL:
 	case SMB2_CHANGE_NOTIFY:
 	default:
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 0bb7877..bfc1498 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1540,3 +1540,158 @@ SMB2_echo(struct TCP_Server_Info *server)
 	cifs_small_buf_release(smb2);
 	return rc;
 }
+
+static unsigned int
+num_entries(char *bufstart, char *end_of_buf, char **lastentry)
+{
+	int len;
+	unsigned int entrycount = 0;
+	unsigned int next_offset = 0;
+	struct smb2_file_full_directory_info *entryptr;
+
+	if (bufstart == NULL)
+		return 0;
+
+	entryptr = (struct smb2_file_full_directory_info *)bufstart;
+
+	while (1) {
+		entryptr = (struct smb2_file_full_directory_info *)
+					((char *)entryptr + next_offset);
+
+		if ((char *)entryptr +
+		    sizeof(struct smb2_file_full_directory_info) > end_of_buf) {
+			cERROR(1, "malformed search entry would overflow");
+			break;
+		}
+
+		len = le32_to_cpu(entryptr->filename_length);
+		if ((char *)entryptr + len +
+		    sizeof(struct smb2_file_full_directory_info) > end_of_buf) {
+			cERROR(1, "directory entry name would overflow frame"
+				" end of buf %p", end_of_buf);
+			break;
+		}
+
+		*lastentry = (char *)entryptr;
+
+		entrycount += 1;
+
+		next_offset =  le32_to_cpu(entryptr->next_entry_offset);
+		if (!next_offset)
+			break;
+	}
+
+	return entrycount;
+}
+
+/*
+ * Readdir/FindFirst
+ */
+int SMB2_query_directory(const int xid, struct cifs_tcon *tcon,
+			 u64 persistent_fid, u64 volatile_fid, int index,
+			 struct cifs_search_info *psrch_inf)
+{
+	struct smb2_query_directory_req *pSMB2;
+	struct smb2_query_directory_rsp *pSMB2r = NULL;
+	struct kvec iov[2];
+	int rc = 0;
+	int len;
+	int resp_buftype;
+	int status;
+	unsigned char *bufptr;
+	struct TCP_Server_Info *server;
+	struct cifs_ses *ses = tcon->ses;
+	__le16 asteriks = cpu_to_le16('*');
+	char *end_of_smb;
+	unsigned int output_size = CIFSMaxBufSize;
+
+	if (ses && (ses->server))
+		server = ses->server;
+	else
+		return -EIO;
+
+	rc = small_smb2_init(SMB2_QUERY_DIRECTORY, tcon, (void **) &pSMB2);
+	if (rc)
+		return rc;
+
+	pSMB2->FileInformationClass = FILEID_FULL_DIRECTORY_INFORMATION;
+
+	pSMB2->FileIndex = cpu_to_le32(index);
+	pSMB2->PersistentFileId = persistent_fid;
+	pSMB2->VolatileFileId = volatile_fid;
+
+	len = 0x2;
+	bufptr = pSMB2->Buffer;
+	memcpy(bufptr, &asteriks, len);
+
+	pSMB2->FileNameOffset =
+		cpu_to_le16(sizeof(struct smb2_query_directory_req) - 1 - 4);
+	pSMB2->FileNameLength = cpu_to_le16(len);
+	/*
+	 * BB could be 30 bytes or so longer if we used SMB2 specific
+	 * buffer lengths, but this is safe and close enough
+	 */
+	output_size = min_t(unsigned int, output_size, server->maxBuf);
+	output_size = min_t(unsigned int, output_size, 2 << 15);
+	pSMB2->OutputBufferLength = cpu_to_le32(output_size);
+
+	iov[0].iov_base = (char *)pSMB2;
+	iov[0].iov_len = be32_to_cpu(pSMB2->hdr.smb2_buf_length) + 4 - 1;
+
+	iov[1].iov_base = (char *)(pSMB2->Buffer);
+	iov[1].iov_len = len;
+
+	pSMB2->hdr.smb2_buf_length = cpu_to_be32(be32_to_cpu(
+			pSMB2->hdr.smb2_buf_length) + len - 1);
+
+	rc = smb2_sendrcv2(xid, ses, iov, 2, &resp_buftype /* ret */, &status,
+			   CIFS_STD_OP | CIFS_LOG_ERROR);
+	cFYI(1, "rddir buftype %d rc %d status %d", resp_buftype, rc, status);
+	if (rc) {
+		cifs_stats_fail_inc(tcon, SMB2QUERY_DIRECTORY);
+		goto qdir_exit;
+	}
+	pSMB2r = (struct smb2_query_directory_rsp *)iov[0].iov_base;
+
+	rc = validate_buf(le16_to_cpu(pSMB2r->OutputBufferOffset),
+			  le32_to_cpu(pSMB2r->OutputBufferLength), &pSMB2r->hdr,
+			  sizeof(struct smb2_file_full_directory_info));
+	if (rc)
+		goto qdir_exit;
+
+	if (psrch_inf->ntwrk_buf_start) {
+		if (psrch_inf->smallBuf)
+			cifs_small_buf_release(psrch_inf->ntwrk_buf_start);
+		else
+			cifs_buf_release(psrch_inf->ntwrk_buf_start);
+	}
+	psrch_inf->ntwrk_buf_start = (char *)pSMB2r;
+	psrch_inf->srch_entries_start = psrch_inf->last_entry = 4 /* RFCLEN */ +
+		(char *)&pSMB2r->hdr +	le16_to_cpu(pSMB2r->OutputBufferOffset);
+	end_of_smb = be32_to_cpu(pSMB2r->hdr.smb2_buf_length) +
+				4 /* RFC1001len field */ + (char *)&pSMB2r->hdr;
+	psrch_inf->entries_in_buffer =
+			num_entries(psrch_inf->srch_entries_start, end_of_smb,
+				    &psrch_inf->last_entry);
+	psrch_inf->index_of_last_entry += psrch_inf->entries_in_buffer;
+	cFYI(1, "num entries %d last_index %lld srch start %p srch end %p",
+		psrch_inf->entries_in_buffer, psrch_inf->index_of_last_entry,
+		psrch_inf->srch_entries_start, psrch_inf->last_entry);
+	if (resp_buftype == CIFS_LARGE_BUFFER)
+		psrch_inf->smallBuf = false;
+	else if (resp_buftype == CIFS_SMALL_BUFFER)
+		psrch_inf->smallBuf = true;
+	else
+		cERROR(1, "illegal search buffer type");
+
+	if (le32_to_cpu(pSMB2r->hdr.Status) == STATUS_NO_MORE_FILES)
+		psrch_inf->endOfSearch = 1;
+	else
+		psrch_inf->endOfSearch = 0;
+
+	return rc;
+
+qdir_exit:
+	free_rsp_buf(resp_buftype, pSMB2r);
+	return rc;
+}
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 81bd490..9c8b59d 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -511,6 +511,34 @@ struct smb2_echo_rsp {
 	__u16  Reserved;
 } __packed;
 
+/* search (query_directory) Flags field */
+#define SMB2_RESTART_SCANS		0x01
+#define SMB2_RETURN_SINGLE_ENTRY	0x02
+#define SMB2_INDEX_SPECIFIED		0x04
+#define SMB2_REOPEN			0x10
+
+struct smb2_query_directory_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 33 */
+	__u8   FileInformationClass;
+	__u8   Flags;
+	__le32 FileIndex;
+	__u64  PersistentFileId; /* opaque endianness */
+	__u64  VolatileFileId; /* opaque endianness */
+	__le16 FileNameOffset;
+	__le16 FileNameLength;
+	__le32 OutputBufferLength;
+	__u8   Buffer[1];
+} __packed;
+
+struct smb2_query_directory_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize; /* Must be 9 */
+	__le16 OutputBufferOffset;
+	__le32 OutputBufferLength;
+	__u8   Buffer[1];
+} __packed;
+
 /* Possible InfoType values */
 #define SMB2_O_INFO_FILE	0x01
 #define SMB2_O_INFO_FILESYSTEM	0x02
@@ -594,6 +622,23 @@ struct smb2_query_info_rsp {
 #define FILEID_GLOBAL_TX_DIRECTORY_INFORMATION 50
 #define FILE_STANDARD_LINK_INFORMATION	54
 
+struct smb2_file_full_directory_info {
+	__le32 next_entry_offset;
+	__u32  file_index;
+	__le64 creation_time;
+	__le64 last_access_time;
+	__le64 last_write_time;
+	__le64 change_time;
+	__le64 end_of_file;
+	__le64 allocation_size;
+	__le32 file_attribute;
+	__le32 filename_length;
+	__le32 easize;
+	__u32  reserved2;
+	__le64 file_id;
+	char   filename[0];
+} __packed;
+
 /*
  * This level 18, although with struct with same name is different from cifs
  * level 0x107. Level 0x107 has an extra u64 between AccessFlags and
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index f821722..468f184 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -85,6 +85,7 @@ extern int smb2_rmdir(struct inode *inode, struct dentry *direntry);
 extern int smb2_unlink(struct inode *dir, struct dentry *dentry);
 extern int smb2_create(struct inode *dir, struct dentry *direntry, int mode,
 		       struct nameidata *nd);
+extern int smb2_readdir(struct file *file, void *direntry, filldir_t filldir);
 
 extern struct cifsFileInfo *smb2_new_fileinfo(__u64 persist_fid,
 					      __u64 volatile_fid,
@@ -144,5 +145,8 @@ extern int SMB2_read(const int xid, struct cifs_io_parms *io_parms,
 		     unsigned int remaining_bytes);
 extern int smb2_async_readv(struct cifs_readdata *rdata);
 extern int SMB2_echo(struct TCP_Server_Info *server);
+extern int SMB2_query_directory(const int xid, struct cifs_tcon *tcon,
+				u64 persistent_fid, u64 volatile_fid, int index,
+				struct cifs_search_info *);
 
 #endif			/* _SMB2PROTO_H */
diff --git a/fs/cifs/smb2readdir.c b/fs/cifs/smb2readdir.c
new file mode 100644
index 0000000..a9b489f
--- /dev/null
+++ b/fs/cifs/smb2readdir.c
@@ -0,0 +1,518 @@
+/*
+ *   fs/cifs/smb2readdir.c
+ *
+ *   Directory search handling for SMB2 protocol
+ *
+ *   Copyright (C) International Business Machines  Corp., 2011
+ *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
+ *              Pavel Shilovsky (pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org) 2012
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
+#include <linux/slab.h>
+#include <linux/stat.h>
+#include "cifspdu.h"
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
+static void
+smb2_fill_common_info(struct cifs_fattr *fattr, struct cifs_sb_info *cifs_sb)
+{
+	fattr->cf_uid = cifs_sb->mnt_uid;
+	fattr->cf_gid = cifs_sb->mnt_gid;
+
+	if (fattr->cf_cifsattrs & FILE_ATTRIBUTE_DIRECTORY) {
+		fattr->cf_mode = S_IFDIR | cifs_sb->mnt_dir_mode;
+		fattr->cf_dtype = DT_DIR;
+	} else {
+		fattr->cf_mode = S_IFREG | cifs_sb->mnt_file_mode;
+		fattr->cf_dtype = DT_REG;
+	}
+
+	if (fattr->cf_cifsattrs & FILE_ATTRIBUTE_READONLY)
+		fattr->cf_mode &= ~S_IWUGO;
+}
+
+static void
+smb2_dir_info_to_fattr(struct cifs_fattr *fattr,
+		       struct smb2_file_full_directory_info *info,
+		       struct cifs_sb_info *cifs_sb)
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
+	smb2_fill_common_info(fattr, cifs_sb);
+}
+
+static int smb2_initiate_search(const int xid, struct file *file)
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
+	full_path = cifs_build_utf16path_from_dentry(file->f_path.dentry);
+	if (full_path == NULL)
+		return -ENOMEM;
+
+	rc = SMB2_open(xid, tcon, full_path, &persistent_fid, &volatile_fid,
+		       FILE_READ_ATTRIBUTES | FILE_READ_DATA, FILE_OPEN, 0, 0);
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
+static char *smb2_nxt_dir_entry(char *old_entry, char *end_of_smb)
+{
+	char *new_entry;
+	struct smb2_file_full_directory_info *dir_info =
+		(struct smb2_file_full_directory_info *)old_entry;
+
+	new_entry = old_entry + le32_to_cpu(dir_info->next_entry_offset);
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
+static void
+smb2_fill_dirent(struct cifs_dirent *de,
+		 const struct smb2_file_full_directory_info *info)
+{
+	memset(de, 0, sizeof(*de));
+	de->name = &info->filename[0];
+	de->namelen = le32_to_cpu(info->filename_length);
+	de->resume_key = info->file_index;
+}
+
+#define UNICODE_DOT cpu_to_le16(0x2e)
+
+/* return 0 if no match and 1 for . (current directory) and 2 for .. (parent) */
+static int
+smb2_entry_is_dot(struct cifs_dirent *de)
+{
+	int rc = 0;
+	__le16 *ufilename;
+
+	if (!de->name)
+		return 0;
+
+	ufilename = (__le16 *)de->name;
+	if (de->namelen == 2) {
+		/* check for . */
+		if (ufilename[0] == UNICODE_DOT)
+			rc = 1;
+	} else if (de->namelen == 4) {
+		/* check for .. */
+		if (ufilename[0] == UNICODE_DOT &&
+		    ufilename[1] == UNICODE_DOT)
+			rc = 2;
+	}
+
+	return rc;
+}
+
+static void
+smb2_save_resume_key(const char *cur_ent, struct cifsFileInfo *cfile)
+{
+	struct cifs_dirent de;
+
+	smb2_fill_dirent(&de, (void *)cur_ent);
+	cfile->srch_inf.presume_name = de.name;
+	cfile->srch_inf.resume_name_len = de.namelen;
+	cfile->srch_inf.resume_key = de.resume_key;
+}
+
+/* Find the corresponding entry in the search */
+/*
+ * Note that the SMB server returns search entries for . and .. which
+ * complicates logic here if we choose to parse for them and we do not
+ * assume that they are located in the findfirst return buffer.
+ */
+/*
+ * We start counting in the buffer with entry 2 and increment for every
+ * entry (do not increment for . or .. entry).
+ */
+static int
+smb2_find_entry(const int xid, struct cifs_tcon *tcon,
+		struct file *file, char **ppCurrentEntry, int *num_to_ret)
+{
+	int rc = 0;
+	int pos_in_buf = 0;
+	loff_t first_entry_in_buffer;
+	loff_t index_to_find = file->f_pos;
+	struct cifsFileInfo *cfile = file->private_data;
+	/* check if index in the buffer */
+
+	if ((cfile == NULL) || (ppCurrentEntry == NULL) ||
+	   (num_to_ret == NULL))
+		return -ENOENT;
+
+	*ppCurrentEntry = NULL;
+	first_entry_in_buffer =
+		cfile->srch_inf.index_of_last_entry -
+			cfile->srch_inf.entries_in_buffer;
+
+	/*
+	 * if first entry in buf is zero then is first buffer
+	 * in search response data which means it is likely . and ..
+	 * will be in this buffer, although some servers do not return
+	 * . and .. for the root of a drive and for those we need
+	 * to start two entries earlier.
+	 */
+
+	dump_cifs_file_struct(file, "In fce ");
+	if (((index_to_find < cfile->srch_inf.index_of_last_entry) &&
+	     cifs_is_dir_changed(file)) ||
+	   (index_to_find < first_entry_in_buffer)) {
+		/* close and restart search */
+		cFYI(1, "search backing up - close and restart search");
+		spin_lock(&cifs_file_list_lock);
+		if (!cfile->srch_inf.endOfSearch &&
+		    !cfile->invalidHandle) {
+			cfile->invalidHandle = true;
+			spin_unlock(&cifs_file_list_lock);
+			SMB2_close(xid, tcon, cfile->persist_fid,
+				   cfile->volatile_fid);
+		} else
+			spin_unlock(&cifs_file_list_lock);
+		if (cfile->srch_inf.ntwrk_buf_start) {
+			cFYI(1, "freeing SMB ff cache buf on search rewind");
+			if (cfile->srch_inf.smallBuf)
+				cifs_small_buf_release(cfile->srch_inf.
+						ntwrk_buf_start);
+			else
+				cifs_buf_release(cfile->srch_inf.
+						ntwrk_buf_start);
+			cfile->srch_inf.ntwrk_buf_start = NULL;
+		}
+		rc = smb2_initiate_search(xid, file);
+		if (rc) {
+			cFYI(1, "error %d reinitiating a search on rewind",
+				 rc);
+			return rc;
+		}
+		/* FindFirst/Next set last_entry to NULL on malformed reply */
+		if (cfile->srch_inf.last_entry)
+			smb2_save_resume_key(cfile->srch_inf.last_entry,
+						cfile);
+	}
+
+	while ((index_to_find >= cfile->srch_inf.index_of_last_entry) &&
+	      (rc == 0) && !cfile->srch_inf.endOfSearch) {
+		cFYI(1, "calling findnext2");
+		rc = SMB2_query_directory(xid, tcon, cfile->persist_fid,
+					  cfile->volatile_fid, 0,
+					  &cfile->srch_inf);
+		/* FindFirst/Next set last_entry to NULL on malformed reply */
+		if (cfile->srch_inf.last_entry)
+			smb2_save_resume_key(cfile->srch_inf.last_entry,
+					     cfile);
+		if (rc)
+			return -ENOENT;
+	}
+	if (index_to_find < cfile->srch_inf.index_of_last_entry) {
+		/* we found the buffer that contains the entry */
+		/* scan and find it */
+		int i;
+		char *cur_entry;
+		char *end_of_smb = cfile->srch_inf.ntwrk_buf_start +
+			smb2_calc_size((struct smb2_hdr *)
+				cfile->srch_inf.ntwrk_buf_start);
+		cur_entry = cfile->srch_inf.srch_entries_start;
+		first_entry_in_buffer = cfile->srch_inf.index_of_last_entry
+					- cfile->srch_inf.entries_in_buffer;
+		pos_in_buf = index_to_find - first_entry_in_buffer;
+		cFYI(1, "found entry - pos_in_buf %d", pos_in_buf);
+
+		for (i = 0; (i < (pos_in_buf)) && (cur_entry != NULL); i++) {
+			/* go entry by entry figuring out which is first */
+			cur_entry = smb2_nxt_dir_entry(cur_entry, end_of_smb);
+		}
+		if ((cur_entry == NULL) && (i < pos_in_buf)) {
+			/* BB fixme - check if we should flag this error */
+			cERROR(1, "reached end of buf searching for pos in buf"
+			  " %d index to find %lld rc %d",
+			  pos_in_buf, index_to_find, rc);
+		}
+		rc = 0;
+		*ppCurrentEntry = cur_entry;
+	} else {
+		cFYI(1, "index not in buffer - could not findnext into it");
+		return 0;
+	}
+
+	if (pos_in_buf >= cfile->srch_inf.entries_in_buffer) {
+		cFYI(1, "can not return entries pos_in_buf beyond last");
+		*num_to_ret = 0;
+	} else
+		*num_to_ret = cfile->srch_inf.entries_in_buffer - pos_in_buf;
+
+	return rc;
+}
+
+static int
+smb2_filldir(char *find_entry, struct file *file, filldir_t filldir,
+	     void *dirent, char *scratch_buf, unsigned int max_len)
+{
+	struct super_block *sb = file->f_path.dentry->d_sb;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	struct nls_table *nlt = cifs_sb->local_nls;
+	struct cifs_dirent de = { NULL, };
+	struct cifs_fattr fattr;
+	struct dentry *dentry;
+	struct qstr name;
+	int rc = 0;
+	ino_t ino;
+
+	smb2_fill_dirent(&de, (void *)find_entry);
+
+	if (de.namelen > max_len) {
+		cERROR(1, "bad search response length %zd past smb end",
+			  de.namelen);
+		return -EINVAL;
+	}
+
+	/* skip . and .. since we added them first */
+	if (smb2_entry_is_dot(&de))
+		return 0;
+
+	name.name = scratch_buf;
+	name.len = cifs_from_utf16((char *)name.name, (__le16 *)de.name,
+				   UNICODE_NAME_MAX,
+				   min_t(size_t, de.namelen, (size_t)max_len),
+				   nlt, cifs_sb->mnt_cifs_flags &
+						CIFS_MOUNT_MAP_SPECIAL_CHR);
+	name.len -= nls_nullsize(nlt);
+
+	smb2_dir_info_to_fattr(&fattr, (struct smb2_file_full_directory_info *)
+			       find_entry, cifs_sb);
+
+	fattr.cf_uniqueid = iunique(sb, ROOT_I);
+	cifs_autodisable_serverino(cifs_sb);
+
+	ino = cifs_uniqueid_to_ino_t(fattr.cf_uniqueid);
+	dentry = cifs_readdir_lookup(file->f_dentry, &name, &fattr);
+
+	rc = filldir(dirent, name.name, name.len, file->f_pos, ino,
+		     fattr.cf_dtype);
+
+	dput(dentry);
+	return rc;
+}
+
+int smb2_readdir(struct file *file, void *direntry, filldir_t filldir)
+{
+	int rc = 0;
+	int xid, i;
+	struct cifs_tcon *tcon;
+	struct cifsFileInfo *cfile = NULL;
+	char *cur_ent;
+	int num_to_fill = 0;
+	char *tmp_buf = NULL;
+	char *end_of_smb;
+	unsigned int max_len;
+
+	xid = GetXid();
+
+	/*
+	 * Ensure FindFirst doesn't fail before doing filldir() for '.' and
+	 * '..'. Otherwise we won't be able to notify VFS in case of failure.
+	 */
+	if (file->private_data == NULL) {
+		rc = smb2_initiate_search(xid, file);
+		cFYI(1, "initiate cifs search rc %d", rc);
+		if (rc)
+			goto rddir2_exit;
+	}
+
+	switch ((int) file->f_pos) {
+	case 0:
+		if (filldir(direntry, ".", 1, file->f_pos,
+		     file->f_path.dentry->d_inode->i_ino, DT_DIR) < 0) {
+			cERROR(1, "Filldir for current dir failed");
+			rc = -ENOMEM;
+			break;
+		}
+		file->f_pos++;
+	case 1:
+		if (filldir(direntry, "..", 2, file->f_pos,
+		     parent_ino(file->f_path.dentry), DT_DIR) < 0) {
+			cERROR(1, "Filldir for parent dir failed");
+			rc = -ENOMEM;
+			break;
+		}
+		file->f_pos++;
+	default:
+		/*
+		 * 1) If search is active,
+		 *    is in current search buffer?
+		 *    if it before then restart search
+		 *    if after then keep searching till find it.
+		 */
+
+		if (file->private_data == NULL) {
+			rc = -EINVAL;
+			FreeXid(xid);
+			return rc;
+		}
+		cfile = file->private_data;
+		if (cfile->srch_inf.endOfSearch) {
+			if (cfile->srch_inf.emptyDir) {
+				cFYI(1, "End of search, empty dir");
+				rc = 0;
+				break;
+			}
+		} /* else {
+			cfile->invalidHandle = true;
+			CIFSFindClose(xid, tcon, cfile->netfid);
+		} */
+
+		tcon = tlink_tcon(cfile->tlink);
+		rc = smb2_find_entry(xid, tcon, file, &cur_ent, &num_to_fill);
+		if (rc) {
+			cFYI(1, "fce error %d", rc);
+			goto rddir2_exit;
+		} else if (cur_ent != NULL) {
+			cFYI(1, "entry %lld found", file->f_pos);
+		} else {
+			cFYI(1, "could not find entry");
+			goto rddir2_exit;
+		}
+		cFYI(1, "loop through %d times filling dir for net buf %p",
+			num_to_fill, cfile->srch_inf.ntwrk_buf_start);
+		max_len = smb2_calc_size((struct smb2_hdr *)
+				cfile->srch_inf.ntwrk_buf_start);
+		end_of_smb = cfile->srch_inf.ntwrk_buf_start + max_len;
+
+		tmp_buf = kmalloc(UNICODE_NAME_MAX, GFP_KERNEL);
+		if (tmp_buf == NULL) {
+			rc = -ENOMEM;
+			break;
+		}
+
+		for (i = 0; (i < num_to_fill) && (rc == 0); i++) {
+			if (cur_ent == NULL) {
+				/* evaluate whether this case is an error */
+				cERROR(1, "past SMB end,  num to fill %d i %d",
+					  num_to_fill, i);
+				break;
+			}
+			/*
+			 * if buggy server returns . and .. late do
+			 * we want to check for that here?
+			 */
+			rc = smb2_filldir(cur_ent, file, filldir, direntry,
+					  tmp_buf, max_len);
+			if (rc == -EOVERFLOW) {
+				rc = 0;
+				break;
+			}
+
+			file->f_pos++;
+			if (file->f_pos ==
+				cfile->srch_inf.index_of_last_entry) {
+				cFYI(1, "last entry in buf at pos %lld %s",
+					file->f_pos, tmp_buf);
+				smb2_save_resume_key(cur_ent, cfile);
+				break;
+			} else
+				cur_ent = smb2_nxt_dir_entry(cur_ent,
+							     end_of_smb);
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
