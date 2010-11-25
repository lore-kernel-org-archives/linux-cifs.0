From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] CIFS: Simplify non-posix open stuff
Date: Thu, 25 Nov 2010 17:44:57 +0300
Message-ID: <1290696298-5204-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Delete cifs_open_inode_helper and move non-posix open related things
to cifs_nt_open function.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsproto.h |    4 +
 fs/cifs/file.c      |  184 +++++++++++++++++++--------------------------------
 2 files changed, 72 insertions(+), 116 deletions(-)

diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 6ed59af..09d048c 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -113,6 +113,10 @@ extern int cifs_posix_open(char *full_path, struct inode **pinode,
 				struct super_block *sb,
 				int mode, unsigned int f_flags,
 				__u32 *poplock, __u16 *pnetfid, int xid);
+extern int cifs_nt_open(char *full_path, struct inode **pinode,
+			struct cifs_sb_info *cifs_sb, struct cifsTconInfo *tcon,
+			unsigned int f_flags, __u32 *poplock, __u16 *pnetfid,
+			int xid);
 void cifs_fill_uniqueid(struct super_block *sb, struct cifs_fattr *fattr);
 extern void cifs_unix_basic_to_fattr(struct cifs_fattr *fattr,
 				     FILE_UNIX_BASIC_INFO *info,
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index b857ce5..c7d642f 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -104,53 +104,6 @@ static inline int cifs_get_disposition(unsigned int flags)
 		return FILE_OPEN;
 }
 
-static inline int cifs_open_inode_helper(struct inode *inode,
-	struct cifsTconInfo *pTcon, __u32 oplock, FILE_ALL_INFO *buf,
-	char *full_path, int xid)
-{
-	struct cifsInodeInfo *pCifsInode = CIFS_I(inode);
-	struct timespec temp;
-	int rc;
-
-	if (pCifsInode->clientCanCacheRead) {
-		/* we have the inode open somewhere else
-		   no need to discard cache data */
-		goto client_can_cache;
-	}
-
-	/* BB need same check in cifs_create too? */
-	/* if not oplocked, invalidate inode pages if mtime or file
-	   size changed */
-	temp = cifs_NTtimeToUnix(buf->LastWriteTime);
-	if (timespec_equal(&inode->i_mtime, &temp) &&
-			   (inode->i_size ==
-			    (loff_t)le64_to_cpu(buf->EndOfFile))) {
-		cFYI(1, "inode unchanged on server");
-	} else {
-		if (inode->i_mapping) {
-			/* BB no need to lock inode until after invalidate
-			since namei code should already have it locked? */
-			rc = filemap_write_and_wait(inode->i_mapping);
-			mapping_set_error(inode->i_mapping, rc);
-		}
-		cFYI(1, "invalidating remote inode since open detected it "
-			 "changed");
-		invalidate_remote_inode(inode);
-	}
-
-client_can_cache:
-	if (pTcon->unix_ext)
-		rc = cifs_get_inode_info_unix(&inode, full_path, inode->i_sb,
-					      xid);
-	else
-		rc = cifs_get_inode_info(&inode, full_path, buf, inode->i_sb,
-					 xid, NULL);
-
-	cifs_set_oplock_level(pCifsInode, oplock);
-
-	return rc;
-}
-
 int cifs_posix_open(char *full_path, struct inode **pinode,
 			struct super_block *sb, int mode, unsigned int f_flags,
 			__u32 *poplock, __u16 *pnetfid, int xid)
@@ -213,6 +166,71 @@ posix_open_ret:
 	return rc;
 }
 
+int cifs_nt_open(char *full_path, struct inode **pinode,
+		 struct cifs_sb_info *cifs_sb, struct cifsTconInfo *tcon,
+		 unsigned int f_flags, __u32 *poplock, __u16 *pnetfid, int xid)
+{
+	int rc;
+	int desiredAccess;
+	int disposition;
+	FILE_ALL_INFO *buf;
+
+	desiredAccess = cifs_convert_flags(f_flags);
+
+/*********************************************************************
+ *  open flag mapping table:
+ *
+ *	POSIX Flag            CIFS Disposition
+ *	----------            ----------------
+ *	O_CREAT               FILE_OPEN_IF
+ *	O_CREAT | O_EXCL      FILE_CREATE
+ *	O_CREAT | O_TRUNC     FILE_OVERWRITE_IF
+ *	O_TRUNC               FILE_OVERWRITE
+ *	none of the above     FILE_OPEN
+ *
+ *	Note that there is not a direct match between disposition
+ *	FILE_SUPERSEDE (ie create whether or not file exists although
+ *	O_CREAT | O_TRUNC is similar but truncates the existing
+ *	file rather than creating a new file as FILE_SUPERSEDE does
+ *	(which uses the attributes / metadata passed in on open call)
+ *?
+ *?  O_SYNC is a reasonable match to CIFS writethrough flag
+ *?  and the read write flags match reasonably.  O_LARGEFILE
+ *?  is irrelevant because largefile support is always used
+ *?  by this client. Flags O_APPEND, O_DIRECT, O_DIRECTORY,
+ *	 O_FASYNC, O_NOFOLLOW, O_NONBLOCK need further investigation
+ *********************************************************************/
+
+	disposition = cifs_get_disposition(f_flags);
+
+	/* BB pass O_SYNC flag through on file attributes .. BB */
+
+	buf = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	if (tcon->ses->capabilities & CAP_NT_SMBS)
+		rc = CIFSSMBOpen(xid, tcon, full_path, disposition,
+			 desiredAccess, CREATE_NOT_DIR, pnetfid, poplock, buf,
+			 cifs_sb->local_nls, cifs_sb->mnt_cifs_flags
+				 & CIFS_MOUNT_MAP_SPECIAL_CHR);
+	else
+		rc = SMBLegacyOpen(xid, tcon, full_path, disposition,
+			desiredAccess, CREATE_NOT_DIR, pnetfid, poplock, buf,
+			cifs_sb->local_nls, cifs_sb->mnt_cifs_flags
+				& CIFS_MOUNT_MAP_SPECIAL_CHR);
+
+	if (rc)
+		goto out;
+
+	rc = cifs_get_inode_info(pinode, full_path, buf, (*pinode)->i_sb,
+				 xid, NULL);
+
+out:
+	kfree(buf);
+	return rc;
+}
+
 struct cifsFileInfo *
 cifs_new_fileinfo(__u16 fileHandle, struct file *file,
 		  struct tcon_link *tlink, __u32 oplock)
@@ -317,10 +335,7 @@ int cifs_open(struct inode *inode, struct file *file)
 	struct cifsFileInfo *pCifsFile = NULL;
 	struct cifsInodeInfo *pCifsInode;
 	char *full_path = NULL;
-	int desiredAccess;
-	int disposition;
 	__u16 netfid;
-	FILE_ALL_INFO *buf = NULL;
 
 	xid = GetXid();
 
@@ -385,71 +400,9 @@ int cifs_open(struct inode *inode, struct file *file)
 		   or DFS errors */
 	}
 
-	desiredAccess = cifs_convert_flags(file->f_flags);
-
-/*********************************************************************
- *  open flag mapping table:
- *
- *	POSIX Flag            CIFS Disposition
- *	----------            ----------------
- *	O_CREAT               FILE_OPEN_IF
- *	O_CREAT | O_EXCL      FILE_CREATE
- *	O_CREAT | O_TRUNC     FILE_OVERWRITE_IF
- *	O_TRUNC               FILE_OVERWRITE
- *	none of the above     FILE_OPEN
- *
- *	Note that there is not a direct match between disposition
- *	FILE_SUPERSEDE (ie create whether or not file exists although
- *	O_CREAT | O_TRUNC is similar but truncates the existing
- *	file rather than creating a new file as FILE_SUPERSEDE does
- *	(which uses the attributes / metadata passed in on open call)
- *?
- *?  O_SYNC is a reasonable match to CIFS writethrough flag
- *?  and the read write flags match reasonably.  O_LARGEFILE
- *?  is irrelevant because largefile support is always used
- *?  by this client. Flags O_APPEND, O_DIRECT, O_DIRECTORY,
- *	 O_FASYNC, O_NOFOLLOW, O_NONBLOCK need further investigation
- *********************************************************************/
-
-	disposition = cifs_get_disposition(file->f_flags);
-
-	/* BB pass O_SYNC flag through on file attributes .. BB */
-
-	/* Also refresh inode by passing in file_info buf returned by SMBOpen
-	   and calling get_inode_info with returned buf (at least helps
-	   non-Unix server case) */
-
-	/* BB we can not do this if this is the second open of a file
-	   and the first handle has writebehind data, we might be
-	   able to simply do a filemap_fdatawrite/filemap_fdatawait first */
-	buf = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
-	if (!buf) {
-		rc = -ENOMEM;
-		goto out;
-	}
-
-	if (tcon->ses->capabilities & CAP_NT_SMBS)
-		rc = CIFSSMBOpen(xid, tcon, full_path, disposition,
-			 desiredAccess, CREATE_NOT_DIR, &netfid, &oplock, buf,
-			 cifs_sb->local_nls, cifs_sb->mnt_cifs_flags
-				 & CIFS_MOUNT_MAP_SPECIAL_CHR);
-	else
-		rc = -EIO; /* no NT SMB support fall into legacy open below */
-
-	if (rc == -EIO) {
-		/* Old server, try legacy style OpenX */
-		rc = SMBLegacyOpen(xid, tcon, full_path, disposition,
-			desiredAccess, CREATE_NOT_DIR, &netfid, &oplock, buf,
-			cifs_sb->local_nls, cifs_sb->mnt_cifs_flags
-				& CIFS_MOUNT_MAP_SPECIAL_CHR);
-	}
-	if (rc) {
-		cFYI(1, "cifs_open returned 0x%x", rc);
-		goto out;
-	}
-
-	rc = cifs_open_inode_helper(inode, tcon, oplock, buf, full_path, xid);
-	if (rc != 0)
+	rc = cifs_nt_open(full_path, &inode, cifs_sb, tcon, file->f_flags,
+			  &oplock, &netfid, xid);
+	if (rc)
 		goto out;
 
 	pCifsFile = cifs_new_fileinfo(netfid, file, tlink, oplock);
@@ -481,7 +434,6 @@ int cifs_open(struct inode *inode, struct file *file)
 	}
 
 out:
-	kfree(buf);
 	kfree(full_path);
 	FreeXid(xid);
 	cifs_put_tlink(tlink);
-- 
1.7.0.4
