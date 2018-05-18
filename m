From: Long Li <longli@linuxonhyperv.com>
Subject: [RFC PATCH 09/09] Introduce cache=rdma moutning option
Date: Thu, 17 May 2018 17:22:14 -0700
Message-ID: <20180518002214.5657-10-longli@linuxonhyperv.com>
References: <20180518002214.5657-1-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
Cc: Long Li <longli@microsoft.com>
To: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180518002214.5657-1-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Long Li <longli@microsoft.com>

When cache=rdma is enabled on mount options, CIFS do not allocate internal data
buffer pages for I/O, data is read/writen directly to user memory via RDMA.

Signed-off-by: Long Li <longli@microsoft.com>
---
 fs/cifs/cifs_fs_sb.h | 2 ++
 fs/cifs/cifsglob.h   | 1 +
 fs/cifs/connect.c    | 9 +++++++++
 fs/cifs/dir.c        | 5 +++++
 fs/cifs/file.c       | 4 ++++
 fs/cifs/inode.c      | 4 +++-
 6 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
index 350fa55..7c28dc3 100644
--- a/fs/cifs/cifs_fs_sb.h
+++ b/fs/cifs/cifs_fs_sb.h
@@ -51,6 +51,8 @@
 					      */
 #define CIFS_MOUNT_UID_FROM_ACL 0x2000000 /* try to get UID via special SID */
 
+#define CIFS_MOUNT_DIRECT_RDMA	0x4000000
+
 struct cifs_sb_info {
 	struct rb_root tlink_tree;
 	spinlock_t tlink_tree_lock;
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index a51855c..3bec63f 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -518,6 +518,7 @@ struct smb_vol {
 	bool server_ino:1; /* use inode numbers from server ie UniqueId */
 	bool direct_io:1;
 	bool strict_io:1; /* strict cache behavior */
+	bool rdma_io:1;
 	bool remap:1;      /* set to remap seven reserved chars in filenames */
 	bool sfu_remap:1;  /* remap seven reserved chars ala SFU */
 	bool posix_paths:1; /* unset to not ask for posix pathnames. */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 46d0cf4..c92b3d8 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -282,6 +282,7 @@ enum {
 	Opt_cache_loose,
 	Opt_cache_strict,
 	Opt_cache_none,
+	Opt_cache_rdma,
 	Opt_cache_err
 };
 
@@ -289,6 +290,7 @@ static const match_table_t cifs_cacheflavor_tokens = {
 	{ Opt_cache_loose, "loose" },
 	{ Opt_cache_strict, "strict" },
 	{ Opt_cache_none, "none" },
+	{ Opt_cache_rdma, "rdma" },
 	{ Opt_cache_err, NULL }
 };
 
@@ -1128,6 +1130,9 @@ cifs_parse_cache_flavor(char *value, struct smb_vol *vol)
 		vol->direct_io = true;
 		vol->strict_io = false;
 		break;
+	case Opt_cache_rdma:
+		vol->rdma_io = true;
+		break;
 	default:
 		cifs_dbg(VFS, "bad cache= option: %s\n", value);
 		return 1;
@@ -3612,6 +3617,10 @@ int cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
 		cifs_dbg(FYI, "mounting share using direct i/o\n");
 		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_DIRECT_IO;
 	}
+	if (pvolume_info->rdma_io) {
+		cifs_dbg(VFS, "mounting share using rdma i/o\n");
+		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_DIRECT_RDMA;
+	}
 	if (pvolume_info->mfsymlinks) {
 		if (pvolume_info->sfu_emul) {
 			/*
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 81ba6e0..ce69b1c 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -557,6 +557,11 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 			file->f_op = &cifs_file_direct_ops;
 		}
 
+	if (file->f_flags & O_DIRECT &&
+		CIFS_SB(inode->i_sb)->mnt_cifs_flags & CIFS_MOUNT_DIRECT_RDMA)
+			file->f_op = &cifs_file_direct_rdma_ops;
+
+
 	file_info = cifs_new_fileinfo(&fid, file, tlink, oplock);
 	if (file_info == NULL) {
 		if (server->ops->close)
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 0b394db..30ccf6a 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -492,6 +492,10 @@ int cifs_open(struct inode *inode, struct file *file)
 			file->f_op = &cifs_file_direct_ops;
 	}
 
+	if (file->f_flags & O_DIRECT &&
+            cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DIRECT_RDMA)
+		file->f_op = &cifs_file_direct_rdma_ops;
+
 	if (server->oplocks)
 		oplock = REQ_OPLOCK;
 	else
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 3c371f7..7991298 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -44,7 +44,9 @@ static void cifs_set_ops(struct inode *inode)
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFREG:
 		inode->i_op = &cifs_file_inode_ops;
-		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DIRECT_IO) {
+		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DIRECT_RDMA)
+			inode->i_fop = &cifs_file_direct_rdma_ops;
+		else if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DIRECT_IO) {
 			if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_BRL)
 				inode->i_fop = &cifs_file_direct_nobrl_ops;
 			else
-- 
2.7.4
