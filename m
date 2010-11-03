From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cifs: make cifs_set_oplock_level() take a cifsInodeInfo pointer
Date: Wed,  3 Nov 2010 10:58:57 +0300
Message-ID: <1288771137-5458-1-git-send-email-piastryyy@gmail.com>
References: <1288769214-11113-1-git-send-email-sjayaraman@suse.de>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1288769214-11113-1-git-send-email-sjayaraman-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

All the callers already have a pointer to struct cifsInodeInfo. Use it.

Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsfs.c    |    3 +--
 fs/cifs/cifsproto.h |    2 +-
 fs/cifs/file.c      |    8 ++++----
 fs/cifs/misc.c      |   16 +++++++++-------
 4 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 38526a6..9c37897 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -321,8 +321,7 @@ cifs_alloc_inode(struct super_block *sb)
 	/* Until the file is open and we have gotten oplock
 	info back from the server, can not assume caching of
 	file data or metadata */
-	cifs_inode->clientCanCacheRead = false;
-	cifs_inode->clientCanCacheAll = false;
+	cifs_set_oplock_level(cifs_inode, 0);
 	cifs_inode->delete_pending = false;
 	cifs_inode->invalid_mapping = false;
 	cifs_inode->vfs_inode.i_blkbits = 14;  /* 2**14 = CIFS_MAX_MSGSIZE */
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 7f050f4..7ed69b6 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -104,7 +104,7 @@ extern struct timespec cifs_NTtimeToUnix(__le64 utc_nanoseconds_since_1601);
 extern u64 cifs_UnixTimeToNT(struct timespec);
 extern struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time,
 				      int offset);
-extern void cifs_set_oplock_level(struct inode *inode, __u32 oplock);
+extern void cifs_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock);
 
 extern struct cifsFileInfo *cifs_new_fileinfo(__u16 fileHandle,
 				struct file *file, struct tcon_link *tlink,
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 71185d1..a0d13c7 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -146,7 +146,7 @@ client_can_cache:
 		rc = cifs_get_inode_info(&inode, full_path, buf, inode->i_sb,
 					 xid, NULL);
 
-	cifs_set_oplock_level(inode, oplock);
+	cifs_set_oplock_level(pCifsInode, oplock);
 
 	return rc;
 }
@@ -248,7 +248,7 @@ cifs_new_fileinfo(__u16 fileHandle, struct file *file,
 		list_add_tail(&pCifsFile->flist, &pCifsInode->openFileList);
 	spin_unlock(&cifs_file_list_lock);
 
-	cifs_set_oplock_level(inode, oplock);
+	cifs_set_oplock_level(pCifsInode, oplock);
 
 	file->private_data = pCifsFile;
 	return pCifsFile;
@@ -279,7 +279,7 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
 	if (list_empty(&cifsi->openFileList)) {
 		cFYI(1, "closing last open instance for inode %p",
 			cifs_file->dentry->d_inode);
-		cifs_set_oplock_level(inode, 0);
+		cifs_set_oplock_level(cifsi, 0);
 	}
 	spin_unlock(&cifs_file_list_lock);
 
@@ -611,7 +611,7 @@ reopen_success:
 	     we can not go to the server to get the new inod
 	     info */
 
-	cifs_set_oplock_level(inode, oplock);
+	cifs_set_oplock_level(pCifsInode, oplock);
 
 	cifs_relock_file(pCifsFile);
 
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index d3b9dde..43f1028 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -570,7 +570,7 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 				cFYI(1, "file id match, oplock break");
 				pCifsInode = CIFS_I(netfile->dentry->d_inode);
 
-				cifs_set_oplock_level(netfile->dentry->d_inode,
+				cifs_set_oplock_level(pCifsInode,
 						      pSMB->OplockLevel);
 				/*
 				 * cifs_oplock_break_put() can't be called
@@ -722,18 +722,20 @@ cifs_autodisable_serverino(struct cifs_sb_info *cifs_sb)
 	}
 }
 
-void cifs_set_oplock_level(struct inode *inode, __u32 oplock)
+void cifs_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock)
 {
-	struct cifsInodeInfo *cinode = CIFS_I(inode);
+	oplock &= 0xF;
 
-	if ((oplock & 0xF) == OPLOCK_EXCLUSIVE) {
+	if (oplock == OPLOCK_EXCLUSIVE) {
 		cinode->clientCanCacheAll = true;
 		cinode->clientCanCacheRead = true;
-		cFYI(1, "Exclusive Oplock granted on inode %p", inode);
-	} else if ((oplock & 0xF) == OPLOCK_READ) {
+		cFYI(1, "Exclusive Oplock granted on inode %p",
+		     &cinode->vfs_inode);
+	} else if (oplock == OPLOCK_READ) {
 		cinode->clientCanCacheAll = false;
 		cinode->clientCanCacheRead = true;
-		cFYI(1, "Level II Oplock granted on inode %p", inode);
+		cFYI(1, "Level II Oplock granted on inode %p",
+		    &cinode->vfs_inode);
 	} else {
 		cinode->clientCanCacheAll = false;
 		cinode->clientCanCacheRead = false;
-- 
1.7.2.3
