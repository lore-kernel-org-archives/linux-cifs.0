From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/3] cifs: clean up error handling in cifs_mknod
Date: Thu,  5 Aug 2010 10:18:34 -0400
Message-ID: <1281017916-31380-2-git-send-email-jlayton@redhat.com>
References: <1281017916-31380-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1281017916-31380-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Get rid of some nesting and add a label we can goto on error.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/dir.c |  153 ++++++++++++++++++++++++++++-----------------------------
 1 files changed, 76 insertions(+), 77 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index a7de5e9..f8d02f0 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -496,6 +496,11 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, int mode,
 	struct cifsTconInfo *pTcon;
 	char *full_path = NULL;
 	struct inode *newinode = NULL;
+	int oplock = 0;
+	u16 fileHandle;
+	FILE_ALL_INFO *buf = NULL;
+	unsigned int bytes_written;
+	struct win_dev *pdev;
 
 	if (!old_valid_dev(device_number))
 		return -EINVAL;
@@ -506,9 +511,12 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, int mode,
 	pTcon = cifs_sb->tcon;
 
 	full_path = build_path_from_dentry(direntry);
-	if (full_path == NULL)
+	if (full_path == NULL) {
 		rc = -ENOMEM;
-	else if (pTcon->unix_ext) {
+		goto mknod_out;
+	}
+
+	if (pTcon->unix_ext) {
 		struct cifs_unix_set_info_args args = {
 			.mode	= mode & ~current_umask(),
 			.ctime	= NO_CHANGE_64,
@@ -527,87 +535,78 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, int mode,
 					    cifs_sb->local_nls,
 					    cifs_sb->mnt_cifs_flags &
 						CIFS_MOUNT_MAP_SPECIAL_CHR);
+		if (rc)
+			goto mknod_out;
 
-		if (!rc) {
-			rc = cifs_get_inode_info_unix(&newinode, full_path,
+		rc = cifs_get_inode_info_unix(&newinode, full_path,
 						inode->i_sb, xid);
-			if (pTcon->nocase)
-				direntry->d_op = &cifs_ci_dentry_ops;
-			else
-				direntry->d_op = &cifs_dentry_ops;
-			if (rc == 0)
-				d_instantiate(direntry, newinode);
-		}
-	} else {
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL) {
-			int oplock = 0;
-			u16 fileHandle;
-			FILE_ALL_INFO *buf;
+		if (pTcon->nocase)
+			direntry->d_op = &cifs_ci_dentry_ops;
+		else
+			direntry->d_op = &cifs_dentry_ops;
 
-			cFYI(1, "sfu compat create special file");
+		if (rc == 0)
+			d_instantiate(direntry, newinode);
+		goto mknod_out;
+	}
 
-			buf = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
-			if (buf == NULL) {
-				kfree(full_path);
-				rc = -ENOMEM;
-				FreeXid(xid);
-				return rc;
-			}
+	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UNX_EMUL))
+		goto mknod_out;
 
-			rc = CIFSSMBOpen(xid, pTcon, full_path,
-					 FILE_CREATE, /* fail if exists */
-					 GENERIC_WRITE /* BB would
-					  WRITE_OWNER | WRITE_DAC be better? */,
-					 /* Create a file and set the
-					    file attribute to SYSTEM */
-					 CREATE_NOT_DIR | CREATE_OPTION_SPECIAL,
-					 &fileHandle, &oplock, buf,
-					 cifs_sb->local_nls,
-					 cifs_sb->mnt_cifs_flags &
-					    CIFS_MOUNT_MAP_SPECIAL_CHR);
-
-			/* BB FIXME - add handling for backlevel servers
-			   which need legacy open and check for all
-			   calls to SMBOpen for fallback to SMBLeagcyOpen */
-			if (!rc) {
-				/* BB Do not bother to decode buf since no
-				   local inode yet to put timestamps in,
-				   but we can reuse it safely */
-				unsigned int bytes_written;
-				struct win_dev *pdev;
-				pdev = (struct win_dev *)buf;
-				if (S_ISCHR(mode)) {
-					memcpy(pdev->type, "IntxCHR", 8);
-					pdev->major =
-					      cpu_to_le64(MAJOR(device_number));
-					pdev->minor =
-					      cpu_to_le64(MINOR(device_number));
-					rc = CIFSSMBWrite(xid, pTcon,
-						fileHandle,
-						sizeof(struct win_dev),
-						0, &bytes_written, (char *)pdev,
-						NULL, 0);
-				} else if (S_ISBLK(mode)) {
-					memcpy(pdev->type, "IntxBLK", 8);
-					pdev->major =
-					      cpu_to_le64(MAJOR(device_number));
-					pdev->minor =
-					      cpu_to_le64(MINOR(device_number));
-					rc = CIFSSMBWrite(xid, pTcon,
-						fileHandle,
-						sizeof(struct win_dev),
-						0, &bytes_written, (char *)pdev,
-						NULL, 0);
-				} /* else if(S_ISFIFO */
-				CIFSSMBClose(xid, pTcon, fileHandle);
-				d_drop(direntry);
-			}
-			kfree(buf);
-			/* add code here to set EAs */
-		}
+
+	cFYI(1, "sfu compat create special file");
+
+	buf = kmalloc(sizeof(FILE_ALL_INFO), GFP_KERNEL);
+	if (buf == NULL) {
+		kfree(full_path);
+		rc = -ENOMEM;
+		FreeXid(xid);
+		return rc;
 	}
 
+	/* FIXME: would WRITE_OWNER | WRITE_DAC be better? */
+	rc = CIFSSMBOpen(xid, pTcon, full_path, FILE_CREATE,
+			 GENERIC_WRITE, CREATE_NOT_DIR | CREATE_OPTION_SPECIAL,
+			 &fileHandle, &oplock, buf, cifs_sb->local_nls,
+			 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
+	if (rc)
+		goto mknod_out;
+
+	/* BB Do not bother to decode buf since no local inode yet to put
+	 * timestamps in, but we can reuse it safely */
+
+	pdev = (struct win_dev *)buf;
+	if (S_ISCHR(mode)) {
+		memcpy(pdev->type, "IntxCHR", 8);
+		pdev->major =
+		      cpu_to_le64(MAJOR(device_number));
+		pdev->minor =
+		      cpu_to_le64(MINOR(device_number));
+		rc = CIFSSMBWrite(xid, pTcon,
+			fileHandle,
+			sizeof(struct win_dev),
+			0, &bytes_written, (char *)pdev,
+			NULL, 0);
+	} else if (S_ISBLK(mode)) {
+		memcpy(pdev->type, "IntxBLK", 8);
+		pdev->major =
+		      cpu_to_le64(MAJOR(device_number));
+		pdev->minor =
+		      cpu_to_le64(MINOR(device_number));
+		rc = CIFSSMBWrite(xid, pTcon,
+			fileHandle,
+			sizeof(struct win_dev),
+			0, &bytes_written, (char *)pdev,
+			NULL, 0);
+	} /* else if (S_ISFIFO) */
+	CIFSSMBClose(xid, pTcon, fileHandle);
+	d_drop(direntry);
+
+	/* FIXME: add code here to set EAs */
+
+mknod_out:
 	kfree(full_path);
+	kfree(buf);
 	FreeXid(xid);
 	return rc;
 }
-- 
1.7.2
