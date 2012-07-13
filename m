From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 12/32] CIFS: Fix a wrong pointer in atomic_open
Date: Fri, 13 Jul 2012 11:53:25 +0400
Message-ID: <1342166025-29377-13-git-send-email-pshilovsky@samba.org>
References: <1342166025-29377-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342166025-29377-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Commit 8ce5c35dd353cbf533383c54dca8aa7d2da6950f caused a regression
in cifs open codepath.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/dir.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index d364654..2caba0b 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -387,7 +387,6 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 	struct cifs_tcon *tcon;
 	__u16 fileHandle;
 	__u32 oplock;
-	struct file *filp;
 	struct cifsFileInfo *pfile_info;
 
 	/* Posix open is only called (at lookup time) for file create now.  For
@@ -418,7 +417,6 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 	     inode, direntry->d_name.name, direntry);
 
 	tlink = cifs_sb_tlink(CIFS_SB(inode->i_sb));
-	filp = ERR_CAST(tlink);
 	if (IS_ERR(tlink))
 		goto out_free_xid;
 
@@ -436,10 +434,9 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 		goto out;
 	}
 
-	pfile_info = cifs_new_fileinfo(fileHandle, filp, tlink, oplock);
+	pfile_info = cifs_new_fileinfo(fileHandle, file, tlink, oplock);
 	if (pfile_info == NULL) {
 		CIFSSMBClose(xid, tcon, fileHandle);
-		fput(filp);
 		rc = -ENOMEM;
 	}
 
-- 
1.7.1
