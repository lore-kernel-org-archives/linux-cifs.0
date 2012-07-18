From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 39/45] CIFS: Move readdir code to ops struct
Date: Wed, 18 Jul 2012 19:48:55 +0400
Message-ID: <1342626541-29872-40-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h  |   15 +++++
 fs/cifs/cifsproto.h |    2 +-
 fs/cifs/file.c      |   62 +++++++++++--------
 fs/cifs/netmisc.c   |    3 +-
 fs/cifs/readdir.c   |  165 ++++++++++++++++++++++++++++-----------------------
 fs/cifs/smb1ops.c   |   31 ++++++++++
 6 files changed, 174 insertions(+), 104 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 7c20d5a..406ad6d 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -177,6 +177,7 @@ struct cifs_fid;
 struct cifs_readdata;
 struct cifs_writedata;
 struct cifs_io_parms;
+struct cifs_search_info;
 
 struct smb_version_operations {
 	int (*send_cancel)(struct TCP_Server_Info *, void *,
@@ -313,6 +314,20 @@ struct smb_version_operations {
 	int (*sync_write)(const unsigned int, struct cifsFileInfo *,
 			  struct cifs_io_parms *, unsigned int *, struct kvec *,
 			  unsigned long);
+	/* open dir, start readdir */
+	int (*query_dir_first)(const unsigned int, struct cifs_tcon *,
+			       const char *, struct cifs_sb_info *,
+			       struct cifs_fid *, __u16,
+			       struct cifs_search_info *);
+	/* continue readdir */
+	int (*query_dir_next)(const unsigned int, struct cifs_tcon *,
+			      struct cifs_fid *,
+			      __u16, struct cifs_search_info *srch_inf);
+	/* close dir */
+	int (*close_dir)(const unsigned int, struct cifs_tcon *,
+			 struct cifs_fid *);
+	/* calculate a size of SMB message */
+	unsigned int (*calc_smb_size)(void *);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 6e04941..afc0797 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -100,7 +100,7 @@ extern void cifs_update_eof(struct cifsInodeInfo *cifsi, loff_t offset,
 			    unsigned int bytes_written);
 extern struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *, bool);
 extern struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *, bool);
-extern unsigned int smbCalcSize(struct smb_hdr *ptr);
+extern unsigned int smbCalcSize(void *buf);
 extern int decode_negTokenInit(unsigned char *security_blob, int length,
 			struct TCP_Server_Info *server);
 extern int cifs_convert_address(struct sockaddr *dst, const char *src, int len);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 2ffee05..da9dc50 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -609,39 +609,47 @@ int cifs_closedir(struct inode *inode, struct file *file)
 	int rc = 0;
 	unsigned int xid;
 	struct cifsFileInfo *cfile = file->private_data;
-	char *tmp;
+	struct cifs_tcon *tcon;
+	struct TCP_Server_Info *server;
+	char *buf;
 
 	cFYI(1, "Closedir inode = 0x%p", inode);
 
+	if (cfile == NULL)
+		return rc;
+
 	xid = get_xid();
+	tcon = tlink_tcon(cfile->tlink);
+	server = tcon->ses->server;
 
-	if (cfile) {
-		struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
+	cFYI(1, "Freeing private data in close dir");
+	spin_lock(&cifs_file_list_lock);
+	if (!cfile->srch_inf.endOfSearch && !cfile->invalidHandle) {
+		cfile->invalidHandle = true;
+		spin_unlock(&cifs_file_list_lock);
+		if (server->ops->close_dir)
+			rc = server->ops->close_dir(xid, tcon, &cfile->fid);
+		else
+			rc = -ENOSYS;
+		cFYI(1, "Closing uncompleted readdir with rc %d", rc);
+		/* not much we can do if it fails anyway, ignore rc */
+		rc = 0;
+	} else
+		spin_unlock(&cifs_file_list_lock);
 
-		cFYI(1, "Freeing private data in close dir");
-		spin_lock(&cifs_file_list_lock);
-		if (!cfile->srch_inf.endOfSearch && !cfile->invalidHandle) {
-			cfile->invalidHandle = true;
-			spin_unlock(&cifs_file_list_lock);
-			rc = CIFSFindClose(xid, tcon, cfile->fid.netfid);
-			cFYI(1, "Closing uncompleted readdir with rc %d", rc);
-			/* not much we can do if it fails anyway, ignore rc */
-			rc = 0;
-		} else
-			spin_unlock(&cifs_file_list_lock);
-		tmp = cfile->srch_inf.ntwrk_buf_start;
-		if (tmp) {
-			cFYI(1, "closedir free smb buf in srch struct");
-			cfile->srch_inf.ntwrk_buf_start = NULL;
-			if (cfile->srch_inf.smallBuf)
-				cifs_small_buf_release(tmp);
-			else
-				cifs_buf_release(tmp);
-		}
-		cifs_put_tlink(cfile->tlink);
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
 	free_xid(xid);
 	return rc;
diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index 581c225..e7bab3b 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -913,8 +913,9 @@ map_smb_to_linux_error(char *buf, bool logErr)
  * portion, the number of word parameters and the data portion of the message
  */
 unsigned int
-smbCalcSize(struct smb_hdr *ptr)
+smbCalcSize(void *buf)
 {
+	struct smb_hdr *ptr = (struct smb_hdr *)buf;
 	return (sizeof(struct smb_hdr) + (2 * ptr->WordCount) +
 		2 /* size of the bcc field */ + get_bcc(ptr));
 }
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 9e76e3b..b0f4a42 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -220,7 +220,8 @@ int get_symlink_reparse_path(char *full_path, struct cifs_sb_info *cifs_sb,
 }
  */
 
-static int initiate_cifs_search(const unsigned int xid, struct file *file)
+static int
+initiate_cifs_search(const unsigned int xid, struct file *file)
 {
 	__u16 search_flags;
 	int rc = 0;
@@ -229,6 +230,7 @@ static int initiate_cifs_search(const unsigned int xid, struct file *file)
 	struct cifs_sb_info *cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
 	struct tcon_link *tlink = NULL;
 	struct cifs_tcon *tcon;
+	struct TCP_Server_Info *server;
 
 	if (file->private_data == NULL) {
 		tlink = cifs_sb_tlink(cifs_sb);
@@ -248,6 +250,13 @@ static int initiate_cifs_search(const unsigned int xid, struct file *file)
 		tcon = tlink_tcon(cifsFile->tlink);
 	}
 
+	server = tcon->ses->server;
+
+	if (!server->ops->query_dir_first) {
+		rc = -ENOSYS;
+		goto error_exit;
+	}
+
 	cifsFile->invalidHandle = true;
 	cifsFile->srch_inf.endOfSearch = false;
 
@@ -278,10 +287,10 @@ ffirst_retry:
 	if (backup_cred(cifs_sb))
 		search_flags |= CIFS_SEARCH_BACKUP_SEARCH;
 
-	rc = CIFSFindFirst(xid, tcon, full_path, cifs_sb->local_nls,
-		&cifsFile->fid.netfid, search_flags, &cifsFile->srch_inf,
-		cifs_sb->mnt_cifs_flags &
-			CIFS_MOUNT_MAP_SPECIAL_CHR, CIFS_DIR_SEP(cifs_sb));
+	rc = server->ops->query_dir_first(xid, tcon, full_path, cifs_sb,
+					  &cifsFile->fid, search_flags,
+					  &cifsFile->srch_inf);
+
 	if (rc == 0)
 		cifsFile->invalidHandle = false;
 	/* BB add following call to handle readdir on new NTFS symlink errors
@@ -501,62 +510,67 @@ static int cifs_save_resume_key(const char *current_entry,
 	return rc;
 }
 
-/* find the corresponding entry in the search */
-/* Note that the SMB server returns search entries for . and .. which
-   complicates logic here if we choose to parse for them and we do not
-   assume that they are located in the findfirst return buffer.*/
-/* We start counting in the buffer with entry 2 and increment for every
-   entry (do not increment for . or .. entry) */
-static int find_cifs_entry(const unsigned int xid, struct cifs_tcon *pTcon,
-	struct file *file, char **ppCurrentEntry, int *num_to_ret)
+/*
+ * Find the corresponding entry in the search. Note that the SMB server returns
+ * search entries for . and .. which complicates logic here if we choose to
+ * parse for them and we do not assume that they are located in the findfirst
+ * return buffer. We start counting in the buffer with entry 2 and increment for
+ * every entry (do not increment for . or .. entry).
+ */
+static int
+find_cifs_entry(const unsigned int xid, struct cifs_tcon *tcon,
+		struct file *file, char **current_entry, int *num_to_ret)
 {
 	__u16 search_flags;
 	int rc = 0;
 	int pos_in_buf = 0;
 	loff_t first_entry_in_buffer;
 	loff_t index_to_find = file->f_pos;
-	struct cifsFileInfo *cifsFile = file->private_data;
+	struct cifsFileInfo *cfile = file->private_data;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
+	struct TCP_Server_Info *server = tcon->ses->server;
 	/* check if index in the buffer */
 
-	if ((cifsFile == NULL) || (ppCurrentEntry == NULL) ||
-	   (num_to_ret == NULL))
+	if (!server->ops->query_dir_first || !server->ops->query_dir_next)
+		return -ENOSYS;
+
+	if ((cfile == NULL) || (current_entry == NULL) || (num_to_ret == NULL))
 		return -ENOENT;
 
-	*ppCurrentEntry = NULL;
-	first_entry_in_buffer =
-		cifsFile->srch_inf.index_of_last_entry -
-			cifsFile->srch_inf.entries_in_buffer;
+	*current_entry = NULL;
+	first_entry_in_buffer = cfile->srch_inf.index_of_last_entry -
+					cfile->srch_inf.entries_in_buffer;
 
-	/* if first entry in buf is zero then is first buffer
-	in search response data which means it is likely . and ..
-	will be in this buffer, although some servers do not return
-	. and .. for the root of a drive and for those we need
-	to start two entries earlier */
+	/*
+	 * If first entry in buf is zero then is first buffer
+	 * in search response data which means it is likely . and ..
+	 * will be in this buffer, although some servers do not return
+	 * . and .. for the root of a drive and for those we need
+	 * to start two entries earlier.
+	 */
 
 	dump_cifs_file_struct(file, "In fce ");
-	if (((index_to_find < cifsFile->srch_inf.index_of_last_entry) &&
-	     is_dir_changed(file)) ||
-	   (index_to_find < first_entry_in_buffer)) {
+	if (((index_to_find < cfile->srch_inf.index_of_last_entry) &&
+	     is_dir_changed(file)) || (index_to_find < first_entry_in_buffer)) {
 		/* close and restart search */
 		cFYI(1, "search backing up - close and restart search");
 		spin_lock(&cifs_file_list_lock);
-		if (!cifsFile->srch_inf.endOfSearch &&
-		    !cifsFile->invalidHandle) {
-			cifsFile->invalidHandle = true;
+		if (!cfile->srch_inf.endOfSearch && !cfile->invalidHandle) {
+			cfile->invalidHandle = true;
 			spin_unlock(&cifs_file_list_lock);
-			CIFSFindClose(xid, pTcon, cifsFile->fid.netfid);
+			if (server->ops->close)
+				server->ops->close(xid, tcon, &cfile->fid);
 		} else
 			spin_unlock(&cifs_file_list_lock);
-		if (cifsFile->srch_inf.ntwrk_buf_start) {
+		if (cfile->srch_inf.ntwrk_buf_start) {
 			cFYI(1, "freeing SMB ff cache buf on search rewind");
-			if (cifsFile->srch_inf.smallBuf)
-				cifs_small_buf_release(cifsFile->srch_inf.
+			if (cfile->srch_inf.smallBuf)
+				cifs_small_buf_release(cfile->srch_inf.
 						ntwrk_buf_start);
 			else
-				cifs_buf_release(cifsFile->srch_inf.
+				cifs_buf_release(cfile->srch_inf.
 						ntwrk_buf_start);
-			cifsFile->srch_inf.ntwrk_buf_start = NULL;
+			cfile->srch_inf.ntwrk_buf_start = NULL;
 		}
 		rc = initiate_cifs_search(xid, file);
 		if (rc) {
@@ -565,65 +579,64 @@ static int find_cifs_entry(const unsigned int xid, struct cifs_tcon *pTcon,
 			return rc;
 		}
 		/* FindFirst/Next set last_entry to NULL on malformed reply */
-		if (cifsFile->srch_inf.last_entry)
-			cifs_save_resume_key(cifsFile->srch_inf.last_entry,
-						cifsFile);
+		if (cfile->srch_inf.last_entry)
+			cifs_save_resume_key(cfile->srch_inf.last_entry, cfile);
 	}
 
 	search_flags = CIFS_SEARCH_CLOSE_AT_END | CIFS_SEARCH_RETURN_RESUME;
 	if (backup_cred(cifs_sb))
 		search_flags |= CIFS_SEARCH_BACKUP_SEARCH;
 
-	while ((index_to_find >= cifsFile->srch_inf.index_of_last_entry) &&
-	      (rc == 0) && !cifsFile->srch_inf.endOfSearch) {
+	while ((index_to_find >= cfile->srch_inf.index_of_last_entry) &&
+	       (rc == 0) && !cfile->srch_inf.endOfSearch) {
 		cFYI(1, "calling findnext2");
-		rc = CIFSFindNext(xid, pTcon, cifsFile->fid.netfid,
-				  search_flags, &cifsFile->srch_inf);
+		rc = server->ops->query_dir_next(xid, tcon, &cfile->fid,
+						 search_flags,
+						 &cfile->srch_inf);
 		/* FindFirst/Next set last_entry to NULL on malformed reply */
-		if (cifsFile->srch_inf.last_entry)
-			cifs_save_resume_key(cifsFile->srch_inf.last_entry,
-						cifsFile);
+		if (cfile->srch_inf.last_entry)
+			cifs_save_resume_key(cfile->srch_inf.last_entry, cfile);
 		if (rc)
 			return -ENOENT;
 	}
-	if (index_to_find < cifsFile->srch_inf.index_of_last_entry) {
+	if (index_to_find < cfile->srch_inf.index_of_last_entry) {
 		/* we found the buffer that contains the entry */
 		/* scan and find it */
 		int i;
-		char *current_entry;
-		char *end_of_smb = cifsFile->srch_inf.ntwrk_buf_start +
-			smbCalcSize((struct smb_hdr *)
-				cifsFile->srch_inf.ntwrk_buf_start);
-
-		current_entry = cifsFile->srch_inf.srch_entries_start;
-		first_entry_in_buffer = cifsFile->srch_inf.index_of_last_entry
-					- cifsFile->srch_inf.entries_in_buffer;
+		char *cur_ent;
+		char *end_of_smb = cfile->srch_inf.ntwrk_buf_start +
+			server->ops->calc_smb_size(
+					cfile->srch_inf.ntwrk_buf_start);
+
+		cur_ent = cfile->srch_inf.srch_entries_start;
+		first_entry_in_buffer = cfile->srch_inf.index_of_last_entry
+					- cfile->srch_inf.entries_in_buffer;
 		pos_in_buf = index_to_find - first_entry_in_buffer;
 		cFYI(1, "found entry - pos_in_buf %d", pos_in_buf);
 
-		for (i = 0; (i < (pos_in_buf)) && (current_entry != NULL); i++) {
+		for (i = 0; (i < (pos_in_buf)) && (cur_ent != NULL); i++) {
 			/* go entry by entry figuring out which is first */
-			current_entry = nxt_dir_entry(current_entry, end_of_smb,
-						cifsFile->srch_inf.info_level);
+			cur_ent = nxt_dir_entry(cur_ent, end_of_smb,
+						cfile->srch_inf.info_level);
 		}
-		if ((current_entry == NULL) && (i < pos_in_buf)) {
+		if ((cur_ent == NULL) && (i < pos_in_buf)) {
 			/* BB fixme - check if we should flag this error */
 			cERROR(1, "reached end of buf searching for pos in buf"
-			  " %d index to find %lld rc %d",
-			  pos_in_buf, index_to_find, rc);
+				  " %d index to find %lld rc %d", pos_in_buf,
+				  index_to_find, rc);
 		}
 		rc = 0;
-		*ppCurrentEntry = current_entry;
+		*current_entry = cur_ent;
 	} else {
 		cFYI(1, "index not in buffer - could not findnext into it");
 		return 0;
 	}
 
-	if (pos_in_buf >= cifsFile->srch_inf.entries_in_buffer) {
+	if (pos_in_buf >= cfile->srch_inf.entries_in_buffer) {
 		cFYI(1, "can not return entries pos_in_buf beyond last");
 		*num_to_ret = 0;
 	} else
-		*num_to_ret = cifsFile->srch_inf.entries_in_buffer - pos_in_buf;
+		*num_to_ret = cfile->srch_inf.entries_in_buffer - pos_in_buf;
 
 	return rc;
 }
@@ -723,7 +736,7 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 	int rc = 0;
 	unsigned int xid;
 	int i;
-	struct cifs_tcon *pTcon;
+	struct cifs_tcon *tcon;
 	struct cifsFileInfo *cifsFile = NULL;
 	char *current_entry;
 	int num_to_fill = 0;
@@ -781,12 +794,12 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 			}
 		} /* else {
 			cifsFile->invalidHandle = true;
-			CIFSFindClose(xid, pTcon, cifsFile->fid.netfid);
+			tcon->ses->server->close(xid, tcon, &cifsFile->fid);
 		} */
 
-		pTcon = tlink_tcon(cifsFile->tlink);
-		rc = find_cifs_entry(xid, pTcon, file,
-				&current_entry, &num_to_fill);
+		tcon = tlink_tcon(cifsFile->tlink);
+		rc = find_cifs_entry(xid, tcon, file, &current_entry,
+				     &num_to_fill);
 		if (rc) {
 			cFYI(1, "fce error %d", rc);
 			goto rddir2_exit;
@@ -798,7 +811,7 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 		}
 		cFYI(1, "loop through %d times filling dir for net buf %p",
 			num_to_fill, cifsFile->srch_inf.ntwrk_buf_start);
-		max_len = smbCalcSize((struct smb_hdr *)
+		max_len = tcon->ses->server->ops->calc_smb_size(
 				cifsFile->srch_inf.ntwrk_buf_start);
 		end_of_smb = cifsFile->srch_inf.ntwrk_buf_start + max_len;
 
@@ -815,10 +828,12 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 					  num_to_fill, i);
 				break;
 			}
-			/* if buggy server returns . and .. late do
-			we want to check for that here? */
-			rc = cifs_filldir(current_entry, file,
-					filldir, direntry, tmp_buf, max_len);
+			/*
+			 * if buggy server returns . and .. late do we want to
+			 * check for that here?
+			 */
+			rc = cifs_filldir(current_entry, file, filldir,
+					  direntry, tmp_buf, max_len);
 			if (rc == -EOVERFLOW) {
 				rc = 0;
 				break;
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index ed31196..068d609 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -836,6 +836,33 @@ out:
 	return rc;
 }
 
+static int
+cifs_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
+		     const char *path, struct cifs_sb_info *cifs_sb,
+		     struct cifs_fid *fid, __u16 search_flags,
+		     struct cifs_search_info *srch_inf)
+{
+	return CIFSFindFirst(xid, tcon, path, cifs_sb->local_nls,
+			     &fid->netfid, search_flags, srch_inf,
+			     cifs_sb->mnt_cifs_flags &
+			     CIFS_MOUNT_MAP_SPECIAL_CHR, CIFS_DIR_SEP(cifs_sb));
+}
+
+static int
+cifs_query_dir_next(const unsigned int xid, struct cifs_tcon *tcon,
+		    struct cifs_fid *fid, __u16 search_flags,
+		    struct cifs_search_info *srch_inf)
+{
+	return CIFSFindNext(xid, tcon, fid->netfid, search_flags, srch_inf);
+}
+
+static int
+cifs_close_dir(const unsigned int xid, struct cifs_tcon *tcon,
+	       struct cifs_fid *fid)
+{
+	return CIFSFindClose(xid, tcon, fid->netfid);
+}
+
 struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
 	.compare_fids = cifs_compare_fids,
@@ -891,6 +918,10 @@ struct smb_version_operations smb1_operations = {
 	.async_writev = cifs_async_writev,
 	.sync_read = cifs_sync_read,
 	.sync_write = cifs_sync_write,
+	.query_dir_first = cifs_query_dir_first,
+	.query_dir_next = cifs_query_dir_next,
+	.close_dir = cifs_close_dir,
+	.calc_smb_size = smbCalcSize,
 };
 
 struct smb_version_values smb1_values = {
-- 
1.7.1
