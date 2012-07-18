From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 26/45] CIFS: Move readpage code to ops struct
Date: Wed, 18 Jul 2012 19:48:42 +0400
Message-ID: <1342626541-29872-27-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h |    5 +++++
 fs/cifs/file.c     |   28 +++++++++++++++++-----------
 fs/cifs/smb1ops.c  |   10 ++++++++++
 3 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 68eda60..222d865 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -174,6 +174,7 @@ struct smb_vol;
 struct cifs_fid;
 struct cifs_readdata;
 struct cifs_writedata;
+struct cifs_io_parms;
 
 struct smb_version_operations {
 	int (*send_cancel)(struct TCP_Server_Info *, void *,
@@ -286,6 +287,10 @@ struct smb_version_operations {
 	int (*async_readv)(struct cifs_readdata *);
 	/* async write to the server */
 	int (*async_writev)(struct cifs_writedata *);
+	/* sync read from the server */
+	int (*sync_read)(const unsigned int, struct cifsFileInfo *,
+			 struct cifs_io_parms *, unsigned int *, char **,
+			 int *);
 };
 
 struct smb_version_values {
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index fd2c8bb..6b92bbe 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2771,8 +2771,8 @@ ssize_t cifs_strict_readv(struct kiocb *iocb, const struct iovec *iov,
 	return cifs_user_readv(iocb, iov, nr_segs, pos);
 }
 
-static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
-			 loff_t *poffset)
+static ssize_t
+cifs_read(struct file *file, char *read_data, size_t read_size, loff_t *offset)
 {
 	int rc = -EACCES;
 	unsigned int bytes_read = 0;
@@ -2781,8 +2781,9 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 	unsigned int rsize;
 	struct cifs_sb_info *cifs_sb;
 	struct cifs_tcon *tcon;
+	struct TCP_Server_Info *server;
 	unsigned int xid;
-	char *current_offset;
+	char *cur_offset;
 	struct cifsFileInfo *open_file;
 	struct cifs_io_parms io_parms;
 	int buf_type = CIFS_NO_BUFFER;
@@ -2801,6 +2802,12 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 	}
 	open_file = file->private_data;
 	tcon = tlink_tcon(open_file->tlink);
+	server = tcon->ses->server;
+
+	if (!server->ops->sync_read) {
+		free_xid(xid);
+		return -ENOSYS;
+	}
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
 		pid = open_file->pid;
@@ -2810,9 +2817,8 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
 		cFYI(1, "attempting read on write only file instance");
 
-	for (total_read = 0, current_offset = read_data;
-	     read_size > total_read;
-	     total_read += bytes_read, current_offset += bytes_read) {
+	for (total_read = 0, cur_offset = read_data; read_size > total_read;
+	     total_read += bytes_read, cur_offset += bytes_read) {
 		current_read_size = min_t(uint, read_size - total_read, rsize);
 		/*
 		 * For windows me and 9x we do not want to request more than it
@@ -2830,13 +2836,13 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 				if (rc != 0)
 					break;
 			}
-			io_parms.netfid = open_file->fid.netfid;
 			io_parms.pid = pid;
 			io_parms.tcon = tcon;
-			io_parms.offset = *poffset;
+			io_parms.offset = *offset;
 			io_parms.length = current_read_size;
-			rc = CIFSSMBRead(xid, &io_parms, &bytes_read,
-					 &current_offset, &buf_type);
+			rc = server->ops->sync_read(xid, open_file, &io_parms,
+						    &bytes_read, &cur_offset,
+						    &buf_type);
 		}
 		if (rc || (bytes_read == 0)) {
 			if (total_read) {
@@ -2847,7 +2853,7 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 			}
 		} else {
 			cifs_stats_bytes_read(tcon, total_read);
-			*poffset += bytes_read;
+			*offset += bytes_read;
 		}
 	}
 	free_xid(xid);
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index 50c3697..cea958e 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -739,6 +739,15 @@ cifs_flush_file(const unsigned int xid, struct cifs_tcon *tcon,
 	return CIFSSMBFlush(xid, tcon, fid->netfid);
 }
 
+static int
+cifs_sync_read(const unsigned int xid, struct cifsFileInfo *cfile,
+	       struct cifs_io_parms *parms, unsigned int *bytes_read,
+	       char **buf, int *buf_type)
+{
+	parms->netfid = cfile->fid.netfid;
+	return CIFSSMBRead(xid, parms, bytes_read, buf, buf_type);
+}
+
 struct smb_version_operations smb1_operations = {
 	.send_cancel = send_nt_cancel,
 	.compare_fids = cifs_compare_fids,
@@ -787,6 +796,7 @@ struct smb_version_operations smb1_operations = {
 	.flush = cifs_flush_file,
 	.async_readv = cifs_async_readv,
 	.async_writev = cifs_async_writev,
+	.sync_read = cifs_sync_read,
 };
 
 struct smb_version_values smb1_values = {
-- 
1.7.1
