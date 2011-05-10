From: Sage Weil <sage@newdream.net>
Subject: [PATCH 18/18] cifs: remove unnecessary dentry_unhash on rmdir/rename_dir
Date: Mon,  9 May 2011 21:43:36 -0700
Message-ID: <1305002616-16782-19-git-send-email-sage@newdream.net>
References: <1305002616-16782-1-git-send-email-sage@newdream.net>
Cc: Sage Weil <sage@newdream.net>, Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org
To: viro@ZenIV.linux.org.uk, hch@lst.de, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1305002616-16782-1-git-send-email-sage@newdream.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Cifs has no problems with lingering references to unlinked directory
inodes.

CC: Steve French <sfrench@samba.org>
CC: linux-cifs@vger.kernel.org
Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/cifs/inode.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 18546b7..8852470 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1461,8 +1461,6 @@ int cifs_rmdir(struct inode *inode, struct dentry *direntry)
 
 	cFYI(1, "cifs_rmdir, inode = 0x%p", inode);
 
-	dentry_unhash(direntry);
-
 	xid = GetXid();
 
 	full_path = build_path_from_dentry(direntry);
@@ -1571,9 +1569,6 @@ int cifs_rename(struct inode *source_dir, struct dentry *source_dentry,
 	FILE_UNIX_BASIC_INFO *info_buf_target;
 	int xid, rc, tmprc;
 
-	if (target_dentry->d_inode && S_ISDIR(target_dentry->d_inode->i_mode))
-		dentry_unhash(target_dentry);
-
 	cifs_sb = CIFS_SB(source_dir->i_sb);
 	tlink = cifs_sb_tlink(cifs_sb);
 	if (IS_ERR(tlink))
-- 
1.7.1

