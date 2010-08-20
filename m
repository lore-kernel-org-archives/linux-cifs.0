From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 01/15] cifs: eliminate redundant xdev check in cifs_rename
Date: Fri, 20 Aug 2010 15:31:57 -0400
Message-ID: <1282332731-17444-2-git-send-email-jlayton@redhat.com>
References: <1282332731-17444-1-git-send-email-jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org
To: linux-cifs@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1282332731-17444-1-git-send-email-jlayton@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

The VFS always checks that the source and target of a rename are on the
same vfsmount, and hence have the same superblock. So, this check is
redundant. Remove it and simplify the error handling.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/inode.c |   30 +++++++++---------------------
 1 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 7eacb10..dd41355 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1468,29 +1468,18 @@ int cifs_rename(struct inode *source_dir, struct dentry *source_dentry,
 {
 	char *fromName = NULL;
 	char *toName = NULL;
-	struct cifs_sb_info *cifs_sb_source;
-	struct cifs_sb_info *cifs_sb_target;
+	struct cifs_sb_info *cifs_sb;
 	struct cifsTconInfo *tcon;
 	FILE_UNIX_BASIC_INFO *info_buf_source = NULL;
 	FILE_UNIX_BASIC_INFO *info_buf_target;
 	int xid, rc, tmprc;
 
-	cifs_sb_target = CIFS_SB(target_dir->i_sb);
-	cifs_sb_source = CIFS_SB(source_dir->i_sb);
-	tcon = cifs_sb_source->tcon;
+	cifs_sb = CIFS_SB(source_dir->i_sb);
+	tcon = cifs_sb->tcon;
 
 	xid = GetXid();
 
 	/*
-	 * BB: this might be allowed if same server, but different share.
-	 * Consider adding support for this
-	 */
-	if (tcon != cifs_sb_target->tcon) {
-		rc = -EXDEV;
-		goto cifs_rename_exit;
-	}
-
-	/*
 	 * we already have the rename sem so we do not need to
 	 * grab it again here to protect the path integrity
 	 */
@@ -1525,17 +1514,16 @@ int cifs_rename(struct inode *source_dir, struct dentry *source_dentry,
 		info_buf_target = info_buf_source + 1;
 		tmprc = CIFSSMBUnixQPathInfo(xid, tcon, fromName,
 					info_buf_source,
-					cifs_sb_source->local_nls,
-					cifs_sb_source->mnt_cifs_flags &
+					cifs_sb->local_nls,
+					cifs_sb->mnt_cifs_flags &
 					CIFS_MOUNT_MAP_SPECIAL_CHR);
 		if (tmprc != 0)
 			goto unlink_target;
 
-		tmprc = CIFSSMBUnixQPathInfo(xid, tcon,
-					toName, info_buf_target,
-					cifs_sb_target->local_nls,
-					/* remap based on source sb */
-					cifs_sb_source->mnt_cifs_flags &
+		tmprc = CIFSSMBUnixQPathInfo(xid, tcon, toName,
+					info_buf_target,
+					cifs_sb->local_nls,
+					cifs_sb->mnt_cifs_flags &
 					CIFS_MOUNT_MAP_SPECIAL_CHR);
 
 		if (tmprc == 0 && (info_buf_source->UniqueId ==
-- 
1.7.2.1

