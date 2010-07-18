From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH] cifs: truncate fallout
Date: Sun, 18 Jul 2010 17:51:21 -0400
Message-ID: <20100718215121.GA19508@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

[this is for the for-next branch in Al's vfs.git tree]

Remove the calls to inode_newsize_ok given that we already did it as
part of inode_change_ok in the beginning of cifs_setattr_(no)unix.

No need to call ->truncate if cifs doesn't have one, so remove the
explicit call in cifs_vmtruncate, and replace the calls to vmtruncate
with truncate_setsize which is vmtruncate minus inode_newsize_ok
and the call to ->truncate.

Rename cifs_vmtruncate to cifs_setsize to match the new calling conventions.

Question 1:  why does cifs do the pagecache munging and i_size update twice
	for each setattr call, once opencoded in cifs_vmtruncate, and once
	using the VFS helpers?
Question 2: what is supposed to be protected by i_lock in cifs_vmtruncate?
	Do we need it around the call to inode_change_ok?

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

Index: linux-2.6/fs/cifs/inode.c
===================================================================
--- linux-2.6.orig/fs/cifs/inode.c	2010-07-09 12:51:51.798649373 -0700
+++ linux-2.6/fs/cifs/inode.c	2010-07-09 12:55:00.594647100 -0700
@@ -1663,26 +1663,16 @@ static int cifs_truncate_page(struct add
 	return rc;
 }
 
-static int cifs_vmtruncate(struct inode *inode, loff_t offset)
+static int cifs_setsize(struct inode *inode, loff_t offset)
 {
 	loff_t oldsize;
-	int err;
 
 	spin_lock(&inode->i_lock);
-	err = inode_newsize_ok(inode, offset);
-	if (err) {
-		spin_unlock(&inode->i_lock);
-		goto out;
-	}
-
 	oldsize = inode->i_size;
 	i_size_write(inode, offset);
 	spin_unlock(&inode->i_lock);
+
 	truncate_pagecache(inode, oldsize, offset);
-	if (inode->i_op->truncate)
-		inode->i_op->truncate(inode);
-out:
-	return err;
 }
 
 static int
@@ -1755,7 +1745,7 @@ cifs_set_file_size(struct inode *inode,
 
 	if (rc == 0) {
 		cifsInode->server_eof = attrs->ia_size;
-		rc = cifs_vmtruncate(inode, attrs->ia_size);
+		rc = cifs_setsize(inode, attrs->ia_size);
 		cifs_truncate_page(inode->i_mapping, inode->i_size);
 	}
 
@@ -1876,7 +1866,7 @@ cifs_setattr_unix(struct dentry *direntr
 
 	if ((attrs->ia_valid & ATTR_SIZE) &&
 	    attrs->ia_size != i_size_read(inode)) {
-		rc = vmtruncate(inode, attrs->ia_size);
+		rc = truncate_setsize(inode, attrs->ia_size);
 		if (rc)
 			goto out;
 	}
@@ -2035,7 +2025,7 @@ cifs_setattr_nounix(struct dentry *diren
 
 	if ((attrs->ia_valid & ATTR_SIZE) &&
 	    attrs->ia_size != i_size_read(inode)) {
-		rc = vmtruncate(inode, attrs->ia_size);
+		rc = truncate_setsize(inode, attrs->ia_size);
 		if (rc)
 			goto cifs_setattr_exit;
 	}
