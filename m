From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: [PATCH 03/10] fs: cifs: Replace CURRENT_TIME with current_fs_time()
Date: Tue,  2 Feb 2016 22:07:43 -0800
Message-ID: <1454479670-8204-4-git-send-email-deepa.kernel@gmail.com>
References: <1454479670-8204-1-git-send-email-deepa.kernel@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Dave Chinner <david@fromorbit.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
To: linux-fsdevel@vger.kernel.org, y2038@lists.linaro.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454479670-8204-1-git-send-email-deepa.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

CURRENT_TIME macro is not appropriate for filesystems as it
doesn't use the right granularity for filesystem timestamps.
Use current_fs_time() instead.

Change signature of helper cifs_all_info_to_fattr since it
now needs both super_block and cifs_sb_info.

Note: The inode timestamps read from the server are assumed
to have correct granularity and range.

Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
---
 fs/cifs/inode.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index aeb26db..fa72359 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -320,9 +320,8 @@ cifs_create_dfs_fattr(struct cifs_fattr *fattr, struct super_block *sb)
 	fattr->cf_mode = S_IFDIR | S_IXUGO | S_IRWXU;
 	fattr->cf_uid = cifs_sb->mnt_uid;
 	fattr->cf_gid = cifs_sb->mnt_gid;
-	fattr->cf_atime = CURRENT_TIME;
-	fattr->cf_ctime = CURRENT_TIME;
-	fattr->cf_mtime = CURRENT_TIME;
+	fattr->cf_atime = fattr->cf_ctime =
+		fattr->cf_mtime = current_fs_time(sb);
 	fattr->cf_nlink = 2;
 	fattr->cf_flags |= CIFS_FATTR_DFS_REFERRAL;
 }
@@ -584,9 +583,10 @@ static int cifs_sfu_mode(struct cifs_fattr *fattr, const unsigned char *path,
 /* Fill a cifs_fattr struct with info from FILE_ALL_INFO */
 static void
 cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
-		       struct cifs_sb_info *cifs_sb, bool adjust_tz,
+		       struct super_block *sb, bool adjust_tz,
 		       bool symlink)
 {
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
 	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 
 	memset(fattr, 0, sizeof(*fattr));
@@ -597,7 +597,7 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
 	if (info->LastAccessTime)
 		fattr->cf_atime = cifs_NTtimeToUnix(info->LastAccessTime);
 	else
-		fattr->cf_atime = CURRENT_TIME;
+		fattr->cf_atime = current_fs_time(sb);
 
 	fattr->cf_ctime = cifs_NTtimeToUnix(info->ChangeTime);
 	fattr->cf_mtime = cifs_NTtimeToUnix(info->LastWriteTime);
@@ -657,7 +657,6 @@ cifs_get_file_info(struct file *filp)
 	FILE_ALL_INFO find_data;
 	struct cifs_fattr fattr;
 	struct inode *inode = file_inode(filp);
-	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifsFileInfo *cfile = filp->private_data;
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
 	struct TCP_Server_Info *server = tcon->ses->server;
@@ -669,7 +668,7 @@ cifs_get_file_info(struct file *filp)
 	rc = server->ops->query_file_info(xid, tcon, &cfile->fid, &find_data);
 	switch (rc) {
 	case 0:
-		cifs_all_info_to_fattr(&fattr, &find_data, cifs_sb, false,
+		cifs_all_info_to_fattr(&fattr, &find_data, inode->i_sb, false,
 				       false);
 		break;
 	case -EREMOTE:
@@ -751,7 +750,7 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
 	}
 
 	if (!rc) {
-		cifs_all_info_to_fattr(&fattr, data, cifs_sb, adjust_tz,
+		cifs_all_info_to_fattr(&fattr, data, sb, adjust_tz,
 				       symlink);
 	} else if (rc == -EREMOTE) {
 		cifs_create_dfs_fattr(&fattr, sb);
-- 
1.9.1
