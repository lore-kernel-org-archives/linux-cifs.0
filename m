From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 22/36] fs/cifs: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:50:14 -0700
Message-ID: <50f719e6afc5504af06be41c057062f625615a0b.1278967121.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: Jiri Kosina <trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1278967120.git.joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
---
 fs/cifs/file.c  |   24 ++++++++++--------------
 fs/cifs/inode.c |    4 ++--
 fs/cifs/ioctl.c |    3 +--
 3 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 409e4f5..b5fb2a0 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -427,7 +427,7 @@ static int cifs_reopen_file(struct file *file, bool can_flush)
 	__u16 netfid;
 
 	if (file->private_data)
-		pCifsFile = (struct cifsFileInfo *)file->private_data;
+		pCifsFile = file->private_data;
 	else
 		return -EBADF;
 
@@ -565,8 +565,7 @@ int cifs_close(struct inode *inode, struct file *file)
 	int xid, timeout;
 	struct cifs_sb_info *cifs_sb;
 	struct cifsTconInfo *pTcon;
-	struct cifsFileInfo *pSMBFile =
-		(struct cifsFileInfo *)file->private_data;
+	struct cifsFileInfo *pSMBFile = file->private_data;
 
 	xid = GetXid();
 
@@ -641,8 +640,7 @@ int cifs_closedir(struct inode *inode, struct file *file)
 {
 	int rc = 0;
 	int xid;
-	struct cifsFileInfo *pCFileStruct =
-	    (struct cifsFileInfo *)file->private_data;
+	struct cifsFileInfo *pCFileStruct = file->private_data;
 	char *ptmp;
 
 	cFYI(1, "Closedir inode = 0x%p", inode);
@@ -863,8 +861,7 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *pfLock)
 				      length, pfLock,
 				      posix_lock_type, wait_flag);
 	} else {
-		struct cifsFileInfo *fid =
-			(struct cifsFileInfo *)file->private_data;
+		struct cifsFileInfo *fid = file->private_data;
 
 		if (numLock) {
 			rc = CIFSSMBLock(xid, tcon, netfid, length,
@@ -965,7 +962,7 @@ ssize_t cifs_user_write(struct file *file, const char __user *write_data,
 
 	if (file->private_data == NULL)
 		return -EBADF;
-	open_file = (struct cifsFileInfo *) file->private_data;
+	open_file = file->private_data;
 
 	rc = generic_write_checks(file, poffset, &write_size, 0);
 	if (rc)
@@ -1067,7 +1064,7 @@ static ssize_t cifs_write(struct file *file, const char *write_data,
 
 	if (file->private_data == NULL)
 		return -EBADF;
-	open_file = (struct cifsFileInfo *)file->private_data;
+	open_file = file->private_data;
 
 	xid = GetXid();
 
@@ -1651,8 +1648,7 @@ int cifs_fsync(struct file *file, int datasync)
 	int xid;
 	int rc = 0;
 	struct cifsTconInfo *tcon;
-	struct cifsFileInfo *smbfile =
-		(struct cifsFileInfo *)file->private_data;
+	struct cifsFileInfo *smbfile = file->private_data;
 	struct inode *inode = file->f_path.dentry->d_inode;
 
 	xid = GetXid();
@@ -1756,7 +1752,7 @@ ssize_t cifs_user_read(struct file *file, char __user *read_data,
 		FreeXid(xid);
 		return rc;
 	}
-	open_file = (struct cifsFileInfo *)file->private_data;
+	open_file = file->private_data;
 
 	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
 		cFYI(1, "attempting read on write only file instance");
@@ -1837,7 +1833,7 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
 		FreeXid(xid);
 		return rc;
 	}
-	open_file = (struct cifsFileInfo *)file->private_data;
+	open_file = file->private_data;
 
 	if ((file->f_flags & O_ACCMODE) == O_WRONLY)
 		cFYI(1, "attempting read on write only file instance");
@@ -1968,7 +1964,7 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
 		FreeXid(xid);
 		return rc;
 	}
-	open_file = (struct cifsFileInfo *)file->private_data;
+	open_file = file->private_data;
 	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
 	pTcon = cifs_sb->tcon;
 
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 107c84d..ee08248 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -288,7 +288,7 @@ int cifs_get_file_info_unix(struct file *filp)
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifsTconInfo *tcon = cifs_sb->tcon;
-	struct cifsFileInfo *cfile = (struct cifsFileInfo *) filp->private_data;
+	struct cifsFileInfo *cfile = filp->private_data;
 
 	xid = GetXid();
 	rc = CIFSSMBUnixQFileInfo(xid, tcon, cfile->netfid, &find_data);
@@ -515,7 +515,7 @@ int cifs_get_file_info(struct file *filp)
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifsTconInfo *tcon = cifs_sb->tcon;
-	struct cifsFileInfo *cfile = (struct cifsFileInfo *) filp->private_data;
+	struct cifsFileInfo *cfile = filp->private_data;
 
 	xid = GetXid();
 	rc = CIFSSMBQFileInfo(xid, tcon, cfile->netfid, &find_data);
diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
index 505926f..9d38a71 100644
--- a/fs/cifs/ioctl.c
+++ b/fs/cifs/ioctl.c
@@ -41,8 +41,7 @@ long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg)
 	__u64	ExtAttrMask = 0;
 	__u64   caps;
 	struct cifsTconInfo *tcon;
-	struct cifsFileInfo *pSMBFile =
-		(struct cifsFileInfo *)filep->private_data;
+	struct cifsFileInfo *pSMBFile = filep->private_data;
 #endif /* CONFIG_CIFS_POSIX */
 
 	xid = GetXid();
-- 
1.7.1.337.g6068.dirty
