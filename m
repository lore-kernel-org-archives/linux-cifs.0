From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] CIFS: Simplify cifs_open code
Date: Thu, 25 Nov 2010 17:44:58 +0300
Message-ID: <1290696298-5204-2-git-send-email-piastryyy@gmail.com>
References: <1290696298-5204-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1290696298-5204-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Make the code more general for use in posix and non-posix open.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/file.c |   54 +++++++++++++++++++++++-------------------------------
 1 files changed, 23 insertions(+), 31 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index c7d642f..2e21cd1 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -335,6 +335,7 @@ int cifs_open(struct inode *inode, struct file *file)
 	struct cifsFileInfo *pCifsFile = NULL;
 	struct cifsInodeInfo *pCifsInode;
 	char *full_path = NULL;
+	bool posix_open_ok = false;
 	__u16 netfid;
 
 	xid = GetXid();
@@ -373,17 +374,7 @@ int cifs_open(struct inode *inode, struct file *file)
 				file->f_flags, &oplock, &netfid, xid);
 		if (rc == 0) {
 			cFYI(1, "posix open succeeded");
-
-			pCifsFile = cifs_new_fileinfo(netfid, file, tlink,
-						      oplock);
-			if (pCifsFile == NULL) {
-				CIFSSMBClose(xid, tcon, netfid);
-				rc = -ENOMEM;
-			}
-
-			cifs_fscache_set_inode_cookie(inode, file);
-
-			goto out;
+			posix_open_ok = true;
 		} else if ((rc == -EINVAL) || (rc == -EOPNOTSUPP)) {
 			if (tcon->ses->serverNOS)
 				cERROR(1, "server %s of type %s returned"
@@ -400,37 +391,38 @@ int cifs_open(struct inode *inode, struct file *file)
 		   or DFS errors */
 	}
 
-	rc = cifs_nt_open(full_path, &inode, cifs_sb, tcon, file->f_flags,
-			  &oplock, &netfid, xid);
-	if (rc)
-		goto out;
+	if (!posix_open_ok) {
+		rc = cifs_nt_open(full_path, &inode, cifs_sb, tcon,
+				  file->f_flags, &oplock, &netfid, xid);
+		if (rc)
+			goto out;
+	}
 
 	pCifsFile = cifs_new_fileinfo(netfid, file, tlink, oplock);
 	if (pCifsFile == NULL) {
+		CIFSSMBClose(xid, tcon, netfid);
 		rc = -ENOMEM;
 		goto out;
 	}
 
 	cifs_fscache_set_inode_cookie(inode, file);
 
-	if (oplock & CIFS_CREATE_ACTION) {
+	if ((oplock & CIFS_CREATE_ACTION) && !posix_open_ok && tcon->unix_ext) {
 		/* time to set mode which we can not set earlier due to
 		   problems creating new read-only files */
-		if (tcon->unix_ext) {
-			struct cifs_unix_set_info_args args = {
-				.mode	= inode->i_mode,
-				.uid	= NO_CHANGE_64,
-				.gid	= NO_CHANGE_64,
-				.ctime	= NO_CHANGE_64,
-				.atime	= NO_CHANGE_64,
-				.mtime	= NO_CHANGE_64,
-				.device	= 0,
-			};
-			CIFSSMBUnixSetPathInfo(xid, tcon, full_path, &args,
-					       cifs_sb->local_nls,
-					       cifs_sb->mnt_cifs_flags &
-						CIFS_MOUNT_MAP_SPECIAL_CHR);
-		}
+		struct cifs_unix_set_info_args args = {
+			.mode	= inode->i_mode,
+			.uid	= NO_CHANGE_64,
+			.gid	= NO_CHANGE_64,
+			.ctime	= NO_CHANGE_64,
+			.atime	= NO_CHANGE_64,
+			.mtime	= NO_CHANGE_64,
+			.device	= 0,
+		};
+		CIFSSMBUnixSetPathInfo(xid, tcon, full_path, &args,
+				       cifs_sb->local_nls,
+				       cifs_sb->mnt_cifs_flags &
+					CIFS_MOUNT_MAP_SPECIAL_CHR);
 	}
 
 out:
-- 
1.7.0.4
