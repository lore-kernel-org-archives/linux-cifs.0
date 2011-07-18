From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH] cifs: fix usage of d_materialise_unique in cifs_get_root
Date: Mon, 18 Jul 2011 08:03:14 -0400
Message-ID: <1310990594-3570-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	piastryyy@gmail.com, viro@ZenIV.linux.org.uk
To: smfrench@gmail.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

It currently calls d_lookup to get a dentry and then passes that to
d_materialise_unique. This is wrong as d_materialise_unique is intended
to introduce a new dentry into the tree. It also uses d_lookup when
lookup_one_len would generally be a better choice since it does
permission checks.

Also, fix the dentry hash calculation to work with nocase mounts.

Cc: Pavel Shilovsky <piastryyy@gmail.com>
Reported-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/cifsfs.c |   73 +++++++++++++++++++++++++++++++-----------------------
 1 files changed, 42 insertions(+), 31 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 9dd4375..fdb96eb 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -35,6 +35,7 @@
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
+#include <linux/namei.h>
 #include <net/ipv6.h>
 #include "cifsfs.h"
 #include "cifspdu.h"
@@ -556,47 +557,57 @@ cifs_get_root(struct smb_vol *vol, struct super_block *sb)
 		full_path[i] = 0;
 		cFYI(1, "get dentry for %s", pstart);
 
+		dchild = lookup_one_len(pstart, dparent, len);
+		if (dchild != NULL) {
+			if (dchild->d_inode != NULL)
+				goto next_component;
+			cFYI(1, "dentry is negative");
+			dput(dchild);
+		} else {
+			cFYI(1, "dentry does not exist");
+		}
+
 		name.name = pstart;
 		name.len = len;
-		name.hash = full_name_hash(pstart, len);
-		dchild = d_lookup(dparent, &name);
+		if (dparent->d_op && dparent->d_op->d_hash)
+			dparent->d_op->d_hash(dparent, dparent->d_inode, &name);
+		else
+			name.hash = full_name_hash(pstart, len);
+
+		dchild = d_alloc(dparent, &name);
 		if (dchild == NULL) {
-			cFYI(1, "not exists");
-			dchild = d_alloc(dparent, &name);
-			if (dchild == NULL) {
-				dput(dparent);
-				dparent = ERR_PTR(-ENOMEM);
-				goto out;
-			}
+			dput(dparent);
+			dparent = ERR_PTR(-ENOMEM);
+			goto out;
 		}
 
 		cFYI(1, "get inode");
-		if (dchild->d_inode == NULL) {
-			cFYI(1, "not exists");
-			inode = NULL;
-			if (cifs_sb_master_tcon(CIFS_SB(sb))->unix_ext)
-				rc = cifs_get_inode_info_unix(&inode, full_path,
-							      sb, xid);
-			else
-				rc = cifs_get_inode_info(&inode, full_path,
-							 NULL, sb, xid, NULL);
-			if (rc) {
-				dput(dchild);
+		inode = NULL;
+		if (cifs_sb_master_tcon(CIFS_SB(sb))->unix_ext)
+			rc = cifs_get_inode_info_unix(&inode, full_path,
+						      sb, xid);
+		else
+			rc = cifs_get_inode_info(&inode, full_path,
+						 NULL, sb, xid, NULL);
+		if (rc) {
+			dput(dchild);
+			dput(dparent);
+			dparent = ERR_PTR(rc);
+			goto out;
+		}
+
+		alias = d_materialise_unique(dchild, inode);
+		if (alias != NULL) {
+			dput(dchild);
+			if (IS_ERR(alias)) {
 				dput(dparent);
-				dparent = ERR_PTR(rc);
+				dparent = ERR_CAST(alias);
 				goto out;
 			}
-			alias = d_materialise_unique(dchild, inode);
-			if (alias != NULL) {
-				dput(dchild);
-				if (IS_ERR(alias)) {
-					dput(dparent);
-					dparent = ERR_PTR(-EINVAL); /* XXX */
-					goto out;
-				}
-				dchild = alias;
-			}
+			dchild = alias;
 		}
+
+next_component:
 		cFYI(1, "parent %p, child %p", dparent, dchild);
 
 		dput(dparent);
-- 
1.7.6

