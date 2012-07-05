From: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] Always update the dentry cache with fresh readdir() results
Date: Thu, 05 Jul 2012 18:38:27 +1000
Message-ID: <1341477507.22307.21.camel@obed>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-TcRVjDme/F7ZnyL6CpBO"
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


--=-TcRVjDme/F7ZnyL6CpBO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

When we do a readdir() in CIFS, we are potentially efficiently
collecting a great deal of current, catchable stat information.

It is important that we always keep the dentry cache current for two
reasons:
 - the information may have changed (within the actime timeout).
 - if we still have a dentry cache value after that timeout, it is quite
expensive (1xRTT per entry) to find out if it was still correct.

This hits folks who are using CIFS over a WAN very badly.  For example
on an emulated 50ms delay I would have ls --color complete in .1
seconds, and a second run take 4.5 seconds, as each stat() (for the
colouring) would create a trans2 query_path_info query for each file,
right after getting the same information in the trans2 find_first2.

This patch implements the simplest approach, I would welcome a
correction on if there is a better approach than d_drop() and dput().

Tested on 3.4.4-3.cifsrevalidate.fc17.i686 with a 50ms WANem emulated
WAN against Samba 4.0 beta3.

Thanks,

Andrew Bartlett
-- 
Andrew Bartlett                                http://samba.org/~abartlet/
Authentication Developer, Samba Team           http://samba.org

--=-TcRVjDme/F7ZnyL6CpBO
Content-Disposition: attachment;
	filename*0=0001-fs-cifs-Always-recreate-the-cifs-dentry-cache-when-w.pat;
	filename*1=ch
Content-Type: text/x-patch;
	name="0001-fs-cifs-Always-recreate-the-cifs-dentry-cache-when-w.patch";
	charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 4478a902d3606205313eb37a225da22712841bff Mon Sep 17 00:00:00 2001
From: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Date: Thu, 5 Jul 2012 15:48:08 +1000
Subject: [PATCH] fs/cifs: Always recreate the cifs dentry cache when we have
 fresh information

When we do a readdir() in CIFS, we are potentially efficiently
collecting a great deal of current, cache-able stat information.

It is important that we always keep the dentry cache current for two reasons:
 - the information may have changed (within the actime timeout).
 - if we still have a dentry cache value after that timeout, it is quite
   expensive (1xRTT per entry) to find out if it was still correct.

This hits folks who are using CIFS over a WAN very badly.  For example
on an emulated 50ms delay I would have ls --color complete in .1
seconds, and a second run take 4.5 seconds, as each stat() (for the
colouring) would create a trans2 query_path_info query for each file,
right after getting the same information in the trans2 find_first2.

This patch implements the simplest approach, I would welcome a
correction on if there is a better approach than d_drop() and dput().

Tested on 3.4.4-3.cifsrevalidate.fc17.i686 against Samba 4.0 beta3.

Andrew Bartlett

Signed-off-by: Andrew Bartlett <abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/readdir.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 0a8224d..f964b40 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -66,9 +66,13 @@ static inline void dump_cifs_file_struct(struct file *file, char *label)
 #endif /* DEBUG2 */
 
 /*
- * Find the dentry that matches "name". If there isn't one, create one. If it's
- * a negative dentry or the uniqueid changed, then drop it and recreate it.
+ * Find the dentry that matches "name". If there isn't one, create
+ * one.  Otherwise recreate it fresh so we start the timeout for
+ * revalidation again.  Local locks are much faster than the network
+ * ops to revalidate it, particularly as revalidation will be
+ * per-inode, but here we have a whole directory at once!
  */
+
 static struct dentry *
 cifs_readdir_lookup(struct dentry *parent, struct qstr *name,
 		    struct cifs_fattr *fattr)
@@ -86,9 +90,6 @@ cifs_readdir_lookup(struct dentry *parent, struct qstr *name,
 
 	dentry = d_lookup(parent, name);
 	if (dentry) {
-		/* FIXME: check for inode number changes? */
-		if (dentry->d_inode != NULL)
-			return dentry;
 		d_drop(dentry);
 		dput(dentry);
 	}
-- 
1.7.7.6


--=-TcRVjDme/F7ZnyL6CpBO--
