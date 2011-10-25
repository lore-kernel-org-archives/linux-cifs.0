From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 28/53] CIFS: Add write related address space operations for SMB2
Date: Tue, 25 Oct 2011 10:12:01 +0400
Message-ID: <1319523146-2859-29-git-send-email-piastry@etersoft.ru>
References: <1319523146-2859-1-git-send-email-piastry@etersoft.ru>
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319523146-2859-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

and temporarily disable writepages support.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/file.c      |   35 +++++++++++++++++++++++++++++------
 fs/cifs/smb2file.c  |   16 ++++++++++++++--
 fs/cifs/smb2proto.h |    4 ++++
 3 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index f20b38c..4e9616d 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1461,9 +1461,10 @@ cifs_update_eof(struct cifsInodeInfo *cifsi, loff_t offset,
 		cifsi->server_eof = end_of_write;
 }
 
-static ssize_t cifs_write(struct cifsFileInfo *open_file, __u32 pid,
-			  const char *write_data, size_t write_size,
-			  loff_t *poffset)
+static ssize_t
+cifs_write_generic(struct cifsFileInfo *open_file, __u32 pid,
+		   const char *write_data, size_t write_size, loff_t *poffset,
+		   iwrite_callback_t *write_cb)
 {
 	int rc = 0;
 	unsigned int bytes_written = 0;
@@ -1506,13 +1507,12 @@ static ssize_t cifs_write(struct cifsFileInfo *open_file, __u32 pid,
 			/* iov[0] is reserved for smb header */
 			iov[1].iov_base = (char *)write_data + total_written;
 			iov[1].iov_len = len;
-			io_parms.netfid = open_file->netfid;
 			io_parms.pid = pid;
 			io_parms.tcon = pTcon;
 			io_parms.offset = *poffset;
 			io_parms.length = len;
-			rc = CIFSSMBWrite2(xid, &io_parms, &bytes_written, iov,
-					   1, 0);
+			rc = write_cb(xid, open_file, &io_parms, &bytes_written,
+				      iov, 1, write_size - total_written, 0);
 		}
 		if (rc || (bytes_written == 0)) {
 			if (total_written)
@@ -1540,6 +1540,29 @@ static ssize_t cifs_write(struct cifsFileInfo *open_file, __u32 pid,
 	return total_written;
 }
 
+static int cifs_write_cb(int xid, struct cifsFileInfo *cfile,
+			 struct cifs_io_parms *parms, unsigned int *written,
+			 struct kvec *iov, unsigned long nr_segs,
+			 unsigned int remaining_bytes, int timeout)
+{
+
+	parms->netfid = cfile->netfid;
+	return CIFSSMBWrite2(xid, parms, written, iov, nr_segs, timeout);
+}
+
+static ssize_t
+cifs_write(struct cifsFileInfo *cfile, __u32 pid, const char *write_data,
+	   size_t write_size, loff_t *offset)
+{
+#ifdef CONFIG_CIFS_SMB2
+	if (tlink_tcon(cfile->tlink)->ses->server->is_smb2)
+		return cifs_write_generic(cfile, pid, write_data, write_size,
+					  offset, smb2_write_cb);
+#endif
+	return cifs_write_generic(cfile, pid, write_data, write_size, offset,
+				  cifs_write_cb);
+}
+
 struct cifsFileInfo *find_readable_file(struct cifsInodeInfo *cifs_inode,
 					bool fsuid_only)
 {
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 39a98c2..69e880f 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -152,7 +152,7 @@ const struct address_space_operations smb2_addr_ops = {
 	.readpage = cifs_readpage,
 	/*.readpages = cifs_readpages,*/
 	.writepage = cifs_writepage,
-	.writepages = cifs_writepages,
+	/*.writepages = cifs_writepages,*/
 	.write_begin = cifs_write_begin,
 	.write_end = cifs_write_end,
 	.set_page_dirty = __set_page_dirty_nobuffers,
@@ -169,7 +169,7 @@ const struct address_space_operations smb2_addr_ops = {
 const struct address_space_operations smb2_addr_ops_smallbuf = {
 	.readpage = cifs_readpage,
 	.writepage = cifs_writepage,
-	.writepages = cifs_writepages,
+	/*.writepages = cifs_writepages,*/
 	.write_begin = cifs_write_begin,
 	.write_end = cifs_write_end,
 	.set_page_dirty = __set_page_dirty_nobuffers,
@@ -452,3 +452,15 @@ smb2_read_cb(int xid, struct cifsFileInfo *cfile, struct cifs_io_parms *parms,
 	return SMB2_read(xid, parms, bytes_read, buf, buf_type,
 			 remaining_bytes);
 }
+
+int
+smb2_write_cb(int xid, struct cifsFileInfo *cfile, struct cifs_io_parms *parms,
+	      unsigned int *written, struct kvec *iov, unsigned long nr_segs,
+	      unsigned int remaining_bytes, int timeout)
+{
+
+	parms->persist_fid = cfile->persist_fid;
+	parms->volatile_fid = cfile->volatile_fid;
+	return SMB2_write(xid, parms, written, iov, nr_segs,
+			  remaining_bytes, timeout);
+}
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 529dbdd..7e92820 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -123,6 +123,10 @@ extern int smb2_read_cb(int xid, struct cifsFileInfo *cfile,
 			struct cifs_io_parms *parms, unsigned int *bytes_read,
 			char **buf, int *buf_type,
 			unsigned int remaining_bytes);
+extern int smb2_write_cb(int xid, struct cifsFileInfo *cfile,
+			 struct cifs_io_parms *parms, unsigned int *written,
+			 struct kvec *iov, unsigned long nr_segs,
+			 unsigned int remaining_bytes, int timeout);
 
 extern int smb2_open(struct inode *inode, struct file *file);
 extern ssize_t smb2_user_readv(struct kiocb *iocb, const struct iovec *iov,
-- 
1.7.1
