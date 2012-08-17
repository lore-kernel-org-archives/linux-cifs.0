From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] CIFS: Fix cifs_do_create error hadnling
Date: Fri, 17 Aug 2012 18:43:48 +0400
Message-ID: <1345214629-11059-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Commit d2c127197dfc0b2bae62a52e1e0d3e3ff493919e caused a regression
in cifs_do_create error handling. Fix this by closing a file handle
in the case of a get_inode_info(_unix) error. Also remove unnecessary
checks for newinode being NULL.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/dir.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index cbe709a..781025b 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -356,19 +356,12 @@ cifs_create_get_file_info:
 cifs_create_set_dentry:
 	if (rc != 0) {
 		cFYI(1, "Create worked, get_inode_info failed rc = %d", rc);
+		CIFSSMBClose(xid, tcon, *fileHandle);
 		goto out;
 	}
 	d_drop(direntry);
 	d_add(direntry, newinode);
 
-	/* ENOENT for create?  How weird... */
-	rc = -ENOENT;
-	if (!newinode) {
-		CIFSSMBClose(xid, tcon, *fileHandle);
-		goto out;
-	}
-	rc = 0;
-
 out:
 	kfree(buf);
 	kfree(full_path);
-- 
1.7.1
