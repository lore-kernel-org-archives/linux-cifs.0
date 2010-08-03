From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 8/8] cifs: implement CIFSCreateMFSymLink()
Date: Tue,  3 Aug 2010 17:06:00 +0200
Message-ID: <1280847960-16371-9-git-send-email-metze@samba.org>
References: <1280847960-16371-1-git-send-email-metze@samba.org>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280847960-16371-1-git-send-email-metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/link.c |   39 +++++++++++++++++++++++++++++++++++----
 1 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index b281d26..93d2dfd 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -135,10 +135,39 @@ CIFSFormatMFSymlink(u8 *buf, unsigned int buf_len, const char *link_str)
 static int
 CIFSCreateMFSymLink(const int xid, struct cifsTconInfo *tcon,
 		    const char *fromName, const char *toName,
-		    const struct nls_table *nls_codepage)
+		    const struct nls_table *nls_codepage, int remap)
 {
-	int rc = -EOPNOTSUPP;
-	return rc;
+	int rc;
+	int oplock = 0;
+	__u16 netfid = 0;
+	u8 buf[CIFS_MF_SYMLINK_FILE_SIZE];
+	unsigned int bytes_written = 0;
+
+	rc = CIFSFormatMFSymlink(buf, sizeof(buf), toName);
+	if (rc != 0) {
+		return rc;
+	}
+
+	rc = CIFSSMBOpen(xid, tcon, fromName, FILE_CREATE, GENERIC_WRITE,
+			 CREATE_NOT_DIR, &netfid, &oplock, NULL,
+			 nls_codepage, remap);
+	if (rc != 0) {
+		return rc;
+	}
+
+	rc = CIFSSMBWrite(xid, tcon, netfid,
+			  sizeof(buf) /* length */,
+			  0 /* offset */,
+			  &bytes_written, buf, NULL, 0);
+	CIFSSMBClose(xid, tcon, netfid);
+	if (rc != 0) {
+		return rc;
+	}
+
+	if (bytes_written != sizeof(buf))
+		return -EIO;
+
+	return 0;
 }
 
 static int
@@ -416,7 +445,9 @@ cifs_symlink(struct inode *inode, struct dentry *direntry, const char *symname)
 	/* BB what if DFS and this volume is on different share? BB */
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS)
 		rc = CIFSCreateMFSymLink(xid, pTcon, full_path, symname,
-					 cifs_sb->local_nls);
+					 cifs_sb->local_nls,
+					 cifs_sb->mnt_cifs_flags &
+						CIFS_MOUNT_MAP_SPECIAL_CHR);
 	else if (pTcon->unix_ext)
 		rc = CIFSUnixCreateSymLink(xid, pTcon, full_path, symname,
 					   cifs_sb->local_nls);
-- 
1.7.0.4
