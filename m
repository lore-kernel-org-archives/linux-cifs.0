From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 2/2] CIFS: Add rwpidforward mount option
Date: Thu, 26 May 2011 10:02:00 +0400
Message-ID: <1306389721-28550-3-git-send-email-piastry@etersoft.ru>
References: <1306389721-28550-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1306389721-28550-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Add rwpidforward mount option that switches on a mode when we forward
pid of a process who opened a file to any read and write operation.

This can prevent applications like WINE from failing on read or write
operation on a previously locked file region from the same netfd from
another process if we use mandatory brlock style.

It is actual for WINE because during a run of WINE program two processes
work on the same netfd - share the same file struct between several VFS
fds:
1) WINE-server does open and lock;
2) WINE-application does read and write.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/README       |    3 ++
 fs/cifs/cifs_fs_sb.h |    1 +
 fs/cifs/cifsfs.c     |    8 +++++
 fs/cifs/cifsglob.h   |    1 +
 fs/cifs/cifsproto.h  |    5 +--
 fs/cifs/cifssmb.c    |   17 +++++++---
 fs/cifs/connect.c    |    4 ++
 fs/cifs/file.c       |   82 +++++++++++++++++++++++++++++++++++++------------
 fs/cifs/inode.c      |   11 +++++--
 fs/cifs/link.c       |   22 ++++++++-----
 10 files changed, 115 insertions(+), 39 deletions(-)

diff --git a/fs/cifs/README b/fs/cifs/README
index 4a3ca0e..c5c2c5e 100644
--- a/fs/cifs/README
+++ b/fs/cifs/README
@@ -457,6 +457,9 @@ A partial list of the supported mount options follows:
 		otherwise - read from the server. All written data are stored
 		in the cache, but if the client doesn't have Exclusive Oplock,
 		it writes the data to the server.
+  rwpidforward  Forward pid of a process who opened a file to any read or write
+		operation on that file. This prevent applications like WINE
+		from failing on read and write if we use mandatory brlock style.
   acl   	Allow setfacl and getfacl to manage posix ACLs if server
 		supports them.  (default)
   noacl 	Do not allow setfacl and getfacl calls on this mount
diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index c96b44b..ffb1459 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -41,6 +41,7 @@
 #define CIFS_MOUNT_MF_SYMLINKS	0x10000 /* Minshall+French Symlinks enabled */
 #define CIFS_MOUNT_MULTIUSER	0x20000 /* multiuser mount */
 #define CIFS_MOUNT_STRICT_IO	0x40000 /* strict cache mode */
+#define CIFS_MOUNT_RWPIDFORWARD	0x80000 /* use pid forwarding for rw */
 
 struct cifs_sb_info {
 	struct rb_root tlink_tree;
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 360fe2e..26981bf 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -415,12 +415,20 @@ cifs_show_options(struct seq_file *s, struct vfsmount *m)
 		seq_printf(s, ",nocase");
 	if (tcon->retry)
 		seq_printf(s, ",hard");
+	if (tcon->unix_ext)
+		seq_printf(s, ",unix");
+	else
+		seq_printf(s, ",nounix");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
 		seq_printf(s, ",posixpaths");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID)
 		seq_printf(s, ",setuids");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)
 		seq_printf(s, ",serverino");
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+		seq_printf(s, ",rwpidforward");
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL)
+		seq_printf(s, ",forcemand");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DIRECT_IO)
 		seq_printf(s, ",directio");
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index ca0c378..310cdda 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -200,6 +200,7 @@ struct smb_vol {
 	bool fsc:1;	/* enable fscache */
 	bool mfsymlinks:1; /* use Minshall+French Symlinks */
 	bool multiuser:1;
+	bool rwpidforward:1; /* pid forward for read/write operations */
 	unsigned int rsize;
 	unsigned int wsize;
 	bool sockopt_tcp_nodelay:1;
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index e41f607..1706345 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -345,9 +345,8 @@ extern int CIFSSMBClose(const int xid, struct cifsTconInfo *tcon,
 extern int CIFSSMBFlush(const int xid, struct cifsTconInfo *tcon,
 			const int smb_file_id);
 
-extern int CIFSSMBRead(const int xid, struct cifsTconInfo *tcon,
-			const int netfid, unsigned int count,
-			const __u64 lseek, unsigned int *nbytes, char **buf,
+extern int CIFSSMBRead(const int xid, struct cifs_io_parms *io_parms,
+			unsigned int *nbytes, char **buf,
 			int *return_buf_type);
 extern int CIFSSMBWrite(const int xid, struct cifs_io_parms *io_parms,
 			unsigned int *nbytes, const char *buf,
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index f39fa08..19fd815 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1382,8 +1382,7 @@ openRetry:
 }
 
 int
-CIFSSMBRead(const int xid, struct cifsTconInfo *tcon, const int netfid,
-	    const unsigned int count, const __u64 lseek, unsigned int *nbytes,
+CIFSSMBRead(const int xid, struct cifs_io_parms *io_parms, unsigned int *nbytes,
 	    char **buf, int *pbuf_type)
 {
 	int rc = -EACCES;
@@ -1393,13 +1392,18 @@ CIFSSMBRead(const int xid, struct cifsTconInfo *tcon, const int netfid,
 	int wct;
 	int resp_buf_type = 0;
 	struct kvec iov[1];
+	__u32 pid = io_parms->pid;
+	__u16 netfid = io_parms->netfid;
+	__u64 offset = io_parms->offset;
+	struct cifsTconInfo *tcon = io_parms->tcon;
+	unsigned int count = io_parms->length;
 
 	cFYI(1, "Reading %d bytes on fid %d", count, netfid);
 	if (tcon->ses->capabilities & CAP_LARGE_FILES)
 		wct = 12;
 	else {
 		wct = 10; /* old style read */
-		if ((lseek >> 32) > 0)  {
+		if ((offset >> 32) > 0)  {
 			/* can not handle this big offset for old */
 			return -EIO;
 		}
@@ -1410,15 +1414,18 @@ CIFSSMBRead(const int xid, struct cifsTconInfo *tcon, const int netfid,
 	if (rc)
 		return rc;
 
+	pSMB->hdr.Pid = cpu_to_le16((__u16)pid);
+	pSMB->hdr.PidHigh = cpu_to_le16((__u16)(pid >> 16));
+
 	/* tcon and ses pointer are checked in smb_init */
 	if (tcon->ses->server == NULL)
 		return -ECONNABORTED;
 
 	pSMB->AndXCommand = 0xFF;       /* none */
 	pSMB->Fid = netfid;
-	pSMB->OffsetLow = cpu_to_le32(lseek & 0xFFFFFFFF);
+	pSMB->OffsetLow = cpu_to_le32(offset & 0xFFFFFFFF);
 	if (wct == 12)
-		pSMB->OffsetHigh = cpu_to_le32(lseek >> 32);
+		pSMB->OffsetHigh = cpu_to_le32(offset >> 32);
 
 	pSMB->Remaining = 0;
 	pSMB->MaxCount = cpu_to_le16(count & 0xFFFF);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 3172baa..4ebb940 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1359,6 +1359,8 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
 			vol->server_ino = 1;
 		} else if (strnicmp(data, "noserverino", 9) == 0) {
 			vol->server_ino = 0;
+		} else if (strnicmp(data, "rwpidforward", 4) == 0) {
+			vol->rwpidforward = 1;
 		} else if (strnicmp(data, "cifsacl", 7) == 0) {
 			vol->cifs_acl = 1;
 		} else if (strnicmp(data, "nocifsacl", 9) == 0) {
@@ -2689,6 +2691,8 @@ void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NOSSYNC;
 	if (pvolume_info->mand_lock)
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NOPOSIXBRL;
+	if (pvolume_info->rwpidforward)
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_RWPIDFORWARD;
 	if (pvolume_info->cifs_acl)
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_CIFS_ACL;
 	if (pvolume_info->override_uid)
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index dfc0d35..7db74d1 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -725,8 +725,8 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *pfLock)
 			else
 				posix_lock_type = CIFS_WRLCK;
 			rc = CIFSSMBPosixLock(xid, tcon, netfid, 1 /* get */,
-					length,	pfLock,
-					posix_lock_type, wait_flag);
+					length, pfLock, posix_lock_type,
+					wait_flag);
 			FreeXid(xid);
 			return rc;
 		}
@@ -797,8 +797,8 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *pfLock)
 			posix_lock_type = CIFS_UNLCK;
 
 		rc = CIFSSMBPosixLock(xid, tcon, netfid, 0 /* set */,
-				      length, pfLock,
-				      posix_lock_type, wait_flag);
+				      length, pfLock, posix_lock_type,
+				      wait_flag);
 	} else {
 		struct cifsFileInfo *fid = file->private_data;
 
@@ -1346,6 +1346,14 @@ static int cifs_write_end(struct file *file, struct address_space *mapping,
 {
 	int rc;
 	struct inode *inode = mapping->host;
+	struct cifsFileInfo *cfile = file->private_data;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(cfile->dentry->d_sb);
+	__u32 pid;
+
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+		pid = cfile->pid;
+	else
+		pid = current->tgid;
 
 	cFYI(1, "write_end for page %p from pos %lld with %d bytes",
 		 page, pos, copied);
@@ -1369,8 +1377,7 @@ static int cifs_write_end(struct file *file, struct address_space *mapping,
 		/* BB check if anything else missing out of ppw
 		   such as updating last write time */
 		page_data = kmap(page);
-		rc = cifs_write(file->private_data, current->tgid,
-				page_data + offset, copied, &pos);
+		rc = cifs_write(cfile, pid, page_data + offset, copied, &pos);
 		/* if (rc < 0) should we set writebehind rc? */
 		kunmap(page);
 
@@ -1523,6 +1530,7 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 	struct cifs_sb_info *cifs_sb;
 	struct cifs_io_parms io_parms;
 	int xid, rc;
+	__u32 pid;
 
 	len = iov_length(iov, nr_segs);
 	if (!len)
@@ -1554,6 +1562,12 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 
 	xid = GetXid();
 	open_file = file->private_data;
+
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+		pid = open_file->pid;
+	else
+		pid = current->tgid;
+
 	pTcon = tlink_tcon(open_file->tlink);
 	inode = file->f_path.dentry->d_inode;
 
@@ -1581,7 +1595,7 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 					break;
 			}
 			io_parms.netfid = open_file->netfid;
-			io_parms.pid = current->tgid;
+			io_parms.pid = pid;
 			io_parms.tcon = pTcon;
 			io_parms.offset = *poffset;
 			io_parms.length = cur_len;
@@ -1682,7 +1696,9 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
 	struct cifsTconInfo *pTcon;
 	struct cifsFileInfo *open_file;
 	struct smb_com_read_rsp *pSMBr;
+	struct cifs_io_parms io_parms;
 	char *read_data;
+	__u32 pid;
 
 	if (!nr_segs)
 		return 0;
@@ -1697,6 +1713,11 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
 	open_file = file->private_data;
 	pTcon = tlink_tcon(open_file->tlink);
 
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+		pid = open_file->pid;
+	else
+		pid = current->tgid;
+
 	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
 		cFYI(1, "attempting read on write only file instance");
 
@@ -1712,8 +1733,12 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
 				if (rc != 0)
 					break;
 			}
-			rc = CIFSSMBRead(xid, pTcon, open_file->netfid,
-					 cur_len, *poffset, &bytes_read,
+			io_parms.netfid = open_file->netfid;
+			io_parms.pid = pid;
+			io_parms.tcon = pTcon;
+			io_parms.offset = *poffset;
+			io_parms.length = len;
+			rc = CIFSSMBRead(xid, &io_parms, &bytes_read,
 					 &read_data, &buf_type);
 			pSMBr = (struct smb_com_read_rsp *)read_data;
 			if (read_data) {
@@ -1794,7 +1819,9 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 	int xid;
 	char *current_offset;
 	struct cifsFileInfo *open_file;
+	struct cifs_io_parms io_parms;
 	int buf_type = CIFS_NO_BUFFER;
+	__u32 pid;
 
 	xid = GetXid();
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
@@ -1807,6 +1834,11 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 	open_file = file->private_data;
 	pTcon = tlink_tcon(open_file->tlink);
 
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+		pid = open_file->pid;
+	else
+		pid = current->tgid;
+
 	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
 		cFYI(1, "attempting read on write only file instance");
 
@@ -1829,11 +1861,13 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 				if (rc != 0)
 					break;
 			}
-			rc = CIFSSMBRead(xid, pTcon,
-					 open_file->netfid,
-					 current_read_size, *poffset,
-					 &bytes_read, &current_offset,
-					 &buf_type);
+			io_parms.netfid = open_file->netfid;
+			io_parms.pid = pid;
+			io_parms.tcon = pTcon;
+			io_parms.offset = *poffset;
+			io_parms.length = current_read_size;
+			rc = CIFSSMBRead(xid, &io_parms, &bytes_read,
+					 &current_offset, &buf_type);
 		}
 		if (rc || (bytes_read == 0)) {
 			if (total_read) {
@@ -1970,7 +2004,9 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 	char *smb_read_data = NULL;
 	struct smb_com_read_rsp *pSMBr;
 	struct cifsFileInfo *open_file;
+	struct cifs_io_parms io_parms;
 	int buf_type = CIFS_NO_BUFFER;
+	__u32 pid;
 
 	xid = GetXid();
 	if (file->private_data == NULL) {
@@ -1992,6 +2028,11 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 		goto read_complete;
 
 	cFYI(DBG2, "rpages: num pages %d", num_pages);
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
+		pid = open_file->pid;
+	else
+		pid = current->tgid;
+
 	for (i = 0; i < num_pages; ) {
 		unsigned contig_pages;
 		struct page *tmp_page;
@@ -2033,12 +2074,13 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 				if (rc != 0)
 					break;
 			}
-
-			rc = CIFSSMBRead(xid, pTcon,
-					 open_file->netfid,
-					 read_size, offset,
-					 &bytes_read, &smb_read_data,
-					 &buf_type);
+			io_parms.netfid = open_file->netfid;
+			io_parms.pid = pid;
+			io_parms.tcon = pTcon;
+			io_parms.offset = offset;
+			io_parms.length = read_size;
+			rc = CIFSSMBRead(xid, &io_parms, &bytes_read,
+					 &smb_read_data, &buf_type);
 			/* BB more RC checks ? */
 			if (rc == -EAGAIN) {
 				if (smb_read_data) {
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 53ea625..e2d9dd8 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -374,6 +374,7 @@ cifs_sfu_type(struct cifs_fattr *fattr, const unsigned char *path,
 	__u16 netfid;
 	struct tcon_link *tlink;
 	struct cifsTconInfo *tcon;
+	struct cifs_io_parms io_parms;
 	char buf[24];
 	unsigned int bytes_read;
 	char *pbuf;
@@ -405,9 +406,13 @@ cifs_sfu_type(struct cifs_fattr *fattr, const unsigned char *path,
 	if (rc == 0) {
 		int buf_type = CIFS_NO_BUFFER;
 			/* Read header */
-		rc = CIFSSMBRead(xid, tcon, netfid,
-				 24 /* length */, 0 /* offset */,
-				 &bytes_read, &pbuf, &buf_type);
+		io_parms.netfid = netfid;
+		io_parms.pid = current->tgid;
+		io_parms.tcon = tcon;
+		io_parms.offset = 0;
+		io_parms.length = 24;
+		rc = CIFSSMBRead(xid, &io_parms, &bytes_read, &pbuf,
+				 &buf_type);
 		if ((rc == 0) && (bytes_read >= 8)) {
 			if (memcmp("IntxBLK", pbuf, 8) == 0) {
 				cFYI(1, "Block device");
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index 1a6a388..4682d44 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -235,6 +235,7 @@ CIFSQueryMFSymLink(const int xid, struct cifsTconInfo *tcon,
 	unsigned int bytes_read = 0;
 	int buf_type = CIFS_NO_BUFFER;
 	unsigned int link_len = 0;
+	struct cifs_io_parms io_parms;
 	FILE_ALL_INFO file_info;
 
 	rc = CIFSSMBOpen(xid, tcon, searchName, FILE_OPEN, GENERIC_READ,
@@ -253,11 +254,13 @@ CIFSQueryMFSymLink(const int xid, struct cifsTconInfo *tcon,
 	if (!buf)
 		return -ENOMEM;
 	pbuf = buf;
+	io_parms.netfid = netfid;
+	io_parms.pid = current->tgid;
+	io_parms.tcon = tcon;
+	io_parms.offset = 0;
+	io_parms.length = CIFS_MF_SYMLINK_FILE_SIZE;
 
-	rc = CIFSSMBRead(xid, tcon, netfid,
-			 CIFS_MF_SYMLINK_FILE_SIZE /* length */,
-			 0 /* offset */,
-			 &bytes_read, &pbuf, &buf_type);
+	rc = CIFSSMBRead(xid, &io_parms, &bytes_read, &pbuf, &buf_type);
 	CIFSSMBClose(xid, tcon, netfid);
 	if (rc != 0) {
 		kfree(buf);
@@ -296,6 +299,7 @@ CIFSCheckMFSymlink(struct cifs_fattr *fattr,
 	__u16 netfid = 0;
 	struct tcon_link *tlink;
 	struct cifsTconInfo *pTcon;
+	struct cifs_io_parms io_parms;
 	u8 *buf;
 	char *pbuf;
 	unsigned int bytes_read = 0;
@@ -332,11 +336,13 @@ CIFSCheckMFSymlink(struct cifs_fattr *fattr,
 		goto out;
 	}
 	pbuf = buf;
+	io_parms.netfid = netfid;
+	io_parms.pid = current->tgid;
+	io_parms.tcon = pTcon;
+	io_parms.offset = 0;
+	io_parms.length = CIFS_MF_SYMLINK_FILE_SIZE;
 
-	rc = CIFSSMBRead(xid, pTcon, netfid,
-			 CIFS_MF_SYMLINK_FILE_SIZE /* length */,
-			 0 /* offset */,
-			 &bytes_read, &pbuf, &buf_type);
+	rc = CIFSSMBRead(xid, &io_parms, &bytes_read, &pbuf, &buf_type);
 	CIFSSMBClose(xid, pTcon, netfid);
 	if (rc != 0) {
 		kfree(buf);
-- 
1.7.1
