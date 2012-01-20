From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 39/50] CIFS: Add SMB2 support for flush operation
Date: Fri, 20 Jan 2012 12:35:00 +0400
Message-ID: <1327048511-2342-39-git-send-email-piastry@etersoft.ru>
References: <1327048511-2342-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1327048511-2342-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    1 +
 fs/cifs/cifsproto.h |    5 +++++
 fs/cifs/file.c      |   34 +++++++++++++++++++++++++---------
 fs/cifs/smb2file.c  |   30 ++++++++++++++++++++++++------
 fs/cifs/smb2pdu.c   |   40 ++++++++++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.h   |   15 +++++++++++++++
 fs/cifs/smb2proto.h |    6 ++++++
 7 files changed, 116 insertions(+), 15 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 69d2b31..3c525b8 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -656,6 +656,7 @@ typedef int (iread_callback_t)(int, struct cifsFileInfo *,
 typedef int (read_callback_t)(int, struct cifsFileInfo *,
 			      struct cifs_io_parms *, unsigned int *, char **,
 			      int *, unsigned int);
+typedef int (fsync_callback_t)(int, struct cifsFileInfo *);
 
 /*
  * Take a reference on the file private data. Must be called with
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index d549a22..1a32f98 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -225,6 +225,11 @@ extern int cifs_is_dir_changed(struct file *file);
 extern struct dentry *cifs_readdir_lookup(struct dentry *parent,
 					  struct qstr *name,
 					  struct cifs_fattr *fattr);
+extern int cifs_strict_fsync_generic(struct file *file, loff_t start,
+				     loff_t end, int datasync,
+				     fsync_callback_t *fsync_cb);
+extern int cifs_fsync_generic(struct file *file, loff_t start, loff_t end,
+			      int datasync, fsync_callback_t *fsync_cb);
 void cifs_proc_init(void);
 void cifs_proc_clean(void);
 
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index b5912c2..c2e108b 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2065,12 +2065,17 @@ int cifs_write_end(struct file *file, struct address_space *mapping, loff_t pos,
 	return rc;
 }
 
-int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
-		      int datasync)
+static int
+cifs_fsync_cb(int xid, struct cifsFileInfo *cfile)
+{
+	return CIFSSMBFlush(xid, tlink_tcon(cfile->tlink), cfile->netfid);
+}
+
+int cifs_strict_fsync_generic(struct file *file, loff_t start, loff_t end,
+			      int datasync, fsync_callback_t *fsync_cb)
 {
 	int xid;
 	int rc = 0;
-	struct cifs_tcon *tcon;
 	struct cifsFileInfo *smbfile = file->private_data;
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
@@ -2093,20 +2098,26 @@ int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
 		}
 	}
 
-	tcon = tlink_tcon(smbfile->tlink);
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
-		rc = CIFSSMBFlush(xid, tcon, smbfile->netfid);
+		rc = fsync_cb(xid, smbfile);
 
 	FreeXid(xid);
 	mutex_unlock(&inode->i_mutex);
 	return rc;
 }
 
-int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+int
+cifs_strict_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+{
+	return cifs_strict_fsync_generic(file, datasync, start, end,
+					 cifs_fsync_cb);
+}
+
+int cifs_fsync_generic(struct file *file, loff_t start, loff_t end,
+		       int datasync, fsync_callback_t *fsync_cb)
 {
 	int xid;
 	int rc = 0;
-	struct cifs_tcon *tcon;
 	struct cifsFileInfo *smbfile = file->private_data;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
 	struct inode *inode = file->f_mapping->host;
@@ -2121,15 +2132,20 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	cFYI(1, "Sync file - name: %s datasync: 0x%x",
 		file->f_path.dentry->d_name.name, datasync);
 
-	tcon = tlink_tcon(smbfile->tlink);
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
-		rc = CIFSSMBFlush(xid, tcon, smbfile->netfid);
+		rc = fsync_cb(xid, smbfile);
 
 	FreeXid(xid);
 	mutex_unlock(&inode->i_mutex);
 	return rc;
 }
 
+int
+cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+{
+	return cifs_fsync_generic(file, start, end, datasync, cifs_fsync_cb);
+}
+
 /*
  * As file closes, flush all cached write data for this inode checking
  * for write behind errors.
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 3cfef35..2d5e2db 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -42,7 +42,7 @@ const struct file_operations smb2_file_ops = {
 	.open = smb2_open,
 	.release = cifs_close,
 	.lock = cifs_lock,
-	.fsync = cifs_fsync,
+	.fsync = smb2_fsync,
 	.flush = cifs_flush,
 	.mmap  = cifs_file_mmap,
 	.splice_read = generic_file_splice_read,
@@ -61,7 +61,7 @@ const struct file_operations smb2_file_strict_ops = {
 	.open = smb2_open,
 	.release = cifs_close,
 	.lock = cifs_lock,
-	.fsync = cifs_strict_fsync,
+	.fsync = smb2_strict_fsync,
 	.flush = cifs_flush,
 	.mmap = cifs_file_strict_mmap,
 	.splice_read = generic_file_splice_read,
@@ -81,7 +81,7 @@ const struct file_operations smb2_file_direct_ops = {
 	.open = smb2_open,
 	.release = cifs_close,
 	.lock = cifs_lock,
-	.fsync = cifs_fsync,
+	.fsync = smb2_fsync,
 	.flush = cifs_flush,
 	.mmap = cifs_file_mmap,
 	.splice_read = generic_file_splice_read,
@@ -99,7 +99,7 @@ const struct file_operations smb2_file_nobrl_ops = {
 	.aio_write = cifs_file_aio_write,
 	.open = smb2_open,
 	.release = cifs_close,
-	.fsync = cifs_fsync,
+	.fsync = smb2_fsync,
 	.flush = cifs_flush,
 	.mmap  = cifs_file_mmap,
 	.splice_read = generic_file_splice_read,
@@ -117,7 +117,7 @@ const struct file_operations smb2_file_strict_nobrl_ops = {
 	.aio_write = cifs_strict_writev,
 	.open = smb2_open,
 	.release = cifs_close,
-	.fsync = cifs_strict_fsync,
+	.fsync = smb2_strict_fsync,
 	.flush = cifs_flush,
 	.mmap = cifs_file_strict_mmap,
 	.splice_read = generic_file_splice_read,
@@ -136,7 +136,7 @@ const struct file_operations smb2_file_direct_nobrl_ops = {
 	.aio_write = smb2_user_writev,
 	.open = smb2_open,
 	.release = cifs_close,
-	.fsync = cifs_fsync,
+	.fsync = smb2_fsync,
 	.flush = cifs_flush,
 	.mmap = cifs_file_mmap,
 	.splice_read = generic_file_splice_read,
@@ -473,3 +473,21 @@ smb2_readpages(struct file *file, struct address_space *mapping,
 	return cifs_readpages_generic(file, mapping, page_list, num_pages,
 				      smb2_async_readv);
 }
+
+static int
+smb2_fsync_cb(int xid, struct cifsFileInfo *cfile)
+{
+	return SMB2_flush(xid, tlink_tcon(cfile->tlink), cfile->persist_fid,
+			  cfile->volatile_fid);
+}
+
+int smb2_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+{
+	return cifs_fsync_generic(file, start, end, datasync, smb2_fsync_cb);
+}
+
+int smb2_strict_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+{
+	return cifs_strict_fsync_generic(file, start, end, datasync,
+					 smb2_fsync_cb);
+}
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index ae1eb69..31e735f 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1842,3 +1842,43 @@ set_link_exit:
 	free_rsp_buf(resp_buftype, pSMB2r);
 	return rc;
 }
+
+int SMB2_flush(const int xid, struct cifs_tcon *tcon,
+	       u64 persistent_file_id, u64 volatile_file_id)
+{
+	struct smb2_flush_req *pSMB2;
+	struct TCP_Server_Info *server;
+	struct cifs_ses *ses = tcon->ses;
+	struct kvec iov[1];
+	int resp_buftype;
+	int status;
+	int rc = 0;
+
+	cFYI(1, "Flush");
+
+	if (ses && (ses->server))
+		server = ses->server;
+	else
+		return -EIO;
+
+	rc = small_smb2_init(SMB2_FLUSH, tcon, (void **) &pSMB2);
+	if (rc)
+		return rc;
+
+	pSMB2->PersistentFileId = persistent_file_id;
+	pSMB2->VolatileFileId = volatile_file_id;
+
+	iov[0].iov_base = (char *)pSMB2;
+	iov[0].iov_len = be32_to_cpu(pSMB2->hdr.smb2_buf_length)
+					+ 4 /* rfc1001 len */;
+
+	rc = smb2_sendrcv2(xid, ses, iov, 1, &resp_buftype /* ret */, &status,
+			   CIFS_STD_OP | CIFS_LOG_ERROR);
+	cFYI(1, "FLUSH rc %d status %d", rc, status);
+
+	if ((rc != 0) && tcon)
+		cifs_stats_fail_inc(tcon, SMB2FLUSH);
+
+	free_rsp_buf(resp_buftype, iov[0].iov_base);
+	return rc;
+}
diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 4d0fa6e..7d7c596 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -441,6 +441,21 @@ struct smb2_close_rsp {
 	__le32 Attributes;
 } __packed;
 
+struct smb2_flush_req {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;	/* Must be 24 */
+	__le16 Reserved1;
+	__le32 Reserved2;
+	__u64  PersistentFileId; /* opaque endianness */
+	__u64  VolatileFileId; /* opaque endianness */
+} __packed;
+
+struct smb2_flush_rsp {
+	struct smb2_hdr hdr;
+	__le16 StructureSize;
+	__le16 Reserved;
+} __packed;
+
 struct smb2_read_req {
 	struct smb2_hdr hdr;
 	__le16 StructureSize; /* Must be 49 */
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 61814bf..baf46d3 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -120,6 +120,10 @@ extern int smb2_writepages(struct address_space *mapping,
 			   struct writeback_control *wbc);
 extern int smb2_readpages(struct file *file, struct address_space *mapping,
 			  struct list_head *page_list, unsigned num_pages);
+extern int smb2_strict_fsync(struct file *file, loff_t start, loff_t end,
+			     int datasync);
+extern int smb2_fsync(struct file *file, loff_t start, loff_t end,
+		      int datasync);
 
 /*
  *  SMB2 Worker functions - most of protocol specific implementation details
@@ -162,5 +166,7 @@ extern int SMB2_rename(const int xid, struct cifs_tcon *tcon,
 extern int SMB2_set_hardlink(const int xid, struct cifs_tcon *tcon,
 			     u64 persistent_fid, u64 volatile_fid,
 			     __le16 *target_file);
+extern int SMB2_flush(const int xid, struct cifs_tcon *tcon,
+		      u64 persistent_file_id, u64 volatile_file_id);
 
 #endif			/* _SMB2PROTO_H */
-- 
1.7.1
