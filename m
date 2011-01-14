From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: remove extraneous calls to d_set_d_op
Date: Fri, 14 Jan 2011 07:22:56 -0500
Message-ID: <1295007776-32329-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Testing with the connectathon tests caused this panic:

[  388.266918] ------------[ cut here ]------------
[  388.267823] kernel BUG at fs/dcache.c:1358!

[...]

[  388.267823] RIP: 0010:[<ffffffff81129146>]  [<ffffffff81129146>] d_set_d_op+0x10/0x58

[...]

[  388.267823] Call Trace:
[  388.267823]  [<ffffffffa0147a3c>] cifs_create+0x5cd/0x6fe [cifs]
[  388.267823]  [<ffffffff81123c5d>] vfs_create+0x70/0x91
[  388.267823]  [<ffffffff8112499d>] do_last+0x15a/0x2ff
[  388.267823]  [<ffffffff81124e41>] do_filp_open+0x2ff/0x6db
[  388.267823]  [<ffffffff8110ca5f>] ? kmem_cache_free+0x76/0xb4
[  388.267823]  [<ffffffff81464c6b>] ? _cond_resched+0xe/0x22
[  388.267823]  [<ffffffff81229300>] ? might_fault+0x21/0x23
[  388.267823]  [<ffffffff81229400>] ? __strncpy_from_user+0x1f/0x4e
[  388.267823]  [<ffffffff8112eb70>] ? alloc_fd+0x74/0x11f
[  388.267823]  [<ffffffff81118808>] do_sys_open+0x60/0xf2
[  388.267823]  [<ffffffff810992e3>] ? audit_syscall_entry+0x11c/0x148
[  388.267823]  [<ffffffff811188ba>] sys_open+0x20/0x22
[  388.267823]  [<ffffffff811188e4>] sys_creat+0x15/0x17
[  388.267823]  [<ffffffff8100ac42>] system_call_fastpath+0x16/0x1b
[  388.436446] ---[ end trace a012e6143ebad719 ]---

The problem is that d_op is already set during the lookup. d_set_d_op
will BUG() if you try to set operations when they have already been set.

Remove all of the d_set_d_op calls except for during lookups and ensure
that it gets set on every lookup.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/dir.c   |   32 +++++++-------------------------
 fs/cifs/inode.c |    9 ---------
 fs/cifs/link.c  |    9 ++-------
 3 files changed, 9 insertions(+), 41 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 2e77382..1bb1729 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -130,17 +130,6 @@ cifs_bp_rename_retry:
 	return full_path;
 }
 
-static void setup_cifs_dentry(struct cifsTconInfo *tcon,
-			      struct dentry *direntry,
-			      struct inode *newinode)
-{
-	if (tcon->nocase)
-		d_set_d_op(direntry, &cifs_ci_dentry_ops);
-	else
-		d_set_d_op(direntry, &cifs_dentry_ops);
-	d_instantiate(direntry, newinode);
-}
-
 /* Inode operations in similar order to how they appear in Linux file fs.h */
 
 int
@@ -327,7 +316,7 @@ cifs_create_get_file_info:
 
 cifs_create_set_dentry:
 	if (rc == 0)
-		setup_cifs_dentry(tcon, direntry, newinode);
+		d_instantiate(direntry, newinode);
 	else
 		cFYI(1, "Create worked, get_inode_info failed rc = %d", rc);
 
@@ -418,11 +407,6 @@ int cifs_mknod(struct inode *inode, struct dentry *direntry, int mode,
 
 		rc = cifs_get_inode_info_unix(&newinode, full_path,
 						inode->i_sb, xid);
-		if (pTcon->nocase)
-			d_set_d_op(direntry, &cifs_ci_dentry_ops);
-		else
-			d_set_d_op(direntry, &cifs_dentry_ops);
-
 		if (rc == 0)
 			d_instantiate(direntry, newinode);
 		goto mknod_out;
@@ -522,6 +506,12 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	}
 	pTcon = tlink_tcon(tlink);
 
+	/* set dentry operations */
+	if (pTcon->nocase)
+		d_set_d_op(direntry, &cifs_ci_dentry_ops);
+	else
+		d_set_d_op(direntry, &cifs_dentry_ops);
+
 	/*
 	 * Don't allow the separator character in a path component.
 	 * The VFS will not allow "/", but "\" is allowed by posix.
@@ -601,10 +591,6 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 				parent_dir_inode->i_sb, xid, NULL);
 
 	if ((rc == 0) && (newInode != NULL)) {
-		if (pTcon->nocase)
-			d_set_d_op(direntry, &cifs_ci_dentry_ops);
-		else
-			d_set_d_op(direntry, &cifs_dentry_ops);
 		d_add(direntry, newInode);
 		if (posix_open) {
 			filp = lookup_instantiate_filp(nd, direntry,
@@ -631,10 +617,6 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	} else if (rc == -ENOENT) {
 		rc = 0;
 		direntry->d_time = jiffies;
-		if (pTcon->nocase)
-			d_set_d_op(direntry, &cifs_ci_dentry_ops);
-		else
-			d_set_d_op(direntry, &cifs_dentry_ops);
 		d_add(direntry, NULL);
 	/*	if it was once a directory (but how can we tell?) we could do
 		shrink_dcache_parent(direntry); */
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 0c7e369..74e1e82 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1324,11 +1324,6 @@ int cifs_mkdir(struct inode *inode, struct dentry *direntry, int mode)
 /*BB check (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID ) to see if need
 	to set uid/gid */
 			inc_nlink(inode);
-			if (pTcon->nocase)
-				d_set_d_op(direntry, &cifs_ci_dentry_ops);
-			else
-				d_set_d_op(direntry, &cifs_dentry_ops);
-
 			cifs_unix_basic_to_fattr(&fattr, pInfo, cifs_sb);
 			cifs_fill_uniqueid(inode->i_sb, &fattr);
 			newinode = cifs_iget(inode->i_sb, &fattr);
@@ -1368,10 +1363,6 @@ mkdir_get_info:
 			rc = cifs_get_inode_info(&newinode, full_path, NULL,
 						 inode->i_sb, xid, NULL);
 
-		if (pTcon->nocase)
-			d_set_d_op(direntry, &cifs_ci_dentry_ops);
-		else
-			d_set_d_op(direntry, &cifs_dentry_ops);
 		d_instantiate(direntry, newinode);
 		 /* setting nlink not necessary except in cases where we
 		  * failed to get it from the server or was set bogus */
diff --git a/fs/cifs/link.c b/fs/cifs/link.c
index fe2f6a9..486efc5 100644
--- a/fs/cifs/link.c
+++ b/fs/cifs/link.c
@@ -520,16 +520,11 @@ cifs_symlink(struct inode *inode, struct dentry *direntry, const char *symname)
 			rc = cifs_get_inode_info(&newinode, full_path, NULL,
 						 inode->i_sb, xid, NULL);
 
-		if (rc != 0) {
+		if (rc != 0)
 			cFYI(1, "Create symlink ok, getinodeinfo fail rc = %d",
 			      rc);
-		} else {
-			if (pTcon->nocase)
-				d_set_d_op(direntry, &cifs_ci_dentry_ops);
-			else
-				d_set_d_op(direntry, &cifs_dentry_ops);
+		else
 			d_instantiate(direntry, newinode);
-		}
 	}
 symlink_exit:
 	kfree(full_path);
-- 
1.7.3.4
