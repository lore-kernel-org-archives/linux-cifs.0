From: Sage Weil <sage@newdream.net>
Subject: [PATCH 19/19] cifs: remove unnecessary dentry_unhash on rmdir/rename_dir
Date: Tue, 24 May 2011 13:06:22 -0700
Message-ID: <1306267582-5347-20-git-send-email-sage@newdream.net>
References: <1306267582-5347-1-git-send-email-sage@newdream.net>
Cc: linux-fsdevel@vger.kernel.org, hch@lst.de,
	Sage Weil <sage@newdream.net>,
	Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
To: viro@ZenIV.linux.org.uk
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1306267582-5347-1-git-send-email-sage@newdream.net>
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
index 9ac2290..de02ed5 100644
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
1.7.0

