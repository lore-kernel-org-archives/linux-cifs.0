From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: [PATCH v2 2/4] cifs: new helper function: cifs_revalidate_mapping
Date: Wed, 30 Apr 2014 09:31:46 -0400
Message-ID: <1398864708-18185-3-git-send-email-jlayton@poochiereds.net>
References: <1398864708-18185-1-git-send-email-jlayton@poochiereds.net>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1398864708-18185-1-git-send-email-jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Consolidate a bit of code. In a later patch we'll expand this to fix
some races.

Signed-off-by: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
---
 fs/cifs/cifsfs.h |  1 +
 fs/cifs/inode.c  | 16 ++++++++++------
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 26a754f49ba1..40d5a4df1e38 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -67,6 +67,7 @@ extern int cifs_revalidate_dentry_attr(struct dentry *);
 extern int cifs_revalidate_file(struct file *filp);
 extern int cifs_revalidate_dentry(struct dentry *);
 extern int cifs_invalidate_mapping(struct inode *inode);
+extern int cifs_revalidate_mapping(struct inode *inode);
 extern int cifs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 extern int cifs_setattr(struct dentry *, struct iattr *);
 
diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index fa9ef8d902b5..ff420b275777 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -1779,6 +1779,14 @@ cifs_invalidate_mapping(struct inode *inode)
 	return rc;
 }
 
+int
+cifs_revalidate_mapping(struct inode *inode)
+{
+	if (test_bit(CIFS_INO_INVALID_MAPPING, &CIFS_I(inode)->flags))
+		return cifs_invalidate_mapping(inode);
+	return 0;
+}
+
 int cifs_revalidate_file_attr(struct file *filp)
 {
 	int rc = 0;
@@ -1845,9 +1853,7 @@ int cifs_revalidate_file(struct file *filp)
 	if (rc)
 		return rc;
 
-	if (test_bit(CIFS_INO_INVALID_MAPPING, &CIFS_I(inode)->flags))
-		rc = cifs_invalidate_mapping(inode);
-	return rc;
+	return cifs_revalidate_mapping(inode);
 }
 
 /* revalidate a dentry's inode attributes */
@@ -1860,9 +1866,7 @@ int cifs_revalidate_dentry(struct dentry *dentry)
 	if (rc)
 		return rc;
 
-	if (test_bit(CIFS_INO_INVALID_MAPPING, &CIFS_I(inode)->flags))
-		rc = cifs_invalidate_mapping(inode);
-	return rc;
+	return cifs_revalidate_mapping(inode);
 }
 
 int cifs_getattr(struct vfsmount *mnt, struct dentry *dentry,
-- 
1.9.0
