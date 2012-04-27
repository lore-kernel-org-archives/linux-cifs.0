From: Ian Kent <raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org>
Subject: [PATCH] cifs - check S_AUTOMOUNT in revalidate
Date: Fri, 27 Apr 2012 16:18:15 +0800
Message-ID: <20120427081815.4478.26011.stgit@perseus.themaw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When revalidating a dentry, if the inode wasn't known to be a dfs
entry when the dentry was instantiated, such as when created via
->readdir(), the DCACHE_NEED_AUTOMOUNT flag needs to be set on the
dentry in ->d_revalidate().

The false return from cifs_d_revalidate(), due to the inode now
being marked with the S_AUTOMOUNT flag, might not invalidate the
dentry if there is a concurrent unlazy path walk. This is because
the dentry reference count will be at least 2 in this case causing
d_invalidate() to return EBUSY. So the asumption that the dentry
will be discarded then correctly instantiated via ->lookup() might
not hold.

Signed-off-by: Ian Kent <raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org>
Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---

 fs/cifs/dir.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index d172c8e..ec4e9a2 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -668,12 +668,19 @@ cifs_d_revalidate(struct dentry *direntry, struct nameidata *nd)
 			return 0;
 		else {
 			/*
-			 * Forcibly invalidate automounting directory inodes
-			 * (remote DFS directories) so to have them
-			 * instantiated again for automount
+			 * If the inode wasn't known to be a dfs entry when
+			 * the dentry was instantiated, such as when created
+			 * via ->readdir(), it needs to be set now since the
+			 * attributes will have been updated by
+			 * cifs_revalidate_dentry().
 			 */
-			if (IS_AUTOMOUNT(direntry->d_inode))
-				return 0;
+			if (IS_AUTOMOUNT(direntry->d_inode) &&
+			   !(direntry->d_flags & DCACHE_NEED_AUTOMOUNT)) {
+				spin_lock(&direntry->d_lock);
+				direntry->d_flags |= DCACHE_NEED_AUTOMOUNT;
+				spin_unlock(&direntry->d_lock);
+			}
+
 			return 1;
 		}
 	}
