From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 2/4] CIFS: Cleanup cifs_mknod
Date: Thu, 16 Jan 2014 15:53:34 +0400
Message-ID: <1389873217-17519-3-git-send-email-piastry@etersoft.ru>
References: <1389873217-17519-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389873217-17519-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Rename camel case variable and fix comment style.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/dir.c |   48 ++++++++++++++++++++++--------------------------
 1 file changed, 22 insertions(+), 26 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index a514e0a..0850325 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -565,12 +565,12 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
 	int create_options = CREATE_NOT_DIR | CREATE_OPTION_SPECIAL;
 	struct cifs_sb_info *cifs_sb;
 	struct tcon_link *tlink;
-	struct cifs_tcon *pTcon;
+	struct cifs_tcon *tcon;
 	struct cifs_io_parms io_parms;
 	char *full_path = NULL;
 	struct inode *newinode = NULL;
 	int oplock = 0;
-	u16 fileHandle;
+	u16 netfid;
 	FILE_ALL_INFO *buf = NULL;
 	unsigned int bytes_written;
 	struct win_dev *pdev;
@@ -583,7 +583,7 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
 	if (IS_ERR(tlink))
 		return PTR_ERR(tlink);
 
-	pTcon = tlink_tcon(tlink);
+	tcon = tlink_tcon(tlink);
 
 	xid = get_xid();
 
@@ -593,7 +593,7 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
 		goto mknod_out;
 	}
 
-	if (pTcon->unix_ext) {
+	if (tcon->unix_ext) {
 		struct cifs_unix_set_info_args args = {
 			.mode	= mode & ~current_umask(),
 			.ctime	= NO_CHANGE_64,
@@ -608,7 +608,7 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
 			args.uid = INVALID_UID; /* no change */
 			args.gid = INVALID_GID; /* no change */
 		}
-		rc = CIFSSMBUnixSetPathInfo(xid, pTcon, full_path, &args,
+		rc = CIFSSMBUnixSetPathInfo(xid, tcon, full_path, &args,
 					    cifs_sb->local_nls,
 					    cifs_sb->mnt_cifs_flags &
 						CIFS_MOUNT_MAP_SPECIAL_CHR);
@@ -640,42 +640,38 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, umode_t mode,
 	if (backup_cred(cifs_sb))
 		create_options |= CREATE_OPEN_BACKUP_INTENT;
 
-	rc = CIFSSMBOpen(xid, pTcon, full_path, FILE_CREATE,
+	rc = CIFSSMBOpen(xid, tcon, full_path, FILE_CREATE,
 			 GENERIC_WRITE, create_options,
-			 &fileHandle, &oplock, buf, cifs_sb->local_nls,
+			 &netfid, &oplock, buf, cifs_sb->local_nls,
 			 cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_SPECIAL_CHR);
 	if (rc)
 		goto mknod_out;
 
-	/* BB Do not bother to decode buf since no local inode yet to put
-	 * timestamps in, but we can reuse it safely */
+	/*
+	 * BB Do not bother to decode buf since no local inode yet to put
+	 * timestamps in, but we can reuse it safely.
+	 */
 
 	pdev = (struct win_dev *)buf;
-	io_parms.netfid = fileHandle;
+	io_parms.netfid = netfid;
 	io_parms.pid = current->tgid;
-	io_parms.tcon = pTcon;
+	io_parms.tcon = tcon;
 	io_parms.offset = 0;
 	io_parms.length = sizeof(struct win_dev);
 	if (S_ISCHR(mode)) {
 		memcpy(pdev->type, "IntxCHR", 8);
-		pdev->major =
-		      cpu_to_le64(MAJOR(device_number));
-		pdev->minor =
-		      cpu_to_le64(MINOR(device_number));
-		rc = CIFSSMBWrite(xid, &io_parms,
-			&bytes_written, (char *)pdev,
-			NULL, 0);
+		pdev->major = cpu_to_le64(MAJOR(device_number));
+		pdev->minor = cpu_to_le64(MINOR(device_number));
+		rc = CIFSSMBWrite(xid, &io_parms, &bytes_written, (char *)pdev,
+				  NULL, 0);
 	} else if (S_ISBLK(mode)) {
 		memcpy(pdev->type, "IntxBLK", 8);
-		pdev->major =
-		      cpu_to_le64(MAJOR(device_number));
-		pdev->minor =
-		      cpu_to_le64(MINOR(device_number));
-		rc = CIFSSMBWrite(xid, &io_parms,
-			&bytes_written, (char *)pdev,
-			NULL, 0);
+		pdev->major = cpu_to_le64(MAJOR(device_number));
+		pdev->minor = cpu_to_le64(MINOR(device_number));
+		rc = CIFSSMBWrite(xid, &io_parms, &bytes_written, (char *)pdev,
+				  NULL, 0);
 	} /* else if (S_ISFIFO) */
-	CIFSSMBClose(xid, pTcon, fileHandle);
+	CIFSSMBClose(xid, tcon, netfid);
 	d_drop(direntry);
 
 	/* FIXME: add code here to set EAs */
-- 
1.7.10.4
