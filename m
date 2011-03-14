From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: always do is_path_accessible check in cifs_mount
Date: Mon, 14 Mar 2011 13:48:08 -0400
Message-ID: <1300124888-16958-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ysharma-3moEsy1GKqIAvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently, we skip doing the is_path_accessible check in cifs_mount if
there is no prefixpath. I have a report of at least one server however
that allows a TREE_CONNECT to a share that has a DFS referral at its
root. The reporter in this case was using a UNC that had no prefixpath,
so the is_path_accessible check was not triggered and the box later hit
a BUG() because we were chasing a DFS referral on the root dentry for
the mount.

This patch fixes this by removing the check for a zero-length
prefixpath.  That should make the is_path_accessible check be done in
this situation and should allow the client to chase the DFS referral at
mount time instead.

Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Reported-and-Tested-by: Yogesh Sharma <ysharma-3moEsy1GKqIAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 63ec77c..b82e8af 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2865,7 +2865,7 @@ try_mount_again:
 
 remote_path_check:
 	/* check if a whole path (including prepath) is not remote */
-	if (!rc && cifs_sb->prepathlen && tcon) {
+	if (!rc && tcon) {
 		/* build_path_to_root works only when we have a valid tcon */
 		full_path = cifs_build_path_to_root(cifs_sb, tcon);
 		if (full_path == NULL) {
-- 
1.7.4
