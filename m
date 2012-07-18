From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 14/45] CIFS: Move guery file info code to ops struct
Date: Wed, 18 Jul 2012 19:48:30 +0400
Message-ID: <1342626541-29872-15-git-send-email-pshilovsky@samba.org>
References: <1342626541-29872-1-git-send-email-pshilovsky@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342626541-29872-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

and make cifs_get_file_info(_unix) calls static.

Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsglob.h  |    3 +++
 fs/cifs/cifsproto.h |    2 --
 fs/cifs/inode.c     |   12 +++++++++---
 fs/cifs/smb1ops.c   |    8 ++++++++
 4 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index bd2b397..0467e38 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -236,6 +236,9 @@ struct smb_version_operations {
 	int (*query_path_info)(const unsigned int, struct cifs_tcon *,
 			       struct cifs_sb_info *, const char *,
 			       FILE_ALL_INFO *, bool *);
+	/* query file data from the server */
+	int (*query_file_info)(const unsigned int, struct cifs_tcon *,
+			       struct cifs_fid *, FILE_ALL_INFO *);
 	/* get server index number */
 	int (*get_srv_inum)(const unsigned int, struct cifs_tcon *,
 			    struct cifs_sb_info *, const char *,
diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
index 80b0e40..c811f66 100644
--- a/fs/cifs/cifsproto.h
+++ b/fs/cifs/cifsproto.h
@@ -137,11 +137,9 @@ extern void cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr);
 extern struct inode *cifs_iget(struct super_block *sb,
 			       struct cifs_fattr *fattr);
 
-extern int cifs_get_file_info(struct file *filp);
 extern int cifs_get_inode_info(struct inode **inode, const char *full_path,
 			       FILE_ALL_INFO *data, struct super_block *sb,
 			       int xid, const __u16 *fid);
-extern int cifs_get_file_info_unix(struct file *filp);
 extern int cifs_get_inode_info_unix(struct inode **pinode,
 			const unsigned char *search_path,
 			struct super_block *sb, unsigned int xid);
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 1eeb6a0..39ef1a6 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -286,7 +286,8 @@ cifs_create_dfs_fattr(struct cifs_fattr *fattr, struct super_block *sb)
 	fattr->cf_flags |= CIFS_FATTR_DFS_REFERRAL;
 }
 
-int cifs_get_file_info_unix(struct file *filp)
+static int
+cifs_get_file_info_unix(struct file *filp)
 {
 	int rc;
 	unsigned int xid;
@@ -554,7 +555,8 @@ cifs_all_info_to_fattr(struct cifs_fattr *fattr, FILE_ALL_INFO *info,
 	fattr->cf_gid = cifs_sb->mnt_gid;
 }
 
-int cifs_get_file_info(struct file *filp)
+static int
+cifs_get_file_info(struct file *filp)
 {
 	int rc;
 	unsigned int xid;
@@ -564,9 +566,13 @@ int cifs_get_file_info(struct file *filp)
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifsFileInfo *cfile = filp->private_data;
 	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
+	struct TCP_Server_Info *server = tcon->ses->server;
+
+	if (!server->ops->query_file_info)
+		return -ENOSYS;
 
 	xid = get_xid();
-	rc = CIFSSMBQFileInfo(xid, tcon, cfile->fid.netfid, &find_data);
+	rc = server->ops->query_file_info(xid, tcon, &cfile->fid, &find_data);
 	switch (rc) {
 	case 0:
 		cifs_all_info_to_fattr(&fattr, &find_data, cifs_sb, false);
diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
index bb75847..cbbc122 100644
--- a/fs/cifs/smb1ops.c
+++ b/fs/cifs/smb1ops.c
@@ -489,6 +489,13 @@ cifs_get_srv_inum(const unsigned int xid, struct cifs_tcon *tcon,
 						CIFS_MOUNT_MAP_SPECIAL_CHR);
 }
 
+static int
+cifs_query_file_info(const unsigned int xid, struct cifs_tcon *tcon,
+		     struct cifs_fid *fid, FILE_ALL_INFO *data)
+{
+	return CIFSSMBQFileInfo(xid, tcon, fid->netfid, data);
+}
+
 static char *
 cifs_build_path_to_root(struct smb_vol *vol, struct cifs_sb_info *cifs_sb,
 			struct cifs_tcon *tcon)
@@ -672,6 +679,7 @@ struct smb_version_operations smb1_operations = {
 	.qfs_tcon = cifs_qfs_tcon,
 	.is_path_accessible = cifs_is_path_accessible,
 	.query_path_info = cifs_query_path_info,
+	.query_file_info = cifs_query_file_info,
 	.get_srv_inum = cifs_get_srv_inum,
 	.build_path_to_root = cifs_build_path_to_root,
 	.echo = CIFSSMBEcho,
-- 
1.7.1
