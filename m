From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH V2] cifs: Add support of Alternate Data Streams
Date: Sat, 15 Sep 2012 22:05:47 -0500
Message-ID: <1347764747-16822-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tugosavi-xthvdsQ13ZrQT0dZR+AlfA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Add support of Alternate Data Streams (ads).

The generic access flags that cifs client currently employs are sufficient
for alternate data streams as well (MS-CIFS 2.2.4.64.1).

The ads files have a : in the name, so that is used to differentiate
between a regular file and its alternate data streams as they
have the same file id.
This scheme applies to non-posix compliant servers such as Windows only.

One operation that does not work is Rename (0x7).


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/inode.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index cb79c7e..a28950a 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -709,10 +709,15 @@ cifs_get_inode_info(struct inode **inode, const char *full_path,
 			cFYI(1, "CIFSCheckMFSymlink: %d", tmprc);
 	}
 
+	if (strstr(full_path, ":"))
+		fattr.cf_flags |= S_PRIVATE;
+
 	if (!*inode) {
 		*inode = cifs_iget(sb, &fattr);
 		if (!*inode)
 			rc = -ENOMEM;
+		else
+			(*inode)->i_flags |= fattr.cf_flags;
 	} else {
 		cifs_fattr_to_inode(*inode, &fattr);
 	}
@@ -744,6 +749,10 @@ cifs_find_inode(struct inode *inode, void *opaque)
 	if ((inode->i_mode & S_IFMT) != (fattr->cf_mode & S_IFMT))
 		return 0;
 
+	/* don't match inode with different flags */
+	if ((inode->i_flags & S_PRIVATE) != (fattr->cf_flags & S_PRIVATE))
+		return 0;
+
 	/* if it's not a directory or has no dentries, then flag it */
 	if (S_ISDIR(inode->i_mode) && !hlist_empty(&inode->i_dentry))
 		fattr->cf_flags |= CIFS_FATTR_INO_COLLISION;
-- 
1.6.0.2
