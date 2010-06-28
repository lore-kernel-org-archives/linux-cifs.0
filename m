From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/3] cifs: reduce false positives with inode aliasing serverino autodisable
Date: Mon, 28 Jun 2010 07:10:13 -0400
Message-ID: <1277723413-23769-4-git-send-email-jlayton@redhat.com>
References: <1277723413-23769-1-git-send-email-jlayton@redhat.com>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1277723413-23769-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It turns out that not all directory inodes with dentries on the
i_dentry list are unusable here. We only consider them unusable if they
are still hashed or if they have a root dentry attached.

Full disclosure -- this check is inherently racy. There's nothing that
stops someone from slapping a new dentry onto this inode just after
this check, or hashing an existing one that's already attached. So,
this is really a "best effort" thing to work around misbehaving servers.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/inode.c |   43 +++++++++++++++++++++++++++++++------------
 1 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 35e2466..1bfb8ec 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -736,15 +736,9 @@ cifs_find_inode(struct inode *inode, void *opaque)
 	if ((inode->i_mode & S_IFMT) != (fattr->cf_mode & S_IFMT))
 		return 0;
 
-	/*
-	 * uh oh -- it's a directory. We can't use it since hardlinked dirs are
-	 * verboten. Disable serverino and return it as if it were found, the
-	 * caller can discard it, generate a uniqueid and retry the find
-	 */
-	if (S_ISDIR(inode->i_mode) && !list_empty(&inode->i_dentry)) {
+	/* if it's not a directory or has no dentries, then flag it */
+	if (S_ISDIR(inode->i_mode) && !list_empty(&inode->i_dentry))
 		fattr->cf_flags |= CIFS_FATTR_INO_COLLISION;
-		cifs_autodisable_serverino(CIFS_SB(inode->i_sb));
-	}
 
 	return 1;
 }
@@ -759,6 +753,27 @@ cifs_init_inode(struct inode *inode, void *opaque)
 	return 0;
 }
 
+/*
+ * walk dentry list for an inode and report whether it has aliases that
+ * are hashed. We use this to determine if a directory inode can actually
+ * be used.
+ */
+static bool
+inode_has_hashed_dentries(struct inode *inode)
+{
+	struct dentry *dentry;
+
+	spin_lock(&dcache_lock);
+	list_for_each_entry(dentry, &inode->i_dentry, d_alias) {
+		if (!d_unhashed(dentry) || IS_ROOT(dentry)) {
+			spin_unlock(&dcache_lock);
+			return true;
+		}
+	}
+	spin_unlock(&dcache_lock);
+	return false;
+}
+
 /* Given fattrs, get a corresponding inode */
 struct inode *
 cifs_iget(struct super_block *sb, struct cifs_fattr *fattr)
@@ -774,12 +789,16 @@ retry_iget5_locked:
 
 	inode = iget5_locked(sb, hash, cifs_find_inode, cifs_init_inode, fattr);
 	if (inode) {
-		/* was there a problematic inode number collision? */
+		/* was there a potentially problematic inode collision? */
 		if (fattr->cf_flags & CIFS_FATTR_INO_COLLISION) {
-			iput(inode);
-			fattr->cf_uniqueid = iunique(sb, ROOT_I);
 			fattr->cf_flags &= ~CIFS_FATTR_INO_COLLISION;
-			goto retry_iget5_locked;
+
+			if (inode_has_hashed_dentries(inode)) {
+				cifs_autodisable_serverino(CIFS_SB(sb));
+				iput(inode);
+				fattr->cf_uniqueid = iunique(sb, ROOT_I);
+				goto retry_iget5_locked;
+			}
 		}
 
 		cifs_fattr_to_inode(inode, fattr);
-- 
1.6.6.1
