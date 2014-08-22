From: shirishpargaonkar@gmail.com
Subject: [PATCH 4/5] cifs: shared-superblock - create a dentry as a disconnected root
Date: Fri, 22 Aug 2014 17:21:28 -0500
Message-ID: <1408746088-10261-1-git-send-email-spargaonkar@suse.com>
Cc: linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	shirish <shirishpargaonkar@gmail.com>,
	Shirish Pargaonkar <spargaonkar@suse.com>
To: smfrench@gmail.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: shirish <shirishpargaonkar@gmail.com>


Create a disconnected root dentry if to an authenticated user, the leaf
directory of a mount is accessible but one or more intermediate paths are not.
In case a server does not provide uniqueid, insert an element for the
disconnected root dentry in a linked list off of superblock.


Signed-off-by: Shirish Pargaonkar <spargaonkar@suse.com>
---
 fs/cifs/cifsfs.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 4e759f6..0942622 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -602,6 +602,46 @@ cifs_alloc_rdelem(char *full_path, struct dentry *rdentry,
 	return rdelem;
 }
 
+static struct dentry *
+create_root_dis_dentry(struct super_block *sb, struct inode *rinode,
+			char *fpath)
+{
+	int rc;
+	unsigned int xid;
+	struct dentry *dentry = NULL;
+	struct cifs_rdelem *rdelem = NULL;
+	struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+
+	xid = get_xid();
+	if (tcon->unix_ext)
+		rc = cifs_get_inode_info_unix(&rinode, fpath, sb, xid);
+	else
+		rc = cifs_get_inode_info(&rinode, fpath, NULL, sb, xid, NULL);
+	free_xid(xid);
+
+	if ((rc == 0) && (rinode != NULL)) {
+		dentry = d_obtain_alias(rinode);
+		if (IS_ERR(dentry)) {
+			iput(rinode);
+			goto rdelem_ret;
+		}
+		if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)) {
+			rdelem =
+				cifs_alloc_rdelem(fpath, dentry, rinode);
+			if (IS_ERR(rdelem))
+				goto rdelem_ret;
+			spin_lock(&cifs_sb->rtdislock);
+			list_add(&rdelem->rdlist, &cifs_sb->rtdislist);
+			spin_unlock(&cifs_sb->rtdislock);
+		}
+		return dentry;
+	}
+
+rdelem_ret:
+	return ERR_PTR(-EACCES);
+}
+
 /*
  * Get root dentry from superblock according to prefix path mount option.
  * Return dentry with refcount + 1 on success and NULL otherwise.
@@ -614,9 +654,10 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
 	char *full_path = NULL;
 	char *s, *p;
 	char sep;
+	struct inode *rinode = NULL;
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
 
-	full_path = cifs_build_path_to_root(vol, cifs_sb,
-					    cifs_sb_master_tcon(cifs_sb));
+	full_path = cifs_build_path_to_root(vol, cifs_sb, tcon);
 	if (full_path == NULL)
 		return ERR_PTR(-ENOMEM);
 
@@ -657,6 +698,10 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
 		dput(dentry);
 		dentry = child;
 	} while (!IS_ERR(dentry));
+
+	if (IS_ERR(dentry) && (PTR_ERR(dentry) == -EACCES) && *s)
+		dentry = create_root_dis_dentry(sb, rinode, full_path);
+
 	kfree(full_path);
 	return dentry;
 }
-- 
1.8.4.5

