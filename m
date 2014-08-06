From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] CIFS: Update CreationTime on every query info request
Date: Wed,  6 Aug 2014 15:15:43 +0400
Message-ID: <1407323743-12381-1-git-send-email-pshilovsky@samba.org>
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Samba server can change a creation time of an inode in the default
configuration. The client sets this value during the inode initialization
only and uses it the inode search. In this case harlinked dentries may
link to different inodes. As the results the Cthon basic test #7 fails
on nounix Samba mounts.

Fix this by making the client update the creation time on every
query info request.

Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/inode.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index a174605..2029e7c 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -173,6 +173,9 @@ cifs_fattr_to_inode(struct inode *inode, struct cifs_fattr *fattr)
 
 	cifs_i->cifsAttrs = fattr->cf_cifsattrs;
 
+	/* Samba server changes this value in the default configuration */
+	cifs_i->createtime = fattr->cf_createtime;
+
 	if (fattr->cf_flags & CIFS_FATTR_NEED_REVAL)
 		cifs_i->time = 0;
 	else
-- 
1.8.1.2
