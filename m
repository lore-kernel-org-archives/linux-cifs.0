From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] CIFS: Fix oops while mounting with prefixpath
Date: Mon, 25 Jul 2011 17:59:10 +0400
Message-ID: <1311602350-10857-1-git-send-email-piastryyy@gmail.com>
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

commit fec11dd9a0109fe52fd631e5c510778d6cbff6cc caused
a regression when we have already mounted //server/share/a
and want to mount //server/share/a/b.

The problem is that lookup_one_len calls __lookup_hash
with nd pointer as NULL. Then __lookup_hash calls
do_revalidate in the case when dentry exists and we end
up with NULL pointer deference in cifs_d_revalidate:

if (nd->flags & LOOKUP_RCU)
	return -ECHILD;

Fix this by checking nd for NULL.

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index fa8c21d..d8d26f3 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -641,7 +641,7 @@ lookup_out:
 static int
 cifs_d_revalidate(struct dentry *direntry, struct nameidata *nd)
 {
-	if (nd->flags & LOOKUP_RCU)
+	if (nd && (nd->flags & LOOKUP_RCU))
 		return -ECHILD;
 
 	if (direntry->d_inode) {
-- 
1.7.1
