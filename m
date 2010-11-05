From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/6] CIFS: Make cifs_fsync work with strict cache mode
Date: Fri,  5 Nov 2010 11:29:35 +0300
Message-ID: <1288945777-9197-5-git-send-email-piastryyy@gmail.com>
References: <1288945777-9197-1-git-send-email-piastryyy@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1288945777-9197-1-git-send-email-piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Remove filemap_write_and_wait call because it is previously called from
vfs_sync_range and invalidate inode if we don't have at least Level II
oplock and strcit cache mode switched on.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/file.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 85824c0..e8ca2d6 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1603,20 +1603,20 @@ int cifs_fsync(struct file *file, int datasync)
 	struct cifsTconInfo *tcon;
 	struct cifsFileInfo *smbfile = file->private_data;
 	struct inode *inode = file->f_path.dentry->d_inode;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 
 	xid = GetXid();
 
 	cFYI(1, "Sync file - name: %s datasync: 0x%x",
 		file->f_path.dentry->d_name.name, datasync);
 
-	rc = filemap_write_and_wait(inode->i_mapping);
-	if (rc == 0) {
-		struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	if (!CIFS_I(inode)->clientCanCacheRead &&
+	    ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) == 0))
+		invalidate_remote_inode(inode);
 
-		tcon = tlink_tcon(smbfile->tlink);
-		if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
-			rc = CIFSSMBFlush(xid, tcon, smbfile->netfid);
-	}
+	tcon = tlink_tcon(smbfile->tlink);
+	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC))
+		rc = CIFSSMBFlush(xid, tcon, smbfile->netfid);
 
 	FreeXid(xid);
 	return rc;
-- 
1.7.2.3
