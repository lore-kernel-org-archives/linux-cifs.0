From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH 3/4] CIFS: Remove extra indentation in cifs_sfu_type
Date: Thu, 16 Jan 2014 15:53:35 +0400
Message-ID: <1389873217-17519-4-git-send-email-piastry@etersoft.ru>
References: <1389873217-17519-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389873217-17519-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/inode.c |   97 ++++++++++++++++++++++++++++---------------------------
 1 file changed, 50 insertions(+), 47 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 6f7f57a..5793b5a 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -404,7 +404,7 @@ int cifs_get_inode_info_unix(struct inode **pinode,
 }
 
 static int
-cifs_sfu_type(struct cifs_fattr *fattr, const unsigned char *path,
+cifs_sfu_type(struct cifs_fattr *fattr, const char *path,
 	      struct cifs_sb_info *cifs_sb, unsigned int xid)
 {
 	int rc;
@@ -416,6 +416,7 @@ cifs_sfu_type(struct cifs_fattr *fattr, const unsigned char *path,
 	char buf[24];
 	unsigned int bytes_read;
 	char *pbuf;
+	int buf_type = CIFS_NO_BUFFER;
 
 	pbuf = buf;
 
@@ -441,57 +442,59 @@ cifs_sfu_type(struct cifs_fattr *fattr, const unsigned char *path,
 			 cifs_sb->local_nls,
 			 cifs_sb->mnt_cifs_flags &
 				CIFS_MOUNT_MAP_SPECIAL_CHR);
-	if (rc == 0) {
-		int buf_type = CIFS_NO_BUFFER;
-			/* Read header */
-		io_parms.netfid = netfid;
-		io_parms.pid = current->tgid;
-		io_parms.tcon = tcon;
-		io_parms.offset = 0;
-		io_parms.length = 24;
-		rc = CIFSSMBRead(xid, &io_parms, &bytes_read, &pbuf,
-				 &buf_type);
-		if ((rc == 0) && (bytes_read >= 8)) {
-			if (memcmp("IntxBLK", pbuf, 8) == 0) {
-				cifs_dbg(FYI, "Block device\n");
-				fattr->cf_mode |= S_IFBLK;
-				fattr->cf_dtype = DT_BLK;
-				if (bytes_read == 24) {
-					/* we have enough to decode dev num */
-					__u64 mjr; /* major */
-					__u64 mnr; /* minor */
-					mjr = le64_to_cpu(*(__le64 *)(pbuf+8));
-					mnr = le64_to_cpu(*(__le64 *)(pbuf+16));
-					fattr->cf_rdev = MKDEV(mjr, mnr);
-				}
-			} else if (memcmp("IntxCHR", pbuf, 8) == 0) {
-				cifs_dbg(FYI, "Char device\n");
-				fattr->cf_mode |= S_IFCHR;
-				fattr->cf_dtype = DT_CHR;
-				if (bytes_read == 24) {
-					/* we have enough to decode dev num */
-					__u64 mjr; /* major */
-					__u64 mnr; /* minor */
-					mjr = le64_to_cpu(*(__le64 *)(pbuf+8));
-					mnr = le64_to_cpu(*(__le64 *)(pbuf+16));
-					fattr->cf_rdev = MKDEV(mjr, mnr);
-				}
-			} else if (memcmp("IntxLNK", pbuf, 7) == 0) {
-				cifs_dbg(FYI, "Symlink\n");
-				fattr->cf_mode |= S_IFLNK;
-				fattr->cf_dtype = DT_LNK;
-			} else {
-				fattr->cf_mode |= S_IFREG; /* file? */
-				fattr->cf_dtype = DT_REG;
-				rc = -EOPNOTSUPP;
+	if (rc) {
+		cifs_put_tlink(tlink);
+		return rc;
+	}
+
+	/* Read header */
+	io_parms.netfid = netfid;
+	io_parms.pid = current->tgid;
+	io_parms.tcon = tcon;
+	io_parms.offset = 0;
+	io_parms.length = 24;
+
+	rc = CIFSSMBRead(xid, &io_parms, &bytes_read, &pbuf, &buf_type);
+	if ((rc == 0) && (bytes_read >= 8)) {
+		if (memcmp("IntxBLK", pbuf, 8) == 0) {
+			cifs_dbg(FYI, "Block device\n");
+			fattr->cf_mode |= S_IFBLK;
+			fattr->cf_dtype = DT_BLK;
+			if (bytes_read == 24) {
+				/* we have enough to decode dev num */
+				__u64 mjr; /* major */
+				__u64 mnr; /* minor */
+				mjr = le64_to_cpu(*(__le64 *)(pbuf+8));
+				mnr = le64_to_cpu(*(__le64 *)(pbuf+16));
+				fattr->cf_rdev = MKDEV(mjr, mnr);
+			}
+		} else if (memcmp("IntxCHR", pbuf, 8) == 0) {
+			cifs_dbg(FYI, "Char device\n");
+			fattr->cf_mode |= S_IFCHR;
+			fattr->cf_dtype = DT_CHR;
+			if (bytes_read == 24) {
+				/* we have enough to decode dev num */
+				__u64 mjr; /* major */
+				__u64 mnr; /* minor */
+				mjr = le64_to_cpu(*(__le64 *)(pbuf+8));
+				mnr = le64_to_cpu(*(__le64 *)(pbuf+16));
+				fattr->cf_rdev = MKDEV(mjr, mnr);
 			}
+		} else if (memcmp("IntxLNK", pbuf, 7) == 0) {
+			cifs_dbg(FYI, "Symlink\n");
+			fattr->cf_mode |= S_IFLNK;
+			fattr->cf_dtype = DT_LNK;
 		} else {
-			fattr->cf_mode |= S_IFREG; /* then it is a file */
+			fattr->cf_mode |= S_IFREG; /* file? */
 			fattr->cf_dtype = DT_REG;
-			rc = -EOPNOTSUPP; /* or some unknown SFU type */
+			rc = -EOPNOTSUPP;
 		}
-		CIFSSMBClose(xid, tcon, netfid);
+	} else {
+		fattr->cf_mode |= S_IFREG; /* then it is a file */
+		fattr->cf_dtype = DT_REG;
+		rc = -EOPNOTSUPP; /* or some unknown SFU type */
 	}
+	CIFSSMBClose(xid, tcon, netfid);
 	cifs_put_tlink(tlink);
 	return rc;
 }
-- 
1.7.10.4
