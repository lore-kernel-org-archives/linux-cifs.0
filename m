From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/9] Use %pd in CIFS
Date: Tue, 10 Dec 2013 15:26:41 +0000
Message-ID: <20131210152641.4916.13637.stgit@warthog.procyon.org.uk>
References: <20131210152612.4916.80435.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131210152612.4916.80435.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Use the new %pd printk() specifier in CIFS to replace passing of dentry name or
dentry name and name length * 2 with just passing the dentry.

Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---

 fs/cifs/dir.c   |   14 +++++++-------
 fs/cifs/file.c  |   10 ++++------
 fs/cifs/inode.c |   12 ++++++------
 3 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 11ff5f116b20..4b18490bdad3 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -462,8 +462,8 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 
 	xid = get_xid();
 
-	cifs_dbg(FYI, "parent inode = 0x%p name is: %s and dentry = 0x%p\n",
-		 inode, direntry->d_name.name, direntry);
+	cifs_dbg(FYI, "parent inode = 0x%p name is: %pd and dentry = 0x%p\n",
+		 inode, direntry, direntry);
 
 	tlink = cifs_sb_tlink(CIFS_SB(inode->i_sb));
 	if (IS_ERR(tlink)) {
@@ -531,8 +531,8 @@ int cifs_create(struct inode *inode, struct dentry *direntry, umode_t mode,
 	__u32 oplock;
 	int created = FILE_CREATED;
 
-	cifs_dbg(FYI, "cifs_create parent inode = 0x%p name is: %s and dentry = 0x%p\n",
-		 inode, direntry->d_name.name, direntry);
+	cifs_dbg(FYI, "cifs_create parent inode = 0x%p name is: %pd and dentry = 0x%p\n",
+		 inode, direntry, direntry);
 
 	tlink = cifs_sb_tlink(CIFS_SB(inode->i_sb));
 	rc = PTR_ERR(tlink);
@@ -701,8 +701,8 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 
 	xid = get_xid();
 
-	cifs_dbg(FYI, "parent inode = 0x%p name is: %s and dentry = 0x%p\n",
-		 parent_dir_inode, direntry->d_name.name, direntry);
+	cifs_dbg(FYI, "parent inode = 0x%p name is: %pd and dentry = 0x%p\n",
+		 parent_dir_inode, direntry, direntry);
 
 	/* check whether path exists */
 
@@ -821,7 +821,7 @@ cifs_d_revalidate(struct dentry *direntry, unsigned int flags)
 {
 	int rc = 0;
 
-	cifs_dbg(FYI, "In cifs d_delete, name = %s\n", direntry->d_name.name);
+	cifs_dbg(FYI, "In cifs d_delete, name = %pd\n", direntry);
 
 	return rc;
 }     */
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 5a5a87240fe2..90f9ee34e1c6 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1642,8 +1642,8 @@ cifs_write(struct cifsFileInfo *open_file, __u32 pid, const char *write_data,
 
 	cifs_sb = CIFS_SB(dentry->d_sb);
 
-	cifs_dbg(FYI, "write %zd bytes to offset %lld of %s\n",
-		 write_size, *offset, dentry->d_name.name);
+	cifs_dbg(FYI, "write %zd bytes to offset %lld of %pd\n",
+		 write_size, *offset, dentry);
 
 	tcon = tlink_tcon(open_file->tlink);
 	server = tcon->ses->server;
@@ -2213,8 +2213,7 @@ int cifs_strict_fsync(struct file *file, loff_t start, loff_t end,
 
 	xid = get_xid();
 
-	cifs_dbg(FYI, "Sync file - name: %s datasync: 0x%x\n",
-		 file->f_path.dentry->d_name.name, datasync);
+	cifs_dbg(FYI, "Sync file - name: %pD datasync: 0x%x\n", file, datasync);
 
 	if (!CIFS_CACHE_READ(CIFS_I(inode))) {
 		rc = cifs_invalidate_mapping(inode);
@@ -2255,8 +2254,7 @@ int cifs_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 
 	xid = get_xid();
 
-	cifs_dbg(FYI, "Sync file - name: %s datasync: 0x%x\n",
-		 file->f_path.dentry->d_name.name, datasync);
+	cifs_dbg(FYI, "Sync file - name: %pD datasync: 0x%x\n", file, datasync);
 
 	tcon = tlink_tcon(smbfile->tlink);
 	if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOSSYNC)) {
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 36f9ebb93ceb..64ac645ea4b8 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1391,8 +1391,8 @@ cifs_posix_mkdir(struct inode *inode, struct dentry *dentry, umode_t mode,
 	d_instantiate(dentry, newinode);
 
 #ifdef CONFIG_CIFS_DEBUG2
-	cifs_dbg(FYI, "instantiated dentry %p %s to inode %p\n",
-		 dentry, dentry->d_name.name, newinode);
+	cifs_dbg(FYI, "instantiated dentry %p %pd to inode %p\n",
+		 dentry, dentry, newinode);
 
 	if (newinode->i_nlink != 2)
 		cifs_dbg(FYI, "unexpected number of links %d\n",
@@ -2019,8 +2019,8 @@ cifs_setattr_unix(struct dentry *direntry, struct iattr *attrs)
 	struct cifs_unix_set_info_args *args = NULL;
 	struct cifsFileInfo *open_file;
 
-	cifs_dbg(FYI, "setattr_unix on file %s attrs->ia_valid=0x%x\n",
-		 direntry->d_name.name, attrs->ia_valid);
+	cifs_dbg(FYI, "setattr_unix on file %pd attrs->ia_valid=0x%x\n",
+		 direntry, attrs->ia_valid);
 
 	xid = get_xid();
 
@@ -2162,8 +2162,8 @@ cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
 
 	xid = get_xid();
 
-	cifs_dbg(FYI, "setattr on file %s attrs->iavalid 0x%x\n",
-		 direntry->d_name.name, attrs->ia_valid);
+	cifs_dbg(FYI, "setattr on file %pd attrs->iavalid 0x%x\n",
+		 direntry, attrs->ia_valid);
 
 	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_PERM)
 		attrs->ia_valid |= ATTR_FORCE;
