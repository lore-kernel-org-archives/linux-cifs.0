From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 02/17] AFS: Use d_automount() rather than abusing follow_link()
Date: Thu, 30 Sep 2010 19:15:05 +0100
Message-ID: <20100930181505.30939.44270.stgit@warthog.procyon.org.uk>
References: <20100930181455.30939.53914.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-fs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, autofs-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-afs-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: viro-rfM+Q5joDG/XmaaqVzeoHQ@public.gmane.org, jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100930181455.30939.53914.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Make AFS use the new d_automount() dentry operation rather than abusing
follow_link() on directories.

Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 fs/afs/dir.c      |    1 +
 fs/afs/inode.c    |    3 ++-
 fs/afs/internal.h |    1 +
 fs/afs/mntpt.c    |   47 +++++++++++++++--------------------------------
 4 files changed, 19 insertions(+), 33 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 0d38c09..23395e9 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -65,6 +65,7 @@ static const struct dentry_operations afs_fs_dentry_operations = {
 	.d_revalidate	= afs_d_revalidate,
 	.d_delete	= afs_d_delete,
 	.d_release	= afs_d_release,
+	.d_automount	= afs_d_automount,
 };
 
 #define AFS_DIR_HASHTBL_SIZE	128
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 0747339..db66c52 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -184,7 +184,8 @@ struct inode *afs_iget_autocell(struct inode *dir, const char *dev_name,
 	inode->i_generation	= 0;
 
 	set_bit(AFS_VNODE_PSEUDODIR, &vnode->flags);
-	inode->i_flags |= S_NOATIME;
+	set_bit(AFS_VNODE_MOUNTPOINT, &vnode->flags);
+	inode->i_flags |= S_AUTOMOUNT | S_NOATIME;
 	unlock_new_inode(inode);
 	_leave(" = %p", inode);
 	return inode;
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index cca8eef..085cfcf 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -590,6 +590,7 @@ extern const struct inode_operations afs_mntpt_inode_operations;
 extern const struct inode_operations afs_autocell_inode_operations;
 extern const struct file_operations afs_mntpt_file_operations;
 
+extern struct vfsmount *afs_d_automount(struct path *);
 extern int afs_mntpt_check_symlink(struct afs_vnode *, struct key *);
 extern void afs_mntpt_kill_timer(void);
 
diff --git a/fs/afs/mntpt.c b/fs/afs/mntpt.c
index 6d55268..7d190cf 100644
--- a/fs/afs/mntpt.c
+++ b/fs/afs/mntpt.c
@@ -24,7 +24,6 @@ static struct dentry *afs_mntpt_lookup(struct inode *dir,
 				       struct dentry *dentry,
 				       struct nameidata *nd);
 static int afs_mntpt_open(struct inode *inode, struct file *file);
-static void *afs_mntpt_follow_link(struct dentry *dentry, struct nameidata *nd);
 static void afs_mntpt_expiry_timed_out(struct work_struct *work);
 
 const struct file_operations afs_mntpt_file_operations = {
@@ -33,13 +32,11 @@ const struct file_operations afs_mntpt_file_operations = {
 
 const struct inode_operations afs_mntpt_inode_operations = {
 	.lookup		= afs_mntpt_lookup,
-	.follow_link	= afs_mntpt_follow_link,
 	.readlink	= page_readlink,
 	.getattr	= afs_getattr,
 };
 
 const struct inode_operations afs_autocell_inode_operations = {
-	.follow_link	= afs_mntpt_follow_link,
 	.getattr	= afs_getattr,
 };
 
@@ -87,6 +84,7 @@ int afs_mntpt_check_symlink(struct afs_vnode *vnode, struct key *key)
 		_debug("symlink is a mountpoint");
 		spin_lock(&vnode->lock);
 		set_bit(AFS_VNODE_MOUNTPOINT, &vnode->flags);
+		vnode->vfs_inode.i_flags |= S_AUTOMOUNT;
 		spin_unlock(&vnode->lock);
 	}
 
@@ -237,52 +235,37 @@ error_no_devname:
 }
 
 /*
- * follow a link from a mountpoint directory, thus causing it to be mounted
+ * handle an automount point
  */
-static void *afs_mntpt_follow_link(struct dentry *dentry, struct nameidata *nd)
+struct vfsmount *afs_d_automount(struct path *path)
 {
 	struct vfsmount *newmnt;
 	int err;
 
-	_enter("%p{%s},{%s:%p{%s},}",
-	       dentry,
-	       dentry->d_name.name,
-	       nd->path.mnt->mnt_devname,
-	       dentry,
-	       nd->path.dentry->d_name.name);
-
-	dput(nd->path.dentry);
-	nd->path.dentry = dget(dentry);
+	_enter("{%s,%s}", path->mnt->mnt_devname, path->dentry->d_name.name);
 
-	newmnt = afs_mntpt_do_automount(nd->path.dentry);
-	if (IS_ERR(newmnt)) {
-		path_put(&nd->path);
-		return (void *)newmnt;
-	}
+	newmnt = afs_mntpt_do_automount(path->dentry);
+	if (IS_ERR(newmnt))
+		return newmnt;
 
 	mntget(newmnt);
-	err = do_add_mount(newmnt, &nd->path, MNT_SHRINKABLE, &afs_vfsmounts);
+	err = do_add_mount(newmnt, path, MNT_SHRINKABLE, &afs_vfsmounts);
 	switch (err) {
 	case 0:
-		path_put(&nd->path);
-		nd->path.mnt = newmnt;
-		nd->path.dentry = dget(newmnt->mnt_root);
 		schedule_delayed_work(&afs_mntpt_expiry_timer,
 				      afs_mntpt_expiry_timeout * HZ);
-		break;
+		_leave(" = %p {%s}", newmnt, newmnt->mnt_devname);
+		return newmnt;
 	case -EBUSY:
 		/* someone else made a mount here whilst we were busy */
-		while (d_mountpoint(nd->path.dentry) &&
-		       follow_down(&nd->path))
-			;
-		err = 0;
+		mntput(newmnt);
+		_leave(" = NULL [EBUSY]");
+		return NULL;
 	default:
 		mntput(newmnt);
-		break;
+		_leave(" = %d", err);
+		return ERR_PTR(err);
 	}
-
-	_leave(" = %d", err);
-	return ERR_PTR(err);
 }
 
 /*
