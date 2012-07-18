From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 28/45] CIFS: Move writepage to ops struct
Date: Wed, 18 Jul 2012 19:48:44 +0400
Message-ID: <1342626541-29872-29-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    4 ++++
 fs/cifs/cifsproto.h |    3 +--
 fs/cifs/cifssmb.c   |    6 ++----
 fs/cifs/file.c      |   36 ++++++++++++++++++++----------------
 fs/cifs/smb1ops.c   |   11 +++++++++++
 5 files changed, 38 insertions(+), 22 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 222d865..3e54b19 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -291,6 +291,10 @@ struct smb_version_operations {
 	int (*sync_read)(const unsigned int, struct cifsFileInfo *,
 			 struct cifs_io_parms *, unsigned int *, char **,
 			 int *);
+	/* sync write to the server */
+	int (*sync_write)(const unsigned int, struct cifsFileInfo *,
+			  struct cifs_io_parms *, unsigned int *, struct kvec *,
+			  unsigned long);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 01d5514..bdf8948 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -369,8 +369,7 @@ extern int CIFSSMBWrite(const unsigned int xid, struct cifs_io_parms *io_parms,
 			unsigned int *nbytes, const char *buf,
 			const char __user *ubuf, const int long_op);
 extern int CIFSSMBWrite2(const unsigned int xid, struct cifs_io_parms *io_parms,
-			unsigned int *nbytes, struct kvec *iov, const int nvec,
-			const int long_op);
+			unsigned int *nbytes, struct kvec *iov, const int nvec);
 extern int CIFSGetSrvInodeNumber(const unsigned int xid, struct cifs_tcon *tcon,
 				 const char *search_name, __u64 *inode_number,
 				 const struct nls_table *nls_codepage,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index d27c8be..666535c 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -2118,8 +2118,7 @@ async_writev_out:
 
 int
 CIFSSMBWrite2(const unsigned int xid, struct cifs_io_parms *io_parms,
-	      unsigned int *nbytes, struct kvec *iov, int n_vec,
-	      const int long_op)
+	      unsigned int *nbytes, struct kvec *iov, int n_vec)
 {
 	int rc = -EACCES;
 	WRITE_REQ *pSMB = NULL;
@@ -2190,8 +2189,7 @@ CIFSSMBWrite2(const unsigned int xid, struct cifs_io_parms *io_parms,
 		iov[0].iov_len = smb_hdr_len + 8;
 
 
-	rc = SendReceive2(xid, tcon->ses, iov, n_vec + 1, &resp_buf_type,
-			  long_op);
+	rc = SendReceive2(xid, tcon->ses, iov, n_vec + 1, &resp_buf_type, 0);
 	cifs_stats_inc(&tcon->stats.cifs_stats.num_writes);
 	if (rc) {
 		cFYI(1, "Send error Write2 = %d", rc);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 6b92bbe..2ffee05 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1470,15 +1470,16 @@ cifs_update_eof(struct cifsInodeInfo *cifsi, loff_t offset,
 		cifsi->server_eof = end_of_write;
 }
 
-static ssize_t cifs_write(struct cifsFileInfo *open_file, __u32 pid,
-			  const char *write_data, size_t write_size,
-			  loff_t *poffset)
+static ssize_t
+cifs_write(struct cifsFileInfo *open_file, __u32 pid, const char *write_data,
+	   size_t write_size, loff_t *offset)
 {
 	int rc = 0;
 	unsigned int bytes_written = 0;
 	unsigned int total_written;
 	struct cifs_sb_info *cifs_sb;
-	struct cifs_tcon *pTcon;
+	struct cifs_tcon *tcon;
+	struct TCP_Server_Info *server;
 	unsigned int xid;
 	struct dentry *dentry = open_file->dentry;
 	struct cifsInodeInfo *cifsi = CIFS_I(dentry->d_inode);
@@ -1487,9 +1488,13 @@ static ssize_t cifs_write(struct cifsFileInfo *open_file, __u32 pid,
 	cifs_sb = CIFS_SB(dentry->d_sb);
 
 	cFYI(1, "write %zd bytes to offset %lld of %s", write_size,
-	   *poffset, dentry->d_name.name);
+	     *offset, dentry->d_name.name);
+
+	tcon = tlink_tcon(open_file->tlink);
+	server = tcon->ses->server;
 
-	pTcon = tlink_tcon(open_file->tlink);
+	if (!server->ops->sync_write)
+		return -ENOSYS;
 
 	xid = get_xid();
 
@@ -1515,13 +1520,12 @@ static ssize_t cifs_write(struct cifsFileInfo *open_file, __u32 pid,
 			/* iov[0] is reserved for smb header */
 			iov[1].iov_base = (char *)write_data + total_written;
 			iov[1].iov_len = len;
-			io_parms.netfid = open_file->fid.netfid;
 			io_parms.pid = pid;
-			io_parms.tcon = pTcon;
-			io_parms.offset = *poffset;
+			io_parms.tcon = tcon;
+			io_parms.offset = *offset;
 			io_parms.length = len;
-			rc = CIFSSMBWrite2(xid, &io_parms, &bytes_written, iov,
-					   1, 0);
+			rc = server->ops->sync_write(xid, open_file, &io_parms,
+						     &bytes_written, iov, 1);
 		}
 		if (rc || (bytes_written == 0)) {
 			if (total_written)
@@ -1532,18 +1536,18 @@ static ssize_t cifs_write(struct cifsFileInfo *open_file, __u32 pid,
 			}
 		} else {
 			spin_lock(&dentry->d_inode->i_lock);
-			cifs_update_eof(cifsi, *poffset, bytes_written);
+			cifs_update_eof(cifsi, *offset, bytes_written);
 			spin_unlock(&dentry->d_inode->i_lock);
-			*poffset += bytes_written;
+			*offset += bytes_written;
 		}
 	}
 
-	cifs_stats_bytes_written(pTcon, total_written);
+	cifs_stats_bytes_written(tcon, total_written);
 
 	if (total_written > 0) {
 		spin_lock(&dentry->d_inode->i_lock);
-		if (*poffset > dentry->d_inode->i_size)
-			i_size_write(dentry->d_inode, *poffset);
+		if (*offset > dentry->d_inode->i_size)
+			i_size_write(dentry->d_inode, *offset);
 		spin_unlock(&dentry->d_inode->i_lock);
 	}
 	mark_inode_dirty_sync(dentry->d_inode);
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index cea958e..aa55c2f 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -748,6 +748,16 @@ cifs_sync_read(const unsigned int xid, struct cifsFileInfo *cfile,
 	return CIFSSMBRead(xid, parms, bytes_read, buf, buf_type);
 }
 
+static int
+cifs_sync_write(const unsigned int xid, struct cifsFileInfo *cfile,
+		struct cifs_io_parms *parms, unsigned int *written,
+		struct kvec *iov, unsigned long nr_segs)
+{
+
+	parms->netfid = cfile->fid.netfid;
+	return CIFSSMBWrite2(xid, parms, written, iov, nr_segs);
+}
+
 struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
 	.compare_fids = cifs_compare_fids,
@@ -797,6 +807,7 @@ struct smb_version_operations smb1_operations = {
 	.async_readv = cifs_async_readv,
 	.async_writev = cifs_async_writev,
 	.sync_read = cifs_sync_read,
+	.sync_write = cifs_sync_write,
 };
 
 struct smb_version_values smb1_values = {
-- 
1.7.1
