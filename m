From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: always update the inode cache with the results from a FIND_*
Date: Fri,  6 Jul 2012 07:09:42 -0400
Message-ID: <1341572982-23885-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	bill_robertson-nSG1tDLywIjKnmoGZ802fQ@public.gmane.org, dion_edwards-nSG1tDLywIjKnmoGZ802fQ@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When we get back a FIND_FIRST/NEXT result, we have some info about the
dentry that we use to instantiate a new inode. We were ignoring and
discarding that info when we had an existing dentry in the cache.

Fix this by updating the inode in place when we find an existing dentry
and the uniqueid is the same.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # .31.x
Reported-and-Tested-by: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Reported-by: Bill Robertson <bill_robertson-nSG1tDLywIjKnmoGZ802fQ@public.gmane.org>
Reported-by: Dion Edwards <dion_edwards-nSG1tDLywIjKnmoGZ802fQ@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/readdir.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 0a8224d..a4217f0 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -86,9 +86,12 @@ cifs_readdir_lookup(struct dentry *parent, struct qstr *name,
 
 	dentry = d_lookup(parent, name);
 	if (dentry) {
-		/* FIXME: check for inode number changes? */
-		if (dentry->d_inode != NULL)
+		inode = dentry->d_inode;
+		/* update inode in place if i_ino didn't change */
+		if (inode && CIFS_I(inode)->uniqueid == fattr->cf_uniqueid) {
+			cifs_fattr_to_inode(inode, fattr);
 			return dentry;
+		}
 		d_drop(dentry);
 		dput(dentry);
 	}
-- 
1.7.7.6
