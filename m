From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 27/50] CIFS: Add read related address space operations for SMB2
Date: Fri, 20 Jan 2012 12:34:48 +0400
Message-ID: <1327048511-2342-27-git-send-email-piastry@etersoft.ru>
References: <1327048511-2342-1-git-send-email-piastry@etersoft.ru>
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1327048511-2342-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

and temporarily disable readpages support.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    3 +++
 fs/cifs/file.c      |   34 +++++++++++++++++++++++++++++-----
 fs/cifs/smb2file.c  |   13 ++++++++++++-
 fs/cifs/smb2pdu.c   |    7 ++++++-
 fs/cifs/smb2proto.h |    4 ++++
 5 files changed, 54 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index dedeb0f..31cce8e 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -610,6 +610,9 @@ typedef int (iwrite_callback_t)(int, struct cifsFileInfo *,
 typedef int (iread_callback_t)(int, struct cifsFileInfo *,
 			       struct cifs_io_parms *, unsigned int *, char **,
 			       char **, int *);
+typedef int (read_callback_t)(int, struct cifsFileInfo *,
+			      struct cifs_io_parms *, unsigned int *, char **,
+			      int *, unsigned int);
 
 /*
  * Take a reference on the file private data. Must be called with
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index f8adef8..e7c66bb 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2514,8 +2514,9 @@ ssize_t cifs_strict_readv(struct kiocb *iocb, const struct iovec *iov,
 	return cifs_user_readv(iocb, iov, nr_segs, pos);
 }
 
-static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
-			 loff_t *poffset)
+static ssize_t
+cifs_read_generic(struct file *file, char *read_data, size_t read_size,
+		  loff_t *poffset, read_callback_t *read_cb)
 {
 	int rc = -EACCES;
 	unsigned int bytes_read = 0;
@@ -2572,13 +2573,12 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 				if (rc != 0)
 					break;
 			}
-			io_parms.netfid = open_file->netfid;
 			io_parms.pid = pid;
 			io_parms.tcon = pTcon;
 			io_parms.offset = *poffset;
 			io_parms.length = current_read_size;
-			rc = CIFSSMBRead(xid, &io_parms, &bytes_read,
-					 &current_offset, &buf_type);
+			rc = read_cb(xid, open_file, &io_parms, &bytes_read,
+				     &current_offset, &buf_type, 0);
 		}
 		if (rc || (bytes_read == 0)) {
 			if (total_read) {
@@ -2596,6 +2596,30 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 	return total_read;
 }
 
+static int
+cifs_read_cb(int xid, struct cifsFileInfo *cfile, struct cifs_io_parms *parms,
+	     unsigned int *bytes_read, char **buf, int *buf_type,
+	     unsigned int remaining_bytes)
+{
+	parms->netfid = cfile->netfid;
+	return CIFSSMBRead(xid, parms, bytes_read, buf, buf_type);
+}
+
+static ssize_t
+cifs_read(struct file *file, char *read_data, size_t read_size, loff_t *offset)
+{
+#ifdef CONFIG_CIFS_SMB2
+	struct cifsFileInfo *cfile = (struct cifsFileInfo *)file->private_data;
+
+	if (tlink_tcon(cfile->tlink)->ses->server->is_smb2)
+		return cifs_read_generic(file, read_data, read_size, offset,
+					 smb2_read_cb);
+#endif
+
+	return cifs_read_generic(file, read_data, read_size, offset,
+				 cifs_read_cb);
+}
+
 /*
  * If the page is mmap'ed into a process' page tables, then we need to make
  * sure that it doesn't change while being written back.
diff --git a/fs/cifs/smb2file.c b/fs/cifs/smb2file.c
index 99d4c5f..9cdc0a1 100644
--- a/fs/cifs/smb2file.c
+++ b/fs/cifs/smb2file.c
@@ -149,7 +149,7 @@ const struct file_operations smb2_file_direct_nobrl_ops = {
 
 const struct address_space_operations smb2_addr_ops = {
 	.readpage = cifs_readpage,
-	.readpages = cifs_readpages,
+	/*.readpages = cifs_readpages,*/
 	.writepage = cifs_writepage,
 	.writepages = cifs_writepages,
 	.write_begin = cifs_write_begin,
@@ -436,3 +436,14 @@ ssize_t smb2_user_readv(struct kiocb *iocb, const struct iovec *iov,
 
 	return read;
 }
+
+int
+smb2_read_cb(int xid, struct cifsFileInfo *cfile, struct cifs_io_parms *parms,
+	     unsigned int *bytes_read, char **buf, int *buf_type,
+	     unsigned int remaining_bytes)
+{
+	parms->persist_fid = cfile->persist_fid;
+	parms->volatile_fid = cfile->volatile_fid;
+	return SMB2_read(xid, parms, bytes_read, buf, buf_type,
+			 remaining_bytes);
+}
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index c4d4928..f323d6d 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1221,7 +1221,12 @@ int SMB2_read(const int xid, struct cifs_io_parms *io_parms,
 			*nbytes = 0;
 		}
 	}
-	if (resp_buftype != CIFS_NO_BUFFER) {
+
+	if (*buf) {
+		memcpy(*buf, (char *)pSMB2r->hdr.ProtocolId +
+			pSMB2r->DataOffset, *nbytes);
+		free_rsp_buf(resp_buftype, iov[0].iov_base);
+	} else if (resp_buftype != CIFS_NO_BUFFER) {
 		*buf = iov[0].iov_base;
 		if (resp_buftype == CIFS_SMALL_BUFFER)
 			*pbuf_type = CIFS_SMALL_BUFFER;
diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
index 6c73551..7ce37dd 100644
--- a/fs/cifs/smb2proto.h
+++ b/fs/cifs/smb2proto.h
@@ -87,6 +87,10 @@ extern ssize_t smb2_user_writev(struct kiocb *iocb, const struct iovec *iov,
 				unsigned long nr_segs, loff_t pos);
 extern ssize_t smb2_user_readv(struct kiocb *iocb, const struct iovec *iov,
 			       unsigned long nr_segs, loff_t pos);
+extern int smb2_read_cb(int xid, struct cifsFileInfo *cfile,
+			struct cifs_io_parms *parms, unsigned int *bytes_read,
+			char **buf, int *buf_type,
+			unsigned int remaining_bytes);
 
 /*
  *  SMB2 Worker functions - most of protocol specific implementation details
-- 
1.7.1
