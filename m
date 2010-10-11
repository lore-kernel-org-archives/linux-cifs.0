From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 03/16] cifs: eliminate cifs_posix_open_inode_helper
Date: Mon, 11 Oct 2010 15:07:20 -0400
Message-ID: <1286824053-12084-4-git-send-email-jlayton@redhat.com>
References: <1286824053-12084-1-git-send-email-jlayton@redhat.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1286824053-12084-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This function is redundant. The only thing it does is set the canCache
flags, but those get set in cifs_new_fileinfo anyway.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Acked-by: Dave Kleikamp <shaggy-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 fs/cifs/file.c |   67 --------------------------------------------------------
 1 files changed, 0 insertions(+), 67 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index fd78a35..c10f085 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -106,64 +106,6 @@ static inline int cifs_get_disposition(unsigned int flags)
 		return FILE_OPEN;
 }
 
-/* all arguments to this function must be checked for validity in caller */
-static inline int
-cifs_posix_open_inode_helper(struct inode *inode, struct file *file,
-			     struct cifsInodeInfo *pCifsInode, __u32 oplock,
-			     u16 netfid)
-{
-
-	write_lock(&GlobalSMBSeslock);
-
-	pCifsInode = CIFS_I(file->f_path.dentry->d_inode);
-	if (pCifsInode == NULL) {
-		write_unlock(&GlobalSMBSeslock);
-		return -EINVAL;
-	}
-
-	if (pCifsInode->clientCanCacheRead) {
-		/* we have the inode open somewhere else
-		   no need to discard cache data */
-		goto psx_client_can_cache;
-	}
-
-	/* BB FIXME need to fix this check to move it earlier into posix_open
-	   BB  fIX following section BB FIXME */
-
-	/* if not oplocked, invalidate inode pages if mtime or file
-	   size changed */
-/*	temp = cifs_NTtimeToUnix(le64_to_cpu(buf->LastWriteTime));
-	if (timespec_equal(&file->f_path.dentry->d_inode->i_mtime, &temp) &&
-			   (file->f_path.dentry->d_inode->i_size ==
-			    (loff_t)le64_to_cpu(buf->EndOfFile))) {
-		cFYI(1, "inode unchanged on server");
-	} else {
-		if (file->f_path.dentry->d_inode->i_mapping) {
-			rc = filemap_write_and_wait(file->f_path.dentry->d_inode->i_mapping);
-			if (rc != 0)
-				CIFS_I(file->f_path.dentry->d_inode)->write_behind_rc = rc;
-		}
-		cFYI(1, "invalidating remote inode since open detected it "
-			 "changed");
-		invalidate_remote_inode(file->f_path.dentry->d_inode);
-	} */
-
-psx_client_can_cache:
-	if ((oplock & 0xF) == OPLOCK_EXCLUSIVE) {
-		pCifsInode->clientCanCacheAll = true;
-		pCifsInode->clientCanCacheRead = true;
-		cFYI(1, "Exclusive Oplock granted on inode %p",
-			 file->f_path.dentry->d_inode);
-	} else if ((oplock & 0xF) == OPLOCK_READ)
-		pCifsInode->clientCanCacheRead = true;
-
-	/* will have to change the unlock if we reenable the
-	   filemap_fdatawrite (which does not seem necessary */
-	write_unlock(&GlobalSMBSeslock);
-	return 0;
-}
-
-/* all arguments to this function must be checked for validity in caller */
 static inline int cifs_open_inode_helper(struct inode *inode,
 	struct cifsTconInfo *pTcon, __u32 oplock, FILE_ALL_INFO *buf,
 	char *full_path, int xid)
@@ -271,15 +213,6 @@ int cifs_open(struct inode *inode, struct file *file)
 				oflags, &oplock, &netfid, xid);
 		if (rc == 0) {
 			cFYI(1, "posix open succeeded");
-			/* no need for special case handling of setting mode
-			   on read only files needed here */
-
-			rc = cifs_posix_open_inode_helper(inode, file,
-					pCifsInode, oplock, netfid);
-			if (rc != 0) {
-				CIFSSMBClose(xid, tcon, netfid);
-				goto out;
-			}
 
 			pCifsFile = cifs_new_fileinfo(inode, netfid, file,
 							tlink, oflags, oplock);
-- 
1.7.2.3
