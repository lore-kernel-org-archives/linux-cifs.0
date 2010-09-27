From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/3] CIFS: Invaldate remote inode on the last close
Date: Mon, 27 Sep 2010 22:32:35 +0400
Message-ID: <AANLkTikGiHe3JeryfV8V2PH+yAObqpd5PwGAkvZFidF9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When we close the last file handle of the inode we should invalidate it
to prevent data coherency problem when we open it again but it has been
modified by other clients.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/file.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index de046e1..68e1789 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -153,9 +153,16 @@ psx_client_can_cache:
 		pCifsInode->clientCanCacheAll = true;
 		pCifsInode->clientCanCacheRead = true;
 		cFYI(1, "Exclusive Oplock granted on inode %p",
-			 file->f_path.dentry->d_inode);
-	} else if ((oplock & 0xF) == OPLOCK_READ)
+		     file->f_path.dentry->d_inode);
+	} else if ((oplock & 0xF) == OPLOCK_READ) {
+		pCifsInode->clientCanCacheAll = false;
 		pCifsInode->clientCanCacheRead = true;
+		cFYI(1, "Level II Oplock franted on inode %p",
+		     file->f_path.dentry->d_inode);
+	} else {
+		pCifsInode->clientCanCacheAll = false;
+		pCifsInode->clientCanCacheRead = false;
+	}

 	/* will have to change the unlock if we reenable the
 	   filemap_fdatawrite (which does not seem necessary */
@@ -211,8 +218,14 @@ client_can_cache:
 		pCifsInode->clientCanCacheAll = true;
 		pCifsInode->clientCanCacheRead = true;
 		cFYI(1, "Exclusive Oplock granted on inode %p", inode);
-	} else if ((oplock & 0xF) == OPLOCK_READ)
+	} else if ((oplock & 0xF) == OPLOCK_READ) {
+		pCifsInode->clientCanCacheAll = false;
 		pCifsInode->clientCanCacheRead = true;
+		cFYI(1, "Level II Oplock franted on inode %p", inode);
+	} else {
+		pCifsInode->clientCanCacheAll = false;
+		pCifsInode->clientCanCacheRead = false;
+	}

 	return rc;
 }
@@ -633,6 +646,8 @@ int cifs_close(struct inode *inode, struct file *file)
 		   on this inode, much less write behind and read ahead */
 		CIFS_I(inode)->clientCanCacheRead = false;
 		CIFS_I(inode)->clientCanCacheAll  = false;
+		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO)
+			invalidate_remote_inode(inode);
 	}
 	read_unlock(&GlobalSMBSeslock);
 	if ((rc == 0) && CIFS_I(inode)->write_behind_rc)
-- 
1.7.2.1
